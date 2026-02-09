
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 e6 07 00 00       	call   80081c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_lock_cons();
  80004c:	e8 cd 2a 00 00       	call   802b1e <sys_lock_cons>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 e0 3f 80 00       	push   $0x803fe0
  800060:	e8 2e 13 00 00       	call   801393 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 2f 19 00 00       	call   8019aa <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 5d 24 00 00       	call   8024ed <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 18 2b 00 00       	call   802bce <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 2a 2b 00 00       	call   802be7 <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 00 40 80 00       	push   $0x804000
  8000e7:	e8 ce 0b 00 00       	call   800cba <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 23 40 80 00       	push   $0x804023
  8000f7:	e8 be 0b 00 00       	call   800cba <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 31 40 80 00       	push   $0x804031
  800107:	e8 ae 0b 00 00       	call   800cba <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 40 40 80 00       	push   $0x804040
  800117:	e8 9e 0b 00 00       	call   800cba <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 50 40 80 00       	push   $0x804050
  800127:	e8 8e 0b 00 00       	call   800cba <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 cb 06 00 00       	call   8007ff <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 9c 06 00 00       	call   8007e0 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 8f 06 00 00       	call   8007e0 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_unlock_cons();
  800166:	e8 cd 29 00 00       	call   802b38 <sys_unlock_cons>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 1c 05 00 00       	call   8006a8 <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 3a 05 00 00       	call   8006d9 <InitializeIdentical>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 5c 05 00 00       	call   80070e <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 49 05 00 00       	call   80070e <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 17 03 00 00       	call   8004ed <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 17 04 00 00       	call   8005fe <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 5c 40 80 00       	push   $0x80405c
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 7e 40 80 00       	push   $0x80407e
  800202:	e8 c5 07 00 00       	call   8009cc <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 9c 40 80 00       	push   $0x80409c
  80020f:	e8 a6 0a 00 00       	call   800cba <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 d0 40 80 00       	push   $0x8040d0
  80021f:	e8 96 0a 00 00       	call   800cba <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 04 41 80 00       	push   $0x804104
  80022f:	e8 86 0a 00 00       	call   800cba <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 36 41 80 00       	push   $0x804136
  80023f:	e8 76 0a 00 00       	call   800cba <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 1f 24 00 00       	call   802671 <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 4c 41 80 00       	push   $0x80414c
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 7e 40 80 00       	push   $0x80407e
  800282:	e8 45 07 00 00       	call   8009cc <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 2e 29 00 00       	call   802bce <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 40 29 00 00       	call   802be7 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 9c 41 80 00       	push   $0x80419c
  8002c5:	68 c1 41 80 00       	push   $0x8041c1
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 7e 40 80 00       	push   $0x80407e
  8002d1:	e8 f6 06 00 00       	call   8009cc <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 4c 41 80 00       	push   $0x80414c
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 7e 40 80 00       	push   $0x80407e
  8002fa:	e8 cd 06 00 00       	call   8009cc <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 b6 28 00 00       	call   802bce <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 c8 28 00 00       	call   802be7 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 9c 41 80 00       	push   $0x80419c
  80033d:	68 c1 41 80 00       	push   $0x8041c1
  800342:	6a 77                	push   $0x77
  800344:	68 7e 40 80 00       	push   $0x80407e
  800349:	e8 7e 06 00 00       	call   8009cc <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 4c 41 80 00       	push   $0x80414c
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 7e 40 80 00       	push   $0x80407e
  800372:	e8 55 06 00 00       	call   8009cc <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 3e 28 00 00       	call   802bce <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 50 28 00 00       	call   802be7 <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 9c 41 80 00       	push   $0x80419c
  8003b1:	68 c1 41 80 00       	push   $0x8041c1
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 7e 40 80 00       	push   $0x80407e
  8003c0:	e8 07 06 00 00       	call   8009cc <_panic>
		}
		///========================================================================
	sys_lock_cons();
  8003c5:	e8 54 27 00 00       	call   802b1e <sys_lock_cons>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 d6 41 80 00       	push   $0x8041d6
  8003d8:	e8 dd 08 00 00       	call   800cba <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 1a 04 00 00       	call   8007ff <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 eb 03 00 00       	call   8007e0 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 de 03 00 00       	call   8007e0 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 d1 03 00 00       	call   8007e0 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_unlock_cons();
  80041e:	e8 15 27 00 00       	call   802b38 <sys_unlock_cons>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	53                   	push   %ebx
  800437:	83 ec 14             	sub    $0x14,%esp
	int numOFEmptyLocInWS = 0, i;
  80043a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800441:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800448:	e9 84 00 00 00       	jmp    8004d1 <CheckAndCountEmptyLocInWS+0x9e>
	{
		if (myEnv->__uptr_pws[i].empty)
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800456:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800459:	89 d0                	mov    %edx,%eax
  80045b:	01 c0                	add    %eax,%eax
  80045d:	01 d0                	add    %edx,%eax
  80045f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800466:	01 d8                	add    %ebx,%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	01 c8                	add    %ecx,%eax
  80046c:	8a 40 04             	mov    0x4(%eax),%al
  80046f:	84 c0                	test   %al,%al
  800471:	74 05                	je     800478 <CheckAndCountEmptyLocInWS+0x45>
		{
			numOFEmptyLocInWS++;
  800473:	ff 45 f4             	incl   -0xc(%ebp)
  800476:	eb 56                	jmp    8004ce <CheckAndCountEmptyLocInWS+0x9b>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	01 d0                	add    %edx,%eax
  80048a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800491:	01 d8                	add    %ebx,%eax
  800493:	01 d0                	add    %edx,%eax
  800495:	01 c8                	add    %ecx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80049c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  8004a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004aa:	85 c0                	test   %eax,%eax
  8004ac:	79 20                	jns    8004ce <CheckAndCountEmptyLocInWS+0x9b>
  8004ae:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004b5:	77 17                	ja     8004ce <CheckAndCountEmptyLocInWS+0x9b>
				panic("freeMem didn't remove its page(s) from the WS");
  8004b7:	83 ec 04             	sub    $0x4,%esp
  8004ba:	68 f4 41 80 00       	push   $0x8041f4
  8004bf:	68 a0 00 00 00       	push   $0xa0
  8004c4:	68 7e 40 80 00       	push   $0x80407e
  8004c9:	e8 fe 04 00 00       	call   8009cc <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ce:	ff 45 f0             	incl   -0x10(%ebp)
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	39 c2                	cmp    %eax,%edx
  8004df:	0f 87 68 ff ff ff    	ja     80044d <CheckAndCountEmptyLocInWS+0x1a>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004e5:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	48                   	dec    %eax
  8004f7:	50                   	push   %eax
  8004f8:	6a 00                	push   $0x0
  8004fa:	ff 75 0c             	pushl  0xc(%ebp)
  8004fd:	ff 75 08             	pushl  0x8(%ebp)
  800500:	e8 06 00 00 00       	call   80050b <QSort>
  800505:	83 c4 10             	add    $0x10,%esp
}
  800508:	90                   	nop
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	3b 45 14             	cmp    0x14(%ebp),%eax
  800517:	0f 8d de 00 00 00    	jge    8005fb <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	40                   	inc    %eax
  800521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80052a:	e9 80 00 00 00       	jmp    8005af <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80052f:	ff 45 f4             	incl   -0xc(%ebp)
  800532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800535:	3b 45 14             	cmp    0x14(%ebp),%eax
  800538:	7f 2b                	jg     800565 <QSort+0x5a>
  80053a:	8b 45 10             	mov    0x10(%ebp),%eax
  80053d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8b 10                	mov    (%eax),%edx
  80054b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	01 c8                	add    %ecx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	39 c2                	cmp    %eax,%edx
  80055e:	7d cf                	jge    80052f <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800560:	eb 03                	jmp    800565 <QSort+0x5a>
  800562:	ff 4d f0             	decl   -0x10(%ebp)
  800565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800568:	3b 45 10             	cmp    0x10(%ebp),%eax
  80056b:	7e 26                	jle    800593 <QSort+0x88>
  80056d:	8b 45 10             	mov    0x10(%ebp),%eax
  800570:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	8b 10                	mov    (%eax),%edx
  80057e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	39 c2                	cmp    %eax,%edx
  800591:	7e cf                	jle    800562 <QSort+0x57>

		if (i <= j)
  800593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800596:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800599:	7f 14                	jg     8005af <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80059b:	83 ec 04             	sub    $0x4,%esp
  80059e:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a4:	ff 75 08             	pushl  0x8(%ebp)
  8005a7:	e8 a9 00 00 00       	call   800655 <Swap>
  8005ac:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b5:	0f 8e 77 ff ff ff    	jle    800532 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005bb:	83 ec 04             	sub    $0x4,%esp
  8005be:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c1:	ff 75 10             	pushl  0x10(%ebp)
  8005c4:	ff 75 08             	pushl  0x8(%ebp)
  8005c7:	e8 89 00 00 00       	call   800655 <Swap>
  8005cc:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d2:	48                   	dec    %eax
  8005d3:	50                   	push   %eax
  8005d4:	ff 75 10             	pushl  0x10(%ebp)
  8005d7:	ff 75 0c             	pushl  0xc(%ebp)
  8005da:	ff 75 08             	pushl  0x8(%ebp)
  8005dd:	e8 29 ff ff ff       	call   80050b <QSort>
  8005e2:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005e5:	ff 75 14             	pushl  0x14(%ebp)
  8005e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 15 ff ff ff       	call   80050b <QSort>
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	eb 01                	jmp    8005fc <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005fb:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800604:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80060b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800612:	eb 33                	jmp    800647 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800614:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800617:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	01 d0                	add    %edx,%eax
  800623:	8b 10                	mov    (%eax),%edx
  800625:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800628:	40                   	inc    %eax
  800629:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	01 c8                	add    %ecx,%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	39 c2                	cmp    %eax,%edx
  800639:	7e 09                	jle    800644 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80063b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800642:	eb 0c                	jmp    800650 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800644:	ff 45 f8             	incl   -0x8(%ebp)
  800647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064a:	48                   	dec    %eax
  80064b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80064e:	7f c4                	jg     800614 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800650:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800653:	c9                   	leave  
  800654:	c3                   	ret    

00800655 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80065b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	01 d0                	add    %edx,%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	01 c2                	add    %eax,%edx
  80067e:	8b 45 10             	mov    0x10(%ebp),%eax
  800681:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	01 c8                	add    %ecx,%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800691:	8b 45 10             	mov    0x10(%ebp),%eax
  800694:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	01 c2                	add    %eax,%edx
  8006a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a3:	89 02                	mov    %eax,(%edx)
}
  8006a5:	90                   	nop
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006b5:	eb 17                	jmp    8006ce <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	01 c2                	add    %eax,%edx
  8006c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006c9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006cb:	ff 45 fc             	incl   -0x4(%ebp)
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006d4:	7c e1                	jl     8006b7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006d6:	90                   	nop
  8006d7:	c9                   	leave  
  8006d8:	c3                   	ret    

008006d9 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8006d9:	55                   	push   %ebp
  8006da:	89 e5                	mov    %esp,%ebp
  8006dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006e6:	eb 1b                	jmp    800703 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	01 c2                	add    %eax,%edx
  8006f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fa:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006fd:	48                   	dec    %eax
  8006fe:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800700:	ff 45 fc             	incl   -0x4(%ebp)
  800703:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800706:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800709:	7c dd                	jl     8006e8 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80070b:	90                   	nop
  80070c:	c9                   	leave  
  80070d:	c3                   	ret    

0080070e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800714:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800717:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80071c:	f7 e9                	imul   %ecx
  80071e:	c1 f9 1f             	sar    $0x1f,%ecx
  800721:	89 d0                	mov    %edx,%eax
  800723:	29 c8                	sub    %ecx,%eax
  800725:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800728:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80072f:	eb 1e                	jmp    80074f <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800731:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800734:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800744:	99                   	cltd   
  800745:	f7 7d f8             	idivl  -0x8(%ebp)
  800748:	89 d0                	mov    %edx,%eax
  80074a:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80074c:	ff 45 fc             	incl   -0x4(%ebp)
  80074f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800752:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800755:	7c da                	jl     800731 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  800757:	90                   	nop
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800760:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80076e:	eb 42                	jmp    8007b2 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	99                   	cltd   
  800774:	f7 7d f0             	idivl  -0x10(%ebp)
  800777:	89 d0                	mov    %edx,%eax
  800779:	85 c0                	test   %eax,%eax
  80077b:	75 10                	jne    80078d <PrintElements+0x33>
			cprintf("\n");
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	68 22 42 80 00       	push   $0x804222
  800785:	e8 30 05 00 00       	call   800cba <cprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80078d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800790:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	01 d0                	add    %edx,%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	50                   	push   %eax
  8007a2:	68 24 42 80 00       	push   $0x804224
  8007a7:	e8 0e 05 00 00       	call   800cba <cprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8007af:	ff 45 f4             	incl   -0xc(%ebp)
  8007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b5:	48                   	dec    %eax
  8007b6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8007b9:	7f b5                	jg     800770 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	01 d0                	add    %edx,%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	50                   	push   %eax
  8007d0:	68 29 42 80 00       	push   $0x804229
  8007d5:	e8 e0 04 00 00       	call   800cba <cprintf>
  8007da:	83 c4 10             	add    $0x10,%esp

}
  8007dd:	90                   	nop
  8007de:	c9                   	leave  
  8007df:	c3                   	ret    

008007e0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007ec:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007f0:	83 ec 0c             	sub    $0xc,%esp
  8007f3:	50                   	push   %eax
  8007f4:	e8 6d 24 00 00       	call   802c66 <sys_cputc>
  8007f9:	83 c4 10             	add    $0x10,%esp
}
  8007fc:	90                   	nop
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    

008007ff <getchar>:


int
getchar(void)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800805:	e8 fb 22 00 00       	call   802b05 <sys_cgetc>
  80080a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80080d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <iscons>:

int iscons(int fdnum)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800815:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80081a:	5d                   	pop    %ebp
  80081b:	c3                   	ret    

0080081c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	57                   	push   %edi
  800820:	56                   	push   %esi
  800821:	53                   	push   %ebx
  800822:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800825:	e8 6d 25 00 00       	call   802d97 <sys_getenvindex>
  80082a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80082d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	01 c0                	add    %eax,%eax
  800834:	01 d0                	add    %edx,%eax
  800836:	c1 e0 02             	shl    $0x2,%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	c1 e0 02             	shl    $0x2,%eax
  80083e:	01 d0                	add    %edx,%eax
  800840:	c1 e0 03             	shl    $0x3,%eax
  800843:	01 d0                	add    %edx,%eax
  800845:	c1 e0 02             	shl    $0x2,%eax
  800848:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80084d:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800852:	a1 24 50 80 00       	mov    0x805024,%eax
  800857:	8a 40 20             	mov    0x20(%eax),%al
  80085a:	84 c0                	test   %al,%al
  80085c:	74 0d                	je     80086b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80085e:	a1 24 50 80 00       	mov    0x805024,%eax
  800863:	83 c0 20             	add    $0x20,%eax
  800866:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80086b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80086f:	7e 0a                	jle    80087b <libmain+0x5f>
		binaryname = argv[0];
  800871:	8b 45 0c             	mov    0xc(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 af f7 ff ff       	call   800038 <_main>
  800889:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80088c:	a1 00 50 80 00       	mov    0x805000,%eax
  800891:	85 c0                	test   %eax,%eax
  800893:	0f 84 01 01 00 00    	je     80099a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800899:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80089f:	bb 28 43 80 00       	mov    $0x804328,%ebx
  8008a4:	ba 0e 00 00 00       	mov    $0xe,%edx
  8008a9:	89 c7                	mov    %eax,%edi
  8008ab:	89 de                	mov    %ebx,%esi
  8008ad:	89 d1                	mov    %edx,%ecx
  8008af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8008b1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8008b4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8008b9:	b0 00                	mov    $0x0,%al
  8008bb:	89 d7                	mov    %edx,%edi
  8008bd:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8008bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8008c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	50                   	push   %eax
  8008cd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8008d3:	50                   	push   %eax
  8008d4:	e8 f4 26 00 00       	call   802fcd <sys_utilities>
  8008d9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8008dc:	e8 3d 22 00 00       	call   802b1e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8008e1:	83 ec 0c             	sub    $0xc,%esp
  8008e4:	68 48 42 80 00       	push   $0x804248
  8008e9:	e8 cc 03 00 00       	call   800cba <cprintf>
  8008ee:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8008f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	74 18                	je     800910 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8008f8:	e8 ee 26 00 00       	call   802feb <sys_get_optimal_num_faults>
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	50                   	push   %eax
  800901:	68 70 42 80 00       	push   $0x804270
  800906:	e8 af 03 00 00       	call   800cba <cprintf>
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	eb 59                	jmp    800969 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800910:	a1 24 50 80 00       	mov    0x805024,%eax
  800915:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80091b:	a1 24 50 80 00       	mov    0x805024,%eax
  800920:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800926:	83 ec 04             	sub    $0x4,%esp
  800929:	52                   	push   %edx
  80092a:	50                   	push   %eax
  80092b:	68 94 42 80 00       	push   $0x804294
  800930:	e8 85 03 00 00       	call   800cba <cprintf>
  800935:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800938:	a1 24 50 80 00       	mov    0x805024,%eax
  80093d:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
  800948:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80094e:	a1 24 50 80 00       	mov    0x805024,%eax
  800953:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800959:	51                   	push   %ecx
  80095a:	52                   	push   %edx
  80095b:	50                   	push   %eax
  80095c:	68 bc 42 80 00       	push   $0x8042bc
  800961:	e8 54 03 00 00       	call   800cba <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800969:	a1 24 50 80 00       	mov    0x805024,%eax
  80096e:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	50                   	push   %eax
  800978:	68 14 43 80 00       	push   $0x804314
  80097d:	e8 38 03 00 00       	call   800cba <cprintf>
  800982:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800985:	83 ec 0c             	sub    $0xc,%esp
  800988:	68 48 42 80 00       	push   $0x804248
  80098d:	e8 28 03 00 00       	call   800cba <cprintf>
  800992:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800995:	e8 9e 21 00 00       	call   802b38 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80099a:	e8 1f 00 00 00       	call   8009be <exit>
}
  80099f:	90                   	nop
  8009a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5f                   	pop    %edi
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8009ae:	83 ec 0c             	sub    $0xc,%esp
  8009b1:	6a 00                	push   $0x0
  8009b3:	e8 ab 23 00 00       	call   802d63 <sys_destroy_env>
  8009b8:	83 c4 10             	add    $0x10,%esp
}
  8009bb:	90                   	nop
  8009bc:	c9                   	leave  
  8009bd:	c3                   	ret    

008009be <exit>:

void
exit(void)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8009c4:	e8 00 24 00 00       	call   802dc9 <sys_exit_env>
}
  8009c9:	90                   	nop
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8009d5:	83 c0 04             	add    $0x4,%eax
  8009d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009db:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	74 16                	je     8009fa <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009e4:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	50                   	push   %eax
  8009ed:	68 8c 43 80 00       	push   $0x80438c
  8009f2:	e8 c3 02 00 00       	call   800cba <cprintf>
  8009f7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8009fa:	a1 04 50 80 00       	mov    0x805004,%eax
  8009ff:	83 ec 0c             	sub    $0xc,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	ff 75 08             	pushl  0x8(%ebp)
  800a08:	50                   	push   %eax
  800a09:	68 94 43 80 00       	push   $0x804394
  800a0e:	6a 74                	push   $0x74
  800a10:	e8 d2 02 00 00       	call   800ce7 <cprintf_colored>
  800a15:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800a18:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 24 02 00 00       	call   800c4b <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	6a 00                	push   $0x0
  800a2f:	68 bc 43 80 00       	push   $0x8043bc
  800a34:	e8 12 02 00 00       	call   800c4b <vcprintf>
  800a39:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a3c:	e8 7d ff ff ff       	call   8009be <exit>

	// should not return here
	while (1) ;
  800a41:	eb fe                	jmp    800a41 <_panic+0x75>

00800a43 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	53                   	push   %ebx
  800a47:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a4a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	39 c2                	cmp    %eax,%edx
  800a5a:	74 14                	je     800a70 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a5c:	83 ec 04             	sub    $0x4,%esp
  800a5f:	68 c0 43 80 00       	push   $0x8043c0
  800a64:	6a 26                	push   $0x26
  800a66:	68 0c 44 80 00       	push   $0x80440c
  800a6b:	e8 5c ff ff ff       	call   8009cc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a7e:	e9 d9 00 00 00       	jmp    800b5c <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	01 d0                	add    %edx,%eax
  800a92:	8b 00                	mov    (%eax),%eax
  800a94:	85 c0                	test   %eax,%eax
  800a96:	75 08                	jne    800aa0 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800a98:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a9b:	e9 b9 00 00 00       	jmp    800b59 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800aa0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800aae:	eb 79                	jmp    800b29 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ab0:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab5:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800abb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800abe:	89 d0                	mov    %edx,%eax
  800ac0:	01 c0                	add    %eax,%eax
  800ac2:	01 d0                	add    %edx,%eax
  800ac4:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800acb:	01 d8                	add    %ebx,%eax
  800acd:	01 d0                	add    %edx,%eax
  800acf:	01 c8                	add    %ecx,%eax
  800ad1:	8a 40 04             	mov    0x4(%eax),%al
  800ad4:	84 c0                	test   %al,%al
  800ad6:	75 4e                	jne    800b26 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad8:	a1 24 50 80 00       	mov    0x805024,%eax
  800add:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800ae3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae6:	89 d0                	mov    %edx,%eax
  800ae8:	01 c0                	add    %eax,%eax
  800aea:	01 d0                	add    %edx,%eax
  800aec:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800af3:	01 d8                	add    %ebx,%eax
  800af5:	01 d0                	add    %edx,%eax
  800af7:	01 c8                	add    %ecx,%eax
  800af9:	8b 00                	mov    (%eax),%eax
  800afb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800afe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b06:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	01 c8                	add    %ecx,%eax
  800b17:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b19:	39 c2                	cmp    %eax,%edx
  800b1b:	75 09                	jne    800b26 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800b1d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b24:	eb 19                	jmp    800b3f <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b26:	ff 45 e8             	incl   -0x18(%ebp)
  800b29:	a1 24 50 80 00       	mov    0x805024,%eax
  800b2e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b37:	39 c2                	cmp    %eax,%edx
  800b39:	0f 87 71 ff ff ff    	ja     800ab0 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b43:	75 14                	jne    800b59 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800b45:	83 ec 04             	sub    $0x4,%esp
  800b48:	68 18 44 80 00       	push   $0x804418
  800b4d:	6a 3a                	push   $0x3a
  800b4f:	68 0c 44 80 00       	push   $0x80440c
  800b54:	e8 73 fe ff ff       	call   8009cc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b59:	ff 45 f0             	incl   -0x10(%ebp)
  800b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b62:	0f 8c 1b ff ff ff    	jl     800a83 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b6f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b76:	eb 2e                	jmp    800ba6 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b78:	a1 24 50 80 00       	mov    0x805024,%eax
  800b7d:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800b83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b86:	89 d0                	mov    %edx,%eax
  800b88:	01 c0                	add    %eax,%eax
  800b8a:	01 d0                	add    %edx,%eax
  800b8c:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800b93:	01 d8                	add    %ebx,%eax
  800b95:	01 d0                	add    %edx,%eax
  800b97:	01 c8                	add    %ecx,%eax
  800b99:	8a 40 04             	mov    0x4(%eax),%al
  800b9c:	3c 01                	cmp    $0x1,%al
  800b9e:	75 03                	jne    800ba3 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800ba0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ba3:	ff 45 e0             	incl   -0x20(%ebp)
  800ba6:	a1 24 50 80 00       	mov    0x805024,%eax
  800bab:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb4:	39 c2                	cmp    %eax,%edx
  800bb6:	77 c0                	ja     800b78 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bbb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bbe:	74 14                	je     800bd4 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800bc0:	83 ec 04             	sub    $0x4,%esp
  800bc3:	68 6c 44 80 00       	push   $0x80446c
  800bc8:	6a 44                	push   $0x44
  800bca:	68 0c 44 80 00       	push   $0x80440c
  800bcf:	e8 f8 fd ff ff       	call   8009cc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800bd4:	90                   	nop
  800bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    

00800bda <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	53                   	push   %ebx
  800bde:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	8b 00                	mov    (%eax),%eax
  800be6:	8d 48 01             	lea    0x1(%eax),%ecx
  800be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bec:	89 0a                	mov    %ecx,(%edx)
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	88 d1                	mov    %dl,%cl
  800bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 00                	mov    (%eax),%eax
  800bff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c04:	75 30                	jne    800c36 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800c06:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800c0c:	a0 44 50 80 00       	mov    0x805044,%al
  800c11:	0f b6 c0             	movzbl %al,%eax
  800c14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c17:	8b 09                	mov    (%ecx),%ecx
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1e:	83 c1 08             	add    $0x8,%ecx
  800c21:	52                   	push   %edx
  800c22:	50                   	push   %eax
  800c23:	53                   	push   %ebx
  800c24:	51                   	push   %ecx
  800c25:	e8 b0 1e 00 00       	call   802ada <sys_cputs>
  800c2a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	8b 40 04             	mov    0x4(%eax),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c45:	90                   	nop
  800c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c54:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c5b:	00 00 00 
	b.cnt = 0;
  800c5e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c65:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c68:	ff 75 0c             	pushl  0xc(%ebp)
  800c6b:	ff 75 08             	pushl  0x8(%ebp)
  800c6e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	68 da 0b 80 00       	push   $0x800bda
  800c7a:	e8 5a 02 00 00       	call   800ed9 <vprintfmt>
  800c7f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c82:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800c88:	a0 44 50 80 00       	mov    0x805044,%al
  800c8d:	0f b6 c0             	movzbl %al,%eax
  800c90:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c96:	52                   	push   %edx
  800c97:	50                   	push   %eax
  800c98:	51                   	push   %ecx
  800c99:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c9f:	83 c0 08             	add    $0x8,%eax
  800ca2:	50                   	push   %eax
  800ca3:	e8 32 1e 00 00       	call   802ada <sys_cputs>
  800ca8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800cab:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800cb2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cc0:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800cc7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd6:	50                   	push   %eax
  800cd7:	e8 6f ff ff ff       	call   800c4b <vcprintf>
  800cdc:	83 c4 10             	add    $0x10,%esp
  800cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ced:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	c1 e0 08             	shl    $0x8,%eax
  800cfa:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800cff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	83 ec 08             	sub    $0x8,%esp
  800d0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d11:	50                   	push   %eax
  800d12:	e8 34 ff ff ff       	call   800c4b <vcprintf>
  800d17:	83 c4 10             	add    $0x10,%esp
  800d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800d1d:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800d24:	07 00 00 

	return cnt;
  800d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d32:	e8 e7 1d 00 00       	call   802b1e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d37:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	83 ec 08             	sub    $0x8,%esp
  800d43:	ff 75 f4             	pushl  -0xc(%ebp)
  800d46:	50                   	push   %eax
  800d47:	e8 ff fe ff ff       	call   800c4b <vcprintf>
  800d4c:	83 c4 10             	add    $0x10,%esp
  800d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d52:	e8 e1 1d 00 00       	call   802b38 <sys_unlock_cons>
	return cnt;
  800d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 14             	sub    $0x14,%esp
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d6f:	8b 45 18             	mov    0x18(%ebp),%eax
  800d72:	ba 00 00 00 00       	mov    $0x0,%edx
  800d77:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d7a:	77 55                	ja     800dd1 <printnum+0x75>
  800d7c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d7f:	72 05                	jb     800d86 <printnum+0x2a>
  800d81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d84:	77 4b                	ja     800dd1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d86:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d89:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d8c:	8b 45 18             	mov    0x18(%ebp),%eax
  800d8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d94:	52                   	push   %edx
  800d95:	50                   	push   %eax
  800d96:	ff 75 f4             	pushl  -0xc(%ebp)
  800d99:	ff 75 f0             	pushl  -0x10(%ebp)
  800d9c:	e8 db 2f 00 00       	call   803d7c <__udivdi3>
  800da1:	83 c4 10             	add    $0x10,%esp
  800da4:	83 ec 04             	sub    $0x4,%esp
  800da7:	ff 75 20             	pushl  0x20(%ebp)
  800daa:	53                   	push   %ebx
  800dab:	ff 75 18             	pushl  0x18(%ebp)
  800dae:	52                   	push   %edx
  800daf:	50                   	push   %eax
  800db0:	ff 75 0c             	pushl  0xc(%ebp)
  800db3:	ff 75 08             	pushl  0x8(%ebp)
  800db6:	e8 a1 ff ff ff       	call   800d5c <printnum>
  800dbb:	83 c4 20             	add    $0x20,%esp
  800dbe:	eb 1a                	jmp    800dda <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800dc0:	83 ec 08             	sub    $0x8,%esp
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 20             	pushl  0x20(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	ff d0                	call   *%eax
  800dce:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dd1:	ff 4d 1c             	decl   0x1c(%ebp)
  800dd4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dd8:	7f e6                	jg     800dc0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dda:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ddd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de8:	53                   	push   %ebx
  800de9:	51                   	push   %ecx
  800dea:	52                   	push   %edx
  800deb:	50                   	push   %eax
  800dec:	e8 9b 30 00 00       	call   803e8c <__umoddi3>
  800df1:	83 c4 10             	add    $0x10,%esp
  800df4:	05 d4 46 80 00       	add    $0x8046d4,%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	0f be c0             	movsbl %al,%eax
  800dfe:	83 ec 08             	sub    $0x8,%esp
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	50                   	push   %eax
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	ff d0                	call   *%eax
  800e0a:	83 c4 10             	add    $0x10,%esp
}
  800e0d:	90                   	nop
  800e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e16:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e1a:	7e 1c                	jle    800e38 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8b 00                	mov    (%eax),%eax
  800e21:	8d 50 08             	lea    0x8(%eax),%edx
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 10                	mov    %edx,(%eax)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8b 00                	mov    (%eax),%eax
  800e2e:	83 e8 08             	sub    $0x8,%eax
  800e31:	8b 50 04             	mov    0x4(%eax),%edx
  800e34:	8b 00                	mov    (%eax),%eax
  800e36:	eb 40                	jmp    800e78 <getuint+0x65>
	else if (lflag)
  800e38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3c:	74 1e                	je     800e5c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8b 00                	mov    (%eax),%eax
  800e43:	8d 50 04             	lea    0x4(%eax),%edx
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 10                	mov    %edx,(%eax)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8b 00                	mov    (%eax),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5a:	eb 1c                	jmp    800e78 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8b 00                	mov    (%eax),%eax
  800e61:	8d 50 04             	lea    0x4(%eax),%edx
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	89 10                	mov    %edx,(%eax)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	83 e8 04             	sub    $0x4,%eax
  800e71:	8b 00                	mov    (%eax),%eax
  800e73:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e7d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e81:	7e 1c                	jle    800e9f <getint+0x25>
		return va_arg(*ap, long long);
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8b 00                	mov    (%eax),%eax
  800e88:	8d 50 08             	lea    0x8(%eax),%edx
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 10                	mov    %edx,(%eax)
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	83 e8 08             	sub    $0x8,%eax
  800e98:	8b 50 04             	mov    0x4(%eax),%edx
  800e9b:	8b 00                	mov    (%eax),%eax
  800e9d:	eb 38                	jmp    800ed7 <getint+0x5d>
	else if (lflag)
  800e9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea3:	74 1a                	je     800ebf <getint+0x45>
		return va_arg(*ap, long);
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8b 00                	mov    (%eax),%eax
  800eaa:	8d 50 04             	lea    0x4(%eax),%edx
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	89 10                	mov    %edx,(%eax)
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8b 00                	mov    (%eax),%eax
  800eb7:	83 e8 04             	sub    $0x4,%eax
  800eba:	8b 00                	mov    (%eax),%eax
  800ebc:	99                   	cltd   
  800ebd:	eb 18                	jmp    800ed7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8b 00                	mov    (%eax),%eax
  800ec4:	8d 50 04             	lea    0x4(%eax),%edx
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 10                	mov    %edx,(%eax)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	83 e8 04             	sub    $0x4,%eax
  800ed4:	8b 00                	mov    (%eax),%eax
  800ed6:	99                   	cltd   
}
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee1:	eb 17                	jmp    800efa <vprintfmt+0x21>
			if (ch == '\0')
  800ee3:	85 db                	test   %ebx,%ebx
  800ee5:	0f 84 c1 03 00 00    	je     8012ac <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	ff 75 0c             	pushl  0xc(%ebp)
  800ef1:	53                   	push   %ebx
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 10             	mov    %edx,0x10(%ebp)
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f b6 d8             	movzbl %al,%ebx
  800f08:	83 fb 25             	cmp    $0x25,%ebx
  800f0b:	75 d6                	jne    800ee3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f0d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f11:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f18:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f1f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f26:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f30:	8d 50 01             	lea    0x1(%eax),%edx
  800f33:	89 55 10             	mov    %edx,0x10(%ebp)
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f b6 d8             	movzbl %al,%ebx
  800f3b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f3e:	83 f8 5b             	cmp    $0x5b,%eax
  800f41:	0f 87 3d 03 00 00    	ja     801284 <vprintfmt+0x3ab>
  800f47:	8b 04 85 f8 46 80 00 	mov    0x8046f8(,%eax,4),%eax
  800f4e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f50:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f54:	eb d7                	jmp    800f2d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f56:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f5a:	eb d1                	jmp    800f2d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f5c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	c1 e0 02             	shl    $0x2,%eax
  800f6b:	01 d0                	add    %edx,%eax
  800f6d:	01 c0                	add    %eax,%eax
  800f6f:	01 d8                	add    %ebx,%eax
  800f71:	83 e8 30             	sub    $0x30,%eax
  800f74:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f77:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f7f:	83 fb 2f             	cmp    $0x2f,%ebx
  800f82:	7e 3e                	jle    800fc2 <vprintfmt+0xe9>
  800f84:	83 fb 39             	cmp    $0x39,%ebx
  800f87:	7f 39                	jg     800fc2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f89:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f8c:	eb d5                	jmp    800f63 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f91:	83 c0 04             	add    $0x4,%eax
  800f94:	89 45 14             	mov    %eax,0x14(%ebp)
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	83 e8 04             	sub    $0x4,%eax
  800f9d:	8b 00                	mov    (%eax),%eax
  800f9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800fa2:	eb 1f                	jmp    800fc3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800fa4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa8:	79 83                	jns    800f2d <vprintfmt+0x54>
				width = 0;
  800faa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fb1:	e9 77 ff ff ff       	jmp    800f2d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fb6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fbd:	e9 6b ff ff ff       	jmp    800f2d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fc2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc7:	0f 89 60 ff ff ff    	jns    800f2d <vprintfmt+0x54>
				width = precision, precision = -1;
  800fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fd3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fda:	e9 4e ff ff ff       	jmp    800f2d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fdf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fe2:	e9 46 ff ff ff       	jmp    800f2d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fea:	83 c0 04             	add    $0x4,%eax
  800fed:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff3:	83 e8 04             	sub    $0x4,%eax
  800ff6:	8b 00                	mov    (%eax),%eax
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 0c             	pushl  0xc(%ebp)
  800ffe:	50                   	push   %eax
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	ff d0                	call   *%eax
  801004:	83 c4 10             	add    $0x10,%esp
			break;
  801007:	e9 9b 02 00 00       	jmp    8012a7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80100c:	8b 45 14             	mov    0x14(%ebp),%eax
  80100f:	83 c0 04             	add    $0x4,%eax
  801012:	89 45 14             	mov    %eax,0x14(%ebp)
  801015:	8b 45 14             	mov    0x14(%ebp),%eax
  801018:	83 e8 04             	sub    $0x4,%eax
  80101b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80101d:	85 db                	test   %ebx,%ebx
  80101f:	79 02                	jns    801023 <vprintfmt+0x14a>
				err = -err;
  801021:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801023:	83 fb 64             	cmp    $0x64,%ebx
  801026:	7f 0b                	jg     801033 <vprintfmt+0x15a>
  801028:	8b 34 9d 40 45 80 00 	mov    0x804540(,%ebx,4),%esi
  80102f:	85 f6                	test   %esi,%esi
  801031:	75 19                	jne    80104c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801033:	53                   	push   %ebx
  801034:	68 e5 46 80 00       	push   $0x8046e5
  801039:	ff 75 0c             	pushl  0xc(%ebp)
  80103c:	ff 75 08             	pushl  0x8(%ebp)
  80103f:	e8 70 02 00 00       	call   8012b4 <printfmt>
  801044:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801047:	e9 5b 02 00 00       	jmp    8012a7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80104c:	56                   	push   %esi
  80104d:	68 ee 46 80 00       	push   $0x8046ee
  801052:	ff 75 0c             	pushl  0xc(%ebp)
  801055:	ff 75 08             	pushl  0x8(%ebp)
  801058:	e8 57 02 00 00       	call   8012b4 <printfmt>
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 42 02 00 00       	jmp    8012a7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801065:	8b 45 14             	mov    0x14(%ebp),%eax
  801068:	83 c0 04             	add    $0x4,%eax
  80106b:	89 45 14             	mov    %eax,0x14(%ebp)
  80106e:	8b 45 14             	mov    0x14(%ebp),%eax
  801071:	83 e8 04             	sub    $0x4,%eax
  801074:	8b 30                	mov    (%eax),%esi
  801076:	85 f6                	test   %esi,%esi
  801078:	75 05                	jne    80107f <vprintfmt+0x1a6>
				p = "(null)";
  80107a:	be f1 46 80 00       	mov    $0x8046f1,%esi
			if (width > 0 && padc != '-')
  80107f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801083:	7e 6d                	jle    8010f2 <vprintfmt+0x219>
  801085:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801089:	74 67                	je     8010f2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80108b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	50                   	push   %eax
  801092:	56                   	push   %esi
  801093:	e8 26 05 00 00       	call   8015be <strnlen>
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80109e:	eb 16                	jmp    8010b6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8010a0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	ff 75 0c             	pushl  0xc(%ebp)
  8010aa:	50                   	push   %eax
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	ff d0                	call   *%eax
  8010b0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010b3:	ff 4d e4             	decl   -0x1c(%ebp)
  8010b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ba:	7f e4                	jg     8010a0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010bc:	eb 34                	jmp    8010f2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010c2:	74 1c                	je     8010e0 <vprintfmt+0x207>
  8010c4:	83 fb 1f             	cmp    $0x1f,%ebx
  8010c7:	7e 05                	jle    8010ce <vprintfmt+0x1f5>
  8010c9:	83 fb 7e             	cmp    $0x7e,%ebx
  8010cc:	7e 12                	jle    8010e0 <vprintfmt+0x207>
					putch('?', putdat);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	6a 3f                	push   $0x3f
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	ff d0                	call   *%eax
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	eb 0f                	jmp    8010ef <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010e0:	83 ec 08             	sub    $0x8,%esp
  8010e3:	ff 75 0c             	pushl  0xc(%ebp)
  8010e6:	53                   	push   %ebx
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	ff d0                	call   *%eax
  8010ec:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8010f2:	89 f0                	mov    %esi,%eax
  8010f4:	8d 70 01             	lea    0x1(%eax),%esi
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f be d8             	movsbl %al,%ebx
  8010fc:	85 db                	test   %ebx,%ebx
  8010fe:	74 24                	je     801124 <vprintfmt+0x24b>
  801100:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801104:	78 b8                	js     8010be <vprintfmt+0x1e5>
  801106:	ff 4d e0             	decl   -0x20(%ebp)
  801109:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80110d:	79 af                	jns    8010be <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80110f:	eb 13                	jmp    801124 <vprintfmt+0x24b>
				putch(' ', putdat);
  801111:	83 ec 08             	sub    $0x8,%esp
  801114:	ff 75 0c             	pushl  0xc(%ebp)
  801117:	6a 20                	push   $0x20
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	ff d0                	call   *%eax
  80111e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801121:	ff 4d e4             	decl   -0x1c(%ebp)
  801124:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801128:	7f e7                	jg     801111 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80112a:	e9 78 01 00 00       	jmp    8012a7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80112f:	83 ec 08             	sub    $0x8,%esp
  801132:	ff 75 e8             	pushl  -0x18(%ebp)
  801135:	8d 45 14             	lea    0x14(%ebp),%eax
  801138:	50                   	push   %eax
  801139:	e8 3c fd ff ff       	call   800e7a <getint>
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801144:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114d:	85 d2                	test   %edx,%edx
  80114f:	79 23                	jns    801174 <vprintfmt+0x29b>
				putch('-', putdat);
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	ff 75 0c             	pushl  0xc(%ebp)
  801157:	6a 2d                	push   $0x2d
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	ff d0                	call   *%eax
  80115e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801167:	f7 d8                	neg    %eax
  801169:	83 d2 00             	adc    $0x0,%edx
  80116c:	f7 da                	neg    %edx
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 bc 00 00 00       	jmp    80123c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 e8             	pushl  -0x18(%ebp)
  801186:	8d 45 14             	lea    0x14(%ebp),%eax
  801189:	50                   	push   %eax
  80118a:	e8 84 fc ff ff       	call   800e13 <getuint>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801195:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801198:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80119f:	e9 98 00 00 00       	jmp    80123c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	ff 75 0c             	pushl  0xc(%ebp)
  8011aa:	6a 58                	push   $0x58
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	ff d0                	call   *%eax
  8011b1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ba:	6a 58                	push   $0x58
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	ff d0                	call   *%eax
  8011c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011c4:	83 ec 08             	sub    $0x8,%esp
  8011c7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ca:	6a 58                	push   $0x58
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	ff d0                	call   *%eax
  8011d1:	83 c4 10             	add    $0x10,%esp
			break;
  8011d4:	e9 ce 00 00 00       	jmp    8012a7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011d9:	83 ec 08             	sub    $0x8,%esp
  8011dc:	ff 75 0c             	pushl  0xc(%ebp)
  8011df:	6a 30                	push   $0x30
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	ff d0                	call   *%eax
  8011e6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	6a 78                	push   $0x78
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	ff d0                	call   *%eax
  8011f6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fc:	83 c0 04             	add    $0x4,%eax
  8011ff:	89 45 14             	mov    %eax,0x14(%ebp)
  801202:	8b 45 14             	mov    0x14(%ebp),%eax
  801205:	83 e8 04             	sub    $0x4,%eax
  801208:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80120a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801214:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80121b:	eb 1f                	jmp    80123c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	ff 75 e8             	pushl  -0x18(%ebp)
  801223:	8d 45 14             	lea    0x14(%ebp),%eax
  801226:	50                   	push   %eax
  801227:	e8 e7 fb ff ff       	call   800e13 <getuint>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801232:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801235:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80123c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801240:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	52                   	push   %edx
  801247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124a:	50                   	push   %eax
  80124b:	ff 75 f4             	pushl  -0xc(%ebp)
  80124e:	ff 75 f0             	pushl  -0x10(%ebp)
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	ff 75 08             	pushl  0x8(%ebp)
  801257:	e8 00 fb ff ff       	call   800d5c <printnum>
  80125c:	83 c4 20             	add    $0x20,%esp
			break;
  80125f:	eb 46                	jmp    8012a7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	ff 75 0c             	pushl  0xc(%ebp)
  801267:	53                   	push   %ebx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	ff d0                	call   *%eax
  80126d:	83 c4 10             	add    $0x10,%esp
			break;
  801270:	eb 35                	jmp    8012a7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801272:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801279:	eb 2c                	jmp    8012a7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80127b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801282:	eb 23                	jmp    8012a7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	ff 75 0c             	pushl  0xc(%ebp)
  80128a:	6a 25                	push   $0x25
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	ff d0                	call   *%eax
  801291:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801294:	ff 4d 10             	decl   0x10(%ebp)
  801297:	eb 03                	jmp    80129c <vprintfmt+0x3c3>
  801299:	ff 4d 10             	decl   0x10(%ebp)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	48                   	dec    %eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 25                	cmp    $0x25,%al
  8012a4:	75 f3                	jne    801299 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8012a6:	90                   	nop
		}
	}
  8012a7:	e9 35 fc ff ff       	jmp    800ee1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012ac:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b0:	5b                   	pop    %ebx
  8012b1:	5e                   	pop    %esi
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    

008012b4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8012bd:	83 c0 04             	add    $0x4,%eax
  8012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c9:	50                   	push   %eax
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 04 fc ff ff       	call   800ed9 <vprintfmt>
  8012d5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012d8:	90                   	nop
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e1:	8b 40 08             	mov    0x8(%eax),%eax
  8012e4:	8d 50 01             	lea    0x1(%eax),%edx
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	8b 10                	mov    (%eax),%edx
  8012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f5:	8b 40 04             	mov    0x4(%eax),%eax
  8012f8:	39 c2                	cmp    %eax,%edx
  8012fa:	73 12                	jae    80130e <sprintputch+0x33>
		*b->buf++ = ch;
  8012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8b 55 08             	mov    0x8(%ebp),%edx
  80130c:	88 10                	mov    %dl,(%eax)
}
  80130e:	90                   	nop
  80130f:	5d                   	pop    %ebp
  801310:	c3                   	ret    

00801311 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	8d 50 ff             	lea    -0x1(%eax),%edx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80132b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801332:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801336:	74 06                	je     80133e <vsnprintf+0x2d>
  801338:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80133c:	7f 07                	jg     801345 <vsnprintf+0x34>
		return -E_INVAL;
  80133e:	b8 03 00 00 00       	mov    $0x3,%eax
  801343:	eb 20                	jmp    801365 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801345:	ff 75 14             	pushl  0x14(%ebp)
  801348:	ff 75 10             	pushl  0x10(%ebp)
  80134b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80134e:	50                   	push   %eax
  80134f:	68 db 12 80 00       	push   $0x8012db
  801354:	e8 80 fb ff ff       	call   800ed9 <vprintfmt>
  801359:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80135c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801362:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80136d:	8d 45 10             	lea    0x10(%ebp),%eax
  801370:	83 c0 04             	add    $0x4,%eax
  801373:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	ff 75 f4             	pushl  -0xc(%ebp)
  80137c:	50                   	push   %eax
  80137d:	ff 75 0c             	pushl  0xc(%ebp)
  801380:	ff 75 08             	pushl  0x8(%ebp)
  801383:	e8 89 ff ff ff       	call   801311 <vsnprintf>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139d:	74 13                	je     8013b2 <readline+0x1f>
		cprintf("%s", prompt);
  80139f:	83 ec 08             	sub    $0x8,%esp
  8013a2:	ff 75 08             	pushl  0x8(%ebp)
  8013a5:	68 68 48 80 00       	push   $0x804868
  8013aa:	e8 0b f9 ff ff       	call   800cba <cprintf>
  8013af:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013b9:	83 ec 0c             	sub    $0xc,%esp
  8013bc:	6a 00                	push   $0x0
  8013be:	e8 4f f4 ff ff       	call   800812 <iscons>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013c9:	e8 31 f4 ff ff       	call   8007ff <getchar>
  8013ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013d5:	79 22                	jns    8013f9 <readline+0x66>
			if (c != -E_EOF)
  8013d7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013db:	0f 84 ad 00 00 00    	je     80148e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013e1:	83 ec 08             	sub    $0x8,%esp
  8013e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8013e7:	68 6b 48 80 00       	push   $0x80486b
  8013ec:	e8 c9 f8 ff ff       	call   800cba <cprintf>
  8013f1:	83 c4 10             	add    $0x10,%esp
			break;
  8013f4:	e9 95 00 00 00       	jmp    80148e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013f9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013fd:	7e 34                	jle    801433 <readline+0xa0>
  8013ff:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801406:	7f 2b                	jg     801433 <readline+0xa0>
			if (echoing)
  801408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140c:	74 0e                	je     80141c <readline+0x89>
				cputchar(c);
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	ff 75 ec             	pushl  -0x14(%ebp)
  801414:	e8 c7 f3 ff ff       	call   8007e0 <cputchar>
  801419:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141f:	8d 50 01             	lea    0x1(%eax),%edx
  801422:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801425:	89 c2                	mov    %eax,%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80142f:	88 10                	mov    %dl,(%eax)
  801431:	eb 56                	jmp    801489 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801433:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801437:	75 1f                	jne    801458 <readline+0xc5>
  801439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80143d:	7e 19                	jle    801458 <readline+0xc5>
			if (echoing)
  80143f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801443:	74 0e                	je     801453 <readline+0xc0>
				cputchar(c);
  801445:	83 ec 0c             	sub    $0xc,%esp
  801448:	ff 75 ec             	pushl  -0x14(%ebp)
  80144b:	e8 90 f3 ff ff       	call   8007e0 <cputchar>
  801450:	83 c4 10             	add    $0x10,%esp

			i--;
  801453:	ff 4d f4             	decl   -0xc(%ebp)
  801456:	eb 31                	jmp    801489 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801458:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80145c:	74 0a                	je     801468 <readline+0xd5>
  80145e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801462:	0f 85 61 ff ff ff    	jne    8013c9 <readline+0x36>
			if (echoing)
  801468:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80146c:	74 0e                	je     80147c <readline+0xe9>
				cputchar(c);
  80146e:	83 ec 0c             	sub    $0xc,%esp
  801471:	ff 75 ec             	pushl  -0x14(%ebp)
  801474:	e8 67 f3 ff ff       	call   8007e0 <cputchar>
  801479:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80147c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801482:	01 d0                	add    %edx,%eax
  801484:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801487:	eb 06                	jmp    80148f <readline+0xfc>
		}
	}
  801489:	e9 3b ff ff ff       	jmp    8013c9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80148e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80148f:	90                   	nop
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801498:	e8 81 16 00 00       	call   802b1e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80149d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a1:	74 13                	je     8014b6 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	ff 75 08             	pushl  0x8(%ebp)
  8014a9:	68 68 48 80 00       	push   $0x804868
  8014ae:	e8 07 f8 ff ff       	call   800cba <cprintf>
  8014b3:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8014b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8014bd:	83 ec 0c             	sub    $0xc,%esp
  8014c0:	6a 00                	push   $0x0
  8014c2:	e8 4b f3 ff ff       	call   800812 <iscons>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8014cd:	e8 2d f3 ff ff       	call   8007ff <getchar>
  8014d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014d9:	79 22                	jns    8014fd <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014db:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014df:	0f 84 ad 00 00 00    	je     801592 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8014eb:	68 6b 48 80 00       	push   $0x80486b
  8014f0:	e8 c5 f7 ff ff       	call   800cba <cprintf>
  8014f5:	83 c4 10             	add    $0x10,%esp
				break;
  8014f8:	e9 95 00 00 00       	jmp    801592 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014fd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801501:	7e 34                	jle    801537 <atomic_readline+0xa5>
  801503:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80150a:	7f 2b                	jg     801537 <atomic_readline+0xa5>
				if (echoing)
  80150c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801510:	74 0e                	je     801520 <atomic_readline+0x8e>
					cputchar(c);
  801512:	83 ec 0c             	sub    $0xc,%esp
  801515:	ff 75 ec             	pushl  -0x14(%ebp)
  801518:	e8 c3 f2 ff ff       	call   8007e0 <cputchar>
  80151d:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801523:	8d 50 01             	lea    0x1(%eax),%edx
  801526:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801529:	89 c2                	mov    %eax,%edx
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801533:	88 10                	mov    %dl,(%eax)
  801535:	eb 56                	jmp    80158d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801537:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80153b:	75 1f                	jne    80155c <atomic_readline+0xca>
  80153d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801541:	7e 19                	jle    80155c <atomic_readline+0xca>
				if (echoing)
  801543:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801547:	74 0e                	je     801557 <atomic_readline+0xc5>
					cputchar(c);
  801549:	83 ec 0c             	sub    $0xc,%esp
  80154c:	ff 75 ec             	pushl  -0x14(%ebp)
  80154f:	e8 8c f2 ff ff       	call   8007e0 <cputchar>
  801554:	83 c4 10             	add    $0x10,%esp
				i--;
  801557:	ff 4d f4             	decl   -0xc(%ebp)
  80155a:	eb 31                	jmp    80158d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80155c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801560:	74 0a                	je     80156c <atomic_readline+0xda>
  801562:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801566:	0f 85 61 ff ff ff    	jne    8014cd <atomic_readline+0x3b>
				if (echoing)
  80156c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801570:	74 0e                	je     801580 <atomic_readline+0xee>
					cputchar(c);
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	ff 75 ec             	pushl  -0x14(%ebp)
  801578:	e8 63 f2 ff ff       	call   8007e0 <cputchar>
  80157d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801580:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 d0                	add    %edx,%eax
  801588:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80158b:	eb 06                	jmp    801593 <atomic_readline+0x101>
			}
		}
  80158d:	e9 3b ff ff ff       	jmp    8014cd <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801592:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801593:	e8 a0 15 00 00       	call   802b38 <sys_unlock_cons>
}
  801598:	90                   	nop
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a8:	eb 06                	jmp    8015b0 <strlen+0x15>
		n++;
  8015aa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ad:	ff 45 08             	incl   0x8(%ebp)
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8a 00                	mov    (%eax),%al
  8015b5:	84 c0                	test   %al,%al
  8015b7:	75 f1                	jne    8015aa <strlen+0xf>
		n++;
	return n;
  8015b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015cb:	eb 09                	jmp    8015d6 <strnlen+0x18>
		n++;
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015d0:	ff 45 08             	incl   0x8(%ebp)
  8015d3:	ff 4d 0c             	decl   0xc(%ebp)
  8015d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015da:	74 09                	je     8015e5 <strnlen+0x27>
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	84 c0                	test   %al,%al
  8015e3:	75 e8                	jne    8015cd <strnlen+0xf>
		n++;
	return n;
  8015e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015f6:	90                   	nop
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8d 50 01             	lea    0x1(%eax),%edx
  8015fd:	89 55 08             	mov    %edx,0x8(%ebp)
  801600:	8b 55 0c             	mov    0xc(%ebp),%edx
  801603:	8d 4a 01             	lea    0x1(%edx),%ecx
  801606:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801609:	8a 12                	mov    (%edx),%dl
  80160b:	88 10                	mov    %dl,(%eax)
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	84 c0                	test   %al,%al
  801611:	75 e4                	jne    8015f7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801613:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80162b:	eb 1f                	jmp    80164c <strncpy+0x34>
		*dst++ = *src;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8d 50 01             	lea    0x1(%eax),%edx
  801633:	89 55 08             	mov    %edx,0x8(%ebp)
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8a 12                	mov    (%edx),%dl
  80163b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	84 c0                	test   %al,%al
  801644:	74 03                	je     801649 <strncpy+0x31>
			src++;
  801646:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801649:	ff 45 fc             	incl   -0x4(%ebp)
  80164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801652:	72 d9                	jb     80162d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801654:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 30                	je     80169b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80166b:	eb 16                	jmp    801683 <strlcpy+0x2a>
			*dst++ = *src++;
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8d 50 01             	lea    0x1(%eax),%edx
  801673:	89 55 08             	mov    %edx,0x8(%ebp)
  801676:	8b 55 0c             	mov    0xc(%ebp),%edx
  801679:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80167f:	8a 12                	mov    (%edx),%dl
  801681:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801683:	ff 4d 10             	decl   0x10(%ebp)
  801686:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168a:	74 09                	je     801695 <strlcpy+0x3c>
  80168c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	84 c0                	test   %al,%al
  801693:	75 d8                	jne    80166d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80169b:	8b 55 08             	mov    0x8(%ebp),%edx
  80169e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a1:	29 c2                	sub    %eax,%edx
  8016a3:	89 d0                	mov    %edx,%eax
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016aa:	eb 06                	jmp    8016b2 <strcmp+0xb>
		p++, q++;
  8016ac:	ff 45 08             	incl   0x8(%ebp)
  8016af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	84 c0                	test   %al,%al
  8016b9:	74 0e                	je     8016c9 <strcmp+0x22>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 10                	mov    (%eax),%dl
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	38 c2                	cmp    %al,%dl
  8016c7:	74 e3                	je     8016ac <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	0f b6 d0             	movzbl %al,%edx
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 c0             	movzbl %al,%eax
  8016d9:	29 c2                	sub    %eax,%edx
  8016db:	89 d0                	mov    %edx,%eax
}
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    

008016df <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016e2:	eb 09                	jmp    8016ed <strncmp+0xe>
		n--, p++, q++;
  8016e4:	ff 4d 10             	decl   0x10(%ebp)
  8016e7:	ff 45 08             	incl   0x8(%ebp)
  8016ea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f1:	74 17                	je     80170a <strncmp+0x2b>
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	84 c0                	test   %al,%al
  8016fa:	74 0e                	je     80170a <strncmp+0x2b>
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8a 10                	mov    (%eax),%dl
  801701:	8b 45 0c             	mov    0xc(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	38 c2                	cmp    %al,%dl
  801708:	74 da                	je     8016e4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80170a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170e:	75 07                	jne    801717 <strncmp+0x38>
		return 0;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	eb 14                	jmp    80172b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	0f b6 d0             	movzbl %al,%edx
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	0f b6 c0             	movzbl %al,%eax
  801727:	29 c2                	sub    %eax,%edx
  801729:	89 d0                	mov    %edx,%eax
}
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    

0080172d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	8b 45 0c             	mov    0xc(%ebp),%eax
  801736:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801739:	eb 12                	jmp    80174d <strchr+0x20>
		if (*s == c)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801743:	75 05                	jne    80174a <strchr+0x1d>
			return (char *) s;
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	eb 11                	jmp    80175b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80174a:	ff 45 08             	incl   0x8(%ebp)
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8a 00                	mov    (%eax),%al
  801752:	84 c0                	test   %al,%al
  801754:	75 e5                	jne    80173b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	8b 45 0c             	mov    0xc(%ebp),%eax
  801766:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801769:	eb 0d                	jmp    801778 <strfind+0x1b>
		if (*s == c)
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8a 00                	mov    (%eax),%al
  801770:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801773:	74 0e                	je     801783 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801775:	ff 45 08             	incl   0x8(%ebp)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	75 ea                	jne    80176b <strfind+0xe>
  801781:	eb 01                	jmp    801784 <strfind+0x27>
		if (*s == c)
			break;
  801783:	90                   	nop
	return (char *) s;
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801795:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801799:	76 63                	jbe    8017fe <memset+0x75>
		uint64 data_block = c;
  80179b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179e:	99                   	cltd   
  80179f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8017a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ab:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8017af:	c1 e0 08             	shl    $0x8,%eax
  8017b2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017b5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8017b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017be:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8017c2:	c1 e0 10             	shl    $0x10,%eax
  8017c5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017c8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8017cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d1:	89 c2                	mov    %eax,%edx
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017db:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017de:	eb 18                	jmp    8017f8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017e3:	8d 41 08             	lea    0x8(%ecx),%eax
  8017e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ef:	89 01                	mov    %eax,(%ecx)
  8017f1:	89 51 04             	mov    %edx,0x4(%ecx)
  8017f4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017f8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017fc:	77 e2                	ja     8017e0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801802:	74 23                	je     801827 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801804:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801807:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80180a:	eb 0e                	jmp    80181a <memset+0x91>
			*p8++ = (uint8)c;
  80180c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180f:	8d 50 01             	lea    0x1(%eax),%edx
  801812:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
  801818:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80181a:	8b 45 10             	mov    0x10(%ebp),%eax
  80181d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801820:	89 55 10             	mov    %edx,0x10(%ebp)
  801823:	85 c0                	test   %eax,%eax
  801825:	75 e5                	jne    80180c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801832:	8b 45 0c             	mov    0xc(%ebp),%eax
  801835:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80183e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801842:	76 24                	jbe    801868 <memcpy+0x3c>
		while(n >= 8){
  801844:	eb 1c                	jmp    801862 <memcpy+0x36>
			*d64 = *s64;
  801846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801849:	8b 50 04             	mov    0x4(%eax),%edx
  80184c:	8b 00                	mov    (%eax),%eax
  80184e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801851:	89 01                	mov    %eax,(%ecx)
  801853:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801856:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80185a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80185e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801862:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801866:	77 de                	ja     801846 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801868:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80186c:	74 31                	je     80189f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801871:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801874:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801877:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80187a:	eb 16                	jmp    801892 <memcpy+0x66>
			*d8++ = *s8++;
  80187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187f:	8d 50 01             	lea    0x1(%eax),%edx
  801882:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801885:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801888:	8d 4a 01             	lea    0x1(%edx),%ecx
  80188b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80188e:	8a 12                	mov    (%edx),%dl
  801890:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801892:	8b 45 10             	mov    0x10(%ebp),%eax
  801895:	8d 50 ff             	lea    -0x1(%eax),%edx
  801898:	89 55 10             	mov    %edx,0x10(%ebp)
  80189b:	85 c0                	test   %eax,%eax
  80189d:	75 dd                	jne    80187c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018bc:	73 50                	jae    80190e <memmove+0x6a>
  8018be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	01 d0                	add    %edx,%eax
  8018c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018c9:	76 43                	jbe    80190e <memmove+0x6a>
		s += n;
  8018cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ce:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018d7:	eb 10                	jmp    8018e9 <memmove+0x45>
			*--d = *--s;
  8018d9:	ff 4d f8             	decl   -0x8(%ebp)
  8018dc:	ff 4d fc             	decl   -0x4(%ebp)
  8018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e2:	8a 10                	mov    (%eax),%dl
  8018e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	75 e3                	jne    8018d9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018f6:	eb 23                	jmp    80191b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	8d 50 01             	lea    0x1(%eax),%edx
  8018fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801901:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801904:	8d 4a 01             	lea    0x1(%edx),%ecx
  801907:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80190a:	8a 12                	mov    (%edx),%dl
  80190c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80190e:	8b 45 10             	mov    0x10(%ebp),%eax
  801911:	8d 50 ff             	lea    -0x1(%eax),%edx
  801914:	89 55 10             	mov    %edx,0x10(%ebp)
  801917:	85 c0                	test   %eax,%eax
  801919:	75 dd                	jne    8018f8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80192c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801932:	eb 2a                	jmp    80195e <memcmp+0x3e>
		if (*s1 != *s2)
  801934:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801937:	8a 10                	mov    (%eax),%dl
  801939:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193c:	8a 00                	mov    (%eax),%al
  80193e:	38 c2                	cmp    %al,%dl
  801940:	74 16                	je     801958 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	0f b6 d0             	movzbl %al,%edx
  80194a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194d:	8a 00                	mov    (%eax),%al
  80194f:	0f b6 c0             	movzbl %al,%eax
  801952:	29 c2                	sub    %eax,%edx
  801954:	89 d0                	mov    %edx,%eax
  801956:	eb 18                	jmp    801970 <memcmp+0x50>
		s1++, s2++;
  801958:	ff 45 fc             	incl   -0x4(%ebp)
  80195b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80195e:	8b 45 10             	mov    0x10(%ebp),%eax
  801961:	8d 50 ff             	lea    -0x1(%eax),%edx
  801964:	89 55 10             	mov    %edx,0x10(%ebp)
  801967:	85 c0                	test   %eax,%eax
  801969:	75 c9                	jne    801934 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801978:	8b 55 08             	mov    0x8(%ebp),%edx
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	01 d0                	add    %edx,%eax
  801980:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801983:	eb 15                	jmp    80199a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	8a 00                	mov    (%eax),%al
  80198a:	0f b6 d0             	movzbl %al,%edx
  80198d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801990:	0f b6 c0             	movzbl %al,%eax
  801993:	39 c2                	cmp    %eax,%edx
  801995:	74 0d                	je     8019a4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801997:	ff 45 08             	incl   0x8(%ebp)
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019a0:	72 e3                	jb     801985 <memfind+0x13>
  8019a2:	eb 01                	jmp    8019a5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019a4:	90                   	nop
	return (void *) s;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019be:	eb 03                	jmp    8019c3 <strtol+0x19>
		s++;
  8019c0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	3c 20                	cmp    $0x20,%al
  8019ca:	74 f4                	je     8019c0 <strtol+0x16>
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	3c 09                	cmp    $0x9,%al
  8019d3:	74 eb                	je     8019c0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	3c 2b                	cmp    $0x2b,%al
  8019dc:	75 05                	jne    8019e3 <strtol+0x39>
		s++;
  8019de:	ff 45 08             	incl   0x8(%ebp)
  8019e1:	eb 13                	jmp    8019f6 <strtol+0x4c>
	else if (*s == '-')
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	3c 2d                	cmp    $0x2d,%al
  8019ea:	75 0a                	jne    8019f6 <strtol+0x4c>
		s++, neg = 1;
  8019ec:	ff 45 08             	incl   0x8(%ebp)
  8019ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019fa:	74 06                	je     801a02 <strtol+0x58>
  8019fc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a00:	75 20                	jne    801a22 <strtol+0x78>
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 30                	cmp    $0x30,%al
  801a09:	75 17                	jne    801a22 <strtol+0x78>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	40                   	inc    %eax
  801a0f:	8a 00                	mov    (%eax),%al
  801a11:	3c 78                	cmp    $0x78,%al
  801a13:	75 0d                	jne    801a22 <strtol+0x78>
		s += 2, base = 16;
  801a15:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a19:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a20:	eb 28                	jmp    801a4a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a26:	75 15                	jne    801a3d <strtol+0x93>
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	3c 30                	cmp    $0x30,%al
  801a2f:	75 0c                	jne    801a3d <strtol+0x93>
		s++, base = 8;
  801a31:	ff 45 08             	incl   0x8(%ebp)
  801a34:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a3b:	eb 0d                	jmp    801a4a <strtol+0xa0>
	else if (base == 0)
  801a3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a41:	75 07                	jne    801a4a <strtol+0xa0>
		base = 10;
  801a43:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8a 00                	mov    (%eax),%al
  801a4f:	3c 2f                	cmp    $0x2f,%al
  801a51:	7e 19                	jle    801a6c <strtol+0xc2>
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8a 00                	mov    (%eax),%al
  801a58:	3c 39                	cmp    $0x39,%al
  801a5a:	7f 10                	jg     801a6c <strtol+0xc2>
			dig = *s - '0';
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8a 00                	mov    (%eax),%al
  801a61:	0f be c0             	movsbl %al,%eax
  801a64:	83 e8 30             	sub    $0x30,%eax
  801a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a6a:	eb 42                	jmp    801aae <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8a 00                	mov    (%eax),%al
  801a71:	3c 60                	cmp    $0x60,%al
  801a73:	7e 19                	jle    801a8e <strtol+0xe4>
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8a 00                	mov    (%eax),%al
  801a7a:	3c 7a                	cmp    $0x7a,%al
  801a7c:	7f 10                	jg     801a8e <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	8a 00                	mov    (%eax),%al
  801a83:	0f be c0             	movsbl %al,%eax
  801a86:	83 e8 57             	sub    $0x57,%eax
  801a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a8c:	eb 20                	jmp    801aae <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	8a 00                	mov    (%eax),%al
  801a93:	3c 40                	cmp    $0x40,%al
  801a95:	7e 39                	jle    801ad0 <strtol+0x126>
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8a 00                	mov    (%eax),%al
  801a9c:	3c 5a                	cmp    $0x5a,%al
  801a9e:	7f 30                	jg     801ad0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	8a 00                	mov    (%eax),%al
  801aa5:	0f be c0             	movsbl %al,%eax
  801aa8:	83 e8 37             	sub    $0x37,%eax
  801aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ab4:	7d 19                	jge    801acf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801ab6:	ff 45 08             	incl   0x8(%ebp)
  801ab9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abc:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ac0:	89 c2                	mov    %eax,%edx
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	01 d0                	add    %edx,%eax
  801ac7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801aca:	e9 7b ff ff ff       	jmp    801a4a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801acf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ad0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ad4:	74 08                	je     801ade <strtol+0x134>
		*endptr = (char *) s;
  801ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  801adc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ade:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ae2:	74 07                	je     801aeb <strtol+0x141>
  801ae4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae7:	f7 d8                	neg    %eax
  801ae9:	eb 03                	jmp    801aee <strtol+0x144>
  801aeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <ltostr>:

void
ltostr(long value, char *str)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801afd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b08:	79 13                	jns    801b1d <ltostr+0x2d>
	{
		neg = 1;
  801b0a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b14:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b17:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b1a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b25:	99                   	cltd   
  801b26:	f7 f9                	idiv   %ecx
  801b28:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b2e:	8d 50 01             	lea    0x1(%eax),%edx
  801b31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b34:	89 c2                	mov    %eax,%edx
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	01 d0                	add    %edx,%eax
  801b3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b3e:	83 c2 30             	add    $0x30,%edx
  801b41:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b46:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b4b:	f7 e9                	imul   %ecx
  801b4d:	c1 fa 02             	sar    $0x2,%edx
  801b50:	89 c8                	mov    %ecx,%eax
  801b52:	c1 f8 1f             	sar    $0x1f,%eax
  801b55:	29 c2                	sub    %eax,%edx
  801b57:	89 d0                	mov    %edx,%eax
  801b59:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b60:	75 bb                	jne    801b1d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6c:	48                   	dec    %eax
  801b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b74:	74 3d                	je     801bb3 <ltostr+0xc3>
		start = 1 ;
  801b76:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b7d:	eb 34                	jmp    801bb3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b85:	01 d0                	add    %edx,%eax
  801b87:	8a 00                	mov    (%eax),%al
  801b89:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b92:	01 c2                	add    %eax,%edx
  801b94:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9a:	01 c8                	add    %ecx,%eax
  801b9c:	8a 00                	mov    (%eax),%al
  801b9e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ba0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba6:	01 c2                	add    %eax,%edx
  801ba8:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bab:	88 02                	mov    %al,(%edx)
		start++ ;
  801bad:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801bb0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bb9:	7c c4                	jl     801b7f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bbb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc1:	01 d0                	add    %edx,%eax
  801bc3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bc6:	90                   	nop
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	e8 c4 f9 ff ff       	call   80159b <strlen>
  801bd7:	83 c4 04             	add    $0x4,%esp
  801bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	e8 b6 f9 ff ff       	call   80159b <strlen>
  801be5:	83 c4 04             	add    $0x4,%esp
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801beb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bf9:	eb 17                	jmp    801c12 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801c01:	01 c2                	add    %eax,%edx
  801c03:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	01 c8                	add    %ecx,%eax
  801c0b:	8a 00                	mov    (%eax),%al
  801c0d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c0f:	ff 45 fc             	incl   -0x4(%ebp)
  801c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c18:	7c e1                	jl     801bfb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c21:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c28:	eb 1f                	jmp    801c49 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c2d:	8d 50 01             	lea    0x1(%eax),%edx
  801c30:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c33:	89 c2                	mov    %eax,%edx
  801c35:	8b 45 10             	mov    0x10(%ebp),%eax
  801c38:	01 c2                	add    %eax,%edx
  801c3a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c40:	01 c8                	add    %ecx,%eax
  801c42:	8a 00                	mov    (%eax),%al
  801c44:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c46:	ff 45 f8             	incl   -0x8(%ebp)
  801c49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c4c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c4f:	7c d9                	jl     801c2a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c54:	8b 45 10             	mov    0x10(%ebp),%eax
  801c57:	01 d0                	add    %edx,%eax
  801c59:	c6 00 00             	movb   $0x0,(%eax)
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c62:	8b 45 14             	mov    0x14(%ebp),%eax
  801c65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6e:	8b 00                	mov    (%eax),%eax
  801c70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c77:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7a:	01 d0                	add    %edx,%eax
  801c7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c82:	eb 0c                	jmp    801c90 <strsplit+0x31>
			*string++ = 0;
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	8d 50 01             	lea    0x1(%eax),%edx
  801c8a:	89 55 08             	mov    %edx,0x8(%ebp)
  801c8d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	8a 00                	mov    (%eax),%al
  801c95:	84 c0                	test   %al,%al
  801c97:	74 18                	je     801cb1 <strsplit+0x52>
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	8a 00                	mov    (%eax),%al
  801c9e:	0f be c0             	movsbl %al,%eax
  801ca1:	50                   	push   %eax
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	e8 83 fa ff ff       	call   80172d <strchr>
  801caa:	83 c4 08             	add    $0x8,%esp
  801cad:	85 c0                	test   %eax,%eax
  801caf:	75 d3                	jne    801c84 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	8a 00                	mov    (%eax),%al
  801cb6:	84 c0                	test   %al,%al
  801cb8:	74 5a                	je     801d14 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801cba:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbd:	8b 00                	mov    (%eax),%eax
  801cbf:	83 f8 0f             	cmp    $0xf,%eax
  801cc2:	75 07                	jne    801ccb <strsplit+0x6c>
		{
			return 0;
  801cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc9:	eb 66                	jmp    801d31 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cce:	8b 00                	mov    (%eax),%eax
  801cd0:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd3:	8b 55 14             	mov    0x14(%ebp),%edx
  801cd6:	89 0a                	mov    %ecx,(%edx)
  801cd8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce2:	01 c2                	add    %eax,%edx
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ce9:	eb 03                	jmp    801cee <strsplit+0x8f>
			string++;
  801ceb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	8a 00                	mov    (%eax),%al
  801cf3:	84 c0                	test   %al,%al
  801cf5:	74 8b                	je     801c82 <strsplit+0x23>
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	0f be c0             	movsbl %al,%eax
  801cff:	50                   	push   %eax
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	e8 25 fa ff ff       	call   80172d <strchr>
  801d08:	83 c4 08             	add    $0x8,%esp
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 dc                	je     801ceb <strsplit+0x8c>
			string++;
	}
  801d0f:	e9 6e ff ff ff       	jmp    801c82 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d14:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d15:	8b 45 14             	mov    0x14(%ebp),%eax
  801d18:	8b 00                	mov    (%eax),%eax
  801d1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d21:	8b 45 10             	mov    0x10(%ebp),%eax
  801d24:	01 d0                	add    %edx,%eax
  801d26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d2c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d46:	eb 4a                	jmp    801d92 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	01 c2                	add    %eax,%edx
  801d50:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d56:	01 c8                	add    %ecx,%eax
  801d58:	8a 00                	mov    (%eax),%al
  801d5a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d62:	01 d0                	add    %edx,%eax
  801d64:	8a 00                	mov    (%eax),%al
  801d66:	3c 40                	cmp    $0x40,%al
  801d68:	7e 25                	jle    801d8f <str2lower+0x5c>
  801d6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d70:	01 d0                	add    %edx,%eax
  801d72:	8a 00                	mov    (%eax),%al
  801d74:	3c 5a                	cmp    $0x5a,%al
  801d76:	7f 17                	jg     801d8f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	01 d0                	add    %edx,%eax
  801d80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d83:	8b 55 08             	mov    0x8(%ebp),%edx
  801d86:	01 ca                	add    %ecx,%edx
  801d88:	8a 12                	mov    (%edx),%dl
  801d8a:	83 c2 20             	add    $0x20,%edx
  801d8d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d8f:	ff 45 fc             	incl   -0x4(%ebp)
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	e8 01 f8 ff ff       	call   80159b <strlen>
  801d9a:	83 c4 04             	add    $0x4,%esp
  801d9d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801da0:	7f a6                	jg     801d48 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	6a 10                	push   $0x10
  801db2:	e8 b2 15 00 00       	call   803369 <alloc_block>
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801dbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dc1:	75 14                	jne    801dd7 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	68 7c 48 80 00       	push   $0x80487c
  801dcb:	6a 14                	push   $0x14
  801dcd:	68 a5 48 80 00       	push   $0x8048a5
  801dd2:	e8 f5 eb ff ff       	call   8009cc <_panic>

	node->start = start;
  801dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dda:	8b 55 08             	mov    0x8(%ebp),%edx
  801ddd:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de5:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801de8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801def:	a1 28 50 80 00       	mov    0x805028,%eax
  801df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df7:	eb 18                	jmp    801e11 <insert_page_alloc+0x6a>
		if (start < it->start)
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	8b 00                	mov    (%eax),%eax
  801dfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e01:	77 37                	ja     801e3a <insert_page_alloc+0x93>
			break;
		prev = it;
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801e09:	a1 30 50 80 00       	mov    0x805030,%eax
  801e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e15:	74 08                	je     801e1f <insert_page_alloc+0x78>
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	8b 40 08             	mov    0x8(%eax),%eax
  801e1d:	eb 05                	jmp    801e24 <insert_page_alloc+0x7d>
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	a3 30 50 80 00       	mov    %eax,0x805030
  801e29:	a1 30 50 80 00       	mov    0x805030,%eax
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	75 c7                	jne    801df9 <insert_page_alloc+0x52>
  801e32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e36:	75 c1                	jne    801df9 <insert_page_alloc+0x52>
  801e38:	eb 01                	jmp    801e3b <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801e3a:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e3f:	75 64                	jne    801ea5 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801e41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e45:	75 14                	jne    801e5b <insert_page_alloc+0xb4>
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	68 b4 48 80 00       	push   $0x8048b4
  801e4f:	6a 21                	push   $0x21
  801e51:	68 a5 48 80 00       	push   $0x8048a5
  801e56:	e8 71 eb ff ff       	call   8009cc <_panic>
  801e5b:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e64:	89 50 08             	mov    %edx,0x8(%eax)
  801e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6a:	8b 40 08             	mov    0x8(%eax),%eax
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	74 0d                	je     801e7e <insert_page_alloc+0xd7>
  801e71:	a1 28 50 80 00       	mov    0x805028,%eax
  801e76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e79:	89 50 0c             	mov    %edx,0xc(%eax)
  801e7c:	eb 08                	jmp    801e86 <insert_page_alloc+0xdf>
  801e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e81:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e89:	a3 28 50 80 00       	mov    %eax,0x805028
  801e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e98:	a1 34 50 80 00       	mov    0x805034,%eax
  801e9d:	40                   	inc    %eax
  801e9e:	a3 34 50 80 00       	mov    %eax,0x805034
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801ea3:	eb 71                	jmp    801f16 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801ea5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ea9:	74 06                	je     801eb1 <insert_page_alloc+0x10a>
  801eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eaf:	75 14                	jne    801ec5 <insert_page_alloc+0x11e>
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	68 d8 48 80 00       	push   $0x8048d8
  801eb9:	6a 23                	push   $0x23
  801ebb:	68 a5 48 80 00       	push   $0x8048a5
  801ec0:	e8 07 eb ff ff       	call   8009cc <_panic>
  801ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec8:	8b 50 08             	mov    0x8(%eax),%edx
  801ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ece:	89 50 08             	mov    %edx,0x8(%eax)
  801ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed4:	8b 40 08             	mov    0x8(%eax),%eax
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	74 0c                	je     801ee7 <insert_page_alloc+0x140>
  801edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ede:	8b 40 08             	mov    0x8(%eax),%eax
  801ee1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ee4:	89 50 0c             	mov    %edx,0xc(%eax)
  801ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eed:	89 50 08             	mov    %edx,0x8(%eax)
  801ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef6:	89 50 0c             	mov    %edx,0xc(%eax)
  801ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efc:	8b 40 08             	mov    0x8(%eax),%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	75 08                	jne    801f0b <insert_page_alloc+0x164>
  801f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f06:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f0b:	a1 34 50 80 00       	mov    0x805034,%eax
  801f10:	40                   	inc    %eax
  801f11:	a3 34 50 80 00       	mov    %eax,0x805034
}
  801f16:	90                   	nop
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801f1f:	a1 28 50 80 00       	mov    0x805028,%eax
  801f24:	85 c0                	test   %eax,%eax
  801f26:	75 0c                	jne    801f34 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801f28:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f2d:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801f32:	eb 67                	jmp    801f9b <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801f34:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f3c:	a1 28 50 80 00       	mov    0x805028,%eax
  801f41:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801f44:	eb 26                	jmp    801f6c <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f49:	8b 10                	mov    (%eax),%edx
  801f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f4e:	8b 40 04             	mov    0x4(%eax),%eax
  801f51:	01 d0                	add    %edx,%eax
  801f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f5c:	76 06                	jbe    801f64 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f64:	a1 30 50 80 00       	mov    0x805030,%eax
  801f69:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801f6c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f70:	74 08                	je     801f7a <recompute_page_alloc_break+0x61>
  801f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f75:	8b 40 08             	mov    0x8(%eax),%eax
  801f78:	eb 05                	jmp    801f7f <recompute_page_alloc_break+0x66>
  801f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7f:	a3 30 50 80 00       	mov    %eax,0x805030
  801f84:	a1 30 50 80 00       	mov    0x805030,%eax
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	75 b9                	jne    801f46 <recompute_page_alloc_break+0x2d>
  801f8d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f91:	75 b3                	jne    801f46 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f96:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801fa3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801faa:	8b 55 08             	mov    0x8(%ebp),%edx
  801fad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fb0:	01 d0                	add    %edx,%eax
  801fb2:	48                   	dec    %eax
  801fb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801fb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbe:	f7 75 d8             	divl   -0x28(%ebp)
  801fc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc4:	29 d0                	sub    %edx,%eax
  801fc6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801fc9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801fcd:	75 0a                	jne    801fd9 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	e9 7e 01 00 00       	jmp    802157 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801fd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801fe0:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801fe4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801feb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801ff2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801ffa:	a1 28 50 80 00       	mov    0x805028,%eax
  801fff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802002:	eb 69                	jmp    80206d <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802004:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802007:	8b 00                	mov    (%eax),%eax
  802009:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80200c:	76 47                	jbe    802055 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80200e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802011:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  802014:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802017:	8b 00                	mov    (%eax),%eax
  802019:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80201c:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  80201f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802022:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802025:	72 2e                	jb     802055 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  802027:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80202b:	75 14                	jne    802041 <alloc_pages_custom_fit+0xa4>
  80202d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802030:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802033:	75 0c                	jne    802041 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  802035:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802038:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  80203b:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80203f:	eb 14                	jmp    802055 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802041:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802044:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802047:	76 0c                	jbe    802055 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802049:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80204c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80204f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802052:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802055:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802058:	8b 10                	mov    (%eax),%edx
  80205a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80205d:	8b 40 04             	mov    0x4(%eax),%eax
  802060:	01 d0                	add    %edx,%eax
  802062:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802065:	a1 30 50 80 00       	mov    0x805030,%eax
  80206a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80206d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802071:	74 08                	je     80207b <alloc_pages_custom_fit+0xde>
  802073:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802076:	8b 40 08             	mov    0x8(%eax),%eax
  802079:	eb 05                	jmp    802080 <alloc_pages_custom_fit+0xe3>
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
  802080:	a3 30 50 80 00       	mov    %eax,0x805030
  802085:	a1 30 50 80 00       	mov    0x805030,%eax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	0f 85 72 ff ff ff    	jne    802004 <alloc_pages_custom_fit+0x67>
  802092:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802096:	0f 85 68 ff ff ff    	jne    802004 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  80209c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020a1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020a4:	76 47                	jbe    8020ed <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8020a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8020ac:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8020b4:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8020b7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020ba:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020bd:	72 2e                	jb     8020ed <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8020bf:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8020c3:	75 14                	jne    8020d9 <alloc_pages_custom_fit+0x13c>
  8020c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020c8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020cb:	75 0c                	jne    8020d9 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8020cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8020d3:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8020d7:	eb 14                	jmp    8020ed <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8020d9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020dc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020df:	76 0c                	jbe    8020ed <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  8020e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  8020e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  8020ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  8020f4:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8020f8:	74 08                	je     802102 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802100:	eb 40                	jmp    802142 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802102:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802106:	74 08                	je     802110 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80210e:	eb 32                	jmp    802142 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802110:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802115:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802118:	89 c2                	mov    %eax,%edx
  80211a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80211f:	39 c2                	cmp    %eax,%edx
  802121:	73 07                	jae    80212a <alloc_pages_custom_fit+0x18d>
			return NULL;
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	eb 2d                	jmp    802157 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  80212a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80212f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802132:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802138:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80213b:	01 d0                	add    %edx,%eax
  80213d:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  802142:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802145:	83 ec 08             	sub    $0x8,%esp
  802148:	ff 75 d0             	pushl  -0x30(%ebp)
  80214b:	50                   	push   %eax
  80214c:	e8 56 fc ff ff       	call   801da7 <insert_page_alloc>
  802151:	83 c4 10             	add    $0x10,%esp

	return result;
  802154:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802165:	a1 28 50 80 00       	mov    0x805028,%eax
  80216a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80216d:	eb 1a                	jmp    802189 <find_allocated_size+0x30>
		if (it->start == va)
  80216f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802172:	8b 00                	mov    (%eax),%eax
  802174:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802177:	75 08                	jne    802181 <find_allocated_size+0x28>
			return it->size;
  802179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217c:	8b 40 04             	mov    0x4(%eax),%eax
  80217f:	eb 34                	jmp    8021b5 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802181:	a1 30 50 80 00       	mov    0x805030,%eax
  802186:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802189:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80218d:	74 08                	je     802197 <find_allocated_size+0x3e>
  80218f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802192:	8b 40 08             	mov    0x8(%eax),%eax
  802195:	eb 05                	jmp    80219c <find_allocated_size+0x43>
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	a3 30 50 80 00       	mov    %eax,0x805030
  8021a1:	a1 30 50 80 00       	mov    0x805030,%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	75 c5                	jne    80216f <find_allocated_size+0x16>
  8021aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ae:	75 bf                	jne    80216f <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8021b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8021c3:	a1 28 50 80 00       	mov    0x805028,%eax
  8021c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cb:	e9 e1 01 00 00       	jmp    8023b1 <free_pages+0x1fa>
		if (it->start == va) {
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021d8:	0f 85 cb 01 00 00    	jne    8023a9 <free_pages+0x1f2>

			uint32 start = it->start;
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 40 04             	mov    0x4(%eax),%eax
  8021ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  8021ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f2:	f7 d0                	not    %eax
  8021f4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8021f7:	73 1d                	jae    802216 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021ff:	ff 75 e8             	pushl  -0x18(%ebp)
  802202:	68 0c 49 80 00       	push   $0x80490c
  802207:	68 a5 00 00 00       	push   $0xa5
  80220c:	68 a5 48 80 00       	push   $0x8048a5
  802211:	e8 b6 e7 ff ff       	call   8009cc <_panic>
			}

			uint32 start_end = start + size;
  802216:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221c:	01 d0                	add    %edx,%eax
  80221e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	79 19                	jns    802241 <free_pages+0x8a>
  802228:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80222f:	77 10                	ja     802241 <free_pages+0x8a>
  802231:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802238:	77 07                	ja     802241 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  80223a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	78 2c                	js     80226d <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802244:	83 ec 0c             	sub    $0xc,%esp
  802247:	68 00 00 00 a0       	push   $0xa0000000
  80224c:	ff 75 e0             	pushl  -0x20(%ebp)
  80224f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802252:	ff 75 e8             	pushl  -0x18(%ebp)
  802255:	ff 75 e4             	pushl  -0x1c(%ebp)
  802258:	50                   	push   %eax
  802259:	68 50 49 80 00       	push   $0x804950
  80225e:	68 ad 00 00 00       	push   $0xad
  802263:	68 a5 48 80 00       	push   $0x8048a5
  802268:	e8 5f e7 ff ff       	call   8009cc <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80226d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802270:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802273:	e9 88 00 00 00       	jmp    802300 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802278:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  80227f:	76 17                	jbe    802298 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802281:	ff 75 f0             	pushl  -0x10(%ebp)
  802284:	68 b4 49 80 00       	push   $0x8049b4
  802289:	68 b4 00 00 00       	push   $0xb4
  80228e:	68 a5 48 80 00       	push   $0x8048a5
  802293:	e8 34 e7 ff ff       	call   8009cc <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229b:	05 00 10 00 00       	add    $0x1000,%eax
  8022a0:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8022a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	79 2e                	jns    8022d8 <free_pages+0x121>
  8022aa:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8022b1:	77 25                	ja     8022d8 <free_pages+0x121>
  8022b3:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8022ba:	77 1c                	ja     8022d8 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8022bc:	83 ec 08             	sub    $0x8,%esp
  8022bf:	68 00 10 00 00       	push   $0x1000
  8022c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8022c7:	e8 38 0d 00 00       	call   803004 <sys_free_user_mem>
  8022cc:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8022cf:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8022d6:	eb 28                	jmp    802300 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	68 00 00 00 a0       	push   $0xa0000000
  8022e0:	ff 75 dc             	pushl  -0x24(%ebp)
  8022e3:	68 00 10 00 00       	push   $0x1000
  8022e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8022eb:	50                   	push   %eax
  8022ec:	68 f4 49 80 00       	push   $0x8049f4
  8022f1:	68 bd 00 00 00       	push   $0xbd
  8022f6:	68 a5 48 80 00       	push   $0x8048a5
  8022fb:	e8 cc e6 ff ff       	call   8009cc <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802303:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802306:	0f 82 6c ff ff ff    	jb     802278 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  80230c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802310:	75 17                	jne    802329 <free_pages+0x172>
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	68 56 4a 80 00       	push   $0x804a56
  80231a:	68 c1 00 00 00       	push   $0xc1
  80231f:	68 a5 48 80 00       	push   $0x8048a5
  802324:	e8 a3 e6 ff ff       	call   8009cc <_panic>
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 40 08             	mov    0x8(%eax),%eax
  80232f:	85 c0                	test   %eax,%eax
  802331:	74 11                	je     802344 <free_pages+0x18d>
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 40 08             	mov    0x8(%eax),%eax
  802339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233c:	8b 52 0c             	mov    0xc(%edx),%edx
  80233f:	89 50 0c             	mov    %edx,0xc(%eax)
  802342:	eb 0b                	jmp    80234f <free_pages+0x198>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 40 0c             	mov    0xc(%eax),%eax
  80234a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 40 0c             	mov    0xc(%eax),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	74 11                	je     80236a <free_pages+0x1b3>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 40 0c             	mov    0xc(%eax),%eax
  80235f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802362:	8b 52 08             	mov    0x8(%edx),%edx
  802365:	89 50 08             	mov    %edx,0x8(%eax)
  802368:	eb 0b                	jmp    802375 <free_pages+0x1be>
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 40 08             	mov    0x8(%eax),%eax
  802370:	a3 28 50 80 00       	mov    %eax,0x805028
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802389:	a1 34 50 80 00       	mov    0x805034,%eax
  80238e:	48                   	dec    %eax
  80238f:	a3 34 50 80 00       	mov    %eax,0x805034
			free_block(it);
  802394:	83 ec 0c             	sub    $0xc,%esp
  802397:	ff 75 f4             	pushl  -0xc(%ebp)
  80239a:	e8 24 15 00 00       	call   8038c3 <free_block>
  80239f:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8023a2:	e8 72 fb ff ff       	call   801f19 <recompute_page_alloc_break>

			return;
  8023a7:	eb 37                	jmp    8023e0 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8023a9:	a1 30 50 80 00       	mov    0x805030,%eax
  8023ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b5:	74 08                	je     8023bf <free_pages+0x208>
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 08             	mov    0x8(%eax),%eax
  8023bd:	eb 05                	jmp    8023c4 <free_pages+0x20d>
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8023c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	0f 85 fa fd ff ff    	jne    8021d0 <free_pages+0x19>
  8023d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023da:	0f 85 f0 fd ff ff    	jne    8021d0 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    

008023ec <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8023f2:	a1 08 50 80 00       	mov    0x805008,%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	74 60                	je     80245b <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8023fb:	83 ec 08             	sub    $0x8,%esp
  8023fe:	68 00 00 00 82       	push   $0x82000000
  802403:	68 00 00 00 80       	push   $0x80000000
  802408:	e8 0d 0d 00 00       	call   80311a <initialize_dynamic_allocator>
  80240d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802410:	e8 f3 0a 00 00       	call   802f08 <sys_get_uheap_strategy>
  802415:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80241a:	a1 40 50 80 00       	mov    0x805040,%eax
  80241f:	05 00 10 00 00       	add    $0x1000,%eax
  802424:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  802429:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80242e:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  802433:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  80243a:	00 00 00 
  80243d:	c7 05 2c 50 80 00 00 	movl   $0x0,0x80502c
  802444:	00 00 00 
  802447:	c7 05 34 50 80 00 00 	movl   $0x0,0x805034
  80244e:	00 00 00 

		__firstTimeFlag = 0;
  802451:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802458:	00 00 00 
	}
}
  80245b:	90                   	nop
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802472:	83 ec 08             	sub    $0x8,%esp
  802475:	68 06 04 00 00       	push   $0x406
  80247a:	50                   	push   %eax
  80247b:	e8 d2 06 00 00       	call   802b52 <__sys_allocate_page>
  802480:	83 c4 10             	add    $0x10,%esp
  802483:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802486:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248a:	79 17                	jns    8024a3 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  80248c:	83 ec 04             	sub    $0x4,%esp
  80248f:	68 74 4a 80 00       	push   $0x804a74
  802494:	68 ea 00 00 00       	push   $0xea
  802499:	68 a5 48 80 00       	push   $0x8048a5
  80249e:	e8 29 e5 ff ff       	call   8009cc <_panic>
	return 0;
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	50                   	push   %eax
  8024c2:	e8 d2 06 00 00       	call   802b99 <__sys_unmap_frame>
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8024cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024d1:	79 17                	jns    8024ea <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  8024d3:	83 ec 04             	sub    $0x4,%esp
  8024d6:	68 b0 4a 80 00       	push   $0x804ab0
  8024db:	68 f5 00 00 00       	push   $0xf5
  8024e0:	68 a5 48 80 00       	push   $0x8048a5
  8024e5:	e8 e2 e4 ff ff       	call   8009cc <_panic>
}
  8024ea:	90                   	nop
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024f3:	e8 f4 fe ff ff       	call   8023ec <uheap_init>
	if (size == 0) return NULL ;
  8024f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024fc:	75 0a                	jne    802508 <malloc+0x1b>
  8024fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802503:	e9 67 01 00 00       	jmp    80266f <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802508:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80250f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802516:	77 16                	ja     80252e <malloc+0x41>
		result = alloc_block(size);
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	ff 75 08             	pushl  0x8(%ebp)
  80251e:	e8 46 0e 00 00       	call   803369 <alloc_block>
  802523:	83 c4 10             	add    $0x10,%esp
  802526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802529:	e9 3e 01 00 00       	jmp    80266c <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  80252e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802535:	8b 55 08             	mov    0x8(%ebp),%edx
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	01 d0                	add    %edx,%eax
  80253d:	48                   	dec    %eax
  80253e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802541:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802544:	ba 00 00 00 00       	mov    $0x0,%edx
  802549:	f7 75 f0             	divl   -0x10(%ebp)
  80254c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254f:	29 d0                	sub    %edx,%eax
  802551:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802554:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	75 0a                	jne    802567 <malloc+0x7a>
			return NULL;
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
  802562:	e9 08 01 00 00       	jmp    80266f <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802567:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	74 0f                	je     80257f <malloc+0x92>
  802570:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802576:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80257b:	39 c2                	cmp    %eax,%edx
  80257d:	73 0a                	jae    802589 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  80257f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802584:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802589:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80258e:	83 f8 05             	cmp    $0x5,%eax
  802591:	75 11                	jne    8025a4 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	ff 75 e8             	pushl  -0x18(%ebp)
  802599:	e8 ff f9 ff ff       	call   801f9d <alloc_pages_custom_fit>
  80259e:	83 c4 10             	add    $0x10,%esp
  8025a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8025a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a8:	0f 84 be 00 00 00    	je     80266c <malloc+0x17f>
			uint32 result_va = (uint32)result;
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ba:	e8 9a fb ff ff       	call   802159 <find_allocated_size>
  8025bf:	83 c4 10             	add    $0x10,%esp
  8025c2:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8025c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025c9:	75 17                	jne    8025e2 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8025cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ce:	68 f0 4a 80 00       	push   $0x804af0
  8025d3:	68 24 01 00 00       	push   $0x124
  8025d8:	68 a5 48 80 00       	push   $0x8048a5
  8025dd:	e8 ea e3 ff ff       	call   8009cc <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8025e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e5:	f7 d0                	not    %eax
  8025e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025ea:	73 1d                	jae    802609 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8025ec:	83 ec 0c             	sub    $0xc,%esp
  8025ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8025f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025f5:	68 38 4b 80 00       	push   $0x804b38
  8025fa:	68 29 01 00 00       	push   $0x129
  8025ff:	68 a5 48 80 00       	push   $0x8048a5
  802604:	e8 c3 e3 ff ff       	call   8009cc <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802609:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260f:	01 d0                	add    %edx,%eax
  802611:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	79 2c                	jns    802647 <malloc+0x15a>
  80261b:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802622:	77 23                	ja     802647 <malloc+0x15a>
  802624:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80262b:	77 1a                	ja     802647 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80262d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	79 13                	jns    802647 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802634:	83 ec 08             	sub    $0x8,%esp
  802637:	ff 75 e0             	pushl  -0x20(%ebp)
  80263a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80263d:	e8 de 09 00 00       	call   803020 <sys_allocate_user_mem>
  802642:	83 c4 10             	add    $0x10,%esp
  802645:	eb 25                	jmp    80266c <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802647:	68 00 00 00 a0       	push   $0xa0000000
  80264c:	ff 75 dc             	pushl  -0x24(%ebp)
  80264f:	ff 75 e0             	pushl  -0x20(%ebp)
  802652:	ff 75 e4             	pushl  -0x1c(%ebp)
  802655:	ff 75 f4             	pushl  -0xc(%ebp)
  802658:	68 74 4b 80 00       	push   $0x804b74
  80265d:	68 33 01 00 00       	push   $0x133
  802662:	68 a5 48 80 00       	push   $0x8048a5
  802667:	e8 60 e3 ff ff       	call   8009cc <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802677:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267b:	0f 84 26 01 00 00    	je     8027a7 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	79 1c                	jns    8026aa <free+0x39>
  80268e:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802695:	77 13                	ja     8026aa <free+0x39>
		free_block(virtual_address);
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	ff 75 08             	pushl  0x8(%ebp)
  80269d:	e8 21 12 00 00       	call   8038c3 <free_block>
  8026a2:	83 c4 10             	add    $0x10,%esp
		return;
  8026a5:	e9 01 01 00 00       	jmp    8027ab <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8026aa:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8026b2:	0f 82 d8 00 00 00    	jb     802790 <free+0x11f>
  8026b8:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8026bf:	0f 87 cb 00 00 00    	ja     802790 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	25 ff 0f 00 00       	and    $0xfff,%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 17                	je     8026e8 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8026d1:	ff 75 08             	pushl  0x8(%ebp)
  8026d4:	68 e4 4b 80 00       	push   $0x804be4
  8026d9:	68 57 01 00 00       	push   $0x157
  8026de:	68 a5 48 80 00       	push   $0x8048a5
  8026e3:	e8 e4 e2 ff ff       	call   8009cc <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	ff 75 08             	pushl  0x8(%ebp)
  8026ee:	e8 66 fa ff ff       	call   802159 <find_allocated_size>
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8026f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fd:	0f 84 a7 00 00 00    	je     8027aa <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	f7 d0                	not    %eax
  802708:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80270b:	73 1d                	jae    80272a <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  80270d:	83 ec 0c             	sub    $0xc,%esp
  802710:	ff 75 f0             	pushl  -0x10(%ebp)
  802713:	ff 75 f4             	pushl  -0xc(%ebp)
  802716:	68 0c 4c 80 00       	push   $0x804c0c
  80271b:	68 61 01 00 00       	push   $0x161
  802720:	68 a5 48 80 00       	push   $0x8048a5
  802725:	e8 a2 e2 ff ff       	call   8009cc <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80272a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	01 d0                	add    %edx,%eax
  802732:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	79 19                	jns    802755 <free+0xe4>
  80273c:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802743:	77 10                	ja     802755 <free+0xe4>
  802745:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80274c:	77 07                	ja     802755 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80274e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	78 2b                	js     802780 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802755:	83 ec 0c             	sub    $0xc,%esp
  802758:	68 00 00 00 a0       	push   $0xa0000000
  80275d:	ff 75 ec             	pushl  -0x14(%ebp)
  802760:	ff 75 f0             	pushl  -0x10(%ebp)
  802763:	ff 75 f4             	pushl  -0xc(%ebp)
  802766:	ff 75 f0             	pushl  -0x10(%ebp)
  802769:	ff 75 08             	pushl  0x8(%ebp)
  80276c:	68 48 4c 80 00       	push   $0x804c48
  802771:	68 69 01 00 00       	push   $0x169
  802776:	68 a5 48 80 00       	push   $0x8048a5
  80277b:	e8 4c e2 ff ff       	call   8009cc <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802780:	83 ec 0c             	sub    $0xc,%esp
  802783:	ff 75 08             	pushl  0x8(%ebp)
  802786:	e8 2c fa ff ff       	call   8021b7 <free_pages>
  80278b:	83 c4 10             	add    $0x10,%esp
		return;
  80278e:	eb 1b                	jmp    8027ab <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802790:	ff 75 08             	pushl  0x8(%ebp)
  802793:	68 a4 4c 80 00       	push   $0x804ca4
  802798:	68 70 01 00 00       	push   $0x170
  80279d:	68 a5 48 80 00       	push   $0x8048a5
  8027a2:	e8 25 e2 ff ff       	call   8009cc <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8027a7:	90                   	nop
  8027a8:	eb 01                	jmp    8027ab <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8027aa:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8027ab:	c9                   	leave  
  8027ac:	c3                   	ret    

008027ad <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
  8027b0:	83 ec 38             	sub    $0x38,%esp
  8027b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8027b6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027b9:	e8 2e fc ff ff       	call   8023ec <uheap_init>
	if (size == 0) return NULL ;
  8027be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027c2:	75 0a                	jne    8027ce <smalloc+0x21>
  8027c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c9:	e9 3d 01 00 00       	jmp    80290b <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8027ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8027d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8027dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8027df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e3:	74 0e                	je     8027f3 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8027eb:	05 00 10 00 00       	add    $0x1000,%eax
  8027f0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	c1 e8 0c             	shr    $0xc,%eax
  8027f9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8027fc:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802801:	85 c0                	test   %eax,%eax
  802803:	75 0a                	jne    80280f <smalloc+0x62>
		return NULL;
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
  80280a:	e9 fc 00 00 00       	jmp    80290b <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80280f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 0f                	je     802827 <smalloc+0x7a>
  802818:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80281e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802823:	39 c2                	cmp    %eax,%edx
  802825:	73 0a                	jae    802831 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802827:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80282c:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802831:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802836:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80283b:	29 c2                	sub    %eax,%edx
  80283d:	89 d0                	mov    %edx,%eax
  80283f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802842:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802848:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80284d:	29 c2                	sub    %eax,%edx
  80284f:	89 d0                	mov    %edx,%eax
  802851:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80285a:	77 13                	ja     80286f <smalloc+0xc2>
  80285c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802862:	77 0b                	ja     80286f <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802867:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80286a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80286d:	73 0a                	jae    802879 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80286f:	b8 00 00 00 00       	mov    $0x0,%eax
  802874:	e9 92 00 00 00       	jmp    80290b <smalloc+0x15e>
	}

	void *va = NULL;
  802879:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802880:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802885:	83 f8 05             	cmp    $0x5,%eax
  802888:	75 11                	jne    80289b <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80288a:	83 ec 0c             	sub    $0xc,%esp
  80288d:	ff 75 f4             	pushl  -0xc(%ebp)
  802890:	e8 08 f7 ff ff       	call   801f9d <alloc_pages_custom_fit>
  802895:	83 c4 10             	add    $0x10,%esp
  802898:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80289b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80289f:	75 27                	jne    8028c8 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8028a1:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8028a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ab:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028ae:	89 c2                	mov    %eax,%edx
  8028b0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028b5:	39 c2                	cmp    %eax,%edx
  8028b7:	73 07                	jae    8028c0 <smalloc+0x113>
			return NULL;}
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	eb 4b                	jmp    80290b <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8028c0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8028c8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8028cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8028cf:	50                   	push   %eax
  8028d0:	ff 75 0c             	pushl  0xc(%ebp)
  8028d3:	ff 75 08             	pushl  0x8(%ebp)
  8028d6:	e8 cb 03 00 00       	call   802ca6 <sys_create_shared_object>
  8028db:	83 c4 10             	add    $0x10,%esp
  8028de:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8028e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8028e5:	79 07                	jns    8028ee <smalloc+0x141>
		return NULL;
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ec:	eb 1d                	jmp    80290b <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8028ee:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8028f3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8028f6:	75 10                	jne    802908 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8028f8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  80290b:	c9                   	leave  
  80290c:	c3                   	ret    

0080290d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802913:	e8 d4 fa ff ff       	call   8023ec <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802918:	83 ec 08             	sub    $0x8,%esp
  80291b:	ff 75 0c             	pushl  0xc(%ebp)
  80291e:	ff 75 08             	pushl  0x8(%ebp)
  802921:	e8 aa 03 00 00       	call   802cd0 <sys_size_of_shared_object>
  802926:	83 c4 10             	add    $0x10,%esp
  802929:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80292c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802930:	7f 0a                	jg     80293c <sget+0x2f>
		return NULL;
  802932:	b8 00 00 00 00       	mov    $0x0,%eax
  802937:	e9 32 01 00 00       	jmp    802a6e <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80293c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802942:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802945:	25 ff 0f 00 00       	and    $0xfff,%eax
  80294a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80294d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802951:	74 0e                	je     802961 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802959:	05 00 10 00 00       	add    $0x1000,%eax
  80295e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802961:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802966:	85 c0                	test   %eax,%eax
  802968:	75 0a                	jne    802974 <sget+0x67>
		return NULL;
  80296a:	b8 00 00 00 00       	mov    $0x0,%eax
  80296f:	e9 fa 00 00 00       	jmp    802a6e <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802974:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	74 0f                	je     80298c <sget+0x7f>
  80297d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802983:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802988:	39 c2                	cmp    %eax,%edx
  80298a:	73 0a                	jae    802996 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80298c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802991:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802996:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80299b:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8029a0:	29 c2                	sub    %eax,%edx
  8029a2:	89 d0                	mov    %edx,%eax
  8029a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8029a7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8029ad:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8029b2:	29 c2                	sub    %eax,%edx
  8029b4:	89 d0                	mov    %edx,%eax
  8029b6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029bf:	77 13                	ja     8029d4 <sget+0xc7>
  8029c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029c7:	77 0b                	ja     8029d4 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8029c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cc:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8029cf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8029d2:	73 0a                	jae    8029de <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8029d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d9:	e9 90 00 00 00       	jmp    802a6e <sget+0x161>

	void *va = NULL;
  8029de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8029e5:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8029ea:	83 f8 05             	cmp    $0x5,%eax
  8029ed:	75 11                	jne    802a00 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8029ef:	83 ec 0c             	sub    $0xc,%esp
  8029f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8029f5:	e8 a3 f5 ff ff       	call   801f9d <alloc_pages_custom_fit>
  8029fa:	83 c4 10             	add    $0x10,%esp
  8029fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802a00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a04:	75 27                	jne    802a2d <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802a06:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802a0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a10:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a13:	89 c2                	mov    %eax,%edx
  802a15:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a1a:	39 c2                	cmp    %eax,%edx
  802a1c:	73 07                	jae    802a25 <sget+0x118>
			return NULL;
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a23:	eb 49                	jmp    802a6e <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802a25:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	ff 75 f0             	pushl  -0x10(%ebp)
  802a33:	ff 75 0c             	pushl  0xc(%ebp)
  802a36:	ff 75 08             	pushl  0x8(%ebp)
  802a39:	e8 af 02 00 00       	call   802ced <sys_get_shared_object>
  802a3e:	83 c4 10             	add    $0x10,%esp
  802a41:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802a44:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a48:	79 07                	jns    802a51 <sget+0x144>
		return NULL;
  802a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4f:	eb 1d                	jmp    802a6e <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802a51:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802a56:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802a59:	75 10                	jne    802a6b <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802a5b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	01 d0                	add    %edx,%eax
  802a66:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802a6e:	c9                   	leave  
  802a6f:	c3                   	ret    

00802a70 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
  802a73:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a76:	e8 71 f9 ff ff       	call   8023ec <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802a7b:	83 ec 04             	sub    $0x4,%esp
  802a7e:	68 c8 4c 80 00       	push   $0x804cc8
  802a83:	68 19 02 00 00       	push   $0x219
  802a88:	68 a5 48 80 00       	push   $0x8048a5
  802a8d:	e8 3a df ff ff       	call   8009cc <_panic>

00802a92 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802a92:	55                   	push   %ebp
  802a93:	89 e5                	mov    %esp,%ebp
  802a95:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802a98:	83 ec 04             	sub    $0x4,%esp
  802a9b:	68 f0 4c 80 00       	push   $0x804cf0
  802aa0:	68 2b 02 00 00       	push   $0x22b
  802aa5:	68 a5 48 80 00       	push   $0x8048a5
  802aaa:	e8 1d df ff ff       	call   8009cc <_panic>

00802aaf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802aaf:	55                   	push   %ebp
  802ab0:	89 e5                	mov    %esp,%ebp
  802ab2:	57                   	push   %edi
  802ab3:	56                   	push   %esi
  802ab4:	53                   	push   %ebx
  802ab5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ac1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ac4:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ac7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802aca:	cd 30                	int    $0x30
  802acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ad2:	83 c4 10             	add    $0x10,%esp
  802ad5:	5b                   	pop    %ebx
  802ad6:	5e                   	pop    %esi
  802ad7:	5f                   	pop    %edi
  802ad8:	5d                   	pop    %ebp
  802ad9:	c3                   	ret    

00802ada <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ada:	55                   	push   %ebp
  802adb:	89 e5                	mov    %esp,%ebp
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ae3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ae6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ae9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	6a 00                	push   $0x0
  802af2:	51                   	push   %ecx
  802af3:	52                   	push   %edx
  802af4:	ff 75 0c             	pushl  0xc(%ebp)
  802af7:	50                   	push   %eax
  802af8:	6a 00                	push   $0x0
  802afa:	e8 b0 ff ff ff       	call   802aaf <syscall>
  802aff:	83 c4 18             	add    $0x18,%esp
}
  802b02:	90                   	nop
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 02                	push   $0x2
  802b14:	e8 96 ff ff ff       	call   802aaf <syscall>
  802b19:	83 c4 18             	add    $0x18,%esp
}
  802b1c:	c9                   	leave  
  802b1d:	c3                   	ret    

00802b1e <sys_lock_cons>:

void sys_lock_cons(void)
{
  802b1e:	55                   	push   %ebp
  802b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802b21:	6a 00                	push   $0x0
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 03                	push   $0x3
  802b2d:	e8 7d ff ff ff       	call   802aaf <syscall>
  802b32:	83 c4 18             	add    $0x18,%esp
}
  802b35:	90                   	nop
  802b36:	c9                   	leave  
  802b37:	c3                   	ret    

00802b38 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802b38:	55                   	push   %ebp
  802b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 04                	push   $0x4
  802b47:	e8 63 ff ff ff       	call   802aaf <syscall>
  802b4c:	83 c4 18             	add    $0x18,%esp
}
  802b4f:	90                   	nop
  802b50:	c9                   	leave  
  802b51:	c3                   	ret    

00802b52 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802b52:	55                   	push   %ebp
  802b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	52                   	push   %edx
  802b62:	50                   	push   %eax
  802b63:	6a 08                	push   $0x8
  802b65:	e8 45 ff ff ff       	call   802aaf <syscall>
  802b6a:	83 c4 18             	add    $0x18,%esp
}
  802b6d:	c9                   	leave  
  802b6e:	c3                   	ret    

00802b6f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802b6f:	55                   	push   %ebp
  802b70:	89 e5                	mov    %esp,%ebp
  802b72:	56                   	push   %esi
  802b73:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802b74:	8b 75 18             	mov    0x18(%ebp),%esi
  802b77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	56                   	push   %esi
  802b84:	53                   	push   %ebx
  802b85:	51                   	push   %ecx
  802b86:	52                   	push   %edx
  802b87:	50                   	push   %eax
  802b88:	6a 09                	push   $0x9
  802b8a:	e8 20 ff ff ff       	call   802aaf <syscall>
  802b8f:	83 c4 18             	add    $0x18,%esp
}
  802b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b95:	5b                   	pop    %ebx
  802b96:	5e                   	pop    %esi
  802b97:	5d                   	pop    %ebp
  802b98:	c3                   	ret    

00802b99 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802b9c:	6a 00                	push   $0x0
  802b9e:	6a 00                	push   $0x0
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	ff 75 08             	pushl  0x8(%ebp)
  802ba7:	6a 0a                	push   $0xa
  802ba9:	e8 01 ff ff ff       	call   802aaf <syscall>
  802bae:	83 c4 18             	add    $0x18,%esp
}
  802bb1:	c9                   	leave  
  802bb2:	c3                   	ret    

00802bb3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802bb3:	55                   	push   %ebp
  802bb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	ff 75 0c             	pushl  0xc(%ebp)
  802bbf:	ff 75 08             	pushl  0x8(%ebp)
  802bc2:	6a 0b                	push   $0xb
  802bc4:	e8 e6 fe ff ff       	call   802aaf <syscall>
  802bc9:	83 c4 18             	add    $0x18,%esp
}
  802bcc:	c9                   	leave  
  802bcd:	c3                   	ret    

00802bce <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802bce:	55                   	push   %ebp
  802bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802bd1:	6a 00                	push   $0x0
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 00                	push   $0x0
  802bdb:	6a 0c                	push   $0xc
  802bdd:	e8 cd fe ff ff       	call   802aaf <syscall>
  802be2:	83 c4 18             	add    $0x18,%esp
}
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802bea:	6a 00                	push   $0x0
  802bec:	6a 00                	push   $0x0
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 0d                	push   $0xd
  802bf6:	e8 b4 fe ff ff       	call   802aaf <syscall>
  802bfb:	83 c4 18             	add    $0x18,%esp
}
  802bfe:	c9                   	leave  
  802bff:	c3                   	ret    

00802c00 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c00:	55                   	push   %ebp
  802c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	6a 00                	push   $0x0
  802c09:	6a 00                	push   $0x0
  802c0b:	6a 00                	push   $0x0
  802c0d:	6a 0e                	push   $0xe
  802c0f:	e8 9b fe ff ff       	call   802aaf <syscall>
  802c14:	83 c4 18             	add    $0x18,%esp
}
  802c17:	c9                   	leave  
  802c18:	c3                   	ret    

00802c19 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c19:	55                   	push   %ebp
  802c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	6a 00                	push   $0x0
  802c26:	6a 0f                	push   $0xf
  802c28:	e8 82 fe ff ff       	call   802aaf <syscall>
  802c2d:	83 c4 18             	add    $0x18,%esp
}
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    

00802c32 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	ff 75 08             	pushl  0x8(%ebp)
  802c40:	6a 10                	push   $0x10
  802c42:	e8 68 fe ff ff       	call   802aaf <syscall>
  802c47:	83 c4 18             	add    $0x18,%esp
}
  802c4a:	c9                   	leave  
  802c4b:	c3                   	ret    

00802c4c <sys_scarce_memory>:

void sys_scarce_memory()
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802c4f:	6a 00                	push   $0x0
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	6a 00                	push   $0x0
  802c59:	6a 11                	push   $0x11
  802c5b:	e8 4f fe ff ff       	call   802aaf <syscall>
  802c60:	83 c4 18             	add    $0x18,%esp
}
  802c63:	90                   	nop
  802c64:	c9                   	leave  
  802c65:	c3                   	ret    

00802c66 <sys_cputc>:

void
sys_cputc(const char c)
{
  802c66:	55                   	push   %ebp
  802c67:	89 e5                	mov    %esp,%ebp
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802c72:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c76:	6a 00                	push   $0x0
  802c78:	6a 00                	push   $0x0
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 00                	push   $0x0
  802c7e:	50                   	push   %eax
  802c7f:	6a 01                	push   $0x1
  802c81:	e8 29 fe ff ff       	call   802aaf <syscall>
  802c86:	83 c4 18             	add    $0x18,%esp
}
  802c89:	90                   	nop
  802c8a:	c9                   	leave  
  802c8b:	c3                   	ret    

00802c8c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802c8f:	6a 00                	push   $0x0
  802c91:	6a 00                	push   $0x0
  802c93:	6a 00                	push   $0x0
  802c95:	6a 00                	push   $0x0
  802c97:	6a 00                	push   $0x0
  802c99:	6a 14                	push   $0x14
  802c9b:	e8 0f fe ff ff       	call   802aaf <syscall>
  802ca0:	83 c4 18             	add    $0x18,%esp
}
  802ca3:	90                   	nop
  802ca4:	c9                   	leave  
  802ca5:	c3                   	ret    

00802ca6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	83 ec 04             	sub    $0x4,%esp
  802cac:	8b 45 10             	mov    0x10(%ebp),%eax
  802caf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802cb2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cb5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	6a 00                	push   $0x0
  802cbe:	51                   	push   %ecx
  802cbf:	52                   	push   %edx
  802cc0:	ff 75 0c             	pushl  0xc(%ebp)
  802cc3:	50                   	push   %eax
  802cc4:	6a 15                	push   $0x15
  802cc6:	e8 e4 fd ff ff       	call   802aaf <syscall>
  802ccb:	83 c4 18             	add    $0x18,%esp
}
  802cce:	c9                   	leave  
  802ccf:	c3                   	ret    

00802cd0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	52                   	push   %edx
  802ce0:	50                   	push   %eax
  802ce1:	6a 16                	push   $0x16
  802ce3:	e8 c7 fd ff ff       	call   802aaf <syscall>
  802ce8:	83 c4 18             	add    $0x18,%esp
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    

00802ced <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802cf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	51                   	push   %ecx
  802cfe:	52                   	push   %edx
  802cff:	50                   	push   %eax
  802d00:	6a 17                	push   $0x17
  802d02:	e8 a8 fd ff ff       	call   802aaf <syscall>
  802d07:	83 c4 18             	add    $0x18,%esp
}
  802d0a:	c9                   	leave  
  802d0b:	c3                   	ret    

00802d0c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802d0c:	55                   	push   %ebp
  802d0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	6a 00                	push   $0x0
  802d1b:	52                   	push   %edx
  802d1c:	50                   	push   %eax
  802d1d:	6a 18                	push   $0x18
  802d1f:	e8 8b fd ff ff       	call   802aaf <syscall>
  802d24:	83 c4 18             	add    $0x18,%esp
}
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	6a 00                	push   $0x0
  802d31:	ff 75 14             	pushl  0x14(%ebp)
  802d34:	ff 75 10             	pushl  0x10(%ebp)
  802d37:	ff 75 0c             	pushl  0xc(%ebp)
  802d3a:	50                   	push   %eax
  802d3b:	6a 19                	push   $0x19
  802d3d:	e8 6d fd ff ff       	call   802aaf <syscall>
  802d42:	83 c4 18             	add    $0x18,%esp
}
  802d45:	c9                   	leave  
  802d46:	c3                   	ret    

00802d47 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802d47:	55                   	push   %ebp
  802d48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	50                   	push   %eax
  802d56:	6a 1a                	push   $0x1a
  802d58:	e8 52 fd ff ff       	call   802aaf <syscall>
  802d5d:	83 c4 18             	add    $0x18,%esp
}
  802d60:	90                   	nop
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	50                   	push   %eax
  802d72:	6a 1b                	push   $0x1b
  802d74:	e8 36 fd ff ff       	call   802aaf <syscall>
  802d79:	83 c4 18             	add    $0x18,%esp
}
  802d7c:	c9                   	leave  
  802d7d:	c3                   	ret    

00802d7e <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d7e:	55                   	push   %ebp
  802d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d81:	6a 00                	push   $0x0
  802d83:	6a 00                	push   $0x0
  802d85:	6a 00                	push   $0x0
  802d87:	6a 00                	push   $0x0
  802d89:	6a 00                	push   $0x0
  802d8b:	6a 05                	push   $0x5
  802d8d:	e8 1d fd ff ff       	call   802aaf <syscall>
  802d92:	83 c4 18             	add    $0x18,%esp
}
  802d95:	c9                   	leave  
  802d96:	c3                   	ret    

00802d97 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d97:	55                   	push   %ebp
  802d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 00                	push   $0x0
  802da4:	6a 06                	push   $0x6
  802da6:	e8 04 fd ff ff       	call   802aaf <syscall>
  802dab:	83 c4 18             	add    $0x18,%esp
}
  802dae:	c9                   	leave  
  802daf:	c3                   	ret    

00802db0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802db0:	55                   	push   %ebp
  802db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 07                	push   $0x7
  802dbf:	e8 eb fc ff ff       	call   802aaf <syscall>
  802dc4:	83 c4 18             	add    $0x18,%esp
}
  802dc7:	c9                   	leave  
  802dc8:	c3                   	ret    

00802dc9 <sys_exit_env>:


void sys_exit_env(void)
{
  802dc9:	55                   	push   %ebp
  802dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 1c                	push   $0x1c
  802dd8:	e8 d2 fc ff ff       	call   802aaf <syscall>
  802ddd:	83 c4 18             	add    $0x18,%esp
}
  802de0:	90                   	nop
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802de9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dec:	8d 50 04             	lea    0x4(%eax),%edx
  802def:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	6a 00                	push   $0x0
  802df8:	52                   	push   %edx
  802df9:	50                   	push   %eax
  802dfa:	6a 1d                	push   $0x1d
  802dfc:	e8 ae fc ff ff       	call   802aaf <syscall>
  802e01:	83 c4 18             	add    $0x18,%esp
	return result;
  802e04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e0d:	89 01                	mov    %eax,(%ecx)
  802e0f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	c9                   	leave  
  802e16:	c2 04 00             	ret    $0x4

00802e19 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e19:	55                   	push   %ebp
  802e1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	ff 75 10             	pushl  0x10(%ebp)
  802e23:	ff 75 0c             	pushl  0xc(%ebp)
  802e26:	ff 75 08             	pushl  0x8(%ebp)
  802e29:	6a 13                	push   $0x13
  802e2b:	e8 7f fc ff ff       	call   802aaf <syscall>
  802e30:	83 c4 18             	add    $0x18,%esp
	return ;
  802e33:	90                   	nop
}
  802e34:	c9                   	leave  
  802e35:	c3                   	ret    

00802e36 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e36:	55                   	push   %ebp
  802e37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e39:	6a 00                	push   $0x0
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 00                	push   $0x0
  802e3f:	6a 00                	push   $0x0
  802e41:	6a 00                	push   $0x0
  802e43:	6a 1e                	push   $0x1e
  802e45:	e8 65 fc ff ff       	call   802aaf <syscall>
  802e4a:	83 c4 18             	add    $0x18,%esp
}
  802e4d:	c9                   	leave  
  802e4e:	c3                   	ret    

00802e4f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802e4f:	55                   	push   %ebp
  802e50:	89 e5                	mov    %esp,%ebp
  802e52:	83 ec 04             	sub    $0x4,%esp
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e5b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	50                   	push   %eax
  802e68:	6a 1f                	push   $0x1f
  802e6a:	e8 40 fc ff ff       	call   802aaf <syscall>
  802e6f:	83 c4 18             	add    $0x18,%esp
	return ;
  802e72:	90                   	nop
}
  802e73:	c9                   	leave  
  802e74:	c3                   	ret    

00802e75 <rsttst>:
void rsttst()
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e78:	6a 00                	push   $0x0
  802e7a:	6a 00                	push   $0x0
  802e7c:	6a 00                	push   $0x0
  802e7e:	6a 00                	push   $0x0
  802e80:	6a 00                	push   $0x0
  802e82:	6a 21                	push   $0x21
  802e84:	e8 26 fc ff ff       	call   802aaf <syscall>
  802e89:	83 c4 18             	add    $0x18,%esp
	return ;
  802e8c:	90                   	nop
}
  802e8d:	c9                   	leave  
  802e8e:	c3                   	ret    

00802e8f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e8f:	55                   	push   %ebp
  802e90:	89 e5                	mov    %esp,%ebp
  802e92:	83 ec 04             	sub    $0x4,%esp
  802e95:	8b 45 14             	mov    0x14(%ebp),%eax
  802e98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e9b:	8b 55 18             	mov    0x18(%ebp),%edx
  802e9e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ea2:	52                   	push   %edx
  802ea3:	50                   	push   %eax
  802ea4:	ff 75 10             	pushl  0x10(%ebp)
  802ea7:	ff 75 0c             	pushl  0xc(%ebp)
  802eaa:	ff 75 08             	pushl  0x8(%ebp)
  802ead:	6a 20                	push   $0x20
  802eaf:	e8 fb fb ff ff       	call   802aaf <syscall>
  802eb4:	83 c4 18             	add    $0x18,%esp
	return ;
  802eb7:	90                   	nop
}
  802eb8:	c9                   	leave  
  802eb9:	c3                   	ret    

00802eba <chktst>:
void chktst(uint32 n)
{
  802eba:	55                   	push   %ebp
  802ebb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802ebd:	6a 00                	push   $0x0
  802ebf:	6a 00                	push   $0x0
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	ff 75 08             	pushl  0x8(%ebp)
  802ec8:	6a 22                	push   $0x22
  802eca:	e8 e0 fb ff ff       	call   802aaf <syscall>
  802ecf:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed2:	90                   	nop
}
  802ed3:	c9                   	leave  
  802ed4:	c3                   	ret    

00802ed5 <inctst>:

void inctst()
{
  802ed5:	55                   	push   %ebp
  802ed6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 23                	push   $0x23
  802ee4:	e8 c6 fb ff ff       	call   802aaf <syscall>
  802ee9:	83 c4 18             	add    $0x18,%esp
	return ;
  802eec:	90                   	nop
}
  802eed:	c9                   	leave  
  802eee:	c3                   	ret    

00802eef <gettst>:
uint32 gettst()
{
  802eef:	55                   	push   %ebp
  802ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	6a 24                	push   $0x24
  802efe:	e8 ac fb ff ff       	call   802aaf <syscall>
  802f03:	83 c4 18             	add    $0x18,%esp
}
  802f06:	c9                   	leave  
  802f07:	c3                   	ret    

00802f08 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802f08:	55                   	push   %ebp
  802f09:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 25                	push   $0x25
  802f17:	e8 93 fb ff ff       	call   802aaf <syscall>
  802f1c:	83 c4 18             	add    $0x18,%esp
  802f1f:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802f24:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802f29:	c9                   	leave  
  802f2a:	c3                   	ret    

00802f2b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f2b:	55                   	push   %ebp
  802f2c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	ff 75 08             	pushl  0x8(%ebp)
  802f41:	6a 26                	push   $0x26
  802f43:	e8 67 fb ff ff       	call   802aaf <syscall>
  802f48:	83 c4 18             	add    $0x18,%esp
	return ;
  802f4b:	90                   	nop
}
  802f4c:	c9                   	leave  
  802f4d:	c3                   	ret    

00802f4e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802f4e:	55                   	push   %ebp
  802f4f:	89 e5                	mov    %esp,%ebp
  802f51:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802f52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	6a 00                	push   $0x0
  802f60:	53                   	push   %ebx
  802f61:	51                   	push   %ecx
  802f62:	52                   	push   %edx
  802f63:	50                   	push   %eax
  802f64:	6a 27                	push   $0x27
  802f66:	e8 44 fb ff ff       	call   802aaf <syscall>
  802f6b:	83 c4 18             	add    $0x18,%esp
}
  802f6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f71:	c9                   	leave  
  802f72:	c3                   	ret    

00802f73 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802f73:	55                   	push   %ebp
  802f74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	52                   	push   %edx
  802f83:	50                   	push   %eax
  802f84:	6a 28                	push   $0x28
  802f86:	e8 24 fb ff ff       	call   802aaf <syscall>
  802f8b:	83 c4 18             	add    $0x18,%esp
}
  802f8e:	c9                   	leave  
  802f8f:	c3                   	ret    

00802f90 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802f93:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	6a 00                	push   $0x0
  802f9e:	51                   	push   %ecx
  802f9f:	ff 75 10             	pushl  0x10(%ebp)
  802fa2:	52                   	push   %edx
  802fa3:	50                   	push   %eax
  802fa4:	6a 29                	push   $0x29
  802fa6:	e8 04 fb ff ff       	call   802aaf <syscall>
  802fab:	83 c4 18             	add    $0x18,%esp
}
  802fae:	c9                   	leave  
  802faf:	c3                   	ret    

00802fb0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802fb0:	55                   	push   %ebp
  802fb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	ff 75 10             	pushl  0x10(%ebp)
  802fba:	ff 75 0c             	pushl  0xc(%ebp)
  802fbd:	ff 75 08             	pushl  0x8(%ebp)
  802fc0:	6a 12                	push   $0x12
  802fc2:	e8 e8 fa ff ff       	call   802aaf <syscall>
  802fc7:	83 c4 18             	add    $0x18,%esp
	return ;
  802fca:	90                   	nop
}
  802fcb:	c9                   	leave  
  802fcc:	c3                   	ret    

00802fcd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802fcd:	55                   	push   %ebp
  802fce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802fd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	52                   	push   %edx
  802fdd:	50                   	push   %eax
  802fde:	6a 2a                	push   $0x2a
  802fe0:	e8 ca fa ff ff       	call   802aaf <syscall>
  802fe5:	83 c4 18             	add    $0x18,%esp
	return;
  802fe8:	90                   	nop
}
  802fe9:	c9                   	leave  
  802fea:	c3                   	ret    

00802feb <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802feb:	55                   	push   %ebp
  802fec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 00                	push   $0x0
  802ff2:	6a 00                	push   $0x0
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 2b                	push   $0x2b
  802ffa:	e8 b0 fa ff ff       	call   802aaf <syscall>
  802fff:	83 c4 18             	add    $0x18,%esp
}
  803002:	c9                   	leave  
  803003:	c3                   	ret    

00803004 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803004:	55                   	push   %ebp
  803005:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803007:	6a 00                	push   $0x0
  803009:	6a 00                	push   $0x0
  80300b:	6a 00                	push   $0x0
  80300d:	ff 75 0c             	pushl  0xc(%ebp)
  803010:	ff 75 08             	pushl  0x8(%ebp)
  803013:	6a 2d                	push   $0x2d
  803015:	e8 95 fa ff ff       	call   802aaf <syscall>
  80301a:	83 c4 18             	add    $0x18,%esp
	return;
  80301d:	90                   	nop
}
  80301e:	c9                   	leave  
  80301f:	c3                   	ret    

00803020 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	6a 00                	push   $0x0
  803029:	ff 75 0c             	pushl  0xc(%ebp)
  80302c:	ff 75 08             	pushl  0x8(%ebp)
  80302f:	6a 2c                	push   $0x2c
  803031:	e8 79 fa ff ff       	call   802aaf <syscall>
  803036:	83 c4 18             	add    $0x18,%esp
	return ;
  803039:	90                   	nop
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80303f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	6a 00                	push   $0x0
  803047:	6a 00                	push   $0x0
  803049:	6a 00                	push   $0x0
  80304b:	52                   	push   %edx
  80304c:	50                   	push   %eax
  80304d:	6a 2e                	push   $0x2e
  80304f:	e8 5b fa ff ff       	call   802aaf <syscall>
  803054:	83 c4 18             	add    $0x18,%esp
	return ;
  803057:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803058:	c9                   	leave  
  803059:	c3                   	ret    

0080305a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80305a:	55                   	push   %ebp
  80305b:	89 e5                	mov    %esp,%ebp
  80305d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803060:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  803067:	72 09                	jb     803072 <to_page_va+0x18>
  803069:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  803070:	72 14                	jb     803086 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803072:	83 ec 04             	sub    $0x4,%esp
  803075:	68 14 4d 80 00       	push   $0x804d14
  80307a:	6a 15                	push   $0x15
  80307c:	68 3f 4d 80 00       	push   $0x804d3f
  803081:	e8 46 d9 ff ff       	call   8009cc <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	ba 60 50 80 00       	mov    $0x805060,%edx
  80308e:	29 d0                	sub    %edx,%eax
  803090:	c1 f8 02             	sar    $0x2,%eax
  803093:	89 c2                	mov    %eax,%edx
  803095:	89 d0                	mov    %edx,%eax
  803097:	c1 e0 02             	shl    $0x2,%eax
  80309a:	01 d0                	add    %edx,%eax
  80309c:	c1 e0 02             	shl    $0x2,%eax
  80309f:	01 d0                	add    %edx,%eax
  8030a1:	c1 e0 02             	shl    $0x2,%eax
  8030a4:	01 d0                	add    %edx,%eax
  8030a6:	89 c1                	mov    %eax,%ecx
  8030a8:	c1 e1 08             	shl    $0x8,%ecx
  8030ab:	01 c8                	add    %ecx,%eax
  8030ad:	89 c1                	mov    %eax,%ecx
  8030af:	c1 e1 10             	shl    $0x10,%ecx
  8030b2:	01 c8                	add    %ecx,%eax
  8030b4:	01 c0                	add    %eax,%eax
  8030b6:	01 d0                	add    %edx,%eax
  8030b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	c1 e0 0c             	shl    $0xc,%eax
  8030c1:	89 c2                	mov    %eax,%edx
  8030c3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030c8:	01 d0                	add    %edx,%eax
}
  8030ca:	c9                   	leave  
  8030cb:	c3                   	ret    

008030cc <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8030cc:	55                   	push   %ebp
  8030cd:	89 e5                	mov    %esp,%ebp
  8030cf:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8030d2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030da:	29 c2                	sub    %eax,%edx
  8030dc:	89 d0                	mov    %edx,%eax
  8030de:	c1 e8 0c             	shr    $0xc,%eax
  8030e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8030e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e8:	78 09                	js     8030f3 <to_page_info+0x27>
  8030ea:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8030f1:	7e 14                	jle    803107 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8030f3:	83 ec 04             	sub    $0x4,%esp
  8030f6:	68 58 4d 80 00       	push   $0x804d58
  8030fb:	6a 22                	push   $0x22
  8030fd:	68 3f 4d 80 00       	push   $0x804d3f
  803102:	e8 c5 d8 ff ff       	call   8009cc <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310a:	89 d0                	mov    %edx,%eax
  80310c:	01 c0                	add    %eax,%eax
  80310e:	01 d0                	add    %edx,%eax
  803110:	c1 e0 02             	shl    $0x2,%eax
  803113:	05 60 50 80 00       	add    $0x805060,%eax
}
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
  80311d:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	05 00 00 00 02       	add    $0x2000000,%eax
  803128:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80312b:	73 16                	jae    803143 <initialize_dynamic_allocator+0x29>
  80312d:	68 7c 4d 80 00       	push   $0x804d7c
  803132:	68 a2 4d 80 00       	push   $0x804da2
  803137:	6a 34                	push   $0x34
  803139:	68 3f 4d 80 00       	push   $0x804d3f
  80313e:	e8 89 d8 ff ff       	call   8009cc <_panic>
		is_initialized = 1;
  803143:	c7 05 38 50 80 00 01 	movl   $0x1,0x805038
  80314a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  803155:	8b 45 0c             	mov    0xc(%ebp),%eax
  803158:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  80315d:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  803164:	00 00 00 
  803167:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80316e:	00 00 00 
  803171:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  803178:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  80317b:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803189:	eb 36                	jmp    8031c1 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	c1 e0 04             	shl    $0x4,%eax
  803191:	05 80 d0 81 00       	add    $0x81d080,%eax
  803196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	c1 e0 04             	shl    $0x4,%eax
  8031a2:	05 84 d0 81 00       	add    $0x81d084,%eax
  8031a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	c1 e0 04             	shl    $0x4,%eax
  8031b3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8031be:	ff 45 f4             	incl   -0xc(%ebp)
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031c7:	72 c2                	jb     80318b <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8031c9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8031cf:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031d4:	29 c2                	sub    %eax,%edx
  8031d6:	89 d0                	mov    %edx,%eax
  8031d8:	c1 e8 0c             	shr    $0xc,%eax
  8031db:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8031de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8031e5:	e9 c8 00 00 00       	jmp    8032b2 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  8031ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ed:	89 d0                	mov    %edx,%eax
  8031ef:	01 c0                	add    %eax,%eax
  8031f1:	01 d0                	add    %edx,%eax
  8031f3:	c1 e0 02             	shl    $0x2,%eax
  8031f6:	05 68 50 80 00       	add    $0x805068,%eax
  8031fb:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803203:	89 d0                	mov    %edx,%eax
  803205:	01 c0                	add    %eax,%eax
  803207:	01 d0                	add    %edx,%eax
  803209:	c1 e0 02             	shl    $0x2,%eax
  80320c:	05 6a 50 80 00       	add    $0x80506a,%eax
  803211:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803216:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80321c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80321f:	89 c8                	mov    %ecx,%eax
  803221:	01 c0                	add    %eax,%eax
  803223:	01 c8                	add    %ecx,%eax
  803225:	c1 e0 02             	shl    $0x2,%eax
  803228:	05 64 50 80 00       	add    $0x805064,%eax
  80322d:	89 10                	mov    %edx,(%eax)
  80322f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803232:	89 d0                	mov    %edx,%eax
  803234:	01 c0                	add    %eax,%eax
  803236:	01 d0                	add    %edx,%eax
  803238:	c1 e0 02             	shl    $0x2,%eax
  80323b:	05 64 50 80 00       	add    $0x805064,%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	74 1b                	je     803261 <initialize_dynamic_allocator+0x147>
  803246:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80324c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80324f:	89 c8                	mov    %ecx,%eax
  803251:	01 c0                	add    %eax,%eax
  803253:	01 c8                	add    %ecx,%eax
  803255:	c1 e0 02             	shl    $0x2,%eax
  803258:	05 60 50 80 00       	add    $0x805060,%eax
  80325d:	89 02                	mov    %eax,(%edx)
  80325f:	eb 16                	jmp    803277 <initialize_dynamic_allocator+0x15d>
  803261:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803264:	89 d0                	mov    %edx,%eax
  803266:	01 c0                	add    %eax,%eax
  803268:	01 d0                	add    %edx,%eax
  80326a:	c1 e0 02             	shl    $0x2,%eax
  80326d:	05 60 50 80 00       	add    $0x805060,%eax
  803272:	a3 48 50 80 00       	mov    %eax,0x805048
  803277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327a:	89 d0                	mov    %edx,%eax
  80327c:	01 c0                	add    %eax,%eax
  80327e:	01 d0                	add    %edx,%eax
  803280:	c1 e0 02             	shl    $0x2,%eax
  803283:	05 60 50 80 00       	add    $0x805060,%eax
  803288:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80328d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803290:	89 d0                	mov    %edx,%eax
  803292:	01 c0                	add    %eax,%eax
  803294:	01 d0                	add    %edx,%eax
  803296:	c1 e0 02             	shl    $0x2,%eax
  803299:	05 60 50 80 00       	add    $0x805060,%eax
  80329e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a4:	a1 54 50 80 00       	mov    0x805054,%eax
  8032a9:	40                   	inc    %eax
  8032aa:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8032af:	ff 45 f0             	incl   -0x10(%ebp)
  8032b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032b8:	0f 82 2c ff ff ff    	jb     8031ea <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8032be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032c4:	eb 2f                	jmp    8032f5 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8032c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c9:	89 d0                	mov    %edx,%eax
  8032cb:	01 c0                	add    %eax,%eax
  8032cd:	01 d0                	add    %edx,%eax
  8032cf:	c1 e0 02             	shl    $0x2,%eax
  8032d2:	05 68 50 80 00       	add    $0x805068,%eax
  8032d7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8032dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032df:	89 d0                	mov    %edx,%eax
  8032e1:	01 c0                	add    %eax,%eax
  8032e3:	01 d0                	add    %edx,%eax
  8032e5:	c1 e0 02             	shl    $0x2,%eax
  8032e8:	05 6a 50 80 00       	add    $0x80506a,%eax
  8032ed:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8032f2:	ff 45 ec             	incl   -0x14(%ebp)
  8032f5:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8032fc:	76 c8                	jbe    8032c6 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8032fe:	90                   	nop
  8032ff:	c9                   	leave  
  803300:	c3                   	ret    

00803301 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803301:	55                   	push   %ebp
  803302:	89 e5                	mov    %esp,%ebp
  803304:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803307:	8b 55 08             	mov    0x8(%ebp),%edx
  80330a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80330f:	29 c2                	sub    %eax,%edx
  803311:	89 d0                	mov    %edx,%eax
  803313:	c1 e8 0c             	shr    $0xc,%eax
  803316:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803319:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80331c:	89 d0                	mov    %edx,%eax
  80331e:	01 c0                	add    %eax,%eax
  803320:	01 d0                	add    %edx,%eax
  803322:	c1 e0 02             	shl    $0x2,%eax
  803325:	05 68 50 80 00       	add    $0x805068,%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80332f:	c9                   	leave  
  803330:	c3                   	ret    

00803331 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803331:	55                   	push   %ebp
  803332:	89 e5                	mov    %esp,%ebp
  803334:	83 ec 14             	sub    $0x14,%esp
  803337:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  80333a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80333e:	77 07                	ja     803347 <nearest_pow2_ceil.1513+0x16>
  803340:	b8 01 00 00 00       	mov    $0x1,%eax
  803345:	eb 20                	jmp    803367 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803347:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  80334e:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803351:	eb 08                	jmp    80335b <nearest_pow2_ceil.1513+0x2a>
  803353:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803356:	01 c0                	add    %eax,%eax
  803358:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80335b:	d1 6d 08             	shrl   0x8(%ebp)
  80335e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803362:	75 ef                	jne    803353 <nearest_pow2_ceil.1513+0x22>
        return power;
  803364:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803367:	c9                   	leave  
  803368:	c3                   	ret    

00803369 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803369:	55                   	push   %ebp
  80336a:	89 e5                	mov    %esp,%ebp
  80336c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80336f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803376:	76 16                	jbe    80338e <alloc_block+0x25>
  803378:	68 b8 4d 80 00       	push   $0x804db8
  80337d:	68 a2 4d 80 00       	push   $0x804da2
  803382:	6a 72                	push   $0x72
  803384:	68 3f 4d 80 00       	push   $0x804d3f
  803389:	e8 3e d6 ff ff       	call   8009cc <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  80338e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803392:	75 0a                	jne    80339e <alloc_block+0x35>
  803394:	b8 00 00 00 00       	mov    $0x0,%eax
  803399:	e9 bd 04 00 00       	jmp    80385b <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80339e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8033ab:	73 06                	jae    8033b3 <alloc_block+0x4a>
        size = min_block_size;
  8033ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b0:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  8033b3:	83 ec 0c             	sub    $0xc,%esp
  8033b6:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8033b9:	ff 75 08             	pushl  0x8(%ebp)
  8033bc:	89 c1                	mov    %eax,%ecx
  8033be:	e8 6e ff ff ff       	call   803331 <nearest_pow2_ceil.1513>
  8033c3:	83 c4 10             	add    $0x10,%esp
  8033c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  8033c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033cc:	83 ec 0c             	sub    $0xc,%esp
  8033cf:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8033d2:	52                   	push   %edx
  8033d3:	89 c1                	mov    %eax,%ecx
  8033d5:	e8 83 04 00 00       	call   80385d <log2_ceil.1520>
  8033da:	83 c4 10             	add    $0x10,%esp
  8033dd:	83 e8 03             	sub    $0x3,%eax
  8033e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  8033e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e6:	c1 e0 04             	shl    $0x4,%eax
  8033e9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	85 c0                	test   %eax,%eax
  8033f2:	0f 84 d8 00 00 00    	je     8034d0 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8033f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fb:	c1 e0 04             	shl    $0x4,%eax
  8033fe:	05 80 d0 81 00       	add    $0x81d080,%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803408:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80340c:	75 17                	jne    803425 <alloc_block+0xbc>
  80340e:	83 ec 04             	sub    $0x4,%esp
  803411:	68 d9 4d 80 00       	push   $0x804dd9
  803416:	68 98 00 00 00       	push   $0x98
  80341b:	68 3f 4d 80 00       	push   $0x804d3f
  803420:	e8 a7 d5 ff ff       	call   8009cc <_panic>
  803425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	85 c0                	test   %eax,%eax
  80342c:	74 10                	je     80343e <alloc_block+0xd5>
  80342e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803431:	8b 00                	mov    (%eax),%eax
  803433:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803436:	8b 52 04             	mov    0x4(%edx),%edx
  803439:	89 50 04             	mov    %edx,0x4(%eax)
  80343c:	eb 14                	jmp    803452 <alloc_block+0xe9>
  80343e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803441:	8b 40 04             	mov    0x4(%eax),%eax
  803444:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803447:	c1 e2 04             	shl    $0x4,%edx
  80344a:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803450:	89 02                	mov    %eax,(%edx)
  803452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803455:	8b 40 04             	mov    0x4(%eax),%eax
  803458:	85 c0                	test   %eax,%eax
  80345a:	74 0f                	je     80346b <alloc_block+0x102>
  80345c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80345f:	8b 40 04             	mov    0x4(%eax),%eax
  803462:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803465:	8b 12                	mov    (%edx),%edx
  803467:	89 10                	mov    %edx,(%eax)
  803469:	eb 13                	jmp    80347e <alloc_block+0x115>
  80346b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803473:	c1 e2 04             	shl    $0x4,%edx
  803476:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80347c:	89 02                	mov    %eax,(%edx)
  80347e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80348a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803494:	c1 e0 04             	shl    $0x4,%eax
  803497:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8034a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a4:	c1 e0 04             	shl    $0x4,%eax
  8034a7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034ac:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8034ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b1:	83 ec 0c             	sub    $0xc,%esp
  8034b4:	50                   	push   %eax
  8034b5:	e8 12 fc ff ff       	call   8030cc <to_page_info>
  8034ba:	83 c4 10             	add    $0x10,%esp
  8034bd:	89 c2                	mov    %eax,%edx
  8034bf:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8034c3:	48                   	dec    %eax
  8034c4:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8034c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034cb:	e9 8b 03 00 00       	jmp    80385b <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8034d0:	a1 48 50 80 00       	mov    0x805048,%eax
  8034d5:	85 c0                	test   %eax,%eax
  8034d7:	0f 84 64 02 00 00    	je     803741 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  8034dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8034e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8034e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034e9:	75 17                	jne    803502 <alloc_block+0x199>
  8034eb:	83 ec 04             	sub    $0x4,%esp
  8034ee:	68 d9 4d 80 00       	push   $0x804dd9
  8034f3:	68 a0 00 00 00       	push   $0xa0
  8034f8:	68 3f 4d 80 00       	push   $0x804d3f
  8034fd:	e8 ca d4 ff ff       	call   8009cc <_panic>
  803502:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 10                	je     80351b <alloc_block+0x1b2>
  80350b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803513:	8b 52 04             	mov    0x4(%edx),%edx
  803516:	89 50 04             	mov    %edx,0x4(%eax)
  803519:	eb 0b                	jmp    803526 <alloc_block+0x1bd>
  80351b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351e:	8b 40 04             	mov    0x4(%eax),%eax
  803521:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803526:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803529:	8b 40 04             	mov    0x4(%eax),%eax
  80352c:	85 c0                	test   %eax,%eax
  80352e:	74 0f                	je     80353f <alloc_block+0x1d6>
  803530:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803533:	8b 40 04             	mov    0x4(%eax),%eax
  803536:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803539:	8b 12                	mov    (%edx),%edx
  80353b:	89 10                	mov    %edx,(%eax)
  80353d:	eb 0a                	jmp    803549 <alloc_block+0x1e0>
  80353f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	a3 48 50 80 00       	mov    %eax,0x805048
  803549:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80354c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803552:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355c:	a1 54 50 80 00       	mov    0x805054,%eax
  803561:	48                   	dec    %eax
  803562:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  803567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80356d:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803571:	b8 00 10 00 00       	mov    $0x1000,%eax
  803576:	99                   	cltd   
  803577:	f7 7d e8             	idivl  -0x18(%ebp)
  80357a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80357d:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803581:	83 ec 0c             	sub    $0xc,%esp
  803584:	ff 75 dc             	pushl  -0x24(%ebp)
  803587:	e8 ce fa ff ff       	call   80305a <to_page_va>
  80358c:	83 c4 10             	add    $0x10,%esp
  80358f:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803592:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803595:	83 ec 0c             	sub    $0xc,%esp
  803598:	50                   	push   %eax
  803599:	e8 c0 ee ff ff       	call   80245e <get_page>
  80359e:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8035a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035a8:	e9 aa 00 00 00       	jmp    803657 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  8035ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b0:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  8035b4:	89 c2                	mov    %eax,%edx
  8035b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b9:	01 d0                	add    %edx,%eax
  8035bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8035be:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035c2:	75 17                	jne    8035db <alloc_block+0x272>
  8035c4:	83 ec 04             	sub    $0x4,%esp
  8035c7:	68 f8 4d 80 00       	push   $0x804df8
  8035cc:	68 aa 00 00 00       	push   $0xaa
  8035d1:	68 3f 4d 80 00       	push   $0x804d3f
  8035d6:	e8 f1 d3 ff ff       	call   8009cc <_panic>
  8035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035de:	c1 e0 04             	shl    $0x4,%eax
  8035e1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035e6:	8b 10                	mov    (%eax),%edx
  8035e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035eb:	89 50 04             	mov    %edx,0x4(%eax)
  8035ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f1:	8b 40 04             	mov    0x4(%eax),%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	74 14                	je     80360c <alloc_block+0x2a3>
  8035f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fb:	c1 e0 04             	shl    $0x4,%eax
  8035fe:	05 84 d0 81 00       	add    $0x81d084,%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	eb 11                	jmp    80361d <alloc_block+0x2b4>
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	c1 e0 04             	shl    $0x4,%eax
  803612:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361b:	89 02                	mov    %eax,(%edx)
  80361d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803620:	c1 e0 04             	shl    $0x4,%eax
  803623:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803629:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362c:	89 02                	mov    %eax,(%edx)
  80362e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363a:	c1 e0 04             	shl    $0x4,%eax
  80363d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803642:	8b 00                	mov    (%eax),%eax
  803644:	8d 50 01             	lea    0x1(%eax),%edx
  803647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364a:	c1 e0 04             	shl    $0x4,%eax
  80364d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803652:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803654:	ff 45 f4             	incl   -0xc(%ebp)
  803657:	b8 00 10 00 00       	mov    $0x1000,%eax
  80365c:	99                   	cltd   
  80365d:	f7 7d e8             	idivl  -0x18(%ebp)
  803660:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803663:	0f 8f 44 ff ff ff    	jg     8035ad <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366c:	c1 e0 04             	shl    $0x4,%eax
  80366f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803674:	8b 00                	mov    (%eax),%eax
  803676:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803679:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80367d:	75 17                	jne    803696 <alloc_block+0x32d>
  80367f:	83 ec 04             	sub    $0x4,%esp
  803682:	68 d9 4d 80 00       	push   $0x804dd9
  803687:	68 ae 00 00 00       	push   $0xae
  80368c:	68 3f 4d 80 00       	push   $0x804d3f
  803691:	e8 36 d3 ff ff       	call   8009cc <_panic>
  803696:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	85 c0                	test   %eax,%eax
  80369d:	74 10                	je     8036af <alloc_block+0x346>
  80369f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036a2:	8b 00                	mov    (%eax),%eax
  8036a4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8036a7:	8b 52 04             	mov    0x4(%edx),%edx
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	eb 14                	jmp    8036c3 <alloc_block+0x35a>
  8036af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036b2:	8b 40 04             	mov    0x4(%eax),%eax
  8036b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b8:	c1 e2 04             	shl    $0x4,%edx
  8036bb:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8036c1:	89 02                	mov    %eax,(%edx)
  8036c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036c6:	8b 40 04             	mov    0x4(%eax),%eax
  8036c9:	85 c0                	test   %eax,%eax
  8036cb:	74 0f                	je     8036dc <alloc_block+0x373>
  8036cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036d0:	8b 40 04             	mov    0x4(%eax),%eax
  8036d3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8036d6:	8b 12                	mov    (%edx),%edx
  8036d8:	89 10                	mov    %edx,(%eax)
  8036da:	eb 13                	jmp    8036ef <alloc_block+0x386>
  8036dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e4:	c1 e2 04             	shl    $0x4,%edx
  8036e7:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8036ed:	89 02                	mov    %eax,(%edx)
  8036ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803705:	c1 e0 04             	shl    $0x4,%eax
  803708:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803715:	c1 e0 04             	shl    $0x4,%eax
  803718:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80371d:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80371f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	50                   	push   %eax
  803726:	e8 a1 f9 ff ff       	call   8030cc <to_page_info>
  80372b:	83 c4 10             	add    $0x10,%esp
  80372e:	89 c2                	mov    %eax,%edx
  803730:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803734:	48                   	dec    %eax
  803735:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80373c:	e9 1a 01 00 00       	jmp    80385b <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803744:	40                   	inc    %eax
  803745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803748:	e9 ed 00 00 00       	jmp    80383a <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80374d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803750:	c1 e0 04             	shl    $0x4,%eax
  803753:	05 80 d0 81 00       	add    $0x81d080,%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	85 c0                	test   %eax,%eax
  80375c:	0f 84 d5 00 00 00    	je     803837 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803765:	c1 e0 04             	shl    $0x4,%eax
  803768:	05 80 d0 81 00       	add    $0x81d080,%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803772:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803776:	75 17                	jne    80378f <alloc_block+0x426>
  803778:	83 ec 04             	sub    $0x4,%esp
  80377b:	68 d9 4d 80 00       	push   $0x804dd9
  803780:	68 b8 00 00 00       	push   $0xb8
  803785:	68 3f 4d 80 00       	push   $0x804d3f
  80378a:	e8 3d d2 ff ff       	call   8009cc <_panic>
  80378f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803792:	8b 00                	mov    (%eax),%eax
  803794:	85 c0                	test   %eax,%eax
  803796:	74 10                	je     8037a8 <alloc_block+0x43f>
  803798:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80379b:	8b 00                	mov    (%eax),%eax
  80379d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037a0:	8b 52 04             	mov    0x4(%edx),%edx
  8037a3:	89 50 04             	mov    %edx,0x4(%eax)
  8037a6:	eb 14                	jmp    8037bc <alloc_block+0x453>
  8037a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037ab:	8b 40 04             	mov    0x4(%eax),%eax
  8037ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b1:	c1 e2 04             	shl    $0x4,%edx
  8037b4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8037ba:	89 02                	mov    %eax,(%edx)
  8037bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037bf:	8b 40 04             	mov    0x4(%eax),%eax
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	74 0f                	je     8037d5 <alloc_block+0x46c>
  8037c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037c9:	8b 40 04             	mov    0x4(%eax),%eax
  8037cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037cf:	8b 12                	mov    (%edx),%edx
  8037d1:	89 10                	mov    %edx,(%eax)
  8037d3:	eb 13                	jmp    8037e8 <alloc_block+0x47f>
  8037d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037d8:	8b 00                	mov    (%eax),%eax
  8037da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037dd:	c1 e2 04             	shl    $0x4,%edx
  8037e0:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8037e6:	89 02                	mov    %eax,(%edx)
  8037e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037fe:	c1 e0 04             	shl    $0x4,%eax
  803801:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80380b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380e:	c1 e0 04             	shl    $0x4,%eax
  803811:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803816:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803818:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80381b:	83 ec 0c             	sub    $0xc,%esp
  80381e:	50                   	push   %eax
  80381f:	e8 a8 f8 ff ff       	call   8030cc <to_page_info>
  803824:	83 c4 10             	add    $0x10,%esp
  803827:	89 c2                	mov    %eax,%edx
  803829:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80382d:	48                   	dec    %eax
  80382e:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803832:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803835:	eb 24                	jmp    80385b <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803837:	ff 45 f0             	incl   -0x10(%ebp)
  80383a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80383e:	0f 8e 09 ff ff ff    	jle    80374d <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803844:	83 ec 04             	sub    $0x4,%esp
  803847:	68 1b 4e 80 00       	push   $0x804e1b
  80384c:	68 bf 00 00 00       	push   $0xbf
  803851:	68 3f 4d 80 00       	push   $0x804d3f
  803856:	e8 71 d1 ff ff       	call   8009cc <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80385b:	c9                   	leave  
  80385c:	c3                   	ret    

0080385d <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80385d:	55                   	push   %ebp
  80385e:	89 e5                	mov    %esp,%ebp
  803860:	83 ec 14             	sub    $0x14,%esp
  803863:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803866:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80386a:	75 07                	jne    803873 <log2_ceil.1520+0x16>
  80386c:	b8 00 00 00 00       	mov    $0x0,%eax
  803871:	eb 1b                	jmp    80388e <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803873:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80387a:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80387d:	eb 06                	jmp    803885 <log2_ceil.1520+0x28>
            x >>= 1;
  80387f:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803882:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803885:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803889:	75 f4                	jne    80387f <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  80388b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80388e:	c9                   	leave  
  80388f:	c3                   	ret    

00803890 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803890:	55                   	push   %ebp
  803891:	89 e5                	mov    %esp,%ebp
  803893:	83 ec 14             	sub    $0x14,%esp
  803896:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803899:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389d:	75 07                	jne    8038a6 <log2_ceil.1547+0x16>
  80389f:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a4:	eb 1b                	jmp    8038c1 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8038a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8038ad:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8038b0:	eb 06                	jmp    8038b8 <log2_ceil.1547+0x28>
			x >>= 1;
  8038b2:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8038b5:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8038b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038bc:	75 f4                	jne    8038b2 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8038be:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8038c1:	c9                   	leave  
  8038c2:	c3                   	ret    

008038c3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8038c3:	55                   	push   %ebp
  8038c4:	89 e5                	mov    %esp,%ebp
  8038c6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8038c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8038cc:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8038d1:	39 c2                	cmp    %eax,%edx
  8038d3:	72 0c                	jb     8038e1 <free_block+0x1e>
  8038d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d8:	a1 40 50 80 00       	mov    0x805040,%eax
  8038dd:	39 c2                	cmp    %eax,%edx
  8038df:	72 19                	jb     8038fa <free_block+0x37>
  8038e1:	68 20 4e 80 00       	push   $0x804e20
  8038e6:	68 a2 4d 80 00       	push   $0x804da2
  8038eb:	68 d0 00 00 00       	push   $0xd0
  8038f0:	68 3f 4d 80 00       	push   $0x804d3f
  8038f5:	e8 d2 d0 ff ff       	call   8009cc <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8038fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038fe:	0f 84 42 03 00 00    	je     803c46 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803904:	8b 55 08             	mov    0x8(%ebp),%edx
  803907:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80390c:	39 c2                	cmp    %eax,%edx
  80390e:	72 0c                	jb     80391c <free_block+0x59>
  803910:	8b 55 08             	mov    0x8(%ebp),%edx
  803913:	a1 40 50 80 00       	mov    0x805040,%eax
  803918:	39 c2                	cmp    %eax,%edx
  80391a:	72 17                	jb     803933 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80391c:	83 ec 04             	sub    $0x4,%esp
  80391f:	68 58 4e 80 00       	push   $0x804e58
  803924:	68 e6 00 00 00       	push   $0xe6
  803929:	68 3f 4d 80 00       	push   $0x804d3f
  80392e:	e8 99 d0 ff ff       	call   8009cc <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803933:	8b 55 08             	mov    0x8(%ebp),%edx
  803936:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80393b:	29 c2                	sub    %eax,%edx
  80393d:	89 d0                	mov    %edx,%eax
  80393f:	83 e0 07             	and    $0x7,%eax
  803942:	85 c0                	test   %eax,%eax
  803944:	74 17                	je     80395d <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803946:	83 ec 04             	sub    $0x4,%esp
  803949:	68 8c 4e 80 00       	push   $0x804e8c
  80394e:	68 ea 00 00 00       	push   $0xea
  803953:	68 3f 4d 80 00       	push   $0x804d3f
  803958:	e8 6f d0 ff ff       	call   8009cc <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	83 ec 0c             	sub    $0xc,%esp
  803963:	50                   	push   %eax
  803964:	e8 63 f7 ff ff       	call   8030cc <to_page_info>
  803969:	83 c4 10             	add    $0x10,%esp
  80396c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80396f:	83 ec 0c             	sub    $0xc,%esp
  803972:	ff 75 08             	pushl  0x8(%ebp)
  803975:	e8 87 f9 ff ff       	call   803301 <get_block_size>
  80397a:	83 c4 10             	add    $0x10,%esp
  80397d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803980:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803984:	75 17                	jne    80399d <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803986:	83 ec 04             	sub    $0x4,%esp
  803989:	68 b8 4e 80 00       	push   $0x804eb8
  80398e:	68 f1 00 00 00       	push   $0xf1
  803993:	68 3f 4d 80 00       	push   $0x804d3f
  803998:	e8 2f d0 ff ff       	call   8009cc <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80399d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a0:	83 ec 0c             	sub    $0xc,%esp
  8039a3:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8039a6:	52                   	push   %edx
  8039a7:	89 c1                	mov    %eax,%ecx
  8039a9:	e8 e2 fe ff ff       	call   803890 <log2_ceil.1547>
  8039ae:	83 c4 10             	add    $0x10,%esp
  8039b1:	83 e8 03             	sub    $0x3,%eax
  8039b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8039bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8039c1:	75 17                	jne    8039da <free_block+0x117>
  8039c3:	83 ec 04             	sub    $0x4,%esp
  8039c6:	68 04 4f 80 00       	push   $0x804f04
  8039cb:	68 f6 00 00 00       	push   $0xf6
  8039d0:	68 3f 4d 80 00       	push   $0x804d3f
  8039d5:	e8 f2 cf ff ff       	call   8009cc <_panic>
  8039da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dd:	c1 e0 04             	shl    $0x4,%eax
  8039e0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8039e5:	8b 10                	mov    (%eax),%edx
  8039e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ea:	89 10                	mov    %edx,(%eax)
  8039ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	74 15                	je     803a0a <free_block+0x147>
  8039f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f8:	c1 e0 04             	shl    $0x4,%eax
  8039fb:	05 80 d0 81 00       	add    $0x81d080,%eax
  803a00:	8b 00                	mov    (%eax),%eax
  803a02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a05:	89 50 04             	mov    %edx,0x4(%eax)
  803a08:	eb 11                	jmp    803a1b <free_block+0x158>
  803a0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0d:	c1 e0 04             	shl    $0x4,%eax
  803a10:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a19:	89 02                	mov    %eax,(%edx)
  803a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1e:	c1 e0 04             	shl    $0x4,%eax
  803a21:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a2a:	89 02                	mov    %eax,(%edx)
  803a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a39:	c1 e0 04             	shl    $0x4,%eax
  803a3c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a41:	8b 00                	mov    (%eax),%eax
  803a43:	8d 50 01             	lea    0x1(%eax),%edx
  803a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a49:	c1 e0 04             	shl    $0x4,%eax
  803a4c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803a51:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a56:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a5a:	40                   	inc    %eax
  803a5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a5e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803a62:	8b 55 08             	mov    0x8(%ebp),%edx
  803a65:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803a6a:	29 c2                	sub    %eax,%edx
  803a6c:	89 d0                	mov    %edx,%eax
  803a6e:	c1 e8 0c             	shr    $0xc,%eax
  803a71:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a77:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a7b:	0f b7 c8             	movzwl %ax,%ecx
  803a7e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a83:	99                   	cltd   
  803a84:	f7 7d e8             	idivl  -0x18(%ebp)
  803a87:	39 c1                	cmp    %eax,%ecx
  803a89:	0f 85 b8 01 00 00    	jne    803c47 <free_block+0x384>
    	uint32 blocks_removed = 0;
  803a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a99:	c1 e0 04             	shl    $0x4,%eax
  803a9c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803aa1:	8b 00                	mov    (%eax),%eax
  803aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803aa6:	e9 d5 00 00 00       	jmp    803b80 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aae:	8b 00                	mov    (%eax),%eax
  803ab0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ab6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803abb:	29 c2                	sub    %eax,%edx
  803abd:	89 d0                	mov    %edx,%eax
  803abf:	c1 e8 0c             	shr    $0xc,%eax
  803ac2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803ac5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ac8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803acb:	0f 85 a9 00 00 00    	jne    803b7a <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ad5:	75 17                	jne    803aee <free_block+0x22b>
  803ad7:	83 ec 04             	sub    $0x4,%esp
  803ada:	68 d9 4d 80 00       	push   $0x804dd9
  803adf:	68 04 01 00 00       	push   $0x104
  803ae4:	68 3f 4d 80 00       	push   $0x804d3f
  803ae9:	e8 de ce ff ff       	call   8009cc <_panic>
  803aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	85 c0                	test   %eax,%eax
  803af5:	74 10                	je     803b07 <free_block+0x244>
  803af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803afa:	8b 00                	mov    (%eax),%eax
  803afc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aff:	8b 52 04             	mov    0x4(%edx),%edx
  803b02:	89 50 04             	mov    %edx,0x4(%eax)
  803b05:	eb 14                	jmp    803b1b <free_block+0x258>
  803b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b0a:	8b 40 04             	mov    0x4(%eax),%eax
  803b0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b10:	c1 e2 04             	shl    $0x4,%edx
  803b13:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803b19:	89 02                	mov    %eax,(%edx)
  803b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b1e:	8b 40 04             	mov    0x4(%eax),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	74 0f                	je     803b34 <free_block+0x271>
  803b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b28:	8b 40 04             	mov    0x4(%eax),%eax
  803b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b2e:	8b 12                	mov    (%edx),%edx
  803b30:	89 10                	mov    %edx,(%eax)
  803b32:	eb 13                	jmp    803b47 <free_block+0x284>
  803b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b37:	8b 00                	mov    (%eax),%eax
  803b39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b3c:	c1 e2 04             	shl    $0x4,%edx
  803b3f:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803b45:	89 02                	mov    %eax,(%edx)
  803b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5d:	c1 e0 04             	shl    $0x4,%eax
  803b60:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803b65:	8b 00                	mov    (%eax),%eax
  803b67:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6d:	c1 e0 04             	shl    $0x4,%eax
  803b70:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803b75:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803b77:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803b7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803b80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b84:	0f 85 21 ff ff ff    	jne    803aab <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803b8a:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b8f:	99                   	cltd   
  803b90:	f7 7d e8             	idivl  -0x18(%ebp)
  803b93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803b96:	74 17                	je     803baf <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803b98:	83 ec 04             	sub    $0x4,%esp
  803b9b:	68 28 4f 80 00       	push   $0x804f28
  803ba0:	68 0c 01 00 00       	push   $0x10c
  803ba5:	68 3f 4d 80 00       	push   $0x804d3f
  803baa:	e8 1d ce ff ff       	call   8009cc <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bb2:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bbb:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bc5:	75 17                	jne    803bde <free_block+0x31b>
  803bc7:	83 ec 04             	sub    $0x4,%esp
  803bca:	68 f8 4d 80 00       	push   $0x804df8
  803bcf:	68 11 01 00 00       	push   $0x111
  803bd4:	68 3f 4d 80 00       	push   $0x804d3f
  803bd9:	e8 ee cd ff ff       	call   8009cc <_panic>
  803bde:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be7:	89 50 04             	mov    %edx,0x4(%eax)
  803bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bed:	8b 40 04             	mov    0x4(%eax),%eax
  803bf0:	85 c0                	test   %eax,%eax
  803bf2:	74 0c                	je     803c00 <free_block+0x33d>
  803bf4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803bf9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bfc:	89 10                	mov    %edx,(%eax)
  803bfe:	eb 08                	jmp    803c08 <free_block+0x345>
  803c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c03:	a3 48 50 80 00       	mov    %eax,0x805048
  803c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c0b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c19:	a1 54 50 80 00       	mov    0x805054,%eax
  803c1e:	40                   	inc    %eax
  803c1f:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803c24:	83 ec 0c             	sub    $0xc,%esp
  803c27:	ff 75 ec             	pushl  -0x14(%ebp)
  803c2a:	e8 2b f4 ff ff       	call   80305a <to_page_va>
  803c2f:	83 c4 10             	add    $0x10,%esp
  803c32:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803c35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c38:	83 ec 0c             	sub    $0xc,%esp
  803c3b:	50                   	push   %eax
  803c3c:	e8 69 e8 ff ff       	call   8024aa <return_page>
  803c41:	83 c4 10             	add    $0x10,%esp
  803c44:	eb 01                	jmp    803c47 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803c46:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803c47:	c9                   	leave  
  803c48:	c3                   	ret    

00803c49 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803c49:	55                   	push   %ebp
  803c4a:	89 e5                	mov    %esp,%ebp
  803c4c:	83 ec 14             	sub    $0x14,%esp
  803c4f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803c52:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803c56:	77 07                	ja     803c5f <nearest_pow2_ceil.1572+0x16>
      return 1;
  803c58:	b8 01 00 00 00       	mov    $0x1,%eax
  803c5d:	eb 20                	jmp    803c7f <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803c5f:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803c66:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803c69:	eb 08                	jmp    803c73 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c6e:	01 c0                	add    %eax,%eax
  803c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803c73:	d1 6d 08             	shrl   0x8(%ebp)
  803c76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c7a:	75 ef                	jne    803c6b <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803c7f:	c9                   	leave  
  803c80:	c3                   	ret    

00803c81 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803c81:	55                   	push   %ebp
  803c82:	89 e5                	mov    %esp,%ebp
  803c84:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803c87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c8b:	75 13                	jne    803ca0 <realloc_block+0x1f>
    return alloc_block(new_size);
  803c8d:	83 ec 0c             	sub    $0xc,%esp
  803c90:	ff 75 0c             	pushl  0xc(%ebp)
  803c93:	e8 d1 f6 ff ff       	call   803369 <alloc_block>
  803c98:	83 c4 10             	add    $0x10,%esp
  803c9b:	e9 d9 00 00 00       	jmp    803d79 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803ca0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ca4:	75 18                	jne    803cbe <realloc_block+0x3d>
    free_block(va);
  803ca6:	83 ec 0c             	sub    $0xc,%esp
  803ca9:	ff 75 08             	pushl  0x8(%ebp)
  803cac:	e8 12 fc ff ff       	call   8038c3 <free_block>
  803cb1:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb9:	e9 bb 00 00 00       	jmp    803d79 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803cbe:	83 ec 0c             	sub    $0xc,%esp
  803cc1:	ff 75 08             	pushl  0x8(%ebp)
  803cc4:	e8 38 f6 ff ff       	call   803301 <get_block_size>
  803cc9:	83 c4 10             	add    $0x10,%esp
  803ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803ccf:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cdc:	73 06                	jae    803ce4 <realloc_block+0x63>
    new_size = min_block_size;
  803cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce1:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803ce4:	83 ec 0c             	sub    $0xc,%esp
  803ce7:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803cea:	ff 75 0c             	pushl  0xc(%ebp)
  803ced:	89 c1                	mov    %eax,%ecx
  803cef:	e8 55 ff ff ff       	call   803c49 <nearest_pow2_ceil.1572>
  803cf4:	83 c4 10             	add    $0x10,%esp
  803cf7:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cfd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803d00:	75 05                	jne    803d07 <realloc_block+0x86>
    return va;
  803d02:	8b 45 08             	mov    0x8(%ebp),%eax
  803d05:	eb 72                	jmp    803d79 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803d07:	83 ec 0c             	sub    $0xc,%esp
  803d0a:	ff 75 0c             	pushl  0xc(%ebp)
  803d0d:	e8 57 f6 ff ff       	call   803369 <alloc_block>
  803d12:	83 c4 10             	add    $0x10,%esp
  803d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803d18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d1c:	75 07                	jne    803d25 <realloc_block+0xa4>
    return NULL;
  803d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d23:	eb 54                	jmp    803d79 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803d25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d2b:	39 d0                	cmp    %edx,%eax
  803d2d:	76 02                	jbe    803d31 <realloc_block+0xb0>
  803d2f:	89 d0                	mov    %edx,%eax
  803d31:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803d34:	8b 45 08             	mov    0x8(%ebp),%eax
  803d37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803d3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803d40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d47:	eb 17                	jmp    803d60 <realloc_block+0xdf>
    dst[i] = src[i];
  803d49:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4f:	01 c2                	add    %eax,%edx
  803d51:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d57:	01 c8                	add    %ecx,%eax
  803d59:	8a 00                	mov    (%eax),%al
  803d5b:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803d5d:	ff 45 f4             	incl   -0xc(%ebp)
  803d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d63:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d66:	72 e1                	jb     803d49 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803d68:	83 ec 0c             	sub    $0xc,%esp
  803d6b:	ff 75 08             	pushl  0x8(%ebp)
  803d6e:	e8 50 fb ff ff       	call   8038c3 <free_block>
  803d73:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803d79:	c9                   	leave  
  803d7a:	c3                   	ret    
  803d7b:	90                   	nop

00803d7c <__udivdi3>:
  803d7c:	55                   	push   %ebp
  803d7d:	57                   	push   %edi
  803d7e:	56                   	push   %esi
  803d7f:	53                   	push   %ebx
  803d80:	83 ec 1c             	sub    $0x1c,%esp
  803d83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d93:	89 ca                	mov    %ecx,%edx
  803d95:	89 f8                	mov    %edi,%eax
  803d97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d9b:	85 f6                	test   %esi,%esi
  803d9d:	75 2d                	jne    803dcc <__udivdi3+0x50>
  803d9f:	39 cf                	cmp    %ecx,%edi
  803da1:	77 65                	ja     803e08 <__udivdi3+0x8c>
  803da3:	89 fd                	mov    %edi,%ebp
  803da5:	85 ff                	test   %edi,%edi
  803da7:	75 0b                	jne    803db4 <__udivdi3+0x38>
  803da9:	b8 01 00 00 00       	mov    $0x1,%eax
  803dae:	31 d2                	xor    %edx,%edx
  803db0:	f7 f7                	div    %edi
  803db2:	89 c5                	mov    %eax,%ebp
  803db4:	31 d2                	xor    %edx,%edx
  803db6:	89 c8                	mov    %ecx,%eax
  803db8:	f7 f5                	div    %ebp
  803dba:	89 c1                	mov    %eax,%ecx
  803dbc:	89 d8                	mov    %ebx,%eax
  803dbe:	f7 f5                	div    %ebp
  803dc0:	89 cf                	mov    %ecx,%edi
  803dc2:	89 fa                	mov    %edi,%edx
  803dc4:	83 c4 1c             	add    $0x1c,%esp
  803dc7:	5b                   	pop    %ebx
  803dc8:	5e                   	pop    %esi
  803dc9:	5f                   	pop    %edi
  803dca:	5d                   	pop    %ebp
  803dcb:	c3                   	ret    
  803dcc:	39 ce                	cmp    %ecx,%esi
  803dce:	77 28                	ja     803df8 <__udivdi3+0x7c>
  803dd0:	0f bd fe             	bsr    %esi,%edi
  803dd3:	83 f7 1f             	xor    $0x1f,%edi
  803dd6:	75 40                	jne    803e18 <__udivdi3+0x9c>
  803dd8:	39 ce                	cmp    %ecx,%esi
  803dda:	72 0a                	jb     803de6 <__udivdi3+0x6a>
  803ddc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803de0:	0f 87 9e 00 00 00    	ja     803e84 <__udivdi3+0x108>
  803de6:	b8 01 00 00 00       	mov    $0x1,%eax
  803deb:	89 fa                	mov    %edi,%edx
  803ded:	83 c4 1c             	add    $0x1c,%esp
  803df0:	5b                   	pop    %ebx
  803df1:	5e                   	pop    %esi
  803df2:	5f                   	pop    %edi
  803df3:	5d                   	pop    %ebp
  803df4:	c3                   	ret    
  803df5:	8d 76 00             	lea    0x0(%esi),%esi
  803df8:	31 ff                	xor    %edi,%edi
  803dfa:	31 c0                	xor    %eax,%eax
  803dfc:	89 fa                	mov    %edi,%edx
  803dfe:	83 c4 1c             	add    $0x1c,%esp
  803e01:	5b                   	pop    %ebx
  803e02:	5e                   	pop    %esi
  803e03:	5f                   	pop    %edi
  803e04:	5d                   	pop    %ebp
  803e05:	c3                   	ret    
  803e06:	66 90                	xchg   %ax,%ax
  803e08:	89 d8                	mov    %ebx,%eax
  803e0a:	f7 f7                	div    %edi
  803e0c:	31 ff                	xor    %edi,%edi
  803e0e:	89 fa                	mov    %edi,%edx
  803e10:	83 c4 1c             	add    $0x1c,%esp
  803e13:	5b                   	pop    %ebx
  803e14:	5e                   	pop    %esi
  803e15:	5f                   	pop    %edi
  803e16:	5d                   	pop    %ebp
  803e17:	c3                   	ret    
  803e18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e1d:	89 eb                	mov    %ebp,%ebx
  803e1f:	29 fb                	sub    %edi,%ebx
  803e21:	89 f9                	mov    %edi,%ecx
  803e23:	d3 e6                	shl    %cl,%esi
  803e25:	89 c5                	mov    %eax,%ebp
  803e27:	88 d9                	mov    %bl,%cl
  803e29:	d3 ed                	shr    %cl,%ebp
  803e2b:	89 e9                	mov    %ebp,%ecx
  803e2d:	09 f1                	or     %esi,%ecx
  803e2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e33:	89 f9                	mov    %edi,%ecx
  803e35:	d3 e0                	shl    %cl,%eax
  803e37:	89 c5                	mov    %eax,%ebp
  803e39:	89 d6                	mov    %edx,%esi
  803e3b:	88 d9                	mov    %bl,%cl
  803e3d:	d3 ee                	shr    %cl,%esi
  803e3f:	89 f9                	mov    %edi,%ecx
  803e41:	d3 e2                	shl    %cl,%edx
  803e43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e47:	88 d9                	mov    %bl,%cl
  803e49:	d3 e8                	shr    %cl,%eax
  803e4b:	09 c2                	or     %eax,%edx
  803e4d:	89 d0                	mov    %edx,%eax
  803e4f:	89 f2                	mov    %esi,%edx
  803e51:	f7 74 24 0c          	divl   0xc(%esp)
  803e55:	89 d6                	mov    %edx,%esi
  803e57:	89 c3                	mov    %eax,%ebx
  803e59:	f7 e5                	mul    %ebp
  803e5b:	39 d6                	cmp    %edx,%esi
  803e5d:	72 19                	jb     803e78 <__udivdi3+0xfc>
  803e5f:	74 0b                	je     803e6c <__udivdi3+0xf0>
  803e61:	89 d8                	mov    %ebx,%eax
  803e63:	31 ff                	xor    %edi,%edi
  803e65:	e9 58 ff ff ff       	jmp    803dc2 <__udivdi3+0x46>
  803e6a:	66 90                	xchg   %ax,%ax
  803e6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e70:	89 f9                	mov    %edi,%ecx
  803e72:	d3 e2                	shl    %cl,%edx
  803e74:	39 c2                	cmp    %eax,%edx
  803e76:	73 e9                	jae    803e61 <__udivdi3+0xe5>
  803e78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e7b:	31 ff                	xor    %edi,%edi
  803e7d:	e9 40 ff ff ff       	jmp    803dc2 <__udivdi3+0x46>
  803e82:	66 90                	xchg   %ax,%ax
  803e84:	31 c0                	xor    %eax,%eax
  803e86:	e9 37 ff ff ff       	jmp    803dc2 <__udivdi3+0x46>
  803e8b:	90                   	nop

00803e8c <__umoddi3>:
  803e8c:	55                   	push   %ebp
  803e8d:	57                   	push   %edi
  803e8e:	56                   	push   %esi
  803e8f:	53                   	push   %ebx
  803e90:	83 ec 1c             	sub    $0x1c,%esp
  803e93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ea7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803eab:	89 f3                	mov    %esi,%ebx
  803ead:	89 fa                	mov    %edi,%edx
  803eaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eb3:	89 34 24             	mov    %esi,(%esp)
  803eb6:	85 c0                	test   %eax,%eax
  803eb8:	75 1a                	jne    803ed4 <__umoddi3+0x48>
  803eba:	39 f7                	cmp    %esi,%edi
  803ebc:	0f 86 a2 00 00 00    	jbe    803f64 <__umoddi3+0xd8>
  803ec2:	89 c8                	mov    %ecx,%eax
  803ec4:	89 f2                	mov    %esi,%edx
  803ec6:	f7 f7                	div    %edi
  803ec8:	89 d0                	mov    %edx,%eax
  803eca:	31 d2                	xor    %edx,%edx
  803ecc:	83 c4 1c             	add    $0x1c,%esp
  803ecf:	5b                   	pop    %ebx
  803ed0:	5e                   	pop    %esi
  803ed1:	5f                   	pop    %edi
  803ed2:	5d                   	pop    %ebp
  803ed3:	c3                   	ret    
  803ed4:	39 f0                	cmp    %esi,%eax
  803ed6:	0f 87 ac 00 00 00    	ja     803f88 <__umoddi3+0xfc>
  803edc:	0f bd e8             	bsr    %eax,%ebp
  803edf:	83 f5 1f             	xor    $0x1f,%ebp
  803ee2:	0f 84 ac 00 00 00    	je     803f94 <__umoddi3+0x108>
  803ee8:	bf 20 00 00 00       	mov    $0x20,%edi
  803eed:	29 ef                	sub    %ebp,%edi
  803eef:	89 fe                	mov    %edi,%esi
  803ef1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ef5:	89 e9                	mov    %ebp,%ecx
  803ef7:	d3 e0                	shl    %cl,%eax
  803ef9:	89 d7                	mov    %edx,%edi
  803efb:	89 f1                	mov    %esi,%ecx
  803efd:	d3 ef                	shr    %cl,%edi
  803eff:	09 c7                	or     %eax,%edi
  803f01:	89 e9                	mov    %ebp,%ecx
  803f03:	d3 e2                	shl    %cl,%edx
  803f05:	89 14 24             	mov    %edx,(%esp)
  803f08:	89 d8                	mov    %ebx,%eax
  803f0a:	d3 e0                	shl    %cl,%eax
  803f0c:	89 c2                	mov    %eax,%edx
  803f0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f12:	d3 e0                	shl    %cl,%eax
  803f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f1c:	89 f1                	mov    %esi,%ecx
  803f1e:	d3 e8                	shr    %cl,%eax
  803f20:	09 d0                	or     %edx,%eax
  803f22:	d3 eb                	shr    %cl,%ebx
  803f24:	89 da                	mov    %ebx,%edx
  803f26:	f7 f7                	div    %edi
  803f28:	89 d3                	mov    %edx,%ebx
  803f2a:	f7 24 24             	mull   (%esp)
  803f2d:	89 c6                	mov    %eax,%esi
  803f2f:	89 d1                	mov    %edx,%ecx
  803f31:	39 d3                	cmp    %edx,%ebx
  803f33:	0f 82 87 00 00 00    	jb     803fc0 <__umoddi3+0x134>
  803f39:	0f 84 91 00 00 00    	je     803fd0 <__umoddi3+0x144>
  803f3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f43:	29 f2                	sub    %esi,%edx
  803f45:	19 cb                	sbb    %ecx,%ebx
  803f47:	89 d8                	mov    %ebx,%eax
  803f49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f4d:	d3 e0                	shl    %cl,%eax
  803f4f:	89 e9                	mov    %ebp,%ecx
  803f51:	d3 ea                	shr    %cl,%edx
  803f53:	09 d0                	or     %edx,%eax
  803f55:	89 e9                	mov    %ebp,%ecx
  803f57:	d3 eb                	shr    %cl,%ebx
  803f59:	89 da                	mov    %ebx,%edx
  803f5b:	83 c4 1c             	add    $0x1c,%esp
  803f5e:	5b                   	pop    %ebx
  803f5f:	5e                   	pop    %esi
  803f60:	5f                   	pop    %edi
  803f61:	5d                   	pop    %ebp
  803f62:	c3                   	ret    
  803f63:	90                   	nop
  803f64:	89 fd                	mov    %edi,%ebp
  803f66:	85 ff                	test   %edi,%edi
  803f68:	75 0b                	jne    803f75 <__umoddi3+0xe9>
  803f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6f:	31 d2                	xor    %edx,%edx
  803f71:	f7 f7                	div    %edi
  803f73:	89 c5                	mov    %eax,%ebp
  803f75:	89 f0                	mov    %esi,%eax
  803f77:	31 d2                	xor    %edx,%edx
  803f79:	f7 f5                	div    %ebp
  803f7b:	89 c8                	mov    %ecx,%eax
  803f7d:	f7 f5                	div    %ebp
  803f7f:	89 d0                	mov    %edx,%eax
  803f81:	e9 44 ff ff ff       	jmp    803eca <__umoddi3+0x3e>
  803f86:	66 90                	xchg   %ax,%ax
  803f88:	89 c8                	mov    %ecx,%eax
  803f8a:	89 f2                	mov    %esi,%edx
  803f8c:	83 c4 1c             	add    $0x1c,%esp
  803f8f:	5b                   	pop    %ebx
  803f90:	5e                   	pop    %esi
  803f91:	5f                   	pop    %edi
  803f92:	5d                   	pop    %ebp
  803f93:	c3                   	ret    
  803f94:	3b 04 24             	cmp    (%esp),%eax
  803f97:	72 06                	jb     803f9f <__umoddi3+0x113>
  803f99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f9d:	77 0f                	ja     803fae <__umoddi3+0x122>
  803f9f:	89 f2                	mov    %esi,%edx
  803fa1:	29 f9                	sub    %edi,%ecx
  803fa3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fa7:	89 14 24             	mov    %edx,(%esp)
  803faa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fb2:	8b 14 24             	mov    (%esp),%edx
  803fb5:	83 c4 1c             	add    $0x1c,%esp
  803fb8:	5b                   	pop    %ebx
  803fb9:	5e                   	pop    %esi
  803fba:	5f                   	pop    %edi
  803fbb:	5d                   	pop    %ebp
  803fbc:	c3                   	ret    
  803fbd:	8d 76 00             	lea    0x0(%esi),%esi
  803fc0:	2b 04 24             	sub    (%esp),%eax
  803fc3:	19 fa                	sbb    %edi,%edx
  803fc5:	89 d1                	mov    %edx,%ecx
  803fc7:	89 c6                	mov    %eax,%esi
  803fc9:	e9 71 ff ff ff       	jmp    803f3f <__umoddi3+0xb3>
  803fce:	66 90                	xchg   %ax,%ax
  803fd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fd4:	72 ea                	jb     803fc0 <__umoddi3+0x134>
  803fd6:	89 d9                	mov    %ebx,%ecx
  803fd8:	e9 62 ff ff ff       	jmp    803f3f <__umoddi3+0xb3>
