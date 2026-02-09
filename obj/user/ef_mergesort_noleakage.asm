
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 2f 07 00 00       	call   800765 <libmain>
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
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_lock_cons();
  800041:	e8 19 28 00 00       	call   80285f <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3d 80 00       	push   $0x803d20
  80004e:	e8 b0 0b 00 00       	call   800c03 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3d 80 00       	push   $0x803d22
  80005e:	e8 a0 0b 00 00       	call   800c03 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 3d 80 00       	push   $0x803d38
  80006e:	e8 90 0b 00 00       	call   800c03 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3d 80 00       	push   $0x803d22
  80007e:	e8 80 0b 00 00       	call   800c03 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3d 80 00       	push   $0x803d20
  80008e:	e8 70 0b 00 00       	call   800c03 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 50 3d 80 00       	push   $0x803d50
  80009e:	e8 60 0b 00 00       	call   800c03 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 6f 3d 80 00       	push   $0x803d6f
  8000b8:	e8 46 0b 00 00       	call   800c03 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 5f 21 00 00       	call   80222e <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 74 3d 80 00       	push   $0x803d74
  8000dd:	e8 21 0b 00 00       	call   800c03 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 96 3d 80 00       	push   $0x803d96
  8000ed:	e8 11 0b 00 00       	call   800c03 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 a4 3d 80 00       	push   $0x803da4
  8000fd:	e8 01 0b 00 00       	call   800c03 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 b3 3d 80 00       	push   $0x803db3
  80010d:	e8 f1 0a 00 00       	call   800c03 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 c3 3d 80 00       	push   $0x803dc3
  80011d:	e8 e1 0a 00 00       	call   800c03 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 f3 05 00 00       	call   800729 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 e6 05 00 00       	call   800729 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_unlock_cons();
  800158:	e8 1c 27 00 00       	call   802879 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f5 01 00 00       	call   800373 <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 13 02 00 00       	call   8003a4 <InitializeIdentical>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 35 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 22 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 ee 02 00 00       	call   8004b8 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001cd:	e8 8d 26 00 00       	call   80285f <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 cc 3d 80 00       	push   $0x803dcc
  8001da:	e8 24 0a 00 00       	call   800c03 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001e2:	e8 92 26 00 00       	call   802879 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d4 00 00 00       	call   8002c9 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 00 3e 80 00       	push   $0x803e00
  800209:	6a 4e                	push   $0x4e
  80020b:	68 22 3e 80 00       	push   $0x803e22
  800210:	e8 00 07 00 00       	call   800915 <_panic>
		else
		{
			sys_lock_cons();
  800215:	e8 45 26 00 00       	call   80285f <sys_lock_cons>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 40 3e 80 00       	push   $0x803e40
  800222:	e8 dc 09 00 00       	call   800c03 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 74 3e 80 00       	push   $0x803e74
  800232:	e8 cc 09 00 00       	call   800c03 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 a8 3e 80 00       	push   $0x803ea8
  800242:	e8 bc 09 00 00       	call   800c03 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80024a:	e8 2a 26 00 00       	call   802879 <sys_unlock_cons>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 58 21 00 00       	call   8023b2 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80025d:	e8 fd 25 00 00       	call   80285f <sys_lock_cons>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 da 3e 80 00       	push   $0x803eda
  800270:	e8 8e 09 00 00       	call   800c03 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 a0 04 00 00       	call   800729 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 93 04 00 00       	call   800729 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 86 04 00 00       	call   800729 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_lock_cons();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_unlock_cons();
  8002b2:	e8 c2 25 00 00       	call   802879 <sys_unlock_cons>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

	//To indicate that it's completed successfully
	inctst();
  8002c1:	e8 50 29 00 00       	call   802c16 <inctst>

}
  8002c6:	90                   	nop
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dd:	eb 33                	jmp    800312 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	01 d0                	add    %edx,%eax
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f3:	40                   	inc    %eax
  8002f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	01 c8                	add    %ecx,%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	7e 09                	jle    80030f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030d:	eb 0c                	jmp    80031b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030f:	ff 45 f8             	incl   -0x8(%ebp)
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	48                   	dec    %eax
  800316:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800319:	7f c4                	jg     8002df <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800326:	8b 45 0c             	mov    0xc(%ebp),%eax
  800329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 d0                	add    %edx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	01 c8                	add    %ecx,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	01 c2                	add    %eax,%edx
  80036b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036e:	89 02                	mov    %eax,(%edx)
}
  800370:	90                   	nop
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800380:	eb 17                	jmp    800399 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800382:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	01 c2                	add    %eax,%edx
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800396:	ff 45 fc             	incl   -0x4(%ebp)
  800399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039f:	7c e1                	jl     800382 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a1:	90                   	nop
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b1:	eb 1b                	jmp    8003ce <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c2                	add    %eax,%edx
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c8:	48                   	dec    %eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c dd                	jl     8003b3 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e2:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e7:	f7 e9                	imul   %ecx
  8003e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	29 c8                	sub    %ecx,%eax
  8003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003f7:	75 07                	jne    800400 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003f9:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800407:	eb 1e                	jmp    800427 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	99                   	cltd   
  80041d:	f7 7d f8             	idivl  -0x8(%ebp)
  800420:	89 d0                	mov    %edx,%eax
  800422:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800424:	ff 45 fc             	incl   -0x4(%ebp)
  800427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042d:	7c da                	jl     800409 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80042f:	90                   	nop
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800438:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800446:	eb 42                	jmp    80048a <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044b:	99                   	cltd   
  80044c:	f7 7d f0             	idivl  -0x10(%ebp)
  80044f:	89 d0                	mov    %edx,%eax
  800451:	85 c0                	test   %eax,%eax
  800453:	75 10                	jne    800465 <PrintElements+0x33>
			cprintf("\n");
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	68 20 3d 80 00       	push   $0x803d20
  80045d:	e8 a1 07 00 00       	call   800c03 <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 f8 3e 80 00       	push   $0x803ef8
  80047f:	e8 7f 07 00 00       	call   800c03 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800487:	ff 45 f4             	incl   -0xc(%ebp)
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	48                   	dec    %eax
  80048e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800491:	7f b5                	jg     800448 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800496:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 6f 3d 80 00       	push   $0x803d6f
  8004ad:	e8 51 07 00 00       	call   800c03 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp

}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c4:	7d 54                	jge    80051a <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	89 c2                	mov    %eax,%edx
  8004d0:	c1 ea 1f             	shr    $0x1f,%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	d1 f8                	sar    %eax
  8004d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 cd ff ff ff       	call   8004b8 <MSort>
  8004eb:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f1:	40                   	inc    %eax
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	ff 75 10             	pushl  0x10(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	e8 b7 ff ff ff       	call   8004b8 <MSort>
  800501:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800504:	ff 75 10             	pushl  0x10(%ebp)
  800507:	ff 75 f4             	pushl  -0xc(%ebp)
  80050a:	ff 75 0c             	pushl  0xc(%ebp)
  80050d:	ff 75 08             	pushl  0x8(%ebp)
  800510:	e8 08 00 00 00       	call   80051d <Merge>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	eb 01                	jmp    80051b <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80051a:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	2b 45 0c             	sub    0xc(%ebp),%eax
  800529:	40                   	inc    %eax
  80052a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	2b 45 10             	sub    0x10(%ebp),%eax
  800533:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80053d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800547:	c1 e0 02             	shl    $0x2,%eax
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	50                   	push   %eax
  80054e:	e8 db 1c 00 00       	call   80222e <malloc>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	c1 e0 02             	shl    $0x2,%eax
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	50                   	push   %eax
  800563:	e8 c6 1c 00 00       	call   80222e <malloc>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800575:	eb 2f                	jmp    8005a6 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800584:	01 c2                	add    %eax,%edx
  800586:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800593:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	ff 45 ec             	incl   -0x14(%ebp)
  8005a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ac:	7c c9                	jl     800577 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b5:	eb 2a                	jmp    8005e1 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c4:	01 c2                	add    %eax,%edx
  8005c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cc:	01 c8                	add    %ecx,%eax
  8005ce:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	01 c8                	add    %ecx,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005de:	ff 45 e8             	incl   -0x18(%ebp)
  8005e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e7:	7c ce                	jl     8005b7 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ef:	e9 0a 01 00 00       	jmp    8006fe <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005fa:	0f 8d 95 00 00 00    	jge    800695 <Merge+0x178>
  800600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800603:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800606:	0f 8d 89 00 00 00    	jge    800695 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800616:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800619:	01 d0                	add    %edx,%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	39 c2                	cmp    %eax,%edx
  800630:	7d 33                	jge    800665 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800635:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80063a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800650:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800657:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800660:	e9 96 00 00 00       	jmp    8006fb <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800668:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800683:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80068d:	01 d0                	add    %edx,%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800693:	eb 66                	jmp    8006fb <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800698:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80069b:	7d 30                	jge    8006cd <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80069d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b5:	8d 50 01             	lea    0x1(%eax),%edx
  8006b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 01                	mov    %eax,(%ecx)
  8006cb:	eb 2e                	jmp    8006fb <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8d 50 01             	lea    0x1(%eax),%edx
  8006e8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800701:	3b 45 14             	cmp    0x14(%ebp),%eax
  800704:	0f 8e ea fe ff ff    	jle    8005f4 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d8             	pushl  -0x28(%ebp)
  800710:	e8 9d 1c 00 00       	call   8023b2 <free>
  800715:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071e:	e8 8f 1c 00 00       	call   8023b2 <free>
  800723:	83 c4 10             	add    $0x10,%esp

}
  800726:	90                   	nop
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800735:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800739:	83 ec 0c             	sub    $0xc,%esp
  80073c:	50                   	push   %eax
  80073d:	e8 65 22 00 00       	call   8029a7 <sys_cputc>
  800742:	83 c4 10             	add    $0x10,%esp
}
  800745:	90                   	nop
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <getchar>:


int
getchar(void)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80074e:	e8 f3 20 00 00       	call   802846 <sys_cgetc>
  800753:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <iscons>:

int iscons(int fdnum)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
  80076b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80076e:	e8 65 23 00 00       	call   802ad8 <sys_getenvindex>
  800773:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800779:	89 d0                	mov    %edx,%eax
  80077b:	01 c0                	add    %eax,%eax
  80077d:	01 d0                	add    %edx,%eax
  80077f:	c1 e0 02             	shl    $0x2,%eax
  800782:	01 d0                	add    %edx,%eax
  800784:	c1 e0 02             	shl    $0x2,%eax
  800787:	01 d0                	add    %edx,%eax
  800789:	c1 e0 03             	shl    $0x3,%eax
  80078c:	01 d0                	add    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800796:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80079b:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a0:	8a 40 20             	mov    0x20(%eax),%al
  8007a3:	84 c0                	test   %al,%al
  8007a5:	74 0d                	je     8007b4 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ac:	83 c0 20             	add    $0x20,%eax
  8007af:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b8:	7e 0a                	jle    8007c4 <libmain+0x5f>
		binaryname = argv[0];
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 66 f8 ff ff       	call   800038 <_main>
  8007d2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	0f 84 01 01 00 00    	je     8008e3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007e2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007e8:	bb f8 3f 80 00       	mov    $0x803ff8,%ebx
  8007ed:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007f2:	89 c7                	mov    %eax,%edi
  8007f4:	89 de                	mov    %ebx,%esi
  8007f6:	89 d1                	mov    %edx,%ecx
  8007f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007fa:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007fd:	b9 56 00 00 00       	mov    $0x56,%ecx
  800802:	b0 00                	mov    $0x0,%al
  800804:	89 d7                	mov    %edx,%edi
  800806:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800808:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80080f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	50                   	push   %eax
  800816:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80081c:	50                   	push   %eax
  80081d:	e8 ec 24 00 00       	call   802d0e <sys_utilities>
  800822:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800825:	e8 35 20 00 00       	call   80285f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80082a:	83 ec 0c             	sub    $0xc,%esp
  80082d:	68 18 3f 80 00       	push   $0x803f18
  800832:	e8 cc 03 00 00       	call   800c03 <cprintf>
  800837:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80083a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083d:	85 c0                	test   %eax,%eax
  80083f:	74 18                	je     800859 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800841:	e8 e6 24 00 00       	call   802d2c <sys_get_optimal_num_faults>
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	50                   	push   %eax
  80084a:	68 40 3f 80 00       	push   $0x803f40
  80084f:	e8 af 03 00 00       	call   800c03 <cprintf>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	eb 59                	jmp    8008b2 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800859:	a1 24 50 80 00       	mov    0x805024,%eax
  80085e:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800864:	a1 24 50 80 00       	mov    0x805024,%eax
  800869:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80086f:	83 ec 04             	sub    $0x4,%esp
  800872:	52                   	push   %edx
  800873:	50                   	push   %eax
  800874:	68 64 3f 80 00       	push   $0x803f64
  800879:	e8 85 03 00 00       	call   800c03 <cprintf>
  80087e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800881:	a1 24 50 80 00       	mov    0x805024,%eax
  800886:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
  800891:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800897:	a1 24 50 80 00       	mov    0x805024,%eax
  80089c:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8008a2:	51                   	push   %ecx
  8008a3:	52                   	push   %edx
  8008a4:	50                   	push   %eax
  8008a5:	68 8c 3f 80 00       	push   $0x803f8c
  8008aa:	e8 54 03 00 00       	call   800c03 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b7:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	50                   	push   %eax
  8008c1:	68 e4 3f 80 00       	push   $0x803fe4
  8008c6:	e8 38 03 00 00       	call   800c03 <cprintf>
  8008cb:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008ce:	83 ec 0c             	sub    $0xc,%esp
  8008d1:	68 18 3f 80 00       	push   $0x803f18
  8008d6:	e8 28 03 00 00       	call   800c03 <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008de:	e8 96 1f 00 00       	call   802879 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008e3:	e8 1f 00 00 00       	call   800907 <exit>
}
  8008e8:	90                   	nop
  8008e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5f                   	pop    %edi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	6a 00                	push   $0x0
  8008fc:	e8 a3 21 00 00       	call   802aa4 <sys_destroy_env>
  800901:	83 c4 10             	add    $0x10,%esp
}
  800904:	90                   	nop
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <exit>:

void
exit(void)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80090d:	e8 f8 21 00 00       	call   802b0a <sys_exit_env>
}
  800912:	90                   	nop
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80091b:	8d 45 10             	lea    0x10(%ebp),%eax
  80091e:	83 c0 04             	add    $0x4,%eax
  800921:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800924:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800929:	85 c0                	test   %eax,%eax
  80092b:	74 16                	je     800943 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80092d:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	50                   	push   %eax
  800936:	68 5c 40 80 00       	push   $0x80405c
  80093b:	e8 c3 02 00 00       	call   800c03 <cprintf>
  800940:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800943:	a1 04 50 80 00       	mov    0x805004,%eax
  800948:	83 ec 0c             	sub    $0xc,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	ff 75 08             	pushl  0x8(%ebp)
  800951:	50                   	push   %eax
  800952:	68 64 40 80 00       	push   $0x804064
  800957:	6a 74                	push   $0x74
  800959:	e8 d2 02 00 00       	call   800c30 <cprintf_colored>
  80095e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800961:	8b 45 10             	mov    0x10(%ebp),%eax
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 f4             	pushl  -0xc(%ebp)
  80096a:	50                   	push   %eax
  80096b:	e8 24 02 00 00       	call   800b94 <vcprintf>
  800970:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	6a 00                	push   $0x0
  800978:	68 8c 40 80 00       	push   $0x80408c
  80097d:	e8 12 02 00 00       	call   800b94 <vcprintf>
  800982:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800985:	e8 7d ff ff ff       	call   800907 <exit>

	// should not return here
	while (1) ;
  80098a:	eb fe                	jmp    80098a <_panic+0x75>

0080098c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800993:	a1 24 50 80 00       	mov    0x805024,%eax
  800998:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80099e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a1:	39 c2                	cmp    %eax,%edx
  8009a3:	74 14                	je     8009b9 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 90 40 80 00       	push   $0x804090
  8009ad:	6a 26                	push   $0x26
  8009af:	68 dc 40 80 00       	push   $0x8040dc
  8009b4:	e8 5c ff ff ff       	call   800915 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009c7:	e9 d9 00 00 00       	jmp    800aa5 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	01 d0                	add    %edx,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	85 c0                	test   %eax,%eax
  8009df:	75 08                	jne    8009e9 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8009e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009e4:	e9 b9 00 00 00       	jmp    800aa2 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8009e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009f7:	eb 79                	jmp    800a72 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009f9:	a1 24 50 80 00       	mov    0x805024,%eax
  8009fe:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a07:	89 d0                	mov    %edx,%eax
  800a09:	01 c0                	add    %eax,%eax
  800a0b:	01 d0                	add    %edx,%eax
  800a0d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a14:	01 d8                	add    %ebx,%eax
  800a16:	01 d0                	add    %edx,%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8a 40 04             	mov    0x4(%eax),%al
  800a1d:	84 c0                	test   %al,%al
  800a1f:	75 4e                	jne    800a6f <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a21:	a1 24 50 80 00       	mov    0x805024,%eax
  800a26:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a2f:	89 d0                	mov    %edx,%eax
  800a31:	01 c0                	add    %eax,%eax
  800a33:	01 d0                	add    %edx,%eax
  800a35:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a3c:	01 d8                	add    %ebx,%eax
  800a3e:	01 d0                	add    %edx,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a4f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a54:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	01 c8                	add    %ecx,%eax
  800a60:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	75 09                	jne    800a6f <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800a66:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a6d:	eb 19                	jmp    800a88 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a6f:	ff 45 e8             	incl   -0x18(%ebp)
  800a72:	a1 24 50 80 00       	mov    0x805024,%eax
  800a77:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a80:	39 c2                	cmp    %eax,%edx
  800a82:	0f 87 71 ff ff ff    	ja     8009f9 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a8c:	75 14                	jne    800aa2 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 e8 40 80 00       	push   $0x8040e8
  800a96:	6a 3a                	push   $0x3a
  800a98:	68 dc 40 80 00       	push   $0x8040dc
  800a9d:	e8 73 fe ff ff       	call   800915 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800aa2:	ff 45 f0             	incl   -0x10(%ebp)
  800aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800aab:	0f 8c 1b ff ff ff    	jl     8009cc <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ab1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800abf:	eb 2e                	jmp    800aef <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ac1:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac6:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800acc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d0                	add    %edx,%eax
  800ad5:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800adc:	01 d8                	add    %ebx,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	01 c8                	add    %ecx,%eax
  800ae2:	8a 40 04             	mov    0x4(%eax),%al
  800ae5:	3c 01                	cmp    $0x1,%al
  800ae7:	75 03                	jne    800aec <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800ae9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aec:	ff 45 e0             	incl   -0x20(%ebp)
  800aef:	a1 24 50 80 00       	mov    0x805024,%eax
  800af4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afd:	39 c2                	cmp    %eax,%edx
  800aff:	77 c0                	ja     800ac1 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b04:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b07:	74 14                	je     800b1d <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800b09:	83 ec 04             	sub    $0x4,%esp
  800b0c:	68 3c 41 80 00       	push   $0x80413c
  800b11:	6a 44                	push   $0x44
  800b13:	68 dc 40 80 00       	push   $0x8040dc
  800b18:	e8 f8 fd ff ff       	call   800915 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b1d:	90                   	nop
  800b1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	53                   	push   %ebx
  800b27:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	89 0a                	mov    %ecx,(%edx)
  800b37:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3a:	88 d1                	mov    %dl,%cl
  800b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b4d:	75 30                	jne    800b7f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b4f:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800b55:	a0 44 50 80 00       	mov    0x805044,%al
  800b5a:	0f b6 c0             	movzbl %al,%eax
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b60:	8b 09                	mov    (%ecx),%ecx
  800b62:	89 cb                	mov    %ecx,%ebx
  800b64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b67:	83 c1 08             	add    $0x8,%ecx
  800b6a:	52                   	push   %edx
  800b6b:	50                   	push   %eax
  800b6c:	53                   	push   %ebx
  800b6d:	51                   	push   %ecx
  800b6e:	e8 a8 1c 00 00       	call   80281b <sys_cputs>
  800b73:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b82:	8b 40 04             	mov    0x4(%eax),%eax
  800b85:	8d 50 01             	lea    0x1(%eax),%edx
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b8e:	90                   	nop
  800b8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b9d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ba4:	00 00 00 
	b.cnt = 0;
  800ba7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bae:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	ff 75 08             	pushl  0x8(%ebp)
  800bb7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bbd:	50                   	push   %eax
  800bbe:	68 23 0b 80 00       	push   $0x800b23
  800bc3:	e8 5a 02 00 00       	call   800e22 <vprintfmt>
  800bc8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bcb:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800bd1:	a0 44 50 80 00       	mov    0x805044,%al
  800bd6:	0f b6 c0             	movzbl %al,%eax
  800bd9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bdf:	52                   	push   %edx
  800be0:	50                   	push   %eax
  800be1:	51                   	push   %ecx
  800be2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800be8:	83 c0 08             	add    $0x8,%eax
  800beb:	50                   	push   %eax
  800bec:	e8 2a 1c 00 00       	call   80281b <sys_cputs>
  800bf1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bf4:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800bfb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c09:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800c10:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1f:	50                   	push   %eax
  800c20:	e8 6f ff ff ff       	call   800b94 <vcprintf>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c36:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	c1 e0 08             	shl    $0x8,%eax
  800c43:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800c48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c4b:	83 c0 04             	add    $0x4,%eax
  800c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	50                   	push   %eax
  800c5b:	e8 34 ff ff ff       	call   800b94 <vcprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c66:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800c6d:	07 00 00 

	return cnt;
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c7b:	e8 df 1b 00 00       	call   80285f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c80:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8f:	50                   	push   %eax
  800c90:	e8 ff fe ff ff       	call   800b94 <vcprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c9b:	e8 d9 1b 00 00       	call   802879 <sys_unlock_cons>
	return cnt;
  800ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 14             	sub    $0x14,%esp
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cb8:	8b 45 18             	mov    0x18(%ebp),%eax
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc3:	77 55                	ja     800d1a <printnum+0x75>
  800cc5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc8:	72 05                	jb     800ccf <printnum+0x2a>
  800cca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ccd:	77 4b                	ja     800d1a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ccf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cd2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cd5:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdd:	52                   	push   %edx
  800cde:	50                   	push   %eax
  800cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce5:	e8 d2 2d 00 00       	call   803abc <__udivdi3>
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	ff 75 20             	pushl  0x20(%ebp)
  800cf3:	53                   	push   %ebx
  800cf4:	ff 75 18             	pushl  0x18(%ebp)
  800cf7:	52                   	push   %edx
  800cf8:	50                   	push   %eax
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	ff 75 08             	pushl  0x8(%ebp)
  800cff:	e8 a1 ff ff ff       	call   800ca5 <printnum>
  800d04:	83 c4 20             	add    $0x20,%esp
  800d07:	eb 1a                	jmp    800d23 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 20             	pushl  0x20(%ebp)
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	ff d0                	call   *%eax
  800d17:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d1a:	ff 4d 1c             	decl   0x1c(%ebp)
  800d1d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d21:	7f e6                	jg     800d09 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d23:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d31:	53                   	push   %ebx
  800d32:	51                   	push   %ecx
  800d33:	52                   	push   %edx
  800d34:	50                   	push   %eax
  800d35:	e8 92 2e 00 00       	call   803bcc <__umoddi3>
  800d3a:	83 c4 10             	add    $0x10,%esp
  800d3d:	05 b4 43 80 00       	add    $0x8043b4,%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	0f be c0             	movsbl %al,%eax
  800d47:	83 ec 08             	sub    $0x8,%esp
  800d4a:	ff 75 0c             	pushl  0xc(%ebp)
  800d4d:	50                   	push   %eax
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
}
  800d56:	90                   	nop
  800d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d5f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d63:	7e 1c                	jle    800d81 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	8d 50 08             	lea    0x8(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	89 10                	mov    %edx,(%eax)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	83 e8 08             	sub    $0x8,%eax
  800d7a:	8b 50 04             	mov    0x4(%eax),%edx
  800d7d:	8b 00                	mov    (%eax),%eax
  800d7f:	eb 40                	jmp    800dc1 <getuint+0x65>
	else if (lflag)
  800d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d85:	74 1e                	je     800da5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	8d 50 04             	lea    0x4(%eax),%edx
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 10                	mov    %edx,(%eax)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8b 00                	mov    (%eax),%eax
  800d99:	83 e8 04             	sub    $0x4,%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	eb 1c                	jmp    800dc1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	8d 50 04             	lea    0x4(%eax),%edx
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 10                	mov    %edx,(%eax)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 00                	mov    (%eax),%eax
  800dbc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dc6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dca:	7e 1c                	jle    800de8 <getint+0x25>
		return va_arg(*ap, long long);
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	8d 50 08             	lea    0x8(%eax),%edx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	89 10                	mov    %edx,(%eax)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	83 e8 08             	sub    $0x8,%eax
  800de1:	8b 50 04             	mov    0x4(%eax),%edx
  800de4:	8b 00                	mov    (%eax),%eax
  800de6:	eb 38                	jmp    800e20 <getint+0x5d>
	else if (lflag)
  800de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dec:	74 1a                	je     800e08 <getint+0x45>
		return va_arg(*ap, long);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	8d 50 04             	lea    0x4(%eax),%edx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 10                	mov    %edx,(%eax)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 00                	mov    (%eax),%eax
  800e00:	83 e8 04             	sub    $0x4,%eax
  800e03:	8b 00                	mov    (%eax),%eax
  800e05:	99                   	cltd   
  800e06:	eb 18                	jmp    800e20 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8b 00                	mov    (%eax),%eax
  800e0d:	8d 50 04             	lea    0x4(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 10                	mov    %edx,(%eax)
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8b 00                	mov    (%eax),%eax
  800e1a:	83 e8 04             	sub    $0x4,%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	99                   	cltd   
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e2a:	eb 17                	jmp    800e43 <vprintfmt+0x21>
			if (ch == '\0')
  800e2c:	85 db                	test   %ebx,%ebx
  800e2e:	0f 84 c1 03 00 00    	je     8011f5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	53                   	push   %ebx
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	ff d0                	call   *%eax
  800e40:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e43:	8b 45 10             	mov    0x10(%ebp),%eax
  800e46:	8d 50 01             	lea    0x1(%eax),%edx
  800e49:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	0f b6 d8             	movzbl %al,%ebx
  800e51:	83 fb 25             	cmp    $0x25,%ebx
  800e54:	75 d6                	jne    800e2c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e56:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e5a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 01             	lea    0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	0f b6 d8             	movzbl %al,%ebx
  800e84:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e87:	83 f8 5b             	cmp    $0x5b,%eax
  800e8a:	0f 87 3d 03 00 00    	ja     8011cd <vprintfmt+0x3ab>
  800e90:	8b 04 85 d8 43 80 00 	mov    0x8043d8(,%eax,4),%eax
  800e97:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e99:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e9d:	eb d7                	jmp    800e76 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e9f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ea3:	eb d1                	jmp    800e76 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800eaf:	89 d0                	mov    %edx,%eax
  800eb1:	c1 e0 02             	shl    $0x2,%eax
  800eb4:	01 d0                	add    %edx,%eax
  800eb6:	01 c0                	add    %eax,%eax
  800eb8:	01 d8                	add    %ebx,%eax
  800eba:	83 e8 30             	sub    $0x30,%eax
  800ebd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ec8:	83 fb 2f             	cmp    $0x2f,%ebx
  800ecb:	7e 3e                	jle    800f0b <vprintfmt+0xe9>
  800ecd:	83 fb 39             	cmp    $0x39,%ebx
  800ed0:	7f 39                	jg     800f0b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ed2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ed5:	eb d5                	jmp    800eac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ed7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eda:	83 c0 04             	add    $0x4,%eax
  800edd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee3:	83 e8 04             	sub    $0x4,%eax
  800ee6:	8b 00                	mov    (%eax),%eax
  800ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800eeb:	eb 1f                	jmp    800f0c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800eed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef1:	79 83                	jns    800e76 <vprintfmt+0x54>
				width = 0;
  800ef3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800efa:	e9 77 ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800eff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f06:	e9 6b ff ff ff       	jmp    800e76 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f0b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f10:	0f 89 60 ff ff ff    	jns    800e76 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f23:	e9 4e ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f28:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f2b:	e9 46 ff ff ff       	jmp    800e76 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f30:	8b 45 14             	mov    0x14(%ebp),%eax
  800f33:	83 c0 04             	add    $0x4,%eax
  800f36:	89 45 14             	mov    %eax,0x14(%ebp)
  800f39:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3c:	83 e8 04             	sub    $0x4,%eax
  800f3f:	8b 00                	mov    (%eax),%eax
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	50                   	push   %eax
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			break;
  800f50:	e9 9b 02 00 00       	jmp    8011f0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f55:	8b 45 14             	mov    0x14(%ebp),%eax
  800f58:	83 c0 04             	add    $0x4,%eax
  800f5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f61:	83 e8 04             	sub    $0x4,%eax
  800f64:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f66:	85 db                	test   %ebx,%ebx
  800f68:	79 02                	jns    800f6c <vprintfmt+0x14a>
				err = -err;
  800f6a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f6c:	83 fb 64             	cmp    $0x64,%ebx
  800f6f:	7f 0b                	jg     800f7c <vprintfmt+0x15a>
  800f71:	8b 34 9d 20 42 80 00 	mov    0x804220(,%ebx,4),%esi
  800f78:	85 f6                	test   %esi,%esi
  800f7a:	75 19                	jne    800f95 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f7c:	53                   	push   %ebx
  800f7d:	68 c5 43 80 00       	push   $0x8043c5
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 70 02 00 00       	call   8011fd <printfmt>
  800f8d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f90:	e9 5b 02 00 00       	jmp    8011f0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f95:	56                   	push   %esi
  800f96:	68 ce 43 80 00       	push   $0x8043ce
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	e8 57 02 00 00       	call   8011fd <printfmt>
  800fa6:	83 c4 10             	add    $0x10,%esp
			break;
  800fa9:	e9 42 02 00 00       	jmp    8011f0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fae:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb1:	83 c0 04             	add    $0x4,%eax
  800fb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fba:	83 e8 04             	sub    $0x4,%eax
  800fbd:	8b 30                	mov    (%eax),%esi
  800fbf:	85 f6                	test   %esi,%esi
  800fc1:	75 05                	jne    800fc8 <vprintfmt+0x1a6>
				p = "(null)";
  800fc3:	be d1 43 80 00       	mov    $0x8043d1,%esi
			if (width > 0 && padc != '-')
  800fc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcc:	7e 6d                	jle    80103b <vprintfmt+0x219>
  800fce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fd2:	74 67                	je     80103b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	50                   	push   %eax
  800fdb:	56                   	push   %esi
  800fdc:	e8 1e 03 00 00       	call   8012ff <strnlen>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fe7:	eb 16                	jmp    800fff <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fe9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 0c             	pushl  0xc(%ebp)
  800ff3:	50                   	push   %eax
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	ff d0                	call   *%eax
  800ff9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ffc:	ff 4d e4             	decl   -0x1c(%ebp)
  800fff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801003:	7f e4                	jg     800fe9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801005:	eb 34                	jmp    80103b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801007:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80100b:	74 1c                	je     801029 <vprintfmt+0x207>
  80100d:	83 fb 1f             	cmp    $0x1f,%ebx
  801010:	7e 05                	jle    801017 <vprintfmt+0x1f5>
  801012:	83 fb 7e             	cmp    $0x7e,%ebx
  801015:	7e 12                	jle    801029 <vprintfmt+0x207>
					putch('?', putdat);
  801017:	83 ec 08             	sub    $0x8,%esp
  80101a:	ff 75 0c             	pushl  0xc(%ebp)
  80101d:	6a 3f                	push   $0x3f
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	ff d0                	call   *%eax
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	eb 0f                	jmp    801038 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	ff 75 0c             	pushl  0xc(%ebp)
  80102f:	53                   	push   %ebx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	ff d0                	call   *%eax
  801035:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801038:	ff 4d e4             	decl   -0x1c(%ebp)
  80103b:	89 f0                	mov    %esi,%eax
  80103d:	8d 70 01             	lea    0x1(%eax),%esi
  801040:	8a 00                	mov    (%eax),%al
  801042:	0f be d8             	movsbl %al,%ebx
  801045:	85 db                	test   %ebx,%ebx
  801047:	74 24                	je     80106d <vprintfmt+0x24b>
  801049:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104d:	78 b8                	js     801007 <vprintfmt+0x1e5>
  80104f:	ff 4d e0             	decl   -0x20(%ebp)
  801052:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801056:	79 af                	jns    801007 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801058:	eb 13                	jmp    80106d <vprintfmt+0x24b>
				putch(' ', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 20                	push   $0x20
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80106a:	ff 4d e4             	decl   -0x1c(%ebp)
  80106d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801071:	7f e7                	jg     80105a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801073:	e9 78 01 00 00       	jmp    8011f0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	ff 75 e8             	pushl  -0x18(%ebp)
  80107e:	8d 45 14             	lea    0x14(%ebp),%eax
  801081:	50                   	push   %eax
  801082:	e8 3c fd ff ff       	call   800dc3 <getint>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801096:	85 d2                	test   %edx,%edx
  801098:	79 23                	jns    8010bd <vprintfmt+0x29b>
				putch('-', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 2d                	push   $0x2d
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b0:	f7 d8                	neg    %eax
  8010b2:	83 d2 00             	adc    $0x0,%edx
  8010b5:	f7 da                	neg    %edx
  8010b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c4:	e9 bc 00 00 00       	jmp    801185 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	e8 84 fc ff ff       	call   800d5c <getuint>
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e8:	e9 98 00 00 00       	jmp    801185 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 58                	push   $0x58
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	ff 75 0c             	pushl  0xc(%ebp)
  801103:	6a 58                	push   $0x58
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	ff d0                	call   *%eax
  80110a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	ff 75 0c             	pushl  0xc(%ebp)
  801113:	6a 58                	push   $0x58
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
			break;
  80111d:	e9 ce 00 00 00       	jmp    8011f0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	6a 30                	push   $0x30
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	ff d0                	call   *%eax
  80112f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801132:	83 ec 08             	sub    $0x8,%esp
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	6a 78                	push   $0x78
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	ff d0                	call   *%eax
  80113f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801142:	8b 45 14             	mov    0x14(%ebp),%eax
  801145:	83 c0 04             	add    $0x4,%eax
  801148:	89 45 14             	mov    %eax,0x14(%ebp)
  80114b:	8b 45 14             	mov    0x14(%ebp),%eax
  80114e:	83 e8 04             	sub    $0x4,%eax
  801151:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801153:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80115d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801164:	eb 1f                	jmp    801185 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	ff 75 e8             	pushl  -0x18(%ebp)
  80116c:	8d 45 14             	lea    0x14(%ebp),%eax
  80116f:	50                   	push   %eax
  801170:	e8 e7 fb ff ff       	call   800d5c <getuint>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80117e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801185:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80118c:	83 ec 04             	sub    $0x4,%esp
  80118f:	52                   	push   %edx
  801190:	ff 75 e4             	pushl  -0x1c(%ebp)
  801193:	50                   	push   %eax
  801194:	ff 75 f4             	pushl  -0xc(%ebp)
  801197:	ff 75 f0             	pushl  -0x10(%ebp)
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	ff 75 08             	pushl  0x8(%ebp)
  8011a0:	e8 00 fb ff ff       	call   800ca5 <printnum>
  8011a5:	83 c4 20             	add    $0x20,%esp
			break;
  8011a8:	eb 46                	jmp    8011f0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011aa:	83 ec 08             	sub    $0x8,%esp
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	53                   	push   %ebx
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	ff d0                	call   *%eax
  8011b6:	83 c4 10             	add    $0x10,%esp
			break;
  8011b9:	eb 35                	jmp    8011f0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011bb:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  8011c2:	eb 2c                	jmp    8011f0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011c4:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  8011cb:	eb 23                	jmp    8011f0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	ff 75 0c             	pushl  0xc(%ebp)
  8011d3:	6a 25                	push   $0x25
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	ff d0                	call   *%eax
  8011da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011dd:	ff 4d 10             	decl   0x10(%ebp)
  8011e0:	eb 03                	jmp    8011e5 <vprintfmt+0x3c3>
  8011e2:	ff 4d 10             	decl   0x10(%ebp)
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	48                   	dec    %eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 25                	cmp    $0x25,%al
  8011ed:	75 f3                	jne    8011e2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011ef:	90                   	nop
		}
	}
  8011f0:	e9 35 fc ff ff       	jmp    800e2a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f9:	5b                   	pop    %ebx
  8011fa:	5e                   	pop    %esi
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 04 fc ff ff       	call   800e22 <vprintfmt>
  80121e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801221:	90                   	nop
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	8b 40 08             	mov    0x8(%eax),%eax
  80122d:	8d 50 01             	lea    0x1(%eax),%edx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	8b 10                	mov    (%eax),%edx
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	8b 40 04             	mov    0x4(%eax),%eax
  801241:	39 c2                	cmp    %eax,%edx
  801243:	73 12                	jae    801257 <sprintputch+0x33>
		*b->buf++ = ch;
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	8b 00                	mov    (%eax),%eax
  80124a:	8d 48 01             	lea    0x1(%eax),%ecx
  80124d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801250:	89 0a                	mov    %ecx,(%edx)
  801252:	8b 55 08             	mov    0x8(%ebp),%edx
  801255:	88 10                	mov    %dl,(%eax)
}
  801257:	90                   	nop
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	8d 50 ff             	lea    -0x1(%eax),%edx
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	01 d0                	add    %edx,%eax
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801274:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80127b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127f:	74 06                	je     801287 <vsnprintf+0x2d>
  801281:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801285:	7f 07                	jg     80128e <vsnprintf+0x34>
		return -E_INVAL;
  801287:	b8 03 00 00 00       	mov    $0x3,%eax
  80128c:	eb 20                	jmp    8012ae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128e:	ff 75 14             	pushl  0x14(%ebp)
  801291:	ff 75 10             	pushl  0x10(%ebp)
  801294:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801297:	50                   	push   %eax
  801298:	68 24 12 80 00       	push   $0x801224
  80129d:	e8 80 fb ff ff       	call   800e22 <vprintfmt>
  8012a2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b6:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b9:	83 c0 04             	add    $0x4,%eax
  8012bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c5:	50                   	push   %eax
  8012c6:	ff 75 0c             	pushl  0xc(%ebp)
  8012c9:	ff 75 08             	pushl  0x8(%ebp)
  8012cc:	e8 89 ff ff ff       	call   80125a <vsnprintf>
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e9:	eb 06                	jmp    8012f1 <strlen+0x15>
		n++;
  8012eb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ee:	ff 45 08             	incl   0x8(%ebp)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	75 f1                	jne    8012eb <strlen+0xf>
		n++;
	return n;
  8012fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130c:	eb 09                	jmp    801317 <strnlen+0x18>
		n++;
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801311:	ff 45 08             	incl   0x8(%ebp)
  801314:	ff 4d 0c             	decl   0xc(%ebp)
  801317:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131b:	74 09                	je     801326 <strnlen+0x27>
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	84 c0                	test   %al,%al
  801324:	75 e8                	jne    80130e <strnlen+0xf>
		n++;
	return n;
  801326:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801337:	90                   	nop
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8d 50 01             	lea    0x1(%eax),%edx
  80133e:	89 55 08             	mov    %edx,0x8(%ebp)
  801341:	8b 55 0c             	mov    0xc(%ebp),%edx
  801344:	8d 4a 01             	lea    0x1(%edx),%ecx
  801347:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80134a:	8a 12                	mov    (%edx),%dl
  80134c:	88 10                	mov    %dl,(%eax)
  80134e:	8a 00                	mov    (%eax),%al
  801350:	84 c0                	test   %al,%al
  801352:	75 e4                	jne    801338 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801354:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136c:	eb 1f                	jmp    80138d <strncpy+0x34>
		*dst++ = *src;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8d 50 01             	lea    0x1(%eax),%edx
  801374:	89 55 08             	mov    %edx,0x8(%ebp)
  801377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137a:	8a 12                	mov    (%edx),%dl
  80137c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	84 c0                	test   %al,%al
  801385:	74 03                	je     80138a <strncpy+0x31>
			src++;
  801387:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80138a:	ff 45 fc             	incl   -0x4(%ebp)
  80138d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801390:	3b 45 10             	cmp    0x10(%ebp),%eax
  801393:	72 d9                	jb     80136e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801395:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013aa:	74 30                	je     8013dc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013ac:	eb 16                	jmp    8013c4 <strlcpy+0x2a>
			*dst++ = *src++;
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8d 50 01             	lea    0x1(%eax),%edx
  8013b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013c0:	8a 12                	mov    (%edx),%dl
  8013c2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013c4:	ff 4d 10             	decl   0x10(%ebp)
  8013c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cb:	74 09                	je     8013d6 <strlcpy+0x3c>
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	84 c0                	test   %al,%al
  8013d4:	75 d8                	jne    8013ae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e2:	29 c2                	sub    %eax,%edx
  8013e4:	89 d0                	mov    %edx,%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013eb:	eb 06                	jmp    8013f3 <strcmp+0xb>
		p++, q++;
  8013ed:	ff 45 08             	incl   0x8(%ebp)
  8013f0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	84 c0                	test   %al,%al
  8013fa:	74 0e                	je     80140a <strcmp+0x22>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 10                	mov    (%eax),%dl
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	38 c2                	cmp    %al,%dl
  801408:	74 e3                	je     8013ed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	0f b6 d0             	movzbl %al,%edx
  801412:	8b 45 0c             	mov    0xc(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	29 c2                	sub    %eax,%edx
  80141c:	89 d0                	mov    %edx,%eax
}
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801423:	eb 09                	jmp    80142e <strncmp+0xe>
		n--, p++, q++;
  801425:	ff 4d 10             	decl   0x10(%ebp)
  801428:	ff 45 08             	incl   0x8(%ebp)
  80142b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80142e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801432:	74 17                	je     80144b <strncmp+0x2b>
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	74 0e                	je     80144b <strncmp+0x2b>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 10                	mov    (%eax),%dl
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	38 c2                	cmp    %al,%dl
  801449:	74 da                	je     801425 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80144b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144f:	75 07                	jne    801458 <strncmp+0x38>
		return 0;
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
  801456:	eb 14                	jmp    80146c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	0f b6 d0             	movzbl %al,%edx
  801460:	8b 45 0c             	mov    0xc(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	0f b6 c0             	movzbl %al,%eax
  801468:	29 c2                	sub    %eax,%edx
  80146a:	89 d0                	mov    %edx,%eax
}
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 04             	sub    $0x4,%esp
  801474:	8b 45 0c             	mov    0xc(%ebp),%eax
  801477:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80147a:	eb 12                	jmp    80148e <strchr+0x20>
		if (*s == c)
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801484:	75 05                	jne    80148b <strchr+0x1d>
			return (char *) s;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	eb 11                	jmp    80149c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80148b:	ff 45 08             	incl   0x8(%ebp)
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	84 c0                	test   %al,%al
  801495:	75 e5                	jne    80147c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 04             	sub    $0x4,%esp
  8014a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014aa:	eb 0d                	jmp    8014b9 <strfind+0x1b>
		if (*s == c)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014b4:	74 0e                	je     8014c4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014b6:	ff 45 08             	incl   0x8(%ebp)
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	84 c0                	test   %al,%al
  8014c0:	75 ea                	jne    8014ac <strfind+0xe>
  8014c2:	eb 01                	jmp    8014c5 <strfind+0x27>
		if (*s == c)
			break;
  8014c4:	90                   	nop
	return (char *) s;
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014d6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014da:	76 63                	jbe    80153f <memset+0x75>
		uint64 data_block = c;
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	99                   	cltd   
  8014e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ec:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014f0:	c1 e0 08             	shl    $0x8,%eax
  8014f3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014f6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ff:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801503:	c1 e0 10             	shl    $0x10,%eax
  801506:	09 45 f0             	or     %eax,-0x10(%ebp)
  801509:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80150c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801512:	89 c2                	mov    %eax,%edx
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	09 45 f0             	or     %eax,-0x10(%ebp)
  80151c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80151f:	eb 18                	jmp    801539 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801521:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801524:	8d 41 08             	lea    0x8(%ecx),%eax
  801527:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80152a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801530:	89 01                	mov    %eax,(%ecx)
  801532:	89 51 04             	mov    %edx,0x4(%ecx)
  801535:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801539:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80153d:	77 e2                	ja     801521 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80153f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801543:	74 23                	je     801568 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801545:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801548:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80154b:	eb 0e                	jmp    80155b <memset+0x91>
			*p8++ = (uint8)c;
  80154d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801550:	8d 50 01             	lea    0x1(%eax),%edx
  801553:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801556:	8b 55 0c             	mov    0xc(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e5                	jne    80154d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80157f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801583:	76 24                	jbe    8015a9 <memcpy+0x3c>
		while(n >= 8){
  801585:	eb 1c                	jmp    8015a3 <memcpy+0x36>
			*d64 = *s64;
  801587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158a:	8b 50 04             	mov    0x4(%eax),%edx
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801592:	89 01                	mov    %eax,(%ecx)
  801594:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801597:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80159b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80159f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015a3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015a7:	77 de                	ja     801587 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ad:	74 31                	je     8015e0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015bb:	eb 16                	jmp    8015d3 <memcpy+0x66>
			*d8++ = *s8++;
  8015bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c0:	8d 50 01             	lea    0x1(%eax),%edx
  8015c3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015cc:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015cf:	8a 12                	mov    (%edx),%dl
  8015d1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	75 dd                	jne    8015bd <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015fd:	73 50                	jae    80164f <memmove+0x6a>
  8015ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801602:	8b 45 10             	mov    0x10(%ebp),%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80160a:	76 43                	jbe    80164f <memmove+0x6a>
		s += n;
  80160c:	8b 45 10             	mov    0x10(%ebp),%eax
  80160f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801618:	eb 10                	jmp    80162a <memmove+0x45>
			*--d = *--s;
  80161a:	ff 4d f8             	decl   -0x8(%ebp)
  80161d:	ff 4d fc             	decl   -0x4(%ebp)
  801620:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801623:	8a 10                	mov    (%eax),%dl
  801625:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801628:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80162a:	8b 45 10             	mov    0x10(%ebp),%eax
  80162d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801630:	89 55 10             	mov    %edx,0x10(%ebp)
  801633:	85 c0                	test   %eax,%eax
  801635:	75 e3                	jne    80161a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801637:	eb 23                	jmp    80165c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801639:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163c:	8d 50 01             	lea    0x1(%eax),%edx
  80163f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801642:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801645:	8d 4a 01             	lea    0x1(%edx),%ecx
  801648:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80164b:	8a 12                	mov    (%edx),%dl
  80164d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	8d 50 ff             	lea    -0x1(%eax),%edx
  801655:	89 55 10             	mov    %edx,0x10(%ebp)
  801658:	85 c0                	test   %eax,%eax
  80165a:	75 dd                	jne    801639 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80166d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801670:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801673:	eb 2a                	jmp    80169f <memcmp+0x3e>
		if (*s1 != *s2)
  801675:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801678:	8a 10                	mov    (%eax),%dl
  80167a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	38 c2                	cmp    %al,%dl
  801681:	74 16                	je     801699 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801683:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801686:	8a 00                	mov    (%eax),%al
  801688:	0f b6 d0             	movzbl %al,%edx
  80168b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	0f b6 c0             	movzbl %al,%eax
  801693:	29 c2                	sub    %eax,%edx
  801695:	89 d0                	mov    %edx,%eax
  801697:	eb 18                	jmp    8016b1 <memcmp+0x50>
		s1++, s2++;
  801699:	ff 45 fc             	incl   -0x4(%ebp)
  80169c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80169f:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	75 c9                	jne    801675 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bf:	01 d0                	add    %edx,%eax
  8016c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016c4:	eb 15                	jmp    8016db <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	8a 00                	mov    (%eax),%al
  8016cb:	0f b6 d0             	movzbl %al,%edx
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	0f b6 c0             	movzbl %al,%eax
  8016d4:	39 c2                	cmp    %eax,%edx
  8016d6:	74 0d                	je     8016e5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016d8:	ff 45 08             	incl   0x8(%ebp)
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016e1:	72 e3                	jb     8016c6 <memfind+0x13>
  8016e3:	eb 01                	jmp    8016e6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016e5:	90                   	nop
	return (void *) s;
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ff:	eb 03                	jmp    801704 <strtol+0x19>
		s++;
  801701:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3c 20                	cmp    $0x20,%al
  80170b:	74 f4                	je     801701 <strtol+0x16>
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	3c 09                	cmp    $0x9,%al
  801714:	74 eb                	je     801701 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	3c 2b                	cmp    $0x2b,%al
  80171d:	75 05                	jne    801724 <strtol+0x39>
		s++;
  80171f:	ff 45 08             	incl   0x8(%ebp)
  801722:	eb 13                	jmp    801737 <strtol+0x4c>
	else if (*s == '-')
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	3c 2d                	cmp    $0x2d,%al
  80172b:	75 0a                	jne    801737 <strtol+0x4c>
		s++, neg = 1;
  80172d:	ff 45 08             	incl   0x8(%ebp)
  801730:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801737:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173b:	74 06                	je     801743 <strtol+0x58>
  80173d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801741:	75 20                	jne    801763 <strtol+0x78>
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8a 00                	mov    (%eax),%al
  801748:	3c 30                	cmp    $0x30,%al
  80174a:	75 17                	jne    801763 <strtol+0x78>
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	40                   	inc    %eax
  801750:	8a 00                	mov    (%eax),%al
  801752:	3c 78                	cmp    $0x78,%al
  801754:	75 0d                	jne    801763 <strtol+0x78>
		s += 2, base = 16;
  801756:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80175a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801761:	eb 28                	jmp    80178b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801763:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801767:	75 15                	jne    80177e <strtol+0x93>
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8a 00                	mov    (%eax),%al
  80176e:	3c 30                	cmp    $0x30,%al
  801770:	75 0c                	jne    80177e <strtol+0x93>
		s++, base = 8;
  801772:	ff 45 08             	incl   0x8(%ebp)
  801775:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80177c:	eb 0d                	jmp    80178b <strtol+0xa0>
	else if (base == 0)
  80177e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801782:	75 07                	jne    80178b <strtol+0xa0>
		base = 10;
  801784:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	3c 2f                	cmp    $0x2f,%al
  801792:	7e 19                	jle    8017ad <strtol+0xc2>
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	3c 39                	cmp    $0x39,%al
  80179b:	7f 10                	jg     8017ad <strtol+0xc2>
			dig = *s - '0';
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	83 e8 30             	sub    $0x30,%eax
  8017a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ab:	eb 42                	jmp    8017ef <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 60                	cmp    $0x60,%al
  8017b4:	7e 19                	jle    8017cf <strtol+0xe4>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 7a                	cmp    $0x7a,%al
  8017bd:	7f 10                	jg     8017cf <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	0f be c0             	movsbl %al,%eax
  8017c7:	83 e8 57             	sub    $0x57,%eax
  8017ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cd:	eb 20                	jmp    8017ef <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8a 00                	mov    (%eax),%al
  8017d4:	3c 40                	cmp    $0x40,%al
  8017d6:	7e 39                	jle    801811 <strtol+0x126>
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	8a 00                	mov    (%eax),%al
  8017dd:	3c 5a                	cmp    $0x5a,%al
  8017df:	7f 30                	jg     801811 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	0f be c0             	movsbl %al,%eax
  8017e9:	83 e8 37             	sub    $0x37,%eax
  8017ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017f5:	7d 19                	jge    801810 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017f7:	ff 45 08             	incl   0x8(%ebp)
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	0f af 45 10          	imul   0x10(%ebp),%eax
  801801:	89 c2                	mov    %eax,%edx
  801803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80180b:	e9 7b ff ff ff       	jmp    80178b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801810:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801811:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801815:	74 08                	je     80181f <strtol+0x134>
		*endptr = (char *) s;
  801817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181a:	8b 55 08             	mov    0x8(%ebp),%edx
  80181d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80181f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801823:	74 07                	je     80182c <strtol+0x141>
  801825:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801828:	f7 d8                	neg    %eax
  80182a:	eb 03                	jmp    80182f <strtol+0x144>
  80182c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <ltostr>:

void
ltostr(long value, char *str)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80183e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801845:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801849:	79 13                	jns    80185e <ltostr+0x2d>
	{
		neg = 1;
  80184b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801852:	8b 45 0c             	mov    0xc(%ebp),%eax
  801855:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801858:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80185b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801866:	99                   	cltd   
  801867:	f7 f9                	idiv   %ecx
  801869:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80186c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186f:	8d 50 01             	lea    0x1(%eax),%edx
  801872:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801875:	89 c2                	mov    %eax,%edx
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	01 d0                	add    %edx,%eax
  80187c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80187f:	83 c2 30             	add    $0x30,%edx
  801882:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801884:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801887:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80188c:	f7 e9                	imul   %ecx
  80188e:	c1 fa 02             	sar    $0x2,%edx
  801891:	89 c8                	mov    %ecx,%eax
  801893:	c1 f8 1f             	sar    $0x1f,%eax
  801896:	29 c2                	sub    %eax,%edx
  801898:	89 d0                	mov    %edx,%eax
  80189a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80189d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a1:	75 bb                	jne    80185e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ad:	48                   	dec    %eax
  8018ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b5:	74 3d                	je     8018f4 <ltostr+0xc3>
		start = 1 ;
  8018b7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018be:	eb 34                	jmp    8018f4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c6:	01 d0                	add    %edx,%eax
  8018c8:	8a 00                	mov    (%eax),%al
  8018ca:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d3:	01 c2                	add    %eax,%edx
  8018d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018db:	01 c8                	add    %ecx,%eax
  8018dd:	8a 00                	mov    (%eax),%al
  8018df:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	01 c2                	add    %eax,%edx
  8018e9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018ec:	88 02                	mov    %al,(%edx)
		start++ ;
  8018ee:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018f1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018fa:	7c c4                	jl     8018c0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801907:	90                   	nop
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801910:	ff 75 08             	pushl  0x8(%ebp)
  801913:	e8 c4 f9 ff ff       	call   8012dc <strlen>
  801918:	83 c4 04             	add    $0x4,%esp
  80191b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	e8 b6 f9 ff ff       	call   8012dc <strlen>
  801926:	83 c4 04             	add    $0x4,%esp
  801929:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80192c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801933:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80193a:	eb 17                	jmp    801953 <strcconcat+0x49>
		final[s] = str1[s] ;
  80193c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80193f:	8b 45 10             	mov    0x10(%ebp),%eax
  801942:	01 c2                	add    %eax,%edx
  801944:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	01 c8                	add    %ecx,%eax
  80194c:	8a 00                	mov    (%eax),%al
  80194e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801950:	ff 45 fc             	incl   -0x4(%ebp)
  801953:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801956:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801959:	7c e1                	jl     80193c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80195b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801962:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801969:	eb 1f                	jmp    80198a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196e:	8d 50 01             	lea    0x1(%eax),%edx
  801971:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801974:	89 c2                	mov    %eax,%edx
  801976:	8b 45 10             	mov    0x10(%ebp),%eax
  801979:	01 c2                	add    %eax,%edx
  80197b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 c8                	add    %ecx,%eax
  801983:	8a 00                	mov    (%eax),%al
  801985:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801987:	ff 45 f8             	incl   -0x8(%ebp)
  80198a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80198d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801990:	7c d9                	jl     80196b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801992:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801995:	8b 45 10             	mov    0x10(%ebp),%eax
  801998:	01 d0                	add    %edx,%eax
  80199a:	c6 00 00             	movb   $0x0,(%eax)
}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8019af:	8b 00                	mov    (%eax),%eax
  8019b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bb:	01 d0                	add    %edx,%eax
  8019bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c3:	eb 0c                	jmp    8019d1 <strsplit+0x31>
			*string++ = 0;
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	8d 50 01             	lea    0x1(%eax),%edx
  8019cb:	89 55 08             	mov    %edx,0x8(%ebp)
  8019ce:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8a 00                	mov    (%eax),%al
  8019d6:	84 c0                	test   %al,%al
  8019d8:	74 18                	je     8019f2 <strsplit+0x52>
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8a 00                	mov    (%eax),%al
  8019df:	0f be c0             	movsbl %al,%eax
  8019e2:	50                   	push   %eax
  8019e3:	ff 75 0c             	pushl  0xc(%ebp)
  8019e6:	e8 83 fa ff ff       	call   80146e <strchr>
  8019eb:	83 c4 08             	add    $0x8,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	75 d3                	jne    8019c5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	84 c0                	test   %al,%al
  8019f9:	74 5a                	je     801a55 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	83 f8 0f             	cmp    $0xf,%eax
  801a03:	75 07                	jne    801a0c <strsplit+0x6c>
		{
			return 0;
  801a05:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0a:	eb 66                	jmp    801a72 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0f:	8b 00                	mov    (%eax),%eax
  801a11:	8d 48 01             	lea    0x1(%eax),%ecx
  801a14:	8b 55 14             	mov    0x14(%ebp),%edx
  801a17:	89 0a                	mov    %ecx,(%edx)
  801a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a20:	8b 45 10             	mov    0x10(%ebp),%eax
  801a23:	01 c2                	add    %eax,%edx
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a2a:	eb 03                	jmp    801a2f <strsplit+0x8f>
			string++;
  801a2c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8a 00                	mov    (%eax),%al
  801a34:	84 c0                	test   %al,%al
  801a36:	74 8b                	je     8019c3 <strsplit+0x23>
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	8a 00                	mov    (%eax),%al
  801a3d:	0f be c0             	movsbl %al,%eax
  801a40:	50                   	push   %eax
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	e8 25 fa ff ff       	call   80146e <strchr>
  801a49:	83 c4 08             	add    $0x8,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	74 dc                	je     801a2c <strsplit+0x8c>
			string++;
	}
  801a50:	e9 6e ff ff ff       	jmp    8019c3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a55:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a56:	8b 45 14             	mov    0x14(%ebp),%eax
  801a59:	8b 00                	mov    (%eax),%eax
  801a5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a62:	8b 45 10             	mov    0x10(%ebp),%eax
  801a65:	01 d0                	add    %edx,%eax
  801a67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a6d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a87:	eb 4a                	jmp    801ad3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	01 c2                	add    %eax,%edx
  801a91:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a97:	01 c8                	add    %ecx,%eax
  801a99:	8a 00                	mov    (%eax),%al
  801a9b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 25                	jle    801ad0 <str2lower+0x5c>
  801aab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	8a 00                	mov    (%eax),%al
  801ab5:	3c 5a                	cmp    $0x5a,%al
  801ab7:	7f 17                	jg     801ad0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ab9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	01 d0                	add    %edx,%eax
  801ac1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ac4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac7:	01 ca                	add    %ecx,%edx
  801ac9:	8a 12                	mov    (%edx),%dl
  801acb:	83 c2 20             	add    $0x20,%edx
  801ace:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ad0:	ff 45 fc             	incl   -0x4(%ebp)
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	e8 01 f8 ff ff       	call   8012dc <strlen>
  801adb:	83 c4 04             	add    $0x4,%esp
  801ade:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ae1:	7f a6                	jg     801a89 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801ae3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	6a 10                	push   $0x10
  801af3:	e8 b2 15 00 00       	call   8030aa <alloc_block>
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801afe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b02:	75 14                	jne    801b18 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	68 48 45 80 00       	push   $0x804548
  801b0c:	6a 14                	push   $0x14
  801b0e:	68 71 45 80 00       	push   $0x804571
  801b13:	e8 fd ed ff ff       	call   800915 <_panic>

	node->start = start;
  801b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b1e:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801b29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801b30:	a1 28 50 80 00       	mov    0x805028,%eax
  801b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b38:	eb 18                	jmp    801b52 <insert_page_alloc+0x6a>
		if (start < it->start)
  801b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3d:	8b 00                	mov    (%eax),%eax
  801b3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b42:	77 37                	ja     801b7b <insert_page_alloc+0x93>
			break;
		prev = it;
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801b4a:	a1 30 50 80 00       	mov    0x805030,%eax
  801b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b56:	74 08                	je     801b60 <insert_page_alloc+0x78>
  801b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5b:	8b 40 08             	mov    0x8(%eax),%eax
  801b5e:	eb 05                	jmp    801b65 <insert_page_alloc+0x7d>
  801b60:	b8 00 00 00 00       	mov    $0x0,%eax
  801b65:	a3 30 50 80 00       	mov    %eax,0x805030
  801b6a:	a1 30 50 80 00       	mov    0x805030,%eax
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	75 c7                	jne    801b3a <insert_page_alloc+0x52>
  801b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b77:	75 c1                	jne    801b3a <insert_page_alloc+0x52>
  801b79:	eb 01                	jmp    801b7c <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801b7b:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b80:	75 64                	jne    801be6 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b86:	75 14                	jne    801b9c <insert_page_alloc+0xb4>
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	68 80 45 80 00       	push   $0x804580
  801b90:	6a 21                	push   $0x21
  801b92:	68 71 45 80 00       	push   $0x804571
  801b97:	e8 79 ed ff ff       	call   800915 <_panic>
  801b9c:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba5:	89 50 08             	mov    %edx,0x8(%eax)
  801ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bab:	8b 40 08             	mov    0x8(%eax),%eax
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	74 0d                	je     801bbf <insert_page_alloc+0xd7>
  801bb2:	a1 28 50 80 00       	mov    0x805028,%eax
  801bb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bba:	89 50 0c             	mov    %edx,0xc(%eax)
  801bbd:	eb 08                	jmp    801bc7 <insert_page_alloc+0xdf>
  801bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bca:	a3 28 50 80 00       	mov    %eax,0x805028
  801bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801bd9:	a1 34 50 80 00       	mov    0x805034,%eax
  801bde:	40                   	inc    %eax
  801bdf:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801be4:	eb 71                	jmp    801c57 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bea:	74 06                	je     801bf2 <insert_page_alloc+0x10a>
  801bec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bf0:	75 14                	jne    801c06 <insert_page_alloc+0x11e>
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 a4 45 80 00       	push   $0x8045a4
  801bfa:	6a 23                	push   $0x23
  801bfc:	68 71 45 80 00       	push   $0x804571
  801c01:	e8 0f ed ff ff       	call   800915 <_panic>
  801c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c09:	8b 50 08             	mov    0x8(%eax),%edx
  801c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0f:	89 50 08             	mov    %edx,0x8(%eax)
  801c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c15:	8b 40 08             	mov    0x8(%eax),%eax
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	74 0c                	je     801c28 <insert_page_alloc+0x140>
  801c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1f:	8b 40 08             	mov    0x8(%eax),%eax
  801c22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c25:	89 50 0c             	mov    %edx,0xc(%eax)
  801c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c2e:	89 50 08             	mov    %edx,0x8(%eax)
  801c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c37:	89 50 0c             	mov    %edx,0xc(%eax)
  801c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3d:	8b 40 08             	mov    0x8(%eax),%eax
  801c40:	85 c0                	test   %eax,%eax
  801c42:	75 08                	jne    801c4c <insert_page_alloc+0x164>
  801c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c4c:	a1 34 50 80 00       	mov    0x805034,%eax
  801c51:	40                   	inc    %eax
  801c52:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801c57:	90                   	nop
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801c60:	a1 28 50 80 00       	mov    0x805028,%eax
  801c65:	85 c0                	test   %eax,%eax
  801c67:	75 0c                	jne    801c75 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801c69:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c6e:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801c73:	eb 67                	jmp    801cdc <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801c75:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c7d:	a1 28 50 80 00       	mov    0x805028,%eax
  801c82:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801c85:	eb 26                	jmp    801cad <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801c87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8a:	8b 10                	mov    (%eax),%edx
  801c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8f:	8b 40 04             	mov    0x4(%eax),%eax
  801c92:	01 d0                	add    %edx,%eax
  801c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c9d:	76 06                	jbe    801ca5 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca2:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ca5:	a1 30 50 80 00       	mov    0x805030,%eax
  801caa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801cad:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801cb1:	74 08                	je     801cbb <recompute_page_alloc_break+0x61>
  801cb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb6:	8b 40 08             	mov    0x8(%eax),%eax
  801cb9:	eb 05                	jmp    801cc0 <recompute_page_alloc_break+0x66>
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	a3 30 50 80 00       	mov    %eax,0x805030
  801cc5:	a1 30 50 80 00       	mov    0x805030,%eax
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	75 b9                	jne    801c87 <recompute_page_alloc_break+0x2d>
  801cce:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801cd2:	75 b3                	jne    801c87 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cd7:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801ce4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  801cee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cf1:	01 d0                	add    %edx,%eax
  801cf3:	48                   	dec    %eax
  801cf4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801cf7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801cff:	f7 75 d8             	divl   -0x28(%ebp)
  801d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d05:	29 d0                	sub    %edx,%eax
  801d07:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801d0a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801d0e:	75 0a                	jne    801d1a <alloc_pages_custom_fit+0x3c>
		return NULL;
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
  801d15:	e9 7e 01 00 00       	jmp    801e98 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801d1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801d21:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801d25:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801d2c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801d33:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801d3b:	a1 28 50 80 00       	mov    0x805028,%eax
  801d40:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d43:	eb 69                	jmp    801dae <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d48:	8b 00                	mov    (%eax),%eax
  801d4a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d4d:	76 47                	jbe    801d96 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d52:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d58:	8b 00                	mov    (%eax),%eax
  801d5a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801d5d:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801d60:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d63:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d66:	72 2e                	jb     801d96 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801d68:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801d6c:	75 14                	jne    801d82 <alloc_pages_custom_fit+0xa4>
  801d6e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d71:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d74:	75 0c                	jne    801d82 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801d76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801d7c:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801d80:	eb 14                	jmp    801d96 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801d82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d85:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d88:	76 0c                	jbe    801d96 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801d8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801d90:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d93:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d99:	8b 10                	mov    (%eax),%edx
  801d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d9e:	8b 40 04             	mov    0x4(%eax),%eax
  801da1:	01 d0                	add    %edx,%eax
  801da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801da6:	a1 30 50 80 00       	mov    0x805030,%eax
  801dab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801db2:	74 08                	je     801dbc <alloc_pages_custom_fit+0xde>
  801db4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db7:	8b 40 08             	mov    0x8(%eax),%eax
  801dba:	eb 05                	jmp    801dc1 <alloc_pages_custom_fit+0xe3>
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc1:	a3 30 50 80 00       	mov    %eax,0x805030
  801dc6:	a1 30 50 80 00       	mov    0x805030,%eax
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	0f 85 72 ff ff ff    	jne    801d45 <alloc_pages_custom_fit+0x67>
  801dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dd7:	0f 85 68 ff ff ff    	jne    801d45 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801ddd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801de2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801de5:	76 47                	jbe    801e2e <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801ded:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801df2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801df5:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801df8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dfb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801dfe:	72 2e                	jb     801e2e <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801e00:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e04:	75 14                	jne    801e1a <alloc_pages_custom_fit+0x13c>
  801e06:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e09:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e0c:	75 0c                	jne    801e1a <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801e0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801e14:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e18:	eb 14                	jmp    801e2e <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801e1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e1d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e20:	76 0c                	jbe    801e2e <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801e22:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e25:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801e28:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801e2e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801e35:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e39:	74 08                	je     801e43 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e41:	eb 40                	jmp    801e83 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801e43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e47:	74 08                	je     801e51 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e4f:	eb 32                	jmp    801e83 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801e51:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e56:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801e59:	89 c2                	mov    %eax,%edx
  801e5b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e60:	39 c2                	cmp    %eax,%edx
  801e62:	73 07                	jae    801e6b <alloc_pages_custom_fit+0x18d>
			return NULL;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
  801e69:	eb 2d                	jmp    801e98 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801e6b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e70:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801e73:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801e79:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e7c:	01 d0                	add    %edx,%eax
  801e7e:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801e83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e86:	83 ec 08             	sub    $0x8,%esp
  801e89:	ff 75 d0             	pushl  -0x30(%ebp)
  801e8c:	50                   	push   %eax
  801e8d:	e8 56 fc ff ff       	call   801ae8 <insert_page_alloc>
  801e92:	83 c4 10             	add    $0x10,%esp

	return result;
  801e95:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ea6:	a1 28 50 80 00       	mov    0x805028,%eax
  801eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eae:	eb 1a                	jmp    801eca <find_allocated_size+0x30>
		if (it->start == va)
  801eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb3:	8b 00                	mov    (%eax),%eax
  801eb5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801eb8:	75 08                	jne    801ec2 <find_allocated_size+0x28>
			return it->size;
  801eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ebd:	8b 40 04             	mov    0x4(%eax),%eax
  801ec0:	eb 34                	jmp    801ef6 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ec2:	a1 30 50 80 00       	mov    0x805030,%eax
  801ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ece:	74 08                	je     801ed8 <find_allocated_size+0x3e>
  801ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed3:	8b 40 08             	mov    0x8(%eax),%eax
  801ed6:	eb 05                	jmp    801edd <find_allocated_size+0x43>
  801ed8:	b8 00 00 00 00       	mov    $0x0,%eax
  801edd:	a3 30 50 80 00       	mov    %eax,0x805030
  801ee2:	a1 30 50 80 00       	mov    0x805030,%eax
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	75 c5                	jne    801eb0 <find_allocated_size+0x16>
  801eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eef:	75 bf                	jne    801eb0 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f04:	a1 28 50 80 00       	mov    0x805028,%eax
  801f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0c:	e9 e1 01 00 00       	jmp    8020f2 <free_pages+0x1fa>
		if (it->start == va) {
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	8b 00                	mov    (%eax),%eax
  801f16:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f19:	0f 85 cb 01 00 00    	jne    8020ea <free_pages+0x1f2>

			uint32 start = it->start;
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f22:	8b 00                	mov    (%eax),%eax
  801f24:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 40 04             	mov    0x4(%eax),%eax
  801f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f33:	f7 d0                	not    %eax
  801f35:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f38:	73 1d                	jae    801f57 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f40:	ff 75 e8             	pushl  -0x18(%ebp)
  801f43:	68 d8 45 80 00       	push   $0x8045d8
  801f48:	68 a5 00 00 00       	push   $0xa5
  801f4d:	68 71 45 80 00       	push   $0x804571
  801f52:	e8 be e9 ff ff       	call   800915 <_panic>
			}

			uint32 start_end = start + size;
  801f57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5d:	01 d0                	add    %edx,%eax
  801f5f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f65:	85 c0                	test   %eax,%eax
  801f67:	79 19                	jns    801f82 <free_pages+0x8a>
  801f69:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801f70:	77 10                	ja     801f82 <free_pages+0x8a>
  801f72:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801f79:	77 07                	ja     801f82 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801f7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 2c                	js     801fae <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801f82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	68 00 00 00 a0       	push   $0xa0000000
  801f8d:	ff 75 e0             	pushl  -0x20(%ebp)
  801f90:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f93:	ff 75 e8             	pushl  -0x18(%ebp)
  801f96:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f99:	50                   	push   %eax
  801f9a:	68 1c 46 80 00       	push   $0x80461c
  801f9f:	68 ad 00 00 00       	push   $0xad
  801fa4:	68 71 45 80 00       	push   $0x804571
  801fa9:	e8 67 e9 ff ff       	call   800915 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fb4:	e9 88 00 00 00       	jmp    802041 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801fb9:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801fc0:	76 17                	jbe    801fd9 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801fc2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc5:	68 80 46 80 00       	push   $0x804680
  801fca:	68 b4 00 00 00       	push   $0xb4
  801fcf:	68 71 45 80 00       	push   $0x804571
  801fd4:	e8 3c e9 ff ff       	call   800915 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdc:	05 00 10 00 00       	add    $0x1000,%eax
  801fe1:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	79 2e                	jns    802019 <free_pages+0x121>
  801feb:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801ff2:	77 25                	ja     802019 <free_pages+0x121>
  801ff4:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ffb:	77 1c                	ja     802019 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801ffd:	83 ec 08             	sub    $0x8,%esp
  802000:	68 00 10 00 00       	push   $0x1000
  802005:	ff 75 f0             	pushl  -0x10(%ebp)
  802008:	e8 38 0d 00 00       	call   802d45 <sys_free_user_mem>
  80200d:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802010:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802017:	eb 28                	jmp    802041 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201c:	68 00 00 00 a0       	push   $0xa0000000
  802021:	ff 75 dc             	pushl  -0x24(%ebp)
  802024:	68 00 10 00 00       	push   $0x1000
  802029:	ff 75 f0             	pushl  -0x10(%ebp)
  80202c:	50                   	push   %eax
  80202d:	68 c0 46 80 00       	push   $0x8046c0
  802032:	68 bd 00 00 00       	push   $0xbd
  802037:	68 71 45 80 00       	push   $0x804571
  80203c:	e8 d4 e8 ff ff       	call   800915 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802044:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802047:	0f 82 6c ff ff ff    	jb     801fb9 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  80204d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802051:	75 17                	jne    80206a <free_pages+0x172>
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	68 22 47 80 00       	push   $0x804722
  80205b:	68 c1 00 00 00       	push   $0xc1
  802060:	68 71 45 80 00       	push   $0x804571
  802065:	e8 ab e8 ff ff       	call   800915 <_panic>
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 08             	mov    0x8(%eax),%eax
  802070:	85 c0                	test   %eax,%eax
  802072:	74 11                	je     802085 <free_pages+0x18d>
  802074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802077:	8b 40 08             	mov    0x8(%eax),%eax
  80207a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207d:	8b 52 0c             	mov    0xc(%edx),%edx
  802080:	89 50 0c             	mov    %edx,0xc(%eax)
  802083:	eb 0b                	jmp    802090 <free_pages+0x198>
  802085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802088:	8b 40 0c             	mov    0xc(%eax),%eax
  80208b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	8b 40 0c             	mov    0xc(%eax),%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	74 11                	je     8020ab <free_pages+0x1b3>
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a3:	8b 52 08             	mov    0x8(%edx),%edx
  8020a6:	89 50 08             	mov    %edx,0x8(%eax)
  8020a9:	eb 0b                	jmp    8020b6 <free_pages+0x1be>
  8020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ae:	8b 40 08             	mov    0x8(%eax),%eax
  8020b1:	a3 28 50 80 00       	mov    %eax,0x805028
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020ca:	a1 34 50 80 00       	mov    0x805034,%eax
  8020cf:	48                   	dec    %eax
  8020d0:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020db:	e8 24 15 00 00       	call   803604 <free_block>
  8020e0:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8020e3:	e8 72 fb ff ff       	call   801c5a <recompute_page_alloc_break>

			return;
  8020e8:	eb 37                	jmp    802121 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8020ea:	a1 30 50 80 00       	mov    0x805030,%eax
  8020ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f6:	74 08                	je     802100 <free_pages+0x208>
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 40 08             	mov    0x8(%eax),%eax
  8020fe:	eb 05                	jmp    802105 <free_pages+0x20d>
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	a3 30 50 80 00       	mov    %eax,0x805030
  80210a:	a1 30 50 80 00       	mov    0x805030,%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	0f 85 fa fd ff ff    	jne    801f11 <free_pages+0x19>
  802117:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211b:	0f 85 f0 fd ff ff    	jne    801f11 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212b:	5d                   	pop    %ebp
  80212c:	c3                   	ret    

0080212d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802133:	a1 08 50 80 00       	mov    0x805008,%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	74 60                	je     80219c <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80213c:	83 ec 08             	sub    $0x8,%esp
  80213f:	68 00 00 00 82       	push   $0x82000000
  802144:	68 00 00 00 80       	push   $0x80000000
  802149:	e8 0d 0d 00 00       	call   802e5b <initialize_dynamic_allocator>
  80214e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802151:	e8 f3 0a 00 00       	call   802c49 <sys_get_uheap_strategy>
  802156:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80215b:	a1 40 50 80 00       	mov    0x805040,%eax
  802160:	05 00 10 00 00       	add    $0x1000,%eax
  802165:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80216a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80216f:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  802174:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  80217b:	00 00 00 
  80217e:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  802185:	00 00 00 
  802188:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  80218f:	00 00 00 

		__firstTimeFlag = 0;
  802192:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802199:	00 00 00 
	}
}
  80219c:	90                   	nop
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021b3:	83 ec 08             	sub    $0x8,%esp
  8021b6:	68 06 04 00 00       	push   $0x406
  8021bb:	50                   	push   %eax
  8021bc:	e8 d2 06 00 00       	call   802893 <__sys_allocate_page>
  8021c1:	83 c4 10             	add    $0x10,%esp
  8021c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8021c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021cb:	79 17                	jns    8021e4 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	68 40 47 80 00       	push   $0x804740
  8021d5:	68 ea 00 00 00       	push   $0xea
  8021da:	68 71 45 80 00       	push   $0x804571
  8021df:	e8 31 e7 ff ff       	call   800915 <_panic>
	return 0;
  8021e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	50                   	push   %eax
  802203:	e8 d2 06 00 00       	call   8028da <__sys_unmap_frame>
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80220e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802212:	79 17                	jns    80222b <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 7c 47 80 00       	push   $0x80477c
  80221c:	68 f5 00 00 00       	push   $0xf5
  802221:	68 71 45 80 00       	push   $0x804571
  802226:	e8 ea e6 ff ff       	call   800915 <_panic>
}
  80222b:	90                   	nop
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802234:	e8 f4 fe ff ff       	call   80212d <uheap_init>
	if (size == 0) return NULL ;
  802239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223d:	75 0a                	jne    802249 <malloc+0x1b>
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	e9 67 01 00 00       	jmp    8023b0 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802250:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802257:	77 16                	ja     80226f <malloc+0x41>
		result = alloc_block(size);
  802259:	83 ec 0c             	sub    $0xc,%esp
  80225c:	ff 75 08             	pushl  0x8(%ebp)
  80225f:	e8 46 0e 00 00       	call   8030aa <alloc_block>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226a:	e9 3e 01 00 00       	jmp    8023ad <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  80226f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802276:	8b 55 08             	mov    0x8(%ebp),%edx
  802279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227c:	01 d0                	add    %edx,%eax
  80227e:	48                   	dec    %eax
  80227f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802285:	ba 00 00 00 00       	mov    $0x0,%edx
  80228a:	f7 75 f0             	divl   -0x10(%ebp)
  80228d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802290:	29 d0                	sub    %edx,%eax
  802292:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802295:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80229a:	85 c0                	test   %eax,%eax
  80229c:	75 0a                	jne    8022a8 <malloc+0x7a>
			return NULL;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	e9 08 01 00 00       	jmp    8023b0 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8022a8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	74 0f                	je     8022c0 <malloc+0x92>
  8022b1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022b7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022bc:	39 c2                	cmp    %eax,%edx
  8022be:	73 0a                	jae    8022ca <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8022c0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022c5:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8022ca:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8022cf:	83 f8 05             	cmp    $0x5,%eax
  8022d2:	75 11                	jne    8022e5 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8022d4:	83 ec 0c             	sub    $0xc,%esp
  8022d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8022da:	e8 ff f9 ff ff       	call   801cde <alloc_pages_custom_fit>
  8022df:	83 c4 10             	add    $0x10,%esp
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8022e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e9:	0f 84 be 00 00 00    	je     8023ad <malloc+0x17f>
			uint32 result_va = (uint32)result;
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  8022f5:	83 ec 0c             	sub    $0xc,%esp
  8022f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fb:	e8 9a fb ff ff       	call   801e9a <find_allocated_size>
  802300:	83 c4 10             	add    $0x10,%esp
  802303:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802306:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80230a:	75 17                	jne    802323 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  80230c:	ff 75 f4             	pushl  -0xc(%ebp)
  80230f:	68 bc 47 80 00       	push   $0x8047bc
  802314:	68 24 01 00 00       	push   $0x124
  802319:	68 71 45 80 00       	push   $0x804571
  80231e:	e8 f2 e5 ff ff       	call   800915 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802326:	f7 d0                	not    %eax
  802328:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80232b:	73 1d                	jae    80234a <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  80232d:	83 ec 0c             	sub    $0xc,%esp
  802330:	ff 75 e0             	pushl  -0x20(%ebp)
  802333:	ff 75 e4             	pushl  -0x1c(%ebp)
  802336:	68 04 48 80 00       	push   $0x804804
  80233b:	68 29 01 00 00       	push   $0x129
  802340:	68 71 45 80 00       	push   $0x804571
  802345:	e8 cb e5 ff ff       	call   800915 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  80234a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80234d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802350:	01 d0                	add    %edx,%eax
  802352:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	79 2c                	jns    802388 <malloc+0x15a>
  80235c:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802363:	77 23                	ja     802388 <malloc+0x15a>
  802365:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80236c:	77 1a                	ja     802388 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80236e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	79 13                	jns    802388 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802375:	83 ec 08             	sub    $0x8,%esp
  802378:	ff 75 e0             	pushl  -0x20(%ebp)
  80237b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80237e:	e8 de 09 00 00       	call   802d61 <sys_allocate_user_mem>
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	eb 25                	jmp    8023ad <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802388:	68 00 00 00 a0       	push   $0xa0000000
  80238d:	ff 75 dc             	pushl  -0x24(%ebp)
  802390:	ff 75 e0             	pushl  -0x20(%ebp)
  802393:	ff 75 e4             	pushl  -0x1c(%ebp)
  802396:	ff 75 f4             	pushl  -0xc(%ebp)
  802399:	68 40 48 80 00       	push   $0x804840
  80239e:	68 33 01 00 00       	push   $0x133
  8023a3:	68 71 45 80 00       	push   $0x804571
  8023a8:	e8 68 e5 ff ff       	call   800915 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
  8023b5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8023b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bc:	0f 84 26 01 00 00    	je     8024e8 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	79 1c                	jns    8023eb <free+0x39>
  8023cf:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8023d6:	77 13                	ja     8023eb <free+0x39>
		free_block(virtual_address);
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	ff 75 08             	pushl  0x8(%ebp)
  8023de:	e8 21 12 00 00       	call   803604 <free_block>
  8023e3:	83 c4 10             	add    $0x10,%esp
		return;
  8023e6:	e9 01 01 00 00       	jmp    8024ec <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8023eb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8023f3:	0f 82 d8 00 00 00    	jb     8024d1 <free+0x11f>
  8023f9:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802400:	0f 87 cb 00 00 00    	ja     8024d1 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	25 ff 0f 00 00       	and    $0xfff,%eax
  80240e:	85 c0                	test   %eax,%eax
  802410:	74 17                	je     802429 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802412:	ff 75 08             	pushl  0x8(%ebp)
  802415:	68 b0 48 80 00       	push   $0x8048b0
  80241a:	68 57 01 00 00       	push   $0x157
  80241f:	68 71 45 80 00       	push   $0x804571
  802424:	e8 ec e4 ff ff       	call   800915 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	ff 75 08             	pushl  0x8(%ebp)
  80242f:	e8 66 fa ff ff       	call   801e9a <find_allocated_size>
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  80243a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80243e:	0f 84 a7 00 00 00    	je     8024eb <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	f7 d0                	not    %eax
  802449:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80244c:	73 1d                	jae    80246b <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	ff 75 f0             	pushl  -0x10(%ebp)
  802454:	ff 75 f4             	pushl  -0xc(%ebp)
  802457:	68 d8 48 80 00       	push   $0x8048d8
  80245c:	68 61 01 00 00       	push   $0x161
  802461:	68 71 45 80 00       	push   $0x804571
  802466:	e8 aa e4 ff ff       	call   800915 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80246b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	01 d0                	add    %edx,%eax
  802473:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	79 19                	jns    802496 <free+0xe4>
  80247d:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802484:	77 10                	ja     802496 <free+0xe4>
  802486:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80248d:	77 07                	ja     802496 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80248f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	78 2b                	js     8024c1 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802496:	83 ec 0c             	sub    $0xc,%esp
  802499:	68 00 00 00 a0       	push   $0xa0000000
  80249e:	ff 75 ec             	pushl  -0x14(%ebp)
  8024a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8024a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8024aa:	ff 75 08             	pushl  0x8(%ebp)
  8024ad:	68 14 49 80 00       	push   $0x804914
  8024b2:	68 69 01 00 00       	push   $0x169
  8024b7:	68 71 45 80 00       	push   $0x804571
  8024bc:	e8 54 e4 ff ff       	call   800915 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	ff 75 08             	pushl  0x8(%ebp)
  8024c7:	e8 2c fa ff ff       	call   801ef8 <free_pages>
  8024cc:	83 c4 10             	add    $0x10,%esp
		return;
  8024cf:	eb 1b                	jmp    8024ec <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8024d1:	ff 75 08             	pushl  0x8(%ebp)
  8024d4:	68 70 49 80 00       	push   $0x804970
  8024d9:	68 70 01 00 00       	push   $0x170
  8024de:	68 71 45 80 00       	push   $0x804571
  8024e3:	e8 2d e4 ff ff       	call   800915 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8024e8:	90                   	nop
  8024e9:	eb 01                	jmp    8024ec <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8024eb:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	83 ec 38             	sub    $0x38,%esp
  8024f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024fa:	e8 2e fc ff ff       	call   80212d <uheap_init>
	if (size == 0) return NULL ;
  8024ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802503:	75 0a                	jne    80250f <smalloc+0x21>
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	e9 3d 01 00 00       	jmp    80264c <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80250f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802515:	8b 45 0c             	mov    0xc(%ebp),%eax
  802518:	25 ff 0f 00 00       	and    $0xfff,%eax
  80251d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802520:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802524:	74 0e                	je     802534 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80252c:	05 00 10 00 00       	add    $0x1000,%eax
  802531:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	c1 e8 0c             	shr    $0xc,%eax
  80253a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  80253d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	75 0a                	jne    802550 <smalloc+0x62>
		return NULL;
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
  80254b:	e9 fc 00 00 00       	jmp    80264c <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802550:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	74 0f                	je     802568 <smalloc+0x7a>
  802559:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80255f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802564:	39 c2                	cmp    %eax,%edx
  802566:	73 0a                	jae    802572 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802568:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80256d:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802572:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802577:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80257c:	29 c2                	sub    %eax,%edx
  80257e:	89 d0                	mov    %edx,%eax
  802580:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802583:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802589:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80258e:	29 c2                	sub    %eax,%edx
  802590:	89 d0                	mov    %edx,%eax
  802592:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80259b:	77 13                	ja     8025b0 <smalloc+0xc2>
  80259d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025a3:	77 0b                	ja     8025b0 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8025a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a8:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025ab:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025ae:	73 0a                	jae    8025ba <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8025b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b5:	e9 92 00 00 00       	jmp    80264c <smalloc+0x15e>
	}

	void *va = NULL;
  8025ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8025c1:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8025c6:	83 f8 05             	cmp    $0x5,%eax
  8025c9:	75 11                	jne    8025dc <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8025cb:	83 ec 0c             	sub    $0xc,%esp
  8025ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d1:	e8 08 f7 ff ff       	call   801cde <alloc_pages_custom_fit>
  8025d6:	83 c4 10             	add    $0x10,%esp
  8025d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8025dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e0:	75 27                	jne    802609 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8025e2:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8025e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ec:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8025ef:	89 c2                	mov    %eax,%edx
  8025f1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8025f6:	39 c2                	cmp    %eax,%edx
  8025f8:	73 07                	jae    802601 <smalloc+0x113>
			return NULL;}
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ff:	eb 4b                	jmp    80264c <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802601:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802606:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802609:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80260d:	ff 75 f0             	pushl  -0x10(%ebp)
  802610:	50                   	push   %eax
  802611:	ff 75 0c             	pushl  0xc(%ebp)
  802614:	ff 75 08             	pushl  0x8(%ebp)
  802617:	e8 cb 03 00 00       	call   8029e7 <sys_create_shared_object>
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802622:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802626:	79 07                	jns    80262f <smalloc+0x141>
		return NULL;
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
  80262d:	eb 1d                	jmp    80264c <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80262f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802634:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802637:	75 10                	jne    802649 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802639:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	01 d0                	add    %edx,%eax
  802644:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  80264c:	c9                   	leave  
  80264d:	c3                   	ret    

0080264e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802654:	e8 d4 fa ff ff       	call   80212d <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802659:	83 ec 08             	sub    $0x8,%esp
  80265c:	ff 75 0c             	pushl  0xc(%ebp)
  80265f:	ff 75 08             	pushl  0x8(%ebp)
  802662:	e8 aa 03 00 00       	call   802a11 <sys_size_of_shared_object>
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80266d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802671:	7f 0a                	jg     80267d <sget+0x2f>
		return NULL;
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
  802678:	e9 32 01 00 00       	jmp    8027af <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80267d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802680:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802686:	25 ff 0f 00 00       	and    $0xfff,%eax
  80268b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80268e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802692:	74 0e                	je     8026a2 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80269a:	05 00 10 00 00       	add    $0x1000,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8026a2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	75 0a                	jne    8026b5 <sget+0x67>
		return NULL;
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	e9 fa 00 00 00       	jmp    8027af <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8026b5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	74 0f                	je     8026cd <sget+0x7f>
  8026be:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026c4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026c9:	39 c2                	cmp    %eax,%edx
  8026cb:	73 0a                	jae    8026d7 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8026cd:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026d2:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8026d7:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026dc:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8026e1:	29 c2                	sub    %eax,%edx
  8026e3:	89 d0                	mov    %edx,%eax
  8026e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8026e8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026ee:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026f3:	29 c2                	sub    %eax,%edx
  8026f5:	89 d0                	mov    %edx,%eax
  8026f7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802700:	77 13                	ja     802715 <sget+0xc7>
  802702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802705:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802708:	77 0b                	ja     802715 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80270a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270d:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802710:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802713:	73 0a                	jae    80271f <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802715:	b8 00 00 00 00       	mov    $0x0,%eax
  80271a:	e9 90 00 00 00       	jmp    8027af <sget+0x161>

	void *va = NULL;
  80271f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802726:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80272b:	83 f8 05             	cmp    $0x5,%eax
  80272e:	75 11                	jne    802741 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802730:	83 ec 0c             	sub    $0xc,%esp
  802733:	ff 75 f4             	pushl  -0xc(%ebp)
  802736:	e8 a3 f5 ff ff       	call   801cde <alloc_pages_custom_fit>
  80273b:	83 c4 10             	add    $0x10,%esp
  80273e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802741:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802745:	75 27                	jne    80276e <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802747:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80274e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802751:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802754:	89 c2                	mov    %eax,%edx
  802756:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80275b:	39 c2                	cmp    %eax,%edx
  80275d:	73 07                	jae    802766 <sget+0x118>
			return NULL;
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	eb 49                	jmp    8027af <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802766:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80276b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80276e:	83 ec 04             	sub    $0x4,%esp
  802771:	ff 75 f0             	pushl  -0x10(%ebp)
  802774:	ff 75 0c             	pushl  0xc(%ebp)
  802777:	ff 75 08             	pushl  0x8(%ebp)
  80277a:	e8 af 02 00 00       	call   802a2e <sys_get_shared_object>
  80277f:	83 c4 10             	add    $0x10,%esp
  802782:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802785:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802789:	79 07                	jns    802792 <sget+0x144>
		return NULL;
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
  802790:	eb 1d                	jmp    8027af <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802792:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802797:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80279a:	75 10                	jne    8027ac <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80279c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	01 d0                	add    %edx,%eax
  8027a7:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8027ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027b7:	e8 71 f9 ff ff       	call   80212d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8027bc:	83 ec 04             	sub    $0x4,%esp
  8027bf:	68 94 49 80 00       	push   $0x804994
  8027c4:	68 19 02 00 00       	push   $0x219
  8027c9:	68 71 45 80 00       	push   $0x804571
  8027ce:	e8 42 e1 ff ff       	call   800915 <_panic>

008027d3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8027d9:	83 ec 04             	sub    $0x4,%esp
  8027dc:	68 bc 49 80 00       	push   $0x8049bc
  8027e1:	68 2b 02 00 00       	push   $0x22b
  8027e6:	68 71 45 80 00       	push   $0x804571
  8027eb:	e8 25 e1 ff ff       	call   800915 <_panic>

008027f0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	57                   	push   %edi
  8027f4:	56                   	push   %esi
  8027f5:	53                   	push   %ebx
  8027f6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802802:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802805:	8b 7d 18             	mov    0x18(%ebp),%edi
  802808:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80280b:	cd 30                	int    $0x30
  80280d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802813:	83 c4 10             	add    $0x10,%esp
  802816:	5b                   	pop    %ebx
  802817:	5e                   	pop    %esi
  802818:	5f                   	pop    %edi
  802819:	5d                   	pop    %ebp
  80281a:	c3                   	ret    

0080281b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 04             	sub    $0x4,%esp
  802821:	8b 45 10             	mov    0x10(%ebp),%eax
  802824:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802827:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80282a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	6a 00                	push   $0x0
  802833:	51                   	push   %ecx
  802834:	52                   	push   %edx
  802835:	ff 75 0c             	pushl  0xc(%ebp)
  802838:	50                   	push   %eax
  802839:	6a 00                	push   $0x0
  80283b:	e8 b0 ff ff ff       	call   8027f0 <syscall>
  802840:	83 c4 18             	add    $0x18,%esp
}
  802843:	90                   	nop
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <sys_cgetc>:

int
sys_cgetc(void)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 02                	push   $0x2
  802855:	e8 96 ff ff ff       	call   8027f0 <syscall>
  80285a:	83 c4 18             	add    $0x18,%esp
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 03                	push   $0x3
  80286e:	e8 7d ff ff ff       	call   8027f0 <syscall>
  802873:	83 c4 18             	add    $0x18,%esp
}
  802876:	90                   	nop
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 04                	push   $0x4
  802888:	e8 63 ff ff ff       	call   8027f0 <syscall>
  80288d:	83 c4 18             	add    $0x18,%esp
}
  802890:	90                   	nop
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802896:	8b 55 0c             	mov    0xc(%ebp),%edx
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	52                   	push   %edx
  8028a3:	50                   	push   %eax
  8028a4:	6a 08                	push   $0x8
  8028a6:	e8 45 ff ff ff       	call   8027f0 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	56                   	push   %esi
  8028b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8028b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	56                   	push   %esi
  8028c5:	53                   	push   %ebx
  8028c6:	51                   	push   %ecx
  8028c7:	52                   	push   %edx
  8028c8:	50                   	push   %eax
  8028c9:	6a 09                	push   $0x9
  8028cb:	e8 20 ff ff ff       	call   8027f0 <syscall>
  8028d0:	83 c4 18             	add    $0x18,%esp
}
  8028d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028d6:	5b                   	pop    %ebx
  8028d7:	5e                   	pop    %esi
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    

008028da <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	ff 75 08             	pushl  0x8(%ebp)
  8028e8:	6a 0a                	push   $0xa
  8028ea:	e8 01 ff ff ff       	call   8027f0 <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
}
  8028f2:	c9                   	leave  
  8028f3:	c3                   	ret    

008028f4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	ff 75 0c             	pushl  0xc(%ebp)
  802900:	ff 75 08             	pushl  0x8(%ebp)
  802903:	6a 0b                	push   $0xb
  802905:	e8 e6 fe ff ff       	call   8027f0 <syscall>
  80290a:	83 c4 18             	add    $0x18,%esp
}
  80290d:	c9                   	leave  
  80290e:	c3                   	ret    

0080290f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802912:	6a 00                	push   $0x0
  802914:	6a 00                	push   $0x0
  802916:	6a 00                	push   $0x0
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 0c                	push   $0xc
  80291e:	e8 cd fe ff ff       	call   8027f0 <syscall>
  802923:	83 c4 18             	add    $0x18,%esp
}
  802926:	c9                   	leave  
  802927:	c3                   	ret    

00802928 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 0d                	push   $0xd
  802937:	e8 b4 fe ff ff       	call   8027f0 <syscall>
  80293c:	83 c4 18             	add    $0x18,%esp
}
  80293f:	c9                   	leave  
  802940:	c3                   	ret    

00802941 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	6a 0e                	push   $0xe
  802950:	e8 9b fe ff ff       	call   8027f0 <syscall>
  802955:	83 c4 18             	add    $0x18,%esp
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 0f                	push   $0xf
  802969:	e8 82 fe ff ff       	call   8027f0 <syscall>
  80296e:	83 c4 18             	add    $0x18,%esp
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	ff 75 08             	pushl  0x8(%ebp)
  802981:	6a 10                	push   $0x10
  802983:	e8 68 fe ff ff       	call   8027f0 <syscall>
  802988:	83 c4 18             	add    $0x18,%esp
}
  80298b:	c9                   	leave  
  80298c:	c3                   	ret    

0080298d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80298d:	55                   	push   %ebp
  80298e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 00                	push   $0x0
  80299a:	6a 11                	push   $0x11
  80299c:	e8 4f fe ff ff       	call   8027f0 <syscall>
  8029a1:	83 c4 18             	add    $0x18,%esp
}
  8029a4:	90                   	nop
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8029b3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	50                   	push   %eax
  8029c0:	6a 01                	push   $0x1
  8029c2:	e8 29 fe ff ff       	call   8027f0 <syscall>
  8029c7:	83 c4 18             	add    $0x18,%esp
}
  8029ca:	90                   	nop
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 14                	push   $0x14
  8029dc:	e8 0f fe ff ff       	call   8027f0 <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
}
  8029e4:	90                   	nop
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8029f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8029f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	6a 00                	push   $0x0
  8029ff:	51                   	push   %ecx
  802a00:	52                   	push   %edx
  802a01:	ff 75 0c             	pushl  0xc(%ebp)
  802a04:	50                   	push   %eax
  802a05:	6a 15                	push   $0x15
  802a07:	e8 e4 fd ff ff       	call   8027f0 <syscall>
  802a0c:	83 c4 18             	add    $0x18,%esp
}
  802a0f:	c9                   	leave  
  802a10:	c3                   	ret    

00802a11 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	52                   	push   %edx
  802a21:	50                   	push   %eax
  802a22:	6a 16                	push   $0x16
  802a24:	e8 c7 fd ff ff       	call   8027f0 <syscall>
  802a29:	83 c4 18             	add    $0x18,%esp
}
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	51                   	push   %ecx
  802a3f:	52                   	push   %edx
  802a40:	50                   	push   %eax
  802a41:	6a 17                	push   $0x17
  802a43:	e8 a8 fd ff ff       	call   8027f0 <syscall>
  802a48:	83 c4 18             	add    $0x18,%esp
}
  802a4b:	c9                   	leave  
  802a4c:	c3                   	ret    

00802a4d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	52                   	push   %edx
  802a5d:	50                   	push   %eax
  802a5e:	6a 18                	push   $0x18
  802a60:	e8 8b fd ff ff       	call   8027f0 <syscall>
  802a65:	83 c4 18             	add    $0x18,%esp
}
  802a68:	c9                   	leave  
  802a69:	c3                   	ret    

00802a6a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	6a 00                	push   $0x0
  802a72:	ff 75 14             	pushl  0x14(%ebp)
  802a75:	ff 75 10             	pushl  0x10(%ebp)
  802a78:	ff 75 0c             	pushl  0xc(%ebp)
  802a7b:	50                   	push   %eax
  802a7c:	6a 19                	push   $0x19
  802a7e:	e8 6d fd ff ff       	call   8027f0 <syscall>
  802a83:	83 c4 18             	add    $0x18,%esp
}
  802a86:	c9                   	leave  
  802a87:	c3                   	ret    

00802a88 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802a88:	55                   	push   %ebp
  802a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 00                	push   $0x0
  802a94:	6a 00                	push   $0x0
  802a96:	50                   	push   %eax
  802a97:	6a 1a                	push   $0x1a
  802a99:	e8 52 fd ff ff       	call   8027f0 <syscall>
  802a9e:	83 c4 18             	add    $0x18,%esp
}
  802aa1:	90                   	nop
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    

00802aa4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	50                   	push   %eax
  802ab3:	6a 1b                	push   $0x1b
  802ab5:	e8 36 fd ff ff       	call   8027f0 <syscall>
  802aba:	83 c4 18             	add    $0x18,%esp
}
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    

00802abf <sys_getenvid>:

int32 sys_getenvid(void)
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	6a 05                	push   $0x5
  802ace:	e8 1d fd ff ff       	call   8027f0 <syscall>
  802ad3:	83 c4 18             	add    $0x18,%esp
}
  802ad6:	c9                   	leave  
  802ad7:	c3                   	ret    

00802ad8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 06                	push   $0x6
  802ae7:	e8 04 fd ff ff       	call   8027f0 <syscall>
  802aec:	83 c4 18             	add    $0x18,%esp
}
  802aef:	c9                   	leave  
  802af0:	c3                   	ret    

00802af1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802af1:	55                   	push   %ebp
  802af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802af4:	6a 00                	push   $0x0
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	6a 07                	push   $0x7
  802b00:	e8 eb fc ff ff       	call   8027f0 <syscall>
  802b05:	83 c4 18             	add    $0x18,%esp
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <sys_exit_env>:


void sys_exit_env(void)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	6a 1c                	push   $0x1c
  802b19:	e8 d2 fc ff ff       	call   8027f0 <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
}
  802b21:	90                   	nop
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    

00802b24 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
  802b27:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b2d:	8d 50 04             	lea    0x4(%eax),%edx
  802b30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	52                   	push   %edx
  802b3a:	50                   	push   %eax
  802b3b:	6a 1d                	push   $0x1d
  802b3d:	e8 ae fc ff ff       	call   8027f0 <syscall>
  802b42:	83 c4 18             	add    $0x18,%esp
	return result;
  802b45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b4e:	89 01                	mov    %eax,(%ecx)
  802b50:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	c9                   	leave  
  802b57:	c2 04 00             	ret    $0x4

00802b5a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b5a:	55                   	push   %ebp
  802b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	ff 75 10             	pushl  0x10(%ebp)
  802b64:	ff 75 0c             	pushl  0xc(%ebp)
  802b67:	ff 75 08             	pushl  0x8(%ebp)
  802b6a:	6a 13                	push   $0x13
  802b6c:	e8 7f fc ff ff       	call   8027f0 <syscall>
  802b71:	83 c4 18             	add    $0x18,%esp
	return ;
  802b74:	90                   	nop
}
  802b75:	c9                   	leave  
  802b76:	c3                   	ret    

00802b77 <sys_rcr2>:
uint32 sys_rcr2()
{
  802b77:	55                   	push   %ebp
  802b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b7a:	6a 00                	push   $0x0
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 00                	push   $0x0
  802b80:	6a 00                	push   $0x0
  802b82:	6a 00                	push   $0x0
  802b84:	6a 1e                	push   $0x1e
  802b86:	e8 65 fc ff ff       	call   8027f0 <syscall>
  802b8b:	83 c4 18             	add    $0x18,%esp
}
  802b8e:	c9                   	leave  
  802b8f:	c3                   	ret    

00802b90 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
  802b93:	83 ec 04             	sub    $0x4,%esp
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b9c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	50                   	push   %eax
  802ba9:	6a 1f                	push   $0x1f
  802bab:	e8 40 fc ff ff       	call   8027f0 <syscall>
  802bb0:	83 c4 18             	add    $0x18,%esp
	return ;
  802bb3:	90                   	nop
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <rsttst>:
void rsttst()
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802bb9:	6a 00                	push   $0x0
  802bbb:	6a 00                	push   $0x0
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 21                	push   $0x21
  802bc5:	e8 26 fc ff ff       	call   8027f0 <syscall>
  802bca:	83 c4 18             	add    $0x18,%esp
	return ;
  802bcd:	90                   	nop
}
  802bce:	c9                   	leave  
  802bcf:	c3                   	ret    

00802bd0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	83 ec 04             	sub    $0x4,%esp
  802bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  802bd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802bdc:	8b 55 18             	mov    0x18(%ebp),%edx
  802bdf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802be3:	52                   	push   %edx
  802be4:	50                   	push   %eax
  802be5:	ff 75 10             	pushl  0x10(%ebp)
  802be8:	ff 75 0c             	pushl  0xc(%ebp)
  802beb:	ff 75 08             	pushl  0x8(%ebp)
  802bee:	6a 20                	push   $0x20
  802bf0:	e8 fb fb ff ff       	call   8027f0 <syscall>
  802bf5:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf8:	90                   	nop
}
  802bf9:	c9                   	leave  
  802bfa:	c3                   	ret    

00802bfb <chktst>:
void chktst(uint32 n)
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	6a 00                	push   $0x0
  802c04:	6a 00                	push   $0x0
  802c06:	ff 75 08             	pushl  0x8(%ebp)
  802c09:	6a 22                	push   $0x22
  802c0b:	e8 e0 fb ff ff       	call   8027f0 <syscall>
  802c10:	83 c4 18             	add    $0x18,%esp
	return ;
  802c13:	90                   	nop
}
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

00802c16 <inctst>:

void inctst()
{
  802c16:	55                   	push   %ebp
  802c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	6a 23                	push   $0x23
  802c25:	e8 c6 fb ff ff       	call   8027f0 <syscall>
  802c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  802c2d:	90                   	nop
}
  802c2e:	c9                   	leave  
  802c2f:	c3                   	ret    

00802c30 <gettst>:
uint32 gettst()
{
  802c30:	55                   	push   %ebp
  802c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c33:	6a 00                	push   $0x0
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 24                	push   $0x24
  802c3f:	e8 ac fb ff ff       	call   8027f0 <syscall>
  802c44:	83 c4 18             	add    $0x18,%esp
}
  802c47:	c9                   	leave  
  802c48:	c3                   	ret    

00802c49 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802c49:	55                   	push   %ebp
  802c4a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	6a 25                	push   $0x25
  802c58:	e8 93 fb ff ff       	call   8027f0 <syscall>
  802c5d:	83 c4 18             	add    $0x18,%esp
  802c60:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802c65:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802c6a:	c9                   	leave  
  802c6b:	c3                   	ret    

00802c6c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c6c:	55                   	push   %ebp
  802c6d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 00                	push   $0x0
  802c7f:	ff 75 08             	pushl  0x8(%ebp)
  802c82:	6a 26                	push   $0x26
  802c84:	e8 67 fb ff ff       	call   8027f0 <syscall>
  802c89:	83 c4 18             	add    $0x18,%esp
	return ;
  802c8c:	90                   	nop
}
  802c8d:	c9                   	leave  
  802c8e:	c3                   	ret    

00802c8f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c8f:	55                   	push   %ebp
  802c90:	89 e5                	mov    %esp,%ebp
  802c92:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	6a 00                	push   $0x0
  802ca1:	53                   	push   %ebx
  802ca2:	51                   	push   %ecx
  802ca3:	52                   	push   %edx
  802ca4:	50                   	push   %eax
  802ca5:	6a 27                	push   $0x27
  802ca7:	e8 44 fb ff ff       	call   8027f0 <syscall>
  802cac:	83 c4 18             	add    $0x18,%esp
}
  802caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cb2:	c9                   	leave  
  802cb3:	c3                   	ret    

00802cb4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802cb4:	55                   	push   %ebp
  802cb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	52                   	push   %edx
  802cc4:	50                   	push   %eax
  802cc5:	6a 28                	push   $0x28
  802cc7:	e8 24 fb ff ff       	call   8027f0 <syscall>
  802ccc:	83 c4 18             	add    $0x18,%esp
}
  802ccf:	c9                   	leave  
  802cd0:	c3                   	ret    

00802cd1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802cd1:	55                   	push   %ebp
  802cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802cd4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	6a 00                	push   $0x0
  802cdf:	51                   	push   %ecx
  802ce0:	ff 75 10             	pushl  0x10(%ebp)
  802ce3:	52                   	push   %edx
  802ce4:	50                   	push   %eax
  802ce5:	6a 29                	push   $0x29
  802ce7:	e8 04 fb ff ff       	call   8027f0 <syscall>
  802cec:	83 c4 18             	add    $0x18,%esp
}
  802cef:	c9                   	leave  
  802cf0:	c3                   	ret    

00802cf1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802cf1:	55                   	push   %ebp
  802cf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802cf4:	6a 00                	push   $0x0
  802cf6:	6a 00                	push   $0x0
  802cf8:	ff 75 10             	pushl  0x10(%ebp)
  802cfb:	ff 75 0c             	pushl  0xc(%ebp)
  802cfe:	ff 75 08             	pushl  0x8(%ebp)
  802d01:	6a 12                	push   $0x12
  802d03:	e8 e8 fa ff ff       	call   8027f0 <syscall>
  802d08:	83 c4 18             	add    $0x18,%esp
	return ;
  802d0b:	90                   	nop
}
  802d0c:	c9                   	leave  
  802d0d:	c3                   	ret    

00802d0e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d0e:	55                   	push   %ebp
  802d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	6a 00                	push   $0x0
  802d19:	6a 00                	push   $0x0
  802d1b:	6a 00                	push   $0x0
  802d1d:	52                   	push   %edx
  802d1e:	50                   	push   %eax
  802d1f:	6a 2a                	push   $0x2a
  802d21:	e8 ca fa ff ff       	call   8027f0 <syscall>
  802d26:	83 c4 18             	add    $0x18,%esp
	return;
  802d29:	90                   	nop
}
  802d2a:	c9                   	leave  
  802d2b:	c3                   	ret    

00802d2c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802d2c:	55                   	push   %ebp
  802d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	6a 00                	push   $0x0
  802d35:	6a 00                	push   $0x0
  802d37:	6a 00                	push   $0x0
  802d39:	6a 2b                	push   $0x2b
  802d3b:	e8 b0 fa ff ff       	call   8027f0 <syscall>
  802d40:	83 c4 18             	add    $0x18,%esp
}
  802d43:	c9                   	leave  
  802d44:	c3                   	ret    

00802d45 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802d45:	55                   	push   %ebp
  802d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802d48:	6a 00                	push   $0x0
  802d4a:	6a 00                	push   $0x0
  802d4c:	6a 00                	push   $0x0
  802d4e:	ff 75 0c             	pushl  0xc(%ebp)
  802d51:	ff 75 08             	pushl  0x8(%ebp)
  802d54:	6a 2d                	push   $0x2d
  802d56:	e8 95 fa ff ff       	call   8027f0 <syscall>
  802d5b:	83 c4 18             	add    $0x18,%esp
	return;
  802d5e:	90                   	nop
}
  802d5f:	c9                   	leave  
  802d60:	c3                   	ret    

00802d61 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802d64:	6a 00                	push   $0x0
  802d66:	6a 00                	push   $0x0
  802d68:	6a 00                	push   $0x0
  802d6a:	ff 75 0c             	pushl  0xc(%ebp)
  802d6d:	ff 75 08             	pushl  0x8(%ebp)
  802d70:	6a 2c                	push   $0x2c
  802d72:	e8 79 fa ff ff       	call   8027f0 <syscall>
  802d77:	83 c4 18             	add    $0x18,%esp
	return ;
  802d7a:	90                   	nop
}
  802d7b:	c9                   	leave  
  802d7c:	c3                   	ret    

00802d7d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802d7d:	55                   	push   %ebp
  802d7e:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	52                   	push   %edx
  802d8d:	50                   	push   %eax
  802d8e:	6a 2e                	push   $0x2e
  802d90:	e8 5b fa ff ff       	call   8027f0 <syscall>
  802d95:	83 c4 18             	add    $0x18,%esp
	return ;
  802d98:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    

00802d9b <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802d9b:	55                   	push   %ebp
  802d9c:	89 e5                	mov    %esp,%ebp
  802d9e:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802da1:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802da8:	72 09                	jb     802db3 <to_page_va+0x18>
  802daa:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802db1:	72 14                	jb     802dc7 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802db3:	83 ec 04             	sub    $0x4,%esp
  802db6:	68 e0 49 80 00       	push   $0x8049e0
  802dbb:	6a 15                	push   $0x15
  802dbd:	68 0b 4a 80 00       	push   $0x804a0b
  802dc2:	e8 4e db ff ff       	call   800915 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	ba 60 50 80 00       	mov    $0x805060,%edx
  802dcf:	29 d0                	sub    %edx,%eax
  802dd1:	c1 f8 02             	sar    $0x2,%eax
  802dd4:	89 c2                	mov    %eax,%edx
  802dd6:	89 d0                	mov    %edx,%eax
  802dd8:	c1 e0 02             	shl    $0x2,%eax
  802ddb:	01 d0                	add    %edx,%eax
  802ddd:	c1 e0 02             	shl    $0x2,%eax
  802de0:	01 d0                	add    %edx,%eax
  802de2:	c1 e0 02             	shl    $0x2,%eax
  802de5:	01 d0                	add    %edx,%eax
  802de7:	89 c1                	mov    %eax,%ecx
  802de9:	c1 e1 08             	shl    $0x8,%ecx
  802dec:	01 c8                	add    %ecx,%eax
  802dee:	89 c1                	mov    %eax,%ecx
  802df0:	c1 e1 10             	shl    $0x10,%ecx
  802df3:	01 c8                	add    %ecx,%eax
  802df5:	01 c0                	add    %eax,%eax
  802df7:	01 d0                	add    %edx,%eax
  802df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	c1 e0 0c             	shl    $0xc,%eax
  802e02:	89 c2                	mov    %eax,%edx
  802e04:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e09:	01 d0                	add    %edx,%eax
}
  802e0b:	c9                   	leave  
  802e0c:	c3                   	ret    

00802e0d <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
  802e10:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802e13:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e18:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1b:	29 c2                	sub    %eax,%edx
  802e1d:	89 d0                	mov    %edx,%eax
  802e1f:	c1 e8 0c             	shr    $0xc,%eax
  802e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e29:	78 09                	js     802e34 <to_page_info+0x27>
  802e2b:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802e32:	7e 14                	jle    802e48 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802e34:	83 ec 04             	sub    $0x4,%esp
  802e37:	68 24 4a 80 00       	push   $0x804a24
  802e3c:	6a 22                	push   $0x22
  802e3e:	68 0b 4a 80 00       	push   $0x804a0b
  802e43:	e8 cd da ff ff       	call   800915 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4b:	89 d0                	mov    %edx,%eax
  802e4d:	01 c0                	add    %eax,%eax
  802e4f:	01 d0                	add    %edx,%eax
  802e51:	c1 e0 02             	shl    $0x2,%eax
  802e54:	05 60 50 80 00       	add    $0x805060,%eax
}
  802e59:	c9                   	leave  
  802e5a:	c3                   	ret    

00802e5b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
  802e5e:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	05 00 00 00 02       	add    $0x2000000,%eax
  802e69:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e6c:	73 16                	jae    802e84 <initialize_dynamic_allocator+0x29>
  802e6e:	68 48 4a 80 00       	push   $0x804a48
  802e73:	68 6e 4a 80 00       	push   $0x804a6e
  802e78:	6a 34                	push   $0x34
  802e7a:	68 0b 4a 80 00       	push   $0x804a0b
  802e7f:	e8 91 da ff ff       	call   800915 <_panic>
		is_initialized = 1;
  802e84:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  802e8b:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e99:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802e9e:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802ea5:	00 00 00 
  802ea8:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802eaf:	00 00 00 
  802eb2:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802eb9:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802ebc:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802ec3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802eca:	eb 36                	jmp    802f02 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	c1 e0 04             	shl    $0x4,%eax
  802ed2:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ed7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	c1 e0 04             	shl    $0x4,%eax
  802ee3:	05 84 d0 81 00       	add    $0x81d084,%eax
  802ee8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	c1 e0 04             	shl    $0x4,%eax
  802ef4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ef9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802eff:	ff 45 f4             	incl   -0xc(%ebp)
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f08:	72 c2                	jb     802ecc <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802f0a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802f10:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f15:	29 c2                	sub    %eax,%edx
  802f17:	89 d0                	mov    %edx,%eax
  802f19:	c1 e8 0c             	shr    $0xc,%eax
  802f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802f1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f26:	e9 c8 00 00 00       	jmp    802ff3 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802f2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2e:	89 d0                	mov    %edx,%eax
  802f30:	01 c0                	add    %eax,%eax
  802f32:	01 d0                	add    %edx,%eax
  802f34:	c1 e0 02             	shl    $0x2,%eax
  802f37:	05 68 50 80 00       	add    $0x805068,%eax
  802f3c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802f41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f44:	89 d0                	mov    %edx,%eax
  802f46:	01 c0                	add    %eax,%eax
  802f48:	01 d0                	add    %edx,%eax
  802f4a:	c1 e0 02             	shl    $0x2,%eax
  802f4d:	05 6a 50 80 00       	add    $0x80506a,%eax
  802f52:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802f57:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802f5d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802f60:	89 c8                	mov    %ecx,%eax
  802f62:	01 c0                	add    %eax,%eax
  802f64:	01 c8                	add    %ecx,%eax
  802f66:	c1 e0 02             	shl    $0x2,%eax
  802f69:	05 64 50 80 00       	add    $0x805064,%eax
  802f6e:	89 10                	mov    %edx,(%eax)
  802f70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f73:	89 d0                	mov    %edx,%eax
  802f75:	01 c0                	add    %eax,%eax
  802f77:	01 d0                	add    %edx,%eax
  802f79:	c1 e0 02             	shl    $0x2,%eax
  802f7c:	05 64 50 80 00       	add    $0x805064,%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 1b                	je     802fa2 <initialize_dynamic_allocator+0x147>
  802f87:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802f8d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802f90:	89 c8                	mov    %ecx,%eax
  802f92:	01 c0                	add    %eax,%eax
  802f94:	01 c8                	add    %ecx,%eax
  802f96:	c1 e0 02             	shl    $0x2,%eax
  802f99:	05 60 50 80 00       	add    $0x805060,%eax
  802f9e:	89 02                	mov    %eax,(%edx)
  802fa0:	eb 16                	jmp    802fb8 <initialize_dynamic_allocator+0x15d>
  802fa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa5:	89 d0                	mov    %edx,%eax
  802fa7:	01 c0                	add    %eax,%eax
  802fa9:	01 d0                	add    %edx,%eax
  802fab:	c1 e0 02             	shl    $0x2,%eax
  802fae:	05 60 50 80 00       	add    $0x805060,%eax
  802fb3:	a3 48 50 80 00       	mov    %eax,0x805048
  802fb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbb:	89 d0                	mov    %edx,%eax
  802fbd:	01 c0                	add    %eax,%eax
  802fbf:	01 d0                	add    %edx,%eax
  802fc1:	c1 e0 02             	shl    $0x2,%eax
  802fc4:	05 60 50 80 00       	add    $0x805060,%eax
  802fc9:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802fce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd1:	89 d0                	mov    %edx,%eax
  802fd3:	01 c0                	add    %eax,%eax
  802fd5:	01 d0                	add    %edx,%eax
  802fd7:	c1 e0 02             	shl    $0x2,%eax
  802fda:	05 60 50 80 00       	add    $0x805060,%eax
  802fdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe5:	a1 54 50 80 00       	mov    0x805054,%eax
  802fea:	40                   	inc    %eax
  802feb:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802ff0:	ff 45 f0             	incl   -0x10(%ebp)
  802ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ff9:	0f 82 2c ff ff ff    	jb     802f2b <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802fff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803002:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803005:	eb 2f                	jmp    803036 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803007:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80300a:	89 d0                	mov    %edx,%eax
  80300c:	01 c0                	add    %eax,%eax
  80300e:	01 d0                	add    %edx,%eax
  803010:	c1 e0 02             	shl    $0x2,%eax
  803013:	05 68 50 80 00       	add    $0x805068,%eax
  803018:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  80301d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803020:	89 d0                	mov    %edx,%eax
  803022:	01 c0                	add    %eax,%eax
  803024:	01 d0                	add    %edx,%eax
  803026:	c1 e0 02             	shl    $0x2,%eax
  803029:	05 6a 50 80 00       	add    $0x80506a,%eax
  80302e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803033:	ff 45 ec             	incl   -0x14(%ebp)
  803036:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  80303d:	76 c8                	jbe    803007 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80303f:	90                   	nop
  803040:	c9                   	leave  
  803041:	c3                   	ret    

00803042 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803042:	55                   	push   %ebp
  803043:	89 e5                	mov    %esp,%ebp
  803045:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803048:	8b 55 08             	mov    0x8(%ebp),%edx
  80304b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803050:	29 c2                	sub    %eax,%edx
  803052:	89 d0                	mov    %edx,%eax
  803054:	c1 e8 0c             	shr    $0xc,%eax
  803057:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  80305a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80305d:	89 d0                	mov    %edx,%eax
  80305f:	01 c0                	add    %eax,%eax
  803061:	01 d0                	add    %edx,%eax
  803063:	c1 e0 02             	shl    $0x2,%eax
  803066:	05 68 50 80 00       	add    $0x805068,%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803070:	c9                   	leave  
  803071:	c3                   	ret    

00803072 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803072:	55                   	push   %ebp
  803073:	89 e5                	mov    %esp,%ebp
  803075:	83 ec 14             	sub    $0x14,%esp
  803078:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  80307b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80307f:	77 07                	ja     803088 <nearest_pow2_ceil.1513+0x16>
  803081:	b8 01 00 00 00       	mov    $0x1,%eax
  803086:	eb 20                	jmp    8030a8 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803088:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  80308f:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803092:	eb 08                	jmp    80309c <nearest_pow2_ceil.1513+0x2a>
  803094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803097:	01 c0                	add    %eax,%eax
  803099:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80309c:	d1 6d 08             	shrl   0x8(%ebp)
  80309f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a3:	75 ef                	jne    803094 <nearest_pow2_ceil.1513+0x22>
        return power;
  8030a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
  8030ad:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8030b0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8030b7:	76 16                	jbe    8030cf <alloc_block+0x25>
  8030b9:	68 84 4a 80 00       	push   $0x804a84
  8030be:	68 6e 4a 80 00       	push   $0x804a6e
  8030c3:	6a 72                	push   $0x72
  8030c5:	68 0b 4a 80 00       	push   $0x804a0b
  8030ca:	e8 46 d8 ff ff       	call   800915 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8030cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d3:	75 0a                	jne    8030df <alloc_block+0x35>
  8030d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030da:	e9 bd 04 00 00       	jmp    80359c <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8030df:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8030ec:	73 06                	jae    8030f4 <alloc_block+0x4a>
        size = min_block_size;
  8030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f1:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  8030f4:	83 ec 0c             	sub    $0xc,%esp
  8030f7:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8030fa:	ff 75 08             	pushl  0x8(%ebp)
  8030fd:	89 c1                	mov    %eax,%ecx
  8030ff:	e8 6e ff ff ff       	call   803072 <nearest_pow2_ceil.1513>
  803104:	83 c4 10             	add    $0x10,%esp
  803107:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  80310a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80310d:	83 ec 0c             	sub    $0xc,%esp
  803110:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803113:	52                   	push   %edx
  803114:	89 c1                	mov    %eax,%ecx
  803116:	e8 83 04 00 00       	call   80359e <log2_ceil.1520>
  80311b:	83 c4 10             	add    $0x10,%esp
  80311e:	83 e8 03             	sub    $0x3,%eax
  803121:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803127:	c1 e0 04             	shl    $0x4,%eax
  80312a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	0f 84 d8 00 00 00    	je     803211 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313c:	c1 e0 04             	shl    $0x4,%eax
  80313f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803149:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80314d:	75 17                	jne    803166 <alloc_block+0xbc>
  80314f:	83 ec 04             	sub    $0x4,%esp
  803152:	68 a5 4a 80 00       	push   $0x804aa5
  803157:	68 98 00 00 00       	push   $0x98
  80315c:	68 0b 4a 80 00       	push   $0x804a0b
  803161:	e8 af d7 ff ff       	call   800915 <_panic>
  803166:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803169:	8b 00                	mov    (%eax),%eax
  80316b:	85 c0                	test   %eax,%eax
  80316d:	74 10                	je     80317f <alloc_block+0xd5>
  80316f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803177:	8b 52 04             	mov    0x4(%edx),%edx
  80317a:	89 50 04             	mov    %edx,0x4(%eax)
  80317d:	eb 14                	jmp    803193 <alloc_block+0xe9>
  80317f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803182:	8b 40 04             	mov    0x4(%eax),%eax
  803185:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803188:	c1 e2 04             	shl    $0x4,%edx
  80318b:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803191:	89 02                	mov    %eax,(%edx)
  803193:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	85 c0                	test   %eax,%eax
  80319b:	74 0f                	je     8031ac <alloc_block+0x102>
  80319d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031a6:	8b 12                	mov    (%edx),%edx
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	eb 13                	jmp    8031bf <alloc_block+0x115>
  8031ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b4:	c1 e2 04             	shl    $0x4,%edx
  8031b7:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031bd:	89 02                	mov    %eax,(%edx)
  8031bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d5:	c1 e0 04             	shl    $0x4,%eax
  8031d8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8031e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e5:	c1 e0 04             	shl    $0x4,%eax
  8031e8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031ed:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8031ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f2:	83 ec 0c             	sub    $0xc,%esp
  8031f5:	50                   	push   %eax
  8031f6:	e8 12 fc ff ff       	call   802e0d <to_page_info>
  8031fb:	83 c4 10             	add    $0x10,%esp
  8031fe:	89 c2                	mov    %eax,%edx
  803200:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803204:	48                   	dec    %eax
  803205:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320c:	e9 8b 03 00 00       	jmp    80359c <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803211:	a1 48 50 80 00       	mov    0x805048,%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	0f 84 64 02 00 00    	je     803482 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  80321e:	a1 48 50 80 00       	mov    0x805048,%eax
  803223:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803226:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80322a:	75 17                	jne    803243 <alloc_block+0x199>
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	68 a5 4a 80 00       	push   $0x804aa5
  803234:	68 a0 00 00 00       	push   $0xa0
  803239:	68 0b 4a 80 00       	push   $0x804a0b
  80323e:	e8 d2 d6 ff ff       	call   800915 <_panic>
  803243:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 10                	je     80325c <alloc_block+0x1b2>
  80324c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803254:	8b 52 04             	mov    0x4(%edx),%edx
  803257:	89 50 04             	mov    %edx,0x4(%eax)
  80325a:	eb 0b                	jmp    803267 <alloc_block+0x1bd>
  80325c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325f:	8b 40 04             	mov    0x4(%eax),%eax
  803262:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803267:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326a:	8b 40 04             	mov    0x4(%eax),%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	74 0f                	je     803280 <alloc_block+0x1d6>
  803271:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803274:	8b 40 04             	mov    0x4(%eax),%eax
  803277:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80327a:	8b 12                	mov    (%edx),%edx
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	eb 0a                	jmp    80328a <alloc_block+0x1e0>
  803280:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	a3 48 50 80 00       	mov    %eax,0x805048
  80328a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803293:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803296:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329d:	a1 54 50 80 00       	mov    0x805054,%eax
  8032a2:	48                   	dec    %eax
  8032a3:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  8032a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032ae:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8032b2:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032b7:	99                   	cltd   
  8032b8:	f7 7d e8             	idivl  -0x18(%ebp)
  8032bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032be:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8032c2:	83 ec 0c             	sub    $0xc,%esp
  8032c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8032c8:	e8 ce fa ff ff       	call   802d9b <to_page_va>
  8032cd:	83 c4 10             	add    $0x10,%esp
  8032d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8032d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032d6:	83 ec 0c             	sub    $0xc,%esp
  8032d9:	50                   	push   %eax
  8032da:	e8 c0 ee ff ff       	call   80219f <get_page>
  8032df:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8032e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032e9:	e9 aa 00 00 00       	jmp    803398 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  8032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f1:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  8032f5:	89 c2                	mov    %eax,%edx
  8032f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8032ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803303:	75 17                	jne    80331c <alloc_block+0x272>
  803305:	83 ec 04             	sub    $0x4,%esp
  803308:	68 c4 4a 80 00       	push   $0x804ac4
  80330d:	68 aa 00 00 00       	push   $0xaa
  803312:	68 0b 4a 80 00       	push   $0x804a0b
  803317:	e8 f9 d5 ff ff       	call   800915 <_panic>
  80331c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331f:	c1 e0 04             	shl    $0x4,%eax
  803322:	05 84 d0 81 00       	add    $0x81d084,%eax
  803327:	8b 10                	mov    (%eax),%edx
  803329:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332c:	89 50 04             	mov    %edx,0x4(%eax)
  80332f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	85 c0                	test   %eax,%eax
  803337:	74 14                	je     80334d <alloc_block+0x2a3>
  803339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333c:	c1 e0 04             	shl    $0x4,%eax
  80333f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	eb 11                	jmp    80335e <alloc_block+0x2b4>
  80334d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803350:	c1 e0 04             	shl    $0x4,%eax
  803353:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335c:	89 02                	mov    %eax,(%edx)
  80335e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803361:	c1 e0 04             	shl    $0x4,%eax
  803364:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80336a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336d:	89 02                	mov    %eax,(%edx)
  80336f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803372:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337b:	c1 e0 04             	shl    $0x4,%eax
  80337e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	8d 50 01             	lea    0x1(%eax),%edx
  803388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338b:	c1 e0 04             	shl    $0x4,%eax
  80338e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803393:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803395:	ff 45 f4             	incl   -0xc(%ebp)
  803398:	b8 00 10 00 00       	mov    $0x1000,%eax
  80339d:	99                   	cltd   
  80339e:	f7 7d e8             	idivl  -0x18(%ebp)
  8033a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033a4:	0f 8f 44 ff ff ff    	jg     8032ee <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8033aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ad:	c1 e0 04             	shl    $0x4,%eax
  8033b0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8033ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033be:	75 17                	jne    8033d7 <alloc_block+0x32d>
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	68 a5 4a 80 00       	push   $0x804aa5
  8033c8:	68 ae 00 00 00       	push   $0xae
  8033cd:	68 0b 4a 80 00       	push   $0x804a0b
  8033d2:	e8 3e d5 ff ff       	call   800915 <_panic>
  8033d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033da:	8b 00                	mov    (%eax),%eax
  8033dc:	85 c0                	test   %eax,%eax
  8033de:	74 10                	je     8033f0 <alloc_block+0x346>
  8033e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8033e8:	8b 52 04             	mov    0x4(%edx),%edx
  8033eb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ee:	eb 14                	jmp    803404 <alloc_block+0x35a>
  8033f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033f3:	8b 40 04             	mov    0x4(%eax),%eax
  8033f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f9:	c1 e2 04             	shl    $0x4,%edx
  8033fc:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803402:	89 02                	mov    %eax,(%edx)
  803404:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803407:	8b 40 04             	mov    0x4(%eax),%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	74 0f                	je     80341d <alloc_block+0x373>
  80340e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803411:	8b 40 04             	mov    0x4(%eax),%eax
  803414:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803417:	8b 12                	mov    (%edx),%edx
  803419:	89 10                	mov    %edx,(%eax)
  80341b:	eb 13                	jmp    803430 <alloc_block+0x386>
  80341d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803420:	8b 00                	mov    (%eax),%eax
  803422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803425:	c1 e2 04             	shl    $0x4,%edx
  803428:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80342e:	89 02                	mov    %eax,(%edx)
  803430:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803439:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80343c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803446:	c1 e0 04             	shl    $0x4,%eax
  803449:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80344e:	8b 00                	mov    (%eax),%eax
  803450:	8d 50 ff             	lea    -0x1(%eax),%edx
  803453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803456:	c1 e0 04             	shl    $0x4,%eax
  803459:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80345e:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803460:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803463:	83 ec 0c             	sub    $0xc,%esp
  803466:	50                   	push   %eax
  803467:	e8 a1 f9 ff ff       	call   802e0d <to_page_info>
  80346c:	83 c4 10             	add    $0x10,%esp
  80346f:	89 c2                	mov    %eax,%edx
  803471:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803475:	48                   	dec    %eax
  803476:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  80347a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80347d:	e9 1a 01 00 00       	jmp    80359c <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803485:	40                   	inc    %eax
  803486:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803489:	e9 ed 00 00 00       	jmp    80357b <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80348e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803491:	c1 e0 04             	shl    $0x4,%eax
  803494:	05 80 d0 81 00       	add    $0x81d080,%eax
  803499:	8b 00                	mov    (%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	0f 84 d5 00 00 00    	je     803578 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8034a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a6:	c1 e0 04             	shl    $0x4,%eax
  8034a9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034ae:	8b 00                	mov    (%eax),%eax
  8034b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8034b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8034b7:	75 17                	jne    8034d0 <alloc_block+0x426>
  8034b9:	83 ec 04             	sub    $0x4,%esp
  8034bc:	68 a5 4a 80 00       	push   $0x804aa5
  8034c1:	68 b8 00 00 00       	push   $0xb8
  8034c6:	68 0b 4a 80 00       	push   $0x804a0b
  8034cb:	e8 45 d4 ff ff       	call   800915 <_panic>
  8034d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	85 c0                	test   %eax,%eax
  8034d7:	74 10                	je     8034e9 <alloc_block+0x43f>
  8034d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8034e1:	8b 52 04             	mov    0x4(%edx),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	eb 14                	jmp    8034fd <alloc_block+0x453>
  8034e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034ec:	8b 40 04             	mov    0x4(%eax),%eax
  8034ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f2:	c1 e2 04             	shl    $0x4,%edx
  8034f5:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8034fb:	89 02                	mov    %eax,(%edx)
  8034fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803500:	8b 40 04             	mov    0x4(%eax),%eax
  803503:	85 c0                	test   %eax,%eax
  803505:	74 0f                	je     803516 <alloc_block+0x46c>
  803507:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80350a:	8b 40 04             	mov    0x4(%eax),%eax
  80350d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803510:	8b 12                	mov    (%edx),%edx
  803512:	89 10                	mov    %edx,(%eax)
  803514:	eb 13                	jmp    803529 <alloc_block+0x47f>
  803516:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803519:	8b 00                	mov    (%eax),%eax
  80351b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351e:	c1 e2 04             	shl    $0x4,%edx
  803521:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803527:	89 02                	mov    %eax,(%edx)
  803529:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80352c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803532:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353f:	c1 e0 04             	shl    $0x4,%eax
  803542:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	8d 50 ff             	lea    -0x1(%eax),%edx
  80354c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354f:	c1 e0 04             	shl    $0x4,%eax
  803552:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803557:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803559:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80355c:	83 ec 0c             	sub    $0xc,%esp
  80355f:	50                   	push   %eax
  803560:	e8 a8 f8 ff ff       	call   802e0d <to_page_info>
  803565:	83 c4 10             	add    $0x10,%esp
  803568:	89 c2                	mov    %eax,%edx
  80356a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80356e:	48                   	dec    %eax
  80356f:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803573:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803576:	eb 24                	jmp    80359c <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803578:	ff 45 f0             	incl   -0x10(%ebp)
  80357b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80357f:	0f 8e 09 ff ff ff    	jle    80348e <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803585:	83 ec 04             	sub    $0x4,%esp
  803588:	68 e7 4a 80 00       	push   $0x804ae7
  80358d:	68 bf 00 00 00       	push   $0xbf
  803592:	68 0b 4a 80 00       	push   $0x804a0b
  803597:	e8 79 d3 ff ff       	call   800915 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80359c:	c9                   	leave  
  80359d:	c3                   	ret    

0080359e <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80359e:	55                   	push   %ebp
  80359f:	89 e5                	mov    %esp,%ebp
  8035a1:	83 ec 14             	sub    $0x14,%esp
  8035a4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8035a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ab:	75 07                	jne    8035b4 <log2_ceil.1520+0x16>
  8035ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b2:	eb 1b                	jmp    8035cf <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8035b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8035bb:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8035be:	eb 06                	jmp    8035c6 <log2_ceil.1520+0x28>
            x >>= 1;
  8035c0:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8035c3:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8035c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ca:	75 f4                	jne    8035c0 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8035cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8035cf:	c9                   	leave  
  8035d0:	c3                   	ret    

008035d1 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8035d1:	55                   	push   %ebp
  8035d2:	89 e5                	mov    %esp,%ebp
  8035d4:	83 ec 14             	sub    $0x14,%esp
  8035d7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8035da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035de:	75 07                	jne    8035e7 <log2_ceil.1547+0x16>
  8035e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e5:	eb 1b                	jmp    803602 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8035e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8035ee:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8035f1:	eb 06                	jmp    8035f9 <log2_ceil.1547+0x28>
			x >>= 1;
  8035f3:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8035f6:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8035f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035fd:	75 f4                	jne    8035f3 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8035ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803602:	c9                   	leave  
  803603:	c3                   	ret    

00803604 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803604:	55                   	push   %ebp
  803605:	89 e5                	mov    %esp,%ebp
  803607:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80360a:	8b 55 08             	mov    0x8(%ebp),%edx
  80360d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803612:	39 c2                	cmp    %eax,%edx
  803614:	72 0c                	jb     803622 <free_block+0x1e>
  803616:	8b 55 08             	mov    0x8(%ebp),%edx
  803619:	a1 40 50 80 00       	mov    0x805040,%eax
  80361e:	39 c2                	cmp    %eax,%edx
  803620:	72 19                	jb     80363b <free_block+0x37>
  803622:	68 ec 4a 80 00       	push   $0x804aec
  803627:	68 6e 4a 80 00       	push   $0x804a6e
  80362c:	68 d0 00 00 00       	push   $0xd0
  803631:	68 0b 4a 80 00       	push   $0x804a0b
  803636:	e8 da d2 ff ff       	call   800915 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80363b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363f:	0f 84 42 03 00 00    	je     803987 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803645:	8b 55 08             	mov    0x8(%ebp),%edx
  803648:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80364d:	39 c2                	cmp    %eax,%edx
  80364f:	72 0c                	jb     80365d <free_block+0x59>
  803651:	8b 55 08             	mov    0x8(%ebp),%edx
  803654:	a1 40 50 80 00       	mov    0x805040,%eax
  803659:	39 c2                	cmp    %eax,%edx
  80365b:	72 17                	jb     803674 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	68 24 4b 80 00       	push   $0x804b24
  803665:	68 e6 00 00 00       	push   $0xe6
  80366a:	68 0b 4a 80 00       	push   $0x804a0b
  80366f:	e8 a1 d2 ff ff       	call   800915 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803674:	8b 55 08             	mov    0x8(%ebp),%edx
  803677:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80367c:	29 c2                	sub    %eax,%edx
  80367e:	89 d0                	mov    %edx,%eax
  803680:	83 e0 07             	and    $0x7,%eax
  803683:	85 c0                	test   %eax,%eax
  803685:	74 17                	je     80369e <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803687:	83 ec 04             	sub    $0x4,%esp
  80368a:	68 58 4b 80 00       	push   $0x804b58
  80368f:	68 ea 00 00 00       	push   $0xea
  803694:	68 0b 4a 80 00       	push   $0x804a0b
  803699:	e8 77 d2 ff ff       	call   800915 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80369e:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a1:	83 ec 0c             	sub    $0xc,%esp
  8036a4:	50                   	push   %eax
  8036a5:	e8 63 f7 ff ff       	call   802e0d <to_page_info>
  8036aa:	83 c4 10             	add    $0x10,%esp
  8036ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8036b0:	83 ec 0c             	sub    $0xc,%esp
  8036b3:	ff 75 08             	pushl  0x8(%ebp)
  8036b6:	e8 87 f9 ff ff       	call   803042 <get_block_size>
  8036bb:	83 c4 10             	add    $0x10,%esp
  8036be:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8036c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036c5:	75 17                	jne    8036de <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8036c7:	83 ec 04             	sub    $0x4,%esp
  8036ca:	68 84 4b 80 00       	push   $0x804b84
  8036cf:	68 f1 00 00 00       	push   $0xf1
  8036d4:	68 0b 4a 80 00       	push   $0x804a0b
  8036d9:	e8 37 d2 ff ff       	call   800915 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8036de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036e1:	83 ec 0c             	sub    $0xc,%esp
  8036e4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8036e7:	52                   	push   %edx
  8036e8:	89 c1                	mov    %eax,%ecx
  8036ea:	e8 e2 fe ff ff       	call   8035d1 <log2_ceil.1547>
  8036ef:	83 c4 10             	add    $0x10,%esp
  8036f2:	83 e8 03             	sub    $0x3,%eax
  8036f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8036fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803702:	75 17                	jne    80371b <free_block+0x117>
  803704:	83 ec 04             	sub    $0x4,%esp
  803707:	68 d0 4b 80 00       	push   $0x804bd0
  80370c:	68 f6 00 00 00       	push   $0xf6
  803711:	68 0b 4a 80 00       	push   $0x804a0b
  803716:	e8 fa d1 ff ff       	call   800915 <_panic>
  80371b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371e:	c1 e0 04             	shl    $0x4,%eax
  803721:	05 80 d0 81 00       	add    $0x81d080,%eax
  803726:	8b 10                	mov    (%eax),%edx
  803728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80372b:	89 10                	mov    %edx,(%eax)
  80372d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 15                	je     80374b <free_block+0x147>
  803736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803739:	c1 e0 04             	shl    $0x4,%eax
  80373c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803741:	8b 00                	mov    (%eax),%eax
  803743:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803746:	89 50 04             	mov    %edx,0x4(%eax)
  803749:	eb 11                	jmp    80375c <free_block+0x158>
  80374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374e:	c1 e0 04             	shl    $0x4,%eax
  803751:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803757:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80375a:	89 02                	mov    %eax,(%edx)
  80375c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375f:	c1 e0 04             	shl    $0x4,%eax
  803762:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803768:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376b:	89 02                	mov    %eax,(%edx)
  80376d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803770:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377a:	c1 e0 04             	shl    $0x4,%eax
  80377d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803782:	8b 00                	mov    (%eax),%eax
  803784:	8d 50 01             	lea    0x1(%eax),%edx
  803787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378a:	c1 e0 04             	shl    $0x4,%eax
  80378d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803792:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803797:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80379b:	40                   	inc    %eax
  80379c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80379f:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8037a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037a6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8037ab:	29 c2                	sub    %eax,%edx
  8037ad:	89 d0                	mov    %edx,%eax
  8037af:	c1 e8 0c             	shr    $0xc,%eax
  8037b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8037b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037bc:	0f b7 c8             	movzwl %ax,%ecx
  8037bf:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037c4:	99                   	cltd   
  8037c5:	f7 7d e8             	idivl  -0x18(%ebp)
  8037c8:	39 c1                	cmp    %eax,%ecx
  8037ca:	0f 85 b8 01 00 00    	jne    803988 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8037d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8037d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037da:	c1 e0 04             	shl    $0x4,%eax
  8037dd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8037e7:	e9 d5 00 00 00       	jmp    8038c1 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8037ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ef:	8b 00                	mov    (%eax),%eax
  8037f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8037f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8037fc:	29 c2                	sub    %eax,%edx
  8037fe:	89 d0                	mov    %edx,%eax
  803800:	c1 e8 0c             	shr    $0xc,%eax
  803803:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803806:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803809:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80380c:	0f 85 a9 00 00 00    	jne    8038bb <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803812:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803816:	75 17                	jne    80382f <free_block+0x22b>
  803818:	83 ec 04             	sub    $0x4,%esp
  80381b:	68 a5 4a 80 00       	push   $0x804aa5
  803820:	68 04 01 00 00       	push   $0x104
  803825:	68 0b 4a 80 00       	push   $0x804a0b
  80382a:	e8 e6 d0 ff ff       	call   800915 <_panic>
  80382f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	85 c0                	test   %eax,%eax
  803836:	74 10                	je     803848 <free_block+0x244>
  803838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383b:	8b 00                	mov    (%eax),%eax
  80383d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803840:	8b 52 04             	mov    0x4(%edx),%edx
  803843:	89 50 04             	mov    %edx,0x4(%eax)
  803846:	eb 14                	jmp    80385c <free_block+0x258>
  803848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384b:	8b 40 04             	mov    0x4(%eax),%eax
  80384e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803851:	c1 e2 04             	shl    $0x4,%edx
  803854:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80385a:	89 02                	mov    %eax,(%edx)
  80385c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385f:	8b 40 04             	mov    0x4(%eax),%eax
  803862:	85 c0                	test   %eax,%eax
  803864:	74 0f                	je     803875 <free_block+0x271>
  803866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803869:	8b 40 04             	mov    0x4(%eax),%eax
  80386c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80386f:	8b 12                	mov    (%edx),%edx
  803871:	89 10                	mov    %edx,(%eax)
  803873:	eb 13                	jmp    803888 <free_block+0x284>
  803875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803878:	8b 00                	mov    (%eax),%eax
  80387a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387d:	c1 e2 04             	shl    $0x4,%edx
  803880:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803886:	89 02                	mov    %eax,(%edx)
  803888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803894:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	c1 e0 04             	shl    $0x4,%eax
  8038a1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ae:	c1 e0 04             	shl    $0x4,%eax
  8038b1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038b6:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8038b8:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8038bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8038c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038c5:	0f 85 21 ff ff ff    	jne    8037ec <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8038cb:	b8 00 10 00 00       	mov    $0x1000,%eax
  8038d0:	99                   	cltd   
  8038d1:	f7 7d e8             	idivl  -0x18(%ebp)
  8038d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8038d7:	74 17                	je     8038f0 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8038d9:	83 ec 04             	sub    $0x4,%esp
  8038dc:	68 f4 4b 80 00       	push   $0x804bf4
  8038e1:	68 0c 01 00 00       	push   $0x10c
  8038e6:	68 0b 4a 80 00       	push   $0x804a0b
  8038eb:	e8 25 d0 ff ff       	call   800915 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8038f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f3:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8038f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038fc:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803902:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803906:	75 17                	jne    80391f <free_block+0x31b>
  803908:	83 ec 04             	sub    $0x4,%esp
  80390b:	68 c4 4a 80 00       	push   $0x804ac4
  803910:	68 11 01 00 00       	push   $0x111
  803915:	68 0b 4a 80 00       	push   $0x804a0b
  80391a:	e8 f6 cf ff ff       	call   800915 <_panic>
  80391f:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803928:	89 50 04             	mov    %edx,0x4(%eax)
  80392b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80392e:	8b 40 04             	mov    0x4(%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 0c                	je     803941 <free_block+0x33d>
  803935:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80393a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80393d:	89 10                	mov    %edx,(%eax)
  80393f:	eb 08                	jmp    803949 <free_block+0x345>
  803941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803944:	a3 48 50 80 00       	mov    %eax,0x805048
  803949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80394c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803954:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80395a:	a1 54 50 80 00       	mov    0x805054,%eax
  80395f:	40                   	inc    %eax
  803960:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803965:	83 ec 0c             	sub    $0xc,%esp
  803968:	ff 75 ec             	pushl  -0x14(%ebp)
  80396b:	e8 2b f4 ff ff       	call   802d9b <to_page_va>
  803970:	83 c4 10             	add    $0x10,%esp
  803973:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803979:	83 ec 0c             	sub    $0xc,%esp
  80397c:	50                   	push   %eax
  80397d:	e8 69 e8 ff ff       	call   8021eb <return_page>
  803982:	83 c4 10             	add    $0x10,%esp
  803985:	eb 01                	jmp    803988 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803987:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803988:	c9                   	leave  
  803989:	c3                   	ret    

0080398a <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80398a:	55                   	push   %ebp
  80398b:	89 e5                	mov    %esp,%ebp
  80398d:	83 ec 14             	sub    $0x14,%esp
  803990:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803993:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803997:	77 07                	ja     8039a0 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803999:	b8 01 00 00 00       	mov    $0x1,%eax
  80399e:	eb 20                	jmp    8039c0 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8039a0:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8039a7:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8039aa:	eb 08                	jmp    8039b4 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8039ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039af:	01 c0                	add    %eax,%eax
  8039b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8039b4:	d1 6d 08             	shrl   0x8(%ebp)
  8039b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039bb:	75 ef                	jne    8039ac <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8039bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8039c0:	c9                   	leave  
  8039c1:	c3                   	ret    

008039c2 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8039c2:	55                   	push   %ebp
  8039c3:	89 e5                	mov    %esp,%ebp
  8039c5:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8039c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039cc:	75 13                	jne    8039e1 <realloc_block+0x1f>
    return alloc_block(new_size);
  8039ce:	83 ec 0c             	sub    $0xc,%esp
  8039d1:	ff 75 0c             	pushl  0xc(%ebp)
  8039d4:	e8 d1 f6 ff ff       	call   8030aa <alloc_block>
  8039d9:	83 c4 10             	add    $0x10,%esp
  8039dc:	e9 d9 00 00 00       	jmp    803aba <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8039e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039e5:	75 18                	jne    8039ff <realloc_block+0x3d>
    free_block(va);
  8039e7:	83 ec 0c             	sub    $0xc,%esp
  8039ea:	ff 75 08             	pushl  0x8(%ebp)
  8039ed:	e8 12 fc ff ff       	call   803604 <free_block>
  8039f2:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8039f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fa:	e9 bb 00 00 00       	jmp    803aba <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8039ff:	83 ec 0c             	sub    $0xc,%esp
  803a02:	ff 75 08             	pushl  0x8(%ebp)
  803a05:	e8 38 f6 ff ff       	call   803042 <get_block_size>
  803a0a:	83 c4 10             	add    $0x10,%esp
  803a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803a10:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803a1d:	73 06                	jae    803a25 <realloc_block+0x63>
    new_size = min_block_size;
  803a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a22:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803a25:	83 ec 0c             	sub    $0xc,%esp
  803a28:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803a2b:	ff 75 0c             	pushl  0xc(%ebp)
  803a2e:	89 c1                	mov    %eax,%ecx
  803a30:	e8 55 ff ff ff       	call   80398a <nearest_pow2_ceil.1572>
  803a35:	83 c4 10             	add    $0x10,%esp
  803a38:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a41:	75 05                	jne    803a48 <realloc_block+0x86>
    return va;
  803a43:	8b 45 08             	mov    0x8(%ebp),%eax
  803a46:	eb 72                	jmp    803aba <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803a48:	83 ec 0c             	sub    $0xc,%esp
  803a4b:	ff 75 0c             	pushl  0xc(%ebp)
  803a4e:	e8 57 f6 ff ff       	call   8030aa <alloc_block>
  803a53:	83 c4 10             	add    $0x10,%esp
  803a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803a59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a5d:	75 07                	jne    803a66 <realloc_block+0xa4>
    return NULL;
  803a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a64:	eb 54                	jmp    803aba <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803a66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6c:	39 d0                	cmp    %edx,%eax
  803a6e:	76 02                	jbe    803a72 <realloc_block+0xb0>
  803a70:	89 d0                	mov    %edx,%eax
  803a72:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803a75:	8b 45 08             	mov    0x8(%ebp),%eax
  803a78:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803a81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a88:	eb 17                	jmp    803aa1 <realloc_block+0xdf>
    dst[i] = src[i];
  803a8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a90:	01 c2                	add    %eax,%edx
  803a92:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a98:	01 c8                	add    %ecx,%eax
  803a9a:	8a 00                	mov    (%eax),%al
  803a9c:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803a9e:	ff 45 f4             	incl   -0xc(%ebp)
  803aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803aa7:	72 e1                	jb     803a8a <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803aa9:	83 ec 0c             	sub    $0xc,%esp
  803aac:	ff 75 08             	pushl  0x8(%ebp)
  803aaf:	e8 50 fb ff ff       	call   803604 <free_block>
  803ab4:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803aba:	c9                   	leave  
  803abb:	c3                   	ret    

00803abc <__udivdi3>:
  803abc:	55                   	push   %ebp
  803abd:	57                   	push   %edi
  803abe:	56                   	push   %esi
  803abf:	53                   	push   %ebx
  803ac0:	83 ec 1c             	sub    $0x1c,%esp
  803ac3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ac7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803acb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803acf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ad3:	89 ca                	mov    %ecx,%edx
  803ad5:	89 f8                	mov    %edi,%eax
  803ad7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803adb:	85 f6                	test   %esi,%esi
  803add:	75 2d                	jne    803b0c <__udivdi3+0x50>
  803adf:	39 cf                	cmp    %ecx,%edi
  803ae1:	77 65                	ja     803b48 <__udivdi3+0x8c>
  803ae3:	89 fd                	mov    %edi,%ebp
  803ae5:	85 ff                	test   %edi,%edi
  803ae7:	75 0b                	jne    803af4 <__udivdi3+0x38>
  803ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  803aee:	31 d2                	xor    %edx,%edx
  803af0:	f7 f7                	div    %edi
  803af2:	89 c5                	mov    %eax,%ebp
  803af4:	31 d2                	xor    %edx,%edx
  803af6:	89 c8                	mov    %ecx,%eax
  803af8:	f7 f5                	div    %ebp
  803afa:	89 c1                	mov    %eax,%ecx
  803afc:	89 d8                	mov    %ebx,%eax
  803afe:	f7 f5                	div    %ebp
  803b00:	89 cf                	mov    %ecx,%edi
  803b02:	89 fa                	mov    %edi,%edx
  803b04:	83 c4 1c             	add    $0x1c,%esp
  803b07:	5b                   	pop    %ebx
  803b08:	5e                   	pop    %esi
  803b09:	5f                   	pop    %edi
  803b0a:	5d                   	pop    %ebp
  803b0b:	c3                   	ret    
  803b0c:	39 ce                	cmp    %ecx,%esi
  803b0e:	77 28                	ja     803b38 <__udivdi3+0x7c>
  803b10:	0f bd fe             	bsr    %esi,%edi
  803b13:	83 f7 1f             	xor    $0x1f,%edi
  803b16:	75 40                	jne    803b58 <__udivdi3+0x9c>
  803b18:	39 ce                	cmp    %ecx,%esi
  803b1a:	72 0a                	jb     803b26 <__udivdi3+0x6a>
  803b1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b20:	0f 87 9e 00 00 00    	ja     803bc4 <__udivdi3+0x108>
  803b26:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2b:	89 fa                	mov    %edi,%edx
  803b2d:	83 c4 1c             	add    $0x1c,%esp
  803b30:	5b                   	pop    %ebx
  803b31:	5e                   	pop    %esi
  803b32:	5f                   	pop    %edi
  803b33:	5d                   	pop    %ebp
  803b34:	c3                   	ret    
  803b35:	8d 76 00             	lea    0x0(%esi),%esi
  803b38:	31 ff                	xor    %edi,%edi
  803b3a:	31 c0                	xor    %eax,%eax
  803b3c:	89 fa                	mov    %edi,%edx
  803b3e:	83 c4 1c             	add    $0x1c,%esp
  803b41:	5b                   	pop    %ebx
  803b42:	5e                   	pop    %esi
  803b43:	5f                   	pop    %edi
  803b44:	5d                   	pop    %ebp
  803b45:	c3                   	ret    
  803b46:	66 90                	xchg   %ax,%ax
  803b48:	89 d8                	mov    %ebx,%eax
  803b4a:	f7 f7                	div    %edi
  803b4c:	31 ff                	xor    %edi,%edi
  803b4e:	89 fa                	mov    %edi,%edx
  803b50:	83 c4 1c             	add    $0x1c,%esp
  803b53:	5b                   	pop    %ebx
  803b54:	5e                   	pop    %esi
  803b55:	5f                   	pop    %edi
  803b56:	5d                   	pop    %ebp
  803b57:	c3                   	ret    
  803b58:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b5d:	89 eb                	mov    %ebp,%ebx
  803b5f:	29 fb                	sub    %edi,%ebx
  803b61:	89 f9                	mov    %edi,%ecx
  803b63:	d3 e6                	shl    %cl,%esi
  803b65:	89 c5                	mov    %eax,%ebp
  803b67:	88 d9                	mov    %bl,%cl
  803b69:	d3 ed                	shr    %cl,%ebp
  803b6b:	89 e9                	mov    %ebp,%ecx
  803b6d:	09 f1                	or     %esi,%ecx
  803b6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b73:	89 f9                	mov    %edi,%ecx
  803b75:	d3 e0                	shl    %cl,%eax
  803b77:	89 c5                	mov    %eax,%ebp
  803b79:	89 d6                	mov    %edx,%esi
  803b7b:	88 d9                	mov    %bl,%cl
  803b7d:	d3 ee                	shr    %cl,%esi
  803b7f:	89 f9                	mov    %edi,%ecx
  803b81:	d3 e2                	shl    %cl,%edx
  803b83:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b87:	88 d9                	mov    %bl,%cl
  803b89:	d3 e8                	shr    %cl,%eax
  803b8b:	09 c2                	or     %eax,%edx
  803b8d:	89 d0                	mov    %edx,%eax
  803b8f:	89 f2                	mov    %esi,%edx
  803b91:	f7 74 24 0c          	divl   0xc(%esp)
  803b95:	89 d6                	mov    %edx,%esi
  803b97:	89 c3                	mov    %eax,%ebx
  803b99:	f7 e5                	mul    %ebp
  803b9b:	39 d6                	cmp    %edx,%esi
  803b9d:	72 19                	jb     803bb8 <__udivdi3+0xfc>
  803b9f:	74 0b                	je     803bac <__udivdi3+0xf0>
  803ba1:	89 d8                	mov    %ebx,%eax
  803ba3:	31 ff                	xor    %edi,%edi
  803ba5:	e9 58 ff ff ff       	jmp    803b02 <__udivdi3+0x46>
  803baa:	66 90                	xchg   %ax,%ax
  803bac:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bb0:	89 f9                	mov    %edi,%ecx
  803bb2:	d3 e2                	shl    %cl,%edx
  803bb4:	39 c2                	cmp    %eax,%edx
  803bb6:	73 e9                	jae    803ba1 <__udivdi3+0xe5>
  803bb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bbb:	31 ff                	xor    %edi,%edi
  803bbd:	e9 40 ff ff ff       	jmp    803b02 <__udivdi3+0x46>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	31 c0                	xor    %eax,%eax
  803bc6:	e9 37 ff ff ff       	jmp    803b02 <__udivdi3+0x46>
  803bcb:	90                   	nop

00803bcc <__umoddi3>:
  803bcc:	55                   	push   %ebp
  803bcd:	57                   	push   %edi
  803bce:	56                   	push   %esi
  803bcf:	53                   	push   %ebx
  803bd0:	83 ec 1c             	sub    $0x1c,%esp
  803bd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803be7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803beb:	89 f3                	mov    %esi,%ebx
  803bed:	89 fa                	mov    %edi,%edx
  803bef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bf3:	89 34 24             	mov    %esi,(%esp)
  803bf6:	85 c0                	test   %eax,%eax
  803bf8:	75 1a                	jne    803c14 <__umoddi3+0x48>
  803bfa:	39 f7                	cmp    %esi,%edi
  803bfc:	0f 86 a2 00 00 00    	jbe    803ca4 <__umoddi3+0xd8>
  803c02:	89 c8                	mov    %ecx,%eax
  803c04:	89 f2                	mov    %esi,%edx
  803c06:	f7 f7                	div    %edi
  803c08:	89 d0                	mov    %edx,%eax
  803c0a:	31 d2                	xor    %edx,%edx
  803c0c:	83 c4 1c             	add    $0x1c,%esp
  803c0f:	5b                   	pop    %ebx
  803c10:	5e                   	pop    %esi
  803c11:	5f                   	pop    %edi
  803c12:	5d                   	pop    %ebp
  803c13:	c3                   	ret    
  803c14:	39 f0                	cmp    %esi,%eax
  803c16:	0f 87 ac 00 00 00    	ja     803cc8 <__umoddi3+0xfc>
  803c1c:	0f bd e8             	bsr    %eax,%ebp
  803c1f:	83 f5 1f             	xor    $0x1f,%ebp
  803c22:	0f 84 ac 00 00 00    	je     803cd4 <__umoddi3+0x108>
  803c28:	bf 20 00 00 00       	mov    $0x20,%edi
  803c2d:	29 ef                	sub    %ebp,%edi
  803c2f:	89 fe                	mov    %edi,%esi
  803c31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c35:	89 e9                	mov    %ebp,%ecx
  803c37:	d3 e0                	shl    %cl,%eax
  803c39:	89 d7                	mov    %edx,%edi
  803c3b:	89 f1                	mov    %esi,%ecx
  803c3d:	d3 ef                	shr    %cl,%edi
  803c3f:	09 c7                	or     %eax,%edi
  803c41:	89 e9                	mov    %ebp,%ecx
  803c43:	d3 e2                	shl    %cl,%edx
  803c45:	89 14 24             	mov    %edx,(%esp)
  803c48:	89 d8                	mov    %ebx,%eax
  803c4a:	d3 e0                	shl    %cl,%eax
  803c4c:	89 c2                	mov    %eax,%edx
  803c4e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c52:	d3 e0                	shl    %cl,%eax
  803c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c58:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c5c:	89 f1                	mov    %esi,%ecx
  803c5e:	d3 e8                	shr    %cl,%eax
  803c60:	09 d0                	or     %edx,%eax
  803c62:	d3 eb                	shr    %cl,%ebx
  803c64:	89 da                	mov    %ebx,%edx
  803c66:	f7 f7                	div    %edi
  803c68:	89 d3                	mov    %edx,%ebx
  803c6a:	f7 24 24             	mull   (%esp)
  803c6d:	89 c6                	mov    %eax,%esi
  803c6f:	89 d1                	mov    %edx,%ecx
  803c71:	39 d3                	cmp    %edx,%ebx
  803c73:	0f 82 87 00 00 00    	jb     803d00 <__umoddi3+0x134>
  803c79:	0f 84 91 00 00 00    	je     803d10 <__umoddi3+0x144>
  803c7f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c83:	29 f2                	sub    %esi,%edx
  803c85:	19 cb                	sbb    %ecx,%ebx
  803c87:	89 d8                	mov    %ebx,%eax
  803c89:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c8d:	d3 e0                	shl    %cl,%eax
  803c8f:	89 e9                	mov    %ebp,%ecx
  803c91:	d3 ea                	shr    %cl,%edx
  803c93:	09 d0                	or     %edx,%eax
  803c95:	89 e9                	mov    %ebp,%ecx
  803c97:	d3 eb                	shr    %cl,%ebx
  803c99:	89 da                	mov    %ebx,%edx
  803c9b:	83 c4 1c             	add    $0x1c,%esp
  803c9e:	5b                   	pop    %ebx
  803c9f:	5e                   	pop    %esi
  803ca0:	5f                   	pop    %edi
  803ca1:	5d                   	pop    %ebp
  803ca2:	c3                   	ret    
  803ca3:	90                   	nop
  803ca4:	89 fd                	mov    %edi,%ebp
  803ca6:	85 ff                	test   %edi,%edi
  803ca8:	75 0b                	jne    803cb5 <__umoddi3+0xe9>
  803caa:	b8 01 00 00 00       	mov    $0x1,%eax
  803caf:	31 d2                	xor    %edx,%edx
  803cb1:	f7 f7                	div    %edi
  803cb3:	89 c5                	mov    %eax,%ebp
  803cb5:	89 f0                	mov    %esi,%eax
  803cb7:	31 d2                	xor    %edx,%edx
  803cb9:	f7 f5                	div    %ebp
  803cbb:	89 c8                	mov    %ecx,%eax
  803cbd:	f7 f5                	div    %ebp
  803cbf:	89 d0                	mov    %edx,%eax
  803cc1:	e9 44 ff ff ff       	jmp    803c0a <__umoddi3+0x3e>
  803cc6:	66 90                	xchg   %ax,%ax
  803cc8:	89 c8                	mov    %ecx,%eax
  803cca:	89 f2                	mov    %esi,%edx
  803ccc:	83 c4 1c             	add    $0x1c,%esp
  803ccf:	5b                   	pop    %ebx
  803cd0:	5e                   	pop    %esi
  803cd1:	5f                   	pop    %edi
  803cd2:	5d                   	pop    %ebp
  803cd3:	c3                   	ret    
  803cd4:	3b 04 24             	cmp    (%esp),%eax
  803cd7:	72 06                	jb     803cdf <__umoddi3+0x113>
  803cd9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cdd:	77 0f                	ja     803cee <__umoddi3+0x122>
  803cdf:	89 f2                	mov    %esi,%edx
  803ce1:	29 f9                	sub    %edi,%ecx
  803ce3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ce7:	89 14 24             	mov    %edx,(%esp)
  803cea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cee:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cf2:	8b 14 24             	mov    (%esp),%edx
  803cf5:	83 c4 1c             	add    $0x1c,%esp
  803cf8:	5b                   	pop    %ebx
  803cf9:	5e                   	pop    %esi
  803cfa:	5f                   	pop    %edi
  803cfb:	5d                   	pop    %ebp
  803cfc:	c3                   	ret    
  803cfd:	8d 76 00             	lea    0x0(%esi),%esi
  803d00:	2b 04 24             	sub    (%esp),%eax
  803d03:	19 fa                	sbb    %edi,%edx
  803d05:	89 d1                	mov    %edx,%ecx
  803d07:	89 c6                	mov    %eax,%esi
  803d09:	e9 71 ff ff ff       	jmp    803c7f <__umoddi3+0xb3>
  803d0e:	66 90                	xchg   %ax,%ax
  803d10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d14:	72 ea                	jb     803d00 <__umoddi3+0x134>
  803d16:	89 d9                	mov    %ebx,%ecx
  803d18:	e9 62 ff ff ff       	jmp    803c7f <__umoddi3+0xb3>
