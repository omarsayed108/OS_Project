
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 1e 13 00 00       	call   801354 <libmain>
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
  800067:	e8 92 34 00 00       	call   8034fe <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 d5 34 00 00       	call   803549 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 56 2d 00 00       	call   802e1d <malloc>
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
  8000df:	e8 1a 34 00 00       	call   8034fe <sys_calculate_free_frames>
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
  800125:	68 20 49 80 00       	push   $0x804920
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 ee 16 00 00       	call   80181f <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 10 34 00 00       	call   803549 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 49 80 00       	push   $0x80499c
  800150:	6a 0c                	push   $0xc
  800152:	e8 c8 16 00 00       	call   80181f <cprintf_colored>
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
  800174:	e8 85 33 00 00       	call   8034fe <sys_calculate_free_frames>
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
  8001b9:	e8 40 33 00 00       	call   8034fe <sys_calculate_free_frames>
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
  8001f8:	68 14 4a 80 00       	push   $0x804a14
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 1b 16 00 00       	call   80181f <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 3d 33 00 00       	call   803549 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 4a 80 00       	push   $0x804aa0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 ee 15 00 00       	call   80181f <cprintf_colored>
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
  800270:	e8 4b 36 00 00       	call   8038c0 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 4b 80 00       	push   $0x804b18
  80028f:	6a 0c                	push   $0xc
  800291:	e8 89 15 00 00       	call   80181f <cprintf_colored>
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
  8002ae:	e8 4b 32 00 00       	call   8034fe <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 8e 32 00 00       	call   803549 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 d0 2c 00 00       	call   802fa1 <free>
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
  8002fc:	e8 48 32 00 00       	call   803549 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 4b 80 00       	push   $0x804b50
  800318:	6a 0c                	push   $0xc
  80031a:	e8 00 15 00 00       	call   80181f <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 d7 31 00 00       	call   8034fe <sys_calculate_free_frames>
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
  80035f:	68 9c 4b 80 00       	push   $0x804b9c
  800364:	6a 0c                	push   $0xc
  800366:	e8 b4 14 00 00       	call   80181f <cprintf_colored>
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
  8003bd:	e8 fe 34 00 00       	call   8038c0 <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 f8 4b 80 00       	push   $0x804bf8
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 3c 14 00 00       	call   80181f <cprintf_colored>
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
  800433:	68 30 4c 80 00       	push   $0x804c30
  800438:	6a 03                	push   $0x3
  80043a:	e8 e0 13 00 00       	call   80181f <cprintf_colored>
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
  8004fc:	68 60 4c 80 00       	push   $0x804c60
  800501:	6a 0c                	push   $0xc
  800503:	e8 17 13 00 00       	call   80181f <cprintf_colored>
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
  8005d6:	68 60 4c 80 00       	push   $0x804c60
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 3d 12 00 00       	call   80181f <cprintf_colored>
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
  8006b0:	68 60 4c 80 00       	push   $0x804c60
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 63 11 00 00       	call   80181f <cprintf_colored>
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
  80078a:	68 60 4c 80 00       	push   $0x804c60
  80078f:	6a 0c                	push   $0xc
  800791:	e8 89 10 00 00       	call   80181f <cprintf_colored>
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
  800864:	68 60 4c 80 00       	push   $0x804c60
  800869:	6a 0c                	push   $0xc
  80086b:	e8 af 0f 00 00       	call   80181f <cprintf_colored>
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
  80093e:	68 60 4c 80 00       	push   $0x804c60
  800943:	6a 0c                	push   $0xc
  800945:	e8 d5 0e 00 00       	call   80181f <cprintf_colored>
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
  800a33:	68 60 4c 80 00       	push   $0x804c60
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 e0 0d 00 00       	call   80181f <cprintf_colored>
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
  800b31:	68 60 4c 80 00       	push   $0x804c60
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 e2 0c 00 00       	call   80181f <cprintf_colored>
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
  800c2f:	68 60 4c 80 00       	push   $0x804c60
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 e4 0b 00 00       	call   80181f <cprintf_colored>
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
  800d2d:	68 60 4c 80 00       	push   $0x804c60
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 e6 0a 00 00       	call   80181f <cprintf_colored>
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
  800e1a:	68 60 4c 80 00       	push   $0x804c60
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 f9 09 00 00       	call   80181f <cprintf_colored>
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
  800f07:	68 60 4c 80 00       	push   $0x804c60
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 0c 09 00 00       	call   80181f <cprintf_colored>
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
  800ff4:	68 60 4c 80 00       	push   $0x804c60
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 1f 08 00 00       	call   80181f <cprintf_colored>
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
  801017:	68 b2 4c 80 00       	push   $0x804cb2
  80101c:	6a 03                	push   $0x3
  80101e:	e8 fc 07 00 00       	call   80181f <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 c2 24 00 00       	call   8034fe <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 02 25 00 00       	call   803549 <sys_pf_calculate_allocated_pages>
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
  801072:	e8 a6 1d 00 00       	call   802e1d <malloc>
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
  8010a1:	68 d0 4c 80 00       	push   $0x804cd0
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 72 07 00 00       	call   80181f <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 94 24 00 00       	call   803549 <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 0c 4d 80 00       	push   $0x804d0c
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 46 07 00 00       	call   80181f <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 1d 24 00 00       	call   8034fe <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 7c 4d 80 00       	push   $0x804d7c
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 1a 07 00 00       	call   80181f <cprintf_colored>
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


void _main(void)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801126:	a1 00 62 80 00       	mov    0x806200,%eax
  80112b:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801131:	a1 00 62 80 00       	mov    0x806200,%eax
  801136:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80113c:	39 c2                	cmp    %eax,%edx
  80113e:	72 14                	jb     801154 <_main+0x38>
			panic("Please increase the WS size");
  801140:	83 ec 04             	sub    $0x4,%esp
  801143:	68 c4 4d 80 00       	push   $0x804dc4
  801148:	6a 18                	push   $0x18
  80114a:	68 e0 4d 80 00       	push   $0x804de0
  80114f:	e8 b0 03 00 00       	call   801504 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/
	int eval = 0;
  801154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool correct ;

	correct = 1;
  80115b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//Create some areas in PAGE allocators
	cprintf_colored(TEXT_cyan,"%~\n1 Create some allocations\n");
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	68 f4 4d 80 00       	push   $0x804df4
  80116a:	6a 03                	push   $0x3
  80116c:	e8 ae 06 00 00       	call   80181f <cprintf_colored>
  801171:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  801174:	e8 72 f2 ff ff       	call   8003eb <initial_page_allocations>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
		eval = eval * 70 / 100; //rescale
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 02             	shl    $0x2,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80118f:	89 d1                	mov    %edx,%ecx
  801191:	29 c1                	sub    %eax,%ecx
  801193:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  801198:	f7 e9                	imul   %ecx
  80119a:	c1 fa 05             	sar    $0x5,%edx
  80119d:	89 c8                	mov    %ecx,%eax
  80119f:	c1 f8 1f             	sar    $0x1f,%eax
  8011a2:	29 c2                	sub    %eax,%edx
  8011a4:	89 d0                	mov    %edx,%eax
  8011a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	//2. Check BREAK
	correct = 1;
  8011a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n2. Check Page Allocator BREAK [10%]\n");
  8011b0:	83 ec 08             	sub    $0x8,%esp
  8011b3:	68 14 4e 80 00       	push   $0x804e14
  8011b8:	6a 03                	push   $0x3
  8011ba:	e8 60 06 00 00       	call   80181f <cprintf_colored>
  8011bf:	83 c4 10             	add    $0x10,%esp
	{
		uint32 allocSizes = 0;
  8011c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int i = 0; i < allocIndex; ++i)
  8011c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8011d0:	eb 30                	jmp    801202 <_main+0xe6>
		{
			allocSizes += ROUNDUP(requestedSizes[i], PAGE_SIZE);
  8011d2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8011d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011dc:	8b 14 85 60 61 80 00 	mov    0x806160(,%eax,4),%edx
  8011e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	48                   	dec    %eax
  8011e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f4:	f7 75 e0             	divl   -0x20(%ebp)
  8011f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011fa:	29 d0                	sub    %edx,%eax
  8011fc:	01 45 ec             	add    %eax,-0x14(%ebp)
	//2. Check BREAK
	correct = 1;
	cprintf_colored(TEXT_cyan,"%~\n2. Check Page Allocator BREAK [10%]\n");
	{
		uint32 allocSizes = 0;
		for (int i = 0; i < allocIndex; ++i)
  8011ff:	ff 45 e8             	incl   -0x18(%ebp)
  801202:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801207:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80120a:	7c c6                	jl     8011d2 <_main+0xb6>
		{
			allocSizes += ROUNDUP(requestedSizes[i], PAGE_SIZE);
		}
		uint32 expectedVA = ACTUAL_PAGE_ALLOC_START + allocSizes;
  80120c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120f:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  801214:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(uheapPageAllocBreak != expectedVA) {correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedVA, uheapPageAllocBreak);}
  801217:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80121c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80121f:	74 1f                	je     801240 <_main+0x124>
  801221:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801228:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80122d:	50                   	push   %eax
  80122e:	ff 75 d8             	pushl  -0x28(%ebp)
  801231:	68 3c 4e 80 00       	push   $0x804e3c
  801236:	6a 0c                	push   $0xc
  801238:	e8 e2 05 00 00       	call   80181f <cprintf_colored>
  80123d:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 10;
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 04                	je     80124a <_main+0x12e>
  801246:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	correct = 1;
  80124a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//3. Check Content
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
  801251:	8d 95 34 ff ff ff    	lea    -0xcc(%ebp),%edx
  801257:	b9 28 00 00 00       	mov    $0x28,%ecx
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
  801261:	89 d7                	mov    %edx,%edi
  801263:	f3 ab                	rep stos %eax,%es:(%edi)
	cprintf_colored(TEXT_cyan,"%~\n3. Check Content [20%]\n");
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	68 74 4e 80 00       	push   $0x804e74
  80126d:	6a 03                	push   $0x3
  80126f:	e8 ab 05 00 00       	call   80181f <cprintf_colored>
  801274:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 0; i < allocIndex; ++i)
  801277:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80127e:	e9 97 00 00 00       	jmp    80131a <_main+0x1fe>
		{
			char* ptr = (char*)ptr_allocations[i];
  801283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801286:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  80128d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			sums[i] += ptr[0] ;
  801290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801293:	8b 94 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%edx
  80129a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	0f be c0             	movsbl %al,%eax
  8012a2:	01 c2                	add    %eax,%edx
  8012a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a7:	89 94 85 34 ff ff ff 	mov    %edx,-0xcc(%ebp,%eax,4)
			sums[i] += ptr[lastIndices[i]] ;
  8012ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b1:	8b 94 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%edx
  8012b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012bb:	8b 04 85 c0 60 80 00 	mov    0x8060c0(,%eax,4),%eax
  8012c2:	89 c1                	mov    %eax,%ecx
  8012c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012c7:	01 c8                	add    %ecx,%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	0f be c0             	movsbl %al,%eax
  8012ce:	01 c2                	add    %eax,%edx
  8012d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d3:	89 94 85 34 ff ff ff 	mov    %edx,-0xcc(%ebp,%eax,4)
			if (sums[i] != (maxByte + maxByte))
  8012da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012dd:	8b 84 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%eax
  8012e4:	3d fe 00 00 00       	cmp    $0xfe,%eax
  8012e9:	74 2c                	je     801317 <_main+0x1fb>
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in allocation#%d. Expected = %d, Actual = %d\n", i, maxByte + maxByte, sums[i]); }
  8012eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f5:	8b 84 85 34 ff ff ff 	mov    -0xcc(%ebp,%eax,4),%eax
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	50                   	push   %eax
  801300:	68 fe 00 00 00       	push   $0xfe
  801305:	ff 75 e4             	pushl  -0x1c(%ebp)
  801308:	68 90 4e 80 00       	push   $0x804e90
  80130d:	6a 0c                	push   $0xc
  80130f:	e8 0b 05 00 00       	call   80181f <cprintf_colored>
  801314:	83 c4 20             	add    $0x20,%esp

	//3. Check Content
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
	cprintf_colored(TEXT_cyan,"%~\n3. Check Content [20%]\n");
	{
		for (int i = 0; i < allocIndex; ++i)
  801317:	ff 45 e4             	incl   -0x1c(%ebp)
  80131a:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80131f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801322:	0f 8c 5b ff ff ff    	jl     801283 <_main+0x167>
			sums[i] += ptr[lastIndices[i]] ;
			if (sums[i] != (maxByte + maxByte))
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in allocation#%d. Expected = %d, Actual = %d\n", i, maxByte + maxByte, sums[i]); }
		}
	}
	if (correct) eval += 20;
  801328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80132c:	74 04                	je     801332 <_main+0x216>
  80132e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	correct = 1;
  801332:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "%~\nTest malloc (1) [PAGE ALLOCATOR] completed. Eval = %d\n", eval);
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	ff 75 f4             	pushl  -0xc(%ebp)
  80133f:	68 d0 4e 80 00       	push   $0x804ed0
  801344:	6a 0a                	push   $0xa
  801346:	e8 d4 04 00 00       	call   80181f <cprintf_colored>
  80134b:	83 c4 10             	add    $0x10,%esp

	return;
  80134e:	90                   	nop
}
  80134f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	57                   	push   %edi
  801358:	56                   	push   %esi
  801359:	53                   	push   %ebx
  80135a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80135d:	e8 65 23 00 00       	call   8036c7 <sys_getenvindex>
  801362:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801365:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801368:	89 d0                	mov    %edx,%eax
  80136a:	01 c0                	add    %eax,%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	c1 e0 02             	shl    $0x2,%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	c1 e0 02             	shl    $0x2,%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	c1 e0 03             	shl    $0x3,%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	c1 e0 02             	shl    $0x2,%eax
  801380:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801385:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80138a:	a1 00 62 80 00       	mov    0x806200,%eax
  80138f:	8a 40 20             	mov    0x20(%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	74 0d                	je     8013a3 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801396:	a1 00 62 80 00       	mov    0x806200,%eax
  80139b:	83 c0 20             	add    $0x20,%eax
  80139e:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8013a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a7:	7e 0a                	jle    8013b3 <libmain+0x5f>
		binaryname = argv[0];
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	8b 00                	mov    (%eax),%eax
  8013ae:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 5b fd ff ff       	call   80111c <_main>
  8013c1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8013c4:	a1 00 60 80 00       	mov    0x806000,%eax
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	0f 84 01 01 00 00    	je     8014d2 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8013d1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8013d7:	bb 04 50 80 00       	mov    $0x805004,%ebx
  8013dc:	ba 0e 00 00 00       	mov    $0xe,%edx
  8013e1:	89 c7                	mov    %eax,%edi
  8013e3:	89 de                	mov    %ebx,%esi
  8013e5:	89 d1                	mov    %edx,%ecx
  8013e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8013e9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8013ec:	b9 56 00 00 00       	mov    $0x56,%ecx
  8013f1:	b0 00                	mov    $0x0,%al
  8013f3:	89 d7                	mov    %edx,%edi
  8013f5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8013f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8013fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	50                   	push   %eax
  801405:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80140b:	50                   	push   %eax
  80140c:	e8 ec 24 00 00       	call   8038fd <sys_utilities>
  801411:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801414:	e8 35 20 00 00       	call   80344e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801419:	83 ec 0c             	sub    $0xc,%esp
  80141c:	68 24 4f 80 00       	push   $0x804f24
  801421:	e8 cc 03 00 00       	call   8017f2 <cprintf>
  801426:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142c:	85 c0                	test   %eax,%eax
  80142e:	74 18                	je     801448 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801430:	e8 e6 24 00 00       	call   80391b <sys_get_optimal_num_faults>
  801435:	83 ec 08             	sub    $0x8,%esp
  801438:	50                   	push   %eax
  801439:	68 4c 4f 80 00       	push   $0x804f4c
  80143e:	e8 af 03 00 00       	call   8017f2 <cprintf>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	eb 59                	jmp    8014a1 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801448:	a1 00 62 80 00       	mov    0x806200,%eax
  80144d:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  801453:	a1 00 62 80 00       	mov    0x806200,%eax
  801458:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	52                   	push   %edx
  801462:	50                   	push   %eax
  801463:	68 70 4f 80 00       	push   $0x804f70
  801468:	e8 85 03 00 00       	call   8017f2 <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801470:	a1 00 62 80 00       	mov    0x806200,%eax
  801475:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80147b:	a1 00 62 80 00       	mov    0x806200,%eax
  801480:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  801486:	a1 00 62 80 00       	mov    0x806200,%eax
  80148b:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  801491:	51                   	push   %ecx
  801492:	52                   	push   %edx
  801493:	50                   	push   %eax
  801494:	68 98 4f 80 00       	push   $0x804f98
  801499:	e8 54 03 00 00       	call   8017f2 <cprintf>
  80149e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8014a1:	a1 00 62 80 00       	mov    0x806200,%eax
  8014a6:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	50                   	push   %eax
  8014b0:	68 f0 4f 80 00       	push   $0x804ff0
  8014b5:	e8 38 03 00 00       	call   8017f2 <cprintf>
  8014ba:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8014bd:	83 ec 0c             	sub    $0xc,%esp
  8014c0:	68 24 4f 80 00       	push   $0x804f24
  8014c5:	e8 28 03 00 00       	call   8017f2 <cprintf>
  8014ca:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8014cd:	e8 96 1f 00 00       	call   803468 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8014d2:	e8 1f 00 00 00       	call   8014f6 <exit>
}
  8014d7:	90                   	nop
  8014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5f                   	pop    %edi
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	6a 00                	push   $0x0
  8014eb:	e8 a3 21 00 00       	call   803693 <sys_destroy_env>
  8014f0:	83 c4 10             	add    $0x10,%esp
}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <exit>:

void
exit(void)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8014fc:	e8 f8 21 00 00       	call   8036f9 <sys_exit_env>
}
  801501:	90                   	nop
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80150a:	8d 45 10             	lea    0x10(%ebp),%eax
  80150d:	83 c0 04             	add    $0x4,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801513:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801518:	85 c0                	test   %eax,%eax
  80151a:	74 16                	je     801532 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80151c:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801521:	83 ec 08             	sub    $0x8,%esp
  801524:	50                   	push   %eax
  801525:	68 68 50 80 00       	push   $0x805068
  80152a:	e8 c3 02 00 00       	call   8017f2 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801532:	a1 04 60 80 00       	mov    0x806004,%eax
  801537:	83 ec 0c             	sub    $0xc,%esp
  80153a:	ff 75 0c             	pushl  0xc(%ebp)
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	50                   	push   %eax
  801541:	68 70 50 80 00       	push   $0x805070
  801546:	6a 74                	push   $0x74
  801548:	e8 d2 02 00 00       	call   80181f <cprintf_colored>
  80154d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801550:	8b 45 10             	mov    0x10(%ebp),%eax
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	ff 75 f4             	pushl  -0xc(%ebp)
  801559:	50                   	push   %eax
  80155a:	e8 24 02 00 00       	call   801783 <vcprintf>
  80155f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	6a 00                	push   $0x0
  801567:	68 98 50 80 00       	push   $0x805098
  80156c:	e8 12 02 00 00       	call   801783 <vcprintf>
  801571:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801574:	e8 7d ff ff ff       	call   8014f6 <exit>

	// should not return here
	while (1) ;
  801579:	eb fe                	jmp    801579 <_panic+0x75>

0080157b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	53                   	push   %ebx
  80157f:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801582:	a1 00 62 80 00       	mov    0x806200,%eax
  801587:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	39 c2                	cmp    %eax,%edx
  801592:	74 14                	je     8015a8 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	68 9c 50 80 00       	push   $0x80509c
  80159c:	6a 26                	push   $0x26
  80159e:	68 e8 50 80 00       	push   $0x8050e8
  8015a3:	e8 5c ff ff ff       	call   801504 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8015a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8015af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8015b6:	e9 d9 00 00 00       	jmp    801694 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	01 d0                	add    %edx,%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	75 08                	jne    8015d8 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8015d0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8015d3:	e9 b9 00 00 00       	jmp    801691 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8015d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8015e6:	eb 79                	jmp    801661 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8015e8:	a1 00 62 80 00       	mov    0x806200,%eax
  8015ed:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8015f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015f6:	89 d0                	mov    %edx,%eax
  8015f8:	01 c0                	add    %eax,%eax
  8015fa:	01 d0                	add    %edx,%eax
  8015fc:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801603:	01 d8                	add    %ebx,%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	01 c8                	add    %ecx,%eax
  801609:	8a 40 04             	mov    0x4(%eax),%al
  80160c:	84 c0                	test   %al,%al
  80160e:	75 4e                	jne    80165e <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801610:	a1 00 62 80 00       	mov    0x806200,%eax
  801615:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80161b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80161e:	89 d0                	mov    %edx,%eax
  801620:	01 c0                	add    %eax,%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80162b:	01 d8                	add    %ebx,%eax
  80162d:	01 d0                	add    %edx,%eax
  80162f:	01 c8                	add    %ecx,%eax
  801631:	8b 00                	mov    (%eax),%eax
  801633:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801636:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801639:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80163e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	01 c8                	add    %ecx,%eax
  80164f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801651:	39 c2                	cmp    %eax,%edx
  801653:	75 09                	jne    80165e <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  801655:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80165c:	eb 19                	jmp    801677 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80165e:	ff 45 e8             	incl   -0x18(%ebp)
  801661:	a1 00 62 80 00       	mov    0x806200,%eax
  801666:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80166c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80166f:	39 c2                	cmp    %eax,%edx
  801671:	0f 87 71 ff ff ff    	ja     8015e8 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801677:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80167b:	75 14                	jne    801691 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  80167d:	83 ec 04             	sub    $0x4,%esp
  801680:	68 f4 50 80 00       	push   $0x8050f4
  801685:	6a 3a                	push   $0x3a
  801687:	68 e8 50 80 00       	push   $0x8050e8
  80168c:	e8 73 fe ff ff       	call   801504 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801691:	ff 45 f0             	incl   -0x10(%ebp)
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801697:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80169a:	0f 8c 1b ff ff ff    	jl     8015bb <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8016a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8016ae:	eb 2e                	jmp    8016de <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8016b0:	a1 00 62 80 00       	mov    0x806200,%eax
  8016b5:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8016bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016be:	89 d0                	mov    %edx,%eax
  8016c0:	01 c0                	add    %eax,%eax
  8016c2:	01 d0                	add    %edx,%eax
  8016c4:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8016cb:	01 d8                	add    %ebx,%eax
  8016cd:	01 d0                	add    %edx,%eax
  8016cf:	01 c8                	add    %ecx,%eax
  8016d1:	8a 40 04             	mov    0x4(%eax),%al
  8016d4:	3c 01                	cmp    $0x1,%al
  8016d6:	75 03                	jne    8016db <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8016d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016db:	ff 45 e0             	incl   -0x20(%ebp)
  8016de:	a1 00 62 80 00       	mov    0x806200,%eax
  8016e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ec:	39 c2                	cmp    %eax,%edx
  8016ee:	77 c0                	ja     8016b0 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8016f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8016f6:	74 14                	je     80170c <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8016f8:	83 ec 04             	sub    $0x4,%esp
  8016fb:	68 48 51 80 00       	push   $0x805148
  801700:	6a 44                	push   $0x44
  801702:	68 e8 50 80 00       	push   $0x8050e8
  801707:	e8 f8 fd ff ff       	call   801504 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80170c:	90                   	nop
  80170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	53                   	push   %ebx
  801716:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171c:	8b 00                	mov    (%eax),%eax
  80171e:	8d 48 01             	lea    0x1(%eax),%ecx
  801721:	8b 55 0c             	mov    0xc(%ebp),%edx
  801724:	89 0a                	mov    %ecx,(%edx)
  801726:	8b 55 08             	mov    0x8(%ebp),%edx
  801729:	88 d1                	mov    %dl,%cl
  80172b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801732:	8b 45 0c             	mov    0xc(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	3d ff 00 00 00       	cmp    $0xff,%eax
  80173c:	75 30                	jne    80176e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80173e:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801744:	a0 24 62 80 00       	mov    0x806224,%al
  801749:	0f b6 c0             	movzbl %al,%eax
  80174c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174f:	8b 09                	mov    (%ecx),%ecx
  801751:	89 cb                	mov    %ecx,%ebx
  801753:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801756:	83 c1 08             	add    $0x8,%ecx
  801759:	52                   	push   %edx
  80175a:	50                   	push   %eax
  80175b:	53                   	push   %ebx
  80175c:	51                   	push   %ecx
  80175d:	e8 a8 1c 00 00       	call   80340a <sys_cputs>
  801762:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801765:	8b 45 0c             	mov    0xc(%ebp),%eax
  801768:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	8b 40 04             	mov    0x4(%eax),%eax
  801774:	8d 50 01             	lea    0x1(%eax),%edx
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80177d:	90                   	nop
  80177e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80178c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801793:	00 00 00 
	b.cnt = 0;
  801796:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80179d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8017ac:	50                   	push   %eax
  8017ad:	68 12 17 80 00       	push   $0x801712
  8017b2:	e8 5a 02 00 00       	call   801a11 <vprintfmt>
  8017b7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8017ba:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  8017c0:	a0 24 62 80 00       	mov    0x806224,%al
  8017c5:	0f b6 c0             	movzbl %al,%eax
  8017c8:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8017ce:	52                   	push   %edx
  8017cf:	50                   	push   %eax
  8017d0:	51                   	push   %ecx
  8017d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8017d7:	83 c0 08             	add    $0x8,%eax
  8017da:	50                   	push   %eax
  8017db:	e8 2a 1c 00 00       	call   80340a <sys_cputs>
  8017e0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8017e3:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  8017ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8017f8:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  8017ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  801802:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	ff 75 f4             	pushl  -0xc(%ebp)
  80180e:	50                   	push   %eax
  80180f:	e8 6f ff ff ff       	call   801783 <vcprintf>
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80181a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801825:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	c1 e0 08             	shl    $0x8,%eax
  801832:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  801837:	8d 45 0c             	lea    0xc(%ebp),%eax
  80183a:	83 c0 04             	add    $0x4,%eax
  80183d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	83 ec 08             	sub    $0x8,%esp
  801846:	ff 75 f4             	pushl  -0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	e8 34 ff ff ff       	call   801783 <vcprintf>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801855:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  80185c:	07 00 00 

	return cnt;
  80185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80186a:	e8 df 1b 00 00       	call   80344e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80186f:	8d 45 0c             	lea    0xc(%ebp),%eax
  801872:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	83 ec 08             	sub    $0x8,%esp
  80187b:	ff 75 f4             	pushl  -0xc(%ebp)
  80187e:	50                   	push   %eax
  80187f:	e8 ff fe ff ff       	call   801783 <vcprintf>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80188a:	e8 d9 1b 00 00       	call   803468 <sys_unlock_cons>
	return cnt;
  80188f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
  801898:	83 ec 14             	sub    $0x14,%esp
  80189b:	8b 45 10             	mov    0x10(%ebp),%eax
  80189e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018a7:	8b 45 18             	mov    0x18(%ebp),%eax
  8018aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018b2:	77 55                	ja     801909 <printnum+0x75>
  8018b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018b7:	72 05                	jb     8018be <printnum+0x2a>
  8018b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018bc:	77 4b                	ja     801909 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018be:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018c1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	52                   	push   %edx
  8018cd:	50                   	push   %eax
  8018ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d4:	e8 d3 2d 00 00       	call   8046ac <__udivdi3>
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	ff 75 20             	pushl  0x20(%ebp)
  8018e2:	53                   	push   %ebx
  8018e3:	ff 75 18             	pushl  0x18(%ebp)
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	e8 a1 ff ff ff       	call   801894 <printnum>
  8018f3:	83 c4 20             	add    $0x20,%esp
  8018f6:	eb 1a                	jmp    801912 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8018f8:	83 ec 08             	sub    $0x8,%esp
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 20             	pushl  0x20(%ebp)
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	ff d0                	call   *%eax
  801906:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801909:	ff 4d 1c             	decl   0x1c(%ebp)
  80190c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801910:	7f e6                	jg     8018f8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801912:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801915:	bb 00 00 00 00       	mov    $0x0,%ebx
  80191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801920:	53                   	push   %ebx
  801921:	51                   	push   %ecx
  801922:	52                   	push   %edx
  801923:	50                   	push   %eax
  801924:	e8 93 2e 00 00       	call   8047bc <__umoddi3>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	05 b4 53 80 00       	add    $0x8053b4,%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	50                   	push   %eax
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	ff d0                	call   *%eax
  801942:	83 c4 10             	add    $0x10,%esp
}
  801945:	90                   	nop
  801946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80194e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801952:	7e 1c                	jle    801970 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8b 00                	mov    (%eax),%eax
  801959:	8d 50 08             	lea    0x8(%eax),%edx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	89 10                	mov    %edx,(%eax)
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	8b 00                	mov    (%eax),%eax
  801966:	83 e8 08             	sub    $0x8,%eax
  801969:	8b 50 04             	mov    0x4(%eax),%edx
  80196c:	8b 00                	mov    (%eax),%eax
  80196e:	eb 40                	jmp    8019b0 <getuint+0x65>
	else if (lflag)
  801970:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801974:	74 1e                	je     801994 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	8b 00                	mov    (%eax),%eax
  80197b:	8d 50 04             	lea    0x4(%eax),%edx
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	89 10                	mov    %edx,(%eax)
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8b 00                	mov    (%eax),%eax
  801988:	83 e8 04             	sub    $0x4,%eax
  80198b:	8b 00                	mov    (%eax),%eax
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
  801992:	eb 1c                	jmp    8019b0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	8b 00                	mov    (%eax),%eax
  801999:	8d 50 04             	lea    0x4(%eax),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 10                	mov    %edx,(%eax)
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	8b 00                	mov    (%eax),%eax
  8019a6:	83 e8 04             	sub    $0x4,%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    

008019b2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019b5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019b9:	7e 1c                	jle    8019d7 <getint+0x25>
		return va_arg(*ap, long long);
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8b 00                	mov    (%eax),%eax
  8019c0:	8d 50 08             	lea    0x8(%eax),%edx
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	89 10                	mov    %edx,(%eax)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8b 00                	mov    (%eax),%eax
  8019cd:	83 e8 08             	sub    $0x8,%eax
  8019d0:	8b 50 04             	mov    0x4(%eax),%edx
  8019d3:	8b 00                	mov    (%eax),%eax
  8019d5:	eb 38                	jmp    801a0f <getint+0x5d>
	else if (lflag)
  8019d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019db:	74 1a                	je     8019f7 <getint+0x45>
		return va_arg(*ap, long);
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 00                	mov    (%eax),%eax
  8019e2:	8d 50 04             	lea    0x4(%eax),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	89 10                	mov    %edx,(%eax)
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8b 00                	mov    (%eax),%eax
  8019ef:	83 e8 04             	sub    $0x4,%eax
  8019f2:	8b 00                	mov    (%eax),%eax
  8019f4:	99                   	cltd   
  8019f5:	eb 18                	jmp    801a0f <getint+0x5d>
	else
		return va_arg(*ap, int);
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8b 00                	mov    (%eax),%eax
  8019fc:	8d 50 04             	lea    0x4(%eax),%edx
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	89 10                	mov    %edx,(%eax)
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	8b 00                	mov    (%eax),%eax
  801a09:	83 e8 04             	sub    $0x4,%eax
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	99                   	cltd   
}
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    

00801a11 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	56                   	push   %esi
  801a15:	53                   	push   %ebx
  801a16:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a19:	eb 17                	jmp    801a32 <vprintfmt+0x21>
			if (ch == '\0')
  801a1b:	85 db                	test   %ebx,%ebx
  801a1d:	0f 84 c1 03 00 00    	je     801de4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	53                   	push   %ebx
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	ff d0                	call   *%eax
  801a2f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a32:	8b 45 10             	mov    0x10(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 10             	mov    %edx,0x10(%ebp)
  801a3b:	8a 00                	mov    (%eax),%al
  801a3d:	0f b6 d8             	movzbl %al,%ebx
  801a40:	83 fb 25             	cmp    $0x25,%ebx
  801a43:	75 d6                	jne    801a1b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a45:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a49:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a50:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a57:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a65:	8b 45 10             	mov    0x10(%ebp),%eax
  801a68:	8d 50 01             	lea    0x1(%eax),%edx
  801a6b:	89 55 10             	mov    %edx,0x10(%ebp)
  801a6e:	8a 00                	mov    (%eax),%al
  801a70:	0f b6 d8             	movzbl %al,%ebx
  801a73:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a76:	83 f8 5b             	cmp    $0x5b,%eax
  801a79:	0f 87 3d 03 00 00    	ja     801dbc <vprintfmt+0x3ab>
  801a7f:	8b 04 85 d8 53 80 00 	mov    0x8053d8(,%eax,4),%eax
  801a86:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a88:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801a8c:	eb d7                	jmp    801a65 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a8e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801a92:	eb d1                	jmp    801a65 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a94:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801a9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9e:	89 d0                	mov    %edx,%eax
  801aa0:	c1 e0 02             	shl    $0x2,%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	01 c0                	add    %eax,%eax
  801aa7:	01 d8                	add    %ebx,%eax
  801aa9:	83 e8 30             	sub    $0x30,%eax
  801aac:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab2:	8a 00                	mov    (%eax),%al
  801ab4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ab7:	83 fb 2f             	cmp    $0x2f,%ebx
  801aba:	7e 3e                	jle    801afa <vprintfmt+0xe9>
  801abc:	83 fb 39             	cmp    $0x39,%ebx
  801abf:	7f 39                	jg     801afa <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ac1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ac4:	eb d5                	jmp    801a9b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac9:	83 c0 04             	add    $0x4,%eax
  801acc:	89 45 14             	mov    %eax,0x14(%ebp)
  801acf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad2:	83 e8 04             	sub    $0x4,%eax
  801ad5:	8b 00                	mov    (%eax),%eax
  801ad7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801ada:	eb 1f                	jmp    801afb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801adc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ae0:	79 83                	jns    801a65 <vprintfmt+0x54>
				width = 0;
  801ae2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801ae9:	e9 77 ff ff ff       	jmp    801a65 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801aee:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801af5:	e9 6b ff ff ff       	jmp    801a65 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801afa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801afb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aff:	0f 89 60 ff ff ff    	jns    801a65 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b0b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b12:	e9 4e ff ff ff       	jmp    801a65 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b17:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b1a:	e9 46 ff ff ff       	jmp    801a65 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b22:	83 c0 04             	add    $0x4,%eax
  801b25:	89 45 14             	mov    %eax,0x14(%ebp)
  801b28:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2b:	83 e8 04             	sub    $0x4,%eax
  801b2e:	8b 00                	mov    (%eax),%eax
  801b30:	83 ec 08             	sub    $0x8,%esp
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	50                   	push   %eax
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
			break;
  801b3f:	e9 9b 02 00 00       	jmp    801ddf <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b44:	8b 45 14             	mov    0x14(%ebp),%eax
  801b47:	83 c0 04             	add    $0x4,%eax
  801b4a:	89 45 14             	mov    %eax,0x14(%ebp)
  801b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b50:	83 e8 04             	sub    $0x4,%eax
  801b53:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b55:	85 db                	test   %ebx,%ebx
  801b57:	79 02                	jns    801b5b <vprintfmt+0x14a>
				err = -err;
  801b59:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b5b:	83 fb 64             	cmp    $0x64,%ebx
  801b5e:	7f 0b                	jg     801b6b <vprintfmt+0x15a>
  801b60:	8b 34 9d 20 52 80 00 	mov    0x805220(,%ebx,4),%esi
  801b67:	85 f6                	test   %esi,%esi
  801b69:	75 19                	jne    801b84 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b6b:	53                   	push   %ebx
  801b6c:	68 c5 53 80 00       	push   $0x8053c5
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	e8 70 02 00 00       	call   801dec <printfmt>
  801b7c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b7f:	e9 5b 02 00 00       	jmp    801ddf <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b84:	56                   	push   %esi
  801b85:	68 ce 53 80 00       	push   $0x8053ce
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	e8 57 02 00 00       	call   801dec <printfmt>
  801b95:	83 c4 10             	add    $0x10,%esp
			break;
  801b98:	e9 42 02 00 00       	jmp    801ddf <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba0:	83 c0 04             	add    $0x4,%eax
  801ba3:	89 45 14             	mov    %eax,0x14(%ebp)
  801ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba9:	83 e8 04             	sub    $0x4,%eax
  801bac:	8b 30                	mov    (%eax),%esi
  801bae:	85 f6                	test   %esi,%esi
  801bb0:	75 05                	jne    801bb7 <vprintfmt+0x1a6>
				p = "(null)";
  801bb2:	be d1 53 80 00       	mov    $0x8053d1,%esi
			if (width > 0 && padc != '-')
  801bb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bbb:	7e 6d                	jle    801c2a <vprintfmt+0x219>
  801bbd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801bc1:	74 67                	je     801c2a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc6:	83 ec 08             	sub    $0x8,%esp
  801bc9:	50                   	push   %eax
  801bca:	56                   	push   %esi
  801bcb:	e8 1e 03 00 00       	call   801eee <strnlen>
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801bd6:	eb 16                	jmp    801bee <vprintfmt+0x1dd>
					putch(padc, putdat);
  801bd8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801bdc:	83 ec 08             	sub    $0x8,%esp
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	50                   	push   %eax
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	ff d0                	call   *%eax
  801be8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801beb:	ff 4d e4             	decl   -0x1c(%ebp)
  801bee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bf2:	7f e4                	jg     801bd8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801bf4:	eb 34                	jmp    801c2a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801bf6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bfa:	74 1c                	je     801c18 <vprintfmt+0x207>
  801bfc:	83 fb 1f             	cmp    $0x1f,%ebx
  801bff:	7e 05                	jle    801c06 <vprintfmt+0x1f5>
  801c01:	83 fb 7e             	cmp    $0x7e,%ebx
  801c04:	7e 12                	jle    801c18 <vprintfmt+0x207>
					putch('?', putdat);
  801c06:	83 ec 08             	sub    $0x8,%esp
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	6a 3f                	push   $0x3f
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	ff d0                	call   *%eax
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	eb 0f                	jmp    801c27 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	53                   	push   %ebx
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	ff d0                	call   *%eax
  801c24:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c27:	ff 4d e4             	decl   -0x1c(%ebp)
  801c2a:	89 f0                	mov    %esi,%eax
  801c2c:	8d 70 01             	lea    0x1(%eax),%esi
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be d8             	movsbl %al,%ebx
  801c34:	85 db                	test   %ebx,%ebx
  801c36:	74 24                	je     801c5c <vprintfmt+0x24b>
  801c38:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c3c:	78 b8                	js     801bf6 <vprintfmt+0x1e5>
  801c3e:	ff 4d e0             	decl   -0x20(%ebp)
  801c41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c45:	79 af                	jns    801bf6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c47:	eb 13                	jmp    801c5c <vprintfmt+0x24b>
				putch(' ', putdat);
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	6a 20                	push   $0x20
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	ff d0                	call   *%eax
  801c56:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c59:	ff 4d e4             	decl   -0x1c(%ebp)
  801c5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c60:	7f e7                	jg     801c49 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c62:	e9 78 01 00 00       	jmp    801ddf <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c67:	83 ec 08             	sub    $0x8,%esp
  801c6a:	ff 75 e8             	pushl  -0x18(%ebp)
  801c6d:	8d 45 14             	lea    0x14(%ebp),%eax
  801c70:	50                   	push   %eax
  801c71:	e8 3c fd ff ff       	call   8019b2 <getint>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c85:	85 d2                	test   %edx,%edx
  801c87:	79 23                	jns    801cac <vprintfmt+0x29b>
				putch('-', putdat);
  801c89:	83 ec 08             	sub    $0x8,%esp
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	6a 2d                	push   $0x2d
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	ff d0                	call   *%eax
  801c96:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c9f:	f7 d8                	neg    %eax
  801ca1:	83 d2 00             	adc    $0x0,%edx
  801ca4:	f7 da                	neg    %edx
  801ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ca9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cac:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cb3:	e9 bc 00 00 00       	jmp    801d74 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cb8:	83 ec 08             	sub    $0x8,%esp
  801cbb:	ff 75 e8             	pushl  -0x18(%ebp)
  801cbe:	8d 45 14             	lea    0x14(%ebp),%eax
  801cc1:	50                   	push   %eax
  801cc2:	e8 84 fc ff ff       	call   80194b <getuint>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ccd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801cd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cd7:	e9 98 00 00 00       	jmp    801d74 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801cdc:	83 ec 08             	sub    $0x8,%esp
  801cdf:	ff 75 0c             	pushl  0xc(%ebp)
  801ce2:	6a 58                	push   $0x58
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	ff d0                	call   *%eax
  801ce9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	6a 58                	push   $0x58
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	ff d0                	call   *%eax
  801cf9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cfc:	83 ec 08             	sub    $0x8,%esp
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	6a 58                	push   $0x58
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	ff d0                	call   *%eax
  801d09:	83 c4 10             	add    $0x10,%esp
			break;
  801d0c:	e9 ce 00 00 00       	jmp    801ddf <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d11:	83 ec 08             	sub    $0x8,%esp
  801d14:	ff 75 0c             	pushl  0xc(%ebp)
  801d17:	6a 30                	push   $0x30
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	ff d0                	call   *%eax
  801d1e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d21:	83 ec 08             	sub    $0x8,%esp
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	6a 78                	push   $0x78
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	ff d0                	call   *%eax
  801d2e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d31:	8b 45 14             	mov    0x14(%ebp),%eax
  801d34:	83 c0 04             	add    $0x4,%eax
  801d37:	89 45 14             	mov    %eax,0x14(%ebp)
  801d3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3d:	83 e8 04             	sub    $0x4,%eax
  801d40:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d4c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d53:	eb 1f                	jmp    801d74 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	ff 75 e8             	pushl  -0x18(%ebp)
  801d5b:	8d 45 14             	lea    0x14(%ebp),%eax
  801d5e:	50                   	push   %eax
  801d5f:	e8 e7 fb ff ff       	call   80194b <getuint>
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d6d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d74:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	83 ec 04             	sub    $0x4,%esp
  801d7e:	52                   	push   %edx
  801d7f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d82:	50                   	push   %eax
  801d83:	ff 75 f4             	pushl  -0xc(%ebp)
  801d86:	ff 75 f0             	pushl  -0x10(%ebp)
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	ff 75 08             	pushl  0x8(%ebp)
  801d8f:	e8 00 fb ff ff       	call   801894 <printnum>
  801d94:	83 c4 20             	add    $0x20,%esp
			break;
  801d97:	eb 46                	jmp    801ddf <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801d99:	83 ec 08             	sub    $0x8,%esp
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	53                   	push   %ebx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	ff d0                	call   *%eax
  801da5:	83 c4 10             	add    $0x10,%esp
			break;
  801da8:	eb 35                	jmp    801ddf <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801daa:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  801db1:	eb 2c                	jmp    801ddf <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801db3:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  801dba:	eb 23                	jmp    801ddf <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	ff 75 0c             	pushl  0xc(%ebp)
  801dc2:	6a 25                	push   $0x25
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	ff d0                	call   *%eax
  801dc9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dcc:	ff 4d 10             	decl   0x10(%ebp)
  801dcf:	eb 03                	jmp    801dd4 <vprintfmt+0x3c3>
  801dd1:	ff 4d 10             	decl   0x10(%ebp)
  801dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd7:	48                   	dec    %eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	3c 25                	cmp    $0x25,%al
  801ddc:	75 f3                	jne    801dd1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801dde:	90                   	nop
		}
	}
  801ddf:	e9 35 fc ff ff       	jmp    801a19 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801de4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801de5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de8:	5b                   	pop    %ebx
  801de9:	5e                   	pop    %esi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801df2:	8d 45 10             	lea    0x10(%ebp),%eax
  801df5:	83 c0 04             	add    $0x4,%eax
  801df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfe:	ff 75 f4             	pushl  -0xc(%ebp)
  801e01:	50                   	push   %eax
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	ff 75 08             	pushl  0x8(%ebp)
  801e08:	e8 04 fc ff ff       	call   801a11 <vprintfmt>
  801e0d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e10:	90                   	nop
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	8b 40 08             	mov    0x8(%eax),%eax
  801e1c:	8d 50 01             	lea    0x1(%eax),%edx
  801e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e22:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e28:	8b 10                	mov    (%eax),%edx
  801e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2d:	8b 40 04             	mov    0x4(%eax),%eax
  801e30:	39 c2                	cmp    %eax,%edx
  801e32:	73 12                	jae    801e46 <sprintputch+0x33>
		*b->buf++ = ch;
  801e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e37:	8b 00                	mov    (%eax),%eax
  801e39:	8d 48 01             	lea    0x1(%eax),%ecx
  801e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3f:	89 0a                	mov    %ecx,(%edx)
  801e41:	8b 55 08             	mov    0x8(%ebp),%edx
  801e44:	88 10                	mov    %dl,(%eax)
}
  801e46:	90                   	nop
  801e47:	5d                   	pop    %ebp
  801e48:	c3                   	ret    

00801e49 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	01 d0                	add    %edx,%eax
  801e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e6e:	74 06                	je     801e76 <vsnprintf+0x2d>
  801e70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e74:	7f 07                	jg     801e7d <vsnprintf+0x34>
		return -E_INVAL;
  801e76:	b8 03 00 00 00       	mov    $0x3,%eax
  801e7b:	eb 20                	jmp    801e9d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e7d:	ff 75 14             	pushl  0x14(%ebp)
  801e80:	ff 75 10             	pushl  0x10(%ebp)
  801e83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e86:	50                   	push   %eax
  801e87:	68 13 1e 80 00       	push   $0x801e13
  801e8c:	e8 80 fb ff ff       	call   801a11 <vprintfmt>
  801e91:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e97:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ea5:	8d 45 10             	lea    0x10(%ebp),%eax
  801ea8:	83 c0 04             	add    $0x4,%eax
  801eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801eae:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb4:	50                   	push   %eax
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	ff 75 08             	pushl  0x8(%ebp)
  801ebb:	e8 89 ff ff ff       	call   801e49 <vsnprintf>
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ed1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ed8:	eb 06                	jmp    801ee0 <strlen+0x15>
		n++;
  801eda:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801edd:	ff 45 08             	incl   0x8(%ebp)
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	84 c0                	test   %al,%al
  801ee7:	75 f1                	jne    801eda <strlen+0xf>
		n++;
	return n;
  801ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ef4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801efb:	eb 09                	jmp    801f06 <strnlen+0x18>
		n++;
  801efd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f00:	ff 45 08             	incl   0x8(%ebp)
  801f03:	ff 4d 0c             	decl   0xc(%ebp)
  801f06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f0a:	74 09                	je     801f15 <strnlen+0x27>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	84 c0                	test   %al,%al
  801f13:	75 e8                	jne    801efd <strnlen+0xf>
		n++;
	return n;
  801f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f26:	90                   	nop
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	8d 50 01             	lea    0x1(%eax),%edx
  801f2d:	89 55 08             	mov    %edx,0x8(%ebp)
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f36:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f39:	8a 12                	mov    (%edx),%dl
  801f3b:	88 10                	mov    %dl,(%eax)
  801f3d:	8a 00                	mov    (%eax),%al
  801f3f:	84 c0                	test   %al,%al
  801f41:	75 e4                	jne    801f27 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f5b:	eb 1f                	jmp    801f7c <strncpy+0x34>
		*dst++ = *src;
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	8d 50 01             	lea    0x1(%eax),%edx
  801f63:	89 55 08             	mov    %edx,0x8(%ebp)
  801f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f69:	8a 12                	mov    (%edx),%dl
  801f6b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	8a 00                	mov    (%eax),%al
  801f72:	84 c0                	test   %al,%al
  801f74:	74 03                	je     801f79 <strncpy+0x31>
			src++;
  801f76:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f79:	ff 45 fc             	incl   -0x4(%ebp)
  801f7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f82:	72 d9                	jb     801f5d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f84:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f99:	74 30                	je     801fcb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801f9b:	eb 16                	jmp    801fb3 <strlcpy+0x2a>
			*dst++ = *src++;
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	8d 50 01             	lea    0x1(%eax),%edx
  801fa3:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa9:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801faf:	8a 12                	mov    (%edx),%dl
  801fb1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fb3:	ff 4d 10             	decl   0x10(%ebp)
  801fb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fba:	74 09                	je     801fc5 <strlcpy+0x3c>
  801fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbf:	8a 00                	mov    (%eax),%al
  801fc1:	84 c0                	test   %al,%al
  801fc3:	75 d8                	jne    801f9d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd1:	29 c2                	sub    %eax,%edx
  801fd3:	89 d0                	mov    %edx,%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801fda:	eb 06                	jmp    801fe2 <strcmp+0xb>
		p++, q++;
  801fdc:	ff 45 08             	incl   0x8(%ebp)
  801fdf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	8a 00                	mov    (%eax),%al
  801fe7:	84 c0                	test   %al,%al
  801fe9:	74 0e                	je     801ff9 <strcmp+0x22>
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	8a 10                	mov    (%eax),%dl
  801ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff3:	8a 00                	mov    (%eax),%al
  801ff5:	38 c2                	cmp    %al,%dl
  801ff7:	74 e3                	je     801fdc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	8a 00                	mov    (%eax),%al
  801ffe:	0f b6 d0             	movzbl %al,%edx
  802001:	8b 45 0c             	mov    0xc(%ebp),%eax
  802004:	8a 00                	mov    (%eax),%al
  802006:	0f b6 c0             	movzbl %al,%eax
  802009:	29 c2                	sub    %eax,%edx
  80200b:	89 d0                	mov    %edx,%eax
}
  80200d:	5d                   	pop    %ebp
  80200e:	c3                   	ret    

0080200f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802012:	eb 09                	jmp    80201d <strncmp+0xe>
		n--, p++, q++;
  802014:	ff 4d 10             	decl   0x10(%ebp)
  802017:	ff 45 08             	incl   0x8(%ebp)
  80201a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80201d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802021:	74 17                	je     80203a <strncmp+0x2b>
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	8a 00                	mov    (%eax),%al
  802028:	84 c0                	test   %al,%al
  80202a:	74 0e                	je     80203a <strncmp+0x2b>
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	8a 10                	mov    (%eax),%dl
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	8a 00                	mov    (%eax),%al
  802036:	38 c2                	cmp    %al,%dl
  802038:	74 da                	je     802014 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80203a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80203e:	75 07                	jne    802047 <strncmp+0x38>
		return 0;
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	eb 14                	jmp    80205b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	8a 00                	mov    (%eax),%al
  80204c:	0f b6 d0             	movzbl %al,%edx
  80204f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802052:	8a 00                	mov    (%eax),%al
  802054:	0f b6 c0             	movzbl %al,%eax
  802057:	29 c2                	sub    %eax,%edx
  802059:	89 d0                	mov    %edx,%eax
}
  80205b:	5d                   	pop    %ebp
  80205c:	c3                   	ret    

0080205d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	8b 45 0c             	mov    0xc(%ebp),%eax
  802066:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802069:	eb 12                	jmp    80207d <strchr+0x20>
		if (*s == c)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8a 00                	mov    (%eax),%al
  802070:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802073:	75 05                	jne    80207a <strchr+0x1d>
			return (char *) s;
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	eb 11                	jmp    80208b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80207a:	ff 45 08             	incl   0x8(%ebp)
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8a 00                	mov    (%eax),%al
  802082:	84 c0                	test   %al,%al
  802084:	75 e5                	jne    80206b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	8b 45 0c             	mov    0xc(%ebp),%eax
  802096:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802099:	eb 0d                	jmp    8020a8 <strfind+0x1b>
		if (*s == c)
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	8a 00                	mov    (%eax),%al
  8020a0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020a3:	74 0e                	je     8020b3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020a5:	ff 45 08             	incl   0x8(%ebp)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	8a 00                	mov    (%eax),%al
  8020ad:	84 c0                	test   %al,%al
  8020af:	75 ea                	jne    80209b <strfind+0xe>
  8020b1:	eb 01                	jmp    8020b4 <strfind+0x27>
		if (*s == c)
			break;
  8020b3:	90                   	nop
	return (char *) s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8020c5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8020c9:	76 63                	jbe    80212e <memset+0x75>
		uint64 data_block = c;
  8020cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ce:	99                   	cltd   
  8020cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8020d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8020df:	c1 e0 08             	shl    $0x8,%eax
  8020e2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020e5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ee:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8020f2:	c1 e0 10             	shl    $0x10,%eax
  8020f5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8020f8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802101:	89 c2                	mov    %eax,%edx
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	09 45 f0             	or     %eax,-0x10(%ebp)
  80210b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80210e:	eb 18                	jmp    802128 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802110:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802113:	8d 41 08             	lea    0x8(%ecx),%eax
  802116:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211f:	89 01                	mov    %eax,(%ecx)
  802121:	89 51 04             	mov    %edx,0x4(%ecx)
  802124:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802128:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80212c:	77 e2                	ja     802110 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80212e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802132:	74 23                	je     802157 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802137:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80213a:	eb 0e                	jmp    80214a <memset+0x91>
			*p8++ = (uint8)c;
  80213c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80213f:	8d 50 01             	lea    0x1(%eax),%edx
  802142:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802145:	8b 55 0c             	mov    0xc(%ebp),%edx
  802148:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80214a:	8b 45 10             	mov    0x10(%ebp),%eax
  80214d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802150:	89 55 10             	mov    %edx,0x10(%ebp)
  802153:	85 c0                	test   %eax,%eax
  802155:	75 e5                	jne    80213c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802162:	8b 45 0c             	mov    0xc(%ebp),%eax
  802165:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80216e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802172:	76 24                	jbe    802198 <memcpy+0x3c>
		while(n >= 8){
  802174:	eb 1c                	jmp    802192 <memcpy+0x36>
			*d64 = *s64;
  802176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802179:	8b 50 04             	mov    0x4(%eax),%edx
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802181:	89 01                	mov    %eax,(%ecx)
  802183:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802186:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80218a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80218e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802192:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802196:	77 de                	ja     802176 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802198:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219c:	74 31                	je     8021cf <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80219e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8021a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8021aa:	eb 16                	jmp    8021c2 <memcpy+0x66>
			*d8++ = *s8++;
  8021ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021af:	8d 50 01             	lea    0x1(%eax),%edx
  8021b2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8021b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021bb:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8021be:	8a 12                	mov    (%edx),%dl
  8021c0:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8021c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	75 dd                	jne    8021ac <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8021da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8021e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021ec:	73 50                	jae    80223e <memmove+0x6a>
  8021ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	01 d0                	add    %edx,%eax
  8021f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021f9:	76 43                	jbe    80223e <memmove+0x6a>
		s += n;
  8021fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8021fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802201:	8b 45 10             	mov    0x10(%ebp),%eax
  802204:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802207:	eb 10                	jmp    802219 <memmove+0x45>
			*--d = *--s;
  802209:	ff 4d f8             	decl   -0x8(%ebp)
  80220c:	ff 4d fc             	decl   -0x4(%ebp)
  80220f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802212:	8a 10                	mov    (%eax),%dl
  802214:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802217:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802219:	8b 45 10             	mov    0x10(%ebp),%eax
  80221c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80221f:	89 55 10             	mov    %edx,0x10(%ebp)
  802222:	85 c0                	test   %eax,%eax
  802224:	75 e3                	jne    802209 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802226:	eb 23                	jmp    80224b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802228:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80222b:	8d 50 01             	lea    0x1(%eax),%edx
  80222e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802231:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802234:	8d 4a 01             	lea    0x1(%edx),%ecx
  802237:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80223a:	8a 12                	mov    (%edx),%dl
  80223c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80223e:	8b 45 10             	mov    0x10(%ebp),%eax
  802241:	8d 50 ff             	lea    -0x1(%eax),%edx
  802244:	89 55 10             	mov    %edx,0x10(%ebp)
  802247:	85 c0                	test   %eax,%eax
  802249:	75 dd                	jne    802228 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80225c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802262:	eb 2a                	jmp    80228e <memcmp+0x3e>
		if (*s1 != *s2)
  802264:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802267:	8a 10                	mov    (%eax),%dl
  802269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80226c:	8a 00                	mov    (%eax),%al
  80226e:	38 c2                	cmp    %al,%dl
  802270:	74 16                	je     802288 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802272:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802275:	8a 00                	mov    (%eax),%al
  802277:	0f b6 d0             	movzbl %al,%edx
  80227a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80227d:	8a 00                	mov    (%eax),%al
  80227f:	0f b6 c0             	movzbl %al,%eax
  802282:	29 c2                	sub    %eax,%edx
  802284:	89 d0                	mov    %edx,%eax
  802286:	eb 18                	jmp    8022a0 <memcmp+0x50>
		s1++, s2++;
  802288:	ff 45 fc             	incl   -0x4(%ebp)
  80228b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80228e:	8b 45 10             	mov    0x10(%ebp),%eax
  802291:	8d 50 ff             	lea    -0x1(%eax),%edx
  802294:	89 55 10             	mov    %edx,0x10(%ebp)
  802297:	85 c0                	test   %eax,%eax
  802299:	75 c9                	jne    802264 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80229b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8022a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ae:	01 d0                	add    %edx,%eax
  8022b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8022b3:	eb 15                	jmp    8022ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8a 00                	mov    (%eax),%al
  8022ba:	0f b6 d0             	movzbl %al,%edx
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	0f b6 c0             	movzbl %al,%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	74 0d                	je     8022d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8022c7:	ff 45 08             	incl   0x8(%ebp)
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8022d0:	72 e3                	jb     8022b5 <memfind+0x13>
  8022d2:	eb 01                	jmp    8022d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8022d4:	90                   	nop
	return (void *) s;
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8022e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8022e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022ee:	eb 03                	jmp    8022f3 <strtol+0x19>
		s++;
  8022f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	8a 00                	mov    (%eax),%al
  8022f8:	3c 20                	cmp    $0x20,%al
  8022fa:	74 f4                	je     8022f0 <strtol+0x16>
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	8a 00                	mov    (%eax),%al
  802301:	3c 09                	cmp    $0x9,%al
  802303:	74 eb                	je     8022f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	8a 00                	mov    (%eax),%al
  80230a:	3c 2b                	cmp    $0x2b,%al
  80230c:	75 05                	jne    802313 <strtol+0x39>
		s++;
  80230e:	ff 45 08             	incl   0x8(%ebp)
  802311:	eb 13                	jmp    802326 <strtol+0x4c>
	else if (*s == '-')
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8a 00                	mov    (%eax),%al
  802318:	3c 2d                	cmp    $0x2d,%al
  80231a:	75 0a                	jne    802326 <strtol+0x4c>
		s++, neg = 1;
  80231c:	ff 45 08             	incl   0x8(%ebp)
  80231f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802326:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80232a:	74 06                	je     802332 <strtol+0x58>
  80232c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802330:	75 20                	jne    802352 <strtol+0x78>
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8a 00                	mov    (%eax),%al
  802337:	3c 30                	cmp    $0x30,%al
  802339:	75 17                	jne    802352 <strtol+0x78>
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	40                   	inc    %eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	3c 78                	cmp    $0x78,%al
  802343:	75 0d                	jne    802352 <strtol+0x78>
		s += 2, base = 16;
  802345:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802349:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802350:	eb 28                	jmp    80237a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802352:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802356:	75 15                	jne    80236d <strtol+0x93>
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	8a 00                	mov    (%eax),%al
  80235d:	3c 30                	cmp    $0x30,%al
  80235f:	75 0c                	jne    80236d <strtol+0x93>
		s++, base = 8;
  802361:	ff 45 08             	incl   0x8(%ebp)
  802364:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80236b:	eb 0d                	jmp    80237a <strtol+0xa0>
	else if (base == 0)
  80236d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802371:	75 07                	jne    80237a <strtol+0xa0>
		base = 10;
  802373:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	8a 00                	mov    (%eax),%al
  80237f:	3c 2f                	cmp    $0x2f,%al
  802381:	7e 19                	jle    80239c <strtol+0xc2>
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	8a 00                	mov    (%eax),%al
  802388:	3c 39                	cmp    $0x39,%al
  80238a:	7f 10                	jg     80239c <strtol+0xc2>
			dig = *s - '0';
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	8a 00                	mov    (%eax),%al
  802391:	0f be c0             	movsbl %al,%eax
  802394:	83 e8 30             	sub    $0x30,%eax
  802397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239a:	eb 42                	jmp    8023de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8a 00                	mov    (%eax),%al
  8023a1:	3c 60                	cmp    $0x60,%al
  8023a3:	7e 19                	jle    8023be <strtol+0xe4>
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	8a 00                	mov    (%eax),%al
  8023aa:	3c 7a                	cmp    $0x7a,%al
  8023ac:	7f 10                	jg     8023be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	8a 00                	mov    (%eax),%al
  8023b3:	0f be c0             	movsbl %al,%eax
  8023b6:	83 e8 57             	sub    $0x57,%eax
  8023b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bc:	eb 20                	jmp    8023de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	8a 00                	mov    (%eax),%al
  8023c3:	3c 40                	cmp    $0x40,%al
  8023c5:	7e 39                	jle    802400 <strtol+0x126>
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	8a 00                	mov    (%eax),%al
  8023cc:	3c 5a                	cmp    $0x5a,%al
  8023ce:	7f 30                	jg     802400 <strtol+0x126>
			dig = *s - 'A' + 10;
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8a 00                	mov    (%eax),%al
  8023d5:	0f be c0             	movsbl %al,%eax
  8023d8:	83 e8 37             	sub    $0x37,%eax
  8023db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8023e4:	7d 19                	jge    8023ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8023e6:	ff 45 08             	incl   0x8(%ebp)
  8023e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8023f0:	89 c2                	mov    %eax,%edx
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	01 d0                	add    %edx,%eax
  8023f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8023fa:	e9 7b ff ff ff       	jmp    80237a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8023ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802400:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802404:	74 08                	je     80240e <strtol+0x134>
		*endptr = (char *) s;
  802406:	8b 45 0c             	mov    0xc(%ebp),%eax
  802409:	8b 55 08             	mov    0x8(%ebp),%edx
  80240c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80240e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802412:	74 07                	je     80241b <strtol+0x141>
  802414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802417:	f7 d8                	neg    %eax
  802419:	eb 03                	jmp    80241e <strtol+0x144>
  80241b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <ltostr>:

void
ltostr(long value, char *str)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80242d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802434:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802438:	79 13                	jns    80244d <ltostr+0x2d>
	{
		neg = 1;
  80243a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802441:	8b 45 0c             	mov    0xc(%ebp),%eax
  802444:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802447:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80244a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802455:	99                   	cltd   
  802456:	f7 f9                	idiv   %ecx
  802458:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80245b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80245e:	8d 50 01             	lea    0x1(%eax),%edx
  802461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802464:	89 c2                	mov    %eax,%edx
  802466:	8b 45 0c             	mov    0xc(%ebp),%eax
  802469:	01 d0                	add    %edx,%eax
  80246b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80246e:	83 c2 30             	add    $0x30,%edx
  802471:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802473:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802476:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80247b:	f7 e9                	imul   %ecx
  80247d:	c1 fa 02             	sar    $0x2,%edx
  802480:	89 c8                	mov    %ecx,%eax
  802482:	c1 f8 1f             	sar    $0x1f,%eax
  802485:	29 c2                	sub    %eax,%edx
  802487:	89 d0                	mov    %edx,%eax
  802489:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80248c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802490:	75 bb                	jne    80244d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802499:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80249c:	48                   	dec    %eax
  80249d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8024a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024a4:	74 3d                	je     8024e3 <ltostr+0xc3>
		start = 1 ;
  8024a6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8024ad:	eb 34                	jmp    8024e3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8024af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b5:	01 d0                	add    %edx,%eax
  8024b7:	8a 00                	mov    (%eax),%al
  8024b9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8024bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c2:	01 c2                	add    %eax,%edx
  8024c4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8024c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ca:	01 c8                	add    %ecx,%eax
  8024cc:	8a 00                	mov    (%eax),%al
  8024ce:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8024d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d6:	01 c2                	add    %eax,%edx
  8024d8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8024db:	88 02                	mov    %al,(%edx)
		start++ ;
  8024dd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8024e0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e9:	7c c4                	jl     8024af <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8024eb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8024ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8024f6:	90                   	nop
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8024ff:	ff 75 08             	pushl  0x8(%ebp)
  802502:	e8 c4 f9 ff ff       	call   801ecb <strlen>
  802507:	83 c4 04             	add    $0x4,%esp
  80250a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80250d:	ff 75 0c             	pushl  0xc(%ebp)
  802510:	e8 b6 f9 ff ff       	call   801ecb <strlen>
  802515:	83 c4 04             	add    $0x4,%esp
  802518:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80251b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802522:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802529:	eb 17                	jmp    802542 <strcconcat+0x49>
		final[s] = str1[s] ;
  80252b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80252e:	8b 45 10             	mov    0x10(%ebp),%eax
  802531:	01 c2                	add    %eax,%edx
  802533:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	01 c8                	add    %ecx,%eax
  80253b:	8a 00                	mov    (%eax),%al
  80253d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80253f:	ff 45 fc             	incl   -0x4(%ebp)
  802542:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802545:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802548:	7c e1                	jl     80252b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80254a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802551:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802558:	eb 1f                	jmp    802579 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80255a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255d:	8d 50 01             	lea    0x1(%eax),%edx
  802560:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802563:	89 c2                	mov    %eax,%edx
  802565:	8b 45 10             	mov    0x10(%ebp),%eax
  802568:	01 c2                	add    %eax,%edx
  80256a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80256d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802570:	01 c8                	add    %ecx,%eax
  802572:	8a 00                	mov    (%eax),%al
  802574:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802576:	ff 45 f8             	incl   -0x8(%ebp)
  802579:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80257c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80257f:	7c d9                	jl     80255a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802581:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802584:	8b 45 10             	mov    0x10(%ebp),%eax
  802587:	01 d0                	add    %edx,%eax
  802589:	c6 00 00             	movb   $0x0,(%eax)
}
  80258c:	90                   	nop
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802592:	8b 45 14             	mov    0x14(%ebp),%eax
  802595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80259b:	8b 45 14             	mov    0x14(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025aa:	01 d0                	add    %edx,%eax
  8025ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8025b2:	eb 0c                	jmp    8025c0 <strsplit+0x31>
			*string++ = 0;
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	8d 50 01             	lea    0x1(%eax),%edx
  8025ba:	89 55 08             	mov    %edx,0x8(%ebp)
  8025bd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	8a 00                	mov    (%eax),%al
  8025c5:	84 c0                	test   %al,%al
  8025c7:	74 18                	je     8025e1 <strsplit+0x52>
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	8a 00                	mov    (%eax),%al
  8025ce:	0f be c0             	movsbl %al,%eax
  8025d1:	50                   	push   %eax
  8025d2:	ff 75 0c             	pushl  0xc(%ebp)
  8025d5:	e8 83 fa ff ff       	call   80205d <strchr>
  8025da:	83 c4 08             	add    $0x8,%esp
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	75 d3                	jne    8025b4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	8a 00                	mov    (%eax),%al
  8025e6:	84 c0                	test   %al,%al
  8025e8:	74 5a                	je     802644 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8025ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	83 f8 0f             	cmp    $0xf,%eax
  8025f2:	75 07                	jne    8025fb <strsplit+0x6c>
		{
			return 0;
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f9:	eb 66                	jmp    802661 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8025fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	8d 48 01             	lea    0x1(%eax),%ecx
  802603:	8b 55 14             	mov    0x14(%ebp),%edx
  802606:	89 0a                	mov    %ecx,(%edx)
  802608:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80260f:	8b 45 10             	mov    0x10(%ebp),%eax
  802612:	01 c2                	add    %eax,%edx
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802619:	eb 03                	jmp    80261e <strsplit+0x8f>
			string++;
  80261b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	8a 00                	mov    (%eax),%al
  802623:	84 c0                	test   %al,%al
  802625:	74 8b                	je     8025b2 <strsplit+0x23>
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	8a 00                	mov    (%eax),%al
  80262c:	0f be c0             	movsbl %al,%eax
  80262f:	50                   	push   %eax
  802630:	ff 75 0c             	pushl  0xc(%ebp)
  802633:	e8 25 fa ff ff       	call   80205d <strchr>
  802638:	83 c4 08             	add    $0x8,%esp
  80263b:	85 c0                	test   %eax,%eax
  80263d:	74 dc                	je     80261b <strsplit+0x8c>
			string++;
	}
  80263f:	e9 6e ff ff ff       	jmp    8025b2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802644:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802645:	8b 45 14             	mov    0x14(%ebp),%eax
  802648:	8b 00                	mov    (%eax),%eax
  80264a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802651:	8b 45 10             	mov    0x10(%ebp),%eax
  802654:	01 d0                	add    %edx,%eax
  802656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80265c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80266f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802676:	eb 4a                	jmp    8026c2 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	01 c2                	add    %eax,%edx
  802680:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802683:	8b 45 0c             	mov    0xc(%ebp),%eax
  802686:	01 c8                	add    %ecx,%eax
  802688:	8a 00                	mov    (%eax),%al
  80268a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80268c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80268f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802692:	01 d0                	add    %edx,%eax
  802694:	8a 00                	mov    (%eax),%al
  802696:	3c 40                	cmp    $0x40,%al
  802698:	7e 25                	jle    8026bf <str2lower+0x5c>
  80269a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80269d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a0:	01 d0                	add    %edx,%eax
  8026a2:	8a 00                	mov    (%eax),%al
  8026a4:	3c 5a                	cmp    $0x5a,%al
  8026a6:	7f 17                	jg     8026bf <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8026a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	01 d0                	add    %edx,%eax
  8026b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b6:	01 ca                	add    %ecx,%edx
  8026b8:	8a 12                	mov    (%edx),%dl
  8026ba:	83 c2 20             	add    $0x20,%edx
  8026bd:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8026bf:	ff 45 fc             	incl   -0x4(%ebp)
  8026c2:	ff 75 0c             	pushl  0xc(%ebp)
  8026c5:	e8 01 f8 ff ff       	call   801ecb <strlen>
  8026ca:	83 c4 04             	add    $0x4,%esp
  8026cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8026d0:	7f a6                	jg     802678 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8026d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	6a 10                	push   $0x10
  8026e2:	e8 b2 15 00 00       	call   803c99 <alloc_block>
  8026e7:	83 c4 10             	add    $0x10,%esp
  8026ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8026ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026f1:	75 14                	jne    802707 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	68 48 55 80 00       	push   $0x805548
  8026fb:	6a 14                	push   $0x14
  8026fd:	68 71 55 80 00       	push   $0x805571
  802702:	e8 fd ed ff ff       	call   801504 <_panic>

	node->start = start;
  802707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270a:	8b 55 08             	mov    0x8(%ebp),%edx
  80270d:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80270f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802712:	8b 55 0c             	mov    0xc(%ebp),%edx
  802715:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802718:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80271f:	a1 04 62 80 00       	mov    0x806204,%eax
  802724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802727:	eb 18                	jmp    802741 <insert_page_alloc+0x6a>
		if (start < it->start)
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802731:	77 37                	ja     80276a <insert_page_alloc+0x93>
			break;
		prev = it;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  802739:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80273e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802745:	74 08                	je     80274f <insert_page_alloc+0x78>
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 08             	mov    0x8(%eax),%eax
  80274d:	eb 05                	jmp    802754 <insert_page_alloc+0x7d>
  80274f:	b8 00 00 00 00       	mov    $0x0,%eax
  802754:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802759:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	75 c7                	jne    802729 <insert_page_alloc+0x52>
  802762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802766:	75 c1                	jne    802729 <insert_page_alloc+0x52>
  802768:	eb 01                	jmp    80276b <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  80276a:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  80276b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80276f:	75 64                	jne    8027d5 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  802771:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802775:	75 14                	jne    80278b <insert_page_alloc+0xb4>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 80 55 80 00       	push   $0x805580
  80277f:	6a 21                	push   $0x21
  802781:	68 71 55 80 00       	push   $0x805571
  802786:	e8 79 ed ff ff       	call   801504 <_panic>
  80278b:	8b 15 04 62 80 00    	mov    0x806204,%edx
  802791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802794:	89 50 08             	mov    %edx,0x8(%eax)
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	8b 40 08             	mov    0x8(%eax),%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	74 0d                	je     8027ae <insert_page_alloc+0xd7>
  8027a1:	a1 04 62 80 00       	mov    0x806204,%eax
  8027a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a9:	89 50 0c             	mov    %edx,0xc(%eax)
  8027ac:	eb 08                	jmp    8027b6 <insert_page_alloc+0xdf>
  8027ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b1:	a3 08 62 80 00       	mov    %eax,0x806208
  8027b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b9:	a3 04 62 80 00       	mov    %eax,0x806204
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027c8:	a1 10 62 80 00       	mov    0x806210,%eax
  8027cd:	40                   	inc    %eax
  8027ce:	a3 10 62 80 00       	mov    %eax,0x806210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8027d3:	eb 71                	jmp    802846 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8027d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d9:	74 06                	je     8027e1 <insert_page_alloc+0x10a>
  8027db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027df:	75 14                	jne    8027f5 <insert_page_alloc+0x11e>
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 a4 55 80 00       	push   $0x8055a4
  8027e9:	6a 23                	push   $0x23
  8027eb:	68 71 55 80 00       	push   $0x805571
  8027f0:	e8 0f ed ff ff       	call   801504 <_panic>
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	8b 50 08             	mov    0x8(%eax),%edx
  8027fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fe:	89 50 08             	mov    %edx,0x8(%eax)
  802801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802804:	8b 40 08             	mov    0x8(%eax),%eax
  802807:	85 c0                	test   %eax,%eax
  802809:	74 0c                	je     802817 <insert_page_alloc+0x140>
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 40 08             	mov    0x8(%eax),%eax
  802811:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802814:	89 50 0c             	mov    %edx,0xc(%eax)
  802817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80281d:	89 50 08             	mov    %edx,0x8(%eax)
  802820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802823:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802826:	89 50 0c             	mov    %edx,0xc(%eax)
  802829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282c:	8b 40 08             	mov    0x8(%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	75 08                	jne    80283b <insert_page_alloc+0x164>
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	a3 08 62 80 00       	mov    %eax,0x806208
  80283b:	a1 10 62 80 00       	mov    0x806210,%eax
  802840:	40                   	inc    %eax
  802841:	a3 10 62 80 00       	mov    %eax,0x806210
}
  802846:	90                   	nop
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  80284f:	a1 04 62 80 00       	mov    0x806204,%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	75 0c                	jne    802864 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  802858:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80285d:	a3 50 e2 81 00       	mov    %eax,0x81e250
		return;
  802862:	eb 67                	jmp    8028cb <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  802864:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802869:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80286c:	a1 04 62 80 00       	mov    0x806204,%eax
  802871:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802874:	eb 26                	jmp    80289c <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  802876:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802879:	8b 10                	mov    (%eax),%edx
  80287b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80287e:	8b 40 04             	mov    0x4(%eax),%eax
  802881:	01 d0                	add    %edx,%eax
  802883:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80288c:	76 06                	jbe    802894 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802894:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802899:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80289c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8028a0:	74 08                	je     8028aa <recompute_page_alloc_break+0x61>
  8028a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028a5:	8b 40 08             	mov    0x8(%eax),%eax
  8028a8:	eb 05                	jmp    8028af <recompute_page_alloc_break+0x66>
  8028aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8028af:	a3 0c 62 80 00       	mov    %eax,0x80620c
  8028b4:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	75 b9                	jne    802876 <recompute_page_alloc_break+0x2d>
  8028bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8028c1:	75 b3                	jne    802876 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8028c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028c6:	a3 50 e2 81 00       	mov    %eax,0x81e250
}
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
  8028d0:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8028d3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8028da:	8b 55 08             	mov    0x8(%ebp),%edx
  8028dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028e0:	01 d0                	add    %edx,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ee:	f7 75 d8             	divl   -0x28(%ebp)
  8028f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028f4:	29 d0                	sub    %edx,%eax
  8028f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8028f9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8028fd:	75 0a                	jne    802909 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802904:	e9 7e 01 00 00       	jmp    802a87 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  802909:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  802910:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802914:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  80291b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  802922:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80292a:	a1 04 62 80 00       	mov    0x806204,%eax
  80292f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802932:	eb 69                	jmp    80299d <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802934:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80293c:	76 47                	jbe    802985 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80293e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802941:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  802944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80294c:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  80294f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802952:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802955:	72 2e                	jb     802985 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  802957:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80295b:	75 14                	jne    802971 <alloc_pages_custom_fit+0xa4>
  80295d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802960:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802963:	75 0c                	jne    802971 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  802965:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802968:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  80296b:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80296f:	eb 14                	jmp    802985 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802971:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802974:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802977:	76 0c                	jbe    802985 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802979:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80297f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802982:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802985:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802988:	8b 10                	mov    (%eax),%edx
  80298a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	01 d0                	add    %edx,%eax
  802992:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802995:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80299a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80299d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029a1:	74 08                	je     8029ab <alloc_pages_custom_fit+0xde>
  8029a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a6:	8b 40 08             	mov    0x8(%eax),%eax
  8029a9:	eb 05                	jmp    8029b0 <alloc_pages_custom_fit+0xe3>
  8029ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b0:	a3 0c 62 80 00       	mov    %eax,0x80620c
  8029b5:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	0f 85 72 ff ff ff    	jne    802934 <alloc_pages_custom_fit+0x67>
  8029c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029c6:	0f 85 68 ff ff ff    	jne    802934 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8029cc:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8029d1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029d4:	76 47                	jbe    802a1d <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8029d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8029dc:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8029e1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029e4:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8029e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029ea:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8029ed:	72 2e                	jb     802a1d <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8029ef:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8029f3:	75 14                	jne    802a09 <alloc_pages_custom_fit+0x13c>
  8029f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029f8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8029fb:	75 0c                	jne    802a09 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8029fd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802a03:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802a07:	eb 14                	jmp    802a1d <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802a09:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a0c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a0f:	76 0c                	jbe    802a1d <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802a11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a14:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802a17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802a1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802a24:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802a28:	74 08                	je     802a32 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a30:	eb 40                	jmp    802a72 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802a32:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a36:	74 08                	je     802a40 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a3e:	eb 32                	jmp    802a72 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802a40:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802a45:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802a48:	89 c2                	mov    %eax,%edx
  802a4a:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802a4f:	39 c2                	cmp    %eax,%edx
  802a51:	73 07                	jae    802a5a <alloc_pages_custom_fit+0x18d>
			return NULL;
  802a53:	b8 00 00 00 00       	mov    $0x0,%eax
  802a58:	eb 2d                	jmp    802a87 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802a5a:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802a5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802a62:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802a68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a6b:	01 d0                	add    %edx,%eax
  802a6d:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}


	insert_page_alloc((uint32)result, required_size);
  802a72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a75:	83 ec 08             	sub    $0x8,%esp
  802a78:	ff 75 d0             	pushl  -0x30(%ebp)
  802a7b:	50                   	push   %eax
  802a7c:	e8 56 fc ff ff       	call   8026d7 <insert_page_alloc>
  802a81:	83 c4 10             	add    $0x10,%esp

	return result;
  802a84:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802a95:	a1 04 62 80 00       	mov    0x806204,%eax
  802a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a9d:	eb 1a                	jmp    802ab9 <find_allocated_size+0x30>
		if (it->start == va)
  802a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802aa7:	75 08                	jne    802ab1 <find_allocated_size+0x28>
			return it->size;
  802aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	eb 34                	jmp    802ae5 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802ab1:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802ab6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ab9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802abd:	74 08                	je     802ac7 <find_allocated_size+0x3e>
  802abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ac2:	8b 40 08             	mov    0x8(%eax),%eax
  802ac5:	eb 05                	jmp    802acc <find_allocated_size+0x43>
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  802acc:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802ad1:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	75 c5                	jne    802a9f <find_allocated_size+0x16>
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ade:	75 bf                	jne    802a9f <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802ae0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    

00802ae7 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802af3:	a1 04 62 80 00       	mov    0x806204,%eax
  802af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afb:	e9 e1 01 00 00       	jmp    802ce1 <free_pages+0x1fa>
		if (it->start == va) {
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b08:	0f 85 cb 01 00 00    	jne    802cd9 <free_pages+0x1f2>

			uint32 start = it->start;
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 40 04             	mov    0x4(%eax),%eax
  802b1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b22:	f7 d0                	not    %eax
  802b24:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b27:	73 1d                	jae    802b46 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802b29:	83 ec 0c             	sub    $0xc,%esp
  802b2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b2f:	ff 75 e8             	pushl  -0x18(%ebp)
  802b32:	68 d8 55 80 00       	push   $0x8055d8
  802b37:	68 a5 00 00 00       	push   $0xa5
  802b3c:	68 71 55 80 00       	push   $0x805571
  802b41:	e8 be e9 ff ff       	call   801504 <_panic>
			}

			uint32 start_end = start + size;
  802b46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4c:	01 d0                	add    %edx,%eax
  802b4e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802b51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	79 19                	jns    802b71 <free_pages+0x8a>
  802b58:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802b5f:	77 10                	ja     802b71 <free_pages+0x8a>
  802b61:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802b68:	77 07                	ja     802b71 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	78 2c                	js     802b9d <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b74:	83 ec 0c             	sub    $0xc,%esp
  802b77:	68 00 00 00 a0       	push   $0xa0000000
  802b7c:	ff 75 e0             	pushl  -0x20(%ebp)
  802b7f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b82:	ff 75 e8             	pushl  -0x18(%ebp)
  802b85:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b88:	50                   	push   %eax
  802b89:	68 1c 56 80 00       	push   $0x80561c
  802b8e:	68 ad 00 00 00       	push   $0xad
  802b93:	68 71 55 80 00       	push   $0x805571
  802b98:	e8 67 e9 ff ff       	call   801504 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ba3:	e9 88 00 00 00       	jmp    802c30 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802ba8:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802baf:	76 17                	jbe    802bc8 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802bb1:	ff 75 f0             	pushl  -0x10(%ebp)
  802bb4:	68 80 56 80 00       	push   $0x805680
  802bb9:	68 b4 00 00 00       	push   $0xb4
  802bbe:	68 71 55 80 00       	push   $0x805571
  802bc3:	e8 3c e9 ff ff       	call   801504 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	05 00 10 00 00       	add    $0x1000,%eax
  802bd0:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	79 2e                	jns    802c08 <free_pages+0x121>
  802bda:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802be1:	77 25                	ja     802c08 <free_pages+0x121>
  802be3:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802bea:	77 1c                	ja     802c08 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802bec:	83 ec 08             	sub    $0x8,%esp
  802bef:	68 00 10 00 00       	push   $0x1000
  802bf4:	ff 75 f0             	pushl  -0x10(%ebp)
  802bf7:	e8 38 0d 00 00       	call   803934 <sys_free_user_mem>
  802bfc:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802bff:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802c06:	eb 28                	jmp    802c30 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	68 00 00 00 a0       	push   $0xa0000000
  802c10:	ff 75 dc             	pushl  -0x24(%ebp)
  802c13:	68 00 10 00 00       	push   $0x1000
  802c18:	ff 75 f0             	pushl  -0x10(%ebp)
  802c1b:	50                   	push   %eax
  802c1c:	68 c0 56 80 00       	push   $0x8056c0
  802c21:	68 bd 00 00 00       	push   $0xbd
  802c26:	68 71 55 80 00       	push   $0x805571
  802c2b:	e8 d4 e8 ff ff       	call   801504 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c36:	0f 82 6c ff ff ff    	jb     802ba8 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802c3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c40:	75 17                	jne    802c59 <free_pages+0x172>
  802c42:	83 ec 04             	sub    $0x4,%esp
  802c45:	68 22 57 80 00       	push   $0x805722
  802c4a:	68 c1 00 00 00       	push   $0xc1
  802c4f:	68 71 55 80 00       	push   $0x805571
  802c54:	e8 ab e8 ff ff       	call   801504 <_panic>
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 40 08             	mov    0x8(%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 11                	je     802c74 <free_pages+0x18d>
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 40 08             	mov    0x8(%eax),%eax
  802c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6c:	8b 52 0c             	mov    0xc(%edx),%edx
  802c6f:	89 50 0c             	mov    %edx,0xc(%eax)
  802c72:	eb 0b                	jmp    802c7f <free_pages+0x198>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7a:	a3 08 62 80 00       	mov    %eax,0x806208
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 40 0c             	mov    0xc(%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 11                	je     802c9a <free_pages+0x1b3>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c92:	8b 52 08             	mov    0x8(%edx),%edx
  802c95:	89 50 08             	mov    %edx,0x8(%eax)
  802c98:	eb 0b                	jmp    802ca5 <free_pages+0x1be>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ca0:	a3 04 62 80 00       	mov    %eax,0x806204
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cb9:	a1 10 62 80 00       	mov    0x806210,%eax
  802cbe:	48                   	dec    %eax
  802cbf:	a3 10 62 80 00       	mov    %eax,0x806210
			free_block(it);
  802cc4:	83 ec 0c             	sub    $0xc,%esp
  802cc7:	ff 75 f4             	pushl  -0xc(%ebp)
  802cca:	e8 24 15 00 00       	call   8041f3 <free_block>
  802ccf:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802cd2:	e8 72 fb ff ff       	call   802849 <recompute_page_alloc_break>

			return;
  802cd7:	eb 37                	jmp    802d10 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802cd9:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce5:	74 08                	je     802cef <free_pages+0x208>
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 40 08             	mov    0x8(%eax),%eax
  802ced:	eb 05                	jmp    802cf4 <free_pages+0x20d>
  802cef:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf4:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802cf9:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	0f 85 fa fd ff ff    	jne    802b00 <free_pages+0x19>
  802d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0a:	0f 85 f0 fd ff ff    	jne    802b00 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802d10:	c9                   	leave  
  802d11:	c3                   	ret    

00802d12 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d1a:	5d                   	pop    %ebp
  802d1b:	c3                   	ret    

00802d1c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802d1c:	55                   	push   %ebp
  802d1d:	89 e5                	mov    %esp,%ebp
  802d1f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802d22:	a1 08 60 80 00       	mov    0x806008,%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	74 60                	je     802d8b <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802d2b:	83 ec 08             	sub    $0x8,%esp
  802d2e:	68 00 00 00 82       	push   $0x82000000
  802d33:	68 00 00 00 80       	push   $0x80000000
  802d38:	e8 0d 0d 00 00       	call   803a4a <initialize_dynamic_allocator>
  802d3d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802d40:	e8 f3 0a 00 00       	call   803838 <sys_get_uheap_strategy>
  802d45:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802d4a:	a1 20 62 80 00       	mov    0x806220,%eax
  802d4f:	05 00 10 00 00       	add    $0x1000,%eax
  802d54:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802d59:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802d5e:	a3 50 e2 81 00       	mov    %eax,0x81e250

		LIST_INIT(&page_alloc_list);
  802d63:	c7 05 04 62 80 00 00 	movl   $0x0,0x806204
  802d6a:	00 00 00 
  802d6d:	c7 05 08 62 80 00 00 	movl   $0x0,0x806208
  802d74:	00 00 00 
  802d77:	c7 05 10 62 80 00 00 	movl   $0x0,0x806210
  802d7e:	00 00 00 

		__firstTimeFlag = 0;
  802d81:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802d88:	00 00 00 
	}
}
  802d8b:	90                   	nop
  802d8c:	c9                   	leave  
  802d8d:	c3                   	ret    

00802d8e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
  802d91:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802da2:	83 ec 08             	sub    $0x8,%esp
  802da5:	68 06 04 00 00       	push   $0x406
  802daa:	50                   	push   %eax
  802dab:	e8 d2 06 00 00       	call   803482 <__sys_allocate_page>
  802db0:	83 c4 10             	add    $0x10,%esp
  802db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802db6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dba:	79 17                	jns    802dd3 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 40 57 80 00       	push   $0x805740
  802dc4:	68 ea 00 00 00       	push   $0xea
  802dc9:	68 71 55 80 00       	push   $0x805571
  802dce:	e8 31 e7 ff ff       	call   801504 <_panic>
	return 0;
  802dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dd8:	c9                   	leave  
  802dd9:	c3                   	ret    

00802dda <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802dda:	55                   	push   %ebp
  802ddb:	89 e5                	mov    %esp,%ebp
  802ddd:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802dee:	83 ec 0c             	sub    $0xc,%esp
  802df1:	50                   	push   %eax
  802df2:	e8 d2 06 00 00       	call   8034c9 <__sys_unmap_frame>
  802df7:	83 c4 10             	add    $0x10,%esp
  802dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e01:	79 17                	jns    802e1a <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	68 7c 57 80 00       	push   $0x80577c
  802e0b:	68 f5 00 00 00       	push   $0xf5
  802e10:	68 71 55 80 00       	push   $0x805571
  802e15:	e8 ea e6 ff ff       	call   801504 <_panic>
}
  802e1a:	90                   	nop
  802e1b:	c9                   	leave  
  802e1c:	c3                   	ret    

00802e1d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802e1d:	55                   	push   %ebp
  802e1e:	89 e5                	mov    %esp,%ebp
  802e20:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802e23:	e8 f4 fe ff ff       	call   802d1c <uheap_init>
	if (size == 0) return NULL ;
  802e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2c:	75 0a                	jne    802e38 <malloc+0x1b>
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e33:	e9 67 01 00 00       	jmp    802f9f <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802e38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802e3f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802e46:	77 16                	ja     802e5e <malloc+0x41>
		result = alloc_block(size);
  802e48:	83 ec 0c             	sub    $0xc,%esp
  802e4b:	ff 75 08             	pushl  0x8(%ebp)
  802e4e:	e8 46 0e 00 00       	call   803c99 <alloc_block>
  802e53:	83 c4 10             	add    $0x10,%esp
  802e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e59:	e9 3e 01 00 00       	jmp    802f9c <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802e5e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802e65:	8b 55 08             	mov    0x8(%ebp),%edx
  802e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6b:	01 d0                	add    %edx,%eax
  802e6d:	48                   	dec    %eax
  802e6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e74:	ba 00 00 00 00       	mov    $0x0,%edx
  802e79:	f7 75 f0             	divl   -0x10(%ebp)
  802e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7f:	29 d0                	sub    %edx,%eax
  802e81:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802e84:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	75 0a                	jne    802e97 <malloc+0x7a>
			return NULL;
  802e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e92:	e9 08 01 00 00       	jmp    802f9f <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802e97:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 0f                	je     802eaf <malloc+0x92>
  802ea0:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802ea6:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802eab:	39 c2                	cmp    %eax,%edx
  802ead:	73 0a                	jae    802eb9 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802eaf:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802eb4:	a3 50 e2 81 00       	mov    %eax,0x81e250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802eb9:	a1 44 e2 81 00       	mov    0x81e244,%eax
  802ebe:	83 f8 05             	cmp    $0x5,%eax
  802ec1:	75 11                	jne    802ed4 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802ec3:	83 ec 0c             	sub    $0xc,%esp
  802ec6:	ff 75 e8             	pushl  -0x18(%ebp)
  802ec9:	e8 ff f9 ff ff       	call   8028cd <alloc_pages_custom_fit>
  802ece:	83 c4 10             	add    $0x10,%esp
  802ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed8:	0f 84 be 00 00 00    	je     802f9c <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802ee4:	83 ec 0c             	sub    $0xc,%esp
  802ee7:	ff 75 f4             	pushl  -0xc(%ebp)
  802eea:	e8 9a fb ff ff       	call   802a89 <find_allocated_size>
  802eef:	83 c4 10             	add    $0x10,%esp
  802ef2:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802ef5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ef9:	75 17                	jne    802f12 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802efb:	ff 75 f4             	pushl  -0xc(%ebp)
  802efe:	68 bc 57 80 00       	push   $0x8057bc
  802f03:	68 24 01 00 00       	push   $0x124
  802f08:	68 71 55 80 00       	push   $0x805571
  802f0d:	e8 f2 e5 ff ff       	call   801504 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802f12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f15:	f7 d0                	not    %eax
  802f17:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f1a:	73 1d                	jae    802f39 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802f1c:	83 ec 0c             	sub    $0xc,%esp
  802f1f:	ff 75 e0             	pushl  -0x20(%ebp)
  802f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f25:	68 04 58 80 00       	push   $0x805804
  802f2a:	68 29 01 00 00       	push   $0x129
  802f2f:	68 71 55 80 00       	push   $0x805571
  802f34:	e8 cb e5 ff ff       	call   801504 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802f39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3f:	01 d0                	add    %edx,%eax
  802f41:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	79 2c                	jns    802f77 <malloc+0x15a>
  802f4b:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802f52:	77 23                	ja     802f77 <malloc+0x15a>
  802f54:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802f5b:	77 1a                	ja     802f77 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802f5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	79 13                	jns    802f77 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802f64:	83 ec 08             	sub    $0x8,%esp
  802f67:	ff 75 e0             	pushl  -0x20(%ebp)
  802f6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f6d:	e8 de 09 00 00       	call   803950 <sys_allocate_user_mem>
  802f72:	83 c4 10             	add    $0x10,%esp
  802f75:	eb 25                	jmp    802f9c <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802f77:	68 00 00 00 a0       	push   $0xa0000000
  802f7c:	ff 75 dc             	pushl  -0x24(%ebp)
  802f7f:	ff 75 e0             	pushl  -0x20(%ebp)
  802f82:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f85:	ff 75 f4             	pushl  -0xc(%ebp)
  802f88:	68 40 58 80 00       	push   $0x805840
  802f8d:	68 33 01 00 00       	push   $0x133
  802f92:	68 71 55 80 00       	push   $0x805571
  802f97:	e8 68 e5 ff ff       	call   801504 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802f9f:	c9                   	leave  
  802fa0:	c3                   	ret    

00802fa1 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802fa1:	55                   	push   %ebp
  802fa2:	89 e5                	mov    %esp,%ebp
  802fa4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802fa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fab:	0f 84 26 01 00 00    	je     8030d7 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	79 1c                	jns    802fda <free+0x39>
  802fbe:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802fc5:	77 13                	ja     802fda <free+0x39>
		free_block(virtual_address);
  802fc7:	83 ec 0c             	sub    $0xc,%esp
  802fca:	ff 75 08             	pushl  0x8(%ebp)
  802fcd:	e8 21 12 00 00       	call   8041f3 <free_block>
  802fd2:	83 c4 10             	add    $0x10,%esp
		return;
  802fd5:	e9 01 01 00 00       	jmp    8030db <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802fda:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802fdf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802fe2:	0f 82 d8 00 00 00    	jb     8030c0 <free+0x11f>
  802fe8:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802fef:	0f 87 cb 00 00 00    	ja     8030c0 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	25 ff 0f 00 00       	and    $0xfff,%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 17                	je     803018 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  803001:	ff 75 08             	pushl  0x8(%ebp)
  803004:	68 b0 58 80 00       	push   $0x8058b0
  803009:	68 57 01 00 00       	push   $0x157
  80300e:	68 71 55 80 00       	push   $0x805571
  803013:	e8 ec e4 ff ff       	call   801504 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  803018:	83 ec 0c             	sub    $0xc,%esp
  80301b:	ff 75 08             	pushl  0x8(%ebp)
  80301e:	e8 66 fa ff ff       	call   802a89 <find_allocated_size>
  803023:	83 c4 10             	add    $0x10,%esp
  803026:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  803029:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302d:	0f 84 a7 00 00 00    	je     8030da <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	f7 d0                	not    %eax
  803038:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80303b:	73 1d                	jae    80305a <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  80303d:	83 ec 0c             	sub    $0xc,%esp
  803040:	ff 75 f0             	pushl  -0x10(%ebp)
  803043:	ff 75 f4             	pushl  -0xc(%ebp)
  803046:	68 d8 58 80 00       	push   $0x8058d8
  80304b:	68 61 01 00 00       	push   $0x161
  803050:	68 71 55 80 00       	push   $0x805571
  803055:	e8 aa e4 ff ff       	call   801504 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80305a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	01 d0                	add    %edx,%eax
  803062:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	79 19                	jns    803085 <free+0xe4>
  80306c:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  803073:	77 10                	ja     803085 <free+0xe4>
  803075:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80307c:	77 07                	ja     803085 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803081:	85 c0                	test   %eax,%eax
  803083:	78 2b                	js     8030b0 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  803085:	83 ec 0c             	sub    $0xc,%esp
  803088:	68 00 00 00 a0       	push   $0xa0000000
  80308d:	ff 75 ec             	pushl  -0x14(%ebp)
  803090:	ff 75 f0             	pushl  -0x10(%ebp)
  803093:	ff 75 f4             	pushl  -0xc(%ebp)
  803096:	ff 75 f0             	pushl  -0x10(%ebp)
  803099:	ff 75 08             	pushl  0x8(%ebp)
  80309c:	68 14 59 80 00       	push   $0x805914
  8030a1:	68 69 01 00 00       	push   $0x169
  8030a6:	68 71 55 80 00       	push   $0x805571
  8030ab:	e8 54 e4 ff ff       	call   801504 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8030b0:	83 ec 0c             	sub    $0xc,%esp
  8030b3:	ff 75 08             	pushl  0x8(%ebp)
  8030b6:	e8 2c fa ff ff       	call   802ae7 <free_pages>
  8030bb:	83 c4 10             	add    $0x10,%esp
		return;
  8030be:	eb 1b                	jmp    8030db <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8030c0:	ff 75 08             	pushl  0x8(%ebp)
  8030c3:	68 70 59 80 00       	push   $0x805970
  8030c8:	68 70 01 00 00       	push   $0x170
  8030cd:	68 71 55 80 00       	push   $0x805571
  8030d2:	e8 2d e4 ff ff       	call   801504 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8030d7:	90                   	nop
  8030d8:	eb 01                	jmp    8030db <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8030da:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8030db:	c9                   	leave  
  8030dc:	c3                   	ret    

008030dd <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8030dd:	55                   	push   %ebp
  8030de:	89 e5                	mov    %esp,%ebp
  8030e0:	83 ec 38             	sub    $0x38,%esp
  8030e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8030e6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8030e9:	e8 2e fc ff ff       	call   802d1c <uheap_init>
	if (size == 0) return NULL ;
  8030ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030f2:	75 0a                	jne    8030fe <smalloc+0x21>
  8030f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f9:	e9 3d 01 00 00       	jmp    80323b <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8030fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803101:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  803104:	8b 45 0c             	mov    0xc(%ebp),%eax
  803107:	25 ff 0f 00 00       	and    $0xfff,%eax
  80310c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80310f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803113:	74 0e                	je     803123 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  803115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803118:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80311b:	05 00 10 00 00       	add    $0x1000,%eax
  803120:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	c1 e8 0c             	shr    $0xc,%eax
  803129:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  80312c:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	75 0a                	jne    80313f <smalloc+0x62>
		return NULL;
  803135:	b8 00 00 00 00       	mov    $0x0,%eax
  80313a:	e9 fc 00 00 00       	jmp    80323b <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80313f:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803144:	85 c0                	test   %eax,%eax
  803146:	74 0f                	je     803157 <smalloc+0x7a>
  803148:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80314e:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803153:	39 c2                	cmp    %eax,%edx
  803155:	73 0a                	jae    803161 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  803157:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80315c:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803161:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803166:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80316b:	29 c2                	sub    %eax,%edx
  80316d:	89 d0                	mov    %edx,%eax
  80316f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803172:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  803178:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80317d:	29 c2                	sub    %eax,%edx
  80317f:	89 d0                	mov    %edx,%eax
  803181:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80318a:	77 13                	ja     80319f <smalloc+0xc2>
  80318c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803192:	77 0b                	ja     80319f <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  803194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803197:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80319a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80319d:	73 0a                	jae    8031a9 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80319f:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a4:	e9 92 00 00 00       	jmp    80323b <smalloc+0x15e>
	}

	void *va = NULL;
  8031a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8031b0:	a1 44 e2 81 00       	mov    0x81e244,%eax
  8031b5:	83 f8 05             	cmp    $0x5,%eax
  8031b8:	75 11                	jne    8031cb <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8031ba:	83 ec 0c             	sub    $0xc,%esp
  8031bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8031c0:	e8 08 f7 ff ff       	call   8028cd <alloc_pages_custom_fit>
  8031c5:	83 c4 10             	add    $0x10,%esp
  8031c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8031cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031cf:	75 27                	jne    8031f8 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8031d1:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8031d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031db:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8031de:	89 c2                	mov    %eax,%edx
  8031e0:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8031e5:	39 c2                	cmp    %eax,%edx
  8031e7:	73 07                	jae    8031f0 <smalloc+0x113>
			return NULL;}
  8031e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ee:	eb 4b                	jmp    80323b <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8031f0:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8031f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8031f8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8031fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ff:	50                   	push   %eax
  803200:	ff 75 0c             	pushl  0xc(%ebp)
  803203:	ff 75 08             	pushl  0x8(%ebp)
  803206:	e8 cb 03 00 00       	call   8035d6 <sys_create_shared_object>
  80320b:	83 c4 10             	add    $0x10,%esp
  80320e:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  803211:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803215:	79 07                	jns    80321e <smalloc+0x141>
		return NULL;
  803217:	b8 00 00 00 00       	mov    $0x0,%eax
  80321c:	eb 1d                	jmp    80323b <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80321e:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803223:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803226:	75 10                	jne    803238 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  803228:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	01 d0                	add    %edx,%eax
  803233:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}

	return va;
  803238:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  80323b:	c9                   	leave  
  80323c:	c3                   	ret    

0080323d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80323d:	55                   	push   %ebp
  80323e:	89 e5                	mov    %esp,%ebp
  803240:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803243:	e8 d4 fa ff ff       	call   802d1c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  803248:	83 ec 08             	sub    $0x8,%esp
  80324b:	ff 75 0c             	pushl  0xc(%ebp)
  80324e:	ff 75 08             	pushl  0x8(%ebp)
  803251:	e8 aa 03 00 00       	call   803600 <sys_size_of_shared_object>
  803256:	83 c4 10             	add    $0x10,%esp
  803259:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80325c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803260:	7f 0a                	jg     80326c <sget+0x2f>
		return NULL;
  803262:	b8 00 00 00 00       	mov    $0x0,%eax
  803267:	e9 32 01 00 00       	jmp    80339e <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80326c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	25 ff 0f 00 00       	and    $0xfff,%eax
  80327a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80327d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803281:	74 0e                	je     803291 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803289:	05 00 10 00 00       	add    $0x1000,%eax
  80328e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  803291:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	75 0a                	jne    8032a4 <sget+0x67>
		return NULL;
  80329a:	b8 00 00 00 00       	mov    $0x0,%eax
  80329f:	e9 fa 00 00 00       	jmp    80339e <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8032a4:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 0f                	je     8032bc <sget+0x7f>
  8032ad:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8032b3:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8032b8:	39 c2                	cmp    %eax,%edx
  8032ba:	73 0a                	jae    8032c6 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8032bc:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8032c1:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8032c6:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8032cb:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8032d0:	29 c2                	sub    %eax,%edx
  8032d2:	89 d0                	mov    %edx,%eax
  8032d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8032d7:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8032dd:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8032e2:	29 c2                	sub    %eax,%edx
  8032e4:	89 d0                	mov    %edx,%eax
  8032e6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032ef:	77 13                	ja     803304 <sget+0xc7>
  8032f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032f7:	77 0b                	ja     803304 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8032f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fc:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8032ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803302:	73 0a                	jae    80330e <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  803304:	b8 00 00 00 00       	mov    $0x0,%eax
  803309:	e9 90 00 00 00       	jmp    80339e <sget+0x161>

	void *va = NULL;
  80330e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  803315:	a1 44 e2 81 00       	mov    0x81e244,%eax
  80331a:	83 f8 05             	cmp    $0x5,%eax
  80331d:	75 11                	jne    803330 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80331f:	83 ec 0c             	sub    $0xc,%esp
  803322:	ff 75 f4             	pushl  -0xc(%ebp)
  803325:	e8 a3 f5 ff ff       	call   8028cd <alloc_pages_custom_fit>
  80332a:	83 c4 10             	add    $0x10,%esp
  80332d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  803330:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803334:	75 27                	jne    80335d <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803336:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80333d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803340:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803343:	89 c2                	mov    %eax,%edx
  803345:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80334a:	39 c2                	cmp    %eax,%edx
  80334c:	73 07                	jae    803355 <sget+0x118>
			return NULL;
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
  803353:	eb 49                	jmp    80339e <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  803355:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80335a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80335d:	83 ec 04             	sub    $0x4,%esp
  803360:	ff 75 f0             	pushl  -0x10(%ebp)
  803363:	ff 75 0c             	pushl  0xc(%ebp)
  803366:	ff 75 08             	pushl  0x8(%ebp)
  803369:	e8 af 02 00 00       	call   80361d <sys_get_shared_object>
  80336e:	83 c4 10             	add    $0x10,%esp
  803371:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  803374:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803378:	79 07                	jns    803381 <sget+0x144>
		return NULL;
  80337a:	b8 00 00 00 00       	mov    $0x0,%eax
  80337f:	eb 1d                	jmp    80339e <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  803381:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803386:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803389:	75 10                	jne    80339b <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80338b:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	01 d0                	add    %edx,%eax
  803396:	a3 50 e2 81 00       	mov    %eax,0x81e250

	return va;
  80339b:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80339e:	c9                   	leave  
  80339f:	c3                   	ret    

008033a0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8033a0:	55                   	push   %ebp
  8033a1:	89 e5                	mov    %esp,%ebp
  8033a3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8033a6:	e8 71 f9 ff ff       	call   802d1c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8033ab:	83 ec 04             	sub    $0x4,%esp
  8033ae:	68 94 59 80 00       	push   $0x805994
  8033b3:	68 19 02 00 00       	push   $0x219
  8033b8:	68 71 55 80 00       	push   $0x805571
  8033bd:	e8 42 e1 ff ff       	call   801504 <_panic>

008033c2 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8033c2:	55                   	push   %ebp
  8033c3:	89 e5                	mov    %esp,%ebp
  8033c5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8033c8:	83 ec 04             	sub    $0x4,%esp
  8033cb:	68 bc 59 80 00       	push   $0x8059bc
  8033d0:	68 2b 02 00 00       	push   $0x22b
  8033d5:	68 71 55 80 00       	push   $0x805571
  8033da:	e8 25 e1 ff ff       	call   801504 <_panic>

008033df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
  8033e2:	57                   	push   %edi
  8033e3:	56                   	push   %esi
  8033e4:	53                   	push   %ebx
  8033e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8033f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8033fa:	cd 30                	int    $0x30
  8033fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8033ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803402:	83 c4 10             	add    $0x10,%esp
  803405:	5b                   	pop    %ebx
  803406:	5e                   	pop    %esi
  803407:	5f                   	pop    %edi
  803408:	5d                   	pop    %ebp
  803409:	c3                   	ret    

0080340a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80340a:	55                   	push   %ebp
  80340b:	89 e5                	mov    %esp,%ebp
  80340d:	83 ec 04             	sub    $0x4,%esp
  803410:	8b 45 10             	mov    0x10(%ebp),%eax
  803413:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803416:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803419:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	6a 00                	push   $0x0
  803422:	51                   	push   %ecx
  803423:	52                   	push   %edx
  803424:	ff 75 0c             	pushl  0xc(%ebp)
  803427:	50                   	push   %eax
  803428:	6a 00                	push   $0x0
  80342a:	e8 b0 ff ff ff       	call   8033df <syscall>
  80342f:	83 c4 18             	add    $0x18,%esp
}
  803432:	90                   	nop
  803433:	c9                   	leave  
  803434:	c3                   	ret    

00803435 <sys_cgetc>:

int
sys_cgetc(void)
{
  803435:	55                   	push   %ebp
  803436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803438:	6a 00                	push   $0x0
  80343a:	6a 00                	push   $0x0
  80343c:	6a 00                	push   $0x0
  80343e:	6a 00                	push   $0x0
  803440:	6a 00                	push   $0x0
  803442:	6a 02                	push   $0x2
  803444:	e8 96 ff ff ff       	call   8033df <syscall>
  803449:	83 c4 18             	add    $0x18,%esp
}
  80344c:	c9                   	leave  
  80344d:	c3                   	ret    

0080344e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80344e:	55                   	push   %ebp
  80344f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803451:	6a 00                	push   $0x0
  803453:	6a 00                	push   $0x0
  803455:	6a 00                	push   $0x0
  803457:	6a 00                	push   $0x0
  803459:	6a 00                	push   $0x0
  80345b:	6a 03                	push   $0x3
  80345d:	e8 7d ff ff ff       	call   8033df <syscall>
  803462:	83 c4 18             	add    $0x18,%esp
}
  803465:	90                   	nop
  803466:	c9                   	leave  
  803467:	c3                   	ret    

00803468 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803468:	55                   	push   %ebp
  803469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80346b:	6a 00                	push   $0x0
  80346d:	6a 00                	push   $0x0
  80346f:	6a 00                	push   $0x0
  803471:	6a 00                	push   $0x0
  803473:	6a 00                	push   $0x0
  803475:	6a 04                	push   $0x4
  803477:	e8 63 ff ff ff       	call   8033df <syscall>
  80347c:	83 c4 18             	add    $0x18,%esp
}
  80347f:	90                   	nop
  803480:	c9                   	leave  
  803481:	c3                   	ret    

00803482 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803482:	55                   	push   %ebp
  803483:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803485:	8b 55 0c             	mov    0xc(%ebp),%edx
  803488:	8b 45 08             	mov    0x8(%ebp),%eax
  80348b:	6a 00                	push   $0x0
  80348d:	6a 00                	push   $0x0
  80348f:	6a 00                	push   $0x0
  803491:	52                   	push   %edx
  803492:	50                   	push   %eax
  803493:	6a 08                	push   $0x8
  803495:	e8 45 ff ff ff       	call   8033df <syscall>
  80349a:	83 c4 18             	add    $0x18,%esp
}
  80349d:	c9                   	leave  
  80349e:	c3                   	ret    

0080349f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80349f:	55                   	push   %ebp
  8034a0:	89 e5                	mov    %esp,%ebp
  8034a2:	56                   	push   %esi
  8034a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8034a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8034a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	56                   	push   %esi
  8034b4:	53                   	push   %ebx
  8034b5:	51                   	push   %ecx
  8034b6:	52                   	push   %edx
  8034b7:	50                   	push   %eax
  8034b8:	6a 09                	push   $0x9
  8034ba:	e8 20 ff ff ff       	call   8033df <syscall>
  8034bf:	83 c4 18             	add    $0x18,%esp
}
  8034c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034c5:	5b                   	pop    %ebx
  8034c6:	5e                   	pop    %esi
  8034c7:	5d                   	pop    %ebp
  8034c8:	c3                   	ret    

008034c9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8034c9:	55                   	push   %ebp
  8034ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8034cc:	6a 00                	push   $0x0
  8034ce:	6a 00                	push   $0x0
  8034d0:	6a 00                	push   $0x0
  8034d2:	6a 00                	push   $0x0
  8034d4:	ff 75 08             	pushl  0x8(%ebp)
  8034d7:	6a 0a                	push   $0xa
  8034d9:	e8 01 ff ff ff       	call   8033df <syscall>
  8034de:	83 c4 18             	add    $0x18,%esp
}
  8034e1:	c9                   	leave  
  8034e2:	c3                   	ret    

008034e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8034e3:	55                   	push   %ebp
  8034e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 00                	push   $0x0
  8034ea:	6a 00                	push   $0x0
  8034ec:	ff 75 0c             	pushl  0xc(%ebp)
  8034ef:	ff 75 08             	pushl  0x8(%ebp)
  8034f2:	6a 0b                	push   $0xb
  8034f4:	e8 e6 fe ff ff       	call   8033df <syscall>
  8034f9:	83 c4 18             	add    $0x18,%esp
}
  8034fc:	c9                   	leave  
  8034fd:	c3                   	ret    

008034fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8034fe:	55                   	push   %ebp
  8034ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803501:	6a 00                	push   $0x0
  803503:	6a 00                	push   $0x0
  803505:	6a 00                	push   $0x0
  803507:	6a 00                	push   $0x0
  803509:	6a 00                	push   $0x0
  80350b:	6a 0c                	push   $0xc
  80350d:	e8 cd fe ff ff       	call   8033df <syscall>
  803512:	83 c4 18             	add    $0x18,%esp
}
  803515:	c9                   	leave  
  803516:	c3                   	ret    

00803517 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803517:	55                   	push   %ebp
  803518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80351a:	6a 00                	push   $0x0
  80351c:	6a 00                	push   $0x0
  80351e:	6a 00                	push   $0x0
  803520:	6a 00                	push   $0x0
  803522:	6a 00                	push   $0x0
  803524:	6a 0d                	push   $0xd
  803526:	e8 b4 fe ff ff       	call   8033df <syscall>
  80352b:	83 c4 18             	add    $0x18,%esp
}
  80352e:	c9                   	leave  
  80352f:	c3                   	ret    

00803530 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803530:	55                   	push   %ebp
  803531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803533:	6a 00                	push   $0x0
  803535:	6a 00                	push   $0x0
  803537:	6a 00                	push   $0x0
  803539:	6a 00                	push   $0x0
  80353b:	6a 00                	push   $0x0
  80353d:	6a 0e                	push   $0xe
  80353f:	e8 9b fe ff ff       	call   8033df <syscall>
  803544:	83 c4 18             	add    $0x18,%esp
}
  803547:	c9                   	leave  
  803548:	c3                   	ret    

00803549 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803549:	55                   	push   %ebp
  80354a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80354c:	6a 00                	push   $0x0
  80354e:	6a 00                	push   $0x0
  803550:	6a 00                	push   $0x0
  803552:	6a 00                	push   $0x0
  803554:	6a 00                	push   $0x0
  803556:	6a 0f                	push   $0xf
  803558:	e8 82 fe ff ff       	call   8033df <syscall>
  80355d:	83 c4 18             	add    $0x18,%esp
}
  803560:	c9                   	leave  
  803561:	c3                   	ret    

00803562 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803562:	55                   	push   %ebp
  803563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803565:	6a 00                	push   $0x0
  803567:	6a 00                	push   $0x0
  803569:	6a 00                	push   $0x0
  80356b:	6a 00                	push   $0x0
  80356d:	ff 75 08             	pushl  0x8(%ebp)
  803570:	6a 10                	push   $0x10
  803572:	e8 68 fe ff ff       	call   8033df <syscall>
  803577:	83 c4 18             	add    $0x18,%esp
}
  80357a:	c9                   	leave  
  80357b:	c3                   	ret    

0080357c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80357c:	55                   	push   %ebp
  80357d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80357f:	6a 00                	push   $0x0
  803581:	6a 00                	push   $0x0
  803583:	6a 00                	push   $0x0
  803585:	6a 00                	push   $0x0
  803587:	6a 00                	push   $0x0
  803589:	6a 11                	push   $0x11
  80358b:	e8 4f fe ff ff       	call   8033df <syscall>
  803590:	83 c4 18             	add    $0x18,%esp
}
  803593:	90                   	nop
  803594:	c9                   	leave  
  803595:	c3                   	ret    

00803596 <sys_cputc>:

void
sys_cputc(const char c)
{
  803596:	55                   	push   %ebp
  803597:	89 e5                	mov    %esp,%ebp
  803599:	83 ec 04             	sub    $0x4,%esp
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8035a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8035a6:	6a 00                	push   $0x0
  8035a8:	6a 00                	push   $0x0
  8035aa:	6a 00                	push   $0x0
  8035ac:	6a 00                	push   $0x0
  8035ae:	50                   	push   %eax
  8035af:	6a 01                	push   $0x1
  8035b1:	e8 29 fe ff ff       	call   8033df <syscall>
  8035b6:	83 c4 18             	add    $0x18,%esp
}
  8035b9:	90                   	nop
  8035ba:	c9                   	leave  
  8035bb:	c3                   	ret    

008035bc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8035bc:	55                   	push   %ebp
  8035bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8035bf:	6a 00                	push   $0x0
  8035c1:	6a 00                	push   $0x0
  8035c3:	6a 00                	push   $0x0
  8035c5:	6a 00                	push   $0x0
  8035c7:	6a 00                	push   $0x0
  8035c9:	6a 14                	push   $0x14
  8035cb:	e8 0f fe ff ff       	call   8033df <syscall>
  8035d0:	83 c4 18             	add    $0x18,%esp
}
  8035d3:	90                   	nop
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	83 ec 04             	sub    $0x4,%esp
  8035dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8035df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8035e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8035e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8035e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ec:	6a 00                	push   $0x0
  8035ee:	51                   	push   %ecx
  8035ef:	52                   	push   %edx
  8035f0:	ff 75 0c             	pushl  0xc(%ebp)
  8035f3:	50                   	push   %eax
  8035f4:	6a 15                	push   $0x15
  8035f6:	e8 e4 fd ff ff       	call   8033df <syscall>
  8035fb:	83 c4 18             	add    $0x18,%esp
}
  8035fe:	c9                   	leave  
  8035ff:	c3                   	ret    

00803600 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803600:	55                   	push   %ebp
  803601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803603:	8b 55 0c             	mov    0xc(%ebp),%edx
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	6a 00                	push   $0x0
  80360b:	6a 00                	push   $0x0
  80360d:	6a 00                	push   $0x0
  80360f:	52                   	push   %edx
  803610:	50                   	push   %eax
  803611:	6a 16                	push   $0x16
  803613:	e8 c7 fd ff ff       	call   8033df <syscall>
  803618:	83 c4 18             	add    $0x18,%esp
}
  80361b:	c9                   	leave  
  80361c:	c3                   	ret    

0080361d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80361d:	55                   	push   %ebp
  80361e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803620:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803623:	8b 55 0c             	mov    0xc(%ebp),%edx
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	6a 00                	push   $0x0
  80362b:	6a 00                	push   $0x0
  80362d:	51                   	push   %ecx
  80362e:	52                   	push   %edx
  80362f:	50                   	push   %eax
  803630:	6a 17                	push   $0x17
  803632:	e8 a8 fd ff ff       	call   8033df <syscall>
  803637:	83 c4 18             	add    $0x18,%esp
}
  80363a:	c9                   	leave  
  80363b:	c3                   	ret    

0080363c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80363f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	6a 00                	push   $0x0
  803647:	6a 00                	push   $0x0
  803649:	6a 00                	push   $0x0
  80364b:	52                   	push   %edx
  80364c:	50                   	push   %eax
  80364d:	6a 18                	push   $0x18
  80364f:	e8 8b fd ff ff       	call   8033df <syscall>
  803654:	83 c4 18             	add    $0x18,%esp
}
  803657:	c9                   	leave  
  803658:	c3                   	ret    

00803659 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803659:	55                   	push   %ebp
  80365a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	6a 00                	push   $0x0
  803661:	ff 75 14             	pushl  0x14(%ebp)
  803664:	ff 75 10             	pushl  0x10(%ebp)
  803667:	ff 75 0c             	pushl  0xc(%ebp)
  80366a:	50                   	push   %eax
  80366b:	6a 19                	push   $0x19
  80366d:	e8 6d fd ff ff       	call   8033df <syscall>
  803672:	83 c4 18             	add    $0x18,%esp
}
  803675:	c9                   	leave  
  803676:	c3                   	ret    

00803677 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803677:	55                   	push   %ebp
  803678:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	6a 00                	push   $0x0
  80367f:	6a 00                	push   $0x0
  803681:	6a 00                	push   $0x0
  803683:	6a 00                	push   $0x0
  803685:	50                   	push   %eax
  803686:	6a 1a                	push   $0x1a
  803688:	e8 52 fd ff ff       	call   8033df <syscall>
  80368d:	83 c4 18             	add    $0x18,%esp
}
  803690:	90                   	nop
  803691:	c9                   	leave  
  803692:	c3                   	ret    

00803693 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803693:	55                   	push   %ebp
  803694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	6a 00                	push   $0x0
  80369b:	6a 00                	push   $0x0
  80369d:	6a 00                	push   $0x0
  80369f:	6a 00                	push   $0x0
  8036a1:	50                   	push   %eax
  8036a2:	6a 1b                	push   $0x1b
  8036a4:	e8 36 fd ff ff       	call   8033df <syscall>
  8036a9:	83 c4 18             	add    $0x18,%esp
}
  8036ac:	c9                   	leave  
  8036ad:	c3                   	ret    

008036ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8036ae:	55                   	push   %ebp
  8036af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8036b1:	6a 00                	push   $0x0
  8036b3:	6a 00                	push   $0x0
  8036b5:	6a 00                	push   $0x0
  8036b7:	6a 00                	push   $0x0
  8036b9:	6a 00                	push   $0x0
  8036bb:	6a 05                	push   $0x5
  8036bd:	e8 1d fd ff ff       	call   8033df <syscall>
  8036c2:	83 c4 18             	add    $0x18,%esp
}
  8036c5:	c9                   	leave  
  8036c6:	c3                   	ret    

008036c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8036c7:	55                   	push   %ebp
  8036c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8036ca:	6a 00                	push   $0x0
  8036cc:	6a 00                	push   $0x0
  8036ce:	6a 00                	push   $0x0
  8036d0:	6a 00                	push   $0x0
  8036d2:	6a 00                	push   $0x0
  8036d4:	6a 06                	push   $0x6
  8036d6:	e8 04 fd ff ff       	call   8033df <syscall>
  8036db:	83 c4 18             	add    $0x18,%esp
}
  8036de:	c9                   	leave  
  8036df:	c3                   	ret    

008036e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8036e0:	55                   	push   %ebp
  8036e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8036e3:	6a 00                	push   $0x0
  8036e5:	6a 00                	push   $0x0
  8036e7:	6a 00                	push   $0x0
  8036e9:	6a 00                	push   $0x0
  8036eb:	6a 00                	push   $0x0
  8036ed:	6a 07                	push   $0x7
  8036ef:	e8 eb fc ff ff       	call   8033df <syscall>
  8036f4:	83 c4 18             	add    $0x18,%esp
}
  8036f7:	c9                   	leave  
  8036f8:	c3                   	ret    

008036f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8036f9:	55                   	push   %ebp
  8036fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8036fc:	6a 00                	push   $0x0
  8036fe:	6a 00                	push   $0x0
  803700:	6a 00                	push   $0x0
  803702:	6a 00                	push   $0x0
  803704:	6a 00                	push   $0x0
  803706:	6a 1c                	push   $0x1c
  803708:	e8 d2 fc ff ff       	call   8033df <syscall>
  80370d:	83 c4 18             	add    $0x18,%esp
}
  803710:	90                   	nop
  803711:	c9                   	leave  
  803712:	c3                   	ret    

00803713 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803713:	55                   	push   %ebp
  803714:	89 e5                	mov    %esp,%ebp
  803716:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803719:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80371c:	8d 50 04             	lea    0x4(%eax),%edx
  80371f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803722:	6a 00                	push   $0x0
  803724:	6a 00                	push   $0x0
  803726:	6a 00                	push   $0x0
  803728:	52                   	push   %edx
  803729:	50                   	push   %eax
  80372a:	6a 1d                	push   $0x1d
  80372c:	e8 ae fc ff ff       	call   8033df <syscall>
  803731:	83 c4 18             	add    $0x18,%esp
	return result;
  803734:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803737:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80373a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80373d:	89 01                	mov    %eax,(%ecx)
  80373f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	c9                   	leave  
  803746:	c2 04 00             	ret    $0x4

00803749 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803749:	55                   	push   %ebp
  80374a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80374c:	6a 00                	push   $0x0
  80374e:	6a 00                	push   $0x0
  803750:	ff 75 10             	pushl  0x10(%ebp)
  803753:	ff 75 0c             	pushl  0xc(%ebp)
  803756:	ff 75 08             	pushl  0x8(%ebp)
  803759:	6a 13                	push   $0x13
  80375b:	e8 7f fc ff ff       	call   8033df <syscall>
  803760:	83 c4 18             	add    $0x18,%esp
	return ;
  803763:	90                   	nop
}
  803764:	c9                   	leave  
  803765:	c3                   	ret    

00803766 <sys_rcr2>:
uint32 sys_rcr2()
{
  803766:	55                   	push   %ebp
  803767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803769:	6a 00                	push   $0x0
  80376b:	6a 00                	push   $0x0
  80376d:	6a 00                	push   $0x0
  80376f:	6a 00                	push   $0x0
  803771:	6a 00                	push   $0x0
  803773:	6a 1e                	push   $0x1e
  803775:	e8 65 fc ff ff       	call   8033df <syscall>
  80377a:	83 c4 18             	add    $0x18,%esp
}
  80377d:	c9                   	leave  
  80377e:	c3                   	ret    

0080377f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80377f:	55                   	push   %ebp
  803780:	89 e5                	mov    %esp,%ebp
  803782:	83 ec 04             	sub    $0x4,%esp
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80378b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80378f:	6a 00                	push   $0x0
  803791:	6a 00                	push   $0x0
  803793:	6a 00                	push   $0x0
  803795:	6a 00                	push   $0x0
  803797:	50                   	push   %eax
  803798:	6a 1f                	push   $0x1f
  80379a:	e8 40 fc ff ff       	call   8033df <syscall>
  80379f:	83 c4 18             	add    $0x18,%esp
	return ;
  8037a2:	90                   	nop
}
  8037a3:	c9                   	leave  
  8037a4:	c3                   	ret    

008037a5 <rsttst>:
void rsttst()
{
  8037a5:	55                   	push   %ebp
  8037a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8037a8:	6a 00                	push   $0x0
  8037aa:	6a 00                	push   $0x0
  8037ac:	6a 00                	push   $0x0
  8037ae:	6a 00                	push   $0x0
  8037b0:	6a 00                	push   $0x0
  8037b2:	6a 21                	push   $0x21
  8037b4:	e8 26 fc ff ff       	call   8033df <syscall>
  8037b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8037bc:	90                   	nop
}
  8037bd:	c9                   	leave  
  8037be:	c3                   	ret    

008037bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8037bf:	55                   	push   %ebp
  8037c0:	89 e5                	mov    %esp,%ebp
  8037c2:	83 ec 04             	sub    $0x4,%esp
  8037c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8037c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8037cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8037ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8037d2:	52                   	push   %edx
  8037d3:	50                   	push   %eax
  8037d4:	ff 75 10             	pushl  0x10(%ebp)
  8037d7:	ff 75 0c             	pushl  0xc(%ebp)
  8037da:	ff 75 08             	pushl  0x8(%ebp)
  8037dd:	6a 20                	push   $0x20
  8037df:	e8 fb fb ff ff       	call   8033df <syscall>
  8037e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8037e7:	90                   	nop
}
  8037e8:	c9                   	leave  
  8037e9:	c3                   	ret    

008037ea <chktst>:
void chktst(uint32 n)
{
  8037ea:	55                   	push   %ebp
  8037eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8037ed:	6a 00                	push   $0x0
  8037ef:	6a 00                	push   $0x0
  8037f1:	6a 00                	push   $0x0
  8037f3:	6a 00                	push   $0x0
  8037f5:	ff 75 08             	pushl  0x8(%ebp)
  8037f8:	6a 22                	push   $0x22
  8037fa:	e8 e0 fb ff ff       	call   8033df <syscall>
  8037ff:	83 c4 18             	add    $0x18,%esp
	return ;
  803802:	90                   	nop
}
  803803:	c9                   	leave  
  803804:	c3                   	ret    

00803805 <inctst>:

void inctst()
{
  803805:	55                   	push   %ebp
  803806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803808:	6a 00                	push   $0x0
  80380a:	6a 00                	push   $0x0
  80380c:	6a 00                	push   $0x0
  80380e:	6a 00                	push   $0x0
  803810:	6a 00                	push   $0x0
  803812:	6a 23                	push   $0x23
  803814:	e8 c6 fb ff ff       	call   8033df <syscall>
  803819:	83 c4 18             	add    $0x18,%esp
	return ;
  80381c:	90                   	nop
}
  80381d:	c9                   	leave  
  80381e:	c3                   	ret    

0080381f <gettst>:
uint32 gettst()
{
  80381f:	55                   	push   %ebp
  803820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803822:	6a 00                	push   $0x0
  803824:	6a 00                	push   $0x0
  803826:	6a 00                	push   $0x0
  803828:	6a 00                	push   $0x0
  80382a:	6a 00                	push   $0x0
  80382c:	6a 24                	push   $0x24
  80382e:	e8 ac fb ff ff       	call   8033df <syscall>
  803833:	83 c4 18             	add    $0x18,%esp
}
  803836:	c9                   	leave  
  803837:	c3                   	ret    

00803838 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803838:	55                   	push   %ebp
  803839:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80383b:	6a 00                	push   $0x0
  80383d:	6a 00                	push   $0x0
  80383f:	6a 00                	push   $0x0
  803841:	6a 00                	push   $0x0
  803843:	6a 00                	push   $0x0
  803845:	6a 25                	push   $0x25
  803847:	e8 93 fb ff ff       	call   8033df <syscall>
  80384c:	83 c4 18             	add    $0x18,%esp
  80384f:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  803854:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  803859:	c9                   	leave  
  80385a:	c3                   	ret    

0080385b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80385b:	55                   	push   %ebp
  80385c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803866:	6a 00                	push   $0x0
  803868:	6a 00                	push   $0x0
  80386a:	6a 00                	push   $0x0
  80386c:	6a 00                	push   $0x0
  80386e:	ff 75 08             	pushl  0x8(%ebp)
  803871:	6a 26                	push   $0x26
  803873:	e8 67 fb ff ff       	call   8033df <syscall>
  803878:	83 c4 18             	add    $0x18,%esp
	return ;
  80387b:	90                   	nop
}
  80387c:	c9                   	leave  
  80387d:	c3                   	ret    

0080387e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80387e:	55                   	push   %ebp
  80387f:	89 e5                	mov    %esp,%ebp
  803881:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803882:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803885:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80388b:	8b 45 08             	mov    0x8(%ebp),%eax
  80388e:	6a 00                	push   $0x0
  803890:	53                   	push   %ebx
  803891:	51                   	push   %ecx
  803892:	52                   	push   %edx
  803893:	50                   	push   %eax
  803894:	6a 27                	push   $0x27
  803896:	e8 44 fb ff ff       	call   8033df <syscall>
  80389b:	83 c4 18             	add    $0x18,%esp
}
  80389e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038a1:	c9                   	leave  
  8038a2:	c3                   	ret    

008038a3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8038a3:	55                   	push   %ebp
  8038a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8038a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	6a 00                	push   $0x0
  8038ae:	6a 00                	push   $0x0
  8038b0:	6a 00                	push   $0x0
  8038b2:	52                   	push   %edx
  8038b3:	50                   	push   %eax
  8038b4:	6a 28                	push   $0x28
  8038b6:	e8 24 fb ff ff       	call   8033df <syscall>
  8038bb:	83 c4 18             	add    $0x18,%esp
}
  8038be:	c9                   	leave  
  8038bf:	c3                   	ret    

008038c0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8038c0:	55                   	push   %ebp
  8038c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8038c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8038c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	6a 00                	push   $0x0
  8038ce:	51                   	push   %ecx
  8038cf:	ff 75 10             	pushl  0x10(%ebp)
  8038d2:	52                   	push   %edx
  8038d3:	50                   	push   %eax
  8038d4:	6a 29                	push   $0x29
  8038d6:	e8 04 fb ff ff       	call   8033df <syscall>
  8038db:	83 c4 18             	add    $0x18,%esp
}
  8038de:	c9                   	leave  
  8038df:	c3                   	ret    

008038e0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8038e0:	55                   	push   %ebp
  8038e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8038e3:	6a 00                	push   $0x0
  8038e5:	6a 00                	push   $0x0
  8038e7:	ff 75 10             	pushl  0x10(%ebp)
  8038ea:	ff 75 0c             	pushl  0xc(%ebp)
  8038ed:	ff 75 08             	pushl  0x8(%ebp)
  8038f0:	6a 12                	push   $0x12
  8038f2:	e8 e8 fa ff ff       	call   8033df <syscall>
  8038f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8038fa:	90                   	nop
}
  8038fb:	c9                   	leave  
  8038fc:	c3                   	ret    

008038fd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8038fd:	55                   	push   %ebp
  8038fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803900:	8b 55 0c             	mov    0xc(%ebp),%edx
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	6a 00                	push   $0x0
  803908:	6a 00                	push   $0x0
  80390a:	6a 00                	push   $0x0
  80390c:	52                   	push   %edx
  80390d:	50                   	push   %eax
  80390e:	6a 2a                	push   $0x2a
  803910:	e8 ca fa ff ff       	call   8033df <syscall>
  803915:	83 c4 18             	add    $0x18,%esp
	return;
  803918:	90                   	nop
}
  803919:	c9                   	leave  
  80391a:	c3                   	ret    

0080391b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80391b:	55                   	push   %ebp
  80391c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80391e:	6a 00                	push   $0x0
  803920:	6a 00                	push   $0x0
  803922:	6a 00                	push   $0x0
  803924:	6a 00                	push   $0x0
  803926:	6a 00                	push   $0x0
  803928:	6a 2b                	push   $0x2b
  80392a:	e8 b0 fa ff ff       	call   8033df <syscall>
  80392f:	83 c4 18             	add    $0x18,%esp
}
  803932:	c9                   	leave  
  803933:	c3                   	ret    

00803934 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803934:	55                   	push   %ebp
  803935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803937:	6a 00                	push   $0x0
  803939:	6a 00                	push   $0x0
  80393b:	6a 00                	push   $0x0
  80393d:	ff 75 0c             	pushl  0xc(%ebp)
  803940:	ff 75 08             	pushl  0x8(%ebp)
  803943:	6a 2d                	push   $0x2d
  803945:	e8 95 fa ff ff       	call   8033df <syscall>
  80394a:	83 c4 18             	add    $0x18,%esp
	return;
  80394d:	90                   	nop
}
  80394e:	c9                   	leave  
  80394f:	c3                   	ret    

00803950 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803950:	55                   	push   %ebp
  803951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803953:	6a 00                	push   $0x0
  803955:	6a 00                	push   $0x0
  803957:	6a 00                	push   $0x0
  803959:	ff 75 0c             	pushl  0xc(%ebp)
  80395c:	ff 75 08             	pushl  0x8(%ebp)
  80395f:	6a 2c                	push   $0x2c
  803961:	e8 79 fa ff ff       	call   8033df <syscall>
  803966:	83 c4 18             	add    $0x18,%esp
	return ;
  803969:	90                   	nop
}
  80396a:	c9                   	leave  
  80396b:	c3                   	ret    

0080396c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80396c:	55                   	push   %ebp
  80396d:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80396f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
  803975:	6a 00                	push   $0x0
  803977:	6a 00                	push   $0x0
  803979:	6a 00                	push   $0x0
  80397b:	52                   	push   %edx
  80397c:	50                   	push   %eax
  80397d:	6a 2e                	push   $0x2e
  80397f:	e8 5b fa ff ff       	call   8033df <syscall>
  803984:	83 c4 18             	add    $0x18,%esp
	return ;
  803987:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803988:	c9                   	leave  
  803989:	c3                   	ret    

0080398a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80398a:	55                   	push   %ebp
  80398b:	89 e5                	mov    %esp,%ebp
  80398d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803990:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  803997:	72 09                	jb     8039a2 <to_page_va+0x18>
  803999:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  8039a0:	72 14                	jb     8039b6 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8039a2:	83 ec 04             	sub    $0x4,%esp
  8039a5:	68 e0 59 80 00       	push   $0x8059e0
  8039aa:	6a 15                	push   $0x15
  8039ac:	68 0b 5a 80 00       	push   $0x805a0b
  8039b1:	e8 4e db ff ff       	call   801504 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8039b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b9:	ba 40 62 80 00       	mov    $0x806240,%edx
  8039be:	29 d0                	sub    %edx,%eax
  8039c0:	c1 f8 02             	sar    $0x2,%eax
  8039c3:	89 c2                	mov    %eax,%edx
  8039c5:	89 d0                	mov    %edx,%eax
  8039c7:	c1 e0 02             	shl    $0x2,%eax
  8039ca:	01 d0                	add    %edx,%eax
  8039cc:	c1 e0 02             	shl    $0x2,%eax
  8039cf:	01 d0                	add    %edx,%eax
  8039d1:	c1 e0 02             	shl    $0x2,%eax
  8039d4:	01 d0                	add    %edx,%eax
  8039d6:	89 c1                	mov    %eax,%ecx
  8039d8:	c1 e1 08             	shl    $0x8,%ecx
  8039db:	01 c8                	add    %ecx,%eax
  8039dd:	89 c1                	mov    %eax,%ecx
  8039df:	c1 e1 10             	shl    $0x10,%ecx
  8039e2:	01 c8                	add    %ecx,%eax
  8039e4:	01 c0                	add    %eax,%eax
  8039e6:	01 d0                	add    %edx,%eax
  8039e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ee:	c1 e0 0c             	shl    $0xc,%eax
  8039f1:	89 c2                	mov    %eax,%edx
  8039f3:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8039f8:	01 d0                	add    %edx,%eax
}
  8039fa:	c9                   	leave  
  8039fb:	c3                   	ret    

008039fc <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8039fc:	55                   	push   %ebp
  8039fd:	89 e5                	mov    %esp,%ebp
  8039ff:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803a02:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803a07:	8b 55 08             	mov    0x8(%ebp),%edx
  803a0a:	29 c2                	sub    %eax,%edx
  803a0c:	89 d0                	mov    %edx,%eax
  803a0e:	c1 e8 0c             	shr    $0xc,%eax
  803a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803a14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a18:	78 09                	js     803a23 <to_page_info+0x27>
  803a1a:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803a21:	7e 14                	jle    803a37 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803a23:	83 ec 04             	sub    $0x4,%esp
  803a26:	68 24 5a 80 00       	push   $0x805a24
  803a2b:	6a 22                	push   $0x22
  803a2d:	68 0b 5a 80 00       	push   $0x805a0b
  803a32:	e8 cd da ff ff       	call   801504 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a3a:	89 d0                	mov    %edx,%eax
  803a3c:	01 c0                	add    %eax,%eax
  803a3e:	01 d0                	add    %edx,%eax
  803a40:	c1 e0 02             	shl    $0x2,%eax
  803a43:	05 40 62 80 00       	add    $0x806240,%eax
}
  803a48:	c9                   	leave  
  803a49:	c3                   	ret    

00803a4a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803a4a:	55                   	push   %ebp
  803a4b:	89 e5                	mov    %esp,%ebp
  803a4d:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803a50:	8b 45 08             	mov    0x8(%ebp),%eax
  803a53:	05 00 00 00 02       	add    $0x2000000,%eax
  803a58:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a5b:	73 16                	jae    803a73 <initialize_dynamic_allocator+0x29>
  803a5d:	68 48 5a 80 00       	push   $0x805a48
  803a62:	68 6e 5a 80 00       	push   $0x805a6e
  803a67:	6a 34                	push   $0x34
  803a69:	68 0b 5a 80 00       	push   $0x805a0b
  803a6e:	e8 91 da ff ff       	call   801504 <_panic>
		is_initialized = 1;
  803a73:	c7 05 14 62 80 00 01 	movl   $0x1,0x806214
  803a7a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a80:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  803a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a88:	a3 20 62 80 00       	mov    %eax,0x806220

	LIST_INIT(&freePagesList);
  803a8d:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  803a94:	00 00 00 
  803a97:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  803a9e:	00 00 00 
  803aa1:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  803aa8:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803aab:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ab9:	eb 36                	jmp    803af1 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abe:	c1 e0 04             	shl    $0x4,%eax
  803ac1:	05 60 e2 81 00       	add    $0x81e260,%eax
  803ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acf:	c1 e0 04             	shl    $0x4,%eax
  803ad2:	05 64 e2 81 00       	add    $0x81e264,%eax
  803ad7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae0:	c1 e0 04             	shl    $0x4,%eax
  803ae3:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803aee:	ff 45 f4             	incl   -0xc(%ebp)
  803af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803af7:	72 c2                	jb     803abb <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803af9:	8b 15 20 62 80 00    	mov    0x806220,%edx
  803aff:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803b04:	29 c2                	sub    %eax,%edx
  803b06:	89 d0                	mov    %edx,%eax
  803b08:	c1 e8 0c             	shr    $0xc,%eax
  803b0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803b0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b15:	e9 c8 00 00 00       	jmp    803be2 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803b1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b1d:	89 d0                	mov    %edx,%eax
  803b1f:	01 c0                	add    %eax,%eax
  803b21:	01 d0                	add    %edx,%eax
  803b23:	c1 e0 02             	shl    $0x2,%eax
  803b26:	05 48 62 80 00       	add    $0x806248,%eax
  803b2b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b33:	89 d0                	mov    %edx,%eax
  803b35:	01 c0                	add    %eax,%eax
  803b37:	01 d0                	add    %edx,%eax
  803b39:	c1 e0 02             	shl    $0x2,%eax
  803b3c:	05 4a 62 80 00       	add    $0x80624a,%eax
  803b41:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803b46:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803b4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b4f:	89 c8                	mov    %ecx,%eax
  803b51:	01 c0                	add    %eax,%eax
  803b53:	01 c8                	add    %ecx,%eax
  803b55:	c1 e0 02             	shl    $0x2,%eax
  803b58:	05 44 62 80 00       	add    $0x806244,%eax
  803b5d:	89 10                	mov    %edx,(%eax)
  803b5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b62:	89 d0                	mov    %edx,%eax
  803b64:	01 c0                	add    %eax,%eax
  803b66:	01 d0                	add    %edx,%eax
  803b68:	c1 e0 02             	shl    $0x2,%eax
  803b6b:	05 44 62 80 00       	add    $0x806244,%eax
  803b70:	8b 00                	mov    (%eax),%eax
  803b72:	85 c0                	test   %eax,%eax
  803b74:	74 1b                	je     803b91 <initialize_dynamic_allocator+0x147>
  803b76:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803b7c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b7f:	89 c8                	mov    %ecx,%eax
  803b81:	01 c0                	add    %eax,%eax
  803b83:	01 c8                	add    %ecx,%eax
  803b85:	c1 e0 02             	shl    $0x2,%eax
  803b88:	05 40 62 80 00       	add    $0x806240,%eax
  803b8d:	89 02                	mov    %eax,(%edx)
  803b8f:	eb 16                	jmp    803ba7 <initialize_dynamic_allocator+0x15d>
  803b91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b94:	89 d0                	mov    %edx,%eax
  803b96:	01 c0                	add    %eax,%eax
  803b98:	01 d0                	add    %edx,%eax
  803b9a:	c1 e0 02             	shl    $0x2,%eax
  803b9d:	05 40 62 80 00       	add    $0x806240,%eax
  803ba2:	a3 28 62 80 00       	mov    %eax,0x806228
  803ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803baa:	89 d0                	mov    %edx,%eax
  803bac:	01 c0                	add    %eax,%eax
  803bae:	01 d0                	add    %edx,%eax
  803bb0:	c1 e0 02             	shl    $0x2,%eax
  803bb3:	05 40 62 80 00       	add    $0x806240,%eax
  803bb8:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803bbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bc0:	89 d0                	mov    %edx,%eax
  803bc2:	01 c0                	add    %eax,%eax
  803bc4:	01 d0                	add    %edx,%eax
  803bc6:	c1 e0 02             	shl    $0x2,%eax
  803bc9:	05 40 62 80 00       	add    $0x806240,%eax
  803bce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd4:	a1 34 62 80 00       	mov    0x806234,%eax
  803bd9:	40                   	inc    %eax
  803bda:	a3 34 62 80 00       	mov    %eax,0x806234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803bdf:	ff 45 f0             	incl   -0x10(%ebp)
  803be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803be8:	0f 82 2c ff ff ff    	jb     803b1a <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803bf4:	eb 2f                	jmp    803c25 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803bf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bf9:	89 d0                	mov    %edx,%eax
  803bfb:	01 c0                	add    %eax,%eax
  803bfd:	01 d0                	add    %edx,%eax
  803bff:	c1 e0 02             	shl    $0x2,%eax
  803c02:	05 48 62 80 00       	add    $0x806248,%eax
  803c07:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803c0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c0f:	89 d0                	mov    %edx,%eax
  803c11:	01 c0                	add    %eax,%eax
  803c13:	01 d0                	add    %edx,%eax
  803c15:	c1 e0 02             	shl    $0x2,%eax
  803c18:	05 4a 62 80 00       	add    $0x80624a,%eax
  803c1d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803c22:	ff 45 ec             	incl   -0x14(%ebp)
  803c25:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803c2c:	76 c8                	jbe    803bf6 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803c2e:	90                   	nop
  803c2f:	c9                   	leave  
  803c30:	c3                   	ret    

00803c31 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803c31:	55                   	push   %ebp
  803c32:	89 e5                	mov    %esp,%ebp
  803c34:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803c37:	8b 55 08             	mov    0x8(%ebp),%edx
  803c3a:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803c3f:	29 c2                	sub    %eax,%edx
  803c41:	89 d0                	mov    %edx,%eax
  803c43:	c1 e8 0c             	shr    $0xc,%eax
  803c46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803c49:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803c4c:	89 d0                	mov    %edx,%eax
  803c4e:	01 c0                	add    %eax,%eax
  803c50:	01 d0                	add    %edx,%eax
  803c52:	c1 e0 02             	shl    $0x2,%eax
  803c55:	05 48 62 80 00       	add    $0x806248,%eax
  803c5a:	8b 00                	mov    (%eax),%eax
  803c5c:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803c5f:	c9                   	leave  
  803c60:	c3                   	ret    

00803c61 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803c61:	55                   	push   %ebp
  803c62:	89 e5                	mov    %esp,%ebp
  803c64:	83 ec 14             	sub    $0x14,%esp
  803c67:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803c6a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803c6e:	77 07                	ja     803c77 <nearest_pow2_ceil.1513+0x16>
  803c70:	b8 01 00 00 00       	mov    $0x1,%eax
  803c75:	eb 20                	jmp    803c97 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803c77:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803c7e:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803c81:	eb 08                	jmp    803c8b <nearest_pow2_ceil.1513+0x2a>
  803c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c86:	01 c0                	add    %eax,%eax
  803c88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803c8b:	d1 6d 08             	shrl   0x8(%ebp)
  803c8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c92:	75 ef                	jne    803c83 <nearest_pow2_ceil.1513+0x22>
        return power;
  803c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803c97:	c9                   	leave  
  803c98:	c3                   	ret    

00803c99 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c99:	55                   	push   %ebp
  803c9a:	89 e5                	mov    %esp,%ebp
  803c9c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c9f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803ca6:	76 16                	jbe    803cbe <alloc_block+0x25>
  803ca8:	68 84 5a 80 00       	push   $0x805a84
  803cad:	68 6e 5a 80 00       	push   $0x805a6e
  803cb2:	6a 72                	push   $0x72
  803cb4:	68 0b 5a 80 00       	push   $0x805a0b
  803cb9:	e8 46 d8 ff ff       	call   801504 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803cbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cc2:	75 0a                	jne    803cce <alloc_block+0x35>
  803cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc9:	e9 bd 04 00 00       	jmp    80418b <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803cce:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cdb:	73 06                	jae    803ce3 <alloc_block+0x4a>
        size = min_block_size;
  803cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce0:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803ce3:	83 ec 0c             	sub    $0xc,%esp
  803ce6:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803ce9:	ff 75 08             	pushl  0x8(%ebp)
  803cec:	89 c1                	mov    %eax,%ecx
  803cee:	e8 6e ff ff ff       	call   803c61 <nearest_pow2_ceil.1513>
  803cf3:	83 c4 10             	add    $0x10,%esp
  803cf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803cf9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cfc:	83 ec 0c             	sub    $0xc,%esp
  803cff:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803d02:	52                   	push   %edx
  803d03:	89 c1                	mov    %eax,%ecx
  803d05:	e8 83 04 00 00       	call   80418d <log2_ceil.1520>
  803d0a:	83 c4 10             	add    $0x10,%esp
  803d0d:	83 e8 03             	sub    $0x3,%eax
  803d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d16:	c1 e0 04             	shl    $0x4,%eax
  803d19:	05 60 e2 81 00       	add    $0x81e260,%eax
  803d1e:	8b 00                	mov    (%eax),%eax
  803d20:	85 c0                	test   %eax,%eax
  803d22:	0f 84 d8 00 00 00    	je     803e00 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2b:	c1 e0 04             	shl    $0x4,%eax
  803d2e:	05 60 e2 81 00       	add    $0x81e260,%eax
  803d33:	8b 00                	mov    (%eax),%eax
  803d35:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803d38:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d3c:	75 17                	jne    803d55 <alloc_block+0xbc>
  803d3e:	83 ec 04             	sub    $0x4,%esp
  803d41:	68 a5 5a 80 00       	push   $0x805aa5
  803d46:	68 98 00 00 00       	push   $0x98
  803d4b:	68 0b 5a 80 00       	push   $0x805a0b
  803d50:	e8 af d7 ff ff       	call   801504 <_panic>
  803d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d58:	8b 00                	mov    (%eax),%eax
  803d5a:	85 c0                	test   %eax,%eax
  803d5c:	74 10                	je     803d6e <alloc_block+0xd5>
  803d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d61:	8b 00                	mov    (%eax),%eax
  803d63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d66:	8b 52 04             	mov    0x4(%edx),%edx
  803d69:	89 50 04             	mov    %edx,0x4(%eax)
  803d6c:	eb 14                	jmp    803d82 <alloc_block+0xe9>
  803d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d71:	8b 40 04             	mov    0x4(%eax),%eax
  803d74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d77:	c1 e2 04             	shl    $0x4,%edx
  803d7a:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803d80:	89 02                	mov    %eax,(%edx)
  803d82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d85:	8b 40 04             	mov    0x4(%eax),%eax
  803d88:	85 c0                	test   %eax,%eax
  803d8a:	74 0f                	je     803d9b <alloc_block+0x102>
  803d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d8f:	8b 40 04             	mov    0x4(%eax),%eax
  803d92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d95:	8b 12                	mov    (%edx),%edx
  803d97:	89 10                	mov    %edx,(%eax)
  803d99:	eb 13                	jmp    803dae <alloc_block+0x115>
  803d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d9e:	8b 00                	mov    (%eax),%eax
  803da0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da3:	c1 e2 04             	shl    $0x4,%edx
  803da6:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803dac:	89 02                	mov    %eax,(%edx)
  803dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc4:	c1 e0 04             	shl    $0x4,%eax
  803dc7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803dcc:	8b 00                	mov    (%eax),%eax
  803dce:	8d 50 ff             	lea    -0x1(%eax),%edx
  803dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd4:	c1 e0 04             	shl    $0x4,%eax
  803dd7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ddc:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803de1:	83 ec 0c             	sub    $0xc,%esp
  803de4:	50                   	push   %eax
  803de5:	e8 12 fc ff ff       	call   8039fc <to_page_info>
  803dea:	83 c4 10             	add    $0x10,%esp
  803ded:	89 c2                	mov    %eax,%edx
  803def:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803df3:	48                   	dec    %eax
  803df4:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dfb:	e9 8b 03 00 00       	jmp    80418b <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803e00:	a1 28 62 80 00       	mov    0x806228,%eax
  803e05:	85 c0                	test   %eax,%eax
  803e07:	0f 84 64 02 00 00    	je     804071 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803e0d:	a1 28 62 80 00       	mov    0x806228,%eax
  803e12:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803e15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e19:	75 17                	jne    803e32 <alloc_block+0x199>
  803e1b:	83 ec 04             	sub    $0x4,%esp
  803e1e:	68 a5 5a 80 00       	push   $0x805aa5
  803e23:	68 a0 00 00 00       	push   $0xa0
  803e28:	68 0b 5a 80 00       	push   $0x805a0b
  803e2d:	e8 d2 d6 ff ff       	call   801504 <_panic>
  803e32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e35:	8b 00                	mov    (%eax),%eax
  803e37:	85 c0                	test   %eax,%eax
  803e39:	74 10                	je     803e4b <alloc_block+0x1b2>
  803e3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3e:	8b 00                	mov    (%eax),%eax
  803e40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e43:	8b 52 04             	mov    0x4(%edx),%edx
  803e46:	89 50 04             	mov    %edx,0x4(%eax)
  803e49:	eb 0b                	jmp    803e56 <alloc_block+0x1bd>
  803e4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4e:	8b 40 04             	mov    0x4(%eax),%eax
  803e51:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803e56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e59:	8b 40 04             	mov    0x4(%eax),%eax
  803e5c:	85 c0                	test   %eax,%eax
  803e5e:	74 0f                	je     803e6f <alloc_block+0x1d6>
  803e60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e63:	8b 40 04             	mov    0x4(%eax),%eax
  803e66:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e69:	8b 12                	mov    (%edx),%edx
  803e6b:	89 10                	mov    %edx,(%eax)
  803e6d:	eb 0a                	jmp    803e79 <alloc_block+0x1e0>
  803e6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e72:	8b 00                	mov    (%eax),%eax
  803e74:	a3 28 62 80 00       	mov    %eax,0x806228
  803e79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e8c:	a1 34 62 80 00       	mov    0x806234,%eax
  803e91:	48                   	dec    %eax
  803e92:	a3 34 62 80 00       	mov    %eax,0x806234

        page_info_e->block_size = pow;
  803e97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e9d:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803ea1:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ea6:	99                   	cltd   
  803ea7:	f7 7d e8             	idivl  -0x18(%ebp)
  803eaa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ead:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803eb1:	83 ec 0c             	sub    $0xc,%esp
  803eb4:	ff 75 dc             	pushl  -0x24(%ebp)
  803eb7:	e8 ce fa ff ff       	call   80398a <to_page_va>
  803ebc:	83 c4 10             	add    $0x10,%esp
  803ebf:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803ec2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ec5:	83 ec 0c             	sub    $0xc,%esp
  803ec8:	50                   	push   %eax
  803ec9:	e8 c0 ee ff ff       	call   802d8e <get_page>
  803ece:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803ed1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ed8:	e9 aa 00 00 00       	jmp    803f87 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee0:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803ee4:	89 c2                	mov    %eax,%edx
  803ee6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ee9:	01 d0                	add    %edx,%eax
  803eeb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803eee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ef2:	75 17                	jne    803f0b <alloc_block+0x272>
  803ef4:	83 ec 04             	sub    $0x4,%esp
  803ef7:	68 c4 5a 80 00       	push   $0x805ac4
  803efc:	68 aa 00 00 00       	push   $0xaa
  803f01:	68 0b 5a 80 00       	push   $0x805a0b
  803f06:	e8 f9 d5 ff ff       	call   801504 <_panic>
  803f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0e:	c1 e0 04             	shl    $0x4,%eax
  803f11:	05 64 e2 81 00       	add    $0x81e264,%eax
  803f16:	8b 10                	mov    (%eax),%edx
  803f18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f1b:	89 50 04             	mov    %edx,0x4(%eax)
  803f1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f21:	8b 40 04             	mov    0x4(%eax),%eax
  803f24:	85 c0                	test   %eax,%eax
  803f26:	74 14                	je     803f3c <alloc_block+0x2a3>
  803f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2b:	c1 e0 04             	shl    $0x4,%eax
  803f2e:	05 64 e2 81 00       	add    $0x81e264,%eax
  803f33:	8b 00                	mov    (%eax),%eax
  803f35:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f38:	89 10                	mov    %edx,(%eax)
  803f3a:	eb 11                	jmp    803f4d <alloc_block+0x2b4>
  803f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3f:	c1 e0 04             	shl    $0x4,%eax
  803f42:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  803f48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f4b:	89 02                	mov    %eax,(%edx)
  803f4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f50:	c1 e0 04             	shl    $0x4,%eax
  803f53:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803f59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f5c:	89 02                	mov    %eax,(%edx)
  803f5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6a:	c1 e0 04             	shl    $0x4,%eax
  803f6d:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803f72:	8b 00                	mov    (%eax),%eax
  803f74:	8d 50 01             	lea    0x1(%eax),%edx
  803f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7a:	c1 e0 04             	shl    $0x4,%eax
  803f7d:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803f82:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803f84:	ff 45 f4             	incl   -0xc(%ebp)
  803f87:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f8c:	99                   	cltd   
  803f8d:	f7 7d e8             	idivl  -0x18(%ebp)
  803f90:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803f93:	0f 8f 44 ff ff ff    	jg     803edd <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9c:	c1 e0 04             	shl    $0x4,%eax
  803f9f:	05 60 e2 81 00       	add    $0x81e260,%eax
  803fa4:	8b 00                	mov    (%eax),%eax
  803fa6:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803fa9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803fad:	75 17                	jne    803fc6 <alloc_block+0x32d>
  803faf:	83 ec 04             	sub    $0x4,%esp
  803fb2:	68 a5 5a 80 00       	push   $0x805aa5
  803fb7:	68 ae 00 00 00       	push   $0xae
  803fbc:	68 0b 5a 80 00       	push   $0x805a0b
  803fc1:	e8 3e d5 ff ff       	call   801504 <_panic>
  803fc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fc9:	8b 00                	mov    (%eax),%eax
  803fcb:	85 c0                	test   %eax,%eax
  803fcd:	74 10                	je     803fdf <alloc_block+0x346>
  803fcf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fd2:	8b 00                	mov    (%eax),%eax
  803fd4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803fd7:	8b 52 04             	mov    0x4(%edx),%edx
  803fda:	89 50 04             	mov    %edx,0x4(%eax)
  803fdd:	eb 14                	jmp    803ff3 <alloc_block+0x35a>
  803fdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fe2:	8b 40 04             	mov    0x4(%eax),%eax
  803fe5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fe8:	c1 e2 04             	shl    $0x4,%edx
  803feb:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803ff1:	89 02                	mov    %eax,(%edx)
  803ff3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ff6:	8b 40 04             	mov    0x4(%eax),%eax
  803ff9:	85 c0                	test   %eax,%eax
  803ffb:	74 0f                	je     80400c <alloc_block+0x373>
  803ffd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804000:	8b 40 04             	mov    0x4(%eax),%eax
  804003:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804006:	8b 12                	mov    (%edx),%edx
  804008:	89 10                	mov    %edx,(%eax)
  80400a:	eb 13                	jmp    80401f <alloc_block+0x386>
  80400c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80400f:	8b 00                	mov    (%eax),%eax
  804011:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804014:	c1 e2 04             	shl    $0x4,%edx
  804017:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  80401d:	89 02                	mov    %eax,(%edx)
  80401f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804022:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804028:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80402b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804035:	c1 e0 04             	shl    $0x4,%eax
  804038:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80403d:	8b 00                	mov    (%eax),%eax
  80403f:	8d 50 ff             	lea    -0x1(%eax),%edx
  804042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804045:	c1 e0 04             	shl    $0x4,%eax
  804048:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80404d:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80404f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804052:	83 ec 0c             	sub    $0xc,%esp
  804055:	50                   	push   %eax
  804056:	e8 a1 f9 ff ff       	call   8039fc <to_page_info>
  80405b:	83 c4 10             	add    $0x10,%esp
  80405e:	89 c2                	mov    %eax,%edx
  804060:	66 8b 42 0a          	mov    0xa(%edx),%ax
  804064:	48                   	dec    %eax
  804065:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  804069:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80406c:	e9 1a 01 00 00       	jmp    80418b <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  804071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804074:	40                   	inc    %eax
  804075:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804078:	e9 ed 00 00 00       	jmp    80416a <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80407d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804080:	c1 e0 04             	shl    $0x4,%eax
  804083:	05 60 e2 81 00       	add    $0x81e260,%eax
  804088:	8b 00                	mov    (%eax),%eax
  80408a:	85 c0                	test   %eax,%eax
  80408c:	0f 84 d5 00 00 00    	je     804167 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  804092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804095:	c1 e0 04             	shl    $0x4,%eax
  804098:	05 60 e2 81 00       	add    $0x81e260,%eax
  80409d:	8b 00                	mov    (%eax),%eax
  80409f:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8040a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8040a6:	75 17                	jne    8040bf <alloc_block+0x426>
  8040a8:	83 ec 04             	sub    $0x4,%esp
  8040ab:	68 a5 5a 80 00       	push   $0x805aa5
  8040b0:	68 b8 00 00 00       	push   $0xb8
  8040b5:	68 0b 5a 80 00       	push   $0x805a0b
  8040ba:	e8 45 d4 ff ff       	call   801504 <_panic>
  8040bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040c2:	8b 00                	mov    (%eax),%eax
  8040c4:	85 c0                	test   %eax,%eax
  8040c6:	74 10                	je     8040d8 <alloc_block+0x43f>
  8040c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040cb:	8b 00                	mov    (%eax),%eax
  8040cd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8040d0:	8b 52 04             	mov    0x4(%edx),%edx
  8040d3:	89 50 04             	mov    %edx,0x4(%eax)
  8040d6:	eb 14                	jmp    8040ec <alloc_block+0x453>
  8040d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040db:	8b 40 04             	mov    0x4(%eax),%eax
  8040de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040e1:	c1 e2 04             	shl    $0x4,%edx
  8040e4:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8040ea:	89 02                	mov    %eax,(%edx)
  8040ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040ef:	8b 40 04             	mov    0x4(%eax),%eax
  8040f2:	85 c0                	test   %eax,%eax
  8040f4:	74 0f                	je     804105 <alloc_block+0x46c>
  8040f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040f9:	8b 40 04             	mov    0x4(%eax),%eax
  8040fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8040ff:	8b 12                	mov    (%edx),%edx
  804101:	89 10                	mov    %edx,(%eax)
  804103:	eb 13                	jmp    804118 <alloc_block+0x47f>
  804105:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804108:	8b 00                	mov    (%eax),%eax
  80410a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80410d:	c1 e2 04             	shl    $0x4,%edx
  804110:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  804116:	89 02                	mov    %eax,(%edx)
  804118:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80411b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804121:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804124:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80412b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80412e:	c1 e0 04             	shl    $0x4,%eax
  804131:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804136:	8b 00                	mov    (%eax),%eax
  804138:	8d 50 ff             	lea    -0x1(%eax),%edx
  80413b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80413e:	c1 e0 04             	shl    $0x4,%eax
  804141:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804146:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  804148:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80414b:	83 ec 0c             	sub    $0xc,%esp
  80414e:	50                   	push   %eax
  80414f:	e8 a8 f8 ff ff       	call   8039fc <to_page_info>
  804154:	83 c4 10             	add    $0x10,%esp
  804157:	89 c2                	mov    %eax,%edx
  804159:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80415d:	48                   	dec    %eax
  80415e:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  804162:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804165:	eb 24                	jmp    80418b <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  804167:	ff 45 f0             	incl   -0x10(%ebp)
  80416a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80416e:	0f 8e 09 ff ff ff    	jle    80407d <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  804174:	83 ec 04             	sub    $0x4,%esp
  804177:	68 e7 5a 80 00       	push   $0x805ae7
  80417c:	68 bf 00 00 00       	push   $0xbf
  804181:	68 0b 5a 80 00       	push   $0x805a0b
  804186:	e8 79 d3 ff ff       	call   801504 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80418b:	c9                   	leave  
  80418c:	c3                   	ret    

0080418d <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80418d:	55                   	push   %ebp
  80418e:	89 e5                	mov    %esp,%ebp
  804190:	83 ec 14             	sub    $0x14,%esp
  804193:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  804196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80419a:	75 07                	jne    8041a3 <log2_ceil.1520+0x16>
  80419c:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a1:	eb 1b                	jmp    8041be <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8041a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8041aa:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8041ad:	eb 06                	jmp    8041b5 <log2_ceil.1520+0x28>
            x >>= 1;
  8041af:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8041b2:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8041b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041b9:	75 f4                	jne    8041af <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8041bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8041be:	c9                   	leave  
  8041bf:	c3                   	ret    

008041c0 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8041c0:	55                   	push   %ebp
  8041c1:	89 e5                	mov    %esp,%ebp
  8041c3:	83 ec 14             	sub    $0x14,%esp
  8041c6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8041c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041cd:	75 07                	jne    8041d6 <log2_ceil.1547+0x16>
  8041cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8041d4:	eb 1b                	jmp    8041f1 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8041d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8041dd:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8041e0:	eb 06                	jmp    8041e8 <log2_ceil.1547+0x28>
			x >>= 1;
  8041e2:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8041e5:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8041e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041ec:	75 f4                	jne    8041e2 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8041ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8041f1:	c9                   	leave  
  8041f2:	c3                   	ret    

008041f3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8041f3:	55                   	push   %ebp
  8041f4:	89 e5                	mov    %esp,%ebp
  8041f6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8041f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8041fc:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804201:	39 c2                	cmp    %eax,%edx
  804203:	72 0c                	jb     804211 <free_block+0x1e>
  804205:	8b 55 08             	mov    0x8(%ebp),%edx
  804208:	a1 20 62 80 00       	mov    0x806220,%eax
  80420d:	39 c2                	cmp    %eax,%edx
  80420f:	72 19                	jb     80422a <free_block+0x37>
  804211:	68 ec 5a 80 00       	push   $0x805aec
  804216:	68 6e 5a 80 00       	push   $0x805a6e
  80421b:	68 d0 00 00 00       	push   $0xd0
  804220:	68 0b 5a 80 00       	push   $0x805a0b
  804225:	e8 da d2 ff ff       	call   801504 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80422a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80422e:	0f 84 42 03 00 00    	je     804576 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  804234:	8b 55 08             	mov    0x8(%ebp),%edx
  804237:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80423c:	39 c2                	cmp    %eax,%edx
  80423e:	72 0c                	jb     80424c <free_block+0x59>
  804240:	8b 55 08             	mov    0x8(%ebp),%edx
  804243:	a1 20 62 80 00       	mov    0x806220,%eax
  804248:	39 c2                	cmp    %eax,%edx
  80424a:	72 17                	jb     804263 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80424c:	83 ec 04             	sub    $0x4,%esp
  80424f:	68 24 5b 80 00       	push   $0x805b24
  804254:	68 e6 00 00 00       	push   $0xe6
  804259:	68 0b 5a 80 00       	push   $0x805a0b
  80425e:	e8 a1 d2 ff ff       	call   801504 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  804263:	8b 55 08             	mov    0x8(%ebp),%edx
  804266:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80426b:	29 c2                	sub    %eax,%edx
  80426d:	89 d0                	mov    %edx,%eax
  80426f:	83 e0 07             	and    $0x7,%eax
  804272:	85 c0                	test   %eax,%eax
  804274:	74 17                	je     80428d <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  804276:	83 ec 04             	sub    $0x4,%esp
  804279:	68 58 5b 80 00       	push   $0x805b58
  80427e:	68 ea 00 00 00       	push   $0xea
  804283:	68 0b 5a 80 00       	push   $0x805a0b
  804288:	e8 77 d2 ff ff       	call   801504 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80428d:	8b 45 08             	mov    0x8(%ebp),%eax
  804290:	83 ec 0c             	sub    $0xc,%esp
  804293:	50                   	push   %eax
  804294:	e8 63 f7 ff ff       	call   8039fc <to_page_info>
  804299:	83 c4 10             	add    $0x10,%esp
  80429c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80429f:	83 ec 0c             	sub    $0xc,%esp
  8042a2:	ff 75 08             	pushl  0x8(%ebp)
  8042a5:	e8 87 f9 ff ff       	call   803c31 <get_block_size>
  8042aa:	83 c4 10             	add    $0x10,%esp
  8042ad:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8042b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8042b4:	75 17                	jne    8042cd <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8042b6:	83 ec 04             	sub    $0x4,%esp
  8042b9:	68 84 5b 80 00       	push   $0x805b84
  8042be:	68 f1 00 00 00       	push   $0xf1
  8042c3:	68 0b 5a 80 00       	push   $0x805a0b
  8042c8:	e8 37 d2 ff ff       	call   801504 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8042cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042d0:	83 ec 0c             	sub    $0xc,%esp
  8042d3:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8042d6:	52                   	push   %edx
  8042d7:	89 c1                	mov    %eax,%ecx
  8042d9:	e8 e2 fe ff ff       	call   8041c0 <log2_ceil.1547>
  8042de:	83 c4 10             	add    $0x10,%esp
  8042e1:	83 e8 03             	sub    $0x3,%eax
  8042e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8042e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8042ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8042f1:	75 17                	jne    80430a <free_block+0x117>
  8042f3:	83 ec 04             	sub    $0x4,%esp
  8042f6:	68 d0 5b 80 00       	push   $0x805bd0
  8042fb:	68 f6 00 00 00       	push   $0xf6
  804300:	68 0b 5a 80 00       	push   $0x805a0b
  804305:	e8 fa d1 ff ff       	call   801504 <_panic>
  80430a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80430d:	c1 e0 04             	shl    $0x4,%eax
  804310:	05 60 e2 81 00       	add    $0x81e260,%eax
  804315:	8b 10                	mov    (%eax),%edx
  804317:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80431a:	89 10                	mov    %edx,(%eax)
  80431c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80431f:	8b 00                	mov    (%eax),%eax
  804321:	85 c0                	test   %eax,%eax
  804323:	74 15                	je     80433a <free_block+0x147>
  804325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804328:	c1 e0 04             	shl    $0x4,%eax
  80432b:	05 60 e2 81 00       	add    $0x81e260,%eax
  804330:	8b 00                	mov    (%eax),%eax
  804332:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804335:	89 50 04             	mov    %edx,0x4(%eax)
  804338:	eb 11                	jmp    80434b <free_block+0x158>
  80433a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80433d:	c1 e0 04             	shl    $0x4,%eax
  804340:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  804346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804349:	89 02                	mov    %eax,(%edx)
  80434b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80434e:	c1 e0 04             	shl    $0x4,%eax
  804351:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  804357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80435a:	89 02                	mov    %eax,(%edx)
  80435c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80435f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804369:	c1 e0 04             	shl    $0x4,%eax
  80436c:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804371:	8b 00                	mov    (%eax),%eax
  804373:	8d 50 01             	lea    0x1(%eax),%edx
  804376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804379:	c1 e0 04             	shl    $0x4,%eax
  80437c:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804381:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  804383:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804386:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80438a:	40                   	inc    %eax
  80438b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80438e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  804392:	8b 55 08             	mov    0x8(%ebp),%edx
  804395:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80439a:	29 c2                	sub    %eax,%edx
  80439c:	89 d0                	mov    %edx,%eax
  80439e:	c1 e8 0c             	shr    $0xc,%eax
  8043a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8043a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043a7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8043ab:	0f b7 c8             	movzwl %ax,%ecx
  8043ae:	b8 00 10 00 00       	mov    $0x1000,%eax
  8043b3:	99                   	cltd   
  8043b4:	f7 7d e8             	idivl  -0x18(%ebp)
  8043b7:	39 c1                	cmp    %eax,%ecx
  8043b9:	0f 85 b8 01 00 00    	jne    804577 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8043bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8043c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043c9:	c1 e0 04             	shl    $0x4,%eax
  8043cc:	05 60 e2 81 00       	add    $0x81e260,%eax
  8043d1:	8b 00                	mov    (%eax),%eax
  8043d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8043d6:	e9 d5 00 00 00       	jmp    8044b0 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8043db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043de:	8b 00                	mov    (%eax),%eax
  8043e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8043e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043e6:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8043eb:	29 c2                	sub    %eax,%edx
  8043ed:	89 d0                	mov    %edx,%eax
  8043ef:	c1 e8 0c             	shr    $0xc,%eax
  8043f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8043f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043f8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8043fb:	0f 85 a9 00 00 00    	jne    8044aa <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  804401:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804405:	75 17                	jne    80441e <free_block+0x22b>
  804407:	83 ec 04             	sub    $0x4,%esp
  80440a:	68 a5 5a 80 00       	push   $0x805aa5
  80440f:	68 04 01 00 00       	push   $0x104
  804414:	68 0b 5a 80 00       	push   $0x805a0b
  804419:	e8 e6 d0 ff ff       	call   801504 <_panic>
  80441e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804421:	8b 00                	mov    (%eax),%eax
  804423:	85 c0                	test   %eax,%eax
  804425:	74 10                	je     804437 <free_block+0x244>
  804427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80442a:	8b 00                	mov    (%eax),%eax
  80442c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80442f:	8b 52 04             	mov    0x4(%edx),%edx
  804432:	89 50 04             	mov    %edx,0x4(%eax)
  804435:	eb 14                	jmp    80444b <free_block+0x258>
  804437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80443a:	8b 40 04             	mov    0x4(%eax),%eax
  80443d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804440:	c1 e2 04             	shl    $0x4,%edx
  804443:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  804449:	89 02                	mov    %eax,(%edx)
  80444b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80444e:	8b 40 04             	mov    0x4(%eax),%eax
  804451:	85 c0                	test   %eax,%eax
  804453:	74 0f                	je     804464 <free_block+0x271>
  804455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804458:	8b 40 04             	mov    0x4(%eax),%eax
  80445b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80445e:	8b 12                	mov    (%edx),%edx
  804460:	89 10                	mov    %edx,(%eax)
  804462:	eb 13                	jmp    804477 <free_block+0x284>
  804464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804467:	8b 00                	mov    (%eax),%eax
  804469:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80446c:	c1 e2 04             	shl    $0x4,%edx
  80446f:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  804475:	89 02                	mov    %eax,(%edx)
  804477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80447a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80448a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80448d:	c1 e0 04             	shl    $0x4,%eax
  804490:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804495:	8b 00                	mov    (%eax),%eax
  804497:	8d 50 ff             	lea    -0x1(%eax),%edx
  80449a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80449d:	c1 e0 04             	shl    $0x4,%eax
  8044a0:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8044a5:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8044a7:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8044aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8044ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8044b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044b4:	0f 85 21 ff ff ff    	jne    8043db <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8044ba:	b8 00 10 00 00       	mov    $0x1000,%eax
  8044bf:	99                   	cltd   
  8044c0:	f7 7d e8             	idivl  -0x18(%ebp)
  8044c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8044c6:	74 17                	je     8044df <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8044c8:	83 ec 04             	sub    $0x4,%esp
  8044cb:	68 f4 5b 80 00       	push   $0x805bf4
  8044d0:	68 0c 01 00 00       	push   $0x10c
  8044d5:	68 0b 5a 80 00       	push   $0x805a0b
  8044da:	e8 25 d0 ff ff       	call   801504 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8044df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044e2:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8044e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044eb:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8044f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8044f5:	75 17                	jne    80450e <free_block+0x31b>
  8044f7:	83 ec 04             	sub    $0x4,%esp
  8044fa:	68 c4 5a 80 00       	push   $0x805ac4
  8044ff:	68 11 01 00 00       	push   $0x111
  804504:	68 0b 5a 80 00       	push   $0x805a0b
  804509:	e8 f6 cf ff ff       	call   801504 <_panic>
  80450e:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  804514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804517:	89 50 04             	mov    %edx,0x4(%eax)
  80451a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80451d:	8b 40 04             	mov    0x4(%eax),%eax
  804520:	85 c0                	test   %eax,%eax
  804522:	74 0c                	je     804530 <free_block+0x33d>
  804524:	a1 2c 62 80 00       	mov    0x80622c,%eax
  804529:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80452c:	89 10                	mov    %edx,(%eax)
  80452e:	eb 08                	jmp    804538 <free_block+0x345>
  804530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804533:	a3 28 62 80 00       	mov    %eax,0x806228
  804538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80453b:	a3 2c 62 80 00       	mov    %eax,0x80622c
  804540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804549:	a1 34 62 80 00       	mov    0x806234,%eax
  80454e:	40                   	inc    %eax
  80454f:	a3 34 62 80 00       	mov    %eax,0x806234

        uint32 pp = to_page_va(page_info_e);
  804554:	83 ec 0c             	sub    $0xc,%esp
  804557:	ff 75 ec             	pushl  -0x14(%ebp)
  80455a:	e8 2b f4 ff ff       	call   80398a <to_page_va>
  80455f:	83 c4 10             	add    $0x10,%esp
  804562:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  804565:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804568:	83 ec 0c             	sub    $0xc,%esp
  80456b:	50                   	push   %eax
  80456c:	e8 69 e8 ff ff       	call   802dda <return_page>
  804571:	83 c4 10             	add    $0x10,%esp
  804574:	eb 01                	jmp    804577 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  804576:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804577:	c9                   	leave  
  804578:	c3                   	ret    

00804579 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  804579:	55                   	push   %ebp
  80457a:	89 e5                	mov    %esp,%ebp
  80457c:	83 ec 14             	sub    $0x14,%esp
  80457f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  804582:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804586:	77 07                	ja     80458f <nearest_pow2_ceil.1572+0x16>
      return 1;
  804588:	b8 01 00 00 00       	mov    $0x1,%eax
  80458d:	eb 20                	jmp    8045af <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80458f:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  804596:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  804599:	eb 08                	jmp    8045a3 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  80459b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80459e:	01 c0                	add    %eax,%eax
  8045a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8045a3:	d1 6d 08             	shrl   0x8(%ebp)
  8045a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8045aa:	75 ef                	jne    80459b <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8045ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8045af:	c9                   	leave  
  8045b0:	c3                   	ret    

008045b1 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8045b1:	55                   	push   %ebp
  8045b2:	89 e5                	mov    %esp,%ebp
  8045b4:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8045b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8045bb:	75 13                	jne    8045d0 <realloc_block+0x1f>
    return alloc_block(new_size);
  8045bd:	83 ec 0c             	sub    $0xc,%esp
  8045c0:	ff 75 0c             	pushl  0xc(%ebp)
  8045c3:	e8 d1 f6 ff ff       	call   803c99 <alloc_block>
  8045c8:	83 c4 10             	add    $0x10,%esp
  8045cb:	e9 d9 00 00 00       	jmp    8046a9 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8045d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8045d4:	75 18                	jne    8045ee <realloc_block+0x3d>
    free_block(va);
  8045d6:	83 ec 0c             	sub    $0xc,%esp
  8045d9:	ff 75 08             	pushl  0x8(%ebp)
  8045dc:	e8 12 fc ff ff       	call   8041f3 <free_block>
  8045e1:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8045e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8045e9:	e9 bb 00 00 00       	jmp    8046a9 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8045ee:	83 ec 0c             	sub    $0xc,%esp
  8045f1:	ff 75 08             	pushl  0x8(%ebp)
  8045f4:	e8 38 f6 ff ff       	call   803c31 <get_block_size>
  8045f9:	83 c4 10             	add    $0x10,%esp
  8045fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8045ff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804606:	8b 45 0c             	mov    0xc(%ebp),%eax
  804609:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80460c:	73 06                	jae    804614 <realloc_block+0x63>
    new_size = min_block_size;
  80460e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804611:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  804614:	83 ec 0c             	sub    $0xc,%esp
  804617:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80461a:	ff 75 0c             	pushl  0xc(%ebp)
  80461d:	89 c1                	mov    %eax,%ecx
  80461f:	e8 55 ff ff ff       	call   804579 <nearest_pow2_ceil.1572>
  804624:	83 c4 10             	add    $0x10,%esp
  804627:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80462a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80462d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804630:	75 05                	jne    804637 <realloc_block+0x86>
    return va;
  804632:	8b 45 08             	mov    0x8(%ebp),%eax
  804635:	eb 72                	jmp    8046a9 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  804637:	83 ec 0c             	sub    $0xc,%esp
  80463a:	ff 75 0c             	pushl  0xc(%ebp)
  80463d:	e8 57 f6 ff ff       	call   803c99 <alloc_block>
  804642:	83 c4 10             	add    $0x10,%esp
  804645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  804648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80464c:	75 07                	jne    804655 <realloc_block+0xa4>
    return NULL;
  80464e:	b8 00 00 00 00       	mov    $0x0,%eax
  804653:	eb 54                	jmp    8046a9 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  804655:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80465b:	39 d0                	cmp    %edx,%eax
  80465d:	76 02                	jbe    804661 <realloc_block+0xb0>
  80465f:	89 d0                	mov    %edx,%eax
  804661:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  804664:	8b 45 08             	mov    0x8(%ebp),%eax
  804667:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  80466a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80466d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  804670:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804677:	eb 17                	jmp    804690 <realloc_block+0xdf>
    dst[i] = src[i];
  804679:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80467c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80467f:	01 c2                	add    %eax,%edx
  804681:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  804684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804687:	01 c8                	add    %ecx,%eax
  804689:	8a 00                	mov    (%eax),%al
  80468b:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80468d:	ff 45 f4             	incl   -0xc(%ebp)
  804690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804693:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804696:	72 e1                	jb     804679 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  804698:	83 ec 0c             	sub    $0xc,%esp
  80469b:	ff 75 08             	pushl  0x8(%ebp)
  80469e:	e8 50 fb ff ff       	call   8041f3 <free_block>
  8046a3:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8046a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8046a9:	c9                   	leave  
  8046aa:	c3                   	ret    
  8046ab:	90                   	nop

008046ac <__udivdi3>:
  8046ac:	55                   	push   %ebp
  8046ad:	57                   	push   %edi
  8046ae:	56                   	push   %esi
  8046af:	53                   	push   %ebx
  8046b0:	83 ec 1c             	sub    $0x1c,%esp
  8046b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8046b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8046bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8046c3:	89 ca                	mov    %ecx,%edx
  8046c5:	89 f8                	mov    %edi,%eax
  8046c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8046cb:	85 f6                	test   %esi,%esi
  8046cd:	75 2d                	jne    8046fc <__udivdi3+0x50>
  8046cf:	39 cf                	cmp    %ecx,%edi
  8046d1:	77 65                	ja     804738 <__udivdi3+0x8c>
  8046d3:	89 fd                	mov    %edi,%ebp
  8046d5:	85 ff                	test   %edi,%edi
  8046d7:	75 0b                	jne    8046e4 <__udivdi3+0x38>
  8046d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8046de:	31 d2                	xor    %edx,%edx
  8046e0:	f7 f7                	div    %edi
  8046e2:	89 c5                	mov    %eax,%ebp
  8046e4:	31 d2                	xor    %edx,%edx
  8046e6:	89 c8                	mov    %ecx,%eax
  8046e8:	f7 f5                	div    %ebp
  8046ea:	89 c1                	mov    %eax,%ecx
  8046ec:	89 d8                	mov    %ebx,%eax
  8046ee:	f7 f5                	div    %ebp
  8046f0:	89 cf                	mov    %ecx,%edi
  8046f2:	89 fa                	mov    %edi,%edx
  8046f4:	83 c4 1c             	add    $0x1c,%esp
  8046f7:	5b                   	pop    %ebx
  8046f8:	5e                   	pop    %esi
  8046f9:	5f                   	pop    %edi
  8046fa:	5d                   	pop    %ebp
  8046fb:	c3                   	ret    
  8046fc:	39 ce                	cmp    %ecx,%esi
  8046fe:	77 28                	ja     804728 <__udivdi3+0x7c>
  804700:	0f bd fe             	bsr    %esi,%edi
  804703:	83 f7 1f             	xor    $0x1f,%edi
  804706:	75 40                	jne    804748 <__udivdi3+0x9c>
  804708:	39 ce                	cmp    %ecx,%esi
  80470a:	72 0a                	jb     804716 <__udivdi3+0x6a>
  80470c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804710:	0f 87 9e 00 00 00    	ja     8047b4 <__udivdi3+0x108>
  804716:	b8 01 00 00 00       	mov    $0x1,%eax
  80471b:	89 fa                	mov    %edi,%edx
  80471d:	83 c4 1c             	add    $0x1c,%esp
  804720:	5b                   	pop    %ebx
  804721:	5e                   	pop    %esi
  804722:	5f                   	pop    %edi
  804723:	5d                   	pop    %ebp
  804724:	c3                   	ret    
  804725:	8d 76 00             	lea    0x0(%esi),%esi
  804728:	31 ff                	xor    %edi,%edi
  80472a:	31 c0                	xor    %eax,%eax
  80472c:	89 fa                	mov    %edi,%edx
  80472e:	83 c4 1c             	add    $0x1c,%esp
  804731:	5b                   	pop    %ebx
  804732:	5e                   	pop    %esi
  804733:	5f                   	pop    %edi
  804734:	5d                   	pop    %ebp
  804735:	c3                   	ret    
  804736:	66 90                	xchg   %ax,%ax
  804738:	89 d8                	mov    %ebx,%eax
  80473a:	f7 f7                	div    %edi
  80473c:	31 ff                	xor    %edi,%edi
  80473e:	89 fa                	mov    %edi,%edx
  804740:	83 c4 1c             	add    $0x1c,%esp
  804743:	5b                   	pop    %ebx
  804744:	5e                   	pop    %esi
  804745:	5f                   	pop    %edi
  804746:	5d                   	pop    %ebp
  804747:	c3                   	ret    
  804748:	bd 20 00 00 00       	mov    $0x20,%ebp
  80474d:	89 eb                	mov    %ebp,%ebx
  80474f:	29 fb                	sub    %edi,%ebx
  804751:	89 f9                	mov    %edi,%ecx
  804753:	d3 e6                	shl    %cl,%esi
  804755:	89 c5                	mov    %eax,%ebp
  804757:	88 d9                	mov    %bl,%cl
  804759:	d3 ed                	shr    %cl,%ebp
  80475b:	89 e9                	mov    %ebp,%ecx
  80475d:	09 f1                	or     %esi,%ecx
  80475f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804763:	89 f9                	mov    %edi,%ecx
  804765:	d3 e0                	shl    %cl,%eax
  804767:	89 c5                	mov    %eax,%ebp
  804769:	89 d6                	mov    %edx,%esi
  80476b:	88 d9                	mov    %bl,%cl
  80476d:	d3 ee                	shr    %cl,%esi
  80476f:	89 f9                	mov    %edi,%ecx
  804771:	d3 e2                	shl    %cl,%edx
  804773:	8b 44 24 08          	mov    0x8(%esp),%eax
  804777:	88 d9                	mov    %bl,%cl
  804779:	d3 e8                	shr    %cl,%eax
  80477b:	09 c2                	or     %eax,%edx
  80477d:	89 d0                	mov    %edx,%eax
  80477f:	89 f2                	mov    %esi,%edx
  804781:	f7 74 24 0c          	divl   0xc(%esp)
  804785:	89 d6                	mov    %edx,%esi
  804787:	89 c3                	mov    %eax,%ebx
  804789:	f7 e5                	mul    %ebp
  80478b:	39 d6                	cmp    %edx,%esi
  80478d:	72 19                	jb     8047a8 <__udivdi3+0xfc>
  80478f:	74 0b                	je     80479c <__udivdi3+0xf0>
  804791:	89 d8                	mov    %ebx,%eax
  804793:	31 ff                	xor    %edi,%edi
  804795:	e9 58 ff ff ff       	jmp    8046f2 <__udivdi3+0x46>
  80479a:	66 90                	xchg   %ax,%ax
  80479c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047a0:	89 f9                	mov    %edi,%ecx
  8047a2:	d3 e2                	shl    %cl,%edx
  8047a4:	39 c2                	cmp    %eax,%edx
  8047a6:	73 e9                	jae    804791 <__udivdi3+0xe5>
  8047a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8047ab:	31 ff                	xor    %edi,%edi
  8047ad:	e9 40 ff ff ff       	jmp    8046f2 <__udivdi3+0x46>
  8047b2:	66 90                	xchg   %ax,%ax
  8047b4:	31 c0                	xor    %eax,%eax
  8047b6:	e9 37 ff ff ff       	jmp    8046f2 <__udivdi3+0x46>
  8047bb:	90                   	nop

008047bc <__umoddi3>:
  8047bc:	55                   	push   %ebp
  8047bd:	57                   	push   %edi
  8047be:	56                   	push   %esi
  8047bf:	53                   	push   %ebx
  8047c0:	83 ec 1c             	sub    $0x1c,%esp
  8047c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8047c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8047cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8047d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8047db:	89 f3                	mov    %esi,%ebx
  8047dd:	89 fa                	mov    %edi,%edx
  8047df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047e3:	89 34 24             	mov    %esi,(%esp)
  8047e6:	85 c0                	test   %eax,%eax
  8047e8:	75 1a                	jne    804804 <__umoddi3+0x48>
  8047ea:	39 f7                	cmp    %esi,%edi
  8047ec:	0f 86 a2 00 00 00    	jbe    804894 <__umoddi3+0xd8>
  8047f2:	89 c8                	mov    %ecx,%eax
  8047f4:	89 f2                	mov    %esi,%edx
  8047f6:	f7 f7                	div    %edi
  8047f8:	89 d0                	mov    %edx,%eax
  8047fa:	31 d2                	xor    %edx,%edx
  8047fc:	83 c4 1c             	add    $0x1c,%esp
  8047ff:	5b                   	pop    %ebx
  804800:	5e                   	pop    %esi
  804801:	5f                   	pop    %edi
  804802:	5d                   	pop    %ebp
  804803:	c3                   	ret    
  804804:	39 f0                	cmp    %esi,%eax
  804806:	0f 87 ac 00 00 00    	ja     8048b8 <__umoddi3+0xfc>
  80480c:	0f bd e8             	bsr    %eax,%ebp
  80480f:	83 f5 1f             	xor    $0x1f,%ebp
  804812:	0f 84 ac 00 00 00    	je     8048c4 <__umoddi3+0x108>
  804818:	bf 20 00 00 00       	mov    $0x20,%edi
  80481d:	29 ef                	sub    %ebp,%edi
  80481f:	89 fe                	mov    %edi,%esi
  804821:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804825:	89 e9                	mov    %ebp,%ecx
  804827:	d3 e0                	shl    %cl,%eax
  804829:	89 d7                	mov    %edx,%edi
  80482b:	89 f1                	mov    %esi,%ecx
  80482d:	d3 ef                	shr    %cl,%edi
  80482f:	09 c7                	or     %eax,%edi
  804831:	89 e9                	mov    %ebp,%ecx
  804833:	d3 e2                	shl    %cl,%edx
  804835:	89 14 24             	mov    %edx,(%esp)
  804838:	89 d8                	mov    %ebx,%eax
  80483a:	d3 e0                	shl    %cl,%eax
  80483c:	89 c2                	mov    %eax,%edx
  80483e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804842:	d3 e0                	shl    %cl,%eax
  804844:	89 44 24 04          	mov    %eax,0x4(%esp)
  804848:	8b 44 24 08          	mov    0x8(%esp),%eax
  80484c:	89 f1                	mov    %esi,%ecx
  80484e:	d3 e8                	shr    %cl,%eax
  804850:	09 d0                	or     %edx,%eax
  804852:	d3 eb                	shr    %cl,%ebx
  804854:	89 da                	mov    %ebx,%edx
  804856:	f7 f7                	div    %edi
  804858:	89 d3                	mov    %edx,%ebx
  80485a:	f7 24 24             	mull   (%esp)
  80485d:	89 c6                	mov    %eax,%esi
  80485f:	89 d1                	mov    %edx,%ecx
  804861:	39 d3                	cmp    %edx,%ebx
  804863:	0f 82 87 00 00 00    	jb     8048f0 <__umoddi3+0x134>
  804869:	0f 84 91 00 00 00    	je     804900 <__umoddi3+0x144>
  80486f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804873:	29 f2                	sub    %esi,%edx
  804875:	19 cb                	sbb    %ecx,%ebx
  804877:	89 d8                	mov    %ebx,%eax
  804879:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80487d:	d3 e0                	shl    %cl,%eax
  80487f:	89 e9                	mov    %ebp,%ecx
  804881:	d3 ea                	shr    %cl,%edx
  804883:	09 d0                	or     %edx,%eax
  804885:	89 e9                	mov    %ebp,%ecx
  804887:	d3 eb                	shr    %cl,%ebx
  804889:	89 da                	mov    %ebx,%edx
  80488b:	83 c4 1c             	add    $0x1c,%esp
  80488e:	5b                   	pop    %ebx
  80488f:	5e                   	pop    %esi
  804890:	5f                   	pop    %edi
  804891:	5d                   	pop    %ebp
  804892:	c3                   	ret    
  804893:	90                   	nop
  804894:	89 fd                	mov    %edi,%ebp
  804896:	85 ff                	test   %edi,%edi
  804898:	75 0b                	jne    8048a5 <__umoddi3+0xe9>
  80489a:	b8 01 00 00 00       	mov    $0x1,%eax
  80489f:	31 d2                	xor    %edx,%edx
  8048a1:	f7 f7                	div    %edi
  8048a3:	89 c5                	mov    %eax,%ebp
  8048a5:	89 f0                	mov    %esi,%eax
  8048a7:	31 d2                	xor    %edx,%edx
  8048a9:	f7 f5                	div    %ebp
  8048ab:	89 c8                	mov    %ecx,%eax
  8048ad:	f7 f5                	div    %ebp
  8048af:	89 d0                	mov    %edx,%eax
  8048b1:	e9 44 ff ff ff       	jmp    8047fa <__umoddi3+0x3e>
  8048b6:	66 90                	xchg   %ax,%ax
  8048b8:	89 c8                	mov    %ecx,%eax
  8048ba:	89 f2                	mov    %esi,%edx
  8048bc:	83 c4 1c             	add    $0x1c,%esp
  8048bf:	5b                   	pop    %ebx
  8048c0:	5e                   	pop    %esi
  8048c1:	5f                   	pop    %edi
  8048c2:	5d                   	pop    %ebp
  8048c3:	c3                   	ret    
  8048c4:	3b 04 24             	cmp    (%esp),%eax
  8048c7:	72 06                	jb     8048cf <__umoddi3+0x113>
  8048c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8048cd:	77 0f                	ja     8048de <__umoddi3+0x122>
  8048cf:	89 f2                	mov    %esi,%edx
  8048d1:	29 f9                	sub    %edi,%ecx
  8048d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8048d7:	89 14 24             	mov    %edx,(%esp)
  8048da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8048e2:	8b 14 24             	mov    (%esp),%edx
  8048e5:	83 c4 1c             	add    $0x1c,%esp
  8048e8:	5b                   	pop    %ebx
  8048e9:	5e                   	pop    %esi
  8048ea:	5f                   	pop    %edi
  8048eb:	5d                   	pop    %ebp
  8048ec:	c3                   	ret    
  8048ed:	8d 76 00             	lea    0x0(%esi),%esi
  8048f0:	2b 04 24             	sub    (%esp),%eax
  8048f3:	19 fa                	sbb    %edi,%edx
  8048f5:	89 d1                	mov    %edx,%ecx
  8048f7:	89 c6                	mov    %eax,%esi
  8048f9:	e9 71 ff ff ff       	jmp    80486f <__umoddi3+0xb3>
  8048fe:	66 90                	xchg   %ax,%ax
  804900:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804904:	72 ea                	jb     8048f0 <__umoddi3+0x134>
  804906:	89 d9                	mov    %ebx,%ecx
  804908:	e9 62 ff ff ff       	jmp    80486f <__umoddi3+0xb3>
