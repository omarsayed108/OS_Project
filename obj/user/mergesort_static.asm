
obj/user/mergesort_static:     file format elf32-i386


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
  800031:	e8 d5 06 00 00       	call   80070b <libmain>
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
  80004b:	e8 ad 1a 00 00       	call   801afd <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 a0 22 80 00       	push   $0x8022a0
  800058:	e8 4c 0b 00 00       	call   800ba9 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 a2 22 80 00       	push   $0x8022a2
  800068:	e8 3c 0b 00 00       	call   800ba9 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 b8 22 80 00       	push   $0x8022b8
  800078:	e8 2c 0b 00 00       	call   800ba9 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 a2 22 80 00       	push   $0x8022a2
  800088:	e8 1c 0b 00 00       	call   800ba9 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 a0 22 80 00       	push   $0x8022a0
  800098:	e8 0c 0b 00 00       	call   800ba9 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 800000;
  8000a0:	c7 45 ec 00 35 0c 00 	movl   $0xc3500,-0x14(%ebp)
		cprintf("Enter the number of elements: %d\n", NumOfElements) ;
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ad:	68 d0 22 80 00       	push   $0x8022d0
  8000b2:	e8 f2 0a 00 00       	call   800ba9 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp

		cprintf("Chose the initialization method:\n") ;
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 f4 22 80 00       	push   $0x8022f4
  8000c2:	e8 e2 0a 00 00       	call   800ba9 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 16 23 80 00       	push   $0x802316
  8000d2:	e8 d2 0a 00 00       	call   800ba9 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 24 23 80 00       	push   $0x802324
  8000e2:	e8 c2 0a 00 00       	call   800ba9 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 33 23 80 00       	push   $0x802333
  8000f2:	e8 b2 0a 00 00       	call   800ba9 <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 43 23 80 00       	push   $0x802343
  800102:	e8 a2 0a 00 00       	call   800ba9 <cprintf>
  800107:	83 c4 10             	add    $0x10,%esp
			Chose = 'c' ;
  80010a:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80010e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	50                   	push   %eax
  800116:	e8 b4 05 00 00       	call   8006cf <cputchar>
  80011b:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	6a 0a                	push   $0xa
  800123:	e8 a7 05 00 00       	call   8006cf <cputchar>
  800128:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80012b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80012f:	74 0c                	je     80013d <_main+0x105>
  800131:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800135:	74 06                	je     80013d <_main+0x105>
  800137:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80013b:	75 bd                	jne    8000fa <_main+0xc2>

		//2012: lock the interrupt
		sys_unlock_cons();
  80013d:	e8 d5 19 00 00       	call   801b17 <sys_unlock_cons>

		//int *Elements = malloc(sizeof(int) * NumOfElements) ;
		int *Elements = __Elements;
  800142:	c7 45 e8 40 85 b2 00 	movl   $0xb28540,-0x18(%ebp)
		int  i ;
		switch (Chose)
  800149:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80014d:	83 f8 62             	cmp    $0x62,%eax
  800150:	74 1d                	je     80016f <_main+0x137>
  800152:	83 f8 63             	cmp    $0x63,%eax
  800155:	74 2b                	je     800182 <_main+0x14a>
  800157:	83 f8 61             	cmp    $0x61,%eax
  80015a:	75 39                	jne    800195 <_main+0x15d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	ff 75 ec             	pushl  -0x14(%ebp)
  800162:	ff 75 e8             	pushl  -0x18(%ebp)
  800165:	e8 e7 01 00 00       	call   800351 <InitializeAscending>
  80016a:	83 c4 10             	add    $0x10,%esp
			break ;
  80016d:	eb 37                	jmp    8001a6 <_main+0x16e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 ec             	pushl  -0x14(%ebp)
  800175:	ff 75 e8             	pushl  -0x18(%ebp)
  800178:	e8 05 02 00 00       	call   800382 <InitializeIdentical>
  80017d:	83 c4 10             	add    $0x10,%esp
			break ;
  800180:	eb 24                	jmp    8001a6 <_main+0x16e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800182:	83 ec 08             	sub    $0x8,%esp
  800185:	ff 75 ec             	pushl  -0x14(%ebp)
  800188:	ff 75 e8             	pushl  -0x18(%ebp)
  80018b:	e8 27 02 00 00       	call   8003b7 <InitializeSemiRandom>
  800190:	83 c4 10             	add    $0x10,%esp
			break ;
  800193:	eb 11                	jmp    8001a6 <_main+0x16e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 ec             	pushl  -0x14(%ebp)
  80019b:	ff 75 e8             	pushl  -0x18(%ebp)
  80019e:	e8 14 02 00 00       	call   8003b7 <InitializeSemiRandom>
  8001a3:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ac:	6a 01                	push   $0x1
  8001ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b1:	e8 e0 02 00 00       	call   800496 <MSort>
  8001b6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b9:	e8 3f 19 00 00       	call   801afd <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 4c 23 80 00       	push   $0x80234c
  8001c6:	e8 de 09 00 00       	call   800ba9 <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001ce:	e8 44 19 00 00       	call   801b17 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 c6 00 00 00       	call   8002a7 <CheckSorted>
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8001eb:	75 14                	jne    800201 <_main+0x1c9>
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	68 80 23 80 00       	push   $0x802380
  8001f5:	6a 51                	push   $0x51
  8001f7:	68 a2 23 80 00       	push   $0x8023a2
  8001fc:	e8 ba 06 00 00       	call   8008bb <_panic>
		else
		{
			sys_lock_cons();
  800201:	e8 f7 18 00 00       	call   801afd <sys_lock_cons>
			cprintf("===============================================\n") ;
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 bc 23 80 00       	push   $0x8023bc
  80020e:	e8 96 09 00 00       	call   800ba9 <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 f0 23 80 00       	push   $0x8023f0
  80021e:	e8 86 09 00 00       	call   800ba9 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 24 24 80 00       	push   $0x802424
  80022e:	e8 76 09 00 00       	call   800ba9 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800236:	e8 dc 18 00 00       	call   801b17 <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  80023b:	e8 bd 18 00 00       	call   801afd <sys_lock_cons>
		Chose = 0 ;
  800240:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800244:	eb 3e                	jmp    800284 <_main+0x24c>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 56 24 80 00       	push   $0x802456
  80024e:	e8 56 09 00 00       	call   800ba9 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
			Chose = 'n' ;
  800256:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  80025a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	50                   	push   %eax
  800262:	e8 68 04 00 00       	call   8006cf <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 0a                	push   $0xa
  80026f:	e8 5b 04 00 00       	call   8006cf <cputchar>
  800274:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 4e 04 00 00       	call   8006cf <cputchar>
  800281:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800284:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800288:	74 06                	je     800290 <_main+0x258>
  80028a:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80028e:	75 b6                	jne    800246 <_main+0x20e>
			Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  800290:	e8 82 18 00 00       	call   801b17 <sys_unlock_cons>

	} while (Chose == 'y');
  800295:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800299:	0f 84 a9 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  80029f:	e8 10 1c 00 00       	call   801eb4 <inctst>

}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ad:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002bb:	eb 33                	jmp    8002f0 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	8b 10                	mov    (%eax),%edx
  8002ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002d1:	40                   	inc    %eax
  8002d2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	01 c8                	add    %ecx,%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	39 c2                	cmp    %eax,%edx
  8002e2:	7e 09                	jle    8002ed <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8002e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8002eb:	eb 0c                	jmp    8002f9 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002ed:	ff 45 f8             	incl   -0x8(%ebp)
  8002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f3:	48                   	dec    %eax
  8002f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8002f7:	7f c4                	jg     8002bd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8002f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8b 00                	mov    (%eax),%eax
  800315:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	01 c2                	add    %eax,%edx
  800327:	8b 45 10             	mov    0x10(%ebp),%eax
  80032a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	01 c8                	add    %ecx,%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80033a:	8b 45 10             	mov    0x10(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80034c:	89 02                	mov    %eax,(%edx)
}
  80034e:	90                   	nop
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80035e:	eb 17                	jmp    800377 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800360:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800363:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	01 c2                	add    %eax,%edx
  80036f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800372:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	ff 45 fc             	incl   -0x4(%ebp)
  800377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80037a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80037d:	7c e1                	jl     800360 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80038f:	eb 1b                	jmp    8003ac <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003a6:	48                   	dec    %eax
  8003a7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	ff 45 fc             	incl   -0x4(%ebp)
  8003ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003b2:	7c dd                	jl     800391 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003b4:	90                   	nop
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c0:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003c5:	f7 e9                	imul   %ecx
  8003c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ca:	89 d0                	mov    %edx,%eax
  8003cc:	29 c8                	sub    %ecx,%eax
  8003ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003d5:	75 07                	jne    8003de <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003d7:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e5:	eb 1e                	jmp    800405 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8003e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	99                   	cltd   
  8003fb:	f7 7d f8             	idivl  -0x8(%ebp)
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800402:	ff 45 fc             	incl   -0x4(%ebp)
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80040b:	7c da                	jl     8003e7 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80040d:	90                   	nop
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800416:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80041d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800424:	eb 42                	jmp    800468 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800429:	99                   	cltd   
  80042a:	f7 7d f0             	idivl  -0x10(%ebp)
  80042d:	89 d0                	mov    %edx,%eax
  80042f:	85 c0                	test   %eax,%eax
  800431:	75 10                	jne    800443 <PrintElements+0x33>
			cprintf("\n");
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	68 a0 22 80 00       	push   $0x8022a0
  80043b:	e8 69 07 00 00       	call   800ba9 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	01 d0                	add    %edx,%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	50                   	push   %eax
  800458:	68 74 24 80 00       	push   $0x802474
  80045d:	e8 47 07 00 00       	call   800ba9 <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800465:	ff 45 f4             	incl   -0xc(%ebp)
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	48                   	dec    %eax
  80046c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80046f:	7f b5                	jg     800426 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	01 d0                	add    %edx,%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	50                   	push   %eax
  800486:	68 79 24 80 00       	push   $0x802479
  80048b:	e8 19 07 00 00       	call   800ba9 <cprintf>
  800490:	83 c4 10             	add    $0x10,%esp

}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <MSort>:


void MSort(int* A, int p, int r)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004a2:	7d 54                	jge    8004f8 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	89 c2                	mov    %eax,%edx
  8004ae:	c1 ea 1f             	shr    $0x1f,%edx
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	d1 f8                	sar    %eax
  8004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	e8 cd ff ff ff       	call   800496 <MSort>
  8004c9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cf:	40                   	inc    %eax
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	ff 75 10             	pushl  0x10(%ebp)
  8004d6:	50                   	push   %eax
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	e8 b7 ff ff ff       	call   800496 <MSort>
  8004df:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004e2:	ff 75 10             	pushl  0x10(%ebp)
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 08 00 00 00       	call   8004fb <Merge>
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	eb 01                	jmp    8004f9 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8004f8:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  800501:	8b 45 10             	mov    0x10(%ebp),%eax
  800504:	2b 45 0c             	sub    0xc(%ebp),%eax
  800507:	40                   	inc    %eax
  800508:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	2b 45 10             	sub    0x10(%ebp),%eax
  800511:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  800514:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  80051b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  800522:	c7 45 e0 60 30 80 00 	movl   $0x803060,-0x20(%ebp)
	int* Right = __Right;
  800529:	c7 45 dc 40 59 e3 00 	movl   $0xe35940,-0x24(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800537:	eb 2f                	jmp    800568 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	01 c2                	add    %eax,%edx
  800548:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054e:	01 c8                	add    %ecx,%eax
  800550:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800555:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 c8                	add    %ecx,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800565:	ff 45 f4             	incl   -0xc(%ebp)
  800568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80056e:	7c c9                	jl     800539 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800570:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800577:	eb 2a                	jmp    8005a3 <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800586:	01 c2                	add    %eax,%edx
  800588:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058e:	01 c8                	add    %ecx,%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	ff 45 f0             	incl   -0x10(%ebp)
  8005a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005a9:	7c ce                	jl     800579 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8005b1:	e9 0a 01 00 00       	jmp    8006c0 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005b9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8005bc:	0f 8d 95 00 00 00    	jge    800657 <Merge+0x15c>
  8005c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005c5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c8:	0f 8d 89 00 00 00    	jge    800657 <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	39 c2                	cmp    %eax,%edx
  8005f2:	7d 33                	jge    800627 <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8005f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005f7:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800612:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800622:	e9 96 00 00 00       	jmp    8006bd <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80062a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80063c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80063f:	8d 50 01             	lea    0x1(%eax),%edx
  800642:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800655:	eb 66                	jmp    8006bd <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80065a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80065d:	7d 30                	jge    80068f <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  80065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800662:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800667:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800677:	8d 50 01             	lea    0x1(%eax),%edx
  80067a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 01                	mov    %eax,(%ecx)
  80068d:	eb 2e                	jmp    8006bd <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  80068f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006bd:	ff 45 ec             	incl   -0x14(%ebp)
  8006c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006c3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006c6:	0f 8e ea fe ff ff    	jle    8005b6 <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006df:	83 ec 0c             	sub    $0xc,%esp
  8006e2:	50                   	push   %eax
  8006e3:	e8 5d 15 00 00       	call   801c45 <sys_cputc>
  8006e8:	83 c4 10             	add    $0x10,%esp
}
  8006eb:	90                   	nop
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getchar>:


int
getchar(void)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8006f4:	e8 eb 13 00 00       	call   801ae4 <sys_cgetc>
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8006fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006ff:	c9                   	leave  
  800700:	c3                   	ret    

00800701 <iscons>:

int iscons(int fdnum)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800704:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800709:	5d                   	pop    %ebp
  80070a:	c3                   	ret    

0080070b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	57                   	push   %edi
  80070f:	56                   	push   %esi
  800710:	53                   	push   %ebx
  800711:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800714:	e8 5d 16 00 00       	call   801d76 <sys_getenvindex>
  800719:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80071c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80071f:	89 d0                	mov    %edx,%eax
  800721:	01 c0                	add    %eax,%eax
  800723:	01 d0                	add    %edx,%eax
  800725:	c1 e0 02             	shl    $0x2,%eax
  800728:	01 d0                	add    %edx,%eax
  80072a:	c1 e0 02             	shl    $0x2,%eax
  80072d:	01 d0                	add    %edx,%eax
  80072f:	c1 e0 03             	shl    $0x3,%eax
  800732:	01 d0                	add    %edx,%eax
  800734:	c1 e0 02             	shl    $0x2,%eax
  800737:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80073c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800741:	a1 20 30 80 00       	mov    0x803020,%eax
  800746:	8a 40 20             	mov    0x20(%eax),%al
  800749:	84 c0                	test   %al,%al
  80074b:	74 0d                	je     80075a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80074d:	a1 20 30 80 00       	mov    0x803020,%eax
  800752:	83 c0 20             	add    $0x20,%eax
  800755:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80075a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80075e:	7e 0a                	jle    80076a <libmain+0x5f>
		binaryname = argv[0];
  800760:	8b 45 0c             	mov    0xc(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	ff 75 08             	pushl  0x8(%ebp)
  800773:	e8 c0 f8 ff ff       	call   800038 <_main>
  800778:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80077b:	a1 00 30 80 00       	mov    0x803000,%eax
  800780:	85 c0                	test   %eax,%eax
  800782:	0f 84 01 01 00 00    	je     800889 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800788:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80078e:	bb 78 25 80 00       	mov    $0x802578,%ebx
  800793:	ba 0e 00 00 00       	mov    $0xe,%edx
  800798:	89 c7                	mov    %eax,%edi
  80079a:	89 de                	mov    %ebx,%esi
  80079c:	89 d1                	mov    %edx,%ecx
  80079e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007a8:	b0 00                	mov    $0x0,%al
  8007aa:	89 d7                	mov    %edx,%edi
  8007ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	e8 e4 17 00 00       	call   801fac <sys_utilities>
  8007c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8007cb:	e8 2d 13 00 00       	call   801afd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 98 24 80 00       	push   $0x802498
  8007d8:	e8 cc 03 00 00       	call   800ba9 <cprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8007e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	74 18                	je     8007ff <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8007e7:	e8 de 17 00 00       	call   801fca <sys_get_optimal_num_faults>
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	50                   	push   %eax
  8007f0:	68 c0 24 80 00       	push   $0x8024c0
  8007f5:	e8 af 03 00 00       	call   800ba9 <cprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	eb 59                	jmp    800858 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800804:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80080a:	a1 20 30 80 00       	mov    0x803020,%eax
  80080f:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800815:	83 ec 04             	sub    $0x4,%esp
  800818:	52                   	push   %edx
  800819:	50                   	push   %eax
  80081a:	68 e4 24 80 00       	push   $0x8024e4
  80081f:	e8 85 03 00 00       	call   800ba9 <cprintf>
  800824:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800827:	a1 20 30 80 00       	mov    0x803020,%eax
  80082c:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800832:	a1 20 30 80 00       	mov    0x803020,%eax
  800837:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80083d:	a1 20 30 80 00       	mov    0x803020,%eax
  800842:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800848:	51                   	push   %ecx
  800849:	52                   	push   %edx
  80084a:	50                   	push   %eax
  80084b:	68 0c 25 80 00       	push   $0x80250c
  800850:	e8 54 03 00 00       	call   800ba9 <cprintf>
  800855:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800858:	a1 20 30 80 00       	mov    0x803020,%eax
  80085d:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	50                   	push   %eax
  800867:	68 64 25 80 00       	push   $0x802564
  80086c:	e8 38 03 00 00       	call   800ba9 <cprintf>
  800871:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800874:	83 ec 0c             	sub    $0xc,%esp
  800877:	68 98 24 80 00       	push   $0x802498
  80087c:	e8 28 03 00 00       	call   800ba9 <cprintf>
  800881:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800884:	e8 8e 12 00 00       	call   801b17 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800889:	e8 1f 00 00 00       	call   8008ad <exit>
}
  80088e:	90                   	nop
  80088f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5f                   	pop    %edi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80089d:	83 ec 0c             	sub    $0xc,%esp
  8008a0:	6a 00                	push   $0x0
  8008a2:	e8 9b 14 00 00       	call   801d42 <sys_destroy_env>
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	90                   	nop
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    

008008ad <exit>:

void
exit(void)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008b3:	e8 f0 14 00 00       	call   801da8 <sys_exit_env>
}
  8008b8:	90                   	nop
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ca:	a1 44 2d 14 01       	mov    0x1142d44,%eax
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	74 16                	je     8008e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008d3:	a1 44 2d 14 01       	mov    0x1142d44,%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	50                   	push   %eax
  8008dc:	68 dc 25 80 00       	push   $0x8025dc
  8008e1:	e8 c3 02 00 00       	call   800ba9 <cprintf>
  8008e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8008e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	ff 75 08             	pushl  0x8(%ebp)
  8008f7:	50                   	push   %eax
  8008f8:	68 e4 25 80 00       	push   $0x8025e4
  8008fd:	6a 74                	push   $0x74
  8008ff:	e8 d2 02 00 00       	call   800bd6 <cprintf_colored>
  800904:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	ff 75 f4             	pushl  -0xc(%ebp)
  800910:	50                   	push   %eax
  800911:	e8 24 02 00 00       	call   800b3a <vcprintf>
  800916:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	6a 00                	push   $0x0
  80091e:	68 0c 26 80 00       	push   $0x80260c
  800923:	e8 12 02 00 00       	call   800b3a <vcprintf>
  800928:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80092b:	e8 7d ff ff ff       	call   8008ad <exit>

	// should not return here
	while (1) ;
  800930:	eb fe                	jmp    800930 <_panic+0x75>

00800932 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	53                   	push   %ebx
  800936:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800939:	a1 20 30 80 00       	mov    0x803020,%eax
  80093e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	39 c2                	cmp    %eax,%edx
  800949:	74 14                	je     80095f <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80094b:	83 ec 04             	sub    $0x4,%esp
  80094e:	68 10 26 80 00       	push   $0x802610
  800953:	6a 26                	push   $0x26
  800955:	68 5c 26 80 00       	push   $0x80265c
  80095a:	e8 5c ff ff ff       	call   8008bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80095f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800966:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80096d:	e9 d9 00 00 00       	jmp    800a4b <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800975:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	01 d0                	add    %edx,%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	85 c0                	test   %eax,%eax
  800985:	75 08                	jne    80098f <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800987:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80098a:	e9 b9 00 00 00       	jmp    800a48 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80098f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800996:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80099d:	eb 79                	jmp    800a18 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80099f:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a4:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8009aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ad:	89 d0                	mov    %edx,%eax
  8009af:	01 c0                	add    %eax,%eax
  8009b1:	01 d0                	add    %edx,%eax
  8009b3:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8009ba:	01 d8                	add    %ebx,%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	01 c8                	add    %ecx,%eax
  8009c0:	8a 40 04             	mov    0x4(%eax),%al
  8009c3:	84 c0                	test   %al,%al
  8009c5:	75 4e                	jne    800a15 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8009cc:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8009d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009d5:	89 d0                	mov    %edx,%eax
  8009d7:	01 c0                	add    %eax,%eax
  8009d9:	01 d0                	add    %edx,%eax
  8009db:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8009e2:	01 d8                	add    %ebx,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	01 c8                	add    %ecx,%eax
  8009e8:	8b 00                	mov    (%eax),%eax
  8009ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	01 c8                	add    %ecx,%eax
  800a06:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a08:	39 c2                	cmp    %eax,%edx
  800a0a:	75 09                	jne    800a15 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800a0c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a13:	eb 19                	jmp    800a2e <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a15:	ff 45 e8             	incl   -0x18(%ebp)
  800a18:	a1 20 30 80 00       	mov    0x803020,%eax
  800a1d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	0f 87 71 ff ff ff    	ja     80099f <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a32:	75 14                	jne    800a48 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800a34:	83 ec 04             	sub    $0x4,%esp
  800a37:	68 68 26 80 00       	push   $0x802668
  800a3c:	6a 3a                	push   $0x3a
  800a3e:	68 5c 26 80 00       	push   $0x80265c
  800a43:	e8 73 fe ff ff       	call   8008bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a48:	ff 45 f0             	incl   -0x10(%ebp)
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a51:	0f 8c 1b ff ff ff    	jl     800972 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a65:	eb 2e                	jmp    800a95 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a67:	a1 20 30 80 00       	mov    0x803020,%eax
  800a6c:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	01 d0                	add    %edx,%eax
  800a7b:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a82:	01 d8                	add    %ebx,%eax
  800a84:	01 d0                	add    %edx,%eax
  800a86:	01 c8                	add    %ecx,%eax
  800a88:	8a 40 04             	mov    0x4(%eax),%al
  800a8b:	3c 01                	cmp    $0x1,%al
  800a8d:	75 03                	jne    800a92 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800a8f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a92:	ff 45 e0             	incl   -0x20(%ebp)
  800a95:	a1 20 30 80 00       	mov    0x803020,%eax
  800a9a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa3:	39 c2                	cmp    %eax,%edx
  800aa5:	77 c0                	ja     800a67 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aaa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aad:	74 14                	je     800ac3 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 bc 26 80 00       	push   $0x8026bc
  800ab7:	6a 44                	push   $0x44
  800ab9:	68 5c 26 80 00       	push   $0x80265c
  800abe:	e8 f8 fd ff ff       	call   8008bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ac3:	90                   	nop
  800ac4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	53                   	push   %ebx
  800acd:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	8b 00                	mov    (%eax),%eax
  800ad5:	8d 48 01             	lea    0x1(%eax),%ecx
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	89 0a                	mov    %ecx,(%edx)
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae0:	88 d1                	mov    %dl,%cl
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	3d ff 00 00 00       	cmp    $0xff,%eax
  800af3:	75 30                	jne    800b25 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800af5:	8b 15 48 2d 14 01    	mov    0x1142d48,%edx
  800afb:	a0 60 04 b1 00       	mov    0xb10460,%al
  800b00:	0f b6 c0             	movzbl %al,%eax
  800b03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b06:	8b 09                	mov    (%ecx),%ecx
  800b08:	89 cb                	mov    %ecx,%ebx
  800b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0d:	83 c1 08             	add    $0x8,%ecx
  800b10:	52                   	push   %edx
  800b11:	50                   	push   %eax
  800b12:	53                   	push   %ebx
  800b13:	51                   	push   %ecx
  800b14:	e8 a0 0f 00 00       	call   801ab9 <sys_cputs>
  800b19:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	8d 50 01             	lea    0x1(%eax),%edx
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b34:	90                   	nop
  800b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b43:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4a:	00 00 00 
	b.cnt = 0;
  800b4d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b54:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	ff 75 08             	pushl  0x8(%ebp)
  800b5d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b63:	50                   	push   %eax
  800b64:	68 c9 0a 80 00       	push   $0x800ac9
  800b69:	e8 5a 02 00 00       	call   800dc8 <vprintfmt>
  800b6e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b71:	8b 15 48 2d 14 01    	mov    0x1142d48,%edx
  800b77:	a0 60 04 b1 00       	mov    0xb10460,%al
  800b7c:	0f b6 c0             	movzbl %al,%eax
  800b7f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800b85:	52                   	push   %edx
  800b86:	50                   	push   %eax
  800b87:	51                   	push   %ecx
  800b88:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8e:	83 c0 08             	add    $0x8,%eax
  800b91:	50                   	push   %eax
  800b92:	e8 22 0f 00 00       	call   801ab9 <sys_cputs>
  800b97:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b9a:	c6 05 60 04 b1 00 00 	movb   $0x0,0xb10460
	return b.cnt;
  800ba1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800baf:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
	va_start(ap, fmt);
  800bb6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc5:	50                   	push   %eax
  800bc6:	e8 6f ff ff ff       	call   800b3a <vcprintf>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd4:	c9                   	leave  
  800bd5:	c3                   	ret    

00800bd6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bdc:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
	curTextClr = (textClr << 8) ; //set text color by the given value
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	c1 e0 08             	shl    $0x8,%eax
  800be9:	a3 48 2d 14 01       	mov    %eax,0x1142d48
	va_start(ap, fmt);
  800bee:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf1:	83 c0 04             	add    $0x4,%eax
  800bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800c00:	50                   	push   %eax
  800c01:	e8 34 ff ff ff       	call   800b3a <vcprintf>
  800c06:	83 c4 10             	add    $0x10,%esp
  800c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c0c:	c7 05 48 2d 14 01 00 	movl   $0x700,0x1142d48
  800c13:	07 00 00 

	return cnt;
  800c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c21:	e8 d7 0e 00 00       	call   801afd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c26:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 f4             	pushl  -0xc(%ebp)
  800c35:	50                   	push   %eax
  800c36:	e8 ff fe ff ff       	call   800b3a <vcprintf>
  800c3b:	83 c4 10             	add    $0x10,%esp
  800c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c41:	e8 d1 0e 00 00       	call   801b17 <sys_unlock_cons>
	return cnt;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 14             	sub    $0x14,%esp
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c5e:	8b 45 18             	mov    0x18(%ebp),%eax
  800c61:	ba 00 00 00 00       	mov    $0x0,%edx
  800c66:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c69:	77 55                	ja     800cc0 <printnum+0x75>
  800c6b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c6e:	72 05                	jb     800c75 <printnum+0x2a>
  800c70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c73:	77 4b                	ja     800cc0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c75:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c78:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c7b:	8b 45 18             	mov    0x18(%ebp),%eax
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	52                   	push   %edx
  800c84:	50                   	push   %eax
  800c85:	ff 75 f4             	pushl  -0xc(%ebp)
  800c88:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8b:	e8 ac 13 00 00       	call   80203c <__udivdi3>
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	83 ec 04             	sub    $0x4,%esp
  800c96:	ff 75 20             	pushl  0x20(%ebp)
  800c99:	53                   	push   %ebx
  800c9a:	ff 75 18             	pushl  0x18(%ebp)
  800c9d:	52                   	push   %edx
  800c9e:	50                   	push   %eax
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 a1 ff ff ff       	call   800c4b <printnum>
  800caa:	83 c4 20             	add    $0x20,%esp
  800cad:	eb 1a                	jmp    800cc9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	ff 75 20             	pushl  0x20(%ebp)
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cc0:	ff 4d 1c             	decl   0x1c(%ebp)
  800cc3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cc7:	7f e6                	jg     800caf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cc9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ccc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd7:	53                   	push   %ebx
  800cd8:	51                   	push   %ecx
  800cd9:	52                   	push   %edx
  800cda:	50                   	push   %eax
  800cdb:	e8 6c 14 00 00       	call   80214c <__umoddi3>
  800ce0:	83 c4 10             	add    $0x10,%esp
  800ce3:	05 34 29 80 00       	add    $0x802934,%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f be c0             	movsbl %al,%eax
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	50                   	push   %eax
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	ff d0                	call   *%eax
  800cf9:	83 c4 10             	add    $0x10,%esp
}
  800cfc:	90                   	nop
  800cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d05:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d09:	7e 1c                	jle    800d27 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	8d 50 08             	lea    0x8(%eax),%edx
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 10                	mov    %edx,(%eax)
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8b 00                	mov    (%eax),%eax
  800d1d:	83 e8 08             	sub    $0x8,%eax
  800d20:	8b 50 04             	mov    0x4(%eax),%edx
  800d23:	8b 00                	mov    (%eax),%eax
  800d25:	eb 40                	jmp    800d67 <getuint+0x65>
	else if (lflag)
  800d27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2b:	74 1e                	je     800d4b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8b 00                	mov    (%eax),%eax
  800d32:	8d 50 04             	lea    0x4(%eax),%edx
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	89 10                	mov    %edx,(%eax)
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8b 00                	mov    (%eax),%eax
  800d3f:	83 e8 04             	sub    $0x4,%eax
  800d42:	8b 00                	mov    (%eax),%eax
  800d44:	ba 00 00 00 00       	mov    $0x0,%edx
  800d49:	eb 1c                	jmp    800d67 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d70:	7e 1c                	jle    800d8e <getint+0x25>
		return va_arg(*ap, long long);
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	8d 50 08             	lea    0x8(%eax),%edx
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	89 10                	mov    %edx,(%eax)
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8b 00                	mov    (%eax),%eax
  800d84:	83 e8 08             	sub    $0x8,%eax
  800d87:	8b 50 04             	mov    0x4(%eax),%edx
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	eb 38                	jmp    800dc6 <getint+0x5d>
	else if (lflag)
  800d8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d92:	74 1a                	je     800dae <getint+0x45>
		return va_arg(*ap, long);
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8b 00                	mov    (%eax),%eax
  800d99:	8d 50 04             	lea    0x4(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	89 10                	mov    %edx,(%eax)
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	8b 00                	mov    (%eax),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 00                	mov    (%eax),%eax
  800dab:	99                   	cltd   
  800dac:	eb 18                	jmp    800dc6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8b 00                	mov    (%eax),%eax
  800db3:	8d 50 04             	lea    0x4(%eax),%edx
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 10                	mov    %edx,(%eax)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	83 e8 04             	sub    $0x4,%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	99                   	cltd   
}
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dd0:	eb 17                	jmp    800de9 <vprintfmt+0x21>
			if (ch == '\0')
  800dd2:	85 db                	test   %ebx,%ebx
  800dd4:	0f 84 c1 03 00 00    	je     80119b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	53                   	push   %ebx
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800de9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dec:	8d 50 01             	lea    0x1(%eax),%edx
  800def:	89 55 10             	mov    %edx,0x10(%ebp)
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 d8             	movzbl %al,%ebx
  800df7:	83 fb 25             	cmp    $0x25,%ebx
  800dfa:	75 d6                	jne    800dd2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dfc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e00:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1f:	8d 50 01             	lea    0x1(%eax),%edx
  800e22:	89 55 10             	mov    %edx,0x10(%ebp)
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	0f b6 d8             	movzbl %al,%ebx
  800e2a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e2d:	83 f8 5b             	cmp    $0x5b,%eax
  800e30:	0f 87 3d 03 00 00    	ja     801173 <vprintfmt+0x3ab>
  800e36:	8b 04 85 58 29 80 00 	mov    0x802958(,%eax,4),%eax
  800e3d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e3f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e43:	eb d7                	jmp    800e1c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e45:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e49:	eb d1                	jmp    800e1c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e55:	89 d0                	mov    %edx,%eax
  800e57:	c1 e0 02             	shl    $0x2,%eax
  800e5a:	01 d0                	add    %edx,%eax
  800e5c:	01 c0                	add    %eax,%eax
  800e5e:	01 d8                	add    %ebx,%eax
  800e60:	83 e8 30             	sub    $0x30,%eax
  800e63:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e66:	8b 45 10             	mov    0x10(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e6e:	83 fb 2f             	cmp    $0x2f,%ebx
  800e71:	7e 3e                	jle    800eb1 <vprintfmt+0xe9>
  800e73:	83 fb 39             	cmp    $0x39,%ebx
  800e76:	7f 39                	jg     800eb1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e78:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e7b:	eb d5                	jmp    800e52 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e91:	eb 1f                	jmp    800eb2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e97:	79 83                	jns    800e1c <vprintfmt+0x54>
				width = 0;
  800e99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ea0:	e9 77 ff ff ff       	jmp    800e1c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ea5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eac:	e9 6b ff ff ff       	jmp    800e1c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800eb1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800eb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb6:	0f 89 60 ff ff ff    	jns    800e1c <vprintfmt+0x54>
				width = precision, precision = -1;
  800ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ebf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ec2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ec9:	e9 4e ff ff ff       	jmp    800e1c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ece:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ed1:	e9 46 ff ff ff       	jmp    800e1c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 c0 04             	add    $0x4,%eax
  800edc:	89 45 14             	mov    %eax,0x14(%ebp)
  800edf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee2:	83 e8 04             	sub    $0x4,%eax
  800ee5:	8b 00                	mov    (%eax),%eax
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	50                   	push   %eax
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	ff d0                	call   *%eax
  800ef3:	83 c4 10             	add    $0x10,%esp
			break;
  800ef6:	e9 9b 02 00 00       	jmp    801196 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800efb:	8b 45 14             	mov    0x14(%ebp),%eax
  800efe:	83 c0 04             	add    $0x4,%eax
  800f01:	89 45 14             	mov    %eax,0x14(%ebp)
  800f04:	8b 45 14             	mov    0x14(%ebp),%eax
  800f07:	83 e8 04             	sub    $0x4,%eax
  800f0a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f0c:	85 db                	test   %ebx,%ebx
  800f0e:	79 02                	jns    800f12 <vprintfmt+0x14a>
				err = -err;
  800f10:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f12:	83 fb 64             	cmp    $0x64,%ebx
  800f15:	7f 0b                	jg     800f22 <vprintfmt+0x15a>
  800f17:	8b 34 9d a0 27 80 00 	mov    0x8027a0(,%ebx,4),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 19                	jne    800f3b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f22:	53                   	push   %ebx
  800f23:	68 45 29 80 00       	push   $0x802945
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	ff 75 08             	pushl  0x8(%ebp)
  800f2e:	e8 70 02 00 00       	call   8011a3 <printfmt>
  800f33:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f36:	e9 5b 02 00 00       	jmp    801196 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f3b:	56                   	push   %esi
  800f3c:	68 4e 29 80 00       	push   $0x80294e
  800f41:	ff 75 0c             	pushl  0xc(%ebp)
  800f44:	ff 75 08             	pushl  0x8(%ebp)
  800f47:	e8 57 02 00 00       	call   8011a3 <printfmt>
  800f4c:	83 c4 10             	add    $0x10,%esp
			break;
  800f4f:	e9 42 02 00 00       	jmp    801196 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f54:	8b 45 14             	mov    0x14(%ebp),%eax
  800f57:	83 c0 04             	add    $0x4,%eax
  800f5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f60:	83 e8 04             	sub    $0x4,%eax
  800f63:	8b 30                	mov    (%eax),%esi
  800f65:	85 f6                	test   %esi,%esi
  800f67:	75 05                	jne    800f6e <vprintfmt+0x1a6>
				p = "(null)";
  800f69:	be 51 29 80 00       	mov    $0x802951,%esi
			if (width > 0 && padc != '-')
  800f6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f72:	7e 6d                	jle    800fe1 <vprintfmt+0x219>
  800f74:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f78:	74 67                	je     800fe1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f7d:	83 ec 08             	sub    $0x8,%esp
  800f80:	50                   	push   %eax
  800f81:	56                   	push   %esi
  800f82:	e8 1e 03 00 00       	call   8012a5 <strnlen>
  800f87:	83 c4 10             	add    $0x10,%esp
  800f8a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f8d:	eb 16                	jmp    800fa5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f8f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f93:	83 ec 08             	sub    $0x8,%esp
  800f96:	ff 75 0c             	pushl  0xc(%ebp)
  800f99:	50                   	push   %eax
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	ff d0                	call   *%eax
  800f9f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fa2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa9:	7f e4                	jg     800f8f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fab:	eb 34                	jmp    800fe1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fb1:	74 1c                	je     800fcf <vprintfmt+0x207>
  800fb3:	83 fb 1f             	cmp    $0x1f,%ebx
  800fb6:	7e 05                	jle    800fbd <vprintfmt+0x1f5>
  800fb8:	83 fb 7e             	cmp    $0x7e,%ebx
  800fbb:	7e 12                	jle    800fcf <vprintfmt+0x207>
					putch('?', putdat);
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	ff 75 0c             	pushl  0xc(%ebp)
  800fc3:	6a 3f                	push   $0x3f
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	ff d0                	call   *%eax
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	eb 0f                	jmp    800fde <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fcf:	83 ec 08             	sub    $0x8,%esp
  800fd2:	ff 75 0c             	pushl  0xc(%ebp)
  800fd5:	53                   	push   %ebx
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	ff d0                	call   *%eax
  800fdb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fde:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe1:	89 f0                	mov    %esi,%eax
  800fe3:	8d 70 01             	lea    0x1(%eax),%esi
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f be d8             	movsbl %al,%ebx
  800feb:	85 db                	test   %ebx,%ebx
  800fed:	74 24                	je     801013 <vprintfmt+0x24b>
  800fef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ff3:	78 b8                	js     800fad <vprintfmt+0x1e5>
  800ff5:	ff 4d e0             	decl   -0x20(%ebp)
  800ff8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ffc:	79 af                	jns    800fad <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ffe:	eb 13                	jmp    801013 <vprintfmt+0x24b>
				putch(' ', putdat);
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 0c             	pushl  0xc(%ebp)
  801006:	6a 20                	push   $0x20
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	ff d0                	call   *%eax
  80100d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801010:	ff 4d e4             	decl   -0x1c(%ebp)
  801013:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801017:	7f e7                	jg     801000 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801019:	e9 78 01 00 00       	jmp    801196 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	ff 75 e8             	pushl  -0x18(%ebp)
  801024:	8d 45 14             	lea    0x14(%ebp),%eax
  801027:	50                   	push   %eax
  801028:	e8 3c fd ff ff       	call   800d69 <getint>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801033:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103c:	85 d2                	test   %edx,%edx
  80103e:	79 23                	jns    801063 <vprintfmt+0x29b>
				putch('-', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 2d                	push   $0x2d
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801056:	f7 d8                	neg    %eax
  801058:	83 d2 00             	adc    $0x0,%edx
  80105b:	f7 da                	neg    %edx
  80105d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801060:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801063:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80106a:	e9 bc 00 00 00       	jmp    80112b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 84 fc ff ff       	call   800d02 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801087:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80108e:	e9 98 00 00 00       	jmp    80112b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	6a 58                	push   $0x58
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	ff d0                	call   *%eax
  8010a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010a3:	83 ec 08             	sub    $0x8,%esp
  8010a6:	ff 75 0c             	pushl  0xc(%ebp)
  8010a9:	6a 58                	push   $0x58
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	ff d0                	call   *%eax
  8010b0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	6a 58                	push   $0x58
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	ff d0                	call   *%eax
  8010c0:	83 c4 10             	add    $0x10,%esp
			break;
  8010c3:	e9 ce 00 00 00       	jmp    801196 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010c8:	83 ec 08             	sub    $0x8,%esp
  8010cb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ce:	6a 30                	push   $0x30
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	ff d0                	call   *%eax
  8010d5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010d8:	83 ec 08             	sub    $0x8,%esp
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	6a 78                	push   $0x78
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	ff d0                	call   *%eax
  8010e5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	83 c0 04             	add    $0x4,%eax
  8010ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8010f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f4:	83 e8 04             	sub    $0x4,%eax
  8010f7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801103:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80110a:	eb 1f                	jmp    80112b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	ff 75 e8             	pushl  -0x18(%ebp)
  801112:	8d 45 14             	lea    0x14(%ebp),%eax
  801115:	50                   	push   %eax
  801116:	e8 e7 fb ff ff       	call   800d02 <getuint>
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801121:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801124:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80112b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80112f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801132:	83 ec 04             	sub    $0x4,%esp
  801135:	52                   	push   %edx
  801136:	ff 75 e4             	pushl  -0x1c(%ebp)
  801139:	50                   	push   %eax
  80113a:	ff 75 f4             	pushl  -0xc(%ebp)
  80113d:	ff 75 f0             	pushl  -0x10(%ebp)
  801140:	ff 75 0c             	pushl  0xc(%ebp)
  801143:	ff 75 08             	pushl  0x8(%ebp)
  801146:	e8 00 fb ff ff       	call   800c4b <printnum>
  80114b:	83 c4 20             	add    $0x20,%esp
			break;
  80114e:	eb 46                	jmp    801196 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	53                   	push   %ebx
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	ff d0                	call   *%eax
  80115c:	83 c4 10             	add    $0x10,%esp
			break;
  80115f:	eb 35                	jmp    801196 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801161:	c6 05 60 04 b1 00 00 	movb   $0x0,0xb10460
			break;
  801168:	eb 2c                	jmp    801196 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80116a:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
			break;
  801171:	eb 23                	jmp    801196 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801173:	83 ec 08             	sub    $0x8,%esp
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	6a 25                	push   $0x25
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	ff d0                	call   *%eax
  801180:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801183:	ff 4d 10             	decl   0x10(%ebp)
  801186:	eb 03                	jmp    80118b <vprintfmt+0x3c3>
  801188:	ff 4d 10             	decl   0x10(%ebp)
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	48                   	dec    %eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 25                	cmp    $0x25,%al
  801193:	75 f3                	jne    801188 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801195:	90                   	nop
		}
	}
  801196:	e9 35 fc ff ff       	jmp    800dd0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80119b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80119c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ac:	83 c0 04             	add    $0x4,%eax
  8011af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b8:	50                   	push   %eax
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	ff 75 08             	pushl  0x8(%ebp)
  8011bf:	e8 04 fc ff ff       	call   800dc8 <vprintfmt>
  8011c4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011c7:	90                   	nop
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	8b 40 08             	mov    0x8(%eax),%eax
  8011d3:	8d 50 01             	lea    0x1(%eax),%edx
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011df:	8b 10                	mov    (%eax),%edx
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	8b 40 04             	mov    0x4(%eax),%eax
  8011e7:	39 c2                	cmp    %eax,%edx
  8011e9:	73 12                	jae    8011fd <sprintputch+0x33>
		*b->buf++ = ch;
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	8b 00                	mov    (%eax),%eax
  8011f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f6:	89 0a                	mov    %ecx,(%edx)
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	88 10                	mov    %dl,(%eax)
}
  8011fd:	90                   	nop
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80121a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801225:	74 06                	je     80122d <vsnprintf+0x2d>
  801227:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80122b:	7f 07                	jg     801234 <vsnprintf+0x34>
		return -E_INVAL;
  80122d:	b8 03 00 00 00       	mov    $0x3,%eax
  801232:	eb 20                	jmp    801254 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801234:	ff 75 14             	pushl  0x14(%ebp)
  801237:	ff 75 10             	pushl  0x10(%ebp)
  80123a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80123d:	50                   	push   %eax
  80123e:	68 ca 11 80 00       	push   $0x8011ca
  801243:	e8 80 fb ff ff       	call   800dc8 <vprintfmt>
  801248:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80124b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80124e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801251:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80125c:	8d 45 10             	lea    0x10(%ebp),%eax
  80125f:	83 c0 04             	add    $0x4,%eax
  801262:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	ff 75 f4             	pushl  -0xc(%ebp)
  80126b:	50                   	push   %eax
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	ff 75 08             	pushl  0x8(%ebp)
  801272:	e8 89 ff ff ff       	call   801200 <vsnprintf>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801288:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80128f:	eb 06                	jmp    801297 <strlen+0x15>
		n++;
  801291:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	84 c0                	test   %al,%al
  80129e:	75 f1                	jne    801291 <strlen+0xf>
		n++;
	return n;
  8012a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b2:	eb 09                	jmp    8012bd <strnlen+0x18>
		n++;
  8012b4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b7:	ff 45 08             	incl   0x8(%ebp)
  8012ba:	ff 4d 0c             	decl   0xc(%ebp)
  8012bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012c1:	74 09                	je     8012cc <strnlen+0x27>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	84 c0                	test   %al,%al
  8012ca:	75 e8                	jne    8012b4 <strnlen+0xf>
		n++;
	return n;
  8012cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012dd:	90                   	nop
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8d 50 01             	lea    0x1(%eax),%edx
  8012e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012f0:	8a 12                	mov    (%edx),%dl
  8012f2:	88 10                	mov    %dl,(%eax)
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	75 e4                	jne    8012de <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80130b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801312:	eb 1f                	jmp    801333 <strncpy+0x34>
		*dst++ = *src;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8a 12                	mov    (%edx),%dl
  801322:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	84 c0                	test   %al,%al
  80132b:	74 03                	je     801330 <strncpy+0x31>
			src++;
  80132d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801330:	ff 45 fc             	incl   -0x4(%ebp)
  801333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801336:	3b 45 10             	cmp    0x10(%ebp),%eax
  801339:	72 d9                	jb     801314 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80133b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80134c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801350:	74 30                	je     801382 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801352:	eb 16                	jmp    80136a <strlcpy+0x2a>
			*dst++ = *src++;
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	8d 50 01             	lea    0x1(%eax),%edx
  80135a:	89 55 08             	mov    %edx,0x8(%ebp)
  80135d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801360:	8d 4a 01             	lea    0x1(%edx),%ecx
  801363:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801366:	8a 12                	mov    (%edx),%dl
  801368:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80136a:	ff 4d 10             	decl   0x10(%ebp)
  80136d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801371:	74 09                	je     80137c <strlcpy+0x3c>
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	84 c0                	test   %al,%al
  80137a:	75 d8                	jne    801354 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801388:	29 c2                	sub    %eax,%edx
  80138a:	89 d0                	mov    %edx,%eax
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801391:	eb 06                	jmp    801399 <strcmp+0xb>
		p++, q++;
  801393:	ff 45 08             	incl   0x8(%ebp)
  801396:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	84 c0                	test   %al,%al
  8013a0:	74 0e                	je     8013b0 <strcmp+0x22>
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 10                	mov    (%eax),%dl
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	38 c2                	cmp    %al,%dl
  8013ae:	74 e3                	je     801393 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	0f b6 d0             	movzbl %al,%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	0f b6 c0             	movzbl %al,%eax
  8013c0:	29 c2                	sub    %eax,%edx
  8013c2:	89 d0                	mov    %edx,%eax
}
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013c9:	eb 09                	jmp    8013d4 <strncmp+0xe>
		n--, p++, q++;
  8013cb:	ff 4d 10             	decl   0x10(%ebp)
  8013ce:	ff 45 08             	incl   0x8(%ebp)
  8013d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d8:	74 17                	je     8013f1 <strncmp+0x2b>
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	84 c0                	test   %al,%al
  8013e1:	74 0e                	je     8013f1 <strncmp+0x2b>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 10                	mov    (%eax),%dl
  8013e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	38 c2                	cmp    %al,%dl
  8013ef:	74 da                	je     8013cb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f5:	75 07                	jne    8013fe <strncmp+0x38>
		return 0;
  8013f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fc:	eb 14                	jmp    801412 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f b6 d0             	movzbl %al,%edx
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	0f b6 c0             	movzbl %al,%eax
  80140e:	29 c2                	sub    %eax,%edx
  801410:	89 d0                	mov    %edx,%eax
}
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    

00801414 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 04             	sub    $0x4,%esp
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801420:	eb 12                	jmp    801434 <strchr+0x20>
		if (*s == c)
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80142a:	75 05                	jne    801431 <strchr+0x1d>
			return (char *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	eb 11                	jmp    801442 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	75 e5                	jne    801422 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80143d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801450:	eb 0d                	jmp    80145f <strfind+0x1b>
		if (*s == c)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80145a:	74 0e                	je     80146a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80145c:	ff 45 08             	incl   0x8(%ebp)
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	84 c0                	test   %al,%al
  801466:	75 ea                	jne    801452 <strfind+0xe>
  801468:	eb 01                	jmp    80146b <strfind+0x27>
		if (*s == c)
			break;
  80146a:	90                   	nop
	return (char *) s;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80147c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801480:	76 63                	jbe    8014e5 <memset+0x75>
		uint64 data_block = c;
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	99                   	cltd   
  801486:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801489:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801492:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801496:	c1 e0 08             	shl    $0x8,%eax
  801499:	09 45 f0             	or     %eax,-0x10(%ebp)
  80149c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8014a9:	c1 e0 10             	shl    $0x10,%eax
  8014ac:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014af:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b8:	89 c2                	mov    %eax,%edx
  8014ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bf:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014c2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8014c5:	eb 18                	jmp    8014df <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8014c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ca:	8d 41 08             	lea    0x8(%ecx),%eax
  8014cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8014d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d6:	89 01                	mov    %eax,(%ecx)
  8014d8:	89 51 04             	mov    %edx,0x4(%ecx)
  8014db:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8014df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014e3:	77 e2                	ja     8014c7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	74 23                	je     80150e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8014eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014f1:	eb 0e                	jmp    801501 <memset+0x91>
			*p8++ = (uint8)c;
  8014f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f6:	8d 50 01             	lea    0x1(%eax),%edx
  8014f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ff:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e5                	jne    8014f3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801525:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801529:	76 24                	jbe    80154f <memcpy+0x3c>
		while(n >= 8){
  80152b:	eb 1c                	jmp    801549 <memcpy+0x36>
			*d64 = *s64;
  80152d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801530:	8b 50 04             	mov    0x4(%eax),%edx
  801533:	8b 00                	mov    (%eax),%eax
  801535:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801538:	89 01                	mov    %eax,(%ecx)
  80153a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80153d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801541:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801545:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801549:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80154d:	77 de                	ja     80152d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80154f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801553:	74 31                	je     801586 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801555:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801558:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80155b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801561:	eb 16                	jmp    801579 <memcpy+0x66>
			*d8++ = *s8++;
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	8d 50 01             	lea    0x1(%eax),%edx
  801569:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80156c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801572:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801575:	8a 12                	mov    (%edx),%dl
  801577:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801579:	8b 45 10             	mov    0x10(%ebp),%eax
  80157c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157f:	89 55 10             	mov    %edx,0x10(%ebp)
  801582:	85 c0                	test   %eax,%eax
  801584:	75 dd                	jne    801563 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801591:	8b 45 0c             	mov    0xc(%ebp),%eax
  801594:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80159d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015a3:	73 50                	jae    8015f5 <memmove+0x6a>
  8015a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ab:	01 d0                	add    %edx,%eax
  8015ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015b0:	76 43                	jbe    8015f5 <memmove+0x6a>
		s += n;
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015be:	eb 10                	jmp    8015d0 <memmove+0x45>
			*--d = *--s;
  8015c0:	ff 4d f8             	decl   -0x8(%ebp)
  8015c3:	ff 4d fc             	decl   -0x4(%ebp)
  8015c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c9:	8a 10                	mov    (%eax),%dl
  8015cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ce:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 e3                	jne    8015c0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015dd:	eb 23                	jmp    801602 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e2:	8d 50 01             	lea    0x1(%eax),%edx
  8015e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015f1:	8a 12                	mov    (%edx),%dl
  8015f3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8015fe:	85 c0                	test   %eax,%eax
  801600:	75 dd                	jne    8015df <memmove+0x54>
			*d++ = *s++;

	return dst;
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801613:	8b 45 0c             	mov    0xc(%ebp),%eax
  801616:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801619:	eb 2a                	jmp    801645 <memcmp+0x3e>
		if (*s1 != *s2)
  80161b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161e:	8a 10                	mov    (%eax),%dl
  801620:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	38 c2                	cmp    %al,%dl
  801627:	74 16                	je     80163f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801629:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	0f b6 d0             	movzbl %al,%edx
  801631:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	0f b6 c0             	movzbl %al,%eax
  801639:	29 c2                	sub    %eax,%edx
  80163b:	89 d0                	mov    %edx,%eax
  80163d:	eb 18                	jmp    801657 <memcmp+0x50>
		s1++, s2++;
  80163f:	ff 45 fc             	incl   -0x4(%ebp)
  801642:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801645:	8b 45 10             	mov    0x10(%ebp),%eax
  801648:	8d 50 ff             	lea    -0x1(%eax),%edx
  80164b:	89 55 10             	mov    %edx,0x10(%ebp)
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 c9                	jne    80161b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80165f:	8b 55 08             	mov    0x8(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80166a:	eb 15                	jmp    801681 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	0f b6 d0             	movzbl %al,%edx
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	0f b6 c0             	movzbl %al,%eax
  80167a:	39 c2                	cmp    %eax,%edx
  80167c:	74 0d                	je     80168b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80167e:	ff 45 08             	incl   0x8(%ebp)
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801687:	72 e3                	jb     80166c <memfind+0x13>
  801689:	eb 01                	jmp    80168c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80168b:	90                   	nop
	return (void *) s;
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801697:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80169e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016a5:	eb 03                	jmp    8016aa <strtol+0x19>
		s++;
  8016a7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	3c 20                	cmp    $0x20,%al
  8016b1:	74 f4                	je     8016a7 <strtol+0x16>
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	3c 09                	cmp    $0x9,%al
  8016ba:	74 eb                	je     8016a7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2b                	cmp    $0x2b,%al
  8016c3:	75 05                	jne    8016ca <strtol+0x39>
		s++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
  8016c8:	eb 13                	jmp    8016dd <strtol+0x4c>
	else if (*s == '-')
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	3c 2d                	cmp    $0x2d,%al
  8016d1:	75 0a                	jne    8016dd <strtol+0x4c>
		s++, neg = 1;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
  8016d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016e1:	74 06                	je     8016e9 <strtol+0x58>
  8016e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016e7:	75 20                	jne    801709 <strtol+0x78>
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	3c 30                	cmp    $0x30,%al
  8016f0:	75 17                	jne    801709 <strtol+0x78>
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	40                   	inc    %eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	3c 78                	cmp    $0x78,%al
  8016fa:	75 0d                	jne    801709 <strtol+0x78>
		s += 2, base = 16;
  8016fc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801700:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801707:	eb 28                	jmp    801731 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	75 15                	jne    801724 <strtol+0x93>
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	3c 30                	cmp    $0x30,%al
  801716:	75 0c                	jne    801724 <strtol+0x93>
		s++, base = 8;
  801718:	ff 45 08             	incl   0x8(%ebp)
  80171b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801722:	eb 0d                	jmp    801731 <strtol+0xa0>
	else if (base == 0)
  801724:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801728:	75 07                	jne    801731 <strtol+0xa0>
		base = 10;
  80172a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8a 00                	mov    (%eax),%al
  801736:	3c 2f                	cmp    $0x2f,%al
  801738:	7e 19                	jle    801753 <strtol+0xc2>
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	3c 39                	cmp    $0x39,%al
  801741:	7f 10                	jg     801753 <strtol+0xc2>
			dig = *s - '0';
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8a 00                	mov    (%eax),%al
  801748:	0f be c0             	movsbl %al,%eax
  80174b:	83 e8 30             	sub    $0x30,%eax
  80174e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801751:	eb 42                	jmp    801795 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8a 00                	mov    (%eax),%al
  801758:	3c 60                	cmp    $0x60,%al
  80175a:	7e 19                	jle    801775 <strtol+0xe4>
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	3c 7a                	cmp    $0x7a,%al
  801763:	7f 10                	jg     801775 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	8a 00                	mov    (%eax),%al
  80176a:	0f be c0             	movsbl %al,%eax
  80176d:	83 e8 57             	sub    $0x57,%eax
  801770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801773:	eb 20                	jmp    801795 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	3c 40                	cmp    $0x40,%al
  80177c:	7e 39                	jle    8017b7 <strtol+0x126>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 00                	mov    (%eax),%al
  801783:	3c 5a                	cmp    $0x5a,%al
  801785:	7f 30                	jg     8017b7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8a 00                	mov    (%eax),%al
  80178c:	0f be c0             	movsbl %al,%eax
  80178f:	83 e8 37             	sub    $0x37,%eax
  801792:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801798:	3b 45 10             	cmp    0x10(%ebp),%eax
  80179b:	7d 19                	jge    8017b6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80179d:	ff 45 08             	incl   0x8(%ebp)
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017a7:	89 c2                	mov    %eax,%edx
  8017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ac:	01 d0                	add    %edx,%eax
  8017ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017b1:	e9 7b ff ff ff       	jmp    801731 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017b6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017bb:	74 08                	je     8017c5 <strtol+0x134>
		*endptr = (char *) s;
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017c9:	74 07                	je     8017d2 <strtol+0x141>
  8017cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ce:	f7 d8                	neg    %eax
  8017d0:	eb 03                	jmp    8017d5 <strtol+0x144>
  8017d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <ltostr>:

void
ltostr(long value, char *str)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017ef:	79 13                	jns    801804 <ltostr+0x2d>
	{
		neg = 1;
  8017f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017fe:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801801:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80180c:	99                   	cltd   
  80180d:	f7 f9                	idiv   %ecx
  80180f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	89 c2                	mov    %eax,%edx
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	01 d0                	add    %edx,%eax
  801822:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801825:	83 c2 30             	add    $0x30,%edx
  801828:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80182a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801832:	f7 e9                	imul   %ecx
  801834:	c1 fa 02             	sar    $0x2,%edx
  801837:	89 c8                	mov    %ecx,%eax
  801839:	c1 f8 1f             	sar    $0x1f,%eax
  80183c:	29 c2                	sub    %eax,%edx
  80183e:	89 d0                	mov    %edx,%eax
  801840:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801843:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801847:	75 bb                	jne    801804 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801850:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801853:	48                   	dec    %eax
  801854:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801857:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80185b:	74 3d                	je     80189a <ltostr+0xc3>
		start = 1 ;
  80185d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801864:	eb 34                	jmp    80189a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801866:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186c:	01 d0                	add    %edx,%eax
  80186e:	8a 00                	mov    (%eax),%al
  801870:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801873:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801876:	8b 45 0c             	mov    0xc(%ebp),%eax
  801879:	01 c2                	add    %eax,%edx
  80187b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	01 c8                	add    %ecx,%eax
  801883:	8a 00                	mov    (%eax),%al
  801885:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801887:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80188a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188d:	01 c2                	add    %eax,%edx
  80188f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801892:	88 02                	mov    %al,(%edx)
		start++ ;
  801894:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801897:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a0:	7c c4                	jl     801866 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a8:	01 d0                	add    %edx,%eax
  8018aa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018ad:	90                   	nop
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	e8 c4 f9 ff ff       	call   801282 <strlen>
  8018be:	83 c4 04             	add    $0x4,%esp
  8018c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	e8 b6 f9 ff ff       	call   801282 <strlen>
  8018cc:	83 c4 04             	add    $0x4,%esp
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018e0:	eb 17                	jmp    8018f9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 c2                	add    %eax,%edx
  8018ea:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	01 c8                	add    %ecx,%eax
  8018f2:	8a 00                	mov    (%eax),%al
  8018f4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018f6:	ff 45 fc             	incl   -0x4(%ebp)
  8018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ff:	7c e1                	jl     8018e2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801901:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801908:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80190f:	eb 1f                	jmp    801930 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801911:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801914:	8d 50 01             	lea    0x1(%eax),%edx
  801917:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80191a:	89 c2                	mov    %eax,%edx
  80191c:	8b 45 10             	mov    0x10(%ebp),%eax
  80191f:	01 c2                	add    %eax,%edx
  801921:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801924:	8b 45 0c             	mov    0xc(%ebp),%eax
  801927:	01 c8                	add    %ecx,%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80192d:	ff 45 f8             	incl   -0x8(%ebp)
  801930:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801933:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801936:	7c d9                	jl     801911 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801938:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80193b:	8b 45 10             	mov    0x10(%ebp),%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	c6 00 00             	movb   $0x0,(%eax)
}
  801943:	90                   	nop
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801949:	8b 45 14             	mov    0x14(%ebp),%eax
  80194c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801952:	8b 45 14             	mov    0x14(%ebp),%eax
  801955:	8b 00                	mov    (%eax),%eax
  801957:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80195e:	8b 45 10             	mov    0x10(%ebp),%eax
  801961:	01 d0                	add    %edx,%eax
  801963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801969:	eb 0c                	jmp    801977 <strsplit+0x31>
			*string++ = 0;
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8d 50 01             	lea    0x1(%eax),%edx
  801971:	89 55 08             	mov    %edx,0x8(%ebp)
  801974:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8a 00                	mov    (%eax),%al
  80197c:	84 c0                	test   %al,%al
  80197e:	74 18                	je     801998 <strsplit+0x52>
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	8a 00                	mov    (%eax),%al
  801985:	0f be c0             	movsbl %al,%eax
  801988:	50                   	push   %eax
  801989:	ff 75 0c             	pushl  0xc(%ebp)
  80198c:	e8 83 fa ff ff       	call   801414 <strchr>
  801991:	83 c4 08             	add    $0x8,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	75 d3                	jne    80196b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	84 c0                	test   %al,%al
  80199f:	74 5a                	je     8019fb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a4:	8b 00                	mov    (%eax),%eax
  8019a6:	83 f8 0f             	cmp    $0xf,%eax
  8019a9:	75 07                	jne    8019b2 <strsplit+0x6c>
		{
			return 0;
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	eb 66                	jmp    801a18 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b5:	8b 00                	mov    (%eax),%eax
  8019b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8019ba:	8b 55 14             	mov    0x14(%ebp),%edx
  8019bd:	89 0a                	mov    %ecx,(%edx)
  8019bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c9:	01 c2                	add    %eax,%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019d0:	eb 03                	jmp    8019d5 <strsplit+0x8f>
			string++;
  8019d2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	74 8b                	je     801969 <strsplit+0x23>
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	8a 00                	mov    (%eax),%al
  8019e3:	0f be c0             	movsbl %al,%eax
  8019e6:	50                   	push   %eax
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	e8 25 fa ff ff       	call   801414 <strchr>
  8019ef:	83 c4 08             	add    $0x8,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	74 dc                	je     8019d2 <strsplit+0x8c>
			string++;
	}
  8019f6:	e9 6e ff ff ff       	jmp    801969 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019fb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ff:	8b 00                	mov    (%eax),%eax
  801a01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a08:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0b:	01 d0                	add    %edx,%eax
  801a0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a13:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a2d:	eb 4a                	jmp    801a79 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	01 c2                	add    %eax,%edx
  801a37:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	01 c8                	add    %ecx,%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	3c 40                	cmp    $0x40,%al
  801a4f:	7e 25                	jle    801a76 <str2lower+0x5c>
  801a51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a57:	01 d0                	add    %edx,%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	3c 5a                	cmp    $0x5a,%al
  801a5d:	7f 17                	jg     801a76 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801a5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	01 d0                	add    %edx,%eax
  801a67:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6d:	01 ca                	add    %ecx,%edx
  801a6f:	8a 12                	mov    (%edx),%dl
  801a71:	83 c2 20             	add    $0x20,%edx
  801a74:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801a76:	ff 45 fc             	incl   -0x4(%ebp)
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	e8 01 f8 ff ff       	call   801282 <strlen>
  801a81:	83 c4 04             	add    $0x4,%esp
  801a84:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a87:	7f a6                	jg     801a2f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801aa6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801aa9:	cd 30                	int    $0x30
  801aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801ac5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	51                   	push   %ecx
  801ad2:	52                   	push   %edx
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	50                   	push   %eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	e8 b0 ff ff ff       	call   801a8e <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 02                	push   $0x2
  801af3:	e8 96 ff ff ff       	call   801a8e <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_lock_cons>:

void sys_lock_cons(void)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 03                	push   $0x3
  801b0c:	e8 7d ff ff ff       	call   801a8e <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 04                	push   $0x4
  801b26:	e8 63 ff ff ff       	call   801a8e <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 08                	push   $0x8
  801b44:	e8 45 ff ff ff       	call   801a8e <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	56                   	push   %esi
  801b52:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b53:	8b 75 18             	mov    0x18(%ebp),%esi
  801b56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	51                   	push   %ecx
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 09                	push   $0x9
  801b69:	e8 20 ff ff ff       	call   801a8e <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b74:	5b                   	pop    %ebx
  801b75:	5e                   	pop    %esi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    

00801b78 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	6a 0a                	push   $0xa
  801b88:	e8 01 ff ff ff       	call   801a8e <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	6a 0b                	push   $0xb
  801ba3:	e8 e6 fe ff ff       	call   801a8e <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 0c                	push   $0xc
  801bbc:	e8 cd fe ff ff       	call   801a8e <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 0d                	push   $0xd
  801bd5:	e8 b4 fe ff ff       	call   801a8e <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 0e                	push   $0xe
  801bee:	e8 9b fe ff ff       	call   801a8e <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 0f                	push   $0xf
  801c07:	e8 82 fe ff ff       	call   801a8e <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 10                	push   $0x10
  801c21:	e8 68 fe ff ff       	call   801a8e <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 11                	push   $0x11
  801c3a:	e8 4f fe ff ff       	call   801a8e <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	50                   	push   %eax
  801c5e:	6a 01                	push   $0x1
  801c60:	e8 29 fe ff ff       	call   801a8e <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 14                	push   $0x14
  801c7a:	e8 0f fe ff ff       	call   801a8e <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	90                   	nop
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c91:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c94:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	51                   	push   %ecx
  801c9e:	52                   	push   %edx
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	50                   	push   %eax
  801ca3:	6a 15                	push   $0x15
  801ca5:	e8 e4 fd ff ff       	call   801a8e <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 16                	push   $0x16
  801cc2:	e8 c7 fd ff ff       	call   801a8e <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ccf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	51                   	push   %ecx
  801cdd:	52                   	push   %edx
  801cde:	50                   	push   %eax
  801cdf:	6a 17                	push   $0x17
  801ce1:	e8 a8 fd ff ff       	call   801a8e <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	52                   	push   %edx
  801cfb:	50                   	push   %eax
  801cfc:	6a 18                	push   $0x18
  801cfe:	e8 8b fd ff ff       	call   801a8e <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	ff 75 14             	pushl  0x14(%ebp)
  801d13:	ff 75 10             	pushl  0x10(%ebp)
  801d16:	ff 75 0c             	pushl  0xc(%ebp)
  801d19:	50                   	push   %eax
  801d1a:	6a 19                	push   $0x19
  801d1c:	e8 6d fd ff ff       	call   801a8e <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	50                   	push   %eax
  801d35:	6a 1a                	push   $0x1a
  801d37:	e8 52 fd ff ff       	call   801a8e <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	90                   	nop
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	50                   	push   %eax
  801d51:	6a 1b                	push   $0x1b
  801d53:	e8 36 fd ff ff       	call   801a8e <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 05                	push   $0x5
  801d6c:	e8 1d fd ff ff       	call   801a8e <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 06                	push   $0x6
  801d85:	e8 04 fd ff ff       	call   801a8e <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 07                	push   $0x7
  801d9e:	e8 eb fc ff ff       	call   801a8e <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_exit_env>:


void sys_exit_env(void)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 1c                	push   $0x1c
  801db7:	e8 d2 fc ff ff       	call   801a8e <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
}
  801dbf:	90                   	nop
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dc8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dcb:	8d 50 04             	lea    0x4(%eax),%edx
  801dce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	52                   	push   %edx
  801dd8:	50                   	push   %eax
  801dd9:	6a 1d                	push   $0x1d
  801ddb:	e8 ae fc ff ff       	call   801a8e <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return result;
  801de3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801de9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dec:	89 01                	mov    %eax,(%ecx)
  801dee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	c9                   	leave  
  801df5:	c2 04 00             	ret    $0x4

00801df8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	ff 75 10             	pushl  0x10(%ebp)
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	ff 75 08             	pushl  0x8(%ebp)
  801e08:	6a 13                	push   $0x13
  801e0a:	e8 7f fc ff ff       	call   801a8e <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e12:	90                   	nop
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 1e                	push   $0x1e
  801e24:	e8 65 fc ff ff       	call   801a8e <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e3a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	50                   	push   %eax
  801e47:	6a 1f                	push   $0x1f
  801e49:	e8 40 fc ff ff       	call   801a8e <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e51:	90                   	nop
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <rsttst>:
void rsttst()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 21                	push   $0x21
  801e63:	e8 26 fc ff ff       	call   801a8e <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6b:	90                   	nop
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	8b 45 14             	mov    0x14(%ebp),%eax
  801e77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e7a:	8b 55 18             	mov    0x18(%ebp),%edx
  801e7d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e81:	52                   	push   %edx
  801e82:	50                   	push   %eax
  801e83:	ff 75 10             	pushl  0x10(%ebp)
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	6a 20                	push   $0x20
  801e8e:	e8 fb fb ff ff       	call   801a8e <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
	return ;
  801e96:	90                   	nop
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <chktst>:
void chktst(uint32 n)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	6a 22                	push   $0x22
  801ea9:	e8 e0 fb ff ff       	call   801a8e <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb1:	90                   	nop
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <inctst>:

void inctst()
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 23                	push   $0x23
  801ec3:	e8 c6 fb ff ff       	call   801a8e <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecb:	90                   	nop
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <gettst>:
uint32 gettst()
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 24                	push   $0x24
  801edd:	e8 ac fb ff ff       	call   801a8e <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 25                	push   $0x25
  801ef6:	e8 93 fb ff ff       	call   801a8e <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
  801efe:	a3 80 84 b2 00       	mov    %eax,0xb28480
	return uheapPlaceStrategy ;
  801f03:	a1 80 84 b2 00       	mov    0xb28480,%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	a3 80 84 b2 00       	mov    %eax,0xb28480
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	ff 75 08             	pushl  0x8(%ebp)
  801f20:	6a 26                	push   $0x26
  801f22:	e8 67 fb ff ff       	call   801a8e <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2a:	90                   	nop
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	6a 00                	push   $0x0
  801f3f:	53                   	push   %ebx
  801f40:	51                   	push   %ecx
  801f41:	52                   	push   %edx
  801f42:	50                   	push   %eax
  801f43:	6a 27                	push   $0x27
  801f45:	e8 44 fb ff ff       	call   801a8e <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	52                   	push   %edx
  801f62:	50                   	push   %eax
  801f63:	6a 28                	push   $0x28
  801f65:	e8 24 fb ff ff       	call   801a8e <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	51                   	push   %ecx
  801f7e:	ff 75 10             	pushl  0x10(%ebp)
  801f81:	52                   	push   %edx
  801f82:	50                   	push   %eax
  801f83:	6a 29                	push   $0x29
  801f85:	e8 04 fb ff ff       	call   801a8e <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	ff 75 10             	pushl  0x10(%ebp)
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	ff 75 08             	pushl  0x8(%ebp)
  801f9f:	6a 12                	push   $0x12
  801fa1:	e8 e8 fa ff ff       	call   801a8e <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa9:	90                   	nop
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	6a 2a                	push   $0x2a
  801fbf:	e8 ca fa ff ff       	call   801a8e <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
	return;
  801fc7:	90                   	nop
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 2b                	push   $0x2b
  801fd9:	e8 b0 fa ff ff       	call   801a8e <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	6a 2d                	push   $0x2d
  801ff4:	e8 95 fa ff ff       	call   801a8e <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 2c                	push   $0x2c
  802010:	e8 79 fa ff ff       	call   801a8e <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return ;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80201e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	52                   	push   %edx
  80202b:	50                   	push   %eax
  80202c:	6a 2e                	push   $0x2e
  80202e:	e8 5b fa ff ff       	call   801a8e <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
	return ;
  802036:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    
  802039:	66 90                	xchg   %ax,%ax
  80203b:	90                   	nop

0080203c <__udivdi3>:
  80203c:	55                   	push   %ebp
  80203d:	57                   	push   %edi
  80203e:	56                   	push   %esi
  80203f:	53                   	push   %ebx
  802040:	83 ec 1c             	sub    $0x1c,%esp
  802043:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802047:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80204b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80204f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802053:	89 ca                	mov    %ecx,%edx
  802055:	89 f8                	mov    %edi,%eax
  802057:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80205b:	85 f6                	test   %esi,%esi
  80205d:	75 2d                	jne    80208c <__udivdi3+0x50>
  80205f:	39 cf                	cmp    %ecx,%edi
  802061:	77 65                	ja     8020c8 <__udivdi3+0x8c>
  802063:	89 fd                	mov    %edi,%ebp
  802065:	85 ff                	test   %edi,%edi
  802067:	75 0b                	jne    802074 <__udivdi3+0x38>
  802069:	b8 01 00 00 00       	mov    $0x1,%eax
  80206e:	31 d2                	xor    %edx,%edx
  802070:	f7 f7                	div    %edi
  802072:	89 c5                	mov    %eax,%ebp
  802074:	31 d2                	xor    %edx,%edx
  802076:	89 c8                	mov    %ecx,%eax
  802078:	f7 f5                	div    %ebp
  80207a:	89 c1                	mov    %eax,%ecx
  80207c:	89 d8                	mov    %ebx,%eax
  80207e:	f7 f5                	div    %ebp
  802080:	89 cf                	mov    %ecx,%edi
  802082:	89 fa                	mov    %edi,%edx
  802084:	83 c4 1c             	add    $0x1c,%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5f                   	pop    %edi
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    
  80208c:	39 ce                	cmp    %ecx,%esi
  80208e:	77 28                	ja     8020b8 <__udivdi3+0x7c>
  802090:	0f bd fe             	bsr    %esi,%edi
  802093:	83 f7 1f             	xor    $0x1f,%edi
  802096:	75 40                	jne    8020d8 <__udivdi3+0x9c>
  802098:	39 ce                	cmp    %ecx,%esi
  80209a:	72 0a                	jb     8020a6 <__udivdi3+0x6a>
  80209c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8020a0:	0f 87 9e 00 00 00    	ja     802144 <__udivdi3+0x108>
  8020a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ab:	89 fa                	mov    %edi,%edx
  8020ad:	83 c4 1c             	add    $0x1c,%esp
  8020b0:	5b                   	pop    %ebx
  8020b1:	5e                   	pop    %esi
  8020b2:	5f                   	pop    %edi
  8020b3:	5d                   	pop    %ebp
  8020b4:	c3                   	ret    
  8020b5:	8d 76 00             	lea    0x0(%esi),%esi
  8020b8:	31 ff                	xor    %edi,%edi
  8020ba:	31 c0                	xor    %eax,%eax
  8020bc:	89 fa                	mov    %edi,%edx
  8020be:	83 c4 1c             	add    $0x1c,%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5f                   	pop    %edi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    
  8020c6:	66 90                	xchg   %ax,%ax
  8020c8:	89 d8                	mov    %ebx,%eax
  8020ca:	f7 f7                	div    %edi
  8020cc:	31 ff                	xor    %edi,%edi
  8020ce:	89 fa                	mov    %edi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020dd:	89 eb                	mov    %ebp,%ebx
  8020df:	29 fb                	sub    %edi,%ebx
  8020e1:	89 f9                	mov    %edi,%ecx
  8020e3:	d3 e6                	shl    %cl,%esi
  8020e5:	89 c5                	mov    %eax,%ebp
  8020e7:	88 d9                	mov    %bl,%cl
  8020e9:	d3 ed                	shr    %cl,%ebp
  8020eb:	89 e9                	mov    %ebp,%ecx
  8020ed:	09 f1                	or     %esi,%ecx
  8020ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020f3:	89 f9                	mov    %edi,%ecx
  8020f5:	d3 e0                	shl    %cl,%eax
  8020f7:	89 c5                	mov    %eax,%ebp
  8020f9:	89 d6                	mov    %edx,%esi
  8020fb:	88 d9                	mov    %bl,%cl
  8020fd:	d3 ee                	shr    %cl,%esi
  8020ff:	89 f9                	mov    %edi,%ecx
  802101:	d3 e2                	shl    %cl,%edx
  802103:	8b 44 24 08          	mov    0x8(%esp),%eax
  802107:	88 d9                	mov    %bl,%cl
  802109:	d3 e8                	shr    %cl,%eax
  80210b:	09 c2                	or     %eax,%edx
  80210d:	89 d0                	mov    %edx,%eax
  80210f:	89 f2                	mov    %esi,%edx
  802111:	f7 74 24 0c          	divl   0xc(%esp)
  802115:	89 d6                	mov    %edx,%esi
  802117:	89 c3                	mov    %eax,%ebx
  802119:	f7 e5                	mul    %ebp
  80211b:	39 d6                	cmp    %edx,%esi
  80211d:	72 19                	jb     802138 <__udivdi3+0xfc>
  80211f:	74 0b                	je     80212c <__udivdi3+0xf0>
  802121:	89 d8                	mov    %ebx,%eax
  802123:	31 ff                	xor    %edi,%edi
  802125:	e9 58 ff ff ff       	jmp    802082 <__udivdi3+0x46>
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802130:	89 f9                	mov    %edi,%ecx
  802132:	d3 e2                	shl    %cl,%edx
  802134:	39 c2                	cmp    %eax,%edx
  802136:	73 e9                	jae    802121 <__udivdi3+0xe5>
  802138:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80213b:	31 ff                	xor    %edi,%edi
  80213d:	e9 40 ff ff ff       	jmp    802082 <__udivdi3+0x46>
  802142:	66 90                	xchg   %ax,%ax
  802144:	31 c0                	xor    %eax,%eax
  802146:	e9 37 ff ff ff       	jmp    802082 <__udivdi3+0x46>
  80214b:	90                   	nop

0080214c <__umoddi3>:
  80214c:	55                   	push   %ebp
  80214d:	57                   	push   %edi
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	83 ec 1c             	sub    $0x1c,%esp
  802153:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802157:	8b 74 24 34          	mov    0x34(%esp),%esi
  80215b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80215f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802163:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802167:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80216b:	89 f3                	mov    %esi,%ebx
  80216d:	89 fa                	mov    %edi,%edx
  80216f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802173:	89 34 24             	mov    %esi,(%esp)
  802176:	85 c0                	test   %eax,%eax
  802178:	75 1a                	jne    802194 <__umoddi3+0x48>
  80217a:	39 f7                	cmp    %esi,%edi
  80217c:	0f 86 a2 00 00 00    	jbe    802224 <__umoddi3+0xd8>
  802182:	89 c8                	mov    %ecx,%eax
  802184:	89 f2                	mov    %esi,%edx
  802186:	f7 f7                	div    %edi
  802188:	89 d0                	mov    %edx,%eax
  80218a:	31 d2                	xor    %edx,%edx
  80218c:	83 c4 1c             	add    $0x1c,%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    
  802194:	39 f0                	cmp    %esi,%eax
  802196:	0f 87 ac 00 00 00    	ja     802248 <__umoddi3+0xfc>
  80219c:	0f bd e8             	bsr    %eax,%ebp
  80219f:	83 f5 1f             	xor    $0x1f,%ebp
  8021a2:	0f 84 ac 00 00 00    	je     802254 <__umoddi3+0x108>
  8021a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8021ad:	29 ef                	sub    %ebp,%edi
  8021af:	89 fe                	mov    %edi,%esi
  8021b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021b5:	89 e9                	mov    %ebp,%ecx
  8021b7:	d3 e0                	shl    %cl,%eax
  8021b9:	89 d7                	mov    %edx,%edi
  8021bb:	89 f1                	mov    %esi,%ecx
  8021bd:	d3 ef                	shr    %cl,%edi
  8021bf:	09 c7                	or     %eax,%edi
  8021c1:	89 e9                	mov    %ebp,%ecx
  8021c3:	d3 e2                	shl    %cl,%edx
  8021c5:	89 14 24             	mov    %edx,(%esp)
  8021c8:	89 d8                	mov    %ebx,%eax
  8021ca:	d3 e0                	shl    %cl,%eax
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021d2:	d3 e0                	shl    %cl,%eax
  8021d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021dc:	89 f1                	mov    %esi,%ecx
  8021de:	d3 e8                	shr    %cl,%eax
  8021e0:	09 d0                	or     %edx,%eax
  8021e2:	d3 eb                	shr    %cl,%ebx
  8021e4:	89 da                	mov    %ebx,%edx
  8021e6:	f7 f7                	div    %edi
  8021e8:	89 d3                	mov    %edx,%ebx
  8021ea:	f7 24 24             	mull   (%esp)
  8021ed:	89 c6                	mov    %eax,%esi
  8021ef:	89 d1                	mov    %edx,%ecx
  8021f1:	39 d3                	cmp    %edx,%ebx
  8021f3:	0f 82 87 00 00 00    	jb     802280 <__umoddi3+0x134>
  8021f9:	0f 84 91 00 00 00    	je     802290 <__umoddi3+0x144>
  8021ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  802203:	29 f2                	sub    %esi,%edx
  802205:	19 cb                	sbb    %ecx,%ebx
  802207:	89 d8                	mov    %ebx,%eax
  802209:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80220d:	d3 e0                	shl    %cl,%eax
  80220f:	89 e9                	mov    %ebp,%ecx
  802211:	d3 ea                	shr    %cl,%edx
  802213:	09 d0                	or     %edx,%eax
  802215:	89 e9                	mov    %ebp,%ecx
  802217:	d3 eb                	shr    %cl,%ebx
  802219:	89 da                	mov    %ebx,%edx
  80221b:	83 c4 1c             	add    $0x1c,%esp
  80221e:	5b                   	pop    %ebx
  80221f:	5e                   	pop    %esi
  802220:	5f                   	pop    %edi
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    
  802223:	90                   	nop
  802224:	89 fd                	mov    %edi,%ebp
  802226:	85 ff                	test   %edi,%edi
  802228:	75 0b                	jne    802235 <__umoddi3+0xe9>
  80222a:	b8 01 00 00 00       	mov    $0x1,%eax
  80222f:	31 d2                	xor    %edx,%edx
  802231:	f7 f7                	div    %edi
  802233:	89 c5                	mov    %eax,%ebp
  802235:	89 f0                	mov    %esi,%eax
  802237:	31 d2                	xor    %edx,%edx
  802239:	f7 f5                	div    %ebp
  80223b:	89 c8                	mov    %ecx,%eax
  80223d:	f7 f5                	div    %ebp
  80223f:	89 d0                	mov    %edx,%eax
  802241:	e9 44 ff ff ff       	jmp    80218a <__umoddi3+0x3e>
  802246:	66 90                	xchg   %ax,%ax
  802248:	89 c8                	mov    %ecx,%eax
  80224a:	89 f2                	mov    %esi,%edx
  80224c:	83 c4 1c             	add    $0x1c,%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5f                   	pop    %edi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    
  802254:	3b 04 24             	cmp    (%esp),%eax
  802257:	72 06                	jb     80225f <__umoddi3+0x113>
  802259:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80225d:	77 0f                	ja     80226e <__umoddi3+0x122>
  80225f:	89 f2                	mov    %esi,%edx
  802261:	29 f9                	sub    %edi,%ecx
  802263:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802267:	89 14 24             	mov    %edx,(%esp)
  80226a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80226e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802272:	8b 14 24             	mov    (%esp),%edx
  802275:	83 c4 1c             	add    $0x1c,%esp
  802278:	5b                   	pop    %ebx
  802279:	5e                   	pop    %esi
  80227a:	5f                   	pop    %edi
  80227b:	5d                   	pop    %ebp
  80227c:	c3                   	ret    
  80227d:	8d 76 00             	lea    0x0(%esi),%esi
  802280:	2b 04 24             	sub    (%esp),%eax
  802283:	19 fa                	sbb    %edi,%edx
  802285:	89 d1                	mov    %edx,%ecx
  802287:	89 c6                	mov    %eax,%esi
  802289:	e9 71 ff ff ff       	jmp    8021ff <__umoddi3+0xb3>
  80228e:	66 90                	xchg   %ax,%ax
  802290:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802294:	72 ea                	jb     802280 <__umoddi3+0x134>
  802296:	89 d9                	mov    %ebx,%ecx
  802298:	e9 62 ff ff ff       	jmp    8021ff <__umoddi3+0xb3>
