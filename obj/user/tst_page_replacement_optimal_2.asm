
obj/user/tst_page_replacement_optimal_2:     file format elf32-i386


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
  800031:	e8 c9 02 00 00       	call   8002ff <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 expectedRefStream[EXPECTED_REF_CNT] = {
		0xeebf1000, 0xeebfb000, 0xeebfc000, 0xeebf2000, 0xeebf3000, 0xeebf4000,
		0xeebf5000, 0xeebf6000, 0xeebf7000, 0xeebf8000, 0xeebf9000, 0xeebfa000
} ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c c1 00 00    	sub    $0xc10c,%esp
	char __arr__[PAGE_SIZE*12];

	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

	int freePages = sys_calculate_free_frames();
  800044:	e8 58 17 00 00       	call   8017a1 <sys_calculate_free_frames>
  800049:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80004c:	e8 9b 17 00 00       	call   8017ec <sys_pf_calculate_allocated_pages>
  800051:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Writing (Modified)
	__arr__[PAGE_SIZE*10-1] = 'a' ;
  800054:	c6 85 cb df ff ff 61 	movb   $0x61,-0x2035(%ebp)

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  80005b:	8a 85 cb ef ff ff    	mov    -0x1035(%ebp),%al
  800061:	88 45 d7             	mov    %al,-0x29(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  800064:	8a 45 cb             	mov    -0x35(%ebp),%al
  800067:	88 45 d6             	mov    %al,-0x2a(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80006a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800071:	eb 29                	jmp    80009c <_main+0x64>
	{
		__arr__[i] = -1 ;
  800073:	8d 95 cc 3f ff ff    	lea    -0xc034(%ebp),%edx
  800079:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ ;
  800081:	a1 00 30 80 00       	mov    0x803000,%eax
  800086:	8a 00                	mov    (%eax),%al
  800088:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *__ptr2__ ;
  80008b:	a1 04 30 80 00       	mov    0x803004,%eax
  800090:	8a 00                	mov    (%eax),%al
  800092:	88 45 e6             	mov    %al,-0x1a(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800095:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  80009c:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  8000a3:	7e ce                	jle    800073 <_main+0x3b>
		garbage5 = *__ptr2__ ;
	}

	//===================

	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
  8000a5:	83 ec 08             	sub    $0x8,%esp
  8000a8:	68 a0 1e 80 00       	push   $0x801ea0
  8000ad:	6a 03                	push   $0x3
  8000af:	e8 16 07 00 00       	call   8007ca <cprintf_colored>
  8000b4:	83 c4 10             	add    $0x10,%esp
	{
		if (garbage4 != *__ptr__) panic("test failed!");
  8000b7:	a1 00 30 80 00       	mov    0x803000,%eax
  8000bc:	8a 00                	mov    (%eax),%al
  8000be:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 b9 1e 80 00       	push   $0x801eb9
  8000cb:	6a 31                	push   $0x31
  8000cd:	68 c8 1e 80 00       	push   $0x801ec8
  8000d2:	e8 d8 03 00 00       	call   8004af <_panic>
		if (garbage5 != *__ptr2__) panic("test failed!");
  8000d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000dc:	8a 00                	mov    (%eax),%al
  8000de:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8000e1:	74 14                	je     8000f7 <_main+0xbf>
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	68 b9 1e 80 00       	push   $0x801eb9
  8000eb:	6a 32                	push   $0x32
  8000ed:	68 c8 1e 80 00       	push   $0x801ec8
  8000f2:	e8 b8 03 00 00       	call   8004af <_panic>
		if(__arr__[PAGE_SIZE*10-1] != 'a') panic("test failed!");
  8000f7:	8a 85 cb df ff ff    	mov    -0x2035(%ebp),%al
  8000fd:	3c 61                	cmp    $0x61,%al
  8000ff:	74 14                	je     800115 <_main+0xdd>
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	68 b9 1e 80 00       	push   $0x801eb9
  800109:	6a 33                	push   $0x33
  80010b:	68 c8 1e 80 00       	push   $0x801ec8
  800110:	e8 9a 03 00 00       	call   8004af <_panic>
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800115:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80011c:	eb 2c                	jmp    80014a <_main+0x112>
		{
			if(__arr__[i] != -1) panic("test failed!");
  80011e:	8d 95 cc 3f ff ff    	lea    -0xc034(%ebp),%edx
  800124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800127:	01 d0                	add    %edx,%eax
  800129:	8a 00                	mov    (%eax),%al
  80012b:	3c ff                	cmp    $0xff,%al
  80012d:	74 14                	je     800143 <_main+0x10b>
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	68 b9 1e 80 00       	push   $0x801eb9
  800137:	6a 36                	push   $0x36
  800139:	68 c8 1e 80 00       	push   $0x801ec8
  80013e:	e8 6c 03 00 00       	call   8004af <_panic>
	cprintf_colored(TEXT_cyan, "%~\nChecking Content... \n");
	{
		if (garbage4 != *__ptr__) panic("test failed!");
		if (garbage5 != *__ptr2__) panic("test failed!");
		if(__arr__[PAGE_SIZE*10-1] != 'a') panic("test failed!");
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800143:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  80014a:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800151:	7e cb                	jle    80011e <_main+0xe6>
		{
			if(__arr__[i] != -1) panic("test failed!");
		}
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking EXPECTED REFERENCE STREAM... \n");
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 f0 1e 80 00       	push   $0x801ef0
  80015b:	6a 03                	push   $0x3
  80015d:	e8 68 06 00 00       	call   8007ca <cprintf_colored>
  800162:	83 c4 10             	add    $0x10,%esp
	{
		char separator[2] = "@";
  800165:	66 c7 85 c6 3f ff ff 	movw   $0x40,-0xc03a(%ebp)
  80016c:	40 00 
		char checkRefStreamCmd[100] = "__CheckRefStream@";
  80016e:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  800174:	bb 71 20 80 00       	mov    $0x802071,%ebx
  800179:	ba 12 00 00 00       	mov    $0x12,%edx
  80017e:	89 c7                	mov    %eax,%edi
  800180:	89 de                	mov    %ebx,%esi
  800182:	89 d1                	mov    %edx,%ecx
  800184:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800186:	8d 95 fc 3e ff ff    	lea    -0xc104(%ebp),%edx
  80018c:	b9 52 00 00 00       	mov    $0x52,%ecx
  800191:	b0 00                	mov    $0x0,%al
  800193:	89 d7                	mov    %edx,%edi
  800195:	f3 aa                	rep stos %al,%es:(%edi)
		char token[20] ;
		char cmdWithCnt[100] ;
		ltostr(EXPECTED_REF_CNT, token);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001a0:	50                   	push   %eax
  8001a1:	6a 0c                	push   $0xc
  8001a3:	e8 23 12 00 00       	call   8013cb <ltostr>
  8001a8:	83 c4 10             	add    $0x10,%esp
		strcconcat(checkRefStreamCmd, token, cmdWithCnt);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	8d 85 ea 3e ff ff    	lea    -0xc116(%ebp),%eax
  8001c2:	50                   	push   %eax
  8001c3:	e8 dc 12 00 00       	call   8014a4 <strcconcat>
  8001c8:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  8001db:	50                   	push   %eax
  8001dc:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 bc 12 00 00       	call   8014a4 <strcconcat>
  8001e8:	83 c4 10             	add    $0x10,%esp
		ltostr((uint32)&expectedRefStream, token);
  8001eb:	ba 20 30 80 00       	mov    $0x803020,%edx
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	52                   	push   %edx
  8001fb:	e8 cb 11 00 00       	call   8013cb <ltostr>
  800200:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, token, cmdWithCnt);
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	8d 85 b2 3f ff ff    	lea    -0xc04e(%ebp),%eax
  800213:	50                   	push   %eax
  800214:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80021a:	50                   	push   %eax
  80021b:	e8 84 12 00 00       	call   8014a4 <strcconcat>
  800220:	83 c4 10             	add    $0x10,%esp
		strcconcat(cmdWithCnt, separator, cmdWithCnt);
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80022c:	50                   	push   %eax
  80022d:	8d 85 c6 3f ff ff    	lea    -0xc03a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80023a:	50                   	push   %eax
  80023b:	e8 64 12 00 00       	call   8014a4 <strcconcat>
  800240:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("%~Ref Command = %s\n", cmdWithCnt);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80024c:	50                   	push   %eax
  80024d:	68 1b 1f 80 00       	push   $0x801f1b
  800252:	e8 b8 05 00 00       	call   80080f <atomic_cprintf>
  800257:	83 c4 10             	add    $0x10,%esp

		sys_utilities(cmdWithCnt, (uint32)&found);
  80025a:	8d 85 c8 3f ff ff    	lea    -0xc038(%ebp),%eax
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	50                   	push   %eax
  800264:	8d 85 4e 3f ff ff    	lea    -0xc0b2(%ebp),%eax
  80026a:	50                   	push   %eax
  80026b:	e8 30 19 00 00       	call   801ba0 <sys_utilities>
  800270:	83 c4 10             	add    $0x10,%esp

		//if (found != 1) panic("OPTIMAL alg. failed.. unexpected page reference stream!");
	}
	cprintf_colored(TEXT_cyan, "%~\nChecking Allocation in Mem & Page File... \n");
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	68 30 1f 80 00       	push   $0x801f30
  80027b:	6a 03                	push   $0x3
  80027d:	e8 48 05 00 00       	call   8007ca <cprintf_colored>
  800282:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800285:	e8 62 15 00 00       	call   8017ec <sys_pf_calculate_allocated_pages>
  80028a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80028d:	74 14                	je     8002a3 <_main+0x26b>
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	68 60 1f 80 00       	push   $0x801f60
  800297:	6a 4e                	push   $0x4e
  800299:	68 c8 1e 80 00       	push   $0x801ec8
  80029e:	e8 0c 02 00 00       	call   8004af <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8002a3:	e8 f9 14 00 00       	call   8017a1 <sys_calculate_free_frames>
  8002a8:	89 c3                	mov    %eax,%ebx
  8002aa:	e8 0b 15 00 00       	call   8017ba <sys_calculate_modified_frames>
  8002af:	01 d8                	add    %ebx,%eax
  8002b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int expectedNumOfFrames = 11;
  8002b4:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)
		if( (freePages - freePagesAfter) != expectedNumOfFrames)
  8002bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002be:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8002c4:	74 1e                	je     8002e4 <_main+0x2ac>
			panic("Unexpected number of allocated frames in RAM. Expected = %d, Actual = %d", expectedNumOfFrames, (freePages - freePagesAfter));
  8002c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	ff 75 cc             	pushl  -0x34(%ebp)
  8002d3:	68 cc 1f 80 00       	push   $0x801fcc
  8002d8:	6a 53                	push   $0x53
  8002da:	68 c8 1e 80 00       	push   $0x801ec8
  8002df:	e8 cb 01 00 00       	call   8004af <_panic>
	}

	cprintf_colored(TEXT_light_green, "%~\nCongratulations!! test PAGE replacement #2 [OPTIMAL Alg.] is completed successfully.\n");
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	68 18 20 80 00       	push   $0x802018
  8002ec:	6a 0a                	push   $0xa
  8002ee:	e8 d7 04 00 00       	call   8007ca <cprintf_colored>
  8002f3:	83 c4 10             	add    $0x10,%esp
	return;
  8002f6:	90                   	nop
}
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	57                   	push   %edi
  800303:	56                   	push   %esi
  800304:	53                   	push   %ebx
  800305:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800308:	e8 5d 16 00 00       	call   80196a <sys_getenvindex>
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800310:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800313:	89 d0                	mov    %edx,%eax
  800315:	01 c0                	add    %eax,%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	c1 e0 02             	shl    $0x2,%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c1 e0 02             	shl    $0x2,%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	c1 e0 03             	shl    $0x3,%eax
  800326:	01 d0                	add    %edx,%eax
  800328:	c1 e0 02             	shl    $0x2,%eax
  80032b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800330:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800335:	a1 60 30 80 00       	mov    0x803060,%eax
  80033a:	8a 40 20             	mov    0x20(%eax),%al
  80033d:	84 c0                	test   %al,%al
  80033f:	74 0d                	je     80034e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800341:	a1 60 30 80 00       	mov    0x803060,%eax
  800346:	83 c0 20             	add    $0x20,%eax
  800349:	a3 54 30 80 00       	mov    %eax,0x803054

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80034e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800352:	7e 0a                	jle    80035e <libmain+0x5f>
		binaryname = argv[0];
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	a3 54 30 80 00       	mov    %eax,0x803054

	// call user main routine
	_main(argc, argv);
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 0c             	pushl  0xc(%ebp)
  800364:	ff 75 08             	pushl  0x8(%ebp)
  800367:	e8 cc fc ff ff       	call   800038 <_main>
  80036c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80036f:	a1 50 30 80 00       	mov    0x803050,%eax
  800374:	85 c0                	test   %eax,%eax
  800376:	0f 84 01 01 00 00    	je     80047d <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80037c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800382:	bb d0 21 80 00       	mov    $0x8021d0,%ebx
  800387:	ba 0e 00 00 00       	mov    $0xe,%edx
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	89 de                	mov    %ebx,%esi
  800390:	89 d1                	mov    %edx,%ecx
  800392:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800394:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800397:	b9 56 00 00 00       	mov    $0x56,%ecx
  80039c:	b0 00                	mov    $0x0,%al
  80039e:	89 d7                	mov    %edx,%edi
  8003a0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003ac:	83 ec 08             	sub    $0x8,%esp
  8003af:	50                   	push   %eax
  8003b0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003b6:	50                   	push   %eax
  8003b7:	e8 e4 17 00 00       	call   801ba0 <sys_utilities>
  8003bc:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003bf:	e8 2d 13 00 00       	call   8016f1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003c4:	83 ec 0c             	sub    $0xc,%esp
  8003c7:	68 f0 20 80 00       	push   $0x8020f0
  8003cc:	e8 cc 03 00 00       	call   80079d <cprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d7:	85 c0                	test   %eax,%eax
  8003d9:	74 18                	je     8003f3 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003db:	e8 de 17 00 00       	call   801bbe <sys_get_optimal_num_faults>
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	50                   	push   %eax
  8003e4:	68 18 21 80 00       	push   $0x802118
  8003e9:	e8 af 03 00 00       	call   80079d <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	eb 59                	jmp    80044c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f3:	a1 60 30 80 00       	mov    0x803060,%eax
  8003f8:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003fe:	a1 60 30 80 00       	mov    0x803060,%eax
  800403:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	52                   	push   %edx
  80040d:	50                   	push   %eax
  80040e:	68 3c 21 80 00       	push   $0x80213c
  800413:	e8 85 03 00 00       	call   80079d <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80041b:	a1 60 30 80 00       	mov    0x803060,%eax
  800420:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800426:	a1 60 30 80 00       	mov    0x803060,%eax
  80042b:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800431:	a1 60 30 80 00       	mov    0x803060,%eax
  800436:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80043c:	51                   	push   %ecx
  80043d:	52                   	push   %edx
  80043e:	50                   	push   %eax
  80043f:	68 64 21 80 00       	push   $0x802164
  800444:	e8 54 03 00 00       	call   80079d <cprintf>
  800449:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044c:	a1 60 30 80 00       	mov    0x803060,%eax
  800451:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	50                   	push   %eax
  80045b:	68 bc 21 80 00       	push   $0x8021bc
  800460:	e8 38 03 00 00       	call   80079d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	68 f0 20 80 00       	push   $0x8020f0
  800470:	e8 28 03 00 00       	call   80079d <cprintf>
  800475:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800478:	e8 8e 12 00 00       	call   80170b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80047d:	e8 1f 00 00 00       	call   8004a1 <exit>
}
  800482:	90                   	nop
  800483:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800486:	5b                   	pop    %ebx
  800487:	5e                   	pop    %esi
  800488:	5f                   	pop    %edi
  800489:	5d                   	pop    %ebp
  80048a:	c3                   	ret    

0080048b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800491:	83 ec 0c             	sub    $0xc,%esp
  800494:	6a 00                	push   $0x0
  800496:	e8 9b 14 00 00       	call   801936 <sys_destroy_env>
  80049b:	83 c4 10             	add    $0x10,%esp
}
  80049e:	90                   	nop
  80049f:	c9                   	leave  
  8004a0:	c3                   	ret    

008004a1 <exit>:

void
exit(void)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004a7:	e8 f0 14 00 00       	call   80199c <sys_exit_env>
}
  8004ac:	90                   	nop
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b8:	83 c0 04             	add    $0x4,%eax
  8004bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004be:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	74 16                	je     8004dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004c7:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	50                   	push   %eax
  8004d0:	68 34 22 80 00       	push   $0x802234
  8004d5:	e8 c3 02 00 00       	call   80079d <cprintf>
  8004da:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004dd:	a1 54 30 80 00       	mov    0x803054,%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	50                   	push   %eax
  8004ec:	68 3c 22 80 00       	push   $0x80223c
  8004f1:	6a 74                	push   $0x74
  8004f3:	e8 d2 02 00 00       	call   8007ca <cprintf_colored>
  8004f8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	ff 75 f4             	pushl  -0xc(%ebp)
  800504:	50                   	push   %eax
  800505:	e8 24 02 00 00       	call   80072e <vcprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	6a 00                	push   $0x0
  800512:	68 64 22 80 00       	push   $0x802264
  800517:	e8 12 02 00 00       	call   80072e <vcprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80051f:	e8 7d ff ff ff       	call   8004a1 <exit>

	// should not return here
	while (1) ;
  800524:	eb fe                	jmp    800524 <_panic+0x75>

00800526 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	53                   	push   %ebx
  80052a:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80052d:	a1 60 30 80 00       	mov    0x803060,%eax
  800532:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	74 14                	je     800553 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 68 22 80 00       	push   $0x802268
  800547:	6a 26                	push   $0x26
  800549:	68 b4 22 80 00       	push   $0x8022b4
  80054e:	e8 5c ff ff ff       	call   8004af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800553:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800561:	e9 d9 00 00 00       	jmp    80063f <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800569:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	01 d0                	add    %edx,%eax
  800575:	8b 00                	mov    (%eax),%eax
  800577:	85 c0                	test   %eax,%eax
  800579:	75 08                	jne    800583 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80057b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80057e:	e9 b9 00 00 00       	jmp    80063c <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800583:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800591:	eb 79                	jmp    80060c <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800593:	a1 60 30 80 00       	mov    0x803060,%eax
  800598:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80059e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	01 c0                	add    %eax,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005ae:	01 d8                	add    %ebx,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	01 c8                	add    %ecx,%eax
  8005b4:	8a 40 04             	mov    0x4(%eax),%al
  8005b7:	84 c0                	test   %al,%al
  8005b9:	75 4e                	jne    800609 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005bb:	a1 60 30 80 00       	mov    0x803060,%eax
  8005c0:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c9:	89 d0                	mov    %edx,%eax
  8005cb:	01 c0                	add    %eax,%eax
  8005cd:	01 d0                	add    %edx,%eax
  8005cf:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005d6:	01 d8                	add    %ebx,%eax
  8005d8:	01 d0                	add    %edx,%eax
  8005da:	01 c8                	add    %ecx,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ee:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	01 c8                	add    %ecx,%eax
  8005fa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005fc:	39 c2                	cmp    %eax,%edx
  8005fe:	75 09                	jne    800609 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800600:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800607:	eb 19                	jmp    800622 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800609:	ff 45 e8             	incl   -0x18(%ebp)
  80060c:	a1 60 30 80 00       	mov    0x803060,%eax
  800611:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80061a:	39 c2                	cmp    %eax,%edx
  80061c:	0f 87 71 ff ff ff    	ja     800593 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800622:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800626:	75 14                	jne    80063c <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	68 c0 22 80 00       	push   $0x8022c0
  800630:	6a 3a                	push   $0x3a
  800632:	68 b4 22 80 00       	push   $0x8022b4
  800637:	e8 73 fe ff ff       	call   8004af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80063c:	ff 45 f0             	incl   -0x10(%ebp)
  80063f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800642:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800645:	0f 8c 1b ff ff ff    	jl     800566 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80064b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800652:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800659:	eb 2e                	jmp    800689 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80065b:	a1 60 30 80 00       	mov    0x803060,%eax
  800660:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800666:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	01 c0                	add    %eax,%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800676:	01 d8                	add    %ebx,%eax
  800678:	01 d0                	add    %edx,%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8a 40 04             	mov    0x4(%eax),%al
  80067f:	3c 01                	cmp    $0x1,%al
  800681:	75 03                	jne    800686 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800683:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800686:	ff 45 e0             	incl   -0x20(%ebp)
  800689:	a1 60 30 80 00       	mov    0x803060,%eax
  80068e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800697:	39 c2                	cmp    %eax,%edx
  800699:	77 c0                	ja     80065b <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80069b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006a1:	74 14                	je     8006b7 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 14 23 80 00       	push   $0x802314
  8006ab:	6a 44                	push   $0x44
  8006ad:	68 b4 22 80 00       	push   $0x8022b4
  8006b2:	e8 f8 fd ff ff       	call   8004af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b7:	90                   	nop
  8006b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	53                   	push   %ebx
  8006c1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 48 01             	lea    0x1(%eax),%ecx
  8006cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cf:	89 0a                	mov    %ecx,(%edx)
  8006d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8006d4:	88 d1                	mov    %dl,%cl
  8006d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006e7:	75 30                	jne    800719 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006e9:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  8006ef:	a0 84 30 80 00       	mov    0x803084,%al
  8006f4:	0f b6 c0             	movzbl %al,%eax
  8006f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fa:	8b 09                	mov    (%ecx),%ecx
  8006fc:	89 cb                	mov    %ecx,%ebx
  8006fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800701:	83 c1 08             	add    $0x8,%ecx
  800704:	52                   	push   %edx
  800705:	50                   	push   %eax
  800706:	53                   	push   %ebx
  800707:	51                   	push   %ecx
  800708:	e8 a0 0f 00 00       	call   8016ad <sys_cputs>
  80070d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800710:	8b 45 0c             	mov    0xc(%ebp),%eax
  800713:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071c:	8b 40 04             	mov    0x4(%eax),%eax
  80071f:	8d 50 01             	lea    0x1(%eax),%edx
  800722:	8b 45 0c             	mov    0xc(%ebp),%eax
  800725:	89 50 04             	mov    %edx,0x4(%eax)
}
  800728:	90                   	nop
  800729:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800737:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80073e:	00 00 00 
	b.cnt = 0;
  800741:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800748:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80074b:	ff 75 0c             	pushl  0xc(%ebp)
  80074e:	ff 75 08             	pushl  0x8(%ebp)
  800751:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800757:	50                   	push   %eax
  800758:	68 bd 06 80 00       	push   $0x8006bd
  80075d:	e8 5a 02 00 00       	call   8009bc <vprintfmt>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800765:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  80076b:	a0 84 30 80 00       	mov    0x803084,%al
  800770:	0f b6 c0             	movzbl %al,%eax
  800773:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800779:	52                   	push   %edx
  80077a:	50                   	push   %eax
  80077b:	51                   	push   %ecx
  80077c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800782:	83 c0 08             	add    $0x8,%eax
  800785:	50                   	push   %eax
  800786:	e8 22 0f 00 00       	call   8016ad <sys_cputs>
  80078b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80078e:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  800795:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a3:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  8007aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	e8 6f ff ff ff       	call   80072e <vcprintf>
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007d0:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	c1 e0 08             	shl    $0x8,%eax
  8007dd:	a3 5c b1 81 00       	mov    %eax,0x81b15c
	va_start(ap, fmt);
  8007e2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e5:	83 c0 04             	add    $0x4,%eax
  8007e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f4:	50                   	push   %eax
  8007f5:	e8 34 ff ff ff       	call   80072e <vcprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800800:	c7 05 5c b1 81 00 00 	movl   $0x700,0x81b15c
  800807:	07 00 00 

	return cnt;
  80080a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800815:	e8 d7 0e 00 00       	call   8016f1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80081a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80081d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	ff 75 f4             	pushl  -0xc(%ebp)
  800829:	50                   	push   %eax
  80082a:	e8 ff fe ff ff       	call   80072e <vcprintf>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800835:	e8 d1 0e 00 00       	call   80170b <sys_unlock_cons>
	return cnt;
  80083a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80083d:	c9                   	leave  
  80083e:	c3                   	ret    

0080083f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	53                   	push   %ebx
  800843:	83 ec 14             	sub    $0x14,%esp
  800846:	8b 45 10             	mov    0x10(%ebp),%eax
  800849:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800852:	8b 45 18             	mov    0x18(%ebp),%eax
  800855:	ba 00 00 00 00       	mov    $0x0,%edx
  80085a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80085d:	77 55                	ja     8008b4 <printnum+0x75>
  80085f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800862:	72 05                	jb     800869 <printnum+0x2a>
  800864:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800867:	77 4b                	ja     8008b4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800869:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80086c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80086f:	8b 45 18             	mov    0x18(%ebp),%eax
  800872:	ba 00 00 00 00       	mov    $0x0,%edx
  800877:	52                   	push   %edx
  800878:	50                   	push   %eax
  800879:	ff 75 f4             	pushl  -0xc(%ebp)
  80087c:	ff 75 f0             	pushl  -0x10(%ebp)
  80087f:	e8 ac 13 00 00       	call   801c30 <__udivdi3>
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	83 ec 04             	sub    $0x4,%esp
  80088a:	ff 75 20             	pushl  0x20(%ebp)
  80088d:	53                   	push   %ebx
  80088e:	ff 75 18             	pushl  0x18(%ebp)
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	ff 75 0c             	pushl  0xc(%ebp)
  800896:	ff 75 08             	pushl  0x8(%ebp)
  800899:	e8 a1 ff ff ff       	call   80083f <printnum>
  80089e:	83 c4 20             	add    $0x20,%esp
  8008a1:	eb 1a                	jmp    8008bd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	ff 75 20             	pushl  0x20(%ebp)
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b4:	ff 4d 1c             	decl   0x1c(%ebp)
  8008b7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008bb:	7f e6                	jg     8008a3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008bd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cb:	53                   	push   %ebx
  8008cc:	51                   	push   %ecx
  8008cd:	52                   	push   %edx
  8008ce:	50                   	push   %eax
  8008cf:	e8 6c 14 00 00       	call   801d40 <__umoddi3>
  8008d4:	83 c4 10             	add    $0x10,%esp
  8008d7:	05 74 25 80 00       	add    $0x802574,%eax
  8008dc:	8a 00                	mov    (%eax),%al
  8008de:	0f be c0             	movsbl %al,%eax
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	50                   	push   %eax
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	ff d0                	call   *%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f4:	c9                   	leave  
  8008f5:	c3                   	ret    

008008f6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008fd:	7e 1c                	jle    80091b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	8d 50 08             	lea    0x8(%eax),%edx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 10                	mov    %edx,(%eax)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	83 e8 08             	sub    $0x8,%eax
  800914:	8b 50 04             	mov    0x4(%eax),%edx
  800917:	8b 00                	mov    (%eax),%eax
  800919:	eb 40                	jmp    80095b <getuint+0x65>
	else if (lflag)
  80091b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091f:	74 1e                	je     80093f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	8d 50 04             	lea    0x4(%eax),%edx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	89 10                	mov    %edx,(%eax)
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	83 e8 04             	sub    $0x4,%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	ba 00 00 00 00       	mov    $0x0,%edx
  80093d:	eb 1c                	jmp    80095b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 50 04             	lea    0x4(%eax),%edx
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	89 10                	mov    %edx,(%eax)
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	83 e8 04             	sub    $0x4,%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800960:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800964:	7e 1c                	jle    800982 <getint+0x25>
		return va_arg(*ap, long long);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 08             	lea    0x8(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 08             	sub    $0x8,%eax
  80097b:	8b 50 04             	mov    0x4(%eax),%edx
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	eb 38                	jmp    8009ba <getint+0x5d>
	else if (lflag)
  800982:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800986:	74 1a                	je     8009a2 <getint+0x45>
		return va_arg(*ap, long);
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	8d 50 04             	lea    0x4(%eax),%edx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	89 10                	mov    %edx,(%eax)
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	83 e8 04             	sub    $0x4,%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	99                   	cltd   
  8009a0:	eb 18                	jmp    8009ba <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	99                   	cltd   
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	56                   	push   %esi
  8009c0:	53                   	push   %ebx
  8009c1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c4:	eb 17                	jmp    8009dd <vprintfmt+0x21>
			if (ch == '\0')
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	0f 84 c1 03 00 00    	je     800d8f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	53                   	push   %ebx
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	8d 50 01             	lea    0x1(%eax),%edx
  8009e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e6:	8a 00                	mov    (%eax),%al
  8009e8:	0f b6 d8             	movzbl %al,%ebx
  8009eb:	83 fb 25             	cmp    $0x25,%ebx
  8009ee:	75 d6                	jne    8009c6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009f0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009f4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009fb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a09:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	8d 50 01             	lea    0x1(%eax),%edx
  800a16:	89 55 10             	mov    %edx,0x10(%ebp)
  800a19:	8a 00                	mov    (%eax),%al
  800a1b:	0f b6 d8             	movzbl %al,%ebx
  800a1e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a21:	83 f8 5b             	cmp    $0x5b,%eax
  800a24:	0f 87 3d 03 00 00    	ja     800d67 <vprintfmt+0x3ab>
  800a2a:	8b 04 85 98 25 80 00 	mov    0x802598(,%eax,4),%eax
  800a31:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a33:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a37:	eb d7                	jmp    800a10 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a39:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a3d:	eb d1                	jmp    800a10 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a49:	89 d0                	mov    %edx,%eax
  800a4b:	c1 e0 02             	shl    $0x2,%eax
  800a4e:	01 d0                	add    %edx,%eax
  800a50:	01 c0                	add    %eax,%eax
  800a52:	01 d8                	add    %ebx,%eax
  800a54:	83 e8 30             	sub    $0x30,%eax
  800a57:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5d:	8a 00                	mov    (%eax),%al
  800a5f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a62:	83 fb 2f             	cmp    $0x2f,%ebx
  800a65:	7e 3e                	jle    800aa5 <vprintfmt+0xe9>
  800a67:	83 fb 39             	cmp    $0x39,%ebx
  800a6a:	7f 39                	jg     800aa5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a6c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a6f:	eb d5                	jmp    800a46 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 e8 04             	sub    $0x4,%eax
  800a80:	8b 00                	mov    (%eax),%eax
  800a82:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a85:	eb 1f                	jmp    800aa6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8b:	79 83                	jns    800a10 <vprintfmt+0x54>
				width = 0;
  800a8d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a94:	e9 77 ff ff ff       	jmp    800a10 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a99:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aa0:	e9 6b ff ff ff       	jmp    800a10 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aa5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aa6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aaa:	0f 89 60 ff ff ff    	jns    800a10 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ab6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800abd:	e9 4e ff ff ff       	jmp    800a10 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ac5:	e9 46 ff ff ff       	jmp    800a10 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	50                   	push   %eax
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			break;
  800aea:	e9 9b 02 00 00       	jmp    800d8a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 c0 04             	add    $0x4,%eax
  800af5:	89 45 14             	mov    %eax,0x14(%ebp)
  800af8:	8b 45 14             	mov    0x14(%ebp),%eax
  800afb:	83 e8 04             	sub    $0x4,%eax
  800afe:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b00:	85 db                	test   %ebx,%ebx
  800b02:	79 02                	jns    800b06 <vprintfmt+0x14a>
				err = -err;
  800b04:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b06:	83 fb 64             	cmp    $0x64,%ebx
  800b09:	7f 0b                	jg     800b16 <vprintfmt+0x15a>
  800b0b:	8b 34 9d e0 23 80 00 	mov    0x8023e0(,%ebx,4),%esi
  800b12:	85 f6                	test   %esi,%esi
  800b14:	75 19                	jne    800b2f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b16:	53                   	push   %ebx
  800b17:	68 85 25 80 00       	push   $0x802585
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	ff 75 08             	pushl  0x8(%ebp)
  800b22:	e8 70 02 00 00       	call   800d97 <printfmt>
  800b27:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2a:	e9 5b 02 00 00       	jmp    800d8a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b2f:	56                   	push   %esi
  800b30:	68 8e 25 80 00       	push   $0x80258e
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	ff 75 08             	pushl  0x8(%ebp)
  800b3b:	e8 57 02 00 00       	call   800d97 <printfmt>
  800b40:	83 c4 10             	add    $0x10,%esp
			break;
  800b43:	e9 42 02 00 00       	jmp    800d8a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b48:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4b:	83 c0 04             	add    $0x4,%eax
  800b4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b51:	8b 45 14             	mov    0x14(%ebp),%eax
  800b54:	83 e8 04             	sub    $0x4,%eax
  800b57:	8b 30                	mov    (%eax),%esi
  800b59:	85 f6                	test   %esi,%esi
  800b5b:	75 05                	jne    800b62 <vprintfmt+0x1a6>
				p = "(null)";
  800b5d:	be 91 25 80 00       	mov    $0x802591,%esi
			if (width > 0 && padc != '-')
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7e 6d                	jle    800bd5 <vprintfmt+0x219>
  800b68:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b6c:	74 67                	je     800bd5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	50                   	push   %eax
  800b75:	56                   	push   %esi
  800b76:	e8 1e 03 00 00       	call   800e99 <strnlen>
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b81:	eb 16                	jmp    800b99 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b83:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	50                   	push   %eax
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9d:	7f e4                	jg     800b83 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9f:	eb 34                	jmp    800bd5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ba1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ba5:	74 1c                	je     800bc3 <vprintfmt+0x207>
  800ba7:	83 fb 1f             	cmp    $0x1f,%ebx
  800baa:	7e 05                	jle    800bb1 <vprintfmt+0x1f5>
  800bac:	83 fb 7e             	cmp    $0x7e,%ebx
  800baf:	7e 12                	jle    800bc3 <vprintfmt+0x207>
					putch('?', putdat);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	6a 3f                	push   $0x3f
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	ff d0                	call   *%eax
  800bbe:	83 c4 10             	add    $0x10,%esp
  800bc1:	eb 0f                	jmp    800bd2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	53                   	push   %ebx
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	ff d0                	call   *%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd5:	89 f0                	mov    %esi,%eax
  800bd7:	8d 70 01             	lea    0x1(%eax),%esi
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	0f be d8             	movsbl %al,%ebx
  800bdf:	85 db                	test   %ebx,%ebx
  800be1:	74 24                	je     800c07 <vprintfmt+0x24b>
  800be3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be7:	78 b8                	js     800ba1 <vprintfmt+0x1e5>
  800be9:	ff 4d e0             	decl   -0x20(%ebp)
  800bec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf0:	79 af                	jns    800ba1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf2:	eb 13                	jmp    800c07 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	6a 20                	push   $0x20
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
  800c01:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c04:	ff 4d e4             	decl   -0x1c(%ebp)
  800c07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0b:	7f e7                	jg     800bf4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c0d:	e9 78 01 00 00       	jmp    800d8a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 e8             	pushl  -0x18(%ebp)
  800c18:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1b:	50                   	push   %eax
  800c1c:	e8 3c fd ff ff       	call   80095d <getint>
  800c21:	83 c4 10             	add    $0x10,%esp
  800c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c27:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c30:	85 d2                	test   %edx,%edx
  800c32:	79 23                	jns    800c57 <vprintfmt+0x29b>
				putch('-', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 2d                	push   $0x2d
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4a:	f7 d8                	neg    %eax
  800c4c:	83 d2 00             	adc    $0x0,%edx
  800c4f:	f7 da                	neg    %edx
  800c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c57:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c5e:	e9 bc 00 00 00       	jmp    800d1f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c63:	83 ec 08             	sub    $0x8,%esp
  800c66:	ff 75 e8             	pushl  -0x18(%ebp)
  800c69:	8d 45 14             	lea    0x14(%ebp),%eax
  800c6c:	50                   	push   %eax
  800c6d:	e8 84 fc ff ff       	call   8008f6 <getuint>
  800c72:	83 c4 10             	add    $0x10,%esp
  800c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c7b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c82:	e9 98 00 00 00       	jmp    800d1f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 58                	push   $0x58
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	6a 58                	push   $0x58
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	ff d0                	call   *%eax
  800ca4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ca7:	83 ec 08             	sub    $0x8,%esp
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	6a 58                	push   $0x58
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			break;
  800cb7:	e9 ce 00 00 00       	jmp    800d8a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cbc:	83 ec 08             	sub    $0x8,%esp
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	6a 30                	push   $0x30
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ccc:	83 ec 08             	sub    $0x8,%esp
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	6a 78                	push   $0x78
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	ff d0                	call   *%eax
  800cd9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	83 c0 04             	add    $0x4,%eax
  800ce2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	83 e8 04             	sub    $0x4,%eax
  800ceb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cf7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cfe:	eb 1f                	jmp    800d1f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d00:	83 ec 08             	sub    $0x8,%esp
  800d03:	ff 75 e8             	pushl  -0x18(%ebp)
  800d06:	8d 45 14             	lea    0x14(%ebp),%eax
  800d09:	50                   	push   %eax
  800d0a:	e8 e7 fb ff ff       	call   8008f6 <getuint>
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d15:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d18:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d1f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	52                   	push   %edx
  800d2a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d2d:	50                   	push   %eax
  800d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d31:	ff 75 f0             	pushl  -0x10(%ebp)
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	ff 75 08             	pushl  0x8(%ebp)
  800d3a:	e8 00 fb ff ff       	call   80083f <printnum>
  800d3f:	83 c4 20             	add    $0x20,%esp
			break;
  800d42:	eb 46                	jmp    800d8a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d44:	83 ec 08             	sub    $0x8,%esp
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	53                   	push   %ebx
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	ff d0                	call   *%eax
  800d50:	83 c4 10             	add    $0x10,%esp
			break;
  800d53:	eb 35                	jmp    800d8a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d55:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800d5c:	eb 2c                	jmp    800d8a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d5e:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800d65:	eb 23                	jmp    800d8a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d67:	83 ec 08             	sub    $0x8,%esp
  800d6a:	ff 75 0c             	pushl  0xc(%ebp)
  800d6d:	6a 25                	push   $0x25
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	ff d0                	call   *%eax
  800d74:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d77:	ff 4d 10             	decl   0x10(%ebp)
  800d7a:	eb 03                	jmp    800d7f <vprintfmt+0x3c3>
  800d7c:	ff 4d 10             	decl   0x10(%ebp)
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	48                   	dec    %eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 25                	cmp    $0x25,%al
  800d87:	75 f3                	jne    800d7c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d89:	90                   	nop
		}
	}
  800d8a:	e9 35 fc ff ff       	jmp    8009c4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d8f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d9d:	8d 45 10             	lea    0x10(%ebp),%eax
  800da0:	83 c0 04             	add    $0x4,%eax
  800da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dac:	50                   	push   %eax
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	ff 75 08             	pushl  0x8(%ebp)
  800db3:	e8 04 fc ff ff       	call   8009bc <vprintfmt>
  800db8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dbb:	90                   	nop
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	8b 40 08             	mov    0x8(%eax),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8b 10                	mov    (%eax),%edx
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	8b 40 04             	mov    0x4(%eax),%eax
  800ddb:	39 c2                	cmp    %eax,%edx
  800ddd:	73 12                	jae    800df1 <sprintputch+0x33>
		*b->buf++ = ch;
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 00                	mov    (%eax),%eax
  800de4:	8d 48 01             	lea    0x1(%eax),%ecx
  800de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dea:	89 0a                	mov    %ecx,(%edx)
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	88 10                	mov    %dl,(%eax)
}
  800df1:	90                   	nop
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	01 d0                	add    %edx,%eax
  800e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e19:	74 06                	je     800e21 <vsnprintf+0x2d>
  800e1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1f:	7f 07                	jg     800e28 <vsnprintf+0x34>
		return -E_INVAL;
  800e21:	b8 03 00 00 00       	mov    $0x3,%eax
  800e26:	eb 20                	jmp    800e48 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e28:	ff 75 14             	pushl  0x14(%ebp)
  800e2b:	ff 75 10             	pushl  0x10(%ebp)
  800e2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e31:	50                   	push   %eax
  800e32:	68 be 0d 80 00       	push   $0x800dbe
  800e37:	e8 80 fb ff ff       	call   8009bc <vprintfmt>
  800e3c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e42:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e50:	8d 45 10             	lea    0x10(%ebp),%eax
  800e53:	83 c0 04             	add    $0x4,%eax
  800e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e59:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5f:	50                   	push   %eax
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	ff 75 08             	pushl  0x8(%ebp)
  800e66:	e8 89 ff ff ff       	call   800df4 <vsnprintf>
  800e6b:	83 c4 10             	add    $0x10,%esp
  800e6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e83:	eb 06                	jmp    800e8b <strlen+0x15>
		n++;
  800e85:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e88:	ff 45 08             	incl   0x8(%ebp)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	84 c0                	test   %al,%al
  800e92:	75 f1                	jne    800e85 <strlen+0xf>
		n++;
	return n;
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e97:	c9                   	leave  
  800e98:	c3                   	ret    

00800e99 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea6:	eb 09                	jmp    800eb1 <strnlen+0x18>
		n++;
  800ea8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eab:	ff 45 08             	incl   0x8(%ebp)
  800eae:	ff 4d 0c             	decl   0xc(%ebp)
  800eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb5:	74 09                	je     800ec0 <strnlen+0x27>
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e8                	jne    800ea8 <strnlen+0xf>
		n++;
	return n;
  800ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ed1:	90                   	nop
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 08             	mov    %edx,0x8(%ebp)
  800edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 e4                	jne    800ed2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f06:	eb 1f                	jmp    800f27 <strncpy+0x34>
		*dst++ = *src;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8d 50 01             	lea    0x1(%eax),%edx
  800f0e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f14:	8a 12                	mov    (%edx),%dl
  800f16:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	84 c0                	test   %al,%al
  800f1f:	74 03                	je     800f24 <strncpy+0x31>
			src++;
  800f21:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f24:	ff 45 fc             	incl   -0x4(%ebp)
  800f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f2d:	72 d9                	jb     800f08 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f44:	74 30                	je     800f76 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f46:	eb 16                	jmp    800f5e <strlcpy+0x2a>
			*dst++ = *src++;
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8d 50 01             	lea    0x1(%eax),%edx
  800f4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f5a:	8a 12                	mov    (%edx),%dl
  800f5c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f5e:	ff 4d 10             	decl   0x10(%ebp)
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 09                	je     800f70 <strlcpy+0x3c>
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	84 c0                	test   %al,%al
  800f6e:	75 d8                	jne    800f48 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f76:	8b 55 08             	mov    0x8(%ebp),%edx
  800f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7c:	29 c2                	sub    %eax,%edx
  800f7e:	89 d0                	mov    %edx,%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f85:	eb 06                	jmp    800f8d <strcmp+0xb>
		p++, q++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	84 c0                	test   %al,%al
  800f94:	74 0e                	je     800fa4 <strcmp+0x22>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 10                	mov    (%eax),%dl
  800f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	38 c2                	cmp    %al,%dl
  800fa2:	74 e3                	je     800f87 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fbd:	eb 09                	jmp    800fc8 <strncmp+0xe>
		n--, p++, q++;
  800fbf:	ff 4d 10             	decl   0x10(%ebp)
  800fc2:	ff 45 08             	incl   0x8(%ebp)
  800fc5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcc:	74 17                	je     800fe5 <strncmp+0x2b>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	74 0e                	je     800fe5 <strncmp+0x2b>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 10                	mov    (%eax),%dl
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	38 c2                	cmp    %al,%dl
  800fe3:	74 da                	je     800fbf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fe5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe9:	75 07                	jne    800ff2 <strncmp+0x38>
		return 0;
  800feb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff0:	eb 14                	jmp    801006 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	0f b6 d0             	movzbl %al,%edx
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f b6 c0             	movzbl %al,%eax
  801002:	29 c2                	sub    %eax,%edx
  801004:	89 d0                	mov    %edx,%eax
}
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801014:	eb 12                	jmp    801028 <strchr+0x20>
		if (*s == c)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101e:	75 05                	jne    801025 <strchr+0x1d>
			return (char *) s;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	eb 11                	jmp    801036 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801025:	ff 45 08             	incl   0x8(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	84 c0                	test   %al,%al
  80102f:	75 e5                	jne    801016 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801044:	eb 0d                	jmp    801053 <strfind+0x1b>
		if (*s == c)
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80104e:	74 0e                	je     80105e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801050:	ff 45 08             	incl   0x8(%ebp)
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	84 c0                	test   %al,%al
  80105a:	75 ea                	jne    801046 <strfind+0xe>
  80105c:	eb 01                	jmp    80105f <strfind+0x27>
		if (*s == c)
			break;
  80105e:	90                   	nop
	return (char *) s;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801070:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801074:	76 63                	jbe    8010d9 <memset+0x75>
		uint64 data_block = c;
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	99                   	cltd   
  80107a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801086:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80108a:	c1 e0 08             	shl    $0x8,%eax
  80108d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801090:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801099:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80109d:	c1 e0 10             	shl    $0x10,%eax
  8010a0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010a3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8010a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ac:	89 c2                	mov    %eax,%edx
  8010ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010b6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010b9:	eb 18                	jmp    8010d3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010bb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010be:	8d 41 08             	lea    0x8(%ecx),%eax
  8010c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ca:	89 01                	mov    %eax,(%ecx)
  8010cc:	89 51 04             	mov    %edx,0x4(%ecx)
  8010cf:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d7:	77 e2                	ja     8010bb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010dd:	74 23                	je     801102 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x91>
			*p8++ = (uint8)c;
  8010e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fe:	85 c0                	test   %eax,%eax
  801100:	75 e5                	jne    8010e7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801119:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80111d:	76 24                	jbe    801143 <memcpy+0x3c>
		while(n >= 8){
  80111f:	eb 1c                	jmp    80113d <memcpy+0x36>
			*d64 = *s64;
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	8b 50 04             	mov    0x4(%eax),%edx
  801127:	8b 00                	mov    (%eax),%eax
  801129:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80112c:	89 01                	mov    %eax,(%ecx)
  80112e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801131:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801135:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801139:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80113d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801141:	77 de                	ja     801121 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801147:	74 31                	je     80117a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801152:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801155:	eb 16                	jmp    80116d <memcpy+0x66>
			*d8++ = *s8++;
  801157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115a:	8d 50 01             	lea    0x1(%eax),%edx
  80115d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801163:	8d 4a 01             	lea    0x1(%edx),%ecx
  801166:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801169:	8a 12                	mov    (%edx),%dl
  80116b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	8d 50 ff             	lea    -0x1(%eax),%edx
  801173:	89 55 10             	mov    %edx,0x10(%ebp)
  801176:	85 c0                	test   %eax,%eax
  801178:	75 dd                	jne    801157 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801185:	8b 45 0c             	mov    0xc(%ebp),%eax
  801188:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801191:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801194:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801197:	73 50                	jae    8011e9 <memmove+0x6a>
  801199:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	01 d0                	add    %edx,%eax
  8011a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011a4:	76 43                	jbe    8011e9 <memmove+0x6a>
		s += n;
  8011a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011b2:	eb 10                	jmp    8011c4 <memmove+0x45>
			*--d = *--s;
  8011b4:	ff 4d f8             	decl   -0x8(%ebp)
  8011b7:	ff 4d fc             	decl   -0x4(%ebp)
  8011ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bd:	8a 10                	mov    (%eax),%dl
  8011bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	75 e3                	jne    8011b4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011d1:	eb 23                	jmp    8011f6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	8d 50 01             	lea    0x1(%eax),%edx
  8011d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011e5:	8a 12                	mov    (%edx),%dl
  8011e7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	75 dd                	jne    8011d3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80120d:	eb 2a                	jmp    801239 <memcmp+0x3e>
		if (*s1 != *s2)
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	8a 10                	mov    (%eax),%dl
  801214:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	38 c2                	cmp    %al,%dl
  80121b:	74 16                	je     801233 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80121d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	0f b6 d0             	movzbl %al,%edx
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f b6 c0             	movzbl %al,%eax
  80122d:	29 c2                	sub    %eax,%edx
  80122f:	89 d0                	mov    %edx,%eax
  801231:	eb 18                	jmp    80124b <memcmp+0x50>
		s1++, s2++;
  801233:	ff 45 fc             	incl   -0x4(%ebp)
  801236:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801239:	8b 45 10             	mov    0x10(%ebp),%eax
  80123c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123f:	89 55 10             	mov    %edx,0x10(%ebp)
  801242:	85 c0                	test   %eax,%eax
  801244:	75 c9                	jne    80120f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801253:	8b 55 08             	mov    0x8(%ebp),%edx
  801256:	8b 45 10             	mov    0x10(%ebp),%eax
  801259:	01 d0                	add    %edx,%eax
  80125b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80125e:	eb 15                	jmp    801275 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	0f b6 d0             	movzbl %al,%edx
  801268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126b:	0f b6 c0             	movzbl %al,%eax
  80126e:	39 c2                	cmp    %eax,%edx
  801270:	74 0d                	je     80127f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801272:	ff 45 08             	incl   0x8(%ebp)
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80127b:	72 e3                	jb     801260 <memfind+0x13>
  80127d:	eb 01                	jmp    801280 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80127f:	90                   	nop
	return (void *) s;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801292:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801299:	eb 03                	jmp    80129e <strtol+0x19>
		s++;
  80129b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	3c 20                	cmp    $0x20,%al
  8012a5:	74 f4                	je     80129b <strtol+0x16>
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 09                	cmp    $0x9,%al
  8012ae:	74 eb                	je     80129b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	3c 2b                	cmp    $0x2b,%al
  8012b7:	75 05                	jne    8012be <strtol+0x39>
		s++;
  8012b9:	ff 45 08             	incl   0x8(%ebp)
  8012bc:	eb 13                	jmp    8012d1 <strtol+0x4c>
	else if (*s == '-')
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	3c 2d                	cmp    $0x2d,%al
  8012c5:	75 0a                	jne    8012d1 <strtol+0x4c>
		s++, neg = 1;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
  8012ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d5:	74 06                	je     8012dd <strtol+0x58>
  8012d7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012db:	75 20                	jne    8012fd <strtol+0x78>
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	3c 30                	cmp    $0x30,%al
  8012e4:	75 17                	jne    8012fd <strtol+0x78>
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	40                   	inc    %eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	3c 78                	cmp    $0x78,%al
  8012ee:	75 0d                	jne    8012fd <strtol+0x78>
		s += 2, base = 16;
  8012f0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012f4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012fb:	eb 28                	jmp    801325 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801301:	75 15                	jne    801318 <strtol+0x93>
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	3c 30                	cmp    $0x30,%al
  80130a:	75 0c                	jne    801318 <strtol+0x93>
		s++, base = 8;
  80130c:	ff 45 08             	incl   0x8(%ebp)
  80130f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801316:	eb 0d                	jmp    801325 <strtol+0xa0>
	else if (base == 0)
  801318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80131c:	75 07                	jne    801325 <strtol+0xa0>
		base = 10;
  80131e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	3c 2f                	cmp    $0x2f,%al
  80132c:	7e 19                	jle    801347 <strtol+0xc2>
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	3c 39                	cmp    $0x39,%al
  801335:	7f 10                	jg     801347 <strtol+0xc2>
			dig = *s - '0';
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	83 e8 30             	sub    $0x30,%eax
  801342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801345:	eb 42                	jmp    801389 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8a 00                	mov    (%eax),%al
  80134c:	3c 60                	cmp    $0x60,%al
  80134e:	7e 19                	jle    801369 <strtol+0xe4>
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	3c 7a                	cmp    $0x7a,%al
  801357:	7f 10                	jg     801369 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f be c0             	movsbl %al,%eax
  801361:	83 e8 57             	sub    $0x57,%eax
  801364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801367:	eb 20                	jmp    801389 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	8a 00                	mov    (%eax),%al
  80136e:	3c 40                	cmp    $0x40,%al
  801370:	7e 39                	jle    8013ab <strtol+0x126>
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	3c 5a                	cmp    $0x5a,%al
  801379:	7f 30                	jg     8013ab <strtol+0x126>
			dig = *s - 'A' + 10;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8a 00                	mov    (%eax),%al
  801380:	0f be c0             	movsbl %al,%eax
  801383:	83 e8 37             	sub    $0x37,%eax
  801386:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80138f:	7d 19                	jge    8013aa <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801391:	ff 45 08             	incl   0x8(%ebp)
  801394:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801397:	0f af 45 10          	imul   0x10(%ebp),%eax
  80139b:	89 c2                	mov    %eax,%edx
  80139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a0:	01 d0                	add    %edx,%eax
  8013a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013a5:	e9 7b ff ff ff       	jmp    801325 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013aa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013af:	74 08                	je     8013b9 <strtol+0x134>
		*endptr = (char *) s;
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013bd:	74 07                	je     8013c6 <strtol+0x141>
  8013bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c2:	f7 d8                	neg    %eax
  8013c4:	eb 03                	jmp    8013c9 <strtol+0x144>
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <ltostr>:

void
ltostr(long value, char *str)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e3:	79 13                	jns    8013f8 <ltostr+0x2d>
	{
		neg = 1;
  8013e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013f2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013f5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801400:	99                   	cltd   
  801401:	f7 f9                	idiv   %ecx
  801403:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801406:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801409:	8d 50 01             	lea    0x1(%eax),%edx
  80140c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80140f:	89 c2                	mov    %eax,%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801419:	83 c2 30             	add    $0x30,%edx
  80141c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80141e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801421:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801426:	f7 e9                	imul   %ecx
  801428:	c1 fa 02             	sar    $0x2,%edx
  80142b:	89 c8                	mov    %ecx,%eax
  80142d:	c1 f8 1f             	sar    $0x1f,%eax
  801430:	29 c2                	sub    %eax,%edx
  801432:	89 d0                	mov    %edx,%eax
  801434:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801437:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80143b:	75 bb                	jne    8013f8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80143d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801444:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801447:	48                   	dec    %eax
  801448:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80144b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80144f:	74 3d                	je     80148e <ltostr+0xc3>
		start = 1 ;
  801451:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801458:	eb 34                	jmp    80148e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80145a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	01 c2                	add    %eax,%edx
  80146f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	01 c8                	add    %ecx,%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80147b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80147e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801481:	01 c2                	add    %eax,%edx
  801483:	8a 45 eb             	mov    -0x15(%ebp),%al
  801486:	88 02                	mov    %al,(%edx)
		start++ ;
  801488:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80148b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80148e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801491:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801494:	7c c4                	jl     80145a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801496:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149c:	01 d0                	add    %edx,%eax
  80149e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014a1:	90                   	nop
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014aa:	ff 75 08             	pushl  0x8(%ebp)
  8014ad:	e8 c4 f9 ff ff       	call   800e76 <strlen>
  8014b2:	83 c4 04             	add    $0x4,%esp
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	e8 b6 f9 ff ff       	call   800e76 <strlen>
  8014c0:	83 c4 04             	add    $0x4,%esp
  8014c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d4:	eb 17                	jmp    8014ed <strcconcat+0x49>
		final[s] = str1[s] ;
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 c2                	add    %eax,%edx
  8014de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 c8                	add    %ecx,%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ea:	ff 45 fc             	incl   -0x4(%ebp)
  8014ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014f3:	7c e1                	jl     8014d6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801503:	eb 1f                	jmp    801524 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801508:	8d 50 01             	lea    0x1(%eax),%edx
  80150b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80150e:	89 c2                	mov    %eax,%edx
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 c2                	add    %eax,%edx
  801515:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801521:	ff 45 f8             	incl   -0x8(%ebp)
  801524:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801527:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80152a:	7c d9                	jl     801505 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80152c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152f:	8b 45 10             	mov    0x10(%ebp),%eax
  801532:	01 d0                	add    %edx,%eax
  801534:	c6 00 00             	movb   $0x0,(%eax)
}
  801537:	90                   	nop
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80153d:	8b 45 14             	mov    0x14(%ebp),%eax
  801540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801546:	8b 45 14             	mov    0x14(%ebp),%eax
  801549:	8b 00                	mov    (%eax),%eax
  80154b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801552:	8b 45 10             	mov    0x10(%ebp),%eax
  801555:	01 d0                	add    %edx,%eax
  801557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80155d:	eb 0c                	jmp    80156b <strsplit+0x31>
			*string++ = 0;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 08             	mov    %edx,0x8(%ebp)
  801568:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 18                	je     80158c <strsplit+0x52>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	0f be c0             	movsbl %al,%eax
  80157c:	50                   	push   %eax
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	e8 83 fa ff ff       	call   801008 <strchr>
  801585:	83 c4 08             	add    $0x8,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	75 d3                	jne    80155f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	84 c0                	test   %al,%al
  801593:	74 5a                	je     8015ef <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801595:	8b 45 14             	mov    0x14(%ebp),%eax
  801598:	8b 00                	mov    (%eax),%eax
  80159a:	83 f8 0f             	cmp    $0xf,%eax
  80159d:	75 07                	jne    8015a6 <strsplit+0x6c>
		{
			return 0;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a4:	eb 66                	jmp    80160c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a9:	8b 00                	mov    (%eax),%eax
  8015ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8015ae:	8b 55 14             	mov    0x14(%ebp),%edx
  8015b1:	89 0a                	mov    %ecx,(%edx)
  8015b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bd:	01 c2                	add    %eax,%edx
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015c4:	eb 03                	jmp    8015c9 <strsplit+0x8f>
			string++;
  8015c6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8a 00                	mov    (%eax),%al
  8015ce:	84 c0                	test   %al,%al
  8015d0:	74 8b                	je     80155d <strsplit+0x23>
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	0f be c0             	movsbl %al,%eax
  8015da:	50                   	push   %eax
  8015db:	ff 75 0c             	pushl  0xc(%ebp)
  8015de:	e8 25 fa ff ff       	call   801008 <strchr>
  8015e3:	83 c4 08             	add    $0x8,%esp
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	74 dc                	je     8015c6 <strsplit+0x8c>
			string++;
	}
  8015ea:	e9 6e ff ff ff       	jmp    80155d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ef:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f3:	8b 00                	mov    (%eax),%eax
  8015f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801607:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80161a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801621:	eb 4a                	jmp    80166d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801623:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	01 c2                	add    %eax,%edx
  80162b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801631:	01 c8                	add    %ecx,%eax
  801633:	8a 00                	mov    (%eax),%al
  801635:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801637:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	01 d0                	add    %edx,%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	3c 40                	cmp    $0x40,%al
  801643:	7e 25                	jle    80166a <str2lower+0x5c>
  801645:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	01 d0                	add    %edx,%eax
  80164d:	8a 00                	mov    (%eax),%al
  80164f:	3c 5a                	cmp    $0x5a,%al
  801651:	7f 17                	jg     80166a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801653:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	01 d0                	add    %edx,%eax
  80165b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80165e:	8b 55 08             	mov    0x8(%ebp),%edx
  801661:	01 ca                	add    %ecx,%edx
  801663:	8a 12                	mov    (%edx),%dl
  801665:	83 c2 20             	add    $0x20,%edx
  801668:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80166a:	ff 45 fc             	incl   -0x4(%ebp)
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	e8 01 f8 ff ff       	call   800e76 <strlen>
  801675:	83 c4 04             	add    $0x4,%esp
  801678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80167b:	7f a6                	jg     801623 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80167d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	57                   	push   %edi
  801686:	56                   	push   %esi
  801687:	53                   	push   %ebx
  801688:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801694:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801697:	8b 7d 18             	mov    0x18(%ebp),%edi
  80169a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80169d:	cd 30                	int    $0x30
  80169f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	5b                   	pop    %ebx
  8016a9:	5e                   	pop    %esi
  8016aa:	5f                   	pop    %edi
  8016ab:	5d                   	pop    %ebp
  8016ac:	c3                   	ret    

008016ad <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	51                   	push   %ecx
  8016c6:	52                   	push   %edx
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	6a 00                	push   $0x0
  8016cd:	e8 b0 ff ff ff       	call   801682 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	90                   	nop
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 02                	push   $0x2
  8016e7:	e8 96 ff ff ff       	call   801682 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 03                	push   $0x3
  801700:	e8 7d ff ff ff       	call   801682 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	90                   	nop
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 04                	push   $0x4
  80171a:	e8 63 ff ff ff       	call   801682 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	90                   	nop
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	52                   	push   %edx
  801735:	50                   	push   %eax
  801736:	6a 08                	push   $0x8
  801738:	e8 45 ff ff ff       	call   801682 <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	56                   	push   %esi
  801746:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801747:	8b 75 18             	mov    0x18(%ebp),%esi
  80174a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	51                   	push   %ecx
  801759:	52                   	push   %edx
  80175a:	50                   	push   %eax
  80175b:	6a 09                	push   $0x9
  80175d:	e8 20 ff ff ff       	call   801682 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	6a 0a                	push   $0xa
  80177c:	e8 01 ff ff ff       	call   801682 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	6a 0b                	push   $0xb
  801797:	e8 e6 fe ff ff       	call   801682 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 0c                	push   $0xc
  8017b0:	e8 cd fe ff ff       	call   801682 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 0d                	push   $0xd
  8017c9:	e8 b4 fe ff ff       	call   801682 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 0e                	push   $0xe
  8017e2:	e8 9b fe ff ff       	call   801682 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 0f                	push   $0xf
  8017fb:	e8 82 fe ff ff       	call   801682 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	6a 10                	push   $0x10
  801815:	e8 68 fe ff ff       	call   801682 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 11                	push   $0x11
  80182e:	e8 4f fe ff ff       	call   801682 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_cputc>:

void
sys_cputc(const char c)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 04             	sub    $0x4,%esp
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801845:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	50                   	push   %eax
  801852:	6a 01                	push   $0x1
  801854:	e8 29 fe ff ff       	call   801682 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	90                   	nop
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 14                	push   $0x14
  80186e:	e8 0f fe ff ff       	call   801682 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801885:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801888:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	6a 00                	push   $0x0
  801891:	51                   	push   %ecx
  801892:	52                   	push   %edx
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	50                   	push   %eax
  801897:	6a 15                	push   $0x15
  801899:	e8 e4 fd ff ff       	call   801682 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	6a 16                	push   $0x16
  8018b6:	e8 c7 fd ff ff       	call   801682 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	51                   	push   %ecx
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 17                	push   $0x17
  8018d5:	e8 a8 fd ff ff       	call   801682 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	52                   	push   %edx
  8018ef:	50                   	push   %eax
  8018f0:	6a 18                	push   $0x18
  8018f2:	e8 8b fd ff ff       	call   801682 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	6a 00                	push   $0x0
  801904:	ff 75 14             	pushl  0x14(%ebp)
  801907:	ff 75 10             	pushl  0x10(%ebp)
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	50                   	push   %eax
  80190e:	6a 19                	push   $0x19
  801910:	e8 6d fd ff ff       	call   801682 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	50                   	push   %eax
  801929:	6a 1a                	push   $0x1a
  80192b:	e8 52 fd ff ff       	call   801682 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	50                   	push   %eax
  801945:	6a 1b                	push   $0x1b
  801947:	e8 36 fd ff ff       	call   801682 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 05                	push   $0x5
  801960:	e8 1d fd ff ff       	call   801682 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 06                	push   $0x6
  801979:	e8 04 fd ff ff       	call   801682 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 07                	push   $0x7
  801992:	e8 eb fc ff ff       	call   801682 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_exit_env>:


void sys_exit_env(void)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 1c                	push   $0x1c
  8019ab:	e8 d2 fc ff ff       	call   801682 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019bf:	8d 50 04             	lea    0x4(%eax),%edx
  8019c2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	52                   	push   %edx
  8019cc:	50                   	push   %eax
  8019cd:	6a 1d                	push   $0x1d
  8019cf:	e8 ae fc ff ff       	call   801682 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return result;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e0:	89 01                	mov    %eax,(%ecx)
  8019e2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	c9                   	leave  
  8019e9:	c2 04 00             	ret    $0x4

008019ec <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 10             	pushl  0x10(%ebp)
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	6a 13                	push   $0x13
  8019fe:	e8 7f fc ff ff       	call   801682 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
	return ;
  801a06:	90                   	nop
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 1e                	push   $0x1e
  801a18:	e8 65 fc ff ff       	call   801682 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a2e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	50                   	push   %eax
  801a3b:	6a 1f                	push   $0x1f
  801a3d:	e8 40 fc ff ff       	call   801682 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
	return ;
  801a45:	90                   	nop
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <rsttst>:
void rsttst()
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 21                	push   $0x21
  801a57:	e8 26 fc ff ff       	call   801682 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5f:	90                   	nop
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a6e:	8b 55 18             	mov    0x18(%ebp),%edx
  801a71:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	ff 75 10             	pushl  0x10(%ebp)
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 20                	push   $0x20
  801a82:	e8 fb fb ff ff       	call   801682 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <chktst>:
void chktst(uint32 n)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 08             	pushl  0x8(%ebp)
  801a9b:	6a 22                	push   $0x22
  801a9d:	e8 e0 fb ff ff       	call   801682 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa5:	90                   	nop
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <inctst>:

void inctst()
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 23                	push   $0x23
  801ab7:	e8 c6 fb ff ff       	call   801682 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
	return ;
  801abf:	90                   	nop
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <gettst>:
uint32 gettst()
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 24                	push   $0x24
  801ad1:	e8 ac fb ff ff       	call   801682 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 25                	push   $0x25
  801aea:	e8 93 fb ff ff       	call   801682 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
  801af2:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  801af7:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	ff 75 08             	pushl  0x8(%ebp)
  801b14:	6a 26                	push   $0x26
  801b16:	e8 67 fb ff ff       	call   801682 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1e:	90                   	nop
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	53                   	push   %ebx
  801b34:	51                   	push   %ecx
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 27                	push   $0x27
  801b39:	e8 44 fb ff ff       	call   801682 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 28                	push   $0x28
  801b59:	e8 24 fb ff ff       	call   801682 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b66:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	51                   	push   %ecx
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 29                	push   $0x29
  801b79:	e8 04 fb ff ff       	call   801682 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	6a 12                	push   $0x12
  801b95:	e8 e8 fa ff ff       	call   801682 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	52                   	push   %edx
  801bb0:	50                   	push   %eax
  801bb1:	6a 2a                	push   $0x2a
  801bb3:	e8 ca fa ff ff       	call   801682 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
	return;
  801bbb:	90                   	nop
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 2b                	push   $0x2b
  801bcd:	e8 b0 fa ff ff       	call   801682 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	ff 75 08             	pushl  0x8(%ebp)
  801be6:	6a 2d                	push   $0x2d
  801be8:	e8 95 fa ff ff       	call   801682 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
	return;
  801bf0:	90                   	nop
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	6a 2c                	push   $0x2c
  801c04:	e8 79 fa ff ff       	call   801682 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0c:	90                   	nop
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	52                   	push   %edx
  801c1f:	50                   	push   %eax
  801c20:	6a 2e                	push   $0x2e
  801c22:	e8 5b fa ff ff       	call   801682 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    
  801c2d:	66 90                	xchg   %ax,%ax
  801c2f:	90                   	nop

00801c30 <__udivdi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c47:	89 ca                	mov    %ecx,%edx
  801c49:	89 f8                	mov    %edi,%eax
  801c4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c4f:	85 f6                	test   %esi,%esi
  801c51:	75 2d                	jne    801c80 <__udivdi3+0x50>
  801c53:	39 cf                	cmp    %ecx,%edi
  801c55:	77 65                	ja     801cbc <__udivdi3+0x8c>
  801c57:	89 fd                	mov    %edi,%ebp
  801c59:	85 ff                	test   %edi,%edi
  801c5b:	75 0b                	jne    801c68 <__udivdi3+0x38>
  801c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c62:	31 d2                	xor    %edx,%edx
  801c64:	f7 f7                	div    %edi
  801c66:	89 c5                	mov    %eax,%ebp
  801c68:	31 d2                	xor    %edx,%edx
  801c6a:	89 c8                	mov    %ecx,%eax
  801c6c:	f7 f5                	div    %ebp
  801c6e:	89 c1                	mov    %eax,%ecx
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	f7 f5                	div    %ebp
  801c74:	89 cf                	mov    %ecx,%edi
  801c76:	89 fa                	mov    %edi,%edx
  801c78:	83 c4 1c             	add    $0x1c,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
  801c80:	39 ce                	cmp    %ecx,%esi
  801c82:	77 28                	ja     801cac <__udivdi3+0x7c>
  801c84:	0f bd fe             	bsr    %esi,%edi
  801c87:	83 f7 1f             	xor    $0x1f,%edi
  801c8a:	75 40                	jne    801ccc <__udivdi3+0x9c>
  801c8c:	39 ce                	cmp    %ecx,%esi
  801c8e:	72 0a                	jb     801c9a <__udivdi3+0x6a>
  801c90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c94:	0f 87 9e 00 00 00    	ja     801d38 <__udivdi3+0x108>
  801c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9f:	89 fa                	mov    %edi,%edx
  801ca1:	83 c4 1c             	add    $0x1c,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
  801ca9:	8d 76 00             	lea    0x0(%esi),%esi
  801cac:	31 ff                	xor    %edi,%edi
  801cae:	31 c0                	xor    %eax,%eax
  801cb0:	89 fa                	mov    %edi,%edx
  801cb2:	83 c4 1c             	add    $0x1c,%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5f                   	pop    %edi
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	f7 f7                	div    %edi
  801cc0:	31 ff                	xor    %edi,%edi
  801cc2:	89 fa                	mov    %edi,%edx
  801cc4:	83 c4 1c             	add    $0x1c,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    
  801ccc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cd1:	89 eb                	mov    %ebp,%ebx
  801cd3:	29 fb                	sub    %edi,%ebx
  801cd5:	89 f9                	mov    %edi,%ecx
  801cd7:	d3 e6                	shl    %cl,%esi
  801cd9:	89 c5                	mov    %eax,%ebp
  801cdb:	88 d9                	mov    %bl,%cl
  801cdd:	d3 ed                	shr    %cl,%ebp
  801cdf:	89 e9                	mov    %ebp,%ecx
  801ce1:	09 f1                	or     %esi,%ecx
  801ce3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ce7:	89 f9                	mov    %edi,%ecx
  801ce9:	d3 e0                	shl    %cl,%eax
  801ceb:	89 c5                	mov    %eax,%ebp
  801ced:	89 d6                	mov    %edx,%esi
  801cef:	88 d9                	mov    %bl,%cl
  801cf1:	d3 ee                	shr    %cl,%esi
  801cf3:	89 f9                	mov    %edi,%ecx
  801cf5:	d3 e2                	shl    %cl,%edx
  801cf7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cfb:	88 d9                	mov    %bl,%cl
  801cfd:	d3 e8                	shr    %cl,%eax
  801cff:	09 c2                	or     %eax,%edx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	89 f2                	mov    %esi,%edx
  801d05:	f7 74 24 0c          	divl   0xc(%esp)
  801d09:	89 d6                	mov    %edx,%esi
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	f7 e5                	mul    %ebp
  801d0f:	39 d6                	cmp    %edx,%esi
  801d11:	72 19                	jb     801d2c <__udivdi3+0xfc>
  801d13:	74 0b                	je     801d20 <__udivdi3+0xf0>
  801d15:	89 d8                	mov    %ebx,%eax
  801d17:	31 ff                	xor    %edi,%edi
  801d19:	e9 58 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d24:	89 f9                	mov    %edi,%ecx
  801d26:	d3 e2                	shl    %cl,%edx
  801d28:	39 c2                	cmp    %eax,%edx
  801d2a:	73 e9                	jae    801d15 <__udivdi3+0xe5>
  801d2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d2f:	31 ff                	xor    %edi,%edi
  801d31:	e9 40 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	31 c0                	xor    %eax,%eax
  801d3a:	e9 37 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d3f:	90                   	nop

00801d40 <__umoddi3>:
  801d40:	55                   	push   %ebp
  801d41:	57                   	push   %edi
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	83 ec 1c             	sub    $0x1c,%esp
  801d47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d5f:	89 f3                	mov    %esi,%ebx
  801d61:	89 fa                	mov    %edi,%edx
  801d63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d67:	89 34 24             	mov    %esi,(%esp)
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	75 1a                	jne    801d88 <__umoddi3+0x48>
  801d6e:	39 f7                	cmp    %esi,%edi
  801d70:	0f 86 a2 00 00 00    	jbe    801e18 <__umoddi3+0xd8>
  801d76:	89 c8                	mov    %ecx,%eax
  801d78:	89 f2                	mov    %esi,%edx
  801d7a:	f7 f7                	div    %edi
  801d7c:	89 d0                	mov    %edx,%eax
  801d7e:	31 d2                	xor    %edx,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	39 f0                	cmp    %esi,%eax
  801d8a:	0f 87 ac 00 00 00    	ja     801e3c <__umoddi3+0xfc>
  801d90:	0f bd e8             	bsr    %eax,%ebp
  801d93:	83 f5 1f             	xor    $0x1f,%ebp
  801d96:	0f 84 ac 00 00 00    	je     801e48 <__umoddi3+0x108>
  801d9c:	bf 20 00 00 00       	mov    $0x20,%edi
  801da1:	29 ef                	sub    %ebp,%edi
  801da3:	89 fe                	mov    %edi,%esi
  801da5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	d3 e0                	shl    %cl,%eax
  801dad:	89 d7                	mov    %edx,%edi
  801daf:	89 f1                	mov    %esi,%ecx
  801db1:	d3 ef                	shr    %cl,%edi
  801db3:	09 c7                	or     %eax,%edi
  801db5:	89 e9                	mov    %ebp,%ecx
  801db7:	d3 e2                	shl    %cl,%edx
  801db9:	89 14 24             	mov    %edx,(%esp)
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	d3 e0                	shl    %cl,%eax
  801dc0:	89 c2                	mov    %eax,%edx
  801dc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dc6:	d3 e0                	shl    %cl,%eax
  801dc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd0:	89 f1                	mov    %esi,%ecx
  801dd2:	d3 e8                	shr    %cl,%eax
  801dd4:	09 d0                	or     %edx,%eax
  801dd6:	d3 eb                	shr    %cl,%ebx
  801dd8:	89 da                	mov    %ebx,%edx
  801dda:	f7 f7                	div    %edi
  801ddc:	89 d3                	mov    %edx,%ebx
  801dde:	f7 24 24             	mull   (%esp)
  801de1:	89 c6                	mov    %eax,%esi
  801de3:	89 d1                	mov    %edx,%ecx
  801de5:	39 d3                	cmp    %edx,%ebx
  801de7:	0f 82 87 00 00 00    	jb     801e74 <__umoddi3+0x134>
  801ded:	0f 84 91 00 00 00    	je     801e84 <__umoddi3+0x144>
  801df3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801df7:	29 f2                	sub    %esi,%edx
  801df9:	19 cb                	sbb    %ecx,%ebx
  801dfb:	89 d8                	mov    %ebx,%eax
  801dfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e01:	d3 e0                	shl    %cl,%eax
  801e03:	89 e9                	mov    %ebp,%ecx
  801e05:	d3 ea                	shr    %cl,%edx
  801e07:	09 d0                	or     %edx,%eax
  801e09:	89 e9                	mov    %ebp,%ecx
  801e0b:	d3 eb                	shr    %cl,%ebx
  801e0d:	89 da                	mov    %ebx,%edx
  801e0f:	83 c4 1c             	add    $0x1c,%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5f                   	pop    %edi
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    
  801e17:	90                   	nop
  801e18:	89 fd                	mov    %edi,%ebp
  801e1a:	85 ff                	test   %edi,%edi
  801e1c:	75 0b                	jne    801e29 <__umoddi3+0xe9>
  801e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e23:	31 d2                	xor    %edx,%edx
  801e25:	f7 f7                	div    %edi
  801e27:	89 c5                	mov    %eax,%ebp
  801e29:	89 f0                	mov    %esi,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f5                	div    %ebp
  801e2f:	89 c8                	mov    %ecx,%eax
  801e31:	f7 f5                	div    %ebp
  801e33:	89 d0                	mov    %edx,%eax
  801e35:	e9 44 ff ff ff       	jmp    801d7e <__umoddi3+0x3e>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	89 c8                	mov    %ecx,%eax
  801e3e:	89 f2                	mov    %esi,%edx
  801e40:	83 c4 1c             	add    $0x1c,%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5f                   	pop    %edi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
  801e48:	3b 04 24             	cmp    (%esp),%eax
  801e4b:	72 06                	jb     801e53 <__umoddi3+0x113>
  801e4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e51:	77 0f                	ja     801e62 <__umoddi3+0x122>
  801e53:	89 f2                	mov    %esi,%edx
  801e55:	29 f9                	sub    %edi,%ecx
  801e57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e5b:	89 14 24             	mov    %edx,(%esp)
  801e5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e62:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e66:	8b 14 24             	mov    (%esp),%edx
  801e69:	83 c4 1c             	add    $0x1c,%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5f                   	pop    %edi
  801e6f:	5d                   	pop    %ebp
  801e70:	c3                   	ret    
  801e71:	8d 76 00             	lea    0x0(%esi),%esi
  801e74:	2b 04 24             	sub    (%esp),%eax
  801e77:	19 fa                	sbb    %edi,%edx
  801e79:	89 d1                	mov    %edx,%ecx
  801e7b:	89 c6                	mov    %eax,%esi
  801e7d:	e9 71 ff ff ff       	jmp    801df3 <__umoddi3+0xb3>
  801e82:	66 90                	xchg   %ax,%ax
  801e84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e88:	72 ea                	jb     801e74 <__umoddi3+0x134>
  801e8a:	89 d9                	mov    %ebx,%ecx
  801e8c:	e9 62 ff ff ff       	jmp    801df3 <__umoddi3+0xb3>
