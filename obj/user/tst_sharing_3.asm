
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 c4 13 00 00       	call   8013fa <libmain>
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
  800067:	e8 38 35 00 00       	call   8035a4 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 7b 35 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char *byteArr;

	//Allocate the required size
	requestedSizes[index] = size ;
  800077:	8b 45 08             	mov    0x8(%ebp),%eax
  80007a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80007d:	89 14 85 60 71 80 00 	mov    %edx,0x807160(,%eax,4)
	uint32 expectedNumOfFrames = ROUNDUP(requestedSizes[index], PAGE_SIZE) / PAGE_SIZE ;
  800084:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80008b:	8b 45 08             	mov    0x8(%ebp),%eax
  80008e:	8b 14 85 60 71 80 00 	mov    0x807160(,%eax,4),%edx
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
  8000b7:	8b 04 85 60 71 80 00 	mov    0x807160(,%eax,4),%eax
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	50                   	push   %eax
  8000c2:	e8 fc 2d 00 00       	call   802ec3 <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	89 c2                	mov    %eax,%edx
  8000cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cf:	89 14 85 20 70 80 00 	mov    %edx,0x807020(,%eax,4)
	}

	//Check allocation in RAM & Page File
	expectedNumOfFrames = expectedNumOfTables ;
  8000d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8000dc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000df:	e8 c0 34 00 00       	call   8035a4 <sys_calculate_free_frames>
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
  800125:	68 c0 49 80 00       	push   $0x8049c0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 94 17 00 00       	call   8018c5 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 b6 34 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 3c 4a 80 00       	push   $0x804a3c
  800150:	6a 0c                	push   $0xc
  800152:	e8 6e 17 00 00       	call   8018c5 <cprintf_colored>
  800157:	83 c4 10             	add    $0x10,%esp

	lastIndices[index] = (size)/sizeof(char) - 1;
  80015a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015d:	48                   	dec    %eax
  80015e:	89 c2                	mov    %eax,%edx
  800160:	8b 45 08             	mov    0x8(%ebp),%eax
  800163:	89 14 85 c0 70 80 00 	mov    %edx,0x8070c0(,%eax,4)
	if (writeData)
  80016a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80016e:	0f 84 25 01 00 00    	je     800299 <allocSpaceInPageAlloc+0x240>
	{
		//Write in first & last pages
		freeFrames = sys_calculate_free_frames() ;
  800174:	e8 2b 34 00 00       	call   8035a4 <sys_calculate_free_frames>
  800179:	89 45 ec             	mov    %eax,-0x14(%ebp)
		byteArr = (char *) ptr_allocations[index];
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800186:	89 45 d8             	mov    %eax,-0x28(%ebp)
		byteArr[0] = maxByte ;
  800189:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018c:	c6 00 7f             	movb   $0x7f,(%eax)
		byteArr[lastIndices[index]] = maxByte ;
  80018f:	8b 45 08             	mov    0x8(%ebp),%eax
  800192:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
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
  8001b9:	e8 e6 33 00 00       	call   8035a4 <sys_calculate_free_frames>
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
  8001f8:	68 b4 4a 80 00       	push   $0x804ab4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 c1 16 00 00       	call   8018c5 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 e3 33 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 40 4b 80 00       	push   $0x804b40
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 94 16 00 00       	call   8018c5 <cprintf_colored>
  800231:	83 c4 10             	add    $0x10,%esp

		//Check WS
		uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800242:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
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
  800270:	e8 f1 36 00 00       	call   803966 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 b8 4b 80 00       	push   $0x804bb8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 2f 16 00 00       	call   8018c5 <cprintf_colored>
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
  8002ae:	e8 f1 32 00 00       	call   8035a4 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 34 33 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 76 2d 00 00       	call   803047 <free>
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
  8002eb:	8b 04 85 60 71 80 00 	mov    0x807160(,%eax,4),%eax
  8002f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8002f7:	76 03                	jbe    8002fc <freeSpaceInPageAlloc+0x5b>
			expectedNumOfFrames++ ;
  8002f9:	ff 45 f0             	incl   -0x10(%ebp)
	}
	//Check allocation in RAM & Page File
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8002fc:	e8 ee 32 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 f0 4b 80 00       	push   $0x804bf0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 a6 15 00 00       	call   8018c5 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 7d 32 00 00       	call   8035a4 <sys_calculate_free_frames>
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
  80035f:	68 3c 4c 80 00       	push   $0x804c3c
  800364:	6a 0c                	push   $0xc
  800366:	e8 5a 15 00 00       	call   8018c5 <cprintf_colored>
  80036b:	83 c4 10             	add    $0x10,%esp

	if (isDataWritten)
  80036e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800372:	74 72                	je     8003e6 <freeSpaceInPageAlloc+0x145>
	{
		//Check WS
		char* byteArr = (char *) ptr_allocations[index];
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80037e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndices[index]])), PAGE_SIZE)} ;
  800381:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800384:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800387:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
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
  8003bd:	e8 a4 35 00 00       	call   803966 <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 98 4c 80 00       	push   $0x804c98
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 e2 14 00 00       	call   8018c5 <cprintf_colored>
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
  800418:	c7 05 40 f2 81 00 00 	movl   $0x0,0x81f240
  80041f:	00 00 00 

	int eval = 0;
  800422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  800429:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n	1.1 Create some areas in PAGE allocators\n");
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	68 d0 4c 80 00       	push   $0x804cd0
  800438:	6a 03                	push   $0x3
  80043a:	e8 86 14 00 00       	call   8018c5 <cprintf_colored>
  80043f:	83 c4 10             	add    $0x10,%esp
	{
		//4 MB
		allocIndex = 0;
  800442:	c7 05 4c f2 81 00 00 	movl   $0x0,0x81f24c
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
  80049e:	a1 40 f2 81 00       	mov    0x81f240,%eax
  8004a3:	01 d0                	add    %edx,%eax
  8004a5:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 2;
  8004aa:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8004b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004b4:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8004b9:	52                   	push   %edx
  8004ba:	6a 01                	push   $0x1
  8004bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8004bf:	50                   	push   %eax
  8004c0:	e8 94 fb ff ff       	call   800059 <allocSpaceInPageAlloc>
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8004cb:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8004d0:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8004d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8004da:	74 2f                	je     80050b <initial_page_allocations+0x120>
  8004dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004e3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8004e8:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  8004ef:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	52                   	push   %edx
  8004f8:	ff 75 ec             	pushl  -0x14(%ebp)
  8004fb:	50                   	push   %eax
  8004fc:	68 00 4d 80 00       	push   $0x804d00
  800501:	6a 0c                	push   $0xc
  800503:	e8 bd 13 00 00       	call   8018c5 <cprintf_colored>
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
  80051c:	c7 05 4c f2 81 00 01 	movl   $0x1,0x81f24c
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
  800578:	a1 40 f2 81 00       	mov    0x81f240,%eax
  80057d:	01 d0                	add    %edx,%eax
  80057f:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  800584:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80058b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80058e:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800593:	52                   	push   %edx
  800594:	6a 01                	push   $0x1
  800596:	ff 75 e8             	pushl  -0x18(%ebp)
  800599:	50                   	push   %eax
  80059a:	e8 ba fa ff ff       	call   800059 <allocSpaceInPageAlloc>
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8005a5:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8005aa:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8005b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8005b4:	74 2f                	je     8005e5 <initial_page_allocations+0x1fa>
  8005b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005bd:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8005c2:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  8005c9:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8005ce:	83 ec 0c             	sub    $0xc,%esp
  8005d1:	52                   	push   %edx
  8005d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	68 00 4d 80 00       	push   $0x804d00
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 e3 12 00 00       	call   8018c5 <cprintf_colored>
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
  8005f6:	c7 05 4c f2 81 00 02 	movl   $0x2,0x81f24c
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
  800652:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1;
  80065e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800665:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800668:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80066d:	52                   	push   %edx
  80066e:	6a 01                	push   $0x1
  800670:	ff 75 e8             	pushl  -0x18(%ebp)
  800673:	50                   	push   %eax
  800674:	e8 e0 f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80067f:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800684:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80068b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80068e:	74 2f                	je     8006bf <initial_page_allocations+0x2d4>
  800690:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800697:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80069c:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  8006a3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	52                   	push   %edx
  8006ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8006af:	50                   	push   %eax
  8006b0:	68 00 4d 80 00       	push   $0x804d00
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 09 12 00 00       	call   8018c5 <cprintf_colored>
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
  8006d0:	c7 05 4c f2 81 00 03 	movl   $0x3,0x81f24c
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
  80072c:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800731:	01 d0                	add    %edx,%eax
  800733:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1;
  800738:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80073f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800742:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800747:	52                   	push   %edx
  800748:	6a 01                	push   $0x1
  80074a:	ff 75 e8             	pushl  -0x18(%ebp)
  80074d:	50                   	push   %eax
  80074e:	e8 06 f9 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800759:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80075e:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800765:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800768:	74 2f                	je     800799 <initial_page_allocations+0x3ae>
  80076a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800771:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800776:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  80077d:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800782:	83 ec 0c             	sub    $0xc,%esp
  800785:	52                   	push   %edx
  800786:	ff 75 ec             	pushl  -0x14(%ebp)
  800789:	50                   	push   %eax
  80078a:	68 00 4d 80 00       	push   $0x804d00
  80078f:	6a 0c                	push   $0xc
  800791:	e8 2f 11 00 00       	call   8018c5 <cprintf_colored>
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
  8007aa:	c7 05 4c f2 81 00 04 	movl   $0x4,0x81f24c
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
  800806:	a1 40 f2 81 00       	mov    0x81f240,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  800812:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800819:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80081c:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800821:	52                   	push   %edx
  800822:	6a 01                	push   $0x1
  800824:	ff 75 e8             	pushl  -0x18(%ebp)
  800827:	50                   	push   %eax
  800828:	e8 2c f8 ff ff       	call   800059 <allocSpaceInPageAlloc>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800833:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800838:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80083f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800842:	74 2f                	je     800873 <initial_page_allocations+0x488>
  800844:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80084b:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800850:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800857:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	52                   	push   %edx
  800860:	ff 75 ec             	pushl  -0x14(%ebp)
  800863:	50                   	push   %eax
  800864:	68 00 4d 80 00       	push   $0x804d00
  800869:	6a 0c                	push   $0xc
  80086b:	e8 55 10 00 00       	call   8018c5 <cprintf_colored>
  800870:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800873:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800877:	74 04                	je     80087d <initial_page_allocations+0x492>
  800879:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  80087d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 5;
  800884:	c7 05 4c f2 81 00 05 	movl   $0x5,0x81f24c
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
  8008e0:	a1 40 f2 81 00       	mov    0x81f240,%eax
  8008e5:	01 d0                	add    %edx,%eax
  8008e7:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  8008ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8008f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008f6:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8008fb:	52                   	push   %edx
  8008fc:	6a 01                	push   $0x1
  8008fe:	ff 75 e8             	pushl  -0x18(%ebp)
  800901:	50                   	push   %eax
  800902:	e8 52 f7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80090d:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800912:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800919:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80091c:	74 2f                	je     80094d <initial_page_allocations+0x562>
  80091e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800925:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80092a:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800931:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800936:	83 ec 0c             	sub    $0xc,%esp
  800939:	52                   	push   %edx
  80093a:	ff 75 ec             	pushl  -0x14(%ebp)
  80093d:	50                   	push   %eax
  80093e:	68 00 4d 80 00       	push   $0x804d00
  800943:	6a 0c                	push   $0xc
  800945:	e8 7b 0f 00 00       	call   8018c5 <cprintf_colored>
  80094a:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  80094d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800951:	74 04                	je     800957 <initial_page_allocations+0x56c>
  800953:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800957:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//1 MB
		allocIndex = 6;
  80095e:	c7 05 4c f2 81 00 06 	movl   $0x6,0x81f24c
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
  8009d5:	a1 40 f2 81 00       	mov    0x81f240,%eax
  8009da:	01 d0                	add    %edx,%eax
  8009dc:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1; //since page allocator is started 1 page after the 32MB of Block Allocator
  8009e1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8009e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8009eb:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8009f0:	52                   	push   %edx
  8009f1:	6a 01                	push   $0x1
  8009f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 5d f6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800a02:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800a07:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800a0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800a11:	74 2f                	je     800a42 <initial_page_allocations+0x657>
  800a13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a1a:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800a1f:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800a26:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800a2b:	83 ec 0c             	sub    $0xc,%esp
  800a2e:	52                   	push   %edx
  800a2f:	ff 75 ec             	pushl  -0x14(%ebp)
  800a32:	50                   	push   %eax
  800a33:	68 00 4d 80 00       	push   $0x804d00
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 86 0e 00 00       	call   8018c5 <cprintf_colored>
  800a3f:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 5;
  800a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a46:	74 04                	je     800a4c <initial_page_allocations+0x661>
  800a48:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		correct = 1;
  800a4c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 7;
  800a53:	c7 05 4c f2 81 00 07 	movl   $0x7,0x81f24c
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
  800ad3:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 0;
  800adf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ae6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ae9:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800aee:	52                   	push   %edx
  800aef:	6a 01                	push   $0x1
  800af1:	ff 75 e8             	pushl  -0x18(%ebp)
  800af4:	50                   	push   %eax
  800af5:	e8 5f f5 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800b00:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800b05:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800b0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800b0f:	74 2f                	je     800b40 <initial_page_allocations+0x755>
  800b11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b18:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800b1d:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800b24:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800b29:	83 ec 0c             	sub    $0xc,%esp
  800b2c:	52                   	push   %edx
  800b2d:	ff 75 ec             	pushl  -0x14(%ebp)
  800b30:	50                   	push   %eax
  800b31:	68 00 4d 80 00       	push   $0x804d00
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 88 0d 00 00       	call   8018c5 <cprintf_colored>
  800b3d:	83 c4 20             	add    $0x20,%esp
		if (correct) eval += 10;
  800b40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b44:	74 04                	je     800b4a <initial_page_allocations+0x75f>
  800b46:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		correct = 1;
  800b4a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//2 MB
		allocIndex = 8;
  800b51:	c7 05 4c f2 81 00 08 	movl   $0x8,0x81f24c
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
  800bd1:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800bd6:	01 d0                	add    %edx,%eax
  800bd8:	a3 40 f2 81 00       	mov    %eax,0x81f240
		expectedNumOfTables = 1;
  800bdd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800be4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800be7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800bec:	52                   	push   %edx
  800bed:	6a 01                	push   $0x1
  800bef:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf2:	50                   	push   %eax
  800bf3:	e8 61 f4 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800bf8:	83 c4 10             	add    $0x10,%esp
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800bfe:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800c03:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800c0a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800c0d:	74 2f                	je     800c3e <initial_page_allocations+0x853>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800c1b:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800c22:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	52                   	push   %edx
  800c2b:	ff 75 ec             	pushl  -0x14(%ebp)
  800c2e:	50                   	push   %eax
  800c2f:	68 00 4d 80 00       	push   $0x804d00
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 8a 0c 00 00       	call   8018c5 <cprintf_colored>
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
  800c4f:	c7 05 4c f2 81 00 09 	movl   $0x9,0x81f24c
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
  800ccf:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800cd4:	01 d0                	add    %edx,%eax
  800cd6:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800cdb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ce2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ce5:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800cea:	52                   	push   %edx
  800ceb:	6a 01                	push   $0x1
  800ced:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf0:	50                   	push   %eax
  800cf1:	e8 63 f3 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800cf6:	83 c4 10             	add    $0x10,%esp
  800cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800cfc:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800d01:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800d08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d0b:	74 2f                	je     800d3c <initial_page_allocations+0x951>
  800d0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d14:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800d19:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800d20:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800d25:	83 ec 0c             	sub    $0xc,%esp
  800d28:	52                   	push   %edx
  800d29:	ff 75 ec             	pushl  -0x14(%ebp)
  800d2c:	50                   	push   %eax
  800d2d:	68 00 4d 80 00       	push   $0x804d00
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 8c 0b 00 00       	call   8018c5 <cprintf_colored>
  800d39:	83 c4 20             	add    $0x20,%esp

			//5 KB
			allocIndex = 10;
  800d3c:	c7 05 4c f2 81 00 0a 	movl   $0xa,0x81f24c
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
  800dbc:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800dc1:	01 d0                	add    %edx,%eax
  800dc3:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800dc8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800dcf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800dd2:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800dd7:	52                   	push   %edx
  800dd8:	6a 01                	push   $0x1
  800dda:	ff 75 e8             	pushl  -0x18(%ebp)
  800ddd:	50                   	push   %eax
  800dde:	e8 76 f2 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800de9:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800dee:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800df5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800df8:	74 2f                	je     800e29 <initial_page_allocations+0xa3e>
  800dfa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e01:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800e06:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800e0d:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	52                   	push   %edx
  800e16:	ff 75 ec             	pushl  -0x14(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	68 00 4d 80 00       	push   $0x804d00
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 9f 0a 00 00       	call   8018c5 <cprintf_colored>
  800e26:	83 c4 20             	add    $0x20,%esp

			//3 KB
			allocIndex = 11;
  800e29:	c7 05 4c f2 81 00 0b 	movl   $0xb,0x81f24c
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
  800ea9:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800eb5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800ebc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800ebf:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ec4:	52                   	push   %edx
  800ec5:	6a 01                	push   $0x1
  800ec7:	ff 75 e8             	pushl  -0x18(%ebp)
  800eca:	50                   	push   %eax
  800ecb:	e8 89 f1 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800ed6:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800edb:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800ee2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ee5:	74 2f                	je     800f16 <initial_page_allocations+0xb2b>
  800ee7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eee:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800ef3:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800efa:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	52                   	push   %edx
  800f03:	ff 75 ec             	pushl  -0x14(%ebp)
  800f06:	50                   	push   %eax
  800f07:	68 00 4d 80 00       	push   $0x804d00
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 b2 09 00 00       	call   8018c5 <cprintf_colored>
  800f13:	83 c4 20             	add    $0x20,%esp

			//9 KB
			allocIndex = 12;
  800f16:	c7 05 4c f2 81 00 0c 	movl   $0xc,0x81f24c
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
  800f96:	a1 40 f2 81 00       	mov    0x81f240,%eax
  800f9b:	01 d0                	add    %edx,%eax
  800f9d:	a3 40 f2 81 00       	mov    %eax,0x81f240
			expectedNumOfTables = 0;
  800fa2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  800fa9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fac:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800fb1:	52                   	push   %edx
  800fb2:	6a 01                	push   $0x1
  800fb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800fb7:	50                   	push   %eax
  800fb8:	e8 9c f0 ff ff       	call   800059 <allocSpaceInPageAlloc>
  800fbd:	83 c4 10             	add    $0x10,%esp
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  800fc3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800fc8:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  800fcf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800fd2:	74 2f                	je     801003 <initial_page_allocations+0xc18>
  800fd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fdb:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800fe0:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  800fe7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	52                   	push   %edx
  800ff0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ff3:	50                   	push   %eax
  800ff4:	68 00 4d 80 00       	push   $0x804d00
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 c5 08 00 00       	call   8018c5 <cprintf_colored>
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
  801017:	68 52 4d 80 00       	push   $0x804d52
  80101c:	6a 03                	push   $0x3
  80101e:	e8 a2 08 00 00       	call   8018c5 <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 68 25 00 00       	call   8035a4 <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 a8 25 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  801047:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		uint32 restOfUHeap = (USER_HEAP_MAX - ACTUAL_PAGE_ALLOC_START) - (totalRequestedSize) ;
  80104d:	a1 40 f2 81 00       	mov    0x81f240,%eax
  801052:	ba 00 f0 ff 1d       	mov    $0x1dfff000,%edx
  801057:	29 c2                	sub    %eax,%edx
  801059:	89 d0                	mov    %edx,%eax
  80105b:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
		ptr_allocations[allocIndex] = malloc(restOfUHeap+1);
  801061:	8b 1d 4c f2 81 00    	mov    0x81f24c,%ebx
  801067:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80106d:	40                   	inc    %eax
  80106e:	83 ec 0c             	sub    $0xc,%esp
  801071:	50                   	push   %eax
  801072:	e8 4c 1e 00 00       	call   802ec3 <malloc>
  801077:	83 c4 10             	add    $0x10,%esp
  80107a:	89 04 9d 20 70 80 00 	mov    %eax,0x807020(,%ebx,4)
		if (ptr_allocations[allocIndex] != NULL) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.1 Allocating insufficient space: should return NULL\n", allocIndex); }
  801081:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  801086:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80108d:	85 c0                	test   %eax,%eax
  80108f:	74 1f                	je     8010b0 <initial_page_allocations+0xcc5>
  801091:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801098:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	50                   	push   %eax
  8010a1:	68 70 4d 80 00       	push   $0x804d70
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 18 08 00 00       	call   8018c5 <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 3a 25 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 ac 4d 80 00       	push   $0x804dac
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 ec 07 00 00       	call   8018c5 <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 c3 24 00 00       	call   8035a4 <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 1c 4e 80 00       	push   $0x804e1c
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 c0 07 00 00       	call   8018c5 <cprintf_colored>
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
#include <inc/lib.h>
#include <user/tst_malloc_helpers.h>

void
_main(void)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 28             	sub    $0x28,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801122:	a1 00 72 80 00       	mov    0x807200,%eax
  801127:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80112d:	a1 00 72 80 00       	mov    0x807200,%eax
  801132:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	72 14                	jb     801150 <_main+0x34>
			panic("Please increase the WS size");
  80113c:	83 ec 04             	sub    $0x4,%esp
  80113f:	68 64 4e 80 00       	push   $0x804e64
  801144:	6a 0d                	push   $0xd
  801146:	68 80 4e 80 00       	push   $0x804e80
  80114b:	e8 5a 04 00 00       	call   8015aa <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	68 98 4e 80 00       	push   $0x804e98
  801158:	6a 0e                	push   $0xe
  80115a:	e8 66 07 00 00       	call   8018c5 <cprintf_colored>
  80115f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	68 cc 4e 80 00       	push   $0x804ecc
  80116a:	6a 0e                	push   $0xe
  80116c:	e8 54 07 00 00       	call   8018c5 <cprintf_colored>
  801171:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	68 28 4f 80 00       	push   $0x804f28
  80117c:	6a 0e                	push   $0xe
  80117e:	e8 42 07 00 00       	call   8018c5 <cprintf_colored>
  801183:	83 c4 10             	add    $0x10,%esp

	int eval = 0;
  801186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80118d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801194:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	int freeFrames, usedDiskPages ;

	uint32 *x, *y, *z ;
	cprintf_colored(TEXT_cyan, "\n%~STEP A: checking creation of shared object that is already exists... [35%] \n\n");
  80119b:	83 ec 08             	sub    $0x8,%esp
  80119e:	68 60 4f 80 00       	push   $0x804f60
  8011a3:	6a 03                	push   $0x3
  8011a5:	e8 1b 07 00 00       	call   8018c5 <cprintf_colored>
  8011aa:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	6a 01                	push   $0x1
  8011b2:	68 00 10 00 00       	push   $0x1000
  8011b7:	68 b1 4f 80 00       	push   $0x804fb1
  8011bc:	e8 c2 1f 00 00       	call   803183 <smalloc>
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8011c7:	e8 d8 23 00 00       	call   8035a4 <sys_calculate_free_frames>
  8011cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011cf:	e8 1b 24 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  8011d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8011d7:	83 ec 04             	sub    $0x4,%esp
  8011da:	6a 01                	push   $0x1
  8011dc:	68 00 10 00 00       	push   $0x1000
  8011e1:	68 b1 4f 80 00       	push   $0x804fb1
  8011e6:	e8 98 1f 00 00       	call   803183 <smalloc>
  8011eb:	83 c4 10             	add    $0x10,%esp
  8011ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0;
  8011f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8011f5:	74 19                	je     801210 <_main+0xf4>
  8011f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to create an already exists object and corresponding error is not returned!!");}
  8011fe:	83 ec 08             	sub    $0x8,%esp
  801201:	68 b4 4f 80 00       	push   $0x804fb4
  801206:	6a 0c                	push   $0xc
  801208:	e8 b8 06 00 00       	call   8018c5 <cprintf_colored>
  80120d:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  801210:	e8 8f 23 00 00       	call   8035a4 <sys_calculate_free_frames>
  801215:	89 c2                	mov    %eax,%edx
  801217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121a:	39 c2                	cmp    %eax,%edx
  80121c:	74 19                	je     801237 <_main+0x11b>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80121e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801225:	83 ec 08             	sub    $0x8,%esp
  801228:	68 0c 50 80 00       	push   $0x80500c
  80122d:	6a 0c                	push   $0xc
  80122f:	e8 91 06 00 00       	call   8018c5 <cprintf_colored>
  801234:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801237:	e8 b3 23 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  80123c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80123f:	74 19                	je     80125a <_main+0x13e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  801241:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	68 6c 50 80 00       	push   $0x80506c
  801250:	6a 0c                	push   $0xc
  801252:	e8 6e 06 00 00       	call   8018c5 <cprintf_colored>
  801257:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  80125a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80125e:	74 04                	je     801264 <_main+0x148>
  801260:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  801264:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking getting shared object that is NOT exists... [35%]\n\n");
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	68 8c 50 80 00       	push   $0x80508c
  801273:	6a 03                	push   $0x3
  801275:	e8 4b 06 00 00       	call   8018c5 <cprintf_colored>
  80127a:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  80127d:	a1 00 72 80 00       	mov    0x807200,%eax
  801282:	8b 40 10             	mov    0x10(%eax),%eax
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	68 d4 50 80 00       	push   $0x8050d4
  80128d:	50                   	push   %eax
  80128e:	e8 50 20 00 00       	call   8032e3 <sget>
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	89 45 e8             	mov    %eax,-0x18(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  801299:	e8 06 23 00 00       	call   8035a4 <sys_calculate_free_frames>
  80129e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8012a1:	e8 49 23 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  8012a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL)
  8012a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8012ad:	74 19                	je     8012c8 <_main+0x1ac>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to get a NONE existing object and corresponding error is not returned!!");}
  8012af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012b6:	83 ec 08             	sub    $0x8,%esp
  8012b9:	68 d8 50 80 00       	push   $0x8050d8
  8012be:	6a 0c                	push   $0xc
  8012c0:	e8 00 06 00 00       	call   8018c5 <cprintf_colored>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  8012c8:	e8 d7 22 00 00       	call   8035a4 <sys_calculate_free_frames>
  8012cd:	89 c2                	mov    %eax,%edx
  8012cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d2:	39 c2                	cmp    %eax,%edx
  8012d4:	74 19                	je     8012ef <_main+0x1d3>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8012d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	68 2c 51 80 00       	push   $0x80512c
  8012e5:	6a 0c                	push   $0xc
  8012e7:	e8 d9 05 00 00       	call   8018c5 <cprintf_colored>
  8012ec:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012ef:	e8 fb 22 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  8012f4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8012f7:	74 19                	je     801312 <_main+0x1f6>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  8012f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801300:	83 ec 08             	sub    $0x8,%esp
  801303:	68 6c 50 80 00       	push   $0x80506c
  801308:	6a 0c                	push   $0xc
  80130a:	e8 b6 05 00 00       	call   8018c5 <cprintf_colored>
  80130f:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  801312:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801316:	74 04                	je     80131c <_main+0x200>
  801318:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  80131c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_cyan, "\n%~STEP C: checking the creation of shared object that exceeds the SHARED area limit... [30%]\n\n");
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	68 88 51 80 00       	push   $0x805188
  80132b:	6a 03                	push   $0x3
  80132d:	e8 93 05 00 00       	call   8018c5 <cprintf_colored>
  801332:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  801335:	e8 6a 22 00 00       	call   8035a4 <sys_calculate_free_frames>
  80133a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80133d:	e8 ad 22 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  801342:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  801345:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  80134a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80134d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		y = smalloc("y", size, 1);
  801350:	83 ec 04             	sub    $0x4,%esp
  801353:	6a 01                	push   $0x1
  801355:	ff 75 dc             	pushl  -0x24(%ebp)
  801358:	68 e8 51 80 00       	push   $0x8051e8
  80135d:	e8 21 1e 00 00       	call   803183 <smalloc>
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL)
  801368:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80136c:	74 19                	je     801387 <_main+0x26b>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  80136e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801375:	83 ec 08             	sub    $0x8,%esp
  801378:	68 ec 51 80 00       	push   $0x8051ec
  80137d:	6a 0c                	push   $0xc
  80137f:	e8 41 05 00 00       	call   8018c5 <cprintf_colored>
  801384:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0)
  801387:	e8 18 22 00 00       	call   8035a4 <sys_calculate_free_frames>
  80138c:	89 c2                	mov    %eax,%edx
  80138e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801391:	39 c2                	cmp    %eax,%edx
  801393:	74 19                	je     8013ae <_main+0x292>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  801395:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80139c:	83 ec 08             	sub    $0x8,%esp
  80139f:	68 60 52 80 00       	push   $0x805260
  8013a4:	6a 0c                	push   $0xc
  8013a6:	e8 1a 05 00 00       	call   8018c5 <cprintf_colored>
  8013ab:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8013ae:	e8 3c 22 00 00       	call   8035ef <sys_pf_calculate_allocated_pages>
  8013b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8013b6:	74 19                	je     8013d1 <_main+0x2b5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  8013b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013bf:	83 ec 08             	sub    $0x8,%esp
  8013c2:	68 6c 50 80 00       	push   $0x80506c
  8013c7:	6a 0c                	push   $0xc
  8013c9:	e8 f7 04 00 00       	call   8018c5 <cprintf_colored>
  8013ce:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  8013d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013d5:	74 04                	je     8013db <_main+0x2bf>
  8013d7:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  8013db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "%~\nTest of Shared Variables [Create & Get: Special Cases] completed. Eval = %d%%\n\n", eval);
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e8:	68 d4 52 80 00       	push   $0x8052d4
  8013ed:	6a 0a                	push   $0xa
  8013ef:	e8 d1 04 00 00       	call   8018c5 <cprintf_colored>
  8013f4:	83 c4 10             	add    $0x10,%esp

}
  8013f7:	90                   	nop
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	57                   	push   %edi
  8013fe:	56                   	push   %esi
  8013ff:	53                   	push   %ebx
  801400:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801403:	e8 65 23 00 00       	call   80376d <sys_getenvindex>
  801408:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80140b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80140e:	89 d0                	mov    %edx,%eax
  801410:	01 c0                	add    %eax,%eax
  801412:	01 d0                	add    %edx,%eax
  801414:	c1 e0 02             	shl    $0x2,%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	c1 e0 02             	shl    $0x2,%eax
  80141c:	01 d0                	add    %edx,%eax
  80141e:	c1 e0 03             	shl    $0x3,%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	c1 e0 02             	shl    $0x2,%eax
  801426:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80142b:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801430:	a1 00 72 80 00       	mov    0x807200,%eax
  801435:	8a 40 20             	mov    0x20(%eax),%al
  801438:	84 c0                	test   %al,%al
  80143a:	74 0d                	je     801449 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80143c:	a1 00 72 80 00       	mov    0x807200,%eax
  801441:	83 c0 20             	add    $0x20,%eax
  801444:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801449:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144d:	7e 0a                	jle    801459 <libmain+0x5f>
		binaryname = argv[0];
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	8b 00                	mov    (%eax),%eax
  801454:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	e8 b5 fc ff ff       	call   80111c <_main>
  801467:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80146a:	a1 00 70 80 00       	mov    0x807000,%eax
  80146f:	85 c0                	test   %eax,%eax
  801471:	0f 84 01 01 00 00    	je     801578 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801477:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80147d:	bb 20 54 80 00       	mov    $0x805420,%ebx
  801482:	ba 0e 00 00 00       	mov    $0xe,%edx
  801487:	89 c7                	mov    %eax,%edi
  801489:	89 de                	mov    %ebx,%esi
  80148b:	89 d1                	mov    %edx,%ecx
  80148d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80148f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801492:	b9 56 00 00 00       	mov    $0x56,%ecx
  801497:	b0 00                	mov    $0x0,%al
  801499:	89 d7                	mov    %edx,%edi
  80149b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80149d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8014a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	50                   	push   %eax
  8014ab:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8014b1:	50                   	push   %eax
  8014b2:	e8 ec 24 00 00       	call   8039a3 <sys_utilities>
  8014b7:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8014ba:	e8 35 20 00 00       	call   8034f4 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 40 53 80 00       	push   $0x805340
  8014c7:	e8 cc 03 00 00       	call   801898 <cprintf>
  8014cc:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8014cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 18                	je     8014ee <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8014d6:	e8 e6 24 00 00       	call   8039c1 <sys_get_optimal_num_faults>
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	50                   	push   %eax
  8014df:	68 68 53 80 00       	push   $0x805368
  8014e4:	e8 af 03 00 00       	call   801898 <cprintf>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	eb 59                	jmp    801547 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014ee:	a1 00 72 80 00       	mov    0x807200,%eax
  8014f3:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8014f9:	a1 00 72 80 00       	mov    0x807200,%eax
  8014fe:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	52                   	push   %edx
  801508:	50                   	push   %eax
  801509:	68 8c 53 80 00       	push   $0x80538c
  80150e:	e8 85 03 00 00       	call   801898 <cprintf>
  801513:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801516:	a1 00 72 80 00       	mov    0x807200,%eax
  80151b:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  801521:	a1 00 72 80 00       	mov    0x807200,%eax
  801526:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80152c:	a1 00 72 80 00       	mov    0x807200,%eax
  801531:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  801537:	51                   	push   %ecx
  801538:	52                   	push   %edx
  801539:	50                   	push   %eax
  80153a:	68 b4 53 80 00       	push   $0x8053b4
  80153f:	e8 54 03 00 00       	call   801898 <cprintf>
  801544:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801547:	a1 00 72 80 00       	mov    0x807200,%eax
  80154c:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	50                   	push   %eax
  801556:	68 0c 54 80 00       	push   $0x80540c
  80155b:	e8 38 03 00 00       	call   801898 <cprintf>
  801560:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801563:	83 ec 0c             	sub    $0xc,%esp
  801566:	68 40 53 80 00       	push   $0x805340
  80156b:	e8 28 03 00 00       	call   801898 <cprintf>
  801570:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801573:	e8 96 1f 00 00       	call   80350e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801578:	e8 1f 00 00 00       	call   80159c <exit>
}
  80157d:	90                   	nop
  80157e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80158c:	83 ec 0c             	sub    $0xc,%esp
  80158f:	6a 00                	push   $0x0
  801591:	e8 a3 21 00 00       	call   803739 <sys_destroy_env>
  801596:	83 c4 10             	add    $0x10,%esp
}
  801599:	90                   	nop
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <exit>:

void
exit(void)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015a2:	e8 f8 21 00 00       	call   80379f <sys_exit_env>
}
  8015a7:	90                   	nop
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8015b3:	83 c0 04             	add    $0x4,%eax
  8015b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015b9:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	74 16                	je     8015d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015c2:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8015c7:	83 ec 08             	sub    $0x8,%esp
  8015ca:	50                   	push   %eax
  8015cb:	68 84 54 80 00       	push   $0x805484
  8015d0:	e8 c3 02 00 00       	call   801898 <cprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8015d8:	a1 04 70 80 00       	mov    0x807004,%eax
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	ff 75 08             	pushl  0x8(%ebp)
  8015e6:	50                   	push   %eax
  8015e7:	68 8c 54 80 00       	push   $0x80548c
  8015ec:	6a 74                	push   $0x74
  8015ee:	e8 d2 02 00 00       	call   8018c5 <cprintf_colored>
  8015f3:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8015f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ff:	50                   	push   %eax
  801600:	e8 24 02 00 00       	call   801829 <vcprintf>
  801605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	6a 00                	push   $0x0
  80160d:	68 b4 54 80 00       	push   $0x8054b4
  801612:	e8 12 02 00 00       	call   801829 <vcprintf>
  801617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80161a:	e8 7d ff ff ff       	call   80159c <exit>

	// should not return here
	while (1) ;
  80161f:	eb fe                	jmp    80161f <_panic+0x75>

00801621 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	53                   	push   %ebx
  801625:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801628:	a1 00 72 80 00       	mov    0x807200,%eax
  80162d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801633:	8b 45 0c             	mov    0xc(%ebp),%eax
  801636:	39 c2                	cmp    %eax,%edx
  801638:	74 14                	je     80164e <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	68 b8 54 80 00       	push   $0x8054b8
  801642:	6a 26                	push   $0x26
  801644:	68 04 55 80 00       	push   $0x805504
  801649:	e8 5c ff ff ff       	call   8015aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80164e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801655:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80165c:	e9 d9 00 00 00       	jmp    80173a <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  801661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801664:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	8b 00                	mov    (%eax),%eax
  801672:	85 c0                	test   %eax,%eax
  801674:	75 08                	jne    80167e <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  801676:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801679:	e9 b9 00 00 00       	jmp    801737 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80167e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801685:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80168c:	eb 79                	jmp    801707 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80168e:	a1 00 72 80 00       	mov    0x807200,%eax
  801693:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801699:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80169c:	89 d0                	mov    %edx,%eax
  80169e:	01 c0                	add    %eax,%eax
  8016a0:	01 d0                	add    %edx,%eax
  8016a2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8016a9:	01 d8                	add    %ebx,%eax
  8016ab:	01 d0                	add    %edx,%eax
  8016ad:	01 c8                	add    %ecx,%eax
  8016af:	8a 40 04             	mov    0x4(%eax),%al
  8016b2:	84 c0                	test   %al,%al
  8016b4:	75 4e                	jne    801704 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016b6:	a1 00 72 80 00       	mov    0x807200,%eax
  8016bb:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8016c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016c4:	89 d0                	mov    %edx,%eax
  8016c6:	01 c0                	add    %eax,%eax
  8016c8:	01 d0                	add    %edx,%eax
  8016ca:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8016d1:	01 d8                	add    %ebx,%eax
  8016d3:	01 d0                	add    %edx,%eax
  8016d5:	01 c8                	add    %ecx,%eax
  8016d7:	8b 00                	mov    (%eax),%eax
  8016d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	01 c8                	add    %ecx,%eax
  8016f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016f7:	39 c2                	cmp    %eax,%edx
  8016f9:	75 09                	jne    801704 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8016fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801702:	eb 19                	jmp    80171d <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801704:	ff 45 e8             	incl   -0x18(%ebp)
  801707:	a1 00 72 80 00       	mov    0x807200,%eax
  80170c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801715:	39 c2                	cmp    %eax,%edx
  801717:	0f 87 71 ff ff ff    	ja     80168e <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80171d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801721:	75 14                	jne    801737 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	68 10 55 80 00       	push   $0x805510
  80172b:	6a 3a                	push   $0x3a
  80172d:	68 04 55 80 00       	push   $0x805504
  801732:	e8 73 fe ff ff       	call   8015aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801737:	ff 45 f0             	incl   -0x10(%ebp)
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801740:	0f 8c 1b ff ff ff    	jl     801661 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801746:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80174d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801754:	eb 2e                	jmp    801784 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801756:	a1 00 72 80 00       	mov    0x807200,%eax
  80175b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801761:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801764:	89 d0                	mov    %edx,%eax
  801766:	01 c0                	add    %eax,%eax
  801768:	01 d0                	add    %edx,%eax
  80176a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801771:	01 d8                	add    %ebx,%eax
  801773:	01 d0                	add    %edx,%eax
  801775:	01 c8                	add    %ecx,%eax
  801777:	8a 40 04             	mov    0x4(%eax),%al
  80177a:	3c 01                	cmp    $0x1,%al
  80177c:	75 03                	jne    801781 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80177e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801781:	ff 45 e0             	incl   -0x20(%ebp)
  801784:	a1 00 72 80 00       	mov    0x807200,%eax
  801789:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80178f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801792:	39 c2                	cmp    %eax,%edx
  801794:	77 c0                	ja     801756 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80179c:	74 14                	je     8017b2 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	68 64 55 80 00       	push   $0x805564
  8017a6:	6a 44                	push   $0x44
  8017a8:	68 04 55 80 00       	push   $0x805504
  8017ad:	e8 f8 fd ff ff       	call   8015aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017b2:	90                   	nop
  8017b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8017bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c2:	8b 00                	mov    (%eax),%eax
  8017c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8017c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ca:	89 0a                	mov    %ecx,(%edx)
  8017cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8017cf:	88 d1                	mov    %dl,%cl
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017db:	8b 00                	mov    (%eax),%eax
  8017dd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017e2:	75 30                	jne    801814 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8017e4:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  8017ea:	a0 24 72 80 00       	mov    0x807224,%al
  8017ef:	0f b6 c0             	movzbl %al,%eax
  8017f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f5:	8b 09                	mov    (%ecx),%ecx
  8017f7:	89 cb                	mov    %ecx,%ebx
  8017f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fc:	83 c1 08             	add    $0x8,%ecx
  8017ff:	52                   	push   %edx
  801800:	50                   	push   %eax
  801801:	53                   	push   %ebx
  801802:	51                   	push   %ecx
  801803:	e8 a8 1c 00 00       	call   8034b0 <sys_cputs>
  801808:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80180b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	8b 40 04             	mov    0x4(%eax),%eax
  80181a:	8d 50 01             	lea    0x1(%eax),%edx
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 50 04             	mov    %edx,0x4(%eax)
}
  801823:	90                   	nop
  801824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801832:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801839:	00 00 00 
	b.cnt = 0;
  80183c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801843:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801852:	50                   	push   %eax
  801853:	68 b8 17 80 00       	push   $0x8017b8
  801858:	e8 5a 02 00 00       	call   801ab7 <vprintfmt>
  80185d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801860:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801866:	a0 24 72 80 00       	mov    0x807224,%al
  80186b:	0f b6 c0             	movzbl %al,%eax
  80186e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801874:	52                   	push   %edx
  801875:	50                   	push   %eax
  801876:	51                   	push   %ecx
  801877:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80187d:	83 c0 08             	add    $0x8,%eax
  801880:	50                   	push   %eax
  801881:	e8 2a 1c 00 00       	call   8034b0 <sys_cputs>
  801886:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801889:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801890:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80189e:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  8018a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b4:	50                   	push   %eax
  8018b5:	e8 6f ff ff ff       	call   801829 <vcprintf>
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018cb:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	c1 e0 08             	shl    $0x8,%eax
  8018d8:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  8018dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018e0:	83 c0 04             	add    $0x4,%eax
  8018e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e9:	83 ec 08             	sub    $0x8,%esp
  8018ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ef:	50                   	push   %eax
  8018f0:	e8 34 ff ff ff       	call   801829 <vcprintf>
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8018fb:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801902:	07 00 00 

	return cnt;
  801905:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801910:	e8 df 1b 00 00       	call   8034f4 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801915:	8d 45 0c             	lea    0xc(%ebp),%eax
  801918:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	ff 75 f4             	pushl  -0xc(%ebp)
  801924:	50                   	push   %eax
  801925:	e8 ff fe ff ff       	call   801829 <vcprintf>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801930:	e8 d9 1b 00 00       	call   80350e <sys_unlock_cons>
	return cnt;
  801935:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	53                   	push   %ebx
  80193e:	83 ec 14             	sub    $0x14,%esp
  801941:	8b 45 10             	mov    0x10(%ebp),%eax
  801944:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801947:	8b 45 14             	mov    0x14(%ebp),%eax
  80194a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80194d:	8b 45 18             	mov    0x18(%ebp),%eax
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801958:	77 55                	ja     8019af <printnum+0x75>
  80195a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80195d:	72 05                	jb     801964 <printnum+0x2a>
  80195f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801962:	77 4b                	ja     8019af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801964:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801967:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80196a:	8b 45 18             	mov    0x18(%ebp),%eax
  80196d:	ba 00 00 00 00       	mov    $0x0,%edx
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	ff 75 f4             	pushl  -0xc(%ebp)
  801977:	ff 75 f0             	pushl  -0x10(%ebp)
  80197a:	e8 d5 2d 00 00       	call   804754 <__udivdi3>
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	ff 75 20             	pushl  0x20(%ebp)
  801988:	53                   	push   %ebx
  801989:	ff 75 18             	pushl  0x18(%ebp)
  80198c:	52                   	push   %edx
  80198d:	50                   	push   %eax
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	e8 a1 ff ff ff       	call   80193a <printnum>
  801999:	83 c4 20             	add    $0x20,%esp
  80199c:	eb 1a                	jmp    8019b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80199e:	83 ec 08             	sub    $0x8,%esp
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	ff 75 20             	pushl  0x20(%ebp)
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	ff d0                	call   *%eax
  8019ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019af:	ff 4d 1c             	decl   0x1c(%ebp)
  8019b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8019b6:	7f e6                	jg     80199e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	53                   	push   %ebx
  8019c7:	51                   	push   %ecx
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	e8 95 2e 00 00       	call   804864 <__umoddi3>
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	05 d4 57 80 00       	add    $0x8057d4,%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f be c0             	movsbl %al,%eax
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	50                   	push   %eax
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	ff d0                	call   *%eax
  8019e8:	83 c4 10             	add    $0x10,%esp
}
  8019eb:	90                   	nop
  8019ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019f8:	7e 1c                	jle    801a16 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8b 00                	mov    (%eax),%eax
  8019ff:	8d 50 08             	lea    0x8(%eax),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	89 10                	mov    %edx,(%eax)
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	8b 00                	mov    (%eax),%eax
  801a0c:	83 e8 08             	sub    $0x8,%eax
  801a0f:	8b 50 04             	mov    0x4(%eax),%edx
  801a12:	8b 00                	mov    (%eax),%eax
  801a14:	eb 40                	jmp    801a56 <getuint+0x65>
	else if (lflag)
  801a16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a1a:	74 1e                	je     801a3a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8b 00                	mov    (%eax),%eax
  801a21:	8d 50 04             	lea    0x4(%eax),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	89 10                	mov    %edx,(%eax)
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8b 00                	mov    (%eax),%eax
  801a2e:	83 e8 04             	sub    $0x4,%eax
  801a31:	8b 00                	mov    (%eax),%eax
  801a33:	ba 00 00 00 00       	mov    $0x0,%edx
  801a38:	eb 1c                	jmp    801a56 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	8d 50 04             	lea    0x4(%eax),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	89 10                	mov    %edx,(%eax)
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	83 e8 04             	sub    $0x4,%eax
  801a4f:	8b 00                	mov    (%eax),%eax
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a5b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a5f:	7e 1c                	jle    801a7d <getint+0x25>
		return va_arg(*ap, long long);
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	8b 00                	mov    (%eax),%eax
  801a66:	8d 50 08             	lea    0x8(%eax),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	89 10                	mov    %edx,(%eax)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8b 00                	mov    (%eax),%eax
  801a73:	83 e8 08             	sub    $0x8,%eax
  801a76:	8b 50 04             	mov    0x4(%eax),%edx
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	eb 38                	jmp    801ab5 <getint+0x5d>
	else if (lflag)
  801a7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a81:	74 1a                	je     801a9d <getint+0x45>
		return va_arg(*ap, long);
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	8b 00                	mov    (%eax),%eax
  801a88:	8d 50 04             	lea    0x4(%eax),%edx
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	89 10                	mov    %edx,(%eax)
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	8b 00                	mov    (%eax),%eax
  801a95:	83 e8 04             	sub    $0x4,%eax
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	99                   	cltd   
  801a9b:	eb 18                	jmp    801ab5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8b 00                	mov    (%eax),%eax
  801aa2:	8d 50 04             	lea    0x4(%eax),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	89 10                	mov    %edx,(%eax)
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8b 00                	mov    (%eax),%eax
  801aaf:	83 e8 04             	sub    $0x4,%eax
  801ab2:	8b 00                	mov    (%eax),%eax
  801ab4:	99                   	cltd   
}
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	56                   	push   %esi
  801abb:	53                   	push   %ebx
  801abc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801abf:	eb 17                	jmp    801ad8 <vprintfmt+0x21>
			if (ch == '\0')
  801ac1:	85 db                	test   %ebx,%ebx
  801ac3:	0f 84 c1 03 00 00    	je     801e8a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801ac9:	83 ec 08             	sub    $0x8,%esp
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	53                   	push   %ebx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	ff d0                	call   *%eax
  801ad5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	8d 50 01             	lea    0x1(%eax),%edx
  801ade:	89 55 10             	mov    %edx,0x10(%ebp)
  801ae1:	8a 00                	mov    (%eax),%al
  801ae3:	0f b6 d8             	movzbl %al,%ebx
  801ae6:	83 fb 25             	cmp    $0x25,%ebx
  801ae9:	75 d6                	jne    801ac1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801aeb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801aef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801af6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801afd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801b04:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0e:	8d 50 01             	lea    0x1(%eax),%edx
  801b11:	89 55 10             	mov    %edx,0x10(%ebp)
  801b14:	8a 00                	mov    (%eax),%al
  801b16:	0f b6 d8             	movzbl %al,%ebx
  801b19:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801b1c:	83 f8 5b             	cmp    $0x5b,%eax
  801b1f:	0f 87 3d 03 00 00    	ja     801e62 <vprintfmt+0x3ab>
  801b25:	8b 04 85 f8 57 80 00 	mov    0x8057f8(,%eax,4),%eax
  801b2c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b2e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b32:	eb d7                	jmp    801b0b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b34:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b38:	eb d1                	jmp    801b0b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b3a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b44:	89 d0                	mov    %edx,%eax
  801b46:	c1 e0 02             	shl    $0x2,%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	01 c0                	add    %eax,%eax
  801b4d:	01 d8                	add    %ebx,%eax
  801b4f:	83 e8 30             	sub    $0x30,%eax
  801b52:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b55:	8b 45 10             	mov    0x10(%ebp),%eax
  801b58:	8a 00                	mov    (%eax),%al
  801b5a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b5d:	83 fb 2f             	cmp    $0x2f,%ebx
  801b60:	7e 3e                	jle    801ba0 <vprintfmt+0xe9>
  801b62:	83 fb 39             	cmp    $0x39,%ebx
  801b65:	7f 39                	jg     801ba0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b67:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b6a:	eb d5                	jmp    801b41 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6f:	83 c0 04             	add    $0x4,%eax
  801b72:	89 45 14             	mov    %eax,0x14(%ebp)
  801b75:	8b 45 14             	mov    0x14(%ebp),%eax
  801b78:	83 e8 04             	sub    $0x4,%eax
  801b7b:	8b 00                	mov    (%eax),%eax
  801b7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b80:	eb 1f                	jmp    801ba1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b86:	79 83                	jns    801b0b <vprintfmt+0x54>
				width = 0;
  801b88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b8f:	e9 77 ff ff ff       	jmp    801b0b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b94:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b9b:	e9 6b ff ff ff       	jmp    801b0b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ba0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ba1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ba5:	0f 89 60 ff ff ff    	jns    801b0b <vprintfmt+0x54>
				width = precision, precision = -1;
  801bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bb1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801bb8:	e9 4e ff ff ff       	jmp    801b0b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bbd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801bc0:	e9 46 ff ff ff       	jmp    801b0b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801bc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc8:	83 c0 04             	add    $0x4,%eax
  801bcb:	89 45 14             	mov    %eax,0x14(%ebp)
  801bce:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd1:	83 e8 04             	sub    $0x4,%eax
  801bd4:	8b 00                	mov    (%eax),%eax
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	ff 75 0c             	pushl  0xc(%ebp)
  801bdc:	50                   	push   %eax
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	ff d0                	call   *%eax
  801be2:	83 c4 10             	add    $0x10,%esp
			break;
  801be5:	e9 9b 02 00 00       	jmp    801e85 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bea:	8b 45 14             	mov    0x14(%ebp),%eax
  801bed:	83 c0 04             	add    $0x4,%eax
  801bf0:	89 45 14             	mov    %eax,0x14(%ebp)
  801bf3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf6:	83 e8 04             	sub    $0x4,%eax
  801bf9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801bfb:	85 db                	test   %ebx,%ebx
  801bfd:	79 02                	jns    801c01 <vprintfmt+0x14a>
				err = -err;
  801bff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801c01:	83 fb 64             	cmp    $0x64,%ebx
  801c04:	7f 0b                	jg     801c11 <vprintfmt+0x15a>
  801c06:	8b 34 9d 40 56 80 00 	mov    0x805640(,%ebx,4),%esi
  801c0d:	85 f6                	test   %esi,%esi
  801c0f:	75 19                	jne    801c2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801c11:	53                   	push   %ebx
  801c12:	68 e5 57 80 00       	push   $0x8057e5
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	e8 70 02 00 00       	call   801e92 <printfmt>
  801c22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801c25:	e9 5b 02 00 00       	jmp    801e85 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c2a:	56                   	push   %esi
  801c2b:	68 ee 57 80 00       	push   $0x8057ee
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	e8 57 02 00 00       	call   801e92 <printfmt>
  801c3b:	83 c4 10             	add    $0x10,%esp
			break;
  801c3e:	e9 42 02 00 00       	jmp    801e85 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c43:	8b 45 14             	mov    0x14(%ebp),%eax
  801c46:	83 c0 04             	add    $0x4,%eax
  801c49:	89 45 14             	mov    %eax,0x14(%ebp)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	83 e8 04             	sub    $0x4,%eax
  801c52:	8b 30                	mov    (%eax),%esi
  801c54:	85 f6                	test   %esi,%esi
  801c56:	75 05                	jne    801c5d <vprintfmt+0x1a6>
				p = "(null)";
  801c58:	be f1 57 80 00       	mov    $0x8057f1,%esi
			if (width > 0 && padc != '-')
  801c5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c61:	7e 6d                	jle    801cd0 <vprintfmt+0x219>
  801c63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c67:	74 67                	je     801cd0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6c:	83 ec 08             	sub    $0x8,%esp
  801c6f:	50                   	push   %eax
  801c70:	56                   	push   %esi
  801c71:	e8 1e 03 00 00       	call   801f94 <strnlen>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c7c:	eb 16                	jmp    801c94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c82:	83 ec 08             	sub    $0x8,%esp
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	50                   	push   %eax
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	ff d0                	call   *%eax
  801c8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c91:	ff 4d e4             	decl   -0x1c(%ebp)
  801c94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c98:	7f e4                	jg     801c7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c9a:	eb 34                	jmp    801cd0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ca0:	74 1c                	je     801cbe <vprintfmt+0x207>
  801ca2:	83 fb 1f             	cmp    $0x1f,%ebx
  801ca5:	7e 05                	jle    801cac <vprintfmt+0x1f5>
  801ca7:	83 fb 7e             	cmp    $0x7e,%ebx
  801caa:	7e 12                	jle    801cbe <vprintfmt+0x207>
					putch('?', putdat);
  801cac:	83 ec 08             	sub    $0x8,%esp
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	6a 3f                	push   $0x3f
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	ff d0                	call   *%eax
  801cb9:	83 c4 10             	add    $0x10,%esp
  801cbc:	eb 0f                	jmp    801ccd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801cbe:	83 ec 08             	sub    $0x8,%esp
  801cc1:	ff 75 0c             	pushl  0xc(%ebp)
  801cc4:	53                   	push   %ebx
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	ff d0                	call   *%eax
  801cca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ccd:	ff 4d e4             	decl   -0x1c(%ebp)
  801cd0:	89 f0                	mov    %esi,%eax
  801cd2:	8d 70 01             	lea    0x1(%eax),%esi
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be d8             	movsbl %al,%ebx
  801cda:	85 db                	test   %ebx,%ebx
  801cdc:	74 24                	je     801d02 <vprintfmt+0x24b>
  801cde:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ce2:	78 b8                	js     801c9c <vprintfmt+0x1e5>
  801ce4:	ff 4d e0             	decl   -0x20(%ebp)
  801ce7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ceb:	79 af                	jns    801c9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ced:	eb 13                	jmp    801d02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	ff 75 0c             	pushl  0xc(%ebp)
  801cf5:	6a 20                	push   $0x20
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	ff d0                	call   *%eax
  801cfc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cff:	ff 4d e4             	decl   -0x1c(%ebp)
  801d02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d06:	7f e7                	jg     801cef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801d08:	e9 78 01 00 00       	jmp    801e85 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d0d:	83 ec 08             	sub    $0x8,%esp
  801d10:	ff 75 e8             	pushl  -0x18(%ebp)
  801d13:	8d 45 14             	lea    0x14(%ebp),%eax
  801d16:	50                   	push   %eax
  801d17:	e8 3c fd ff ff       	call   801a58 <getint>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	79 23                	jns    801d52 <vprintfmt+0x29b>
				putch('-', putdat);
  801d2f:	83 ec 08             	sub    $0x8,%esp
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	6a 2d                	push   $0x2d
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	ff d0                	call   *%eax
  801d3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d45:	f7 d8                	neg    %eax
  801d47:	83 d2 00             	adc    $0x0,%edx
  801d4a:	f7 da                	neg    %edx
  801d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d59:	e9 bc 00 00 00       	jmp    801e1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d5e:	83 ec 08             	sub    $0x8,%esp
  801d61:	ff 75 e8             	pushl  -0x18(%ebp)
  801d64:	8d 45 14             	lea    0x14(%ebp),%eax
  801d67:	50                   	push   %eax
  801d68:	e8 84 fc ff ff       	call   8019f1 <getuint>
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d7d:	e9 98 00 00 00       	jmp    801e1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d82:	83 ec 08             	sub    $0x8,%esp
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	6a 58                	push   $0x58
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	ff d0                	call   *%eax
  801d8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d92:	83 ec 08             	sub    $0x8,%esp
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	6a 58                	push   $0x58
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	ff d0                	call   *%eax
  801d9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	6a 58                	push   $0x58
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	ff d0                	call   *%eax
  801daf:	83 c4 10             	add    $0x10,%esp
			break;
  801db2:	e9 ce 00 00 00       	jmp    801e85 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801db7:	83 ec 08             	sub    $0x8,%esp
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	6a 30                	push   $0x30
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	ff d0                	call   *%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	6a 78                	push   $0x78
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	ff d0                	call   *%eax
  801dd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dda:	83 c0 04             	add    $0x4,%eax
  801ddd:	89 45 14             	mov    %eax,0x14(%ebp)
  801de0:	8b 45 14             	mov    0x14(%ebp),%eax
  801de3:	83 e8 04             	sub    $0x4,%eax
  801de6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801df2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801df9:	eb 1f                	jmp    801e1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801dfb:	83 ec 08             	sub    $0x8,%esp
  801dfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801e01:	8d 45 14             	lea    0x14(%ebp),%eax
  801e04:	50                   	push   %eax
  801e05:	e8 e7 fb ff ff       	call   8019f1 <getuint>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801e13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	52                   	push   %edx
  801e25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e28:	50                   	push   %eax
  801e29:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e2f:	ff 75 0c             	pushl  0xc(%ebp)
  801e32:	ff 75 08             	pushl  0x8(%ebp)
  801e35:	e8 00 fb ff ff       	call   80193a <printnum>
  801e3a:	83 c4 20             	add    $0x20,%esp
			break;
  801e3d:	eb 46                	jmp    801e85 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e3f:	83 ec 08             	sub    $0x8,%esp
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	53                   	push   %ebx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	ff d0                	call   *%eax
  801e4b:	83 c4 10             	add    $0x10,%esp
			break;
  801e4e:	eb 35                	jmp    801e85 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e50:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  801e57:	eb 2c                	jmp    801e85 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e59:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  801e60:	eb 23                	jmp    801e85 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e62:	83 ec 08             	sub    $0x8,%esp
  801e65:	ff 75 0c             	pushl  0xc(%ebp)
  801e68:	6a 25                	push   $0x25
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	ff d0                	call   *%eax
  801e6f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e72:	ff 4d 10             	decl   0x10(%ebp)
  801e75:	eb 03                	jmp    801e7a <vprintfmt+0x3c3>
  801e77:	ff 4d 10             	decl   0x10(%ebp)
  801e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7d:	48                   	dec    %eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	3c 25                	cmp    $0x25,%al
  801e82:	75 f3                	jne    801e77 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e84:	90                   	nop
		}
	}
  801e85:	e9 35 fc ff ff       	jmp    801abf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e8a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5e                   	pop    %esi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    

00801e92 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e98:	8d 45 10             	lea    0x10(%ebp),%eax
  801e9b:	83 c0 04             	add    $0x4,%eax
  801e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801ea1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea7:	50                   	push   %eax
  801ea8:	ff 75 0c             	pushl  0xc(%ebp)
  801eab:	ff 75 08             	pushl  0x8(%ebp)
  801eae:	e8 04 fc ff ff       	call   801ab7 <vprintfmt>
  801eb3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801eb6:	90                   	nop
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	8b 40 08             	mov    0x8(%eax),%eax
  801ec2:	8d 50 01             	lea    0x1(%eax),%edx
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ece:	8b 10                	mov    (%eax),%edx
  801ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed3:	8b 40 04             	mov    0x4(%eax),%eax
  801ed6:	39 c2                	cmp    %eax,%edx
  801ed8:	73 12                	jae    801eec <sprintputch+0x33>
		*b->buf++ = ch;
  801eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edd:	8b 00                	mov    (%eax),%eax
  801edf:	8d 48 01             	lea    0x1(%eax),%ecx
  801ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee5:	89 0a                	mov    %ecx,(%edx)
  801ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  801eea:	88 10                	mov    %dl,(%eax)
}
  801eec:	90                   	nop
  801eed:	5d                   	pop    %ebp
  801eee:	c3                   	ret    

00801eef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f14:	74 06                	je     801f1c <vsnprintf+0x2d>
  801f16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f1a:	7f 07                	jg     801f23 <vsnprintf+0x34>
		return -E_INVAL;
  801f1c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f21:	eb 20                	jmp    801f43 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f23:	ff 75 14             	pushl  0x14(%ebp)
  801f26:	ff 75 10             	pushl  0x10(%ebp)
  801f29:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f2c:	50                   	push   %eax
  801f2d:	68 b9 1e 80 00       	push   $0x801eb9
  801f32:	e8 80 fb ff ff       	call   801ab7 <vprintfmt>
  801f37:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f4b:	8d 45 10             	lea    0x10(%ebp),%eax
  801f4e:	83 c0 04             	add    $0x4,%eax
  801f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f54:	8b 45 10             	mov    0x10(%ebp),%eax
  801f57:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5a:	50                   	push   %eax
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	e8 89 ff ff ff       	call   801eef <vsnprintf>
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f7e:	eb 06                	jmp    801f86 <strlen+0x15>
		n++;
  801f80:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f83:	ff 45 08             	incl   0x8(%ebp)
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	8a 00                	mov    (%eax),%al
  801f8b:	84 c0                	test   %al,%al
  801f8d:	75 f1                	jne    801f80 <strlen+0xf>
		n++;
	return n;
  801f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fa1:	eb 09                	jmp    801fac <strnlen+0x18>
		n++;
  801fa3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fa6:	ff 45 08             	incl   0x8(%ebp)
  801fa9:	ff 4d 0c             	decl   0xc(%ebp)
  801fac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fb0:	74 09                	je     801fbb <strnlen+0x27>
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	8a 00                	mov    (%eax),%al
  801fb7:	84 c0                	test   %al,%al
  801fb9:	75 e8                	jne    801fa3 <strnlen+0xf>
		n++;
	return n;
  801fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801fcc:	90                   	nop
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	8d 50 01             	lea    0x1(%eax),%edx
  801fd3:	89 55 08             	mov    %edx,0x8(%ebp)
  801fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd9:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fdc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fdf:	8a 12                	mov    (%edx),%dl
  801fe1:	88 10                	mov    %dl,(%eax)
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	84 c0                	test   %al,%al
  801fe7:	75 e4                	jne    801fcd <strcpy+0xd>
		/* do nothing */;
	return ret;
  801fe9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801ffa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802001:	eb 1f                	jmp    802022 <strncpy+0x34>
		*dst++ = *src;
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	8d 50 01             	lea    0x1(%eax),%edx
  802009:	89 55 08             	mov    %edx,0x8(%ebp)
  80200c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200f:	8a 12                	mov    (%edx),%dl
  802011:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802013:	8b 45 0c             	mov    0xc(%ebp),%eax
  802016:	8a 00                	mov    (%eax),%al
  802018:	84 c0                	test   %al,%al
  80201a:	74 03                	je     80201f <strncpy+0x31>
			src++;
  80201c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80201f:	ff 45 fc             	incl   -0x4(%ebp)
  802022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802025:	3b 45 10             	cmp    0x10(%ebp),%eax
  802028:	72 d9                	jb     802003 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80202a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80203b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80203f:	74 30                	je     802071 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802041:	eb 16                	jmp    802059 <strlcpy+0x2a>
			*dst++ = *src++;
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	8d 50 01             	lea    0x1(%eax),%edx
  802049:	89 55 08             	mov    %edx,0x8(%ebp)
  80204c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802052:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802055:	8a 12                	mov    (%edx),%dl
  802057:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802059:	ff 4d 10             	decl   0x10(%ebp)
  80205c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802060:	74 09                	je     80206b <strlcpy+0x3c>
  802062:	8b 45 0c             	mov    0xc(%ebp),%eax
  802065:	8a 00                	mov    (%eax),%al
  802067:	84 c0                	test   %al,%al
  802069:	75 d8                	jne    802043 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802071:	8b 55 08             	mov    0x8(%ebp),%edx
  802074:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802077:	29 c2                	sub    %eax,%edx
  802079:	89 d0                	mov    %edx,%eax
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802080:	eb 06                	jmp    802088 <strcmp+0xb>
		p++, q++;
  802082:	ff 45 08             	incl   0x8(%ebp)
  802085:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	8a 00                	mov    (%eax),%al
  80208d:	84 c0                	test   %al,%al
  80208f:	74 0e                	je     80209f <strcmp+0x22>
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	8a 10                	mov    (%eax),%dl
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	8a 00                	mov    (%eax),%al
  80209b:	38 c2                	cmp    %al,%dl
  80209d:	74 e3                	je     802082 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	8a 00                	mov    (%eax),%al
  8020a4:	0f b6 d0             	movzbl %al,%edx
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	8a 00                	mov    (%eax),%al
  8020ac:	0f b6 c0             	movzbl %al,%eax
  8020af:	29 c2                	sub    %eax,%edx
  8020b1:	89 d0                	mov    %edx,%eax
}
  8020b3:	5d                   	pop    %ebp
  8020b4:	c3                   	ret    

008020b5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8020b8:	eb 09                	jmp    8020c3 <strncmp+0xe>
		n--, p++, q++;
  8020ba:	ff 4d 10             	decl   0x10(%ebp)
  8020bd:	ff 45 08             	incl   0x8(%ebp)
  8020c0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8020c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c7:	74 17                	je     8020e0 <strncmp+0x2b>
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8a 00                	mov    (%eax),%al
  8020ce:	84 c0                	test   %al,%al
  8020d0:	74 0e                	je     8020e0 <strncmp+0x2b>
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8a 10                	mov    (%eax),%dl
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	8a 00                	mov    (%eax),%al
  8020dc:	38 c2                	cmp    %al,%dl
  8020de:	74 da                	je     8020ba <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8020e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e4:	75 07                	jne    8020ed <strncmp+0x38>
		return 0;
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	eb 14                	jmp    802101 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	8a 00                	mov    (%eax),%al
  8020f2:	0f b6 d0             	movzbl %al,%edx
  8020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f8:	8a 00                	mov    (%eax),%al
  8020fa:	0f b6 c0             	movzbl %al,%eax
  8020fd:	29 c2                	sub    %eax,%edx
  8020ff:	89 d0                	mov    %edx,%eax
}
  802101:	5d                   	pop    %ebp
  802102:	c3                   	ret    

00802103 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80210f:	eb 12                	jmp    802123 <strchr+0x20>
		if (*s == c)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8a 00                	mov    (%eax),%al
  802116:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802119:	75 05                	jne    802120 <strchr+0x1d>
			return (char *) s;
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	eb 11                	jmp    802131 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802120:	ff 45 08             	incl   0x8(%ebp)
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	8a 00                	mov    (%eax),%al
  802128:	84 c0                	test   %al,%al
  80212a:	75 e5                	jne    802111 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80213f:	eb 0d                	jmp    80214e <strfind+0x1b>
		if (*s == c)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8a 00                	mov    (%eax),%al
  802146:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802149:	74 0e                	je     802159 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80214b:	ff 45 08             	incl   0x8(%ebp)
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	84 c0                	test   %al,%al
  802155:	75 ea                	jne    802141 <strfind+0xe>
  802157:	eb 01                	jmp    80215a <strfind+0x27>
		if (*s == c)
			break;
  802159:	90                   	nop
	return (char *) s;
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80216b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80216f:	76 63                	jbe    8021d4 <memset+0x75>
		uint64 data_block = c;
  802171:	8b 45 0c             	mov    0xc(%ebp),%eax
  802174:	99                   	cltd   
  802175:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802178:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802181:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802185:	c1 e0 08             	shl    $0x8,%eax
  802188:	09 45 f0             	or     %eax,-0x10(%ebp)
  80218b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80218e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802194:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802198:	c1 e0 10             	shl    $0x10,%eax
  80219b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80219e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a7:	89 c2                	mov    %eax,%edx
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	09 45 f0             	or     %eax,-0x10(%ebp)
  8021b1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8021b4:	eb 18                	jmp    8021ce <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8021b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021b9:	8d 41 08             	lea    0x8(%ecx),%eax
  8021bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c5:	89 01                	mov    %eax,(%ecx)
  8021c7:	89 51 04             	mov    %edx,0x4(%ecx)
  8021ca:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8021ce:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021d2:	77 e2                	ja     8021b6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8021d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021d8:	74 23                	je     8021fd <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8021da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021e0:	eb 0e                	jmp    8021f0 <memset+0x91>
			*p8++ = (uint8)c;
  8021e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e5:	8d 50 01             	lea    0x1(%eax),%edx
  8021e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ee:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8021f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	75 e5                	jne    8021e2 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  802214:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802218:	76 24                	jbe    80223e <memcpy+0x3c>
		while(n >= 8){
  80221a:	eb 1c                	jmp    802238 <memcpy+0x36>
			*d64 = *s64;
  80221c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221f:	8b 50 04             	mov    0x4(%eax),%edx
  802222:	8b 00                	mov    (%eax),%eax
  802224:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802227:	89 01                	mov    %eax,(%ecx)
  802229:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80222c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802230:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802234:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802238:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80223c:	77 de                	ja     80221c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80223e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802242:	74 31                	je     802275 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802244:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802247:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80224a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80224d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802250:	eb 16                	jmp    802268 <memcpy+0x66>
			*d8++ = *s8++;
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802255:	8d 50 01             	lea    0x1(%eax),%edx
  802258:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80225b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802261:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802264:	8a 12                	mov    (%edx),%dl
  802266:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802268:	8b 45 10             	mov    0x10(%ebp),%eax
  80226b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80226e:	89 55 10             	mov    %edx,0x10(%ebp)
  802271:	85 c0                	test   %eax,%eax
  802273:	75 dd                	jne    802252 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80228c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80228f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802292:	73 50                	jae    8022e4 <memmove+0x6a>
  802294:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802297:	8b 45 10             	mov    0x10(%ebp),%eax
  80229a:	01 d0                	add    %edx,%eax
  80229c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80229f:	76 43                	jbe    8022e4 <memmove+0x6a>
		s += n;
  8022a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8022a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022aa:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8022ad:	eb 10                	jmp    8022bf <memmove+0x45>
			*--d = *--s;
  8022af:	ff 4d f8             	decl   -0x8(%ebp)
  8022b2:	ff 4d fc             	decl   -0x4(%ebp)
  8022b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b8:	8a 10                	mov    (%eax),%dl
  8022ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022bd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8022bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	75 e3                	jne    8022af <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8022cc:	eb 23                	jmp    8022f1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8022ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022d1:	8d 50 01             	lea    0x1(%eax),%edx
  8022d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022dd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022e0:	8a 12                	mov    (%edx),%dl
  8022e2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8022e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	75 dd                	jne    8022ce <memmove+0x54>
			*d++ = *s++;

	return dst;
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802302:	8b 45 0c             	mov    0xc(%ebp),%eax
  802305:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802308:	eb 2a                	jmp    802334 <memcmp+0x3e>
		if (*s1 != *s2)
  80230a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230d:	8a 10                	mov    (%eax),%dl
  80230f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802312:	8a 00                	mov    (%eax),%al
  802314:	38 c2                	cmp    %al,%dl
  802316:	74 16                	je     80232e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802318:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80231b:	8a 00                	mov    (%eax),%al
  80231d:	0f b6 d0             	movzbl %al,%edx
  802320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802323:	8a 00                	mov    (%eax),%al
  802325:	0f b6 c0             	movzbl %al,%eax
  802328:	29 c2                	sub    %eax,%edx
  80232a:	89 d0                	mov    %edx,%eax
  80232c:	eb 18                	jmp    802346 <memcmp+0x50>
		s1++, s2++;
  80232e:	ff 45 fc             	incl   -0x4(%ebp)
  802331:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802334:	8b 45 10             	mov    0x10(%ebp),%eax
  802337:	8d 50 ff             	lea    -0x1(%eax),%edx
  80233a:	89 55 10             	mov    %edx,0x10(%ebp)
  80233d:	85 c0                	test   %eax,%eax
  80233f:	75 c9                	jne    80230a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80234e:	8b 55 08             	mov    0x8(%ebp),%edx
  802351:	8b 45 10             	mov    0x10(%ebp),%eax
  802354:	01 d0                	add    %edx,%eax
  802356:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802359:	eb 15                	jmp    802370 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	8a 00                	mov    (%eax),%al
  802360:	0f b6 d0             	movzbl %al,%edx
  802363:	8b 45 0c             	mov    0xc(%ebp),%eax
  802366:	0f b6 c0             	movzbl %al,%eax
  802369:	39 c2                	cmp    %eax,%edx
  80236b:	74 0d                	je     80237a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80236d:	ff 45 08             	incl   0x8(%ebp)
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802376:	72 e3                	jb     80235b <memfind+0x13>
  802378:	eb 01                	jmp    80237b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80237a:	90                   	nop
	return (void *) s;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80238d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802394:	eb 03                	jmp    802399 <strtol+0x19>
		s++;
  802396:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8a 00                	mov    (%eax),%al
  80239e:	3c 20                	cmp    $0x20,%al
  8023a0:	74 f4                	je     802396 <strtol+0x16>
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8a 00                	mov    (%eax),%al
  8023a7:	3c 09                	cmp    $0x9,%al
  8023a9:	74 eb                	je     802396 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8a 00                	mov    (%eax),%al
  8023b0:	3c 2b                	cmp    $0x2b,%al
  8023b2:	75 05                	jne    8023b9 <strtol+0x39>
		s++;
  8023b4:	ff 45 08             	incl   0x8(%ebp)
  8023b7:	eb 13                	jmp    8023cc <strtol+0x4c>
	else if (*s == '-')
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	8a 00                	mov    (%eax),%al
  8023be:	3c 2d                	cmp    $0x2d,%al
  8023c0:	75 0a                	jne    8023cc <strtol+0x4c>
		s++, neg = 1;
  8023c2:	ff 45 08             	incl   0x8(%ebp)
  8023c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d0:	74 06                	je     8023d8 <strtol+0x58>
  8023d2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8023d6:	75 20                	jne    8023f8 <strtol+0x78>
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	8a 00                	mov    (%eax),%al
  8023dd:	3c 30                	cmp    $0x30,%al
  8023df:	75 17                	jne    8023f8 <strtol+0x78>
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	40                   	inc    %eax
  8023e5:	8a 00                	mov    (%eax),%al
  8023e7:	3c 78                	cmp    $0x78,%al
  8023e9:	75 0d                	jne    8023f8 <strtol+0x78>
		s += 2, base = 16;
  8023eb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8023ef:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8023f6:	eb 28                	jmp    802420 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8023f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023fc:	75 15                	jne    802413 <strtol+0x93>
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	8a 00                	mov    (%eax),%al
  802403:	3c 30                	cmp    $0x30,%al
  802405:	75 0c                	jne    802413 <strtol+0x93>
		s++, base = 8;
  802407:	ff 45 08             	incl   0x8(%ebp)
  80240a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802411:	eb 0d                	jmp    802420 <strtol+0xa0>
	else if (base == 0)
  802413:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802417:	75 07                	jne    802420 <strtol+0xa0>
		base = 10;
  802419:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	8a 00                	mov    (%eax),%al
  802425:	3c 2f                	cmp    $0x2f,%al
  802427:	7e 19                	jle    802442 <strtol+0xc2>
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	8a 00                	mov    (%eax),%al
  80242e:	3c 39                	cmp    $0x39,%al
  802430:	7f 10                	jg     802442 <strtol+0xc2>
			dig = *s - '0';
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	8a 00                	mov    (%eax),%al
  802437:	0f be c0             	movsbl %al,%eax
  80243a:	83 e8 30             	sub    $0x30,%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802440:	eb 42                	jmp    802484 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	8a 00                	mov    (%eax),%al
  802447:	3c 60                	cmp    $0x60,%al
  802449:	7e 19                	jle    802464 <strtol+0xe4>
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	8a 00                	mov    (%eax),%al
  802450:	3c 7a                	cmp    $0x7a,%al
  802452:	7f 10                	jg     802464 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	8a 00                	mov    (%eax),%al
  802459:	0f be c0             	movsbl %al,%eax
  80245c:	83 e8 57             	sub    $0x57,%eax
  80245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802462:	eb 20                	jmp    802484 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	8a 00                	mov    (%eax),%al
  802469:	3c 40                	cmp    $0x40,%al
  80246b:	7e 39                	jle    8024a6 <strtol+0x126>
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	8a 00                	mov    (%eax),%al
  802472:	3c 5a                	cmp    $0x5a,%al
  802474:	7f 30                	jg     8024a6 <strtol+0x126>
			dig = *s - 'A' + 10;
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	8a 00                	mov    (%eax),%al
  80247b:	0f be c0             	movsbl %al,%eax
  80247e:	83 e8 37             	sub    $0x37,%eax
  802481:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	3b 45 10             	cmp    0x10(%ebp),%eax
  80248a:	7d 19                	jge    8024a5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80248c:	ff 45 08             	incl   0x8(%ebp)
  80248f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802492:	0f af 45 10          	imul   0x10(%ebp),%eax
  802496:	89 c2                	mov    %eax,%edx
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	01 d0                	add    %edx,%eax
  80249d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8024a0:	e9 7b ff ff ff       	jmp    802420 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8024a5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8024a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024aa:	74 08                	je     8024b4 <strtol+0x134>
		*endptr = (char *) s;
  8024ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024af:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024b8:	74 07                	je     8024c1 <strtol+0x141>
  8024ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024bd:	f7 d8                	neg    %eax
  8024bf:	eb 03                	jmp    8024c4 <strtol+0x144>
  8024c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <ltostr>:

void
ltostr(long value, char *str)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8024cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8024d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8024da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024de:	79 13                	jns    8024f3 <ltostr+0x2d>
	{
		neg = 1;
  8024e0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8024e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ea:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8024ed:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8024f0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8024fb:	99                   	cltd   
  8024fc:	f7 f9                	idiv   %ecx
  8024fe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802501:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802504:	8d 50 01             	lea    0x1(%eax),%edx
  802507:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80250a:	89 c2                	mov    %eax,%edx
  80250c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250f:	01 d0                	add    %edx,%eax
  802511:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802514:	83 c2 30             	add    $0x30,%edx
  802517:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802519:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802521:	f7 e9                	imul   %ecx
  802523:	c1 fa 02             	sar    $0x2,%edx
  802526:	89 c8                	mov    %ecx,%eax
  802528:	c1 f8 1f             	sar    $0x1f,%eax
  80252b:	29 c2                	sub    %eax,%edx
  80252d:	89 d0                	mov    %edx,%eax
  80252f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802532:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802536:	75 bb                	jne    8024f3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80253f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802542:	48                   	dec    %eax
  802543:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802546:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80254a:	74 3d                	je     802589 <ltostr+0xc3>
		start = 1 ;
  80254c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802553:	eb 34                	jmp    802589 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255b:	01 d0                	add    %edx,%eax
  80255d:	8a 00                	mov    (%eax),%al
  80255f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802565:	8b 45 0c             	mov    0xc(%ebp),%eax
  802568:	01 c2                	add    %eax,%edx
  80256a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80256d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802570:	01 c8                	add    %ecx,%eax
  802572:	8a 00                	mov    (%eax),%al
  802574:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802576:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8a 45 eb             	mov    -0x15(%ebp),%al
  802581:	88 02                	mov    %al,(%edx)
		start++ ;
  802583:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802586:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80258f:	7c c4                	jl     802555 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802591:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802594:	8b 45 0c             	mov    0xc(%ebp),%eax
  802597:	01 d0                	add    %edx,%eax
  802599:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80259c:	90                   	nop
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8025a5:	ff 75 08             	pushl  0x8(%ebp)
  8025a8:	e8 c4 f9 ff ff       	call   801f71 <strlen>
  8025ad:	83 c4 04             	add    $0x4,%esp
  8025b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8025b3:	ff 75 0c             	pushl  0xc(%ebp)
  8025b6:	e8 b6 f9 ff ff       	call   801f71 <strlen>
  8025bb:	83 c4 04             	add    $0x4,%esp
  8025be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8025c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8025c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025cf:	eb 17                	jmp    8025e8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8025d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d7:	01 c2                	add    %eax,%edx
  8025d9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	01 c8                	add    %ecx,%eax
  8025e1:	8a 00                	mov    (%eax),%al
  8025e3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8025e5:	ff 45 fc             	incl   -0x4(%ebp)
  8025e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025ee:	7c e1                	jl     8025d1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8025f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8025f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8025fe:	eb 1f                	jmp    80261f <strcconcat+0x80>
		final[s++] = str2[i] ;
  802600:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802603:	8d 50 01             	lea    0x1(%eax),%edx
  802606:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802609:	89 c2                	mov    %eax,%edx
  80260b:	8b 45 10             	mov    0x10(%ebp),%eax
  80260e:	01 c2                	add    %eax,%edx
  802610:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802613:	8b 45 0c             	mov    0xc(%ebp),%eax
  802616:	01 c8                	add    %ecx,%eax
  802618:	8a 00                	mov    (%eax),%al
  80261a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80261c:	ff 45 f8             	incl   -0x8(%ebp)
  80261f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802622:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802625:	7c d9                	jl     802600 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802627:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80262a:	8b 45 10             	mov    0x10(%ebp),%eax
  80262d:	01 d0                	add    %edx,%eax
  80262f:	c6 00 00             	movb   $0x0,(%eax)
}
  802632:	90                   	nop
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802638:	8b 45 14             	mov    0x14(%ebp),%eax
  80263b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802641:	8b 45 14             	mov    0x14(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80264d:	8b 45 10             	mov    0x10(%ebp),%eax
  802650:	01 d0                	add    %edx,%eax
  802652:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802658:	eb 0c                	jmp    802666 <strsplit+0x31>
			*string++ = 0;
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	8d 50 01             	lea    0x1(%eax),%edx
  802660:	89 55 08             	mov    %edx,0x8(%ebp)
  802663:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	8a 00                	mov    (%eax),%al
  80266b:	84 c0                	test   %al,%al
  80266d:	74 18                	je     802687 <strsplit+0x52>
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	8a 00                	mov    (%eax),%al
  802674:	0f be c0             	movsbl %al,%eax
  802677:	50                   	push   %eax
  802678:	ff 75 0c             	pushl  0xc(%ebp)
  80267b:	e8 83 fa ff ff       	call   802103 <strchr>
  802680:	83 c4 08             	add    $0x8,%esp
  802683:	85 c0                	test   %eax,%eax
  802685:	75 d3                	jne    80265a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8a 00                	mov    (%eax),%al
  80268c:	84 c0                	test   %al,%al
  80268e:	74 5a                	je     8026ea <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802690:	8b 45 14             	mov    0x14(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	83 f8 0f             	cmp    $0xf,%eax
  802698:	75 07                	jne    8026a1 <strsplit+0x6c>
		{
			return 0;
  80269a:	b8 00 00 00 00       	mov    $0x0,%eax
  80269f:	eb 66                	jmp    802707 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8026a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8026a9:	8b 55 14             	mov    0x14(%ebp),%edx
  8026ac:	89 0a                	mov    %ecx,(%edx)
  8026ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b8:	01 c2                	add    %eax,%edx
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026bf:	eb 03                	jmp    8026c4 <strsplit+0x8f>
			string++;
  8026c1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	8a 00                	mov    (%eax),%al
  8026c9:	84 c0                	test   %al,%al
  8026cb:	74 8b                	je     802658 <strsplit+0x23>
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	8a 00                	mov    (%eax),%al
  8026d2:	0f be c0             	movsbl %al,%eax
  8026d5:	50                   	push   %eax
  8026d6:	ff 75 0c             	pushl  0xc(%ebp)
  8026d9:	e8 25 fa ff ff       	call   802103 <strchr>
  8026de:	83 c4 08             	add    $0x8,%esp
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 dc                	je     8026c1 <strsplit+0x8c>
			string++;
	}
  8026e5:	e9 6e ff ff ff       	jmp    802658 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8026ea:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8026eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80271c:	eb 4a                	jmp    802768 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80271e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	01 c2                	add    %eax,%edx
  802726:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272c:	01 c8                	add    %ecx,%eax
  80272e:	8a 00                	mov    (%eax),%al
  802730:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802732:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802735:	8b 45 0c             	mov    0xc(%ebp),%eax
  802738:	01 d0                	add    %edx,%eax
  80273a:	8a 00                	mov    (%eax),%al
  80273c:	3c 40                	cmp    $0x40,%al
  80273e:	7e 25                	jle    802765 <str2lower+0x5c>
  802740:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802743:	8b 45 0c             	mov    0xc(%ebp),%eax
  802746:	01 d0                	add    %edx,%eax
  802748:	8a 00                	mov    (%eax),%al
  80274a:	3c 5a                	cmp    $0x5a,%al
  80274c:	7f 17                	jg     802765 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80274e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	01 d0                	add    %edx,%eax
  802756:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802759:	8b 55 08             	mov    0x8(%ebp),%edx
  80275c:	01 ca                	add    %ecx,%edx
  80275e:	8a 12                	mov    (%edx),%dl
  802760:	83 c2 20             	add    $0x20,%edx
  802763:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802765:	ff 45 fc             	incl   -0x4(%ebp)
  802768:	ff 75 0c             	pushl  0xc(%ebp)
  80276b:	e8 01 f8 ff ff       	call   801f71 <strlen>
  802770:	83 c4 04             	add    $0x4,%esp
  802773:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802776:	7f a6                	jg     80271e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802778:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  802783:	83 ec 0c             	sub    $0xc,%esp
  802786:	6a 10                	push   $0x10
  802788:	e8 b2 15 00 00       	call   803d3f <alloc_block>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  802793:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802797:	75 14                	jne    8027ad <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	68 68 59 80 00       	push   $0x805968
  8027a1:	6a 14                	push   $0x14
  8027a3:	68 91 59 80 00       	push   $0x805991
  8027a8:	e8 fd ed ff ff       	call   8015aa <_panic>

	node->start = start;
  8027ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b3:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bb:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8027be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8027c5:	a1 04 72 80 00       	mov    0x807204,%eax
  8027ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cd:	eb 18                	jmp    8027e7 <insert_page_alloc+0x6a>
		if (start < it->start)
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d7:	77 37                	ja     802810 <insert_page_alloc+0x93>
			break;
		prev = it;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8027df:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8027e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	74 08                	je     8027f5 <insert_page_alloc+0x78>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	eb 05                	jmp    8027fa <insert_page_alloc+0x7d>
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	a3 0c 72 80 00       	mov    %eax,0x80720c
  8027ff:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	75 c7                	jne    8027cf <insert_page_alloc+0x52>
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	75 c1                	jne    8027cf <insert_page_alloc+0x52>
  80280e:	eb 01                	jmp    802811 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  802810:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  802811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802815:	75 64                	jne    80287b <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  802817:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80281b:	75 14                	jne    802831 <insert_page_alloc+0xb4>
  80281d:	83 ec 04             	sub    $0x4,%esp
  802820:	68 a0 59 80 00       	push   $0x8059a0
  802825:	6a 21                	push   $0x21
  802827:	68 91 59 80 00       	push   $0x805991
  80282c:	e8 79 ed ff ff       	call   8015aa <_panic>
  802831:	8b 15 04 72 80 00    	mov    0x807204,%edx
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	89 50 08             	mov    %edx,0x8(%eax)
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	8b 40 08             	mov    0x8(%eax),%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	74 0d                	je     802854 <insert_page_alloc+0xd7>
  802847:	a1 04 72 80 00       	mov    0x807204,%eax
  80284c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80284f:	89 50 0c             	mov    %edx,0xc(%eax)
  802852:	eb 08                	jmp    80285c <insert_page_alloc+0xdf>
  802854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802857:	a3 08 72 80 00       	mov    %eax,0x807208
  80285c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285f:	a3 04 72 80 00       	mov    %eax,0x807204
  802864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802867:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80286e:	a1 10 72 80 00       	mov    0x807210,%eax
  802873:	40                   	inc    %eax
  802874:	a3 10 72 80 00       	mov    %eax,0x807210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  802879:	eb 71                	jmp    8028ec <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  80287b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287f:	74 06                	je     802887 <insert_page_alloc+0x10a>
  802881:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802885:	75 14                	jne    80289b <insert_page_alloc+0x11e>
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 c4 59 80 00       	push   $0x8059c4
  80288f:	6a 23                	push   $0x23
  802891:	68 91 59 80 00       	push   $0x805991
  802896:	e8 0f ed ff ff       	call   8015aa <_panic>
  80289b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289e:	8b 50 08             	mov    0x8(%eax),%edx
  8028a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a4:	89 50 08             	mov    %edx,0x8(%eax)
  8028a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028aa:	8b 40 08             	mov    0x8(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0c                	je     8028bd <insert_page_alloc+0x140>
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	8b 40 08             	mov    0x8(%eax),%eax
  8028b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ba:	89 50 0c             	mov    %edx,0xc(%eax)
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c3:	89 50 08             	mov    %edx,0x8(%eax)
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cc:	89 50 0c             	mov    %edx,0xc(%eax)
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 40 08             	mov    0x8(%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	75 08                	jne    8028e1 <insert_page_alloc+0x164>
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	a3 08 72 80 00       	mov    %eax,0x807208
  8028e1:	a1 10 72 80 00       	mov    0x807210,%eax
  8028e6:	40                   	inc    %eax
  8028e7:	a3 10 72 80 00       	mov    %eax,0x807210
}
  8028ec:	90                   	nop
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    

008028ef <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
  8028f2:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8028f5:	a1 04 72 80 00       	mov    0x807204,%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	75 0c                	jne    80290a <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8028fe:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802903:	a3 50 f2 81 00       	mov    %eax,0x81f250
		return;
  802908:	eb 67                	jmp    802971 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80290a:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80290f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802912:	a1 04 72 80 00       	mov    0x807204,%eax
  802917:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80291a:	eb 26                	jmp    802942 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  80291c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80291f:	8b 10                	mov    (%eax),%edx
  802921:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802924:	8b 40 04             	mov    0x4(%eax),%eax
  802927:	01 d0                	add    %edx,%eax
  802929:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802932:	76 06                	jbe    80293a <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80293a:	a1 0c 72 80 00       	mov    0x80720c,%eax
  80293f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802942:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802946:	74 08                	je     802950 <recompute_page_alloc_break+0x61>
  802948:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80294b:	8b 40 08             	mov    0x8(%eax),%eax
  80294e:	eb 05                	jmp    802955 <recompute_page_alloc_break+0x66>
  802950:	b8 00 00 00 00       	mov    $0x0,%eax
  802955:	a3 0c 72 80 00       	mov    %eax,0x80720c
  80295a:	a1 0c 72 80 00       	mov    0x80720c,%eax
  80295f:	85 c0                	test   %eax,%eax
  802961:	75 b9                	jne    80291c <recompute_page_alloc_break+0x2d>
  802963:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802967:	75 b3                	jne    80291c <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  802969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80296c:	a3 50 f2 81 00       	mov    %eax,0x81f250
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  802979:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802980:	8b 55 08             	mov    0x8(%ebp),%edx
  802983:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802986:	01 d0                	add    %edx,%eax
  802988:	48                   	dec    %eax
  802989:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80298c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80298f:	ba 00 00 00 00       	mov    $0x0,%edx
  802994:	f7 75 d8             	divl   -0x28(%ebp)
  802997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80299a:	29 d0                	sub    %edx,%eax
  80299c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80299f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8029a3:	75 0a                	jne    8029af <alloc_pages_custom_fit+0x3c>
		return NULL;
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029aa:	e9 7e 01 00 00       	jmp    802b2d <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8029af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8029b6:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  8029ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  8029c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8029c8:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8029cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8029d0:	a1 04 72 80 00       	mov    0x807204,%eax
  8029d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8029d8:	eb 69                	jmp    802a43 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8029da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029e2:	76 47                	jbe    802a2b <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8029e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8029ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029f2:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8029f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029f8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8029fb:	72 2e                	jb     802a2b <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8029fd:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802a01:	75 14                	jne    802a17 <alloc_pages_custom_fit+0xa4>
  802a03:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a06:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a09:	75 0c                	jne    802a17 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  802a0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  802a11:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802a15:	eb 14                	jmp    802a2b <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802a17:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a1a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a1d:	76 0c                	jbe    802a2b <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802a1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a22:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  802a25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a28:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2e:	8b 10                	mov    (%eax),%edx
  802a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	01 d0                	add    %edx,%eax
  802a38:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802a3b:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802a40:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802a43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a47:	74 08                	je     802a51 <alloc_pages_custom_fit+0xde>
  802a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a4c:	8b 40 08             	mov    0x8(%eax),%eax
  802a4f:	eb 05                	jmp    802a56 <alloc_pages_custom_fit+0xe3>
  802a51:	b8 00 00 00 00       	mov    $0x0,%eax
  802a56:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802a5b:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	0f 85 72 ff ff ff    	jne    8029da <alloc_pages_custom_fit+0x67>
  802a68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a6c:	0f 85 68 ff ff ff    	jne    8029da <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802a72:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802a77:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a7a:	76 47                	jbe    802ac3 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802a82:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802a87:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a8a:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802a8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a90:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a93:	72 2e                	jb     802ac3 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802a95:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802a99:	75 14                	jne    802aaf <alloc_pages_custom_fit+0x13c>
  802a9b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a9e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802aa1:	75 0c                	jne    802aaf <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802aa3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802aa9:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802aad:	eb 14                	jmp    802ac3 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802aaf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ab2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ab5:	76 0c                	jbe    802ac3 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802ab7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802aba:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802abd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ac0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802ac3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802aca:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802ace:	74 08                	je     802ad8 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ad6:	eb 40                	jmp    802b18 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802ad8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802adc:	74 08                	je     802ae6 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ae4:	eb 32                	jmp    802b18 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802ae6:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802aeb:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802aee:	89 c2                	mov    %eax,%edx
  802af0:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802af5:	39 c2                	cmp    %eax,%edx
  802af7:	73 07                	jae    802b00 <alloc_pages_custom_fit+0x18d>
			return NULL;
  802af9:	b8 00 00 00 00       	mov    $0x0,%eax
  802afe:	eb 2d                	jmp    802b2d <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802b00:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802b05:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802b08:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802b0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b11:	01 d0                	add    %edx,%eax
  802b13:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}


	insert_page_alloc((uint32)result, required_size);
  802b18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b1b:	83 ec 08             	sub    $0x8,%esp
  802b1e:	ff 75 d0             	pushl  -0x30(%ebp)
  802b21:	50                   	push   %eax
  802b22:	e8 56 fc ff ff       	call   80277d <insert_page_alloc>
  802b27:	83 c4 10             	add    $0x10,%esp

	return result;
  802b2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802b2d:	c9                   	leave  
  802b2e:	c3                   	ret    

00802b2f <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
  802b32:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b3b:	a1 04 72 80 00       	mov    0x807204,%eax
  802b40:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b43:	eb 1a                	jmp    802b5f <find_allocated_size+0x30>
		if (it->start == va)
  802b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802b4d:	75 08                	jne    802b57 <find_allocated_size+0x28>
			return it->size;
  802b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	eb 34                	jmp    802b8b <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b57:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802b5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b63:	74 08                	je     802b6d <find_allocated_size+0x3e>
  802b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b68:	8b 40 08             	mov    0x8(%eax),%eax
  802b6b:	eb 05                	jmp    802b72 <find_allocated_size+0x43>
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b72:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802b77:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	75 c5                	jne    802b45 <find_allocated_size+0x16>
  802b80:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b84:	75 bf                	jne    802b45 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b8b:	c9                   	leave  
  802b8c:	c3                   	ret    

00802b8d <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802b8d:	55                   	push   %ebp
  802b8e:	89 e5                	mov    %esp,%ebp
  802b90:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b99:	a1 04 72 80 00       	mov    0x807204,%eax
  802b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba1:	e9 e1 01 00 00       	jmp    802d87 <free_pages+0x1fa>
		if (it->start == va) {
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bae:	0f 85 cb 01 00 00    	jne    802d7f <free_pages+0x1f2>

			uint32 start = it->start;
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 40 04             	mov    0x4(%eax),%eax
  802bc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc8:	f7 d0                	not    %eax
  802bca:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802bcd:	73 1d                	jae    802bec <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802bcf:	83 ec 0c             	sub    $0xc,%esp
  802bd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  802bd8:	68 f8 59 80 00       	push   $0x8059f8
  802bdd:	68 a5 00 00 00       	push   $0xa5
  802be2:	68 91 59 80 00       	push   $0x805991
  802be7:	e8 be e9 ff ff       	call   8015aa <_panic>
			}

			uint32 start_end = start + size;
  802bec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf2:	01 d0                	add    %edx,%eax
  802bf4:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	79 19                	jns    802c17 <free_pages+0x8a>
  802bfe:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802c05:	77 10                	ja     802c17 <free_pages+0x8a>
  802c07:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802c0e:	77 07                	ja     802c17 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	78 2c                	js     802c43 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1a:	83 ec 0c             	sub    $0xc,%esp
  802c1d:	68 00 00 00 a0       	push   $0xa0000000
  802c22:	ff 75 e0             	pushl  -0x20(%ebp)
  802c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c28:	ff 75 e8             	pushl  -0x18(%ebp)
  802c2b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c2e:	50                   	push   %eax
  802c2f:	68 3c 5a 80 00       	push   $0x805a3c
  802c34:	68 ad 00 00 00       	push   $0xad
  802c39:	68 91 59 80 00       	push   $0x805991
  802c3e:	e8 67 e9 ff ff       	call   8015aa <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c49:	e9 88 00 00 00       	jmp    802cd6 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802c4e:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802c55:	76 17                	jbe    802c6e <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802c57:	ff 75 f0             	pushl  -0x10(%ebp)
  802c5a:	68 a0 5a 80 00       	push   $0x805aa0
  802c5f:	68 b4 00 00 00       	push   $0xb4
  802c64:	68 91 59 80 00       	push   $0x805991
  802c69:	e8 3c e9 ff ff       	call   8015aa <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	05 00 10 00 00       	add    $0x1000,%eax
  802c76:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	79 2e                	jns    802cae <free_pages+0x121>
  802c80:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802c87:	77 25                	ja     802cae <free_pages+0x121>
  802c89:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802c90:	77 1c                	ja     802cae <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802c92:	83 ec 08             	sub    $0x8,%esp
  802c95:	68 00 10 00 00       	push   $0x1000
  802c9a:	ff 75 f0             	pushl  -0x10(%ebp)
  802c9d:	e8 38 0d 00 00       	call   8039da <sys_free_user_mem>
  802ca2:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802ca5:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802cac:	eb 28                	jmp    802cd6 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	68 00 00 00 a0       	push   $0xa0000000
  802cb6:	ff 75 dc             	pushl  -0x24(%ebp)
  802cb9:	68 00 10 00 00       	push   $0x1000
  802cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  802cc1:	50                   	push   %eax
  802cc2:	68 e0 5a 80 00       	push   $0x805ae0
  802cc7:	68 bd 00 00 00       	push   $0xbd
  802ccc:	68 91 59 80 00       	push   $0x805991
  802cd1:	e8 d4 e8 ff ff       	call   8015aa <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cdc:	0f 82 6c ff ff ff    	jb     802c4e <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802ce2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce6:	75 17                	jne    802cff <free_pages+0x172>
  802ce8:	83 ec 04             	sub    $0x4,%esp
  802ceb:	68 42 5b 80 00       	push   $0x805b42
  802cf0:	68 c1 00 00 00       	push   $0xc1
  802cf5:	68 91 59 80 00       	push   $0x805991
  802cfa:	e8 ab e8 ff ff       	call   8015aa <_panic>
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 08             	mov    0x8(%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 11                	je     802d1a <free_pages+0x18d>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 08             	mov    0x8(%eax),%eax
  802d0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d12:	8b 52 0c             	mov    0xc(%edx),%edx
  802d15:	89 50 0c             	mov    %edx,0xc(%eax)
  802d18:	eb 0b                	jmp    802d25 <free_pages+0x198>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d20:	a3 08 72 80 00       	mov    %eax,0x807208
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 11                	je     802d40 <free_pages+0x1b3>
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 0c             	mov    0xc(%eax),%eax
  802d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d38:	8b 52 08             	mov    0x8(%edx),%edx
  802d3b:	89 50 08             	mov    %edx,0x8(%eax)
  802d3e:	eb 0b                	jmp    802d4b <free_pages+0x1be>
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 40 08             	mov    0x8(%eax),%eax
  802d46:	a3 04 72 80 00       	mov    %eax,0x807204
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d5f:	a1 10 72 80 00       	mov    0x807210,%eax
  802d64:	48                   	dec    %eax
  802d65:	a3 10 72 80 00       	mov    %eax,0x807210
			free_block(it);
  802d6a:	83 ec 0c             	sub    $0xc,%esp
  802d6d:	ff 75 f4             	pushl  -0xc(%ebp)
  802d70:	e8 24 15 00 00       	call   804299 <free_block>
  802d75:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802d78:	e8 72 fb ff ff       	call   8028ef <recompute_page_alloc_break>

			return;
  802d7d:	eb 37                	jmp    802db6 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802d7f:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	74 08                	je     802d95 <free_pages+0x208>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 40 08             	mov    0x8(%eax),%eax
  802d93:	eb 05                	jmp    802d9a <free_pages+0x20d>
  802d95:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9a:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802d9f:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	0f 85 fa fd ff ff    	jne    802ba6 <free_pages+0x19>
  802dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db0:	0f 85 f0 fd ff ff    	jne    802ba6 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802db6:	c9                   	leave  
  802db7:	c3                   	ret    

00802db8 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc0:	5d                   	pop    %ebp
  802dc1:	c3                   	ret    

00802dc2 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802dc8:	a1 08 70 80 00       	mov    0x807008,%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	74 60                	je     802e31 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802dd1:	83 ec 08             	sub    $0x8,%esp
  802dd4:	68 00 00 00 82       	push   $0x82000000
  802dd9:	68 00 00 00 80       	push   $0x80000000
  802dde:	e8 0d 0d 00 00       	call   803af0 <initialize_dynamic_allocator>
  802de3:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802de6:	e8 f3 0a 00 00       	call   8038de <sys_get_uheap_strategy>
  802deb:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802df0:	a1 20 72 80 00       	mov    0x807220,%eax
  802df5:	05 00 10 00 00       	add    $0x1000,%eax
  802dfa:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802dff:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802e04:	a3 50 f2 81 00       	mov    %eax,0x81f250

		LIST_INIT(&page_alloc_list);
  802e09:	c7 05 04 72 80 00 00 	movl   $0x0,0x807204
  802e10:	00 00 00 
  802e13:	c7 05 08 72 80 00 00 	movl   $0x0,0x807208
  802e1a:	00 00 00 
  802e1d:	c7 05 10 72 80 00 00 	movl   $0x0,0x807210
  802e24:	00 00 00 

		__firstTimeFlag = 0;
  802e27:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  802e2e:	00 00 00 
	}
}
  802e31:	90                   	nop
  802e32:	c9                   	leave  
  802e33:	c3                   	ret    

00802e34 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802e34:	55                   	push   %ebp
  802e35:	89 e5                	mov    %esp,%ebp
  802e37:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e48:	83 ec 08             	sub    $0x8,%esp
  802e4b:	68 06 04 00 00       	push   $0x406
  802e50:	50                   	push   %eax
  802e51:	e8 d2 06 00 00       	call   803528 <__sys_allocate_page>
  802e56:	83 c4 10             	add    $0x10,%esp
  802e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802e5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e60:	79 17                	jns    802e79 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802e62:	83 ec 04             	sub    $0x4,%esp
  802e65:	68 60 5b 80 00       	push   $0x805b60
  802e6a:	68 ea 00 00 00       	push   $0xea
  802e6f:	68 91 59 80 00       	push   $0x805991
  802e74:	e8 31 e7 ff ff       	call   8015aa <_panic>
	return 0;
  802e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
  802e83:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e94:	83 ec 0c             	sub    $0xc,%esp
  802e97:	50                   	push   %eax
  802e98:	e8 d2 06 00 00       	call   80356f <__sys_unmap_frame>
  802e9d:	83 c4 10             	add    $0x10,%esp
  802ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802ea3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea7:	79 17                	jns    802ec0 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 9c 5b 80 00       	push   $0x805b9c
  802eb1:	68 f5 00 00 00       	push   $0xf5
  802eb6:	68 91 59 80 00       	push   $0x805991
  802ebb:	e8 ea e6 ff ff       	call   8015aa <_panic>
}
  802ec0:	90                   	nop
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    

00802ec3 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802ec3:	55                   	push   %ebp
  802ec4:	89 e5                	mov    %esp,%ebp
  802ec6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802ec9:	e8 f4 fe ff ff       	call   802dc2 <uheap_init>
	if (size == 0) return NULL ;
  802ece:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed2:	75 0a                	jne    802ede <malloc+0x1b>
  802ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed9:	e9 67 01 00 00       	jmp    803045 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802ede:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802ee5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802eec:	77 16                	ja     802f04 <malloc+0x41>
		result = alloc_block(size);
  802eee:	83 ec 0c             	sub    $0xc,%esp
  802ef1:	ff 75 08             	pushl  0x8(%ebp)
  802ef4:	e8 46 0e 00 00       	call   803d3f <alloc_block>
  802ef9:	83 c4 10             	add    $0x10,%esp
  802efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eff:	e9 3e 01 00 00       	jmp    803042 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802f04:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f11:	01 d0                	add    %edx,%eax
  802f13:	48                   	dec    %eax
  802f14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  802f1f:	f7 75 f0             	divl   -0x10(%ebp)
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	29 d0                	sub    %edx,%eax
  802f27:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802f2a:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	75 0a                	jne    802f3d <malloc+0x7a>
			return NULL;
  802f33:	b8 00 00 00 00       	mov    $0x0,%eax
  802f38:	e9 08 01 00 00       	jmp    803045 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802f3d:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 0f                	je     802f55 <malloc+0x92>
  802f46:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802f4c:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802f51:	39 c2                	cmp    %eax,%edx
  802f53:	73 0a                	jae    802f5f <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802f55:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802f5a:	a3 50 f2 81 00       	mov    %eax,0x81f250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802f5f:	a1 44 f2 81 00       	mov    0x81f244,%eax
  802f64:	83 f8 05             	cmp    $0x5,%eax
  802f67:	75 11                	jne    802f7a <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802f69:	83 ec 0c             	sub    $0xc,%esp
  802f6c:	ff 75 e8             	pushl  -0x18(%ebp)
  802f6f:	e8 ff f9 ff ff       	call   802973 <alloc_pages_custom_fit>
  802f74:	83 c4 10             	add    $0x10,%esp
  802f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7e:	0f 84 be 00 00 00    	je     803042 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802f8a:	83 ec 0c             	sub    $0xc,%esp
  802f8d:	ff 75 f4             	pushl  -0xc(%ebp)
  802f90:	e8 9a fb ff ff       	call   802b2f <find_allocated_size>
  802f95:	83 c4 10             	add    $0x10,%esp
  802f98:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802f9b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f9f:	75 17                	jne    802fb8 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802fa1:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa4:	68 dc 5b 80 00       	push   $0x805bdc
  802fa9:	68 24 01 00 00       	push   $0x124
  802fae:	68 91 59 80 00       	push   $0x805991
  802fb3:	e8 f2 e5 ff ff       	call   8015aa <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802fb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbb:	f7 d0                	not    %eax
  802fbd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fc0:	73 1d                	jae    802fdf <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802fc2:	83 ec 0c             	sub    $0xc,%esp
  802fc5:	ff 75 e0             	pushl  -0x20(%ebp)
  802fc8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fcb:	68 24 5c 80 00       	push   $0x805c24
  802fd0:	68 29 01 00 00       	push   $0x129
  802fd5:	68 91 59 80 00       	push   $0x805991
  802fda:	e8 cb e5 ff ff       	call   8015aa <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802fdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe5:	01 d0                	add    %edx,%eax
  802fe7:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	79 2c                	jns    80301d <malloc+0x15a>
  802ff1:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802ff8:	77 23                	ja     80301d <malloc+0x15a>
  802ffa:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  803001:	77 1a                	ja     80301d <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  803003:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	79 13                	jns    80301d <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80300a:	83 ec 08             	sub    $0x8,%esp
  80300d:	ff 75 e0             	pushl  -0x20(%ebp)
  803010:	ff 75 e4             	pushl  -0x1c(%ebp)
  803013:	e8 de 09 00 00       	call   8039f6 <sys_allocate_user_mem>
  803018:	83 c4 10             	add    $0x10,%esp
  80301b:	eb 25                	jmp    803042 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  80301d:	68 00 00 00 a0       	push   $0xa0000000
  803022:	ff 75 dc             	pushl  -0x24(%ebp)
  803025:	ff 75 e0             	pushl  -0x20(%ebp)
  803028:	ff 75 e4             	pushl  -0x1c(%ebp)
  80302b:	ff 75 f4             	pushl  -0xc(%ebp)
  80302e:	68 60 5c 80 00       	push   $0x805c60
  803033:	68 33 01 00 00       	push   $0x133
  803038:	68 91 59 80 00       	push   $0x805991
  80303d:	e8 68 e5 ff ff       	call   8015aa <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80304d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803051:	0f 84 26 01 00 00    	je     80317d <free+0x136>

	uint32 addr = (uint32)virtual_address;
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	79 1c                	jns    803080 <free+0x39>
  803064:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80306b:	77 13                	ja     803080 <free+0x39>
		free_block(virtual_address);
  80306d:	83 ec 0c             	sub    $0xc,%esp
  803070:	ff 75 08             	pushl  0x8(%ebp)
  803073:	e8 21 12 00 00       	call   804299 <free_block>
  803078:	83 c4 10             	add    $0x10,%esp
		return;
  80307b:	e9 01 01 00 00       	jmp    803181 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  803080:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803085:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  803088:	0f 82 d8 00 00 00    	jb     803166 <free+0x11f>
  80308e:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  803095:	0f 87 cb 00 00 00    	ja     803166 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	25 ff 0f 00 00       	and    $0xfff,%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 17                	je     8030be <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8030a7:	ff 75 08             	pushl  0x8(%ebp)
  8030aa:	68 d0 5c 80 00       	push   $0x805cd0
  8030af:	68 57 01 00 00       	push   $0x157
  8030b4:	68 91 59 80 00       	push   $0x805991
  8030b9:	e8 ec e4 ff ff       	call   8015aa <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8030be:	83 ec 0c             	sub    $0xc,%esp
  8030c1:	ff 75 08             	pushl  0x8(%ebp)
  8030c4:	e8 66 fa ff ff       	call   802b2f <find_allocated_size>
  8030c9:	83 c4 10             	add    $0x10,%esp
  8030cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8030cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d3:	0f 84 a7 00 00 00    	je     803180 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	f7 d0                	not    %eax
  8030de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8030e1:	73 1d                	jae    803100 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8030e3:	83 ec 0c             	sub    $0xc,%esp
  8030e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8030e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8030ec:	68 f8 5c 80 00       	push   $0x805cf8
  8030f1:	68 61 01 00 00       	push   $0x161
  8030f6:	68 91 59 80 00       	push   $0x805991
  8030fb:	e8 aa e4 ff ff       	call   8015aa <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  803100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803106:	01 d0                	add    %edx,%eax
  803108:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	79 19                	jns    80312b <free+0xe4>
  803112:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  803119:	77 10                	ja     80312b <free+0xe4>
  80311b:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  803122:	77 07                	ja     80312b <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  803124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	78 2b                	js     803156 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  80312b:	83 ec 0c             	sub    $0xc,%esp
  80312e:	68 00 00 00 a0       	push   $0xa0000000
  803133:	ff 75 ec             	pushl  -0x14(%ebp)
  803136:	ff 75 f0             	pushl  -0x10(%ebp)
  803139:	ff 75 f4             	pushl  -0xc(%ebp)
  80313c:	ff 75 f0             	pushl  -0x10(%ebp)
  80313f:	ff 75 08             	pushl  0x8(%ebp)
  803142:	68 34 5d 80 00       	push   $0x805d34
  803147:	68 69 01 00 00       	push   $0x169
  80314c:	68 91 59 80 00       	push   $0x805991
  803151:	e8 54 e4 ff ff       	call   8015aa <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  803156:	83 ec 0c             	sub    $0xc,%esp
  803159:	ff 75 08             	pushl  0x8(%ebp)
  80315c:	e8 2c fa ff ff       	call   802b8d <free_pages>
  803161:	83 c4 10             	add    $0x10,%esp
		return;
  803164:	eb 1b                	jmp    803181 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  803166:	ff 75 08             	pushl  0x8(%ebp)
  803169:	68 90 5d 80 00       	push   $0x805d90
  80316e:	68 70 01 00 00       	push   $0x170
  803173:	68 91 59 80 00       	push   $0x805991
  803178:	e8 2d e4 ff ff       	call   8015aa <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80317d:	90                   	nop
  80317e:	eb 01                	jmp    803181 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  803180:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  803181:	c9                   	leave  
  803182:	c3                   	ret    

00803183 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  803183:	55                   	push   %ebp
  803184:	89 e5                	mov    %esp,%ebp
  803186:	83 ec 38             	sub    $0x38,%esp
  803189:	8b 45 10             	mov    0x10(%ebp),%eax
  80318c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80318f:	e8 2e fc ff ff       	call   802dc2 <uheap_init>
	if (size == 0) return NULL ;
  803194:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803198:	75 0a                	jne    8031a4 <smalloc+0x21>
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
  80319f:	e9 3d 01 00 00       	jmp    8032e1 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8031a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8031aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ad:	25 ff 0f 00 00       	and    $0xfff,%eax
  8031b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8031b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031b9:	74 0e                	je     8031c9 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031be:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8031c1:	05 00 10 00 00       	add    $0x1000,%eax
  8031c6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	c1 e8 0c             	shr    $0xc,%eax
  8031cf:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8031d2:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	75 0a                	jne    8031e5 <smalloc+0x62>
		return NULL;
  8031db:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e0:	e9 fc 00 00 00       	jmp    8032e1 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8031e5:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8031ea:	85 c0                	test   %eax,%eax
  8031ec:	74 0f                	je     8031fd <smalloc+0x7a>
  8031ee:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8031f4:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8031f9:	39 c2                	cmp    %eax,%edx
  8031fb:	73 0a                	jae    803207 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8031fd:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803202:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803207:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80320c:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803211:	29 c2                	sub    %eax,%edx
  803213:	89 d0                	mov    %edx,%eax
  803215:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803218:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80321e:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803223:	29 c2                	sub    %eax,%edx
  803225:	89 d0                	mov    %edx,%eax
  803227:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803230:	77 13                	ja     803245 <smalloc+0xc2>
  803232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803235:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803238:	77 0b                	ja     803245 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80323a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323d:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803240:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803243:	73 0a                	jae    80324f <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  803245:	b8 00 00 00 00       	mov    $0x0,%eax
  80324a:	e9 92 00 00 00       	jmp    8032e1 <smalloc+0x15e>
	}

	void *va = NULL;
  80324f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  803256:	a1 44 f2 81 00       	mov    0x81f244,%eax
  80325b:	83 f8 05             	cmp    $0x5,%eax
  80325e:	75 11                	jne    803271 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  803260:	83 ec 0c             	sub    $0xc,%esp
  803263:	ff 75 f4             	pushl  -0xc(%ebp)
  803266:	e8 08 f7 ff ff       	call   802973 <alloc_pages_custom_fit>
  80326b:	83 c4 10             	add    $0x10,%esp
  80326e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  803271:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803275:	75 27                	jne    80329e <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803277:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80327e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803281:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803284:	89 c2                	mov    %eax,%edx
  803286:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80328b:	39 c2                	cmp    %eax,%edx
  80328d:	73 07                	jae    803296 <smalloc+0x113>
			return NULL;}
  80328f:	b8 00 00 00 00       	mov    $0x0,%eax
  803294:	eb 4b                	jmp    8032e1 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  803296:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80329b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80329e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8032a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8032a5:	50                   	push   %eax
  8032a6:	ff 75 0c             	pushl  0xc(%ebp)
  8032a9:	ff 75 08             	pushl  0x8(%ebp)
  8032ac:	e8 cb 03 00 00       	call   80367c <sys_create_shared_object>
  8032b1:	83 c4 10             	add    $0x10,%esp
  8032b4:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8032b7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032bb:	79 07                	jns    8032c4 <smalloc+0x141>
		return NULL;
  8032bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c2:	eb 1d                	jmp    8032e1 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8032c4:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8032c9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8032cc:	75 10                	jne    8032de <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8032ce:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	01 d0                	add    %edx,%eax
  8032d9:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}

	return va;
  8032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8032e9:	e8 d4 fa ff ff       	call   802dc2 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8032ee:	83 ec 08             	sub    $0x8,%esp
  8032f1:	ff 75 0c             	pushl  0xc(%ebp)
  8032f4:	ff 75 08             	pushl  0x8(%ebp)
  8032f7:	e8 aa 03 00 00       	call   8036a6 <sys_size_of_shared_object>
  8032fc:	83 c4 10             	add    $0x10,%esp
  8032ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  803302:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803306:	7f 0a                	jg     803312 <sget+0x2f>
		return NULL;
  803308:	b8 00 00 00 00       	mov    $0x0,%eax
  80330d:	e9 32 01 00 00       	jmp    803444 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  803318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331b:	25 ff 0f 00 00       	and    $0xfff,%eax
  803320:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  803323:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803327:	74 0e                	je     803337 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80332f:	05 00 10 00 00       	add    $0x1000,%eax
  803334:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  803337:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	75 0a                	jne    80334a <sget+0x67>
		return NULL;
  803340:	b8 00 00 00 00       	mov    $0x0,%eax
  803345:	e9 fa 00 00 00       	jmp    803444 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80334a:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80334f:	85 c0                	test   %eax,%eax
  803351:	74 0f                	je     803362 <sget+0x7f>
  803353:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803359:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80335e:	39 c2                	cmp    %eax,%edx
  803360:	73 0a                	jae    80336c <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  803362:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803367:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80336c:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803371:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803376:	29 c2                	sub    %eax,%edx
  803378:	89 d0                	mov    %edx,%eax
  80337a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80337d:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803383:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803388:	29 c2                	sub    %eax,%edx
  80338a:	89 d0                	mov    %edx,%eax
  80338c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803395:	77 13                	ja     8033aa <sget+0xc7>
  803397:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80339d:	77 0b                	ja     8033aa <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a2:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8033a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033a8:	73 0a                	jae    8033b4 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8033aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033af:	e9 90 00 00 00       	jmp    803444 <sget+0x161>

	void *va = NULL;
  8033b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8033bb:	a1 44 f2 81 00       	mov    0x81f244,%eax
  8033c0:	83 f8 05             	cmp    $0x5,%eax
  8033c3:	75 11                	jne    8033d6 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8033c5:	83 ec 0c             	sub    $0xc,%esp
  8033c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8033cb:	e8 a3 f5 ff ff       	call   802973 <alloc_pages_custom_fit>
  8033d0:	83 c4 10             	add    $0x10,%esp
  8033d3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8033d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033da:	75 27                	jne    803403 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8033dc:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8033e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033e6:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8033e9:	89 c2                	mov    %eax,%edx
  8033eb:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8033f0:	39 c2                	cmp    %eax,%edx
  8033f2:	73 07                	jae    8033fb <sget+0x118>
			return NULL;
  8033f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f9:	eb 49                	jmp    803444 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8033fb:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803400:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	ff 75 f0             	pushl  -0x10(%ebp)
  803409:	ff 75 0c             	pushl  0xc(%ebp)
  80340c:	ff 75 08             	pushl  0x8(%ebp)
  80340f:	e8 af 02 00 00       	call   8036c3 <sys_get_shared_object>
  803414:	83 c4 10             	add    $0x10,%esp
  803417:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80341a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80341e:	79 07                	jns    803427 <sget+0x144>
		return NULL;
  803420:	b8 00 00 00 00       	mov    $0x0,%eax
  803425:	eb 1d                	jmp    803444 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  803427:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80342c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80342f:	75 10                	jne    803441 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  803431:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	01 d0                	add    %edx,%eax
  80343c:	a3 50 f2 81 00       	mov    %eax,0x81f250

	return va;
  803441:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  803444:	c9                   	leave  
  803445:	c3                   	ret    

00803446 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803446:	55                   	push   %ebp
  803447:	89 e5                	mov    %esp,%ebp
  803449:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80344c:	e8 71 f9 ff ff       	call   802dc2 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	68 b4 5d 80 00       	push   $0x805db4
  803459:	68 19 02 00 00       	push   $0x219
  80345e:	68 91 59 80 00       	push   $0x805991
  803463:	e8 42 e1 ff ff       	call   8015aa <_panic>

00803468 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803468:	55                   	push   %ebp
  803469:	89 e5                	mov    %esp,%ebp
  80346b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	68 dc 5d 80 00       	push   $0x805ddc
  803476:	68 2b 02 00 00       	push   $0x22b
  80347b:	68 91 59 80 00       	push   $0x805991
  803480:	e8 25 e1 ff ff       	call   8015aa <_panic>

00803485 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803485:	55                   	push   %ebp
  803486:	89 e5                	mov    %esp,%ebp
  803488:	57                   	push   %edi
  803489:	56                   	push   %esi
  80348a:	53                   	push   %ebx
  80348b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80348e:	8b 45 08             	mov    0x8(%ebp),%eax
  803491:	8b 55 0c             	mov    0xc(%ebp),%edx
  803494:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803497:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80349a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80349d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8034a0:	cd 30                	int    $0x30
  8034a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8034a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8034a8:	83 c4 10             	add    $0x10,%esp
  8034ab:	5b                   	pop    %ebx
  8034ac:	5e                   	pop    %esi
  8034ad:	5f                   	pop    %edi
  8034ae:	5d                   	pop    %ebp
  8034af:	c3                   	ret    

008034b0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8034b0:	55                   	push   %ebp
  8034b1:	89 e5                	mov    %esp,%ebp
  8034b3:	83 ec 04             	sub    $0x4,%esp
  8034b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8034b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8034bc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8034bf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c6:	6a 00                	push   $0x0
  8034c8:	51                   	push   %ecx
  8034c9:	52                   	push   %edx
  8034ca:	ff 75 0c             	pushl  0xc(%ebp)
  8034cd:	50                   	push   %eax
  8034ce:	6a 00                	push   $0x0
  8034d0:	e8 b0 ff ff ff       	call   803485 <syscall>
  8034d5:	83 c4 18             	add    $0x18,%esp
}
  8034d8:	90                   	nop
  8034d9:	c9                   	leave  
  8034da:	c3                   	ret    

008034db <sys_cgetc>:

int
sys_cgetc(void)
{
  8034db:	55                   	push   %ebp
  8034dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8034de:	6a 00                	push   $0x0
  8034e0:	6a 00                	push   $0x0
  8034e2:	6a 00                	push   $0x0
  8034e4:	6a 00                	push   $0x0
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 02                	push   $0x2
  8034ea:	e8 96 ff ff ff       	call   803485 <syscall>
  8034ef:	83 c4 18             	add    $0x18,%esp
}
  8034f2:	c9                   	leave  
  8034f3:	c3                   	ret    

008034f4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8034f4:	55                   	push   %ebp
  8034f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8034f7:	6a 00                	push   $0x0
  8034f9:	6a 00                	push   $0x0
  8034fb:	6a 00                	push   $0x0
  8034fd:	6a 00                	push   $0x0
  8034ff:	6a 00                	push   $0x0
  803501:	6a 03                	push   $0x3
  803503:	e8 7d ff ff ff       	call   803485 <syscall>
  803508:	83 c4 18             	add    $0x18,%esp
}
  80350b:	90                   	nop
  80350c:	c9                   	leave  
  80350d:	c3                   	ret    

0080350e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80350e:	55                   	push   %ebp
  80350f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803511:	6a 00                	push   $0x0
  803513:	6a 00                	push   $0x0
  803515:	6a 00                	push   $0x0
  803517:	6a 00                	push   $0x0
  803519:	6a 00                	push   $0x0
  80351b:	6a 04                	push   $0x4
  80351d:	e8 63 ff ff ff       	call   803485 <syscall>
  803522:	83 c4 18             	add    $0x18,%esp
}
  803525:	90                   	nop
  803526:	c9                   	leave  
  803527:	c3                   	ret    

00803528 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803528:	55                   	push   %ebp
  803529:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80352b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	6a 00                	push   $0x0
  803533:	6a 00                	push   $0x0
  803535:	6a 00                	push   $0x0
  803537:	52                   	push   %edx
  803538:	50                   	push   %eax
  803539:	6a 08                	push   $0x8
  80353b:	e8 45 ff ff ff       	call   803485 <syscall>
  803540:	83 c4 18             	add    $0x18,%esp
}
  803543:	c9                   	leave  
  803544:	c3                   	ret    

00803545 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803545:	55                   	push   %ebp
  803546:	89 e5                	mov    %esp,%ebp
  803548:	56                   	push   %esi
  803549:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80354a:	8b 75 18             	mov    0x18(%ebp),%esi
  80354d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803550:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803553:	8b 55 0c             	mov    0xc(%ebp),%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	56                   	push   %esi
  80355a:	53                   	push   %ebx
  80355b:	51                   	push   %ecx
  80355c:	52                   	push   %edx
  80355d:	50                   	push   %eax
  80355e:	6a 09                	push   $0x9
  803560:	e8 20 ff ff ff       	call   803485 <syscall>
  803565:	83 c4 18             	add    $0x18,%esp
}
  803568:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80356b:	5b                   	pop    %ebx
  80356c:	5e                   	pop    %esi
  80356d:	5d                   	pop    %ebp
  80356e:	c3                   	ret    

0080356f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80356f:	55                   	push   %ebp
  803570:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803572:	6a 00                	push   $0x0
  803574:	6a 00                	push   $0x0
  803576:	6a 00                	push   $0x0
  803578:	6a 00                	push   $0x0
  80357a:	ff 75 08             	pushl  0x8(%ebp)
  80357d:	6a 0a                	push   $0xa
  80357f:	e8 01 ff ff ff       	call   803485 <syscall>
  803584:	83 c4 18             	add    $0x18,%esp
}
  803587:	c9                   	leave  
  803588:	c3                   	ret    

00803589 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803589:	55                   	push   %ebp
  80358a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80358c:	6a 00                	push   $0x0
  80358e:	6a 00                	push   $0x0
  803590:	6a 00                	push   $0x0
  803592:	ff 75 0c             	pushl  0xc(%ebp)
  803595:	ff 75 08             	pushl  0x8(%ebp)
  803598:	6a 0b                	push   $0xb
  80359a:	e8 e6 fe ff ff       	call   803485 <syscall>
  80359f:	83 c4 18             	add    $0x18,%esp
}
  8035a2:	c9                   	leave  
  8035a3:	c3                   	ret    

008035a4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8035a4:	55                   	push   %ebp
  8035a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8035a7:	6a 00                	push   $0x0
  8035a9:	6a 00                	push   $0x0
  8035ab:	6a 00                	push   $0x0
  8035ad:	6a 00                	push   $0x0
  8035af:	6a 00                	push   $0x0
  8035b1:	6a 0c                	push   $0xc
  8035b3:	e8 cd fe ff ff       	call   803485 <syscall>
  8035b8:	83 c4 18             	add    $0x18,%esp
}
  8035bb:	c9                   	leave  
  8035bc:	c3                   	ret    

008035bd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8035bd:	55                   	push   %ebp
  8035be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8035c0:	6a 00                	push   $0x0
  8035c2:	6a 00                	push   $0x0
  8035c4:	6a 00                	push   $0x0
  8035c6:	6a 00                	push   $0x0
  8035c8:	6a 00                	push   $0x0
  8035ca:	6a 0d                	push   $0xd
  8035cc:	e8 b4 fe ff ff       	call   803485 <syscall>
  8035d1:	83 c4 18             	add    $0x18,%esp
}
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8035d9:	6a 00                	push   $0x0
  8035db:	6a 00                	push   $0x0
  8035dd:	6a 00                	push   $0x0
  8035df:	6a 00                	push   $0x0
  8035e1:	6a 00                	push   $0x0
  8035e3:	6a 0e                	push   $0xe
  8035e5:	e8 9b fe ff ff       	call   803485 <syscall>
  8035ea:	83 c4 18             	add    $0x18,%esp
}
  8035ed:	c9                   	leave  
  8035ee:	c3                   	ret    

008035ef <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8035ef:	55                   	push   %ebp
  8035f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8035f2:	6a 00                	push   $0x0
  8035f4:	6a 00                	push   $0x0
  8035f6:	6a 00                	push   $0x0
  8035f8:	6a 00                	push   $0x0
  8035fa:	6a 00                	push   $0x0
  8035fc:	6a 0f                	push   $0xf
  8035fe:	e8 82 fe ff ff       	call   803485 <syscall>
  803603:	83 c4 18             	add    $0x18,%esp
}
  803606:	c9                   	leave  
  803607:	c3                   	ret    

00803608 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803608:	55                   	push   %ebp
  803609:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80360b:	6a 00                	push   $0x0
  80360d:	6a 00                	push   $0x0
  80360f:	6a 00                	push   $0x0
  803611:	6a 00                	push   $0x0
  803613:	ff 75 08             	pushl  0x8(%ebp)
  803616:	6a 10                	push   $0x10
  803618:	e8 68 fe ff ff       	call   803485 <syscall>
  80361d:	83 c4 18             	add    $0x18,%esp
}
  803620:	c9                   	leave  
  803621:	c3                   	ret    

00803622 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803622:	55                   	push   %ebp
  803623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803625:	6a 00                	push   $0x0
  803627:	6a 00                	push   $0x0
  803629:	6a 00                	push   $0x0
  80362b:	6a 00                	push   $0x0
  80362d:	6a 00                	push   $0x0
  80362f:	6a 11                	push   $0x11
  803631:	e8 4f fe ff ff       	call   803485 <syscall>
  803636:	83 c4 18             	add    $0x18,%esp
}
  803639:	90                   	nop
  80363a:	c9                   	leave  
  80363b:	c3                   	ret    

0080363c <sys_cputc>:

void
sys_cputc(const char c)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
  80363f:	83 ec 04             	sub    $0x4,%esp
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803648:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80364c:	6a 00                	push   $0x0
  80364e:	6a 00                	push   $0x0
  803650:	6a 00                	push   $0x0
  803652:	6a 00                	push   $0x0
  803654:	50                   	push   %eax
  803655:	6a 01                	push   $0x1
  803657:	e8 29 fe ff ff       	call   803485 <syscall>
  80365c:	83 c4 18             	add    $0x18,%esp
}
  80365f:	90                   	nop
  803660:	c9                   	leave  
  803661:	c3                   	ret    

00803662 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803665:	6a 00                	push   $0x0
  803667:	6a 00                	push   $0x0
  803669:	6a 00                	push   $0x0
  80366b:	6a 00                	push   $0x0
  80366d:	6a 00                	push   $0x0
  80366f:	6a 14                	push   $0x14
  803671:	e8 0f fe ff ff       	call   803485 <syscall>
  803676:	83 c4 18             	add    $0x18,%esp
}
  803679:	90                   	nop
  80367a:	c9                   	leave  
  80367b:	c3                   	ret    

0080367c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80367c:	55                   	push   %ebp
  80367d:	89 e5                	mov    %esp,%ebp
  80367f:	83 ec 04             	sub    $0x4,%esp
  803682:	8b 45 10             	mov    0x10(%ebp),%eax
  803685:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803688:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80368b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	6a 00                	push   $0x0
  803694:	51                   	push   %ecx
  803695:	52                   	push   %edx
  803696:	ff 75 0c             	pushl  0xc(%ebp)
  803699:	50                   	push   %eax
  80369a:	6a 15                	push   $0x15
  80369c:	e8 e4 fd ff ff       	call   803485 <syscall>
  8036a1:	83 c4 18             	add    $0x18,%esp
}
  8036a4:	c9                   	leave  
  8036a5:	c3                   	ret    

008036a6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8036a6:	55                   	push   %ebp
  8036a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8036a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	6a 00                	push   $0x0
  8036b1:	6a 00                	push   $0x0
  8036b3:	6a 00                	push   $0x0
  8036b5:	52                   	push   %edx
  8036b6:	50                   	push   %eax
  8036b7:	6a 16                	push   $0x16
  8036b9:	e8 c7 fd ff ff       	call   803485 <syscall>
  8036be:	83 c4 18             	add    $0x18,%esp
}
  8036c1:	c9                   	leave  
  8036c2:	c3                   	ret    

008036c3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8036c3:	55                   	push   %ebp
  8036c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8036c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cf:	6a 00                	push   $0x0
  8036d1:	6a 00                	push   $0x0
  8036d3:	51                   	push   %ecx
  8036d4:	52                   	push   %edx
  8036d5:	50                   	push   %eax
  8036d6:	6a 17                	push   $0x17
  8036d8:	e8 a8 fd ff ff       	call   803485 <syscall>
  8036dd:	83 c4 18             	add    $0x18,%esp
}
  8036e0:	c9                   	leave  
  8036e1:	c3                   	ret    

008036e2 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8036e2:	55                   	push   %ebp
  8036e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8036e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	6a 00                	push   $0x0
  8036ed:	6a 00                	push   $0x0
  8036ef:	6a 00                	push   $0x0
  8036f1:	52                   	push   %edx
  8036f2:	50                   	push   %eax
  8036f3:	6a 18                	push   $0x18
  8036f5:	e8 8b fd ff ff       	call   803485 <syscall>
  8036fa:	83 c4 18             	add    $0x18,%esp
}
  8036fd:	c9                   	leave  
  8036fe:	c3                   	ret    

008036ff <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8036ff:	55                   	push   %ebp
  803700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	6a 00                	push   $0x0
  803707:	ff 75 14             	pushl  0x14(%ebp)
  80370a:	ff 75 10             	pushl  0x10(%ebp)
  80370d:	ff 75 0c             	pushl  0xc(%ebp)
  803710:	50                   	push   %eax
  803711:	6a 19                	push   $0x19
  803713:	e8 6d fd ff ff       	call   803485 <syscall>
  803718:	83 c4 18             	add    $0x18,%esp
}
  80371b:	c9                   	leave  
  80371c:	c3                   	ret    

0080371d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80371d:	55                   	push   %ebp
  80371e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	6a 00                	push   $0x0
  803725:	6a 00                	push   $0x0
  803727:	6a 00                	push   $0x0
  803729:	6a 00                	push   $0x0
  80372b:	50                   	push   %eax
  80372c:	6a 1a                	push   $0x1a
  80372e:	e8 52 fd ff ff       	call   803485 <syscall>
  803733:	83 c4 18             	add    $0x18,%esp
}
  803736:	90                   	nop
  803737:	c9                   	leave  
  803738:	c3                   	ret    

00803739 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	6a 00                	push   $0x0
  803741:	6a 00                	push   $0x0
  803743:	6a 00                	push   $0x0
  803745:	6a 00                	push   $0x0
  803747:	50                   	push   %eax
  803748:	6a 1b                	push   $0x1b
  80374a:	e8 36 fd ff ff       	call   803485 <syscall>
  80374f:	83 c4 18             	add    $0x18,%esp
}
  803752:	c9                   	leave  
  803753:	c3                   	ret    

00803754 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803754:	55                   	push   %ebp
  803755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803757:	6a 00                	push   $0x0
  803759:	6a 00                	push   $0x0
  80375b:	6a 00                	push   $0x0
  80375d:	6a 00                	push   $0x0
  80375f:	6a 00                	push   $0x0
  803761:	6a 05                	push   $0x5
  803763:	e8 1d fd ff ff       	call   803485 <syscall>
  803768:	83 c4 18             	add    $0x18,%esp
}
  80376b:	c9                   	leave  
  80376c:	c3                   	ret    

0080376d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80376d:	55                   	push   %ebp
  80376e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803770:	6a 00                	push   $0x0
  803772:	6a 00                	push   $0x0
  803774:	6a 00                	push   $0x0
  803776:	6a 00                	push   $0x0
  803778:	6a 00                	push   $0x0
  80377a:	6a 06                	push   $0x6
  80377c:	e8 04 fd ff ff       	call   803485 <syscall>
  803781:	83 c4 18             	add    $0x18,%esp
}
  803784:	c9                   	leave  
  803785:	c3                   	ret    

00803786 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803786:	55                   	push   %ebp
  803787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803789:	6a 00                	push   $0x0
  80378b:	6a 00                	push   $0x0
  80378d:	6a 00                	push   $0x0
  80378f:	6a 00                	push   $0x0
  803791:	6a 00                	push   $0x0
  803793:	6a 07                	push   $0x7
  803795:	e8 eb fc ff ff       	call   803485 <syscall>
  80379a:	83 c4 18             	add    $0x18,%esp
}
  80379d:	c9                   	leave  
  80379e:	c3                   	ret    

0080379f <sys_exit_env>:


void sys_exit_env(void)
{
  80379f:	55                   	push   %ebp
  8037a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8037a2:	6a 00                	push   $0x0
  8037a4:	6a 00                	push   $0x0
  8037a6:	6a 00                	push   $0x0
  8037a8:	6a 00                	push   $0x0
  8037aa:	6a 00                	push   $0x0
  8037ac:	6a 1c                	push   $0x1c
  8037ae:	e8 d2 fc ff ff       	call   803485 <syscall>
  8037b3:	83 c4 18             	add    $0x18,%esp
}
  8037b6:	90                   	nop
  8037b7:	c9                   	leave  
  8037b8:	c3                   	ret    

008037b9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8037b9:	55                   	push   %ebp
  8037ba:	89 e5                	mov    %esp,%ebp
  8037bc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8037bf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8037c2:	8d 50 04             	lea    0x4(%eax),%edx
  8037c5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 00                	push   $0x0
  8037cc:	6a 00                	push   $0x0
  8037ce:	52                   	push   %edx
  8037cf:	50                   	push   %eax
  8037d0:	6a 1d                	push   $0x1d
  8037d2:	e8 ae fc ff ff       	call   803485 <syscall>
  8037d7:	83 c4 18             	add    $0x18,%esp
	return result;
  8037da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8037dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8037e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037e3:	89 01                	mov    %eax,(%ecx)
  8037e5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	c9                   	leave  
  8037ec:	c2 04 00             	ret    $0x4

008037ef <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8037ef:	55                   	push   %ebp
  8037f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8037f2:	6a 00                	push   $0x0
  8037f4:	6a 00                	push   $0x0
  8037f6:	ff 75 10             	pushl  0x10(%ebp)
  8037f9:	ff 75 0c             	pushl  0xc(%ebp)
  8037fc:	ff 75 08             	pushl  0x8(%ebp)
  8037ff:	6a 13                	push   $0x13
  803801:	e8 7f fc ff ff       	call   803485 <syscall>
  803806:	83 c4 18             	add    $0x18,%esp
	return ;
  803809:	90                   	nop
}
  80380a:	c9                   	leave  
  80380b:	c3                   	ret    

0080380c <sys_rcr2>:
uint32 sys_rcr2()
{
  80380c:	55                   	push   %ebp
  80380d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80380f:	6a 00                	push   $0x0
  803811:	6a 00                	push   $0x0
  803813:	6a 00                	push   $0x0
  803815:	6a 00                	push   $0x0
  803817:	6a 00                	push   $0x0
  803819:	6a 1e                	push   $0x1e
  80381b:	e8 65 fc ff ff       	call   803485 <syscall>
  803820:	83 c4 18             	add    $0x18,%esp
}
  803823:	c9                   	leave  
  803824:	c3                   	ret    

00803825 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803825:	55                   	push   %ebp
  803826:	89 e5                	mov    %esp,%ebp
  803828:	83 ec 04             	sub    $0x4,%esp
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803831:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803835:	6a 00                	push   $0x0
  803837:	6a 00                	push   $0x0
  803839:	6a 00                	push   $0x0
  80383b:	6a 00                	push   $0x0
  80383d:	50                   	push   %eax
  80383e:	6a 1f                	push   $0x1f
  803840:	e8 40 fc ff ff       	call   803485 <syscall>
  803845:	83 c4 18             	add    $0x18,%esp
	return ;
  803848:	90                   	nop
}
  803849:	c9                   	leave  
  80384a:	c3                   	ret    

0080384b <rsttst>:
void rsttst()
{
  80384b:	55                   	push   %ebp
  80384c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80384e:	6a 00                	push   $0x0
  803850:	6a 00                	push   $0x0
  803852:	6a 00                	push   $0x0
  803854:	6a 00                	push   $0x0
  803856:	6a 00                	push   $0x0
  803858:	6a 21                	push   $0x21
  80385a:	e8 26 fc ff ff       	call   803485 <syscall>
  80385f:	83 c4 18             	add    $0x18,%esp
	return ;
  803862:	90                   	nop
}
  803863:	c9                   	leave  
  803864:	c3                   	ret    

00803865 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803865:	55                   	push   %ebp
  803866:	89 e5                	mov    %esp,%ebp
  803868:	83 ec 04             	sub    $0x4,%esp
  80386b:	8b 45 14             	mov    0x14(%ebp),%eax
  80386e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803871:	8b 55 18             	mov    0x18(%ebp),%edx
  803874:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803878:	52                   	push   %edx
  803879:	50                   	push   %eax
  80387a:	ff 75 10             	pushl  0x10(%ebp)
  80387d:	ff 75 0c             	pushl  0xc(%ebp)
  803880:	ff 75 08             	pushl  0x8(%ebp)
  803883:	6a 20                	push   $0x20
  803885:	e8 fb fb ff ff       	call   803485 <syscall>
  80388a:	83 c4 18             	add    $0x18,%esp
	return ;
  80388d:	90                   	nop
}
  80388e:	c9                   	leave  
  80388f:	c3                   	ret    

00803890 <chktst>:
void chktst(uint32 n)
{
  803890:	55                   	push   %ebp
  803891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803893:	6a 00                	push   $0x0
  803895:	6a 00                	push   $0x0
  803897:	6a 00                	push   $0x0
  803899:	6a 00                	push   $0x0
  80389b:	ff 75 08             	pushl  0x8(%ebp)
  80389e:	6a 22                	push   $0x22
  8038a0:	e8 e0 fb ff ff       	call   803485 <syscall>
  8038a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8038a8:	90                   	nop
}
  8038a9:	c9                   	leave  
  8038aa:	c3                   	ret    

008038ab <inctst>:

void inctst()
{
  8038ab:	55                   	push   %ebp
  8038ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8038ae:	6a 00                	push   $0x0
  8038b0:	6a 00                	push   $0x0
  8038b2:	6a 00                	push   $0x0
  8038b4:	6a 00                	push   $0x0
  8038b6:	6a 00                	push   $0x0
  8038b8:	6a 23                	push   $0x23
  8038ba:	e8 c6 fb ff ff       	call   803485 <syscall>
  8038bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8038c2:	90                   	nop
}
  8038c3:	c9                   	leave  
  8038c4:	c3                   	ret    

008038c5 <gettst>:
uint32 gettst()
{
  8038c5:	55                   	push   %ebp
  8038c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8038c8:	6a 00                	push   $0x0
  8038ca:	6a 00                	push   $0x0
  8038cc:	6a 00                	push   $0x0
  8038ce:	6a 00                	push   $0x0
  8038d0:	6a 00                	push   $0x0
  8038d2:	6a 24                	push   $0x24
  8038d4:	e8 ac fb ff ff       	call   803485 <syscall>
  8038d9:	83 c4 18             	add    $0x18,%esp
}
  8038dc:	c9                   	leave  
  8038dd:	c3                   	ret    

008038de <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8038de:	55                   	push   %ebp
  8038df:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8038e1:	6a 00                	push   $0x0
  8038e3:	6a 00                	push   $0x0
  8038e5:	6a 00                	push   $0x0
  8038e7:	6a 00                	push   $0x0
  8038e9:	6a 00                	push   $0x0
  8038eb:	6a 25                	push   $0x25
  8038ed:	e8 93 fb ff ff       	call   803485 <syscall>
  8038f2:	83 c4 18             	add    $0x18,%esp
  8038f5:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  8038fa:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  8038ff:	c9                   	leave  
  803900:	c3                   	ret    

00803901 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803901:	55                   	push   %ebp
  803902:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80390c:	6a 00                	push   $0x0
  80390e:	6a 00                	push   $0x0
  803910:	6a 00                	push   $0x0
  803912:	6a 00                	push   $0x0
  803914:	ff 75 08             	pushl  0x8(%ebp)
  803917:	6a 26                	push   $0x26
  803919:	e8 67 fb ff ff       	call   803485 <syscall>
  80391e:	83 c4 18             	add    $0x18,%esp
	return ;
  803921:	90                   	nop
}
  803922:	c9                   	leave  
  803923:	c3                   	ret    

00803924 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803924:	55                   	push   %ebp
  803925:	89 e5                	mov    %esp,%ebp
  803927:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803928:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80392b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80392e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	6a 00                	push   $0x0
  803936:	53                   	push   %ebx
  803937:	51                   	push   %ecx
  803938:	52                   	push   %edx
  803939:	50                   	push   %eax
  80393a:	6a 27                	push   $0x27
  80393c:	e8 44 fb ff ff       	call   803485 <syscall>
  803941:	83 c4 18             	add    $0x18,%esp
}
  803944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803947:	c9                   	leave  
  803948:	c3                   	ret    

00803949 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803949:	55                   	push   %ebp
  80394a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80394c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	6a 00                	push   $0x0
  803954:	6a 00                	push   $0x0
  803956:	6a 00                	push   $0x0
  803958:	52                   	push   %edx
  803959:	50                   	push   %eax
  80395a:	6a 28                	push   $0x28
  80395c:	e8 24 fb ff ff       	call   803485 <syscall>
  803961:	83 c4 18             	add    $0x18,%esp
}
  803964:	c9                   	leave  
  803965:	c3                   	ret    

00803966 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803966:	55                   	push   %ebp
  803967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803969:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80396c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80396f:	8b 45 08             	mov    0x8(%ebp),%eax
  803972:	6a 00                	push   $0x0
  803974:	51                   	push   %ecx
  803975:	ff 75 10             	pushl  0x10(%ebp)
  803978:	52                   	push   %edx
  803979:	50                   	push   %eax
  80397a:	6a 29                	push   $0x29
  80397c:	e8 04 fb ff ff       	call   803485 <syscall>
  803981:	83 c4 18             	add    $0x18,%esp
}
  803984:	c9                   	leave  
  803985:	c3                   	ret    

00803986 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803986:	55                   	push   %ebp
  803987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803989:	6a 00                	push   $0x0
  80398b:	6a 00                	push   $0x0
  80398d:	ff 75 10             	pushl  0x10(%ebp)
  803990:	ff 75 0c             	pushl  0xc(%ebp)
  803993:	ff 75 08             	pushl  0x8(%ebp)
  803996:	6a 12                	push   $0x12
  803998:	e8 e8 fa ff ff       	call   803485 <syscall>
  80399d:	83 c4 18             	add    $0x18,%esp
	return ;
  8039a0:	90                   	nop
}
  8039a1:	c9                   	leave  
  8039a2:	c3                   	ret    

008039a3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8039a3:	55                   	push   %ebp
  8039a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8039a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ac:	6a 00                	push   $0x0
  8039ae:	6a 00                	push   $0x0
  8039b0:	6a 00                	push   $0x0
  8039b2:	52                   	push   %edx
  8039b3:	50                   	push   %eax
  8039b4:	6a 2a                	push   $0x2a
  8039b6:	e8 ca fa ff ff       	call   803485 <syscall>
  8039bb:	83 c4 18             	add    $0x18,%esp
	return;
  8039be:	90                   	nop
}
  8039bf:	c9                   	leave  
  8039c0:	c3                   	ret    

008039c1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8039c1:	55                   	push   %ebp
  8039c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8039c4:	6a 00                	push   $0x0
  8039c6:	6a 00                	push   $0x0
  8039c8:	6a 00                	push   $0x0
  8039ca:	6a 00                	push   $0x0
  8039cc:	6a 00                	push   $0x0
  8039ce:	6a 2b                	push   $0x2b
  8039d0:	e8 b0 fa ff ff       	call   803485 <syscall>
  8039d5:	83 c4 18             	add    $0x18,%esp
}
  8039d8:	c9                   	leave  
  8039d9:	c3                   	ret    

008039da <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8039da:	55                   	push   %ebp
  8039db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8039dd:	6a 00                	push   $0x0
  8039df:	6a 00                	push   $0x0
  8039e1:	6a 00                	push   $0x0
  8039e3:	ff 75 0c             	pushl  0xc(%ebp)
  8039e6:	ff 75 08             	pushl  0x8(%ebp)
  8039e9:	6a 2d                	push   $0x2d
  8039eb:	e8 95 fa ff ff       	call   803485 <syscall>
  8039f0:	83 c4 18             	add    $0x18,%esp
	return;
  8039f3:	90                   	nop
}
  8039f4:	c9                   	leave  
  8039f5:	c3                   	ret    

008039f6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8039f6:	55                   	push   %ebp
  8039f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8039f9:	6a 00                	push   $0x0
  8039fb:	6a 00                	push   $0x0
  8039fd:	6a 00                	push   $0x0
  8039ff:	ff 75 0c             	pushl  0xc(%ebp)
  803a02:	ff 75 08             	pushl  0x8(%ebp)
  803a05:	6a 2c                	push   $0x2c
  803a07:	e8 79 fa ff ff       	call   803485 <syscall>
  803a0c:	83 c4 18             	add    $0x18,%esp
	return ;
  803a0f:	90                   	nop
}
  803a10:	c9                   	leave  
  803a11:	c3                   	ret    

00803a12 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803a12:	55                   	push   %ebp
  803a13:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a18:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1b:	6a 00                	push   $0x0
  803a1d:	6a 00                	push   $0x0
  803a1f:	6a 00                	push   $0x0
  803a21:	52                   	push   %edx
  803a22:	50                   	push   %eax
  803a23:	6a 2e                	push   $0x2e
  803a25:	e8 5b fa ff ff       	call   803485 <syscall>
  803a2a:	83 c4 18             	add    $0x18,%esp
	return ;
  803a2d:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803a2e:	c9                   	leave  
  803a2f:	c3                   	ret    

00803a30 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803a30:	55                   	push   %ebp
  803a31:	89 e5                	mov    %esp,%ebp
  803a33:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803a36:	81 7d 08 40 72 80 00 	cmpl   $0x807240,0x8(%ebp)
  803a3d:	72 09                	jb     803a48 <to_page_va+0x18>
  803a3f:	81 7d 08 40 f2 81 00 	cmpl   $0x81f240,0x8(%ebp)
  803a46:	72 14                	jb     803a5c <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803a48:	83 ec 04             	sub    $0x4,%esp
  803a4b:	68 00 5e 80 00       	push   $0x805e00
  803a50:	6a 15                	push   $0x15
  803a52:	68 2b 5e 80 00       	push   $0x805e2b
  803a57:	e8 4e db ff ff       	call   8015aa <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5f:	ba 40 72 80 00       	mov    $0x807240,%edx
  803a64:	29 d0                	sub    %edx,%eax
  803a66:	c1 f8 02             	sar    $0x2,%eax
  803a69:	89 c2                	mov    %eax,%edx
  803a6b:	89 d0                	mov    %edx,%eax
  803a6d:	c1 e0 02             	shl    $0x2,%eax
  803a70:	01 d0                	add    %edx,%eax
  803a72:	c1 e0 02             	shl    $0x2,%eax
  803a75:	01 d0                	add    %edx,%eax
  803a77:	c1 e0 02             	shl    $0x2,%eax
  803a7a:	01 d0                	add    %edx,%eax
  803a7c:	89 c1                	mov    %eax,%ecx
  803a7e:	c1 e1 08             	shl    $0x8,%ecx
  803a81:	01 c8                	add    %ecx,%eax
  803a83:	89 c1                	mov    %eax,%ecx
  803a85:	c1 e1 10             	shl    $0x10,%ecx
  803a88:	01 c8                	add    %ecx,%eax
  803a8a:	01 c0                	add    %eax,%eax
  803a8c:	01 d0                	add    %edx,%eax
  803a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	c1 e0 0c             	shl    $0xc,%eax
  803a97:	89 c2                	mov    %eax,%edx
  803a99:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803a9e:	01 d0                	add    %edx,%eax
}
  803aa0:	c9                   	leave  
  803aa1:	c3                   	ret    

00803aa2 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803aa2:	55                   	push   %ebp
  803aa3:	89 e5                	mov    %esp,%ebp
  803aa5:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803aa8:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803aad:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab0:	29 c2                	sub    %eax,%edx
  803ab2:	89 d0                	mov    %edx,%eax
  803ab4:	c1 e8 0c             	shr    $0xc,%eax
  803ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803aba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803abe:	78 09                	js     803ac9 <to_page_info+0x27>
  803ac0:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803ac7:	7e 14                	jle    803add <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803ac9:	83 ec 04             	sub    $0x4,%esp
  803acc:	68 44 5e 80 00       	push   $0x805e44
  803ad1:	6a 22                	push   $0x22
  803ad3:	68 2b 5e 80 00       	push   $0x805e2b
  803ad8:	e8 cd da ff ff       	call   8015aa <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ae0:	89 d0                	mov    %edx,%eax
  803ae2:	01 c0                	add    %eax,%eax
  803ae4:	01 d0                	add    %edx,%eax
  803ae6:	c1 e0 02             	shl    $0x2,%eax
  803ae9:	05 40 72 80 00       	add    $0x807240,%eax
}
  803aee:	c9                   	leave  
  803aef:	c3                   	ret    

00803af0 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803af0:	55                   	push   %ebp
  803af1:	89 e5                	mov    %esp,%ebp
  803af3:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	05 00 00 00 02       	add    $0x2000000,%eax
  803afe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b01:	73 16                	jae    803b19 <initialize_dynamic_allocator+0x29>
  803b03:	68 68 5e 80 00       	push   $0x805e68
  803b08:	68 8e 5e 80 00       	push   $0x805e8e
  803b0d:	6a 34                	push   $0x34
  803b0f:	68 2b 5e 80 00       	push   $0x805e2b
  803b14:	e8 91 da ff ff       	call   8015aa <_panic>
		is_initialized = 1;
  803b19:	c7 05 14 72 80 00 01 	movl   $0x1,0x807214
  803b20:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd = daEnd;
  803b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2e:	a3 20 72 80 00       	mov    %eax,0x807220

	LIST_INIT(&freePagesList);
  803b33:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  803b3a:	00 00 00 
  803b3d:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  803b44:	00 00 00 
  803b47:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  803b4e:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803b51:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b5f:	eb 36                	jmp    803b97 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b64:	c1 e0 04             	shl    $0x4,%eax
  803b67:	05 60 f2 81 00       	add    $0x81f260,%eax
  803b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b75:	c1 e0 04             	shl    $0x4,%eax
  803b78:	05 64 f2 81 00       	add    $0x81f264,%eax
  803b7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b86:	c1 e0 04             	shl    $0x4,%eax
  803b89:	05 6c f2 81 00       	add    $0x81f26c,%eax
  803b8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803b94:	ff 45 f4             	incl   -0xc(%ebp)
  803b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b9d:	72 c2                	jb     803b61 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803b9f:	8b 15 20 72 80 00    	mov    0x807220,%edx
  803ba5:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803baa:	29 c2                	sub    %eax,%edx
  803bac:	89 d0                	mov    %edx,%eax
  803bae:	c1 e8 0c             	shr    $0xc,%eax
  803bb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803bb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803bbb:	e9 c8 00 00 00       	jmp    803c88 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803bc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bc3:	89 d0                	mov    %edx,%eax
  803bc5:	01 c0                	add    %eax,%eax
  803bc7:	01 d0                	add    %edx,%eax
  803bc9:	c1 e0 02             	shl    $0x2,%eax
  803bcc:	05 48 72 80 00       	add    $0x807248,%eax
  803bd1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803bd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bd9:	89 d0                	mov    %edx,%eax
  803bdb:	01 c0                	add    %eax,%eax
  803bdd:	01 d0                	add    %edx,%eax
  803bdf:	c1 e0 02             	shl    $0x2,%eax
  803be2:	05 4a 72 80 00       	add    $0x80724a,%eax
  803be7:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803bec:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  803bf2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803bf5:	89 c8                	mov    %ecx,%eax
  803bf7:	01 c0                	add    %eax,%eax
  803bf9:	01 c8                	add    %ecx,%eax
  803bfb:	c1 e0 02             	shl    $0x2,%eax
  803bfe:	05 44 72 80 00       	add    $0x807244,%eax
  803c03:	89 10                	mov    %edx,(%eax)
  803c05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c08:	89 d0                	mov    %edx,%eax
  803c0a:	01 c0                	add    %eax,%eax
  803c0c:	01 d0                	add    %edx,%eax
  803c0e:	c1 e0 02             	shl    $0x2,%eax
  803c11:	05 44 72 80 00       	add    $0x807244,%eax
  803c16:	8b 00                	mov    (%eax),%eax
  803c18:	85 c0                	test   %eax,%eax
  803c1a:	74 1b                	je     803c37 <initialize_dynamic_allocator+0x147>
  803c1c:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  803c22:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c25:	89 c8                	mov    %ecx,%eax
  803c27:	01 c0                	add    %eax,%eax
  803c29:	01 c8                	add    %ecx,%eax
  803c2b:	c1 e0 02             	shl    $0x2,%eax
  803c2e:	05 40 72 80 00       	add    $0x807240,%eax
  803c33:	89 02                	mov    %eax,(%edx)
  803c35:	eb 16                	jmp    803c4d <initialize_dynamic_allocator+0x15d>
  803c37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c3a:	89 d0                	mov    %edx,%eax
  803c3c:	01 c0                	add    %eax,%eax
  803c3e:	01 d0                	add    %edx,%eax
  803c40:	c1 e0 02             	shl    $0x2,%eax
  803c43:	05 40 72 80 00       	add    $0x807240,%eax
  803c48:	a3 28 72 80 00       	mov    %eax,0x807228
  803c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c50:	89 d0                	mov    %edx,%eax
  803c52:	01 c0                	add    %eax,%eax
  803c54:	01 d0                	add    %edx,%eax
  803c56:	c1 e0 02             	shl    $0x2,%eax
  803c59:	05 40 72 80 00       	add    $0x807240,%eax
  803c5e:	a3 2c 72 80 00       	mov    %eax,0x80722c
  803c63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c66:	89 d0                	mov    %edx,%eax
  803c68:	01 c0                	add    %eax,%eax
  803c6a:	01 d0                	add    %edx,%eax
  803c6c:	c1 e0 02             	shl    $0x2,%eax
  803c6f:	05 40 72 80 00       	add    $0x807240,%eax
  803c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c7a:	a1 34 72 80 00       	mov    0x807234,%eax
  803c7f:	40                   	inc    %eax
  803c80:	a3 34 72 80 00       	mov    %eax,0x807234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803c85:	ff 45 f0             	incl   -0x10(%ebp)
  803c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c8b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c8e:	0f 82 2c ff ff ff    	jb     803bc0 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c9a:	eb 2f                	jmp    803ccb <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803c9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c9f:	89 d0                	mov    %edx,%eax
  803ca1:	01 c0                	add    %eax,%eax
  803ca3:	01 d0                	add    %edx,%eax
  803ca5:	c1 e0 02             	shl    $0x2,%eax
  803ca8:	05 48 72 80 00       	add    $0x807248,%eax
  803cad:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803cb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb5:	89 d0                	mov    %edx,%eax
  803cb7:	01 c0                	add    %eax,%eax
  803cb9:	01 d0                	add    %edx,%eax
  803cbb:	c1 e0 02             	shl    $0x2,%eax
  803cbe:	05 4a 72 80 00       	add    $0x80724a,%eax
  803cc3:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803cc8:	ff 45 ec             	incl   -0x14(%ebp)
  803ccb:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803cd2:	76 c8                	jbe    803c9c <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803cd4:	90                   	nop
  803cd5:	c9                   	leave  
  803cd6:	c3                   	ret    

00803cd7 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803cd7:	55                   	push   %ebp
  803cd8:	89 e5                	mov    %esp,%ebp
  803cda:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce0:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803ce5:	29 c2                	sub    %eax,%edx
  803ce7:	89 d0                	mov    %edx,%eax
  803ce9:	c1 e8 0c             	shr    $0xc,%eax
  803cec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803cef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803cf2:	89 d0                	mov    %edx,%eax
  803cf4:	01 c0                	add    %eax,%eax
  803cf6:	01 d0                	add    %edx,%eax
  803cf8:	c1 e0 02             	shl    $0x2,%eax
  803cfb:	05 48 72 80 00       	add    $0x807248,%eax
  803d00:	8b 00                	mov    (%eax),%eax
  803d02:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803d05:	c9                   	leave  
  803d06:	c3                   	ret    

00803d07 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803d07:	55                   	push   %ebp
  803d08:	89 e5                	mov    %esp,%ebp
  803d0a:	83 ec 14             	sub    $0x14,%esp
  803d0d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803d10:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803d14:	77 07                	ja     803d1d <nearest_pow2_ceil.1513+0x16>
  803d16:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1b:	eb 20                	jmp    803d3d <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803d1d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803d24:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803d27:	eb 08                	jmp    803d31 <nearest_pow2_ceil.1513+0x2a>
  803d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803d2c:	01 c0                	add    %eax,%eax
  803d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803d31:	d1 6d 08             	shrl   0x8(%ebp)
  803d34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d38:	75 ef                	jne    803d29 <nearest_pow2_ceil.1513+0x22>
        return power;
  803d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803d3d:	c9                   	leave  
  803d3e:	c3                   	ret    

00803d3f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803d3f:	55                   	push   %ebp
  803d40:	89 e5                	mov    %esp,%ebp
  803d42:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803d45:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803d4c:	76 16                	jbe    803d64 <alloc_block+0x25>
  803d4e:	68 a4 5e 80 00       	push   $0x805ea4
  803d53:	68 8e 5e 80 00       	push   $0x805e8e
  803d58:	6a 72                	push   $0x72
  803d5a:	68 2b 5e 80 00       	push   $0x805e2b
  803d5f:	e8 46 d8 ff ff       	call   8015aa <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803d64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d68:	75 0a                	jne    803d74 <alloc_block+0x35>
  803d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6f:	e9 bd 04 00 00       	jmp    804231 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803d74:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d81:	73 06                	jae    803d89 <alloc_block+0x4a>
        size = min_block_size;
  803d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d86:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803d89:	83 ec 0c             	sub    $0xc,%esp
  803d8c:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803d8f:	ff 75 08             	pushl  0x8(%ebp)
  803d92:	89 c1                	mov    %eax,%ecx
  803d94:	e8 6e ff ff ff       	call   803d07 <nearest_pow2_ceil.1513>
  803d99:	83 c4 10             	add    $0x10,%esp
  803d9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803d9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803da2:	83 ec 0c             	sub    $0xc,%esp
  803da5:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803da8:	52                   	push   %edx
  803da9:	89 c1                	mov    %eax,%ecx
  803dab:	e8 83 04 00 00       	call   804233 <log2_ceil.1520>
  803db0:	83 c4 10             	add    $0x10,%esp
  803db3:	83 e8 03             	sub    $0x3,%eax
  803db6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbc:	c1 e0 04             	shl    $0x4,%eax
  803dbf:	05 60 f2 81 00       	add    $0x81f260,%eax
  803dc4:	8b 00                	mov    (%eax),%eax
  803dc6:	85 c0                	test   %eax,%eax
  803dc8:	0f 84 d8 00 00 00    	je     803ea6 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd1:	c1 e0 04             	shl    $0x4,%eax
  803dd4:	05 60 f2 81 00       	add    $0x81f260,%eax
  803dd9:	8b 00                	mov    (%eax),%eax
  803ddb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803dde:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803de2:	75 17                	jne    803dfb <alloc_block+0xbc>
  803de4:	83 ec 04             	sub    $0x4,%esp
  803de7:	68 c5 5e 80 00       	push   $0x805ec5
  803dec:	68 98 00 00 00       	push   $0x98
  803df1:	68 2b 5e 80 00       	push   $0x805e2b
  803df6:	e8 af d7 ff ff       	call   8015aa <_panic>
  803dfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dfe:	8b 00                	mov    (%eax),%eax
  803e00:	85 c0                	test   %eax,%eax
  803e02:	74 10                	je     803e14 <alloc_block+0xd5>
  803e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e07:	8b 00                	mov    (%eax),%eax
  803e09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e0c:	8b 52 04             	mov    0x4(%edx),%edx
  803e0f:	89 50 04             	mov    %edx,0x4(%eax)
  803e12:	eb 14                	jmp    803e28 <alloc_block+0xe9>
  803e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e17:	8b 40 04             	mov    0x4(%eax),%eax
  803e1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e1d:	c1 e2 04             	shl    $0x4,%edx
  803e20:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  803e26:	89 02                	mov    %eax,(%edx)
  803e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e2b:	8b 40 04             	mov    0x4(%eax),%eax
  803e2e:	85 c0                	test   %eax,%eax
  803e30:	74 0f                	je     803e41 <alloc_block+0x102>
  803e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e35:	8b 40 04             	mov    0x4(%eax),%eax
  803e38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e3b:	8b 12                	mov    (%edx),%edx
  803e3d:	89 10                	mov    %edx,(%eax)
  803e3f:	eb 13                	jmp    803e54 <alloc_block+0x115>
  803e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e44:	8b 00                	mov    (%eax),%eax
  803e46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e49:	c1 e2 04             	shl    $0x4,%edx
  803e4c:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  803e52:	89 02                	mov    %eax,(%edx)
  803e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6a:	c1 e0 04             	shl    $0x4,%eax
  803e6d:	05 6c f2 81 00       	add    $0x81f26c,%eax
  803e72:	8b 00                	mov    (%eax),%eax
  803e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7a:	c1 e0 04             	shl    $0x4,%eax
  803e7d:	05 6c f2 81 00       	add    $0x81f26c,%eax
  803e82:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e87:	83 ec 0c             	sub    $0xc,%esp
  803e8a:	50                   	push   %eax
  803e8b:	e8 12 fc ff ff       	call   803aa2 <to_page_info>
  803e90:	83 c4 10             	add    $0x10,%esp
  803e93:	89 c2                	mov    %eax,%edx
  803e95:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803e99:	48                   	dec    %eax
  803e9a:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ea1:	e9 8b 03 00 00       	jmp    804231 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803ea6:	a1 28 72 80 00       	mov    0x807228,%eax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	0f 84 64 02 00 00    	je     804117 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803eb3:	a1 28 72 80 00       	mov    0x807228,%eax
  803eb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803ebb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ebf:	75 17                	jne    803ed8 <alloc_block+0x199>
  803ec1:	83 ec 04             	sub    $0x4,%esp
  803ec4:	68 c5 5e 80 00       	push   $0x805ec5
  803ec9:	68 a0 00 00 00       	push   $0xa0
  803ece:	68 2b 5e 80 00       	push   $0x805e2b
  803ed3:	e8 d2 d6 ff ff       	call   8015aa <_panic>
  803ed8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803edb:	8b 00                	mov    (%eax),%eax
  803edd:	85 c0                	test   %eax,%eax
  803edf:	74 10                	je     803ef1 <alloc_block+0x1b2>
  803ee1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ee4:	8b 00                	mov    (%eax),%eax
  803ee6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ee9:	8b 52 04             	mov    0x4(%edx),%edx
  803eec:	89 50 04             	mov    %edx,0x4(%eax)
  803eef:	eb 0b                	jmp    803efc <alloc_block+0x1bd>
  803ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ef4:	8b 40 04             	mov    0x4(%eax),%eax
  803ef7:	a3 2c 72 80 00       	mov    %eax,0x80722c
  803efc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eff:	8b 40 04             	mov    0x4(%eax),%eax
  803f02:	85 c0                	test   %eax,%eax
  803f04:	74 0f                	je     803f15 <alloc_block+0x1d6>
  803f06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f09:	8b 40 04             	mov    0x4(%eax),%eax
  803f0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f0f:	8b 12                	mov    (%edx),%edx
  803f11:	89 10                	mov    %edx,(%eax)
  803f13:	eb 0a                	jmp    803f1f <alloc_block+0x1e0>
  803f15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f18:	8b 00                	mov    (%eax),%eax
  803f1a:	a3 28 72 80 00       	mov    %eax,0x807228
  803f1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f32:	a1 34 72 80 00       	mov    0x807234,%eax
  803f37:	48                   	dec    %eax
  803f38:	a3 34 72 80 00       	mov    %eax,0x807234

        page_info_e->block_size = pow;
  803f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f43:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803f47:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f4c:	99                   	cltd   
  803f4d:	f7 7d e8             	idivl  -0x18(%ebp)
  803f50:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f53:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803f57:	83 ec 0c             	sub    $0xc,%esp
  803f5a:	ff 75 dc             	pushl  -0x24(%ebp)
  803f5d:	e8 ce fa ff ff       	call   803a30 <to_page_va>
  803f62:	83 c4 10             	add    $0x10,%esp
  803f65:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f6b:	83 ec 0c             	sub    $0xc,%esp
  803f6e:	50                   	push   %eax
  803f6f:	e8 c0 ee ff ff       	call   802e34 <get_page>
  803f74:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803f77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803f7e:	e9 aa 00 00 00       	jmp    80402d <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f86:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803f8a:	89 c2                	mov    %eax,%edx
  803f8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f8f:	01 d0                	add    %edx,%eax
  803f91:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803f94:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f98:	75 17                	jne    803fb1 <alloc_block+0x272>
  803f9a:	83 ec 04             	sub    $0x4,%esp
  803f9d:	68 e4 5e 80 00       	push   $0x805ee4
  803fa2:	68 aa 00 00 00       	push   $0xaa
  803fa7:	68 2b 5e 80 00       	push   $0x805e2b
  803fac:	e8 f9 d5 ff ff       	call   8015aa <_panic>
  803fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb4:	c1 e0 04             	shl    $0x4,%eax
  803fb7:	05 64 f2 81 00       	add    $0x81f264,%eax
  803fbc:	8b 10                	mov    (%eax),%edx
  803fbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fc1:	89 50 04             	mov    %edx,0x4(%eax)
  803fc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fc7:	8b 40 04             	mov    0x4(%eax),%eax
  803fca:	85 c0                	test   %eax,%eax
  803fcc:	74 14                	je     803fe2 <alloc_block+0x2a3>
  803fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd1:	c1 e0 04             	shl    $0x4,%eax
  803fd4:	05 64 f2 81 00       	add    $0x81f264,%eax
  803fd9:	8b 00                	mov    (%eax),%eax
  803fdb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fde:	89 10                	mov    %edx,(%eax)
  803fe0:	eb 11                	jmp    803ff3 <alloc_block+0x2b4>
  803fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe5:	c1 e0 04             	shl    $0x4,%eax
  803fe8:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  803fee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ff1:	89 02                	mov    %eax,(%edx)
  803ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff6:	c1 e0 04             	shl    $0x4,%eax
  803ff9:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  803fff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804002:	89 02                	mov    %eax,(%edx)
  804004:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804007:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80400d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804010:	c1 e0 04             	shl    $0x4,%eax
  804013:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804018:	8b 00                	mov    (%eax),%eax
  80401a:	8d 50 01             	lea    0x1(%eax),%edx
  80401d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804020:	c1 e0 04             	shl    $0x4,%eax
  804023:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804028:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80402a:	ff 45 f4             	incl   -0xc(%ebp)
  80402d:	b8 00 10 00 00       	mov    $0x1000,%eax
  804032:	99                   	cltd   
  804033:	f7 7d e8             	idivl  -0x18(%ebp)
  804036:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804039:	0f 8f 44 ff ff ff    	jg     803f83 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80403f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804042:	c1 e0 04             	shl    $0x4,%eax
  804045:	05 60 f2 81 00       	add    $0x81f260,%eax
  80404a:	8b 00                	mov    (%eax),%eax
  80404c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80404f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804053:	75 17                	jne    80406c <alloc_block+0x32d>
  804055:	83 ec 04             	sub    $0x4,%esp
  804058:	68 c5 5e 80 00       	push   $0x805ec5
  80405d:	68 ae 00 00 00       	push   $0xae
  804062:	68 2b 5e 80 00       	push   $0x805e2b
  804067:	e8 3e d5 ff ff       	call   8015aa <_panic>
  80406c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80406f:	8b 00                	mov    (%eax),%eax
  804071:	85 c0                	test   %eax,%eax
  804073:	74 10                	je     804085 <alloc_block+0x346>
  804075:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804078:	8b 00                	mov    (%eax),%eax
  80407a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80407d:	8b 52 04             	mov    0x4(%edx),%edx
  804080:	89 50 04             	mov    %edx,0x4(%eax)
  804083:	eb 14                	jmp    804099 <alloc_block+0x35a>
  804085:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804088:	8b 40 04             	mov    0x4(%eax),%eax
  80408b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80408e:	c1 e2 04             	shl    $0x4,%edx
  804091:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804097:	89 02                	mov    %eax,(%edx)
  804099:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80409c:	8b 40 04             	mov    0x4(%eax),%eax
  80409f:	85 c0                	test   %eax,%eax
  8040a1:	74 0f                	je     8040b2 <alloc_block+0x373>
  8040a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040a6:	8b 40 04             	mov    0x4(%eax),%eax
  8040a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8040ac:	8b 12                	mov    (%edx),%edx
  8040ae:	89 10                	mov    %edx,(%eax)
  8040b0:	eb 13                	jmp    8040c5 <alloc_block+0x386>
  8040b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040b5:	8b 00                	mov    (%eax),%eax
  8040b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ba:	c1 e2 04             	shl    $0x4,%edx
  8040bd:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8040c3:	89 02                	mov    %eax,(%edx)
  8040c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040db:	c1 e0 04             	shl    $0x4,%eax
  8040de:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8040e3:	8b 00                	mov    (%eax),%eax
  8040e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040eb:	c1 e0 04             	shl    $0x4,%eax
  8040ee:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8040f3:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8040f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040f8:	83 ec 0c             	sub    $0xc,%esp
  8040fb:	50                   	push   %eax
  8040fc:	e8 a1 f9 ff ff       	call   803aa2 <to_page_info>
  804101:	83 c4 10             	add    $0x10,%esp
  804104:	89 c2                	mov    %eax,%edx
  804106:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80410a:	48                   	dec    %eax
  80410b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  80410f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804112:	e9 1a 01 00 00       	jmp    804231 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  804117:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411a:	40                   	inc    %eax
  80411b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80411e:	e9 ed 00 00 00       	jmp    804210 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  804123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804126:	c1 e0 04             	shl    $0x4,%eax
  804129:	05 60 f2 81 00       	add    $0x81f260,%eax
  80412e:	8b 00                	mov    (%eax),%eax
  804130:	85 c0                	test   %eax,%eax
  804132:	0f 84 d5 00 00 00    	je     80420d <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  804138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80413b:	c1 e0 04             	shl    $0x4,%eax
  80413e:	05 60 f2 81 00       	add    $0x81f260,%eax
  804143:	8b 00                	mov    (%eax),%eax
  804145:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  804148:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80414c:	75 17                	jne    804165 <alloc_block+0x426>
  80414e:	83 ec 04             	sub    $0x4,%esp
  804151:	68 c5 5e 80 00       	push   $0x805ec5
  804156:	68 b8 00 00 00       	push   $0xb8
  80415b:	68 2b 5e 80 00       	push   $0x805e2b
  804160:	e8 45 d4 ff ff       	call   8015aa <_panic>
  804165:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804168:	8b 00                	mov    (%eax),%eax
  80416a:	85 c0                	test   %eax,%eax
  80416c:	74 10                	je     80417e <alloc_block+0x43f>
  80416e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804171:	8b 00                	mov    (%eax),%eax
  804173:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804176:	8b 52 04             	mov    0x4(%edx),%edx
  804179:	89 50 04             	mov    %edx,0x4(%eax)
  80417c:	eb 14                	jmp    804192 <alloc_block+0x453>
  80417e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804181:	8b 40 04             	mov    0x4(%eax),%eax
  804184:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804187:	c1 e2 04             	shl    $0x4,%edx
  80418a:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804190:	89 02                	mov    %eax,(%edx)
  804192:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804195:	8b 40 04             	mov    0x4(%eax),%eax
  804198:	85 c0                	test   %eax,%eax
  80419a:	74 0f                	je     8041ab <alloc_block+0x46c>
  80419c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80419f:	8b 40 04             	mov    0x4(%eax),%eax
  8041a2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8041a5:	8b 12                	mov    (%edx),%edx
  8041a7:	89 10                	mov    %edx,(%eax)
  8041a9:	eb 13                	jmp    8041be <alloc_block+0x47f>
  8041ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041ae:	8b 00                	mov    (%eax),%eax
  8041b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041b3:	c1 e2 04             	shl    $0x4,%edx
  8041b6:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8041bc:	89 02                	mov    %eax,(%edx)
  8041be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d4:	c1 e0 04             	shl    $0x4,%eax
  8041d7:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8041dc:	8b 00                	mov    (%eax),%eax
  8041de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8041e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041e4:	c1 e0 04             	shl    $0x4,%eax
  8041e7:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8041ec:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8041ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041f1:	83 ec 0c             	sub    $0xc,%esp
  8041f4:	50                   	push   %eax
  8041f5:	e8 a8 f8 ff ff       	call   803aa2 <to_page_info>
  8041fa:	83 c4 10             	add    $0x10,%esp
  8041fd:	89 c2                	mov    %eax,%edx
  8041ff:	66 8b 42 0a          	mov    0xa(%edx),%ax
  804203:	48                   	dec    %eax
  804204:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  804208:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80420b:	eb 24                	jmp    804231 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80420d:	ff 45 f0             	incl   -0x10(%ebp)
  804210:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  804214:	0f 8e 09 ff ff ff    	jle    804123 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80421a:	83 ec 04             	sub    $0x4,%esp
  80421d:	68 07 5f 80 00       	push   $0x805f07
  804222:	68 bf 00 00 00       	push   $0xbf
  804227:	68 2b 5e 80 00       	push   $0x805e2b
  80422c:	e8 79 d3 ff ff       	call   8015aa <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804231:	c9                   	leave  
  804232:	c3                   	ret    

00804233 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  804233:	55                   	push   %ebp
  804234:	89 e5                	mov    %esp,%ebp
  804236:	83 ec 14             	sub    $0x14,%esp
  804239:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  80423c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804240:	75 07                	jne    804249 <log2_ceil.1520+0x16>
  804242:	b8 00 00 00 00       	mov    $0x0,%eax
  804247:	eb 1b                	jmp    804264 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  804249:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  804250:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  804253:	eb 06                	jmp    80425b <log2_ceil.1520+0x28>
            x >>= 1;
  804255:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  804258:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80425b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80425f:	75 f4                	jne    804255 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  804261:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  804264:	c9                   	leave  
  804265:	c3                   	ret    

00804266 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  804266:	55                   	push   %ebp
  804267:	89 e5                	mov    %esp,%ebp
  804269:	83 ec 14             	sub    $0x14,%esp
  80426c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80426f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804273:	75 07                	jne    80427c <log2_ceil.1547+0x16>
  804275:	b8 00 00 00 00       	mov    $0x0,%eax
  80427a:	eb 1b                	jmp    804297 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80427c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  804283:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  804286:	eb 06                	jmp    80428e <log2_ceil.1547+0x28>
			x >>= 1;
  804288:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80428b:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80428e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804292:	75 f4                	jne    804288 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  804294:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  804297:	c9                   	leave  
  804298:	c3                   	ret    

00804299 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804299:	55                   	push   %ebp
  80429a:	89 e5                	mov    %esp,%ebp
  80429c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80429f:	8b 55 08             	mov    0x8(%ebp),%edx
  8042a2:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8042a7:	39 c2                	cmp    %eax,%edx
  8042a9:	72 0c                	jb     8042b7 <free_block+0x1e>
  8042ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8042ae:	a1 20 72 80 00       	mov    0x807220,%eax
  8042b3:	39 c2                	cmp    %eax,%edx
  8042b5:	72 19                	jb     8042d0 <free_block+0x37>
  8042b7:	68 0c 5f 80 00       	push   $0x805f0c
  8042bc:	68 8e 5e 80 00       	push   $0x805e8e
  8042c1:	68 d0 00 00 00       	push   $0xd0
  8042c6:	68 2b 5e 80 00       	push   $0x805e2b
  8042cb:	e8 da d2 ff ff       	call   8015aa <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8042d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042d4:	0f 84 42 03 00 00    	je     80461c <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8042da:	8b 55 08             	mov    0x8(%ebp),%edx
  8042dd:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8042e2:	39 c2                	cmp    %eax,%edx
  8042e4:	72 0c                	jb     8042f2 <free_block+0x59>
  8042e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8042e9:	a1 20 72 80 00       	mov    0x807220,%eax
  8042ee:	39 c2                	cmp    %eax,%edx
  8042f0:	72 17                	jb     804309 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8042f2:	83 ec 04             	sub    $0x4,%esp
  8042f5:	68 44 5f 80 00       	push   $0x805f44
  8042fa:	68 e6 00 00 00       	push   $0xe6
  8042ff:	68 2b 5e 80 00       	push   $0x805e2b
  804304:	e8 a1 d2 ff ff       	call   8015aa <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  804309:	8b 55 08             	mov    0x8(%ebp),%edx
  80430c:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804311:	29 c2                	sub    %eax,%edx
  804313:	89 d0                	mov    %edx,%eax
  804315:	83 e0 07             	and    $0x7,%eax
  804318:	85 c0                	test   %eax,%eax
  80431a:	74 17                	je     804333 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80431c:	83 ec 04             	sub    $0x4,%esp
  80431f:	68 78 5f 80 00       	push   $0x805f78
  804324:	68 ea 00 00 00       	push   $0xea
  804329:	68 2b 5e 80 00       	push   $0x805e2b
  80432e:	e8 77 d2 ff ff       	call   8015aa <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  804333:	8b 45 08             	mov    0x8(%ebp),%eax
  804336:	83 ec 0c             	sub    $0xc,%esp
  804339:	50                   	push   %eax
  80433a:	e8 63 f7 ff ff       	call   803aa2 <to_page_info>
  80433f:	83 c4 10             	add    $0x10,%esp
  804342:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  804345:	83 ec 0c             	sub    $0xc,%esp
  804348:	ff 75 08             	pushl  0x8(%ebp)
  80434b:	e8 87 f9 ff ff       	call   803cd7 <get_block_size>
  804350:	83 c4 10             	add    $0x10,%esp
  804353:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  804356:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80435a:	75 17                	jne    804373 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80435c:	83 ec 04             	sub    $0x4,%esp
  80435f:	68 a4 5f 80 00       	push   $0x805fa4
  804364:	68 f1 00 00 00       	push   $0xf1
  804369:	68 2b 5e 80 00       	push   $0x805e2b
  80436e:	e8 37 d2 ff ff       	call   8015aa <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  804373:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804376:	83 ec 0c             	sub    $0xc,%esp
  804379:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80437c:	52                   	push   %edx
  80437d:	89 c1                	mov    %eax,%ecx
  80437f:	e8 e2 fe ff ff       	call   804266 <log2_ceil.1547>
  804384:	83 c4 10             	add    $0x10,%esp
  804387:	83 e8 03             	sub    $0x3,%eax
  80438a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80438d:	8b 45 08             	mov    0x8(%ebp),%eax
  804390:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  804393:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804397:	75 17                	jne    8043b0 <free_block+0x117>
  804399:	83 ec 04             	sub    $0x4,%esp
  80439c:	68 f0 5f 80 00       	push   $0x805ff0
  8043a1:	68 f6 00 00 00       	push   $0xf6
  8043a6:	68 2b 5e 80 00       	push   $0x805e2b
  8043ab:	e8 fa d1 ff ff       	call   8015aa <_panic>
  8043b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043b3:	c1 e0 04             	shl    $0x4,%eax
  8043b6:	05 60 f2 81 00       	add    $0x81f260,%eax
  8043bb:	8b 10                	mov    (%eax),%edx
  8043bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043c0:	89 10                	mov    %edx,(%eax)
  8043c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043c5:	8b 00                	mov    (%eax),%eax
  8043c7:	85 c0                	test   %eax,%eax
  8043c9:	74 15                	je     8043e0 <free_block+0x147>
  8043cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ce:	c1 e0 04             	shl    $0x4,%eax
  8043d1:	05 60 f2 81 00       	add    $0x81f260,%eax
  8043d6:	8b 00                	mov    (%eax),%eax
  8043d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043db:	89 50 04             	mov    %edx,0x4(%eax)
  8043de:	eb 11                	jmp    8043f1 <free_block+0x158>
  8043e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043e3:	c1 e0 04             	shl    $0x4,%eax
  8043e6:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  8043ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043ef:	89 02                	mov    %eax,(%edx)
  8043f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043f4:	c1 e0 04             	shl    $0x4,%eax
  8043f7:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  8043fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804400:	89 02                	mov    %eax,(%edx)
  804402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804405:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80440c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80440f:	c1 e0 04             	shl    $0x4,%eax
  804412:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804417:	8b 00                	mov    (%eax),%eax
  804419:	8d 50 01             	lea    0x1(%eax),%edx
  80441c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80441f:	c1 e0 04             	shl    $0x4,%eax
  804422:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804427:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  804429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80442c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804430:	40                   	inc    %eax
  804431:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804434:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  804438:	8b 55 08             	mov    0x8(%ebp),%edx
  80443b:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804440:	29 c2                	sub    %eax,%edx
  804442:	89 d0                	mov    %edx,%eax
  804444:	c1 e8 0c             	shr    $0xc,%eax
  804447:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80444a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80444d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804451:	0f b7 c8             	movzwl %ax,%ecx
  804454:	b8 00 10 00 00       	mov    $0x1000,%eax
  804459:	99                   	cltd   
  80445a:	f7 7d e8             	idivl  -0x18(%ebp)
  80445d:	39 c1                	cmp    %eax,%ecx
  80445f:	0f 85 b8 01 00 00    	jne    80461d <free_block+0x384>
    	uint32 blocks_removed = 0;
  804465:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80446c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80446f:	c1 e0 04             	shl    $0x4,%eax
  804472:	05 60 f2 81 00       	add    $0x81f260,%eax
  804477:	8b 00                	mov    (%eax),%eax
  804479:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80447c:	e9 d5 00 00 00       	jmp    804556 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  804481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804484:	8b 00                	mov    (%eax),%eax
  804486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  804489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80448c:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804491:	29 c2                	sub    %eax,%edx
  804493:	89 d0                	mov    %edx,%eax
  804495:	c1 e8 0c             	shr    $0xc,%eax
  804498:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80449b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80449e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8044a1:	0f 85 a9 00 00 00    	jne    804550 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8044a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044ab:	75 17                	jne    8044c4 <free_block+0x22b>
  8044ad:	83 ec 04             	sub    $0x4,%esp
  8044b0:	68 c5 5e 80 00       	push   $0x805ec5
  8044b5:	68 04 01 00 00       	push   $0x104
  8044ba:	68 2b 5e 80 00       	push   $0x805e2b
  8044bf:	e8 e6 d0 ff ff       	call   8015aa <_panic>
  8044c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044c7:	8b 00                	mov    (%eax),%eax
  8044c9:	85 c0                	test   %eax,%eax
  8044cb:	74 10                	je     8044dd <free_block+0x244>
  8044cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044d0:	8b 00                	mov    (%eax),%eax
  8044d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044d5:	8b 52 04             	mov    0x4(%edx),%edx
  8044d8:	89 50 04             	mov    %edx,0x4(%eax)
  8044db:	eb 14                	jmp    8044f1 <free_block+0x258>
  8044dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044e0:	8b 40 04             	mov    0x4(%eax),%eax
  8044e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044e6:	c1 e2 04             	shl    $0x4,%edx
  8044e9:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8044ef:	89 02                	mov    %eax,(%edx)
  8044f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044f4:	8b 40 04             	mov    0x4(%eax),%eax
  8044f7:	85 c0                	test   %eax,%eax
  8044f9:	74 0f                	je     80450a <free_block+0x271>
  8044fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044fe:	8b 40 04             	mov    0x4(%eax),%eax
  804501:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804504:	8b 12                	mov    (%edx),%edx
  804506:	89 10                	mov    %edx,(%eax)
  804508:	eb 13                	jmp    80451d <free_block+0x284>
  80450a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80450d:	8b 00                	mov    (%eax),%eax
  80450f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804512:	c1 e2 04             	shl    $0x4,%edx
  804515:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  80451b:	89 02                	mov    %eax,(%edx)
  80451d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804529:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804533:	c1 e0 04             	shl    $0x4,%eax
  804536:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80453b:	8b 00                	mov    (%eax),%eax
  80453d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804543:	c1 e0 04             	shl    $0x4,%eax
  804546:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80454b:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80454d:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804550:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804553:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80455a:	0f 85 21 ff ff ff    	jne    804481 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  804560:	b8 00 10 00 00       	mov    $0x1000,%eax
  804565:	99                   	cltd   
  804566:	f7 7d e8             	idivl  -0x18(%ebp)
  804569:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80456c:	74 17                	je     804585 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80456e:	83 ec 04             	sub    $0x4,%esp
  804571:	68 14 60 80 00       	push   $0x806014
  804576:	68 0c 01 00 00       	push   $0x10c
  80457b:	68 2b 5e 80 00       	push   $0x805e2b
  804580:	e8 25 d0 ff ff       	call   8015aa <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  804585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804588:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80458e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804591:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  804597:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80459b:	75 17                	jne    8045b4 <free_block+0x31b>
  80459d:	83 ec 04             	sub    $0x4,%esp
  8045a0:	68 e4 5e 80 00       	push   $0x805ee4
  8045a5:	68 11 01 00 00       	push   $0x111
  8045aa:	68 2b 5e 80 00       	push   $0x805e2b
  8045af:	e8 f6 cf ff ff       	call   8015aa <_panic>
  8045b4:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8045ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045bd:	89 50 04             	mov    %edx,0x4(%eax)
  8045c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045c3:	8b 40 04             	mov    0x4(%eax),%eax
  8045c6:	85 c0                	test   %eax,%eax
  8045c8:	74 0c                	je     8045d6 <free_block+0x33d>
  8045ca:	a1 2c 72 80 00       	mov    0x80722c,%eax
  8045cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045d2:	89 10                	mov    %edx,(%eax)
  8045d4:	eb 08                	jmp    8045de <free_block+0x345>
  8045d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045d9:	a3 28 72 80 00       	mov    %eax,0x807228
  8045de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045e1:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8045e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045ef:	a1 34 72 80 00       	mov    0x807234,%eax
  8045f4:	40                   	inc    %eax
  8045f5:	a3 34 72 80 00       	mov    %eax,0x807234

        uint32 pp = to_page_va(page_info_e);
  8045fa:	83 ec 0c             	sub    $0xc,%esp
  8045fd:	ff 75 ec             	pushl  -0x14(%ebp)
  804600:	e8 2b f4 ff ff       	call   803a30 <to_page_va>
  804605:	83 c4 10             	add    $0x10,%esp
  804608:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80460b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80460e:	83 ec 0c             	sub    $0xc,%esp
  804611:	50                   	push   %eax
  804612:	e8 69 e8 ff ff       	call   802e80 <return_page>
  804617:	83 c4 10             	add    $0x10,%esp
  80461a:	eb 01                	jmp    80461d <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80461c:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80461d:	c9                   	leave  
  80461e:	c3                   	ret    

0080461f <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80461f:	55                   	push   %ebp
  804620:	89 e5                	mov    %esp,%ebp
  804622:	83 ec 14             	sub    $0x14,%esp
  804625:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  804628:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80462c:	77 07                	ja     804635 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80462e:	b8 01 00 00 00       	mov    $0x1,%eax
  804633:	eb 20                	jmp    804655 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  804635:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80463c:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  80463f:	eb 08                	jmp    804649 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  804641:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804644:	01 c0                	add    %eax,%eax
  804646:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  804649:	d1 6d 08             	shrl   0x8(%ebp)
  80464c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804650:	75 ef                	jne    804641 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  804652:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  804655:	c9                   	leave  
  804656:	c3                   	ret    

00804657 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  804657:	55                   	push   %ebp
  804658:	89 e5                	mov    %esp,%ebp
  80465a:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80465d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804661:	75 13                	jne    804676 <realloc_block+0x1f>
    return alloc_block(new_size);
  804663:	83 ec 0c             	sub    $0xc,%esp
  804666:	ff 75 0c             	pushl  0xc(%ebp)
  804669:	e8 d1 f6 ff ff       	call   803d3f <alloc_block>
  80466e:	83 c4 10             	add    $0x10,%esp
  804671:	e9 d9 00 00 00       	jmp    80474f <realloc_block+0xf8>
  }

  if (new_size == 0) {
  804676:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80467a:	75 18                	jne    804694 <realloc_block+0x3d>
    free_block(va);
  80467c:	83 ec 0c             	sub    $0xc,%esp
  80467f:	ff 75 08             	pushl  0x8(%ebp)
  804682:	e8 12 fc ff ff       	call   804299 <free_block>
  804687:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80468a:	b8 00 00 00 00       	mov    $0x0,%eax
  80468f:	e9 bb 00 00 00       	jmp    80474f <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  804694:	83 ec 0c             	sub    $0xc,%esp
  804697:	ff 75 08             	pushl  0x8(%ebp)
  80469a:	e8 38 f6 ff ff       	call   803cd7 <get_block_size>
  80469f:	83 c4 10             	add    $0x10,%esp
  8046a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8046a5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8046ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8046b2:	73 06                	jae    8046ba <realloc_block+0x63>
    new_size = min_block_size;
  8046b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046b7:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8046ba:	83 ec 0c             	sub    $0xc,%esp
  8046bd:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8046c0:	ff 75 0c             	pushl  0xc(%ebp)
  8046c3:	89 c1                	mov    %eax,%ecx
  8046c5:	e8 55 ff ff ff       	call   80461f <nearest_pow2_ceil.1572>
  8046ca:	83 c4 10             	add    $0x10,%esp
  8046cd:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8046d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8046d6:	75 05                	jne    8046dd <realloc_block+0x86>
    return va;
  8046d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8046db:	eb 72                	jmp    80474f <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8046dd:	83 ec 0c             	sub    $0xc,%esp
  8046e0:	ff 75 0c             	pushl  0xc(%ebp)
  8046e3:	e8 57 f6 ff ff       	call   803d3f <alloc_block>
  8046e8:	83 c4 10             	add    $0x10,%esp
  8046eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8046ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046f2:	75 07                	jne    8046fb <realloc_block+0xa4>
    return NULL;
  8046f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f9:	eb 54                	jmp    80474f <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8046fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8046fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  804701:	39 d0                	cmp    %edx,%eax
  804703:	76 02                	jbe    804707 <realloc_block+0xb0>
  804705:	89 d0                	mov    %edx,%eax
  804707:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80470a:	8b 45 08             	mov    0x8(%ebp),%eax
  80470d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  804710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804713:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  804716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80471d:	eb 17                	jmp    804736 <realloc_block+0xdf>
    dst[i] = src[i];
  80471f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804725:	01 c2                	add    %eax,%edx
  804727:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80472a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80472d:	01 c8                	add    %ecx,%eax
  80472f:	8a 00                	mov    (%eax),%al
  804731:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  804733:	ff 45 f4             	incl   -0xc(%ebp)
  804736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804739:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80473c:	72 e1                	jb     80471f <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80473e:	83 ec 0c             	sub    $0xc,%esp
  804741:	ff 75 08             	pushl  0x8(%ebp)
  804744:	e8 50 fb ff ff       	call   804299 <free_block>
  804749:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80474c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80474f:	c9                   	leave  
  804750:	c3                   	ret    
  804751:	66 90                	xchg   %ax,%ax
  804753:	90                   	nop

00804754 <__udivdi3>:
  804754:	55                   	push   %ebp
  804755:	57                   	push   %edi
  804756:	56                   	push   %esi
  804757:	53                   	push   %ebx
  804758:	83 ec 1c             	sub    $0x1c,%esp
  80475b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80475f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804763:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804767:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80476b:	89 ca                	mov    %ecx,%edx
  80476d:	89 f8                	mov    %edi,%eax
  80476f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804773:	85 f6                	test   %esi,%esi
  804775:	75 2d                	jne    8047a4 <__udivdi3+0x50>
  804777:	39 cf                	cmp    %ecx,%edi
  804779:	77 65                	ja     8047e0 <__udivdi3+0x8c>
  80477b:	89 fd                	mov    %edi,%ebp
  80477d:	85 ff                	test   %edi,%edi
  80477f:	75 0b                	jne    80478c <__udivdi3+0x38>
  804781:	b8 01 00 00 00       	mov    $0x1,%eax
  804786:	31 d2                	xor    %edx,%edx
  804788:	f7 f7                	div    %edi
  80478a:	89 c5                	mov    %eax,%ebp
  80478c:	31 d2                	xor    %edx,%edx
  80478e:	89 c8                	mov    %ecx,%eax
  804790:	f7 f5                	div    %ebp
  804792:	89 c1                	mov    %eax,%ecx
  804794:	89 d8                	mov    %ebx,%eax
  804796:	f7 f5                	div    %ebp
  804798:	89 cf                	mov    %ecx,%edi
  80479a:	89 fa                	mov    %edi,%edx
  80479c:	83 c4 1c             	add    $0x1c,%esp
  80479f:	5b                   	pop    %ebx
  8047a0:	5e                   	pop    %esi
  8047a1:	5f                   	pop    %edi
  8047a2:	5d                   	pop    %ebp
  8047a3:	c3                   	ret    
  8047a4:	39 ce                	cmp    %ecx,%esi
  8047a6:	77 28                	ja     8047d0 <__udivdi3+0x7c>
  8047a8:	0f bd fe             	bsr    %esi,%edi
  8047ab:	83 f7 1f             	xor    $0x1f,%edi
  8047ae:	75 40                	jne    8047f0 <__udivdi3+0x9c>
  8047b0:	39 ce                	cmp    %ecx,%esi
  8047b2:	72 0a                	jb     8047be <__udivdi3+0x6a>
  8047b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8047b8:	0f 87 9e 00 00 00    	ja     80485c <__udivdi3+0x108>
  8047be:	b8 01 00 00 00       	mov    $0x1,%eax
  8047c3:	89 fa                	mov    %edi,%edx
  8047c5:	83 c4 1c             	add    $0x1c,%esp
  8047c8:	5b                   	pop    %ebx
  8047c9:	5e                   	pop    %esi
  8047ca:	5f                   	pop    %edi
  8047cb:	5d                   	pop    %ebp
  8047cc:	c3                   	ret    
  8047cd:	8d 76 00             	lea    0x0(%esi),%esi
  8047d0:	31 ff                	xor    %edi,%edi
  8047d2:	31 c0                	xor    %eax,%eax
  8047d4:	89 fa                	mov    %edi,%edx
  8047d6:	83 c4 1c             	add    $0x1c,%esp
  8047d9:	5b                   	pop    %ebx
  8047da:	5e                   	pop    %esi
  8047db:	5f                   	pop    %edi
  8047dc:	5d                   	pop    %ebp
  8047dd:	c3                   	ret    
  8047de:	66 90                	xchg   %ax,%ax
  8047e0:	89 d8                	mov    %ebx,%eax
  8047e2:	f7 f7                	div    %edi
  8047e4:	31 ff                	xor    %edi,%edi
  8047e6:	89 fa                	mov    %edi,%edx
  8047e8:	83 c4 1c             	add    $0x1c,%esp
  8047eb:	5b                   	pop    %ebx
  8047ec:	5e                   	pop    %esi
  8047ed:	5f                   	pop    %edi
  8047ee:	5d                   	pop    %ebp
  8047ef:	c3                   	ret    
  8047f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8047f5:	89 eb                	mov    %ebp,%ebx
  8047f7:	29 fb                	sub    %edi,%ebx
  8047f9:	89 f9                	mov    %edi,%ecx
  8047fb:	d3 e6                	shl    %cl,%esi
  8047fd:	89 c5                	mov    %eax,%ebp
  8047ff:	88 d9                	mov    %bl,%cl
  804801:	d3 ed                	shr    %cl,%ebp
  804803:	89 e9                	mov    %ebp,%ecx
  804805:	09 f1                	or     %esi,%ecx
  804807:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80480b:	89 f9                	mov    %edi,%ecx
  80480d:	d3 e0                	shl    %cl,%eax
  80480f:	89 c5                	mov    %eax,%ebp
  804811:	89 d6                	mov    %edx,%esi
  804813:	88 d9                	mov    %bl,%cl
  804815:	d3 ee                	shr    %cl,%esi
  804817:	89 f9                	mov    %edi,%ecx
  804819:	d3 e2                	shl    %cl,%edx
  80481b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80481f:	88 d9                	mov    %bl,%cl
  804821:	d3 e8                	shr    %cl,%eax
  804823:	09 c2                	or     %eax,%edx
  804825:	89 d0                	mov    %edx,%eax
  804827:	89 f2                	mov    %esi,%edx
  804829:	f7 74 24 0c          	divl   0xc(%esp)
  80482d:	89 d6                	mov    %edx,%esi
  80482f:	89 c3                	mov    %eax,%ebx
  804831:	f7 e5                	mul    %ebp
  804833:	39 d6                	cmp    %edx,%esi
  804835:	72 19                	jb     804850 <__udivdi3+0xfc>
  804837:	74 0b                	je     804844 <__udivdi3+0xf0>
  804839:	89 d8                	mov    %ebx,%eax
  80483b:	31 ff                	xor    %edi,%edi
  80483d:	e9 58 ff ff ff       	jmp    80479a <__udivdi3+0x46>
  804842:	66 90                	xchg   %ax,%ax
  804844:	8b 54 24 08          	mov    0x8(%esp),%edx
  804848:	89 f9                	mov    %edi,%ecx
  80484a:	d3 e2                	shl    %cl,%edx
  80484c:	39 c2                	cmp    %eax,%edx
  80484e:	73 e9                	jae    804839 <__udivdi3+0xe5>
  804850:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804853:	31 ff                	xor    %edi,%edi
  804855:	e9 40 ff ff ff       	jmp    80479a <__udivdi3+0x46>
  80485a:	66 90                	xchg   %ax,%ax
  80485c:	31 c0                	xor    %eax,%eax
  80485e:	e9 37 ff ff ff       	jmp    80479a <__udivdi3+0x46>
  804863:	90                   	nop

00804864 <__umoddi3>:
  804864:	55                   	push   %ebp
  804865:	57                   	push   %edi
  804866:	56                   	push   %esi
  804867:	53                   	push   %ebx
  804868:	83 ec 1c             	sub    $0x1c,%esp
  80486b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80486f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804873:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804877:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80487b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80487f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804883:	89 f3                	mov    %esi,%ebx
  804885:	89 fa                	mov    %edi,%edx
  804887:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80488b:	89 34 24             	mov    %esi,(%esp)
  80488e:	85 c0                	test   %eax,%eax
  804890:	75 1a                	jne    8048ac <__umoddi3+0x48>
  804892:	39 f7                	cmp    %esi,%edi
  804894:	0f 86 a2 00 00 00    	jbe    80493c <__umoddi3+0xd8>
  80489a:	89 c8                	mov    %ecx,%eax
  80489c:	89 f2                	mov    %esi,%edx
  80489e:	f7 f7                	div    %edi
  8048a0:	89 d0                	mov    %edx,%eax
  8048a2:	31 d2                	xor    %edx,%edx
  8048a4:	83 c4 1c             	add    $0x1c,%esp
  8048a7:	5b                   	pop    %ebx
  8048a8:	5e                   	pop    %esi
  8048a9:	5f                   	pop    %edi
  8048aa:	5d                   	pop    %ebp
  8048ab:	c3                   	ret    
  8048ac:	39 f0                	cmp    %esi,%eax
  8048ae:	0f 87 ac 00 00 00    	ja     804960 <__umoddi3+0xfc>
  8048b4:	0f bd e8             	bsr    %eax,%ebp
  8048b7:	83 f5 1f             	xor    $0x1f,%ebp
  8048ba:	0f 84 ac 00 00 00    	je     80496c <__umoddi3+0x108>
  8048c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8048c5:	29 ef                	sub    %ebp,%edi
  8048c7:	89 fe                	mov    %edi,%esi
  8048c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8048cd:	89 e9                	mov    %ebp,%ecx
  8048cf:	d3 e0                	shl    %cl,%eax
  8048d1:	89 d7                	mov    %edx,%edi
  8048d3:	89 f1                	mov    %esi,%ecx
  8048d5:	d3 ef                	shr    %cl,%edi
  8048d7:	09 c7                	or     %eax,%edi
  8048d9:	89 e9                	mov    %ebp,%ecx
  8048db:	d3 e2                	shl    %cl,%edx
  8048dd:	89 14 24             	mov    %edx,(%esp)
  8048e0:	89 d8                	mov    %ebx,%eax
  8048e2:	d3 e0                	shl    %cl,%eax
  8048e4:	89 c2                	mov    %eax,%edx
  8048e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048ea:	d3 e0                	shl    %cl,%eax
  8048ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048f4:	89 f1                	mov    %esi,%ecx
  8048f6:	d3 e8                	shr    %cl,%eax
  8048f8:	09 d0                	or     %edx,%eax
  8048fa:	d3 eb                	shr    %cl,%ebx
  8048fc:	89 da                	mov    %ebx,%edx
  8048fe:	f7 f7                	div    %edi
  804900:	89 d3                	mov    %edx,%ebx
  804902:	f7 24 24             	mull   (%esp)
  804905:	89 c6                	mov    %eax,%esi
  804907:	89 d1                	mov    %edx,%ecx
  804909:	39 d3                	cmp    %edx,%ebx
  80490b:	0f 82 87 00 00 00    	jb     804998 <__umoddi3+0x134>
  804911:	0f 84 91 00 00 00    	je     8049a8 <__umoddi3+0x144>
  804917:	8b 54 24 04          	mov    0x4(%esp),%edx
  80491b:	29 f2                	sub    %esi,%edx
  80491d:	19 cb                	sbb    %ecx,%ebx
  80491f:	89 d8                	mov    %ebx,%eax
  804921:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804925:	d3 e0                	shl    %cl,%eax
  804927:	89 e9                	mov    %ebp,%ecx
  804929:	d3 ea                	shr    %cl,%edx
  80492b:	09 d0                	or     %edx,%eax
  80492d:	89 e9                	mov    %ebp,%ecx
  80492f:	d3 eb                	shr    %cl,%ebx
  804931:	89 da                	mov    %ebx,%edx
  804933:	83 c4 1c             	add    $0x1c,%esp
  804936:	5b                   	pop    %ebx
  804937:	5e                   	pop    %esi
  804938:	5f                   	pop    %edi
  804939:	5d                   	pop    %ebp
  80493a:	c3                   	ret    
  80493b:	90                   	nop
  80493c:	89 fd                	mov    %edi,%ebp
  80493e:	85 ff                	test   %edi,%edi
  804940:	75 0b                	jne    80494d <__umoddi3+0xe9>
  804942:	b8 01 00 00 00       	mov    $0x1,%eax
  804947:	31 d2                	xor    %edx,%edx
  804949:	f7 f7                	div    %edi
  80494b:	89 c5                	mov    %eax,%ebp
  80494d:	89 f0                	mov    %esi,%eax
  80494f:	31 d2                	xor    %edx,%edx
  804951:	f7 f5                	div    %ebp
  804953:	89 c8                	mov    %ecx,%eax
  804955:	f7 f5                	div    %ebp
  804957:	89 d0                	mov    %edx,%eax
  804959:	e9 44 ff ff ff       	jmp    8048a2 <__umoddi3+0x3e>
  80495e:	66 90                	xchg   %ax,%ax
  804960:	89 c8                	mov    %ecx,%eax
  804962:	89 f2                	mov    %esi,%edx
  804964:	83 c4 1c             	add    $0x1c,%esp
  804967:	5b                   	pop    %ebx
  804968:	5e                   	pop    %esi
  804969:	5f                   	pop    %edi
  80496a:	5d                   	pop    %ebp
  80496b:	c3                   	ret    
  80496c:	3b 04 24             	cmp    (%esp),%eax
  80496f:	72 06                	jb     804977 <__umoddi3+0x113>
  804971:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804975:	77 0f                	ja     804986 <__umoddi3+0x122>
  804977:	89 f2                	mov    %esi,%edx
  804979:	29 f9                	sub    %edi,%ecx
  80497b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80497f:	89 14 24             	mov    %edx,(%esp)
  804982:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804986:	8b 44 24 04          	mov    0x4(%esp),%eax
  80498a:	8b 14 24             	mov    (%esp),%edx
  80498d:	83 c4 1c             	add    $0x1c,%esp
  804990:	5b                   	pop    %ebx
  804991:	5e                   	pop    %esi
  804992:	5f                   	pop    %edi
  804993:	5d                   	pop    %ebp
  804994:	c3                   	ret    
  804995:	8d 76 00             	lea    0x0(%esi),%esi
  804998:	2b 04 24             	sub    (%esp),%eax
  80499b:	19 fa                	sbb    %edi,%edx
  80499d:	89 d1                	mov    %edx,%ecx
  80499f:	89 c6                	mov    %eax,%esi
  8049a1:	e9 71 ff ff ff       	jmp    804917 <__umoddi3+0xb3>
  8049a6:	66 90                	xchg   %ax,%ax
  8049a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8049ac:	72 ea                	jb     804998 <__umoddi3+0x134>
  8049ae:	89 d9                	mov    %ebx,%ecx
  8049b0:	e9 62 ff ff ff       	jmp    804917 <__umoddi3+0xb3>
