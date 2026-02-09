
obj/user/matrix_operations:     file format elf32-i386


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
  800031:	e8 de 09 00 00       	call   800a14 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements);
int64** MatrixAddition(int **M1, int **M2, int NumOfElements);
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Line[255] ;
	char Chose ;
	int val =0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int NumOfElements = 3;
  800049:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	do
	{
		val = 0;
  800050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		NumOfElements = 3;
  800057:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80005e:	e8 a5 2a 00 00       	call   802b08 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 e0 41 80 00       	push   $0x8041e0
  80006b:	e8 34 0c 00 00       	call   800ca4 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 e4 41 80 00       	push   $0x8041e4
  80007b:	e8 24 0c 00 00       	call   800ca4 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 08 42 80 00       	push   $0x804208
  80008b:	e8 14 0c 00 00       	call   800ca4 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 e4 41 80 00       	push   $0x8041e4
  80009b:	e8 04 0c 00 00       	call   800ca4 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 e0 41 80 00       	push   $0x8041e0
  8000ab:	e8 f4 0b 00 00       	call   800ca4 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 2c 42 80 00       	push   $0x80422c
  8000c2:	e8 b6 12 00 00       	call   80137d <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 b7 18 00 00       	call   801994 <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 4c 42 80 00       	push   $0x80424c
  8000eb:	e8 b4 0b 00 00       	call   800ca4 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 6e 42 80 00       	push   $0x80426e
  8000fb:	e8 a4 0b 00 00       	call   800ca4 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 7c 42 80 00       	push   $0x80427c
  80010b:	e8 94 0b 00 00       	call   800ca4 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 8a 42 80 00       	push   $0x80428a
  80011b:	e8 84 0b 00 00       	call   800ca4 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 9a 42 80 00       	push   $0x80429a
  80012b:	e8 74 0b 00 00       	call   800ca4 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800133:	e8 bf 08 00 00       	call   8009f7 <getchar>
  800138:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80013b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	50                   	push   %eax
  800143:	e8 90 08 00 00       	call   8009d8 <cputchar>
  800148:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	6a 0a                	push   $0xa
  800150:	e8 83 08 00 00       	call   8009d8 <cputchar>
  800155:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800158:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  80015c:	74 0c                	je     80016a <_main+0x132>
  80015e:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800162:	74 06                	je     80016a <_main+0x132>
  800164:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800168:	75 b9                	jne    800123 <_main+0xeb>

		if (Chose == 'b')
  80016a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80016e:	75 30                	jne    8001a0 <_main+0x168>
		{
			readline("Enter the value to be initialized: ", Line);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	68 a4 42 80 00       	push   $0x8042a4
  80017f:	e8 f9 11 00 00       	call   80137d <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 fa 17 00 00       	call   801994 <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 7d 29 00 00       	call   802b22 <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 23 23 00 00       	call   8024d7 <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 0e 23 00 00       	call   8024d7 <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (int i = 0; i < NumOfElements; ++i)
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	eb 4b                	jmp    800223 <_main+0x1eb>
		{
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
  8001d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8001e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 e0 22 00 00       	call   8024d7 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 03                	mov    %eax,(%ebx)
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
  8001fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800206:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800209:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	e8 bc 22 00 00       	call   8024d7 <malloc>
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	89 03                	mov    %eax,(%ebx)
		sys_unlock_cons();

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
		int **M2 = malloc(sizeof(int) * NumOfElements) ;

		for (int i = 0; i < NumOfElements; ++i)
  800220:	ff 45 f0             	incl   -0x10(%ebp)
  800223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800226:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800229:	7c ad                	jl     8001d8 <_main+0x1a0>
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
		}

		int  i ;
		switch (Chose)
  80022b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80022f:	83 f8 62             	cmp    $0x62,%eax
  800232:	74 2e                	je     800262 <_main+0x22a>
  800234:	83 f8 63             	cmp    $0x63,%eax
  800237:	74 53                	je     80028c <_main+0x254>
  800239:	83 f8 61             	cmp    $0x61,%eax
  80023c:	75 72                	jne    8002b0 <_main+0x278>
		{
		case 'a':
			InitializeAscending(M1, NumOfElements);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 dc             	pushl  -0x24(%ebp)
  800247:	e8 9b 05 00 00       	call   8007e7 <InitializeAscending>
  80024c:	83 c4 10             	add    $0x10,%esp
			InitializeAscending(M2, NumOfElements);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	e8 8a 05 00 00       	call   8007e7 <InitializeAscending>
  80025d:	83 c4 10             	add    $0x10,%esp
			break ;
  800260:	eb 70                	jmp    8002d2 <_main+0x29a>
		case 'b':
			InitializeIdentical(M1, NumOfElements, val);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 f4             	pushl  -0xc(%ebp)
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	e8 c3 05 00 00       	call   800836 <InitializeIdentical>
  800273:	83 c4 10             	add    $0x10,%esp
			InitializeIdentical(M2, NumOfElements, val);
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	ff 75 f4             	pushl  -0xc(%ebp)
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 d8             	pushl  -0x28(%ebp)
  800282:	e8 af 05 00 00       	call   800836 <InitializeIdentical>
  800287:	83 c4 10             	add    $0x10,%esp
			break ;
  80028a:	eb 46                	jmp    8002d2 <_main+0x29a>
		case 'c':
			InitializeSemiRandom(M1, NumOfElements);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	e8 eb 05 00 00       	call   800885 <InitializeSemiRandom>
  80029a:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 da 05 00 00       	call   800885 <InitializeSemiRandom>
  8002ab:	83 c4 10             	add    $0x10,%esp
			//PrintElements(M1, NumOfElements);
			break ;
  8002ae:	eb 22                	jmp    8002d2 <_main+0x29a>
		default:
			InitializeSemiRandom(M1, NumOfElements);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	e8 c7 05 00 00       	call   800885 <InitializeSemiRandom>
  8002be:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 b6 05 00 00       	call   800885 <InitializeSemiRandom>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
  8002d2:	e8 31 28 00 00       	call   802b08 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 c8 42 80 00       	push   $0x8042c8
  8002df:	e8 c0 09 00 00       	call   800ca4 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 e6 42 80 00       	push   $0x8042e6
  8002ef:	e8 b0 09 00 00       	call   800ca4 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 fd 42 80 00       	push   $0x8042fd
  8002ff:	e8 a0 09 00 00       	call   800ca4 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 14 43 80 00       	push   $0x804314
  80030f:	e8 90 09 00 00       	call   800ca4 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 9a 42 80 00       	push   $0x80429a
  80031f:	e8 80 09 00 00       	call   800ca4 <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800327:	e8 cb 06 00 00       	call   8009f7 <getchar>
  80032c:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80032f:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	50                   	push   %eax
  800337:	e8 9c 06 00 00       	call   8009d8 <cputchar>
  80033c:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	6a 0a                	push   $0xa
  800344:	e8 8f 06 00 00       	call   8009d8 <cputchar>
  800349:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80034c:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800350:	74 0c                	je     80035e <_main+0x326>
  800352:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800356:	74 06                	je     80035e <_main+0x326>
  800358:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  80035c:	75 b9                	jne    800317 <_main+0x2df>
		sys_unlock_cons();
  80035e:	e8 bf 27 00 00       	call   802b22 <sys_unlock_cons>


		int64** Res = NULL ;
  800363:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		switch (Chose)
  80036a:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80036e:	83 f8 62             	cmp    $0x62,%eax
  800371:	74 23                	je     800396 <_main+0x35e>
  800373:	83 f8 63             	cmp    $0x63,%eax
  800376:	74 37                	je     8003af <_main+0x377>
  800378:	83 f8 61             	cmp    $0x61,%eax
  80037b:	75 4b                	jne    8003c8 <_main+0x390>
		{
		case 'a':
			Res = MatrixAddition(M1, M2, NumOfElements);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	ff 75 e4             	pushl  -0x1c(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 dc             	pushl  -0x24(%ebp)
  800389:	e8 9f 02 00 00       	call   80062d <MatrixAddition>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  800394:	eb 49                	jmp    8003df <_main+0x3a7>
		case 'b':
			Res = MatrixSubtraction(M1, M2, NumOfElements);
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039c:	ff 75 d8             	pushl  -0x28(%ebp)
  80039f:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a2:	e8 62 03 00 00       	call   800709 <MatrixSubtraction>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003ad:	eb 30                	jmp    8003df <_main+0x3a7>
		case 'c':
			Res = MatrixMultiply(M1, M2, NumOfElements);
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bb:	e8 1d 01 00 00       	call   8004dd <MatrixMultiply>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003c6:	eb 17                	jmp    8003df <_main+0x3a7>
		default:
			Res = MatrixAddition(M1, M2, NumOfElements);
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	e8 54 02 00 00       	call   80062d <MatrixAddition>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
		}


		sys_lock_cons();
  8003df:	e8 24 27 00 00       	call   802b08 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 2b 43 80 00       	push   $0x80432b
  8003ec:	e8 b3 08 00 00       	call   800ca4 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 29 27 00 00       	call   802b22 <sys_unlock_cons>

		for (int i = 0; i < NumOfElements; ++i)
  8003f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800400:	eb 5a                	jmp    80045c <_main+0x424>
		{
			free(M1[i]);
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	50                   	push   %eax
  800417:	e8 3f 22 00 00       	call   80265b <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 22 22 00 00       	call   80265b <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 05 22 00 00       	call   80265b <free>
  800456:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
		cprintf("Operation is COMPLETED.\n");
		sys_unlock_cons();

		for (int i = 0; i < NumOfElements; ++i)
  800459:	ff 45 e8             	incl   -0x18(%ebp)
  80045c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800462:	7c 9e                	jl     800402 <_main+0x3ca>
		{
			free(M1[i]);
			free(M2[i]);
			free(Res[i]);
		}
		free(M1) ;
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	ff 75 dc             	pushl  -0x24(%ebp)
  80046a:	e8 ec 21 00 00       	call   80265b <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 de 21 00 00       	call   80265b <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 d0 21 00 00       	call   80265b <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 75 26 00 00       	call   802b08 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 44 43 80 00       	push   $0x804344
  80049b:	e8 04 08 00 00       	call   800ca4 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8004a3:	e8 4f 05 00 00       	call   8009f7 <getchar>
  8004a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
		cputchar(Chose);
  8004ab:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	50                   	push   %eax
  8004b3:	e8 20 05 00 00       	call   8009d8 <cputchar>
  8004b8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 0a                	push   $0xa
  8004c0:	e8 13 05 00 00       	call   8009d8 <cputchar>
  8004c5:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8004c8:	e8 55 26 00 00       	call   802b22 <sys_unlock_cons>

	} while (Chose == 'y');
  8004cd:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8004d1:	0f 84 79 fb ff ff    	je     800050 <_main+0x18>

}
  8004d7:	90                   	nop
  8004d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <MatrixMultiply>:

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 2c             	sub    $0x2c,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	50                   	push   %eax
  8004f0:	e8 e2 1f 00 00       	call   8024d7 <malloc>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800502:	eb 27                	jmp    80052b <MatrixMultiply+0x4e>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 b4 1f 00 00       	call   8024d7 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 03                	mov    %eax,(%ebx)

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800528:	ff 45 e4             	incl   -0x1c(%ebp)
  80052b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800531:	7c d1                	jl     800504 <MatrixMultiply+0x27>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053a:	e9 d7 00 00 00       	jmp    800616 <MatrixMultiply+0x139>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80053f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800546:	e9 bc 00 00 00       	jmp    800607 <MatrixMultiply+0x12a>
		{
			Res[i][j] = 0 ;
  80054b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055f:	c1 e2 03             	shl    $0x3,%edx
  800562:	01 d0                	add    %edx,%eax
  800564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80056a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			for (int k = 0; k < NumOfElements; ++k)
  800571:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800578:	eb 7e                	jmp    8005f8 <MatrixMultiply+0x11b>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
  80057a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058e:	c1 e2 03             	shl    $0x3,%edx
  800591:	8d 34 10             	lea    (%eax,%edx,1),%esi
  800594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a8:	c1 e2 03             	shl    $0x3,%edx
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	8b 08                	mov    (%eax),%ecx
  8005af:	8b 58 04             	mov    0x4(%eax),%ebx
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c6:	c1 e2 02             	shl    $0x2,%edx
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d0:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	01 f8                	add    %edi,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005e1:	c1 e7 02             	shl    $0x2,%edi
  8005e4:	01 f8                	add    %edi,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	0f af c2             	imul   %edx,%eax
  8005eb:	99                   	cltd   
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	11 da                	adc    %ebx,%edx
  8005f0:	89 06                	mov    %eax,(%esi)
  8005f2:	89 56 04             	mov    %edx,0x4(%esi)
	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = 0 ;
			for (int k = 0; k < NumOfElements; ++k)
  8005f5:	ff 45 d8             	incl   -0x28(%ebp)
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005fe:	0f 8c 76 ff ff ff    	jl     80057a <MatrixMultiply+0x9d>
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  800604:	ff 45 dc             	incl   -0x24(%ebp)
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80060d:	0f 8c 38 ff ff ff    	jl     80054b <MatrixMultiply+0x6e>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	3b 45 10             	cmp    0x10(%ebp),%eax
  80061c:	0f 8c 1d ff ff ff    	jl     80053f <MatrixMultiply+0x62>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
			}
		}
	}
	return Res;
  800622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800625:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800628:	5b                   	pop    %ebx
  800629:	5e                   	pop    %esi
  80062a:	5f                   	pop    %edi
  80062b:	5d                   	pop    %ebp
  80062c:	c3                   	ret    

0080062d <MatrixAddition>:

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	53                   	push   %ebx
  800631:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800634:	8b 45 10             	mov    0x10(%ebp),%eax
  800637:	c1 e0 03             	shl    $0x3,%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 94 1e 00 00       	call   8024d7 <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800650:	eb 27                	jmp    800679 <MatrixAddition+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800655:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800662:	8b 45 10             	mov    0x10(%ebp),%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	50                   	push   %eax
  80066c:	e8 66 1e 00 00       	call   8024d7 <malloc>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 03                	mov    %eax,(%ebx)

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800676:	ff 45 f4             	incl   -0xc(%ebp)
  800679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80067f:	7c d1                	jl     800652 <MatrixAddition+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	eb 6f                	jmp    8006f9 <MatrixAddition+0xcc>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80068a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800691:	eb 5b                	jmp    8006ee <MatrixAddition+0xc1>
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
  800693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a0:	01 d0                	add    %edx,%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006a7:	c1 e2 03             	shl    $0x3,%edx
  8006aa:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c1:	c1 e2 02             	shl    $0x2,%edx
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	01 d8                	add    %ebx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8006dc:	c1 e3 02             	shl    $0x2,%ebx
  8006df:	01 d8                	add    %ebx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	99                   	cltd   
  8006e6:	89 01                	mov    %eax,(%ecx)
  8006e8:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8006eb:	ff 45 ec             	incl   -0x14(%ebp)
  8006ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006f4:	7c 9d                	jl     800693 <MatrixAddition+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8006f6:	ff 45 f0             	incl   -0x10(%ebp)
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006ff:	7c 89                	jl     80068a <MatrixAddition+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
		}
	}
	return Res;
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  800704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <MatrixSubtraction>:

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	53                   	push   %ebx
  80070d:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	c1 e0 03             	shl    $0x3,%eax
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	50                   	push   %eax
  80071a:	e8 b8 1d 00 00       	call   8024d7 <malloc>
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80072c:	eb 27                	jmp    800755 <MatrixSubtraction+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  80072e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	c1 e0 03             	shl    $0x3,%eax
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	50                   	push   %eax
  800748:	e8 8a 1d 00 00       	call   8024d7 <malloc>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 03                	mov    %eax,(%ebx)

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800752:	ff 45 f4             	incl   -0xc(%ebp)
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	3b 45 10             	cmp    0x10(%ebp),%eax
  80075b:	7c d1                	jl     80072e <MatrixSubtraction+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  80075d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800764:	eb 71                	jmp    8007d7 <MatrixSubtraction+0xce>
	{
		for (int j = 0; j < NumOfElements; ++j)
  800766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80076d:	eb 5d                	jmp    8007cc <MatrixSubtraction+0xc3>
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80077c:	01 d0                	add    %edx,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800783:	c1 e2 03             	shl    $0x3,%edx
  800786:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80079d:	c1 e2 02             	shl    $0x2,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a7:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8007b8:	c1 e3 02             	shl    $0x2,%ebx
  8007bb:	01 d8                	add    %ebx,%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	29 c2                	sub    %eax,%edx
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	99                   	cltd   
  8007c4:	89 01                	mov    %eax,(%ecx)
  8007c6:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8007c9:	ff 45 ec             	incl   -0x14(%ebp)
  8007cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007d2:	7c 9b                	jl     80076f <MatrixSubtraction+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8007d4:	ff 45 f0             	incl   -0x10(%ebp)
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007dd:	7c 87                	jl     800766 <MatrixSubtraction+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
		}
	}
	return Res;
  8007df:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <InitializeAscending>:

///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8007f4:	eb 35                	jmp    80082b <InitializeAscending+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8007f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8007fd:	eb 21                	jmp    800820 <InitializeAscending+0x39>
		{
			(Elements)[i][j] = j ;
  8007ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800813:	c1 e2 02             	shl    $0x2,%edx
  800816:	01 c2                	add    %eax,%edx
  800818:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80081b:	89 02                	mov    %eax,(%edx)
void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80081d:	ff 45 f8             	incl   -0x8(%ebp)
  800820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800823:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800826:	7c d7                	jl     8007ff <InitializeAscending+0x18>
///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800828:	ff 45 fc             	incl   -0x4(%ebp)
  80082b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80082e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800831:	7c c3                	jl     8007f6 <InitializeAscending+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = j ;
		}
	}
}
  800833:	90                   	nop
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <InitializeIdentical>:

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80083c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800843:	eb 35                	jmp    80087a <InitializeIdentical+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80084c:	eb 21                	jmp    80086f <InitializeIdentical+0x39>
		{
			(Elements)[i][j] = value ;
  80084e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800851:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800862:	c1 e2 02             	shl    $0x2,%edx
  800865:	01 c2                	add    %eax,%edx
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 02                	mov    %eax,(%edx)
void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80086c:	ff 45 f8             	incl   -0x8(%ebp)
  80086f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800872:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800875:	7c d7                	jl     80084e <InitializeIdentical+0x18>
}

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800877:	ff 45 fc             	incl   -0x4(%ebp)
  80087a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80087d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800880:	7c c3                	jl     800845 <InitializeIdentical+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = value ;
		}
	}
}
  800882:	90                   	nop
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <InitializeSemiRandom>:

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 20             	sub    $0x20,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80088c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800893:	eb 56                	jmp    8008eb <InitializeSemiRandom+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80089c:	eb 42                	jmp    8008e0 <InitializeSemiRandom+0x5b>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
  80089e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b2:	c1 e2 02             	shl    $0x2,%edx
  8008b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8008b8:	0f 31                	rdtsc  
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8008c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	f7 f3                	div    %ebx
  8008d9:	89 d0                	mov    %edx,%eax
  8008db:	89 01                	mov    %eax,(%ecx)
void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8008dd:	ff 45 f4             	incl   -0xc(%ebp)
  8008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008e6:	7c b6                	jl     80089e <InitializeSemiRandom+0x19>
}

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008e8:	ff 45 f8             	incl   -0x8(%ebp)
  8008eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f1:	7c a2                	jl     800895 <InitializeSemiRandom+0x10>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
			//	cprintf("i=%d\n",i);
		}
	}
}
  8008f3:	90                   	nop
  8008f4:	83 c4 20             	add    $0x20,%esp
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <PrintElements>:

void PrintElements(int **Elements, int NumOfElements)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800907:	eb 53                	jmp    80095c <PrintElements+0x62>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800909:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800910:	eb 2f                	jmp    800941 <PrintElements+0x47>
		{
			cprintf("%~%d, ",Elements[i][j]);
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800926:	c1 e2 02             	shl    $0x2,%edx
  800929:	01 d0                	add    %edx,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	50                   	push   %eax
  800931:	68 62 43 80 00       	push   $0x804362
  800936:	e8 69 03 00 00       	call   800ca4 <cprintf>
  80093b:	83 c4 10             	add    $0x10,%esp
void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80093e:	ff 45 f0             	incl   -0x10(%ebp)
  800941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800944:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800947:	7c c9                	jl     800912 <PrintElements+0x18>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
  800949:	83 ec 0c             	sub    $0xc,%esp
  80094c:	68 69 43 80 00       	push   $0x804369
  800951:	e8 4e 03 00 00       	call   800ca4 <cprintf>
  800956:	83 c4 10             	add    $0x10,%esp
}

void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800959:	ff 45 f4             	incl   -0xc(%ebp)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800962:	7c a5                	jl     800909 <PrintElements+0xf>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <PrintElements64>:

void PrintElements64(int64 **Elements, int NumOfElements)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80096d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800974:	eb 57                	jmp    8009cd <PrintElements64+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800976:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097d:	eb 33                	jmp    8009b2 <PrintElements64+0x4b>
		{
			cprintf("%~%lld, ",Elements[i][j]);
  80097f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800982:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	01 d0                	add    %edx,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800993:	c1 e2 03             	shl    $0x3,%edx
  800996:	01 d0                	add    %edx,%eax
  800998:	8b 50 04             	mov    0x4(%eax),%edx
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	52                   	push   %edx
  8009a1:	50                   	push   %eax
  8009a2:	68 6d 43 80 00       	push   $0x80436d
  8009a7:	e8 f8 02 00 00       	call   800ca4 <cprintf>
  8009ac:	83 c4 10             	add    $0x10,%esp
void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8009af:	ff 45 f0             	incl   -0x10(%ebp)
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b8:	7c c5                	jl     80097f <PrintElements64+0x18>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
  8009ba:	83 ec 0c             	sub    $0xc,%esp
  8009bd:	68 69 43 80 00       	push   $0x804369
  8009c2:	e8 dd 02 00 00       	call   800ca4 <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
}

void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009ca:	ff 45 f4             	incl   -0xc(%ebp)
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009d3:	7c a1                	jl     800976 <PrintElements64+0xf>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  8009d5:	90                   	nop
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8009e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8009e8:	83 ec 0c             	sub    $0xc,%esp
  8009eb:	50                   	push   %eax
  8009ec:	e8 5f 22 00 00       	call   802c50 <sys_cputc>
  8009f1:	83 c4 10             	add    $0x10,%esp
}
  8009f4:	90                   	nop
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <getchar>:


int
getchar(void)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8009fd:	e8 ed 20 00 00       	call   802aef <sys_cgetc>
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <iscons>:

int iscons(int fdnum)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800a0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800a1d:	e8 5f 23 00 00       	call   802d81 <sys_getenvindex>
  800a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	01 c0                	add    %eax,%eax
  800a2c:	01 d0                	add    %edx,%eax
  800a2e:	c1 e0 02             	shl    $0x2,%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	c1 e0 02             	shl    $0x2,%eax
  800a36:	01 d0                	add    %edx,%eax
  800a38:	c1 e0 03             	shl    $0x3,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 02             	shl    $0x2,%eax
  800a40:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a45:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a4a:	a1 20 60 80 00       	mov    0x806020,%eax
  800a4f:	8a 40 20             	mov    0x20(%eax),%al
  800a52:	84 c0                	test   %al,%al
  800a54:	74 0d                	je     800a63 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800a56:	a1 20 60 80 00       	mov    0x806020,%eax
  800a5b:	83 c0 20             	add    $0x20,%eax
  800a5e:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a67:	7e 0a                	jle    800a73 <libmain+0x5f>
		binaryname = argv[0];
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	ff 75 08             	pushl  0x8(%ebp)
  800a7c:	e8 b7 f5 ff ff       	call   800038 <_main>
  800a81:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800a84:	a1 00 60 80 00       	mov    0x806000,%eax
  800a89:	85 c0                	test   %eax,%eax
  800a8b:	0f 84 01 01 00 00    	je     800b92 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800a91:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800a97:	bb 70 44 80 00       	mov    $0x804470,%ebx
  800a9c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800aa1:	89 c7                	mov    %eax,%edi
  800aa3:	89 de                	mov    %ebx,%esi
  800aa5:	89 d1                	mov    %edx,%ecx
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800aa9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800aac:	b9 56 00 00 00       	mov    $0x56,%ecx
  800ab1:	b0 00                	mov    $0x0,%al
  800ab3:	89 d7                	mov    %edx,%edi
  800ab5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800ab7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800abe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	50                   	push   %eax
  800ac5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800acb:	50                   	push   %eax
  800acc:	e8 e6 24 00 00       	call   802fb7 <sys_utilities>
  800ad1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800ad4:	e8 2f 20 00 00       	call   802b08 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800ad9:	83 ec 0c             	sub    $0xc,%esp
  800adc:	68 90 43 80 00       	push   $0x804390
  800ae1:	e8 be 01 00 00       	call   800ca4 <cprintf>
  800ae6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aec:	85 c0                	test   %eax,%eax
  800aee:	74 18                	je     800b08 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800af0:	e8 e0 24 00 00       	call   802fd5 <sys_get_optimal_num_faults>
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	50                   	push   %eax
  800af9:	68 b8 43 80 00       	push   $0x8043b8
  800afe:	e8 a1 01 00 00       	call   800ca4 <cprintf>
  800b03:	83 c4 10             	add    $0x10,%esp
  800b06:	eb 59                	jmp    800b61 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b08:	a1 20 60 80 00       	mov    0x806020,%eax
  800b0d:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800b13:	a1 20 60 80 00       	mov    0x806020,%eax
  800b18:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	50                   	push   %eax
  800b23:	68 dc 43 80 00       	push   $0x8043dc
  800b28:	e8 77 01 00 00       	call   800ca4 <cprintf>
  800b2d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800b30:	a1 20 60 80 00       	mov    0x806020,%eax
  800b35:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800b3b:	a1 20 60 80 00       	mov    0x806020,%eax
  800b40:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800b46:	a1 20 60 80 00       	mov    0x806020,%eax
  800b4b:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800b51:	51                   	push   %ecx
  800b52:	52                   	push   %edx
  800b53:	50                   	push   %eax
  800b54:	68 04 44 80 00       	push   $0x804404
  800b59:	e8 46 01 00 00       	call   800ca4 <cprintf>
  800b5e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800b61:	a1 20 60 80 00       	mov    0x806020,%eax
  800b66:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	50                   	push   %eax
  800b70:	68 5c 44 80 00       	push   $0x80445c
  800b75:	e8 2a 01 00 00       	call   800ca4 <cprintf>
  800b7a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800b7d:	83 ec 0c             	sub    $0xc,%esp
  800b80:	68 90 43 80 00       	push   $0x804390
  800b85:	e8 1a 01 00 00       	call   800ca4 <cprintf>
  800b8a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800b8d:	e8 90 1f 00 00       	call   802b22 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800b92:	e8 1f 00 00 00       	call   800bb6 <exit>
}
  800b97:	90                   	nop
  800b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	6a 00                	push   $0x0
  800bab:	e8 9d 21 00 00       	call   802d4d <sys_destroy_env>
  800bb0:	83 c4 10             	add    $0x10,%esp
}
  800bb3:	90                   	nop
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <exit>:

void
exit(void)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800bbc:	e8 f2 21 00 00       	call   802db3 <sys_exit_env>
}
  800bc1:	90                   	nop
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	53                   	push   %ebx
  800bc8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8b 00                	mov    (%eax),%eax
  800bd0:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd6:	89 0a                	mov    %ecx,(%edx)
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	88 d1                	mov    %dl,%cl
  800bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bee:	75 30                	jne    800c20 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800bf0:	8b 15 18 e1 81 00    	mov    0x81e118,%edx
  800bf6:	a0 44 60 80 00       	mov    0x806044,%al
  800bfb:	0f b6 c0             	movzbl %al,%eax
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	8b 09                	mov    (%ecx),%ecx
  800c03:	89 cb                	mov    %ecx,%ebx
  800c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c08:	83 c1 08             	add    $0x8,%ecx
  800c0b:	52                   	push   %edx
  800c0c:	50                   	push   %eax
  800c0d:	53                   	push   %ebx
  800c0e:	51                   	push   %ecx
  800c0f:	e8 b0 1e 00 00       	call   802ac4 <sys_cputs>
  800c14:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 40 04             	mov    0x4(%eax),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c2f:	90                   	nop
  800c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c3e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c45:	00 00 00 
	b.cnt = 0;
  800c48:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c4f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	ff 75 08             	pushl  0x8(%ebp)
  800c58:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c5e:	50                   	push   %eax
  800c5f:	68 c4 0b 80 00       	push   $0x800bc4
  800c64:	e8 5a 02 00 00       	call   800ec3 <vprintfmt>
  800c69:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c6c:	8b 15 18 e1 81 00    	mov    0x81e118,%edx
  800c72:	a0 44 60 80 00       	mov    0x806044,%al
  800c77:	0f b6 c0             	movzbl %al,%eax
  800c7a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c80:	52                   	push   %edx
  800c81:	50                   	push   %eax
  800c82:	51                   	push   %ecx
  800c83:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c89:	83 c0 08             	add    $0x8,%eax
  800c8c:	50                   	push   %eax
  800c8d:	e8 32 1e 00 00       	call   802ac4 <sys_cputs>
  800c92:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c95:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800c9c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800caa:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800cb1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	e8 6f ff ff ff       	call   800c35 <vcprintf>
  800cc6:	83 c4 10             	add    $0x10,%esp
  800cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cd7:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	c1 e0 08             	shl    $0x8,%eax
  800ce4:	a3 18 e1 81 00       	mov    %eax,0x81e118
	va_start(ap, fmt);
  800ce9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	e8 34 ff ff ff       	call   800c35 <vcprintf>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800d07:	c7 05 18 e1 81 00 00 	movl   $0x700,0x81e118
  800d0e:	07 00 00 

	return cnt;
  800d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d1c:	e8 e7 1d 00 00       	call   802b08 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d21:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d30:	50                   	push   %eax
  800d31:	e8 ff fe ff ff       	call   800c35 <vcprintf>
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d3c:	e8 e1 1d 00 00       	call   802b22 <sys_unlock_cons>
	return cnt;
  800d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 14             	sub    $0x14,%esp
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d59:	8b 45 18             	mov    0x18(%ebp),%eax
  800d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d61:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d64:	77 55                	ja     800dbb <printnum+0x75>
  800d66:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d69:	72 05                	jb     800d70 <printnum+0x2a>
  800d6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d6e:	77 4b                	ja     800dbb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d70:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d73:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d76:	8b 45 18             	mov    0x18(%ebp),%eax
  800d79:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7e:	52                   	push   %edx
  800d7f:	50                   	push   %eax
  800d80:	ff 75 f4             	pushl  -0xc(%ebp)
  800d83:	ff 75 f0             	pushl  -0x10(%ebp)
  800d86:	e8 e9 31 00 00       	call   803f74 <__udivdi3>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	ff 75 20             	pushl  0x20(%ebp)
  800d94:	53                   	push   %ebx
  800d95:	ff 75 18             	pushl  0x18(%ebp)
  800d98:	52                   	push   %edx
  800d99:	50                   	push   %eax
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 a1 ff ff ff       	call   800d46 <printnum>
  800da5:	83 c4 20             	add    $0x20,%esp
  800da8:	eb 1a                	jmp    800dc4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	ff 75 20             	pushl  0x20(%ebp)
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dbb:	ff 4d 1c             	decl   0x1c(%ebp)
  800dbe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dc2:	7f e6                	jg     800daa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dc4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd2:	53                   	push   %ebx
  800dd3:	51                   	push   %ecx
  800dd4:	52                   	push   %edx
  800dd5:	50                   	push   %eax
  800dd6:	e8 a9 32 00 00       	call   804084 <__umoddi3>
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	05 f4 46 80 00       	add    $0x8046f4,%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f be c0             	movsbl %al,%eax
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	50                   	push   %eax
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
}
  800df7:	90                   	nop
  800df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e00:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e04:	7e 1c                	jle    800e22 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8b 00                	mov    (%eax),%eax
  800e0b:	8d 50 08             	lea    0x8(%eax),%edx
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	89 10                	mov    %edx,(%eax)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	83 e8 08             	sub    $0x8,%eax
  800e1b:	8b 50 04             	mov    0x4(%eax),%edx
  800e1e:	8b 00                	mov    (%eax),%eax
  800e20:	eb 40                	jmp    800e62 <getuint+0x65>
	else if (lflag)
  800e22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e26:	74 1e                	je     800e46 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	8d 50 04             	lea    0x4(%eax),%edx
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	89 10                	mov    %edx,(%eax)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8b 00                	mov    (%eax),%eax
  800e3a:	83 e8 04             	sub    $0x4,%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e44:	eb 1c                	jmp    800e62 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 00                	mov    (%eax),%eax
  800e4b:	8d 50 04             	lea    0x4(%eax),%edx
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 10                	mov    %edx,(%eax)
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8b 00                	mov    (%eax),%eax
  800e58:	83 e8 04             	sub    $0x4,%eax
  800e5b:	8b 00                	mov    (%eax),%eax
  800e5d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e67:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e6b:	7e 1c                	jle    800e89 <getint+0x25>
		return va_arg(*ap, long long);
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 50 08             	lea    0x8(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 10                	mov    %edx,(%eax)
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8b 00                	mov    (%eax),%eax
  800e7f:	83 e8 08             	sub    $0x8,%eax
  800e82:	8b 50 04             	mov    0x4(%eax),%edx
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	eb 38                	jmp    800ec1 <getint+0x5d>
	else if (lflag)
  800e89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8d:	74 1a                	je     800ea9 <getint+0x45>
		return va_arg(*ap, long);
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8b 00                	mov    (%eax),%eax
  800e94:	8d 50 04             	lea    0x4(%eax),%edx
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 10                	mov    %edx,(%eax)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8b 00                	mov    (%eax),%eax
  800ea1:	83 e8 04             	sub    $0x4,%eax
  800ea4:	8b 00                	mov    (%eax),%eax
  800ea6:	99                   	cltd   
  800ea7:	eb 18                	jmp    800ec1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	8d 50 04             	lea    0x4(%eax),%edx
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 10                	mov    %edx,(%eax)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8b 00                	mov    (%eax),%eax
  800ebb:	83 e8 04             	sub    $0x4,%eax
  800ebe:	8b 00                	mov    (%eax),%eax
  800ec0:	99                   	cltd   
}
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ecb:	eb 17                	jmp    800ee4 <vprintfmt+0x21>
			if (ch == '\0')
  800ecd:	85 db                	test   %ebx,%ebx
  800ecf:	0f 84 c1 03 00 00    	je     801296 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	53                   	push   %ebx
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	ff d0                	call   *%eax
  800ee1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	89 55 10             	mov    %edx,0x10(%ebp)
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f b6 d8             	movzbl %al,%ebx
  800ef2:	83 fb 25             	cmp    $0x25,%ebx
  800ef5:	75 d6                	jne    800ecd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ef7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800efb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f02:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 01             	lea    0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	0f b6 d8             	movzbl %al,%ebx
  800f25:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f28:	83 f8 5b             	cmp    $0x5b,%eax
  800f2b:	0f 87 3d 03 00 00    	ja     80126e <vprintfmt+0x3ab>
  800f31:	8b 04 85 18 47 80 00 	mov    0x804718(,%eax,4),%eax
  800f38:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f3a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f3e:	eb d7                	jmp    800f17 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f40:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f44:	eb d1                	jmp    800f17 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f46:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f50:	89 d0                	mov    %edx,%eax
  800f52:	c1 e0 02             	shl    $0x2,%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	01 c0                	add    %eax,%eax
  800f59:	01 d8                	add    %ebx,%eax
  800f5b:	83 e8 30             	sub    $0x30,%eax
  800f5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f61:	8b 45 10             	mov    0x10(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f69:	83 fb 2f             	cmp    $0x2f,%ebx
  800f6c:	7e 3e                	jle    800fac <vprintfmt+0xe9>
  800f6e:	83 fb 39             	cmp    $0x39,%ebx
  800f71:	7f 39                	jg     800fac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f73:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f76:	eb d5                	jmp    800f4d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	83 c0 04             	add    $0x4,%eax
  800f7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	83 e8 04             	sub    $0x4,%eax
  800f87:	8b 00                	mov    (%eax),%eax
  800f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f92:	79 83                	jns    800f17 <vprintfmt+0x54>
				width = 0;
  800f94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f9b:	e9 77 ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fa0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fa7:	e9 6b ff ff ff       	jmp    800f17 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb1:	0f 89 60 ff ff ff    	jns    800f17 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fbd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fc4:	e9 4e ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fc9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fcc:	e9 46 ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	83 c0 04             	add    $0x4,%eax
  800fd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fda:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdd:	83 e8 04             	sub    $0x4,%eax
  800fe0:	8b 00                	mov    (%eax),%eax
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	50                   	push   %eax
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	ff d0                	call   *%eax
  800fee:	83 c4 10             	add    $0x10,%esp
			break;
  800ff1:	e9 9b 02 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff9:	83 c0 04             	add    $0x4,%eax
  800ffc:	89 45 14             	mov    %eax,0x14(%ebp)
  800fff:	8b 45 14             	mov    0x14(%ebp),%eax
  801002:	83 e8 04             	sub    $0x4,%eax
  801005:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801007:	85 db                	test   %ebx,%ebx
  801009:	79 02                	jns    80100d <vprintfmt+0x14a>
				err = -err;
  80100b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80100d:	83 fb 64             	cmp    $0x64,%ebx
  801010:	7f 0b                	jg     80101d <vprintfmt+0x15a>
  801012:	8b 34 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%esi
  801019:	85 f6                	test   %esi,%esi
  80101b:	75 19                	jne    801036 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80101d:	53                   	push   %ebx
  80101e:	68 05 47 80 00       	push   $0x804705
  801023:	ff 75 0c             	pushl  0xc(%ebp)
  801026:	ff 75 08             	pushl  0x8(%ebp)
  801029:	e8 70 02 00 00       	call   80129e <printfmt>
  80102e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801031:	e9 5b 02 00 00       	jmp    801291 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801036:	56                   	push   %esi
  801037:	68 0e 47 80 00       	push   $0x80470e
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	ff 75 08             	pushl  0x8(%ebp)
  801042:	e8 57 02 00 00       	call   80129e <printfmt>
  801047:	83 c4 10             	add    $0x10,%esp
			break;
  80104a:	e9 42 02 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	83 c0 04             	add    $0x4,%eax
  801055:	89 45 14             	mov    %eax,0x14(%ebp)
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	83 e8 04             	sub    $0x4,%eax
  80105e:	8b 30                	mov    (%eax),%esi
  801060:	85 f6                	test   %esi,%esi
  801062:	75 05                	jne    801069 <vprintfmt+0x1a6>
				p = "(null)";
  801064:	be 11 47 80 00       	mov    $0x804711,%esi
			if (width > 0 && padc != '-')
  801069:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106d:	7e 6d                	jle    8010dc <vprintfmt+0x219>
  80106f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801073:	74 67                	je     8010dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801075:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	50                   	push   %eax
  80107c:	56                   	push   %esi
  80107d:	e8 26 05 00 00       	call   8015a8 <strnlen>
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801088:	eb 16                	jmp    8010a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80108a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	ff 75 0c             	pushl  0xc(%ebp)
  801094:	50                   	push   %eax
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	ff d0                	call   *%eax
  80109a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80109d:	ff 4d e4             	decl   -0x1c(%ebp)
  8010a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a4:	7f e4                	jg     80108a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010a6:	eb 34                	jmp    8010dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010ac:	74 1c                	je     8010ca <vprintfmt+0x207>
  8010ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8010b1:	7e 05                	jle    8010b8 <vprintfmt+0x1f5>
  8010b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8010b6:	7e 12                	jle    8010ca <vprintfmt+0x207>
					putch('?', putdat);
  8010b8:	83 ec 08             	sub    $0x8,%esp
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	6a 3f                	push   $0x3f
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	ff d0                	call   *%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	eb 0f                	jmp    8010d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	53                   	push   %ebx
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	ff d0                	call   *%eax
  8010d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8010dc:	89 f0                	mov    %esi,%eax
  8010de:	8d 70 01             	lea    0x1(%eax),%esi
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f be d8             	movsbl %al,%ebx
  8010e6:	85 db                	test   %ebx,%ebx
  8010e8:	74 24                	je     80110e <vprintfmt+0x24b>
  8010ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010ee:	78 b8                	js     8010a8 <vprintfmt+0x1e5>
  8010f0:	ff 4d e0             	decl   -0x20(%ebp)
  8010f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010f7:	79 af                	jns    8010a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010f9:	eb 13                	jmp    80110e <vprintfmt+0x24b>
				putch(' ', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 20                	push   $0x20
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80110b:	ff 4d e4             	decl   -0x1c(%ebp)
  80110e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801112:	7f e7                	jg     8010fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801114:	e9 78 01 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 e8             	pushl  -0x18(%ebp)
  80111f:	8d 45 14             	lea    0x14(%ebp),%eax
  801122:	50                   	push   %eax
  801123:	e8 3c fd ff ff       	call   800e64 <getint>
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	79 23                	jns    80115e <vprintfmt+0x29b>
				putch('-', putdat);
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	6a 2d                	push   $0x2d
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	ff d0                	call   *%eax
  801148:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80114b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801151:	f7 d8                	neg    %eax
  801153:	83 d2 00             	adc    $0x0,%edx
  801156:	f7 da                	neg    %edx
  801158:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80115e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801165:	e9 bc 00 00 00       	jmp    801226 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 e8             	pushl  -0x18(%ebp)
  801170:	8d 45 14             	lea    0x14(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	e8 84 fc ff ff       	call   800dfd <getuint>
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801182:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801189:	e9 98 00 00 00       	jmp    801226 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80118e:	83 ec 08             	sub    $0x8,%esp
  801191:	ff 75 0c             	pushl  0xc(%ebp)
  801194:	6a 58                	push   $0x58
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	ff d0                	call   *%eax
  80119b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 0c             	pushl  0xc(%ebp)
  8011a4:	6a 58                	push   $0x58
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	ff d0                	call   *%eax
  8011ab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011ae:	83 ec 08             	sub    $0x8,%esp
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	6a 58                	push   $0x58
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	ff d0                	call   *%eax
  8011bb:	83 c4 10             	add    $0x10,%esp
			break;
  8011be:	e9 ce 00 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	6a 30                	push   $0x30
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	ff d0                	call   *%eax
  8011d0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	ff 75 0c             	pushl  0xc(%ebp)
  8011d9:	6a 78                	push   $0x78
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	ff d0                	call   *%eax
  8011e0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e6:	83 c0 04             	add    $0x4,%eax
  8011e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	83 e8 04             	sub    $0x4,%eax
  8011f2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801205:	eb 1f                	jmp    801226 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	ff 75 e8             	pushl  -0x18(%ebp)
  80120d:	8d 45 14             	lea    0x14(%ebp),%eax
  801210:	50                   	push   %eax
  801211:	e8 e7 fb ff ff       	call   800dfd <getuint>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80121c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80121f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801226:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80122a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	52                   	push   %edx
  801231:	ff 75 e4             	pushl  -0x1c(%ebp)
  801234:	50                   	push   %eax
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	ff 75 f0             	pushl  -0x10(%ebp)
  80123b:	ff 75 0c             	pushl  0xc(%ebp)
  80123e:	ff 75 08             	pushl  0x8(%ebp)
  801241:	e8 00 fb ff ff       	call   800d46 <printnum>
  801246:	83 c4 20             	add    $0x20,%esp
			break;
  801249:	eb 46                	jmp    801291 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	53                   	push   %ebx
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	ff d0                	call   *%eax
  801257:	83 c4 10             	add    $0x10,%esp
			break;
  80125a:	eb 35                	jmp    801291 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80125c:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  801263:	eb 2c                	jmp    801291 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801265:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  80126c:	eb 23                	jmp    801291 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	6a 25                	push   $0x25
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	ff d0                	call   *%eax
  80127b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80127e:	ff 4d 10             	decl   0x10(%ebp)
  801281:	eb 03                	jmp    801286 <vprintfmt+0x3c3>
  801283:	ff 4d 10             	decl   0x10(%ebp)
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	48                   	dec    %eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 25                	cmp    $0x25,%al
  80128e:	75 f3                	jne    801283 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801290:	90                   	nop
		}
	}
  801291:	e9 35 fc ff ff       	jmp    800ecb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801296:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801297:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80129a:	5b                   	pop    %ebx
  80129b:	5e                   	pop    %esi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    

0080129e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a7:	83 c0 04             	add    $0x4,%eax
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b3:	50                   	push   %eax
  8012b4:	ff 75 0c             	pushl  0xc(%ebp)
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 04 fc ff ff       	call   800ec3 <vprintfmt>
  8012bf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012c2:	90                   	nop
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8b 40 08             	mov    0x8(%eax),%eax
  8012ce:	8d 50 01             	lea    0x1(%eax),%edx
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012da:	8b 10                	mov    (%eax),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	8b 40 04             	mov    0x4(%eax),%eax
  8012e2:	39 c2                	cmp    %eax,%edx
  8012e4:	73 12                	jae    8012f8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	8b 00                	mov    (%eax),%eax
  8012eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	89 0a                	mov    %ecx,(%edx)
  8012f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f6:	88 10                	mov    %dl,(%eax)
}
  8012f8:	90                   	nop
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80131c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801320:	74 06                	je     801328 <vsnprintf+0x2d>
  801322:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801326:	7f 07                	jg     80132f <vsnprintf+0x34>
		return -E_INVAL;
  801328:	b8 03 00 00 00       	mov    $0x3,%eax
  80132d:	eb 20                	jmp    80134f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80132f:	ff 75 14             	pushl  0x14(%ebp)
  801332:	ff 75 10             	pushl  0x10(%ebp)
  801335:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	68 c5 12 80 00       	push   $0x8012c5
  80133e:	e8 80 fb ff ff       	call   800ec3 <vprintfmt>
  801343:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801349:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801357:	8d 45 10             	lea    0x10(%ebp),%eax
  80135a:	83 c0 04             	add    $0x4,%eax
  80135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	ff 75 f4             	pushl  -0xc(%ebp)
  801366:	50                   	push   %eax
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	ff 75 08             	pushl  0x8(%ebp)
  80136d:	e8 89 ff ff ff       	call   8012fb <vsnprintf>
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801378:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801383:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801387:	74 13                	je     80139c <readline+0x1f>
		cprintf("%s", prompt);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	ff 75 08             	pushl  0x8(%ebp)
  80138f:	68 88 48 80 00       	push   $0x804888
  801394:	e8 0b f9 ff ff       	call   800ca4 <cprintf>
  801399:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80139c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	6a 00                	push   $0x0
  8013a8:	e8 5d f6 ff ff       	call   800a0a <iscons>
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013b3:	e8 3f f6 ff ff       	call   8009f7 <getchar>
  8013b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013bf:	79 22                	jns    8013e3 <readline+0x66>
			if (c != -E_EOF)
  8013c1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013c5:	0f 84 ad 00 00 00    	je     801478 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8013d1:	68 8b 48 80 00       	push   $0x80488b
  8013d6:	e8 c9 f8 ff ff       	call   800ca4 <cprintf>
  8013db:	83 c4 10             	add    $0x10,%esp
			break;
  8013de:	e9 95 00 00 00       	jmp    801478 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013e3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013e7:	7e 34                	jle    80141d <readline+0xa0>
  8013e9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013f0:	7f 2b                	jg     80141d <readline+0xa0>
			if (echoing)
  8013f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f6:	74 0e                	je     801406 <readline+0x89>
				cputchar(c);
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8013fe:	e8 d5 f5 ff ff       	call   8009d8 <cputchar>
  801403:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	8d 50 01             	lea    0x1(%eax),%edx
  80140c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80140f:	89 c2                	mov    %eax,%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801419:	88 10                	mov    %dl,(%eax)
  80141b:	eb 56                	jmp    801473 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80141d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801421:	75 1f                	jne    801442 <readline+0xc5>
  801423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801427:	7e 19                	jle    801442 <readline+0xc5>
			if (echoing)
  801429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142d:	74 0e                	je     80143d <readline+0xc0>
				cputchar(c);
  80142f:	83 ec 0c             	sub    $0xc,%esp
  801432:	ff 75 ec             	pushl  -0x14(%ebp)
  801435:	e8 9e f5 ff ff       	call   8009d8 <cputchar>
  80143a:	83 c4 10             	add    $0x10,%esp

			i--;
  80143d:	ff 4d f4             	decl   -0xc(%ebp)
  801440:	eb 31                	jmp    801473 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801442:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801446:	74 0a                	je     801452 <readline+0xd5>
  801448:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80144c:	0f 85 61 ff ff ff    	jne    8013b3 <readline+0x36>
			if (echoing)
  801452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801456:	74 0e                	je     801466 <readline+0xe9>
				cputchar(c);
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	ff 75 ec             	pushl  -0x14(%ebp)
  80145e:	e8 75 f5 ff ff       	call   8009d8 <cputchar>
  801463:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801471:	eb 06                	jmp    801479 <readline+0xfc>
		}
	}
  801473:	e9 3b ff ff ff       	jmp    8013b3 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801478:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801479:	90                   	nop
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801482:	e8 81 16 00 00       	call   802b08 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801487:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80148b:	74 13                	je     8014a0 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	68 88 48 80 00       	push   $0x804888
  801498:	e8 07 f8 ff ff       	call   800ca4 <cprintf>
  80149d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8014a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	6a 00                	push   $0x0
  8014ac:	e8 59 f5 ff ff       	call   800a0a <iscons>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8014b7:	e8 3b f5 ff ff       	call   8009f7 <getchar>
  8014bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c3:	79 22                	jns    8014e7 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014c5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014c9:	0f 84 ad 00 00 00    	je     80157c <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8014d5:	68 8b 48 80 00       	push   $0x80488b
  8014da:	e8 c5 f7 ff ff       	call   800ca4 <cprintf>
  8014df:	83 c4 10             	add    $0x10,%esp
				break;
  8014e2:	e9 95 00 00 00       	jmp    80157c <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014e7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014eb:	7e 34                	jle    801521 <atomic_readline+0xa5>
  8014ed:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014f4:	7f 2b                	jg     801521 <atomic_readline+0xa5>
				if (echoing)
  8014f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014fa:	74 0e                	je     80150a <atomic_readline+0x8e>
					cputchar(c);
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801502:	e8 d1 f4 ff ff       	call   8009d8 <cputchar>
  801507:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80150a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150d:	8d 50 01             	lea    0x1(%eax),%edx
  801510:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801513:	89 c2                	mov    %eax,%edx
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80151d:	88 10                	mov    %dl,(%eax)
  80151f:	eb 56                	jmp    801577 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801521:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801525:	75 1f                	jne    801546 <atomic_readline+0xca>
  801527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80152b:	7e 19                	jle    801546 <atomic_readline+0xca>
				if (echoing)
  80152d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801531:	74 0e                	je     801541 <atomic_readline+0xc5>
					cputchar(c);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	ff 75 ec             	pushl  -0x14(%ebp)
  801539:	e8 9a f4 ff ff       	call   8009d8 <cputchar>
  80153e:	83 c4 10             	add    $0x10,%esp
				i--;
  801541:	ff 4d f4             	decl   -0xc(%ebp)
  801544:	eb 31                	jmp    801577 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801546:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80154a:	74 0a                	je     801556 <atomic_readline+0xda>
  80154c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801550:	0f 85 61 ff ff ff    	jne    8014b7 <atomic_readline+0x3b>
				if (echoing)
  801556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155a:	74 0e                	je     80156a <atomic_readline+0xee>
					cputchar(c);
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	ff 75 ec             	pushl  -0x14(%ebp)
  801562:	e8 71 f4 ff ff       	call   8009d8 <cputchar>
  801567:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801570:	01 d0                	add    %edx,%eax
  801572:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801575:	eb 06                	jmp    80157d <atomic_readline+0x101>
			}
		}
  801577:	e9 3b ff ff ff       	jmp    8014b7 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80157c:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80157d:	e8 a0 15 00 00       	call   802b22 <sys_unlock_cons>
}
  801582:	90                   	nop
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80158b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801592:	eb 06                	jmp    80159a <strlen+0x15>
		n++;
  801594:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801597:	ff 45 08             	incl   0x8(%ebp)
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	84 c0                	test   %al,%al
  8015a1:	75 f1                	jne    801594 <strlen+0xf>
		n++;
	return n;
  8015a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b5:	eb 09                	jmp    8015c0 <strnlen+0x18>
		n++;
  8015b7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ba:	ff 45 08             	incl   0x8(%ebp)
  8015bd:	ff 4d 0c             	decl   0xc(%ebp)
  8015c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c4:	74 09                	je     8015cf <strnlen+0x27>
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	84 c0                	test   %al,%al
  8015cd:	75 e8                	jne    8015b7 <strnlen+0xf>
		n++;
	return n;
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015e0:	90                   	nop
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8d 50 01             	lea    0x1(%eax),%edx
  8015e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015f3:	8a 12                	mov    (%edx),%dl
  8015f5:	88 10                	mov    %dl,(%eax)
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	84 c0                	test   %al,%al
  8015fb:	75 e4                	jne    8015e1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80160e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801615:	eb 1f                	jmp    801636 <strncpy+0x34>
		*dst++ = *src;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8d 50 01             	lea    0x1(%eax),%edx
  80161d:	89 55 08             	mov    %edx,0x8(%ebp)
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8a 12                	mov    (%edx),%dl
  801625:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	84 c0                	test   %al,%al
  80162e:	74 03                	je     801633 <strncpy+0x31>
			src++;
  801630:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801633:	ff 45 fc             	incl   -0x4(%ebp)
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	3b 45 10             	cmp    0x10(%ebp),%eax
  80163c:	72 d9                	jb     801617 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80164f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801653:	74 30                	je     801685 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801655:	eb 16                	jmp    80166d <strlcpy+0x2a>
			*dst++ = *src++;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8d 50 01             	lea    0x1(%eax),%edx
  80165d:	89 55 08             	mov    %edx,0x8(%ebp)
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8d 4a 01             	lea    0x1(%edx),%ecx
  801666:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801669:	8a 12                	mov    (%edx),%dl
  80166b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80166d:	ff 4d 10             	decl   0x10(%ebp)
  801670:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801674:	74 09                	je     80167f <strlcpy+0x3c>
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	84 c0                	test   %al,%al
  80167d:	75 d8                	jne    801657 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801685:	8b 55 08             	mov    0x8(%ebp),%edx
  801688:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168b:	29 c2                	sub    %eax,%edx
  80168d:	89 d0                	mov    %edx,%eax
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801694:	eb 06                	jmp    80169c <strcmp+0xb>
		p++, q++;
  801696:	ff 45 08             	incl   0x8(%ebp)
  801699:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	84 c0                	test   %al,%al
  8016a3:	74 0e                	je     8016b3 <strcmp+0x22>
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8a 10                	mov    (%eax),%dl
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	38 c2                	cmp    %al,%dl
  8016b1:	74 e3                	je     801696 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	0f b6 d0             	movzbl %al,%edx
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	0f b6 c0             	movzbl %al,%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016cc:	eb 09                	jmp    8016d7 <strncmp+0xe>
		n--, p++, q++;
  8016ce:	ff 4d 10             	decl   0x10(%ebp)
  8016d1:	ff 45 08             	incl   0x8(%ebp)
  8016d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016db:	74 17                	je     8016f4 <strncmp+0x2b>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	84 c0                	test   %al,%al
  8016e4:	74 0e                	je     8016f4 <strncmp+0x2b>
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 10                	mov    (%eax),%dl
  8016eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	38 c2                	cmp    %al,%dl
  8016f2:	74 da                	je     8016ce <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f8:	75 07                	jne    801701 <strncmp+0x38>
		return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ff:	eb 14                	jmp    801715 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f b6 d0             	movzbl %al,%edx
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	0f b6 c0             	movzbl %al,%eax
  801711:	29 c2                	sub    %eax,%edx
  801713:	89 d0                	mov    %edx,%eax
}
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801723:	eb 12                	jmp    801737 <strchr+0x20>
		if (*s == c)
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80172d:	75 05                	jne    801734 <strchr+0x1d>
			return (char *) s;
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	eb 11                	jmp    801745 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801734:	ff 45 08             	incl   0x8(%ebp)
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	84 c0                	test   %al,%al
  80173e:	75 e5                	jne    801725 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801753:	eb 0d                	jmp    801762 <strfind+0x1b>
		if (*s == c)
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80175d:	74 0e                	je     80176d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80175f:	ff 45 08             	incl   0x8(%ebp)
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	84 c0                	test   %al,%al
  801769:	75 ea                	jne    801755 <strfind+0xe>
  80176b:	eb 01                	jmp    80176e <strfind+0x27>
		if (*s == c)
			break;
  80176d:	90                   	nop
	return (char *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80177f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801783:	76 63                	jbe    8017e8 <memset+0x75>
		uint64 data_block = c;
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	99                   	cltd   
  801789:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80178c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801795:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801799:	c1 e0 08             	shl    $0x8,%eax
  80179c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80179f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8017ac:	c1 e0 10             	shl    $0x10,%eax
  8017af:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017b2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bb:	89 c2                	mov    %eax,%edx
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017c5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017c8:	eb 18                	jmp    8017e2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017cd:	8d 41 08             	lea    0x8(%ecx),%eax
  8017d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	89 01                	mov    %eax,(%ecx)
  8017db:	89 51 04             	mov    %edx,0x4(%ecx)
  8017de:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017e2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017e6:	77 e2                	ja     8017ca <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ec:	74 23                	je     801811 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8017ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017f4:	eb 0e                	jmp    801804 <memset+0x91>
			*p8++ = (uint8)c;
  8017f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f9:	8d 50 01             	lea    0x1(%eax),%edx
  8017fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180a:	89 55 10             	mov    %edx,0x10(%ebp)
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 e5                	jne    8017f6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80181c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801828:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80182c:	76 24                	jbe    801852 <memcpy+0x3c>
		while(n >= 8){
  80182e:	eb 1c                	jmp    80184c <memcpy+0x36>
			*d64 = *s64;
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801833:	8b 50 04             	mov    0x4(%eax),%edx
  801836:	8b 00                	mov    (%eax),%eax
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	89 01                	mov    %eax,(%ecx)
  80183d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801840:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801844:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801848:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80184c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801850:	77 de                	ja     801830 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801852:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801856:	74 31                	je     801889 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801858:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80185e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801861:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801864:	eb 16                	jmp    80187c <memcpy+0x66>
			*d8++ = *s8++;
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801869:	8d 50 01             	lea    0x1(%eax),%edx
  80186c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80186f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801872:	8d 4a 01             	lea    0x1(%edx),%ecx
  801875:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801878:	8a 12                	mov    (%edx),%dl
  80187a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80187c:	8b 45 10             	mov    0x10(%ebp),%eax
  80187f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801882:	89 55 10             	mov    %edx,0x10(%ebp)
  801885:	85 c0                	test   %eax,%eax
  801887:	75 dd                	jne    801866 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801894:	8b 45 0c             	mov    0xc(%ebp),%eax
  801897:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018a6:	73 50                	jae    8018f8 <memmove+0x6a>
  8018a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018b3:	76 43                	jbe    8018f8 <memmove+0x6a>
		s += n;
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018c1:	eb 10                	jmp    8018d3 <memmove+0x45>
			*--d = *--s;
  8018c3:	ff 4d f8             	decl   -0x8(%ebp)
  8018c6:	ff 4d fc             	decl   -0x4(%ebp)
  8018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cc:	8a 10                	mov    (%eax),%dl
  8018ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	75 e3                	jne    8018c3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018e0:	eb 23                	jmp    801905 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e5:	8d 50 01             	lea    0x1(%eax),%edx
  8018e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018f1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018f4:	8a 12                	mov    (%edx),%dl
  8018f6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801901:	85 c0                	test   %eax,%eax
  801903:	75 dd                	jne    8018e2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80191c:	eb 2a                	jmp    801948 <memcmp+0x3e>
		if (*s1 != *s2)
  80191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801921:	8a 10                	mov    (%eax),%dl
  801923:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	38 c2                	cmp    %al,%dl
  80192a:	74 16                	je     801942 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80192c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192f:	8a 00                	mov    (%eax),%al
  801931:	0f b6 d0             	movzbl %al,%edx
  801934:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f b6 c0             	movzbl %al,%eax
  80193c:	29 c2                	sub    %eax,%edx
  80193e:	89 d0                	mov    %edx,%eax
  801940:	eb 18                	jmp    80195a <memcmp+0x50>
		s1++, s2++;
  801942:	ff 45 fc             	incl   -0x4(%ebp)
  801945:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80194e:	89 55 10             	mov    %edx,0x10(%ebp)
  801951:	85 c0                	test   %eax,%eax
  801953:	75 c9                	jne    80191e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801962:	8b 55 08             	mov    0x8(%ebp),%edx
  801965:	8b 45 10             	mov    0x10(%ebp),%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80196d:	eb 15                	jmp    801984 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	8a 00                	mov    (%eax),%al
  801974:	0f b6 d0             	movzbl %al,%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	0f b6 c0             	movzbl %al,%eax
  80197d:	39 c2                	cmp    %eax,%edx
  80197f:	74 0d                	je     80198e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801981:	ff 45 08             	incl   0x8(%ebp)
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80198a:	72 e3                	jb     80196f <memfind+0x13>
  80198c:	eb 01                	jmp    80198f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80198e:	90                   	nop
	return (void *) s;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80199a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a8:	eb 03                	jmp    8019ad <strtol+0x19>
		s++;
  8019aa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	3c 20                	cmp    $0x20,%al
  8019b4:	74 f4                	je     8019aa <strtol+0x16>
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	3c 09                	cmp    $0x9,%al
  8019bd:	74 eb                	je     8019aa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	8a 00                	mov    (%eax),%al
  8019c4:	3c 2b                	cmp    $0x2b,%al
  8019c6:	75 05                	jne    8019cd <strtol+0x39>
		s++;
  8019c8:	ff 45 08             	incl   0x8(%ebp)
  8019cb:	eb 13                	jmp    8019e0 <strtol+0x4c>
	else if (*s == '-')
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8a 00                	mov    (%eax),%al
  8019d2:	3c 2d                	cmp    $0x2d,%al
  8019d4:	75 0a                	jne    8019e0 <strtol+0x4c>
		s++, neg = 1;
  8019d6:	ff 45 08             	incl   0x8(%ebp)
  8019d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019e4:	74 06                	je     8019ec <strtol+0x58>
  8019e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019ea:	75 20                	jne    801a0c <strtol+0x78>
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8a 00                	mov    (%eax),%al
  8019f1:	3c 30                	cmp    $0x30,%al
  8019f3:	75 17                	jne    801a0c <strtol+0x78>
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	40                   	inc    %eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	3c 78                	cmp    $0x78,%al
  8019fd:	75 0d                	jne    801a0c <strtol+0x78>
		s += 2, base = 16;
  8019ff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a03:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a0a:	eb 28                	jmp    801a34 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a10:	75 15                	jne    801a27 <strtol+0x93>
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8a 00                	mov    (%eax),%al
  801a17:	3c 30                	cmp    $0x30,%al
  801a19:	75 0c                	jne    801a27 <strtol+0x93>
		s++, base = 8;
  801a1b:	ff 45 08             	incl   0x8(%ebp)
  801a1e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a25:	eb 0d                	jmp    801a34 <strtol+0xa0>
	else if (base == 0)
  801a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a2b:	75 07                	jne    801a34 <strtol+0xa0>
		base = 10;
  801a2d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	8a 00                	mov    (%eax),%al
  801a39:	3c 2f                	cmp    $0x2f,%al
  801a3b:	7e 19                	jle    801a56 <strtol+0xc2>
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	3c 39                	cmp    $0x39,%al
  801a44:	7f 10                	jg     801a56 <strtol+0xc2>
			dig = *s - '0';
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8a 00                	mov    (%eax),%al
  801a4b:	0f be c0             	movsbl %al,%eax
  801a4e:	83 e8 30             	sub    $0x30,%eax
  801a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a54:	eb 42                	jmp    801a98 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	3c 60                	cmp    $0x60,%al
  801a5d:	7e 19                	jle    801a78 <strtol+0xe4>
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	3c 7a                	cmp    $0x7a,%al
  801a66:	7f 10                	jg     801a78 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	8a 00                	mov    (%eax),%al
  801a6d:	0f be c0             	movsbl %al,%eax
  801a70:	83 e8 57             	sub    $0x57,%eax
  801a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a76:	eb 20                	jmp    801a98 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	3c 40                	cmp    $0x40,%al
  801a7f:	7e 39                	jle    801aba <strtol+0x126>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	3c 5a                	cmp    $0x5a,%al
  801a88:	7f 30                	jg     801aba <strtol+0x126>
			dig = *s - 'A' + 10;
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	8a 00                	mov    (%eax),%al
  801a8f:	0f be c0             	movsbl %al,%eax
  801a92:	83 e8 37             	sub    $0x37,%eax
  801a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a9e:	7d 19                	jge    801ab9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aa0:	ff 45 08             	incl   0x8(%ebp)
  801aa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa6:	0f af 45 10          	imul   0x10(%ebp),%eax
  801aaa:	89 c2                	mov    %eax,%edx
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ab4:	e9 7b ff ff ff       	jmp    801a34 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ab9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801aba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801abe:	74 08                	je     801ac8 <strtol+0x134>
		*endptr = (char *) s;
  801ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801acc:	74 07                	je     801ad5 <strtol+0x141>
  801ace:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad1:	f7 d8                	neg    %eax
  801ad3:	eb 03                	jmp    801ad8 <strtol+0x144>
  801ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <ltostr>:

void
ltostr(long value, char *str)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801ae7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801aee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af2:	79 13                	jns    801b07 <ltostr+0x2d>
	{
		neg = 1;
  801af4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b01:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b04:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b0f:	99                   	cltd   
  801b10:	f7 f9                	idiv   %ecx
  801b12:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b18:	8d 50 01             	lea    0x1(%eax),%edx
  801b1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b1e:	89 c2                	mov    %eax,%edx
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b28:	83 c2 30             	add    $0x30,%edx
  801b2b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b30:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b35:	f7 e9                	imul   %ecx
  801b37:	c1 fa 02             	sar    $0x2,%edx
  801b3a:	89 c8                	mov    %ecx,%eax
  801b3c:	c1 f8 1f             	sar    $0x1f,%eax
  801b3f:	29 c2                	sub    %eax,%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b4a:	75 bb                	jne    801b07 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b56:	48                   	dec    %eax
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b5e:	74 3d                	je     801b9d <ltostr+0xc3>
		start = 1 ;
  801b60:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b67:	eb 34                	jmp    801b9d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	01 d0                	add    %edx,%eax
  801b71:	8a 00                	mov    (%eax),%al
  801b73:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7c:	01 c2                	add    %eax,%edx
  801b7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b84:	01 c8                	add    %ecx,%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b90:	01 c2                	add    %eax,%edx
  801b92:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b95:	88 02                	mov    %al,(%edx)
		start++ ;
  801b97:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b9a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ba3:	7c c4                	jl     801b69 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ba5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bb0:	90                   	nop
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	e8 c4 f9 ff ff       	call   801585 <strlen>
  801bc1:	83 c4 04             	add    $0x4,%esp
  801bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	e8 b6 f9 ff ff       	call   801585 <strlen>
  801bcf:	83 c4 04             	add    $0x4,%esp
  801bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801be3:	eb 17                	jmp    801bfc <strcconcat+0x49>
		final[s] = str1[s] ;
  801be5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be8:	8b 45 10             	mov    0x10(%ebp),%eax
  801beb:	01 c2                	add    %eax,%edx
  801bed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	01 c8                	add    %ecx,%eax
  801bf5:	8a 00                	mov    (%eax),%al
  801bf7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bf9:	ff 45 fc             	incl   -0x4(%ebp)
  801bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c02:	7c e1                	jl     801be5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c12:	eb 1f                	jmp    801c33 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c17:	8d 50 01             	lea    0x1(%eax),%edx
  801c1a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c1d:	89 c2                	mov    %eax,%edx
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	01 c2                	add    %eax,%edx
  801c24:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2a:	01 c8                	add    %ecx,%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c30:	ff 45 f8             	incl   -0x8(%ebp)
  801c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c39:	7c d9                	jl     801c14 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c41:	01 d0                	add    %edx,%eax
  801c43:	c6 00 00             	movb   $0x0,(%eax)
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c55:	8b 45 14             	mov    0x14(%ebp),%eax
  801c58:	8b 00                	mov    (%eax),%eax
  801c5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c61:	8b 45 10             	mov    0x10(%ebp),%eax
  801c64:	01 d0                	add    %edx,%eax
  801c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c6c:	eb 0c                	jmp    801c7a <strsplit+0x31>
			*string++ = 0;
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	8d 50 01             	lea    0x1(%eax),%edx
  801c74:	89 55 08             	mov    %edx,0x8(%ebp)
  801c77:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	8a 00                	mov    (%eax),%al
  801c7f:	84 c0                	test   %al,%al
  801c81:	74 18                	je     801c9b <strsplit+0x52>
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8a 00                	mov    (%eax),%al
  801c88:	0f be c0             	movsbl %al,%eax
  801c8b:	50                   	push   %eax
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	e8 83 fa ff ff       	call   801717 <strchr>
  801c94:	83 c4 08             	add    $0x8,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	75 d3                	jne    801c6e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	8a 00                	mov    (%eax),%al
  801ca0:	84 c0                	test   %al,%al
  801ca2:	74 5a                	je     801cfe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca7:	8b 00                	mov    (%eax),%eax
  801ca9:	83 f8 0f             	cmp    $0xf,%eax
  801cac:	75 07                	jne    801cb5 <strsplit+0x6c>
		{
			return 0;
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb3:	eb 66                	jmp    801d1b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cb5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb8:	8b 00                	mov    (%eax),%eax
  801cba:	8d 48 01             	lea    0x1(%eax),%ecx
  801cbd:	8b 55 14             	mov    0x14(%ebp),%edx
  801cc0:	89 0a                	mov    %ecx,(%edx)
  801cc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	01 c2                	add    %eax,%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cd3:	eb 03                	jmp    801cd8 <strsplit+0x8f>
			string++;
  801cd5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	8a 00                	mov    (%eax),%al
  801cdd:	84 c0                	test   %al,%al
  801cdf:	74 8b                	je     801c6c <strsplit+0x23>
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8a 00                	mov    (%eax),%al
  801ce6:	0f be c0             	movsbl %al,%eax
  801ce9:	50                   	push   %eax
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	e8 25 fa ff ff       	call   801717 <strchr>
  801cf2:	83 c4 08             	add    $0x8,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	74 dc                	je     801cd5 <strsplit+0x8c>
			string++;
	}
  801cf9:	e9 6e ff ff ff       	jmp    801c6c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cfe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	8b 00                	mov    (%eax),%eax
  801d04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d30:	eb 4a                	jmp    801d7c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	01 c2                	add    %eax,%edx
  801d3a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d40:	01 c8                	add    %ecx,%eax
  801d42:	8a 00                	mov    (%eax),%al
  801d44:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	8a 00                	mov    (%eax),%al
  801d50:	3c 40                	cmp    $0x40,%al
  801d52:	7e 25                	jle    801d79 <str2lower+0x5c>
  801d54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	8a 00                	mov    (%eax),%al
  801d5e:	3c 5a                	cmp    $0x5a,%al
  801d60:	7f 17                	jg     801d79 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d70:	01 ca                	add    %ecx,%edx
  801d72:	8a 12                	mov    (%edx),%dl
  801d74:	83 c2 20             	add    $0x20,%edx
  801d77:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d79:	ff 45 fc             	incl   -0x4(%ebp)
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	e8 01 f8 ff ff       	call   801585 <strlen>
  801d84:	83 c4 04             	add    $0x4,%esp
  801d87:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d8a:	7f a6                	jg     801d32 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	6a 10                	push   $0x10
  801d9c:	e8 b2 15 00 00       	call   803353 <alloc_block>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801da7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dab:	75 14                	jne    801dc1 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	68 9c 48 80 00       	push   $0x80489c
  801db5:	6a 14                	push   $0x14
  801db7:	68 c5 48 80 00       	push   $0x8048c5
  801dbc:	e8 a4 1f 00 00       	call   803d65 <_panic>

	node->start = start;
  801dc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc7:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcf:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801dd2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801dd9:	a1 24 60 80 00       	mov    0x806024,%eax
  801dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de1:	eb 18                	jmp    801dfb <insert_page_alloc+0x6a>
		if (start < it->start)
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	8b 00                	mov    (%eax),%eax
  801de8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801deb:	77 37                	ja     801e24 <insert_page_alloc+0x93>
			break;
		prev = it;
  801ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801df3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  801df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dff:	74 08                	je     801e09 <insert_page_alloc+0x78>
  801e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e04:	8b 40 08             	mov    0x8(%eax),%eax
  801e07:	eb 05                	jmp    801e0e <insert_page_alloc+0x7d>
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  801e13:	a1 2c 60 80 00       	mov    0x80602c,%eax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	75 c7                	jne    801de3 <insert_page_alloc+0x52>
  801e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e20:	75 c1                	jne    801de3 <insert_page_alloc+0x52>
  801e22:	eb 01                	jmp    801e25 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801e24:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e29:	75 64                	jne    801e8f <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801e2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e2f:	75 14                	jne    801e45 <insert_page_alloc+0xb4>
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	68 d4 48 80 00       	push   $0x8048d4
  801e39:	6a 21                	push   $0x21
  801e3b:	68 c5 48 80 00       	push   $0x8048c5
  801e40:	e8 20 1f 00 00       	call   803d65 <_panic>
  801e45:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4e:	89 50 08             	mov    %edx,0x8(%eax)
  801e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e54:	8b 40 08             	mov    0x8(%eax),%eax
  801e57:	85 c0                	test   %eax,%eax
  801e59:	74 0d                	je     801e68 <insert_page_alloc+0xd7>
  801e5b:	a1 24 60 80 00       	mov    0x806024,%eax
  801e60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e63:	89 50 0c             	mov    %edx,0xc(%eax)
  801e66:	eb 08                	jmp    801e70 <insert_page_alloc+0xdf>
  801e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6b:	a3 28 60 80 00       	mov    %eax,0x806028
  801e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e73:	a3 24 60 80 00       	mov    %eax,0x806024
  801e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e82:	a1 30 60 80 00       	mov    0x806030,%eax
  801e87:	40                   	inc    %eax
  801e88:	a3 30 60 80 00       	mov    %eax,0x806030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801e8d:	eb 71                	jmp    801f00 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801e8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e93:	74 06                	je     801e9b <insert_page_alloc+0x10a>
  801e95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e99:	75 14                	jne    801eaf <insert_page_alloc+0x11e>
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	68 f8 48 80 00       	push   $0x8048f8
  801ea3:	6a 23                	push   $0x23
  801ea5:	68 c5 48 80 00       	push   $0x8048c5
  801eaa:	e8 b6 1e 00 00       	call   803d65 <_panic>
  801eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb2:	8b 50 08             	mov    0x8(%eax),%edx
  801eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb8:	89 50 08             	mov    %edx,0x8(%eax)
  801ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebe:	8b 40 08             	mov    0x8(%eax),%eax
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	74 0c                	je     801ed1 <insert_page_alloc+0x140>
  801ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec8:	8b 40 08             	mov    0x8(%eax),%eax
  801ecb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ece:	89 50 0c             	mov    %edx,0xc(%eax)
  801ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ed7:	89 50 08             	mov    %edx,0x8(%eax)
  801eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee0:	89 50 0c             	mov    %edx,0xc(%eax)
  801ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee6:	8b 40 08             	mov    0x8(%eax),%eax
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	75 08                	jne    801ef5 <insert_page_alloc+0x164>
  801eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef0:	a3 28 60 80 00       	mov    %eax,0x806028
  801ef5:	a1 30 60 80 00       	mov    0x806030,%eax
  801efa:	40                   	inc    %eax
  801efb:	a3 30 60 80 00       	mov    %eax,0x806030
}
  801f00:	90                   	nop
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801f09:	a1 24 60 80 00       	mov    0x806024,%eax
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	75 0c                	jne    801f1e <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801f12:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801f17:	a3 68 e0 81 00       	mov    %eax,0x81e068
		return;
  801f1c:	eb 67                	jmp    801f85 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801f1e:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801f23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f26:	a1 24 60 80 00       	mov    0x806024,%eax
  801f2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801f2e:	eb 26                	jmp    801f56 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f33:	8b 10                	mov    (%eax),%edx
  801f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f38:	8b 40 04             	mov    0x4(%eax),%eax
  801f3b:	01 d0                	add    %edx,%eax
  801f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f46:	76 06                	jbe    801f4e <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f4e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  801f53:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801f56:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f5a:	74 08                	je     801f64 <recompute_page_alloc_break+0x61>
  801f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	eb 05                	jmp    801f69 <recompute_page_alloc_break+0x66>
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
  801f69:	a3 2c 60 80 00       	mov    %eax,0x80602c
  801f6e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	75 b9                	jne    801f30 <recompute_page_alloc_break+0x2d>
  801f77:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f7b:	75 b3                	jne    801f30 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f80:	a3 68 e0 81 00       	mov    %eax,0x81e068
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801f8d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801f94:	8b 55 08             	mov    0x8(%ebp),%edx
  801f97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	48                   	dec    %eax
  801f9d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801fa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa8:	f7 75 d8             	divl   -0x28(%ebp)
  801fab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fae:	29 d0                	sub    %edx,%eax
  801fb0:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801fb3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801fb7:	75 0a                	jne    801fc3 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbe:	e9 7e 01 00 00       	jmp    802141 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801fc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801fca:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801fce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801fd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801fdc:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801fe1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801fe4:	a1 24 60 80 00       	mov    0x806024,%eax
  801fe9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fec:	eb 69                	jmp    802057 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801fee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff1:	8b 00                	mov    (%eax),%eax
  801ff3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ff6:	76 47                	jbe    80203f <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ffb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801ffe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802001:	8b 00                	mov    (%eax),%eax
  802003:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802006:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  802009:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80200c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80200f:	72 2e                	jb     80203f <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  802011:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802015:	75 14                	jne    80202b <alloc_pages_custom_fit+0xa4>
  802017:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80201a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80201d:	75 0c                	jne    80202b <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  80201f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802022:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  802025:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802029:	eb 14                	jmp    80203f <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80202b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80202e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802031:	76 0c                	jbe    80203f <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802033:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802036:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  802039:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80203c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  80203f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802042:	8b 10                	mov    (%eax),%edx
  802044:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802047:	8b 40 04             	mov    0x4(%eax),%eax
  80204a:	01 d0                	add    %edx,%eax
  80204c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80204f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802054:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80205b:	74 08                	je     802065 <alloc_pages_custom_fit+0xde>
  80205d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802060:	8b 40 08             	mov    0x8(%eax),%eax
  802063:	eb 05                	jmp    80206a <alloc_pages_custom_fit+0xe3>
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80206f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	0f 85 72 ff ff ff    	jne    801fee <alloc_pages_custom_fit+0x67>
  80207c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802080:	0f 85 68 ff ff ff    	jne    801fee <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802086:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80208b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80208e:	76 47                	jbe    8020d7 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802093:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802096:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80209b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80209e:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8020a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020a4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020a7:	72 2e                	jb     8020d7 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8020a9:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8020ad:	75 14                	jne    8020c3 <alloc_pages_custom_fit+0x13c>
  8020af:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020b2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020b5:	75 0c                	jne    8020c3 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8020b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8020bd:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8020c1:	eb 14                	jmp    8020d7 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  8020c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020c9:	76 0c                	jbe    8020d7 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  8020cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  8020d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  8020d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  8020de:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8020e2:	74 08                	je     8020ec <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8020ea:	eb 40                	jmp    80212c <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  8020ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020f0:	74 08                	je     8020fa <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  8020f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8020f8:	eb 32                	jmp    80212c <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8020fa:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8020ff:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802102:	89 c2                	mov    %eax,%edx
  802104:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802109:	39 c2                	cmp    %eax,%edx
  80210b:	73 07                	jae    802114 <alloc_pages_custom_fit+0x18d>
			return NULL;
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	eb 2d                	jmp    802141 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802114:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802119:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  80211c:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802122:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802125:	01 d0                	add    %edx,%eax
  802127:	a3 68 e0 81 00       	mov    %eax,0x81e068
	}


	insert_page_alloc((uint32)result, required_size);
  80212c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80212f:	83 ec 08             	sub    $0x8,%esp
  802132:	ff 75 d0             	pushl  -0x30(%ebp)
  802135:	50                   	push   %eax
  802136:	e8 56 fc ff ff       	call   801d91 <insert_page_alloc>
  80213b:	83 c4 10             	add    $0x10,%esp

	return result;
  80213e:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80214f:	a1 24 60 80 00       	mov    0x806024,%eax
  802154:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802157:	eb 1a                	jmp    802173 <find_allocated_size+0x30>
		if (it->start == va)
  802159:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802161:	75 08                	jne    80216b <find_allocated_size+0x28>
			return it->size;
  802163:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802166:	8b 40 04             	mov    0x4(%eax),%eax
  802169:	eb 34                	jmp    80219f <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80216b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802170:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802173:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802177:	74 08                	je     802181 <find_allocated_size+0x3e>
  802179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217c:	8b 40 08             	mov    0x8(%eax),%eax
  80217f:	eb 05                	jmp    802186 <find_allocated_size+0x43>
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
  802186:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80218b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802190:	85 c0                	test   %eax,%eax
  802192:	75 c5                	jne    802159 <find_allocated_size+0x16>
  802194:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802198:	75 bf                	jne    802159 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8021ad:	a1 24 60 80 00       	mov    0x806024,%eax
  8021b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b5:	e9 e1 01 00 00       	jmp    80239b <free_pages+0x1fa>
		if (it->start == va) {
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021c2:	0f 85 cb 01 00 00    	jne    802393 <free_pages+0x1f2>

			uint32 start = it->start;
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 00                	mov    (%eax),%eax
  8021cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 40 04             	mov    0x4(%eax),%eax
  8021d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  8021d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021dc:	f7 d0                	not    %eax
  8021de:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8021e1:	73 1d                	jae    802200 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8021ec:	68 2c 49 80 00       	push   $0x80492c
  8021f1:	68 a5 00 00 00       	push   $0xa5
  8021f6:	68 c5 48 80 00       	push   $0x8048c5
  8021fb:	e8 65 1b 00 00       	call   803d65 <_panic>
			}

			uint32 start_end = start + size;
  802200:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802206:	01 d0                	add    %edx,%eax
  802208:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80220b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80220e:	85 c0                	test   %eax,%eax
  802210:	79 19                	jns    80222b <free_pages+0x8a>
  802212:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802219:	77 10                	ja     80222b <free_pages+0x8a>
  80221b:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802222:	77 07                	ja     80222b <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802224:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802227:	85 c0                	test   %eax,%eax
  802229:	78 2c                	js     802257 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80222b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222e:	83 ec 0c             	sub    $0xc,%esp
  802231:	68 00 00 00 a0       	push   $0xa0000000
  802236:	ff 75 e0             	pushl  -0x20(%ebp)
  802239:	ff 75 e4             	pushl  -0x1c(%ebp)
  80223c:	ff 75 e8             	pushl  -0x18(%ebp)
  80223f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802242:	50                   	push   %eax
  802243:	68 70 49 80 00       	push   $0x804970
  802248:	68 ad 00 00 00       	push   $0xad
  80224d:	68 c5 48 80 00       	push   $0x8048c5
  802252:	e8 0e 1b 00 00       	call   803d65 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80225a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80225d:	e9 88 00 00 00       	jmp    8022ea <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802262:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802269:	76 17                	jbe    802282 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  80226b:	ff 75 f0             	pushl  -0x10(%ebp)
  80226e:	68 d4 49 80 00       	push   $0x8049d4
  802273:	68 b4 00 00 00       	push   $0xb4
  802278:	68 c5 48 80 00       	push   $0x8048c5
  80227d:	e8 e3 1a 00 00       	call   803d65 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802285:	05 00 10 00 00       	add    $0x1000,%eax
  80228a:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	79 2e                	jns    8022c2 <free_pages+0x121>
  802294:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80229b:	77 25                	ja     8022c2 <free_pages+0x121>
  80229d:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8022a4:	77 1c                	ja     8022c2 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8022a6:	83 ec 08             	sub    $0x8,%esp
  8022a9:	68 00 10 00 00       	push   $0x1000
  8022ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8022b1:	e8 38 0d 00 00       	call   802fee <sys_free_user_mem>
  8022b6:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8022b9:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8022c0:	eb 28                	jmp    8022ea <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  8022c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c5:	68 00 00 00 a0       	push   $0xa0000000
  8022ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8022cd:	68 00 10 00 00       	push   $0x1000
  8022d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d5:	50                   	push   %eax
  8022d6:	68 14 4a 80 00       	push   $0x804a14
  8022db:	68 bd 00 00 00       	push   $0xbd
  8022e0:	68 c5 48 80 00       	push   $0x8048c5
  8022e5:	e8 7b 1a 00 00       	call   803d65 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8022f0:	0f 82 6c ff ff ff    	jb     802262 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  8022f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fa:	75 17                	jne    802313 <free_pages+0x172>
  8022fc:	83 ec 04             	sub    $0x4,%esp
  8022ff:	68 76 4a 80 00       	push   $0x804a76
  802304:	68 c1 00 00 00       	push   $0xc1
  802309:	68 c5 48 80 00       	push   $0x8048c5
  80230e:	e8 52 1a 00 00       	call   803d65 <_panic>
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 40 08             	mov    0x8(%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 11                	je     80232e <free_pages+0x18d>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 40 08             	mov    0x8(%eax),%eax
  802323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802326:	8b 52 0c             	mov    0xc(%edx),%edx
  802329:	89 50 0c             	mov    %edx,0xc(%eax)
  80232c:	eb 0b                	jmp    802339 <free_pages+0x198>
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 0c             	mov    0xc(%eax),%eax
  802334:	a3 28 60 80 00       	mov    %eax,0x806028
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 40 0c             	mov    0xc(%eax),%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 11                	je     802354 <free_pages+0x1b3>
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	8b 40 0c             	mov    0xc(%eax),%eax
  802349:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234c:	8b 52 08             	mov    0x8(%edx),%edx
  80234f:	89 50 08             	mov    %edx,0x8(%eax)
  802352:	eb 0b                	jmp    80235f <free_pages+0x1be>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 40 08             	mov    0x8(%eax),%eax
  80235a:	a3 24 60 80 00       	mov    %eax,0x806024
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802373:	a1 30 60 80 00       	mov    0x806030,%eax
  802378:	48                   	dec    %eax
  802379:	a3 30 60 80 00       	mov    %eax,0x806030
			free_block(it);
  80237e:	83 ec 0c             	sub    $0xc,%esp
  802381:	ff 75 f4             	pushl  -0xc(%ebp)
  802384:	e8 24 15 00 00       	call   8038ad <free_block>
  802389:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  80238c:	e8 72 fb ff ff       	call   801f03 <recompute_page_alloc_break>

			return;
  802391:	eb 37                	jmp    8023ca <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802393:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802398:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239f:	74 08                	je     8023a9 <free_pages+0x208>
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 40 08             	mov    0x8(%eax),%eax
  8023a7:	eb 05                	jmp    8023ae <free_pages+0x20d>
  8023a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ae:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8023b3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	0f 85 fa fd ff ff    	jne    8021ba <free_pages+0x19>
  8023c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c4:	0f 85 f0 fd ff ff    	jne    8021ba <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    

008023d6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8023dc:	a1 08 60 80 00       	mov    0x806008,%eax
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	74 60                	je     802445 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8023e5:	83 ec 08             	sub    $0x8,%esp
  8023e8:	68 00 00 00 82       	push   $0x82000000
  8023ed:	68 00 00 00 80       	push   $0x80000000
  8023f2:	e8 0d 0d 00 00       	call   803104 <initialize_dynamic_allocator>
  8023f7:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8023fa:	e8 f3 0a 00 00       	call   802ef2 <sys_get_uheap_strategy>
  8023ff:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802404:	a1 40 60 80 00       	mov    0x806040,%eax
  802409:	05 00 10 00 00       	add    $0x1000,%eax
  80240e:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  802413:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802418:	a3 68 e0 81 00       	mov    %eax,0x81e068

		LIST_INIT(&page_alloc_list);
  80241d:	c7 05 24 60 80 00 00 	movl   $0x0,0x806024
  802424:	00 00 00 
  802427:	c7 05 28 60 80 00 00 	movl   $0x0,0x806028
  80242e:	00 00 00 
  802431:	c7 05 30 60 80 00 00 	movl   $0x0,0x806030
  802438:	00 00 00 

		__firstTimeFlag = 0;
  80243b:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802442:	00 00 00 
	}
}
  802445:	90                   	nop
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
  80244b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80245c:	83 ec 08             	sub    $0x8,%esp
  80245f:	68 06 04 00 00       	push   $0x406
  802464:	50                   	push   %eax
  802465:	e8 d2 06 00 00       	call   802b3c <__sys_allocate_page>
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802470:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802474:	79 17                	jns    80248d <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 94 4a 80 00       	push   $0x804a94
  80247e:	68 ea 00 00 00       	push   $0xea
  802483:	68 c5 48 80 00       	push   $0x8048c5
  802488:	e8 d8 18 00 00       	call   803d65 <_panic>
	return 0;
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024a8:	83 ec 0c             	sub    $0xc,%esp
  8024ab:	50                   	push   %eax
  8024ac:	e8 d2 06 00 00       	call   802b83 <__sys_unmap_frame>
  8024b1:	83 c4 10             	add    $0x10,%esp
  8024b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8024b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024bb:	79 17                	jns    8024d4 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  8024bd:	83 ec 04             	sub    $0x4,%esp
  8024c0:	68 d0 4a 80 00       	push   $0x804ad0
  8024c5:	68 f5 00 00 00       	push   $0xf5
  8024ca:	68 c5 48 80 00       	push   $0x8048c5
  8024cf:	e8 91 18 00 00       	call   803d65 <_panic>
}
  8024d4:	90                   	nop
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024dd:	e8 f4 fe ff ff       	call   8023d6 <uheap_init>
	if (size == 0) return NULL ;
  8024e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e6:	75 0a                	jne    8024f2 <malloc+0x1b>
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ed:	e9 67 01 00 00       	jmp    802659 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8024f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8024f9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802500:	77 16                	ja     802518 <malloc+0x41>
		result = alloc_block(size);
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	ff 75 08             	pushl  0x8(%ebp)
  802508:	e8 46 0e 00 00       	call   803353 <alloc_block>
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802513:	e9 3e 01 00 00       	jmp    802656 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802518:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80251f:	8b 55 08             	mov    0x8(%ebp),%edx
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	01 d0                	add    %edx,%eax
  802527:	48                   	dec    %eax
  802528:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80252b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252e:	ba 00 00 00 00       	mov    $0x0,%edx
  802533:	f7 75 f0             	divl   -0x10(%ebp)
  802536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802539:	29 d0                	sub    %edx,%eax
  80253b:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  80253e:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	75 0a                	jne    802551 <malloc+0x7a>
			return NULL;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	e9 08 01 00 00       	jmp    802659 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802551:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	74 0f                	je     802569 <malloc+0x92>
  80255a:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802560:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802565:	39 c2                	cmp    %eax,%edx
  802567:	73 0a                	jae    802573 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802569:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80256e:	a3 68 e0 81 00       	mov    %eax,0x81e068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802573:	a1 60 e0 81 00       	mov    0x81e060,%eax
  802578:	83 f8 05             	cmp    $0x5,%eax
  80257b:	75 11                	jne    80258e <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	ff 75 e8             	pushl  -0x18(%ebp)
  802583:	e8 ff f9 ff ff       	call   801f87 <alloc_pages_custom_fit>
  802588:	83 c4 10             	add    $0x10,%esp
  80258b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  80258e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802592:	0f 84 be 00 00 00    	je     802656 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80259e:	83 ec 0c             	sub    $0xc,%esp
  8025a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a4:	e8 9a fb ff ff       	call   802143 <find_allocated_size>
  8025a9:	83 c4 10             	add    $0x10,%esp
  8025ac:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8025af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025b3:	75 17                	jne    8025cc <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8025b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b8:	68 10 4b 80 00       	push   $0x804b10
  8025bd:	68 24 01 00 00       	push   $0x124
  8025c2:	68 c5 48 80 00       	push   $0x8048c5
  8025c7:	e8 99 17 00 00       	call   803d65 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8025cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cf:	f7 d0                	not    %eax
  8025d1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025d4:	73 1d                	jae    8025f3 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8025d6:	83 ec 0c             	sub    $0xc,%esp
  8025d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8025dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025df:	68 58 4b 80 00       	push   $0x804b58
  8025e4:	68 29 01 00 00       	push   $0x129
  8025e9:	68 c5 48 80 00       	push   $0x8048c5
  8025ee:	e8 72 17 00 00       	call   803d65 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8025f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f9:	01 d0                	add    %edx,%eax
  8025fb:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	79 2c                	jns    802631 <malloc+0x15a>
  802605:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  80260c:	77 23                	ja     802631 <malloc+0x15a>
  80260e:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802615:	77 1a                	ja     802631 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802617:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	79 13                	jns    802631 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80261e:	83 ec 08             	sub    $0x8,%esp
  802621:	ff 75 e0             	pushl  -0x20(%ebp)
  802624:	ff 75 e4             	pushl  -0x1c(%ebp)
  802627:	e8 de 09 00 00       	call   80300a <sys_allocate_user_mem>
  80262c:	83 c4 10             	add    $0x10,%esp
  80262f:	eb 25                	jmp    802656 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802631:	68 00 00 00 a0       	push   $0xa0000000
  802636:	ff 75 dc             	pushl  -0x24(%ebp)
  802639:	ff 75 e0             	pushl  -0x20(%ebp)
  80263c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80263f:	ff 75 f4             	pushl  -0xc(%ebp)
  802642:	68 94 4b 80 00       	push   $0x804b94
  802647:	68 33 01 00 00       	push   $0x133
  80264c:	68 c5 48 80 00       	push   $0x8048c5
  802651:	e8 0f 17 00 00       	call   803d65 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802665:	0f 84 26 01 00 00    	je     802791 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	79 1c                	jns    802694 <free+0x39>
  802678:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80267f:	77 13                	ja     802694 <free+0x39>
		free_block(virtual_address);
  802681:	83 ec 0c             	sub    $0xc,%esp
  802684:	ff 75 08             	pushl  0x8(%ebp)
  802687:	e8 21 12 00 00       	call   8038ad <free_block>
  80268c:	83 c4 10             	add    $0x10,%esp
		return;
  80268f:	e9 01 01 00 00       	jmp    802795 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802694:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802699:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80269c:	0f 82 d8 00 00 00    	jb     80277a <free+0x11f>
  8026a2:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8026a9:	0f 87 cb 00 00 00    	ja     80277a <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	74 17                	je     8026d2 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8026bb:	ff 75 08             	pushl  0x8(%ebp)
  8026be:	68 04 4c 80 00       	push   $0x804c04
  8026c3:	68 57 01 00 00       	push   $0x157
  8026c8:	68 c5 48 80 00       	push   $0x8048c5
  8026cd:	e8 93 16 00 00       	call   803d65 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8026d2:	83 ec 0c             	sub    $0xc,%esp
  8026d5:	ff 75 08             	pushl  0x8(%ebp)
  8026d8:	e8 66 fa ff ff       	call   802143 <find_allocated_size>
  8026dd:	83 c4 10             	add    $0x10,%esp
  8026e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8026e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e7:	0f 84 a7 00 00 00    	je     802794 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8026ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f0:	f7 d0                	not    %eax
  8026f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026f5:	73 1d                	jae    802714 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8026f7:	83 ec 0c             	sub    $0xc,%esp
  8026fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8026fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802700:	68 2c 4c 80 00       	push   $0x804c2c
  802705:	68 61 01 00 00       	push   $0x161
  80270a:	68 c5 48 80 00       	push   $0x8048c5
  80270f:	e8 51 16 00 00       	call   803d65 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271a:	01 d0                	add    %edx,%eax
  80271c:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	79 19                	jns    80273f <free+0xe4>
  802726:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  80272d:	77 10                	ja     80273f <free+0xe4>
  80272f:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802736:	77 07                	ja     80273f <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	78 2b                	js     80276a <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  80273f:	83 ec 0c             	sub    $0xc,%esp
  802742:	68 00 00 00 a0       	push   $0xa0000000
  802747:	ff 75 ec             	pushl  -0x14(%ebp)
  80274a:	ff 75 f0             	pushl  -0x10(%ebp)
  80274d:	ff 75 f4             	pushl  -0xc(%ebp)
  802750:	ff 75 f0             	pushl  -0x10(%ebp)
  802753:	ff 75 08             	pushl  0x8(%ebp)
  802756:	68 68 4c 80 00       	push   $0x804c68
  80275b:	68 69 01 00 00       	push   $0x169
  802760:	68 c5 48 80 00       	push   $0x8048c5
  802765:	e8 fb 15 00 00       	call   803d65 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80276a:	83 ec 0c             	sub    $0xc,%esp
  80276d:	ff 75 08             	pushl  0x8(%ebp)
  802770:	e8 2c fa ff ff       	call   8021a1 <free_pages>
  802775:	83 c4 10             	add    $0x10,%esp
		return;
  802778:	eb 1b                	jmp    802795 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80277a:	ff 75 08             	pushl  0x8(%ebp)
  80277d:	68 c4 4c 80 00       	push   $0x804cc4
  802782:	68 70 01 00 00       	push   $0x170
  802787:	68 c5 48 80 00       	push   $0x8048c5
  80278c:	e8 d4 15 00 00       	call   803d65 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802791:	90                   	nop
  802792:	eb 01                	jmp    802795 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802794:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
  80279a:	83 ec 38             	sub    $0x38,%esp
  80279d:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a0:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027a3:	e8 2e fc ff ff       	call   8023d6 <uheap_init>
	if (size == 0) return NULL ;
  8027a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027ac:	75 0a                	jne    8027b8 <smalloc+0x21>
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	e9 3d 01 00 00       	jmp    8028f5 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8027b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8027be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c1:	25 ff 0f 00 00       	and    $0xfff,%eax
  8027c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8027c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027cd:	74 0e                	je     8027dd <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8027d5:	05 00 10 00 00       	add    $0x1000,%eax
  8027da:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	c1 e8 0c             	shr    $0xc,%eax
  8027e3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8027e6:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	75 0a                	jne    8027f9 <smalloc+0x62>
		return NULL;
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f4:	e9 fc 00 00 00       	jmp    8028f5 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8027f9:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 0f                	je     802811 <smalloc+0x7a>
  802802:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802808:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80280d:	39 c2                	cmp    %eax,%edx
  80280f:	73 0a                	jae    80281b <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802811:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802816:	a3 68 e0 81 00       	mov    %eax,0x81e068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80281b:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802820:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802825:	29 c2                	sub    %eax,%edx
  802827:	89 d0                	mov    %edx,%eax
  802829:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80282c:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802832:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802837:	29 c2                	sub    %eax,%edx
  802839:	89 d0                	mov    %edx,%eax
  80283b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802844:	77 13                	ja     802859 <smalloc+0xc2>
  802846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802849:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80284c:	77 0b                	ja     802859 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80284e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802851:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802854:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802857:	73 0a                	jae    802863 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802859:	b8 00 00 00 00       	mov    $0x0,%eax
  80285e:	e9 92 00 00 00       	jmp    8028f5 <smalloc+0x15e>
	}

	void *va = NULL;
  802863:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80286a:	a1 60 e0 81 00       	mov    0x81e060,%eax
  80286f:	83 f8 05             	cmp    $0x5,%eax
  802872:	75 11                	jne    802885 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802874:	83 ec 0c             	sub    $0xc,%esp
  802877:	ff 75 f4             	pushl  -0xc(%ebp)
  80287a:	e8 08 f7 ff ff       	call   801f87 <alloc_pages_custom_fit>
  80287f:	83 c4 10             	add    $0x10,%esp
  802882:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802885:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802889:	75 27                	jne    8028b2 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80288b:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802892:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802895:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802898:	89 c2                	mov    %eax,%edx
  80289a:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80289f:	39 c2                	cmp    %eax,%edx
  8028a1:	73 07                	jae    8028aa <smalloc+0x113>
			return NULL;}
  8028a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a8:	eb 4b                	jmp    8028f5 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8028aa:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8028af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8028b2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8028b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8028b9:	50                   	push   %eax
  8028ba:	ff 75 0c             	pushl  0xc(%ebp)
  8028bd:	ff 75 08             	pushl  0x8(%ebp)
  8028c0:	e8 cb 03 00 00       	call   802c90 <sys_create_shared_object>
  8028c5:	83 c4 10             	add    $0x10,%esp
  8028c8:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8028cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8028cf:	79 07                	jns    8028d8 <smalloc+0x141>
		return NULL;
  8028d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d6:	eb 1d                	jmp    8028f5 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8028d8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8028dd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8028e0:	75 10                	jne    8028f2 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8028e2:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	01 d0                	add    %edx,%eax
  8028ed:	a3 68 e0 81 00       	mov    %eax,0x81e068
	}

	return va;
  8028f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028fd:	e8 d4 fa ff ff       	call   8023d6 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802902:	83 ec 08             	sub    $0x8,%esp
  802905:	ff 75 0c             	pushl  0xc(%ebp)
  802908:	ff 75 08             	pushl  0x8(%ebp)
  80290b:	e8 aa 03 00 00       	call   802cba <sys_size_of_shared_object>
  802910:	83 c4 10             	add    $0x10,%esp
  802913:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802916:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80291a:	7f 0a                	jg     802926 <sget+0x2f>
		return NULL;
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
  802921:	e9 32 01 00 00       	jmp    802a58 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802929:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802934:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802937:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293b:	74 0e                	je     80294b <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802943:	05 00 10 00 00       	add    $0x1000,%eax
  802948:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80294b:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	75 0a                	jne    80295e <sget+0x67>
		return NULL;
  802954:	b8 00 00 00 00       	mov    $0x0,%eax
  802959:	e9 fa 00 00 00       	jmp    802a58 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80295e:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	74 0f                	je     802976 <sget+0x7f>
  802967:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80296d:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802972:	39 c2                	cmp    %eax,%edx
  802974:	73 0a                	jae    802980 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802976:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80297b:	a3 68 e0 81 00       	mov    %eax,0x81e068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802980:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802985:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80298a:	29 c2                	sub    %eax,%edx
  80298c:	89 d0                	mov    %edx,%eax
  80298e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802991:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802997:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80299c:	29 c2                	sub    %eax,%edx
  80299e:	89 d0                	mov    %edx,%eax
  8029a0:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029a9:	77 13                	ja     8029be <sget+0xc7>
  8029ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ae:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029b1:	77 0b                	ja     8029be <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8029b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b6:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8029b9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8029bc:	73 0a                	jae    8029c8 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c3:	e9 90 00 00 00       	jmp    802a58 <sget+0x161>

	void *va = NULL;
  8029c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8029cf:	a1 60 e0 81 00       	mov    0x81e060,%eax
  8029d4:	83 f8 05             	cmp    $0x5,%eax
  8029d7:	75 11                	jne    8029ea <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8029df:	e8 a3 f5 ff ff       	call   801f87 <alloc_pages_custom_fit>
  8029e4:	83 c4 10             	add    $0x10,%esp
  8029e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8029ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ee:	75 27                	jne    802a17 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8029f0:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8029f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029fa:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029fd:	89 c2                	mov    %eax,%edx
  8029ff:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a04:	39 c2                	cmp    %eax,%edx
  802a06:	73 07                	jae    802a0f <sget+0x118>
			return NULL;
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0d:	eb 49                	jmp    802a58 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802a0f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	ff 75 f0             	pushl  -0x10(%ebp)
  802a1d:	ff 75 0c             	pushl  0xc(%ebp)
  802a20:	ff 75 08             	pushl  0x8(%ebp)
  802a23:	e8 af 02 00 00       	call   802cd7 <sys_get_shared_object>
  802a28:	83 c4 10             	add    $0x10,%esp
  802a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802a2e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a32:	79 07                	jns    802a3b <sget+0x144>
		return NULL;
  802a34:	b8 00 00 00 00       	mov    $0x0,%eax
  802a39:	eb 1d                	jmp    802a58 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802a3b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802a40:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802a43:	75 10                	jne    802a55 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802a45:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	01 d0                	add    %edx,%eax
  802a50:	a3 68 e0 81 00       	mov    %eax,0x81e068

	return va;
  802a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802a58:	c9                   	leave  
  802a59:	c3                   	ret    

00802a5a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
  802a5d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a60:	e8 71 f9 ff ff       	call   8023d6 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 e8 4c 80 00       	push   $0x804ce8
  802a6d:	68 19 02 00 00       	push   $0x219
  802a72:	68 c5 48 80 00       	push   $0x8048c5
  802a77:	e8 e9 12 00 00       	call   803d65 <_panic>

00802a7c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802a82:	83 ec 04             	sub    $0x4,%esp
  802a85:	68 10 4d 80 00       	push   $0x804d10
  802a8a:	68 2b 02 00 00       	push   $0x22b
  802a8f:	68 c5 48 80 00       	push   $0x8048c5
  802a94:	e8 cc 12 00 00       	call   803d65 <_panic>

00802a99 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
  802a9c:	57                   	push   %edi
  802a9d:	56                   	push   %esi
  802a9e:	53                   	push   %ebx
  802a9f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802aab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802aae:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ab1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ab4:	cd 30                	int    $0x30
  802ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802abc:	83 c4 10             	add    $0x10,%esp
  802abf:	5b                   	pop    %ebx
  802ac0:	5e                   	pop    %esi
  802ac1:	5f                   	pop    %edi
  802ac2:	5d                   	pop    %ebp
  802ac3:	c3                   	ret    

00802ac4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	8b 45 10             	mov    0x10(%ebp),%eax
  802acd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ad0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ad3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	6a 00                	push   $0x0
  802adc:	51                   	push   %ecx
  802add:	52                   	push   %edx
  802ade:	ff 75 0c             	pushl  0xc(%ebp)
  802ae1:	50                   	push   %eax
  802ae2:	6a 00                	push   $0x0
  802ae4:	e8 b0 ff ff ff       	call   802a99 <syscall>
  802ae9:	83 c4 18             	add    $0x18,%esp
}
  802aec:	90                   	nop
  802aed:	c9                   	leave  
  802aee:	c3                   	ret    

00802aef <sys_cgetc>:

int
sys_cgetc(void)
{
  802aef:	55                   	push   %ebp
  802af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	6a 02                	push   $0x2
  802afe:	e8 96 ff ff ff       	call   802a99 <syscall>
  802b03:	83 c4 18             	add    $0x18,%esp
}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802b0b:	6a 00                	push   $0x0
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 03                	push   $0x3
  802b17:	e8 7d ff ff ff       	call   802a99 <syscall>
  802b1c:	83 c4 18             	add    $0x18,%esp
}
  802b1f:	90                   	nop
  802b20:	c9                   	leave  
  802b21:	c3                   	ret    

00802b22 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 04                	push   $0x4
  802b31:	e8 63 ff ff ff       	call   802a99 <syscall>
  802b36:	83 c4 18             	add    $0x18,%esp
}
  802b39:	90                   	nop
  802b3a:	c9                   	leave  
  802b3b:	c3                   	ret    

00802b3c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	52                   	push   %edx
  802b4c:	50                   	push   %eax
  802b4d:	6a 08                	push   $0x8
  802b4f:	e8 45 ff ff ff       	call   802a99 <syscall>
  802b54:	83 c4 18             	add    $0x18,%esp
}
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
  802b5c:	56                   	push   %esi
  802b5d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802b5e:	8b 75 18             	mov    0x18(%ebp),%esi
  802b61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	56                   	push   %esi
  802b6e:	53                   	push   %ebx
  802b6f:	51                   	push   %ecx
  802b70:	52                   	push   %edx
  802b71:	50                   	push   %eax
  802b72:	6a 09                	push   $0x9
  802b74:	e8 20 ff ff ff       	call   802a99 <syscall>
  802b79:	83 c4 18             	add    $0x18,%esp
}
  802b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b7f:	5b                   	pop    %ebx
  802b80:	5e                   	pop    %esi
  802b81:	5d                   	pop    %ebp
  802b82:	c3                   	ret    

00802b83 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802b86:	6a 00                	push   $0x0
  802b88:	6a 00                	push   $0x0
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	ff 75 08             	pushl  0x8(%ebp)
  802b91:	6a 0a                	push   $0xa
  802b93:	e8 01 ff ff ff       	call   802a99 <syscall>
  802b98:	83 c4 18             	add    $0x18,%esp
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	ff 75 0c             	pushl  0xc(%ebp)
  802ba9:	ff 75 08             	pushl  0x8(%ebp)
  802bac:	6a 0b                	push   $0xb
  802bae:	e8 e6 fe ff ff       	call   802a99 <syscall>
  802bb3:	83 c4 18             	add    $0x18,%esp
}
  802bb6:	c9                   	leave  
  802bb7:	c3                   	ret    

00802bb8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802bbb:	6a 00                	push   $0x0
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 0c                	push   $0xc
  802bc7:	e8 cd fe ff ff       	call   802a99 <syscall>
  802bcc:	83 c4 18             	add    $0x18,%esp
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 0d                	push   $0xd
  802be0:	e8 b4 fe ff ff       	call   802a99 <syscall>
  802be5:	83 c4 18             	add    $0x18,%esp
}
  802be8:	c9                   	leave  
  802be9:	c3                   	ret    

00802bea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802bea:	55                   	push   %ebp
  802beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 0e                	push   $0xe
  802bf9:	e8 9b fe ff ff       	call   802a99 <syscall>
  802bfe:	83 c4 18             	add    $0x18,%esp
}
  802c01:	c9                   	leave  
  802c02:	c3                   	ret    

00802c03 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c03:	55                   	push   %ebp
  802c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c06:	6a 00                	push   $0x0
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 0f                	push   $0xf
  802c12:	e8 82 fe ff ff       	call   802a99 <syscall>
  802c17:	83 c4 18             	add    $0x18,%esp
}
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 00                	push   $0x0
  802c27:	ff 75 08             	pushl  0x8(%ebp)
  802c2a:	6a 10                	push   $0x10
  802c2c:	e8 68 fe ff ff       	call   802a99 <syscall>
  802c31:	83 c4 18             	add    $0x18,%esp
}
  802c34:	c9                   	leave  
  802c35:	c3                   	ret    

00802c36 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	6a 00                	push   $0x0
  802c43:	6a 11                	push   $0x11
  802c45:	e8 4f fe ff ff       	call   802a99 <syscall>
  802c4a:	83 c4 18             	add    $0x18,%esp
}
  802c4d:	90                   	nop
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <sys_cputc>:

void
sys_cputc(const char c)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
  802c53:	83 ec 04             	sub    $0x4,%esp
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802c5c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	50                   	push   %eax
  802c69:	6a 01                	push   $0x1
  802c6b:	e8 29 fe ff ff       	call   802a99 <syscall>
  802c70:	83 c4 18             	add    $0x18,%esp
}
  802c73:	90                   	nop
  802c74:	c9                   	leave  
  802c75:	c3                   	ret    

00802c76 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 00                	push   $0x0
  802c7f:	6a 00                	push   $0x0
  802c81:	6a 00                	push   $0x0
  802c83:	6a 14                	push   $0x14
  802c85:	e8 0f fe ff ff       	call   802a99 <syscall>
  802c8a:	83 c4 18             	add    $0x18,%esp
}
  802c8d:	90                   	nop
  802c8e:	c9                   	leave  
  802c8f:	c3                   	ret    

00802c90 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
  802c93:	83 ec 04             	sub    $0x4,%esp
  802c96:	8b 45 10             	mov    0x10(%ebp),%eax
  802c99:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c9c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c9f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	6a 00                	push   $0x0
  802ca8:	51                   	push   %ecx
  802ca9:	52                   	push   %edx
  802caa:	ff 75 0c             	pushl  0xc(%ebp)
  802cad:	50                   	push   %eax
  802cae:	6a 15                	push   $0x15
  802cb0:	e8 e4 fd ff ff       	call   802a99 <syscall>
  802cb5:	83 c4 18             	add    $0x18,%esp
}
  802cb8:	c9                   	leave  
  802cb9:	c3                   	ret    

00802cba <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802cba:	55                   	push   %ebp
  802cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802cbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	6a 00                	push   $0x0
  802cc5:	6a 00                	push   $0x0
  802cc7:	6a 00                	push   $0x0
  802cc9:	52                   	push   %edx
  802cca:	50                   	push   %eax
  802ccb:	6a 16                	push   $0x16
  802ccd:	e8 c7 fd ff ff       	call   802a99 <syscall>
  802cd2:	83 c4 18             	add    $0x18,%esp
}
  802cd5:	c9                   	leave  
  802cd6:	c3                   	ret    

00802cd7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	6a 00                	push   $0x0
  802ce5:	6a 00                	push   $0x0
  802ce7:	51                   	push   %ecx
  802ce8:	52                   	push   %edx
  802ce9:	50                   	push   %eax
  802cea:	6a 17                	push   $0x17
  802cec:	e8 a8 fd ff ff       	call   802a99 <syscall>
  802cf1:	83 c4 18             	add    $0x18,%esp
}
  802cf4:	c9                   	leave  
  802cf5:	c3                   	ret    

00802cf6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802cf6:	55                   	push   %ebp
  802cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	6a 00                	push   $0x0
  802d01:	6a 00                	push   $0x0
  802d03:	6a 00                	push   $0x0
  802d05:	52                   	push   %edx
  802d06:	50                   	push   %eax
  802d07:	6a 18                	push   $0x18
  802d09:	e8 8b fd ff ff       	call   802a99 <syscall>
  802d0e:	83 c4 18             	add    $0x18,%esp
}
  802d11:	c9                   	leave  
  802d12:	c3                   	ret    

00802d13 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d13:	55                   	push   %ebp
  802d14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	6a 00                	push   $0x0
  802d1b:	ff 75 14             	pushl  0x14(%ebp)
  802d1e:	ff 75 10             	pushl  0x10(%ebp)
  802d21:	ff 75 0c             	pushl  0xc(%ebp)
  802d24:	50                   	push   %eax
  802d25:	6a 19                	push   $0x19
  802d27:	e8 6d fd ff ff       	call   802a99 <syscall>
  802d2c:	83 c4 18             	add    $0x18,%esp
}
  802d2f:	c9                   	leave  
  802d30:	c3                   	ret    

00802d31 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802d31:	55                   	push   %ebp
  802d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	50                   	push   %eax
  802d40:	6a 1a                	push   $0x1a
  802d42:	e8 52 fd ff ff       	call   802a99 <syscall>
  802d47:	83 c4 18             	add    $0x18,%esp
}
  802d4a:	90                   	nop
  802d4b:	c9                   	leave  
  802d4c:	c3                   	ret    

00802d4d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	50                   	push   %eax
  802d5c:	6a 1b                	push   $0x1b
  802d5e:	e8 36 fd ff ff       	call   802a99 <syscall>
  802d63:	83 c4 18             	add    $0x18,%esp
}
  802d66:	c9                   	leave  
  802d67:	c3                   	ret    

00802d68 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d68:	55                   	push   %ebp
  802d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	6a 00                	push   $0x0
  802d73:	6a 00                	push   $0x0
  802d75:	6a 05                	push   $0x5
  802d77:	e8 1d fd ff ff       	call   802a99 <syscall>
  802d7c:	83 c4 18             	add    $0x18,%esp
}
  802d7f:	c9                   	leave  
  802d80:	c3                   	ret    

00802d81 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d81:	55                   	push   %ebp
  802d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 00                	push   $0x0
  802d8e:	6a 06                	push   $0x6
  802d90:	e8 04 fd ff ff       	call   802a99 <syscall>
  802d95:	83 c4 18             	add    $0x18,%esp
}
  802d98:	c9                   	leave  
  802d99:	c3                   	ret    

00802d9a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d9a:	55                   	push   %ebp
  802d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	6a 00                	push   $0x0
  802da5:	6a 00                	push   $0x0
  802da7:	6a 07                	push   $0x7
  802da9:	e8 eb fc ff ff       	call   802a99 <syscall>
  802dae:	83 c4 18             	add    $0x18,%esp
}
  802db1:	c9                   	leave  
  802db2:	c3                   	ret    

00802db3 <sys_exit_env>:


void sys_exit_env(void)
{
  802db3:	55                   	push   %ebp
  802db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 1c                	push   $0x1c
  802dc2:	e8 d2 fc ff ff       	call   802a99 <syscall>
  802dc7:	83 c4 18             	add    $0x18,%esp
}
  802dca:	90                   	nop
  802dcb:	c9                   	leave  
  802dcc:	c3                   	ret    

00802dcd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802dcd:	55                   	push   %ebp
  802dce:	89 e5                	mov    %esp,%ebp
  802dd0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802dd3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dd6:	8d 50 04             	lea    0x4(%eax),%edx
  802dd9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ddc:	6a 00                	push   $0x0
  802dde:	6a 00                	push   $0x0
  802de0:	6a 00                	push   $0x0
  802de2:	52                   	push   %edx
  802de3:	50                   	push   %eax
  802de4:	6a 1d                	push   $0x1d
  802de6:	e8 ae fc ff ff       	call   802a99 <syscall>
  802deb:	83 c4 18             	add    $0x18,%esp
	return result;
  802dee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802df1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802df4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802df7:	89 01                	mov    %eax,(%ecx)
  802df9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	c9                   	leave  
  802e00:	c2 04 00             	ret    $0x4

00802e03 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e03:	55                   	push   %ebp
  802e04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	ff 75 10             	pushl  0x10(%ebp)
  802e0d:	ff 75 0c             	pushl  0xc(%ebp)
  802e10:	ff 75 08             	pushl  0x8(%ebp)
  802e13:	6a 13                	push   $0x13
  802e15:	e8 7f fc ff ff       	call   802a99 <syscall>
  802e1a:	83 c4 18             	add    $0x18,%esp
	return ;
  802e1d:	90                   	nop
}
  802e1e:	c9                   	leave  
  802e1f:	c3                   	ret    

00802e20 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 1e                	push   $0x1e
  802e2f:	e8 65 fc ff ff       	call   802a99 <syscall>
  802e34:	83 c4 18             	add    $0x18,%esp
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
  802e3c:	83 ec 04             	sub    $0x4,%esp
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e45:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 00                	push   $0x0
  802e4f:	6a 00                	push   $0x0
  802e51:	50                   	push   %eax
  802e52:	6a 1f                	push   $0x1f
  802e54:	e8 40 fc ff ff       	call   802a99 <syscall>
  802e59:	83 c4 18             	add    $0x18,%esp
	return ;
  802e5c:	90                   	nop
}
  802e5d:	c9                   	leave  
  802e5e:	c3                   	ret    

00802e5f <rsttst>:
void rsttst()
{
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e62:	6a 00                	push   $0x0
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	6a 00                	push   $0x0
  802e6a:	6a 00                	push   $0x0
  802e6c:	6a 21                	push   $0x21
  802e6e:	e8 26 fc ff ff       	call   802a99 <syscall>
  802e73:	83 c4 18             	add    $0x18,%esp
	return ;
  802e76:	90                   	nop
}
  802e77:	c9                   	leave  
  802e78:	c3                   	ret    

00802e79 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e79:	55                   	push   %ebp
  802e7a:	89 e5                	mov    %esp,%ebp
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	8b 45 14             	mov    0x14(%ebp),%eax
  802e82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e85:	8b 55 18             	mov    0x18(%ebp),%edx
  802e88:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e8c:	52                   	push   %edx
  802e8d:	50                   	push   %eax
  802e8e:	ff 75 10             	pushl  0x10(%ebp)
  802e91:	ff 75 0c             	pushl  0xc(%ebp)
  802e94:	ff 75 08             	pushl  0x8(%ebp)
  802e97:	6a 20                	push   $0x20
  802e99:	e8 fb fb ff ff       	call   802a99 <syscall>
  802e9e:	83 c4 18             	add    $0x18,%esp
	return ;
  802ea1:	90                   	nop
}
  802ea2:	c9                   	leave  
  802ea3:	c3                   	ret    

00802ea4 <chktst>:
void chktst(uint32 n)
{
  802ea4:	55                   	push   %ebp
  802ea5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802ea7:	6a 00                	push   $0x0
  802ea9:	6a 00                	push   $0x0
  802eab:	6a 00                	push   $0x0
  802ead:	6a 00                	push   $0x0
  802eaf:	ff 75 08             	pushl  0x8(%ebp)
  802eb2:	6a 22                	push   $0x22
  802eb4:	e8 e0 fb ff ff       	call   802a99 <syscall>
  802eb9:	83 c4 18             	add    $0x18,%esp
	return ;
  802ebc:	90                   	nop
}
  802ebd:	c9                   	leave  
  802ebe:	c3                   	ret    

00802ebf <inctst>:

void inctst()
{
  802ebf:	55                   	push   %ebp
  802ec0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ec2:	6a 00                	push   $0x0
  802ec4:	6a 00                	push   $0x0
  802ec6:	6a 00                	push   $0x0
  802ec8:	6a 00                	push   $0x0
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 23                	push   $0x23
  802ece:	e8 c6 fb ff ff       	call   802a99 <syscall>
  802ed3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed6:	90                   	nop
}
  802ed7:	c9                   	leave  
  802ed8:	c3                   	ret    

00802ed9 <gettst>:
uint32 gettst()
{
  802ed9:	55                   	push   %ebp
  802eda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 24                	push   $0x24
  802ee8:	e8 ac fb ff ff       	call   802a99 <syscall>
  802eed:	83 c4 18             	add    $0x18,%esp
}
  802ef0:	c9                   	leave  
  802ef1:	c3                   	ret    

00802ef2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802ef2:	55                   	push   %ebp
  802ef3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	6a 25                	push   $0x25
  802f01:	e8 93 fb ff ff       	call   802a99 <syscall>
  802f06:	83 c4 18             	add    $0x18,%esp
  802f09:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  802f0e:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  802f13:	c9                   	leave  
  802f14:	c3                   	ret    

00802f15 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f15:	55                   	push   %ebp
  802f16:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	6a 00                	push   $0x0
  802f28:	ff 75 08             	pushl  0x8(%ebp)
  802f2b:	6a 26                	push   $0x26
  802f2d:	e8 67 fb ff ff       	call   802a99 <syscall>
  802f32:	83 c4 18             	add    $0x18,%esp
	return ;
  802f35:	90                   	nop
}
  802f36:	c9                   	leave  
  802f37:	c3                   	ret    

00802f38 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802f38:	55                   	push   %ebp
  802f39:	89 e5                	mov    %esp,%ebp
  802f3b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802f3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	6a 00                	push   $0x0
  802f4a:	53                   	push   %ebx
  802f4b:	51                   	push   %ecx
  802f4c:	52                   	push   %edx
  802f4d:	50                   	push   %eax
  802f4e:	6a 27                	push   $0x27
  802f50:	e8 44 fb ff ff       	call   802a99 <syscall>
  802f55:	83 c4 18             	add    $0x18,%esp
}
  802f58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f5b:	c9                   	leave  
  802f5c:	c3                   	ret    

00802f5d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802f5d:	55                   	push   %ebp
  802f5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	6a 00                	push   $0x0
  802f68:	6a 00                	push   $0x0
  802f6a:	6a 00                	push   $0x0
  802f6c:	52                   	push   %edx
  802f6d:	50                   	push   %eax
  802f6e:	6a 28                	push   $0x28
  802f70:	e8 24 fb ff ff       	call   802a99 <syscall>
  802f75:	83 c4 18             	add    $0x18,%esp
}
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802f7d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	6a 00                	push   $0x0
  802f88:	51                   	push   %ecx
  802f89:	ff 75 10             	pushl  0x10(%ebp)
  802f8c:	52                   	push   %edx
  802f8d:	50                   	push   %eax
  802f8e:	6a 29                	push   $0x29
  802f90:	e8 04 fb ff ff       	call   802a99 <syscall>
  802f95:	83 c4 18             	add    $0x18,%esp
}
  802f98:	c9                   	leave  
  802f99:	c3                   	ret    

00802f9a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802f9a:	55                   	push   %ebp
  802f9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	ff 75 10             	pushl  0x10(%ebp)
  802fa4:	ff 75 0c             	pushl  0xc(%ebp)
  802fa7:	ff 75 08             	pushl  0x8(%ebp)
  802faa:	6a 12                	push   $0x12
  802fac:	e8 e8 fa ff ff       	call   802a99 <syscall>
  802fb1:	83 c4 18             	add    $0x18,%esp
	return ;
  802fb4:	90                   	nop
}
  802fb5:	c9                   	leave  
  802fb6:	c3                   	ret    

00802fb7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802fb7:	55                   	push   %ebp
  802fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	52                   	push   %edx
  802fc7:	50                   	push   %eax
  802fc8:	6a 2a                	push   $0x2a
  802fca:	e8 ca fa ff ff       	call   802a99 <syscall>
  802fcf:	83 c4 18             	add    $0x18,%esp
	return;
  802fd2:	90                   	nop
}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 2b                	push   $0x2b
  802fe4:	e8 b0 fa ff ff       	call   802a99 <syscall>
  802fe9:	83 c4 18             	add    $0x18,%esp
}
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	ff 75 0c             	pushl  0xc(%ebp)
  802ffa:	ff 75 08             	pushl  0x8(%ebp)
  802ffd:	6a 2d                	push   $0x2d
  802fff:	e8 95 fa ff ff       	call   802a99 <syscall>
  803004:	83 c4 18             	add    $0x18,%esp
	return;
  803007:	90                   	nop
}
  803008:	c9                   	leave  
  803009:	c3                   	ret    

0080300a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80300a:	55                   	push   %ebp
  80300b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80300d:	6a 00                	push   $0x0
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	ff 75 0c             	pushl  0xc(%ebp)
  803016:	ff 75 08             	pushl  0x8(%ebp)
  803019:	6a 2c                	push   $0x2c
  80301b:	e8 79 fa ff ff       	call   802a99 <syscall>
  803020:	83 c4 18             	add    $0x18,%esp
	return ;
  803023:	90                   	nop
}
  803024:	c9                   	leave  
  803025:	c3                   	ret    

00803026 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803026:	55                   	push   %ebp
  803027:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	6a 00                	push   $0x0
  803031:	6a 00                	push   $0x0
  803033:	6a 00                	push   $0x0
  803035:	52                   	push   %edx
  803036:	50                   	push   %eax
  803037:	6a 2e                	push   $0x2e
  803039:	e8 5b fa ff ff       	call   802a99 <syscall>
  80303e:	83 c4 18             	add    $0x18,%esp
	return ;
  803041:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803042:	c9                   	leave  
  803043:	c3                   	ret    

00803044 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803044:	55                   	push   %ebp
  803045:	89 e5                	mov    %esp,%ebp
  803047:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80304a:	81 7d 08 60 60 80 00 	cmpl   $0x806060,0x8(%ebp)
  803051:	72 09                	jb     80305c <to_page_va+0x18>
  803053:	81 7d 08 60 e0 81 00 	cmpl   $0x81e060,0x8(%ebp)
  80305a:	72 14                	jb     803070 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	68 34 4d 80 00       	push   $0x804d34
  803064:	6a 15                	push   $0x15
  803066:	68 5f 4d 80 00       	push   $0x804d5f
  80306b:	e8 f5 0c 00 00       	call   803d65 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	ba 60 60 80 00       	mov    $0x806060,%edx
  803078:	29 d0                	sub    %edx,%eax
  80307a:	c1 f8 02             	sar    $0x2,%eax
  80307d:	89 c2                	mov    %eax,%edx
  80307f:	89 d0                	mov    %edx,%eax
  803081:	c1 e0 02             	shl    $0x2,%eax
  803084:	01 d0                	add    %edx,%eax
  803086:	c1 e0 02             	shl    $0x2,%eax
  803089:	01 d0                	add    %edx,%eax
  80308b:	c1 e0 02             	shl    $0x2,%eax
  80308e:	01 d0                	add    %edx,%eax
  803090:	89 c1                	mov    %eax,%ecx
  803092:	c1 e1 08             	shl    $0x8,%ecx
  803095:	01 c8                	add    %ecx,%eax
  803097:	89 c1                	mov    %eax,%ecx
  803099:	c1 e1 10             	shl    $0x10,%ecx
  80309c:	01 c8                	add    %ecx,%eax
  80309e:	01 c0                	add    %eax,%eax
  8030a0:	01 d0                	add    %edx,%eax
  8030a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	c1 e0 0c             	shl    $0xc,%eax
  8030ab:	89 c2                	mov    %eax,%edx
  8030ad:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8030b2:	01 d0                	add    %edx,%eax
}
  8030b4:	c9                   	leave  
  8030b5:	c3                   	ret    

008030b6 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8030bc:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8030c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c4:	29 c2                	sub    %eax,%edx
  8030c6:	89 d0                	mov    %edx,%eax
  8030c8:	c1 e8 0c             	shr    $0xc,%eax
  8030cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8030ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d2:	78 09                	js     8030dd <to_page_info+0x27>
  8030d4:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8030db:	7e 14                	jle    8030f1 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	68 78 4d 80 00       	push   $0x804d78
  8030e5:	6a 22                	push   $0x22
  8030e7:	68 5f 4d 80 00       	push   $0x804d5f
  8030ec:	e8 74 0c 00 00       	call   803d65 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8030f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f4:	89 d0                	mov    %edx,%eax
  8030f6:	01 c0                	add    %eax,%eax
  8030f8:	01 d0                	add    %edx,%eax
  8030fa:	c1 e0 02             	shl    $0x2,%eax
  8030fd:	05 60 60 80 00       	add    $0x806060,%eax
}
  803102:	c9                   	leave  
  803103:	c3                   	ret    

00803104 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803104:	55                   	push   %ebp
  803105:	89 e5                	mov    %esp,%ebp
  803107:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	05 00 00 00 02       	add    $0x2000000,%eax
  803112:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803115:	73 16                	jae    80312d <initialize_dynamic_allocator+0x29>
  803117:	68 9c 4d 80 00       	push   $0x804d9c
  80311c:	68 c2 4d 80 00       	push   $0x804dc2
  803121:	6a 34                	push   $0x34
  803123:	68 5f 4d 80 00       	push   $0x804d5f
  803128:	e8 38 0c 00 00       	call   803d65 <_panic>
		is_initialized = 1;
  80312d:	c7 05 34 60 80 00 01 	movl   $0x1,0x806034
  803134:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd = daEnd;
  80313f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803142:	a3 40 60 80 00       	mov    %eax,0x806040

	LIST_INIT(&freePagesList);
  803147:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  80314e:	00 00 00 
  803151:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803158:	00 00 00 
  80315b:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803162:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803165:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  80316c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803173:	eb 36                	jmp    8031ab <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	c1 e0 04             	shl    $0x4,%eax
  80317b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	c1 e0 04             	shl    $0x4,%eax
  80318c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803191:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	c1 e0 04             	shl    $0x4,%eax
  80319d:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8031a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8031a8:	ff 45 f4             	incl   -0xc(%ebp)
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031b1:	72 c2                	jb     803175 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8031b3:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8031b9:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8031be:	29 c2                	sub    %eax,%edx
  8031c0:	89 d0                	mov    %edx,%eax
  8031c2:	c1 e8 0c             	shr    $0xc,%eax
  8031c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8031c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8031cf:	e9 c8 00 00 00       	jmp    80329c <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  8031d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d7:	89 d0                	mov    %edx,%eax
  8031d9:	01 c0                	add    %eax,%eax
  8031db:	01 d0                	add    %edx,%eax
  8031dd:	c1 e0 02             	shl    $0x2,%eax
  8031e0:	05 68 60 80 00       	add    $0x806068,%eax
  8031e5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8031ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ed:	89 d0                	mov    %edx,%eax
  8031ef:	01 c0                	add    %eax,%eax
  8031f1:	01 d0                	add    %edx,%eax
  8031f3:	c1 e0 02             	shl    $0x2,%eax
  8031f6:	05 6a 60 80 00       	add    $0x80606a,%eax
  8031fb:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803200:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803206:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803209:	89 c8                	mov    %ecx,%eax
  80320b:	01 c0                	add    %eax,%eax
  80320d:	01 c8                	add    %ecx,%eax
  80320f:	c1 e0 02             	shl    $0x2,%eax
  803212:	05 64 60 80 00       	add    $0x806064,%eax
  803217:	89 10                	mov    %edx,(%eax)
  803219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321c:	89 d0                	mov    %edx,%eax
  80321e:	01 c0                	add    %eax,%eax
  803220:	01 d0                	add    %edx,%eax
  803222:	c1 e0 02             	shl    $0x2,%eax
  803225:	05 64 60 80 00       	add    $0x806064,%eax
  80322a:	8b 00                	mov    (%eax),%eax
  80322c:	85 c0                	test   %eax,%eax
  80322e:	74 1b                	je     80324b <initialize_dynamic_allocator+0x147>
  803230:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803236:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803239:	89 c8                	mov    %ecx,%eax
  80323b:	01 c0                	add    %eax,%eax
  80323d:	01 c8                	add    %ecx,%eax
  80323f:	c1 e0 02             	shl    $0x2,%eax
  803242:	05 60 60 80 00       	add    $0x806060,%eax
  803247:	89 02                	mov    %eax,(%edx)
  803249:	eb 16                	jmp    803261 <initialize_dynamic_allocator+0x15d>
  80324b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324e:	89 d0                	mov    %edx,%eax
  803250:	01 c0                	add    %eax,%eax
  803252:	01 d0                	add    %edx,%eax
  803254:	c1 e0 02             	shl    $0x2,%eax
  803257:	05 60 60 80 00       	add    $0x806060,%eax
  80325c:	a3 48 60 80 00       	mov    %eax,0x806048
  803261:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803264:	89 d0                	mov    %edx,%eax
  803266:	01 c0                	add    %eax,%eax
  803268:	01 d0                	add    %edx,%eax
  80326a:	c1 e0 02             	shl    $0x2,%eax
  80326d:	05 60 60 80 00       	add    $0x806060,%eax
  803272:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327a:	89 d0                	mov    %edx,%eax
  80327c:	01 c0                	add    %eax,%eax
  80327e:	01 d0                	add    %edx,%eax
  803280:	c1 e0 02             	shl    $0x2,%eax
  803283:	05 60 60 80 00       	add    $0x806060,%eax
  803288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328e:	a1 54 60 80 00       	mov    0x806054,%eax
  803293:	40                   	inc    %eax
  803294:	a3 54 60 80 00       	mov    %eax,0x806054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803299:	ff 45 f0             	incl   -0x10(%ebp)
  80329c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032a2:	0f 82 2c ff ff ff    	jb     8031d4 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032ae:	eb 2f                	jmp    8032df <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8032b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032b3:	89 d0                	mov    %edx,%eax
  8032b5:	01 c0                	add    %eax,%eax
  8032b7:	01 d0                	add    %edx,%eax
  8032b9:	c1 e0 02             	shl    $0x2,%eax
  8032bc:	05 68 60 80 00       	add    $0x806068,%eax
  8032c1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  8032c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c9:	89 d0                	mov    %edx,%eax
  8032cb:	01 c0                	add    %eax,%eax
  8032cd:	01 d0                	add    %edx,%eax
  8032cf:	c1 e0 02             	shl    $0x2,%eax
  8032d2:	05 6a 60 80 00       	add    $0x80606a,%eax
  8032d7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8032dc:	ff 45 ec             	incl   -0x14(%ebp)
  8032df:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8032e6:	76 c8                	jbe    8032b0 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8032e8:	90                   	nop
  8032e9:	c9                   	leave  
  8032ea:	c3                   	ret    

008032eb <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8032eb:	55                   	push   %ebp
  8032ec:	89 e5                	mov    %esp,%ebp
  8032ee:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  8032f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f4:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8032f9:	29 c2                	sub    %eax,%edx
  8032fb:	89 d0                	mov    %edx,%eax
  8032fd:	c1 e8 0c             	shr    $0xc,%eax
  803300:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803306:	89 d0                	mov    %edx,%eax
  803308:	01 c0                	add    %eax,%eax
  80330a:	01 d0                	add    %edx,%eax
  80330c:	c1 e0 02             	shl    $0x2,%eax
  80330f:	05 68 60 80 00       	add    $0x806068,%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803319:	c9                   	leave  
  80331a:	c3                   	ret    

0080331b <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80331b:	55                   	push   %ebp
  80331c:	89 e5                	mov    %esp,%ebp
  80331e:	83 ec 14             	sub    $0x14,%esp
  803321:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803324:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803328:	77 07                	ja     803331 <nearest_pow2_ceil.1513+0x16>
  80332a:	b8 01 00 00 00       	mov    $0x1,%eax
  80332f:	eb 20                	jmp    803351 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803331:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803338:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  80333b:	eb 08                	jmp    803345 <nearest_pow2_ceil.1513+0x2a>
  80333d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803340:	01 c0                	add    %eax,%eax
  803342:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803345:	d1 6d 08             	shrl   0x8(%ebp)
  803348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334c:	75 ef                	jne    80333d <nearest_pow2_ceil.1513+0x22>
        return power;
  80334e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803351:	c9                   	leave  
  803352:	c3                   	ret    

00803353 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803353:	55                   	push   %ebp
  803354:	89 e5                	mov    %esp,%ebp
  803356:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803359:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803360:	76 16                	jbe    803378 <alloc_block+0x25>
  803362:	68 d8 4d 80 00       	push   $0x804dd8
  803367:	68 c2 4d 80 00       	push   $0x804dc2
  80336c:	6a 72                	push   $0x72
  80336e:	68 5f 4d 80 00       	push   $0x804d5f
  803373:	e8 ed 09 00 00       	call   803d65 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803378:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80337c:	75 0a                	jne    803388 <alloc_block+0x35>
  80337e:	b8 00 00 00 00       	mov    $0x0,%eax
  803383:	e9 bd 04 00 00       	jmp    803845 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803388:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803395:	73 06                	jae    80339d <alloc_block+0x4a>
        size = min_block_size;
  803397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339a:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  80339d:	83 ec 0c             	sub    $0xc,%esp
  8033a0:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8033a3:	ff 75 08             	pushl  0x8(%ebp)
  8033a6:	89 c1                	mov    %eax,%ecx
  8033a8:	e8 6e ff ff ff       	call   80331b <nearest_pow2_ceil.1513>
  8033ad:	83 c4 10             	add    $0x10,%esp
  8033b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  8033b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b6:	83 ec 0c             	sub    $0xc,%esp
  8033b9:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8033bc:	52                   	push   %edx
  8033bd:	89 c1                	mov    %eax,%ecx
  8033bf:	e8 83 04 00 00       	call   803847 <log2_ceil.1520>
  8033c4:	83 c4 10             	add    $0x10,%esp
  8033c7:	83 e8 03             	sub    $0x3,%eax
  8033ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  8033cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d0:	c1 e0 04             	shl    $0x4,%eax
  8033d3:	05 80 e0 81 00       	add    $0x81e080,%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	0f 84 d8 00 00 00    	je     8034ba <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8033e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e5:	c1 e0 04             	shl    $0x4,%eax
  8033e8:	05 80 e0 81 00       	add    $0x81e080,%eax
  8033ed:	8b 00                	mov    (%eax),%eax
  8033ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8033f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033f6:	75 17                	jne    80340f <alloc_block+0xbc>
  8033f8:	83 ec 04             	sub    $0x4,%esp
  8033fb:	68 f9 4d 80 00       	push   $0x804df9
  803400:	68 98 00 00 00       	push   $0x98
  803405:	68 5f 4d 80 00       	push   $0x804d5f
  80340a:	e8 56 09 00 00       	call   803d65 <_panic>
  80340f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803412:	8b 00                	mov    (%eax),%eax
  803414:	85 c0                	test   %eax,%eax
  803416:	74 10                	je     803428 <alloc_block+0xd5>
  803418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803420:	8b 52 04             	mov    0x4(%edx),%edx
  803423:	89 50 04             	mov    %edx,0x4(%eax)
  803426:	eb 14                	jmp    80343c <alloc_block+0xe9>
  803428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342b:	8b 40 04             	mov    0x4(%eax),%eax
  80342e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803431:	c1 e2 04             	shl    $0x4,%edx
  803434:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  80343a:	89 02                	mov    %eax,(%edx)
  80343c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343f:	8b 40 04             	mov    0x4(%eax),%eax
  803442:	85 c0                	test   %eax,%eax
  803444:	74 0f                	je     803455 <alloc_block+0x102>
  803446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803449:	8b 40 04             	mov    0x4(%eax),%eax
  80344c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80344f:	8b 12                	mov    (%edx),%edx
  803451:	89 10                	mov    %edx,(%eax)
  803453:	eb 13                	jmp    803468 <alloc_block+0x115>
  803455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803458:	8b 00                	mov    (%eax),%eax
  80345a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345d:	c1 e2 04             	shl    $0x4,%edx
  803460:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803466:	89 02                	mov    %eax,(%edx)
  803468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803471:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803474:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347e:	c1 e0 04             	shl    $0x4,%eax
  803481:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803486:	8b 00                	mov    (%eax),%eax
  803488:	8d 50 ff             	lea    -0x1(%eax),%edx
  80348b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348e:	c1 e0 04             	shl    $0x4,%eax
  803491:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803496:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349b:	83 ec 0c             	sub    $0xc,%esp
  80349e:	50                   	push   %eax
  80349f:	e8 12 fc ff ff       	call   8030b6 <to_page_info>
  8034a4:	83 c4 10             	add    $0x10,%esp
  8034a7:	89 c2                	mov    %eax,%edx
  8034a9:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8034ad:	48                   	dec    %eax
  8034ae:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8034b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b5:	e9 8b 03 00 00       	jmp    803845 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8034ba:	a1 48 60 80 00       	mov    0x806048,%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	0f 84 64 02 00 00    	je     80372b <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  8034c7:	a1 48 60 80 00       	mov    0x806048,%eax
  8034cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8034cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034d3:	75 17                	jne    8034ec <alloc_block+0x199>
  8034d5:	83 ec 04             	sub    $0x4,%esp
  8034d8:	68 f9 4d 80 00       	push   $0x804df9
  8034dd:	68 a0 00 00 00       	push   $0xa0
  8034e2:	68 5f 4d 80 00       	push   $0x804d5f
  8034e7:	e8 79 08 00 00       	call   803d65 <_panic>
  8034ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	85 c0                	test   %eax,%eax
  8034f3:	74 10                	je     803505 <alloc_block+0x1b2>
  8034f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f8:	8b 00                	mov    (%eax),%eax
  8034fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034fd:	8b 52 04             	mov    0x4(%edx),%edx
  803500:	89 50 04             	mov    %edx,0x4(%eax)
  803503:	eb 0b                	jmp    803510 <alloc_block+0x1bd>
  803505:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803508:	8b 40 04             	mov    0x4(%eax),%eax
  80350b:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803513:	8b 40 04             	mov    0x4(%eax),%eax
  803516:	85 c0                	test   %eax,%eax
  803518:	74 0f                	je     803529 <alloc_block+0x1d6>
  80351a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351d:	8b 40 04             	mov    0x4(%eax),%eax
  803520:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803523:	8b 12                	mov    (%edx),%edx
  803525:	89 10                	mov    %edx,(%eax)
  803527:	eb 0a                	jmp    803533 <alloc_block+0x1e0>
  803529:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	a3 48 60 80 00       	mov    %eax,0x806048
  803533:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80353f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803546:	a1 54 60 80 00       	mov    0x806054,%eax
  80354b:	48                   	dec    %eax
  80354c:	a3 54 60 80 00       	mov    %eax,0x806054

        page_info_e->block_size = pow;
  803551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803554:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803557:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  80355b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803560:	99                   	cltd   
  803561:	f7 7d e8             	idivl  -0x18(%ebp)
  803564:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803567:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  80356b:	83 ec 0c             	sub    $0xc,%esp
  80356e:	ff 75 dc             	pushl  -0x24(%ebp)
  803571:	e8 ce fa ff ff       	call   803044 <to_page_va>
  803576:	83 c4 10             	add    $0x10,%esp
  803579:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  80357c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80357f:	83 ec 0c             	sub    $0xc,%esp
  803582:	50                   	push   %eax
  803583:	e8 c0 ee ff ff       	call   802448 <get_page>
  803588:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80358b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803592:	e9 aa 00 00 00       	jmp    803641 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80359e:	89 c2                	mov    %eax,%edx
  8035a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035a3:	01 d0                	add    %edx,%eax
  8035a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8035a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035ac:	75 17                	jne    8035c5 <alloc_block+0x272>
  8035ae:	83 ec 04             	sub    $0x4,%esp
  8035b1:	68 18 4e 80 00       	push   $0x804e18
  8035b6:	68 aa 00 00 00       	push   $0xaa
  8035bb:	68 5f 4d 80 00       	push   $0x804d5f
  8035c0:	e8 a0 07 00 00       	call   803d65 <_panic>
  8035c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c8:	c1 e0 04             	shl    $0x4,%eax
  8035cb:	05 84 e0 81 00       	add    $0x81e084,%eax
  8035d0:	8b 10                	mov    (%eax),%edx
  8035d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035db:	8b 40 04             	mov    0x4(%eax),%eax
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	74 14                	je     8035f6 <alloc_block+0x2a3>
  8035e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e5:	c1 e0 04             	shl    $0x4,%eax
  8035e8:	05 84 e0 81 00       	add    $0x81e084,%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035f2:	89 10                	mov    %edx,(%eax)
  8035f4:	eb 11                	jmp    803607 <alloc_block+0x2b4>
  8035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f9:	c1 e0 04             	shl    $0x4,%eax
  8035fc:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803605:	89 02                	mov    %eax,(%edx)
  803607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360a:	c1 e0 04             	shl    $0x4,%eax
  80360d:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803613:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803616:	89 02                	mov    %eax,(%edx)
  803618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803624:	c1 e0 04             	shl    $0x4,%eax
  803627:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	8d 50 01             	lea    0x1(%eax),%edx
  803631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803634:	c1 e0 04             	shl    $0x4,%eax
  803637:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80363c:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80363e:	ff 45 f4             	incl   -0xc(%ebp)
  803641:	b8 00 10 00 00       	mov    $0x1000,%eax
  803646:	99                   	cltd   
  803647:	f7 7d e8             	idivl  -0x18(%ebp)
  80364a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80364d:	0f 8f 44 ff ff ff    	jg     803597 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803656:	c1 e0 04             	shl    $0x4,%eax
  803659:	05 80 e0 81 00       	add    $0x81e080,%eax
  80365e:	8b 00                	mov    (%eax),%eax
  803660:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803663:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803667:	75 17                	jne    803680 <alloc_block+0x32d>
  803669:	83 ec 04             	sub    $0x4,%esp
  80366c:	68 f9 4d 80 00       	push   $0x804df9
  803671:	68 ae 00 00 00       	push   $0xae
  803676:	68 5f 4d 80 00       	push   $0x804d5f
  80367b:	e8 e5 06 00 00       	call   803d65 <_panic>
  803680:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	85 c0                	test   %eax,%eax
  803687:	74 10                	je     803699 <alloc_block+0x346>
  803689:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80368c:	8b 00                	mov    (%eax),%eax
  80368e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803691:	8b 52 04             	mov    0x4(%edx),%edx
  803694:	89 50 04             	mov    %edx,0x4(%eax)
  803697:	eb 14                	jmp    8036ad <alloc_block+0x35a>
  803699:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80369c:	8b 40 04             	mov    0x4(%eax),%eax
  80369f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036a2:	c1 e2 04             	shl    $0x4,%edx
  8036a5:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8036ab:	89 02                	mov    %eax,(%edx)
  8036ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036b0:	8b 40 04             	mov    0x4(%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 0f                	je     8036c6 <alloc_block+0x373>
  8036b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036ba:	8b 40 04             	mov    0x4(%eax),%eax
  8036bd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8036c0:	8b 12                	mov    (%edx),%edx
  8036c2:	89 10                	mov    %edx,(%eax)
  8036c4:	eb 13                	jmp    8036d9 <alloc_block+0x386>
  8036c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036c9:	8b 00                	mov    (%eax),%eax
  8036cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ce:	c1 e2 04             	shl    $0x4,%edx
  8036d1:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8036d7:	89 02                	mov    %eax,(%edx)
  8036d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8036e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ef:	c1 e0 04             	shl    $0x4,%eax
  8036f2:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8036f7:	8b 00                	mov    (%eax),%eax
  8036f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8036fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ff:	c1 e0 04             	shl    $0x4,%eax
  803702:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803707:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803709:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80370c:	83 ec 0c             	sub    $0xc,%esp
  80370f:	50                   	push   %eax
  803710:	e8 a1 f9 ff ff       	call   8030b6 <to_page_info>
  803715:	83 c4 10             	add    $0x10,%esp
  803718:	89 c2                	mov    %eax,%edx
  80371a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80371e:	48                   	dec    %eax
  80371f:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803723:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803726:	e9 1a 01 00 00       	jmp    803845 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80372b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372e:	40                   	inc    %eax
  80372f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803732:	e9 ed 00 00 00       	jmp    803824 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373a:	c1 e0 04             	shl    $0x4,%eax
  80373d:	05 80 e0 81 00       	add    $0x81e080,%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	85 c0                	test   %eax,%eax
  803746:	0f 84 d5 00 00 00    	je     803821 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  80374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374f:	c1 e0 04             	shl    $0x4,%eax
  803752:	05 80 e0 81 00       	add    $0x81e080,%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  80375c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803760:	75 17                	jne    803779 <alloc_block+0x426>
  803762:	83 ec 04             	sub    $0x4,%esp
  803765:	68 f9 4d 80 00       	push   $0x804df9
  80376a:	68 b8 00 00 00       	push   $0xb8
  80376f:	68 5f 4d 80 00       	push   $0x804d5f
  803774:	e8 ec 05 00 00       	call   803d65 <_panic>
  803779:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	85 c0                	test   %eax,%eax
  803780:	74 10                	je     803792 <alloc_block+0x43f>
  803782:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803785:	8b 00                	mov    (%eax),%eax
  803787:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80378a:	8b 52 04             	mov    0x4(%edx),%edx
  80378d:	89 50 04             	mov    %edx,0x4(%eax)
  803790:	eb 14                	jmp    8037a6 <alloc_block+0x453>
  803792:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803795:	8b 40 04             	mov    0x4(%eax),%eax
  803798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80379b:	c1 e2 04             	shl    $0x4,%edx
  80379e:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8037a4:	89 02                	mov    %eax,(%edx)
  8037a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ac:	85 c0                	test   %eax,%eax
  8037ae:	74 0f                	je     8037bf <alloc_block+0x46c>
  8037b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037b3:	8b 40 04             	mov    0x4(%eax),%eax
  8037b6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037b9:	8b 12                	mov    (%edx),%edx
  8037bb:	89 10                	mov    %edx,(%eax)
  8037bd:	eb 13                	jmp    8037d2 <alloc_block+0x47f>
  8037bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037c2:	8b 00                	mov    (%eax),%eax
  8037c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037c7:	c1 e2 04             	shl    $0x4,%edx
  8037ca:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8037d0:	89 02                	mov    %eax,(%edx)
  8037d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e8:	c1 e0 04             	shl    $0x4,%eax
  8037eb:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f8:	c1 e0 04             	shl    $0x4,%eax
  8037fb:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803800:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803802:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803805:	83 ec 0c             	sub    $0xc,%esp
  803808:	50                   	push   %eax
  803809:	e8 a8 f8 ff ff       	call   8030b6 <to_page_info>
  80380e:	83 c4 10             	add    $0x10,%esp
  803811:	89 c2                	mov    %eax,%edx
  803813:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803817:	48                   	dec    %eax
  803818:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80381c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80381f:	eb 24                	jmp    803845 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803821:	ff 45 f0             	incl   -0x10(%ebp)
  803824:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803828:	0f 8e 09 ff ff ff    	jle    803737 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80382e:	83 ec 04             	sub    $0x4,%esp
  803831:	68 3b 4e 80 00       	push   $0x804e3b
  803836:	68 bf 00 00 00       	push   $0xbf
  80383b:	68 5f 4d 80 00       	push   $0x804d5f
  803840:	e8 20 05 00 00       	call   803d65 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803845:	c9                   	leave  
  803846:	c3                   	ret    

00803847 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803847:	55                   	push   %ebp
  803848:	89 e5                	mov    %esp,%ebp
  80384a:	83 ec 14             	sub    $0x14,%esp
  80384d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803850:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803854:	75 07                	jne    80385d <log2_ceil.1520+0x16>
  803856:	b8 00 00 00 00       	mov    $0x0,%eax
  80385b:	eb 1b                	jmp    803878 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80385d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803864:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803867:	eb 06                	jmp    80386f <log2_ceil.1520+0x28>
            x >>= 1;
  803869:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80386c:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80386f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803873:	75 f4                	jne    803869 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803875:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803878:	c9                   	leave  
  803879:	c3                   	ret    

0080387a <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80387a:	55                   	push   %ebp
  80387b:	89 e5                	mov    %esp,%ebp
  80387d:	83 ec 14             	sub    $0x14,%esp
  803880:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803883:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803887:	75 07                	jne    803890 <log2_ceil.1547+0x16>
  803889:	b8 00 00 00 00       	mov    $0x0,%eax
  80388e:	eb 1b                	jmp    8038ab <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803890:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803897:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80389a:	eb 06                	jmp    8038a2 <log2_ceil.1547+0x28>
			x >>= 1;
  80389c:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80389f:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8038a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a6:	75 f4                	jne    80389c <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8038a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8038ab:	c9                   	leave  
  8038ac:	c3                   	ret    

008038ad <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8038ad:	55                   	push   %ebp
  8038ae:	89 e5                	mov    %esp,%ebp
  8038b0:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8038b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b6:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8038bb:	39 c2                	cmp    %eax,%edx
  8038bd:	72 0c                	jb     8038cb <free_block+0x1e>
  8038bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c2:	a1 40 60 80 00       	mov    0x806040,%eax
  8038c7:	39 c2                	cmp    %eax,%edx
  8038c9:	72 19                	jb     8038e4 <free_block+0x37>
  8038cb:	68 40 4e 80 00       	push   $0x804e40
  8038d0:	68 c2 4d 80 00       	push   $0x804dc2
  8038d5:	68 d0 00 00 00       	push   $0xd0
  8038da:	68 5f 4d 80 00       	push   $0x804d5f
  8038df:	e8 81 04 00 00       	call   803d65 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8038e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e8:	0f 84 42 03 00 00    	je     803c30 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8038ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f1:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8038f6:	39 c2                	cmp    %eax,%edx
  8038f8:	72 0c                	jb     803906 <free_block+0x59>
  8038fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8038fd:	a1 40 60 80 00       	mov    0x806040,%eax
  803902:	39 c2                	cmp    %eax,%edx
  803904:	72 17                	jb     80391d <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803906:	83 ec 04             	sub    $0x4,%esp
  803909:	68 78 4e 80 00       	push   $0x804e78
  80390e:	68 e6 00 00 00       	push   $0xe6
  803913:	68 5f 4d 80 00       	push   $0x804d5f
  803918:	e8 48 04 00 00       	call   803d65 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80391d:	8b 55 08             	mov    0x8(%ebp),%edx
  803920:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803925:	29 c2                	sub    %eax,%edx
  803927:	89 d0                	mov    %edx,%eax
  803929:	83 e0 07             	and    $0x7,%eax
  80392c:	85 c0                	test   %eax,%eax
  80392e:	74 17                	je     803947 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803930:	83 ec 04             	sub    $0x4,%esp
  803933:	68 ac 4e 80 00       	push   $0x804eac
  803938:	68 ea 00 00 00       	push   $0xea
  80393d:	68 5f 4d 80 00       	push   $0x804d5f
  803942:	e8 1e 04 00 00       	call   803d65 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803947:	8b 45 08             	mov    0x8(%ebp),%eax
  80394a:	83 ec 0c             	sub    $0xc,%esp
  80394d:	50                   	push   %eax
  80394e:	e8 63 f7 ff ff       	call   8030b6 <to_page_info>
  803953:	83 c4 10             	add    $0x10,%esp
  803956:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803959:	83 ec 0c             	sub    $0xc,%esp
  80395c:	ff 75 08             	pushl  0x8(%ebp)
  80395f:	e8 87 f9 ff ff       	call   8032eb <get_block_size>
  803964:	83 c4 10             	add    $0x10,%esp
  803967:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80396a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80396e:	75 17                	jne    803987 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803970:	83 ec 04             	sub    $0x4,%esp
  803973:	68 d8 4e 80 00       	push   $0x804ed8
  803978:	68 f1 00 00 00       	push   $0xf1
  80397d:	68 5f 4d 80 00       	push   $0x804d5f
  803982:	e8 de 03 00 00       	call   803d65 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803987:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80398a:	83 ec 0c             	sub    $0xc,%esp
  80398d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803990:	52                   	push   %edx
  803991:	89 c1                	mov    %eax,%ecx
  803993:	e8 e2 fe ff ff       	call   80387a <log2_ceil.1547>
  803998:	83 c4 10             	add    $0x10,%esp
  80399b:	83 e8 03             	sub    $0x3,%eax
  80399e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8039a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8039a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8039ab:	75 17                	jne    8039c4 <free_block+0x117>
  8039ad:	83 ec 04             	sub    $0x4,%esp
  8039b0:	68 24 4f 80 00       	push   $0x804f24
  8039b5:	68 f6 00 00 00       	push   $0xf6
  8039ba:	68 5f 4d 80 00       	push   $0x804d5f
  8039bf:	e8 a1 03 00 00       	call   803d65 <_panic>
  8039c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c7:	c1 e0 04             	shl    $0x4,%eax
  8039ca:	05 80 e0 81 00       	add    $0x81e080,%eax
  8039cf:	8b 10                	mov    (%eax),%edx
  8039d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d4:	89 10                	mov    %edx,(%eax)
  8039d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d9:	8b 00                	mov    (%eax),%eax
  8039db:	85 c0                	test   %eax,%eax
  8039dd:	74 15                	je     8039f4 <free_block+0x147>
  8039df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e2:	c1 e0 04             	shl    $0x4,%eax
  8039e5:	05 80 e0 81 00       	add    $0x81e080,%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039ef:	89 50 04             	mov    %edx,0x4(%eax)
  8039f2:	eb 11                	jmp    803a05 <free_block+0x158>
  8039f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f7:	c1 e0 04             	shl    $0x4,%eax
  8039fa:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a03:	89 02                	mov    %eax,(%edx)
  803a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a08:	c1 e0 04             	shl    $0x4,%eax
  803a0b:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a14:	89 02                	mov    %eax,(%edx)
  803a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a23:	c1 e0 04             	shl    $0x4,%eax
  803a26:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a2b:	8b 00                	mov    (%eax),%eax
  803a2d:	8d 50 01             	lea    0x1(%eax),%edx
  803a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a33:	c1 e0 04             	shl    $0x4,%eax
  803a36:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a3b:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a40:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a44:	40                   	inc    %eax
  803a45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a48:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  803a4f:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803a54:	29 c2                	sub    %eax,%edx
  803a56:	89 d0                	mov    %edx,%eax
  803a58:	c1 e8 0c             	shr    $0xc,%eax
  803a5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a61:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a65:	0f b7 c8             	movzwl %ax,%ecx
  803a68:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a6d:	99                   	cltd   
  803a6e:	f7 7d e8             	idivl  -0x18(%ebp)
  803a71:	39 c1                	cmp    %eax,%ecx
  803a73:	0f 85 b8 01 00 00    	jne    803c31 <free_block+0x384>
    	uint32 blocks_removed = 0;
  803a79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a83:	c1 e0 04             	shl    $0x4,%eax
  803a86:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a8b:	8b 00                	mov    (%eax),%eax
  803a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803a90:	e9 d5 00 00 00       	jmp    803b6a <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a98:	8b 00                	mov    (%eax),%eax
  803a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aa0:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803aa5:	29 c2                	sub    %eax,%edx
  803aa7:	89 d0                	mov    %edx,%eax
  803aa9:	c1 e8 0c             	shr    $0xc,%eax
  803aac:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803aaf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803ab5:	0f 85 a9 00 00 00    	jne    803b64 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803abb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803abf:	75 17                	jne    803ad8 <free_block+0x22b>
  803ac1:	83 ec 04             	sub    $0x4,%esp
  803ac4:	68 f9 4d 80 00       	push   $0x804df9
  803ac9:	68 04 01 00 00       	push   $0x104
  803ace:	68 5f 4d 80 00       	push   $0x804d5f
  803ad3:	e8 8d 02 00 00       	call   803d65 <_panic>
  803ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803adb:	8b 00                	mov    (%eax),%eax
  803add:	85 c0                	test   %eax,%eax
  803adf:	74 10                	je     803af1 <free_block+0x244>
  803ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ae9:	8b 52 04             	mov    0x4(%edx),%edx
  803aec:	89 50 04             	mov    %edx,0x4(%eax)
  803aef:	eb 14                	jmp    803b05 <free_block+0x258>
  803af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af4:	8b 40 04             	mov    0x4(%eax),%eax
  803af7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803afa:	c1 e2 04             	shl    $0x4,%edx
  803afd:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803b03:	89 02                	mov    %eax,(%edx)
  803b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b08:	8b 40 04             	mov    0x4(%eax),%eax
  803b0b:	85 c0                	test   %eax,%eax
  803b0d:	74 0f                	je     803b1e <free_block+0x271>
  803b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b12:	8b 40 04             	mov    0x4(%eax),%eax
  803b15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b18:	8b 12                	mov    (%edx),%edx
  803b1a:	89 10                	mov    %edx,(%eax)
  803b1c:	eb 13                	jmp    803b31 <free_block+0x284>
  803b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b21:	8b 00                	mov    (%eax),%eax
  803b23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b26:	c1 e2 04             	shl    $0x4,%edx
  803b29:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803b2f:	89 02                	mov    %eax,(%edx)
  803b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b47:	c1 e0 04             	shl    $0x4,%eax
  803b4a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b4f:	8b 00                	mov    (%eax),%eax
  803b51:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b57:	c1 e0 04             	shl    $0x4,%eax
  803b5a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b5f:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803b61:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803b64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803b6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b6e:	0f 85 21 ff ff ff    	jne    803a95 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803b74:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b79:	99                   	cltd   
  803b7a:	f7 7d e8             	idivl  -0x18(%ebp)
  803b7d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803b80:	74 17                	je     803b99 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803b82:	83 ec 04             	sub    $0x4,%esp
  803b85:	68 48 4f 80 00       	push   $0x804f48
  803b8a:	68 0c 01 00 00       	push   $0x10c
  803b8f:	68 5f 4d 80 00       	push   $0x804d5f
  803b94:	e8 cc 01 00 00       	call   803d65 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b9c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba5:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803bab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803baf:	75 17                	jne    803bc8 <free_block+0x31b>
  803bb1:	83 ec 04             	sub    $0x4,%esp
  803bb4:	68 18 4e 80 00       	push   $0x804e18
  803bb9:	68 11 01 00 00       	push   $0x111
  803bbe:	68 5f 4d 80 00       	push   $0x804d5f
  803bc3:	e8 9d 01 00 00       	call   803d65 <_panic>
  803bc8:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd1:	89 50 04             	mov    %edx,0x4(%eax)
  803bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd7:	8b 40 04             	mov    0x4(%eax),%eax
  803bda:	85 c0                	test   %eax,%eax
  803bdc:	74 0c                	je     803bea <free_block+0x33d>
  803bde:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803be3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803be6:	89 10                	mov    %edx,(%eax)
  803be8:	eb 08                	jmp    803bf2 <free_block+0x345>
  803bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bed:	a3 48 60 80 00       	mov    %eax,0x806048
  803bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf5:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c03:	a1 54 60 80 00       	mov    0x806054,%eax
  803c08:	40                   	inc    %eax
  803c09:	a3 54 60 80 00       	mov    %eax,0x806054

        uint32 pp = to_page_va(page_info_e);
  803c0e:	83 ec 0c             	sub    $0xc,%esp
  803c11:	ff 75 ec             	pushl  -0x14(%ebp)
  803c14:	e8 2b f4 ff ff       	call   803044 <to_page_va>
  803c19:	83 c4 10             	add    $0x10,%esp
  803c1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803c1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c22:	83 ec 0c             	sub    $0xc,%esp
  803c25:	50                   	push   %eax
  803c26:	e8 69 e8 ff ff       	call   802494 <return_page>
  803c2b:	83 c4 10             	add    $0x10,%esp
  803c2e:	eb 01                	jmp    803c31 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803c30:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803c31:	c9                   	leave  
  803c32:	c3                   	ret    

00803c33 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803c33:	55                   	push   %ebp
  803c34:	89 e5                	mov    %esp,%ebp
  803c36:	83 ec 14             	sub    $0x14,%esp
  803c39:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803c3c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803c40:	77 07                	ja     803c49 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803c42:	b8 01 00 00 00       	mov    $0x1,%eax
  803c47:	eb 20                	jmp    803c69 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803c49:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803c50:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803c53:	eb 08                	jmp    803c5d <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c58:	01 c0                	add    %eax,%eax
  803c5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803c5d:	d1 6d 08             	shrl   0x8(%ebp)
  803c60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c64:	75 ef                	jne    803c55 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803c69:	c9                   	leave  
  803c6a:	c3                   	ret    

00803c6b <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803c6b:	55                   	push   %ebp
  803c6c:	89 e5                	mov    %esp,%ebp
  803c6e:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803c71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c75:	75 13                	jne    803c8a <realloc_block+0x1f>
    return alloc_block(new_size);
  803c77:	83 ec 0c             	sub    $0xc,%esp
  803c7a:	ff 75 0c             	pushl  0xc(%ebp)
  803c7d:	e8 d1 f6 ff ff       	call   803353 <alloc_block>
  803c82:	83 c4 10             	add    $0x10,%esp
  803c85:	e9 d9 00 00 00       	jmp    803d63 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c8e:	75 18                	jne    803ca8 <realloc_block+0x3d>
    free_block(va);
  803c90:	83 ec 0c             	sub    $0xc,%esp
  803c93:	ff 75 08             	pushl  0x8(%ebp)
  803c96:	e8 12 fc ff ff       	call   8038ad <free_block>
  803c9b:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca3:	e9 bb 00 00 00       	jmp    803d63 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803ca8:	83 ec 0c             	sub    $0xc,%esp
  803cab:	ff 75 08             	pushl  0x8(%ebp)
  803cae:	e8 38 f6 ff ff       	call   8032eb <get_block_size>
  803cb3:	83 c4 10             	add    $0x10,%esp
  803cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803cb9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cc6:	73 06                	jae    803cce <realloc_block+0x63>
    new_size = min_block_size;
  803cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ccb:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803cce:	83 ec 0c             	sub    $0xc,%esp
  803cd1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803cd4:	ff 75 0c             	pushl  0xc(%ebp)
  803cd7:	89 c1                	mov    %eax,%ecx
  803cd9:	e8 55 ff ff ff       	call   803c33 <nearest_pow2_ceil.1572>
  803cde:	83 c4 10             	add    $0x10,%esp
  803ce1:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803cea:	75 05                	jne    803cf1 <realloc_block+0x86>
    return va;
  803cec:	8b 45 08             	mov    0x8(%ebp),%eax
  803cef:	eb 72                	jmp    803d63 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803cf1:	83 ec 0c             	sub    $0xc,%esp
  803cf4:	ff 75 0c             	pushl  0xc(%ebp)
  803cf7:	e8 57 f6 ff ff       	call   803353 <alloc_block>
  803cfc:	83 c4 10             	add    $0x10,%esp
  803cff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803d02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d06:	75 07                	jne    803d0f <realloc_block+0xa4>
    return NULL;
  803d08:	b8 00 00 00 00       	mov    $0x0,%eax
  803d0d:	eb 54                	jmp    803d63 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803d0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d15:	39 d0                	cmp    %edx,%eax
  803d17:	76 02                	jbe    803d1b <realloc_block+0xb0>
  803d19:	89 d0                	mov    %edx,%eax
  803d1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d21:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803d24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803d2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d31:	eb 17                	jmp    803d4a <realloc_block+0xdf>
    dst[i] = src[i];
  803d33:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d39:	01 c2                	add    %eax,%edx
  803d3b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d41:	01 c8                	add    %ecx,%eax
  803d43:	8a 00                	mov    (%eax),%al
  803d45:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803d47:	ff 45 f4             	incl   -0xc(%ebp)
  803d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d50:	72 e1                	jb     803d33 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803d52:	83 ec 0c             	sub    $0xc,%esp
  803d55:	ff 75 08             	pushl  0x8(%ebp)
  803d58:	e8 50 fb ff ff       	call   8038ad <free_block>
  803d5d:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803d63:	c9                   	leave  
  803d64:	c3                   	ret    

00803d65 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803d65:	55                   	push   %ebp
  803d66:	89 e5                	mov    %esp,%ebp
  803d68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803d6b:	8d 45 10             	lea    0x10(%ebp),%eax
  803d6e:	83 c0 04             	add    $0x4,%eax
  803d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803d74:	a1 1c e1 81 00       	mov    0x81e11c,%eax
  803d79:	85 c0                	test   %eax,%eax
  803d7b:	74 16                	je     803d93 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803d7d:	a1 1c e1 81 00       	mov    0x81e11c,%eax
  803d82:	83 ec 08             	sub    $0x8,%esp
  803d85:	50                   	push   %eax
  803d86:	68 7c 4f 80 00       	push   $0x804f7c
  803d8b:	e8 14 cf ff ff       	call   800ca4 <cprintf>
  803d90:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803d93:	a1 04 60 80 00       	mov    0x806004,%eax
  803d98:	83 ec 0c             	sub    $0xc,%esp
  803d9b:	ff 75 0c             	pushl  0xc(%ebp)
  803d9e:	ff 75 08             	pushl  0x8(%ebp)
  803da1:	50                   	push   %eax
  803da2:	68 84 4f 80 00       	push   $0x804f84
  803da7:	6a 74                	push   $0x74
  803da9:	e8 23 cf ff ff       	call   800cd1 <cprintf_colored>
  803dae:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803db1:	8b 45 10             	mov    0x10(%ebp),%eax
  803db4:	83 ec 08             	sub    $0x8,%esp
  803db7:	ff 75 f4             	pushl  -0xc(%ebp)
  803dba:	50                   	push   %eax
  803dbb:	e8 75 ce ff ff       	call   800c35 <vcprintf>
  803dc0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803dc3:	83 ec 08             	sub    $0x8,%esp
  803dc6:	6a 00                	push   $0x0
  803dc8:	68 ac 4f 80 00       	push   $0x804fac
  803dcd:	e8 63 ce ff ff       	call   800c35 <vcprintf>
  803dd2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803dd5:	e8 dc cd ff ff       	call   800bb6 <exit>

	// should not return here
	while (1) ;
  803dda:	eb fe                	jmp    803dda <_panic+0x75>

00803ddc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803ddc:	55                   	push   %ebp
  803ddd:	89 e5                	mov    %esp,%ebp
  803ddf:	53                   	push   %ebx
  803de0:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803de3:	a1 20 60 80 00       	mov    0x806020,%eax
  803de8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df1:	39 c2                	cmp    %eax,%edx
  803df3:	74 14                	je     803e09 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803df5:	83 ec 04             	sub    $0x4,%esp
  803df8:	68 b0 4f 80 00       	push   $0x804fb0
  803dfd:	6a 26                	push   $0x26
  803dff:	68 fc 4f 80 00       	push   $0x804ffc
  803e04:	e8 5c ff ff ff       	call   803d65 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803e09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803e10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803e17:	e9 d9 00 00 00       	jmp    803ef5 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  803e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803e26:	8b 45 08             	mov    0x8(%ebp),%eax
  803e29:	01 d0                	add    %edx,%eax
  803e2b:	8b 00                	mov    (%eax),%eax
  803e2d:	85 c0                	test   %eax,%eax
  803e2f:	75 08                	jne    803e39 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  803e31:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803e34:	e9 b9 00 00 00       	jmp    803ef2 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  803e39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803e40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803e47:	eb 79                	jmp    803ec2 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803e49:	a1 20 60 80 00       	mov    0x806020,%eax
  803e4e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803e54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e57:	89 d0                	mov    %edx,%eax
  803e59:	01 c0                	add    %eax,%eax
  803e5b:	01 d0                	add    %edx,%eax
  803e5d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803e64:	01 d8                	add    %ebx,%eax
  803e66:	01 d0                	add    %edx,%eax
  803e68:	01 c8                	add    %ecx,%eax
  803e6a:	8a 40 04             	mov    0x4(%eax),%al
  803e6d:	84 c0                	test   %al,%al
  803e6f:	75 4e                	jne    803ebf <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803e71:	a1 20 60 80 00       	mov    0x806020,%eax
  803e76:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803e7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e7f:	89 d0                	mov    %edx,%eax
  803e81:	01 c0                	add    %eax,%eax
  803e83:	01 d0                	add    %edx,%eax
  803e85:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803e8c:	01 d8                	add    %ebx,%eax
  803e8e:	01 d0                	add    %edx,%eax
  803e90:	01 c8                	add    %ecx,%eax
  803e92:	8b 00                	mov    (%eax),%eax
  803e94:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803e97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803e9f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803eab:	8b 45 08             	mov    0x8(%ebp),%eax
  803eae:	01 c8                	add    %ecx,%eax
  803eb0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803eb2:	39 c2                	cmp    %eax,%edx
  803eb4:	75 09                	jne    803ebf <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803eb6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803ebd:	eb 19                	jmp    803ed8 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ebf:	ff 45 e8             	incl   -0x18(%ebp)
  803ec2:	a1 20 60 80 00       	mov    0x806020,%eax
  803ec7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed0:	39 c2                	cmp    %eax,%edx
  803ed2:	0f 87 71 ff ff ff    	ja     803e49 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803ed8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803edc:	75 14                	jne    803ef2 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  803ede:	83 ec 04             	sub    $0x4,%esp
  803ee1:	68 08 50 80 00       	push   $0x805008
  803ee6:	6a 3a                	push   $0x3a
  803ee8:	68 fc 4f 80 00       	push   $0x804ffc
  803eed:	e8 73 fe ff ff       	call   803d65 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803ef2:	ff 45 f0             	incl   -0x10(%ebp)
  803ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803efb:	0f 8c 1b ff ff ff    	jl     803e1c <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f08:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803f0f:	eb 2e                	jmp    803f3f <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803f11:	a1 20 60 80 00       	mov    0x806020,%eax
  803f16:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803f1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f1f:	89 d0                	mov    %edx,%eax
  803f21:	01 c0                	add    %eax,%eax
  803f23:	01 d0                	add    %edx,%eax
  803f25:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803f2c:	01 d8                	add    %ebx,%eax
  803f2e:	01 d0                	add    %edx,%eax
  803f30:	01 c8                	add    %ecx,%eax
  803f32:	8a 40 04             	mov    0x4(%eax),%al
  803f35:	3c 01                	cmp    $0x1,%al
  803f37:	75 03                	jne    803f3c <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803f39:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f3c:	ff 45 e0             	incl   -0x20(%ebp)
  803f3f:	a1 20 60 80 00       	mov    0x806020,%eax
  803f44:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803f4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f4d:	39 c2                	cmp    %eax,%edx
  803f4f:	77 c0                	ja     803f11 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f54:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803f57:	74 14                	je     803f6d <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803f59:	83 ec 04             	sub    $0x4,%esp
  803f5c:	68 5c 50 80 00       	push   $0x80505c
  803f61:	6a 44                	push   $0x44
  803f63:	68 fc 4f 80 00       	push   $0x804ffc
  803f68:	e8 f8 fd ff ff       	call   803d65 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803f6d:	90                   	nop
  803f6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803f71:	c9                   	leave  
  803f72:	c3                   	ret    
  803f73:	90                   	nop

00803f74 <__udivdi3>:
  803f74:	55                   	push   %ebp
  803f75:	57                   	push   %edi
  803f76:	56                   	push   %esi
  803f77:	53                   	push   %ebx
  803f78:	83 ec 1c             	sub    $0x1c,%esp
  803f7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f8b:	89 ca                	mov    %ecx,%edx
  803f8d:	89 f8                	mov    %edi,%eax
  803f8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f93:	85 f6                	test   %esi,%esi
  803f95:	75 2d                	jne    803fc4 <__udivdi3+0x50>
  803f97:	39 cf                	cmp    %ecx,%edi
  803f99:	77 65                	ja     804000 <__udivdi3+0x8c>
  803f9b:	89 fd                	mov    %edi,%ebp
  803f9d:	85 ff                	test   %edi,%edi
  803f9f:	75 0b                	jne    803fac <__udivdi3+0x38>
  803fa1:	b8 01 00 00 00       	mov    $0x1,%eax
  803fa6:	31 d2                	xor    %edx,%edx
  803fa8:	f7 f7                	div    %edi
  803faa:	89 c5                	mov    %eax,%ebp
  803fac:	31 d2                	xor    %edx,%edx
  803fae:	89 c8                	mov    %ecx,%eax
  803fb0:	f7 f5                	div    %ebp
  803fb2:	89 c1                	mov    %eax,%ecx
  803fb4:	89 d8                	mov    %ebx,%eax
  803fb6:	f7 f5                	div    %ebp
  803fb8:	89 cf                	mov    %ecx,%edi
  803fba:	89 fa                	mov    %edi,%edx
  803fbc:	83 c4 1c             	add    $0x1c,%esp
  803fbf:	5b                   	pop    %ebx
  803fc0:	5e                   	pop    %esi
  803fc1:	5f                   	pop    %edi
  803fc2:	5d                   	pop    %ebp
  803fc3:	c3                   	ret    
  803fc4:	39 ce                	cmp    %ecx,%esi
  803fc6:	77 28                	ja     803ff0 <__udivdi3+0x7c>
  803fc8:	0f bd fe             	bsr    %esi,%edi
  803fcb:	83 f7 1f             	xor    $0x1f,%edi
  803fce:	75 40                	jne    804010 <__udivdi3+0x9c>
  803fd0:	39 ce                	cmp    %ecx,%esi
  803fd2:	72 0a                	jb     803fde <__udivdi3+0x6a>
  803fd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fd8:	0f 87 9e 00 00 00    	ja     80407c <__udivdi3+0x108>
  803fde:	b8 01 00 00 00       	mov    $0x1,%eax
  803fe3:	89 fa                	mov    %edi,%edx
  803fe5:	83 c4 1c             	add    $0x1c,%esp
  803fe8:	5b                   	pop    %ebx
  803fe9:	5e                   	pop    %esi
  803fea:	5f                   	pop    %edi
  803feb:	5d                   	pop    %ebp
  803fec:	c3                   	ret    
  803fed:	8d 76 00             	lea    0x0(%esi),%esi
  803ff0:	31 ff                	xor    %edi,%edi
  803ff2:	31 c0                	xor    %eax,%eax
  803ff4:	89 fa                	mov    %edi,%edx
  803ff6:	83 c4 1c             	add    $0x1c,%esp
  803ff9:	5b                   	pop    %ebx
  803ffa:	5e                   	pop    %esi
  803ffb:	5f                   	pop    %edi
  803ffc:	5d                   	pop    %ebp
  803ffd:	c3                   	ret    
  803ffe:	66 90                	xchg   %ax,%ax
  804000:	89 d8                	mov    %ebx,%eax
  804002:	f7 f7                	div    %edi
  804004:	31 ff                	xor    %edi,%edi
  804006:	89 fa                	mov    %edi,%edx
  804008:	83 c4 1c             	add    $0x1c,%esp
  80400b:	5b                   	pop    %ebx
  80400c:	5e                   	pop    %esi
  80400d:	5f                   	pop    %edi
  80400e:	5d                   	pop    %ebp
  80400f:	c3                   	ret    
  804010:	bd 20 00 00 00       	mov    $0x20,%ebp
  804015:	89 eb                	mov    %ebp,%ebx
  804017:	29 fb                	sub    %edi,%ebx
  804019:	89 f9                	mov    %edi,%ecx
  80401b:	d3 e6                	shl    %cl,%esi
  80401d:	89 c5                	mov    %eax,%ebp
  80401f:	88 d9                	mov    %bl,%cl
  804021:	d3 ed                	shr    %cl,%ebp
  804023:	89 e9                	mov    %ebp,%ecx
  804025:	09 f1                	or     %esi,%ecx
  804027:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80402b:	89 f9                	mov    %edi,%ecx
  80402d:	d3 e0                	shl    %cl,%eax
  80402f:	89 c5                	mov    %eax,%ebp
  804031:	89 d6                	mov    %edx,%esi
  804033:	88 d9                	mov    %bl,%cl
  804035:	d3 ee                	shr    %cl,%esi
  804037:	89 f9                	mov    %edi,%ecx
  804039:	d3 e2                	shl    %cl,%edx
  80403b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80403f:	88 d9                	mov    %bl,%cl
  804041:	d3 e8                	shr    %cl,%eax
  804043:	09 c2                	or     %eax,%edx
  804045:	89 d0                	mov    %edx,%eax
  804047:	89 f2                	mov    %esi,%edx
  804049:	f7 74 24 0c          	divl   0xc(%esp)
  80404d:	89 d6                	mov    %edx,%esi
  80404f:	89 c3                	mov    %eax,%ebx
  804051:	f7 e5                	mul    %ebp
  804053:	39 d6                	cmp    %edx,%esi
  804055:	72 19                	jb     804070 <__udivdi3+0xfc>
  804057:	74 0b                	je     804064 <__udivdi3+0xf0>
  804059:	89 d8                	mov    %ebx,%eax
  80405b:	31 ff                	xor    %edi,%edi
  80405d:	e9 58 ff ff ff       	jmp    803fba <__udivdi3+0x46>
  804062:	66 90                	xchg   %ax,%ax
  804064:	8b 54 24 08          	mov    0x8(%esp),%edx
  804068:	89 f9                	mov    %edi,%ecx
  80406a:	d3 e2                	shl    %cl,%edx
  80406c:	39 c2                	cmp    %eax,%edx
  80406e:	73 e9                	jae    804059 <__udivdi3+0xe5>
  804070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804073:	31 ff                	xor    %edi,%edi
  804075:	e9 40 ff ff ff       	jmp    803fba <__udivdi3+0x46>
  80407a:	66 90                	xchg   %ax,%ax
  80407c:	31 c0                	xor    %eax,%eax
  80407e:	e9 37 ff ff ff       	jmp    803fba <__udivdi3+0x46>
  804083:	90                   	nop

00804084 <__umoddi3>:
  804084:	55                   	push   %ebp
  804085:	57                   	push   %edi
  804086:	56                   	push   %esi
  804087:	53                   	push   %ebx
  804088:	83 ec 1c             	sub    $0x1c,%esp
  80408b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80408f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804097:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80409b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80409f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040a3:	89 f3                	mov    %esi,%ebx
  8040a5:	89 fa                	mov    %edi,%edx
  8040a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040ab:	89 34 24             	mov    %esi,(%esp)
  8040ae:	85 c0                	test   %eax,%eax
  8040b0:	75 1a                	jne    8040cc <__umoddi3+0x48>
  8040b2:	39 f7                	cmp    %esi,%edi
  8040b4:	0f 86 a2 00 00 00    	jbe    80415c <__umoddi3+0xd8>
  8040ba:	89 c8                	mov    %ecx,%eax
  8040bc:	89 f2                	mov    %esi,%edx
  8040be:	f7 f7                	div    %edi
  8040c0:	89 d0                	mov    %edx,%eax
  8040c2:	31 d2                	xor    %edx,%edx
  8040c4:	83 c4 1c             	add    $0x1c,%esp
  8040c7:	5b                   	pop    %ebx
  8040c8:	5e                   	pop    %esi
  8040c9:	5f                   	pop    %edi
  8040ca:	5d                   	pop    %ebp
  8040cb:	c3                   	ret    
  8040cc:	39 f0                	cmp    %esi,%eax
  8040ce:	0f 87 ac 00 00 00    	ja     804180 <__umoddi3+0xfc>
  8040d4:	0f bd e8             	bsr    %eax,%ebp
  8040d7:	83 f5 1f             	xor    $0x1f,%ebp
  8040da:	0f 84 ac 00 00 00    	je     80418c <__umoddi3+0x108>
  8040e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8040e5:	29 ef                	sub    %ebp,%edi
  8040e7:	89 fe                	mov    %edi,%esi
  8040e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040ed:	89 e9                	mov    %ebp,%ecx
  8040ef:	d3 e0                	shl    %cl,%eax
  8040f1:	89 d7                	mov    %edx,%edi
  8040f3:	89 f1                	mov    %esi,%ecx
  8040f5:	d3 ef                	shr    %cl,%edi
  8040f7:	09 c7                	or     %eax,%edi
  8040f9:	89 e9                	mov    %ebp,%ecx
  8040fb:	d3 e2                	shl    %cl,%edx
  8040fd:	89 14 24             	mov    %edx,(%esp)
  804100:	89 d8                	mov    %ebx,%eax
  804102:	d3 e0                	shl    %cl,%eax
  804104:	89 c2                	mov    %eax,%edx
  804106:	8b 44 24 08          	mov    0x8(%esp),%eax
  80410a:	d3 e0                	shl    %cl,%eax
  80410c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804110:	8b 44 24 08          	mov    0x8(%esp),%eax
  804114:	89 f1                	mov    %esi,%ecx
  804116:	d3 e8                	shr    %cl,%eax
  804118:	09 d0                	or     %edx,%eax
  80411a:	d3 eb                	shr    %cl,%ebx
  80411c:	89 da                	mov    %ebx,%edx
  80411e:	f7 f7                	div    %edi
  804120:	89 d3                	mov    %edx,%ebx
  804122:	f7 24 24             	mull   (%esp)
  804125:	89 c6                	mov    %eax,%esi
  804127:	89 d1                	mov    %edx,%ecx
  804129:	39 d3                	cmp    %edx,%ebx
  80412b:	0f 82 87 00 00 00    	jb     8041b8 <__umoddi3+0x134>
  804131:	0f 84 91 00 00 00    	je     8041c8 <__umoddi3+0x144>
  804137:	8b 54 24 04          	mov    0x4(%esp),%edx
  80413b:	29 f2                	sub    %esi,%edx
  80413d:	19 cb                	sbb    %ecx,%ebx
  80413f:	89 d8                	mov    %ebx,%eax
  804141:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804145:	d3 e0                	shl    %cl,%eax
  804147:	89 e9                	mov    %ebp,%ecx
  804149:	d3 ea                	shr    %cl,%edx
  80414b:	09 d0                	or     %edx,%eax
  80414d:	89 e9                	mov    %ebp,%ecx
  80414f:	d3 eb                	shr    %cl,%ebx
  804151:	89 da                	mov    %ebx,%edx
  804153:	83 c4 1c             	add    $0x1c,%esp
  804156:	5b                   	pop    %ebx
  804157:	5e                   	pop    %esi
  804158:	5f                   	pop    %edi
  804159:	5d                   	pop    %ebp
  80415a:	c3                   	ret    
  80415b:	90                   	nop
  80415c:	89 fd                	mov    %edi,%ebp
  80415e:	85 ff                	test   %edi,%edi
  804160:	75 0b                	jne    80416d <__umoddi3+0xe9>
  804162:	b8 01 00 00 00       	mov    $0x1,%eax
  804167:	31 d2                	xor    %edx,%edx
  804169:	f7 f7                	div    %edi
  80416b:	89 c5                	mov    %eax,%ebp
  80416d:	89 f0                	mov    %esi,%eax
  80416f:	31 d2                	xor    %edx,%edx
  804171:	f7 f5                	div    %ebp
  804173:	89 c8                	mov    %ecx,%eax
  804175:	f7 f5                	div    %ebp
  804177:	89 d0                	mov    %edx,%eax
  804179:	e9 44 ff ff ff       	jmp    8040c2 <__umoddi3+0x3e>
  80417e:	66 90                	xchg   %ax,%ax
  804180:	89 c8                	mov    %ecx,%eax
  804182:	89 f2                	mov    %esi,%edx
  804184:	83 c4 1c             	add    $0x1c,%esp
  804187:	5b                   	pop    %ebx
  804188:	5e                   	pop    %esi
  804189:	5f                   	pop    %edi
  80418a:	5d                   	pop    %ebp
  80418b:	c3                   	ret    
  80418c:	3b 04 24             	cmp    (%esp),%eax
  80418f:	72 06                	jb     804197 <__umoddi3+0x113>
  804191:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804195:	77 0f                	ja     8041a6 <__umoddi3+0x122>
  804197:	89 f2                	mov    %esi,%edx
  804199:	29 f9                	sub    %edi,%ecx
  80419b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80419f:	89 14 24             	mov    %edx,(%esp)
  8041a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041aa:	8b 14 24             	mov    (%esp),%edx
  8041ad:	83 c4 1c             	add    $0x1c,%esp
  8041b0:	5b                   	pop    %ebx
  8041b1:	5e                   	pop    %esi
  8041b2:	5f                   	pop    %edi
  8041b3:	5d                   	pop    %ebp
  8041b4:	c3                   	ret    
  8041b5:	8d 76 00             	lea    0x0(%esi),%esi
  8041b8:	2b 04 24             	sub    (%esp),%eax
  8041bb:	19 fa                	sbb    %edi,%edx
  8041bd:	89 d1                	mov    %edx,%ecx
  8041bf:	89 c6                	mov    %eax,%esi
  8041c1:	e9 71 ff ff ff       	jmp    804137 <__umoddi3+0xb3>
  8041c6:	66 90                	xchg   %ax,%ax
  8041c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041cc:	72 ea                	jb     8041b8 <__umoddi3+0x134>
  8041ce:	89 d9                	mov    %ebx,%ecx
  8041d0:	e9 62 ff ff ff       	jmp    804137 <__umoddi3+0xb3>
