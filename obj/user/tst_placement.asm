
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 d5 05 00 00       	call   80060b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/,	//Stack
		0x81b000 /*for the text color variable*/} ;


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 84 00 00 01    	sub    $0x1000084,%esp
#if USE_KHEAP
	//	cprintf_colored(TEXT_cyan,"envID = %d\n",envID);

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	cprintf_colored(TEXT_cyan,"STEP 0: checking Initial WS entries ...\n");
  800042:	83 ec 08             	sub    $0x8,%esp
  800045:	68 a0 21 80 00       	push   $0x8021a0
  80004a:	6a 03                	push   $0x3
  80004c:	e8 85 0a 00 00       	call   800ad6 <cprintf_colored>
  800051:	83 c4 10             	add    $0x10,%esp
	{
		found = sys_check_WS_list(expectedInitialVAs, 15, 0, 1);
  800054:	6a 01                	push   $0x1
  800056:	6a 00                	push   $0x0
  800058:	6a 0f                	push   $0xf
  80005a:	68 00 30 80 00       	push   $0x803000
  80005f:	e8 0b 1e 00 00       	call   801e6f <sys_check_WS_list>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80006a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80006e:	74 14                	je     800084 <_main+0x4c>
  800070:	83 ec 04             	sub    $0x4,%esp
  800073:	68 cc 21 80 00       	push   $0x8021cc
  800078:	6a 17                	push   $0x17
  80007a:	68 0d 22 80 00       	push   $0x80220d
  80007f:	e8 37 07 00 00       	call   8007bb <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800084:	a1 60 30 80 00       	mov    0x803060,%eax
  800089:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
  80008f:	85 c0                	test   %eax,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 24 22 80 00       	push   $0x802224
  80009b:	6a 1b                	push   $0x1b
  80009d:	68 0d 22 80 00       	push   $0x80220d
  8000a2:	e8 14 07 00 00       	call   8007bb <_panic>
		/*====================================*/
	}
	int eval = 0;
  8000a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan,"\nSTEP 1: checking USER KERNEL STACK... [20%]\n");
  8000b5:	83 ec 08             	sub    $0x8,%esp
  8000b8:	68 64 22 80 00       	push   $0x802264
  8000bd:	6a 03                	push   $0x3
  8000bf:	e8 12 0a 00 00       	call   800ad6 <cprintf_colored>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 stackIsCorrect;
		sys_utilities("__CheckUserKernStack__", (uint32)(&stackIsCorrect));
  8000c7:	8d 85 d8 ff ff fe    	lea    -0x1000028(%ebp),%eax
  8000cd:	83 ec 08             	sub    $0x8,%esp
  8000d0:	50                   	push   %eax
  8000d1:	68 92 22 80 00       	push   $0x802292
  8000d6:	e8 d1 1d 00 00       	call   801eac <sys_utilities>
  8000db:	83 c4 10             	add    $0x10,%esp
		if (!stackIsCorrect)
  8000de:	8b 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%eax
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	75 19                	jne    800101 <_main+0xc9>
		{
			is_correct = 0;
  8000e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf_colored(TEXT_TESTERR_CLR,"User Kernel Stack is not set correctly\n");
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	68 ac 22 80 00       	push   $0x8022ac
  8000f7:	6a 0c                	push   $0xc
  8000f9:	e8 d8 09 00 00       	call   800ad6 <cprintf_colored>
  8000fe:	83 c4 10             	add    $0x10,%esp
		}
	}
	if (is_correct) eval += 20;
  800101:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800105:	74 04                	je     80010b <_main+0xd3>
  800107:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

	cprintf_colored(TEXT_cyan,"\nSTEP 2: checking PLACEMENT...\n");
  80010b:	83 ec 08             	sub    $0x8,%esp
  80010e:	68 d4 22 80 00       	push   $0x8022d4
  800113:	6a 03                	push   $0x3
  800115:	e8 bc 09 00 00       	call   800ad6 <cprintf_colored>
  80011a:	83 c4 10             	add    $0x10,%esp
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011d:	e8 d6 19 00 00       	call   801af8 <sys_pf_calculate_allocated_pages>
  800122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int freePages = sys_calculate_free_frames();
  800125:	e8 83 19 00 00       	call   801aad <sys_calculate_free_frames>
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		//2 stack pages & page table
		int i=PAGE_SIZE*1024;
  80012d:	c7 45 ec 00 00 40 00 	movl   $0x400000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800134:	eb 11                	jmp    800147 <_main+0x10f>
		{
			arr[i] = 1;
  800136:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80013c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80013f:	01 d0                	add    %edx,%eax
  800141:	c6 00 01             	movb   $0x1,(%eax)
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		int freePages = sys_calculate_free_frames();
		//2 stack pages & page table
		int i=PAGE_SIZE*1024;
		for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800144:	ff 45 ec             	incl   -0x14(%ebp)
  800147:	81 7d ec 00 10 40 00 	cmpl   $0x401000,-0x14(%ebp)
  80014e:	7e e6                	jle    800136 <_main+0xfe>
		{
			arr[i] = 1;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*2;
  800150:	c7 45 ec 00 00 80 00 	movl   $0x800000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800157:	eb 11                	jmp    80016a <_main+0x132>
		{
			arr[i] = 2;
  800159:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80015f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800162:	01 d0                	add    %edx,%eax
  800164:	c6 00 02             	movb   $0x2,(%eax)
			arr[i] = 1;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*2;
		for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800167:	ff 45 ec             	incl   -0x14(%ebp)
  80016a:	81 7d ec 00 10 80 00 	cmpl   $0x801000,-0x14(%ebp)
  800171:	7e e6                	jle    800159 <_main+0x121>
		{
			arr[i] = 2;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*3;
  800173:	c7 45 ec 00 00 c0 00 	movl   $0xc00000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*3 + PAGE_SIZE);i++)
  80017a:	eb 11                	jmp    80018d <_main+0x155>
		{
			arr[i] = 3;
  80017c:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	c6 00 03             	movb   $0x3,(%eax)
			arr[i] = 2;
		}

		//2 stack pages & page table
		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3 + PAGE_SIZE);i++)
  80018a:	ff 45 ec             	incl   -0x14(%ebp)
  80018d:	81 7d ec 00 10 c0 00 	cmpl   $0xc01000,-0x14(%ebp)
  800194:	7e e6                	jle    80017c <_main+0x144>
		{
			arr[i] = 3;
		}

		is_correct = 1;
  800196:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		cprintf_colored(TEXT_cyan,"	STEP A: checking PLACEMENT fault handling... [30%] \n");
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	68 f4 22 80 00       	push   $0x8022f4
  8001a5:	6a 03                	push   $0x3
  8001a7:	e8 2a 09 00 00       	call   800ad6 <cprintf_colored>
  8001ac:	83 c4 10             	add    $0x10,%esp
		{
			if( arr[PAGE_SIZE*1024] !=  1)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001af:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  8001b5:	3c 01                	cmp    $0x1,%al
  8001b7:	74 19                	je     8001d2 <_main+0x19a>
  8001b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	68 2c 23 80 00       	push   $0x80232c
  8001c8:	6a 0c                	push   $0xc
  8001ca:	e8 07 09 00 00       	call   800ad6 <cprintf_colored>
  8001cf:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1025] !=  1)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001d2:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  8001d8:	3c 01                	cmp    $0x1,%al
  8001da:	74 19                	je     8001f5 <_main+0x1bd>
  8001dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	68 2c 23 80 00       	push   $0x80232c
  8001eb:	6a 0c                	push   $0xc
  8001ed:	e8 e4 08 00 00       	call   800ad6 <cprintf_colored>
  8001f2:	83 c4 10             	add    $0x10,%esp

			if( arr[PAGE_SIZE*1024*2] !=  2)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  8001f5:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001fb:	3c 02                	cmp    $0x2,%al
  8001fd:	74 19                	je     800218 <_main+0x1e0>
  8001ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800206:	83 ec 08             	sub    $0x8,%esp
  800209:	68 2c 23 80 00       	push   $0x80232c
  80020e:	6a 0c                	push   $0xc
  800210:	e8 c1 08 00 00       	call   800ad6 <cprintf_colored>
  800215:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  2)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  800218:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  80021e:	3c 02                	cmp    $0x2,%al
  800220:	74 19                	je     80023b <_main+0x203>
  800222:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	68 2c 23 80 00       	push   $0x80232c
  800231:	6a 0c                	push   $0xc
  800233:	e8 9e 08 00 00       	call   800ad6 <cprintf_colored>
  800238:	83 c4 10             	add    $0x10,%esp

			if( arr[PAGE_SIZE*1024*3] !=  3)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  80023b:	8a 85 dc ff bf ff    	mov    -0x400024(%ebp),%al
  800241:	3c 03                	cmp    $0x3,%al
  800243:	74 19                	je     80025e <_main+0x226>
  800245:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	68 2c 23 80 00       	push   $0x80232c
  800254:	6a 0c                	push   $0xc
  800256:	e8 7b 08 00 00       	call   800ad6 <cprintf_colored>
  80025b:	83 c4 10             	add    $0x10,%esp
			if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  80025e:	8a 85 dc 0f c0 ff    	mov    -0x3ff024(%ebp),%al
  800264:	3c 03                	cmp    $0x3,%al
  800266:	74 19                	je     800281 <_main+0x249>
  800268:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	68 2c 23 80 00       	push   $0x80232c
  800277:	6a 0c                	push   $0xc
  800279:	e8 58 08 00 00       	call   800ad6 <cprintf_colored>
  80027e:	83 c4 10             	add    $0x10,%esp

			if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf_colored(TEXT_cyan,"new stack pages should NOT be written to Page File until evicted as victim\n");}
  800281:	e8 72 18 00 00       	call   801af8 <sys_pf_calculate_allocated_pages>
  800286:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800289:	74 19                	je     8002a4 <_main+0x26c>
  80028b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 4c 23 80 00       	push   $0x80234c
  80029a:	6a 03                	push   $0x3
  80029c:	e8 35 08 00 00       	call   800ad6 <cprintf_colored>
  8002a1:	83 c4 10             	add    $0x10,%esp

			int expected = 6 /*pages*/ + 3 /*tables*/;
  8002a4:	c7 45 dc 09 00 00 00 	movl   $0x9,-0x24(%ebp)
			if( (freePages - sys_calculate_free_frames() ) != expected )
  8002ab:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002ae:	e8 fa 17 00 00       	call   801aad <sys_calculate_free_frames>
  8002b3:	29 c3                	sub    %eax,%ebx
  8002b5:	89 da                	mov    %ebx,%edx
  8002b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ba:	39 c2                	cmp    %eax,%edx
  8002bc:	74 26                	je     8002e4 <_main+0x2ac>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  8002be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002c5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8002c8:	e8 e0 17 00 00       	call   801aad <sys_calculate_free_frames>
  8002cd:	29 c3                	sub    %eax,%ebx
  8002cf:	89 d8                	mov    %ebx,%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d5:	68 98 23 80 00       	push   $0x802398
  8002da:	6a 0c                	push   $0xc
  8002dc:	e8 f5 07 00 00       	call   800ad6 <cprintf_colored>
  8002e1:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan,"	STEP A finished: PLACEMENT fault handling !\n\n\n");
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	68 e0 23 80 00       	push   $0x8023e0
  8002ec:	6a 03                	push   $0x3
  8002ee:	e8 e3 07 00 00       	call   800ad6 <cprintf_colored>
  8002f3:	83 c4 10             	add    $0x10,%esp

		if (is_correct)
  8002f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002fa:	74 04                	je     800300 <_main+0x2c8>
		{
			eval += 30;
  8002fc:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
		is_correct = 1;
  800300:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		cprintf_colored(TEXT_cyan,"	STEP B: checking WS entries... [30%]\n");
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	68 10 24 80 00       	push   $0x802410
  80030f:	6a 03                	push   $0x3
  800311:	e8 c0 07 00 00       	call   800ad6 <cprintf_colored>
  800316:	83 c4 10             	add    $0x10,%esp
		{
			uint32 expectedPages[21] ;
			{
				expectedPages[0] = 0x800000 ;
  800319:	c7 85 80 ff ff fe 00 	movl   $0x800000,-0x1000080(%ebp)
  800320:	00 80 00 
				expectedPages[1] = 0x801000 ;
  800323:	c7 85 84 ff ff fe 00 	movl   $0x801000,-0x100007c(%ebp)
  80032a:	10 80 00 
				expectedPages[2] = 0x802000 ;
  80032d:	c7 85 88 ff ff fe 00 	movl   $0x802000,-0x1000078(%ebp)
  800334:	20 80 00 
				expectedPages[3] = 0x803000 ;
  800337:	c7 85 8c ff ff fe 00 	movl   $0x803000,-0x1000074(%ebp)
  80033e:	30 80 00 
				expectedPages[4] = 0x804000 ;
  800341:	c7 85 90 ff ff fe 00 	movl   $0x804000,-0x1000070(%ebp)
  800348:	40 80 00 
				expectedPages[5] = 0x805000 ;
  80034b:	c7 85 94 ff ff fe 00 	movl   $0x805000,-0x100006c(%ebp)
  800352:	50 80 00 
				expectedPages[6] = 0x806000 ;
  800355:	c7 85 98 ff ff fe 00 	movl   $0x806000,-0x1000068(%ebp)
  80035c:	60 80 00 
				expectedPages[7] = 0x807000 ;
  80035f:	c7 85 9c ff ff fe 00 	movl   $0x807000,-0x1000064(%ebp)
  800366:	70 80 00 
				expectedPages[8] = 0x808000 ;
  800369:	c7 85 a0 ff ff fe 00 	movl   $0x808000,-0x1000060(%ebp)
  800370:	80 80 00 
				expectedPages[9] = 0x809000 ;
  800373:	c7 85 a4 ff ff fe 00 	movl   $0x809000,-0x100005c(%ebp)
  80037a:	90 80 00 
				expectedPages[10] = 0x80a000 ;
  80037d:	c7 85 a8 ff ff fe 00 	movl   $0x80a000,-0x1000058(%ebp)
  800384:	a0 80 00 
				expectedPages[11] = 0x80b000 ;
  800387:	c7 85 ac ff ff fe 00 	movl   $0x80b000,-0x1000054(%ebp)
  80038e:	b0 80 00 
				expectedPages[12] = 0xeebfd000 ;
  800391:	c7 85 b0 ff ff fe 00 	movl   $0xeebfd000,-0x1000050(%ebp)
  800398:	d0 bf ee 
				expectedPages[13] = 0xedbfd000 ;
  80039b:	c7 85 b4 ff ff fe 00 	movl   $0xedbfd000,-0x100004c(%ebp)
  8003a2:	d0 bf ed 
				expectedPages[14] = 0x81b000 ;
  8003a5:	c7 85 b8 ff ff fe 00 	movl   $0x81b000,-0x1000048(%ebp)
  8003ac:	b0 81 00 
				expectedPages[15] = 0xedffd000 ;
  8003af:	c7 85 bc ff ff fe 00 	movl   $0xedffd000,-0x1000044(%ebp)
  8003b6:	d0 ff ed 
				expectedPages[16] = 0xedffe000 ;
  8003b9:	c7 85 c0 ff ff fe 00 	movl   $0xedffe000,-0x1000040(%ebp)
  8003c0:	e0 ff ed 
				expectedPages[17] = 0xee3fd000 ;
  8003c3:	c7 85 c4 ff ff fe 00 	movl   $0xee3fd000,-0x100003c(%ebp)
  8003ca:	d0 3f ee 
				expectedPages[18] = 0xee3fe000 ;
  8003cd:	c7 85 c8 ff ff fe 00 	movl   $0xee3fe000,-0x1000038(%ebp)
  8003d4:	e0 3f ee 
				expectedPages[19] = 0xee7fd000 ;
  8003d7:	c7 85 cc ff ff fe 00 	movl   $0xee7fd000,-0x1000034(%ebp)
  8003de:	d0 7f ee 
				expectedPages[20] = 0xee7fe000 ;
  8003e1:	c7 85 d0 ff ff fe 00 	movl   $0xee7fe000,-0x1000030(%ebp)
  8003e8:	e0 7f ee 
			}
			found = sys_check_WS_list(expectedPages, 21, 0, 1);
  8003eb:	6a 01                	push   $0x1
  8003ed:	6a 00                	push   $0x0
  8003ef:	6a 15                	push   $0x15
  8003f1:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8003f7:	50                   	push   %eax
  8003f8:	e8 72 1a 00 00       	call   801e6f <sys_check_WS_list>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (found != 1)
  800403:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800407:	74 19                	je     800422 <_main+0x3ea>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800409:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	68 38 24 80 00       	push   $0x802438
  800418:	6a 0c                	push   $0xc
  80041a:	e8 b7 06 00 00       	call   800ad6 <cprintf_colored>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan,"	STEP B finished: WS entries test \n\n\n");
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	68 8c 24 80 00       	push   $0x80248c
  80042a:	6a 03                	push   $0x3
  80042c:	e8 a5 06 00 00       	call   800ad6 <cprintf_colored>
  800431:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800434:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800438:	74 04                	je     80043e <_main+0x406>
		{
			eval += 30;
  80043a:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
		is_correct = 1;
  80043e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		cprintf_colored(TEXT_cyan,"	STEP C: checking working sets WHEN BECOMES FULL... [20%]\n");
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	68 b4 24 80 00       	push   $0x8024b4
  80044d:	6a 03                	push   $0x3
  80044f:	e8 82 06 00 00       	call   800ad6 <cprintf_colored>
  800454:	83 c4 10             	add    $0x10,%esp
		{
			/*NO NEED FOR THIS IF REPL IS "LRU"*/
			if(myEnv->page_last_WS_element != NULL)
  800457:	a1 60 30 80 00       	mov    0x803060,%eax
  80045c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
  800462:	85 c0                	test   %eax,%eax
  800464:	74 19                	je     80047f <_main+0x447>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  800466:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	68 f0 24 80 00       	push   $0x8024f0
  800475:	6a 0c                	push   $0xc
  800477:	e8 5a 06 00 00       	call   800ad6 <cprintf_colored>
  80047c:	83 c4 10             	add    $0x10,%esp

			//1 stack page
			i=PAGE_SIZE*1024*3 + 2*PAGE_SIZE;
  80047f:	c7 45 ec 00 20 c0 00 	movl   $0xc02000,-0x14(%ebp)
			arr[i] = 4;
  800486:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80048c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	c6 00 04             	movb   $0x4,(%eax)

			if( arr[i] != 4)  { is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PLACEMENT of stack page failed\n");}
  800494:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  80049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	8a 00                	mov    (%eax),%al
  8004a1:	3c 04                	cmp    $0x4,%al
  8004a3:	74 19                	je     8004be <_main+0x486>
  8004a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	68 2c 23 80 00       	push   $0x80232c
  8004b4:	6a 0c                	push   $0xc
  8004b6:	e8 1b 06 00 00       	call   800ad6 <cprintf_colored>
  8004bb:	83 c4 10             	add    $0x10,%esp
			//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
			//				0x800000,0x801000,0x802000,0x803000,
			//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};
			uint32 expectedPages[22] ;
			{
				expectedPages[0] = 0x800000 ;
  8004be:	c7 85 80 ff ff fe 00 	movl   $0x800000,-0x1000080(%ebp)
  8004c5:	00 80 00 
				expectedPages[1] = 0x801000 ;
  8004c8:	c7 85 84 ff ff fe 00 	movl   $0x801000,-0x100007c(%ebp)
  8004cf:	10 80 00 
				expectedPages[2] = 0x802000 ;
  8004d2:	c7 85 88 ff ff fe 00 	movl   $0x802000,-0x1000078(%ebp)
  8004d9:	20 80 00 
				expectedPages[3] = 0x803000 ;
  8004dc:	c7 85 8c ff ff fe 00 	movl   $0x803000,-0x1000074(%ebp)
  8004e3:	30 80 00 
				expectedPages[4] = 0x804000 ;
  8004e6:	c7 85 90 ff ff fe 00 	movl   $0x804000,-0x1000070(%ebp)
  8004ed:	40 80 00 
				expectedPages[5] = 0x805000 ;
  8004f0:	c7 85 94 ff ff fe 00 	movl   $0x805000,-0x100006c(%ebp)
  8004f7:	50 80 00 
				expectedPages[6] = 0x806000 ;
  8004fa:	c7 85 98 ff ff fe 00 	movl   $0x806000,-0x1000068(%ebp)
  800501:	60 80 00 
				expectedPages[7] = 0x807000 ;
  800504:	c7 85 9c ff ff fe 00 	movl   $0x807000,-0x1000064(%ebp)
  80050b:	70 80 00 
				expectedPages[8] = 0x808000 ;
  80050e:	c7 85 a0 ff ff fe 00 	movl   $0x808000,-0x1000060(%ebp)
  800515:	80 80 00 
				expectedPages[9] = 0x809000 ;
  800518:	c7 85 a4 ff ff fe 00 	movl   $0x809000,-0x100005c(%ebp)
  80051f:	90 80 00 
				expectedPages[10] = 0x80a000 ;
  800522:	c7 85 a8 ff ff fe 00 	movl   $0x80a000,-0x1000058(%ebp)
  800529:	a0 80 00 
				expectedPages[11] = 0x80b000 ;
  80052c:	c7 85 ac ff ff fe 00 	movl   $0x80b000,-0x1000054(%ebp)
  800533:	b0 80 00 
				expectedPages[12] = 0xeebfd000 ;
  800536:	c7 85 b0 ff ff fe 00 	movl   $0xeebfd000,-0x1000050(%ebp)
  80053d:	d0 bf ee 
				expectedPages[13] = 0xedbfd000 ;
  800540:	c7 85 b4 ff ff fe 00 	movl   $0xedbfd000,-0x100004c(%ebp)
  800547:	d0 bf ed 
				expectedPages[14] = 0x81b000 ;
  80054a:	c7 85 b8 ff ff fe 00 	movl   $0x81b000,-0x1000048(%ebp)
  800551:	b0 81 00 
				expectedPages[15] = 0xedffd000 ;
  800554:	c7 85 bc ff ff fe 00 	movl   $0xedffd000,-0x1000044(%ebp)
  80055b:	d0 ff ed 
				expectedPages[16] = 0xedffe000 ;
  80055e:	c7 85 c0 ff ff fe 00 	movl   $0xedffe000,-0x1000040(%ebp)
  800565:	e0 ff ed 
				expectedPages[17] = 0xee3fd000 ;
  800568:	c7 85 c4 ff ff fe 00 	movl   $0xee3fd000,-0x100003c(%ebp)
  80056f:	d0 3f ee 
				expectedPages[18] = 0xee3fe000 ;
  800572:	c7 85 c8 ff ff fe 00 	movl   $0xee3fe000,-0x1000038(%ebp)
  800579:	e0 3f ee 
				expectedPages[19] = 0xee7fd000 ;
  80057c:	c7 85 cc ff ff fe 00 	movl   $0xee7fd000,-0x1000034(%ebp)
  800583:	d0 7f ee 
				expectedPages[20] = 0xee7fe000 ;
  800586:	c7 85 d0 ff ff fe 00 	movl   $0xee7fe000,-0x1000030(%ebp)
  80058d:	e0 7f ee 
				expectedPages[21] = 0xee7ff000 ;
  800590:	c7 85 d4 ff ff fe 00 	movl   $0xee7ff000,-0x100002c(%ebp)
  800597:	f0 7f ee 
			}
			found = sys_check_WS_list(expectedPages, 22, 0x800000, 1);
  80059a:	6a 01                	push   $0x1
  80059c:	68 00 00 80 00       	push   $0x800000
  8005a1:	6a 16                	push   $0x16
  8005a3:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8005a9:	50                   	push   %eax
  8005aa:	e8 c0 18 00 00       	call   801e6f <sys_check_WS_list>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (found != 1)
  8005b5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8005b9:	74 19                	je     8005d4 <_main+0x59c>
			{ is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  8005bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	68 38 24 80 00       	push   $0x802438
  8005ca:	6a 0c                	push   $0xc
  8005cc:	e8 05 05 00 00       	call   800ad6 <cprintf_colored>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		cprintf_colored(TEXT_cyan, "	STEP C finished: WS is FULL now\n\n\n");
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	68 48 25 80 00       	push   $0x802548
  8005dc:	6a 03                	push   $0x3
  8005de:	e8 f3 04 00 00       	call   800ad6 <cprintf_colored>
  8005e3:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  8005e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005ea:	74 04                	je     8005f0 <_main+0x5b8>
		{
			eval += 20;
  8005ec:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}
	cprintf_colored(TEXT_light_green, "%~\nTest of KERNEL STACK & PAGE PLACEMENT completed. Eval = %d%\n\n", eval);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	68 6c 25 80 00       	push   $0x80256c
  8005fb:	6a 0a                	push   $0xa
  8005fd:	e8 d4 04 00 00       	call   800ad6 <cprintf_colored>
  800602:	83 c4 10             	add    $0x10,%esp

	return;
  800605:	90                   	nop
#endif
}
  800606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800609:	c9                   	leave  
  80060a:	c3                   	ret    

0080060b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
  80060e:	57                   	push   %edi
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800614:	e8 5d 16 00 00       	call   801c76 <sys_getenvindex>
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80061c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80061f:	89 d0                	mov    %edx,%eax
  800621:	01 c0                	add    %eax,%eax
  800623:	01 d0                	add    %edx,%eax
  800625:	c1 e0 02             	shl    $0x2,%eax
  800628:	01 d0                	add    %edx,%eax
  80062a:	c1 e0 02             	shl    $0x2,%eax
  80062d:	01 d0                	add    %edx,%eax
  80062f:	c1 e0 03             	shl    $0x3,%eax
  800632:	01 d0                	add    %edx,%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80063c:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800641:	a1 60 30 80 00       	mov    0x803060,%eax
  800646:	8a 40 20             	mov    0x20(%eax),%al
  800649:	84 c0                	test   %al,%al
  80064b:	74 0d                	je     80065a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80064d:	a1 60 30 80 00       	mov    0x803060,%eax
  800652:	83 c0 20             	add    $0x20,%eax
  800655:	a3 40 30 80 00       	mov    %eax,0x803040

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80065a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065e:	7e 0a                	jle    80066a <libmain+0x5f>
		binaryname = argv[0];
  800660:	8b 45 0c             	mov    0xc(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	a3 40 30 80 00       	mov    %eax,0x803040

	// call user main routine
	_main(argc, argv);
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	ff 75 08             	pushl  0x8(%ebp)
  800673:	e8 c0 f9 ff ff       	call   800038 <_main>
  800678:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80067b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800680:	85 c0                	test   %eax,%eax
  800682:	0f 84 01 01 00 00    	je     800789 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800688:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80068e:	bb a8 26 80 00       	mov    $0x8026a8,%ebx
  800693:	ba 0e 00 00 00       	mov    $0xe,%edx
  800698:	89 c7                	mov    %eax,%edi
  80069a:	89 de                	mov    %ebx,%esi
  80069c:	89 d1                	mov    %edx,%ecx
  80069e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006a8:	b0 00                	mov    $0x0,%al
  8006aa:	89 d7                	mov    %edx,%edi
  8006ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	50                   	push   %eax
  8006bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006c2:	50                   	push   %eax
  8006c3:	e8 e4 17 00 00       	call   801eac <sys_utilities>
  8006c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006cb:	e8 2d 13 00 00       	call   8019fd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006d0:	83 ec 0c             	sub    $0xc,%esp
  8006d3:	68 c8 25 80 00       	push   $0x8025c8
  8006d8:	e8 cc 03 00 00       	call   800aa9 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 18                	je     8006ff <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006e7:	e8 de 17 00 00       	call   801eca <sys_get_optimal_num_faults>
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 f0 25 80 00       	push   $0x8025f0
  8006f5:	e8 af 03 00 00       	call   800aa9 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	eb 59                	jmp    800758 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ff:	a1 60 30 80 00       	mov    0x803060,%eax
  800704:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80070a:	a1 60 30 80 00       	mov    0x803060,%eax
  80070f:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800715:	83 ec 04             	sub    $0x4,%esp
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	68 14 26 80 00       	push   $0x802614
  80071f:	e8 85 03 00 00       	call   800aa9 <cprintf>
  800724:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800727:	a1 60 30 80 00       	mov    0x803060,%eax
  80072c:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800732:	a1 60 30 80 00       	mov    0x803060,%eax
  800737:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80073d:	a1 60 30 80 00       	mov    0x803060,%eax
  800742:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800748:	51                   	push   %ecx
  800749:	52                   	push   %edx
  80074a:	50                   	push   %eax
  80074b:	68 3c 26 80 00       	push   $0x80263c
  800750:	e8 54 03 00 00       	call   800aa9 <cprintf>
  800755:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800758:	a1 60 30 80 00       	mov    0x803060,%eax
  80075d:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	50                   	push   %eax
  800767:	68 94 26 80 00       	push   $0x802694
  80076c:	e8 38 03 00 00       	call   800aa9 <cprintf>
  800771:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	68 c8 25 80 00       	push   $0x8025c8
  80077c:	e8 28 03 00 00       	call   800aa9 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800784:	e8 8e 12 00 00       	call   801a17 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800789:	e8 1f 00 00 00       	call   8007ad <exit>
}
  80078e:	90                   	nop
  80078f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800792:	5b                   	pop    %ebx
  800793:	5e                   	pop    %esi
  800794:	5f                   	pop    %edi
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079d:	83 ec 0c             	sub    $0xc,%esp
  8007a0:	6a 00                	push   $0x0
  8007a2:	e8 9b 14 00 00       	call   801c42 <sys_destroy_env>
  8007a7:	83 c4 10             	add    $0x10,%esp
}
  8007aa:	90                   	nop
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <exit>:

void
exit(void)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b3:	e8 f0 14 00 00       	call   801ca8 <sys_exit_env>
}
  8007b8:	90                   	nop
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007ca:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	74 16                	je     8007e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d3:	a1 58 b1 81 00       	mov    0x81b158,%eax
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	50                   	push   %eax
  8007dc:	68 0c 27 80 00       	push   $0x80270c
  8007e1:	e8 c3 02 00 00       	call   800aa9 <cprintf>
  8007e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007e9:	a1 40 30 80 00       	mov    0x803040,%eax
  8007ee:	83 ec 0c             	sub    $0xc,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	ff 75 08             	pushl  0x8(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	68 14 27 80 00       	push   $0x802714
  8007fd:	6a 74                	push   $0x74
  8007ff:	e8 d2 02 00 00       	call   800ad6 <cprintf_colored>
  800804:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 f4             	pushl  -0xc(%ebp)
  800810:	50                   	push   %eax
  800811:	e8 24 02 00 00       	call   800a3a <vcprintf>
  800816:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	6a 00                	push   $0x0
  80081e:	68 3c 27 80 00       	push   $0x80273c
  800823:	e8 12 02 00 00       	call   800a3a <vcprintf>
  800828:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80082b:	e8 7d ff ff ff       	call   8007ad <exit>

	// should not return here
	while (1) ;
  800830:	eb fe                	jmp    800830 <_panic+0x75>

00800832 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	53                   	push   %ebx
  800836:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800839:	a1 60 30 80 00       	mov    0x803060,%eax
  80083e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	39 c2                	cmp    %eax,%edx
  800849:	74 14                	je     80085f <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	68 40 27 80 00       	push   $0x802740
  800853:	6a 26                	push   $0x26
  800855:	68 8c 27 80 00       	push   $0x80278c
  80085a:	e8 5c ff ff ff       	call   8007bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800866:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80086d:	e9 d9 00 00 00       	jmp    80094b <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800875:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	85 c0                	test   %eax,%eax
  800885:	75 08                	jne    80088f <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800887:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80088a:	e9 b9 00 00 00       	jmp    800948 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80088f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800896:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80089d:	eb 79                	jmp    800918 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80089f:	a1 60 30 80 00       	mov    0x803060,%eax
  8008a4:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8008aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ad:	89 d0                	mov    %edx,%eax
  8008af:	01 c0                	add    %eax,%eax
  8008b1:	01 d0                	add    %edx,%eax
  8008b3:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8008ba:	01 d8                	add    %ebx,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	01 c8                	add    %ecx,%eax
  8008c0:	8a 40 04             	mov    0x4(%eax),%al
  8008c3:	84 c0                	test   %al,%al
  8008c5:	75 4e                	jne    800915 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c7:	a1 60 30 80 00       	mov    0x803060,%eax
  8008cc:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8008d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d5:	89 d0                	mov    %edx,%eax
  8008d7:	01 c0                	add    %eax,%eax
  8008d9:	01 d0                	add    %edx,%eax
  8008db:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8008e2:	01 d8                	add    %ebx,%eax
  8008e4:	01 d0                	add    %edx,%eax
  8008e6:	01 c8                	add    %ecx,%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008f5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	01 c8                	add    %ecx,%eax
  800906:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800908:	39 c2                	cmp    %eax,%edx
  80090a:	75 09                	jne    800915 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80090c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800913:	eb 19                	jmp    80092e <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800915:	ff 45 e8             	incl   -0x18(%ebp)
  800918:	a1 60 30 80 00       	mov    0x803060,%eax
  80091d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800926:	39 c2                	cmp    %eax,%edx
  800928:	0f 87 71 ff ff ff    	ja     80089f <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80092e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800932:	75 14                	jne    800948 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 98 27 80 00       	push   $0x802798
  80093c:	6a 3a                	push   $0x3a
  80093e:	68 8c 27 80 00       	push   $0x80278c
  800943:	e8 73 fe ff ff       	call   8007bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800948:	ff 45 f0             	incl   -0x10(%ebp)
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800951:	0f 8c 1b ff ff ff    	jl     800872 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800957:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80095e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800965:	eb 2e                	jmp    800995 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800967:	a1 60 30 80 00       	mov    0x803060,%eax
  80096c:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800972:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800975:	89 d0                	mov    %edx,%eax
  800977:	01 c0                	add    %eax,%eax
  800979:	01 d0                	add    %edx,%eax
  80097b:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800982:	01 d8                	add    %ebx,%eax
  800984:	01 d0                	add    %edx,%eax
  800986:	01 c8                	add    %ecx,%eax
  800988:	8a 40 04             	mov    0x4(%eax),%al
  80098b:	3c 01                	cmp    $0x1,%al
  80098d:	75 03                	jne    800992 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80098f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800992:	ff 45 e0             	incl   -0x20(%ebp)
  800995:	a1 60 30 80 00       	mov    0x803060,%eax
  80099a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a3:	39 c2                	cmp    %eax,%edx
  8009a5:	77 c0                	ja     800967 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009aa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009ad:	74 14                	je     8009c3 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8009af:	83 ec 04             	sub    $0x4,%esp
  8009b2:	68 ec 27 80 00       	push   $0x8027ec
  8009b7:	6a 44                	push   $0x44
  8009b9:	68 8c 27 80 00       	push   $0x80278c
  8009be:	e8 f8 fd ff ff       	call   8007bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009c3:	90                   	nop
  8009c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	53                   	push   %ebx
  8009cd:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	8d 48 01             	lea    0x1(%eax),%ecx
  8009d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009db:	89 0a                	mov    %ecx,(%edx)
  8009dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e0:	88 d1                	mov    %dl,%cl
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009f3:	75 30                	jne    800a25 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009f5:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  8009fb:	a0 84 30 80 00       	mov    0x803084,%al
  800a00:	0f b6 c0             	movzbl %al,%eax
  800a03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a06:	8b 09                	mov    (%ecx),%ecx
  800a08:	89 cb                	mov    %ecx,%ebx
  800a0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0d:	83 c1 08             	add    $0x8,%ecx
  800a10:	52                   	push   %edx
  800a11:	50                   	push   %eax
  800a12:	53                   	push   %ebx
  800a13:	51                   	push   %ecx
  800a14:	e8 a0 0f 00 00       	call   8019b9 <sys_cputs>
  800a19:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	8b 40 04             	mov    0x4(%eax),%eax
  800a2b:	8d 50 01             	lea    0x1(%eax),%edx
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a34:	90                   	nop
  800a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a43:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a4a:	00 00 00 
	b.cnt = 0;
  800a4d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a54:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	ff 75 08             	pushl  0x8(%ebp)
  800a5d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a63:	50                   	push   %eax
  800a64:	68 c9 09 80 00       	push   $0x8009c9
  800a69:	e8 5a 02 00 00       	call   800cc8 <vprintfmt>
  800a6e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a71:	8b 15 5c b1 81 00    	mov    0x81b15c,%edx
  800a77:	a0 84 30 80 00       	mov    0x803084,%al
  800a7c:	0f b6 c0             	movzbl %al,%eax
  800a7f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a85:	52                   	push   %edx
  800a86:	50                   	push   %eax
  800a87:	51                   	push   %ecx
  800a88:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a8e:	83 c0 08             	add    $0x8,%eax
  800a91:	50                   	push   %eax
  800a92:	e8 22 0f 00 00       	call   8019b9 <sys_cputs>
  800a97:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a9a:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  800aa1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aaf:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  800ab6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	e8 6f ff ff ff       	call   800a3a <vcprintf>
  800acb:	83 c4 10             	add    $0x10,%esp
  800ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800adc:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	c1 e0 08             	shl    $0x8,%eax
  800ae9:	a3 5c b1 81 00       	mov    %eax,0x81b15c
	va_start(ap, fmt);
  800aee:	8d 45 0c             	lea    0xc(%ebp),%eax
  800af1:	83 c0 04             	add    $0x4,%eax
  800af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 f4             	pushl  -0xc(%ebp)
  800b00:	50                   	push   %eax
  800b01:	e8 34 ff ff ff       	call   800a3a <vcprintf>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b0c:	c7 05 5c b1 81 00 00 	movl   $0x700,0x81b15c
  800b13:	07 00 00 

	return cnt;
  800b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b21:	e8 d7 0e 00 00       	call   8019fd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b26:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 f4             	pushl  -0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	e8 ff fe ff ff       	call   800a3a <vcprintf>
  800b3b:	83 c4 10             	add    $0x10,%esp
  800b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b41:	e8 d1 0e 00 00       	call   801a17 <sys_unlock_cons>
	return cnt;
  800b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	53                   	push   %ebx
  800b4f:	83 ec 14             	sub    $0x14,%esp
  800b52:	8b 45 10             	mov    0x10(%ebp),%eax
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b5e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b61:	ba 00 00 00 00       	mov    $0x0,%edx
  800b66:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b69:	77 55                	ja     800bc0 <printnum+0x75>
  800b6b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b6e:	72 05                	jb     800b75 <printnum+0x2a>
  800b70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b73:	77 4b                	ja     800bc0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b75:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b78:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b7b:	8b 45 18             	mov    0x18(%ebp),%eax
  800b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b83:	52                   	push   %edx
  800b84:	50                   	push   %eax
  800b85:	ff 75 f4             	pushl  -0xc(%ebp)
  800b88:	ff 75 f0             	pushl  -0x10(%ebp)
  800b8b:	e8 ac 13 00 00       	call   801f3c <__udivdi3>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	ff 75 20             	pushl  0x20(%ebp)
  800b99:	53                   	push   %ebx
  800b9a:	ff 75 18             	pushl  0x18(%ebp)
  800b9d:	52                   	push   %edx
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 a1 ff ff ff       	call   800b4b <printnum>
  800baa:	83 c4 20             	add    $0x20,%esp
  800bad:	eb 1a                	jmp    800bc9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 20             	pushl  0x20(%ebp)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	ff d0                	call   *%eax
  800bbd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bc0:	ff 4d 1c             	decl   0x1c(%ebp)
  800bc3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bc7:	7f e6                	jg     800baf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bc9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	53                   	push   %ebx
  800bd8:	51                   	push   %ecx
  800bd9:	52                   	push   %edx
  800bda:	50                   	push   %eax
  800bdb:	e8 6c 14 00 00       	call   80204c <__umoddi3>
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	05 54 2a 80 00       	add    $0x802a54,%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	0f be c0             	movsbl %al,%eax
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	ff d0                	call   *%eax
  800bf9:	83 c4 10             	add    $0x10,%esp
}
  800bfc:	90                   	nop
  800bfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c05:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c09:	7e 1c                	jle    800c27 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	8d 50 08             	lea    0x8(%eax),%edx
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 10                	mov    %edx,(%eax)
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	83 e8 08             	sub    $0x8,%eax
  800c20:	8b 50 04             	mov    0x4(%eax),%edx
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	eb 40                	jmp    800c67 <getuint+0x65>
	else if (lflag)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 1e                	je     800c4b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	8d 50 04             	lea    0x4(%eax),%edx
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	89 10                	mov    %edx,(%eax)
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 00                	mov    (%eax),%eax
  800c3f:	83 e8 04             	sub    $0x4,%eax
  800c42:	8b 00                	mov    (%eax),%eax
  800c44:	ba 00 00 00 00       	mov    $0x0,%edx
  800c49:	eb 1c                	jmp    800c67 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	8d 50 04             	lea    0x4(%eax),%edx
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	89 10                	mov    %edx,(%eax)
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 00                	mov    (%eax),%eax
  800c5d:	83 e8 04             	sub    $0x4,%eax
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c70:	7e 1c                	jle    800c8e <getint+0x25>
		return va_arg(*ap, long long);
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	8d 50 08             	lea    0x8(%eax),%edx
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	89 10                	mov    %edx,(%eax)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8b 00                	mov    (%eax),%eax
  800c84:	83 e8 08             	sub    $0x8,%eax
  800c87:	8b 50 04             	mov    0x4(%eax),%edx
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	eb 38                	jmp    800cc6 <getint+0x5d>
	else if (lflag)
  800c8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c92:	74 1a                	je     800cae <getint+0x45>
		return va_arg(*ap, long);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	8d 50 04             	lea    0x4(%eax),%edx
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	89 10                	mov    %edx,(%eax)
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	83 e8 04             	sub    $0x4,%eax
  800ca9:	8b 00                	mov    (%eax),%eax
  800cab:	99                   	cltd   
  800cac:	eb 18                	jmp    800cc6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	99                   	cltd   
}
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd0:	eb 17                	jmp    800ce9 <vprintfmt+0x21>
			if (ch == '\0')
  800cd2:	85 db                	test   %ebx,%ebx
  800cd4:	0f 84 c1 03 00 00    	je     80109b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	53                   	push   %ebx
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	ff d0                	call   *%eax
  800ce6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cec:	8d 50 01             	lea    0x1(%eax),%edx
  800cef:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	0f b6 d8             	movzbl %al,%ebx
  800cf7:	83 fb 25             	cmp    $0x25,%ebx
  800cfa:	75 d6                	jne    800cd2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cfc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d00:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	8d 50 01             	lea    0x1(%eax),%edx
  800d22:	89 55 10             	mov    %edx,0x10(%ebp)
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 d8             	movzbl %al,%ebx
  800d2a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d2d:	83 f8 5b             	cmp    $0x5b,%eax
  800d30:	0f 87 3d 03 00 00    	ja     801073 <vprintfmt+0x3ab>
  800d36:	8b 04 85 78 2a 80 00 	mov    0x802a78(,%eax,4),%eax
  800d3d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d3f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d43:	eb d7                	jmp    800d1c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d45:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d49:	eb d1                	jmp    800d1c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d55:	89 d0                	mov    %edx,%eax
  800d57:	c1 e0 02             	shl    $0x2,%eax
  800d5a:	01 d0                	add    %edx,%eax
  800d5c:	01 c0                	add    %eax,%eax
  800d5e:	01 d8                	add    %ebx,%eax
  800d60:	83 e8 30             	sub    $0x30,%eax
  800d63:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d66:	8b 45 10             	mov    0x10(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d6e:	83 fb 2f             	cmp    $0x2f,%ebx
  800d71:	7e 3e                	jle    800db1 <vprintfmt+0xe9>
  800d73:	83 fb 39             	cmp    $0x39,%ebx
  800d76:	7f 39                	jg     800db1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d78:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d7b:	eb d5                	jmp    800d52 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d91:	eb 1f                	jmp    800db2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d97:	79 83                	jns    800d1c <vprintfmt+0x54>
				width = 0;
  800d99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800da0:	e9 77 ff ff ff       	jmp    800d1c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800da5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dac:	e9 6b ff ff ff       	jmp    800d1c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800db1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800db2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db6:	0f 89 60 ff ff ff    	jns    800d1c <vprintfmt+0x54>
				width = precision, precision = -1;
  800dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dc2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dc9:	e9 4e ff ff ff       	jmp    800d1c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dce:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dd1:	e9 46 ff ff ff       	jmp    800d1c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	50                   	push   %eax
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	ff d0                	call   *%eax
  800df3:	83 c4 10             	add    $0x10,%esp
			break;
  800df6:	e9 9b 02 00 00       	jmp    801096 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfe:	83 c0 04             	add    $0x4,%eax
  800e01:	89 45 14             	mov    %eax,0x14(%ebp)
  800e04:	8b 45 14             	mov    0x14(%ebp),%eax
  800e07:	83 e8 04             	sub    $0x4,%eax
  800e0a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e0c:	85 db                	test   %ebx,%ebx
  800e0e:	79 02                	jns    800e12 <vprintfmt+0x14a>
				err = -err;
  800e10:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e12:	83 fb 64             	cmp    $0x64,%ebx
  800e15:	7f 0b                	jg     800e22 <vprintfmt+0x15a>
  800e17:	8b 34 9d c0 28 80 00 	mov    0x8028c0(,%ebx,4),%esi
  800e1e:	85 f6                	test   %esi,%esi
  800e20:	75 19                	jne    800e3b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e22:	53                   	push   %ebx
  800e23:	68 65 2a 80 00       	push   $0x802a65
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	ff 75 08             	pushl  0x8(%ebp)
  800e2e:	e8 70 02 00 00       	call   8010a3 <printfmt>
  800e33:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e36:	e9 5b 02 00 00       	jmp    801096 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e3b:	56                   	push   %esi
  800e3c:	68 6e 2a 80 00       	push   $0x802a6e
  800e41:	ff 75 0c             	pushl  0xc(%ebp)
  800e44:	ff 75 08             	pushl  0x8(%ebp)
  800e47:	e8 57 02 00 00       	call   8010a3 <printfmt>
  800e4c:	83 c4 10             	add    $0x10,%esp
			break;
  800e4f:	e9 42 02 00 00       	jmp    801096 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e54:	8b 45 14             	mov    0x14(%ebp),%eax
  800e57:	83 c0 04             	add    $0x4,%eax
  800e5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	83 e8 04             	sub    $0x4,%eax
  800e63:	8b 30                	mov    (%eax),%esi
  800e65:	85 f6                	test   %esi,%esi
  800e67:	75 05                	jne    800e6e <vprintfmt+0x1a6>
				p = "(null)";
  800e69:	be 71 2a 80 00       	mov    $0x802a71,%esi
			if (width > 0 && padc != '-')
  800e6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e72:	7e 6d                	jle    800ee1 <vprintfmt+0x219>
  800e74:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e78:	74 67                	je     800ee1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	50                   	push   %eax
  800e81:	56                   	push   %esi
  800e82:	e8 1e 03 00 00       	call   8011a5 <strnlen>
  800e87:	83 c4 10             	add    $0x10,%esp
  800e8a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e8d:	eb 16                	jmp    800ea5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e8f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	ff 75 0c             	pushl  0xc(%ebp)
  800e99:	50                   	push   %eax
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	ff d0                	call   *%eax
  800e9f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ea5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ea9:	7f e4                	jg     800e8f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eab:	eb 34                	jmp    800ee1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ead:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800eb1:	74 1c                	je     800ecf <vprintfmt+0x207>
  800eb3:	83 fb 1f             	cmp    $0x1f,%ebx
  800eb6:	7e 05                	jle    800ebd <vprintfmt+0x1f5>
  800eb8:	83 fb 7e             	cmp    $0x7e,%ebx
  800ebb:	7e 12                	jle    800ecf <vprintfmt+0x207>
					putch('?', putdat);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	6a 3f                	push   $0x3f
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	ff d0                	call   *%eax
  800eca:	83 c4 10             	add    $0x10,%esp
  800ecd:	eb 0f                	jmp    800ede <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ecf:	83 ec 08             	sub    $0x8,%esp
  800ed2:	ff 75 0c             	pushl  0xc(%ebp)
  800ed5:	53                   	push   %ebx
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	ff d0                	call   *%eax
  800edb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ede:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee1:	89 f0                	mov    %esi,%eax
  800ee3:	8d 70 01             	lea    0x1(%eax),%esi
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	0f be d8             	movsbl %al,%ebx
  800eeb:	85 db                	test   %ebx,%ebx
  800eed:	74 24                	je     800f13 <vprintfmt+0x24b>
  800eef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ef3:	78 b8                	js     800ead <vprintfmt+0x1e5>
  800ef5:	ff 4d e0             	decl   -0x20(%ebp)
  800ef8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800efc:	79 af                	jns    800ead <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800efe:	eb 13                	jmp    800f13 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f00:	83 ec 08             	sub    $0x8,%esp
  800f03:	ff 75 0c             	pushl  0xc(%ebp)
  800f06:	6a 20                	push   $0x20
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	ff d0                	call   *%eax
  800f0d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f10:	ff 4d e4             	decl   -0x1c(%ebp)
  800f13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f17:	7f e7                	jg     800f00 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f19:	e9 78 01 00 00       	jmp    801096 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 e8             	pushl  -0x18(%ebp)
  800f24:	8d 45 14             	lea    0x14(%ebp),%eax
  800f27:	50                   	push   %eax
  800f28:	e8 3c fd ff ff       	call   800c69 <getint>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3c:	85 d2                	test   %edx,%edx
  800f3e:	79 23                	jns    800f63 <vprintfmt+0x29b>
				putch('-', putdat);
  800f40:	83 ec 08             	sub    $0x8,%esp
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	6a 2d                	push   $0x2d
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f56:	f7 d8                	neg    %eax
  800f58:	83 d2 00             	adc    $0x0,%edx
  800f5b:	f7 da                	neg    %edx
  800f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f63:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f6a:	e9 bc 00 00 00       	jmp    80102b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 e8             	pushl  -0x18(%ebp)
  800f75:	8d 45 14             	lea    0x14(%ebp),%eax
  800f78:	50                   	push   %eax
  800f79:	e8 84 fc ff ff       	call   800c02 <getuint>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f87:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f8e:	e9 98 00 00 00       	jmp    80102b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f93:	83 ec 08             	sub    $0x8,%esp
  800f96:	ff 75 0c             	pushl  0xc(%ebp)
  800f99:	6a 58                	push   $0x58
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	ff d0                	call   *%eax
  800fa0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 58                	push   $0x58
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fb3:	83 ec 08             	sub    $0x8,%esp
  800fb6:	ff 75 0c             	pushl  0xc(%ebp)
  800fb9:	6a 58                	push   $0x58
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	ff d0                	call   *%eax
  800fc0:	83 c4 10             	add    $0x10,%esp
			break;
  800fc3:	e9 ce 00 00 00       	jmp    801096 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fc8:	83 ec 08             	sub    $0x8,%esp
  800fcb:	ff 75 0c             	pushl  0xc(%ebp)
  800fce:	6a 30                	push   $0x30
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	ff d0                	call   *%eax
  800fd5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 0c             	pushl  0xc(%ebp)
  800fde:	6a 78                	push   $0x78
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	ff d0                	call   *%eax
  800fe5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ff9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801003:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80100a:	eb 1f                	jmp    80102b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 e7 fb ff ff       	call   800c02 <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801024:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80102b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80102f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801032:	83 ec 04             	sub    $0x4,%esp
  801035:	52                   	push   %edx
  801036:	ff 75 e4             	pushl  -0x1c(%ebp)
  801039:	50                   	push   %eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	ff 75 f0             	pushl  -0x10(%ebp)
  801040:	ff 75 0c             	pushl  0xc(%ebp)
  801043:	ff 75 08             	pushl  0x8(%ebp)
  801046:	e8 00 fb ff ff       	call   800b4b <printnum>
  80104b:	83 c4 20             	add    $0x20,%esp
			break;
  80104e:	eb 46                	jmp    801096 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	53                   	push   %ebx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	ff d0                	call   *%eax
  80105c:	83 c4 10             	add    $0x10,%esp
			break;
  80105f:	eb 35                	jmp    801096 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801061:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  801068:	eb 2c                	jmp    801096 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80106a:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  801071:	eb 23                	jmp    801096 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801073:	83 ec 08             	sub    $0x8,%esp
  801076:	ff 75 0c             	pushl  0xc(%ebp)
  801079:	6a 25                	push   $0x25
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	ff d0                	call   *%eax
  801080:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801083:	ff 4d 10             	decl   0x10(%ebp)
  801086:	eb 03                	jmp    80108b <vprintfmt+0x3c3>
  801088:	ff 4d 10             	decl   0x10(%ebp)
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	48                   	dec    %eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	3c 25                	cmp    $0x25,%al
  801093:	75 f3                	jne    801088 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801095:	90                   	nop
		}
	}
  801096:	e9 35 fc ff ff       	jmp    800cd0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80109b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80109c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80109f:	5b                   	pop    %ebx
  8010a0:	5e                   	pop    %esi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ac:	83 c0 04             	add    $0x4,%eax
  8010af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b8:	50                   	push   %eax
  8010b9:	ff 75 0c             	pushl  0xc(%ebp)
  8010bc:	ff 75 08             	pushl  0x8(%ebp)
  8010bf:	e8 04 fc ff ff       	call   800cc8 <vprintfmt>
  8010c4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010c7:	90                   	nop
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	8b 40 08             	mov    0x8(%eax),%eax
  8010d3:	8d 50 01             	lea    0x1(%eax),%edx
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	8b 10                	mov    (%eax),%edx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	8b 40 04             	mov    0x4(%eax),%eax
  8010e7:	39 c2                	cmp    %eax,%edx
  8010e9:	73 12                	jae    8010fd <sprintputch+0x33>
		*b->buf++ = ch;
  8010eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ee:	8b 00                	mov    (%eax),%eax
  8010f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8010f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f6:	89 0a                	mov    %ecx,(%edx)
  8010f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fb:	88 10                	mov    %dl,(%eax)
}
  8010fd:	90                   	nop
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	01 d0                	add    %edx,%eax
  801117:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80111a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801121:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801125:	74 06                	je     80112d <vsnprintf+0x2d>
  801127:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112b:	7f 07                	jg     801134 <vsnprintf+0x34>
		return -E_INVAL;
  80112d:	b8 03 00 00 00       	mov    $0x3,%eax
  801132:	eb 20                	jmp    801154 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801134:	ff 75 14             	pushl  0x14(%ebp)
  801137:	ff 75 10             	pushl  0x10(%ebp)
  80113a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80113d:	50                   	push   %eax
  80113e:	68 ca 10 80 00       	push   $0x8010ca
  801143:	e8 80 fb ff ff       	call   800cc8 <vprintfmt>
  801148:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80114b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80114e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801151:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80115c:	8d 45 10             	lea    0x10(%ebp),%eax
  80115f:	83 c0 04             	add    $0x4,%eax
  801162:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801165:	8b 45 10             	mov    0x10(%ebp),%eax
  801168:	ff 75 f4             	pushl  -0xc(%ebp)
  80116b:	50                   	push   %eax
  80116c:	ff 75 0c             	pushl  0xc(%ebp)
  80116f:	ff 75 08             	pushl  0x8(%ebp)
  801172:	e8 89 ff ff ff       	call   801100 <vsnprintf>
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80117d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801188:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80118f:	eb 06                	jmp    801197 <strlen+0x15>
		n++;
  801191:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801194:	ff 45 08             	incl   0x8(%ebp)
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	84 c0                	test   %al,%al
  80119e:	75 f1                	jne    801191 <strlen+0xf>
		n++;
	return n;
  8011a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b2:	eb 09                	jmp    8011bd <strnlen+0x18>
		n++;
  8011b4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011b7:	ff 45 08             	incl   0x8(%ebp)
  8011ba:	ff 4d 0c             	decl   0xc(%ebp)
  8011bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c1:	74 09                	je     8011cc <strnlen+0x27>
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	84 c0                	test   %al,%al
  8011ca:	75 e8                	jne    8011b4 <strnlen+0xf>
		n++;
	return n;
  8011cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011dd:	90                   	nop
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8d 50 01             	lea    0x1(%eax),%edx
  8011e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011ed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011f0:	8a 12                	mov    (%edx),%dl
  8011f2:	88 10                	mov    %dl,(%eax)
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	84 c0                	test   %al,%al
  8011f8:	75 e4                	jne    8011de <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801212:	eb 1f                	jmp    801233 <strncpy+0x34>
		*dst++ = *src;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8d 50 01             	lea    0x1(%eax),%edx
  80121a:	89 55 08             	mov    %edx,0x8(%ebp)
  80121d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801220:	8a 12                	mov    (%edx),%dl
  801222:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	84 c0                	test   %al,%al
  80122b:	74 03                	je     801230 <strncpy+0x31>
			src++;
  80122d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801230:	ff 45 fc             	incl   -0x4(%ebp)
  801233:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801236:	3b 45 10             	cmp    0x10(%ebp),%eax
  801239:	72 d9                	jb     801214 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80123b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80124c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801250:	74 30                	je     801282 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801252:	eb 16                	jmp    80126a <strlcpy+0x2a>
			*dst++ = *src++;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 08             	mov    %edx,0x8(%ebp)
  80125d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801260:	8d 4a 01             	lea    0x1(%edx),%ecx
  801263:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801266:	8a 12                	mov    (%edx),%dl
  801268:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80126a:	ff 4d 10             	decl   0x10(%ebp)
  80126d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801271:	74 09                	je     80127c <strlcpy+0x3c>
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	84 c0                	test   %al,%al
  80127a:	75 d8                	jne    801254 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801282:	8b 55 08             	mov    0x8(%ebp),%edx
  801285:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801288:	29 c2                	sub    %eax,%edx
  80128a:	89 d0                	mov    %edx,%eax
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801291:	eb 06                	jmp    801299 <strcmp+0xb>
		p++, q++;
  801293:	ff 45 08             	incl   0x8(%ebp)
  801296:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	84 c0                	test   %al,%al
  8012a0:	74 0e                	je     8012b0 <strcmp+0x22>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 10                	mov    (%eax),%dl
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	38 c2                	cmp    %al,%dl
  8012ae:	74 e3                	je     801293 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	0f b6 d0             	movzbl %al,%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f b6 c0             	movzbl %al,%eax
  8012c0:	29 c2                	sub    %eax,%edx
  8012c2:	89 d0                	mov    %edx,%eax
}
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    

008012c6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012c9:	eb 09                	jmp    8012d4 <strncmp+0xe>
		n--, p++, q++;
  8012cb:	ff 4d 10             	decl   0x10(%ebp)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d8:	74 17                	je     8012f1 <strncmp+0x2b>
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	84 c0                	test   %al,%al
  8012e1:	74 0e                	je     8012f1 <strncmp+0x2b>
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 10                	mov    (%eax),%dl
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	38 c2                	cmp    %al,%dl
  8012ef:	74 da                	je     8012cb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f5:	75 07                	jne    8012fe <strncmp+0x38>
		return 0;
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fc:	eb 14                	jmp    801312 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	0f b6 d0             	movzbl %al,%edx
  801306:	8b 45 0c             	mov    0xc(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	0f b6 c0             	movzbl %al,%eax
  80130e:	29 c2                	sub    %eax,%edx
  801310:	89 d0                	mov    %edx,%eax
}
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    

00801314 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801320:	eb 12                	jmp    801334 <strchr+0x20>
		if (*s == c)
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80132a:	75 05                	jne    801331 <strchr+0x1d>
			return (char *) s;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	eb 11                	jmp    801342 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801331:	ff 45 08             	incl   0x8(%ebp)
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	84 c0                	test   %al,%al
  80133b:	75 e5                	jne    801322 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801350:	eb 0d                	jmp    80135f <strfind+0x1b>
		if (*s == c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80135a:	74 0e                	je     80136a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80135c:	ff 45 08             	incl   0x8(%ebp)
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	84 c0                	test   %al,%al
  801366:	75 ea                	jne    801352 <strfind+0xe>
  801368:	eb 01                	jmp    80136b <strfind+0x27>
		if (*s == c)
			break;
  80136a:	90                   	nop
	return (char *) s;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80137c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801380:	76 63                	jbe    8013e5 <memset+0x75>
		uint64 data_block = c;
  801382:	8b 45 0c             	mov    0xc(%ebp),%eax
  801385:	99                   	cltd   
  801386:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801389:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80138c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801392:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801396:	c1 e0 08             	shl    $0x8,%eax
  801399:	09 45 f0             	or     %eax,-0x10(%ebp)
  80139c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8013a9:	c1 e0 10             	shl    $0x10,%eax
  8013ac:	09 45 f0             	or     %eax,-0x10(%ebp)
  8013af:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8013b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b8:	89 c2                	mov    %eax,%edx
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bf:	09 45 f0             	or     %eax,-0x10(%ebp)
  8013c2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8013c5:	eb 18                	jmp    8013df <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8013c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ca:	8d 41 08             	lea    0x8(%ecx),%eax
  8013cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8013d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d6:	89 01                	mov    %eax,(%ecx)
  8013d8:	89 51 04             	mov    %edx,0x4(%ecx)
  8013db:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8013df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013e3:	77 e2                	ja     8013c7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8013e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e9:	74 23                	je     80140e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8013eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013f1:	eb 0e                	jmp    801401 <memset+0x91>
			*p8++ = (uint8)c;
  8013f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f6:	8d 50 01             	lea    0x1(%eax),%edx
  8013f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ff:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	8d 50 ff             	lea    -0x1(%eax),%edx
  801407:	89 55 10             	mov    %edx,0x10(%ebp)
  80140a:	85 c0                	test   %eax,%eax
  80140c:	75 e5                	jne    8013f3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801425:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801429:	76 24                	jbe    80144f <memcpy+0x3c>
		while(n >= 8){
  80142b:	eb 1c                	jmp    801449 <memcpy+0x36>
			*d64 = *s64;
  80142d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801430:	8b 50 04             	mov    0x4(%eax),%edx
  801433:	8b 00                	mov    (%eax),%eax
  801435:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801438:	89 01                	mov    %eax,(%ecx)
  80143a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80143d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801441:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801445:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801449:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80144d:	77 de                	ja     80142d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80144f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801453:	74 31                	je     801486 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801455:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801458:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801461:	eb 16                	jmp    801479 <memcpy+0x66>
			*d8++ = *s8++;
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801466:	8d 50 01             	lea    0x1(%eax),%edx
  801469:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80146c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801472:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801475:	8a 12                	mov    (%edx),%dl
  801477:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80147f:	89 55 10             	mov    %edx,0x10(%ebp)
  801482:	85 c0                	test   %eax,%eax
  801484:	75 dd                	jne    801463 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80149d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a3:	73 50                	jae    8014f5 <memmove+0x6a>
  8014a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ab:	01 d0                	add    %edx,%eax
  8014ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b0:	76 43                	jbe    8014f5 <memmove+0x6a>
		s += n;
  8014b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014be:	eb 10                	jmp    8014d0 <memmove+0x45>
			*--d = *--s;
  8014c0:	ff 4d f8             	decl   -0x8(%ebp)
  8014c3:	ff 4d fc             	decl   -0x4(%ebp)
  8014c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c9:	8a 10                	mov    (%eax),%dl
  8014cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ce:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	75 e3                	jne    8014c0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014dd:	eb 23                	jmp    801502 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e2:	8d 50 01             	lea    0x1(%eax),%edx
  8014e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014f1:	8a 12                	mov    (%edx),%dl
  8014f3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8014fe:	85 c0                	test   %eax,%eax
  801500:	75 dd                	jne    8014df <memmove+0x54>
			*d++ = *s++;

	return dst;
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801513:	8b 45 0c             	mov    0xc(%ebp),%eax
  801516:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801519:	eb 2a                	jmp    801545 <memcmp+0x3e>
		if (*s1 != *s2)
  80151b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151e:	8a 10                	mov    (%eax),%dl
  801520:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801523:	8a 00                	mov    (%eax),%al
  801525:	38 c2                	cmp    %al,%dl
  801527:	74 16                	je     80153f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 d0             	movzbl %al,%edx
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	0f b6 c0             	movzbl %al,%eax
  801539:	29 c2                	sub    %eax,%edx
  80153b:	89 d0                	mov    %edx,%eax
  80153d:	eb 18                	jmp    801557 <memcmp+0x50>
		s1++, s2++;
  80153f:	ff 45 fc             	incl   -0x4(%ebp)
  801542:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801545:	8b 45 10             	mov    0x10(%ebp),%eax
  801548:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154b:	89 55 10             	mov    %edx,0x10(%ebp)
  80154e:	85 c0                	test   %eax,%eax
  801550:	75 c9                	jne    80151b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80155f:	8b 55 08             	mov    0x8(%ebp),%edx
  801562:	8b 45 10             	mov    0x10(%ebp),%eax
  801565:	01 d0                	add    %edx,%eax
  801567:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80156a:	eb 15                	jmp    801581 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	0f b6 d0             	movzbl %al,%edx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	0f b6 c0             	movzbl %al,%eax
  80157a:	39 c2                	cmp    %eax,%edx
  80157c:	74 0d                	je     80158b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80157e:	ff 45 08             	incl   0x8(%ebp)
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801587:	72 e3                	jb     80156c <memfind+0x13>
  801589:	eb 01                	jmp    80158c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80158b:	90                   	nop
	return (void *) s;
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80159e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a5:	eb 03                	jmp    8015aa <strtol+0x19>
		s++;
  8015a7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	3c 20                	cmp    $0x20,%al
  8015b1:	74 f4                	je     8015a7 <strtol+0x16>
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3c 09                	cmp    $0x9,%al
  8015ba:	74 eb                	je     8015a7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	3c 2b                	cmp    $0x2b,%al
  8015c3:	75 05                	jne    8015ca <strtol+0x39>
		s++;
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	eb 13                	jmp    8015dd <strtol+0x4c>
	else if (*s == '-')
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	3c 2d                	cmp    $0x2d,%al
  8015d1:	75 0a                	jne    8015dd <strtol+0x4c>
		s++, neg = 1;
  8015d3:	ff 45 08             	incl   0x8(%ebp)
  8015d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015e1:	74 06                	je     8015e9 <strtol+0x58>
  8015e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015e7:	75 20                	jne    801609 <strtol+0x78>
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	3c 30                	cmp    $0x30,%al
  8015f0:	75 17                	jne    801609 <strtol+0x78>
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	40                   	inc    %eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	3c 78                	cmp    $0x78,%al
  8015fa:	75 0d                	jne    801609 <strtol+0x78>
		s += 2, base = 16;
  8015fc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801600:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801607:	eb 28                	jmp    801631 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801609:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160d:	75 15                	jne    801624 <strtol+0x93>
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	3c 30                	cmp    $0x30,%al
  801616:	75 0c                	jne    801624 <strtol+0x93>
		s++, base = 8;
  801618:	ff 45 08             	incl   0x8(%ebp)
  80161b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801622:	eb 0d                	jmp    801631 <strtol+0xa0>
	else if (base == 0)
  801624:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801628:	75 07                	jne    801631 <strtol+0xa0>
		base = 10;
  80162a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	3c 2f                	cmp    $0x2f,%al
  801638:	7e 19                	jle    801653 <strtol+0xc2>
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	3c 39                	cmp    $0x39,%al
  801641:	7f 10                	jg     801653 <strtol+0xc2>
			dig = *s - '0';
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	0f be c0             	movsbl %al,%eax
  80164b:	83 e8 30             	sub    $0x30,%eax
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801651:	eb 42                	jmp    801695 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	3c 60                	cmp    $0x60,%al
  80165a:	7e 19                	jle    801675 <strtol+0xe4>
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8a 00                	mov    (%eax),%al
  801661:	3c 7a                	cmp    $0x7a,%al
  801663:	7f 10                	jg     801675 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	8a 00                	mov    (%eax),%al
  80166a:	0f be c0             	movsbl %al,%eax
  80166d:	83 e8 57             	sub    $0x57,%eax
  801670:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801673:	eb 20                	jmp    801695 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	3c 40                	cmp    $0x40,%al
  80167c:	7e 39                	jle    8016b7 <strtol+0x126>
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 5a                	cmp    $0x5a,%al
  801685:	7f 30                	jg     8016b7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	8a 00                	mov    (%eax),%al
  80168c:	0f be c0             	movsbl %al,%eax
  80168f:	83 e8 37             	sub    $0x37,%eax
  801692:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801698:	3b 45 10             	cmp    0x10(%ebp),%eax
  80169b:	7d 19                	jge    8016b6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80169d:	ff 45 08             	incl   0x8(%ebp)
  8016a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016a7:	89 c2                	mov    %eax,%edx
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ac:	01 d0                	add    %edx,%eax
  8016ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016b1:	e9 7b ff ff ff       	jmp    801631 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016b6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016bb:	74 08                	je     8016c5 <strtol+0x134>
		*endptr = (char *) s;
  8016bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c9:	74 07                	je     8016d2 <strtol+0x141>
  8016cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ce:	f7 d8                	neg    %eax
  8016d0:	eb 03                	jmp    8016d5 <strtol+0x144>
  8016d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <ltostr>:

void
ltostr(long value, char *str)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ef:	79 13                	jns    801704 <ltostr+0x2d>
	{
		neg = 1;
  8016f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016fe:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801701:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80170c:	99                   	cltd   
  80170d:	f7 f9                	idiv   %ecx
  80170f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801712:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801715:	8d 50 01             	lea    0x1(%eax),%edx
  801718:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80171b:	89 c2                	mov    %eax,%edx
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801725:	83 c2 30             	add    $0x30,%edx
  801728:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80172a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801732:	f7 e9                	imul   %ecx
  801734:	c1 fa 02             	sar    $0x2,%edx
  801737:	89 c8                	mov    %ecx,%eax
  801739:	c1 f8 1f             	sar    $0x1f,%eax
  80173c:	29 c2                	sub    %eax,%edx
  80173e:	89 d0                	mov    %edx,%eax
  801740:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801743:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801747:	75 bb                	jne    801704 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801750:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801753:	48                   	dec    %eax
  801754:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801757:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80175b:	74 3d                	je     80179a <ltostr+0xc3>
		start = 1 ;
  80175d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801764:	eb 34                	jmp    80179a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176c:	01 d0                	add    %edx,%eax
  80176e:	8a 00                	mov    (%eax),%al
  801770:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801776:	8b 45 0c             	mov    0xc(%ebp),%eax
  801779:	01 c2                	add    %eax,%edx
  80177b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80177e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801781:	01 c8                	add    %ecx,%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801787:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178d:	01 c2                	add    %eax,%edx
  80178f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801792:	88 02                	mov    %al,(%edx)
		start++ ;
  801794:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801797:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017a0:	7c c4                	jl     801766 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a8:	01 d0                	add    %edx,%eax
  8017aa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017ad:	90                   	nop
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017b6:	ff 75 08             	pushl  0x8(%ebp)
  8017b9:	e8 c4 f9 ff ff       	call   801182 <strlen>
  8017be:	83 c4 04             	add    $0x4,%esp
  8017c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	e8 b6 f9 ff ff       	call   801182 <strlen>
  8017cc:	83 c4 04             	add    $0x4,%esp
  8017cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017e0:	eb 17                	jmp    8017f9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e8:	01 c2                	add    %eax,%edx
  8017ea:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	01 c8                	add    %ecx,%eax
  8017f2:	8a 00                	mov    (%eax),%al
  8017f4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017f6:	ff 45 fc             	incl   -0x4(%ebp)
  8017f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ff:	7c e1                	jl     8017e2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801801:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801808:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80180f:	eb 1f                	jmp    801830 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801814:	8d 50 01             	lea    0x1(%eax),%edx
  801817:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80181a:	89 c2                	mov    %eax,%edx
  80181c:	8b 45 10             	mov    0x10(%ebp),%eax
  80181f:	01 c2                	add    %eax,%edx
  801821:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 c8                	add    %ecx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
  801830:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801833:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801836:	7c d9                	jl     801811 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801838:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80183b:	8b 45 10             	mov    0x10(%ebp),%eax
  80183e:	01 d0                	add    %edx,%eax
  801840:	c6 00 00             	movb   $0x0,(%eax)
}
  801843:	90                   	nop
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801849:	8b 45 14             	mov    0x14(%ebp),%eax
  80184c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801852:	8b 45 14             	mov    0x14(%ebp),%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80185e:	8b 45 10             	mov    0x10(%ebp),%eax
  801861:	01 d0                	add    %edx,%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801869:	eb 0c                	jmp    801877 <strsplit+0x31>
			*string++ = 0;
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 08             	mov    %edx,0x8(%ebp)
  801874:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	84 c0                	test   %al,%al
  80187e:	74 18                	je     801898 <strsplit+0x52>
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	8a 00                	mov    (%eax),%al
  801885:	0f be c0             	movsbl %al,%eax
  801888:	50                   	push   %eax
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	e8 83 fa ff ff       	call   801314 <strchr>
  801891:	83 c4 08             	add    $0x8,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	75 d3                	jne    80186b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	8a 00                	mov    (%eax),%al
  80189d:	84 c0                	test   %al,%al
  80189f:	74 5a                	je     8018fb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a4:	8b 00                	mov    (%eax),%eax
  8018a6:	83 f8 0f             	cmp    $0xf,%eax
  8018a9:	75 07                	jne    8018b2 <strsplit+0x6c>
		{
			return 0;
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b0:	eb 66                	jmp    801918 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b5:	8b 00                	mov    (%eax),%eax
  8018b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ba:	8b 55 14             	mov    0x14(%ebp),%edx
  8018bd:	89 0a                	mov    %ecx,(%edx)
  8018bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018d0:	eb 03                	jmp    8018d5 <strsplit+0x8f>
			string++;
  8018d2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	84 c0                	test   %al,%al
  8018dc:	74 8b                	je     801869 <strsplit+0x23>
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f be c0             	movsbl %al,%eax
  8018e6:	50                   	push   %eax
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	e8 25 fa ff ff       	call   801314 <strchr>
  8018ef:	83 c4 08             	add    $0x8,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	74 dc                	je     8018d2 <strsplit+0x8c>
			string++;
	}
  8018f6:	e9 6e ff ff ff       	jmp    801869 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018fb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801913:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801926:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192d:	eb 4a                	jmp    801979 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80192f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	01 c2                	add    %eax,%edx
  801937:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80193a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193d:	01 c8                	add    %ecx,%eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801943:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 40                	cmp    $0x40,%al
  80194f:	7e 25                	jle    801976 <str2lower+0x5c>
  801951:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801954:	8b 45 0c             	mov    0xc(%ebp),%eax
  801957:	01 d0                	add    %edx,%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 5a                	cmp    $0x5a,%al
  80195d:	7f 17                	jg     801976 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80195f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	01 d0                	add    %edx,%eax
  801967:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80196a:	8b 55 08             	mov    0x8(%ebp),%edx
  80196d:	01 ca                	add    %ecx,%edx
  80196f:	8a 12                	mov    (%edx),%dl
  801971:	83 c2 20             	add    $0x20,%edx
  801974:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801976:	ff 45 fc             	incl   -0x4(%ebp)
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	e8 01 f8 ff ff       	call   801182 <strlen>
  801981:	83 c4 04             	add    $0x4,%esp
  801984:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801987:	7f a6                	jg     80192f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801989:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	57                   	push   %edi
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019a6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019a9:	cd 30                	int    $0x30
  8019ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8019ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5f                   	pop    %edi
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    

008019b9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8019c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	51                   	push   %ecx
  8019d2:	52                   	push   %edx
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	50                   	push   %eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	e8 b0 ff ff ff       	call   80198e <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 02                	push   $0x2
  8019f3:	e8 96 ff ff ff       	call   80198e <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 03                	push   $0x3
  801a0c:	e8 7d ff ff ff       	call   80198e <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 04                	push   $0x4
  801a26:	e8 63 ff ff ff       	call   80198e <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 08                	push   $0x8
  801a44:	e8 45 ff ff ff       	call   80198e <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	56                   	push   %esi
  801a52:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a53:	8b 75 18             	mov    0x18(%ebp),%esi
  801a56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
  801a64:	51                   	push   %ecx
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 09                	push   $0x9
  801a69:	e8 20 ff ff ff       	call   80198e <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    

00801a78 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 0a                	push   $0xa
  801a88:	e8 01 ff ff ff       	call   80198e <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 0b                	push   $0xb
  801aa3:	e8 e6 fe ff ff       	call   80198e <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 0c                	push   $0xc
  801abc:	e8 cd fe ff ff       	call   80198e <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 0d                	push   $0xd
  801ad5:	e8 b4 fe ff ff       	call   80198e <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 0e                	push   $0xe
  801aee:	e8 9b fe ff ff       	call   80198e <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 0f                	push   $0xf
  801b07:	e8 82 fe ff ff       	call   80198e <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 10                	push   $0x10
  801b21:	e8 68 fe ff ff       	call   80198e <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 11                	push   $0x11
  801b3a:	e8 4f fe ff ff       	call   80198e <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	90                   	nop
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	50                   	push   %eax
  801b5e:	6a 01                	push   $0x1
  801b60:	e8 29 fe ff ff       	call   80198e <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 14                	push   $0x14
  801b7a:	e8 0f fe ff ff       	call   80198e <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b91:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b94:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	51                   	push   %ecx
  801b9e:	52                   	push   %edx
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	50                   	push   %eax
  801ba3:	6a 15                	push   $0x15
  801ba5:	e8 e4 fd ff ff       	call   80198e <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 16                	push   $0x16
  801bc2:	e8 c7 fd ff ff       	call   80198e <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	51                   	push   %ecx
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 17                	push   $0x17
  801be1:	e8 a8 fd ff ff       	call   80198e <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 18                	push   $0x18
  801bfe:	e8 8b fd ff ff       	call   80198e <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	ff 75 14             	pushl  0x14(%ebp)
  801c13:	ff 75 10             	pushl  0x10(%ebp)
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	50                   	push   %eax
  801c1a:	6a 19                	push   $0x19
  801c1c:	e8 6d fd ff ff       	call   80198e <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	50                   	push   %eax
  801c35:	6a 1a                	push   $0x1a
  801c37:	e8 52 fd ff ff       	call   80198e <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	90                   	nop
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	50                   	push   %eax
  801c51:	6a 1b                	push   $0x1b
  801c53:	e8 36 fd ff ff       	call   80198e <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 05                	push   $0x5
  801c6c:	e8 1d fd ff ff       	call   80198e <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 06                	push   $0x6
  801c85:	e8 04 fd ff ff       	call   80198e <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 07                	push   $0x7
  801c9e:	e8 eb fc ff ff       	call   80198e <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 1c                	push   $0x1c
  801cb7:	e8 d2 fc ff ff       	call   80198e <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	90                   	nop
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ccb:	8d 50 04             	lea    0x4(%eax),%edx
  801cce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	52                   	push   %edx
  801cd8:	50                   	push   %eax
  801cd9:	6a 1d                	push   $0x1d
  801cdb:	e8 ae fc ff ff       	call   80198e <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cec:	89 01                	mov    %eax,(%ecx)
  801cee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	c9                   	leave  
  801cf5:	c2 04 00             	ret    $0x4

00801cf8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	ff 75 10             	pushl  0x10(%ebp)
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	ff 75 08             	pushl  0x8(%ebp)
  801d08:	6a 13                	push   $0x13
  801d0a:	e8 7f fc ff ff       	call   80198e <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d12:	90                   	nop
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 1e                	push   $0x1e
  801d24:	e8 65 fc ff ff       	call   80198e <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d3a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	50                   	push   %eax
  801d47:	6a 1f                	push   $0x1f
  801d49:	e8 40 fc ff ff       	call   80198e <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <rsttst>:
void rsttst()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 21                	push   $0x21
  801d63:	e8 26 fc ff ff       	call   80198e <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 04             	sub    $0x4,%esp
  801d74:	8b 45 14             	mov    0x14(%ebp),%eax
  801d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d7a:	8b 55 18             	mov    0x18(%ebp),%edx
  801d7d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d81:	52                   	push   %edx
  801d82:	50                   	push   %eax
  801d83:	ff 75 10             	pushl  0x10(%ebp)
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	6a 20                	push   $0x20
  801d8e:	e8 fb fb ff ff       	call   80198e <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
	return ;
  801d96:	90                   	nop
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <chktst>:
void chktst(uint32 n)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	ff 75 08             	pushl  0x8(%ebp)
  801da7:	6a 22                	push   $0x22
  801da9:	e8 e0 fb ff ff       	call   80198e <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return ;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <inctst>:

void inctst()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 23                	push   $0x23
  801dc3:	e8 c6 fb ff ff       	call   80198e <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcb:	90                   	nop
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <gettst>:
uint32 gettst()
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 24                	push   $0x24
  801ddd:	e8 ac fb ff ff       	call   80198e <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 25                	push   $0x25
  801df6:	e8 93 fb ff ff       	call   80198e <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
  801dfe:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	return uheapPlaceStrategy ;
  801e03:	a1 a0 b0 81 00       	mov    0x81b0a0,%eax
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	a3 a0 b0 81 00       	mov    %eax,0x81b0a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	ff 75 08             	pushl  0x8(%ebp)
  801e20:	6a 26                	push   $0x26
  801e22:	e8 67 fb ff ff       	call   80198e <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2a:	90                   	nop
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	6a 00                	push   $0x0
  801e3f:	53                   	push   %ebx
  801e40:	51                   	push   %ecx
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 27                	push   $0x27
  801e45:	e8 44 fb ff ff       	call   80198e <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	52                   	push   %edx
  801e62:	50                   	push   %eax
  801e63:	6a 28                	push   $0x28
  801e65:	e8 24 fb ff ff       	call   80198e <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	6a 00                	push   $0x0
  801e7d:	51                   	push   %ecx
  801e7e:	ff 75 10             	pushl  0x10(%ebp)
  801e81:	52                   	push   %edx
  801e82:	50                   	push   %eax
  801e83:	6a 29                	push   $0x29
  801e85:	e8 04 fb ff ff       	call   80198e <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	ff 75 10             	pushl  0x10(%ebp)
  801e99:	ff 75 0c             	pushl  0xc(%ebp)
  801e9c:	ff 75 08             	pushl  0x8(%ebp)
  801e9f:	6a 12                	push   $0x12
  801ea1:	e8 e8 fa ff ff       	call   80198e <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea9:	90                   	nop
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	52                   	push   %edx
  801ebc:	50                   	push   %eax
  801ebd:	6a 2a                	push   $0x2a
  801ebf:	e8 ca fa ff ff       	call   80198e <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return;
  801ec7:	90                   	nop
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 2b                	push   $0x2b
  801ed9:	e8 b0 fa ff ff       	call   80198e <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	ff 75 0c             	pushl  0xc(%ebp)
  801eef:	ff 75 08             	pushl  0x8(%ebp)
  801ef2:	6a 2d                	push   $0x2d
  801ef4:	e8 95 fa ff ff       	call   80198e <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
	return;
  801efc:	90                   	nop
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	ff 75 0c             	pushl  0xc(%ebp)
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	6a 2c                	push   $0x2c
  801f10:	e8 79 fa ff ff       	call   80198e <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
	return ;
  801f18:	90                   	nop
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	52                   	push   %edx
  801f2b:	50                   	push   %eax
  801f2c:	6a 2e                	push   $0x2e
  801f2e:	e8 5b fa ff ff       	call   80198e <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
	return ;
  801f36:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    
  801f39:	66 90                	xchg   %ax,%ax
  801f3b:	90                   	nop

00801f3c <__udivdi3>:
  801f3c:	55                   	push   %ebp
  801f3d:	57                   	push   %edi
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	83 ec 1c             	sub    $0x1c,%esp
  801f43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f53:	89 ca                	mov    %ecx,%edx
  801f55:	89 f8                	mov    %edi,%eax
  801f57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f5b:	85 f6                	test   %esi,%esi
  801f5d:	75 2d                	jne    801f8c <__udivdi3+0x50>
  801f5f:	39 cf                	cmp    %ecx,%edi
  801f61:	77 65                	ja     801fc8 <__udivdi3+0x8c>
  801f63:	89 fd                	mov    %edi,%ebp
  801f65:	85 ff                	test   %edi,%edi
  801f67:	75 0b                	jne    801f74 <__udivdi3+0x38>
  801f69:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6e:	31 d2                	xor    %edx,%edx
  801f70:	f7 f7                	div    %edi
  801f72:	89 c5                	mov    %eax,%ebp
  801f74:	31 d2                	xor    %edx,%edx
  801f76:	89 c8                	mov    %ecx,%eax
  801f78:	f7 f5                	div    %ebp
  801f7a:	89 c1                	mov    %eax,%ecx
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	f7 f5                	div    %ebp
  801f80:	89 cf                	mov    %ecx,%edi
  801f82:	89 fa                	mov    %edi,%edx
  801f84:	83 c4 1c             	add    $0x1c,%esp
  801f87:	5b                   	pop    %ebx
  801f88:	5e                   	pop    %esi
  801f89:	5f                   	pop    %edi
  801f8a:	5d                   	pop    %ebp
  801f8b:	c3                   	ret    
  801f8c:	39 ce                	cmp    %ecx,%esi
  801f8e:	77 28                	ja     801fb8 <__udivdi3+0x7c>
  801f90:	0f bd fe             	bsr    %esi,%edi
  801f93:	83 f7 1f             	xor    $0x1f,%edi
  801f96:	75 40                	jne    801fd8 <__udivdi3+0x9c>
  801f98:	39 ce                	cmp    %ecx,%esi
  801f9a:	72 0a                	jb     801fa6 <__udivdi3+0x6a>
  801f9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fa0:	0f 87 9e 00 00 00    	ja     802044 <__udivdi3+0x108>
  801fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fab:	89 fa                	mov    %edi,%edx
  801fad:	83 c4 1c             	add    $0x1c,%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5e                   	pop    %esi
  801fb2:	5f                   	pop    %edi
  801fb3:	5d                   	pop    %ebp
  801fb4:	c3                   	ret    
  801fb5:	8d 76 00             	lea    0x0(%esi),%esi
  801fb8:	31 ff                	xor    %edi,%edi
  801fba:	31 c0                	xor    %eax,%eax
  801fbc:	89 fa                	mov    %edi,%edx
  801fbe:	83 c4 1c             	add    $0x1c,%esp
  801fc1:	5b                   	pop    %ebx
  801fc2:	5e                   	pop    %esi
  801fc3:	5f                   	pop    %edi
  801fc4:	5d                   	pop    %ebp
  801fc5:	c3                   	ret    
  801fc6:	66 90                	xchg   %ax,%ax
  801fc8:	89 d8                	mov    %ebx,%eax
  801fca:	f7 f7                	div    %edi
  801fcc:	31 ff                	xor    %edi,%edi
  801fce:	89 fa                	mov    %edi,%edx
  801fd0:	83 c4 1c             	add    $0x1c,%esp
  801fd3:	5b                   	pop    %ebx
  801fd4:	5e                   	pop    %esi
  801fd5:	5f                   	pop    %edi
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    
  801fd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fdd:	89 eb                	mov    %ebp,%ebx
  801fdf:	29 fb                	sub    %edi,%ebx
  801fe1:	89 f9                	mov    %edi,%ecx
  801fe3:	d3 e6                	shl    %cl,%esi
  801fe5:	89 c5                	mov    %eax,%ebp
  801fe7:	88 d9                	mov    %bl,%cl
  801fe9:	d3 ed                	shr    %cl,%ebp
  801feb:	89 e9                	mov    %ebp,%ecx
  801fed:	09 f1                	or     %esi,%ecx
  801fef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ff3:	89 f9                	mov    %edi,%ecx
  801ff5:	d3 e0                	shl    %cl,%eax
  801ff7:	89 c5                	mov    %eax,%ebp
  801ff9:	89 d6                	mov    %edx,%esi
  801ffb:	88 d9                	mov    %bl,%cl
  801ffd:	d3 ee                	shr    %cl,%esi
  801fff:	89 f9                	mov    %edi,%ecx
  802001:	d3 e2                	shl    %cl,%edx
  802003:	8b 44 24 08          	mov    0x8(%esp),%eax
  802007:	88 d9                	mov    %bl,%cl
  802009:	d3 e8                	shr    %cl,%eax
  80200b:	09 c2                	or     %eax,%edx
  80200d:	89 d0                	mov    %edx,%eax
  80200f:	89 f2                	mov    %esi,%edx
  802011:	f7 74 24 0c          	divl   0xc(%esp)
  802015:	89 d6                	mov    %edx,%esi
  802017:	89 c3                	mov    %eax,%ebx
  802019:	f7 e5                	mul    %ebp
  80201b:	39 d6                	cmp    %edx,%esi
  80201d:	72 19                	jb     802038 <__udivdi3+0xfc>
  80201f:	74 0b                	je     80202c <__udivdi3+0xf0>
  802021:	89 d8                	mov    %ebx,%eax
  802023:	31 ff                	xor    %edi,%edi
  802025:	e9 58 ff ff ff       	jmp    801f82 <__udivdi3+0x46>
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802030:	89 f9                	mov    %edi,%ecx
  802032:	d3 e2                	shl    %cl,%edx
  802034:	39 c2                	cmp    %eax,%edx
  802036:	73 e9                	jae    802021 <__udivdi3+0xe5>
  802038:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80203b:	31 ff                	xor    %edi,%edi
  80203d:	e9 40 ff ff ff       	jmp    801f82 <__udivdi3+0x46>
  802042:	66 90                	xchg   %ax,%ax
  802044:	31 c0                	xor    %eax,%eax
  802046:	e9 37 ff ff ff       	jmp    801f82 <__udivdi3+0x46>
  80204b:	90                   	nop

0080204c <__umoddi3>:
  80204c:	55                   	push   %ebp
  80204d:	57                   	push   %edi
  80204e:	56                   	push   %esi
  80204f:	53                   	push   %ebx
  802050:	83 ec 1c             	sub    $0x1c,%esp
  802053:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802057:	8b 74 24 34          	mov    0x34(%esp),%esi
  80205b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80205f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802067:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80206b:	89 f3                	mov    %esi,%ebx
  80206d:	89 fa                	mov    %edi,%edx
  80206f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802073:	89 34 24             	mov    %esi,(%esp)
  802076:	85 c0                	test   %eax,%eax
  802078:	75 1a                	jne    802094 <__umoddi3+0x48>
  80207a:	39 f7                	cmp    %esi,%edi
  80207c:	0f 86 a2 00 00 00    	jbe    802124 <__umoddi3+0xd8>
  802082:	89 c8                	mov    %ecx,%eax
  802084:	89 f2                	mov    %esi,%edx
  802086:	f7 f7                	div    %edi
  802088:	89 d0                	mov    %edx,%eax
  80208a:	31 d2                	xor    %edx,%edx
  80208c:	83 c4 1c             	add    $0x1c,%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5f                   	pop    %edi
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    
  802094:	39 f0                	cmp    %esi,%eax
  802096:	0f 87 ac 00 00 00    	ja     802148 <__umoddi3+0xfc>
  80209c:	0f bd e8             	bsr    %eax,%ebp
  80209f:	83 f5 1f             	xor    $0x1f,%ebp
  8020a2:	0f 84 ac 00 00 00    	je     802154 <__umoddi3+0x108>
  8020a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8020ad:	29 ef                	sub    %ebp,%edi
  8020af:	89 fe                	mov    %edi,%esi
  8020b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020b5:	89 e9                	mov    %ebp,%ecx
  8020b7:	d3 e0                	shl    %cl,%eax
  8020b9:	89 d7                	mov    %edx,%edi
  8020bb:	89 f1                	mov    %esi,%ecx
  8020bd:	d3 ef                	shr    %cl,%edi
  8020bf:	09 c7                	or     %eax,%edi
  8020c1:	89 e9                	mov    %ebp,%ecx
  8020c3:	d3 e2                	shl    %cl,%edx
  8020c5:	89 14 24             	mov    %edx,(%esp)
  8020c8:	89 d8                	mov    %ebx,%eax
  8020ca:	d3 e0                	shl    %cl,%eax
  8020cc:	89 c2                	mov    %eax,%edx
  8020ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020d2:	d3 e0                	shl    %cl,%eax
  8020d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020dc:	89 f1                	mov    %esi,%ecx
  8020de:	d3 e8                	shr    %cl,%eax
  8020e0:	09 d0                	or     %edx,%eax
  8020e2:	d3 eb                	shr    %cl,%ebx
  8020e4:	89 da                	mov    %ebx,%edx
  8020e6:	f7 f7                	div    %edi
  8020e8:	89 d3                	mov    %edx,%ebx
  8020ea:	f7 24 24             	mull   (%esp)
  8020ed:	89 c6                	mov    %eax,%esi
  8020ef:	89 d1                	mov    %edx,%ecx
  8020f1:	39 d3                	cmp    %edx,%ebx
  8020f3:	0f 82 87 00 00 00    	jb     802180 <__umoddi3+0x134>
  8020f9:	0f 84 91 00 00 00    	je     802190 <__umoddi3+0x144>
  8020ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  802103:	29 f2                	sub    %esi,%edx
  802105:	19 cb                	sbb    %ecx,%ebx
  802107:	89 d8                	mov    %ebx,%eax
  802109:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80210d:	d3 e0                	shl    %cl,%eax
  80210f:	89 e9                	mov    %ebp,%ecx
  802111:	d3 ea                	shr    %cl,%edx
  802113:	09 d0                	or     %edx,%eax
  802115:	89 e9                	mov    %ebp,%ecx
  802117:	d3 eb                	shr    %cl,%ebx
  802119:	89 da                	mov    %ebx,%edx
  80211b:	83 c4 1c             	add    $0x1c,%esp
  80211e:	5b                   	pop    %ebx
  80211f:	5e                   	pop    %esi
  802120:	5f                   	pop    %edi
  802121:	5d                   	pop    %ebp
  802122:	c3                   	ret    
  802123:	90                   	nop
  802124:	89 fd                	mov    %edi,%ebp
  802126:	85 ff                	test   %edi,%edi
  802128:	75 0b                	jne    802135 <__umoddi3+0xe9>
  80212a:	b8 01 00 00 00       	mov    $0x1,%eax
  80212f:	31 d2                	xor    %edx,%edx
  802131:	f7 f7                	div    %edi
  802133:	89 c5                	mov    %eax,%ebp
  802135:	89 f0                	mov    %esi,%eax
  802137:	31 d2                	xor    %edx,%edx
  802139:	f7 f5                	div    %ebp
  80213b:	89 c8                	mov    %ecx,%eax
  80213d:	f7 f5                	div    %ebp
  80213f:	89 d0                	mov    %edx,%eax
  802141:	e9 44 ff ff ff       	jmp    80208a <__umoddi3+0x3e>
  802146:	66 90                	xchg   %ax,%ax
  802148:	89 c8                	mov    %ecx,%eax
  80214a:	89 f2                	mov    %esi,%edx
  80214c:	83 c4 1c             	add    $0x1c,%esp
  80214f:	5b                   	pop    %ebx
  802150:	5e                   	pop    %esi
  802151:	5f                   	pop    %edi
  802152:	5d                   	pop    %ebp
  802153:	c3                   	ret    
  802154:	3b 04 24             	cmp    (%esp),%eax
  802157:	72 06                	jb     80215f <__umoddi3+0x113>
  802159:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80215d:	77 0f                	ja     80216e <__umoddi3+0x122>
  80215f:	89 f2                	mov    %esi,%edx
  802161:	29 f9                	sub    %edi,%ecx
  802163:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802167:	89 14 24             	mov    %edx,(%esp)
  80216a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80216e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802172:	8b 14 24             	mov    (%esp),%edx
  802175:	83 c4 1c             	add    $0x1c,%esp
  802178:	5b                   	pop    %ebx
  802179:	5e                   	pop    %esi
  80217a:	5f                   	pop    %edi
  80217b:	5d                   	pop    %ebp
  80217c:	c3                   	ret    
  80217d:	8d 76 00             	lea    0x0(%esi),%esi
  802180:	2b 04 24             	sub    (%esp),%eax
  802183:	19 fa                	sbb    %edi,%edx
  802185:	89 d1                	mov    %edx,%ecx
  802187:	89 c6                	mov    %eax,%esi
  802189:	e9 71 ff ff ff       	jmp    8020ff <__umoddi3+0xb3>
  80218e:	66 90                	xchg   %ax,%ax
  802190:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802194:	72 ea                	jb     802180 <__umoddi3+0x134>
  802196:	89 d9                	mov    %ebx,%ecx
  802198:	e9 62 ff ff ff       	jmp    8020ff <__umoddi3+0xb3>
