
obj/user/tst_page_replacement_optimal_1:     file format elf32-i386


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
  800031:	e8 99 02 00 00       	call   8002cf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x806000, 0x807000, 0x808000, 0x800000, 0x803000, 0x801000, 0xeebfd000, 0x804000, 0x809000,
		0x80a000, 0x80b000, 0x80c000, 0x827000, 0x802000, 0x800000, 0x803000, 0xeebfd000, 0x801000,
		0x827000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  800044:	6a 01                	push   $0x1
  800046:	68 00 00 80 00       	push   $0x800000
  80004b:	6a 0b                	push   $0xb
  80004d:	68 20 30 80 00       	push   $0x803020
  800052:	e8 dc 1a 00 00       	call   801b33 <sys_check_WS_list>
  800057:	83 c4 10             	add    $0x10,%esp
  80005a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80005d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800060:	83 f8 01             	cmp    $0x1,%eax
  800063:	74 14                	je     800079 <_main+0x41>
  800065:	83 ec 04             	sub    $0x4,%esp
  800068:	68 80 1e 80 00       	push   $0x801e80
  80006d:	6a 1e                	push   $0x1e
  80006f:	68 f4 1e 80 00       	push   $0x801ef4
  800074:	e8 06 04 00 00       	call   80047f <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800079:	e8 f3 16 00 00       	call   801771 <sys_calculate_free_frames>
  80007e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800081:	e8 36 17 00 00       	call   8017bc <sys_pf_calculate_allocated_pages>
  800086:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800089:	c6 05 1f d1 80 00 61 	movb   $0x61,0x80d11f

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800090:	a0 1f e1 80 00       	mov    0x80e11f,%al
  800095:	88 45 db             	mov    %al,-0x25(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800098:	a0 1f f1 80 00       	mov    0x80f11f,%al
  80009d:	88 45 da             	mov    %al,-0x26(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000a7:	eb 26                	jmp    8000cf <_main+0x97>
	{
		__arr__[i] = -1 ;
  8000a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ac:	05 20 31 80 00       	add    $0x803120,%eax
  8000b1:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  8000b4:	a1 00 30 80 00       	mov    0x803000,%eax
  8000b9:	8a 00                	mov    (%eax),%al
  8000bb:	88 45 d9             	mov    %al,-0x27(%ebp)
		garbage5 = *__ptr2__ ;
  8000be:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c3:	8a 00                	mov    (%eax),%al
  8000c5:	88 45 d8             	mov    %al,-0x28(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c8:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8000cf:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  8000d6:	7e d1                	jle    8000a9 <_main+0x71>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking INITIAL WS... \n");
  8000d8:	83 ec 08             	sub    $0x8,%esp
  8000db:	68 1a 1f 80 00       	push   $0x801f1a
  8000e0:	6a 03                	push   $0x3
  8000e2:	e8 b3 06 00 00       	call   80079a <cprintf_colored>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x800000, 1);
  8000ea:	6a 01                	push   $0x1
  8000ec:	68 00 00 80 00       	push   $0x800000
  8000f1:	6a 0b                	push   $0xb
  8000f3:	68 20 30 80 00       	push   $0x803020
  8000f8:	e8 36 1a 00 00       	call   801b33 <sys_check_WS_list>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (found != 1) panic("OPTIMAL alg. failed.. the initial working set is changed while it's not expected to");
  800103:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800106:	83 f8 01             	cmp    $0x1,%eax
  800109:	74 14                	je     80011f <_main+0xe7>
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	68 38 1f 80 00       	push   $0x801f38
  800113:	6a 41                	push   $0x41
  800115:	68 f4 1e 80 00       	push   $0x801ef4
  80011a:	e8 60 03 00 00       	call   80047f <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking EXPECTED REFERENCE STREAM... \n");
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	68 8c 1f 80 00       	push   $0x801f8c
  800127:	6a 03                	push   $0x3
  800129:	e8 6c 06 00 00       	call   80079a <cprintf_colored>
  80012e:	83 c4 10             	add    $0x10,%esp
	{
		char separator[2] = "@";
  800131:	66 c7 45 ca 40 00    	movw   $0x40,-0x36(%ebp)
		char checkRefStreamCmd[100] = "__CheckRefStream@";
  800137:	8d 85 ee fe ff ff    	lea    -0x112(%ebp),%eax
  80013d:	bb 45 21 80 00       	mov    $0x802145,%ebx
  800142:	ba 12 00 00 00       	mov    $0x12,%edx
  800147:	89 c7                	mov    %eax,%edi
  800149:	89 de                	mov    %ebx,%esi
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80014f:	8d 95 00 ff ff ff    	lea    -0x100(%ebp),%edx
  800155:	b9 52 00 00 00       	mov    $0x52,%ecx
  80015a:	b0 00                	mov    $0x0,%al
  80015c:	89 d7                	mov    %edx,%edi
  80015e:	f3 aa                	rep stos %al,%es:(%edi)
		char token[20] ;
		char cmdWithCnt[100] ;
		ltostr(EXPECTED_REF_CNT, token);
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800166:	50                   	push   %eax
  800167:	6a 1c                	push   $0x1c
  800169:	e8 2d 12 00 00       	call   80139b <ltostr>
  80016e:	83 c4 10             	add    $0x10,%esp
		strcconcat(checkRefStreamCmd, token, cmdWithCnt);
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  80017e:	50                   	push   %eax
  80017f:	8d 85 ee fe ff ff    	lea    -0x112(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	e8 e9 12 00 00       	call   801474 <strcconcat>
  80018b:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	8d 45 ca             	lea    -0x36(%ebp),%eax
  80019b:	50                   	push   %eax
  80019c:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 cc 12 00 00       	call   801474 <strcconcat>
  8001a8:	83 c4 10             	add    $0x10,%esp
		ltostr((uint32)&expectedRefStream, token);
  8001ab:	ba 60 30 80 00       	mov    $0x803060,%edx
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	52                   	push   %edx
  8001b8:	e8 de 11 00 00       	call   80139b <ltostr>
  8001bd:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, token, cmdWithCnt);
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  8001cd:	50                   	push   %eax
  8001ce:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 9a 12 00 00       	call   801474 <strcconcat>
  8001da:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	8d 45 ca             	lea    -0x36(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  8001f1:	50                   	push   %eax
  8001f2:	e8 7d 12 00 00       	call   801474 <strcconcat>
  8001f7:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("%~Ref Command = %s\n", cmdWithCnt);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	68 b7 1f 80 00       	push   $0x801fb7
  800209:	e8 d1 05 00 00       	call   8007df <atomic_cprintf>
  80020e:	83 c4 10             	add    $0x10,%esp

		sys_utilities(cmdWithCnt, (uint32)&found);
  800211:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	8d 85 52 ff ff ff    	lea    -0xae(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 4c 19 00 00       	call   801b70 <sys_utilities>
  800224:	83 c4 10             	add    $0x10,%esp

		if (found != 1) panic("OPTIMAL alg. failed.. unexpected page reference stream!");
  800227:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80022a:	83 f8 01             	cmp    $0x1,%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 cc 1f 80 00       	push   $0x801fcc
  800237:	6a 54                	push   $0x54
  800239:	68 f4 1e 80 00       	push   $0x801ef4
  80023e:	e8 3c 02 00 00       	call   80047f <_panic>
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	68 04 20 80 00       	push   $0x802004
  80024b:	6a 03                	push   $0x3
  80024d:	e8 48 05 00 00       	call   80079a <cprintf_colored>
  800252:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800255:	e8 62 15 00 00       	call   8017bc <sys_pf_calculate_allocated_pages>
  80025a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80025d:	74 14                	je     800273 <_main+0x23b>
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	68 34 20 80 00       	push   $0x802034
  800267:	6a 58                	push   $0x58
  800269:	68 f4 1e 80 00       	push   $0x801ef4
  80026e:	e8 0c 02 00 00       	call   80047f <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800273:	e8 f9 14 00 00       	call   801771 <sys_calculate_free_frames>
  800278:	89 c3                	mov    %eax,%ebx
  80027a:	e8 0b 15 00 00       	call   80178a <sys_calculate_modified_frames>
  80027f:	01 d8                	add    %ebx,%eax
  800281:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int expectedNumOfFrames = 7;
  800284:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		if( (freePages - freePagesAfter) != expectedNumOfFrames)
  80028b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800291:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800294:	74 1e                	je     8002b4 <_main+0x27c>
			panic("Unexpected number of allocated frames in RAM. Expected = %d, Actual = %d", expectedNumOfFrames, (freePages - freePagesAfter));
  800296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800299:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a3:	68 a0 20 80 00       	push   $0x8020a0
  8002a8:	6a 5d                	push   $0x5d
  8002aa:	68 f4 1e 80 00       	push   $0x801ef4
  8002af:	e8 cb 01 00 00       	call   80047f <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #1 [OPTIMAL Alg.] is completed successfully.\n");
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	68 ec 20 80 00       	push   $0x8020ec
  8002bc:	6a 0a                	push   $0xa
  8002be:	e8 d7 04 00 00       	call   80079a <cprintf_colored>
  8002c3:	83 c4 10             	add    $0x10,%esp
	return;
  8002c6:	90                   	nop
}
  8002c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	57                   	push   %edi
  8002d3:	56                   	push   %esi
  8002d4:	53                   	push   %ebx
  8002d5:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002d8:	e8 5d 16 00 00       	call   80193a <sys_getenvindex>
  8002dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	01 d0                	add    %edx,%eax
  8002ee:	c1 e0 02             	shl    $0x2,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	c1 e0 03             	shl    $0x3,%eax
  8002f6:	01 d0                	add    %edx,%eax
  8002f8:	c1 e0 02             	shl    $0x2,%eax
  8002fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800300:	a3 e0 30 80 00       	mov    %eax,0x8030e0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800305:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80030a:	8a 40 20             	mov    0x20(%eax),%al
  80030d:	84 c0                	test   %al,%al
  80030f:	74 0d                	je     80031e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800311:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800316:	83 c0 20             	add    $0x20,%eax
  800319:	a3 d4 30 80 00       	mov    %eax,0x8030d4

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800322:	7e 0a                	jle    80032e <libmain+0x5f>
		binaryname = argv[0];
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	8b 00                	mov    (%eax),%eax
  800329:	a3 d4 30 80 00       	mov    %eax,0x8030d4

	// call user main routine
	_main(argc, argv);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 fc fc ff ff       	call   800038 <_main>
  80033c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80033f:	a1 d0 30 80 00       	mov    0x8030d0,%eax
  800344:	85 c0                	test   %eax,%eax
  800346:	0f 84 01 01 00 00    	je     80044d <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80034c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800352:	bb a4 22 80 00       	mov    $0x8022a4,%ebx
  800357:	ba 0e 00 00 00       	mov    $0xe,%edx
  80035c:	89 c7                	mov    %eax,%edi
  80035e:	89 de                	mov    %ebx,%esi
  800360:	89 d1                	mov    %edx,%ecx
  800362:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800364:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800367:	b9 56 00 00 00       	mov    $0x56,%ecx
  80036c:	b0 00                	mov    $0x0,%al
  80036e:	89 d7                	mov    %edx,%edi
  800370:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800372:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800379:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	50                   	push   %eax
  800380:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	e8 e4 17 00 00       	call   801b70 <sys_utilities>
  80038c:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80038f:	e8 2d 13 00 00       	call   8016c1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	68 c4 21 80 00       	push   $0x8021c4
  80039c:	e8 cc 03 00 00       	call   80076d <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	74 18                	je     8003c3 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ab:	e8 de 17 00 00       	call   801b8e <sys_get_optimal_num_faults>
  8003b0:	83 ec 08             	sub    $0x8,%esp
  8003b3:	50                   	push   %eax
  8003b4:	68 ec 21 80 00       	push   $0x8021ec
  8003b9:	e8 af 03 00 00       	call   80076d <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
  8003c1:	eb 59                	jmp    80041c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c3:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003c8:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003ce:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003d3:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	52                   	push   %edx
  8003dd:	50                   	push   %eax
  8003de:	68 10 22 80 00       	push   $0x802210
  8003e3:	e8 85 03 00 00       	call   80076d <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003eb:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003f0:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003f6:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8003fb:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800401:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800406:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80040c:	51                   	push   %ecx
  80040d:	52                   	push   %edx
  80040e:	50                   	push   %eax
  80040f:	68 38 22 80 00       	push   $0x802238
  800414:	e8 54 03 00 00       	call   80076d <cprintf>
  800419:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041c:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800421:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 90 22 80 00       	push   $0x802290
  800430:	e8 38 03 00 00       	call   80076d <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	68 c4 21 80 00       	push   $0x8021c4
  800440:	e8 28 03 00 00       	call   80076d <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800448:	e8 8e 12 00 00       	call   8016db <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80044d:	e8 1f 00 00 00       	call   800471 <exit>
}
  800452:	90                   	nop
  800453:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800456:	5b                   	pop    %ebx
  800457:	5e                   	pop    %esi
  800458:	5f                   	pop    %edi
  800459:	5d                   	pop    %ebp
  80045a:	c3                   	ret    

0080045b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800461:	83 ec 0c             	sub    $0xc,%esp
  800464:	6a 00                	push   $0x0
  800466:	e8 9b 14 00 00       	call   801906 <sys_destroy_env>
  80046b:	83 c4 10             	add    $0x10,%esp
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <exit>:

void
exit(void)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800477:	e8 f0 14 00 00       	call   80196c <sys_exit_env>
}
  80047c:	90                   	nop
  80047d:	c9                   	leave  
  80047e:	c3                   	ret    

0080047f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800485:	8d 45 10             	lea    0x10(%ebp),%eax
  800488:	83 c0 04             	add    $0x4,%eax
  80048b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80048e:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  800493:	85 c0                	test   %eax,%eax
  800495:	74 16                	je     8004ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800497:	a1 f8 71 82 00       	mov    0x8271f8,%eax
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	50                   	push   %eax
  8004a0:	68 08 23 80 00       	push   $0x802308
  8004a5:	e8 c3 02 00 00       	call   80076d <cprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004ad:	a1 d4 30 80 00       	mov    0x8030d4,%eax
  8004b2:	83 ec 0c             	sub    $0xc,%esp
  8004b5:	ff 75 0c             	pushl  0xc(%ebp)
  8004b8:	ff 75 08             	pushl  0x8(%ebp)
  8004bb:	50                   	push   %eax
  8004bc:	68 10 23 80 00       	push   $0x802310
  8004c1:	6a 74                	push   $0x74
  8004c3:	e8 d2 02 00 00       	call   80079a <cprintf_colored>
  8004c8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d4:	50                   	push   %eax
  8004d5:	e8 24 02 00 00       	call   8006fe <vcprintf>
  8004da:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	6a 00                	push   $0x0
  8004e2:	68 38 23 80 00       	push   $0x802338
  8004e7:	e8 12 02 00 00       	call   8006fe <vcprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ef:	e8 7d ff ff ff       	call   800471 <exit>

	// should not return here
	while (1) ;
  8004f4:	eb fe                	jmp    8004f4 <_panic+0x75>

008004f6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	53                   	push   %ebx
  8004fa:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004fd:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800502:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	39 c2                	cmp    %eax,%edx
  80050d:	74 14                	je     800523 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	68 3c 23 80 00       	push   $0x80233c
  800517:	6a 26                	push   $0x26
  800519:	68 88 23 80 00       	push   $0x802388
  80051e:	e8 5c ff ff ff       	call   80047f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800523:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80052a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800531:	e9 d9 00 00 00       	jmp    80060f <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800539:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	85 c0                	test   %eax,%eax
  800549:	75 08                	jne    800553 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80054b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80054e:	e9 b9 00 00 00       	jmp    80060c <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800553:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800561:	eb 79                	jmp    8005dc <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800563:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800568:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80056e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800571:	89 d0                	mov    %edx,%eax
  800573:	01 c0                	add    %eax,%eax
  800575:	01 d0                	add    %edx,%eax
  800577:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80057e:	01 d8                	add    %ebx,%eax
  800580:	01 d0                	add    %edx,%eax
  800582:	01 c8                	add    %ecx,%eax
  800584:	8a 40 04             	mov    0x4(%eax),%al
  800587:	84 c0                	test   %al,%al
  800589:	75 4e                	jne    8005d9 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058b:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800590:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800596:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800599:	89 d0                	mov    %edx,%eax
  80059b:	01 c0                	add    %eax,%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005a6:	01 d8                	add    %ebx,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	01 c8                	add    %ecx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005be:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cc:	39 c2                	cmp    %eax,%edx
  8005ce:	75 09                	jne    8005d9 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005d0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d7:	eb 19                	jmp    8005f2 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d9:	ff 45 e8             	incl   -0x18(%ebp)
  8005dc:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  8005e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ea:	39 c2                	cmp    %eax,%edx
  8005ec:	0f 87 71 ff ff ff    	ja     800563 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f6:	75 14                	jne    80060c <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	68 94 23 80 00       	push   $0x802394
  800600:	6a 3a                	push   $0x3a
  800602:	68 88 23 80 00       	push   $0x802388
  800607:	e8 73 fe ff ff       	call   80047f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060c:	ff 45 f0             	incl   -0x10(%ebp)
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800615:	0f 8c 1b ff ff ff    	jl     800536 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80061b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800622:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800629:	eb 2e                	jmp    800659 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80062b:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  800630:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800636:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800639:	89 d0                	mov    %edx,%eax
  80063b:	01 c0                	add    %eax,%eax
  80063d:	01 d0                	add    %edx,%eax
  80063f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800646:	01 d8                	add    %ebx,%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 e0 30 80 00       	mov    0x8030e0,%eax
  80065e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800667:	39 c2                	cmp    %eax,%edx
  800669:	77 c0                	ja     80062b <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800671:	74 14                	je     800687 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800673:	83 ec 04             	sub    $0x4,%esp
  800676:	68 e8 23 80 00       	push   $0x8023e8
  80067b:	6a 44                	push   $0x44
  80067d:	68 88 23 80 00       	push   $0x802388
  800682:	e8 f8 fd ff ff       	call   80047f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800687:	90                   	nop
  800688:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80068b:	c9                   	leave  
  80068c:	c3                   	ret    

0080068d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	53                   	push   %ebx
  800691:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800694:	8b 45 0c             	mov    0xc(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 48 01             	lea    0x1(%eax),%ecx
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	89 0a                	mov    %ecx,(%edx)
  8006a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a4:	88 d1                	mov    %dl,%cl
  8006a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b7:	75 30                	jne    8006e9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b9:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  8006bf:	a0 04 31 80 00       	mov    0x803104,%al
  8006c4:	0f b6 c0             	movzbl %al,%eax
  8006c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ca:	8b 09                	mov    (%ecx),%ecx
  8006cc:	89 cb                	mov    %ecx,%ebx
  8006ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d1:	83 c1 08             	add    $0x8,%ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	53                   	push   %ebx
  8006d7:	51                   	push   %ecx
  8006d8:	e8 a0 0f 00 00       	call   80167d <sys_cputs>
  8006dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	8b 40 04             	mov    0x4(%eax),%eax
  8006ef:	8d 50 01             	lea    0x1(%eax),%edx
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f8:	90                   	nop
  8006f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fc:	c9                   	leave  
  8006fd:	c3                   	ret    

008006fe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800707:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070e:	00 00 00 
	b.cnt = 0;
  800711:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800718:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	ff 75 08             	pushl  0x8(%ebp)
  800721:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	68 8d 06 80 00       	push   $0x80068d
  80072d:	e8 5a 02 00 00       	call   80098c <vprintfmt>
  800732:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800735:	8b 15 fc 71 82 00    	mov    0x8271fc,%edx
  80073b:	a0 04 31 80 00       	mov    0x803104,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800749:	52                   	push   %edx
  80074a:	50                   	push   %eax
  80074b:	51                   	push   %ecx
  80074c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800752:	83 c0 08             	add    $0x8,%eax
  800755:	50                   	push   %eax
  800756:	e8 22 0f 00 00       	call   80167d <sys_cputs>
  80075b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80075e:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
	return b.cnt;
  800765:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800773:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	va_start(ap, fmt);
  80077a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 f4             	pushl  -0xc(%ebp)
  800789:	50                   	push   %eax
  80078a:	e8 6f ff ff ff       	call   8006fe <vcprintf>
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a0:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	c1 e0 08             	shl    $0x8,%eax
  8007ad:	a3 fc 71 82 00       	mov    %eax,0x8271fc
	va_start(ap, fmt);
  8007b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	e8 34 ff ff ff       	call   8006fe <vcprintf>
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007d0:	c7 05 fc 71 82 00 00 	movl   $0x700,0x8271fc
  8007d7:	07 00 00 

	return cnt;
  8007da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007dd:	c9                   	leave  
  8007de:	c3                   	ret    

008007df <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e5:	e8 d7 0e 00 00       	call   8016c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f9:	50                   	push   %eax
  8007fa:	e8 ff fe ff ff       	call   8006fe <vcprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800805:	e8 d1 0e 00 00       	call   8016db <sys_unlock_cons>
	return cnt;
  80080a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	53                   	push   %ebx
  800813:	83 ec 14             	sub    $0x14,%esp
  800816:	8b 45 10             	mov    0x10(%ebp),%eax
  800819:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800822:	8b 45 18             	mov    0x18(%ebp),%eax
  800825:	ba 00 00 00 00       	mov    $0x0,%edx
  80082a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082d:	77 55                	ja     800884 <printnum+0x75>
  80082f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800832:	72 05                	jb     800839 <printnum+0x2a>
  800834:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800837:	77 4b                	ja     800884 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800839:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083f:	8b 45 18             	mov    0x18(%ebp),%eax
  800842:	ba 00 00 00 00       	mov    $0x0,%edx
  800847:	52                   	push   %edx
  800848:	50                   	push   %eax
  800849:	ff 75 f4             	pushl  -0xc(%ebp)
  80084c:	ff 75 f0             	pushl  -0x10(%ebp)
  80084f:	e8 ac 13 00 00       	call   801c00 <__udivdi3>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	83 ec 04             	sub    $0x4,%esp
  80085a:	ff 75 20             	pushl  0x20(%ebp)
  80085d:	53                   	push   %ebx
  80085e:	ff 75 18             	pushl  0x18(%ebp)
  800861:	52                   	push   %edx
  800862:	50                   	push   %eax
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	ff 75 08             	pushl  0x8(%ebp)
  800869:	e8 a1 ff ff ff       	call   80080f <printnum>
  80086e:	83 c4 20             	add    $0x20,%esp
  800871:	eb 1a                	jmp    80088d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	ff 75 20             	pushl  0x20(%ebp)
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	ff d0                	call   *%eax
  800881:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800884:	ff 4d 1c             	decl   0x1c(%ebp)
  800887:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80088b:	7f e6                	jg     800873 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800890:	bb 00 00 00 00       	mov    $0x0,%ebx
  800895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089b:	53                   	push   %ebx
  80089c:	51                   	push   %ecx
  80089d:	52                   	push   %edx
  80089e:	50                   	push   %eax
  80089f:	e8 6c 14 00 00       	call   801d10 <__umoddi3>
  8008a4:	83 c4 10             	add    $0x10,%esp
  8008a7:	05 54 26 80 00       	add    $0x802654,%eax
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f be c0             	movsbl %al,%eax
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	50                   	push   %eax
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	ff d0                	call   *%eax
  8008bd:	83 c4 10             	add    $0x10,%esp
}
  8008c0:	90                   	nop
  8008c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    

008008c6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cd:	7e 1c                	jle    8008eb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	8d 50 08             	lea    0x8(%eax),%edx
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	89 10                	mov    %edx,(%eax)
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	83 e8 08             	sub    $0x8,%eax
  8008e4:	8b 50 04             	mov    0x4(%eax),%edx
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	eb 40                	jmp    80092b <getuint+0x65>
	else if (lflag)
  8008eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ef:	74 1e                	je     80090f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	8d 50 04             	lea    0x4(%eax),%edx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	89 10                	mov    %edx,(%eax)
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	83 e8 04             	sub    $0x4,%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	ba 00 00 00 00       	mov    $0x0,%edx
  80090d:	eb 1c                	jmp    80092b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	8d 50 04             	lea    0x4(%eax),%edx
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	89 10                	mov    %edx,(%eax)
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 00                	mov    (%eax),%eax
  800921:	83 e8 04             	sub    $0x4,%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800930:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800934:	7e 1c                	jle    800952 <getint+0x25>
		return va_arg(*ap, long long);
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	8d 50 08             	lea    0x8(%eax),%edx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	89 10                	mov    %edx,(%eax)
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	83 e8 08             	sub    $0x8,%eax
  80094b:	8b 50 04             	mov    0x4(%eax),%edx
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	eb 38                	jmp    80098a <getint+0x5d>
	else if (lflag)
  800952:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800956:	74 1a                	je     800972 <getint+0x45>
		return va_arg(*ap, long);
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	8d 50 04             	lea    0x4(%eax),%edx
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	89 10                	mov    %edx,(%eax)
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	83 e8 04             	sub    $0x4,%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	99                   	cltd   
  800970:	eb 18                	jmp    80098a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	8d 50 04             	lea    0x4(%eax),%edx
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	89 10                	mov    %edx,(%eax)
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	83 e8 04             	sub    $0x4,%eax
  800987:	8b 00                	mov    (%eax),%eax
  800989:	99                   	cltd   
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	56                   	push   %esi
  800990:	53                   	push   %ebx
  800991:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800994:	eb 17                	jmp    8009ad <vprintfmt+0x21>
			if (ch == '\0')
  800996:	85 db                	test   %ebx,%ebx
  800998:	0f 84 c1 03 00 00    	je     800d5f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	53                   	push   %ebx
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	ff d0                	call   *%eax
  8009aa:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	8d 50 01             	lea    0x1(%eax),%edx
  8009b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b6:	8a 00                	mov    (%eax),%al
  8009b8:	0f b6 d8             	movzbl %al,%ebx
  8009bb:	83 fb 25             	cmp    $0x25,%ebx
  8009be:	75 d6                	jne    800996 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009cb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	8d 50 01             	lea    0x1(%eax),%edx
  8009e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	0f b6 d8             	movzbl %al,%ebx
  8009ee:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f1:	83 f8 5b             	cmp    $0x5b,%eax
  8009f4:	0f 87 3d 03 00 00    	ja     800d37 <vprintfmt+0x3ab>
  8009fa:	8b 04 85 78 26 80 00 	mov    0x802678(,%eax,4),%eax
  800a01:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a03:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a07:	eb d7                	jmp    8009e0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a09:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0d:	eb d1                	jmp    8009e0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a19:	89 d0                	mov    %edx,%eax
  800a1b:	c1 e0 02             	shl    $0x2,%eax
  800a1e:	01 d0                	add    %edx,%eax
  800a20:	01 c0                	add    %eax,%eax
  800a22:	01 d8                	add    %ebx,%eax
  800a24:	83 e8 30             	sub    $0x30,%eax
  800a27:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2d:	8a 00                	mov    (%eax),%al
  800a2f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a32:	83 fb 2f             	cmp    $0x2f,%ebx
  800a35:	7e 3e                	jle    800a75 <vprintfmt+0xe9>
  800a37:	83 fb 39             	cmp    $0x39,%ebx
  800a3a:	7f 39                	jg     800a75 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3f:	eb d5                	jmp    800a16 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	83 c0 04             	add    $0x4,%eax
  800a47:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 e8 04             	sub    $0x4,%eax
  800a50:	8b 00                	mov    (%eax),%eax
  800a52:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a55:	eb 1f                	jmp    800a76 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	79 83                	jns    8009e0 <vprintfmt+0x54>
				width = 0;
  800a5d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a64:	e9 77 ff ff ff       	jmp    8009e0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a69:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a70:	e9 6b ff ff ff       	jmp    8009e0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a75:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	0f 89 60 ff ff ff    	jns    8009e0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a86:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8d:	e9 4e ff ff ff       	jmp    8009e0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a92:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a95:	e9 46 ff ff ff       	jmp    8009e0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	83 c0 04             	add    $0x4,%eax
  800aa0:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 e8 04             	sub    $0x4,%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	ff d0                	call   *%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
			break;
  800aba:	e9 9b 02 00 00       	jmp    800d5a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	83 c0 04             	add    $0x4,%eax
  800ac5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  800acb:	83 e8 04             	sub    $0x4,%eax
  800ace:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad0:	85 db                	test   %ebx,%ebx
  800ad2:	79 02                	jns    800ad6 <vprintfmt+0x14a>
				err = -err;
  800ad4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad6:	83 fb 64             	cmp    $0x64,%ebx
  800ad9:	7f 0b                	jg     800ae6 <vprintfmt+0x15a>
  800adb:	8b 34 9d c0 24 80 00 	mov    0x8024c0(,%ebx,4),%esi
  800ae2:	85 f6                	test   %esi,%esi
  800ae4:	75 19                	jne    800aff <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae6:	53                   	push   %ebx
  800ae7:	68 65 26 80 00       	push   $0x802665
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 70 02 00 00       	call   800d67 <printfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800afa:	e9 5b 02 00 00       	jmp    800d5a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aff:	56                   	push   %esi
  800b00:	68 6e 26 80 00       	push   $0x80266e
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	ff 75 08             	pushl  0x8(%ebp)
  800b0b:	e8 57 02 00 00       	call   800d67 <printfmt>
  800b10:	83 c4 10             	add    $0x10,%esp
			break;
  800b13:	e9 42 02 00 00       	jmp    800d5a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 30                	mov    (%eax),%esi
  800b29:	85 f6                	test   %esi,%esi
  800b2b:	75 05                	jne    800b32 <vprintfmt+0x1a6>
				p = "(null)";
  800b2d:	be 71 26 80 00       	mov    $0x802671,%esi
			if (width > 0 && padc != '-')
  800b32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b36:	7e 6d                	jle    800ba5 <vprintfmt+0x219>
  800b38:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3c:	74 67                	je     800ba5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	50                   	push   %eax
  800b45:	56                   	push   %esi
  800b46:	e8 1e 03 00 00       	call   800e69 <strnlen>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b51:	eb 16                	jmp    800b69 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b53:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	50                   	push   %eax
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	ff d0                	call   *%eax
  800b63:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b66:	ff 4d e4             	decl   -0x1c(%ebp)
  800b69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6d:	7f e4                	jg     800b53 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6f:	eb 34                	jmp    800ba5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b71:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b75:	74 1c                	je     800b93 <vprintfmt+0x207>
  800b77:	83 fb 1f             	cmp    $0x1f,%ebx
  800b7a:	7e 05                	jle    800b81 <vprintfmt+0x1f5>
  800b7c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7f:	7e 12                	jle    800b93 <vprintfmt+0x207>
					putch('?', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 3f                	push   $0x3f
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	eb 0f                	jmp    800ba2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	53                   	push   %ebx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba5:	89 f0                	mov    %esi,%eax
  800ba7:	8d 70 01             	lea    0x1(%eax),%esi
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	0f be d8             	movsbl %al,%ebx
  800baf:	85 db                	test   %ebx,%ebx
  800bb1:	74 24                	je     800bd7 <vprintfmt+0x24b>
  800bb3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb7:	78 b8                	js     800b71 <vprintfmt+0x1e5>
  800bb9:	ff 4d e0             	decl   -0x20(%ebp)
  800bbc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc0:	79 af                	jns    800b71 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc2:	eb 13                	jmp    800bd7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 20                	push   $0x20
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bdb:	7f e7                	jg     800bc4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bdd:	e9 78 01 00 00       	jmp    800d5a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 e8             	pushl  -0x18(%ebp)
  800be8:	8d 45 14             	lea    0x14(%ebp),%eax
  800beb:	50                   	push   %eax
  800bec:	e8 3c fd ff ff       	call   80092d <getint>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c00:	85 d2                	test   %edx,%edx
  800c02:	79 23                	jns    800c27 <vprintfmt+0x29b>
				putch('-', putdat);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	6a 2d                	push   $0x2d
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1a:	f7 d8                	neg    %eax
  800c1c:	83 d2 00             	adc    $0x0,%edx
  800c1f:	f7 da                	neg    %edx
  800c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c27:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2e:	e9 bc 00 00 00       	jmp    800cef <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 e8             	pushl  -0x18(%ebp)
  800c39:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3c:	50                   	push   %eax
  800c3d:	e8 84 fc ff ff       	call   8008c6 <getuint>
  800c42:	83 c4 10             	add    $0x10,%esp
  800c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c4b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c52:	e9 98 00 00 00       	jmp    800cef <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	6a 58                	push   $0x58
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	6a 58                	push   $0x58
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	6a 58                	push   $0x58
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
			break;
  800c87:	e9 ce 00 00 00       	jmp    800d5a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	6a 30                	push   $0x30
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	ff d0                	call   *%eax
  800c99:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	6a 78                	push   $0x78
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	ff d0                	call   *%eax
  800ca9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cac:	8b 45 14             	mov    0x14(%ebp),%eax
  800caf:	83 c0 04             	add    $0x4,%eax
  800cb2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb8:	83 e8 04             	sub    $0x4,%eax
  800cbb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cce:	eb 1f                	jmp    800cef <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd6:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd9:	50                   	push   %eax
  800cda:	e8 e7 fb ff ff       	call   8008c6 <getuint>
  800cdf:	83 c4 10             	add    $0x10,%esp
  800ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cef:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	83 ec 04             	sub    $0x4,%esp
  800cf9:	52                   	push   %edx
  800cfa:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfd:	50                   	push   %eax
  800cfe:	ff 75 f4             	pushl  -0xc(%ebp)
  800d01:	ff 75 f0             	pushl  -0x10(%ebp)
  800d04:	ff 75 0c             	pushl  0xc(%ebp)
  800d07:	ff 75 08             	pushl  0x8(%ebp)
  800d0a:	e8 00 fb ff ff       	call   80080f <printnum>
  800d0f:	83 c4 20             	add    $0x20,%esp
			break;
  800d12:	eb 46                	jmp    800d5a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d14:	83 ec 08             	sub    $0x8,%esp
  800d17:	ff 75 0c             	pushl  0xc(%ebp)
  800d1a:	53                   	push   %ebx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	ff d0                	call   *%eax
  800d20:	83 c4 10             	add    $0x10,%esp
			break;
  800d23:	eb 35                	jmp    800d5a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d25:	c6 05 04 31 80 00 00 	movb   $0x0,0x803104
			break;
  800d2c:	eb 2c                	jmp    800d5a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2e:	c6 05 04 31 80 00 01 	movb   $0x1,0x803104
			break;
  800d35:	eb 23                	jmp    800d5a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d37:	83 ec 08             	sub    $0x8,%esp
  800d3a:	ff 75 0c             	pushl  0xc(%ebp)
  800d3d:	6a 25                	push   $0x25
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	ff d0                	call   *%eax
  800d44:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d47:	ff 4d 10             	decl   0x10(%ebp)
  800d4a:	eb 03                	jmp    800d4f <vprintfmt+0x3c3>
  800d4c:	ff 4d 10             	decl   0x10(%ebp)
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	48                   	dec    %eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	3c 25                	cmp    $0x25,%al
  800d57:	75 f3                	jne    800d4c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d59:	90                   	nop
		}
	}
  800d5a:	e9 35 fc ff ff       	jmp    800994 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d5f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d63:	5b                   	pop    %ebx
  800d64:	5e                   	pop    %esi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d70:	83 c0 04             	add    $0x4,%eax
  800d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7c:	50                   	push   %eax
  800d7d:	ff 75 0c             	pushl  0xc(%ebp)
  800d80:	ff 75 08             	pushl  0x8(%ebp)
  800d83:	e8 04 fc ff ff       	call   80098c <vprintfmt>
  800d88:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d8b:	90                   	nop
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 40 08             	mov    0x8(%eax),%eax
  800d97:	8d 50 01             	lea    0x1(%eax),%edx
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8b 10                	mov    (%eax),%edx
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8b 40 04             	mov    0x4(%eax),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	73 12                	jae    800dc1 <sprintputch+0x33>
		*b->buf++ = ch;
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8b 00                	mov    (%eax),%eax
  800db4:	8d 48 01             	lea    0x1(%eax),%ecx
  800db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dba:	89 0a                	mov    %ecx,(%edx)
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	88 10                	mov    %dl,(%eax)
}
  800dc1:	90                   	nop
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	01 d0                	add    %edx,%eax
  800ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de9:	74 06                	je     800df1 <vsnprintf+0x2d>
  800deb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800def:	7f 07                	jg     800df8 <vsnprintf+0x34>
		return -E_INVAL;
  800df1:	b8 03 00 00 00       	mov    $0x3,%eax
  800df6:	eb 20                	jmp    800e18 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df8:	ff 75 14             	pushl  0x14(%ebp)
  800dfb:	ff 75 10             	pushl  0x10(%ebp)
  800dfe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e01:	50                   	push   %eax
  800e02:	68 8e 0d 80 00       	push   $0x800d8e
  800e07:	e8 80 fb ff ff       	call   80098c <vprintfmt>
  800e0c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e12:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e20:	8d 45 10             	lea    0x10(%ebp),%eax
  800e23:	83 c0 04             	add    $0x4,%eax
  800e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2f:	50                   	push   %eax
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	ff 75 08             	pushl  0x8(%ebp)
  800e36:	e8 89 ff ff ff       	call   800dc4 <vsnprintf>
  800e3b:	83 c4 10             	add    $0x10,%esp
  800e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e53:	eb 06                	jmp    800e5b <strlen+0x15>
		n++;
  800e55:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e58:	ff 45 08             	incl   0x8(%ebp)
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	84 c0                	test   %al,%al
  800e62:	75 f1                	jne    800e55 <strlen+0xf>
		n++;
	return n;
  800e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e76:	eb 09                	jmp    800e81 <strnlen+0x18>
		n++;
  800e78:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7b:	ff 45 08             	incl   0x8(%ebp)
  800e7e:	ff 4d 0c             	decl   0xc(%ebp)
  800e81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e85:	74 09                	je     800e90 <strnlen+0x27>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	75 e8                	jne    800e78 <strnlen+0xf>
		n++;
	return n;
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea1:	90                   	nop
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 08             	mov    %edx,0x8(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb4:	8a 12                	mov    (%edx),%dl
  800eb6:	88 10                	mov    %dl,(%eax)
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	84 c0                	test   %al,%al
  800ebc:	75 e4                	jne    800ea2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    

00800ec3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ecf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed6:	eb 1f                	jmp    800ef7 <strncpy+0x34>
		*dst++ = *src;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8d 50 01             	lea    0x1(%eax),%edx
  800ede:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	84 c0                	test   %al,%al
  800eef:	74 03                	je     800ef4 <strncpy+0x31>
			src++;
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
  800ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efa:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efd:	72 d9                	jb     800ed8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f14:	74 30                	je     800f46 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f16:	eb 16                	jmp    800f2e <strlcpy+0x2a>
			*dst++ = *src++;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8d 50 01             	lea    0x1(%eax),%edx
  800f1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f2a:	8a 12                	mov    (%edx),%dl
  800f2c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2e:	ff 4d 10             	decl   0x10(%ebp)
  800f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f35:	74 09                	je     800f40 <strlcpy+0x3c>
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	84 c0                	test   %al,%al
  800f3e:	75 d8                	jne    800f18 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	29 c2                	sub    %eax,%edx
  800f4e:	89 d0                	mov    %edx,%eax
}
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f55:	eb 06                	jmp    800f5d <strcmp+0xb>
		p++, q++;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	84 c0                	test   %al,%al
  800f64:	74 0e                	je     800f74 <strcmp+0x22>
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 10                	mov    (%eax),%dl
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	38 c2                	cmp    %al,%dl
  800f72:	74 e3                	je     800f57 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	0f b6 d0             	movzbl %al,%edx
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	0f b6 c0             	movzbl %al,%eax
  800f84:	29 c2                	sub    %eax,%edx
  800f86:	89 d0                	mov    %edx,%eax
}
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f8d:	eb 09                	jmp    800f98 <strncmp+0xe>
		n--, p++, q++;
  800f8f:	ff 4d 10             	decl   0x10(%ebp)
  800f92:	ff 45 08             	incl   0x8(%ebp)
  800f95:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 17                	je     800fb5 <strncmp+0x2b>
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	84 c0                	test   %al,%al
  800fa5:	74 0e                	je     800fb5 <strncmp+0x2b>
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 10                	mov    (%eax),%dl
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	38 c2                	cmp    %al,%dl
  800fb3:	74 da                	je     800f8f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb9:	75 07                	jne    800fc2 <strncmp+0x38>
		return 0;
  800fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc0:	eb 14                	jmp    800fd6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f b6 d0             	movzbl %al,%edx
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f b6 c0             	movzbl %al,%eax
  800fd2:	29 c2                	sub    %eax,%edx
  800fd4:	89 d0                	mov    %edx,%eax
}
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	83 ec 04             	sub    $0x4,%esp
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe4:	eb 12                	jmp    800ff8 <strchr+0x20>
		if (*s == c)
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fee:	75 05                	jne    800ff5 <strchr+0x1d>
			return (char *) s;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	eb 11                	jmp    801006 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff5:	ff 45 08             	incl   0x8(%ebp)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	84 c0                	test   %al,%al
  800fff:	75 e5                	jne    800fe6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801014:	eb 0d                	jmp    801023 <strfind+0x1b>
		if (*s == c)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101e:	74 0e                	je     80102e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	84 c0                	test   %al,%al
  80102a:	75 ea                	jne    801016 <strfind+0xe>
  80102c:	eb 01                	jmp    80102f <strfind+0x27>
		if (*s == c)
			break;
  80102e:	90                   	nop
	return (char *) s;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801040:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801044:	76 63                	jbe    8010a9 <memset+0x75>
		uint64 data_block = c;
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	99                   	cltd   
  80104a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801056:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80105a:	c1 e0 08             	shl    $0x8,%eax
  80105d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801060:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801069:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80106d:	c1 e0 10             	shl    $0x10,%eax
  801070:	09 45 f0             	or     %eax,-0x10(%ebp)
  801073:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801079:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	b8 00 00 00 00       	mov    $0x0,%eax
  801083:	09 45 f0             	or     %eax,-0x10(%ebp)
  801086:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801089:	eb 18                	jmp    8010a3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80108b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108e:	8d 41 08             	lea    0x8(%ecx),%eax
  801091:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109a:	89 01                	mov    %eax,(%ecx)
  80109c:	89 51 04             	mov    %edx,0x4(%ecx)
  80109f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010a3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a7:	77 e2                	ja     80108b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ad:	74 23                	je     8010d2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 0e                	jmp    8010c5 <memset+0x91>
			*p8++ = (uint8)c;
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	8d 50 01             	lea    0x1(%eax),%edx
  8010bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	75 e5                	jne    8010b7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010e9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ed:	76 24                	jbe    801113 <memcpy+0x3c>
		while(n >= 8){
  8010ef:	eb 1c                	jmp    80110d <memcpy+0x36>
			*d64 = *s64;
  8010f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f4:	8b 50 04             	mov    0x4(%eax),%edx
  8010f7:	8b 00                	mov    (%eax),%eax
  8010f9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010fc:	89 01                	mov    %eax,(%ecx)
  8010fe:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801101:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801105:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801109:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80110d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801111:	77 de                	ja     8010f1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801113:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801117:	74 31                	je     80114a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801119:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80111f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801122:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801125:	eb 16                	jmp    80113d <memcpy+0x66>
			*d8++ = *s8++;
  801127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112a:	8d 50 01             	lea    0x1(%eax),%edx
  80112d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801130:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801133:	8d 4a 01             	lea    0x1(%edx),%ecx
  801136:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801139:	8a 12                	mov    (%edx),%dl
  80113b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	8d 50 ff             	lea    -0x1(%eax),%edx
  801143:	89 55 10             	mov    %edx,0x10(%ebp)
  801146:	85 c0                	test   %eax,%eax
  801148:	75 dd                	jne    801127 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801164:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801167:	73 50                	jae    8011b9 <memmove+0x6a>
  801169:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 d0                	add    %edx,%eax
  801171:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801174:	76 43                	jbe    8011b9 <memmove+0x6a>
		s += n;
  801176:	8b 45 10             	mov    0x10(%ebp),%eax
  801179:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801182:	eb 10                	jmp    801194 <memmove+0x45>
			*--d = *--s;
  801184:	ff 4d f8             	decl   -0x8(%ebp)
  801187:	ff 4d fc             	decl   -0x4(%ebp)
  80118a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118d:	8a 10                	mov    (%eax),%dl
  80118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801192:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 e3                	jne    801184 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011a1:	eb 23                	jmp    8011c6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	75 dd                	jne    8011a3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011dd:	eb 2a                	jmp    801209 <memcmp+0x3e>
		if (*s1 != *s2)
  8011df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e2:	8a 10                	mov    (%eax),%dl
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	38 c2                	cmp    %al,%dl
  8011eb:	74 16                	je     801203 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	0f b6 d0             	movzbl %al,%edx
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	0f b6 c0             	movzbl %al,%eax
  8011fd:	29 c2                	sub    %eax,%edx
  8011ff:	89 d0                	mov    %edx,%eax
  801201:	eb 18                	jmp    80121b <memcmp+0x50>
		s1++, s2++;
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120f:	89 55 10             	mov    %edx,0x10(%ebp)
  801212:	85 c0                	test   %eax,%eax
  801214:	75 c9                	jne    8011df <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801216:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801223:	8b 55 08             	mov    0x8(%ebp),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 d0                	add    %edx,%eax
  80122b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80122e:	eb 15                	jmp    801245 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	0f b6 d0             	movzbl %al,%edx
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	0f b6 c0             	movzbl %al,%eax
  80123e:	39 c2                	cmp    %eax,%edx
  801240:	74 0d                	je     80124f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801242:	ff 45 08             	incl   0x8(%ebp)
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80124b:	72 e3                	jb     801230 <memfind+0x13>
  80124d:	eb 01                	jmp    801250 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80124f:	90                   	nop
	return (void *) s;
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80125b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801262:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801269:	eb 03                	jmp    80126e <strtol+0x19>
		s++;
  80126b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	3c 20                	cmp    $0x20,%al
  801275:	74 f4                	je     80126b <strtol+0x16>
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	3c 09                	cmp    $0x9,%al
  80127e:	74 eb                	je     80126b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2b                	cmp    $0x2b,%al
  801287:	75 05                	jne    80128e <strtol+0x39>
		s++;
  801289:	ff 45 08             	incl   0x8(%ebp)
  80128c:	eb 13                	jmp    8012a1 <strtol+0x4c>
	else if (*s == '-')
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	3c 2d                	cmp    $0x2d,%al
  801295:	75 0a                	jne    8012a1 <strtol+0x4c>
		s++, neg = 1;
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a5:	74 06                	je     8012ad <strtol+0x58>
  8012a7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012ab:	75 20                	jne    8012cd <strtol+0x78>
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	3c 30                	cmp    $0x30,%al
  8012b4:	75 17                	jne    8012cd <strtol+0x78>
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	40                   	inc    %eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 78                	cmp    $0x78,%al
  8012be:	75 0d                	jne    8012cd <strtol+0x78>
		s += 2, base = 16;
  8012c0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012cb:	eb 28                	jmp    8012f5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d1:	75 15                	jne    8012e8 <strtol+0x93>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	3c 30                	cmp    $0x30,%al
  8012da:	75 0c                	jne    8012e8 <strtol+0x93>
		s++, base = 8;
  8012dc:	ff 45 08             	incl   0x8(%ebp)
  8012df:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e6:	eb 0d                	jmp    8012f5 <strtol+0xa0>
	else if (base == 0)
  8012e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ec:	75 07                	jne    8012f5 <strtol+0xa0>
		base = 10;
  8012ee:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 2f                	cmp    $0x2f,%al
  8012fc:	7e 19                	jle    801317 <strtol+0xc2>
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	3c 39                	cmp    $0x39,%al
  801305:	7f 10                	jg     801317 <strtol+0xc2>
			dig = *s - '0';
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	0f be c0             	movsbl %al,%eax
  80130f:	83 e8 30             	sub    $0x30,%eax
  801312:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801315:	eb 42                	jmp    801359 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	3c 60                	cmp    $0x60,%al
  80131e:	7e 19                	jle    801339 <strtol+0xe4>
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	3c 7a                	cmp    $0x7a,%al
  801327:	7f 10                	jg     801339 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	0f be c0             	movsbl %al,%eax
  801331:	83 e8 57             	sub    $0x57,%eax
  801334:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801337:	eb 20                	jmp    801359 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	3c 40                	cmp    $0x40,%al
  801340:	7e 39                	jle    80137b <strtol+0x126>
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	3c 5a                	cmp    $0x5a,%al
  801349:	7f 30                	jg     80137b <strtol+0x126>
			dig = *s - 'A' + 10;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	0f be c0             	movsbl %al,%eax
  801353:	83 e8 37             	sub    $0x37,%eax
  801356:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80135f:	7d 19                	jge    80137a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801361:	ff 45 08             	incl   0x8(%ebp)
  801364:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801367:	0f af 45 10          	imul   0x10(%ebp),%eax
  80136b:	89 c2                	mov    %eax,%edx
  80136d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801370:	01 d0                	add    %edx,%eax
  801372:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801375:	e9 7b ff ff ff       	jmp    8012f5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80137a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80137b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137f:	74 08                	je     801389 <strtol+0x134>
		*endptr = (char *) s;
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	8b 55 08             	mov    0x8(%ebp),%edx
  801387:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801389:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80138d:	74 07                	je     801396 <strtol+0x141>
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	f7 d8                	neg    %eax
  801394:	eb 03                	jmp    801399 <strtol+0x144>
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <ltostr>:

void
ltostr(long value, char *str)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b3:	79 13                	jns    8013c8 <ltostr+0x2d>
	{
		neg = 1;
  8013b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013c2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013d0:	99                   	cltd   
  8013d1:	f7 f9                	idiv   %ecx
  8013d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d9:	8d 50 01             	lea    0x1(%eax),%edx
  8013dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013df:	89 c2                	mov    %eax,%edx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 d0                	add    %edx,%eax
  8013e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013e9:	83 c2 30             	add    $0x30,%edx
  8013ec:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f6:	f7 e9                	imul   %ecx
  8013f8:	c1 fa 02             	sar    $0x2,%edx
  8013fb:	89 c8                	mov    %ecx,%eax
  8013fd:	c1 f8 1f             	sar    $0x1f,%eax
  801400:	29 c2                	sub    %eax,%edx
  801402:	89 d0                	mov    %edx,%eax
  801404:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80140b:	75 bb                	jne    8013c8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801417:	48                   	dec    %eax
  801418:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80141b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141f:	74 3d                	je     80145e <ltostr+0xc3>
		start = 1 ;
  801421:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801428:	eb 34                	jmp    80145e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c2                	add    %eax,%edx
  80143f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c8                	add    %ecx,%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80144b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	01 c2                	add    %eax,%edx
  801453:	8a 45 eb             	mov    -0x15(%ebp),%al
  801456:	88 02                	mov    %al,(%edx)
		start++ ;
  801458:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80145b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801461:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801464:	7c c4                	jl     80142a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801466:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 c4 f9 ff ff       	call   800e46 <strlen>
  801482:	83 c4 04             	add    $0x4,%esp
  801485:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801488:	ff 75 0c             	pushl  0xc(%ebp)
  80148b:	e8 b6 f9 ff ff       	call   800e46 <strlen>
  801490:	83 c4 04             	add    $0x4,%esp
  801493:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801496:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a4:	eb 17                	jmp    8014bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 c2                	add    %eax,%edx
  8014ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	01 c8                	add    %ecx,%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ba:	ff 45 fc             	incl   -0x4(%ebp)
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c3:	7c e1                	jl     8014a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d3:	eb 1f                	jmp    8014f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d8:	8d 50 01             	lea    0x1(%eax),%edx
  8014db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e3:	01 c2                	add    %eax,%edx
  8014e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	01 c8                	add    %ecx,%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014f1:	ff 45 f8             	incl   -0x8(%ebp)
  8014f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014fa:	7c d9                	jl     8014d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801502:	01 d0                	add    %edx,%eax
  801504:	c6 00 00             	movb   $0x0,(%eax)
}
  801507:	90                   	nop
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801516:	8b 45 14             	mov    0x14(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801522:	8b 45 10             	mov    0x10(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152d:	eb 0c                	jmp    80153b <strsplit+0x31>
			*string++ = 0;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8d 50 01             	lea    0x1(%eax),%edx
  801535:	89 55 08             	mov    %edx,0x8(%ebp)
  801538:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	84 c0                	test   %al,%al
  801542:	74 18                	je     80155c <strsplit+0x52>
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f be c0             	movsbl %al,%eax
  80154c:	50                   	push   %eax
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	e8 83 fa ff ff       	call   800fd8 <strchr>
  801555:	83 c4 08             	add    $0x8,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	75 d3                	jne    80152f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	84 c0                	test   %al,%al
  801563:	74 5a                	je     8015bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801565:	8b 45 14             	mov    0x14(%ebp),%eax
  801568:	8b 00                	mov    (%eax),%eax
  80156a:	83 f8 0f             	cmp    $0xf,%eax
  80156d:	75 07                	jne    801576 <strsplit+0x6c>
		{
			return 0;
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	eb 66                	jmp    8015dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801576:	8b 45 14             	mov    0x14(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	8d 48 01             	lea    0x1(%eax),%ecx
  80157e:	8b 55 14             	mov    0x14(%ebp),%edx
  801581:	89 0a                	mov    %ecx,(%edx)
  801583:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158a:	8b 45 10             	mov    0x10(%ebp),%eax
  80158d:	01 c2                	add    %eax,%edx
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801594:	eb 03                	jmp    801599 <strsplit+0x8f>
			string++;
  801596:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	84 c0                	test   %al,%al
  8015a0:	74 8b                	je     80152d <strsplit+0x23>
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	0f be c0             	movsbl %al,%eax
  8015aa:	50                   	push   %eax
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	e8 25 fa ff ff       	call   800fd8 <strchr>
  8015b3:	83 c4 08             	add    $0x8,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 dc                	je     801596 <strsplit+0x8c>
			string++;
	}
  8015ba:	e9 6e ff ff ff       	jmp    80152d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f1:	eb 4a                	jmp    80163d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	01 c2                	add    %eax,%edx
  8015fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	01 c8                	add    %ecx,%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801607:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160d:	01 d0                	add    %edx,%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	3c 40                	cmp    $0x40,%al
  801613:	7e 25                	jle    80163a <str2lower+0x5c>
  801615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	01 d0                	add    %edx,%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 5a                	cmp    $0x5a,%al
  801621:	7f 17                	jg     80163a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801623:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	01 d0                	add    %edx,%eax
  80162b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162e:	8b 55 08             	mov    0x8(%ebp),%edx
  801631:	01 ca                	add    %ecx,%edx
  801633:	8a 12                	mov    (%edx),%dl
  801635:	83 c2 20             	add    $0x20,%edx
  801638:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80163a:	ff 45 fc             	incl   -0x4(%ebp)
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	e8 01 f8 ff ff       	call   800e46 <strlen>
  801645:	83 c4 04             	add    $0x4,%esp
  801648:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80164b:	7f a6                	jg     8015f3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80164d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	57                   	push   %edi
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801661:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801664:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801667:	8b 7d 18             	mov    0x18(%ebp),%edi
  80166a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80166d:	cd 30                	int    $0x30
  80166f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	5b                   	pop    %ebx
  801679:	5e                   	pop    %esi
  80167a:	5f                   	pop    %edi
  80167b:	5d                   	pop    %ebp
  80167c:	c3                   	ret    

0080167d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	8b 45 10             	mov    0x10(%ebp),%eax
  801686:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801689:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80168c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	6a 00                	push   $0x0
  801695:	51                   	push   %ecx
  801696:	52                   	push   %edx
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	50                   	push   %eax
  80169b:	6a 00                	push   $0x0
  80169d:	e8 b0 ff ff ff       	call   801652 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	90                   	nop
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 02                	push   $0x2
  8016b7:	e8 96 ff ff ff       	call   801652 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 03                	push   $0x3
  8016d0:	e8 7d ff ff ff       	call   801652 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	90                   	nop
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 04                	push   $0x4
  8016ea:	e8 63 ff ff ff       	call   801652 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	90                   	nop
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	52                   	push   %edx
  801705:	50                   	push   %eax
  801706:	6a 08                	push   $0x8
  801708:	e8 45 ff ff ff       	call   801652 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	56                   	push   %esi
  801716:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801717:	8b 75 18             	mov    0x18(%ebp),%esi
  80171a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80171d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801720:	8b 55 0c             	mov    0xc(%ebp),%edx
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	51                   	push   %ecx
  801729:	52                   	push   %edx
  80172a:	50                   	push   %eax
  80172b:	6a 09                	push   $0x9
  80172d:	e8 20 ff ff ff       	call   801652 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	ff 75 08             	pushl  0x8(%ebp)
  80174a:	6a 0a                	push   $0xa
  80174c:	e8 01 ff ff ff       	call   801652 <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 0b                	push   $0xb
  801767:	e8 e6 fe ff ff       	call   801652 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 0c                	push   $0xc
  801780:	e8 cd fe ff ff       	call   801652 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 0d                	push   $0xd
  801799:	e8 b4 fe ff ff       	call   801652 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 0e                	push   $0xe
  8017b2:	e8 9b fe ff ff       	call   801652 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 0f                	push   $0xf
  8017cb:	e8 82 fe ff ff       	call   801652 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	6a 10                	push   $0x10
  8017e5:	e8 68 fe ff ff       	call   801652 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 11                	push   $0x11
  8017fe:	e8 4f fe ff ff       	call   801652 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	90                   	nop
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_cputc>:

void
sys_cputc(const char c)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801815:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	50                   	push   %eax
  801822:	6a 01                	push   $0x1
  801824:	e8 29 fe ff ff       	call   801652 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 14                	push   $0x14
  80183e:	e8 0f fe ff ff       	call   801652 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	90                   	nop
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	8b 45 10             	mov    0x10(%ebp),%eax
  801852:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801855:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801858:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	51                   	push   %ecx
  801862:	52                   	push   %edx
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	50                   	push   %eax
  801867:	6a 15                	push   $0x15
  801869:	e8 e4 fd ff ff       	call   801652 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	6a 16                	push   $0x16
  801886:	e8 c7 fd ff ff       	call   801652 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801893:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	51                   	push   %ecx
  8018a1:	52                   	push   %edx
  8018a2:	50                   	push   %eax
  8018a3:	6a 17                	push   $0x17
  8018a5:	e8 a8 fd ff ff       	call   801652 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	6a 18                	push   $0x18
  8018c2:	e8 8b fd ff ff       	call   801652 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	ff 75 14             	pushl  0x14(%ebp)
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	50                   	push   %eax
  8018de:	6a 19                	push   $0x19
  8018e0:	e8 6d fd ff ff       	call   801652 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	50                   	push   %eax
  8018f9:	6a 1a                	push   $0x1a
  8018fb:	e8 52 fd ff ff       	call   801652 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	50                   	push   %eax
  801915:	6a 1b                	push   $0x1b
  801917:	e8 36 fd ff ff       	call   801652 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 05                	push   $0x5
  801930:	e8 1d fd ff ff       	call   801652 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 06                	push   $0x6
  801949:	e8 04 fd ff ff       	call   801652 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 07                	push   $0x7
  801962:	e8 eb fc ff ff       	call   801652 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_exit_env>:


void sys_exit_env(void)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 1c                	push   $0x1c
  80197b:	e8 d2 fc ff ff       	call   801652 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80198c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80198f:	8d 50 04             	lea    0x4(%eax),%edx
  801992:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 1d                	push   $0x1d
  80199f:	e8 ae fc ff ff       	call   801652 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b0:	89 01                	mov    %eax,(%ecx)
  8019b2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	c9                   	leave  
  8019b9:	c2 04 00             	ret    $0x4

008019bc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 13                	push   $0x13
  8019ce:	e8 7f fc ff ff       	call   801652 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 1e                	push   $0x1e
  8019e8:	e8 65 fc ff ff       	call   801652 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019fe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	50                   	push   %eax
  801a0b:	6a 1f                	push   $0x1f
  801a0d:	e8 40 fc ff ff       	call   801652 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return ;
  801a15:	90                   	nop
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <rsttst>:
void rsttst()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 21                	push   $0x21
  801a27:	e8 26 fc ff ff       	call   801652 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a3e:	8b 55 18             	mov    0x18(%ebp),%edx
  801a41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a45:	52                   	push   %edx
  801a46:	50                   	push   %eax
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 20                	push   $0x20
  801a52:	e8 fb fb ff ff       	call   801652 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <chktst>:
void chktst(uint32 n)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	6a 22                	push   $0x22
  801a6d:	e8 e0 fb ff ff       	call   801652 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
	return ;
  801a75:	90                   	nop
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <inctst>:

void inctst()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 23                	push   $0x23
  801a87:	e8 c6 fb ff ff       	call   801652 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8f:	90                   	nop
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <gettst>:
uint32 gettst()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 24                	push   $0x24
  801aa1:	e8 ac fb ff ff       	call   801652 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 25                	push   $0x25
  801aba:	e8 93 fb ff ff       	call   801652 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
  801ac2:	a3 40 71 82 00       	mov    %eax,0x827140
	return uheapPlaceStrategy ;
  801ac7:	a1 40 71 82 00       	mov    0x827140,%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	a3 40 71 82 00       	mov    %eax,0x827140
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	6a 26                	push   $0x26
  801ae6:	e8 67 fb ff ff       	call   801652 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
	return ;
  801aee:	90                   	nop
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801af5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	53                   	push   %ebx
  801b04:	51                   	push   %ecx
  801b05:	52                   	push   %edx
  801b06:	50                   	push   %eax
  801b07:	6a 27                	push   $0x27
  801b09:	e8 44 fb ff ff       	call   801652 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 28                	push   $0x28
  801b29:	e8 24 fb ff ff       	call   801652 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b36:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	51                   	push   %ecx
  801b42:	ff 75 10             	pushl  0x10(%ebp)
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 29                	push   $0x29
  801b49:	e8 04 fb ff ff       	call   801652 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 10             	pushl  0x10(%ebp)
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	ff 75 08             	pushl  0x8(%ebp)
  801b63:	6a 12                	push   $0x12
  801b65:	e8 e8 fa ff ff       	call   801652 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 2a                	push   $0x2a
  801b83:	e8 ca fa ff ff       	call   801652 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
	return;
  801b8b:	90                   	nop
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 2b                	push   $0x2b
  801b9d:	e8 b0 fa ff ff       	call   801652 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	6a 2d                	push   $0x2d
  801bb8:	e8 95 fa ff ff       	call   801652 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 2c                	push   $0x2c
  801bd4:	e8 79 fa ff ff       	call   801652 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdc:	90                   	nop
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	52                   	push   %edx
  801bef:	50                   	push   %eax
  801bf0:	6a 2e                	push   $0x2e
  801bf2:	e8 5b fa ff ff       	call   801652 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    
  801bfd:	66 90                	xchg   %ax,%ax
  801bff:	90                   	nop

00801c00 <__udivdi3>:
  801c00:	55                   	push   %ebp
  801c01:	57                   	push   %edi
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 1c             	sub    $0x1c,%esp
  801c07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c17:	89 ca                	mov    %ecx,%edx
  801c19:	89 f8                	mov    %edi,%eax
  801c1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c1f:	85 f6                	test   %esi,%esi
  801c21:	75 2d                	jne    801c50 <__udivdi3+0x50>
  801c23:	39 cf                	cmp    %ecx,%edi
  801c25:	77 65                	ja     801c8c <__udivdi3+0x8c>
  801c27:	89 fd                	mov    %edi,%ebp
  801c29:	85 ff                	test   %edi,%edi
  801c2b:	75 0b                	jne    801c38 <__udivdi3+0x38>
  801c2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c32:	31 d2                	xor    %edx,%edx
  801c34:	f7 f7                	div    %edi
  801c36:	89 c5                	mov    %eax,%ebp
  801c38:	31 d2                	xor    %edx,%edx
  801c3a:	89 c8                	mov    %ecx,%eax
  801c3c:	f7 f5                	div    %ebp
  801c3e:	89 c1                	mov    %eax,%ecx
  801c40:	89 d8                	mov    %ebx,%eax
  801c42:	f7 f5                	div    %ebp
  801c44:	89 cf                	mov    %ecx,%edi
  801c46:	89 fa                	mov    %edi,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	39 ce                	cmp    %ecx,%esi
  801c52:	77 28                	ja     801c7c <__udivdi3+0x7c>
  801c54:	0f bd fe             	bsr    %esi,%edi
  801c57:	83 f7 1f             	xor    $0x1f,%edi
  801c5a:	75 40                	jne    801c9c <__udivdi3+0x9c>
  801c5c:	39 ce                	cmp    %ecx,%esi
  801c5e:	72 0a                	jb     801c6a <__udivdi3+0x6a>
  801c60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c64:	0f 87 9e 00 00 00    	ja     801d08 <__udivdi3+0x108>
  801c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6f:	89 fa                	mov    %edi,%edx
  801c71:	83 c4 1c             	add    $0x1c,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
  801c79:	8d 76 00             	lea    0x0(%esi),%esi
  801c7c:	31 ff                	xor    %edi,%edi
  801c7e:	31 c0                	xor    %eax,%eax
  801c80:	89 fa                	mov    %edi,%edx
  801c82:	83 c4 1c             	add    $0x1c,%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5f                   	pop    %edi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	89 d8                	mov    %ebx,%eax
  801c8e:	f7 f7                	div    %edi
  801c90:	31 ff                	xor    %edi,%edi
  801c92:	89 fa                	mov    %edi,%edx
  801c94:	83 c4 1c             	add    $0x1c,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
  801c9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ca1:	89 eb                	mov    %ebp,%ebx
  801ca3:	29 fb                	sub    %edi,%ebx
  801ca5:	89 f9                	mov    %edi,%ecx
  801ca7:	d3 e6                	shl    %cl,%esi
  801ca9:	89 c5                	mov    %eax,%ebp
  801cab:	88 d9                	mov    %bl,%cl
  801cad:	d3 ed                	shr    %cl,%ebp
  801caf:	89 e9                	mov    %ebp,%ecx
  801cb1:	09 f1                	or     %esi,%ecx
  801cb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cb7:	89 f9                	mov    %edi,%ecx
  801cb9:	d3 e0                	shl    %cl,%eax
  801cbb:	89 c5                	mov    %eax,%ebp
  801cbd:	89 d6                	mov    %edx,%esi
  801cbf:	88 d9                	mov    %bl,%cl
  801cc1:	d3 ee                	shr    %cl,%esi
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	d3 e2                	shl    %cl,%edx
  801cc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ccb:	88 d9                	mov    %bl,%cl
  801ccd:	d3 e8                	shr    %cl,%eax
  801ccf:	09 c2                	or     %eax,%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	89 f2                	mov    %esi,%edx
  801cd5:	f7 74 24 0c          	divl   0xc(%esp)
  801cd9:	89 d6                	mov    %edx,%esi
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	f7 e5                	mul    %ebp
  801cdf:	39 d6                	cmp    %edx,%esi
  801ce1:	72 19                	jb     801cfc <__udivdi3+0xfc>
  801ce3:	74 0b                	je     801cf0 <__udivdi3+0xf0>
  801ce5:	89 d8                	mov    %ebx,%eax
  801ce7:	31 ff                	xor    %edi,%edi
  801ce9:	e9 58 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cf4:	89 f9                	mov    %edi,%ecx
  801cf6:	d3 e2                	shl    %cl,%edx
  801cf8:	39 c2                	cmp    %eax,%edx
  801cfa:	73 e9                	jae    801ce5 <__udivdi3+0xe5>
  801cfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cff:	31 ff                	xor    %edi,%edi
  801d01:	e9 40 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	31 c0                	xor    %eax,%eax
  801d0a:	e9 37 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801d0f:	90                   	nop

00801d10 <__umoddi3>:
  801d10:	55                   	push   %ebp
  801d11:	57                   	push   %edi
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
  801d17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d2f:	89 f3                	mov    %esi,%ebx
  801d31:	89 fa                	mov    %edi,%edx
  801d33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d37:	89 34 24             	mov    %esi,(%esp)
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	75 1a                	jne    801d58 <__umoddi3+0x48>
  801d3e:	39 f7                	cmp    %esi,%edi
  801d40:	0f 86 a2 00 00 00    	jbe    801de8 <__umoddi3+0xd8>
  801d46:	89 c8                	mov    %ecx,%eax
  801d48:	89 f2                	mov    %esi,%edx
  801d4a:	f7 f7                	div    %edi
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	31 d2                	xor    %edx,%edx
  801d50:	83 c4 1c             	add    $0x1c,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
  801d58:	39 f0                	cmp    %esi,%eax
  801d5a:	0f 87 ac 00 00 00    	ja     801e0c <__umoddi3+0xfc>
  801d60:	0f bd e8             	bsr    %eax,%ebp
  801d63:	83 f5 1f             	xor    $0x1f,%ebp
  801d66:	0f 84 ac 00 00 00    	je     801e18 <__umoddi3+0x108>
  801d6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d71:	29 ef                	sub    %ebp,%edi
  801d73:	89 fe                	mov    %edi,%esi
  801d75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d79:	89 e9                	mov    %ebp,%ecx
  801d7b:	d3 e0                	shl    %cl,%eax
  801d7d:	89 d7                	mov    %edx,%edi
  801d7f:	89 f1                	mov    %esi,%ecx
  801d81:	d3 ef                	shr    %cl,%edi
  801d83:	09 c7                	or     %eax,%edi
  801d85:	89 e9                	mov    %ebp,%ecx
  801d87:	d3 e2                	shl    %cl,%edx
  801d89:	89 14 24             	mov    %edx,(%esp)
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	d3 e0                	shl    %cl,%eax
  801d90:	89 c2                	mov    %eax,%edx
  801d92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d96:	d3 e0                	shl    %cl,%eax
  801d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da0:	89 f1                	mov    %esi,%ecx
  801da2:	d3 e8                	shr    %cl,%eax
  801da4:	09 d0                	or     %edx,%eax
  801da6:	d3 eb                	shr    %cl,%ebx
  801da8:	89 da                	mov    %ebx,%edx
  801daa:	f7 f7                	div    %edi
  801dac:	89 d3                	mov    %edx,%ebx
  801dae:	f7 24 24             	mull   (%esp)
  801db1:	89 c6                	mov    %eax,%esi
  801db3:	89 d1                	mov    %edx,%ecx
  801db5:	39 d3                	cmp    %edx,%ebx
  801db7:	0f 82 87 00 00 00    	jb     801e44 <__umoddi3+0x134>
  801dbd:	0f 84 91 00 00 00    	je     801e54 <__umoddi3+0x144>
  801dc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dc7:	29 f2                	sub    %esi,%edx
  801dc9:	19 cb                	sbb    %ecx,%ebx
  801dcb:	89 d8                	mov    %ebx,%eax
  801dcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dd1:	d3 e0                	shl    %cl,%eax
  801dd3:	89 e9                	mov    %ebp,%ecx
  801dd5:	d3 ea                	shr    %cl,%edx
  801dd7:	09 d0                	or     %edx,%eax
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	d3 eb                	shr    %cl,%ebx
  801ddd:	89 da                	mov    %ebx,%edx
  801ddf:	83 c4 1c             	add    $0x1c,%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5f                   	pop    %edi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    
  801de7:	90                   	nop
  801de8:	89 fd                	mov    %edi,%ebp
  801dea:	85 ff                	test   %edi,%edi
  801dec:	75 0b                	jne    801df9 <__umoddi3+0xe9>
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	31 d2                	xor    %edx,%edx
  801df5:	f7 f7                	div    %edi
  801df7:	89 c5                	mov    %eax,%ebp
  801df9:	89 f0                	mov    %esi,%eax
  801dfb:	31 d2                	xor    %edx,%edx
  801dfd:	f7 f5                	div    %ebp
  801dff:	89 c8                	mov    %ecx,%eax
  801e01:	f7 f5                	div    %ebp
  801e03:	89 d0                	mov    %edx,%eax
  801e05:	e9 44 ff ff ff       	jmp    801d4e <__umoddi3+0x3e>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	89 c8                	mov    %ecx,%eax
  801e0e:	89 f2                	mov    %esi,%edx
  801e10:	83 c4 1c             	add    $0x1c,%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    
  801e18:	3b 04 24             	cmp    (%esp),%eax
  801e1b:	72 06                	jb     801e23 <__umoddi3+0x113>
  801e1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e21:	77 0f                	ja     801e32 <__umoddi3+0x122>
  801e23:	89 f2                	mov    %esi,%edx
  801e25:	29 f9                	sub    %edi,%ecx
  801e27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e2b:	89 14 24             	mov    %edx,(%esp)
  801e2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e36:	8b 14 24             	mov    (%esp),%edx
  801e39:	83 c4 1c             	add    $0x1c,%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5e                   	pop    %esi
  801e3e:	5f                   	pop    %edi
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    
  801e41:	8d 76 00             	lea    0x0(%esi),%esi
  801e44:	2b 04 24             	sub    (%esp),%eax
  801e47:	19 fa                	sbb    %edi,%edx
  801e49:	89 d1                	mov    %edx,%ecx
  801e4b:	89 c6                	mov    %eax,%esi
  801e4d:	e9 71 ff ff ff       	jmp    801dc3 <__umoddi3+0xb3>
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e58:	72 ea                	jb     801e44 <__umoddi3+0x134>
  801e5a:	89 d9                	mov    %ebx,%ecx
  801e5c:	e9 62 ff ff ff       	jmp    801dc3 <__umoddi3+0xb3>
