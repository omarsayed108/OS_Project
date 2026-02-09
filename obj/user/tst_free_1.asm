
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 0c 14 00 00       	call   801442 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <inRange>:
bool allocSpaceInPageAlloc(int index, uint32 size, bool writeData, uint32 expectedNumOfTables);
bool freeSpaceInPageAlloc(int index, bool isDataWritten);
int initial_page_allocations();

int inRange(int val, int min, int max)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	return (val >= min && val <= max) ? 1 : 0;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800041:	7c 0f                	jl     800052 <inRange+0x1a>
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	3b 45 10             	cmp    0x10(%ebp),%eax
  800049:	7f 07                	jg     800052 <inRange+0x1a>
  80004b:	b8 01 00 00 00       	mov    $0x1,%eax
  800050:	eb 05                	jmp    800057 <inRange+0x1f>
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800057:	5d                   	pop    %ebp
  800058:	c3                   	ret    

00800059 <allocSpaceInPageAlloc>:

bool allocSpaceInPageAlloc(int index, uint32 size, bool writeData, uint32 expectedNumOfTables)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	53                   	push   %ebx
  80005d:	83 ec 34             	sub    $0x34,%esp
	int correct = 1;
  800060:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int freeFrames = (int)sys_calculate_free_frames() ;
  800067:	e8 80 35 00 00       	call   8035ec <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 c3 35 00 00       	call   803637 <sys_pf_calculate_allocated_pages>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char *byteArr;

	//Allocate the required size
	requestedSizes[index] = size ;
  800077:	8b 45 08             	mov    0x8(%ebp),%eax
  80007a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80007d:	89 14 85 60 61 80 00 	mov    %edx,0x806160(,%eax,4)
	uint32 expectedNumOfFrames = ROUNDUP(requestedSizes[index], PAGE_SIZE) / PAGE_SIZE ;
  800084:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80008b:	8b 45 08             	mov    0x8(%ebp),%eax
  80008e:	8b 14 85 60 61 80 00 	mov    0x806160(,%eax,4),%edx
  800095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800098:	01 d0                	add    %edx,%eax
  80009a:	48                   	dec    %eax
  80009b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80009e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a6:	f7 75 e4             	divl   -0x1c(%ebp)
  8000a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ac:	29 d0                	sub    %edx,%eax
  8000ae:	c1 e8 0c             	shr    $0xc,%eax
  8000b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	{
		ptr_allocations[index] = malloc(requestedSizes[index]);
  8000b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b7:	8b 04 85 60 61 80 00 	mov    0x806160(,%eax,4),%eax
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	50                   	push   %eax
  8000c2:	e8 44 2e 00 00       	call   802f0b <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	89 c2                	mov    %eax,%edx
  8000cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cf:	89 14 85 20 60 80 00 	mov    %edx,0x806020(,%eax,4)
	}

	//Check allocation in RAM & Page File
	expectedNumOfFrames = expectedNumOfTables ;
  8000d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8000dc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000df:	e8 08 35 00 00       	call   8035ec <sys_calculate_free_frames>
  8000e4:	29 c3                	sub    %eax,%ebx
  8000e6:	89 d8                	mov    %ebx,%eax
  8000e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8000eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ee:	83 c0 02             	add    $0x2,%eax
  8000f1:	89 c1                	mov    %eax,%ecx
  8000f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8000f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	51                   	push   %ecx
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	e8 34 ff ff ff       	call   800038 <inRange>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	75 29                	jne    800134 <allocSpaceInPageAlloc+0xdb>
	{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong allocation in alloc#%d: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", index, expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80010b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800115:	83 c0 02             	add    $0x2,%eax
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	ff 75 f0             	pushl  -0x10(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	68 c0 4a 80 00       	push   $0x804ac0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 dc 17 00 00       	call   80190d <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 fe 34 00 00       	call   803637 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 3c 4b 80 00       	push   $0x804b3c
  800150:	6a 0c                	push   $0xc
  800152:	e8 b6 17 00 00       	call   80190d <cprintf_colored>
  800157:	83 c4 10             	add    $0x10,%esp

	lastIndices[index] = (size)/sizeof(char) - 1;
  80015a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015d:	48                   	dec    %eax
  80015e:	89 c2                	mov    %eax,%edx
  800160:	8b 45 08             	mov    0x8(%ebp),%eax
  800163:	89 14 85 c0 60 80 00 	mov    %edx,0x8060c0(,%eax,4)
	if (writeData)
  80016a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016e:	0f 84 25 01 00 00    	je     800299 <allocSpaceInPageAlloc+0x240>
	{
		//Write in first & last pages
		freeFrames = sys_calculate_free_frames() ;
  800174:	e8 73 34 00 00       	call   8035ec <sys_calculate_free_frames>
  800179:	89 45 ec             	mov    %eax,-0x14(%ebp)
		byteArr = (char *) ptr_allocations[index];
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800186:	89 45 d8             	mov    %eax,-0x28(%ebp)
		byteArr[0] = maxByte ;
  800189:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018c:	c6 00 7f             	movb   $0x7f,(%eax)
		byteArr[lastIndices[index]] = maxByte ;
  80018f:	8b 45 08             	mov    0x8(%ebp),%eax
  800192:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
  800199:	89 c2                	mov    %eax,%edx
  80019b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80019e:	01 d0                	add    %edx,%eax
  8001a0:	c6 00 7f             	movb   $0x7f,(%eax)

		//Check allocation in RAM & Page File
		expectedNumOfFrames = 1; /*table already created in malloc due to marking the allocated pages*/ ;
  8001a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if(size > PAGE_SIZE)
  8001aa:	81 7d 0c 00 10 00 00 	cmpl   $0x1000,0xc(%ebp)
  8001b1:	76 03                	jbe    8001b6 <allocSpaceInPageAlloc+0x15d>
			expectedNumOfFrames++ ;
  8001b3:	ff 45 f0             	incl   -0x10(%ebp)

		actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8001b6:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001b9:	e8 2e 34 00 00       	call   8035ec <sys_calculate_free_frames>
  8001be:	29 c3                	sub    %eax,%ebx
  8001c0:	89 d8                	mov    %ebx,%eax
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8001c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001c8:	83 c0 02             	add    $0x2,%eax
  8001cb:	89 c1                	mov    %eax,%ecx
  8001cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8001d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	51                   	push   %ecx
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	e8 5a fe ff ff       	call   800038 <inRange>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	75 22                	jne    800207 <allocSpaceInPageAlloc+0x1ae>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong fault handler in alloc#%d: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", index, expectedNumOfFrames, actualNumOfFrames);}
  8001e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	68 b4 4b 80 00       	push   $0x804bb4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 09 17 00 00       	call   80190d <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 2b 34 00 00       	call   803637 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 40 4c 80 00       	push   $0x804c40
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 dc 16 00 00       	call   80190d <cprintf_colored>
  800231:	83 c4 10             	add    $0x10,%esp

		//Check WS
		uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800242:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
  80024f:	89 c2                	mov    %eax,%edx
  800251:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800254:	01 d0                	add    %edx,%eax
  800256:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800259:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (sys_check_WS_list(expectedVAs, expectedNumOfFrames, 0, 2) != 1)
  800264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800267:	6a 02                	push   $0x2
  800269:	6a 00                	push   $0x0
  80026b:	50                   	push   %eax
  80026c:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80026f:	50                   	push   %eax
  800270:	e8 39 37 00 00       	call   8039ae <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 b8 4c 80 00       	push   $0x804cb8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 77 16 00 00       	call   80190d <cprintf_colored>
  800296:	83 c4 10             	add    $0x10,%esp
	}
	return correct;
  800299:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  80029c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <freeSpaceInPageAlloc>:

bool freeSpaceInPageAlloc(int index, bool isDataWritten)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 38             	sub    $0x38,%esp
	int correct = 1;
  8002a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int freeFrames = (int)sys_calculate_free_frames() ;
  8002ae:	e8 39 33 00 00       	call   8035ec <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 7c 33 00 00       	call   803637 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 be 2d 00 00       	call   80308f <free>
  8002d1:	83 c4 10             	add    $0x10,%esp
	}

	uint32 expectedNumOfFrames = 0;
  8002d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (isDataWritten)
  8002db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8002df:	74 1b                	je     8002fc <freeSpaceInPageAlloc+0x5b>
	{
		expectedNumOfFrames = 1;
  8002e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if(requestedSizes[index] > PAGE_SIZE)
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	8b 04 85 60 61 80 00 	mov    0x806160(,%eax,4),%eax
  8002f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8002f7:	76 03                	jbe    8002fc <freeSpaceInPageAlloc+0x5b>
			expectedNumOfFrames++ ;
  8002f9:	ff 45 f0             	incl   -0x10(%ebp)
	}
	//Check allocation in RAM & Page File
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8002fc:	e8 36 33 00 00       	call   803637 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 f0 4c 80 00       	push   $0x804cf0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 ee 15 00 00       	call   80190d <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 c5 32 00 00       	call   8035ec <sys_calculate_free_frames>
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	29 c2                	sub    %eax,%edx
  80032e:	89 d0                	mov    %edx,%eax
  800330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*max of: 1 page for KERN Block Alloc (WSelement) + 1 page for USER block alloc (private DS) */))
  800333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800336:	83 c0 02             	add    $0x2,%eax
  800339:	89 c2                	mov    %eax,%edx
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	52                   	push   %edx
  800342:	50                   	push   %eax
  800343:	ff 75 e4             	pushl  -0x1c(%ebp)
  800346:	e8 ed fc ff ff       	call   800038 <inRange>
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	85 c0                	test   %eax,%eax
  800350:	75 1c                	jne    80036e <freeSpaceInPageAlloc+0xcd>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 Wrong free in alloc#%d: WS pages in memory and/or page tables are not freed correctly\n", index);}
  800352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	68 3c 4d 80 00       	push   $0x804d3c
  800364:	6a 0c                	push   $0xc
  800366:	e8 a2 15 00 00       	call   80190d <cprintf_colored>
  80036b:	83 c4 10             	add    $0x10,%esp

	if (isDataWritten)
  80036e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800372:	74 72                	je     8003e6 <freeSpaceInPageAlloc+0x145>
	{
		//Check WS
		char* byteArr = (char *) ptr_allocations[index];
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80037e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800381:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800384:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800387:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
  80039c:	89 c2                	mov    %eax,%edx
  80039e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a1:	01 d0                	add    %edx,%eax
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (sys_check_WS_list(notExpectedVAs, expectedNumOfFrames, 0, 3) != 1)
  8003b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b4:	6a 03                	push   $0x3
  8003b6:	6a 00                	push   $0x0
  8003b8:	50                   	push   %eax
  8003b9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8003bc:	50                   	push   %eax
  8003bd:	e8 ec 35 00 00       	call   8039ae <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 98 4d 80 00       	push   $0x804d98
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 2a 15 00 00       	call   80190d <cprintf_colored>
  8003e3:	83 c4 10             	add    $0x10,%esp
	}
	return correct;
  8003e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8003e9:	c9                   	leave  
  8003ea:	c3                   	ret    

008003eb <initial_page_allocations>:

int initial_page_allocations()
{
  8003eb:	55                   	push   %ebp
  8003ec:	89 e5                	mov    %esp,%ebp
  8003ee:	57                   	push   %edi
  8003ef:	53                   	push   %ebx
  8003f0:	81 ec 40 01 00 00    	sub    $0x140,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE FOR SOME
	 * IMPLEMENTATIONS TO DYNAMICALLY ALLOCATE SPECIAL DATA
	 * STRUCTURE TO MANAGE THE PAGE ALLOCATOR.
	 *********************************************************/
	uint32 expectedVA = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  8003f6:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	//malloc some spaces
	int i, freeFrames, usedDiskPages, expectedNumOfTables ;
	uint32 size = 0;
  8003fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	char* ptr;
	int sums[20] = {0};
  800404:	8d 95 b8 fe ff ff    	lea    -0x148(%ebp),%edx
  80040a:	b9 14 00 00 00       	mov    $0x14,%ecx
  80040f:	b8 00 00 00 00       	mov    $0x0,%eax
  800414:	89 d7                	mov    %edx,%edi
  800416:	f3 ab                	rep stos %eax,%es:(%edi)
	totalRequestedSize = 0;
  800418:	c7 05 40 e2 81 00 00 	movl   $0x0,0x81e240
  80041f:	00 00 00 

	int eval = 0;
  800422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  800429:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n	1.1 Create some areas in PAGE allocators\n");
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	68 d0 4d 80 00       	push   $0x804dd0
  800438:	6a 03                	push   $0x3
  80043a:	e8 ce 14 00 00       	call   80190d <cprintf_colored>
  80043f:	83 c4 10             	add    $0x10,%esp
	{
		//4 MB
		allocIndex = 0;
  800442:	c7 05 4c e2 81 00 00 	movl   $0x0,0x81e24c
  800449:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  80044c:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  800453:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	48                   	dec    %eax
  80045c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
  800467:	f7 75 e4             	divl   -0x1c(%ebp)
  80046a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046d:	29 d0                	sub    %edx,%eax
  80046f:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 4*Mega - kilo;
  800472:	c7 45 e8 00 fc 3f 00 	movl   $0x3ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800479:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  800480:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	48                   	dec    %eax
  800489:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80048c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80048f:	ba 00 00 00 00       	mov    $0x0,%edx
  800494:	f7 75 dc             	divl   -0x24(%ebp)
  800497:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049a:	29 d0                	sub    %edx,%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8004a3:	01 d0                	add    %edx,%eax
  8004a5:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 2;
  8004aa:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8004b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004b4:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8004b9:	52                   	push   %edx
  8004ba:	6a 01                	push   $0x1
  8004bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8004bf:	50                   	push   %eax
  8004c0:	e8 94 fb ff ff       	call   800059 <allocSpaceInPageAlloc>
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8004cb:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8004d0:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8004d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8004da:	74 2f                	je     80050b <initial_page_allocations+0x120>
  8004dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004e3:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8004e8:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  8004ef:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	52                   	push   %edx
  8004f8:	ff 75 ec             	pushl  -0x14(%ebp)
  8004fb:	50                   	push   %eax
  8004fc:	68 00 4e 80 00       	push   $0x804e00
  800501:	6a 0c                	push   $0xc
  800503:	e8 05 14 00 00       	call   80190d <cprintf_colored>
  800508:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  80050b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80050f:	74 04                	je     800515 <initial_page_allocations+0x12a>
  800511:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800515:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//3 MB
		allocIndex = 1;
  80051c:	c7 05 4c e2 81 00 01 	movl   $0x1,0x81e24c
  800523:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800526:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80052d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800530:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800533:	01 d0                	add    %edx,%eax
  800535:	48                   	dec    %eax
  800536:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800539:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80053c:	ba 00 00 00 00       	mov    $0x0,%edx
  800541:	f7 75 d0             	divl   -0x30(%ebp)
  800544:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800547:	29 d0                	sub    %edx,%eax
  800549:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 3*Mega - kilo;
  80054c:	c7 45 e8 00 fc 2f 00 	movl   $0x2ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800553:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80055a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80055d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	48                   	dec    %eax
  800563:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800566:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800569:	ba 00 00 00 00       	mov    $0x0,%edx
  80056e:	f7 75 c8             	divl   -0x38(%ebp)
  800571:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800574:	29 d0                	sub    %edx,%eax
  800576:	89 c2                	mov    %eax,%edx
  800578:	a1 40 e2 81 00       	mov    0x81e240,%eax
  80057d:	01 d0                	add    %edx,%eax
  80057f:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  800584:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80058b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80058e:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800593:	52                   	push   %edx
  800594:	6a 01                	push   $0x1
  800596:	ff 75 e8             	pushl  -0x18(%ebp)
  800599:	50                   	push   %eax
  80059a:	e8 ba fa ff ff       	call   800059 <allocSpaceInPageAlloc>
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8005a5:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8005aa:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8005b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8005b4:	74 2f                	je     8005e5 <initial_page_allocations+0x1fa>
  8005b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005bd:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8005c2:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  8005c9:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8005ce:	83 ec 0c             	sub    $0xc,%esp
  8005d1:	52                   	push   %edx
  8005d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	68 00 4e 80 00       	push   $0x804e00
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 2b 13 00 00       	call   80190d <cprintf_colored>
  8005e2:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8005e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005e9:	74 04                	je     8005ef <initial_page_allocations+0x204>
  8005eb:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8005ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//2 MB
		allocIndex = 2;
  8005f6:	c7 05 4c e2 81 00 02 	movl   $0x2,0x81e24c
  8005fd:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800600:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800607:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80060a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80060d:	01 d0                	add    %edx,%eax
  80060f:	48                   	dec    %eax
  800610:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800613:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800616:	ba 00 00 00 00       	mov    $0x0,%edx
  80061b:	f7 75 c0             	divl   -0x40(%ebp)
  80061e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800621:	29 d0                	sub    %edx,%eax
  800623:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800626:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  80062d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  800634:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800637:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	48                   	dec    %eax
  80063d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800640:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800643:	ba 00 00 00 00       	mov    $0x0,%edx
  800648:	f7 75 b8             	divl   -0x48(%ebp)
  80064b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064e:	29 d0                	sub    %edx,%eax
  800650:	89 c2                	mov    %eax,%edx
  800652:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1;
  80065e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800665:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800668:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80066d:	52                   	push   %edx
  80066e:	6a 01                	push   $0x1
  800670:	ff 75 e8             	pushl  -0x18(%ebp)
  800673:	50                   	push   %eax
  800674:	e8 e0 f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80067f:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800684:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80068b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80068e:	74 2f                	je     8006bf <initial_page_allocations+0x2d4>
  800690:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800697:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80069c:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  8006a3:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	52                   	push   %edx
  8006ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8006af:	50                   	push   %eax
  8006b0:	68 00 4e 80 00       	push   $0x804e00
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 51 12 00 00       	call   80190d <cprintf_colored>
  8006bc:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  8006bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006c3:	74 04                	je     8006c9 <initial_page_allocations+0x2de>
  8006c5:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8006c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//4 MB
		allocIndex = 3;
  8006d0:	c7 05 4c e2 81 00 03 	movl   $0x3,0x81e24c
  8006d7:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  8006da:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8006e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	48                   	dec    %eax
  8006ea:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8006ed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	f7 75 b0             	divl   -0x50(%ebp)
  8006f8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006fb:	29 d0                	sub    %edx,%eax
  8006fd:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 4*Mega - kilo;
  800700:	c7 45 e8 00 fc 3f 00 	movl   $0x3ffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800707:	c7 45 a8 00 10 00 00 	movl   $0x1000,-0x58(%ebp)
  80070e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800711:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800714:	01 d0                	add    %edx,%eax
  800716:	48                   	dec    %eax
  800717:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80071a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80071d:	ba 00 00 00 00       	mov    $0x0,%edx
  800722:	f7 75 a8             	divl   -0x58(%ebp)
  800725:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800728:	29 d0                	sub    %edx,%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800731:	01 d0                	add    %edx,%eax
  800733:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1;
  800738:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80073f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800742:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800747:	52                   	push   %edx
  800748:	6a 01                	push   $0x1
  80074a:	ff 75 e8             	pushl  -0x18(%ebp)
  80074d:	50                   	push   %eax
  80074e:	e8 06 f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800759:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80075e:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800765:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800768:	74 2f                	je     800799 <initial_page_allocations+0x3ae>
  80076a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800771:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800776:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  80077d:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800782:	83 ec 0c             	sub    $0xc,%esp
  800785:	52                   	push   %edx
  800786:	ff 75 ec             	pushl  -0x14(%ebp)
  800789:	50                   	push   %eax
  80078a:	68 00 4e 80 00       	push   $0x804e00
  80078f:	6a 0c                	push   $0xc
  800791:	e8 77 11 00 00       	call   80190d <cprintf_colored>
  800796:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800799:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80079d:	74 04                	je     8007a3 <initial_page_allocations+0x3b8>
  80079f:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  8007a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
//		cprintf("%~allocation#%d with size %x is DONE\n", allocIndex, size);

		//1 MB
		allocIndex = 4;
  8007aa:	c7 05 4c e2 81 00 04 	movl   $0x4,0x81e24c
  8007b1:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  8007b4:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  8007bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007be:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	48                   	dec    %eax
  8007c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8007c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cf:	f7 75 a0             	divl   -0x60(%ebp)
  8007d2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8007d5:	29 d0                	sub    %edx,%eax
  8007d7:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 3*kilo;
  8007da:	c7 45 e8 00 f4 0f 00 	movl   $0xff400,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  8007e1:	c7 45 98 00 10 00 00 	movl   $0x1000,-0x68(%ebp)
  8007e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007eb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	48                   	dec    %eax
  8007f1:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8007f4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fc:	f7 75 98             	divl   -0x68(%ebp)
  8007ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800802:	29 d0                	sub    %edx,%eax
  800804:	89 c2                	mov    %eax,%edx
  800806:	a1 40 e2 81 00       	mov    0x81e240,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  800812:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800819:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80081c:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800821:	52                   	push   %edx
  800822:	6a 01                	push   $0x1
  800824:	ff 75 e8             	pushl  -0x18(%ebp)
  800827:	50                   	push   %eax
  800828:	e8 2c f8 ff ff       	call   800059 <allocSpaceInPageAlloc>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800833:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800838:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80083f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800842:	74 2f                	je     800873 <initial_page_allocations+0x488>
  800844:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80084b:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800850:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800857:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	52                   	push   %edx
  800860:	ff 75 ec             	pushl  -0x14(%ebp)
  800863:	50                   	push   %eax
  800864:	68 00 4e 80 00       	push   $0x804e00
  800869:	6a 0c                	push   $0xc
  80086b:	e8 9d 10 00 00       	call   80190d <cprintf_colored>
  800870:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800873:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800877:	74 04                	je     80087d <initial_page_allocations+0x492>
  800879:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  80087d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 5;
  800884:	c7 05 4c e2 81 00 05 	movl   $0x5,0x81e24c
  80088b:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  80088e:	c7 45 90 00 10 00 00 	movl   $0x1000,-0x70(%ebp)
  800895:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800898:	8b 45 90             	mov    -0x70(%ebp),%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	48                   	dec    %eax
  80089e:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8008a1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	f7 75 90             	divl   -0x70(%ebp)
  8008ac:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8008af:	29 d0                	sub    %edx,%eax
  8008b1:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 2*kilo;
  8008b4:	c7 45 e8 00 f8 0f 00 	movl   $0xff800,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  8008bb:	c7 45 88 00 10 00 00 	movl   $0x1000,-0x78(%ebp)
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8008c8:	01 d0                	add    %edx,%eax
  8008ca:	48                   	dec    %eax
  8008cb:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8008ce:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8008d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d6:	f7 75 88             	divl   -0x78(%ebp)
  8008d9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8008dc:	29 d0                	sub    %edx,%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8008e5:	01 d0                	add    %edx,%eax
  8008e7:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  8008ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8008f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008f6:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8008fb:	52                   	push   %edx
  8008fc:	6a 01                	push   $0x1
  8008fe:	ff 75 e8             	pushl  -0x18(%ebp)
  800901:	50                   	push   %eax
  800902:	e8 52 f7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80090d:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800912:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800919:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80091c:	74 2f                	je     80094d <initial_page_allocations+0x562>
  80091e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800925:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80092a:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800931:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800936:	83 ec 0c             	sub    $0xc,%esp
  800939:	52                   	push   %edx
  80093a:	ff 75 ec             	pushl  -0x14(%ebp)
  80093d:	50                   	push   %eax
  80093e:	68 00 4e 80 00       	push   $0x804e00
  800943:	6a 0c                	push   $0xc
  800945:	e8 c3 0f 00 00       	call   80190d <cprintf_colored>
  80094a:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  80094d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800951:	74 04                	je     800957 <initial_page_allocations+0x56c>
  800953:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800957:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 6;
  80095e:	c7 05 4c e2 81 00 06 	movl   $0x6,0x81e24c
  800965:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800968:	c7 45 80 00 10 00 00 	movl   $0x1000,-0x80(%ebp)
  80096f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800972:	8b 45 80             	mov    -0x80(%ebp),%eax
  800975:	01 d0                	add    %edx,%eax
  800977:	48                   	dec    %eax
  800978:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80097e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	f7 75 80             	divl   -0x80(%ebp)
  80098c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800992:	29 d0                	sub    %edx,%eax
  800994:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 1*Mega - 1*kilo;
  800997:	c7 45 e8 00 fc 0f 00 	movl   $0xffc00,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  80099e:	c7 85 78 ff ff ff 00 	movl   $0x1000,-0x88(%ebp)
  8009a5:	10 00 00 
  8009a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ab:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8009b1:	01 d0                	add    %edx,%eax
  8009b3:	48                   	dec    %eax
  8009b4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  8009ba:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	f7 b5 78 ff ff ff    	divl   -0x88(%ebp)
  8009cb:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8009d1:	29 d0                	sub    %edx,%eax
  8009d3:	89 c2                	mov    %eax,%edx
  8009d5:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8009da:	01 d0                	add    %edx,%eax
  8009dc:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1; //since page allocator is started 1 page after the 32MB of Block Allocator
  8009e1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8009e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009eb:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8009f0:	52                   	push   %edx
  8009f1:	6a 01                	push   $0x1
  8009f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 5d f6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800a02:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800a07:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800a0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800a11:	74 2f                	je     800a42 <initial_page_allocations+0x657>
  800a13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a1a:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800a1f:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800a26:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800a2b:	83 ec 0c             	sub    $0xc,%esp
  800a2e:	52                   	push   %edx
  800a2f:	ff 75 ec             	pushl  -0x14(%ebp)
  800a32:	50                   	push   %eax
  800a33:	68 00 4e 80 00       	push   $0x804e00
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 ce 0e 00 00       	call   80190d <cprintf_colored>
  800a3f:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a46:	74 04                	je     800a4c <initial_page_allocations+0x661>
  800a48:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800a4c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 7;
  800a53:	c7 05 4c e2 81 00 07 	movl   $0x7,0x81e24c
  800a5a:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800a5d:	c7 85 70 ff ff ff 00 	movl   $0x1000,-0x90(%ebp)
  800a64:	10 00 00 
  800a67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a6a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a70:	01 d0                	add    %edx,%eax
  800a72:	48                   	dec    %eax
  800a73:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800a79:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a84:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  800a8a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a90:	29 d0                	sub    %edx,%eax
  800a92:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800a95:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800a9c:	c7 85 68 ff ff ff 00 	movl   $0x1000,-0x98(%ebp)
  800aa3:	10 00 00 
  800aa6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aa9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	48                   	dec    %eax
  800ab2:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800ab8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800abe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac3:	f7 b5 68 ff ff ff    	divl   -0x98(%ebp)
  800ac9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800acf:	29 d0                	sub    %edx,%eax
  800ad1:	89 c2                	mov    %eax,%edx
  800ad3:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 0;
  800adf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ae6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ae9:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800aee:	52                   	push   %edx
  800aef:	6a 01                	push   $0x1
  800af1:	ff 75 e8             	pushl  -0x18(%ebp)
  800af4:	50                   	push   %eax
  800af5:	e8 5f f5 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800b00:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800b05:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800b0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800b0f:	74 2f                	je     800b40 <initial_page_allocations+0x755>
  800b11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b18:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800b1d:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800b24:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800b29:	83 ec 0c             	sub    $0xc,%esp
  800b2c:	52                   	push   %edx
  800b2d:	ff 75 ec             	pushl  -0x14(%ebp)
  800b30:	50                   	push   %eax
  800b31:	68 00 4e 80 00       	push   $0x804e00
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 d0 0d 00 00       	call   80190d <cprintf_colored>
  800b3d:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800b40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b44:	74 04                	je     800b4a <initial_page_allocations+0x75f>
  800b46:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800b4a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 8;
  800b51:	c7 05 4c e2 81 00 08 	movl   $0x8,0x81e24c
  800b58:	00 00 00 
		expectedVA += ROUNDUP(size, PAGE_SIZE);
  800b5b:	c7 85 60 ff ff ff 00 	movl   $0x1000,-0xa0(%ebp)
  800b62:	10 00 00 
  800b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b68:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	48                   	dec    %eax
  800b71:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800b77:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b82:	f7 b5 60 ff ff ff    	divl   -0xa0(%ebp)
  800b88:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b8e:	29 d0                	sub    %edx,%eax
  800b90:	01 45 ec             	add    %eax,-0x14(%ebp)
		size = 2*Mega ;
  800b93:	c7 45 e8 00 00 20 00 	movl   $0x200000,-0x18(%ebp)
		totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800b9a:	c7 85 58 ff ff ff 00 	movl   $0x1000,-0xa8(%ebp)
  800ba1:	10 00 00 
  800ba4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ba7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800bad:	01 d0                	add    %edx,%eax
  800baf:	48                   	dec    %eax
  800bb0:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800bb6:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc1:	f7 b5 58 ff ff ff    	divl   -0xa8(%ebp)
  800bc7:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800bcd:	29 d0                	sub    %edx,%eax
  800bcf:	89 c2                	mov    %eax,%edx
  800bd1:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800bd6:	01 d0                	add    %edx,%eax
  800bd8:	a3 40 e2 81 00       	mov    %eax,0x81e240
		expectedNumOfTables = 1;
  800bdd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800be4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800be7:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800bec:	52                   	push   %edx
  800bed:	6a 01                	push   $0x1
  800bef:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf2:	50                   	push   %eax
  800bf3:	e8 61 f4 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800bf8:	83 c4 10             	add    $0x10,%esp
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800bfe:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800c03:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800c0a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800c0d:	74 2f                	je     800c3e <initial_page_allocations+0x853>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800c1b:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800c22:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	52                   	push   %edx
  800c2b:	ff 75 ec             	pushl  -0x14(%ebp)
  800c2e:	50                   	push   %eax
  800c2f:	68 00 4e 80 00       	push   $0x804e00
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 d2 0c 00 00       	call   80190d <cprintf_colored>
  800c3b:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800c3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c42:	74 04                	je     800c48 <initial_page_allocations+0x85d>
  800c44:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800c48:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//ALLOCATIONS OF KILO BYTES
		{
			//3 KB
			allocIndex = 9;
  800c4f:	c7 05 4c e2 81 00 09 	movl   $0x9,0x81e24c
  800c56:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800c59:	c7 85 50 ff ff ff 00 	movl   $0x1000,-0xb0(%ebp)
  800c60:	10 00 00 
  800c63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c66:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	48                   	dec    %eax
  800c6f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800c75:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c80:	f7 b5 50 ff ff ff    	divl   -0xb0(%ebp)
  800c86:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c8c:	29 d0                	sub    %edx,%eax
  800c8e:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 3*kilo ;
  800c91:	c7 45 e8 00 0c 00 00 	movl   $0xc00,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800c98:	c7 85 48 ff ff ff 00 	movl   $0x1000,-0xb8(%ebp)
  800c9f:	10 00 00 
  800ca2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ca5:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cab:	01 d0                	add    %edx,%eax
  800cad:	48                   	dec    %eax
  800cae:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800cb4:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	f7 b5 48 ff ff ff    	divl   -0xb8(%ebp)
  800cc5:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800ccb:	29 d0                	sub    %edx,%eax
  800ccd:	89 c2                	mov    %eax,%edx
  800ccf:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800cd4:	01 d0                	add    %edx,%eax
  800cd6:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800cdb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ce2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ce5:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800cea:	52                   	push   %edx
  800ceb:	6a 01                	push   $0x1
  800ced:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf0:	50                   	push   %eax
  800cf1:	e8 63 f3 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800cf6:	83 c4 10             	add    $0x10,%esp
  800cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800cfc:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800d01:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800d08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d0b:	74 2f                	je     800d3c <initial_page_allocations+0x951>
  800d0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d14:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800d19:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800d20:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800d25:	83 ec 0c             	sub    $0xc,%esp
  800d28:	52                   	push   %edx
  800d29:	ff 75 ec             	pushl  -0x14(%ebp)
  800d2c:	50                   	push   %eax
  800d2d:	68 00 4e 80 00       	push   $0x804e00
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 d4 0b 00 00       	call   80190d <cprintf_colored>
  800d39:	83 c4 20             	add    $0x20,%esp

			//5 KB
			allocIndex = 10;
  800d3c:	c7 05 4c e2 81 00 0a 	movl   $0xa,0x81e24c
  800d43:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800d46:	c7 85 40 ff ff ff 00 	movl   $0x1000,-0xc0(%ebp)
  800d4d:	10 00 00 
  800d50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d53:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d59:	01 d0                	add    %edx,%eax
  800d5b:	48                   	dec    %eax
  800d5c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800d62:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d68:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6d:	f7 b5 40 ff ff ff    	divl   -0xc0(%ebp)
  800d73:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d79:	29 d0                	sub    %edx,%eax
  800d7b:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 5*kilo ;
  800d7e:	c7 45 e8 00 14 00 00 	movl   $0x1400,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800d85:	c7 85 38 ff ff ff 00 	movl   $0x1000,-0xc8(%ebp)
  800d8c:	10 00 00 
  800d8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d92:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d98:	01 d0                	add    %edx,%eax
  800d9a:	48                   	dec    %eax
  800d9b:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800da1:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800da7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dac:	f7 b5 38 ff ff ff    	divl   -0xc8(%ebp)
  800db2:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800db8:	29 d0                	sub    %edx,%eax
  800dba:	89 c2                	mov    %eax,%edx
  800dbc:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800dc1:	01 d0                	add    %edx,%eax
  800dc3:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800dc8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800dcf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800dd2:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800dd7:	52                   	push   %edx
  800dd8:	6a 01                	push   $0x1
  800dda:	ff 75 e8             	pushl  -0x18(%ebp)
  800ddd:	50                   	push   %eax
  800dde:	e8 76 f2 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800de9:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800dee:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800df5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800df8:	74 2f                	je     800e29 <initial_page_allocations+0xa3e>
  800dfa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e01:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800e06:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800e0d:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	52                   	push   %edx
  800e16:	ff 75 ec             	pushl  -0x14(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	68 00 4e 80 00       	push   $0x804e00
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 e7 0a 00 00       	call   80190d <cprintf_colored>
  800e26:	83 c4 20             	add    $0x20,%esp

			//3 KB
			allocIndex = 11;
  800e29:	c7 05 4c e2 81 00 0b 	movl   $0xb,0x81e24c
  800e30:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800e33:	c7 85 30 ff ff ff 00 	movl   $0x1000,-0xd0(%ebp)
  800e3a:	10 00 00 
  800e3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e40:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	48                   	dec    %eax
  800e49:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800e4f:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e55:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5a:	f7 b5 30 ff ff ff    	divl   -0xd0(%ebp)
  800e60:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e66:	29 d0                	sub    %edx,%eax
  800e68:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 3*kilo ;
  800e6b:	c7 45 e8 00 0c 00 00 	movl   $0xc00,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800e72:	c7 85 28 ff ff ff 00 	movl   $0x1000,-0xd8(%ebp)
  800e79:	10 00 00 
  800e7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e7f:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e85:	01 d0                	add    %edx,%eax
  800e87:	48                   	dec    %eax
  800e88:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  800e8e:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e94:	ba 00 00 00 00       	mov    $0x0,%edx
  800e99:	f7 b5 28 ff ff ff    	divl   -0xd8(%ebp)
  800e9f:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800ea5:	29 d0                	sub    %edx,%eax
  800ea7:	89 c2                	mov    %eax,%edx
  800ea9:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800eb5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ebc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ebf:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ec4:	52                   	push   %edx
  800ec5:	6a 01                	push   $0x1
  800ec7:	ff 75 e8             	pushl  -0x18(%ebp)
  800eca:	50                   	push   %eax
  800ecb:	e8 89 f1 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800ed6:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800edb:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800ee2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ee5:	74 2f                	je     800f16 <initial_page_allocations+0xb2b>
  800ee7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eee:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800ef3:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800efa:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	52                   	push   %edx
  800f03:	ff 75 ec             	pushl  -0x14(%ebp)
  800f06:	50                   	push   %eax
  800f07:	68 00 4e 80 00       	push   $0x804e00
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 fa 09 00 00       	call   80190d <cprintf_colored>
  800f13:	83 c4 20             	add    $0x20,%esp

			//9 KB
			allocIndex = 12;
  800f16:	c7 05 4c e2 81 00 0c 	movl   $0xc,0x81e24c
  800f1d:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  800f20:	c7 85 20 ff ff ff 00 	movl   $0x1000,-0xe0(%ebp)
  800f27:	10 00 00 
  800f2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f2d:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800f33:	01 d0                	add    %edx,%eax
  800f35:	48                   	dec    %eax
  800f36:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800f3c:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f42:	ba 00 00 00 00       	mov    $0x0,%edx
  800f47:	f7 b5 20 ff ff ff    	divl   -0xe0(%ebp)
  800f4d:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f53:	29 d0                	sub    %edx,%eax
  800f55:	01 45 ec             	add    %eax,-0x14(%ebp)
			size = 9*kilo ;
  800f58:	c7 45 e8 00 24 00 00 	movl   $0x2400,-0x18(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  800f5f:	c7 85 18 ff ff ff 00 	movl   $0x1000,-0xe8(%ebp)
  800f66:	10 00 00 
  800f69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f6c:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800f72:	01 d0                	add    %edx,%eax
  800f74:	48                   	dec    %eax
  800f75:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f7b:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f81:	ba 00 00 00 00       	mov    $0x0,%edx
  800f86:	f7 b5 18 ff ff ff    	divl   -0xe8(%ebp)
  800f8c:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f92:	29 d0                	sub    %edx,%eax
  800f94:	89 c2                	mov    %eax,%edx
  800f96:	a1 40 e2 81 00       	mov    0x81e240,%eax
  800f9b:	01 d0                	add    %edx,%eax
  800f9d:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 0;
  800fa2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800fa9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fac:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800fb1:	52                   	push   %edx
  800fb2:	6a 01                	push   $0x1
  800fb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800fb7:	50                   	push   %eax
  800fb8:	e8 9c f0 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800fbd:	83 c4 10             	add    $0x10,%esp
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800fc3:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800fc8:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  800fcf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800fd2:	74 2f                	je     801003 <initial_page_allocations+0xc18>
  800fd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fdb:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800fe0:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  800fe7:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	52                   	push   %edx
  800ff0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ff3:	50                   	push   %eax
  800ff4:	68 00 4e 80 00       	push   $0x804e00
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 0d 09 00 00       	call   80190d <cprintf_colored>
  801000:	83 c4 20             	add    $0x20,%esp
		}
		if (correct) eval += 15;
  801003:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801007:	74 04                	je     80100d <initial_page_allocations+0xc22>
  801009:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		correct = 1;
  80100d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	//Insufficient space
	cprintf_colored(TEXT_cyan,"%~\n	1.2 Insufficient Space\n");
  801014:	83 ec 08             	sub    $0x8,%esp
  801017:	68 52 4e 80 00       	push   $0x804e52
  80101c:	6a 03                	push   $0x3
  80101e:	e8 ea 08 00 00       	call   80190d <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 b0 25 00 00       	call   8035ec <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 f0 25 00 00       	call   803637 <sys_pf_calculate_allocated_pages>
  801047:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		uint32 restOfUHeap = (USER_HEAP_MAX - ACTUAL_PAGE_ALLOC_START) - (totalRequestedSize) ;
  80104d:	a1 40 e2 81 00       	mov    0x81e240,%eax
  801052:	ba 00 f0 ff 1d       	mov    $0x1dfff000,%edx
  801057:	29 c2                	sub    %eax,%edx
  801059:	89 d0                	mov    %edx,%eax
  80105b:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
		ptr_allocations[allocIndex] = malloc(restOfUHeap+1);
  801061:	8b 1d 4c e2 81 00    	mov    0x81e24c,%ebx
  801067:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80106d:	40                   	inc    %eax
  80106e:	83 ec 0c             	sub    $0xc,%esp
  801071:	50                   	push   %eax
  801072:	e8 94 1e 00 00       	call   802f0b <malloc>
  801077:	83 c4 10             	add    $0x10,%esp
  80107a:	89 04 9d 20 60 80 00 	mov    %eax,0x806020(,%ebx,4)
		if (ptr_allocations[allocIndex] != NULL) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.1 Allocating insufficient space: should return NULL\n", allocIndex); }
  801081:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801086:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80108d:	85 c0                	test   %eax,%eax
  80108f:	74 1f                	je     8010b0 <initial_page_allocations+0xcc5>
  801091:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801098:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	50                   	push   %eax
  8010a1:	68 70 4e 80 00       	push   $0x804e70
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 60 08 00 00       	call   80190d <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 82 25 00 00       	call   803637 <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 ac 4e 80 00       	push   $0x804eac
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 34 08 00 00       	call   80190d <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 0b 25 00 00       	call   8035ec <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 1c 4f 80 00       	push   $0x804f1c
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 08 08 00 00       	call   80190d <cprintf_colored>
  801105:	83 c4 10             	add    $0x10,%esp
	}
	if (correct)	eval+=10 ;
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 04                	je     801112 <initial_page_allocations+0xd27>
  80110e:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)

	return eval;
  801112:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801115:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801118:	5b                   	pop    %ebx
  801119:	5f                   	pop    %edi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <_main>:
/* *********************************************************** */
#include <inc/lib.h>
#include <user/tst_malloc_helpers.h>

void _main(void)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 28             	sub    $0x28,%esp

#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801122:	a1 00 62 80 00       	mov    0x806200,%eax
  801127:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80112d:	a1 00 62 80 00       	mov    0x806200,%eax
  801132:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	72 14                	jb     801150 <_main+0x34>
			panic("Please increase the WS size");
  80113c:	83 ec 04             	sub    $0x4,%esp
  80113f:	68 64 4f 80 00       	push   $0x804f64
  801144:	6a 15                	push   $0x15
  801146:	68 80 4f 80 00       	push   $0x804f80
  80114b:	e8 a2 04 00 00       	call   8015f2 <_panic>
	/*=================================================*/
#else
	panic("not handled!");
#endif
	//1. Alloc some spaces in PAGE allocator
	int correct = 1;
  801150:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int eval;
	cprintf_colored(TEXT_cyan,"\n1. Alloc some spaces in PAGE allocator\n");
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	68 94 4f 80 00       	push   $0x804f94
  80115f:	6a 03                	push   $0x3
  801161:	e8 a7 07 00 00       	call   80190d <cprintf_colored>
  801166:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  801169:	e8 7d f2 ff ff       	call   8003eb <initial_page_allocations>
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (eval != 100)
  801171:	83 7d f0 64          	cmpl   $0x64,-0x10(%ebp)
  801175:	74 17                	je     80118e <_main+0x72>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"initial allocations are not correct!\nplease make sure the the kmalloc test is correct before testing the kfree\n");
  801177:	83 ec 08             	sub    $0x8,%esp
  80117a:	68 c0 4f 80 00       	push   $0x804fc0
  80117f:	6a 0c                	push   $0xc
  801181:	e8 87 07 00 00       	call   80190d <cprintf_colored>
  801186:	83 c4 10             	add    $0x10,%esp
			return ;
  801189:	e9 b2 02 00 00       	jmp    801440 <_main+0x324>
		}
	}
	eval = 0;
  80118e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 pagealloc_end = ACTUAL_PAGE_ALLOC_START + totalRequestedSize ;
  801195:	a1 40 e2 81 00       	mov    0x81e240,%eax
  80119a:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  80119f:	89 45 ec             	mov    %eax,-0x14(%ebp)


	correct = 1;
  8011a2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	//2. FREE Some
	cprintf_colored(TEXT_cyan,"%~\n2. Free some allocated spaces from PAGE ALLOCATOR [50%]\n");
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	68 30 50 80 00       	push   $0x805030
  8011b1:	6a 03                	push   $0x3
  8011b3:	e8 55 07 00 00       	call   80190d <cprintf_colored>
  8011b8:	83 c4 10             	add    $0x10,%esp
	{
		//3 MB Hole
		correct = freeSpaceInPageAlloc(1, 1);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	6a 01                	push   $0x1
  8011c0:	6a 01                	push   $0x1
  8011c2:	e8 da f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 10;
  8011cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011d1:	74 04                	je     8011d7 <_main+0xbb>
  8011d3:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
		correct = 1;
  8011d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 4 MB Hole
		correct = freeSpaceInPageAlloc(3, 1);
  8011de:	83 ec 08             	sub    $0x8,%esp
  8011e1:	6a 01                	push   $0x1
  8011e3:	6a 03                	push   $0x3
  8011e5:	e8 b7 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 10;
  8011f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011f4:	74 04                	je     8011fa <_main+0xde>
  8011f6:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
		correct = 1;
  8011fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 1 MB Hole
		correct = freeSpaceInPageAlloc(5, 1);
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	6a 01                	push   $0x1
  801206:	6a 05                	push   $0x5
  801208:	e8 94 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  801213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801217:	74 04                	je     80121d <_main+0x101>
  801219:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  80121d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 2 MB Hole
		correct = freeSpaceInPageAlloc(7, 1);
  801224:	83 ec 08             	sub    $0x8,%esp
  801227:	6a 01                	push   $0x1
  801229:	6a 07                	push   $0x7
  80122b:	e8 71 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  801236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80123a:	74 04                	je     801240 <_main+0x124>
  80123c:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801240:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//1st 3 KB Hole
		correct = freeSpaceInPageAlloc(9, 1);
  801247:	83 ec 08             	sub    $0x8,%esp
  80124a:	6a 01                	push   $0x1
  80124c:	6a 09                	push   $0x9
  80124e:	e8 4e f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  801259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80125d:	74 04                	je     801263 <_main+0x147>
  80125f:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801263:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//2nd 3 KB Hole
		correct = freeSpaceInPageAlloc(11, 1);
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	6a 01                	push   $0x1
  80126f:	6a 0b                	push   $0xb
  801271:	e8 2b f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  80127c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801280:	74 04                	je     801286 <_main+0x16a>
  801282:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  801286:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//5 KB Hole (should be merged with prev & next)
		correct = freeSpaceInPageAlloc(10, 1);
  80128d:	83 ec 08             	sub    $0x8,%esp
  801290:	6a 01                	push   $0x1
  801292:	6a 0a                	push   $0xa
  801294:	e8 08 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  80129f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012a3:	74 04                	je     8012a9 <_main+0x18d>
  8012a5:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  8012a9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

		//LAST 9 KB Hole (break should be moved down to the begin of alloc#9)
		correct = freeSpaceInPageAlloc(12, 1);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	6a 01                	push   $0x1
  8012b5:	6a 0c                	push   $0xc
  8012b7:	e8 e5 ef ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (correct) eval += 5;
  8012c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012c6:	74 04                	je     8012cc <_main+0x1b0>
  8012c8:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
		correct = 1;
  8012cc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}

	//3. Check the move-down of the BREAK
	correct = 1;
  8012d3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n3. Check the move-down of the BREAK [20%]\n");
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	68 6c 50 80 00       	push   $0x80506c
  8012e2:	6a 03                	push   $0x3
  8012e4:	e8 24 06 00 00       	call   80190d <cprintf_colored>
  8012e9:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedBreak = ACTUAL_PAGE_ALLOC_START + totalRequestedSize - 28*kilo;
  8012ec:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8012f1:	2d 00 60 00 7e       	sub    $0x7e006000,%eax
  8012f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(uheapPageAllocBreak != expectedBreak)
  8012f9:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8012fe:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801301:	74 1f                	je     801322 <_main+0x206>
		{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedBreak, uheapPageAllocBreak);}
  801303:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80130a:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80130f:	50                   	push   %eax
  801310:	ff 75 e8             	pushl  -0x18(%ebp)
  801313:	68 9c 50 80 00       	push   $0x80509c
  801318:	6a 0c                	push   $0xc
  80131a:	e8 ee 05 00 00       	call   80190d <cprintf_colored>
  80131f:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 20;
  801322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801326:	74 04                	je     80132c <_main+0x210>
  801328:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)

	//4. Test accessing a freed area (processes should be killed by the validation of the fault handler)
	correct = 1;
  80132c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n4. Test accessing a freed area (processes should be killed by the validation of the fault handler) [30%]\n");
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	68 d4 50 80 00       	push   $0x8050d4
  80133b:	6a 03                	push   $0x3
  80133d:	e8 cb 05 00 00       	call   80190d <cprintf_colored>
  801342:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  801345:	e8 49 25 00 00       	call   803893 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80134a:	a1 00 62 80 00       	mov    0x806200,%eax
  80134f:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  801355:	a1 00 62 80 00       	mov    0x806200,%eax
  80135a:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  801360:	89 c1                	mov    %eax,%ecx
  801362:	a1 00 62 80 00       	mov    0x806200,%eax
  801367:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80136d:	52                   	push   %edx
  80136e:	51                   	push   %ecx
  80136f:	50                   	push   %eax
  801370:	68 41 51 80 00       	push   $0x805141
  801375:	e8 cd 23 00 00       	call   803747 <sys_create_env>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		sys_run_env(ID1);
  801380:	83 ec 0c             	sub    $0xc,%esp
  801383:	ff 75 e4             	pushl  -0x1c(%ebp)
  801386:	e8 da 23 00 00       	call   803765 <sys_run_env>
  80138b:	83 c4 10             	add    $0x10,%esp

		//wait until the 1st slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80138e:	90                   	nop
  80138f:	e8 79 25 00 00       	call   80390d <gettst>
  801394:	83 f8 01             	cmp    $0x1,%eax
  801397:	75 f6                	jne    80138f <_main+0x273>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801399:	a1 00 62 80 00       	mov    0x806200,%eax
  80139e:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8013a4:	a1 00 62 80 00       	mov    0x806200,%eax
  8013a9:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8013af:	89 c1                	mov    %eax,%ecx
  8013b1:	a1 00 62 80 00       	mov    0x806200,%eax
  8013b6:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8013bc:	52                   	push   %edx
  8013bd:	51                   	push   %ecx
  8013be:	50                   	push   %eax
  8013bf:	68 4c 51 80 00       	push   $0x80514c
  8013c4:	e8 7e 23 00 00       	call   803747 <sys_create_env>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		sys_run_env(ID2);
  8013cf:	83 ec 0c             	sub    $0xc,%esp
  8013d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8013d5:	e8 8b 23 00 00       	call   803765 <sys_run_env>
  8013da:	83 c4 10             	add    $0x10,%esp

		//wait until the 2nd slave finishes the allocation & freeing operations
		while (gettst() != 2) ;
  8013dd:	90                   	nop
  8013de:	e8 2a 25 00 00       	call   80390d <gettst>
  8013e3:	83 f8 02             	cmp    $0x2,%eax
  8013e6:	75 f6                	jne    8013de <_main+0x2c2>

		//signal them to start accessing the freed area
		inctst();
  8013e8:	e8 06 25 00 00       	call   8038f3 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(15000);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	68 98 3a 00 00       	push   $0x3a98
  8013f5:	e8 9f 33 00 00       	call   804799 <env_sleep>
  8013fa:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  8013fd:	e8 0b 25 00 00       	call   80390d <gettst>
  801402:	83 f8 03             	cmp    $0x3,%eax
  801405:	76 19                	jbe    801420 <_main+0x304>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801407:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	68 58 51 80 00       	push   $0x805158
  801416:	6a 0c                	push   $0xc
  801418:	e8 f0 04 00 00       	call   80190d <cprintf_colored>
  80141d:	83 c4 10             	add    $0x10,%esp
	}
	if (correct)
  801420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801424:	74 04                	je     80142a <_main+0x30e>
	{
		eval += 30;
  801426:	83 45 f0 1e          	addl   $0x1e,-0x10(%ebp)
	}
	cprintf_colored(TEXT_light_green, "%~\ntest free [1] [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	ff 75 f0             	pushl  -0x10(%ebp)
  801430:	68 e4 51 80 00       	push   $0x8051e4
  801435:	6a 0a                	push   $0xa
  801437:	e8 d1 04 00 00       	call   80190d <cprintf_colored>
  80143c:	83 c4 10             	add    $0x10,%esp

	return;
  80143f:	90                   	nop
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	57                   	push   %edi
  801446:	56                   	push   %esi
  801447:	53                   	push   %ebx
  801448:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80144b:	e8 65 23 00 00       	call   8037b5 <sys_getenvindex>
  801450:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801453:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801456:	89 d0                	mov    %edx,%eax
  801458:	01 c0                	add    %eax,%eax
  80145a:	01 d0                	add    %edx,%eax
  80145c:	c1 e0 02             	shl    $0x2,%eax
  80145f:	01 d0                	add    %edx,%eax
  801461:	c1 e0 02             	shl    $0x2,%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	c1 e0 03             	shl    $0x3,%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	c1 e0 02             	shl    $0x2,%eax
  80146e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801473:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801478:	a1 00 62 80 00       	mov    0x806200,%eax
  80147d:	8a 40 20             	mov    0x20(%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 0d                	je     801491 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801484:	a1 00 62 80 00       	mov    0x806200,%eax
  801489:	83 c0 20             	add    $0x20,%eax
  80148c:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801491:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801495:	7e 0a                	jle    8014a1 <libmain+0x5f>
		binaryname = argv[0];
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	ff 75 08             	pushl  0x8(%ebp)
  8014aa:	e8 6d fc ff ff       	call   80111c <_main>
  8014af:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8014b2:	a1 00 60 80 00       	mov    0x806000,%eax
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	0f 84 01 01 00 00    	je     8015c0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8014bf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014c5:	bb 18 53 80 00       	mov    $0x805318,%ebx
  8014ca:	ba 0e 00 00 00       	mov    $0xe,%edx
  8014cf:	89 c7                	mov    %eax,%edi
  8014d1:	89 de                	mov    %ebx,%esi
  8014d3:	89 d1                	mov    %edx,%ecx
  8014d5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8014d7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8014da:	b9 56 00 00 00       	mov    $0x56,%ecx
  8014df:	b0 00                	mov    $0x0,%al
  8014e1:	89 d7                	mov    %edx,%edi
  8014e3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8014e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8014ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	50                   	push   %eax
  8014f3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	e8 ec 24 00 00       	call   8039eb <sys_utilities>
  8014ff:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801502:	e8 35 20 00 00       	call   80353c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801507:	83 ec 0c             	sub    $0xc,%esp
  80150a:	68 38 52 80 00       	push   $0x805238
  80150f:	e8 cc 03 00 00       	call   8018e0 <cprintf>
  801514:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151a:	85 c0                	test   %eax,%eax
  80151c:	74 18                	je     801536 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80151e:	e8 e6 24 00 00       	call   803a09 <sys_get_optimal_num_faults>
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	50                   	push   %eax
  801527:	68 60 52 80 00       	push   $0x805260
  80152c:	e8 af 03 00 00       	call   8018e0 <cprintf>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	eb 59                	jmp    80158f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801536:	a1 00 62 80 00       	mov    0x806200,%eax
  80153b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  801541:	a1 00 62 80 00       	mov    0x806200,%eax
  801546:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	52                   	push   %edx
  801550:	50                   	push   %eax
  801551:	68 84 52 80 00       	push   $0x805284
  801556:	e8 85 03 00 00       	call   8018e0 <cprintf>
  80155b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80155e:	a1 00 62 80 00       	mov    0x806200,%eax
  801563:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  801569:	a1 00 62 80 00       	mov    0x806200,%eax
  80156e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  801574:	a1 00 62 80 00       	mov    0x806200,%eax
  801579:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80157f:	51                   	push   %ecx
  801580:	52                   	push   %edx
  801581:	50                   	push   %eax
  801582:	68 ac 52 80 00       	push   $0x8052ac
  801587:	e8 54 03 00 00       	call   8018e0 <cprintf>
  80158c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80158f:	a1 00 62 80 00       	mov    0x806200,%eax
  801594:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	50                   	push   %eax
  80159e:	68 04 53 80 00       	push   $0x805304
  8015a3:	e8 38 03 00 00       	call   8018e0 <cprintf>
  8015a8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8015ab:	83 ec 0c             	sub    $0xc,%esp
  8015ae:	68 38 52 80 00       	push   $0x805238
  8015b3:	e8 28 03 00 00       	call   8018e0 <cprintf>
  8015b8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8015bb:	e8 96 1f 00 00       	call   803556 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8015c0:	e8 1f 00 00 00       	call   8015e4 <exit>
}
  8015c5:	90                   	nop
  8015c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015d4:	83 ec 0c             	sub    $0xc,%esp
  8015d7:	6a 00                	push   $0x0
  8015d9:	e8 a3 21 00 00       	call   803781 <sys_destroy_env>
  8015de:	83 c4 10             	add    $0x10,%esp
}
  8015e1:	90                   	nop
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <exit>:

void
exit(void)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015ea:	e8 f8 21 00 00       	call   8037e7 <sys_exit_env>
}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8015fb:	83 c0 04             	add    $0x4,%eax
  8015fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801601:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801606:	85 c0                	test   %eax,%eax
  801608:	74 16                	je     801620 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80160a:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  80160f:	83 ec 08             	sub    $0x8,%esp
  801612:	50                   	push   %eax
  801613:	68 7c 53 80 00       	push   $0x80537c
  801618:	e8 c3 02 00 00       	call   8018e0 <cprintf>
  80161d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801620:	a1 04 60 80 00       	mov    0x806004,%eax
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	ff 75 0c             	pushl  0xc(%ebp)
  80162b:	ff 75 08             	pushl  0x8(%ebp)
  80162e:	50                   	push   %eax
  80162f:	68 84 53 80 00       	push   $0x805384
  801634:	6a 74                	push   $0x74
  801636:	e8 d2 02 00 00       	call   80190d <cprintf_colored>
  80163b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	e8 24 02 00 00       	call   801871 <vcprintf>
  80164d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	6a 00                	push   $0x0
  801655:	68 ac 53 80 00       	push   $0x8053ac
  80165a:	e8 12 02 00 00       	call   801871 <vcprintf>
  80165f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801662:	e8 7d ff ff ff       	call   8015e4 <exit>

	// should not return here
	while (1) ;
  801667:	eb fe                	jmp    801667 <_panic+0x75>

00801669 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	53                   	push   %ebx
  80166d:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801670:	a1 00 62 80 00       	mov    0x806200,%eax
  801675:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	39 c2                	cmp    %eax,%edx
  801680:	74 14                	je     801696 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 b0 53 80 00       	push   $0x8053b0
  80168a:	6a 26                	push   $0x26
  80168c:	68 fc 53 80 00       	push   $0x8053fc
  801691:	e8 5c ff ff ff       	call   8015f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801696:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80169d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016a4:	e9 d9 00 00 00       	jmp    801782 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	75 08                	jne    8016c6 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8016be:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016c1:	e9 b9 00 00 00       	jmp    80177f <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8016c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016d4:	eb 79                	jmp    80174f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016d6:	a1 00 62 80 00       	mov    0x806200,%eax
  8016db:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8016e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	01 c0                	add    %eax,%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8016f1:	01 d8                	add    %ebx,%eax
  8016f3:	01 d0                	add    %edx,%eax
  8016f5:	01 c8                	add    %ecx,%eax
  8016f7:	8a 40 04             	mov    0x4(%eax),%al
  8016fa:	84 c0                	test   %al,%al
  8016fc:	75 4e                	jne    80174c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016fe:	a1 00 62 80 00       	mov    0x806200,%eax
  801703:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801709:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80170c:	89 d0                	mov    %edx,%eax
  80170e:	01 c0                	add    %eax,%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801719:	01 d8                	add    %ebx,%eax
  80171b:	01 d0                	add    %edx,%eax
  80171d:	01 c8                	add    %ecx,%eax
  80171f:	8b 00                	mov    (%eax),%eax
  801721:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801727:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80172c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801731:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	01 c8                	add    %ecx,%eax
  80173d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80173f:	39 c2                	cmp    %eax,%edx
  801741:	75 09                	jne    80174c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  801743:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80174a:	eb 19                	jmp    801765 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80174c:	ff 45 e8             	incl   -0x18(%ebp)
  80174f:	a1 00 62 80 00       	mov    0x806200,%eax
  801754:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80175a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	0f 87 71 ff ff ff    	ja     8016d6 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801765:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801769:	75 14                	jne    80177f <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	68 08 54 80 00       	push   $0x805408
  801773:	6a 3a                	push   $0x3a
  801775:	68 fc 53 80 00       	push   $0x8053fc
  80177a:	e8 73 fe ff ff       	call   8015f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80177f:	ff 45 f0             	incl   -0x10(%ebp)
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801788:	0f 8c 1b ff ff ff    	jl     8016a9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80178e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801795:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80179c:	eb 2e                	jmp    8017cc <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80179e:	a1 00 62 80 00       	mov    0x806200,%eax
  8017a3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8017a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017ac:	89 d0                	mov    %edx,%eax
  8017ae:	01 c0                	add    %eax,%eax
  8017b0:	01 d0                	add    %edx,%eax
  8017b2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8017b9:	01 d8                	add    %ebx,%eax
  8017bb:	01 d0                	add    %edx,%eax
  8017bd:	01 c8                	add    %ecx,%eax
  8017bf:	8a 40 04             	mov    0x4(%eax),%al
  8017c2:	3c 01                	cmp    $0x1,%al
  8017c4:	75 03                	jne    8017c9 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8017c6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017c9:	ff 45 e0             	incl   -0x20(%ebp)
  8017cc:	a1 00 62 80 00       	mov    0x806200,%eax
  8017d1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017da:	39 c2                	cmp    %eax,%edx
  8017dc:	77 c0                	ja     80179e <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017e4:	74 14                	je     8017fa <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 5c 54 80 00       	push   $0x80545c
  8017ee:	6a 44                	push   $0x44
  8017f0:	68 fc 53 80 00       	push   $0x8053fc
  8017f5:	e8 f8 fd ff ff       	call   8015f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017fa:	90                   	nop
  8017fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 d1                	mov    %dl,%cl
  801819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	8b 00                	mov    (%eax),%eax
  801825:	3d ff 00 00 00       	cmp    $0xff,%eax
  80182a:	75 30                	jne    80185c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80182c:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801832:	a0 24 62 80 00       	mov    0x806224,%al
  801837:	0f b6 c0             	movzbl %al,%eax
  80183a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183d:	8b 09                	mov    (%ecx),%ecx
  80183f:	89 cb                	mov    %ecx,%ebx
  801841:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801844:	83 c1 08             	add    $0x8,%ecx
  801847:	52                   	push   %edx
  801848:	50                   	push   %eax
  801849:	53                   	push   %ebx
  80184a:	51                   	push   %ecx
  80184b:	e8 a8 1c 00 00       	call   8034f8 <sys_cputs>
  801850:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801853:	8b 45 0c             	mov    0xc(%ebp),%eax
  801856:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	8b 40 04             	mov    0x4(%eax),%eax
  801862:	8d 50 01             	lea    0x1(%eax),%edx
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	89 50 04             	mov    %edx,0x4(%eax)
}
  80186b:	90                   	nop
  80186c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80187a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801881:	00 00 00 
	b.cnt = 0;
  801884:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80188b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80189a:	50                   	push   %eax
  80189b:	68 00 18 80 00       	push   $0x801800
  8018a0:	e8 5a 02 00 00       	call   801aff <vprintfmt>
  8018a5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8018a8:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  8018ae:	a0 24 62 80 00       	mov    0x806224,%al
  8018b3:	0f b6 c0             	movzbl %al,%eax
  8018b6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	51                   	push   %ecx
  8018bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8018c5:	83 c0 08             	add    $0x8,%eax
  8018c8:	50                   	push   %eax
  8018c9:	e8 2a 1c 00 00       	call   8034f8 <sys_cputs>
  8018ce:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8018d1:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  8018d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018e6:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  8018ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fc:	50                   	push   %eax
  8018fd:	e8 6f ff ff ff       	call   801871 <vcprintf>
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801908:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801913:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	c1 e0 08             	shl    $0x8,%eax
  801920:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  801925:	8d 45 0c             	lea    0xc(%ebp),%eax
  801928:	83 c0 04             	add    $0x4,%eax
  80192b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	ff 75 f4             	pushl  -0xc(%ebp)
  801937:	50                   	push   %eax
  801938:	e8 34 ff ff ff       	call   801871 <vcprintf>
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801943:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  80194a:	07 00 00 

	return cnt;
  80194d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801958:	e8 df 1b 00 00       	call   80353c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80195d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801960:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	ff 75 f4             	pushl  -0xc(%ebp)
  80196c:	50                   	push   %eax
  80196d:	e8 ff fe ff ff       	call   801871 <vcprintf>
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801978:	e8 d9 1b 00 00       	call   803556 <sys_unlock_cons>
	return cnt;
  80197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	53                   	push   %ebx
  801986:	83 ec 14             	sub    $0x14,%esp
  801989:	8b 45 10             	mov    0x10(%ebp),%eax
  80198c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80198f:	8b 45 14             	mov    0x14(%ebp),%eax
  801992:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801995:	8b 45 18             	mov    0x18(%ebp),%eax
  801998:	ba 00 00 00 00       	mov    $0x0,%edx
  80199d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8019a0:	77 55                	ja     8019f7 <printnum+0x75>
  8019a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8019a5:	72 05                	jb     8019ac <printnum+0x2a>
  8019a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019aa:	77 4b                	ja     8019f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8019af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8019b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8019b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ba:	52                   	push   %edx
  8019bb:	50                   	push   %eax
  8019bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c2:	e8 91 2e 00 00       	call   804858 <__udivdi3>
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	ff 75 20             	pushl  0x20(%ebp)
  8019d0:	53                   	push   %ebx
  8019d1:	ff 75 18             	pushl  0x18(%ebp)
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	e8 a1 ff ff ff       	call   801982 <printnum>
  8019e1:	83 c4 20             	add    $0x20,%esp
  8019e4:	eb 1a                	jmp    801a00 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019e6:	83 ec 08             	sub    $0x8,%esp
  8019e9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ec:	ff 75 20             	pushl  0x20(%ebp)
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	ff d0                	call   *%eax
  8019f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8019fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8019fe:	7f e6                	jg     8019e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a00:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801a03:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0e:	53                   	push   %ebx
  801a0f:	51                   	push   %ecx
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	e8 51 2f 00 00       	call   804968 <__umoddi3>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	05 d4 56 80 00       	add    $0x8056d4,%eax
  801a1f:	8a 00                	mov    (%eax),%al
  801a21:	0f be c0             	movsbl %al,%eax
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	50                   	push   %eax
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
}
  801a33:	90                   	nop
  801a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a40:	7e 1c                	jle    801a5e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	8d 50 08             	lea    0x8(%eax),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	89 10                	mov    %edx,(%eax)
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	83 e8 08             	sub    $0x8,%eax
  801a57:	8b 50 04             	mov    0x4(%eax),%edx
  801a5a:	8b 00                	mov    (%eax),%eax
  801a5c:	eb 40                	jmp    801a9e <getuint+0x65>
	else if (lflag)
  801a5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a62:	74 1e                	je     801a82 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8b 00                	mov    (%eax),%eax
  801a69:	8d 50 04             	lea    0x4(%eax),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	89 10                	mov    %edx,(%eax)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8b 00                	mov    (%eax),%eax
  801a76:	83 e8 04             	sub    $0x4,%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a80:	eb 1c                	jmp    801a9e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	8b 00                	mov    (%eax),%eax
  801a87:	8d 50 04             	lea    0x4(%eax),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	89 10                	mov    %edx,(%eax)
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	8b 00                	mov    (%eax),%eax
  801a94:	83 e8 04             	sub    $0x4,%eax
  801a97:	8b 00                	mov    (%eax),%eax
  801a99:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801aa3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801aa7:	7e 1c                	jle    801ac5 <getint+0x25>
		return va_arg(*ap, long long);
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	8b 00                	mov    (%eax),%eax
  801aae:	8d 50 08             	lea    0x8(%eax),%edx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	89 10                	mov    %edx,(%eax)
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	8b 00                	mov    (%eax),%eax
  801abb:	83 e8 08             	sub    $0x8,%eax
  801abe:	8b 50 04             	mov    0x4(%eax),%edx
  801ac1:	8b 00                	mov    (%eax),%eax
  801ac3:	eb 38                	jmp    801afd <getint+0x5d>
	else if (lflag)
  801ac5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ac9:	74 1a                	je     801ae5 <getint+0x45>
		return va_arg(*ap, long);
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	8b 00                	mov    (%eax),%eax
  801ad0:	8d 50 04             	lea    0x4(%eax),%edx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	89 10                	mov    %edx,(%eax)
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	8b 00                	mov    (%eax),%eax
  801add:	83 e8 04             	sub    $0x4,%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	99                   	cltd   
  801ae3:	eb 18                	jmp    801afd <getint+0x5d>
	else
		return va_arg(*ap, int);
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	8b 00                	mov    (%eax),%eax
  801aea:	8d 50 04             	lea    0x4(%eax),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	89 10                	mov    %edx,(%eax)
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	8b 00                	mov    (%eax),%eax
  801af7:	83 e8 04             	sub    $0x4,%eax
  801afa:	8b 00                	mov    (%eax),%eax
  801afc:	99                   	cltd   
}
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    

00801aff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	56                   	push   %esi
  801b03:	53                   	push   %ebx
  801b04:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b07:	eb 17                	jmp    801b20 <vprintfmt+0x21>
			if (ch == '\0')
  801b09:	85 db                	test   %ebx,%ebx
  801b0b:	0f 84 c1 03 00 00    	je     801ed2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	53                   	push   %ebx
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	ff d0                	call   *%eax
  801b1d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b20:	8b 45 10             	mov    0x10(%ebp),%eax
  801b23:	8d 50 01             	lea    0x1(%eax),%edx
  801b26:	89 55 10             	mov    %edx,0x10(%ebp)
  801b29:	8a 00                	mov    (%eax),%al
  801b2b:	0f b6 d8             	movzbl %al,%ebx
  801b2e:	83 fb 25             	cmp    $0x25,%ebx
  801b31:	75 d6                	jne    801b09 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801b33:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801b37:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801b3e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801b45:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801b4c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b53:	8b 45 10             	mov    0x10(%ebp),%eax
  801b56:	8d 50 01             	lea    0x1(%eax),%edx
  801b59:	89 55 10             	mov    %edx,0x10(%ebp)
  801b5c:	8a 00                	mov    (%eax),%al
  801b5e:	0f b6 d8             	movzbl %al,%ebx
  801b61:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801b64:	83 f8 5b             	cmp    $0x5b,%eax
  801b67:	0f 87 3d 03 00 00    	ja     801eaa <vprintfmt+0x3ab>
  801b6d:	8b 04 85 f8 56 80 00 	mov    0x8056f8(,%eax,4),%eax
  801b74:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b76:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b7a:	eb d7                	jmp    801b53 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b7c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b80:	eb d1                	jmp    801b53 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b8c:	89 d0                	mov    %edx,%eax
  801b8e:	c1 e0 02             	shl    $0x2,%eax
  801b91:	01 d0                	add    %edx,%eax
  801b93:	01 c0                	add    %eax,%eax
  801b95:	01 d8                	add    %ebx,%eax
  801b97:	83 e8 30             	sub    $0x30,%eax
  801b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba0:	8a 00                	mov    (%eax),%al
  801ba2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ba5:	83 fb 2f             	cmp    $0x2f,%ebx
  801ba8:	7e 3e                	jle    801be8 <vprintfmt+0xe9>
  801baa:	83 fb 39             	cmp    $0x39,%ebx
  801bad:	7f 39                	jg     801be8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801baf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801bb2:	eb d5                	jmp    801b89 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801bb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb7:	83 c0 04             	add    $0x4,%eax
  801bba:	89 45 14             	mov    %eax,0x14(%ebp)
  801bbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc0:	83 e8 04             	sub    $0x4,%eax
  801bc3:	8b 00                	mov    (%eax),%eax
  801bc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801bc8:	eb 1f                	jmp    801be9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801bca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bce:	79 83                	jns    801b53 <vprintfmt+0x54>
				width = 0;
  801bd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801bd7:	e9 77 ff ff ff       	jmp    801b53 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801bdc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801be3:	e9 6b ff ff ff       	jmp    801b53 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801be8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801be9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bed:	0f 89 60 ff ff ff    	jns    801b53 <vprintfmt+0x54>
				width = precision, precision = -1;
  801bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bf9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801c00:	e9 4e ff ff ff       	jmp    801b53 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801c05:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801c08:	e9 46 ff ff ff       	jmp    801b53 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801c0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c10:	83 c0 04             	add    $0x4,%eax
  801c13:	89 45 14             	mov    %eax,0x14(%ebp)
  801c16:	8b 45 14             	mov    0x14(%ebp),%eax
  801c19:	83 e8 04             	sub    $0x4,%eax
  801c1c:	8b 00                	mov    (%eax),%eax
  801c1e:	83 ec 08             	sub    $0x8,%esp
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	50                   	push   %eax
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	ff d0                	call   *%eax
  801c2a:	83 c4 10             	add    $0x10,%esp
			break;
  801c2d:	e9 9b 02 00 00       	jmp    801ecd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c32:	8b 45 14             	mov    0x14(%ebp),%eax
  801c35:	83 c0 04             	add    $0x4,%eax
  801c38:	89 45 14             	mov    %eax,0x14(%ebp)
  801c3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3e:	83 e8 04             	sub    $0x4,%eax
  801c41:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801c43:	85 db                	test   %ebx,%ebx
  801c45:	79 02                	jns    801c49 <vprintfmt+0x14a>
				err = -err;
  801c47:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801c49:	83 fb 64             	cmp    $0x64,%ebx
  801c4c:	7f 0b                	jg     801c59 <vprintfmt+0x15a>
  801c4e:	8b 34 9d 40 55 80 00 	mov    0x805540(,%ebx,4),%esi
  801c55:	85 f6                	test   %esi,%esi
  801c57:	75 19                	jne    801c72 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801c59:	53                   	push   %ebx
  801c5a:	68 e5 56 80 00       	push   $0x8056e5
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	ff 75 08             	pushl  0x8(%ebp)
  801c65:	e8 70 02 00 00       	call   801eda <printfmt>
  801c6a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801c6d:	e9 5b 02 00 00       	jmp    801ecd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c72:	56                   	push   %esi
  801c73:	68 ee 56 80 00       	push   $0x8056ee
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	ff 75 08             	pushl  0x8(%ebp)
  801c7e:	e8 57 02 00 00       	call   801eda <printfmt>
  801c83:	83 c4 10             	add    $0x10,%esp
			break;
  801c86:	e9 42 02 00 00       	jmp    801ecd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8e:	83 c0 04             	add    $0x4,%eax
  801c91:	89 45 14             	mov    %eax,0x14(%ebp)
  801c94:	8b 45 14             	mov    0x14(%ebp),%eax
  801c97:	83 e8 04             	sub    $0x4,%eax
  801c9a:	8b 30                	mov    (%eax),%esi
  801c9c:	85 f6                	test   %esi,%esi
  801c9e:	75 05                	jne    801ca5 <vprintfmt+0x1a6>
				p = "(null)";
  801ca0:	be f1 56 80 00       	mov    $0x8056f1,%esi
			if (width > 0 && padc != '-')
  801ca5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ca9:	7e 6d                	jle    801d18 <vprintfmt+0x219>
  801cab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801caf:	74 67                	je     801d18 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801cb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb4:	83 ec 08             	sub    $0x8,%esp
  801cb7:	50                   	push   %eax
  801cb8:	56                   	push   %esi
  801cb9:	e8 1e 03 00 00       	call   801fdc <strnlen>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801cc4:	eb 16                	jmp    801cdc <vprintfmt+0x1dd>
					putch(padc, putdat);
  801cc6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801cca:	83 ec 08             	sub    $0x8,%esp
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	50                   	push   %eax
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	ff d0                	call   *%eax
  801cd6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cd9:	ff 4d e4             	decl   -0x1c(%ebp)
  801cdc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ce0:	7f e4                	jg     801cc6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ce2:	eb 34                	jmp    801d18 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801ce4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ce8:	74 1c                	je     801d06 <vprintfmt+0x207>
  801cea:	83 fb 1f             	cmp    $0x1f,%ebx
  801ced:	7e 05                	jle    801cf4 <vprintfmt+0x1f5>
  801cef:	83 fb 7e             	cmp    $0x7e,%ebx
  801cf2:	7e 12                	jle    801d06 <vprintfmt+0x207>
					putch('?', putdat);
  801cf4:	83 ec 08             	sub    $0x8,%esp
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	6a 3f                	push   $0x3f
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	ff d0                	call   *%eax
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	eb 0f                	jmp    801d15 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801d06:	83 ec 08             	sub    $0x8,%esp
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	53                   	push   %ebx
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	ff d0                	call   *%eax
  801d12:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d15:	ff 4d e4             	decl   -0x1c(%ebp)
  801d18:	89 f0                	mov    %esi,%eax
  801d1a:	8d 70 01             	lea    0x1(%eax),%esi
  801d1d:	8a 00                	mov    (%eax),%al
  801d1f:	0f be d8             	movsbl %al,%ebx
  801d22:	85 db                	test   %ebx,%ebx
  801d24:	74 24                	je     801d4a <vprintfmt+0x24b>
  801d26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d2a:	78 b8                	js     801ce4 <vprintfmt+0x1e5>
  801d2c:	ff 4d e0             	decl   -0x20(%ebp)
  801d2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d33:	79 af                	jns    801ce4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d35:	eb 13                	jmp    801d4a <vprintfmt+0x24b>
				putch(' ', putdat);
  801d37:	83 ec 08             	sub    $0x8,%esp
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	6a 20                	push   $0x20
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	ff d0                	call   *%eax
  801d44:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d47:	ff 4d e4             	decl   -0x1c(%ebp)
  801d4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d4e:	7f e7                	jg     801d37 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801d50:	e9 78 01 00 00       	jmp    801ecd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	ff 75 e8             	pushl  -0x18(%ebp)
  801d5b:	8d 45 14             	lea    0x14(%ebp),%eax
  801d5e:	50                   	push   %eax
  801d5f:	e8 3c fd ff ff       	call   801aa0 <getint>
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d73:	85 d2                	test   %edx,%edx
  801d75:	79 23                	jns    801d9a <vprintfmt+0x29b>
				putch('-', putdat);
  801d77:	83 ec 08             	sub    $0x8,%esp
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	6a 2d                	push   $0x2d
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	ff d0                	call   *%eax
  801d84:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8d:	f7 d8                	neg    %eax
  801d8f:	83 d2 00             	adc    $0x0,%edx
  801d92:	f7 da                	neg    %edx
  801d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d9a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801da1:	e9 bc 00 00 00       	jmp    801e62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801da6:	83 ec 08             	sub    $0x8,%esp
  801da9:	ff 75 e8             	pushl  -0x18(%ebp)
  801dac:	8d 45 14             	lea    0x14(%ebp),%eax
  801daf:	50                   	push   %eax
  801db0:	e8 84 fc ff ff       	call   801a39 <getuint>
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801dbe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801dc5:	e9 98 00 00 00       	jmp    801e62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	6a 58                	push   $0x58
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	ff d0                	call   *%eax
  801dd7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801dda:	83 ec 08             	sub    $0x8,%esp
  801ddd:	ff 75 0c             	pushl  0xc(%ebp)
  801de0:	6a 58                	push   $0x58
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	ff d0                	call   *%eax
  801de7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801dea:	83 ec 08             	sub    $0x8,%esp
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	6a 58                	push   $0x58
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	ff d0                	call   *%eax
  801df7:	83 c4 10             	add    $0x10,%esp
			break;
  801dfa:	e9 ce 00 00 00       	jmp    801ecd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	6a 30                	push   $0x30
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	ff d0                	call   *%eax
  801e0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801e0f:	83 ec 08             	sub    $0x8,%esp
  801e12:	ff 75 0c             	pushl  0xc(%ebp)
  801e15:	6a 78                	push   $0x78
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	ff d0                	call   *%eax
  801e1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e22:	83 c0 04             	add    $0x4,%eax
  801e25:	89 45 14             	mov    %eax,0x14(%ebp)
  801e28:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2b:	83 e8 04             	sub    $0x4,%eax
  801e2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801e3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801e41:	eb 1f                	jmp    801e62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e43:	83 ec 08             	sub    $0x8,%esp
  801e46:	ff 75 e8             	pushl  -0x18(%ebp)
  801e49:	8d 45 14             	lea    0x14(%ebp),%eax
  801e4c:	50                   	push   %eax
  801e4d:	e8 e7 fb ff ff       	call   801a39 <getuint>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801e5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801e66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	52                   	push   %edx
  801e6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e70:	50                   	push   %eax
  801e71:	ff 75 f4             	pushl  -0xc(%ebp)
  801e74:	ff 75 f0             	pushl  -0x10(%ebp)
  801e77:	ff 75 0c             	pushl  0xc(%ebp)
  801e7a:	ff 75 08             	pushl  0x8(%ebp)
  801e7d:	e8 00 fb ff ff       	call   801982 <printnum>
  801e82:	83 c4 20             	add    $0x20,%esp
			break;
  801e85:	eb 46                	jmp    801ecd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e87:	83 ec 08             	sub    $0x8,%esp
  801e8a:	ff 75 0c             	pushl  0xc(%ebp)
  801e8d:	53                   	push   %ebx
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	ff d0                	call   *%eax
  801e93:	83 c4 10             	add    $0x10,%esp
			break;
  801e96:	eb 35                	jmp    801ecd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e98:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  801e9f:	eb 2c                	jmp    801ecd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801ea1:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  801ea8:	eb 23                	jmp    801ecd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801eaa:	83 ec 08             	sub    $0x8,%esp
  801ead:	ff 75 0c             	pushl  0xc(%ebp)
  801eb0:	6a 25                	push   $0x25
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	ff d0                	call   *%eax
  801eb7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801eba:	ff 4d 10             	decl   0x10(%ebp)
  801ebd:	eb 03                	jmp    801ec2 <vprintfmt+0x3c3>
  801ebf:	ff 4d 10             	decl   0x10(%ebp)
  801ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec5:	48                   	dec    %eax
  801ec6:	8a 00                	mov    (%eax),%al
  801ec8:	3c 25                	cmp    $0x25,%al
  801eca:	75 f3                	jne    801ebf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801ecc:	90                   	nop
		}
	}
  801ecd:	e9 35 fc ff ff       	jmp    801b07 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801ed2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ed3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed6:	5b                   	pop    %ebx
  801ed7:	5e                   	pop    %esi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801ee0:	8d 45 10             	lea    0x10(%ebp),%eax
  801ee3:	83 c0 04             	add    $0x4,%eax
  801ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eec:	ff 75 f4             	pushl  -0xc(%ebp)
  801eef:	50                   	push   %eax
  801ef0:	ff 75 0c             	pushl  0xc(%ebp)
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	e8 04 fc ff ff       	call   801aff <vprintfmt>
  801efb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801efe:	90                   	nop
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	8b 40 08             	mov    0x8(%eax),%eax
  801f0a:	8d 50 01             	lea    0x1(%eax),%edx
  801f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f10:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f16:	8b 10                	mov    (%eax),%edx
  801f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1b:	8b 40 04             	mov    0x4(%eax),%eax
  801f1e:	39 c2                	cmp    %eax,%edx
  801f20:	73 12                	jae    801f34 <sprintputch+0x33>
		*b->buf++ = ch;
  801f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f25:	8b 00                	mov    (%eax),%eax
  801f27:	8d 48 01             	lea    0x1(%eax),%ecx
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	89 0a                	mov    %ecx,(%edx)
  801f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f32:	88 10                	mov    %dl,(%eax)
}
  801f34:	90                   	nop
  801f35:	5d                   	pop    %ebp
  801f36:	c3                   	ret    

00801f37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	01 d0                	add    %edx,%eax
  801f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f5c:	74 06                	je     801f64 <vsnprintf+0x2d>
  801f5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f62:	7f 07                	jg     801f6b <vsnprintf+0x34>
		return -E_INVAL;
  801f64:	b8 03 00 00 00       	mov    $0x3,%eax
  801f69:	eb 20                	jmp    801f8b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f6b:	ff 75 14             	pushl  0x14(%ebp)
  801f6e:	ff 75 10             	pushl  0x10(%ebp)
  801f71:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f74:	50                   	push   %eax
  801f75:	68 01 1f 80 00       	push   $0x801f01
  801f7a:	e8 80 fb ff ff       	call   801aff <vprintfmt>
  801f7f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f85:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f93:	8d 45 10             	lea    0x10(%ebp),%eax
  801f96:	83 c0 04             	add    $0x4,%eax
  801f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa2:	50                   	push   %eax
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	e8 89 ff ff ff       	call   801f37 <vsnprintf>
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801fbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fc6:	eb 06                	jmp    801fce <strlen+0x15>
		n++;
  801fc8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801fcb:	ff 45 08             	incl   0x8(%ebp)
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	8a 00                	mov    (%eax),%al
  801fd3:	84 c0                	test   %al,%al
  801fd5:	75 f1                	jne    801fc8 <strlen+0xf>
		n++;
	return n;
  801fd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fe9:	eb 09                	jmp    801ff4 <strnlen+0x18>
		n++;
  801feb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fee:	ff 45 08             	incl   0x8(%ebp)
  801ff1:	ff 4d 0c             	decl   0xc(%ebp)
  801ff4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ff8:	74 09                	je     802003 <strnlen+0x27>
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	8a 00                	mov    (%eax),%al
  801fff:	84 c0                	test   %al,%al
  802001:	75 e8                	jne    801feb <strnlen+0xf>
		n++;
	return n;
  802003:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802014:	90                   	nop
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	8d 50 01             	lea    0x1(%eax),%edx
  80201b:	89 55 08             	mov    %edx,0x8(%ebp)
  80201e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802021:	8d 4a 01             	lea    0x1(%edx),%ecx
  802024:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802027:	8a 12                	mov    (%edx),%dl
  802029:	88 10                	mov    %dl,(%eax)
  80202b:	8a 00                	mov    (%eax),%al
  80202d:	84 c0                	test   %al,%al
  80202f:	75 e4                	jne    802015 <strcpy+0xd>
		/* do nothing */;
	return ret;
  802031:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802049:	eb 1f                	jmp    80206a <strncpy+0x34>
		*dst++ = *src;
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	8d 50 01             	lea    0x1(%eax),%edx
  802051:	89 55 08             	mov    %edx,0x8(%ebp)
  802054:	8b 55 0c             	mov    0xc(%ebp),%edx
  802057:	8a 12                	mov    (%edx),%dl
  802059:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80205b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205e:	8a 00                	mov    (%eax),%al
  802060:	84 c0                	test   %al,%al
  802062:	74 03                	je     802067 <strncpy+0x31>
			src++;
  802064:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802067:	ff 45 fc             	incl   -0x4(%ebp)
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802070:	72 d9                	jb     80204b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802072:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802083:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802087:	74 30                	je     8020b9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802089:	eb 16                	jmp    8020a1 <strlcpy+0x2a>
			*dst++ = *src++;
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	8d 50 01             	lea    0x1(%eax),%edx
  802091:	89 55 08             	mov    %edx,0x8(%ebp)
  802094:	8b 55 0c             	mov    0xc(%ebp),%edx
  802097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80209a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80209d:	8a 12                	mov    (%edx),%dl
  80209f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8020a1:	ff 4d 10             	decl   0x10(%ebp)
  8020a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020a8:	74 09                	je     8020b3 <strlcpy+0x3c>
  8020aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ad:	8a 00                	mov    (%eax),%al
  8020af:	84 c0                	test   %al,%al
  8020b1:	75 d8                	jne    80208b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8020b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020bf:	29 c2                	sub    %eax,%edx
  8020c1:	89 d0                	mov    %edx,%eax
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8020c8:	eb 06                	jmp    8020d0 <strcmp+0xb>
		p++, q++;
  8020ca:	ff 45 08             	incl   0x8(%ebp)
  8020cd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	8a 00                	mov    (%eax),%al
  8020d5:	84 c0                	test   %al,%al
  8020d7:	74 0e                	je     8020e7 <strcmp+0x22>
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	8a 10                	mov    (%eax),%dl
  8020de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e1:	8a 00                	mov    (%eax),%al
  8020e3:	38 c2                	cmp    %al,%dl
  8020e5:	74 e3                	je     8020ca <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	8a 00                	mov    (%eax),%al
  8020ec:	0f b6 d0             	movzbl %al,%edx
  8020ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f2:	8a 00                	mov    (%eax),%al
  8020f4:	0f b6 c0             	movzbl %al,%eax
  8020f7:	29 c2                	sub    %eax,%edx
  8020f9:	89 d0                	mov    %edx,%eax
}
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    

008020fd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802100:	eb 09                	jmp    80210b <strncmp+0xe>
		n--, p++, q++;
  802102:	ff 4d 10             	decl   0x10(%ebp)
  802105:	ff 45 08             	incl   0x8(%ebp)
  802108:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 17                	je     802128 <strncmp+0x2b>
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8a 00                	mov    (%eax),%al
  802116:	84 c0                	test   %al,%al
  802118:	74 0e                	je     802128 <strncmp+0x2b>
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8a 10                	mov    (%eax),%dl
  80211f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802122:	8a 00                	mov    (%eax),%al
  802124:	38 c2                	cmp    %al,%dl
  802126:	74 da                	je     802102 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802128:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80212c:	75 07                	jne    802135 <strncmp+0x38>
		return 0;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
  802133:	eb 14                	jmp    802149 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	8a 00                	mov    (%eax),%al
  80213a:	0f b6 d0             	movzbl %al,%edx
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	0f b6 c0             	movzbl %al,%eax
  802145:	29 c2                	sub    %eax,%edx
  802147:	89 d0                	mov    %edx,%eax
}
  802149:	5d                   	pop    %ebp
  80214a:	c3                   	ret    

0080214b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 04             	sub    $0x4,%esp
  802151:	8b 45 0c             	mov    0xc(%ebp),%eax
  802154:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802157:	eb 12                	jmp    80216b <strchr+0x20>
		if (*s == c)
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8a 00                	mov    (%eax),%al
  80215e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802161:	75 05                	jne    802168 <strchr+0x1d>
			return (char *) s;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	eb 11                	jmp    802179 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802168:	ff 45 08             	incl   0x8(%ebp)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8a 00                	mov    (%eax),%al
  802170:	84 c0                	test   %al,%al
  802172:	75 e5                	jne    802159 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	8b 45 0c             	mov    0xc(%ebp),%eax
  802184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802187:	eb 0d                	jmp    802196 <strfind+0x1b>
		if (*s == c)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	8a 00                	mov    (%eax),%al
  80218e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802191:	74 0e                	je     8021a1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802193:	ff 45 08             	incl   0x8(%ebp)
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	8a 00                	mov    (%eax),%al
  80219b:	84 c0                	test   %al,%al
  80219d:	75 ea                	jne    802189 <strfind+0xe>
  80219f:	eb 01                	jmp    8021a2 <strfind+0x27>
		if (*s == c)
			break;
  8021a1:	90                   	nop
	return (char *) s;
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8021b3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021b7:	76 63                	jbe    80221c <memset+0x75>
		uint64 data_block = c;
  8021b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bc:	99                   	cltd   
  8021bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8021c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8021cd:	c1 e0 08             	shl    $0x8,%eax
  8021d0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021d3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021dc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8021e0:	c1 e0 10             	shl    $0x10,%eax
  8021e3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021e6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8021e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ef:	89 c2                	mov    %eax,%edx
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021f9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8021fc:	eb 18                	jmp    802216 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8021fe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802201:	8d 41 08             	lea    0x8(%ecx),%eax
  802204:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220d:	89 01                	mov    %eax,(%ecx)
  80220f:	89 51 04             	mov    %edx,0x4(%ecx)
  802212:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802216:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80221a:	77 e2                	ja     8021fe <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80221c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802220:	74 23                	je     802245 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802222:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802225:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802228:	eb 0e                	jmp    802238 <memset+0x91>
			*p8++ = (uint8)c;
  80222a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80222d:	8d 50 01             	lea    0x1(%eax),%edx
  802230:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802233:	8b 55 0c             	mov    0xc(%ebp),%edx
  802236:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802238:	8b 45 10             	mov    0x10(%ebp),%eax
  80223b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80223e:	89 55 10             	mov    %edx,0x10(%ebp)
  802241:	85 c0                	test   %eax,%eax
  802243:	75 e5                	jne    80222a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802250:	8b 45 0c             	mov    0xc(%ebp),%eax
  802253:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80225c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802260:	76 24                	jbe    802286 <memcpy+0x3c>
		while(n >= 8){
  802262:	eb 1c                	jmp    802280 <memcpy+0x36>
			*d64 = *s64;
  802264:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802267:	8b 50 04             	mov    0x4(%eax),%edx
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80226f:	89 01                	mov    %eax,(%ecx)
  802271:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802274:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802278:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80227c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802280:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802284:	77 de                	ja     802264 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802286:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80228a:	74 31                	je     8022bd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80228c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80228f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802292:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802295:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802298:	eb 16                	jmp    8022b0 <memcpy+0x66>
			*d8++ = *s8++;
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	8d 50 01             	lea    0x1(%eax),%edx
  8022a0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8022a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022a9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8022ac:	8a 12                	mov    (%edx),%dl
  8022ae:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8022b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	75 dd                	jne    80229a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8022d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022da:	73 50                	jae    80232c <memmove+0x6a>
  8022dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022df:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e2:	01 d0                	add    %edx,%eax
  8022e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8022e7:	76 43                	jbe    80232c <memmove+0x6a>
		s += n;
  8022e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ec:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8022ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8022f5:	eb 10                	jmp    802307 <memmove+0x45>
			*--d = *--s;
  8022f7:	ff 4d f8             	decl   -0x8(%ebp)
  8022fa:	ff 4d fc             	decl   -0x4(%ebp)
  8022fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802300:	8a 10                	mov    (%eax),%dl
  802302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802305:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802307:	8b 45 10             	mov    0x10(%ebp),%eax
  80230a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80230d:	89 55 10             	mov    %edx,0x10(%ebp)
  802310:	85 c0                	test   %eax,%eax
  802312:	75 e3                	jne    8022f7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802314:	eb 23                	jmp    802339 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802316:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802319:	8d 50 01             	lea    0x1(%eax),%edx
  80231c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80231f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802322:	8d 4a 01             	lea    0x1(%edx),%ecx
  802325:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802328:	8a 12                	mov    (%edx),%dl
  80232a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80232c:	8b 45 10             	mov    0x10(%ebp),%eax
  80232f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802332:	89 55 10             	mov    %edx,0x10(%ebp)
  802335:	85 c0                	test   %eax,%eax
  802337:	75 dd                	jne    802316 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80234a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802350:	eb 2a                	jmp    80237c <memcmp+0x3e>
		if (*s1 != *s2)
  802352:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802355:	8a 10                	mov    (%eax),%dl
  802357:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80235a:	8a 00                	mov    (%eax),%al
  80235c:	38 c2                	cmp    %al,%dl
  80235e:	74 16                	je     802376 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802360:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802363:	8a 00                	mov    (%eax),%al
  802365:	0f b6 d0             	movzbl %al,%edx
  802368:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80236b:	8a 00                	mov    (%eax),%al
  80236d:	0f b6 c0             	movzbl %al,%eax
  802370:	29 c2                	sub    %eax,%edx
  802372:	89 d0                	mov    %edx,%eax
  802374:	eb 18                	jmp    80238e <memcmp+0x50>
		s1++, s2++;
  802376:	ff 45 fc             	incl   -0x4(%ebp)
  802379:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80237c:	8b 45 10             	mov    0x10(%ebp),%eax
  80237f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802382:	89 55 10             	mov    %edx,0x10(%ebp)
  802385:	85 c0                	test   %eax,%eax
  802387:	75 c9                	jne    802352 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802396:	8b 55 08             	mov    0x8(%ebp),%edx
  802399:	8b 45 10             	mov    0x10(%ebp),%eax
  80239c:	01 d0                	add    %edx,%eax
  80239e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8023a1:	eb 15                	jmp    8023b8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8a 00                	mov    (%eax),%al
  8023a8:	0f b6 d0             	movzbl %al,%edx
  8023ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ae:	0f b6 c0             	movzbl %al,%eax
  8023b1:	39 c2                	cmp    %eax,%edx
  8023b3:	74 0d                	je     8023c2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8023b5:	ff 45 08             	incl   0x8(%ebp)
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8023be:	72 e3                	jb     8023a3 <memfind+0x13>
  8023c0:	eb 01                	jmp    8023c3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8023c2:	90                   	nop
	return (void *) s;
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8023ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8023d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023dc:	eb 03                	jmp    8023e1 <strtol+0x19>
		s++;
  8023de:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	8a 00                	mov    (%eax),%al
  8023e6:	3c 20                	cmp    $0x20,%al
  8023e8:	74 f4                	je     8023de <strtol+0x16>
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	8a 00                	mov    (%eax),%al
  8023ef:	3c 09                	cmp    $0x9,%al
  8023f1:	74 eb                	je     8023de <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	8a 00                	mov    (%eax),%al
  8023f8:	3c 2b                	cmp    $0x2b,%al
  8023fa:	75 05                	jne    802401 <strtol+0x39>
		s++;
  8023fc:	ff 45 08             	incl   0x8(%ebp)
  8023ff:	eb 13                	jmp    802414 <strtol+0x4c>
	else if (*s == '-')
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8a 00                	mov    (%eax),%al
  802406:	3c 2d                	cmp    $0x2d,%al
  802408:	75 0a                	jne    802414 <strtol+0x4c>
		s++, neg = 1;
  80240a:	ff 45 08             	incl   0x8(%ebp)
  80240d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802414:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802418:	74 06                	je     802420 <strtol+0x58>
  80241a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80241e:	75 20                	jne    802440 <strtol+0x78>
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	8a 00                	mov    (%eax),%al
  802425:	3c 30                	cmp    $0x30,%al
  802427:	75 17                	jne    802440 <strtol+0x78>
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	40                   	inc    %eax
  80242d:	8a 00                	mov    (%eax),%al
  80242f:	3c 78                	cmp    $0x78,%al
  802431:	75 0d                	jne    802440 <strtol+0x78>
		s += 2, base = 16;
  802433:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802437:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80243e:	eb 28                	jmp    802468 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802440:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802444:	75 15                	jne    80245b <strtol+0x93>
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	8a 00                	mov    (%eax),%al
  80244b:	3c 30                	cmp    $0x30,%al
  80244d:	75 0c                	jne    80245b <strtol+0x93>
		s++, base = 8;
  80244f:	ff 45 08             	incl   0x8(%ebp)
  802452:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802459:	eb 0d                	jmp    802468 <strtol+0xa0>
	else if (base == 0)
  80245b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80245f:	75 07                	jne    802468 <strtol+0xa0>
		base = 10;
  802461:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	8a 00                	mov    (%eax),%al
  80246d:	3c 2f                	cmp    $0x2f,%al
  80246f:	7e 19                	jle    80248a <strtol+0xc2>
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	8a 00                	mov    (%eax),%al
  802476:	3c 39                	cmp    $0x39,%al
  802478:	7f 10                	jg     80248a <strtol+0xc2>
			dig = *s - '0';
  80247a:	8b 45 08             	mov    0x8(%ebp),%eax
  80247d:	8a 00                	mov    (%eax),%al
  80247f:	0f be c0             	movsbl %al,%eax
  802482:	83 e8 30             	sub    $0x30,%eax
  802485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802488:	eb 42                	jmp    8024cc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	8a 00                	mov    (%eax),%al
  80248f:	3c 60                	cmp    $0x60,%al
  802491:	7e 19                	jle    8024ac <strtol+0xe4>
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	8a 00                	mov    (%eax),%al
  802498:	3c 7a                	cmp    $0x7a,%al
  80249a:	7f 10                	jg     8024ac <strtol+0xe4>
			dig = *s - 'a' + 10;
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	8a 00                	mov    (%eax),%al
  8024a1:	0f be c0             	movsbl %al,%eax
  8024a4:	83 e8 57             	sub    $0x57,%eax
  8024a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024aa:	eb 20                	jmp    8024cc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	8a 00                	mov    (%eax),%al
  8024b1:	3c 40                	cmp    $0x40,%al
  8024b3:	7e 39                	jle    8024ee <strtol+0x126>
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8a 00                	mov    (%eax),%al
  8024ba:	3c 5a                	cmp    $0x5a,%al
  8024bc:	7f 30                	jg     8024ee <strtol+0x126>
			dig = *s - 'A' + 10;
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	8a 00                	mov    (%eax),%al
  8024c3:	0f be c0             	movsbl %al,%eax
  8024c6:	83 e8 37             	sub    $0x37,%eax
  8024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8024d2:	7d 19                	jge    8024ed <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8024d4:	ff 45 08             	incl   0x8(%ebp)
  8024d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024da:	0f af 45 10          	imul   0x10(%ebp),%eax
  8024de:	89 c2                	mov    %eax,%edx
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	01 d0                	add    %edx,%eax
  8024e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8024e8:	e9 7b ff ff ff       	jmp    802468 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8024ed:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8024ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024f2:	74 08                	je     8024fc <strtol+0x134>
		*endptr = (char *) s;
  8024f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8024fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802500:	74 07                	je     802509 <strtol+0x141>
  802502:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802505:	f7 d8                	neg    %eax
  802507:	eb 03                	jmp    80250c <strtol+0x144>
  802509:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <ltostr>:

void
ltostr(long value, char *str)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802514:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80251b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802522:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802526:	79 13                	jns    80253b <ltostr+0x2d>
	{
		neg = 1;
  802528:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80252f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802532:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802535:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802538:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802543:	99                   	cltd   
  802544:	f7 f9                	idiv   %ecx
  802546:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802549:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80254c:	8d 50 01             	lea    0x1(%eax),%edx
  80254f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802552:	89 c2                	mov    %eax,%edx
  802554:	8b 45 0c             	mov    0xc(%ebp),%eax
  802557:	01 d0                	add    %edx,%eax
  802559:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80255c:	83 c2 30             	add    $0x30,%edx
  80255f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802561:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802564:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802569:	f7 e9                	imul   %ecx
  80256b:	c1 fa 02             	sar    $0x2,%edx
  80256e:	89 c8                	mov    %ecx,%eax
  802570:	c1 f8 1f             	sar    $0x1f,%eax
  802573:	29 c2                	sub    %eax,%edx
  802575:	89 d0                	mov    %edx,%eax
  802577:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80257a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80257e:	75 bb                	jne    80253b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802587:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80258a:	48                   	dec    %eax
  80258b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80258e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802592:	74 3d                	je     8025d1 <ltostr+0xc3>
		start = 1 ;
  802594:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80259b:	eb 34                	jmp    8025d1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80259d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a3:	01 d0                	add    %edx,%eax
  8025a5:	8a 00                	mov    (%eax),%al
  8025a7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8025aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b0:	01 c2                	add    %eax,%edx
  8025b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b8:	01 c8                	add    %ecx,%eax
  8025ba:	8a 00                	mov    (%eax),%al
  8025bc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8025be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c4:	01 c2                	add    %eax,%edx
  8025c6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8025c9:	88 02                	mov    %al,(%edx)
		start++ ;
  8025cb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8025ce:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025d7:	7c c4                	jl     80259d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8025d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8025dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025df:	01 d0                	add    %edx,%eax
  8025e1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8025e4:	90                   	nop
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8025ed:	ff 75 08             	pushl  0x8(%ebp)
  8025f0:	e8 c4 f9 ff ff       	call   801fb9 <strlen>
  8025f5:	83 c4 04             	add    $0x4,%esp
  8025f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8025fb:	ff 75 0c             	pushl  0xc(%ebp)
  8025fe:	e8 b6 f9 ff ff       	call   801fb9 <strlen>
  802603:	83 c4 04             	add    $0x4,%esp
  802606:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802610:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802617:	eb 17                	jmp    802630 <strcconcat+0x49>
		final[s] = str1[s] ;
  802619:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80261c:	8b 45 10             	mov    0x10(%ebp),%eax
  80261f:	01 c2                	add    %eax,%edx
  802621:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	01 c8                	add    %ecx,%eax
  802629:	8a 00                	mov    (%eax),%al
  80262b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80262d:	ff 45 fc             	incl   -0x4(%ebp)
  802630:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802633:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802636:	7c e1                	jl     802619 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802638:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80263f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802646:	eb 1f                	jmp    802667 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802648:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80264b:	8d 50 01             	lea    0x1(%eax),%edx
  80264e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802651:	89 c2                	mov    %eax,%edx
  802653:	8b 45 10             	mov    0x10(%ebp),%eax
  802656:	01 c2                	add    %eax,%edx
  802658:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80265b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265e:	01 c8                	add    %ecx,%eax
  802660:	8a 00                	mov    (%eax),%al
  802662:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802664:	ff 45 f8             	incl   -0x8(%ebp)
  802667:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80266a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80266d:	7c d9                	jl     802648 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80266f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802672:	8b 45 10             	mov    0x10(%ebp),%eax
  802675:	01 d0                	add    %edx,%eax
  802677:	c6 00 00             	movb   $0x0,(%eax)
}
  80267a:	90                   	nop
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802680:	8b 45 14             	mov    0x14(%ebp),%eax
  802683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802689:	8b 45 14             	mov    0x14(%ebp),%eax
  80268c:	8b 00                	mov    (%eax),%eax
  80268e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802695:	8b 45 10             	mov    0x10(%ebp),%eax
  802698:	01 d0                	add    %edx,%eax
  80269a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8026a0:	eb 0c                	jmp    8026ae <strsplit+0x31>
			*string++ = 0;
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	8d 50 01             	lea    0x1(%eax),%edx
  8026a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8026ab:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	8a 00                	mov    (%eax),%al
  8026b3:	84 c0                	test   %al,%al
  8026b5:	74 18                	je     8026cf <strsplit+0x52>
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	8a 00                	mov    (%eax),%al
  8026bc:	0f be c0             	movsbl %al,%eax
  8026bf:	50                   	push   %eax
  8026c0:	ff 75 0c             	pushl  0xc(%ebp)
  8026c3:	e8 83 fa ff ff       	call   80214b <strchr>
  8026c8:	83 c4 08             	add    $0x8,%esp
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 d3                	jne    8026a2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	8a 00                	mov    (%eax),%al
  8026d4:	84 c0                	test   %al,%al
  8026d6:	74 5a                	je     802732 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8026d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	83 f8 0f             	cmp    $0xf,%eax
  8026e0:	75 07                	jne    8026e9 <strsplit+0x6c>
		{
			return 0;
  8026e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e7:	eb 66                	jmp    80274f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8026e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8026f1:	8b 55 14             	mov    0x14(%ebp),%edx
  8026f4:	89 0a                	mov    %ecx,(%edx)
  8026f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802700:	01 c2                	add    %eax,%edx
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802707:	eb 03                	jmp    80270c <strsplit+0x8f>
			string++;
  802709:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	8a 00                	mov    (%eax),%al
  802711:	84 c0                	test   %al,%al
  802713:	74 8b                	je     8026a0 <strsplit+0x23>
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	8a 00                	mov    (%eax),%al
  80271a:	0f be c0             	movsbl %al,%eax
  80271d:	50                   	push   %eax
  80271e:	ff 75 0c             	pushl  0xc(%ebp)
  802721:	e8 25 fa ff ff       	call   80214b <strchr>
  802726:	83 c4 08             	add    $0x8,%esp
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 dc                	je     802709 <strsplit+0x8c>
			string++;
	}
  80272d:	e9 6e ff ff ff       	jmp    8026a0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802732:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802733:	8b 45 14             	mov    0x14(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80273f:	8b 45 10             	mov    0x10(%ebp),%eax
  802742:	01 d0                	add    %edx,%eax
  802744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80274a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80274f:	c9                   	leave  
  802750:	c3                   	ret    

00802751 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802751:	55                   	push   %ebp
  802752:	89 e5                	mov    %esp,%ebp
  802754:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802757:	8b 45 08             	mov    0x8(%ebp),%eax
  80275a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80275d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802764:	eb 4a                	jmp    8027b0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802766:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	01 c2                	add    %eax,%edx
  80276e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802771:	8b 45 0c             	mov    0xc(%ebp),%eax
  802774:	01 c8                	add    %ecx,%eax
  802776:	8a 00                	mov    (%eax),%al
  802778:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80277a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80277d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802780:	01 d0                	add    %edx,%eax
  802782:	8a 00                	mov    (%eax),%al
  802784:	3c 40                	cmp    $0x40,%al
  802786:	7e 25                	jle    8027ad <str2lower+0x5c>
  802788:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80278b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278e:	01 d0                	add    %edx,%eax
  802790:	8a 00                	mov    (%eax),%al
  802792:	3c 5a                	cmp    $0x5a,%al
  802794:	7f 17                	jg     8027ad <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802796:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	01 d0                	add    %edx,%eax
  80279e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8027a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a4:	01 ca                	add    %ecx,%edx
  8027a6:	8a 12                	mov    (%edx),%dl
  8027a8:	83 c2 20             	add    $0x20,%edx
  8027ab:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8027ad:	ff 45 fc             	incl   -0x4(%ebp)
  8027b0:	ff 75 0c             	pushl  0xc(%ebp)
  8027b3:	e8 01 f8 ff ff       	call   801fb9 <strlen>
  8027b8:	83 c4 04             	add    $0x4,%esp
  8027bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8027be:	7f a6                	jg     802766 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8027c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8027cb:	83 ec 0c             	sub    $0xc,%esp
  8027ce:	6a 10                	push   $0x10
  8027d0:	e8 b2 15 00 00       	call   803d87 <alloc_block>
  8027d5:	83 c4 10             	add    $0x10,%esp
  8027d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8027db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027df:	75 14                	jne    8027f5 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 68 58 80 00       	push   $0x805868
  8027e9:	6a 14                	push   $0x14
  8027eb:	68 91 58 80 00       	push   $0x805891
  8027f0:	e8 fd ed ff ff       	call   8015f2 <_panic>

	node->start = start;
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fb:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	8b 55 0c             	mov    0xc(%ebp),%edx
  802803:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80280d:	a1 04 62 80 00       	mov    0x806204,%eax
  802812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802815:	eb 18                	jmp    80282f <insert_page_alloc+0x6a>
		if (start < it->start)
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281f:	77 37                	ja     802858 <insert_page_alloc+0x93>
			break;
		prev = it;
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  802827:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80282c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802833:	74 08                	je     80283d <insert_page_alloc+0x78>
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 08             	mov    0x8(%eax),%eax
  80283b:	eb 05                	jmp    802842 <insert_page_alloc+0x7d>
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
  802842:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802847:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80284c:	85 c0                	test   %eax,%eax
  80284e:	75 c7                	jne    802817 <insert_page_alloc+0x52>
  802850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802854:	75 c1                	jne    802817 <insert_page_alloc+0x52>
  802856:	eb 01                	jmp    802859 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  802858:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  802859:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80285d:	75 64                	jne    8028c3 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80285f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802863:	75 14                	jne    802879 <insert_page_alloc+0xb4>
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	68 a0 58 80 00       	push   $0x8058a0
  80286d:	6a 21                	push   $0x21
  80286f:	68 91 58 80 00       	push   $0x805891
  802874:	e8 79 ed ff ff       	call   8015f2 <_panic>
  802879:	8b 15 04 62 80 00    	mov    0x806204,%edx
  80287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802882:	89 50 08             	mov    %edx,0x8(%eax)
  802885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802888:	8b 40 08             	mov    0x8(%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 0d                	je     80289c <insert_page_alloc+0xd7>
  80288f:	a1 04 62 80 00       	mov    0x806204,%eax
  802894:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802897:	89 50 0c             	mov    %edx,0xc(%eax)
  80289a:	eb 08                	jmp    8028a4 <insert_page_alloc+0xdf>
  80289c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289f:	a3 08 62 80 00       	mov    %eax,0x806208
  8028a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a7:	a3 04 62 80 00       	mov    %eax,0x806204
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028b6:	a1 10 62 80 00       	mov    0x806210,%eax
  8028bb:	40                   	inc    %eax
  8028bc:	a3 10 62 80 00       	mov    %eax,0x806210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8028c1:	eb 71                	jmp    802934 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8028c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c7:	74 06                	je     8028cf <insert_page_alloc+0x10a>
  8028c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028cd:	75 14                	jne    8028e3 <insert_page_alloc+0x11e>
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	68 c4 58 80 00       	push   $0x8058c4
  8028d7:	6a 23                	push   $0x23
  8028d9:	68 91 58 80 00       	push   $0x805891
  8028de:	e8 0f ed ff ff       	call   8015f2 <_panic>
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 50 08             	mov    0x8(%eax),%edx
  8028e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ec:	89 50 08             	mov    %edx,0x8(%eax)
  8028ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0c                	je     802905 <insert_page_alloc+0x140>
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802902:	89 50 0c             	mov    %edx,0xc(%eax)
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80290b:	89 50 08             	mov    %edx,0x8(%eax)
  80290e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802911:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802914:	89 50 0c             	mov    %edx,0xc(%eax)
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	8b 40 08             	mov    0x8(%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	75 08                	jne    802929 <insert_page_alloc+0x164>
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	a3 08 62 80 00       	mov    %eax,0x806208
  802929:	a1 10 62 80 00       	mov    0x806210,%eax
  80292e:	40                   	inc    %eax
  80292f:	a3 10 62 80 00       	mov    %eax,0x806210
}
  802934:	90                   	nop
  802935:	c9                   	leave  
  802936:	c3                   	ret    

00802937 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  802937:	55                   	push   %ebp
  802938:	89 e5                	mov    %esp,%ebp
  80293a:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  80293d:	a1 04 62 80 00       	mov    0x806204,%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	75 0c                	jne    802952 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  802946:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80294b:	a3 50 e2 81 00       	mov    %eax,0x81e250
		return;
  802950:	eb 67                	jmp    8029b9 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  802952:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802957:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80295a:	a1 04 62 80 00       	mov    0x806204,%eax
  80295f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802962:	eb 26                	jmp    80298a <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  802964:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802967:	8b 10                	mov    (%eax),%edx
  802969:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80296c:	8b 40 04             	mov    0x4(%eax),%eax
  80296f:	01 d0                	add    %edx,%eax
  802971:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80297a:	76 06                	jbe    802982 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802982:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802987:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80298a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80298e:	74 08                	je     802998 <recompute_page_alloc_break+0x61>
  802990:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802993:	8b 40 08             	mov    0x8(%eax),%eax
  802996:	eb 05                	jmp    80299d <recompute_page_alloc_break+0x66>
  802998:	b8 00 00 00 00       	mov    $0x0,%eax
  80299d:	a3 0c 62 80 00       	mov    %eax,0x80620c
  8029a2:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	75 b9                	jne    802964 <recompute_page_alloc_break+0x2d>
  8029ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8029af:	75 b3                	jne    802964 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8029b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029b4:	a3 50 e2 81 00       	mov    %eax,0x81e250
}
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
  8029be:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8029c1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8029c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ce:	01 d0                	add    %edx,%eax
  8029d0:	48                   	dec    %eax
  8029d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029dc:	f7 75 d8             	divl   -0x28(%ebp)
  8029df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029e2:	29 d0                	sub    %edx,%eax
  8029e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8029e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8029eb:	75 0a                	jne    8029f7 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	e9 7e 01 00 00       	jmp    802b75 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8029f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8029fe:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802a02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  802a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  802a10:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802a18:	a1 04 62 80 00       	mov    0x806204,%eax
  802a1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802a20:	eb 69                	jmp    802a8b <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a2a:	76 47                	jbe    802a73 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  802a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  802a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a3a:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  802a3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a40:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a43:	72 2e                	jb     802a73 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  802a45:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802a49:	75 14                	jne    802a5f <alloc_pages_custom_fit+0xa4>
  802a4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a4e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a51:	75 0c                	jne    802a5f <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  802a53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  802a59:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802a5d:	eb 14                	jmp    802a73 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802a5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a62:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a65:	76 0c                	jbe    802a73 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802a67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  802a6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a70:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a76:	8b 10                	mov    (%eax),%edx
  802a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	01 d0                	add    %edx,%eax
  802a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802a83:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802a8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a8f:	74 08                	je     802a99 <alloc_pages_custom_fit+0xde>
  802a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a94:	8b 40 08             	mov    0x8(%eax),%eax
  802a97:	eb 05                	jmp    802a9e <alloc_pages_custom_fit+0xe3>
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9e:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802aa3:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	0f 85 72 ff ff ff    	jne    802a22 <alloc_pages_custom_fit+0x67>
  802ab0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ab4:	0f 85 68 ff ff ff    	jne    802a22 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802aba:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802abf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ac2:	76 47                	jbe    802b0b <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802ac4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802aca:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802acf:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ad2:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802ad5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ad8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802adb:	72 2e                	jb     802b0b <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802add:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802ae1:	75 14                	jne    802af7 <alloc_pages_custom_fit+0x13c>
  802ae3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ae6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802ae9:	75 0c                	jne    802af7 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802aeb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802af1:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802af5:	eb 14                	jmp    802b0b <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802af7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802afa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802afd:	76 0c                	jbe    802b0b <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802aff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b02:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802b05:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b08:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802b0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802b12:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802b16:	74 08                	je     802b20 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802b1e:	eb 40                	jmp    802b60 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802b20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b24:	74 08                	je     802b2e <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b29:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802b2c:	eb 32                	jmp    802b60 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802b2e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802b33:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802b36:	89 c2                	mov    %eax,%edx
  802b38:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802b3d:	39 c2                	cmp    %eax,%edx
  802b3f:	73 07                	jae    802b48 <alloc_pages_custom_fit+0x18d>
			return NULL;
  802b41:	b8 00 00 00 00       	mov    $0x0,%eax
  802b46:	eb 2d                	jmp    802b75 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802b48:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802b4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802b50:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802b56:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b59:	01 d0                	add    %edx,%eax
  802b5b:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}


	insert_page_alloc((uint32)result, required_size);
  802b60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b63:	83 ec 08             	sub    $0x8,%esp
  802b66:	ff 75 d0             	pushl  -0x30(%ebp)
  802b69:	50                   	push   %eax
  802b6a:	e8 56 fc ff ff       	call   8027c5 <insert_page_alloc>
  802b6f:	83 c4 10             	add    $0x10,%esp

	return result;
  802b72:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802b75:	c9                   	leave  
  802b76:	c3                   	ret    

00802b77 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802b77:	55                   	push   %ebp
  802b78:	89 e5                	mov    %esp,%ebp
  802b7a:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b83:	a1 04 62 80 00       	mov    0x806204,%eax
  802b88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b8b:	eb 1a                	jmp    802ba7 <find_allocated_size+0x30>
		if (it->start == va)
  802b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802b95:	75 08                	jne    802b9f <find_allocated_size+0x28>
			return it->size;
  802b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	eb 34                	jmp    802bd3 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b9f:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ba7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bab:	74 08                	je     802bb5 <find_allocated_size+0x3e>
  802bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	eb 05                	jmp    802bba <find_allocated_size+0x43>
  802bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bba:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802bbf:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	75 c5                	jne    802b8d <find_allocated_size+0x16>
  802bc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bcc:	75 bf                	jne    802b8d <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd3:	c9                   	leave  
  802bd4:	c3                   	ret    

00802bd5 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802bd5:	55                   	push   %ebp
  802bd6:	89 e5                	mov    %esp,%ebp
  802bd8:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802be1:	a1 04 62 80 00       	mov    0x806204,%eax
  802be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be9:	e9 e1 01 00 00       	jmp    802dcf <free_pages+0x1fa>
		if (it->start == va) {
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bf6:	0f 85 cb 01 00 00    	jne    802dc7 <free_pages+0x1f2>

			uint32 start = it->start;
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c10:	f7 d0                	not    %eax
  802c12:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c15:	73 1d                	jae    802c34 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802c17:	83 ec 0c             	sub    $0xc,%esp
  802c1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c1d:	ff 75 e8             	pushl  -0x18(%ebp)
  802c20:	68 f8 58 80 00       	push   $0x8058f8
  802c25:	68 a5 00 00 00       	push   $0xa5
  802c2a:	68 91 58 80 00       	push   $0x805891
  802c2f:	e8 be e9 ff ff       	call   8015f2 <_panic>
			}

			uint32 start_end = start + size;
  802c34:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3a:	01 d0                	add    %edx,%eax
  802c3c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	79 19                	jns    802c5f <free_pages+0x8a>
  802c46:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802c4d:	77 10                	ja     802c5f <free_pages+0x8a>
  802c4f:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802c56:	77 07                	ja     802c5f <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	78 2c                	js     802c8b <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c62:	83 ec 0c             	sub    $0xc,%esp
  802c65:	68 00 00 00 a0       	push   $0xa0000000
  802c6a:	ff 75 e0             	pushl  -0x20(%ebp)
  802c6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c70:	ff 75 e8             	pushl  -0x18(%ebp)
  802c73:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c76:	50                   	push   %eax
  802c77:	68 3c 59 80 00       	push   $0x80593c
  802c7c:	68 ad 00 00 00       	push   $0xad
  802c81:	68 91 58 80 00       	push   $0x805891
  802c86:	e8 67 e9 ff ff       	call   8015f2 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c91:	e9 88 00 00 00       	jmp    802d1e <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802c96:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802c9d:	76 17                	jbe    802cb6 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802c9f:	ff 75 f0             	pushl  -0x10(%ebp)
  802ca2:	68 a0 59 80 00       	push   $0x8059a0
  802ca7:	68 b4 00 00 00       	push   $0xb4
  802cac:	68 91 58 80 00       	push   $0x805891
  802cb1:	e8 3c e9 ff ff       	call   8015f2 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb9:	05 00 10 00 00       	add    $0x1000,%eax
  802cbe:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	79 2e                	jns    802cf6 <free_pages+0x121>
  802cc8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802ccf:	77 25                	ja     802cf6 <free_pages+0x121>
  802cd1:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802cd8:	77 1c                	ja     802cf6 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802cda:	83 ec 08             	sub    $0x8,%esp
  802cdd:	68 00 10 00 00       	push   $0x1000
  802ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  802ce5:	e8 38 0d 00 00       	call   803a22 <sys_free_user_mem>
  802cea:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802ced:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802cf4:	eb 28                	jmp    802d1e <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	68 00 00 00 a0       	push   $0xa0000000
  802cfe:	ff 75 dc             	pushl  -0x24(%ebp)
  802d01:	68 00 10 00 00       	push   $0x1000
  802d06:	ff 75 f0             	pushl  -0x10(%ebp)
  802d09:	50                   	push   %eax
  802d0a:	68 e0 59 80 00       	push   $0x8059e0
  802d0f:	68 bd 00 00 00       	push   $0xbd
  802d14:	68 91 58 80 00       	push   $0x805891
  802d19:	e8 d4 e8 ff ff       	call   8015f2 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d21:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d24:	0f 82 6c ff ff ff    	jb     802c96 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802d2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2e:	75 17                	jne    802d47 <free_pages+0x172>
  802d30:	83 ec 04             	sub    $0x4,%esp
  802d33:	68 42 5a 80 00       	push   $0x805a42
  802d38:	68 c1 00 00 00       	push   $0xc1
  802d3d:	68 91 58 80 00       	push   $0x805891
  802d42:	e8 ab e8 ff ff       	call   8015f2 <_panic>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 08             	mov    0x8(%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	74 11                	je     802d62 <free_pages+0x18d>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5a:	8b 52 0c             	mov    0xc(%edx),%edx
  802d5d:	89 50 0c             	mov    %edx,0xc(%eax)
  802d60:	eb 0b                	jmp    802d6d <free_pages+0x198>
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 40 0c             	mov    0xc(%eax),%eax
  802d68:	a3 08 62 80 00       	mov    %eax,0x806208
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 0c             	mov    0xc(%eax),%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 11                	je     802d88 <free_pages+0x1b3>
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d80:	8b 52 08             	mov    0x8(%edx),%edx
  802d83:	89 50 08             	mov    %edx,0x8(%eax)
  802d86:	eb 0b                	jmp    802d93 <free_pages+0x1be>
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 40 08             	mov    0x8(%eax),%eax
  802d8e:	a3 04 62 80 00       	mov    %eax,0x806204
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802da7:	a1 10 62 80 00       	mov    0x806210,%eax
  802dac:	48                   	dec    %eax
  802dad:	a3 10 62 80 00       	mov    %eax,0x806210
			free_block(it);
  802db2:	83 ec 0c             	sub    $0xc,%esp
  802db5:	ff 75 f4             	pushl  -0xc(%ebp)
  802db8:	e8 24 15 00 00       	call   8042e1 <free_block>
  802dbd:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802dc0:	e8 72 fb ff ff       	call   802937 <recompute_page_alloc_break>

			return;
  802dc5:	eb 37                	jmp    802dfe <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802dc7:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd3:	74 08                	je     802ddd <free_pages+0x208>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 40 08             	mov    0x8(%eax),%eax
  802ddb:	eb 05                	jmp    802de2 <free_pages+0x20d>
  802ddd:	b8 00 00 00 00       	mov    $0x0,%eax
  802de2:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802de7:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	0f 85 fa fd ff ff    	jne    802bee <free_pages+0x19>
  802df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df8:	0f 85 f0 fd ff ff    	jne    802bee <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802dfe:	c9                   	leave  
  802dff:	c3                   	ret    

00802e00 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e08:	5d                   	pop    %ebp
  802e09:	c3                   	ret    

00802e0a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802e0a:	55                   	push   %ebp
  802e0b:	89 e5                	mov    %esp,%ebp
  802e0d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802e10:	a1 08 60 80 00       	mov    0x806008,%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	74 60                	je     802e79 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802e19:	83 ec 08             	sub    $0x8,%esp
  802e1c:	68 00 00 00 82       	push   $0x82000000
  802e21:	68 00 00 00 80       	push   $0x80000000
  802e26:	e8 0d 0d 00 00       	call   803b38 <initialize_dynamic_allocator>
  802e2b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802e2e:	e8 f3 0a 00 00       	call   803926 <sys_get_uheap_strategy>
  802e33:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802e38:	a1 20 62 80 00       	mov    0x806220,%eax
  802e3d:	05 00 10 00 00       	add    $0x1000,%eax
  802e42:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802e47:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802e4c:	a3 50 e2 81 00       	mov    %eax,0x81e250

		LIST_INIT(&page_alloc_list);
  802e51:	c7 05 04 62 80 00 00 	movl   $0x0,0x806204
  802e58:	00 00 00 
  802e5b:	c7 05 08 62 80 00 00 	movl   $0x0,0x806208
  802e62:	00 00 00 
  802e65:	c7 05 10 62 80 00 00 	movl   $0x0,0x806210
  802e6c:	00 00 00 

		__firstTimeFlag = 0;
  802e6f:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802e76:	00 00 00 
	}
}
  802e79:	90                   	nop
  802e7a:	c9                   	leave  
  802e7b:	c3                   	ret    

00802e7c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802e7c:	55                   	push   %ebp
  802e7d:	89 e5                	mov    %esp,%ebp
  802e7f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e90:	83 ec 08             	sub    $0x8,%esp
  802e93:	68 06 04 00 00       	push   $0x406
  802e98:	50                   	push   %eax
  802e99:	e8 d2 06 00 00       	call   803570 <__sys_allocate_page>
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802ea4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea8:	79 17                	jns    802ec1 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	68 60 5a 80 00       	push   $0x805a60
  802eb2:	68 ea 00 00 00       	push   $0xea
  802eb7:	68 91 58 80 00       	push   $0x805891
  802ebc:	e8 31 e7 ff ff       	call   8015f2 <_panic>
	return 0;
  802ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ec6:	c9                   	leave  
  802ec7:	c3                   	ret    

00802ec8 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802ec8:	55                   	push   %ebp
  802ec9:	89 e5                	mov    %esp,%ebp
  802ecb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802edc:	83 ec 0c             	sub    $0xc,%esp
  802edf:	50                   	push   %eax
  802ee0:	e8 d2 06 00 00       	call   8035b7 <__sys_unmap_frame>
  802ee5:	83 c4 10             	add    $0x10,%esp
  802ee8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802eeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eef:	79 17                	jns    802f08 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802ef1:	83 ec 04             	sub    $0x4,%esp
  802ef4:	68 9c 5a 80 00       	push   $0x805a9c
  802ef9:	68 f5 00 00 00       	push   $0xf5
  802efe:	68 91 58 80 00       	push   $0x805891
  802f03:	e8 ea e6 ff ff       	call   8015f2 <_panic>
}
  802f08:	90                   	nop
  802f09:	c9                   	leave  
  802f0a:	c3                   	ret    

00802f0b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802f0b:	55                   	push   %ebp
  802f0c:	89 e5                	mov    %esp,%ebp
  802f0e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f11:	e8 f4 fe ff ff       	call   802e0a <uheap_init>
	if (size == 0) return NULL ;
  802f16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1a:	75 0a                	jne    802f26 <malloc+0x1b>
  802f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f21:	e9 67 01 00 00       	jmp    80308d <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802f2d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802f34:	77 16                	ja     802f4c <malloc+0x41>
		result = alloc_block(size);
  802f36:	83 ec 0c             	sub    $0xc,%esp
  802f39:	ff 75 08             	pushl  0x8(%ebp)
  802f3c:	e8 46 0e 00 00       	call   803d87 <alloc_block>
  802f41:	83 c4 10             	add    $0x10,%esp
  802f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f47:	e9 3e 01 00 00       	jmp    80308a <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802f4c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802f53:	8b 55 08             	mov    0x8(%ebp),%edx
  802f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f59:	01 d0                	add    %edx,%eax
  802f5b:	48                   	dec    %eax
  802f5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f62:	ba 00 00 00 00       	mov    $0x0,%edx
  802f67:	f7 75 f0             	divl   -0x10(%ebp)
  802f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6d:	29 d0                	sub    %edx,%eax
  802f6f:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802f72:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	75 0a                	jne    802f85 <malloc+0x7a>
			return NULL;
  802f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f80:	e9 08 01 00 00       	jmp    80308d <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802f85:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	74 0f                	je     802f9d <malloc+0x92>
  802f8e:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802f94:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802f99:	39 c2                	cmp    %eax,%edx
  802f9b:	73 0a                	jae    802fa7 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802f9d:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802fa2:	a3 50 e2 81 00       	mov    %eax,0x81e250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802fa7:	a1 44 e2 81 00       	mov    0x81e244,%eax
  802fac:	83 f8 05             	cmp    $0x5,%eax
  802faf:	75 11                	jne    802fc2 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802fb1:	83 ec 0c             	sub    $0xc,%esp
  802fb4:	ff 75 e8             	pushl  -0x18(%ebp)
  802fb7:	e8 ff f9 ff ff       	call   8029bb <alloc_pages_custom_fit>
  802fbc:	83 c4 10             	add    $0x10,%esp
  802fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc6:	0f 84 be 00 00 00    	je     80308a <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802fd2:	83 ec 0c             	sub    $0xc,%esp
  802fd5:	ff 75 f4             	pushl  -0xc(%ebp)
  802fd8:	e8 9a fb ff ff       	call   802b77 <find_allocated_size>
  802fdd:	83 c4 10             	add    $0x10,%esp
  802fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802fe3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fe7:	75 17                	jne    803000 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  802fec:	68 dc 5a 80 00       	push   $0x805adc
  802ff1:	68 24 01 00 00       	push   $0x124
  802ff6:	68 91 58 80 00       	push   $0x805891
  802ffb:	e8 f2 e5 ff ff       	call   8015f2 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  803000:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803003:	f7 d0                	not    %eax
  803005:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803008:	73 1d                	jae    803027 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  80300a:	83 ec 0c             	sub    $0xc,%esp
  80300d:	ff 75 e0             	pushl  -0x20(%ebp)
  803010:	ff 75 e4             	pushl  -0x1c(%ebp)
  803013:	68 24 5b 80 00       	push   $0x805b24
  803018:	68 29 01 00 00       	push   $0x129
  80301d:	68 91 58 80 00       	push   $0x805891
  803022:	e8 cb e5 ff ff       	call   8015f2 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  803027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80302a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302d:	01 d0                	add    %edx,%eax
  80302f:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  803032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	79 2c                	jns    803065 <malloc+0x15a>
  803039:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  803040:	77 23                	ja     803065 <malloc+0x15a>
  803042:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  803049:	77 1a                	ja     803065 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80304b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	79 13                	jns    803065 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  803052:	83 ec 08             	sub    $0x8,%esp
  803055:	ff 75 e0             	pushl  -0x20(%ebp)
  803058:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305b:	e8 de 09 00 00       	call   803a3e <sys_allocate_user_mem>
  803060:	83 c4 10             	add    $0x10,%esp
  803063:	eb 25                	jmp    80308a <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  803065:	68 00 00 00 a0       	push   $0xa0000000
  80306a:	ff 75 dc             	pushl  -0x24(%ebp)
  80306d:	ff 75 e0             	pushl  -0x20(%ebp)
  803070:	ff 75 e4             	pushl  -0x1c(%ebp)
  803073:	ff 75 f4             	pushl  -0xc(%ebp)
  803076:	68 60 5b 80 00       	push   $0x805b60
  80307b:	68 33 01 00 00       	push   $0x133
  803080:	68 91 58 80 00       	push   $0x805891
  803085:	e8 68 e5 ff ff       	call   8015f2 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  80308d:	c9                   	leave  
  80308e:	c3                   	ret    

0080308f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80308f:	55                   	push   %ebp
  803090:	89 e5                	mov    %esp,%ebp
  803092:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803095:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803099:	0f 84 26 01 00 00    	je     8031c5 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	79 1c                	jns    8030c8 <free+0x39>
  8030ac:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8030b3:	77 13                	ja     8030c8 <free+0x39>
		free_block(virtual_address);
  8030b5:	83 ec 0c             	sub    $0xc,%esp
  8030b8:	ff 75 08             	pushl  0x8(%ebp)
  8030bb:	e8 21 12 00 00       	call   8042e1 <free_block>
  8030c0:	83 c4 10             	add    $0x10,%esp
		return;
  8030c3:	e9 01 01 00 00       	jmp    8031c9 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8030c8:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030cd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8030d0:	0f 82 d8 00 00 00    	jb     8031ae <free+0x11f>
  8030d6:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8030dd:	0f 87 cb 00 00 00    	ja     8031ae <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 17                	je     803106 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8030ef:	ff 75 08             	pushl  0x8(%ebp)
  8030f2:	68 d0 5b 80 00       	push   $0x805bd0
  8030f7:	68 57 01 00 00       	push   $0x157
  8030fc:	68 91 58 80 00       	push   $0x805891
  803101:	e8 ec e4 ff ff       	call   8015f2 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  803106:	83 ec 0c             	sub    $0xc,%esp
  803109:	ff 75 08             	pushl  0x8(%ebp)
  80310c:	e8 66 fa ff ff       	call   802b77 <find_allocated_size>
  803111:	83 c4 10             	add    $0x10,%esp
  803114:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  803117:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80311b:	0f 84 a7 00 00 00    	je     8031c8 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	f7 d0                	not    %eax
  803126:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803129:	73 1d                	jae    803148 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  80312b:	83 ec 0c             	sub    $0xc,%esp
  80312e:	ff 75 f0             	pushl  -0x10(%ebp)
  803131:	ff 75 f4             	pushl  -0xc(%ebp)
  803134:	68 f8 5b 80 00       	push   $0x805bf8
  803139:	68 61 01 00 00       	push   $0x161
  80313e:	68 91 58 80 00       	push   $0x805891
  803143:	e8 aa e4 ff ff       	call   8015f2 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  803148:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314e:	01 d0                	add    %edx,%eax
  803150:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	79 19                	jns    803173 <free+0xe4>
  80315a:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  803161:	77 10                	ja     803173 <free+0xe4>
  803163:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80316a:	77 07                	ja     803173 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80316c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	78 2b                	js     80319e <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  803173:	83 ec 0c             	sub    $0xc,%esp
  803176:	68 00 00 00 a0       	push   $0xa0000000
  80317b:	ff 75 ec             	pushl  -0x14(%ebp)
  80317e:	ff 75 f0             	pushl  -0x10(%ebp)
  803181:	ff 75 f4             	pushl  -0xc(%ebp)
  803184:	ff 75 f0             	pushl  -0x10(%ebp)
  803187:	ff 75 08             	pushl  0x8(%ebp)
  80318a:	68 34 5c 80 00       	push   $0x805c34
  80318f:	68 69 01 00 00       	push   $0x169
  803194:	68 91 58 80 00       	push   $0x805891
  803199:	e8 54 e4 ff ff       	call   8015f2 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80319e:	83 ec 0c             	sub    $0xc,%esp
  8031a1:	ff 75 08             	pushl  0x8(%ebp)
  8031a4:	e8 2c fa ff ff       	call   802bd5 <free_pages>
  8031a9:	83 c4 10             	add    $0x10,%esp
		return;
  8031ac:	eb 1b                	jmp    8031c9 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8031ae:	ff 75 08             	pushl  0x8(%ebp)
  8031b1:	68 90 5c 80 00       	push   $0x805c90
  8031b6:	68 70 01 00 00       	push   $0x170
  8031bb:	68 91 58 80 00       	push   $0x805891
  8031c0:	e8 2d e4 ff ff       	call   8015f2 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8031c5:	90                   	nop
  8031c6:	eb 01                	jmp    8031c9 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8031c8:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8031c9:	c9                   	leave  
  8031ca:	c3                   	ret    

008031cb <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8031cb:	55                   	push   %ebp
  8031cc:	89 e5                	mov    %esp,%ebp
  8031ce:	83 ec 38             	sub    $0x38,%esp
  8031d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8031d4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8031d7:	e8 2e fc ff ff       	call   802e0a <uheap_init>
	if (size == 0) return NULL ;
  8031dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031e0:	75 0a                	jne    8031ec <smalloc+0x21>
  8031e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e7:	e9 3d 01 00 00       	jmp    803329 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8031ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8031f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8031fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8031fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803201:	74 0e                	je     803211 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803209:	05 00 10 00 00       	add    $0x1000,%eax
  80320e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	c1 e8 0c             	shr    $0xc,%eax
  803217:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  80321a:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80321f:	85 c0                	test   %eax,%eax
  803221:	75 0a                	jne    80322d <smalloc+0x62>
		return NULL;
  803223:	b8 00 00 00 00       	mov    $0x0,%eax
  803228:	e9 fc 00 00 00       	jmp    803329 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80322d:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 0f                	je     803245 <smalloc+0x7a>
  803236:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80323c:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803241:	39 c2                	cmp    %eax,%edx
  803243:	73 0a                	jae    80324f <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  803245:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80324a:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80324f:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803254:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803259:	29 c2                	sub    %eax,%edx
  80325b:	89 d0                	mov    %edx,%eax
  80325d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803260:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  803266:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80326b:	29 c2                	sub    %eax,%edx
  80326d:	89 d0                	mov    %edx,%eax
  80326f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803278:	77 13                	ja     80328d <smalloc+0xc2>
  80327a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803280:	77 0b                	ja     80328d <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  803282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803285:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803288:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80328b:	73 0a                	jae    803297 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80328d:	b8 00 00 00 00       	mov    $0x0,%eax
  803292:	e9 92 00 00 00       	jmp    803329 <smalloc+0x15e>
	}

	void *va = NULL;
  803297:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80329e:	a1 44 e2 81 00       	mov    0x81e244,%eax
  8032a3:	83 f8 05             	cmp    $0x5,%eax
  8032a6:	75 11                	jne    8032b9 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8032a8:	83 ec 0c             	sub    $0xc,%esp
  8032ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ae:	e8 08 f7 ff ff       	call   8029bb <alloc_pages_custom_fit>
  8032b3:	83 c4 10             	add    $0x10,%esp
  8032b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8032b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032bd:	75 27                	jne    8032e6 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8032bf:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8032c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8032cc:	89 c2                	mov    %eax,%edx
  8032ce:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032d3:	39 c2                	cmp    %eax,%edx
  8032d5:	73 07                	jae    8032de <smalloc+0x113>
			return NULL;}
  8032d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032dc:	eb 4b                	jmp    803329 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8032de:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8032e6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8032ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8032ed:	50                   	push   %eax
  8032ee:	ff 75 0c             	pushl  0xc(%ebp)
  8032f1:	ff 75 08             	pushl  0x8(%ebp)
  8032f4:	e8 cb 03 00 00       	call   8036c4 <sys_create_shared_object>
  8032f9:	83 c4 10             	add    $0x10,%esp
  8032fc:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8032ff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803303:	79 07                	jns    80330c <smalloc+0x141>
		return NULL;
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	eb 1d                	jmp    803329 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80330c:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803311:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803314:	75 10                	jne    803326 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  803316:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	01 d0                	add    %edx,%eax
  803321:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}

	return va;
  803326:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  803329:	c9                   	leave  
  80332a:	c3                   	ret    

0080332b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80332b:	55                   	push   %ebp
  80332c:	89 e5                	mov    %esp,%ebp
  80332e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803331:	e8 d4 fa ff ff       	call   802e0a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  803336:	83 ec 08             	sub    $0x8,%esp
  803339:	ff 75 0c             	pushl  0xc(%ebp)
  80333c:	ff 75 08             	pushl  0x8(%ebp)
  80333f:	e8 aa 03 00 00       	call   8036ee <sys_size_of_shared_object>
  803344:	83 c4 10             	add    $0x10,%esp
  803347:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80334a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80334e:	7f 0a                	jg     80335a <sget+0x2f>
		return NULL;
  803350:	b8 00 00 00 00       	mov    $0x0,%eax
  803355:	e9 32 01 00 00       	jmp    80348c <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80335a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  803360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803363:	25 ff 0f 00 00       	and    $0xfff,%eax
  803368:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80336b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80336f:	74 0e                	je     80337f <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803377:	05 00 10 00 00       	add    $0x1000,%eax
  80337c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80337f:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803384:	85 c0                	test   %eax,%eax
  803386:	75 0a                	jne    803392 <sget+0x67>
		return NULL;
  803388:	b8 00 00 00 00       	mov    $0x0,%eax
  80338d:	e9 fa 00 00 00       	jmp    80348c <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  803392:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803397:	85 c0                	test   %eax,%eax
  803399:	74 0f                	je     8033aa <sget+0x7f>
  80339b:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8033a1:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8033a6:	39 c2                	cmp    %eax,%edx
  8033a8:	73 0a                	jae    8033b4 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8033aa:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8033af:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8033b4:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8033b9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8033be:	29 c2                	sub    %eax,%edx
  8033c0:	89 d0                	mov    %edx,%eax
  8033c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8033c5:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8033cb:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8033d0:	29 c2                	sub    %eax,%edx
  8033d2:	89 d0                	mov    %edx,%eax
  8033d4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033dd:	77 13                	ja     8033f2 <sget+0xc7>
  8033df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033e5:	77 0b                	ja     8033f2 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8033e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ea:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8033ed:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033f0:	73 0a                	jae    8033fc <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8033f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f7:	e9 90 00 00 00       	jmp    80348c <sget+0x161>

	void *va = NULL;
  8033fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  803403:	a1 44 e2 81 00       	mov    0x81e244,%eax
  803408:	83 f8 05             	cmp    $0x5,%eax
  80340b:	75 11                	jne    80341e <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80340d:	83 ec 0c             	sub    $0xc,%esp
  803410:	ff 75 f4             	pushl  -0xc(%ebp)
  803413:	e8 a3 f5 ff ff       	call   8029bb <alloc_pages_custom_fit>
  803418:	83 c4 10             	add    $0x10,%esp
  80341b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80341e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803422:	75 27                	jne    80344b <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803424:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80342b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80342e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803431:	89 c2                	mov    %eax,%edx
  803433:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803438:	39 c2                	cmp    %eax,%edx
  80343a:	73 07                	jae    803443 <sget+0x118>
			return NULL;
  80343c:	b8 00 00 00 00       	mov    $0x0,%eax
  803441:	eb 49                	jmp    80348c <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  803443:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803448:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	ff 75 f0             	pushl  -0x10(%ebp)
  803451:	ff 75 0c             	pushl  0xc(%ebp)
  803454:	ff 75 08             	pushl  0x8(%ebp)
  803457:	e8 af 02 00 00       	call   80370b <sys_get_shared_object>
  80345c:	83 c4 10             	add    $0x10,%esp
  80345f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  803462:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803466:	79 07                	jns    80346f <sget+0x144>
		return NULL;
  803468:	b8 00 00 00 00       	mov    $0x0,%eax
  80346d:	eb 1d                	jmp    80348c <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80346f:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803474:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803477:	75 10                	jne    803489 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  803479:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	01 d0                	add    %edx,%eax
  803484:	a3 50 e2 81 00       	mov    %eax,0x81e250

	return va;
  803489:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80348c:	c9                   	leave  
  80348d:	c3                   	ret    

0080348e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80348e:	55                   	push   %ebp
  80348f:	89 e5                	mov    %esp,%ebp
  803491:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803494:	e8 71 f9 ff ff       	call   802e0a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	68 b4 5c 80 00       	push   $0x805cb4
  8034a1:	68 19 02 00 00       	push   $0x219
  8034a6:	68 91 58 80 00       	push   $0x805891
  8034ab:	e8 42 e1 ff ff       	call   8015f2 <_panic>

008034b0 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8034b0:	55                   	push   %ebp
  8034b1:	89 e5                	mov    %esp,%ebp
  8034b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	68 dc 5c 80 00       	push   $0x805cdc
  8034be:	68 2b 02 00 00       	push   $0x22b
  8034c3:	68 91 58 80 00       	push   $0x805891
  8034c8:	e8 25 e1 ff ff       	call   8015f2 <_panic>

008034cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8034cd:	55                   	push   %ebp
  8034ce:	89 e5                	mov    %esp,%ebp
  8034d0:	57                   	push   %edi
  8034d1:	56                   	push   %esi
  8034d2:	53                   	push   %ebx
  8034d3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034e2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8034e5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8034e8:	cd 30                	int    $0x30
  8034ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8034ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8034f0:	83 c4 10             	add    $0x10,%esp
  8034f3:	5b                   	pop    %ebx
  8034f4:	5e                   	pop    %esi
  8034f5:	5f                   	pop    %edi
  8034f6:	5d                   	pop    %ebp
  8034f7:	c3                   	ret    

008034f8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8034f8:	55                   	push   %ebp
  8034f9:	89 e5                	mov    %esp,%ebp
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	8b 45 10             	mov    0x10(%ebp),%eax
  803501:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803504:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803507:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	6a 00                	push   $0x0
  803510:	51                   	push   %ecx
  803511:	52                   	push   %edx
  803512:	ff 75 0c             	pushl  0xc(%ebp)
  803515:	50                   	push   %eax
  803516:	6a 00                	push   $0x0
  803518:	e8 b0 ff ff ff       	call   8034cd <syscall>
  80351d:	83 c4 18             	add    $0x18,%esp
}
  803520:	90                   	nop
  803521:	c9                   	leave  
  803522:	c3                   	ret    

00803523 <sys_cgetc>:

int
sys_cgetc(void)
{
  803523:	55                   	push   %ebp
  803524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803526:	6a 00                	push   $0x0
  803528:	6a 00                	push   $0x0
  80352a:	6a 00                	push   $0x0
  80352c:	6a 00                	push   $0x0
  80352e:	6a 00                	push   $0x0
  803530:	6a 02                	push   $0x2
  803532:	e8 96 ff ff ff       	call   8034cd <syscall>
  803537:	83 c4 18             	add    $0x18,%esp
}
  80353a:	c9                   	leave  
  80353b:	c3                   	ret    

0080353c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80353c:	55                   	push   %ebp
  80353d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80353f:	6a 00                	push   $0x0
  803541:	6a 00                	push   $0x0
  803543:	6a 00                	push   $0x0
  803545:	6a 00                	push   $0x0
  803547:	6a 00                	push   $0x0
  803549:	6a 03                	push   $0x3
  80354b:	e8 7d ff ff ff       	call   8034cd <syscall>
  803550:	83 c4 18             	add    $0x18,%esp
}
  803553:	90                   	nop
  803554:	c9                   	leave  
  803555:	c3                   	ret    

00803556 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803556:	55                   	push   %ebp
  803557:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803559:	6a 00                	push   $0x0
  80355b:	6a 00                	push   $0x0
  80355d:	6a 00                	push   $0x0
  80355f:	6a 00                	push   $0x0
  803561:	6a 00                	push   $0x0
  803563:	6a 04                	push   $0x4
  803565:	e8 63 ff ff ff       	call   8034cd <syscall>
  80356a:	83 c4 18             	add    $0x18,%esp
}
  80356d:	90                   	nop
  80356e:	c9                   	leave  
  80356f:	c3                   	ret    

00803570 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803570:	55                   	push   %ebp
  803571:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803573:	8b 55 0c             	mov    0xc(%ebp),%edx
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	6a 00                	push   $0x0
  80357b:	6a 00                	push   $0x0
  80357d:	6a 00                	push   $0x0
  80357f:	52                   	push   %edx
  803580:	50                   	push   %eax
  803581:	6a 08                	push   $0x8
  803583:	e8 45 ff ff ff       	call   8034cd <syscall>
  803588:	83 c4 18             	add    $0x18,%esp
}
  80358b:	c9                   	leave  
  80358c:	c3                   	ret    

0080358d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80358d:	55                   	push   %ebp
  80358e:	89 e5                	mov    %esp,%ebp
  803590:	56                   	push   %esi
  803591:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803592:	8b 75 18             	mov    0x18(%ebp),%esi
  803595:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803598:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80359b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	56                   	push   %esi
  8035a2:	53                   	push   %ebx
  8035a3:	51                   	push   %ecx
  8035a4:	52                   	push   %edx
  8035a5:	50                   	push   %eax
  8035a6:	6a 09                	push   $0x9
  8035a8:	e8 20 ff ff ff       	call   8034cd <syscall>
  8035ad:	83 c4 18             	add    $0x18,%esp
}
  8035b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8035b3:	5b                   	pop    %ebx
  8035b4:	5e                   	pop    %esi
  8035b5:	5d                   	pop    %ebp
  8035b6:	c3                   	ret    

008035b7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8035b7:	55                   	push   %ebp
  8035b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8035ba:	6a 00                	push   $0x0
  8035bc:	6a 00                	push   $0x0
  8035be:	6a 00                	push   $0x0
  8035c0:	6a 00                	push   $0x0
  8035c2:	ff 75 08             	pushl  0x8(%ebp)
  8035c5:	6a 0a                	push   $0xa
  8035c7:	e8 01 ff ff ff       	call   8034cd <syscall>
  8035cc:	83 c4 18             	add    $0x18,%esp
}
  8035cf:	c9                   	leave  
  8035d0:	c3                   	ret    

008035d1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8035d1:	55                   	push   %ebp
  8035d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8035d4:	6a 00                	push   $0x0
  8035d6:	6a 00                	push   $0x0
  8035d8:	6a 00                	push   $0x0
  8035da:	ff 75 0c             	pushl  0xc(%ebp)
  8035dd:	ff 75 08             	pushl  0x8(%ebp)
  8035e0:	6a 0b                	push   $0xb
  8035e2:	e8 e6 fe ff ff       	call   8034cd <syscall>
  8035e7:	83 c4 18             	add    $0x18,%esp
}
  8035ea:	c9                   	leave  
  8035eb:	c3                   	ret    

008035ec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8035ec:	55                   	push   %ebp
  8035ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8035ef:	6a 00                	push   $0x0
  8035f1:	6a 00                	push   $0x0
  8035f3:	6a 00                	push   $0x0
  8035f5:	6a 00                	push   $0x0
  8035f7:	6a 00                	push   $0x0
  8035f9:	6a 0c                	push   $0xc
  8035fb:	e8 cd fe ff ff       	call   8034cd <syscall>
  803600:	83 c4 18             	add    $0x18,%esp
}
  803603:	c9                   	leave  
  803604:	c3                   	ret    

00803605 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803605:	55                   	push   %ebp
  803606:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803608:	6a 00                	push   $0x0
  80360a:	6a 00                	push   $0x0
  80360c:	6a 00                	push   $0x0
  80360e:	6a 00                	push   $0x0
  803610:	6a 00                	push   $0x0
  803612:	6a 0d                	push   $0xd
  803614:	e8 b4 fe ff ff       	call   8034cd <syscall>
  803619:	83 c4 18             	add    $0x18,%esp
}
  80361c:	c9                   	leave  
  80361d:	c3                   	ret    

0080361e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80361e:	55                   	push   %ebp
  80361f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803621:	6a 00                	push   $0x0
  803623:	6a 00                	push   $0x0
  803625:	6a 00                	push   $0x0
  803627:	6a 00                	push   $0x0
  803629:	6a 00                	push   $0x0
  80362b:	6a 0e                	push   $0xe
  80362d:	e8 9b fe ff ff       	call   8034cd <syscall>
  803632:	83 c4 18             	add    $0x18,%esp
}
  803635:	c9                   	leave  
  803636:	c3                   	ret    

00803637 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803637:	55                   	push   %ebp
  803638:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80363a:	6a 00                	push   $0x0
  80363c:	6a 00                	push   $0x0
  80363e:	6a 00                	push   $0x0
  803640:	6a 00                	push   $0x0
  803642:	6a 00                	push   $0x0
  803644:	6a 0f                	push   $0xf
  803646:	e8 82 fe ff ff       	call   8034cd <syscall>
  80364b:	83 c4 18             	add    $0x18,%esp
}
  80364e:	c9                   	leave  
  80364f:	c3                   	ret    

00803650 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803650:	55                   	push   %ebp
  803651:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803653:	6a 00                	push   $0x0
  803655:	6a 00                	push   $0x0
  803657:	6a 00                	push   $0x0
  803659:	6a 00                	push   $0x0
  80365b:	ff 75 08             	pushl  0x8(%ebp)
  80365e:	6a 10                	push   $0x10
  803660:	e8 68 fe ff ff       	call   8034cd <syscall>
  803665:	83 c4 18             	add    $0x18,%esp
}
  803668:	c9                   	leave  
  803669:	c3                   	ret    

0080366a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80366a:	55                   	push   %ebp
  80366b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80366d:	6a 00                	push   $0x0
  80366f:	6a 00                	push   $0x0
  803671:	6a 00                	push   $0x0
  803673:	6a 00                	push   $0x0
  803675:	6a 00                	push   $0x0
  803677:	6a 11                	push   $0x11
  803679:	e8 4f fe ff ff       	call   8034cd <syscall>
  80367e:	83 c4 18             	add    $0x18,%esp
}
  803681:	90                   	nop
  803682:	c9                   	leave  
  803683:	c3                   	ret    

00803684 <sys_cputc>:

void
sys_cputc(const char c)
{
  803684:	55                   	push   %ebp
  803685:	89 e5                	mov    %esp,%ebp
  803687:	83 ec 04             	sub    $0x4,%esp
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803690:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803694:	6a 00                	push   $0x0
  803696:	6a 00                	push   $0x0
  803698:	6a 00                	push   $0x0
  80369a:	6a 00                	push   $0x0
  80369c:	50                   	push   %eax
  80369d:	6a 01                	push   $0x1
  80369f:	e8 29 fe ff ff       	call   8034cd <syscall>
  8036a4:	83 c4 18             	add    $0x18,%esp
}
  8036a7:	90                   	nop
  8036a8:	c9                   	leave  
  8036a9:	c3                   	ret    

008036aa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8036aa:	55                   	push   %ebp
  8036ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8036ad:	6a 00                	push   $0x0
  8036af:	6a 00                	push   $0x0
  8036b1:	6a 00                	push   $0x0
  8036b3:	6a 00                	push   $0x0
  8036b5:	6a 00                	push   $0x0
  8036b7:	6a 14                	push   $0x14
  8036b9:	e8 0f fe ff ff       	call   8034cd <syscall>
  8036be:	83 c4 18             	add    $0x18,%esp
}
  8036c1:	90                   	nop
  8036c2:	c9                   	leave  
  8036c3:	c3                   	ret    

008036c4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8036c4:	55                   	push   %ebp
  8036c5:	89 e5                	mov    %esp,%ebp
  8036c7:	83 ec 04             	sub    $0x4,%esp
  8036ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8036cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8036d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8036d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	6a 00                	push   $0x0
  8036dc:	51                   	push   %ecx
  8036dd:	52                   	push   %edx
  8036de:	ff 75 0c             	pushl  0xc(%ebp)
  8036e1:	50                   	push   %eax
  8036e2:	6a 15                	push   $0x15
  8036e4:	e8 e4 fd ff ff       	call   8034cd <syscall>
  8036e9:	83 c4 18             	add    $0x18,%esp
}
  8036ec:	c9                   	leave  
  8036ed:	c3                   	ret    

008036ee <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8036ee:	55                   	push   %ebp
  8036ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8036f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	6a 00                	push   $0x0
  8036f9:	6a 00                	push   $0x0
  8036fb:	6a 00                	push   $0x0
  8036fd:	52                   	push   %edx
  8036fe:	50                   	push   %eax
  8036ff:	6a 16                	push   $0x16
  803701:	e8 c7 fd ff ff       	call   8034cd <syscall>
  803706:	83 c4 18             	add    $0x18,%esp
}
  803709:	c9                   	leave  
  80370a:	c3                   	ret    

0080370b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80370b:	55                   	push   %ebp
  80370c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80370e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803711:	8b 55 0c             	mov    0xc(%ebp),%edx
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	6a 00                	push   $0x0
  803719:	6a 00                	push   $0x0
  80371b:	51                   	push   %ecx
  80371c:	52                   	push   %edx
  80371d:	50                   	push   %eax
  80371e:	6a 17                	push   $0x17
  803720:	e8 a8 fd ff ff       	call   8034cd <syscall>
  803725:	83 c4 18             	add    $0x18,%esp
}
  803728:	c9                   	leave  
  803729:	c3                   	ret    

0080372a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80372a:	55                   	push   %ebp
  80372b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80372d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	6a 00                	push   $0x0
  803735:	6a 00                	push   $0x0
  803737:	6a 00                	push   $0x0
  803739:	52                   	push   %edx
  80373a:	50                   	push   %eax
  80373b:	6a 18                	push   $0x18
  80373d:	e8 8b fd ff ff       	call   8034cd <syscall>
  803742:	83 c4 18             	add    $0x18,%esp
}
  803745:	c9                   	leave  
  803746:	c3                   	ret    

00803747 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803747:	55                   	push   %ebp
  803748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	6a 00                	push   $0x0
  80374f:	ff 75 14             	pushl  0x14(%ebp)
  803752:	ff 75 10             	pushl  0x10(%ebp)
  803755:	ff 75 0c             	pushl  0xc(%ebp)
  803758:	50                   	push   %eax
  803759:	6a 19                	push   $0x19
  80375b:	e8 6d fd ff ff       	call   8034cd <syscall>
  803760:	83 c4 18             	add    $0x18,%esp
}
  803763:	c9                   	leave  
  803764:	c3                   	ret    

00803765 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803765:	55                   	push   %ebp
  803766:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	6a 00                	push   $0x0
  80376d:	6a 00                	push   $0x0
  80376f:	6a 00                	push   $0x0
  803771:	6a 00                	push   $0x0
  803773:	50                   	push   %eax
  803774:	6a 1a                	push   $0x1a
  803776:	e8 52 fd ff ff       	call   8034cd <syscall>
  80377b:	83 c4 18             	add    $0x18,%esp
}
  80377e:	90                   	nop
  80377f:	c9                   	leave  
  803780:	c3                   	ret    

00803781 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803781:	55                   	push   %ebp
  803782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	6a 00                	push   $0x0
  803789:	6a 00                	push   $0x0
  80378b:	6a 00                	push   $0x0
  80378d:	6a 00                	push   $0x0
  80378f:	50                   	push   %eax
  803790:	6a 1b                	push   $0x1b
  803792:	e8 36 fd ff ff       	call   8034cd <syscall>
  803797:	83 c4 18             	add    $0x18,%esp
}
  80379a:	c9                   	leave  
  80379b:	c3                   	ret    

0080379c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80379c:	55                   	push   %ebp
  80379d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80379f:	6a 00                	push   $0x0
  8037a1:	6a 00                	push   $0x0
  8037a3:	6a 00                	push   $0x0
  8037a5:	6a 00                	push   $0x0
  8037a7:	6a 00                	push   $0x0
  8037a9:	6a 05                	push   $0x5
  8037ab:	e8 1d fd ff ff       	call   8034cd <syscall>
  8037b0:	83 c4 18             	add    $0x18,%esp
}
  8037b3:	c9                   	leave  
  8037b4:	c3                   	ret    

008037b5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8037b5:	55                   	push   %ebp
  8037b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8037b8:	6a 00                	push   $0x0
  8037ba:	6a 00                	push   $0x0
  8037bc:	6a 00                	push   $0x0
  8037be:	6a 00                	push   $0x0
  8037c0:	6a 00                	push   $0x0
  8037c2:	6a 06                	push   $0x6
  8037c4:	e8 04 fd ff ff       	call   8034cd <syscall>
  8037c9:	83 c4 18             	add    $0x18,%esp
}
  8037cc:	c9                   	leave  
  8037cd:	c3                   	ret    

008037ce <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8037ce:	55                   	push   %ebp
  8037cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8037d1:	6a 00                	push   $0x0
  8037d3:	6a 00                	push   $0x0
  8037d5:	6a 00                	push   $0x0
  8037d7:	6a 00                	push   $0x0
  8037d9:	6a 00                	push   $0x0
  8037db:	6a 07                	push   $0x7
  8037dd:	e8 eb fc ff ff       	call   8034cd <syscall>
  8037e2:	83 c4 18             	add    $0x18,%esp
}
  8037e5:	c9                   	leave  
  8037e6:	c3                   	ret    

008037e7 <sys_exit_env>:


void sys_exit_env(void)
{
  8037e7:	55                   	push   %ebp
  8037e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8037ea:	6a 00                	push   $0x0
  8037ec:	6a 00                	push   $0x0
  8037ee:	6a 00                	push   $0x0
  8037f0:	6a 00                	push   $0x0
  8037f2:	6a 00                	push   $0x0
  8037f4:	6a 1c                	push   $0x1c
  8037f6:	e8 d2 fc ff ff       	call   8034cd <syscall>
  8037fb:	83 c4 18             	add    $0x18,%esp
}
  8037fe:	90                   	nop
  8037ff:	c9                   	leave  
  803800:	c3                   	ret    

00803801 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803801:	55                   	push   %ebp
  803802:	89 e5                	mov    %esp,%ebp
  803804:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803807:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80380a:	8d 50 04             	lea    0x4(%eax),%edx
  80380d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803810:	6a 00                	push   $0x0
  803812:	6a 00                	push   $0x0
  803814:	6a 00                	push   $0x0
  803816:	52                   	push   %edx
  803817:	50                   	push   %eax
  803818:	6a 1d                	push   $0x1d
  80381a:	e8 ae fc ff ff       	call   8034cd <syscall>
  80381f:	83 c4 18             	add    $0x18,%esp
	return result;
  803822:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803825:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803828:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80382b:	89 01                	mov    %eax,(%ecx)
  80382d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803830:	8b 45 08             	mov    0x8(%ebp),%eax
  803833:	c9                   	leave  
  803834:	c2 04 00             	ret    $0x4

00803837 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803837:	55                   	push   %ebp
  803838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80383a:	6a 00                	push   $0x0
  80383c:	6a 00                	push   $0x0
  80383e:	ff 75 10             	pushl  0x10(%ebp)
  803841:	ff 75 0c             	pushl  0xc(%ebp)
  803844:	ff 75 08             	pushl  0x8(%ebp)
  803847:	6a 13                	push   $0x13
  803849:	e8 7f fc ff ff       	call   8034cd <syscall>
  80384e:	83 c4 18             	add    $0x18,%esp
	return ;
  803851:	90                   	nop
}
  803852:	c9                   	leave  
  803853:	c3                   	ret    

00803854 <sys_rcr2>:
uint32 sys_rcr2()
{
  803854:	55                   	push   %ebp
  803855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803857:	6a 00                	push   $0x0
  803859:	6a 00                	push   $0x0
  80385b:	6a 00                	push   $0x0
  80385d:	6a 00                	push   $0x0
  80385f:	6a 00                	push   $0x0
  803861:	6a 1e                	push   $0x1e
  803863:	e8 65 fc ff ff       	call   8034cd <syscall>
  803868:	83 c4 18             	add    $0x18,%esp
}
  80386b:	c9                   	leave  
  80386c:	c3                   	ret    

0080386d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80386d:	55                   	push   %ebp
  80386e:	89 e5                	mov    %esp,%ebp
  803870:	83 ec 04             	sub    $0x4,%esp
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803879:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80387d:	6a 00                	push   $0x0
  80387f:	6a 00                	push   $0x0
  803881:	6a 00                	push   $0x0
  803883:	6a 00                	push   $0x0
  803885:	50                   	push   %eax
  803886:	6a 1f                	push   $0x1f
  803888:	e8 40 fc ff ff       	call   8034cd <syscall>
  80388d:	83 c4 18             	add    $0x18,%esp
	return ;
  803890:	90                   	nop
}
  803891:	c9                   	leave  
  803892:	c3                   	ret    

00803893 <rsttst>:
void rsttst()
{
  803893:	55                   	push   %ebp
  803894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803896:	6a 00                	push   $0x0
  803898:	6a 00                	push   $0x0
  80389a:	6a 00                	push   $0x0
  80389c:	6a 00                	push   $0x0
  80389e:	6a 00                	push   $0x0
  8038a0:	6a 21                	push   $0x21
  8038a2:	e8 26 fc ff ff       	call   8034cd <syscall>
  8038a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8038aa:	90                   	nop
}
  8038ab:	c9                   	leave  
  8038ac:	c3                   	ret    

008038ad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8038ad:	55                   	push   %ebp
  8038ae:	89 e5                	mov    %esp,%ebp
  8038b0:	83 ec 04             	sub    $0x4,%esp
  8038b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8038b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8038b9:	8b 55 18             	mov    0x18(%ebp),%edx
  8038bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8038c0:	52                   	push   %edx
  8038c1:	50                   	push   %eax
  8038c2:	ff 75 10             	pushl  0x10(%ebp)
  8038c5:	ff 75 0c             	pushl  0xc(%ebp)
  8038c8:	ff 75 08             	pushl  0x8(%ebp)
  8038cb:	6a 20                	push   $0x20
  8038cd:	e8 fb fb ff ff       	call   8034cd <syscall>
  8038d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8038d5:	90                   	nop
}
  8038d6:	c9                   	leave  
  8038d7:	c3                   	ret    

008038d8 <chktst>:
void chktst(uint32 n)
{
  8038d8:	55                   	push   %ebp
  8038d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8038db:	6a 00                	push   $0x0
  8038dd:	6a 00                	push   $0x0
  8038df:	6a 00                	push   $0x0
  8038e1:	6a 00                	push   $0x0
  8038e3:	ff 75 08             	pushl  0x8(%ebp)
  8038e6:	6a 22                	push   $0x22
  8038e8:	e8 e0 fb ff ff       	call   8034cd <syscall>
  8038ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8038f0:	90                   	nop
}
  8038f1:	c9                   	leave  
  8038f2:	c3                   	ret    

008038f3 <inctst>:

void inctst()
{
  8038f3:	55                   	push   %ebp
  8038f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8038f6:	6a 00                	push   $0x0
  8038f8:	6a 00                	push   $0x0
  8038fa:	6a 00                	push   $0x0
  8038fc:	6a 00                	push   $0x0
  8038fe:	6a 00                	push   $0x0
  803900:	6a 23                	push   $0x23
  803902:	e8 c6 fb ff ff       	call   8034cd <syscall>
  803907:	83 c4 18             	add    $0x18,%esp
	return ;
  80390a:	90                   	nop
}
  80390b:	c9                   	leave  
  80390c:	c3                   	ret    

0080390d <gettst>:
uint32 gettst()
{
  80390d:	55                   	push   %ebp
  80390e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803910:	6a 00                	push   $0x0
  803912:	6a 00                	push   $0x0
  803914:	6a 00                	push   $0x0
  803916:	6a 00                	push   $0x0
  803918:	6a 00                	push   $0x0
  80391a:	6a 24                	push   $0x24
  80391c:	e8 ac fb ff ff       	call   8034cd <syscall>
  803921:	83 c4 18             	add    $0x18,%esp
}
  803924:	c9                   	leave  
  803925:	c3                   	ret    

00803926 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803926:	55                   	push   %ebp
  803927:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803929:	6a 00                	push   $0x0
  80392b:	6a 00                	push   $0x0
  80392d:	6a 00                	push   $0x0
  80392f:	6a 00                	push   $0x0
  803931:	6a 00                	push   $0x0
  803933:	6a 25                	push   $0x25
  803935:	e8 93 fb ff ff       	call   8034cd <syscall>
  80393a:	83 c4 18             	add    $0x18,%esp
  80393d:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  803942:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  803947:	c9                   	leave  
  803948:	c3                   	ret    

00803949 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803949:	55                   	push   %ebp
  80394a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803954:	6a 00                	push   $0x0
  803956:	6a 00                	push   $0x0
  803958:	6a 00                	push   $0x0
  80395a:	6a 00                	push   $0x0
  80395c:	ff 75 08             	pushl  0x8(%ebp)
  80395f:	6a 26                	push   $0x26
  803961:	e8 67 fb ff ff       	call   8034cd <syscall>
  803966:	83 c4 18             	add    $0x18,%esp
	return ;
  803969:	90                   	nop
}
  80396a:	c9                   	leave  
  80396b:	c3                   	ret    

0080396c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80396c:	55                   	push   %ebp
  80396d:	89 e5                	mov    %esp,%ebp
  80396f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803970:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803973:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803976:	8b 55 0c             	mov    0xc(%ebp),%edx
  803979:	8b 45 08             	mov    0x8(%ebp),%eax
  80397c:	6a 00                	push   $0x0
  80397e:	53                   	push   %ebx
  80397f:	51                   	push   %ecx
  803980:	52                   	push   %edx
  803981:	50                   	push   %eax
  803982:	6a 27                	push   $0x27
  803984:	e8 44 fb ff ff       	call   8034cd <syscall>
  803989:	83 c4 18             	add    $0x18,%esp
}
  80398c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80398f:	c9                   	leave  
  803990:	c3                   	ret    

00803991 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803991:	55                   	push   %ebp
  803992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803994:	8b 55 0c             	mov    0xc(%ebp),%edx
  803997:	8b 45 08             	mov    0x8(%ebp),%eax
  80399a:	6a 00                	push   $0x0
  80399c:	6a 00                	push   $0x0
  80399e:	6a 00                	push   $0x0
  8039a0:	52                   	push   %edx
  8039a1:	50                   	push   %eax
  8039a2:	6a 28                	push   $0x28
  8039a4:	e8 24 fb ff ff       	call   8034cd <syscall>
  8039a9:	83 c4 18             	add    $0x18,%esp
}
  8039ac:	c9                   	leave  
  8039ad:	c3                   	ret    

008039ae <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8039ae:	55                   	push   %ebp
  8039af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8039b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8039b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	6a 00                	push   $0x0
  8039bc:	51                   	push   %ecx
  8039bd:	ff 75 10             	pushl  0x10(%ebp)
  8039c0:	52                   	push   %edx
  8039c1:	50                   	push   %eax
  8039c2:	6a 29                	push   $0x29
  8039c4:	e8 04 fb ff ff       	call   8034cd <syscall>
  8039c9:	83 c4 18             	add    $0x18,%esp
}
  8039cc:	c9                   	leave  
  8039cd:	c3                   	ret    

008039ce <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8039ce:	55                   	push   %ebp
  8039cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8039d1:	6a 00                	push   $0x0
  8039d3:	6a 00                	push   $0x0
  8039d5:	ff 75 10             	pushl  0x10(%ebp)
  8039d8:	ff 75 0c             	pushl  0xc(%ebp)
  8039db:	ff 75 08             	pushl  0x8(%ebp)
  8039de:	6a 12                	push   $0x12
  8039e0:	e8 e8 fa ff ff       	call   8034cd <syscall>
  8039e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8039e8:	90                   	nop
}
  8039e9:	c9                   	leave  
  8039ea:	c3                   	ret    

008039eb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8039eb:	55                   	push   %ebp
  8039ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8039ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f4:	6a 00                	push   $0x0
  8039f6:	6a 00                	push   $0x0
  8039f8:	6a 00                	push   $0x0
  8039fa:	52                   	push   %edx
  8039fb:	50                   	push   %eax
  8039fc:	6a 2a                	push   $0x2a
  8039fe:	e8 ca fa ff ff       	call   8034cd <syscall>
  803a03:	83 c4 18             	add    $0x18,%esp
	return;
  803a06:	90                   	nop
}
  803a07:	c9                   	leave  
  803a08:	c3                   	ret    

00803a09 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803a0c:	6a 00                	push   $0x0
  803a0e:	6a 00                	push   $0x0
  803a10:	6a 00                	push   $0x0
  803a12:	6a 00                	push   $0x0
  803a14:	6a 00                	push   $0x0
  803a16:	6a 2b                	push   $0x2b
  803a18:	e8 b0 fa ff ff       	call   8034cd <syscall>
  803a1d:	83 c4 18             	add    $0x18,%esp
}
  803a20:	c9                   	leave  
  803a21:	c3                   	ret    

00803a22 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803a22:	55                   	push   %ebp
  803a23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803a25:	6a 00                	push   $0x0
  803a27:	6a 00                	push   $0x0
  803a29:	6a 00                	push   $0x0
  803a2b:	ff 75 0c             	pushl  0xc(%ebp)
  803a2e:	ff 75 08             	pushl  0x8(%ebp)
  803a31:	6a 2d                	push   $0x2d
  803a33:	e8 95 fa ff ff       	call   8034cd <syscall>
  803a38:	83 c4 18             	add    $0x18,%esp
	return;
  803a3b:	90                   	nop
}
  803a3c:	c9                   	leave  
  803a3d:	c3                   	ret    

00803a3e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803a3e:	55                   	push   %ebp
  803a3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803a41:	6a 00                	push   $0x0
  803a43:	6a 00                	push   $0x0
  803a45:	6a 00                	push   $0x0
  803a47:	ff 75 0c             	pushl  0xc(%ebp)
  803a4a:	ff 75 08             	pushl  0x8(%ebp)
  803a4d:	6a 2c                	push   $0x2c
  803a4f:	e8 79 fa ff ff       	call   8034cd <syscall>
  803a54:	83 c4 18             	add    $0x18,%esp
	return ;
  803a57:	90                   	nop
}
  803a58:	c9                   	leave  
  803a59:	c3                   	ret    

00803a5a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803a5a:	55                   	push   %ebp
  803a5b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	6a 00                	push   $0x0
  803a65:	6a 00                	push   $0x0
  803a67:	6a 00                	push   $0x0
  803a69:	52                   	push   %edx
  803a6a:	50                   	push   %eax
  803a6b:	6a 2e                	push   $0x2e
  803a6d:	e8 5b fa ff ff       	call   8034cd <syscall>
  803a72:	83 c4 18             	add    $0x18,%esp
	return ;
  803a75:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803a76:	c9                   	leave  
  803a77:	c3                   	ret    

00803a78 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803a78:	55                   	push   %ebp
  803a79:	89 e5                	mov    %esp,%ebp
  803a7b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803a7e:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  803a85:	72 09                	jb     803a90 <to_page_va+0x18>
  803a87:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  803a8e:	72 14                	jb     803aa4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803a90:	83 ec 04             	sub    $0x4,%esp
  803a93:	68 00 5d 80 00       	push   $0x805d00
  803a98:	6a 15                	push   $0x15
  803a9a:	68 2b 5d 80 00       	push   $0x805d2b
  803a9f:	e8 4e db ff ff       	call   8015f2 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa7:	ba 40 62 80 00       	mov    $0x806240,%edx
  803aac:	29 d0                	sub    %edx,%eax
  803aae:	c1 f8 02             	sar    $0x2,%eax
  803ab1:	89 c2                	mov    %eax,%edx
  803ab3:	89 d0                	mov    %edx,%eax
  803ab5:	c1 e0 02             	shl    $0x2,%eax
  803ab8:	01 d0                	add    %edx,%eax
  803aba:	c1 e0 02             	shl    $0x2,%eax
  803abd:	01 d0                	add    %edx,%eax
  803abf:	c1 e0 02             	shl    $0x2,%eax
  803ac2:	01 d0                	add    %edx,%eax
  803ac4:	89 c1                	mov    %eax,%ecx
  803ac6:	c1 e1 08             	shl    $0x8,%ecx
  803ac9:	01 c8                	add    %ecx,%eax
  803acb:	89 c1                	mov    %eax,%ecx
  803acd:	c1 e1 10             	shl    $0x10,%ecx
  803ad0:	01 c8                	add    %ecx,%eax
  803ad2:	01 c0                	add    %eax,%eax
  803ad4:	01 d0                	add    %edx,%eax
  803ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	c1 e0 0c             	shl    $0xc,%eax
  803adf:	89 c2                	mov    %eax,%edx
  803ae1:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803ae6:	01 d0                	add    %edx,%eax
}
  803ae8:	c9                   	leave  
  803ae9:	c3                   	ret    

00803aea <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803aea:	55                   	push   %ebp
  803aeb:	89 e5                	mov    %esp,%ebp
  803aed:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803af0:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803af5:	8b 55 08             	mov    0x8(%ebp),%edx
  803af8:	29 c2                	sub    %eax,%edx
  803afa:	89 d0                	mov    %edx,%eax
  803afc:	c1 e8 0c             	shr    $0xc,%eax
  803aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b06:	78 09                	js     803b11 <to_page_info+0x27>
  803b08:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803b0f:	7e 14                	jle    803b25 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803b11:	83 ec 04             	sub    $0x4,%esp
  803b14:	68 44 5d 80 00       	push   $0x805d44
  803b19:	6a 22                	push   $0x22
  803b1b:	68 2b 5d 80 00       	push   $0x805d2b
  803b20:	e8 cd da ff ff       	call   8015f2 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b28:	89 d0                	mov    %edx,%eax
  803b2a:	01 c0                	add    %eax,%eax
  803b2c:	01 d0                	add    %edx,%eax
  803b2e:	c1 e0 02             	shl    $0x2,%eax
  803b31:	05 40 62 80 00       	add    $0x806240,%eax
}
  803b36:	c9                   	leave  
  803b37:	c3                   	ret    

00803b38 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803b38:	55                   	push   %ebp
  803b39:	89 e5                	mov    %esp,%ebp
  803b3b:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b41:	05 00 00 00 02       	add    $0x2000000,%eax
  803b46:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b49:	73 16                	jae    803b61 <initialize_dynamic_allocator+0x29>
  803b4b:	68 68 5d 80 00       	push   $0x805d68
  803b50:	68 8e 5d 80 00       	push   $0x805d8e
  803b55:	6a 34                	push   $0x34
  803b57:	68 2b 5d 80 00       	push   $0x805d2b
  803b5c:	e8 91 da ff ff       	call   8015f2 <_panic>
		is_initialized = 1;
  803b61:	c7 05 14 62 80 00 01 	movl   $0x1,0x806214
  803b68:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6e:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  803b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b76:	a3 20 62 80 00       	mov    %eax,0x806220

	LIST_INIT(&freePagesList);
  803b7b:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  803b82:	00 00 00 
  803b85:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  803b8c:	00 00 00 
  803b8f:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  803b96:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803b99:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ba7:	eb 36                	jmp    803bdf <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bac:	c1 e0 04             	shl    $0x4,%eax
  803baf:	05 60 e2 81 00       	add    $0x81e260,%eax
  803bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbd:	c1 e0 04             	shl    $0x4,%eax
  803bc0:	05 64 e2 81 00       	add    $0x81e264,%eax
  803bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bce:	c1 e0 04             	shl    $0x4,%eax
  803bd1:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803bd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803bdc:	ff 45 f4             	incl   -0xc(%ebp)
  803bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803be5:	72 c2                	jb     803ba9 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803be7:	8b 15 20 62 80 00    	mov    0x806220,%edx
  803bed:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803bf2:	29 c2                	sub    %eax,%edx
  803bf4:	89 d0                	mov    %edx,%eax
  803bf6:	c1 e8 0c             	shr    $0xc,%eax
  803bf9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803bfc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803c03:	e9 c8 00 00 00       	jmp    803cd0 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803c08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c0b:	89 d0                	mov    %edx,%eax
  803c0d:	01 c0                	add    %eax,%eax
  803c0f:	01 d0                	add    %edx,%eax
  803c11:	c1 e0 02             	shl    $0x2,%eax
  803c14:	05 48 62 80 00       	add    $0x806248,%eax
  803c19:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803c1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c21:	89 d0                	mov    %edx,%eax
  803c23:	01 c0                	add    %eax,%eax
  803c25:	01 d0                	add    %edx,%eax
  803c27:	c1 e0 02             	shl    $0x2,%eax
  803c2a:	05 4a 62 80 00       	add    $0x80624a,%eax
  803c2f:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803c34:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803c3a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c3d:	89 c8                	mov    %ecx,%eax
  803c3f:	01 c0                	add    %eax,%eax
  803c41:	01 c8                	add    %ecx,%eax
  803c43:	c1 e0 02             	shl    $0x2,%eax
  803c46:	05 44 62 80 00       	add    $0x806244,%eax
  803c4b:	89 10                	mov    %edx,(%eax)
  803c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c50:	89 d0                	mov    %edx,%eax
  803c52:	01 c0                	add    %eax,%eax
  803c54:	01 d0                	add    %edx,%eax
  803c56:	c1 e0 02             	shl    $0x2,%eax
  803c59:	05 44 62 80 00       	add    $0x806244,%eax
  803c5e:	8b 00                	mov    (%eax),%eax
  803c60:	85 c0                	test   %eax,%eax
  803c62:	74 1b                	je     803c7f <initialize_dynamic_allocator+0x147>
  803c64:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803c6a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c6d:	89 c8                	mov    %ecx,%eax
  803c6f:	01 c0                	add    %eax,%eax
  803c71:	01 c8                	add    %ecx,%eax
  803c73:	c1 e0 02             	shl    $0x2,%eax
  803c76:	05 40 62 80 00       	add    $0x806240,%eax
  803c7b:	89 02                	mov    %eax,(%edx)
  803c7d:	eb 16                	jmp    803c95 <initialize_dynamic_allocator+0x15d>
  803c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c82:	89 d0                	mov    %edx,%eax
  803c84:	01 c0                	add    %eax,%eax
  803c86:	01 d0                	add    %edx,%eax
  803c88:	c1 e0 02             	shl    $0x2,%eax
  803c8b:	05 40 62 80 00       	add    $0x806240,%eax
  803c90:	a3 28 62 80 00       	mov    %eax,0x806228
  803c95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c98:	89 d0                	mov    %edx,%eax
  803c9a:	01 c0                	add    %eax,%eax
  803c9c:	01 d0                	add    %edx,%eax
  803c9e:	c1 e0 02             	shl    $0x2,%eax
  803ca1:	05 40 62 80 00       	add    $0x806240,%eax
  803ca6:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803cab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cae:	89 d0                	mov    %edx,%eax
  803cb0:	01 c0                	add    %eax,%eax
  803cb2:	01 d0                	add    %edx,%eax
  803cb4:	c1 e0 02             	shl    $0x2,%eax
  803cb7:	05 40 62 80 00       	add    $0x806240,%eax
  803cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cc2:	a1 34 62 80 00       	mov    0x806234,%eax
  803cc7:	40                   	inc    %eax
  803cc8:	a3 34 62 80 00       	mov    %eax,0x806234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803ccd:	ff 45 f0             	incl   -0x10(%ebp)
  803cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803cd6:	0f 82 2c ff ff ff    	jb     803c08 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ce2:	eb 2f                	jmp    803d13 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803ce4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ce7:	89 d0                	mov    %edx,%eax
  803ce9:	01 c0                	add    %eax,%eax
  803ceb:	01 d0                	add    %edx,%eax
  803ced:	c1 e0 02             	shl    $0x2,%eax
  803cf0:	05 48 62 80 00       	add    $0x806248,%eax
  803cf5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803cfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cfd:	89 d0                	mov    %edx,%eax
  803cff:	01 c0                	add    %eax,%eax
  803d01:	01 d0                	add    %edx,%eax
  803d03:	c1 e0 02             	shl    $0x2,%eax
  803d06:	05 4a 62 80 00       	add    $0x80624a,%eax
  803d0b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803d10:	ff 45 ec             	incl   -0x14(%ebp)
  803d13:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803d1a:	76 c8                	jbe    803ce4 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803d1c:	90                   	nop
  803d1d:	c9                   	leave  
  803d1e:	c3                   	ret    

00803d1f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803d1f:	55                   	push   %ebp
  803d20:	89 e5                	mov    %esp,%ebp
  803d22:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803d25:	8b 55 08             	mov    0x8(%ebp),%edx
  803d28:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803d2d:	29 c2                	sub    %eax,%edx
  803d2f:	89 d0                	mov    %edx,%eax
  803d31:	c1 e8 0c             	shr    $0xc,%eax
  803d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803d37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803d3a:	89 d0                	mov    %edx,%eax
  803d3c:	01 c0                	add    %eax,%eax
  803d3e:	01 d0                	add    %edx,%eax
  803d40:	c1 e0 02             	shl    $0x2,%eax
  803d43:	05 48 62 80 00       	add    $0x806248,%eax
  803d48:	8b 00                	mov    (%eax),%eax
  803d4a:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803d4d:	c9                   	leave  
  803d4e:	c3                   	ret    

00803d4f <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803d4f:	55                   	push   %ebp
  803d50:	89 e5                	mov    %esp,%ebp
  803d52:	83 ec 14             	sub    $0x14,%esp
  803d55:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803d58:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803d5c:	77 07                	ja     803d65 <nearest_pow2_ceil.1513+0x16>
  803d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d63:	eb 20                	jmp    803d85 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803d65:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803d6c:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803d6f:	eb 08                	jmp    803d79 <nearest_pow2_ceil.1513+0x2a>
  803d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803d74:	01 c0                	add    %eax,%eax
  803d76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803d79:	d1 6d 08             	shrl   0x8(%ebp)
  803d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d80:	75 ef                	jne    803d71 <nearest_pow2_ceil.1513+0x22>
        return power;
  803d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803d85:	c9                   	leave  
  803d86:	c3                   	ret    

00803d87 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803d87:	55                   	push   %ebp
  803d88:	89 e5                	mov    %esp,%ebp
  803d8a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803d8d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803d94:	76 16                	jbe    803dac <alloc_block+0x25>
  803d96:	68 a4 5d 80 00       	push   $0x805da4
  803d9b:	68 8e 5d 80 00       	push   $0x805d8e
  803da0:	6a 72                	push   $0x72
  803da2:	68 2b 5d 80 00       	push   $0x805d2b
  803da7:	e8 46 d8 ff ff       	call   8015f2 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803db0:	75 0a                	jne    803dbc <alloc_block+0x35>
  803db2:	b8 00 00 00 00       	mov    $0x0,%eax
  803db7:	e9 bd 04 00 00       	jmp    804279 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803dbc:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803dc9:	73 06                	jae    803dd1 <alloc_block+0x4a>
        size = min_block_size;
  803dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dce:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803dd1:	83 ec 0c             	sub    $0xc,%esp
  803dd4:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803dd7:	ff 75 08             	pushl  0x8(%ebp)
  803dda:	89 c1                	mov    %eax,%ecx
  803ddc:	e8 6e ff ff ff       	call   803d4f <nearest_pow2_ceil.1513>
  803de1:	83 c4 10             	add    $0x10,%esp
  803de4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803de7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dea:	83 ec 0c             	sub    $0xc,%esp
  803ded:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803df0:	52                   	push   %edx
  803df1:	89 c1                	mov    %eax,%ecx
  803df3:	e8 83 04 00 00       	call   80427b <log2_ceil.1520>
  803df8:	83 c4 10             	add    $0x10,%esp
  803dfb:	83 e8 03             	sub    $0x3,%eax
  803dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e04:	c1 e0 04             	shl    $0x4,%eax
  803e07:	05 60 e2 81 00       	add    $0x81e260,%eax
  803e0c:	8b 00                	mov    (%eax),%eax
  803e0e:	85 c0                	test   %eax,%eax
  803e10:	0f 84 d8 00 00 00    	je     803eee <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e19:	c1 e0 04             	shl    $0x4,%eax
  803e1c:	05 60 e2 81 00       	add    $0x81e260,%eax
  803e21:	8b 00                	mov    (%eax),%eax
  803e23:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803e26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803e2a:	75 17                	jne    803e43 <alloc_block+0xbc>
  803e2c:	83 ec 04             	sub    $0x4,%esp
  803e2f:	68 c5 5d 80 00       	push   $0x805dc5
  803e34:	68 98 00 00 00       	push   $0x98
  803e39:	68 2b 5d 80 00       	push   $0x805d2b
  803e3e:	e8 af d7 ff ff       	call   8015f2 <_panic>
  803e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e46:	8b 00                	mov    (%eax),%eax
  803e48:	85 c0                	test   %eax,%eax
  803e4a:	74 10                	je     803e5c <alloc_block+0xd5>
  803e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e4f:	8b 00                	mov    (%eax),%eax
  803e51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e54:	8b 52 04             	mov    0x4(%edx),%edx
  803e57:	89 50 04             	mov    %edx,0x4(%eax)
  803e5a:	eb 14                	jmp    803e70 <alloc_block+0xe9>
  803e5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e5f:	8b 40 04             	mov    0x4(%eax),%eax
  803e62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e65:	c1 e2 04             	shl    $0x4,%edx
  803e68:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803e6e:	89 02                	mov    %eax,(%edx)
  803e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e73:	8b 40 04             	mov    0x4(%eax),%eax
  803e76:	85 c0                	test   %eax,%eax
  803e78:	74 0f                	je     803e89 <alloc_block+0x102>
  803e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e7d:	8b 40 04             	mov    0x4(%eax),%eax
  803e80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e83:	8b 12                	mov    (%edx),%edx
  803e85:	89 10                	mov    %edx,(%eax)
  803e87:	eb 13                	jmp    803e9c <alloc_block+0x115>
  803e89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e8c:	8b 00                	mov    (%eax),%eax
  803e8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e91:	c1 e2 04             	shl    $0x4,%edx
  803e94:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803e9a:	89 02                	mov    %eax,(%edx)
  803e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ea8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb2:	c1 e0 04             	shl    $0x4,%eax
  803eb5:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803eba:	8b 00                	mov    (%eax),%eax
  803ebc:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec2:	c1 e0 04             	shl    $0x4,%eax
  803ec5:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803eca:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ecf:	83 ec 0c             	sub    $0xc,%esp
  803ed2:	50                   	push   %eax
  803ed3:	e8 12 fc ff ff       	call   803aea <to_page_info>
  803ed8:	83 c4 10             	add    $0x10,%esp
  803edb:	89 c2                	mov    %eax,%edx
  803edd:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803ee1:	48                   	dec    %eax
  803ee2:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803ee6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ee9:	e9 8b 03 00 00       	jmp    804279 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803eee:	a1 28 62 80 00       	mov    0x806228,%eax
  803ef3:	85 c0                	test   %eax,%eax
  803ef5:	0f 84 64 02 00 00    	je     80415f <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803efb:	a1 28 62 80 00       	mov    0x806228,%eax
  803f00:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803f03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f07:	75 17                	jne    803f20 <alloc_block+0x199>
  803f09:	83 ec 04             	sub    $0x4,%esp
  803f0c:	68 c5 5d 80 00       	push   $0x805dc5
  803f11:	68 a0 00 00 00       	push   $0xa0
  803f16:	68 2b 5d 80 00       	push   $0x805d2b
  803f1b:	e8 d2 d6 ff ff       	call   8015f2 <_panic>
  803f20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f23:	8b 00                	mov    (%eax),%eax
  803f25:	85 c0                	test   %eax,%eax
  803f27:	74 10                	je     803f39 <alloc_block+0x1b2>
  803f29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f2c:	8b 00                	mov    (%eax),%eax
  803f2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f31:	8b 52 04             	mov    0x4(%edx),%edx
  803f34:	89 50 04             	mov    %edx,0x4(%eax)
  803f37:	eb 0b                	jmp    803f44 <alloc_block+0x1bd>
  803f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f3c:	8b 40 04             	mov    0x4(%eax),%eax
  803f3f:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f47:	8b 40 04             	mov    0x4(%eax),%eax
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	74 0f                	je     803f5d <alloc_block+0x1d6>
  803f4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f51:	8b 40 04             	mov    0x4(%eax),%eax
  803f54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f57:	8b 12                	mov    (%edx),%edx
  803f59:	89 10                	mov    %edx,(%eax)
  803f5b:	eb 0a                	jmp    803f67 <alloc_block+0x1e0>
  803f5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f60:	8b 00                	mov    (%eax),%eax
  803f62:	a3 28 62 80 00       	mov    %eax,0x806228
  803f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f7a:	a1 34 62 80 00       	mov    0x806234,%eax
  803f7f:	48                   	dec    %eax
  803f80:	a3 34 62 80 00       	mov    %eax,0x806234

        page_info_e->block_size = pow;
  803f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f8b:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803f8f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f94:	99                   	cltd   
  803f95:	f7 7d e8             	idivl  -0x18(%ebp)
  803f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f9b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803f9f:	83 ec 0c             	sub    $0xc,%esp
  803fa2:	ff 75 dc             	pushl  -0x24(%ebp)
  803fa5:	e8 ce fa ff ff       	call   803a78 <to_page_va>
  803faa:	83 c4 10             	add    $0x10,%esp
  803fad:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803fb3:	83 ec 0c             	sub    $0xc,%esp
  803fb6:	50                   	push   %eax
  803fb7:	e8 c0 ee ff ff       	call   802e7c <get_page>
  803fbc:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803fbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803fc6:	e9 aa 00 00 00       	jmp    804075 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fce:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803fd2:	89 c2                	mov    %eax,%edx
  803fd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803fd7:	01 d0                	add    %edx,%eax
  803fd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803fdc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803fe0:	75 17                	jne    803ff9 <alloc_block+0x272>
  803fe2:	83 ec 04             	sub    $0x4,%esp
  803fe5:	68 e4 5d 80 00       	push   $0x805de4
  803fea:	68 aa 00 00 00       	push   $0xaa
  803fef:	68 2b 5d 80 00       	push   $0x805d2b
  803ff4:	e8 f9 d5 ff ff       	call   8015f2 <_panic>
  803ff9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffc:	c1 e0 04             	shl    $0x4,%eax
  803fff:	05 64 e2 81 00       	add    $0x81e264,%eax
  804004:	8b 10                	mov    (%eax),%edx
  804006:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804009:	89 50 04             	mov    %edx,0x4(%eax)
  80400c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80400f:	8b 40 04             	mov    0x4(%eax),%eax
  804012:	85 c0                	test   %eax,%eax
  804014:	74 14                	je     80402a <alloc_block+0x2a3>
  804016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804019:	c1 e0 04             	shl    $0x4,%eax
  80401c:	05 64 e2 81 00       	add    $0x81e264,%eax
  804021:	8b 00                	mov    (%eax),%eax
  804023:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804026:	89 10                	mov    %edx,(%eax)
  804028:	eb 11                	jmp    80403b <alloc_block+0x2b4>
  80402a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402d:	c1 e0 04             	shl    $0x4,%eax
  804030:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  804036:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804039:	89 02                	mov    %eax,(%edx)
  80403b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403e:	c1 e0 04             	shl    $0x4,%eax
  804041:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  804047:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80404a:	89 02                	mov    %eax,(%edx)
  80404c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80404f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804058:	c1 e0 04             	shl    $0x4,%eax
  80405b:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804060:	8b 00                	mov    (%eax),%eax
  804062:	8d 50 01             	lea    0x1(%eax),%edx
  804065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804068:	c1 e0 04             	shl    $0x4,%eax
  80406b:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804070:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  804072:	ff 45 f4             	incl   -0xc(%ebp)
  804075:	b8 00 10 00 00       	mov    $0x1000,%eax
  80407a:	99                   	cltd   
  80407b:	f7 7d e8             	idivl  -0x18(%ebp)
  80407e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804081:	0f 8f 44 ff ff ff    	jg     803fcb <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  804087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408a:	c1 e0 04             	shl    $0x4,%eax
  80408d:	05 60 e2 81 00       	add    $0x81e260,%eax
  804092:	8b 00                	mov    (%eax),%eax
  804094:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  804097:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80409b:	75 17                	jne    8040b4 <alloc_block+0x32d>
  80409d:	83 ec 04             	sub    $0x4,%esp
  8040a0:	68 c5 5d 80 00       	push   $0x805dc5
  8040a5:	68 ae 00 00 00       	push   $0xae
  8040aa:	68 2b 5d 80 00       	push   $0x805d2b
  8040af:	e8 3e d5 ff ff       	call   8015f2 <_panic>
  8040b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040b7:	8b 00                	mov    (%eax),%eax
  8040b9:	85 c0                	test   %eax,%eax
  8040bb:	74 10                	je     8040cd <alloc_block+0x346>
  8040bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040c0:	8b 00                	mov    (%eax),%eax
  8040c2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8040c5:	8b 52 04             	mov    0x4(%edx),%edx
  8040c8:	89 50 04             	mov    %edx,0x4(%eax)
  8040cb:	eb 14                	jmp    8040e1 <alloc_block+0x35a>
  8040cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040d0:	8b 40 04             	mov    0x4(%eax),%eax
  8040d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d6:	c1 e2 04             	shl    $0x4,%edx
  8040d9:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8040df:	89 02                	mov    %eax,(%edx)
  8040e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040e4:	8b 40 04             	mov    0x4(%eax),%eax
  8040e7:	85 c0                	test   %eax,%eax
  8040e9:	74 0f                	je     8040fa <alloc_block+0x373>
  8040eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040ee:	8b 40 04             	mov    0x4(%eax),%eax
  8040f1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8040f4:	8b 12                	mov    (%edx),%edx
  8040f6:	89 10                	mov    %edx,(%eax)
  8040f8:	eb 13                	jmp    80410d <alloc_block+0x386>
  8040fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040fd:	8b 00                	mov    (%eax),%eax
  8040ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804102:	c1 e2 04             	shl    $0x4,%edx
  804105:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  80410b:	89 02                	mov    %eax,(%edx)
  80410d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804116:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804119:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804123:	c1 e0 04             	shl    $0x4,%eax
  804126:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80412b:	8b 00                	mov    (%eax),%eax
  80412d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804133:	c1 e0 04             	shl    $0x4,%eax
  804136:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80413b:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80413d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804140:	83 ec 0c             	sub    $0xc,%esp
  804143:	50                   	push   %eax
  804144:	e8 a1 f9 ff ff       	call   803aea <to_page_info>
  804149:	83 c4 10             	add    $0x10,%esp
  80414c:	89 c2                	mov    %eax,%edx
  80414e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  804152:	48                   	dec    %eax
  804153:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  804157:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80415a:	e9 1a 01 00 00       	jmp    804279 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80415f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804162:	40                   	inc    %eax
  804163:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804166:	e9 ed 00 00 00       	jmp    804258 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80416b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80416e:	c1 e0 04             	shl    $0x4,%eax
  804171:	05 60 e2 81 00       	add    $0x81e260,%eax
  804176:	8b 00                	mov    (%eax),%eax
  804178:	85 c0                	test   %eax,%eax
  80417a:	0f 84 d5 00 00 00    	je     804255 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  804180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804183:	c1 e0 04             	shl    $0x4,%eax
  804186:	05 60 e2 81 00       	add    $0x81e260,%eax
  80418b:	8b 00                	mov    (%eax),%eax
  80418d:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  804190:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804194:	75 17                	jne    8041ad <alloc_block+0x426>
  804196:	83 ec 04             	sub    $0x4,%esp
  804199:	68 c5 5d 80 00       	push   $0x805dc5
  80419e:	68 b8 00 00 00       	push   $0xb8
  8041a3:	68 2b 5d 80 00       	push   $0x805d2b
  8041a8:	e8 45 d4 ff ff       	call   8015f2 <_panic>
  8041ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041b0:	8b 00                	mov    (%eax),%eax
  8041b2:	85 c0                	test   %eax,%eax
  8041b4:	74 10                	je     8041c6 <alloc_block+0x43f>
  8041b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041b9:	8b 00                	mov    (%eax),%eax
  8041bb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8041be:	8b 52 04             	mov    0x4(%edx),%edx
  8041c1:	89 50 04             	mov    %edx,0x4(%eax)
  8041c4:	eb 14                	jmp    8041da <alloc_block+0x453>
  8041c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041c9:	8b 40 04             	mov    0x4(%eax),%eax
  8041cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041cf:	c1 e2 04             	shl    $0x4,%edx
  8041d2:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8041d8:	89 02                	mov    %eax,(%edx)
  8041da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041dd:	8b 40 04             	mov    0x4(%eax),%eax
  8041e0:	85 c0                	test   %eax,%eax
  8041e2:	74 0f                	je     8041f3 <alloc_block+0x46c>
  8041e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041e7:	8b 40 04             	mov    0x4(%eax),%eax
  8041ea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8041ed:	8b 12                	mov    (%edx),%edx
  8041ef:	89 10                	mov    %edx,(%eax)
  8041f1:	eb 13                	jmp    804206 <alloc_block+0x47f>
  8041f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041f6:	8b 00                	mov    (%eax),%eax
  8041f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041fb:	c1 e2 04             	shl    $0x4,%edx
  8041fe:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  804204:	89 02                	mov    %eax,(%edx)
  804206:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80420f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804212:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80421c:	c1 e0 04             	shl    $0x4,%eax
  80421f:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804224:	8b 00                	mov    (%eax),%eax
  804226:	8d 50 ff             	lea    -0x1(%eax),%edx
  804229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80422c:	c1 e0 04             	shl    $0x4,%eax
  80422f:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804234:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  804236:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804239:	83 ec 0c             	sub    $0xc,%esp
  80423c:	50                   	push   %eax
  80423d:	e8 a8 f8 ff ff       	call   803aea <to_page_info>
  804242:	83 c4 10             	add    $0x10,%esp
  804245:	89 c2                	mov    %eax,%edx
  804247:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80424b:	48                   	dec    %eax
  80424c:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  804250:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804253:	eb 24                	jmp    804279 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  804255:	ff 45 f0             	incl   -0x10(%ebp)
  804258:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80425c:	0f 8e 09 ff ff ff    	jle    80416b <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  804262:	83 ec 04             	sub    $0x4,%esp
  804265:	68 07 5e 80 00       	push   $0x805e07
  80426a:	68 bf 00 00 00       	push   $0xbf
  80426f:	68 2b 5d 80 00       	push   $0x805d2b
  804274:	e8 79 d3 ff ff       	call   8015f2 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804279:	c9                   	leave  
  80427a:	c3                   	ret    

0080427b <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80427b:	55                   	push   %ebp
  80427c:	89 e5                	mov    %esp,%ebp
  80427e:	83 ec 14             	sub    $0x14,%esp
  804281:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  804284:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804288:	75 07                	jne    804291 <log2_ceil.1520+0x16>
  80428a:	b8 00 00 00 00       	mov    $0x0,%eax
  80428f:	eb 1b                	jmp    8042ac <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  804291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  804298:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80429b:	eb 06                	jmp    8042a3 <log2_ceil.1520+0x28>
            x >>= 1;
  80429d:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8042a0:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8042a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042a7:	75 f4                	jne    80429d <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8042a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8042ac:	c9                   	leave  
  8042ad:	c3                   	ret    

008042ae <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8042ae:	55                   	push   %ebp
  8042af:	89 e5                	mov    %esp,%ebp
  8042b1:	83 ec 14             	sub    $0x14,%esp
  8042b4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8042b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042bb:	75 07                	jne    8042c4 <log2_ceil.1547+0x16>
  8042bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c2:	eb 1b                	jmp    8042df <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8042c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8042cb:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8042ce:	eb 06                	jmp    8042d6 <log2_ceil.1547+0x28>
			x >>= 1;
  8042d0:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8042d3:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8042d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042da:	75 f4                	jne    8042d0 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8042dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8042df:	c9                   	leave  
  8042e0:	c3                   	ret    

008042e1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8042e1:	55                   	push   %ebp
  8042e2:	89 e5                	mov    %esp,%ebp
  8042e4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8042e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8042ea:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8042ef:	39 c2                	cmp    %eax,%edx
  8042f1:	72 0c                	jb     8042ff <free_block+0x1e>
  8042f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8042f6:	a1 20 62 80 00       	mov    0x806220,%eax
  8042fb:	39 c2                	cmp    %eax,%edx
  8042fd:	72 19                	jb     804318 <free_block+0x37>
  8042ff:	68 0c 5e 80 00       	push   $0x805e0c
  804304:	68 8e 5d 80 00       	push   $0x805d8e
  804309:	68 d0 00 00 00       	push   $0xd0
  80430e:	68 2b 5d 80 00       	push   $0x805d2b
  804313:	e8 da d2 ff ff       	call   8015f2 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  804318:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80431c:	0f 84 42 03 00 00    	je     804664 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  804322:	8b 55 08             	mov    0x8(%ebp),%edx
  804325:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80432a:	39 c2                	cmp    %eax,%edx
  80432c:	72 0c                	jb     80433a <free_block+0x59>
  80432e:	8b 55 08             	mov    0x8(%ebp),%edx
  804331:	a1 20 62 80 00       	mov    0x806220,%eax
  804336:	39 c2                	cmp    %eax,%edx
  804338:	72 17                	jb     804351 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80433a:	83 ec 04             	sub    $0x4,%esp
  80433d:	68 44 5e 80 00       	push   $0x805e44
  804342:	68 e6 00 00 00       	push   $0xe6
  804347:	68 2b 5d 80 00       	push   $0x805d2b
  80434c:	e8 a1 d2 ff ff       	call   8015f2 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  804351:	8b 55 08             	mov    0x8(%ebp),%edx
  804354:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804359:	29 c2                	sub    %eax,%edx
  80435b:	89 d0                	mov    %edx,%eax
  80435d:	83 e0 07             	and    $0x7,%eax
  804360:	85 c0                	test   %eax,%eax
  804362:	74 17                	je     80437b <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  804364:	83 ec 04             	sub    $0x4,%esp
  804367:	68 78 5e 80 00       	push   $0x805e78
  80436c:	68 ea 00 00 00       	push   $0xea
  804371:	68 2b 5d 80 00       	push   $0x805d2b
  804376:	e8 77 d2 ff ff       	call   8015f2 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80437b:	8b 45 08             	mov    0x8(%ebp),%eax
  80437e:	83 ec 0c             	sub    $0xc,%esp
  804381:	50                   	push   %eax
  804382:	e8 63 f7 ff ff       	call   803aea <to_page_info>
  804387:	83 c4 10             	add    $0x10,%esp
  80438a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80438d:	83 ec 0c             	sub    $0xc,%esp
  804390:	ff 75 08             	pushl  0x8(%ebp)
  804393:	e8 87 f9 ff ff       	call   803d1f <get_block_size>
  804398:	83 c4 10             	add    $0x10,%esp
  80439b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80439e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8043a2:	75 17                	jne    8043bb <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8043a4:	83 ec 04             	sub    $0x4,%esp
  8043a7:	68 a4 5e 80 00       	push   $0x805ea4
  8043ac:	68 f1 00 00 00       	push   $0xf1
  8043b1:	68 2b 5d 80 00       	push   $0x805d2b
  8043b6:	e8 37 d2 ff ff       	call   8015f2 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8043bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8043be:	83 ec 0c             	sub    $0xc,%esp
  8043c1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8043c4:	52                   	push   %edx
  8043c5:	89 c1                	mov    %eax,%ecx
  8043c7:	e8 e2 fe ff ff       	call   8042ae <log2_ceil.1547>
  8043cc:	83 c4 10             	add    $0x10,%esp
  8043cf:	83 e8 03             	sub    $0x3,%eax
  8043d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8043d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8043d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8043db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8043df:	75 17                	jne    8043f8 <free_block+0x117>
  8043e1:	83 ec 04             	sub    $0x4,%esp
  8043e4:	68 f0 5e 80 00       	push   $0x805ef0
  8043e9:	68 f6 00 00 00       	push   $0xf6
  8043ee:	68 2b 5d 80 00       	push   $0x805d2b
  8043f3:	e8 fa d1 ff ff       	call   8015f2 <_panic>
  8043f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043fb:	c1 e0 04             	shl    $0x4,%eax
  8043fe:	05 60 e2 81 00       	add    $0x81e260,%eax
  804403:	8b 10                	mov    (%eax),%edx
  804405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804408:	89 10                	mov    %edx,(%eax)
  80440a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80440d:	8b 00                	mov    (%eax),%eax
  80440f:	85 c0                	test   %eax,%eax
  804411:	74 15                	je     804428 <free_block+0x147>
  804413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804416:	c1 e0 04             	shl    $0x4,%eax
  804419:	05 60 e2 81 00       	add    $0x81e260,%eax
  80441e:	8b 00                	mov    (%eax),%eax
  804420:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804423:	89 50 04             	mov    %edx,0x4(%eax)
  804426:	eb 11                	jmp    804439 <free_block+0x158>
  804428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80442b:	c1 e0 04             	shl    $0x4,%eax
  80442e:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  804434:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804437:	89 02                	mov    %eax,(%edx)
  804439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80443c:	c1 e0 04             	shl    $0x4,%eax
  80443f:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  804445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804448:	89 02                	mov    %eax,(%edx)
  80444a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80444d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804457:	c1 e0 04             	shl    $0x4,%eax
  80445a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80445f:	8b 00                	mov    (%eax),%eax
  804461:	8d 50 01             	lea    0x1(%eax),%edx
  804464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804467:	c1 e0 04             	shl    $0x4,%eax
  80446a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80446f:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  804471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804474:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804478:	40                   	inc    %eax
  804479:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80447c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  804480:	8b 55 08             	mov    0x8(%ebp),%edx
  804483:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804488:	29 c2                	sub    %eax,%edx
  80448a:	89 d0                	mov    %edx,%eax
  80448c:	c1 e8 0c             	shr    $0xc,%eax
  80448f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  804492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804495:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804499:	0f b7 c8             	movzwl %ax,%ecx
  80449c:	b8 00 10 00 00       	mov    $0x1000,%eax
  8044a1:	99                   	cltd   
  8044a2:	f7 7d e8             	idivl  -0x18(%ebp)
  8044a5:	39 c1                	cmp    %eax,%ecx
  8044a7:	0f 85 b8 01 00 00    	jne    804665 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8044ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8044b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044b7:	c1 e0 04             	shl    $0x4,%eax
  8044ba:	05 60 e2 81 00       	add    $0x81e260,%eax
  8044bf:	8b 00                	mov    (%eax),%eax
  8044c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8044c4:	e9 d5 00 00 00       	jmp    80459e <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8044c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044cc:	8b 00                	mov    (%eax),%eax
  8044ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8044d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044d4:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8044d9:	29 c2                	sub    %eax,%edx
  8044db:	89 d0                	mov    %edx,%eax
  8044dd:	c1 e8 0c             	shr    $0xc,%eax
  8044e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8044e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044e6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8044e9:	0f 85 a9 00 00 00    	jne    804598 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8044ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044f3:	75 17                	jne    80450c <free_block+0x22b>
  8044f5:	83 ec 04             	sub    $0x4,%esp
  8044f8:	68 c5 5d 80 00       	push   $0x805dc5
  8044fd:	68 04 01 00 00       	push   $0x104
  804502:	68 2b 5d 80 00       	push   $0x805d2b
  804507:	e8 e6 d0 ff ff       	call   8015f2 <_panic>
  80450c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80450f:	8b 00                	mov    (%eax),%eax
  804511:	85 c0                	test   %eax,%eax
  804513:	74 10                	je     804525 <free_block+0x244>
  804515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804518:	8b 00                	mov    (%eax),%eax
  80451a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80451d:	8b 52 04             	mov    0x4(%edx),%edx
  804520:	89 50 04             	mov    %edx,0x4(%eax)
  804523:	eb 14                	jmp    804539 <free_block+0x258>
  804525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804528:	8b 40 04             	mov    0x4(%eax),%eax
  80452b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80452e:	c1 e2 04             	shl    $0x4,%edx
  804531:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  804537:	89 02                	mov    %eax,(%edx)
  804539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80453c:	8b 40 04             	mov    0x4(%eax),%eax
  80453f:	85 c0                	test   %eax,%eax
  804541:	74 0f                	je     804552 <free_block+0x271>
  804543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804546:	8b 40 04             	mov    0x4(%eax),%eax
  804549:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80454c:	8b 12                	mov    (%edx),%edx
  80454e:	89 10                	mov    %edx,(%eax)
  804550:	eb 13                	jmp    804565 <free_block+0x284>
  804552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804555:	8b 00                	mov    (%eax),%eax
  804557:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80455a:	c1 e2 04             	shl    $0x4,%edx
  80455d:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  804563:	89 02                	mov    %eax,(%edx)
  804565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80456e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804571:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80457b:	c1 e0 04             	shl    $0x4,%eax
  80457e:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804583:	8b 00                	mov    (%eax),%eax
  804585:	8d 50 ff             	lea    -0x1(%eax),%edx
  804588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80458b:	c1 e0 04             	shl    $0x4,%eax
  80458e:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804593:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804595:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804598:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80459b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80459e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8045a2:	0f 85 21 ff ff ff    	jne    8044c9 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8045a8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8045ad:	99                   	cltd   
  8045ae:	f7 7d e8             	idivl  -0x18(%ebp)
  8045b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8045b4:	74 17                	je     8045cd <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8045b6:	83 ec 04             	sub    $0x4,%esp
  8045b9:	68 14 5f 80 00       	push   $0x805f14
  8045be:	68 0c 01 00 00       	push   $0x10c
  8045c3:	68 2b 5d 80 00       	push   $0x805d2b
  8045c8:	e8 25 d0 ff ff       	call   8015f2 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8045cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045d0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8045d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045d9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8045df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8045e3:	75 17                	jne    8045fc <free_block+0x31b>
  8045e5:	83 ec 04             	sub    $0x4,%esp
  8045e8:	68 e4 5d 80 00       	push   $0x805de4
  8045ed:	68 11 01 00 00       	push   $0x111
  8045f2:	68 2b 5d 80 00       	push   $0x805d2b
  8045f7:	e8 f6 cf ff ff       	call   8015f2 <_panic>
  8045fc:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  804602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804605:	89 50 04             	mov    %edx,0x4(%eax)
  804608:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80460b:	8b 40 04             	mov    0x4(%eax),%eax
  80460e:	85 c0                	test   %eax,%eax
  804610:	74 0c                	je     80461e <free_block+0x33d>
  804612:	a1 2c 62 80 00       	mov    0x80622c,%eax
  804617:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80461a:	89 10                	mov    %edx,(%eax)
  80461c:	eb 08                	jmp    804626 <free_block+0x345>
  80461e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804621:	a3 28 62 80 00       	mov    %eax,0x806228
  804626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804629:	a3 2c 62 80 00       	mov    %eax,0x80622c
  80462e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804637:	a1 34 62 80 00       	mov    0x806234,%eax
  80463c:	40                   	inc    %eax
  80463d:	a3 34 62 80 00       	mov    %eax,0x806234

        uint32 pp = to_page_va(page_info_e);
  804642:	83 ec 0c             	sub    $0xc,%esp
  804645:	ff 75 ec             	pushl  -0x14(%ebp)
  804648:	e8 2b f4 ff ff       	call   803a78 <to_page_va>
  80464d:	83 c4 10             	add    $0x10,%esp
  804650:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  804653:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804656:	83 ec 0c             	sub    $0xc,%esp
  804659:	50                   	push   %eax
  80465a:	e8 69 e8 ff ff       	call   802ec8 <return_page>
  80465f:	83 c4 10             	add    $0x10,%esp
  804662:	eb 01                	jmp    804665 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  804664:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804665:	c9                   	leave  
  804666:	c3                   	ret    

00804667 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  804667:	55                   	push   %ebp
  804668:	89 e5                	mov    %esp,%ebp
  80466a:	83 ec 14             	sub    $0x14,%esp
  80466d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  804670:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804674:	77 07                	ja     80467d <nearest_pow2_ceil.1572+0x16>
      return 1;
  804676:	b8 01 00 00 00       	mov    $0x1,%eax
  80467b:	eb 20                	jmp    80469d <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80467d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  804684:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  804687:	eb 08                	jmp    804691 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  804689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80468c:	01 c0                	add    %eax,%eax
  80468e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  804691:	d1 6d 08             	shrl   0x8(%ebp)
  804694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804698:	75 ef                	jne    804689 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80469a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80469d:	c9                   	leave  
  80469e:	c3                   	ret    

0080469f <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80469f:	55                   	push   %ebp
  8046a0:	89 e5                	mov    %esp,%ebp
  8046a2:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8046a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8046a9:	75 13                	jne    8046be <realloc_block+0x1f>
    return alloc_block(new_size);
  8046ab:	83 ec 0c             	sub    $0xc,%esp
  8046ae:	ff 75 0c             	pushl  0xc(%ebp)
  8046b1:	e8 d1 f6 ff ff       	call   803d87 <alloc_block>
  8046b6:	83 c4 10             	add    $0x10,%esp
  8046b9:	e9 d9 00 00 00       	jmp    804797 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8046be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8046c2:	75 18                	jne    8046dc <realloc_block+0x3d>
    free_block(va);
  8046c4:	83 ec 0c             	sub    $0xc,%esp
  8046c7:	ff 75 08             	pushl  0x8(%ebp)
  8046ca:	e8 12 fc ff ff       	call   8042e1 <free_block>
  8046cf:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8046d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d7:	e9 bb 00 00 00       	jmp    804797 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8046dc:	83 ec 0c             	sub    $0xc,%esp
  8046df:	ff 75 08             	pushl  0x8(%ebp)
  8046e2:	e8 38 f6 ff ff       	call   803d1f <get_block_size>
  8046e7:	83 c4 10             	add    $0x10,%esp
  8046ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8046ed:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8046f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8046fa:	73 06                	jae    804702 <realloc_block+0x63>
    new_size = min_block_size;
  8046fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046ff:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  804702:	83 ec 0c             	sub    $0xc,%esp
  804705:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804708:	ff 75 0c             	pushl  0xc(%ebp)
  80470b:	89 c1                	mov    %eax,%ecx
  80470d:	e8 55 ff ff ff       	call   804667 <nearest_pow2_ceil.1572>
  804712:	83 c4 10             	add    $0x10,%esp
  804715:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  804718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80471b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80471e:	75 05                	jne    804725 <realloc_block+0x86>
    return va;
  804720:	8b 45 08             	mov    0x8(%ebp),%eax
  804723:	eb 72                	jmp    804797 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  804725:	83 ec 0c             	sub    $0xc,%esp
  804728:	ff 75 0c             	pushl  0xc(%ebp)
  80472b:	e8 57 f6 ff ff       	call   803d87 <alloc_block>
  804730:	83 c4 10             	add    $0x10,%esp
  804733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  804736:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80473a:	75 07                	jne    804743 <realloc_block+0xa4>
    return NULL;
  80473c:	b8 00 00 00 00       	mov    $0x0,%eax
  804741:	eb 54                	jmp    804797 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  804743:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804746:	8b 45 0c             	mov    0xc(%ebp),%eax
  804749:	39 d0                	cmp    %edx,%eax
  80474b:	76 02                	jbe    80474f <realloc_block+0xb0>
  80474d:	89 d0                	mov    %edx,%eax
  80474f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  804752:	8b 45 08             	mov    0x8(%ebp),%eax
  804755:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  804758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80475b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  80475e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804765:	eb 17                	jmp    80477e <realloc_block+0xdf>
    dst[i] = src[i];
  804767:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80476a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80476d:	01 c2                	add    %eax,%edx
  80476f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  804772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804775:	01 c8                	add    %ecx,%eax
  804777:	8a 00                	mov    (%eax),%al
  804779:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80477b:	ff 45 f4             	incl   -0xc(%ebp)
  80477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804781:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804784:	72 e1                	jb     804767 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  804786:	83 ec 0c             	sub    $0xc,%esp
  804789:	ff 75 08             	pushl  0x8(%ebp)
  80478c:	e8 50 fb ff ff       	call   8042e1 <free_block>
  804791:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  804797:	c9                   	leave  
  804798:	c3                   	ret    

00804799 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804799:	55                   	push   %ebp
  80479a:	89 e5                	mov    %esp,%ebp
  80479c:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80479f:	8b 55 08             	mov    0x8(%ebp),%edx
  8047a2:	89 d0                	mov    %edx,%eax
  8047a4:	c1 e0 02             	shl    $0x2,%eax
  8047a7:	01 d0                	add    %edx,%eax
  8047a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8047b0:	01 d0                	add    %edx,%eax
  8047b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8047b9:	01 d0                	add    %edx,%eax
  8047bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8047c2:	01 d0                	add    %edx,%eax
  8047c4:	c1 e0 04             	shl    $0x4,%eax
  8047c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8047ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8047d1:	0f 31                	rdtsc  
  8047d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8047d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8047d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8047df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8047e2:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8047e5:	eb 46                	jmp    80482d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8047e7:	0f 31                	rdtsc  
  8047e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8047ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8047ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8047f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8047f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8047f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8047fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8047fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804801:	29 c2                	sub    %eax,%edx
  804803:	89 d0                	mov    %edx,%eax
  804805:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80480b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80480e:	89 d1                	mov    %edx,%ecx
  804810:	29 c1                	sub    %eax,%ecx
  804812:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804818:	39 c2                	cmp    %eax,%edx
  80481a:	0f 97 c0             	seta   %al
  80481d:	0f b6 c0             	movzbl %al,%eax
  804820:	29 c1                	sub    %eax,%ecx
  804822:	89 c8                	mov    %ecx,%eax
  804824:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804827:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80482a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80482d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804833:	72 b2                	jb     8047e7 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804835:	90                   	nop
  804836:	c9                   	leave  
  804837:	c3                   	ret    

00804838 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804838:	55                   	push   %ebp
  804839:	89 e5                	mov    %esp,%ebp
  80483b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80483e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804845:	eb 03                	jmp    80484a <busy_wait+0x12>
  804847:	ff 45 fc             	incl   -0x4(%ebp)
  80484a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80484d:	3b 45 08             	cmp    0x8(%ebp),%eax
  804850:	72 f5                	jb     804847 <busy_wait+0xf>
	return i;
  804852:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804855:	c9                   	leave  
  804856:	c3                   	ret    
  804857:	90                   	nop

00804858 <__udivdi3>:
  804858:	55                   	push   %ebp
  804859:	57                   	push   %edi
  80485a:	56                   	push   %esi
  80485b:	53                   	push   %ebx
  80485c:	83 ec 1c             	sub    $0x1c,%esp
  80485f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804863:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80486b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80486f:	89 ca                	mov    %ecx,%edx
  804871:	89 f8                	mov    %edi,%eax
  804873:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804877:	85 f6                	test   %esi,%esi
  804879:	75 2d                	jne    8048a8 <__udivdi3+0x50>
  80487b:	39 cf                	cmp    %ecx,%edi
  80487d:	77 65                	ja     8048e4 <__udivdi3+0x8c>
  80487f:	89 fd                	mov    %edi,%ebp
  804881:	85 ff                	test   %edi,%edi
  804883:	75 0b                	jne    804890 <__udivdi3+0x38>
  804885:	b8 01 00 00 00       	mov    $0x1,%eax
  80488a:	31 d2                	xor    %edx,%edx
  80488c:	f7 f7                	div    %edi
  80488e:	89 c5                	mov    %eax,%ebp
  804890:	31 d2                	xor    %edx,%edx
  804892:	89 c8                	mov    %ecx,%eax
  804894:	f7 f5                	div    %ebp
  804896:	89 c1                	mov    %eax,%ecx
  804898:	89 d8                	mov    %ebx,%eax
  80489a:	f7 f5                	div    %ebp
  80489c:	89 cf                	mov    %ecx,%edi
  80489e:	89 fa                	mov    %edi,%edx
  8048a0:	83 c4 1c             	add    $0x1c,%esp
  8048a3:	5b                   	pop    %ebx
  8048a4:	5e                   	pop    %esi
  8048a5:	5f                   	pop    %edi
  8048a6:	5d                   	pop    %ebp
  8048a7:	c3                   	ret    
  8048a8:	39 ce                	cmp    %ecx,%esi
  8048aa:	77 28                	ja     8048d4 <__udivdi3+0x7c>
  8048ac:	0f bd fe             	bsr    %esi,%edi
  8048af:	83 f7 1f             	xor    $0x1f,%edi
  8048b2:	75 40                	jne    8048f4 <__udivdi3+0x9c>
  8048b4:	39 ce                	cmp    %ecx,%esi
  8048b6:	72 0a                	jb     8048c2 <__udivdi3+0x6a>
  8048b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8048bc:	0f 87 9e 00 00 00    	ja     804960 <__udivdi3+0x108>
  8048c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8048c7:	89 fa                	mov    %edi,%edx
  8048c9:	83 c4 1c             	add    $0x1c,%esp
  8048cc:	5b                   	pop    %ebx
  8048cd:	5e                   	pop    %esi
  8048ce:	5f                   	pop    %edi
  8048cf:	5d                   	pop    %ebp
  8048d0:	c3                   	ret    
  8048d1:	8d 76 00             	lea    0x0(%esi),%esi
  8048d4:	31 ff                	xor    %edi,%edi
  8048d6:	31 c0                	xor    %eax,%eax
  8048d8:	89 fa                	mov    %edi,%edx
  8048da:	83 c4 1c             	add    $0x1c,%esp
  8048dd:	5b                   	pop    %ebx
  8048de:	5e                   	pop    %esi
  8048df:	5f                   	pop    %edi
  8048e0:	5d                   	pop    %ebp
  8048e1:	c3                   	ret    
  8048e2:	66 90                	xchg   %ax,%ax
  8048e4:	89 d8                	mov    %ebx,%eax
  8048e6:	f7 f7                	div    %edi
  8048e8:	31 ff                	xor    %edi,%edi
  8048ea:	89 fa                	mov    %edi,%edx
  8048ec:	83 c4 1c             	add    $0x1c,%esp
  8048ef:	5b                   	pop    %ebx
  8048f0:	5e                   	pop    %esi
  8048f1:	5f                   	pop    %edi
  8048f2:	5d                   	pop    %ebp
  8048f3:	c3                   	ret    
  8048f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8048f9:	89 eb                	mov    %ebp,%ebx
  8048fb:	29 fb                	sub    %edi,%ebx
  8048fd:	89 f9                	mov    %edi,%ecx
  8048ff:	d3 e6                	shl    %cl,%esi
  804901:	89 c5                	mov    %eax,%ebp
  804903:	88 d9                	mov    %bl,%cl
  804905:	d3 ed                	shr    %cl,%ebp
  804907:	89 e9                	mov    %ebp,%ecx
  804909:	09 f1                	or     %esi,%ecx
  80490b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80490f:	89 f9                	mov    %edi,%ecx
  804911:	d3 e0                	shl    %cl,%eax
  804913:	89 c5                	mov    %eax,%ebp
  804915:	89 d6                	mov    %edx,%esi
  804917:	88 d9                	mov    %bl,%cl
  804919:	d3 ee                	shr    %cl,%esi
  80491b:	89 f9                	mov    %edi,%ecx
  80491d:	d3 e2                	shl    %cl,%edx
  80491f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804923:	88 d9                	mov    %bl,%cl
  804925:	d3 e8                	shr    %cl,%eax
  804927:	09 c2                	or     %eax,%edx
  804929:	89 d0                	mov    %edx,%eax
  80492b:	89 f2                	mov    %esi,%edx
  80492d:	f7 74 24 0c          	divl   0xc(%esp)
  804931:	89 d6                	mov    %edx,%esi
  804933:	89 c3                	mov    %eax,%ebx
  804935:	f7 e5                	mul    %ebp
  804937:	39 d6                	cmp    %edx,%esi
  804939:	72 19                	jb     804954 <__udivdi3+0xfc>
  80493b:	74 0b                	je     804948 <__udivdi3+0xf0>
  80493d:	89 d8                	mov    %ebx,%eax
  80493f:	31 ff                	xor    %edi,%edi
  804941:	e9 58 ff ff ff       	jmp    80489e <__udivdi3+0x46>
  804946:	66 90                	xchg   %ax,%ax
  804948:	8b 54 24 08          	mov    0x8(%esp),%edx
  80494c:	89 f9                	mov    %edi,%ecx
  80494e:	d3 e2                	shl    %cl,%edx
  804950:	39 c2                	cmp    %eax,%edx
  804952:	73 e9                	jae    80493d <__udivdi3+0xe5>
  804954:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804957:	31 ff                	xor    %edi,%edi
  804959:	e9 40 ff ff ff       	jmp    80489e <__udivdi3+0x46>
  80495e:	66 90                	xchg   %ax,%ax
  804960:	31 c0                	xor    %eax,%eax
  804962:	e9 37 ff ff ff       	jmp    80489e <__udivdi3+0x46>
  804967:	90                   	nop

00804968 <__umoddi3>:
  804968:	55                   	push   %ebp
  804969:	57                   	push   %edi
  80496a:	56                   	push   %esi
  80496b:	53                   	push   %ebx
  80496c:	83 ec 1c             	sub    $0x1c,%esp
  80496f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804973:	8b 74 24 34          	mov    0x34(%esp),%esi
  804977:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80497b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80497f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804983:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804987:	89 f3                	mov    %esi,%ebx
  804989:	89 fa                	mov    %edi,%edx
  80498b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80498f:	89 34 24             	mov    %esi,(%esp)
  804992:	85 c0                	test   %eax,%eax
  804994:	75 1a                	jne    8049b0 <__umoddi3+0x48>
  804996:	39 f7                	cmp    %esi,%edi
  804998:	0f 86 a2 00 00 00    	jbe    804a40 <__umoddi3+0xd8>
  80499e:	89 c8                	mov    %ecx,%eax
  8049a0:	89 f2                	mov    %esi,%edx
  8049a2:	f7 f7                	div    %edi
  8049a4:	89 d0                	mov    %edx,%eax
  8049a6:	31 d2                	xor    %edx,%edx
  8049a8:	83 c4 1c             	add    $0x1c,%esp
  8049ab:	5b                   	pop    %ebx
  8049ac:	5e                   	pop    %esi
  8049ad:	5f                   	pop    %edi
  8049ae:	5d                   	pop    %ebp
  8049af:	c3                   	ret    
  8049b0:	39 f0                	cmp    %esi,%eax
  8049b2:	0f 87 ac 00 00 00    	ja     804a64 <__umoddi3+0xfc>
  8049b8:	0f bd e8             	bsr    %eax,%ebp
  8049bb:	83 f5 1f             	xor    $0x1f,%ebp
  8049be:	0f 84 ac 00 00 00    	je     804a70 <__umoddi3+0x108>
  8049c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8049c9:	29 ef                	sub    %ebp,%edi
  8049cb:	89 fe                	mov    %edi,%esi
  8049cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8049d1:	89 e9                	mov    %ebp,%ecx
  8049d3:	d3 e0                	shl    %cl,%eax
  8049d5:	89 d7                	mov    %edx,%edi
  8049d7:	89 f1                	mov    %esi,%ecx
  8049d9:	d3 ef                	shr    %cl,%edi
  8049db:	09 c7                	or     %eax,%edi
  8049dd:	89 e9                	mov    %ebp,%ecx
  8049df:	d3 e2                	shl    %cl,%edx
  8049e1:	89 14 24             	mov    %edx,(%esp)
  8049e4:	89 d8                	mov    %ebx,%eax
  8049e6:	d3 e0                	shl    %cl,%eax
  8049e8:	89 c2                	mov    %eax,%edx
  8049ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049ee:	d3 e0                	shl    %cl,%eax
  8049f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8049f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049f8:	89 f1                	mov    %esi,%ecx
  8049fa:	d3 e8                	shr    %cl,%eax
  8049fc:	09 d0                	or     %edx,%eax
  8049fe:	d3 eb                	shr    %cl,%ebx
  804a00:	89 da                	mov    %ebx,%edx
  804a02:	f7 f7                	div    %edi
  804a04:	89 d3                	mov    %edx,%ebx
  804a06:	f7 24 24             	mull   (%esp)
  804a09:	89 c6                	mov    %eax,%esi
  804a0b:	89 d1                	mov    %edx,%ecx
  804a0d:	39 d3                	cmp    %edx,%ebx
  804a0f:	0f 82 87 00 00 00    	jb     804a9c <__umoddi3+0x134>
  804a15:	0f 84 91 00 00 00    	je     804aac <__umoddi3+0x144>
  804a1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  804a1f:	29 f2                	sub    %esi,%edx
  804a21:	19 cb                	sbb    %ecx,%ebx
  804a23:	89 d8                	mov    %ebx,%eax
  804a25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804a29:	d3 e0                	shl    %cl,%eax
  804a2b:	89 e9                	mov    %ebp,%ecx
  804a2d:	d3 ea                	shr    %cl,%edx
  804a2f:	09 d0                	or     %edx,%eax
  804a31:	89 e9                	mov    %ebp,%ecx
  804a33:	d3 eb                	shr    %cl,%ebx
  804a35:	89 da                	mov    %ebx,%edx
  804a37:	83 c4 1c             	add    $0x1c,%esp
  804a3a:	5b                   	pop    %ebx
  804a3b:	5e                   	pop    %esi
  804a3c:	5f                   	pop    %edi
  804a3d:	5d                   	pop    %ebp
  804a3e:	c3                   	ret    
  804a3f:	90                   	nop
  804a40:	89 fd                	mov    %edi,%ebp
  804a42:	85 ff                	test   %edi,%edi
  804a44:	75 0b                	jne    804a51 <__umoddi3+0xe9>
  804a46:	b8 01 00 00 00       	mov    $0x1,%eax
  804a4b:	31 d2                	xor    %edx,%edx
  804a4d:	f7 f7                	div    %edi
  804a4f:	89 c5                	mov    %eax,%ebp
  804a51:	89 f0                	mov    %esi,%eax
  804a53:	31 d2                	xor    %edx,%edx
  804a55:	f7 f5                	div    %ebp
  804a57:	89 c8                	mov    %ecx,%eax
  804a59:	f7 f5                	div    %ebp
  804a5b:	89 d0                	mov    %edx,%eax
  804a5d:	e9 44 ff ff ff       	jmp    8049a6 <__umoddi3+0x3e>
  804a62:	66 90                	xchg   %ax,%ax
  804a64:	89 c8                	mov    %ecx,%eax
  804a66:	89 f2                	mov    %esi,%edx
  804a68:	83 c4 1c             	add    $0x1c,%esp
  804a6b:	5b                   	pop    %ebx
  804a6c:	5e                   	pop    %esi
  804a6d:	5f                   	pop    %edi
  804a6e:	5d                   	pop    %ebp
  804a6f:	c3                   	ret    
  804a70:	3b 04 24             	cmp    (%esp),%eax
  804a73:	72 06                	jb     804a7b <__umoddi3+0x113>
  804a75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804a79:	77 0f                	ja     804a8a <__umoddi3+0x122>
  804a7b:	89 f2                	mov    %esi,%edx
  804a7d:	29 f9                	sub    %edi,%ecx
  804a7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804a83:	89 14 24             	mov    %edx,(%esp)
  804a86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804a8e:	8b 14 24             	mov    (%esp),%edx
  804a91:	83 c4 1c             	add    $0x1c,%esp
  804a94:	5b                   	pop    %ebx
  804a95:	5e                   	pop    %esi
  804a96:	5f                   	pop    %edi
  804a97:	5d                   	pop    %ebp
  804a98:	c3                   	ret    
  804a99:	8d 76 00             	lea    0x0(%esi),%esi
  804a9c:	2b 04 24             	sub    (%esp),%eax
  804a9f:	19 fa                	sbb    %edi,%edx
  804aa1:	89 d1                	mov    %edx,%ecx
  804aa3:	89 c6                	mov    %eax,%esi
  804aa5:	e9 71 ff ff ff       	jmp    804a1b <__umoddi3+0xb3>
  804aaa:	66 90                	xchg   %ax,%ax
  804aac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804ab0:	72 ea                	jb     804a9c <__umoddi3+0x134>
  804ab2:	89 d9                	mov    %ebx,%ecx
  804ab4:	e9 62 ff ff ff       	jmp    804a1b <__umoddi3+0xb3>
