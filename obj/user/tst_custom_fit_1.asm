
obj/user/tst_custom_fit_1:     file format elf32-i386


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
  800031:	e8 1c 1a 00 00       	call   801a52 <libmain>
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
  800067:	e8 90 3b 00 00       	call   803bfc <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 d3 3b 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 54 34 00 00       	call   80351b <malloc>
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
  8000df:	e8 18 3b 00 00       	call   803bfc <sys_calculate_free_frames>
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
  800125:	68 20 50 80 00       	push   $0x805020
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 ec 1d 00 00       	call   801f1d <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 0e 3b 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 50 80 00       	push   $0x80509c
  800150:	6a 0c                	push   $0xc
  800152:	e8 c6 1d 00 00       	call   801f1d <cprintf_colored>
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
  800174:	e8 83 3a 00 00       	call   803bfc <sys_calculate_free_frames>
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
  8001b9:	e8 3e 3a 00 00       	call   803bfc <sys_calculate_free_frames>
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
  8001f8:	68 14 51 80 00       	push   $0x805114
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 19 1d 00 00       	call   801f1d <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 3b 3a 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 51 80 00       	push   $0x8051a0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 ec 1c 00 00       	call   801f1d <cprintf_colored>
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
  800270:	e8 49 3d 00 00       	call   803fbe <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 52 80 00       	push   $0x805218
  80028f:	6a 0c                	push   $0xc
  800291:	e8 87 1c 00 00       	call   801f1d <cprintf_colored>
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
  8002ae:	e8 49 39 00 00       	call   803bfc <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 8c 39 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 ce 33 00 00       	call   80369f <free>
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
  8002fc:	e8 46 39 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 52 80 00       	push   $0x805250
  800318:	6a 0c                	push   $0xc
  80031a:	e8 fe 1b 00 00       	call   801f1d <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 d5 38 00 00       	call   803bfc <sys_calculate_free_frames>
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
  80035f:	68 9c 52 80 00       	push   $0x80529c
  800364:	6a 0c                	push   $0xc
  800366:	e8 b2 1b 00 00       	call   801f1d <cprintf_colored>
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
  8003bd:	e8 fc 3b 00 00       	call   803fbe <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 f8 52 80 00       	push   $0x8052f8
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 3a 1b 00 00       	call   801f1d <cprintf_colored>
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
  800433:	68 30 53 80 00       	push   $0x805330
  800438:	6a 03                	push   $0x3
  80043a:	e8 de 1a 00 00       	call   801f1d <cprintf_colored>
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
  8004fc:	68 60 53 80 00       	push   $0x805360
  800501:	6a 0c                	push   $0xc
  800503:	e8 15 1a 00 00       	call   801f1d <cprintf_colored>
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
  8005d6:	68 60 53 80 00       	push   $0x805360
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 3b 19 00 00       	call   801f1d <cprintf_colored>
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
  8006b0:	68 60 53 80 00       	push   $0x805360
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 61 18 00 00       	call   801f1d <cprintf_colored>
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
  80078a:	68 60 53 80 00       	push   $0x805360
  80078f:	6a 0c                	push   $0xc
  800791:	e8 87 17 00 00       	call   801f1d <cprintf_colored>
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
  800864:	68 60 53 80 00       	push   $0x805360
  800869:	6a 0c                	push   $0xc
  80086b:	e8 ad 16 00 00       	call   801f1d <cprintf_colored>
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
  80093e:	68 60 53 80 00       	push   $0x805360
  800943:	6a 0c                	push   $0xc
  800945:	e8 d3 15 00 00       	call   801f1d <cprintf_colored>
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
  800a33:	68 60 53 80 00       	push   $0x805360
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 de 14 00 00       	call   801f1d <cprintf_colored>
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
  800b31:	68 60 53 80 00       	push   $0x805360
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 e0 13 00 00       	call   801f1d <cprintf_colored>
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
  800c2f:	68 60 53 80 00       	push   $0x805360
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 e2 12 00 00       	call   801f1d <cprintf_colored>
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
  800d2d:	68 60 53 80 00       	push   $0x805360
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 e4 11 00 00       	call   801f1d <cprintf_colored>
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
  800e1a:	68 60 53 80 00       	push   $0x805360
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 f7 10 00 00       	call   801f1d <cprintf_colored>
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
  800f07:	68 60 53 80 00       	push   $0x805360
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 0a 10 00 00       	call   801f1d <cprintf_colored>
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
  800ff4:	68 60 53 80 00       	push   $0x805360
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 1d 0f 00 00       	call   801f1d <cprintf_colored>
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
  801017:	68 b2 53 80 00       	push   $0x8053b2
  80101c:	6a 03                	push   $0x3
  80101e:	e8 fa 0e 00 00       	call   801f1d <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 c0 2b 00 00       	call   803bfc <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 00 2c 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
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
  801072:	e8 a4 24 00 00       	call   80351b <malloc>
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
  8010a1:	68 d0 53 80 00       	push   $0x8053d0
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 70 0e 00 00       	call   801f1d <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 92 2b 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 0c 54 80 00       	push   $0x80540c
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 44 0e 00 00       	call   801f1d <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 1b 2b 00 00       	call   803bfc <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 7c 54 80 00       	push   $0x80547c
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 18 0e 00 00       	call   801f1d <cprintf_colored>
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
  80111f:	57                   	push   %edi
  801120:	81 ec e4 00 00 00    	sub    $0xe4,%esp
#if USE_KHEAP

	sys_set_uheap_strategy(UHP_PLACE_CUSTOMFIT);
  801126:	83 ec 0c             	sub    $0xc,%esp
  801129:	6a 05                	push   $0x5
  80112b:	e8 29 2e 00 00       	call   803f59 <sys_set_uheap_strategy>
  801130:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801133:	a1 00 72 80 00       	mov    0x807200,%eax
  801138:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80113e:	a1 00 72 80 00       	mov    0x807200,%eax
  801143:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801149:	39 c2                	cmp    %eax,%edx
  80114b:	72 14                	jb     801161 <_main+0x45>
			panic("Please increase the WS size");
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	68 c4 54 80 00       	push   $0x8054c4
  801155:	6a 18                	push   $0x18
  801157:	68 e0 54 80 00       	push   $0x8054e0
  80115c:	e8 a1 0a 00 00       	call   801c02 <_panic>
	}
	/*=================================================*/
	int correct = 1;
  801161:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	int eval;
	int expectedNumOfTables;

	//1. Alloc some spaces in PAGE allocator
	cprintf_colored(TEXT_cyan,"%~\n1. Alloc some spaces in PAGE allocator\n");
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	68 f8 54 80 00       	push   $0x8054f8
  801170:	6a 03                	push   $0x3
  801172:	e8 a6 0d 00 00       	call   801f1d <cprintf_colored>
  801177:	83 c4 10             	add    $0x10,%esp
	{
		eval = initial_page_allocations();
  80117a:	e8 6c f2 ff ff       	call   8003eb <initial_page_allocations>
  80117f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (eval != 100)
  801182:	83 7d f0 64          	cmpl   $0x64,-0x10(%ebp)
  801186:	74 17                	je     80119f <_main+0x83>
		{
			cprintf_colored(TEXT_TESTERR_CLR,"initial allocations are not correct!\nplease make sure the the kmalloc test is correct before testing the kfree\n");
  801188:	83 ec 08             	sub    $0x8,%esp
  80118b:	68 24 55 80 00       	push   $0x805524
  801190:	6a 0c                	push   $0xc
  801192:	e8 86 0d 00 00       	call   801f1d <cprintf_colored>
  801197:	83 c4 10             	add    $0x10,%esp
			return ;
  80119a:	e9 ae 08 00 00       	jmp    801a4d <_main+0x931>
		}
	}
	eval = 0;
  80119f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//2. Free some allocations to create initial holes
	cprintf_colored(TEXT_cyan,"%~\n2. Free some allocations to create initial holes [5%]\n");
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	68 94 55 80 00       	push   $0x805594
  8011ae:	6a 03                	push   $0x3
  8011b0:	e8 68 0d 00 00       	call   801f1d <cprintf_colored>
  8011b5:	83 c4 10             	add    $0x10,%esp
	correct = 1;
  8011b8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	{
		//3 MB Hole
		correct = freeSpaceInPageAlloc(1, 1);
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	6a 01                	push   $0x1
  8011c4:	6a 01                	push   $0x1
  8011c6:	e8 d6 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//2nd 4 MB Hole
		correct = freeSpaceInPageAlloc(3, 1);
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	6a 01                	push   $0x1
  8011d6:	6a 03                	push   $0x3
  8011d8:	e8 c4 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//2nd 1 MB Hole
		correct = freeSpaceInPageAlloc(5, 1);
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	6a 01                	push   $0x1
  8011e8:	6a 05                	push   $0x5
  8011ea:	e8 b2 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//2nd 2 MB Hole
		correct = freeSpaceInPageAlloc(7, 1);
  8011f5:	83 ec 08             	sub    $0x8,%esp
  8011f8:	6a 01                	push   $0x1
  8011fa:	6a 07                	push   $0x7
  8011fc:	e8 a0 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if (correct) eval += 5;
  801207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120b:	74 04                	je     801211 <_main+0xf5>
  80120d:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//3. Check content of un-freed spaces
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
  801218:	8d 95 18 ff ff ff    	lea    -0xe8(%ebp),%edx
  80121e:	b9 28 00 00 00       	mov    $0x28,%ecx
  801223:	b8 00 00 00 00       	mov    $0x0,%eax
  801228:	89 d7                	mov    %edx,%edi
  80122a:	f3 ab                	rep stos %eax,%es:(%edi)
	cprintf_colored(TEXT_cyan,"%~\n3. Check content of un-freed spaces [5%]\n");
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	68 d0 55 80 00       	push   $0x8055d0
  801234:	6a 03                	push   $0x3
  801236:	e8 e2 0c 00 00       	call   801f1d <cprintf_colored>
  80123b:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 0; i < allocIndex; ++i)
  80123e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801245:	e9 c2 00 00 00       	jmp    80130c <_main+0x1f0>
		{
			//skip the freed spaces
			if (i == 1 || i == 3 || i == 5 || i == 7)
  80124a:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80124e:	0f 84 b4 00 00 00    	je     801308 <_main+0x1ec>
  801254:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
  801258:	0f 84 aa 00 00 00    	je     801308 <_main+0x1ec>
  80125e:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
  801262:	0f 84 a0 00 00 00    	je     801308 <_main+0x1ec>
  801268:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80126c:	0f 84 96 00 00 00    	je     801308 <_main+0x1ec>
				continue;
			char* ptr = (char*)ptr_allocations[i];
  801272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801275:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80127c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			sums[i] += ptr[0] ;
  80127f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801282:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  801289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	0f be c0             	movsbl %al,%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801296:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			sums[i] += ptr[lastIndices[i]] ;
  80129d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a0:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  8012a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012aa:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
  8012b1:	89 c1                	mov    %eax,%ecx
  8012b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b6:	01 c8                	add    %ecx,%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	01 c2                	add    %eax,%edx
  8012bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012c2:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			if (sums[i] != (maxByte + maxByte))
  8012c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012cc:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  8012d3:	3d fe 00 00 00       	cmp    $0xfe,%eax
  8012d8:	74 2f                	je     801309 <_main+0x1ed>
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
  8012da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8012e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e4:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	50                   	push   %eax
  8012ef:	68 fe 00 00 00       	push   $0xfe
  8012f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f7:	68 00 56 80 00       	push   $0x805600
  8012fc:	6a 0c                	push   $0xc
  8012fe:	e8 1a 0c 00 00       	call   801f1d <cprintf_colored>
  801303:	83 c4 20             	add    $0x20,%esp
  801306:	eb 01                	jmp    801309 <_main+0x1ed>
	{
		for (int i = 0; i < allocIndex; ++i)
		{
			//skip the freed spaces
			if (i == 1 || i == 3 || i == 5 || i == 7)
				continue;
  801308:	90                   	nop

	//3. Check content of un-freed spaces
	uint32 sums[MAX_NUM_OF_ALLOCS] = {0};
	cprintf_colored(TEXT_cyan,"%~\n3. Check content of un-freed spaces [5%]\n");
	{
		for (int i = 0; i < allocIndex; ++i)
  801309:	ff 45 ec             	incl   -0x14(%ebp)
  80130c:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  801311:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801314:	0f 8c 30 ff ff ff    	jl     80124a <_main+0x12e>
			sums[i] += ptr[lastIndices[i]] ;
			if (sums[i] != (maxByte + maxByte))
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
		}
	}
	if (correct) eval += 5;
  80131a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80131e:	74 04                	je     801324 <_main+0x208>
  801320:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  801324:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//4. Check BREAK
	correct = 1;
  80132b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	uint32 expectedBreak = 0;
  801332:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n4. Check BREAK [5%]\n");
  801339:	83 ec 08             	sub    $0x8,%esp
  80133c:	68 39 56 80 00       	push   $0x805639
  801341:	6a 03                	push   $0x3
  801343:	e8 d5 0b 00 00       	call   801f1d <cprintf_colored>
  801348:	83 c4 10             	add    $0x10,%esp
	{
		expectedBreak = ACTUAL_PAGE_ALLOC_START + totalRequestedSize;
  80134b:	a1 40 f2 81 00       	mov    0x81f240,%eax
  801350:	2d 00 f0 ff 7d       	sub    $0x7dfff000,%eax
  801355:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(uheapPageAllocBreak != expectedBreak)
  801358:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80135d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801360:	74 1f                	je     801381 <_main+0x265>
		{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedBreak, uheapPageAllocBreak);}
  801362:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801369:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80136e:	50                   	push   %eax
  80136f:	ff 75 e0             	pushl  -0x20(%ebp)
  801372:	68 54 56 80 00       	push   $0x805654
  801377:	6a 0c                	push   $0xc
  801379:	e8 9f 0b 00 00       	call   801f1d <cprintf_colored>
  80137e:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval += 5;
  801381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801385:	74 04                	je     80138b <_main+0x26f>
  801387:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  80138b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//5. Allocate after kfree [Test CUSTOM FIT]
	uint32 allocIndex,expectedVA, size = 0;
  801392:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n5. Allocate after free [Test CUSTOM FIT] [30%]\n");
  801399:	83 ec 08             	sub    $0x8,%esp
  80139c:	68 8c 56 80 00       	push   $0x80568c
  8013a1:	6a 03                	push   $0x3
  8013a3:	e8 75 0b 00 00       	call   801f1d <cprintf_colored>
  8013a8:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB [EXACT FIT in 1MB Hole (alloc#5)]
		allocIndex = 14;
  8013ab:	c7 45 d8 0e 00 00 00 	movl   $0xe,-0x28(%ebp)
		size = 1*Mega - kilo;
  8013b2:	c7 45 dc 00 fc 0f 00 	movl   $0xffc00,-0x24(%ebp)
		expectedNumOfTables = 0;
  8013b9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8013c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8013c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013c6:	52                   	push   %edx
  8013c7:	6a 01                	push   $0x1
  8013c9:	ff 75 dc             	pushl  -0x24(%ebp)
  8013cc:	50                   	push   %eax
  8013cd:	e8 87 ec ff ff       	call   800059 <allocSpaceInPageAlloc>
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[5] ; //Address of 1MB Hole
  8013d8:	a1 34 70 80 00       	mov    0x807034,%eax
  8013dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8013e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013e3:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8013ea:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8013ed:	74 2a                	je     801419 <_main+0x2fd>
  8013ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013f9:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	50                   	push   %eax
  801404:	ff 75 d0             	pushl  -0x30(%ebp)
  801407:	ff 75 d8             	pushl  -0x28(%ebp)
  80140a:	68 c0 56 80 00       	push   $0x8056c0
  80140f:	6a 0c                	push   $0xc
  801411:	e8 07 0b 00 00       	call   801f1d <cprintf_colored>
  801416:	83 c4 20             	add    $0x20,%esp

		//1MB + 4KB [WORST FIT in 4MB Hole (alloc#3)]
		allocIndex = 15;
  801419:	c7 45 d8 0f 00 00 00 	movl   $0xf,-0x28(%ebp)
		size = 1*Mega + 4*kilo;
  801420:	c7 45 dc 00 10 10 00 	movl   $0x101000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801427:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80142e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801431:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801434:	52                   	push   %edx
  801435:	6a 01                	push   $0x1
  801437:	ff 75 dc             	pushl  -0x24(%ebp)
  80143a:	50                   	push   %eax
  80143b:	e8 19 ec ff ff       	call   800059 <allocSpaceInPageAlloc>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[3] ; //Address of 4MB Hole
  801446:	a1 2c 70 80 00       	mov    0x80702c,%eax
  80144b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80144e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801451:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801458:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80145b:	74 2a                	je     801487 <_main+0x36b>
  80145d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801464:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801467:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80146e:	83 ec 0c             	sub    $0xc,%esp
  801471:	50                   	push   %eax
  801472:	ff 75 d0             	pushl  -0x30(%ebp)
  801475:	ff 75 d8             	pushl  -0x28(%ebp)
  801478:	68 c0 56 80 00       	push   $0x8056c0
  80147d:	6a 0c                	push   $0xc
  80147f:	e8 99 0a 00 00       	call   801f1d <cprintf_colored>
  801484:	83 c4 20             	add    $0x20,%esp

		//3MB - 4KB [EXACT FIT in remaining area of 4MB Hole (alloc#3)]
		allocIndex = 16;
  801487:	c7 45 d8 10 00 00 00 	movl   $0x10,-0x28(%ebp)
		size = 3*Mega - 4*kilo;
  80148e:	c7 45 dc 00 f0 2f 00 	movl   $0x2ff000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801495:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80149c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80149f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a2:	52                   	push   %edx
  8014a3:	6a 01                	push   $0x1
  8014a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8014a8:	50                   	push   %eax
  8014a9:	e8 ab eb ff ff       	call   800059 <allocSpaceInPageAlloc>
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[3] + 1*Mega + 4*kilo; //1MB.4KB after the Start Address of 4MB Hole
  8014b4:	a1 2c 70 80 00       	mov    0x80702c,%eax
  8014b9:	05 00 10 10 00       	add    $0x101000,%eax
  8014be:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8014c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c4:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8014cb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8014ce:	74 2a                	je     8014fa <_main+0x3de>
  8014d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8014d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014da:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8014e1:	83 ec 0c             	sub    $0xc,%esp
  8014e4:	50                   	push   %eax
  8014e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8014e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8014eb:	68 c0 56 80 00       	push   $0x8056c0
  8014f0:	6a 0c                	push   $0xc
  8014f2:	e8 26 0a 00 00       	call   801f1d <cprintf_colored>
  8014f7:	83 c4 20             	add    $0x20,%esp

		//1.5 MB [WORST FIT in 3MB Hole (alloc#1)]
		allocIndex = 17;
  8014fa:	c7 45 d8 11 00 00 00 	movl   $0x11,-0x28(%ebp)
		size = 1*Mega + Mega/2;
  801501:	c7 45 dc 00 00 18 00 	movl   $0x180000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801508:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80150f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801512:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801515:	52                   	push   %edx
  801516:	6a 01                	push   $0x1
  801518:	ff 75 dc             	pushl  -0x24(%ebp)
  80151b:	50                   	push   %eax
  80151c:	e8 38 eb ff ff       	call   800059 <allocSpaceInPageAlloc>
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[1] ; //Address of 3MB Hole
  801527:	a1 24 70 80 00       	mov    0x807024,%eax
  80152c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80152f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801532:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801539:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80153c:	74 2a                	je     801568 <_main+0x44c>
  80153e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801545:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801548:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	50                   	push   %eax
  801553:	ff 75 d0             	pushl  -0x30(%ebp)
  801556:	ff 75 d8             	pushl  -0x28(%ebp)
  801559:	68 c0 56 80 00       	push   $0x8056c0
  80155e:	6a 0c                	push   $0xc
  801560:	e8 b8 09 00 00       	call   801f1d <cprintf_colored>
  801565:	83 c4 20             	add    $0x20,%esp

		//2.5 MB [EXTEND THE BREAK]
		allocIndex = 18;
  801568:	c7 45 d8 12 00 00 00 	movl   $0x12,-0x28(%ebp)
		size = 2*Mega + Mega/2;
  80156f:	c7 45 dc 00 00 28 00 	movl   $0x280000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801576:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80157d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801580:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801583:	52                   	push   %edx
  801584:	6a 01                	push   $0x1
  801586:	ff 75 dc             	pushl  -0x24(%ebp)
  801589:	50                   	push   %eax
  80158a:	e8 ca ea ff ff       	call   800059 <allocSpaceInPageAlloc>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = expectedBreak ;
  801595:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801598:	89 45 d0             	mov    %eax,-0x30(%ebp)
		expectedBreak += ROUNDUP(size, PAGE_SIZE);
  80159b:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8015a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8015a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015a8:	01 d0                	add    %edx,%eax
  8015aa:	48                   	dec    %eax
  8015ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8015ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b6:	f7 75 cc             	divl   -0x34(%ebp)
  8015b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8015bc:	29 d0                	sub    %edx,%eax
  8015be:	01 45 e0             	add    %eax,-0x20(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA))
  8015c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015c4:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8015cb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8015ce:	74 2a                	je     8015fa <_main+0x4de>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8015d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015da:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8015e1:	83 ec 0c             	sub    $0xc,%esp
  8015e4:	50                   	push   %eax
  8015e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8015e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8015eb:	68 c0 56 80 00       	push   $0x8056c0
  8015f0:	6a 0c                	push   $0xc
  8015f2:	e8 26 09 00 00       	call   801f1d <cprintf_colored>
  8015f7:	83 c4 20             	add    $0x20,%esp
		if(uheapPageAllocBreak != expectedBreak)
  8015fa:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8015ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801602:	74 1f                	je     801623 <_main+0x507>
		{correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"BREAK value is not correct! Expected = %x, Actual = %x\n", expectedBreak, uheapPageAllocBreak);}
  801604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80160b:	a1 50 f2 81 00       	mov    0x81f250,%eax
  801610:	50                   	push   %eax
  801611:	ff 75 e0             	pushl  -0x20(%ebp)
  801614:	68 54 56 80 00       	push   $0x805654
  801619:	6a 0c                	push   $0xc
  80161b:	e8 fd 08 00 00       	call   801f1d <cprintf_colored>
  801620:	83 c4 10             	add    $0x10,%esp

		//Insufficient space
		allocIndex = 19;
  801623:	c7 45 d8 13 00 00 00 	movl   $0x13,-0x28(%ebp)
		expectedVA = 0;
  80162a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		int freeFrames = (int)sys_calculate_free_frames() ;
  801631:	e8 c6 25 00 00       	call   803bfc <sys_calculate_free_frames>
  801636:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int usedDiskFrames = (int)sys_pf_calculate_allocated_pages() ;
  801639:	e8 09 26 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
  80163e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		uint32 restOfUHeap = (USER_HEAP_MAX - ACTUAL_PAGE_ALLOC_START) - expectedBreak ;
  801641:	b8 00 f0 ff 1d       	mov    $0x1dfff000,%eax
  801646:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801649:	89 45 bc             	mov    %eax,-0x44(%ebp)
		ptr_allocations[allocIndex] = malloc(restOfUHeap+1);
  80164c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80164f:	40                   	inc    %eax
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	50                   	push   %eax
  801654:	e8 c2 1e 00 00       	call   80351b <malloc>
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801661:	89 14 85 20 70 80 00 	mov    %edx,0x807020(,%eax,4)
		if (ptr_allocations[allocIndex] != NULL)
  801668:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80166b:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801672:	85 c0                	test   %eax,%eax
  801674:	74 1c                	je     801692 <_main+0x576>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.1 Allocating insufficient space: should return NULL\n", allocIndex); }
  801676:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80167d:	83 ec 04             	sub    $0x4,%esp
  801680:	ff 75 d8             	pushl  -0x28(%ebp)
  801683:	68 10 57 80 00       	push   $0x805710
  801688:	6a 0c                	push   $0xc
  80168a:	e8 8e 08 00 00       	call   801f1d <cprintf_colored>
  80168f:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskFrames) != 0)
  801692:	e8 b0 25 00 00       	call   803c47 <sys_pf_calculate_allocated_pages>
  801697:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80169a:	74 1c                	je     8016b8 <_main+0x59c>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  80169c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8016a9:	68 48 57 80 00       	push   $0x805748
  8016ae:	6a 0c                	push   $0xc
  8016b0:	e8 68 08 00 00       	call   801f1d <cprintf_colored>
  8016b5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0)
  8016b8:	e8 3f 25 00 00       	call   803bfc <sys_calculate_free_frames>
  8016bd:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8016c0:	74 1c                	je     8016de <_main+0x5c2>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8016c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	ff 75 d8             	pushl  -0x28(%ebp)
  8016cf:	68 b8 57 80 00       	push   $0x8057b8
  8016d4:	6a 0c                	push   $0xc
  8016d6:	e8 42 08 00 00       	call   801f1d <cprintf_colored>
  8016db:	83 c4 10             	add    $0x10,%esp
	}
	if (correct) eval+=30;
  8016de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e2:	74 04                	je     8016e8 <_main+0x5cc>
  8016e4:	83 45 f0 1e          	addl   $0x1e,-0x10(%ebp)
	correct = 1;
  8016e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//6. Check content of newly allocated spaces
	cprintf_colored(TEXT_cyan,"%~\n6. Check content of newly allocated spaces [10%]\n");
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	68 00 58 80 00       	push   $0x805800
  8016f7:	6a 03                	push   $0x3
  8016f9:	e8 1f 08 00 00       	call   801f1d <cprintf_colored>
  8016fe:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 14; i < allocIndex; ++i)
  801701:	c7 45 e8 0e 00 00 00 	movl   $0xe,-0x18(%ebp)
  801708:	e9 97 00 00 00       	jmp    8017a4 <_main+0x688>
		{
			char* ptr = (char*)ptr_allocations[i];
  80170d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801710:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801717:	89 45 b8             	mov    %eax,-0x48(%ebp)
			sums[i] += ptr[0] ;
  80171a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80171d:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  801724:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	0f be c0             	movsbl %al,%eax
  80172c:	01 c2                	add    %eax,%edx
  80172e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801731:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			sums[i] += ptr[lastIndices[i]] ;
  801738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80173b:	8b 94 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%edx
  801742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801745:	8b 04 85 c0 70 80 00 	mov    0x8070c0(,%eax,4),%eax
  80174c:	89 c1                	mov    %eax,%ecx
  80174e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801751:	01 c8                	add    %ecx,%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	0f be c0             	movsbl %al,%eax
  801758:	01 c2                	add    %eax,%edx
  80175a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80175d:	89 94 85 18 ff ff ff 	mov    %edx,-0xe8(%ebp,%eax,4)
			if (sums[i] != (maxByte + maxByte))
  801764:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801767:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  80176e:	3d fe 00 00 00       	cmp    $0xfe,%eax
  801773:	74 2c                	je     8017a1 <_main+0x685>
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
  801775:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80177c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177f:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
  801786:	83 ec 0c             	sub    $0xc,%esp
  801789:	50                   	push   %eax
  80178a:	68 fe 00 00 00       	push   $0xfe
  80178f:	ff 75 e8             	pushl  -0x18(%ebp)
  801792:	68 00 56 80 00       	push   $0x805600
  801797:	6a 0c                	push   $0xc
  801799:	e8 7f 07 00 00       	call   801f1d <cprintf_colored>
  80179e:	83 c4 20             	add    $0x20,%esp
	correct = 1;

	//6. Check content of newly allocated spaces
	cprintf_colored(TEXT_cyan,"%~\n6. Check content of newly allocated spaces [10%]\n");
	{
		for (int i = 14; i < allocIndex; ++i)
  8017a1:	ff 45 e8             	incl   -0x18(%ebp)
  8017a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8017aa:	0f 82 5d ff ff ff    	jb     80170d <_main+0x5f1>
			sums[i] += ptr[lastIndices[i]] ;
			if (sums[i] != (maxByte + maxByte))
			{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"invalid content in alloc#%d. Expected = %d, Actual = %d\n", i, 2*maxByte, sums[i]); }
		}
	}
	if (correct) eval += 10;
  8017b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017b4:	74 04                	je     8017ba <_main+0x69e>
  8017b6:	83 45 f0 0a          	addl   $0xa,-0x10(%ebp)
	correct = 1;
  8017ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//7. Free some allocations to create MERGED holes
	correct = 1;
  8017c1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	cprintf_colored(TEXT_cyan,"%~\n7. Free some allocations to create MERGED holes [5%]\n");
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	68 38 58 80 00       	push   $0x805838
  8017d0:	6a 03                	push   $0x3
  8017d2:	e8 46 07 00 00       	call   801f1d <cprintf_colored>
  8017d7:	83 c4 10             	add    $0x10,%esp
	{
		//Free new 3MB allocation inside the 4MB Hole
		correct = freeSpaceInPageAlloc(16,1);
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	6a 01                	push   $0x1
  8017df:	6a 10                	push   $0x10
  8017e1:	e8 bb ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free new 1MB allocation at the beginning of the 4MB Hole (should be MERGED with next 3MB) => 4MB HOLE
		correct = freeSpaceInPageAlloc(15,1);
  8017ec:	83 ec 08             	sub    $0x8,%esp
  8017ef:	6a 01                	push   $0x1
  8017f1:	6a 0f                	push   $0xf
  8017f3:	e8 a9 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free new 1MB allocation at the beginning of the 3MB Hole (should be MERGED with next 1.5MB) => 3MB HOLE
		correct = freeSpaceInPageAlloc(17,1);
  8017fe:	83 ec 08             	sub    $0x8,%esp
  801801:	6a 01                	push   $0x1
  801803:	6a 11                	push   $0x11
  801805:	e8 97 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free new 1MB allocation at the 1MB Hole (NO MERGED)
		correct = freeSpaceInPageAlloc(14,1);
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	6a 01                	push   $0x1
  801815:	6a 0e                	push   $0xe
  801817:	e8 85 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free original 3rd 1MB allocation (should be MERGED with next 2MB hole and the prev 1MB hole) => 4MB HOLE
		correct = freeSpaceInPageAlloc(6,1);
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	6a 01                	push   $0x1
  801827:	6a 06                	push   $0x6
  801829:	e8 73 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	89 45 f4             	mov    %eax,-0xc(%ebp)

		//Free original last 2MB allocation (should be MERGED with the prev 4MB created hole) => 6MB HOLE
		correct = freeSpaceInPageAlloc(8,1);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	6a 01                	push   $0x1
  801839:	6a 08                	push   $0x8
  80183b:	e8 61 ea ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if (correct) eval += 5;
  801846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80184a:	74 04                	je     801850 <_main+0x734>
  80184c:	83 45 f0 05          	addl   $0x5,-0x10(%ebp)
	correct = 1;
  801850:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	//8. Allocate after kfree [Test CUSTOM FIT in MERGED FREE SPACES]
	cprintf_colored(TEXT_cyan,"%~\n8. Allocate after free [Test CUSTOM FIT in MERGED FREE SPACES] [40%]\n");
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	68 74 58 80 00       	push   $0x805874
  80185f:	6a 03                	push   $0x3
  801861:	e8 b7 06 00 00       	call   801f1d <cprintf_colored>
  801866:	83 c4 10             	add    $0x10,%esp
	{
		//3 MB [EXACT FIT in 3MB Hole]
		allocIndex = 20;
  801869:	c7 45 d8 14 00 00 00 	movl   $0x14,-0x28(%ebp)
		size = 3*Mega - kilo;
  801870:	c7 45 dc 00 fc 2f 00 	movl   $0x2ffc00,-0x24(%ebp)
		expectedNumOfTables = 0;
  801877:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80187e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801881:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801884:	52                   	push   %edx
  801885:	6a 01                	push   $0x1
  801887:	ff 75 dc             	pushl  -0x24(%ebp)
  80188a:	50                   	push   %eax
  80188b:	e8 c9 e7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[1] ; //Address of 3MB Hole
  801896:	a1 24 70 80 00       	mov    0x807024,%eax
  80189b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80189e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018a1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8018a8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018ab:	74 2a                	je     8018d7 <_main+0x7bb>
  8018ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8018b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018b7:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	50                   	push   %eax
  8018c2:	ff 75 d0             	pushl  -0x30(%ebp)
  8018c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8018c8:	68 c0 56 80 00       	push   $0x8056c0
  8018cd:	6a 0c                	push   $0xc
  8018cf:	e8 49 06 00 00       	call   801f1d <cprintf_colored>
  8018d4:	83 c4 20             	add    $0x20,%esp

		//3 MB [WORST FIT in 6MB Hole]
		allocIndex = 21;
  8018d7:	c7 45 d8 15 00 00 00 	movl   $0x15,-0x28(%ebp)
		size = 3*Mega - kilo;
  8018de:	c7 45 dc 00 fc 2f 00 	movl   $0x2ffc00,-0x24(%ebp)
		expectedNumOfTables = 0;
  8018e5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8018ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8018ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018f2:	52                   	push   %edx
  8018f3:	6a 01                	push   $0x1
  8018f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8018f8:	50                   	push   %eax
  8018f9:	e8 5b e7 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[5] ; //Address of 6MB Hole
  801904:	a1 34 70 80 00       	mov    0x807034,%eax
  801909:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80190c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80190f:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801916:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801919:	74 2a                	je     801945 <_main+0x829>
  80191b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801922:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801925:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80192c:	83 ec 0c             	sub    $0xc,%esp
  80192f:	50                   	push   %eax
  801930:	ff 75 d0             	pushl  -0x30(%ebp)
  801933:	ff 75 d8             	pushl  -0x28(%ebp)
  801936:	68 c0 56 80 00       	push   $0x8056c0
  80193b:	6a 0c                	push   $0xc
  80193d:	e8 db 05 00 00       	call   801f1d <cprintf_colored>
  801942:	83 c4 20             	add    $0x20,%esp

		//3MB - 4KB [WORST FIT in 4MB Hole]
		allocIndex = 22;
  801945:	c7 45 d8 16 00 00 00 	movl   $0x16,-0x28(%ebp)
		size = 3*Mega - 4*kilo;
  80194c:	c7 45 dc 00 f0 2f 00 	movl   $0x2ff000,-0x24(%ebp)
		expectedNumOfTables = 0;
  801953:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  80195a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80195d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801960:	52                   	push   %edx
  801961:	6a 01                	push   $0x1
  801963:	ff 75 dc             	pushl  -0x24(%ebp)
  801966:	50                   	push   %eax
  801967:	e8 ed e6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[3] ; //Address of 4MB Hole
  801972:	a1 2c 70 80 00       	mov    0x80702c,%eax
  801977:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  80197a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80197d:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801984:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801987:	74 2a                	je     8019b3 <_main+0x897>
  801989:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801990:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801993:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	50                   	push   %eax
  80199e:	ff 75 d0             	pushl  -0x30(%ebp)
  8019a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8019a4:	68 c0 56 80 00       	push   $0x8056c0
  8019a9:	6a 0c                	push   $0xc
  8019ab:	e8 6d 05 00 00       	call   801f1d <cprintf_colored>
  8019b0:	83 c4 20             	add    $0x20,%esp

		//3 MB [EXACT FIT in remaining of 6MB Hole]
		allocIndex = 23;
  8019b3:	c7 45 d8 17 00 00 00 	movl   $0x17,-0x28(%ebp)
		size = 3*Mega;
  8019ba:	c7 45 dc 00 00 30 00 	movl   $0x300000,-0x24(%ebp)
		expectedNumOfTables = 0;
  8019c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8019c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8019cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ce:	52                   	push   %edx
  8019cf:	6a 01                	push   $0x1
  8019d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8019d4:	50                   	push   %eax
  8019d5:	e8 7f e6 ff ff       	call   800059 <allocSpaceInPageAlloc>
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		expectedVA = (uint32)ptr_allocations[5] + 3*Mega ; //3MB after the start address of 6MB Hole
  8019e0:	a1 34 70 80 00       	mov    0x807034,%eax
  8019e5:	05 00 00 30 00       	add    $0x300000,%eax
  8019ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  8019ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019f0:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8019f7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8019fa:	74 2a                	je     801a26 <_main+0x90a>
  8019fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a06:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	50                   	push   %eax
  801a11:	ff 75 d0             	pushl  -0x30(%ebp)
  801a14:	ff 75 d8             	pushl  -0x28(%ebp)
  801a17:	68 c0 56 80 00       	push   $0x8056c0
  801a1c:	6a 0c                	push   $0xc
  801a1e:	e8 fa 04 00 00       	call   801f1d <cprintf_colored>
  801a23:	83 c4 20             	add    $0x20,%esp
	}
	if (correct) eval += 40;
  801a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a2a:	74 04                	je     801a30 <_main+0x914>
  801a2c:	83 45 f0 28          	addl   $0x28,-0x10(%ebp)
	correct = 1;
  801a30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)


	cprintf_colored(TEXT_light_green, "%~\ntest CUSTOM FIT (1) [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  801a37:	83 ec 04             	sub    $0x4,%esp
  801a3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a3d:	68 c0 58 80 00       	push   $0x8058c0
  801a42:	6a 0a                	push   $0xa
  801a44:	e8 d4 04 00 00       	call   801f1d <cprintf_colored>
  801a49:	83 c4 10             	add    $0x10,%esp

	return;
  801a4c:	90                   	nop
#endif
}
  801a4d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	57                   	push   %edi
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801a5b:	e8 65 23 00 00       	call   803dc5 <sys_getenvindex>
  801a60:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801a63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a66:	89 d0                	mov    %edx,%eax
  801a68:	01 c0                	add    %eax,%eax
  801a6a:	01 d0                	add    %edx,%eax
  801a6c:	c1 e0 02             	shl    $0x2,%eax
  801a6f:	01 d0                	add    %edx,%eax
  801a71:	c1 e0 02             	shl    $0x2,%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c1 e0 03             	shl    $0x3,%eax
  801a79:	01 d0                	add    %edx,%eax
  801a7b:	c1 e0 02             	shl    $0x2,%eax
  801a7e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a83:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801a88:	a1 00 72 80 00       	mov    0x807200,%eax
  801a8d:	8a 40 20             	mov    0x20(%eax),%al
  801a90:	84 c0                	test   %al,%al
  801a92:	74 0d                	je     801aa1 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801a94:	a1 00 72 80 00       	mov    0x807200,%eax
  801a99:	83 c0 20             	add    $0x20,%eax
  801a9c:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aa5:	7e 0a                	jle    801ab1 <libmain+0x5f>
		binaryname = argv[0];
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	8b 00                	mov    (%eax),%eax
  801aac:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801ab1:	83 ec 08             	sub    $0x8,%esp
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	ff 75 08             	pushl  0x8(%ebp)
  801aba:	e8 5d f6 ff ff       	call   80111c <_main>
  801abf:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801ac2:	a1 00 70 80 00       	mov    0x807000,%eax
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	0f 84 01 01 00 00    	je     801bd0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801acf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801ad5:	bb f8 59 80 00       	mov    $0x8059f8,%ebx
  801ada:	ba 0e 00 00 00       	mov    $0xe,%edx
  801adf:	89 c7                	mov    %eax,%edi
  801ae1:	89 de                	mov    %ebx,%esi
  801ae3:	89 d1                	mov    %edx,%ecx
  801ae5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801ae7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801aea:	b9 56 00 00 00       	mov    $0x56,%ecx
  801aef:	b0 00                	mov    $0x0,%al
  801af1:	89 d7                	mov    %edx,%edi
  801af3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801af5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801afc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801aff:	83 ec 08             	sub    $0x8,%esp
  801b02:	50                   	push   %eax
  801b03:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801b09:	50                   	push   %eax
  801b0a:	e8 ec 24 00 00       	call   803ffb <sys_utilities>
  801b0f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801b12:	e8 35 20 00 00       	call   803b4c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801b17:	83 ec 0c             	sub    $0xc,%esp
  801b1a:	68 18 59 80 00       	push   $0x805918
  801b1f:	e8 cc 03 00 00       	call   801ef0 <cprintf>
  801b24:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	74 18                	je     801b46 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801b2e:	e8 e6 24 00 00       	call   804019 <sys_get_optimal_num_faults>
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	50                   	push   %eax
  801b37:	68 40 59 80 00       	push   $0x805940
  801b3c:	e8 af 03 00 00       	call   801ef0 <cprintf>
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	eb 59                	jmp    801b9f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801b46:	a1 00 72 80 00       	mov    0x807200,%eax
  801b4b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  801b51:	a1 00 72 80 00       	mov    0x807200,%eax
  801b56:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	68 64 59 80 00       	push   $0x805964
  801b66:	e8 85 03 00 00       	call   801ef0 <cprintf>
  801b6b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801b6e:	a1 00 72 80 00       	mov    0x807200,%eax
  801b73:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  801b79:	a1 00 72 80 00       	mov    0x807200,%eax
  801b7e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  801b84:	a1 00 72 80 00       	mov    0x807200,%eax
  801b89:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  801b8f:	51                   	push   %ecx
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	68 8c 59 80 00       	push   $0x80598c
  801b97:	e8 54 03 00 00       	call   801ef0 <cprintf>
  801b9c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801b9f:	a1 00 72 80 00       	mov    0x807200,%eax
  801ba4:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  801baa:	83 ec 08             	sub    $0x8,%esp
  801bad:	50                   	push   %eax
  801bae:	68 e4 59 80 00       	push   $0x8059e4
  801bb3:	e8 38 03 00 00       	call   801ef0 <cprintf>
  801bb8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	68 18 59 80 00       	push   $0x805918
  801bc3:	e8 28 03 00 00       	call   801ef0 <cprintf>
  801bc8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801bcb:	e8 96 1f 00 00       	call   803b66 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801bd0:	e8 1f 00 00 00       	call   801bf4 <exit>
}
  801bd5:	90                   	nop
  801bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd9:	5b                   	pop    %ebx
  801bda:	5e                   	pop    %esi
  801bdb:	5f                   	pop    %edi
  801bdc:	5d                   	pop    %ebp
  801bdd:	c3                   	ret    

00801bde <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801be4:	83 ec 0c             	sub    $0xc,%esp
  801be7:	6a 00                	push   $0x0
  801be9:	e8 a3 21 00 00       	call   803d91 <sys_destroy_env>
  801bee:	83 c4 10             	add    $0x10,%esp
}
  801bf1:	90                   	nop
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <exit>:

void
exit(void)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801bfa:	e8 f8 21 00 00       	call   803df7 <sys_exit_env>
}
  801bff:	90                   	nop
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801c08:	8d 45 10             	lea    0x10(%ebp),%eax
  801c0b:	83 c0 04             	add    $0x4,%eax
  801c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801c11:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801c16:	85 c0                	test   %eax,%eax
  801c18:	74 16                	je     801c30 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801c1a:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801c1f:	83 ec 08             	sub    $0x8,%esp
  801c22:	50                   	push   %eax
  801c23:	68 5c 5a 80 00       	push   $0x805a5c
  801c28:	e8 c3 02 00 00       	call   801ef0 <cprintf>
  801c2d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801c30:	a1 04 70 80 00       	mov    0x807004,%eax
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	ff 75 08             	pushl  0x8(%ebp)
  801c3e:	50                   	push   %eax
  801c3f:	68 64 5a 80 00       	push   $0x805a64
  801c44:	6a 74                	push   $0x74
  801c46:	e8 d2 02 00 00       	call   801f1d <cprintf_colored>
  801c4b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c51:	83 ec 08             	sub    $0x8,%esp
  801c54:	ff 75 f4             	pushl  -0xc(%ebp)
  801c57:	50                   	push   %eax
  801c58:	e8 24 02 00 00       	call   801e81 <vcprintf>
  801c5d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801c60:	83 ec 08             	sub    $0x8,%esp
  801c63:	6a 00                	push   $0x0
  801c65:	68 8c 5a 80 00       	push   $0x805a8c
  801c6a:	e8 12 02 00 00       	call   801e81 <vcprintf>
  801c6f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801c72:	e8 7d ff ff ff       	call   801bf4 <exit>

	// should not return here
	while (1) ;
  801c77:	eb fe                	jmp    801c77 <_panic+0x75>

00801c79 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	53                   	push   %ebx
  801c7d:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801c80:	a1 00 72 80 00       	mov    0x807200,%eax
  801c85:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8e:	39 c2                	cmp    %eax,%edx
  801c90:	74 14                	je     801ca6 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	68 90 5a 80 00       	push   $0x805a90
  801c9a:	6a 26                	push   $0x26
  801c9c:	68 dc 5a 80 00       	push   $0x805adc
  801ca1:	e8 5c ff ff ff       	call   801c02 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ca6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801cad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801cb4:	e9 d9 00 00 00       	jmp    801d92 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  801cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	01 d0                	add    %edx,%eax
  801cc8:	8b 00                	mov    (%eax),%eax
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	75 08                	jne    801cd6 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  801cce:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801cd1:	e9 b9 00 00 00       	jmp    801d8f <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  801cd6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cdd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ce4:	eb 79                	jmp    801d5f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801ce6:	a1 00 72 80 00       	mov    0x807200,%eax
  801ceb:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801cf1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	01 c0                	add    %eax,%eax
  801cf8:	01 d0                	add    %edx,%eax
  801cfa:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801d01:	01 d8                	add    %ebx,%eax
  801d03:	01 d0                	add    %edx,%eax
  801d05:	01 c8                	add    %ecx,%eax
  801d07:	8a 40 04             	mov    0x4(%eax),%al
  801d0a:	84 c0                	test   %al,%al
  801d0c:	75 4e                	jne    801d5c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d0e:	a1 00 72 80 00       	mov    0x807200,%eax
  801d13:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801d19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	01 c0                	add    %eax,%eax
  801d20:	01 d0                	add    %edx,%eax
  801d22:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801d29:	01 d8                	add    %ebx,%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	01 c8                	add    %ecx,%eax
  801d2f:	8b 00                	mov    (%eax),%eax
  801d31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d3c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d41:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	01 c8                	add    %ecx,%eax
  801d4d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d4f:	39 c2                	cmp    %eax,%edx
  801d51:	75 09                	jne    801d5c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  801d53:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801d5a:	eb 19                	jmp    801d75 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d5c:	ff 45 e8             	incl   -0x18(%ebp)
  801d5f:	a1 00 72 80 00       	mov    0x807200,%eax
  801d64:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6d:	39 c2                	cmp    %eax,%edx
  801d6f:	0f 87 71 ff ff ff    	ja     801ce6 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801d75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d79:	75 14                	jne    801d8f <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  801d7b:	83 ec 04             	sub    $0x4,%esp
  801d7e:	68 e8 5a 80 00       	push   $0x805ae8
  801d83:	6a 3a                	push   $0x3a
  801d85:	68 dc 5a 80 00       	push   $0x805adc
  801d8a:	e8 73 fe ff ff       	call   801c02 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801d8f:	ff 45 f0             	incl   -0x10(%ebp)
  801d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d95:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d98:	0f 8c 1b ff ff ff    	jl     801cb9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801d9e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801da5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801dac:	eb 2e                	jmp    801ddc <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801dae:	a1 00 72 80 00       	mov    0x807200,%eax
  801db3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801db9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dbc:	89 d0                	mov    %edx,%eax
  801dbe:	01 c0                	add    %eax,%eax
  801dc0:	01 d0                	add    %edx,%eax
  801dc2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801dc9:	01 d8                	add    %ebx,%eax
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	01 c8                	add    %ecx,%eax
  801dcf:	8a 40 04             	mov    0x4(%eax),%al
  801dd2:	3c 01                	cmp    $0x1,%al
  801dd4:	75 03                	jne    801dd9 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  801dd6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801dd9:	ff 45 e0             	incl   -0x20(%ebp)
  801ddc:	a1 00 72 80 00       	mov    0x807200,%eax
  801de1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dea:	39 c2                	cmp    %eax,%edx
  801dec:	77 c0                	ja     801dae <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801df4:	74 14                	je     801e0a <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	68 3c 5b 80 00       	push   $0x805b3c
  801dfe:	6a 44                	push   $0x44
  801e00:	68 dc 5a 80 00       	push   $0x805adc
  801e05:	e8 f8 fd ff ff       	call   801c02 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801e0a:	90                   	nop
  801e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
  801e14:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	8b 00                	mov    (%eax),%eax
  801e1c:	8d 48 01             	lea    0x1(%eax),%ecx
  801e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e22:	89 0a                	mov    %ecx,(%edx)
  801e24:	8b 55 08             	mov    0x8(%ebp),%edx
  801e27:	88 d1                	mov    %dl,%cl
  801e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e33:	8b 00                	mov    (%eax),%eax
  801e35:	3d ff 00 00 00       	cmp    $0xff,%eax
  801e3a:	75 30                	jne    801e6c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801e3c:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801e42:	a0 24 72 80 00       	mov    0x807224,%al
  801e47:	0f b6 c0             	movzbl %al,%eax
  801e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4d:	8b 09                	mov    (%ecx),%ecx
  801e4f:	89 cb                	mov    %ecx,%ebx
  801e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e54:	83 c1 08             	add    $0x8,%ecx
  801e57:	52                   	push   %edx
  801e58:	50                   	push   %eax
  801e59:	53                   	push   %ebx
  801e5a:	51                   	push   %ecx
  801e5b:	e8 a8 1c 00 00       	call   803b08 <sys_cputs>
  801e60:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6f:	8b 40 04             	mov    0x4(%eax),%eax
  801e72:	8d 50 01             	lea    0x1(%eax),%edx
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e78:	89 50 04             	mov    %edx,0x4(%eax)
}
  801e7b:	90                   	nop
  801e7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801e8a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e91:	00 00 00 
	b.cnt = 0;
  801e94:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801e9b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801eaa:	50                   	push   %eax
  801eab:	68 10 1e 80 00       	push   $0x801e10
  801eb0:	e8 5a 02 00 00       	call   80210f <vprintfmt>
  801eb5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801eb8:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801ebe:	a0 24 72 80 00       	mov    0x807224,%al
  801ec3:	0f b6 c0             	movzbl %al,%eax
  801ec6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801ecc:	52                   	push   %edx
  801ecd:	50                   	push   %eax
  801ece:	51                   	push   %ecx
  801ecf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801ed5:	83 c0 08             	add    $0x8,%eax
  801ed8:	50                   	push   %eax
  801ed9:	e8 2a 1c 00 00       	call   803b08 <sys_cputs>
  801ede:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801ee1:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801ee8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801ef6:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  801efd:	8d 45 0c             	lea    0xc(%ebp),%eax
  801f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	83 ec 08             	sub    $0x8,%esp
  801f09:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0c:	50                   	push   %eax
  801f0d:	e8 6f ff ff ff       	call   801e81 <vcprintf>
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801f23:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	c1 e0 08             	shl    $0x8,%eax
  801f30:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801f35:	8d 45 0c             	lea    0xc(%ebp),%eax
  801f38:	83 c0 04             	add    $0x4,%eax
  801f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f41:	83 ec 08             	sub    $0x8,%esp
  801f44:	ff 75 f4             	pushl  -0xc(%ebp)
  801f47:	50                   	push   %eax
  801f48:	e8 34 ff ff ff       	call   801e81 <vcprintf>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801f53:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801f5a:	07 00 00 

	return cnt;
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801f68:	e8 df 1b 00 00       	call   803b4c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801f6d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7c:	50                   	push   %eax
  801f7d:	e8 ff fe ff ff       	call   801e81 <vcprintf>
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801f88:	e8 d9 1b 00 00       	call   803b66 <sys_unlock_cons>
	return cnt;
  801f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	53                   	push   %ebx
  801f96:	83 ec 14             	sub    $0x14,%esp
  801f99:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801fa5:	8b 45 18             	mov    0x18(%ebp),%eax
  801fa8:	ba 00 00 00 00       	mov    $0x0,%edx
  801fad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801fb0:	77 55                	ja     802007 <printnum+0x75>
  801fb2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801fb5:	72 05                	jb     801fbc <printnum+0x2a>
  801fb7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fba:	77 4b                	ja     802007 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801fbc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801fbf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801fc2:	8b 45 18             	mov    0x18(%ebp),%eax
  801fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fca:	52                   	push   %edx
  801fcb:	50                   	push   %eax
  801fcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcf:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd2:	e8 d5 2d 00 00       	call   804dac <__udivdi3>
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	ff 75 20             	pushl  0x20(%ebp)
  801fe0:	53                   	push   %ebx
  801fe1:	ff 75 18             	pushl  0x18(%ebp)
  801fe4:	52                   	push   %edx
  801fe5:	50                   	push   %eax
  801fe6:	ff 75 0c             	pushl  0xc(%ebp)
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	e8 a1 ff ff ff       	call   801f92 <printnum>
  801ff1:	83 c4 20             	add    $0x20,%esp
  801ff4:	eb 1a                	jmp    802010 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801ff6:	83 ec 08             	sub    $0x8,%esp
  801ff9:	ff 75 0c             	pushl  0xc(%ebp)
  801ffc:	ff 75 20             	pushl  0x20(%ebp)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	ff d0                	call   *%eax
  802004:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802007:	ff 4d 1c             	decl   0x1c(%ebp)
  80200a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80200e:	7f e6                	jg     801ff6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802010:	8b 4d 18             	mov    0x18(%ebp),%ecx
  802013:	bb 00 00 00 00       	mov    $0x0,%ebx
  802018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	53                   	push   %ebx
  80201f:	51                   	push   %ecx
  802020:	52                   	push   %edx
  802021:	50                   	push   %eax
  802022:	e8 95 2e 00 00       	call   804ebc <__umoddi3>
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	05 b4 5d 80 00       	add    $0x805db4,%eax
  80202f:	8a 00                	mov    (%eax),%al
  802031:	0f be c0             	movsbl %al,%eax
  802034:	83 ec 08             	sub    $0x8,%esp
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	50                   	push   %eax
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	ff d0                	call   *%eax
  802040:	83 c4 10             	add    $0x10,%esp
}
  802043:	90                   	nop
  802044:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80204c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  802050:	7e 1c                	jle    80206e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	8b 00                	mov    (%eax),%eax
  802057:	8d 50 08             	lea    0x8(%eax),%edx
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	89 10                	mov    %edx,(%eax)
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	8b 00                	mov    (%eax),%eax
  802064:	83 e8 08             	sub    $0x8,%eax
  802067:	8b 50 04             	mov    0x4(%eax),%edx
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	eb 40                	jmp    8020ae <getuint+0x65>
	else if (lflag)
  80206e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802072:	74 1e                	je     802092 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	8b 00                	mov    (%eax),%eax
  802079:	8d 50 04             	lea    0x4(%eax),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	89 10                	mov    %edx,(%eax)
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	8b 00                	mov    (%eax),%eax
  802086:	83 e8 04             	sub    $0x4,%eax
  802089:	8b 00                	mov    (%eax),%eax
  80208b:	ba 00 00 00 00       	mov    $0x0,%edx
  802090:	eb 1c                	jmp    8020ae <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	8b 00                	mov    (%eax),%eax
  802097:	8d 50 04             	lea    0x4(%eax),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	89 10                	mov    %edx,(%eax)
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	8b 00                	mov    (%eax),%eax
  8020a4:	83 e8 04             	sub    $0x4,%eax
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    

008020b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8020b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8020b7:	7e 1c                	jle    8020d5 <getint+0x25>
		return va_arg(*ap, long long);
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8b 00                	mov    (%eax),%eax
  8020be:	8d 50 08             	lea    0x8(%eax),%edx
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	89 10                	mov    %edx,(%eax)
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	8b 00                	mov    (%eax),%eax
  8020cb:	83 e8 08             	sub    $0x8,%eax
  8020ce:	8b 50 04             	mov    0x4(%eax),%edx
  8020d1:	8b 00                	mov    (%eax),%eax
  8020d3:	eb 38                	jmp    80210d <getint+0x5d>
	else if (lflag)
  8020d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020d9:	74 1a                	je     8020f5 <getint+0x45>
		return va_arg(*ap, long);
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	8d 50 04             	lea    0x4(%eax),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	89 10                	mov    %edx,(%eax)
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	8b 00                	mov    (%eax),%eax
  8020ed:	83 e8 04             	sub    $0x4,%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	99                   	cltd   
  8020f3:	eb 18                	jmp    80210d <getint+0x5d>
	else
		return va_arg(*ap, int);
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	8d 50 04             	lea    0x4(%eax),%edx
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	89 10                	mov    %edx,(%eax)
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	83 e8 04             	sub    $0x4,%eax
  80210a:	8b 00                	mov    (%eax),%eax
  80210c:	99                   	cltd   
}
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    

0080210f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802117:	eb 17                	jmp    802130 <vprintfmt+0x21>
			if (ch == '\0')
  802119:	85 db                	test   %ebx,%ebx
  80211b:	0f 84 c1 03 00 00    	je     8024e2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  802121:	83 ec 08             	sub    $0x8,%esp
  802124:	ff 75 0c             	pushl  0xc(%ebp)
  802127:	53                   	push   %ebx
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	ff d0                	call   *%eax
  80212d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802130:	8b 45 10             	mov    0x10(%ebp),%eax
  802133:	8d 50 01             	lea    0x1(%eax),%edx
  802136:	89 55 10             	mov    %edx,0x10(%ebp)
  802139:	8a 00                	mov    (%eax),%al
  80213b:	0f b6 d8             	movzbl %al,%ebx
  80213e:	83 fb 25             	cmp    $0x25,%ebx
  802141:	75 d6                	jne    802119 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802143:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  802147:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80214e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  802155:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80215c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802163:	8b 45 10             	mov    0x10(%ebp),%eax
  802166:	8d 50 01             	lea    0x1(%eax),%edx
  802169:	89 55 10             	mov    %edx,0x10(%ebp)
  80216c:	8a 00                	mov    (%eax),%al
  80216e:	0f b6 d8             	movzbl %al,%ebx
  802171:	8d 43 dd             	lea    -0x23(%ebx),%eax
  802174:	83 f8 5b             	cmp    $0x5b,%eax
  802177:	0f 87 3d 03 00 00    	ja     8024ba <vprintfmt+0x3ab>
  80217d:	8b 04 85 d8 5d 80 00 	mov    0x805dd8(,%eax,4),%eax
  802184:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  802186:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80218a:	eb d7                	jmp    802163 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80218c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  802190:	eb d1                	jmp    802163 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802192:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  802199:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80219c:	89 d0                	mov    %edx,%eax
  80219e:	c1 e0 02             	shl    $0x2,%eax
  8021a1:	01 d0                	add    %edx,%eax
  8021a3:	01 c0                	add    %eax,%eax
  8021a5:	01 d8                	add    %ebx,%eax
  8021a7:	83 e8 30             	sub    $0x30,%eax
  8021aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8021ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b0:	8a 00                	mov    (%eax),%al
  8021b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8021b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8021b8:	7e 3e                	jle    8021f8 <vprintfmt+0xe9>
  8021ba:	83 fb 39             	cmp    $0x39,%ebx
  8021bd:	7f 39                	jg     8021f8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8021bf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8021c2:	eb d5                	jmp    802199 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8021c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c7:	83 c0 04             	add    $0x4,%eax
  8021ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8021cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d0:	83 e8 04             	sub    $0x4,%eax
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8021d8:	eb 1f                	jmp    8021f9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8021da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021de:	79 83                	jns    802163 <vprintfmt+0x54>
				width = 0;
  8021e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8021e7:	e9 77 ff ff ff       	jmp    802163 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8021ec:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8021f3:	e9 6b ff ff ff       	jmp    802163 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8021f8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8021f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021fd:	0f 89 60 ff ff ff    	jns    802163 <vprintfmt+0x54>
				width = precision, precision = -1;
  802203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802206:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802209:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  802210:	e9 4e ff ff ff       	jmp    802163 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802215:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  802218:	e9 46 ff ff ff       	jmp    802163 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80221d:	8b 45 14             	mov    0x14(%ebp),%eax
  802220:	83 c0 04             	add    $0x4,%eax
  802223:	89 45 14             	mov    %eax,0x14(%ebp)
  802226:	8b 45 14             	mov    0x14(%ebp),%eax
  802229:	83 e8 04             	sub    $0x4,%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	83 ec 08             	sub    $0x8,%esp
  802231:	ff 75 0c             	pushl  0xc(%ebp)
  802234:	50                   	push   %eax
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	ff d0                	call   *%eax
  80223a:	83 c4 10             	add    $0x10,%esp
			break;
  80223d:	e9 9b 02 00 00       	jmp    8024dd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  802242:	8b 45 14             	mov    0x14(%ebp),%eax
  802245:	83 c0 04             	add    $0x4,%eax
  802248:	89 45 14             	mov    %eax,0x14(%ebp)
  80224b:	8b 45 14             	mov    0x14(%ebp),%eax
  80224e:	83 e8 04             	sub    $0x4,%eax
  802251:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  802253:	85 db                	test   %ebx,%ebx
  802255:	79 02                	jns    802259 <vprintfmt+0x14a>
				err = -err;
  802257:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  802259:	83 fb 64             	cmp    $0x64,%ebx
  80225c:	7f 0b                	jg     802269 <vprintfmt+0x15a>
  80225e:	8b 34 9d 20 5c 80 00 	mov    0x805c20(,%ebx,4),%esi
  802265:	85 f6                	test   %esi,%esi
  802267:	75 19                	jne    802282 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  802269:	53                   	push   %ebx
  80226a:	68 c5 5d 80 00       	push   $0x805dc5
  80226f:	ff 75 0c             	pushl  0xc(%ebp)
  802272:	ff 75 08             	pushl  0x8(%ebp)
  802275:	e8 70 02 00 00       	call   8024ea <printfmt>
  80227a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80227d:	e9 5b 02 00 00       	jmp    8024dd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802282:	56                   	push   %esi
  802283:	68 ce 5d 80 00       	push   $0x805dce
  802288:	ff 75 0c             	pushl  0xc(%ebp)
  80228b:	ff 75 08             	pushl  0x8(%ebp)
  80228e:	e8 57 02 00 00       	call   8024ea <printfmt>
  802293:	83 c4 10             	add    $0x10,%esp
			break;
  802296:	e9 42 02 00 00       	jmp    8024dd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80229b:	8b 45 14             	mov    0x14(%ebp),%eax
  80229e:	83 c0 04             	add    $0x4,%eax
  8022a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8022a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a7:	83 e8 04             	sub    $0x4,%eax
  8022aa:	8b 30                	mov    (%eax),%esi
  8022ac:	85 f6                	test   %esi,%esi
  8022ae:	75 05                	jne    8022b5 <vprintfmt+0x1a6>
				p = "(null)";
  8022b0:	be d1 5d 80 00       	mov    $0x805dd1,%esi
			if (width > 0 && padc != '-')
  8022b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022b9:	7e 6d                	jle    802328 <vprintfmt+0x219>
  8022bb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8022bf:	74 67                	je     802328 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8022c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c4:	83 ec 08             	sub    $0x8,%esp
  8022c7:	50                   	push   %eax
  8022c8:	56                   	push   %esi
  8022c9:	e8 1e 03 00 00       	call   8025ec <strnlen>
  8022ce:	83 c4 10             	add    $0x10,%esp
  8022d1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8022d4:	eb 16                	jmp    8022ec <vprintfmt+0x1dd>
					putch(padc, putdat);
  8022d6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8022da:	83 ec 08             	sub    $0x8,%esp
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	50                   	push   %eax
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	ff d0                	call   *%eax
  8022e6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8022e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8022ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022f0:	7f e4                	jg     8022d6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8022f2:	eb 34                	jmp    802328 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8022f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8022f8:	74 1c                	je     802316 <vprintfmt+0x207>
  8022fa:	83 fb 1f             	cmp    $0x1f,%ebx
  8022fd:	7e 05                	jle    802304 <vprintfmt+0x1f5>
  8022ff:	83 fb 7e             	cmp    $0x7e,%ebx
  802302:	7e 12                	jle    802316 <vprintfmt+0x207>
					putch('?', putdat);
  802304:	83 ec 08             	sub    $0x8,%esp
  802307:	ff 75 0c             	pushl  0xc(%ebp)
  80230a:	6a 3f                	push   $0x3f
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	ff d0                	call   *%eax
  802311:	83 c4 10             	add    $0x10,%esp
  802314:	eb 0f                	jmp    802325 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  802316:	83 ec 08             	sub    $0x8,%esp
  802319:	ff 75 0c             	pushl  0xc(%ebp)
  80231c:	53                   	push   %ebx
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	ff d0                	call   *%eax
  802322:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802325:	ff 4d e4             	decl   -0x1c(%ebp)
  802328:	89 f0                	mov    %esi,%eax
  80232a:	8d 70 01             	lea    0x1(%eax),%esi
  80232d:	8a 00                	mov    (%eax),%al
  80232f:	0f be d8             	movsbl %al,%ebx
  802332:	85 db                	test   %ebx,%ebx
  802334:	74 24                	je     80235a <vprintfmt+0x24b>
  802336:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80233a:	78 b8                	js     8022f4 <vprintfmt+0x1e5>
  80233c:	ff 4d e0             	decl   -0x20(%ebp)
  80233f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802343:	79 af                	jns    8022f4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802345:	eb 13                	jmp    80235a <vprintfmt+0x24b>
				putch(' ', putdat);
  802347:	83 ec 08             	sub    $0x8,%esp
  80234a:	ff 75 0c             	pushl  0xc(%ebp)
  80234d:	6a 20                	push   $0x20
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	ff d0                	call   *%eax
  802354:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802357:	ff 4d e4             	decl   -0x1c(%ebp)
  80235a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80235e:	7f e7                	jg     802347 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  802360:	e9 78 01 00 00       	jmp    8024dd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  802365:	83 ec 08             	sub    $0x8,%esp
  802368:	ff 75 e8             	pushl  -0x18(%ebp)
  80236b:	8d 45 14             	lea    0x14(%ebp),%eax
  80236e:	50                   	push   %eax
  80236f:	e8 3c fd ff ff       	call   8020b0 <getint>
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80237a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	85 d2                	test   %edx,%edx
  802385:	79 23                	jns    8023aa <vprintfmt+0x29b>
				putch('-', putdat);
  802387:	83 ec 08             	sub    $0x8,%esp
  80238a:	ff 75 0c             	pushl  0xc(%ebp)
  80238d:	6a 2d                	push   $0x2d
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	ff d0                	call   *%eax
  802394:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  802397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239d:	f7 d8                	neg    %eax
  80239f:	83 d2 00             	adc    $0x0,%edx
  8023a2:	f7 da                	neg    %edx
  8023a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8023aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8023b1:	e9 bc 00 00 00       	jmp    802472 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8023b6:	83 ec 08             	sub    $0x8,%esp
  8023b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8023bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8023bf:	50                   	push   %eax
  8023c0:	e8 84 fc ff ff       	call   802049 <getuint>
  8023c5:	83 c4 10             	add    $0x10,%esp
  8023c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8023ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8023d5:	e9 98 00 00 00       	jmp    802472 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8023da:	83 ec 08             	sub    $0x8,%esp
  8023dd:	ff 75 0c             	pushl  0xc(%ebp)
  8023e0:	6a 58                	push   $0x58
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	ff d0                	call   *%eax
  8023e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8023ea:	83 ec 08             	sub    $0x8,%esp
  8023ed:	ff 75 0c             	pushl  0xc(%ebp)
  8023f0:	6a 58                	push   $0x58
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	ff d0                	call   *%eax
  8023f7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8023fa:	83 ec 08             	sub    $0x8,%esp
  8023fd:	ff 75 0c             	pushl  0xc(%ebp)
  802400:	6a 58                	push   $0x58
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	ff d0                	call   *%eax
  802407:	83 c4 10             	add    $0x10,%esp
			break;
  80240a:	e9 ce 00 00 00       	jmp    8024dd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80240f:	83 ec 08             	sub    $0x8,%esp
  802412:	ff 75 0c             	pushl  0xc(%ebp)
  802415:	6a 30                	push   $0x30
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	ff d0                	call   *%eax
  80241c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80241f:	83 ec 08             	sub    $0x8,%esp
  802422:	ff 75 0c             	pushl  0xc(%ebp)
  802425:	6a 78                	push   $0x78
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	ff d0                	call   *%eax
  80242c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80242f:	8b 45 14             	mov    0x14(%ebp),%eax
  802432:	83 c0 04             	add    $0x4,%eax
  802435:	89 45 14             	mov    %eax,0x14(%ebp)
  802438:	8b 45 14             	mov    0x14(%ebp),%eax
  80243b:	83 e8 04             	sub    $0x4,%eax
  80243e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802440:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802443:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80244a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802451:	eb 1f                	jmp    802472 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802453:	83 ec 08             	sub    $0x8,%esp
  802456:	ff 75 e8             	pushl  -0x18(%ebp)
  802459:	8d 45 14             	lea    0x14(%ebp),%eax
  80245c:	50                   	push   %eax
  80245d:	e8 e7 fb ff ff       	call   802049 <getuint>
  802462:	83 c4 10             	add    $0x10,%esp
  802465:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802468:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80246b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802472:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  802476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	52                   	push   %edx
  80247d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802480:	50                   	push   %eax
  802481:	ff 75 f4             	pushl  -0xc(%ebp)
  802484:	ff 75 f0             	pushl  -0x10(%ebp)
  802487:	ff 75 0c             	pushl  0xc(%ebp)
  80248a:	ff 75 08             	pushl  0x8(%ebp)
  80248d:	e8 00 fb ff ff       	call   801f92 <printnum>
  802492:	83 c4 20             	add    $0x20,%esp
			break;
  802495:	eb 46                	jmp    8024dd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802497:	83 ec 08             	sub    $0x8,%esp
  80249a:	ff 75 0c             	pushl  0xc(%ebp)
  80249d:	53                   	push   %ebx
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	ff d0                	call   *%eax
  8024a3:	83 c4 10             	add    $0x10,%esp
			break;
  8024a6:	eb 35                	jmp    8024dd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8024a8:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  8024af:	eb 2c                	jmp    8024dd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8024b1:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  8024b8:	eb 23                	jmp    8024dd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8024ba:	83 ec 08             	sub    $0x8,%esp
  8024bd:	ff 75 0c             	pushl  0xc(%ebp)
  8024c0:	6a 25                	push   $0x25
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	ff d0                	call   *%eax
  8024c7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8024ca:	ff 4d 10             	decl   0x10(%ebp)
  8024cd:	eb 03                	jmp    8024d2 <vprintfmt+0x3c3>
  8024cf:	ff 4d 10             	decl   0x10(%ebp)
  8024d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d5:	48                   	dec    %eax
  8024d6:	8a 00                	mov    (%eax),%al
  8024d8:	3c 25                	cmp    $0x25,%al
  8024da:	75 f3                	jne    8024cf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8024dc:	90                   	nop
		}
	}
  8024dd:	e9 35 fc ff ff       	jmp    802117 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8024e2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8024e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024e6:	5b                   	pop    %ebx
  8024e7:	5e                   	pop    %esi
  8024e8:	5d                   	pop    %ebp
  8024e9:	c3                   	ret    

008024ea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8024f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8024f3:	83 c0 04             	add    $0x4,%eax
  8024f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8024f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ff:	50                   	push   %eax
  802500:	ff 75 0c             	pushl  0xc(%ebp)
  802503:	ff 75 08             	pushl  0x8(%ebp)
  802506:	e8 04 fc ff ff       	call   80210f <vprintfmt>
  80250b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80250e:	90                   	nop
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802514:	8b 45 0c             	mov    0xc(%ebp),%eax
  802517:	8b 40 08             	mov    0x8(%eax),%eax
  80251a:	8d 50 01             	lea    0x1(%eax),%edx
  80251d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802520:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802523:	8b 45 0c             	mov    0xc(%ebp),%eax
  802526:	8b 10                	mov    (%eax),%edx
  802528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252b:	8b 40 04             	mov    0x4(%eax),%eax
  80252e:	39 c2                	cmp    %eax,%edx
  802530:	73 12                	jae    802544 <sprintputch+0x33>
		*b->buf++ = ch;
  802532:	8b 45 0c             	mov    0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	8d 48 01             	lea    0x1(%eax),%ecx
  80253a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253d:	89 0a                	mov    %ecx,(%edx)
  80253f:	8b 55 08             	mov    0x8(%ebp),%edx
  802542:	88 10                	mov    %dl,(%eax)
}
  802544:	90                   	nop
  802545:	5d                   	pop    %ebp
  802546:	c3                   	ret    

00802547 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802553:	8b 45 0c             	mov    0xc(%ebp),%eax
  802556:	8d 50 ff             	lea    -0x1(%eax),%edx
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	01 d0                	add    %edx,%eax
  80255e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802561:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802568:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80256c:	74 06                	je     802574 <vsnprintf+0x2d>
  80256e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802572:	7f 07                	jg     80257b <vsnprintf+0x34>
		return -E_INVAL;
  802574:	b8 03 00 00 00       	mov    $0x3,%eax
  802579:	eb 20                	jmp    80259b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80257b:	ff 75 14             	pushl  0x14(%ebp)
  80257e:	ff 75 10             	pushl  0x10(%ebp)
  802581:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802584:	50                   	push   %eax
  802585:	68 11 25 80 00       	push   $0x802511
  80258a:	e8 80 fb ff ff       	call   80210f <vprintfmt>
  80258f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8025a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8025a6:	83 c0 04             	add    $0x4,%eax
  8025a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8025ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8025af:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b2:	50                   	push   %eax
  8025b3:	ff 75 0c             	pushl  0xc(%ebp)
  8025b6:	ff 75 08             	pushl  0x8(%ebp)
  8025b9:	e8 89 ff ff ff       	call   802547 <vsnprintf>
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8025cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025d6:	eb 06                	jmp    8025de <strlen+0x15>
		n++;
  8025d8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8025db:	ff 45 08             	incl   0x8(%ebp)
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	8a 00                	mov    (%eax),%al
  8025e3:	84 c0                	test   %al,%al
  8025e5:	75 f1                	jne    8025d8 <strlen+0xf>
		n++;
	return n;
  8025e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8025f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025f9:	eb 09                	jmp    802604 <strnlen+0x18>
		n++;
  8025fb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8025fe:	ff 45 08             	incl   0x8(%ebp)
  802601:	ff 4d 0c             	decl   0xc(%ebp)
  802604:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802608:	74 09                	je     802613 <strnlen+0x27>
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	8a 00                	mov    (%eax),%al
  80260f:	84 c0                	test   %al,%al
  802611:	75 e8                	jne    8025fb <strnlen+0xf>
		n++;
	return n;
  802613:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    

00802618 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
  80261b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802624:	90                   	nop
  802625:	8b 45 08             	mov    0x8(%ebp),%eax
  802628:	8d 50 01             	lea    0x1(%eax),%edx
  80262b:	89 55 08             	mov    %edx,0x8(%ebp)
  80262e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802631:	8d 4a 01             	lea    0x1(%edx),%ecx
  802634:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802637:	8a 12                	mov    (%edx),%dl
  802639:	88 10                	mov    %dl,(%eax)
  80263b:	8a 00                	mov    (%eax),%al
  80263d:	84 c0                	test   %al,%al
  80263f:	75 e4                	jne    802625 <strcpy+0xd>
		/* do nothing */;
	return ret;
  802641:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802644:	c9                   	leave  
  802645:	c3                   	ret    

00802646 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80264c:	8b 45 08             	mov    0x8(%ebp),%eax
  80264f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802652:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802659:	eb 1f                	jmp    80267a <strncpy+0x34>
		*dst++ = *src;
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	8d 50 01             	lea    0x1(%eax),%edx
  802661:	89 55 08             	mov    %edx,0x8(%ebp)
  802664:	8b 55 0c             	mov    0xc(%ebp),%edx
  802667:	8a 12                	mov    (%edx),%dl
  802669:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80266b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266e:	8a 00                	mov    (%eax),%al
  802670:	84 c0                	test   %al,%al
  802672:	74 03                	je     802677 <strncpy+0x31>
			src++;
  802674:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802677:	ff 45 fc             	incl   -0x4(%ebp)
  80267a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80267d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802680:	72 d9                	jb     80265b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802682:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802693:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802697:	74 30                	je     8026c9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802699:	eb 16                	jmp    8026b1 <strlcpy+0x2a>
			*dst++ = *src++;
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	8d 50 01             	lea    0x1(%eax),%edx
  8026a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8026a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8026aa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8026ad:	8a 12                	mov    (%edx),%dl
  8026af:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8026b1:	ff 4d 10             	decl   0x10(%ebp)
  8026b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026b8:	74 09                	je     8026c3 <strlcpy+0x3c>
  8026ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bd:	8a 00                	mov    (%eax),%al
  8026bf:	84 c0                	test   %al,%al
  8026c1:	75 d8                	jne    80269b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8026c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026cf:	29 c2                	sub    %eax,%edx
  8026d1:	89 d0                	mov    %edx,%eax
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8026d8:	eb 06                	jmp    8026e0 <strcmp+0xb>
		p++, q++;
  8026da:	ff 45 08             	incl   0x8(%ebp)
  8026dd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8026e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e3:	8a 00                	mov    (%eax),%al
  8026e5:	84 c0                	test   %al,%al
  8026e7:	74 0e                	je     8026f7 <strcmp+0x22>
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	8a 10                	mov    (%eax),%dl
  8026ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f1:	8a 00                	mov    (%eax),%al
  8026f3:	38 c2                	cmp    %al,%dl
  8026f5:	74 e3                	je     8026da <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	8a 00                	mov    (%eax),%al
  8026fc:	0f b6 d0             	movzbl %al,%edx
  8026ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802702:	8a 00                	mov    (%eax),%al
  802704:	0f b6 c0             	movzbl %al,%eax
  802707:	29 c2                	sub    %eax,%edx
  802709:	89 d0                	mov    %edx,%eax
}
  80270b:	5d                   	pop    %ebp
  80270c:	c3                   	ret    

0080270d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802710:	eb 09                	jmp    80271b <strncmp+0xe>
		n--, p++, q++;
  802712:	ff 4d 10             	decl   0x10(%ebp)
  802715:	ff 45 08             	incl   0x8(%ebp)
  802718:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80271b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80271f:	74 17                	je     802738 <strncmp+0x2b>
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	8a 00                	mov    (%eax),%al
  802726:	84 c0                	test   %al,%al
  802728:	74 0e                	je     802738 <strncmp+0x2b>
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	8a 10                	mov    (%eax),%dl
  80272f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802732:	8a 00                	mov    (%eax),%al
  802734:	38 c2                	cmp    %al,%dl
  802736:	74 da                	je     802712 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802738:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80273c:	75 07                	jne    802745 <strncmp+0x38>
		return 0;
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
  802743:	eb 14                	jmp    802759 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	8a 00                	mov    (%eax),%al
  80274a:	0f b6 d0             	movzbl %al,%edx
  80274d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802750:	8a 00                	mov    (%eax),%al
  802752:	0f b6 c0             	movzbl %al,%eax
  802755:	29 c2                	sub    %eax,%edx
  802757:	89 d0                	mov    %edx,%eax
}
  802759:	5d                   	pop    %ebp
  80275a:	c3                   	ret    

0080275b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
  80275e:	83 ec 04             	sub    $0x4,%esp
  802761:	8b 45 0c             	mov    0xc(%ebp),%eax
  802764:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802767:	eb 12                	jmp    80277b <strchr+0x20>
		if (*s == c)
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	8a 00                	mov    (%eax),%al
  80276e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802771:	75 05                	jne    802778 <strchr+0x1d>
			return (char *) s;
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	eb 11                	jmp    802789 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802778:	ff 45 08             	incl   0x8(%ebp)
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	8a 00                	mov    (%eax),%al
  802780:	84 c0                	test   %al,%al
  802782:	75 e5                	jne    802769 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 04             	sub    $0x4,%esp
  802791:	8b 45 0c             	mov    0xc(%ebp),%eax
  802794:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802797:	eb 0d                	jmp    8027a6 <strfind+0x1b>
		if (*s == c)
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	8a 00                	mov    (%eax),%al
  80279e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8027a1:	74 0e                	je     8027b1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8027a3:	ff 45 08             	incl   0x8(%ebp)
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	8a 00                	mov    (%eax),%al
  8027ab:	84 c0                	test   %al,%al
  8027ad:	75 ea                	jne    802799 <strfind+0xe>
  8027af:	eb 01                	jmp    8027b2 <strfind+0x27>
		if (*s == c)
			break;
  8027b1:	90                   	nop
	return (char *) s;
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8027c3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8027c7:	76 63                	jbe    80282c <memset+0x75>
		uint64 data_block = c;
  8027c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cc:	99                   	cltd   
  8027cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8027dd:	c1 e0 08             	shl    $0x8,%eax
  8027e0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8027e3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8027e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ec:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8027f0:	c1 e0 10             	shl    $0x10,%eax
  8027f3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8027f6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ff:	89 c2                	mov    %eax,%edx
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
  802806:	09 45 f0             	or     %eax,-0x10(%ebp)
  802809:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80280c:	eb 18                	jmp    802826 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80280e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802811:	8d 41 08             	lea    0x8(%ecx),%eax
  802814:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281d:	89 01                	mov    %eax,(%ecx)
  80281f:	89 51 04             	mov    %edx,0x4(%ecx)
  802822:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802826:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80282a:	77 e2                	ja     80280e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80282c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802830:	74 23                	je     802855 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802832:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802835:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802838:	eb 0e                	jmp    802848 <memset+0x91>
			*p8++ = (uint8)c;
  80283a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80283d:	8d 50 01             	lea    0x1(%eax),%edx
  802840:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802843:	8b 55 0c             	mov    0xc(%ebp),%edx
  802846:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802848:	8b 45 10             	mov    0x10(%ebp),%eax
  80284b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80284e:	89 55 10             	mov    %edx,0x10(%ebp)
  802851:	85 c0                	test   %eax,%eax
  802853:	75 e5                	jne    80283a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
  80285d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802860:	8b 45 0c             	mov    0xc(%ebp),%eax
  802863:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80286c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802870:	76 24                	jbe    802896 <memcpy+0x3c>
		while(n >= 8){
  802872:	eb 1c                	jmp    802890 <memcpy+0x36>
			*d64 = *s64;
  802874:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802877:	8b 50 04             	mov    0x4(%eax),%edx
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80287f:	89 01                	mov    %eax,(%ecx)
  802881:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802884:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802888:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80288c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802890:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802894:	77 de                	ja     802874 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802896:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80289a:	74 31                	je     8028cd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80289c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80289f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8028a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8028a8:	eb 16                	jmp    8028c0 <memcpy+0x66>
			*d8++ = *s8++;
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8d 50 01             	lea    0x1(%eax),%edx
  8028b0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8028b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8028b9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8028bc:	8a 12                	mov    (%edx),%dl
  8028be:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8028c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	75 dd                	jne    8028aa <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8028d0:	c9                   	leave  
  8028d1:	c3                   	ret    

008028d2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
  8028d5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8028d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8028e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8028ea:	73 50                	jae    80293c <memmove+0x6a>
  8028ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f2:	01 d0                	add    %edx,%eax
  8028f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8028f7:	76 43                	jbe    80293c <memmove+0x6a>
		s += n;
  8028f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8028fc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8028ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802902:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802905:	eb 10                	jmp    802917 <memmove+0x45>
			*--d = *--s;
  802907:	ff 4d f8             	decl   -0x8(%ebp)
  80290a:	ff 4d fc             	decl   -0x4(%ebp)
  80290d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802910:	8a 10                	mov    (%eax),%dl
  802912:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802915:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802917:	8b 45 10             	mov    0x10(%ebp),%eax
  80291a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80291d:	89 55 10             	mov    %edx,0x10(%ebp)
  802920:	85 c0                	test   %eax,%eax
  802922:	75 e3                	jne    802907 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802924:	eb 23                	jmp    802949 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802926:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802929:	8d 50 01             	lea    0x1(%eax),%edx
  80292c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80292f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802932:	8d 4a 01             	lea    0x1(%edx),%ecx
  802935:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802938:	8a 12                	mov    (%edx),%dl
  80293a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80293c:	8b 45 10             	mov    0x10(%ebp),%eax
  80293f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802942:	89 55 10             	mov    %edx,0x10(%ebp)
  802945:	85 c0                	test   %eax,%eax
  802947:	75 dd                	jne    802926 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80295a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802960:	eb 2a                	jmp    80298c <memcmp+0x3e>
		if (*s1 != *s2)
  802962:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802965:	8a 10                	mov    (%eax),%dl
  802967:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80296a:	8a 00                	mov    (%eax),%al
  80296c:	38 c2                	cmp    %al,%dl
  80296e:	74 16                	je     802986 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802973:	8a 00                	mov    (%eax),%al
  802975:	0f b6 d0             	movzbl %al,%edx
  802978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80297b:	8a 00                	mov    (%eax),%al
  80297d:	0f b6 c0             	movzbl %al,%eax
  802980:	29 c2                	sub    %eax,%edx
  802982:	89 d0                	mov    %edx,%eax
  802984:	eb 18                	jmp    80299e <memcmp+0x50>
		s1++, s2++;
  802986:	ff 45 fc             	incl   -0x4(%ebp)
  802989:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80298c:	8b 45 10             	mov    0x10(%ebp),%eax
  80298f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802992:	89 55 10             	mov    %edx,0x10(%ebp)
  802995:	85 c0                	test   %eax,%eax
  802997:	75 c9                	jne    802962 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802999:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8029a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ac:	01 d0                	add    %edx,%eax
  8029ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8029b1:	eb 15                	jmp    8029c8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8a 00                	mov    (%eax),%al
  8029b8:	0f b6 d0             	movzbl %al,%edx
  8029bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029be:	0f b6 c0             	movzbl %al,%eax
  8029c1:	39 c2                	cmp    %eax,%edx
  8029c3:	74 0d                	je     8029d2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8029c5:	ff 45 08             	incl   0x8(%ebp)
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8029ce:	72 e3                	jb     8029b3 <memfind+0x13>
  8029d0:	eb 01                	jmp    8029d3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8029d2:	90                   	nop
	return (void *) s;
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
  8029db:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8029de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8029e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8029ec:	eb 03                	jmp    8029f1 <strtol+0x19>
		s++;
  8029ee:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	8a 00                	mov    (%eax),%al
  8029f6:	3c 20                	cmp    $0x20,%al
  8029f8:	74 f4                	je     8029ee <strtol+0x16>
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	8a 00                	mov    (%eax),%al
  8029ff:	3c 09                	cmp    $0x9,%al
  802a01:	74 eb                	je     8029ee <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	8a 00                	mov    (%eax),%al
  802a08:	3c 2b                	cmp    $0x2b,%al
  802a0a:	75 05                	jne    802a11 <strtol+0x39>
		s++;
  802a0c:	ff 45 08             	incl   0x8(%ebp)
  802a0f:	eb 13                	jmp    802a24 <strtol+0x4c>
	else if (*s == '-')
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	8a 00                	mov    (%eax),%al
  802a16:	3c 2d                	cmp    $0x2d,%al
  802a18:	75 0a                	jne    802a24 <strtol+0x4c>
		s++, neg = 1;
  802a1a:	ff 45 08             	incl   0x8(%ebp)
  802a1d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802a24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a28:	74 06                	je     802a30 <strtol+0x58>
  802a2a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802a2e:	75 20                	jne    802a50 <strtol+0x78>
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	8a 00                	mov    (%eax),%al
  802a35:	3c 30                	cmp    $0x30,%al
  802a37:	75 17                	jne    802a50 <strtol+0x78>
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	40                   	inc    %eax
  802a3d:	8a 00                	mov    (%eax),%al
  802a3f:	3c 78                	cmp    $0x78,%al
  802a41:	75 0d                	jne    802a50 <strtol+0x78>
		s += 2, base = 16;
  802a43:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802a47:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802a4e:	eb 28                	jmp    802a78 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a54:	75 15                	jne    802a6b <strtol+0x93>
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	8a 00                	mov    (%eax),%al
  802a5b:	3c 30                	cmp    $0x30,%al
  802a5d:	75 0c                	jne    802a6b <strtol+0x93>
		s++, base = 8;
  802a5f:	ff 45 08             	incl   0x8(%ebp)
  802a62:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802a69:	eb 0d                	jmp    802a78 <strtol+0xa0>
	else if (base == 0)
  802a6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a6f:	75 07                	jne    802a78 <strtol+0xa0>
		base = 10;
  802a71:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	8a 00                	mov    (%eax),%al
  802a7d:	3c 2f                	cmp    $0x2f,%al
  802a7f:	7e 19                	jle    802a9a <strtol+0xc2>
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	8a 00                	mov    (%eax),%al
  802a86:	3c 39                	cmp    $0x39,%al
  802a88:	7f 10                	jg     802a9a <strtol+0xc2>
			dig = *s - '0';
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	8a 00                	mov    (%eax),%al
  802a8f:	0f be c0             	movsbl %al,%eax
  802a92:	83 e8 30             	sub    $0x30,%eax
  802a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a98:	eb 42                	jmp    802adc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	8a 00                	mov    (%eax),%al
  802a9f:	3c 60                	cmp    $0x60,%al
  802aa1:	7e 19                	jle    802abc <strtol+0xe4>
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8a 00                	mov    (%eax),%al
  802aa8:	3c 7a                	cmp    $0x7a,%al
  802aaa:	7f 10                	jg     802abc <strtol+0xe4>
			dig = *s - 'a' + 10;
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	8a 00                	mov    (%eax),%al
  802ab1:	0f be c0             	movsbl %al,%eax
  802ab4:	83 e8 57             	sub    $0x57,%eax
  802ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aba:	eb 20                	jmp    802adc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8a 00                	mov    (%eax),%al
  802ac1:	3c 40                	cmp    $0x40,%al
  802ac3:	7e 39                	jle    802afe <strtol+0x126>
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	8a 00                	mov    (%eax),%al
  802aca:	3c 5a                	cmp    $0x5a,%al
  802acc:	7f 30                	jg     802afe <strtol+0x126>
			dig = *s - 'A' + 10;
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	8a 00                	mov    (%eax),%al
  802ad3:	0f be c0             	movsbl %al,%eax
  802ad6:	83 e8 37             	sub    $0x37,%eax
  802ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ae2:	7d 19                	jge    802afd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802ae4:	ff 45 08             	incl   0x8(%ebp)
  802ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802aea:	0f af 45 10          	imul   0x10(%ebp),%eax
  802aee:	89 c2                	mov    %eax,%edx
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	01 d0                	add    %edx,%eax
  802af5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802af8:	e9 7b ff ff ff       	jmp    802a78 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802afd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802afe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b02:	74 08                	je     802b0c <strtol+0x134>
		*endptr = (char *) s;
  802b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b07:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802b0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b10:	74 07                	je     802b19 <strtol+0x141>
  802b12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b15:	f7 d8                	neg    %eax
  802b17:	eb 03                	jmp    802b1c <strtol+0x144>
  802b19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802b1c:	c9                   	leave  
  802b1d:	c3                   	ret    

00802b1e <ltostr>:

void
ltostr(long value, char *str)
{
  802b1e:	55                   	push   %ebp
  802b1f:	89 e5                	mov    %esp,%ebp
  802b21:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802b24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802b2b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802b32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b36:	79 13                	jns    802b4b <ltostr+0x2d>
	{
		neg = 1;
  802b38:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b42:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802b45:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802b48:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802b53:	99                   	cltd   
  802b54:	f7 f9                	idiv   %ecx
  802b56:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b5c:	8d 50 01             	lea    0x1(%eax),%edx
  802b5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802b62:	89 c2                	mov    %eax,%edx
  802b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b67:	01 d0                	add    %edx,%eax
  802b69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6c:	83 c2 30             	add    $0x30,%edx
  802b6f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802b71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b74:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802b79:	f7 e9                	imul   %ecx
  802b7b:	c1 fa 02             	sar    $0x2,%edx
  802b7e:	89 c8                	mov    %ecx,%eax
  802b80:	c1 f8 1f             	sar    $0x1f,%eax
  802b83:	29 c2                	sub    %eax,%edx
  802b85:	89 d0                	mov    %edx,%eax
  802b87:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802b8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8e:	75 bb                	jne    802b4b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802b90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802b97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b9a:	48                   	dec    %eax
  802b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802b9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ba2:	74 3d                	je     802be1 <ltostr+0xc3>
		start = 1 ;
  802ba4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802bab:	eb 34                	jmp    802be1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb3:	01 d0                	add    %edx,%eax
  802bb5:	8a 00                	mov    (%eax),%al
  802bb7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc0:	01 c2                	add    %eax,%edx
  802bc2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc8:	01 c8                	add    %ecx,%eax
  802bca:	8a 00                	mov    (%eax),%al
  802bcc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd4:	01 c2                	add    %eax,%edx
  802bd6:	8a 45 eb             	mov    -0x15(%ebp),%al
  802bd9:	88 02                	mov    %al,(%edx)
		start++ ;
  802bdb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802bde:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802be7:	7c c4                	jl     802bad <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802be9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bef:	01 d0                	add    %edx,%eax
  802bf1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802bf4:	90                   	nop
  802bf5:	c9                   	leave  
  802bf6:	c3                   	ret    

00802bf7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
  802bfa:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802bfd:	ff 75 08             	pushl  0x8(%ebp)
  802c00:	e8 c4 f9 ff ff       	call   8025c9 <strlen>
  802c05:	83 c4 04             	add    $0x4,%esp
  802c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802c0b:	ff 75 0c             	pushl  0xc(%ebp)
  802c0e:	e8 b6 f9 ff ff       	call   8025c9 <strlen>
  802c13:	83 c4 04             	add    $0x4,%esp
  802c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802c19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802c20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802c27:	eb 17                	jmp    802c40 <strcconcat+0x49>
		final[s] = str1[s] ;
  802c29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  802c2f:	01 c2                	add    %eax,%edx
  802c31:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	01 c8                	add    %ecx,%eax
  802c39:	8a 00                	mov    (%eax),%al
  802c3b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802c3d:	ff 45 fc             	incl   -0x4(%ebp)
  802c40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c43:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c46:	7c e1                	jl     802c29 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802c48:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802c4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802c56:	eb 1f                	jmp    802c77 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c5b:	8d 50 01             	lea    0x1(%eax),%edx
  802c5e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802c61:	89 c2                	mov    %eax,%edx
  802c63:	8b 45 10             	mov    0x10(%ebp),%eax
  802c66:	01 c2                	add    %eax,%edx
  802c68:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6e:	01 c8                	add    %ecx,%eax
  802c70:	8a 00                	mov    (%eax),%al
  802c72:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802c74:	ff 45 f8             	incl   -0x8(%ebp)
  802c77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c7d:	7c d9                	jl     802c58 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802c7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c82:	8b 45 10             	mov    0x10(%ebp),%eax
  802c85:	01 d0                	add    %edx,%eax
  802c87:	c6 00 00             	movb   $0x0,(%eax)
}
  802c8a:	90                   	nop
  802c8b:	c9                   	leave  
  802c8c:	c3                   	ret    

00802c8d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802c8d:	55                   	push   %ebp
  802c8e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802c90:	8b 45 14             	mov    0x14(%ebp),%eax
  802c93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802c99:	8b 45 14             	mov    0x14(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ca8:	01 d0                	add    %edx,%eax
  802caa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802cb0:	eb 0c                	jmp    802cbe <strsplit+0x31>
			*string++ = 0;
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	8d 50 01             	lea    0x1(%eax),%edx
  802cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  802cbb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8a 00                	mov    (%eax),%al
  802cc3:	84 c0                	test   %al,%al
  802cc5:	74 18                	je     802cdf <strsplit+0x52>
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	8a 00                	mov    (%eax),%al
  802ccc:	0f be c0             	movsbl %al,%eax
  802ccf:	50                   	push   %eax
  802cd0:	ff 75 0c             	pushl  0xc(%ebp)
  802cd3:	e8 83 fa ff ff       	call   80275b <strchr>
  802cd8:	83 c4 08             	add    $0x8,%esp
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	75 d3                	jne    802cb2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8a 00                	mov    (%eax),%al
  802ce4:	84 c0                	test   %al,%al
  802ce6:	74 5a                	je     802d42 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	83 f8 0f             	cmp    $0xf,%eax
  802cf0:	75 07                	jne    802cf9 <strsplit+0x6c>
		{
			return 0;
  802cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf7:	eb 66                	jmp    802d5f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802cf9:	8b 45 14             	mov    0x14(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	8d 48 01             	lea    0x1(%eax),%ecx
  802d01:	8b 55 14             	mov    0x14(%ebp),%edx
  802d04:	89 0a                	mov    %ecx,(%edx)
  802d06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  802d10:	01 c2                	add    %eax,%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802d17:	eb 03                	jmp    802d1c <strsplit+0x8f>
			string++;
  802d19:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8a 00                	mov    (%eax),%al
  802d21:	84 c0                	test   %al,%al
  802d23:	74 8b                	je     802cb0 <strsplit+0x23>
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	8a 00                	mov    (%eax),%al
  802d2a:	0f be c0             	movsbl %al,%eax
  802d2d:	50                   	push   %eax
  802d2e:	ff 75 0c             	pushl  0xc(%ebp)
  802d31:	e8 25 fa ff ff       	call   80275b <strchr>
  802d36:	83 c4 08             	add    $0x8,%esp
  802d39:	85 c0                	test   %eax,%eax
  802d3b:	74 dc                	je     802d19 <strsplit+0x8c>
			string++;
	}
  802d3d:	e9 6e ff ff ff       	jmp    802cb0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802d42:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802d43:	8b 45 14             	mov    0x14(%ebp),%eax
  802d46:	8b 00                	mov    (%eax),%eax
  802d48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d52:	01 d0                	add    %edx,%eax
  802d54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802d5a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d5f:	c9                   	leave  
  802d60:	c3                   	ret    

00802d61 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
  802d64:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802d6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802d74:	eb 4a                	jmp    802dc0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802d76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	01 c2                	add    %eax,%edx
  802d7e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d84:	01 c8                	add    %ecx,%eax
  802d86:	8a 00                	mov    (%eax),%al
  802d88:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d90:	01 d0                	add    %edx,%eax
  802d92:	8a 00                	mov    (%eax),%al
  802d94:	3c 40                	cmp    $0x40,%al
  802d96:	7e 25                	jle    802dbd <str2lower+0x5c>
  802d98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9e:	01 d0                	add    %edx,%eax
  802da0:	8a 00                	mov    (%eax),%al
  802da2:	3c 5a                	cmp    $0x5a,%al
  802da4:	7f 17                	jg     802dbd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802da6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	01 d0                	add    %edx,%eax
  802dae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802db1:	8b 55 08             	mov    0x8(%ebp),%edx
  802db4:	01 ca                	add    %ecx,%edx
  802db6:	8a 12                	mov    (%edx),%dl
  802db8:	83 c2 20             	add    $0x20,%edx
  802dbb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802dbd:	ff 45 fc             	incl   -0x4(%ebp)
  802dc0:	ff 75 0c             	pushl  0xc(%ebp)
  802dc3:	e8 01 f8 ff ff       	call   8025c9 <strlen>
  802dc8:	83 c4 04             	add    $0x4,%esp
  802dcb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802dce:	7f a6                	jg     802d76 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802dd3:	c9                   	leave  
  802dd4:	c3                   	ret    

00802dd5 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  802dd5:	55                   	push   %ebp
  802dd6:	89 e5                	mov    %esp,%ebp
  802dd8:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  802ddb:	83 ec 0c             	sub    $0xc,%esp
  802dde:	6a 10                	push   $0x10
  802de0:	e8 b2 15 00 00       	call   804397 <alloc_block>
  802de5:	83 c4 10             	add    $0x10,%esp
  802de8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  802deb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802def:	75 14                	jne    802e05 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	68 48 5f 80 00       	push   $0x805f48
  802df9:	6a 14                	push   $0x14
  802dfb:	68 71 5f 80 00       	push   $0x805f71
  802e00:	e8 fd ed ff ff       	call   801c02 <_panic>

	node->start = start;
  802e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e08:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0b:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  802e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e13:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802e16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  802e1d:	a1 04 72 80 00       	mov    0x807204,%eax
  802e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e25:	eb 18                	jmp    802e3f <insert_page_alloc+0x6a>
		if (start < it->start)
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e2f:	77 37                	ja     802e68 <insert_page_alloc+0x93>
			break;
		prev = it;
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  802e37:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e43:	74 08                	je     802e4d <insert_page_alloc+0x78>
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 40 08             	mov    0x8(%eax),%eax
  802e4b:	eb 05                	jmp    802e52 <insert_page_alloc+0x7d>
  802e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e52:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802e57:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	75 c7                	jne    802e27 <insert_page_alloc+0x52>
  802e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e64:	75 c1                	jne    802e27 <insert_page_alloc+0x52>
  802e66:	eb 01                	jmp    802e69 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  802e68:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  802e69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6d:	75 64                	jne    802ed3 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  802e6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e73:	75 14                	jne    802e89 <insert_page_alloc+0xb4>
  802e75:	83 ec 04             	sub    $0x4,%esp
  802e78:	68 80 5f 80 00       	push   $0x805f80
  802e7d:	6a 21                	push   $0x21
  802e7f:	68 71 5f 80 00       	push   $0x805f71
  802e84:	e8 79 ed ff ff       	call   801c02 <_panic>
  802e89:	8b 15 04 72 80 00    	mov    0x807204,%edx
  802e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e92:	89 50 08             	mov    %edx,0x8(%eax)
  802e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e98:	8b 40 08             	mov    0x8(%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 0d                	je     802eac <insert_page_alloc+0xd7>
  802e9f:	a1 04 72 80 00       	mov    0x807204,%eax
  802ea4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ea7:	89 50 0c             	mov    %edx,0xc(%eax)
  802eaa:	eb 08                	jmp    802eb4 <insert_page_alloc+0xdf>
  802eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaf:	a3 08 72 80 00       	mov    %eax,0x807208
  802eb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb7:	a3 04 72 80 00       	mov    %eax,0x807204
  802ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ec6:	a1 10 72 80 00       	mov    0x807210,%eax
  802ecb:	40                   	inc    %eax
  802ecc:	a3 10 72 80 00       	mov    %eax,0x807210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  802ed1:	eb 71                	jmp    802f44 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802ed3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed7:	74 06                	je     802edf <insert_page_alloc+0x10a>
  802ed9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802edd:	75 14                	jne    802ef3 <insert_page_alloc+0x11e>
  802edf:	83 ec 04             	sub    $0x4,%esp
  802ee2:	68 a4 5f 80 00       	push   $0x805fa4
  802ee7:	6a 23                	push   $0x23
  802ee9:	68 71 5f 80 00       	push   $0x805f71
  802eee:	e8 0f ed ff ff       	call   801c02 <_panic>
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	8b 50 08             	mov    0x8(%eax),%edx
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	89 50 08             	mov    %edx,0x8(%eax)
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	8b 40 08             	mov    0x8(%eax),%eax
  802f05:	85 c0                	test   %eax,%eax
  802f07:	74 0c                	je     802f15 <insert_page_alloc+0x140>
  802f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0c:	8b 40 08             	mov    0x8(%eax),%eax
  802f0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f12:	89 50 0c             	mov    %edx,0xc(%eax)
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f1b:	89 50 08             	mov    %edx,0x8(%eax)
  802f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f24:	89 50 0c             	mov    %edx,0xc(%eax)
  802f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2a:	8b 40 08             	mov    0x8(%eax),%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	75 08                	jne    802f39 <insert_page_alloc+0x164>
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	a3 08 72 80 00       	mov    %eax,0x807208
  802f39:	a1 10 72 80 00       	mov    0x807210,%eax
  802f3e:	40                   	inc    %eax
  802f3f:	a3 10 72 80 00       	mov    %eax,0x807210
}
  802f44:	90                   	nop
  802f45:	c9                   	leave  
  802f46:	c3                   	ret    

00802f47 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  802f47:	55                   	push   %ebp
  802f48:	89 e5                	mov    %esp,%ebp
  802f4a:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  802f4d:	a1 04 72 80 00       	mov    0x807204,%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	75 0c                	jne    802f62 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  802f56:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802f5b:	a3 50 f2 81 00       	mov    %eax,0x81f250
		return;
  802f60:	eb 67                	jmp    802fc9 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  802f62:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802f6a:	a1 04 72 80 00       	mov    0x807204,%eax
  802f6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802f72:	eb 26                	jmp    802f9a <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  802f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802f77:	8b 10                	mov    (%eax),%edx
  802f79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	01 d0                	add    %edx,%eax
  802f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802f8a:	76 06                	jbe    802f92 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802f92:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802f97:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802f9a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802f9e:	74 08                	je     802fa8 <recompute_page_alloc_break+0x61>
  802fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802fa3:	8b 40 08             	mov    0x8(%eax),%eax
  802fa6:	eb 05                	jmp    802fad <recompute_page_alloc_break+0x66>
  802fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fad:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802fb2:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	75 b9                	jne    802f74 <recompute_page_alloc_break+0x2d>
  802fbb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802fbf:	75 b3                	jne    802f74 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  802fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fc4:	a3 50 f2 81 00       	mov    %eax,0x81f250
}
  802fc9:	c9                   	leave  
  802fca:	c3                   	ret    

00802fcb <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  802fcb:	55                   	push   %ebp
  802fcc:	89 e5                	mov    %esp,%ebp
  802fce:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  802fd1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fdb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fde:	01 d0                	add    %edx,%eax
  802fe0:	48                   	dec    %eax
  802fe1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802fe4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fe7:	ba 00 00 00 00       	mov    $0x0,%edx
  802fec:	f7 75 d8             	divl   -0x28(%ebp)
  802fef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ff2:	29 d0                	sub    %edx,%eax
  802ff4:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  802ff7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802ffb:	75 0a                	jne    803007 <alloc_pages_custom_fit+0x3c>
		return NULL;
  802ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  803002:	e9 7e 01 00 00       	jmp    803185 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  803007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80300e:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  803012:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  803019:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  803020:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803025:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  803028:	a1 04 72 80 00       	mov    0x807204,%eax
  80302d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803030:	eb 69                	jmp    80309b <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  803032:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80303a:	76 47                	jbe    803083 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80303c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  803042:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80304a:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  80304d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803050:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803053:	72 2e                	jb     803083 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  803055:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  803059:	75 14                	jne    80306f <alloc_pages_custom_fit+0xa4>
  80305b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80305e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803061:	75 0c                	jne    80306f <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  803063:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803066:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  803069:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80306d:	eb 14                	jmp    803083 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80306f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803072:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803075:	76 0c                	jbe    803083 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  803077:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80307a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80307d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803080:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  803083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803086:	8b 10                	mov    (%eax),%edx
  803088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	01 d0                	add    %edx,%eax
  803090:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  803093:	a1 0c 72 80 00       	mov    0x80720c,%eax
  803098:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80309b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80309f:	74 08                	je     8030a9 <alloc_pages_custom_fit+0xde>
  8030a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a4:	8b 40 08             	mov    0x8(%eax),%eax
  8030a7:	eb 05                	jmp    8030ae <alloc_pages_custom_fit+0xe3>
  8030a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ae:	a3 0c 72 80 00       	mov    %eax,0x80720c
  8030b3:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	0f 85 72 ff ff ff    	jne    803032 <alloc_pages_custom_fit+0x67>
  8030c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030c4:	0f 85 68 ff ff ff    	jne    803032 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8030ca:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8030cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030d2:	76 47                	jbe    80311b <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8030d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8030da:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8030df:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8030e2:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8030e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030e8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8030eb:	72 2e                	jb     80311b <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8030ed:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8030f1:	75 14                	jne    803107 <alloc_pages_custom_fit+0x13c>
  8030f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030f6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8030f9:	75 0c                	jne    803107 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8030fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  803101:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  803105:	eb 14                	jmp    80311b <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  803107:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80310a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80310d:	76 0c                	jbe    80311b <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80310f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803112:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  803115:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803118:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80311b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  803122:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  803126:	74 08                	je     803130 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80312e:	eb 40                	jmp    803170 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  803130:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803134:	74 08                	je     80313e <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  803136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803139:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80313c:	eb 32                	jmp    803170 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80313e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  803143:	2b 45 d0             	sub    -0x30(%ebp),%eax
  803146:	89 c2                	mov    %eax,%edx
  803148:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80314d:	39 c2                	cmp    %eax,%edx
  80314f:	73 07                	jae    803158 <alloc_pages_custom_fit+0x18d>
			return NULL;
  803151:	b8 00 00 00 00       	mov    $0x0,%eax
  803156:	eb 2d                	jmp    803185 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  803158:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80315d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  803160:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803166:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803169:	01 d0                	add    %edx,%eax
  80316b:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}


	insert_page_alloc((uint32)result, required_size);
  803170:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803173:	83 ec 08             	sub    $0x8,%esp
  803176:	ff 75 d0             	pushl  -0x30(%ebp)
  803179:	50                   	push   %eax
  80317a:	e8 56 fc ff ff       	call   802dd5 <insert_page_alloc>
  80317f:	83 c4 10             	add    $0x10,%esp

	return result;
  803182:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  803185:	c9                   	leave  
  803186:	c3                   	ret    

00803187 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  803187:	55                   	push   %ebp
  803188:	89 e5                	mov    %esp,%ebp
  80318a:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  803193:	a1 04 72 80 00       	mov    0x807204,%eax
  803198:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80319b:	eb 1a                	jmp    8031b7 <find_allocated_size+0x30>
		if (it->start == va)
  80319d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031a0:	8b 00                	mov    (%eax),%eax
  8031a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031a5:	75 08                	jne    8031af <find_allocated_size+0x28>
			return it->size;
  8031a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031aa:	8b 40 04             	mov    0x4(%eax),%eax
  8031ad:	eb 34                	jmp    8031e3 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8031af:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8031b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8031b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8031bb:	74 08                	je     8031c5 <find_allocated_size+0x3e>
  8031bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031c0:	8b 40 08             	mov    0x8(%eax),%eax
  8031c3:	eb 05                	jmp    8031ca <find_allocated_size+0x43>
  8031c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ca:	a3 0c 72 80 00       	mov    %eax,0x80720c
  8031cf:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	75 c5                	jne    80319d <find_allocated_size+0x16>
  8031d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8031dc:	75 bf                	jne    80319d <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8031de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031e3:	c9                   	leave  
  8031e4:	c3                   	ret    

008031e5 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8031e5:	55                   	push   %ebp
  8031e6:	89 e5                	mov    %esp,%ebp
  8031e8:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8031f1:	a1 04 72 80 00       	mov    0x807204,%eax
  8031f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f9:	e9 e1 01 00 00       	jmp    8033df <free_pages+0x1fa>
		if (it->start == va) {
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803206:	0f 85 cb 01 00 00    	jne    8033d7 <free_pages+0x1f2>

			uint32 start = it->start;
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  80321d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803220:	f7 d0                	not    %eax
  803222:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803225:	73 1d                	jae    803244 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  803227:	83 ec 0c             	sub    $0xc,%esp
  80322a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80322d:	ff 75 e8             	pushl  -0x18(%ebp)
  803230:	68 d8 5f 80 00       	push   $0x805fd8
  803235:	68 a5 00 00 00       	push   $0xa5
  80323a:	68 71 5f 80 00       	push   $0x805f71
  80323f:	e8 be e9 ff ff       	call   801c02 <_panic>
			}

			uint32 start_end = start + size;
  803244:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324a:	01 d0                	add    %edx,%eax
  80324c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	79 19                	jns    80326f <free_pages+0x8a>
  803256:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80325d:	77 10                	ja     80326f <free_pages+0x8a>
  80325f:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  803266:	77 07                	ja     80326f <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  803268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	78 2c                	js     80329b <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  80326f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803272:	83 ec 0c             	sub    $0xc,%esp
  803275:	68 00 00 00 a0       	push   $0xa0000000
  80327a:	ff 75 e0             	pushl  -0x20(%ebp)
  80327d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803280:	ff 75 e8             	pushl  -0x18(%ebp)
  803283:	ff 75 e4             	pushl  -0x1c(%ebp)
  803286:	50                   	push   %eax
  803287:	68 1c 60 80 00       	push   $0x80601c
  80328c:	68 ad 00 00 00       	push   $0xad
  803291:	68 71 5f 80 00       	push   $0x805f71
  803296:	e8 67 e9 ff ff       	call   801c02 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8032a1:	e9 88 00 00 00       	jmp    80332e <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8032a6:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8032ad:	76 17                	jbe    8032c6 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8032af:	ff 75 f0             	pushl  -0x10(%ebp)
  8032b2:	68 80 60 80 00       	push   $0x806080
  8032b7:	68 b4 00 00 00       	push   $0xb4
  8032bc:	68 71 5f 80 00       	push   $0x805f71
  8032c1:	e8 3c e9 ff ff       	call   801c02 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8032c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c9:	05 00 10 00 00       	add    $0x1000,%eax
  8032ce:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8032d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	79 2e                	jns    803306 <free_pages+0x121>
  8032d8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8032df:	77 25                	ja     803306 <free_pages+0x121>
  8032e1:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8032e8:	77 1c                	ja     803306 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  8032ea:	83 ec 08             	sub    $0x8,%esp
  8032ed:	68 00 10 00 00       	push   $0x1000
  8032f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f5:	e8 38 0d 00 00       	call   804032 <sys_free_user_mem>
  8032fa:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8032fd:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  803304:	eb 28                	jmp    80332e <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  803306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803309:	68 00 00 00 a0       	push   $0xa0000000
  80330e:	ff 75 dc             	pushl  -0x24(%ebp)
  803311:	68 00 10 00 00       	push   $0x1000
  803316:	ff 75 f0             	pushl  -0x10(%ebp)
  803319:	50                   	push   %eax
  80331a:	68 c0 60 80 00       	push   $0x8060c0
  80331f:	68 bd 00 00 00       	push   $0xbd
  803324:	68 71 5f 80 00       	push   $0x805f71
  803329:	e8 d4 e8 ff ff       	call   801c02 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803334:	0f 82 6c ff ff ff    	jb     8032a6 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  80333a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333e:	75 17                	jne    803357 <free_pages+0x172>
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	68 22 61 80 00       	push   $0x806122
  803348:	68 c1 00 00 00       	push   $0xc1
  80334d:	68 71 5f 80 00       	push   $0x805f71
  803352:	e8 ab e8 ff ff       	call   801c02 <_panic>
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 40 08             	mov    0x8(%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	74 11                	je     803372 <free_pages+0x18d>
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 40 08             	mov    0x8(%eax),%eax
  803367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80336a:	8b 52 0c             	mov    0xc(%edx),%edx
  80336d:	89 50 0c             	mov    %edx,0xc(%eax)
  803370:	eb 0b                	jmp    80337d <free_pages+0x198>
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 40 0c             	mov    0xc(%eax),%eax
  803378:	a3 08 72 80 00       	mov    %eax,0x807208
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 40 0c             	mov    0xc(%eax),%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	74 11                	je     803398 <free_pages+0x1b3>
  803387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338a:	8b 40 0c             	mov    0xc(%eax),%eax
  80338d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803390:	8b 52 08             	mov    0x8(%edx),%edx
  803393:	89 50 08             	mov    %edx,0x8(%eax)
  803396:	eb 0b                	jmp    8033a3 <free_pages+0x1be>
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	8b 40 08             	mov    0x8(%eax),%eax
  80339e:	a3 04 72 80 00       	mov    %eax,0x807204
  8033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8033b7:	a1 10 72 80 00       	mov    0x807210,%eax
  8033bc:	48                   	dec    %eax
  8033bd:	a3 10 72 80 00       	mov    %eax,0x807210
			free_block(it);
  8033c2:	83 ec 0c             	sub    $0xc,%esp
  8033c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8033c8:	e8 24 15 00 00       	call   8048f1 <free_block>
  8033cd:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8033d0:	e8 72 fb ff ff       	call   802f47 <recompute_page_alloc_break>

			return;
  8033d5:	eb 37                	jmp    80340e <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8033d7:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8033dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e3:	74 08                	je     8033ed <free_pages+0x208>
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	8b 40 08             	mov    0x8(%eax),%eax
  8033eb:	eb 05                	jmp    8033f2 <free_pages+0x20d>
  8033ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f2:	a3 0c 72 80 00       	mov    %eax,0x80720c
  8033f7:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	0f 85 fa fd ff ff    	jne    8031fe <free_pages+0x19>
  803404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803408:	0f 85 f0 fd ff ff    	jne    8031fe <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  80340e:	c9                   	leave  
  80340f:	c3                   	ret    

00803410 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  803410:	55                   	push   %ebp
  803411:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  803413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803418:	5d                   	pop    %ebp
  803419:	c3                   	ret    

0080341a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80341a:	55                   	push   %ebp
  80341b:	89 e5                	mov    %esp,%ebp
  80341d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  803420:	a1 08 70 80 00       	mov    0x807008,%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	74 60                	je     803489 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  803429:	83 ec 08             	sub    $0x8,%esp
  80342c:	68 00 00 00 82       	push   $0x82000000
  803431:	68 00 00 00 80       	push   $0x80000000
  803436:	e8 0d 0d 00 00       	call   804148 <initialize_dynamic_allocator>
  80343b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80343e:	e8 f3 0a 00 00       	call   803f36 <sys_get_uheap_strategy>
  803443:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  803448:	a1 20 72 80 00       	mov    0x807220,%eax
  80344d:	05 00 10 00 00       	add    $0x1000,%eax
  803452:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  803457:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80345c:	a3 50 f2 81 00       	mov    %eax,0x81f250

		LIST_INIT(&page_alloc_list);
  803461:	c7 05 04 72 80 00 00 	movl   $0x0,0x807204
  803468:	00 00 00 
  80346b:	c7 05 08 72 80 00 00 	movl   $0x0,0x807208
  803472:	00 00 00 
  803475:	c7 05 10 72 80 00 00 	movl   $0x0,0x807210
  80347c:	00 00 00 

		__firstTimeFlag = 0;
  80347f:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  803486:	00 00 00 
	}
}
  803489:	90                   	nop
  80348a:	c9                   	leave  
  80348b:	c3                   	ret    

0080348c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80348c:	55                   	push   %ebp
  80348d:	89 e5                	mov    %esp,%ebp
  80348f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034a0:	83 ec 08             	sub    $0x8,%esp
  8034a3:	68 06 04 00 00       	push   $0x406
  8034a8:	50                   	push   %eax
  8034a9:	e8 d2 06 00 00       	call   803b80 <__sys_allocate_page>
  8034ae:	83 c4 10             	add    $0x10,%esp
  8034b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8034b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034b8:	79 17                	jns    8034d1 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8034ba:	83 ec 04             	sub    $0x4,%esp
  8034bd:	68 40 61 80 00       	push   $0x806140
  8034c2:	68 ea 00 00 00       	push   $0xea
  8034c7:	68 71 5f 80 00       	push   $0x805f71
  8034cc:	e8 31 e7 ff ff       	call   801c02 <_panic>
	return 0;
  8034d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034d6:	c9                   	leave  
  8034d7:	c3                   	ret    

008034d8 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8034d8:	55                   	push   %ebp
  8034d9:	89 e5                	mov    %esp,%ebp
  8034db:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034ec:	83 ec 0c             	sub    $0xc,%esp
  8034ef:	50                   	push   %eax
  8034f0:	e8 d2 06 00 00       	call   803bc7 <__sys_unmap_frame>
  8034f5:	83 c4 10             	add    $0x10,%esp
  8034f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8034fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ff:	79 17                	jns    803518 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	68 7c 61 80 00       	push   $0x80617c
  803509:	68 f5 00 00 00       	push   $0xf5
  80350e:	68 71 5f 80 00       	push   $0x805f71
  803513:	e8 ea e6 ff ff       	call   801c02 <_panic>
}
  803518:	90                   	nop
  803519:	c9                   	leave  
  80351a:	c3                   	ret    

0080351b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80351b:	55                   	push   %ebp
  80351c:	89 e5                	mov    %esp,%ebp
  80351e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803521:	e8 f4 fe ff ff       	call   80341a <uheap_init>
	if (size == 0) return NULL ;
  803526:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80352a:	75 0a                	jne    803536 <malloc+0x1b>
  80352c:	b8 00 00 00 00       	mov    $0x0,%eax
  803531:	e9 67 01 00 00       	jmp    80369d <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  803536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80353d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803544:	77 16                	ja     80355c <malloc+0x41>
		result = alloc_block(size);
  803546:	83 ec 0c             	sub    $0xc,%esp
  803549:	ff 75 08             	pushl  0x8(%ebp)
  80354c:	e8 46 0e 00 00       	call   804397 <alloc_block>
  803551:	83 c4 10             	add    $0x10,%esp
  803554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803557:	e9 3e 01 00 00       	jmp    80369a <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  80355c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  803563:	8b 55 08             	mov    0x8(%ebp),%edx
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	01 d0                	add    %edx,%eax
  80356b:	48                   	dec    %eax
  80356c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80356f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803572:	ba 00 00 00 00       	mov    $0x0,%edx
  803577:	f7 75 f0             	divl   -0x10(%ebp)
  80357a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357d:	29 d0                	sub    %edx,%eax
  80357f:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  803582:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803587:	85 c0                	test   %eax,%eax
  803589:	75 0a                	jne    803595 <malloc+0x7a>
			return NULL;
  80358b:	b8 00 00 00 00       	mov    $0x0,%eax
  803590:	e9 08 01 00 00       	jmp    80369d <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  803595:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 0f                	je     8035ad <malloc+0x92>
  80359e:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8035a4:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8035a9:	39 c2                	cmp    %eax,%edx
  8035ab:	73 0a                	jae    8035b7 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8035ad:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8035b2:	a3 50 f2 81 00       	mov    %eax,0x81f250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8035b7:	a1 44 f2 81 00       	mov    0x81f244,%eax
  8035bc:	83 f8 05             	cmp    $0x5,%eax
  8035bf:	75 11                	jne    8035d2 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8035c1:	83 ec 0c             	sub    $0xc,%esp
  8035c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8035c7:	e8 ff f9 ff ff       	call   802fcb <alloc_pages_custom_fit>
  8035cc:	83 c4 10             	add    $0x10,%esp
  8035cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8035d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d6:	0f 84 be 00 00 00    	je     80369a <malloc+0x17f>
			uint32 result_va = (uint32)result;
  8035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  8035e2:	83 ec 0c             	sub    $0xc,%esp
  8035e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8035e8:	e8 9a fb ff ff       	call   803187 <find_allocated_size>
  8035ed:	83 c4 10             	add    $0x10,%esp
  8035f0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8035f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035f7:	75 17                	jne    803610 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8035f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8035fc:	68 bc 61 80 00       	push   $0x8061bc
  803601:	68 24 01 00 00       	push   $0x124
  803606:	68 71 5f 80 00       	push   $0x805f71
  80360b:	e8 f2 e5 ff ff       	call   801c02 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  803610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803613:	f7 d0                	not    %eax
  803615:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803618:	73 1d                	jae    803637 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  80361a:	83 ec 0c             	sub    $0xc,%esp
  80361d:	ff 75 e0             	pushl  -0x20(%ebp)
  803620:	ff 75 e4             	pushl  -0x1c(%ebp)
  803623:	68 04 62 80 00       	push   $0x806204
  803628:	68 29 01 00 00       	push   $0x129
  80362d:	68 71 5f 80 00       	push   $0x805f71
  803632:	e8 cb e5 ff ff       	call   801c02 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  803637:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80363a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80363d:	01 d0                	add    %edx,%eax
  80363f:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  803642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803645:	85 c0                	test   %eax,%eax
  803647:	79 2c                	jns    803675 <malloc+0x15a>
  803649:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  803650:	77 23                	ja     803675 <malloc+0x15a>
  803652:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  803659:	77 1a                	ja     803675 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80365b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80365e:	85 c0                	test   %eax,%eax
  803660:	79 13                	jns    803675 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  803662:	83 ec 08             	sub    $0x8,%esp
  803665:	ff 75 e0             	pushl  -0x20(%ebp)
  803668:	ff 75 e4             	pushl  -0x1c(%ebp)
  80366b:	e8 de 09 00 00       	call   80404e <sys_allocate_user_mem>
  803670:	83 c4 10             	add    $0x10,%esp
  803673:	eb 25                	jmp    80369a <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  803675:	68 00 00 00 a0       	push   $0xa0000000
  80367a:	ff 75 dc             	pushl  -0x24(%ebp)
  80367d:	ff 75 e0             	pushl  -0x20(%ebp)
  803680:	ff 75 e4             	pushl  -0x1c(%ebp)
  803683:	ff 75 f4             	pushl  -0xc(%ebp)
  803686:	68 40 62 80 00       	push   $0x806240
  80368b:	68 33 01 00 00       	push   $0x133
  803690:	68 71 5f 80 00       	push   $0x805f71
  803695:	e8 68 e5 ff ff       	call   801c02 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  80369a:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  80369d:	c9                   	leave  
  80369e:	c3                   	ret    

0080369f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80369f:	55                   	push   %ebp
  8036a0:	89 e5                	mov    %esp,%ebp
  8036a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8036a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a9:	0f 84 26 01 00 00    	je     8037d5 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	79 1c                	jns    8036d8 <free+0x39>
  8036bc:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8036c3:	77 13                	ja     8036d8 <free+0x39>
		free_block(virtual_address);
  8036c5:	83 ec 0c             	sub    $0xc,%esp
  8036c8:	ff 75 08             	pushl  0x8(%ebp)
  8036cb:	e8 21 12 00 00       	call   8048f1 <free_block>
  8036d0:	83 c4 10             	add    $0x10,%esp
		return;
  8036d3:	e9 01 01 00 00       	jmp    8037d9 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8036d8:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8036dd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8036e0:	0f 82 d8 00 00 00    	jb     8037be <free+0x11f>
  8036e6:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8036ed:	0f 87 cb 00 00 00    	ja     8037be <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8036f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 17                	je     803716 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8036ff:	ff 75 08             	pushl  0x8(%ebp)
  803702:	68 b0 62 80 00       	push   $0x8062b0
  803707:	68 57 01 00 00       	push   $0x157
  80370c:	68 71 5f 80 00       	push   $0x805f71
  803711:	e8 ec e4 ff ff       	call   801c02 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  803716:	83 ec 0c             	sub    $0xc,%esp
  803719:	ff 75 08             	pushl  0x8(%ebp)
  80371c:	e8 66 fa ff ff       	call   803187 <find_allocated_size>
  803721:	83 c4 10             	add    $0x10,%esp
  803724:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  803727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80372b:	0f 84 a7 00 00 00    	je     8037d8 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  803731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803734:	f7 d0                	not    %eax
  803736:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803739:	73 1d                	jae    803758 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  80373b:	83 ec 0c             	sub    $0xc,%esp
  80373e:	ff 75 f0             	pushl  -0x10(%ebp)
  803741:	ff 75 f4             	pushl  -0xc(%ebp)
  803744:	68 d8 62 80 00       	push   $0x8062d8
  803749:	68 61 01 00 00       	push   $0x161
  80374e:	68 71 5f 80 00       	push   $0x805f71
  803753:	e8 aa e4 ff ff       	call   801c02 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  803758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80375b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375e:	01 d0                	add    %edx,%eax
  803760:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	79 19                	jns    803783 <free+0xe4>
  80376a:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  803771:	77 10                	ja     803783 <free+0xe4>
  803773:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80377a:	77 07                	ja     803783 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80377c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377f:	85 c0                	test   %eax,%eax
  803781:	78 2b                	js     8037ae <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  803783:	83 ec 0c             	sub    $0xc,%esp
  803786:	68 00 00 00 a0       	push   $0xa0000000
  80378b:	ff 75 ec             	pushl  -0x14(%ebp)
  80378e:	ff 75 f0             	pushl  -0x10(%ebp)
  803791:	ff 75 f4             	pushl  -0xc(%ebp)
  803794:	ff 75 f0             	pushl  -0x10(%ebp)
  803797:	ff 75 08             	pushl  0x8(%ebp)
  80379a:	68 14 63 80 00       	push   $0x806314
  80379f:	68 69 01 00 00       	push   $0x169
  8037a4:	68 71 5f 80 00       	push   $0x805f71
  8037a9:	e8 54 e4 ff ff       	call   801c02 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8037ae:	83 ec 0c             	sub    $0xc,%esp
  8037b1:	ff 75 08             	pushl  0x8(%ebp)
  8037b4:	e8 2c fa ff ff       	call   8031e5 <free_pages>
  8037b9:	83 c4 10             	add    $0x10,%esp
		return;
  8037bc:	eb 1b                	jmp    8037d9 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8037be:	ff 75 08             	pushl  0x8(%ebp)
  8037c1:	68 70 63 80 00       	push   $0x806370
  8037c6:	68 70 01 00 00       	push   $0x170
  8037cb:	68 71 5f 80 00       	push   $0x805f71
  8037d0:	e8 2d e4 ff ff       	call   801c02 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8037d5:	90                   	nop
  8037d6:	eb 01                	jmp    8037d9 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8037d8:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8037d9:	c9                   	leave  
  8037da:	c3                   	ret    

008037db <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8037db:	55                   	push   %ebp
  8037dc:	89 e5                	mov    %esp,%ebp
  8037de:	83 ec 38             	sub    $0x38,%esp
  8037e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8037e4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8037e7:	e8 2e fc ff ff       	call   80341a <uheap_init>
	if (size == 0) return NULL ;
  8037ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037f0:	75 0a                	jne    8037fc <smalloc+0x21>
  8037f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f7:	e9 3d 01 00 00       	jmp    803939 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8037fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  803802:	8b 45 0c             	mov    0xc(%ebp),%eax
  803805:	25 ff 0f 00 00       	and    $0xfff,%eax
  80380a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80380d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803811:	74 0e                	je     803821 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  803813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803816:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803819:	05 00 10 00 00       	add    $0x1000,%eax
  80381e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  803821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803824:	c1 e8 0c             	shr    $0xc,%eax
  803827:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  80382a:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80382f:	85 c0                	test   %eax,%eax
  803831:	75 0a                	jne    80383d <smalloc+0x62>
		return NULL;
  803833:	b8 00 00 00 00       	mov    $0x0,%eax
  803838:	e9 fc 00 00 00       	jmp    803939 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80383d:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803842:	85 c0                	test   %eax,%eax
  803844:	74 0f                	je     803855 <smalloc+0x7a>
  803846:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80384c:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803851:	39 c2                	cmp    %eax,%edx
  803853:	73 0a                	jae    80385f <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  803855:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80385a:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80385f:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803864:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803869:	29 c2                	sub    %eax,%edx
  80386b:	89 d0                	mov    %edx,%eax
  80386d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803870:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803876:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80387b:	29 c2                	sub    %eax,%edx
  80387d:	89 d0                	mov    %edx,%eax
  80387f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803885:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803888:	77 13                	ja     80389d <smalloc+0xc2>
  80388a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803890:	77 0b                	ja     80389d <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  803892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803895:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803898:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80389b:	73 0a                	jae    8038a7 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80389d:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a2:	e9 92 00 00 00       	jmp    803939 <smalloc+0x15e>
	}

	void *va = NULL;
  8038a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8038ae:	a1 44 f2 81 00       	mov    0x81f244,%eax
  8038b3:	83 f8 05             	cmp    $0x5,%eax
  8038b6:	75 11                	jne    8038c9 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8038b8:	83 ec 0c             	sub    $0xc,%esp
  8038bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8038be:	e8 08 f7 ff ff       	call   802fcb <alloc_pages_custom_fit>
  8038c3:	83 c4 10             	add    $0x10,%esp
  8038c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8038c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038cd:	75 27                	jne    8038f6 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8038cf:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8038d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8038dc:	89 c2                	mov    %eax,%edx
  8038de:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8038e3:	39 c2                	cmp    %eax,%edx
  8038e5:	73 07                	jae    8038ee <smalloc+0x113>
			return NULL;}
  8038e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ec:	eb 4b                	jmp    803939 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8038ee:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8038f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8038f6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8038fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8038fd:	50                   	push   %eax
  8038fe:	ff 75 0c             	pushl  0xc(%ebp)
  803901:	ff 75 08             	pushl  0x8(%ebp)
  803904:	e8 cb 03 00 00       	call   803cd4 <sys_create_shared_object>
  803909:	83 c4 10             	add    $0x10,%esp
  80390c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80390f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803913:	79 07                	jns    80391c <smalloc+0x141>
		return NULL;
  803915:	b8 00 00 00 00       	mov    $0x0,%eax
  80391a:	eb 1d                	jmp    803939 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80391c:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803921:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803924:	75 10                	jne    803936 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  803926:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	01 d0                	add    %edx,%eax
  803931:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}

	return va;
  803936:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  803939:	c9                   	leave  
  80393a:	c3                   	ret    

0080393b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80393b:	55                   	push   %ebp
  80393c:	89 e5                	mov    %esp,%ebp
  80393e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803941:	e8 d4 fa ff ff       	call   80341a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  803946:	83 ec 08             	sub    $0x8,%esp
  803949:	ff 75 0c             	pushl  0xc(%ebp)
  80394c:	ff 75 08             	pushl  0x8(%ebp)
  80394f:	e8 aa 03 00 00       	call   803cfe <sys_size_of_shared_object>
  803954:	83 c4 10             	add    $0x10,%esp
  803957:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80395a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80395e:	7f 0a                	jg     80396a <sget+0x2f>
		return NULL;
  803960:	b8 00 00 00 00       	mov    $0x0,%eax
  803965:	e9 32 01 00 00       	jmp    803a9c <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80396a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  803970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803973:	25 ff 0f 00 00       	and    $0xfff,%eax
  803978:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80397b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80397f:	74 0e                	je     80398f <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  803981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803984:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803987:	05 00 10 00 00       	add    $0x1000,%eax
  80398c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80398f:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803994:	85 c0                	test   %eax,%eax
  803996:	75 0a                	jne    8039a2 <sget+0x67>
		return NULL;
  803998:	b8 00 00 00 00       	mov    $0x0,%eax
  80399d:	e9 fa 00 00 00       	jmp    803a9c <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8039a2:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	74 0f                	je     8039ba <sget+0x7f>
  8039ab:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8039b1:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8039b6:	39 c2                	cmp    %eax,%edx
  8039b8:	73 0a                	jae    8039c4 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8039ba:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8039bf:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8039c4:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8039c9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8039ce:	29 c2                	sub    %eax,%edx
  8039d0:	89 d0                	mov    %edx,%eax
  8039d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8039d5:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8039db:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8039e0:	29 c2                	sub    %eax,%edx
  8039e2:	89 d0                	mov    %edx,%eax
  8039e4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039ed:	77 13                	ja     803a02 <sget+0xc7>
  8039ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039f2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039f5:	77 0b                	ja     803a02 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8039f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fa:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8039fd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a00:	73 0a                	jae    803a0c <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  803a02:	b8 00 00 00 00       	mov    $0x0,%eax
  803a07:	e9 90 00 00 00       	jmp    803a9c <sget+0x161>

	void *va = NULL;
  803a0c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  803a13:	a1 44 f2 81 00       	mov    0x81f244,%eax
  803a18:	83 f8 05             	cmp    $0x5,%eax
  803a1b:	75 11                	jne    803a2e <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  803a1d:	83 ec 0c             	sub    $0xc,%esp
  803a20:	ff 75 f4             	pushl  -0xc(%ebp)
  803a23:	e8 a3 f5 ff ff       	call   802fcb <alloc_pages_custom_fit>
  803a28:	83 c4 10             	add    $0x10,%esp
  803a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  803a2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a32:	75 27                	jne    803a5b <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803a34:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  803a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a3e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803a41:	89 c2                	mov    %eax,%edx
  803a43:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803a48:	39 c2                	cmp    %eax,%edx
  803a4a:	73 07                	jae    803a53 <sget+0x118>
			return NULL;
  803a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a51:	eb 49                	jmp    803a9c <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  803a53:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  803a5b:	83 ec 04             	sub    $0x4,%esp
  803a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  803a61:	ff 75 0c             	pushl  0xc(%ebp)
  803a64:	ff 75 08             	pushl  0x8(%ebp)
  803a67:	e8 af 02 00 00       	call   803d1b <sys_get_shared_object>
  803a6c:	83 c4 10             	add    $0x10,%esp
  803a6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  803a72:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803a76:	79 07                	jns    803a7f <sget+0x144>
		return NULL;
  803a78:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7d:	eb 1d                	jmp    803a9c <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  803a7f:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803a84:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803a87:	75 10                	jne    803a99 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  803a89:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a92:	01 d0                	add    %edx,%eax
  803a94:	a3 50 f2 81 00       	mov    %eax,0x81f250

	return va;
  803a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  803a9c:	c9                   	leave  
  803a9d:	c3                   	ret    

00803a9e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803a9e:	55                   	push   %ebp
  803a9f:	89 e5                	mov    %esp,%ebp
  803aa1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803aa4:	e8 71 f9 ff ff       	call   80341a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803aa9:	83 ec 04             	sub    $0x4,%esp
  803aac:	68 94 63 80 00       	push   $0x806394
  803ab1:	68 19 02 00 00       	push   $0x219
  803ab6:	68 71 5f 80 00       	push   $0x805f71
  803abb:	e8 42 e1 ff ff       	call   801c02 <_panic>

00803ac0 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803ac0:	55                   	push   %ebp
  803ac1:	89 e5                	mov    %esp,%ebp
  803ac3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803ac6:	83 ec 04             	sub    $0x4,%esp
  803ac9:	68 bc 63 80 00       	push   $0x8063bc
  803ace:	68 2b 02 00 00       	push   $0x22b
  803ad3:	68 71 5f 80 00       	push   $0x805f71
  803ad8:	e8 25 e1 ff ff       	call   801c02 <_panic>

00803add <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803add:	55                   	push   %ebp
  803ade:	89 e5                	mov    %esp,%ebp
  803ae0:	57                   	push   %edi
  803ae1:	56                   	push   %esi
  803ae2:	53                   	push   %ebx
  803ae3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803aec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803aef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803af2:	8b 7d 18             	mov    0x18(%ebp),%edi
  803af5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803af8:	cd 30                	int    $0x30
  803afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803b00:	83 c4 10             	add    $0x10,%esp
  803b03:	5b                   	pop    %ebx
  803b04:	5e                   	pop    %esi
  803b05:	5f                   	pop    %edi
  803b06:	5d                   	pop    %ebp
  803b07:	c3                   	ret    

00803b08 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803b08:	55                   	push   %ebp
  803b09:	89 e5                	mov    %esp,%ebp
  803b0b:	83 ec 04             	sub    $0x4,%esp
  803b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  803b11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803b14:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803b17:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1e:	6a 00                	push   $0x0
  803b20:	51                   	push   %ecx
  803b21:	52                   	push   %edx
  803b22:	ff 75 0c             	pushl  0xc(%ebp)
  803b25:	50                   	push   %eax
  803b26:	6a 00                	push   $0x0
  803b28:	e8 b0 ff ff ff       	call   803add <syscall>
  803b2d:	83 c4 18             	add    $0x18,%esp
}
  803b30:	90                   	nop
  803b31:	c9                   	leave  
  803b32:	c3                   	ret    

00803b33 <sys_cgetc>:

int
sys_cgetc(void)
{
  803b33:	55                   	push   %ebp
  803b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803b36:	6a 00                	push   $0x0
  803b38:	6a 00                	push   $0x0
  803b3a:	6a 00                	push   $0x0
  803b3c:	6a 00                	push   $0x0
  803b3e:	6a 00                	push   $0x0
  803b40:	6a 02                	push   $0x2
  803b42:	e8 96 ff ff ff       	call   803add <syscall>
  803b47:	83 c4 18             	add    $0x18,%esp
}
  803b4a:	c9                   	leave  
  803b4b:	c3                   	ret    

00803b4c <sys_lock_cons>:

void sys_lock_cons(void)
{
  803b4c:	55                   	push   %ebp
  803b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803b4f:	6a 00                	push   $0x0
  803b51:	6a 00                	push   $0x0
  803b53:	6a 00                	push   $0x0
  803b55:	6a 00                	push   $0x0
  803b57:	6a 00                	push   $0x0
  803b59:	6a 03                	push   $0x3
  803b5b:	e8 7d ff ff ff       	call   803add <syscall>
  803b60:	83 c4 18             	add    $0x18,%esp
}
  803b63:	90                   	nop
  803b64:	c9                   	leave  
  803b65:	c3                   	ret    

00803b66 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803b66:	55                   	push   %ebp
  803b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803b69:	6a 00                	push   $0x0
  803b6b:	6a 00                	push   $0x0
  803b6d:	6a 00                	push   $0x0
  803b6f:	6a 00                	push   $0x0
  803b71:	6a 00                	push   $0x0
  803b73:	6a 04                	push   $0x4
  803b75:	e8 63 ff ff ff       	call   803add <syscall>
  803b7a:	83 c4 18             	add    $0x18,%esp
}
  803b7d:	90                   	nop
  803b7e:	c9                   	leave  
  803b7f:	c3                   	ret    

00803b80 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803b80:	55                   	push   %ebp
  803b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b86:	8b 45 08             	mov    0x8(%ebp),%eax
  803b89:	6a 00                	push   $0x0
  803b8b:	6a 00                	push   $0x0
  803b8d:	6a 00                	push   $0x0
  803b8f:	52                   	push   %edx
  803b90:	50                   	push   %eax
  803b91:	6a 08                	push   $0x8
  803b93:	e8 45 ff ff ff       	call   803add <syscall>
  803b98:	83 c4 18             	add    $0x18,%esp
}
  803b9b:	c9                   	leave  
  803b9c:	c3                   	ret    

00803b9d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803b9d:	55                   	push   %ebp
  803b9e:	89 e5                	mov    %esp,%ebp
  803ba0:	56                   	push   %esi
  803ba1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803ba2:	8b 75 18             	mov    0x18(%ebp),%esi
  803ba5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803ba8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bae:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb1:	56                   	push   %esi
  803bb2:	53                   	push   %ebx
  803bb3:	51                   	push   %ecx
  803bb4:	52                   	push   %edx
  803bb5:	50                   	push   %eax
  803bb6:	6a 09                	push   $0x9
  803bb8:	e8 20 ff ff ff       	call   803add <syscall>
  803bbd:	83 c4 18             	add    $0x18,%esp
}
  803bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5d                   	pop    %ebp
  803bc6:	c3                   	ret    

00803bc7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803bc7:	55                   	push   %ebp
  803bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803bca:	6a 00                	push   $0x0
  803bcc:	6a 00                	push   $0x0
  803bce:	6a 00                	push   $0x0
  803bd0:	6a 00                	push   $0x0
  803bd2:	ff 75 08             	pushl  0x8(%ebp)
  803bd5:	6a 0a                	push   $0xa
  803bd7:	e8 01 ff ff ff       	call   803add <syscall>
  803bdc:	83 c4 18             	add    $0x18,%esp
}
  803bdf:	c9                   	leave  
  803be0:	c3                   	ret    

00803be1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803be1:	55                   	push   %ebp
  803be2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803be4:	6a 00                	push   $0x0
  803be6:	6a 00                	push   $0x0
  803be8:	6a 00                	push   $0x0
  803bea:	ff 75 0c             	pushl  0xc(%ebp)
  803bed:	ff 75 08             	pushl  0x8(%ebp)
  803bf0:	6a 0b                	push   $0xb
  803bf2:	e8 e6 fe ff ff       	call   803add <syscall>
  803bf7:	83 c4 18             	add    $0x18,%esp
}
  803bfa:	c9                   	leave  
  803bfb:	c3                   	ret    

00803bfc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803bfc:	55                   	push   %ebp
  803bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803bff:	6a 00                	push   $0x0
  803c01:	6a 00                	push   $0x0
  803c03:	6a 00                	push   $0x0
  803c05:	6a 00                	push   $0x0
  803c07:	6a 00                	push   $0x0
  803c09:	6a 0c                	push   $0xc
  803c0b:	e8 cd fe ff ff       	call   803add <syscall>
  803c10:	83 c4 18             	add    $0x18,%esp
}
  803c13:	c9                   	leave  
  803c14:	c3                   	ret    

00803c15 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803c15:	55                   	push   %ebp
  803c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803c18:	6a 00                	push   $0x0
  803c1a:	6a 00                	push   $0x0
  803c1c:	6a 00                	push   $0x0
  803c1e:	6a 00                	push   $0x0
  803c20:	6a 00                	push   $0x0
  803c22:	6a 0d                	push   $0xd
  803c24:	e8 b4 fe ff ff       	call   803add <syscall>
  803c29:	83 c4 18             	add    $0x18,%esp
}
  803c2c:	c9                   	leave  
  803c2d:	c3                   	ret    

00803c2e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803c2e:	55                   	push   %ebp
  803c2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803c31:	6a 00                	push   $0x0
  803c33:	6a 00                	push   $0x0
  803c35:	6a 00                	push   $0x0
  803c37:	6a 00                	push   $0x0
  803c39:	6a 00                	push   $0x0
  803c3b:	6a 0e                	push   $0xe
  803c3d:	e8 9b fe ff ff       	call   803add <syscall>
  803c42:	83 c4 18             	add    $0x18,%esp
}
  803c45:	c9                   	leave  
  803c46:	c3                   	ret    

00803c47 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803c47:	55                   	push   %ebp
  803c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803c4a:	6a 00                	push   $0x0
  803c4c:	6a 00                	push   $0x0
  803c4e:	6a 00                	push   $0x0
  803c50:	6a 00                	push   $0x0
  803c52:	6a 00                	push   $0x0
  803c54:	6a 0f                	push   $0xf
  803c56:	e8 82 fe ff ff       	call   803add <syscall>
  803c5b:	83 c4 18             	add    $0x18,%esp
}
  803c5e:	c9                   	leave  
  803c5f:	c3                   	ret    

00803c60 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803c60:	55                   	push   %ebp
  803c61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803c63:	6a 00                	push   $0x0
  803c65:	6a 00                	push   $0x0
  803c67:	6a 00                	push   $0x0
  803c69:	6a 00                	push   $0x0
  803c6b:	ff 75 08             	pushl  0x8(%ebp)
  803c6e:	6a 10                	push   $0x10
  803c70:	e8 68 fe ff ff       	call   803add <syscall>
  803c75:	83 c4 18             	add    $0x18,%esp
}
  803c78:	c9                   	leave  
  803c79:	c3                   	ret    

00803c7a <sys_scarce_memory>:

void sys_scarce_memory()
{
  803c7a:	55                   	push   %ebp
  803c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803c7d:	6a 00                	push   $0x0
  803c7f:	6a 00                	push   $0x0
  803c81:	6a 00                	push   $0x0
  803c83:	6a 00                	push   $0x0
  803c85:	6a 00                	push   $0x0
  803c87:	6a 11                	push   $0x11
  803c89:	e8 4f fe ff ff       	call   803add <syscall>
  803c8e:	83 c4 18             	add    $0x18,%esp
}
  803c91:	90                   	nop
  803c92:	c9                   	leave  
  803c93:	c3                   	ret    

00803c94 <sys_cputc>:

void
sys_cputc(const char c)
{
  803c94:	55                   	push   %ebp
  803c95:	89 e5                	mov    %esp,%ebp
  803c97:	83 ec 04             	sub    $0x4,%esp
  803c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803ca0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803ca4:	6a 00                	push   $0x0
  803ca6:	6a 00                	push   $0x0
  803ca8:	6a 00                	push   $0x0
  803caa:	6a 00                	push   $0x0
  803cac:	50                   	push   %eax
  803cad:	6a 01                	push   $0x1
  803caf:	e8 29 fe ff ff       	call   803add <syscall>
  803cb4:	83 c4 18             	add    $0x18,%esp
}
  803cb7:	90                   	nop
  803cb8:	c9                   	leave  
  803cb9:	c3                   	ret    

00803cba <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803cba:	55                   	push   %ebp
  803cbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803cbd:	6a 00                	push   $0x0
  803cbf:	6a 00                	push   $0x0
  803cc1:	6a 00                	push   $0x0
  803cc3:	6a 00                	push   $0x0
  803cc5:	6a 00                	push   $0x0
  803cc7:	6a 14                	push   $0x14
  803cc9:	e8 0f fe ff ff       	call   803add <syscall>
  803cce:	83 c4 18             	add    $0x18,%esp
}
  803cd1:	90                   	nop
  803cd2:	c9                   	leave  
  803cd3:	c3                   	ret    

00803cd4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803cd4:	55                   	push   %ebp
  803cd5:	89 e5                	mov    %esp,%ebp
  803cd7:	83 ec 04             	sub    $0x4,%esp
  803cda:	8b 45 10             	mov    0x10(%ebp),%eax
  803cdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803ce0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803ce3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cea:	6a 00                	push   $0x0
  803cec:	51                   	push   %ecx
  803ced:	52                   	push   %edx
  803cee:	ff 75 0c             	pushl  0xc(%ebp)
  803cf1:	50                   	push   %eax
  803cf2:	6a 15                	push   $0x15
  803cf4:	e8 e4 fd ff ff       	call   803add <syscall>
  803cf9:	83 c4 18             	add    $0x18,%esp
}
  803cfc:	c9                   	leave  
  803cfd:	c3                   	ret    

00803cfe <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803cfe:	55                   	push   %ebp
  803cff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d04:	8b 45 08             	mov    0x8(%ebp),%eax
  803d07:	6a 00                	push   $0x0
  803d09:	6a 00                	push   $0x0
  803d0b:	6a 00                	push   $0x0
  803d0d:	52                   	push   %edx
  803d0e:	50                   	push   %eax
  803d0f:	6a 16                	push   $0x16
  803d11:	e8 c7 fd ff ff       	call   803add <syscall>
  803d16:	83 c4 18             	add    $0x18,%esp
}
  803d19:	c9                   	leave  
  803d1a:	c3                   	ret    

00803d1b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803d1b:	55                   	push   %ebp
  803d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803d1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d24:	8b 45 08             	mov    0x8(%ebp),%eax
  803d27:	6a 00                	push   $0x0
  803d29:	6a 00                	push   $0x0
  803d2b:	51                   	push   %ecx
  803d2c:	52                   	push   %edx
  803d2d:	50                   	push   %eax
  803d2e:	6a 17                	push   $0x17
  803d30:	e8 a8 fd ff ff       	call   803add <syscall>
  803d35:	83 c4 18             	add    $0x18,%esp
}
  803d38:	c9                   	leave  
  803d39:	c3                   	ret    

00803d3a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803d3a:	55                   	push   %ebp
  803d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d40:	8b 45 08             	mov    0x8(%ebp),%eax
  803d43:	6a 00                	push   $0x0
  803d45:	6a 00                	push   $0x0
  803d47:	6a 00                	push   $0x0
  803d49:	52                   	push   %edx
  803d4a:	50                   	push   %eax
  803d4b:	6a 18                	push   $0x18
  803d4d:	e8 8b fd ff ff       	call   803add <syscall>
  803d52:	83 c4 18             	add    $0x18,%esp
}
  803d55:	c9                   	leave  
  803d56:	c3                   	ret    

00803d57 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803d57:	55                   	push   %ebp
  803d58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5d:	6a 00                	push   $0x0
  803d5f:	ff 75 14             	pushl  0x14(%ebp)
  803d62:	ff 75 10             	pushl  0x10(%ebp)
  803d65:	ff 75 0c             	pushl  0xc(%ebp)
  803d68:	50                   	push   %eax
  803d69:	6a 19                	push   $0x19
  803d6b:	e8 6d fd ff ff       	call   803add <syscall>
  803d70:	83 c4 18             	add    $0x18,%esp
}
  803d73:	c9                   	leave  
  803d74:	c3                   	ret    

00803d75 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803d75:	55                   	push   %ebp
  803d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803d78:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7b:	6a 00                	push   $0x0
  803d7d:	6a 00                	push   $0x0
  803d7f:	6a 00                	push   $0x0
  803d81:	6a 00                	push   $0x0
  803d83:	50                   	push   %eax
  803d84:	6a 1a                	push   $0x1a
  803d86:	e8 52 fd ff ff       	call   803add <syscall>
  803d8b:	83 c4 18             	add    $0x18,%esp
}
  803d8e:	90                   	nop
  803d8f:	c9                   	leave  
  803d90:	c3                   	ret    

00803d91 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803d91:	55                   	push   %ebp
  803d92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803d94:	8b 45 08             	mov    0x8(%ebp),%eax
  803d97:	6a 00                	push   $0x0
  803d99:	6a 00                	push   $0x0
  803d9b:	6a 00                	push   $0x0
  803d9d:	6a 00                	push   $0x0
  803d9f:	50                   	push   %eax
  803da0:	6a 1b                	push   $0x1b
  803da2:	e8 36 fd ff ff       	call   803add <syscall>
  803da7:	83 c4 18             	add    $0x18,%esp
}
  803daa:	c9                   	leave  
  803dab:	c3                   	ret    

00803dac <sys_getenvid>:

int32 sys_getenvid(void)
{
  803dac:	55                   	push   %ebp
  803dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803daf:	6a 00                	push   $0x0
  803db1:	6a 00                	push   $0x0
  803db3:	6a 00                	push   $0x0
  803db5:	6a 00                	push   $0x0
  803db7:	6a 00                	push   $0x0
  803db9:	6a 05                	push   $0x5
  803dbb:	e8 1d fd ff ff       	call   803add <syscall>
  803dc0:	83 c4 18             	add    $0x18,%esp
}
  803dc3:	c9                   	leave  
  803dc4:	c3                   	ret    

00803dc5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803dc5:	55                   	push   %ebp
  803dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803dc8:	6a 00                	push   $0x0
  803dca:	6a 00                	push   $0x0
  803dcc:	6a 00                	push   $0x0
  803dce:	6a 00                	push   $0x0
  803dd0:	6a 00                	push   $0x0
  803dd2:	6a 06                	push   $0x6
  803dd4:	e8 04 fd ff ff       	call   803add <syscall>
  803dd9:	83 c4 18             	add    $0x18,%esp
}
  803ddc:	c9                   	leave  
  803ddd:	c3                   	ret    

00803dde <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803dde:	55                   	push   %ebp
  803ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803de1:	6a 00                	push   $0x0
  803de3:	6a 00                	push   $0x0
  803de5:	6a 00                	push   $0x0
  803de7:	6a 00                	push   $0x0
  803de9:	6a 00                	push   $0x0
  803deb:	6a 07                	push   $0x7
  803ded:	e8 eb fc ff ff       	call   803add <syscall>
  803df2:	83 c4 18             	add    $0x18,%esp
}
  803df5:	c9                   	leave  
  803df6:	c3                   	ret    

00803df7 <sys_exit_env>:


void sys_exit_env(void)
{
  803df7:	55                   	push   %ebp
  803df8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803dfa:	6a 00                	push   $0x0
  803dfc:	6a 00                	push   $0x0
  803dfe:	6a 00                	push   $0x0
  803e00:	6a 00                	push   $0x0
  803e02:	6a 00                	push   $0x0
  803e04:	6a 1c                	push   $0x1c
  803e06:	e8 d2 fc ff ff       	call   803add <syscall>
  803e0b:	83 c4 18             	add    $0x18,%esp
}
  803e0e:	90                   	nop
  803e0f:	c9                   	leave  
  803e10:	c3                   	ret    

00803e11 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803e11:	55                   	push   %ebp
  803e12:	89 e5                	mov    %esp,%ebp
  803e14:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803e17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803e1a:	8d 50 04             	lea    0x4(%eax),%edx
  803e1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803e20:	6a 00                	push   $0x0
  803e22:	6a 00                	push   $0x0
  803e24:	6a 00                	push   $0x0
  803e26:	52                   	push   %edx
  803e27:	50                   	push   %eax
  803e28:	6a 1d                	push   $0x1d
  803e2a:	e8 ae fc ff ff       	call   803add <syscall>
  803e2f:	83 c4 18             	add    $0x18,%esp
	return result;
  803e32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803e38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803e3b:	89 01                	mov    %eax,(%ecx)
  803e3d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803e40:	8b 45 08             	mov    0x8(%ebp),%eax
  803e43:	c9                   	leave  
  803e44:	c2 04 00             	ret    $0x4

00803e47 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803e47:	55                   	push   %ebp
  803e48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803e4a:	6a 00                	push   $0x0
  803e4c:	6a 00                	push   $0x0
  803e4e:	ff 75 10             	pushl  0x10(%ebp)
  803e51:	ff 75 0c             	pushl  0xc(%ebp)
  803e54:	ff 75 08             	pushl  0x8(%ebp)
  803e57:	6a 13                	push   $0x13
  803e59:	e8 7f fc ff ff       	call   803add <syscall>
  803e5e:	83 c4 18             	add    $0x18,%esp
	return ;
  803e61:	90                   	nop
}
  803e62:	c9                   	leave  
  803e63:	c3                   	ret    

00803e64 <sys_rcr2>:
uint32 sys_rcr2()
{
  803e64:	55                   	push   %ebp
  803e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803e67:	6a 00                	push   $0x0
  803e69:	6a 00                	push   $0x0
  803e6b:	6a 00                	push   $0x0
  803e6d:	6a 00                	push   $0x0
  803e6f:	6a 00                	push   $0x0
  803e71:	6a 1e                	push   $0x1e
  803e73:	e8 65 fc ff ff       	call   803add <syscall>
  803e78:	83 c4 18             	add    $0x18,%esp
}
  803e7b:	c9                   	leave  
  803e7c:	c3                   	ret    

00803e7d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803e7d:	55                   	push   %ebp
  803e7e:	89 e5                	mov    %esp,%ebp
  803e80:	83 ec 04             	sub    $0x4,%esp
  803e83:	8b 45 08             	mov    0x8(%ebp),%eax
  803e86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803e89:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803e8d:	6a 00                	push   $0x0
  803e8f:	6a 00                	push   $0x0
  803e91:	6a 00                	push   $0x0
  803e93:	6a 00                	push   $0x0
  803e95:	50                   	push   %eax
  803e96:	6a 1f                	push   $0x1f
  803e98:	e8 40 fc ff ff       	call   803add <syscall>
  803e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  803ea0:	90                   	nop
}
  803ea1:	c9                   	leave  
  803ea2:	c3                   	ret    

00803ea3 <rsttst>:
void rsttst()
{
  803ea3:	55                   	push   %ebp
  803ea4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803ea6:	6a 00                	push   $0x0
  803ea8:	6a 00                	push   $0x0
  803eaa:	6a 00                	push   $0x0
  803eac:	6a 00                	push   $0x0
  803eae:	6a 00                	push   $0x0
  803eb0:	6a 21                	push   $0x21
  803eb2:	e8 26 fc ff ff       	call   803add <syscall>
  803eb7:	83 c4 18             	add    $0x18,%esp
	return ;
  803eba:	90                   	nop
}
  803ebb:	c9                   	leave  
  803ebc:	c3                   	ret    

00803ebd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803ebd:	55                   	push   %ebp
  803ebe:	89 e5                	mov    %esp,%ebp
  803ec0:	83 ec 04             	sub    $0x4,%esp
  803ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  803ec6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803ec9:	8b 55 18             	mov    0x18(%ebp),%edx
  803ecc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803ed0:	52                   	push   %edx
  803ed1:	50                   	push   %eax
  803ed2:	ff 75 10             	pushl  0x10(%ebp)
  803ed5:	ff 75 0c             	pushl  0xc(%ebp)
  803ed8:	ff 75 08             	pushl  0x8(%ebp)
  803edb:	6a 20                	push   $0x20
  803edd:	e8 fb fb ff ff       	call   803add <syscall>
  803ee2:	83 c4 18             	add    $0x18,%esp
	return ;
  803ee5:	90                   	nop
}
  803ee6:	c9                   	leave  
  803ee7:	c3                   	ret    

00803ee8 <chktst>:
void chktst(uint32 n)
{
  803ee8:	55                   	push   %ebp
  803ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803eeb:	6a 00                	push   $0x0
  803eed:	6a 00                	push   $0x0
  803eef:	6a 00                	push   $0x0
  803ef1:	6a 00                	push   $0x0
  803ef3:	ff 75 08             	pushl  0x8(%ebp)
  803ef6:	6a 22                	push   $0x22
  803ef8:	e8 e0 fb ff ff       	call   803add <syscall>
  803efd:	83 c4 18             	add    $0x18,%esp
	return ;
  803f00:	90                   	nop
}
  803f01:	c9                   	leave  
  803f02:	c3                   	ret    

00803f03 <inctst>:

void inctst()
{
  803f03:	55                   	push   %ebp
  803f04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803f06:	6a 00                	push   $0x0
  803f08:	6a 00                	push   $0x0
  803f0a:	6a 00                	push   $0x0
  803f0c:	6a 00                	push   $0x0
  803f0e:	6a 00                	push   $0x0
  803f10:	6a 23                	push   $0x23
  803f12:	e8 c6 fb ff ff       	call   803add <syscall>
  803f17:	83 c4 18             	add    $0x18,%esp
	return ;
  803f1a:	90                   	nop
}
  803f1b:	c9                   	leave  
  803f1c:	c3                   	ret    

00803f1d <gettst>:
uint32 gettst()
{
  803f1d:	55                   	push   %ebp
  803f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803f20:	6a 00                	push   $0x0
  803f22:	6a 00                	push   $0x0
  803f24:	6a 00                	push   $0x0
  803f26:	6a 00                	push   $0x0
  803f28:	6a 00                	push   $0x0
  803f2a:	6a 24                	push   $0x24
  803f2c:	e8 ac fb ff ff       	call   803add <syscall>
  803f31:	83 c4 18             	add    $0x18,%esp
}
  803f34:	c9                   	leave  
  803f35:	c3                   	ret    

00803f36 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803f36:	55                   	push   %ebp
  803f37:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803f39:	6a 00                	push   $0x0
  803f3b:	6a 00                	push   $0x0
  803f3d:	6a 00                	push   $0x0
  803f3f:	6a 00                	push   $0x0
  803f41:	6a 00                	push   $0x0
  803f43:	6a 25                	push   $0x25
  803f45:	e8 93 fb ff ff       	call   803add <syscall>
  803f4a:	83 c4 18             	add    $0x18,%esp
  803f4d:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  803f52:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  803f57:	c9                   	leave  
  803f58:	c3                   	ret    

00803f59 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803f59:	55                   	push   %ebp
  803f5a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5f:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803f64:	6a 00                	push   $0x0
  803f66:	6a 00                	push   $0x0
  803f68:	6a 00                	push   $0x0
  803f6a:	6a 00                	push   $0x0
  803f6c:	ff 75 08             	pushl  0x8(%ebp)
  803f6f:	6a 26                	push   $0x26
  803f71:	e8 67 fb ff ff       	call   803add <syscall>
  803f76:	83 c4 18             	add    $0x18,%esp
	return ;
  803f79:	90                   	nop
}
  803f7a:	c9                   	leave  
  803f7b:	c3                   	ret    

00803f7c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803f7c:	55                   	push   %ebp
  803f7d:	89 e5                	mov    %esp,%ebp
  803f7f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803f80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803f83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f89:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8c:	6a 00                	push   $0x0
  803f8e:	53                   	push   %ebx
  803f8f:	51                   	push   %ecx
  803f90:	52                   	push   %edx
  803f91:	50                   	push   %eax
  803f92:	6a 27                	push   $0x27
  803f94:	e8 44 fb ff ff       	call   803add <syscall>
  803f99:	83 c4 18             	add    $0x18,%esp
}
  803f9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803f9f:	c9                   	leave  
  803fa0:	c3                   	ret    

00803fa1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803fa1:	55                   	push   %ebp
  803fa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803faa:	6a 00                	push   $0x0
  803fac:	6a 00                	push   $0x0
  803fae:	6a 00                	push   $0x0
  803fb0:	52                   	push   %edx
  803fb1:	50                   	push   %eax
  803fb2:	6a 28                	push   $0x28
  803fb4:	e8 24 fb ff ff       	call   803add <syscall>
  803fb9:	83 c4 18             	add    $0x18,%esp
}
  803fbc:	c9                   	leave  
  803fbd:	c3                   	ret    

00803fbe <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803fbe:	55                   	push   %ebp
  803fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803fc1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803fca:	6a 00                	push   $0x0
  803fcc:	51                   	push   %ecx
  803fcd:	ff 75 10             	pushl  0x10(%ebp)
  803fd0:	52                   	push   %edx
  803fd1:	50                   	push   %eax
  803fd2:	6a 29                	push   $0x29
  803fd4:	e8 04 fb ff ff       	call   803add <syscall>
  803fd9:	83 c4 18             	add    $0x18,%esp
}
  803fdc:	c9                   	leave  
  803fdd:	c3                   	ret    

00803fde <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803fde:	55                   	push   %ebp
  803fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803fe1:	6a 00                	push   $0x0
  803fe3:	6a 00                	push   $0x0
  803fe5:	ff 75 10             	pushl  0x10(%ebp)
  803fe8:	ff 75 0c             	pushl  0xc(%ebp)
  803feb:	ff 75 08             	pushl  0x8(%ebp)
  803fee:	6a 12                	push   $0x12
  803ff0:	e8 e8 fa ff ff       	call   803add <syscall>
  803ff5:	83 c4 18             	add    $0x18,%esp
	return ;
  803ff8:	90                   	nop
}
  803ff9:	c9                   	leave  
  803ffa:	c3                   	ret    

00803ffb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803ffb:	55                   	push   %ebp
  803ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
  804001:	8b 45 08             	mov    0x8(%ebp),%eax
  804004:	6a 00                	push   $0x0
  804006:	6a 00                	push   $0x0
  804008:	6a 00                	push   $0x0
  80400a:	52                   	push   %edx
  80400b:	50                   	push   %eax
  80400c:	6a 2a                	push   $0x2a
  80400e:	e8 ca fa ff ff       	call   803add <syscall>
  804013:	83 c4 18             	add    $0x18,%esp
	return;
  804016:	90                   	nop
}
  804017:	c9                   	leave  
  804018:	c3                   	ret    

00804019 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  804019:	55                   	push   %ebp
  80401a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80401c:	6a 00                	push   $0x0
  80401e:	6a 00                	push   $0x0
  804020:	6a 00                	push   $0x0
  804022:	6a 00                	push   $0x0
  804024:	6a 00                	push   $0x0
  804026:	6a 2b                	push   $0x2b
  804028:	e8 b0 fa ff ff       	call   803add <syscall>
  80402d:	83 c4 18             	add    $0x18,%esp
}
  804030:	c9                   	leave  
  804031:	c3                   	ret    

00804032 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  804032:	55                   	push   %ebp
  804033:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  804035:	6a 00                	push   $0x0
  804037:	6a 00                	push   $0x0
  804039:	6a 00                	push   $0x0
  80403b:	ff 75 0c             	pushl  0xc(%ebp)
  80403e:	ff 75 08             	pushl  0x8(%ebp)
  804041:	6a 2d                	push   $0x2d
  804043:	e8 95 fa ff ff       	call   803add <syscall>
  804048:	83 c4 18             	add    $0x18,%esp
	return;
  80404b:	90                   	nop
}
  80404c:	c9                   	leave  
  80404d:	c3                   	ret    

0080404e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80404e:	55                   	push   %ebp
  80404f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  804051:	6a 00                	push   $0x0
  804053:	6a 00                	push   $0x0
  804055:	6a 00                	push   $0x0
  804057:	ff 75 0c             	pushl  0xc(%ebp)
  80405a:	ff 75 08             	pushl  0x8(%ebp)
  80405d:	6a 2c                	push   $0x2c
  80405f:	e8 79 fa ff ff       	call   803add <syscall>
  804064:	83 c4 18             	add    $0x18,%esp
	return ;
  804067:	90                   	nop
}
  804068:	c9                   	leave  
  804069:	c3                   	ret    

0080406a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80406a:	55                   	push   %ebp
  80406b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80406d:	8b 55 0c             	mov    0xc(%ebp),%edx
  804070:	8b 45 08             	mov    0x8(%ebp),%eax
  804073:	6a 00                	push   $0x0
  804075:	6a 00                	push   $0x0
  804077:	6a 00                	push   $0x0
  804079:	52                   	push   %edx
  80407a:	50                   	push   %eax
  80407b:	6a 2e                	push   $0x2e
  80407d:	e8 5b fa ff ff       	call   803add <syscall>
  804082:	83 c4 18             	add    $0x18,%esp
	return ;
  804085:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  804086:	c9                   	leave  
  804087:	c3                   	ret    

00804088 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  804088:	55                   	push   %ebp
  804089:	89 e5                	mov    %esp,%ebp
  80408b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80408e:	81 7d 08 40 72 80 00 	cmpl   $0x807240,0x8(%ebp)
  804095:	72 09                	jb     8040a0 <to_page_va+0x18>
  804097:	81 7d 08 40 f2 81 00 	cmpl   $0x81f240,0x8(%ebp)
  80409e:	72 14                	jb     8040b4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8040a0:	83 ec 04             	sub    $0x4,%esp
  8040a3:	68 e0 63 80 00       	push   $0x8063e0
  8040a8:	6a 15                	push   $0x15
  8040aa:	68 0b 64 80 00       	push   $0x80640b
  8040af:	e8 4e db ff ff       	call   801c02 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8040b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b7:	ba 40 72 80 00       	mov    $0x807240,%edx
  8040bc:	29 d0                	sub    %edx,%eax
  8040be:	c1 f8 02             	sar    $0x2,%eax
  8040c1:	89 c2                	mov    %eax,%edx
  8040c3:	89 d0                	mov    %edx,%eax
  8040c5:	c1 e0 02             	shl    $0x2,%eax
  8040c8:	01 d0                	add    %edx,%eax
  8040ca:	c1 e0 02             	shl    $0x2,%eax
  8040cd:	01 d0                	add    %edx,%eax
  8040cf:	c1 e0 02             	shl    $0x2,%eax
  8040d2:	01 d0                	add    %edx,%eax
  8040d4:	89 c1                	mov    %eax,%ecx
  8040d6:	c1 e1 08             	shl    $0x8,%ecx
  8040d9:	01 c8                	add    %ecx,%eax
  8040db:	89 c1                	mov    %eax,%ecx
  8040dd:	c1 e1 10             	shl    $0x10,%ecx
  8040e0:	01 c8                	add    %ecx,%eax
  8040e2:	01 c0                	add    %eax,%eax
  8040e4:	01 d0                	add    %edx,%eax
  8040e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8040e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ec:	c1 e0 0c             	shl    $0xc,%eax
  8040ef:	89 c2                	mov    %eax,%edx
  8040f1:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8040f6:	01 d0                	add    %edx,%eax
}
  8040f8:	c9                   	leave  
  8040f9:	c3                   	ret    

008040fa <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8040fa:	55                   	push   %ebp
  8040fb:	89 e5                	mov    %esp,%ebp
  8040fd:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  804100:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804105:	8b 55 08             	mov    0x8(%ebp),%edx
  804108:	29 c2                	sub    %eax,%edx
  80410a:	89 d0                	mov    %edx,%eax
  80410c:	c1 e8 0c             	shr    $0xc,%eax
  80410f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  804112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804116:	78 09                	js     804121 <to_page_info+0x27>
  804118:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80411f:	7e 14                	jle    804135 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  804121:	83 ec 04             	sub    $0x4,%esp
  804124:	68 24 64 80 00       	push   $0x806424
  804129:	6a 22                	push   $0x22
  80412b:	68 0b 64 80 00       	push   $0x80640b
  804130:	e8 cd da ff ff       	call   801c02 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  804135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804138:	89 d0                	mov    %edx,%eax
  80413a:	01 c0                	add    %eax,%eax
  80413c:	01 d0                	add    %edx,%eax
  80413e:	c1 e0 02             	shl    $0x2,%eax
  804141:	05 40 72 80 00       	add    $0x807240,%eax
}
  804146:	c9                   	leave  
  804147:	c3                   	ret    

00804148 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  804148:	55                   	push   %ebp
  804149:	89 e5                	mov    %esp,%ebp
  80414b:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80414e:	8b 45 08             	mov    0x8(%ebp),%eax
  804151:	05 00 00 00 02       	add    $0x2000000,%eax
  804156:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804159:	73 16                	jae    804171 <initialize_dynamic_allocator+0x29>
  80415b:	68 48 64 80 00       	push   $0x806448
  804160:	68 6e 64 80 00       	push   $0x80646e
  804165:	6a 34                	push   $0x34
  804167:	68 0b 64 80 00       	push   $0x80640b
  80416c:	e8 91 da ff ff       	call   801c02 <_panic>
		is_initialized = 1;
  804171:	c7 05 14 72 80 00 01 	movl   $0x1,0x807214
  804178:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  80417b:	8b 45 08             	mov    0x8(%ebp),%eax
  80417e:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd = daEnd;
  804183:	8b 45 0c             	mov    0xc(%ebp),%eax
  804186:	a3 20 72 80 00       	mov    %eax,0x807220

	LIST_INIT(&freePagesList);
  80418b:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  804192:	00 00 00 
  804195:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  80419c:	00 00 00 
  80419f:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  8041a6:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8041a9:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8041b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8041b7:	eb 36                	jmp    8041ef <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8041b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041bc:	c1 e0 04             	shl    $0x4,%eax
  8041bf:	05 60 f2 81 00       	add    $0x81f260,%eax
  8041c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041cd:	c1 e0 04             	shl    $0x4,%eax
  8041d0:	05 64 f2 81 00       	add    $0x81f264,%eax
  8041d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041de:	c1 e0 04             	shl    $0x4,%eax
  8041e1:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8041e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8041ec:	ff 45 f4             	incl   -0xc(%ebp)
  8041ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8041f5:	72 c2                	jb     8041b9 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8041f7:	8b 15 20 72 80 00    	mov    0x807220,%edx
  8041fd:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804202:	29 c2                	sub    %eax,%edx
  804204:	89 d0                	mov    %edx,%eax
  804206:	c1 e8 0c             	shr    $0xc,%eax
  804209:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  80420c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804213:	e9 c8 00 00 00       	jmp    8042e0 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  804218:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80421b:	89 d0                	mov    %edx,%eax
  80421d:	01 c0                	add    %eax,%eax
  80421f:	01 d0                	add    %edx,%eax
  804221:	c1 e0 02             	shl    $0x2,%eax
  804224:	05 48 72 80 00       	add    $0x807248,%eax
  804229:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  80422e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804231:	89 d0                	mov    %edx,%eax
  804233:	01 c0                	add    %eax,%eax
  804235:	01 d0                	add    %edx,%eax
  804237:	c1 e0 02             	shl    $0x2,%eax
  80423a:	05 4a 72 80 00       	add    $0x80724a,%eax
  80423f:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  804244:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80424a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80424d:	89 c8                	mov    %ecx,%eax
  80424f:	01 c0                	add    %eax,%eax
  804251:	01 c8                	add    %ecx,%eax
  804253:	c1 e0 02             	shl    $0x2,%eax
  804256:	05 44 72 80 00       	add    $0x807244,%eax
  80425b:	89 10                	mov    %edx,(%eax)
  80425d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804260:	89 d0                	mov    %edx,%eax
  804262:	01 c0                	add    %eax,%eax
  804264:	01 d0                	add    %edx,%eax
  804266:	c1 e0 02             	shl    $0x2,%eax
  804269:	05 44 72 80 00       	add    $0x807244,%eax
  80426e:	8b 00                	mov    (%eax),%eax
  804270:	85 c0                	test   %eax,%eax
  804272:	74 1b                	je     80428f <initialize_dynamic_allocator+0x147>
  804274:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80427a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80427d:	89 c8                	mov    %ecx,%eax
  80427f:	01 c0                	add    %eax,%eax
  804281:	01 c8                	add    %ecx,%eax
  804283:	c1 e0 02             	shl    $0x2,%eax
  804286:	05 40 72 80 00       	add    $0x807240,%eax
  80428b:	89 02                	mov    %eax,(%edx)
  80428d:	eb 16                	jmp    8042a5 <initialize_dynamic_allocator+0x15d>
  80428f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804292:	89 d0                	mov    %edx,%eax
  804294:	01 c0                	add    %eax,%eax
  804296:	01 d0                	add    %edx,%eax
  804298:	c1 e0 02             	shl    $0x2,%eax
  80429b:	05 40 72 80 00       	add    $0x807240,%eax
  8042a0:	a3 28 72 80 00       	mov    %eax,0x807228
  8042a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042a8:	89 d0                	mov    %edx,%eax
  8042aa:	01 c0                	add    %eax,%eax
  8042ac:	01 d0                	add    %edx,%eax
  8042ae:	c1 e0 02             	shl    $0x2,%eax
  8042b1:	05 40 72 80 00       	add    $0x807240,%eax
  8042b6:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8042bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042be:	89 d0                	mov    %edx,%eax
  8042c0:	01 c0                	add    %eax,%eax
  8042c2:	01 d0                	add    %edx,%eax
  8042c4:	c1 e0 02             	shl    $0x2,%eax
  8042c7:	05 40 72 80 00       	add    $0x807240,%eax
  8042cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042d2:	a1 34 72 80 00       	mov    0x807234,%eax
  8042d7:	40                   	inc    %eax
  8042d8:	a3 34 72 80 00       	mov    %eax,0x807234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  8042dd:	ff 45 f0             	incl   -0x10(%ebp)
  8042e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042e3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8042e6:	0f 82 2c ff ff ff    	jb     804218 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8042ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8042f2:	eb 2f                	jmp    804323 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  8042f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8042f7:	89 d0                	mov    %edx,%eax
  8042f9:	01 c0                	add    %eax,%eax
  8042fb:	01 d0                	add    %edx,%eax
  8042fd:	c1 e0 02             	shl    $0x2,%eax
  804300:	05 48 72 80 00       	add    $0x807248,%eax
  804305:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  80430a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80430d:	89 d0                	mov    %edx,%eax
  80430f:	01 c0                	add    %eax,%eax
  804311:	01 d0                	add    %edx,%eax
  804313:	c1 e0 02             	shl    $0x2,%eax
  804316:	05 4a 72 80 00       	add    $0x80724a,%eax
  80431b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  804320:	ff 45 ec             	incl   -0x14(%ebp)
  804323:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  80432a:	76 c8                	jbe    8042f4 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80432c:	90                   	nop
  80432d:	c9                   	leave  
  80432e:	c3                   	ret    

0080432f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80432f:	55                   	push   %ebp
  804330:	89 e5                	mov    %esp,%ebp
  804332:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  804335:	8b 55 08             	mov    0x8(%ebp),%edx
  804338:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80433d:	29 c2                	sub    %eax,%edx
  80433f:	89 d0                	mov    %edx,%eax
  804341:	c1 e8 0c             	shr    $0xc,%eax
  804344:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  804347:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80434a:	89 d0                	mov    %edx,%eax
  80434c:	01 c0                	add    %eax,%eax
  80434e:	01 d0                	add    %edx,%eax
  804350:	c1 e0 02             	shl    $0x2,%eax
  804353:	05 48 72 80 00       	add    $0x807248,%eax
  804358:	8b 00                	mov    (%eax),%eax
  80435a:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80435d:	c9                   	leave  
  80435e:	c3                   	ret    

0080435f <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80435f:	55                   	push   %ebp
  804360:	89 e5                	mov    %esp,%ebp
  804362:	83 ec 14             	sub    $0x14,%esp
  804365:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  804368:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80436c:	77 07                	ja     804375 <nearest_pow2_ceil.1513+0x16>
  80436e:	b8 01 00 00 00       	mov    $0x1,%eax
  804373:	eb 20                	jmp    804395 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  804375:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  80437c:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  80437f:	eb 08                	jmp    804389 <nearest_pow2_ceil.1513+0x2a>
  804381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804384:	01 c0                	add    %eax,%eax
  804386:	89 45 fc             	mov    %eax,-0x4(%ebp)
  804389:	d1 6d 08             	shrl   0x8(%ebp)
  80438c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804390:	75 ef                	jne    804381 <nearest_pow2_ceil.1513+0x22>
        return power;
  804392:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  804395:	c9                   	leave  
  804396:	c3                   	ret    

00804397 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804397:	55                   	push   %ebp
  804398:	89 e5                	mov    %esp,%ebp
  80439a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80439d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8043a4:	76 16                	jbe    8043bc <alloc_block+0x25>
  8043a6:	68 84 64 80 00       	push   $0x806484
  8043ab:	68 6e 64 80 00       	push   $0x80646e
  8043b0:	6a 72                	push   $0x72
  8043b2:	68 0b 64 80 00       	push   $0x80640b
  8043b7:	e8 46 d8 ff ff       	call   801c02 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8043bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043c0:	75 0a                	jne    8043cc <alloc_block+0x35>
  8043c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c7:	e9 bd 04 00 00       	jmp    804889 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8043cc:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8043d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8043d9:	73 06                	jae    8043e1 <alloc_block+0x4a>
        size = min_block_size;
  8043db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043de:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  8043e1:	83 ec 0c             	sub    $0xc,%esp
  8043e4:	8d 45 cc             	lea    -0x34(%ebp),%eax
  8043e7:	ff 75 08             	pushl  0x8(%ebp)
  8043ea:	89 c1                	mov    %eax,%ecx
  8043ec:	e8 6e ff ff ff       	call   80435f <nearest_pow2_ceil.1513>
  8043f1:	83 c4 10             	add    $0x10,%esp
  8043f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  8043f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8043fa:	83 ec 0c             	sub    $0xc,%esp
  8043fd:	8d 45 cc             	lea    -0x34(%ebp),%eax
  804400:	52                   	push   %edx
  804401:	89 c1                	mov    %eax,%ecx
  804403:	e8 83 04 00 00       	call   80488b <log2_ceil.1520>
  804408:	83 c4 10             	add    $0x10,%esp
  80440b:	83 e8 03             	sub    $0x3,%eax
  80440e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  804411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804414:	c1 e0 04             	shl    $0x4,%eax
  804417:	05 60 f2 81 00       	add    $0x81f260,%eax
  80441c:	8b 00                	mov    (%eax),%eax
  80441e:	85 c0                	test   %eax,%eax
  804420:	0f 84 d8 00 00 00    	je     8044fe <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  804426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804429:	c1 e0 04             	shl    $0x4,%eax
  80442c:	05 60 f2 81 00       	add    $0x81f260,%eax
  804431:	8b 00                	mov    (%eax),%eax
  804433:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  804436:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80443a:	75 17                	jne    804453 <alloc_block+0xbc>
  80443c:	83 ec 04             	sub    $0x4,%esp
  80443f:	68 a5 64 80 00       	push   $0x8064a5
  804444:	68 98 00 00 00       	push   $0x98
  804449:	68 0b 64 80 00       	push   $0x80640b
  80444e:	e8 af d7 ff ff       	call   801c02 <_panic>
  804453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804456:	8b 00                	mov    (%eax),%eax
  804458:	85 c0                	test   %eax,%eax
  80445a:	74 10                	je     80446c <alloc_block+0xd5>
  80445c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80445f:	8b 00                	mov    (%eax),%eax
  804461:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804464:	8b 52 04             	mov    0x4(%edx),%edx
  804467:	89 50 04             	mov    %edx,0x4(%eax)
  80446a:	eb 14                	jmp    804480 <alloc_block+0xe9>
  80446c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80446f:	8b 40 04             	mov    0x4(%eax),%eax
  804472:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804475:	c1 e2 04             	shl    $0x4,%edx
  804478:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  80447e:	89 02                	mov    %eax,(%edx)
  804480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804483:	8b 40 04             	mov    0x4(%eax),%eax
  804486:	85 c0                	test   %eax,%eax
  804488:	74 0f                	je     804499 <alloc_block+0x102>
  80448a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80448d:	8b 40 04             	mov    0x4(%eax),%eax
  804490:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804493:	8b 12                	mov    (%edx),%edx
  804495:	89 10                	mov    %edx,(%eax)
  804497:	eb 13                	jmp    8044ac <alloc_block+0x115>
  804499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80449c:	8b 00                	mov    (%eax),%eax
  80449e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044a1:	c1 e2 04             	shl    $0x4,%edx
  8044a4:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8044aa:	89 02                	mov    %eax,(%edx)
  8044ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044c2:	c1 e0 04             	shl    $0x4,%eax
  8044c5:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8044ca:	8b 00                	mov    (%eax),%eax
  8044cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8044cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d2:	c1 e0 04             	shl    $0x4,%eax
  8044d5:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8044da:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8044dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044df:	83 ec 0c             	sub    $0xc,%esp
  8044e2:	50                   	push   %eax
  8044e3:	e8 12 fc ff ff       	call   8040fa <to_page_info>
  8044e8:	83 c4 10             	add    $0x10,%esp
  8044eb:	89 c2                	mov    %eax,%edx
  8044ed:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8044f1:	48                   	dec    %eax
  8044f2:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8044f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044f9:	e9 8b 03 00 00       	jmp    804889 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8044fe:	a1 28 72 80 00       	mov    0x807228,%eax
  804503:	85 c0                	test   %eax,%eax
  804505:	0f 84 64 02 00 00    	je     80476f <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  80450b:	a1 28 72 80 00       	mov    0x807228,%eax
  804510:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  804513:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804517:	75 17                	jne    804530 <alloc_block+0x199>
  804519:	83 ec 04             	sub    $0x4,%esp
  80451c:	68 a5 64 80 00       	push   $0x8064a5
  804521:	68 a0 00 00 00       	push   $0xa0
  804526:	68 0b 64 80 00       	push   $0x80640b
  80452b:	e8 d2 d6 ff ff       	call   801c02 <_panic>
  804530:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804533:	8b 00                	mov    (%eax),%eax
  804535:	85 c0                	test   %eax,%eax
  804537:	74 10                	je     804549 <alloc_block+0x1b2>
  804539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80453c:	8b 00                	mov    (%eax),%eax
  80453e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804541:	8b 52 04             	mov    0x4(%edx),%edx
  804544:	89 50 04             	mov    %edx,0x4(%eax)
  804547:	eb 0b                	jmp    804554 <alloc_block+0x1bd>
  804549:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80454c:	8b 40 04             	mov    0x4(%eax),%eax
  80454f:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804554:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804557:	8b 40 04             	mov    0x4(%eax),%eax
  80455a:	85 c0                	test   %eax,%eax
  80455c:	74 0f                	je     80456d <alloc_block+0x1d6>
  80455e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804561:	8b 40 04             	mov    0x4(%eax),%eax
  804564:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804567:	8b 12                	mov    (%edx),%edx
  804569:	89 10                	mov    %edx,(%eax)
  80456b:	eb 0a                	jmp    804577 <alloc_block+0x1e0>
  80456d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804570:	8b 00                	mov    (%eax),%eax
  804572:	a3 28 72 80 00       	mov    %eax,0x807228
  804577:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80457a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804580:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80458a:	a1 34 72 80 00       	mov    0x807234,%eax
  80458f:	48                   	dec    %eax
  804590:	a3 34 72 80 00       	mov    %eax,0x807234

        page_info_e->block_size = pow;
  804595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804598:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80459b:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  80459f:	b8 00 10 00 00       	mov    $0x1000,%eax
  8045a4:	99                   	cltd   
  8045a5:	f7 7d e8             	idivl  -0x18(%ebp)
  8045a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8045ab:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8045af:	83 ec 0c             	sub    $0xc,%esp
  8045b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8045b5:	e8 ce fa ff ff       	call   804088 <to_page_va>
  8045ba:	83 c4 10             	add    $0x10,%esp
  8045bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8045c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8045c3:	83 ec 0c             	sub    $0xc,%esp
  8045c6:	50                   	push   %eax
  8045c7:	e8 c0 ee ff ff       	call   80348c <get_page>
  8045cc:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8045cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8045d6:	e9 aa 00 00 00       	jmp    804685 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  8045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045de:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  8045e2:	89 c2                	mov    %eax,%edx
  8045e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8045e7:	01 d0                	add    %edx,%eax
  8045e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8045ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8045f0:	75 17                	jne    804609 <alloc_block+0x272>
  8045f2:	83 ec 04             	sub    $0x4,%esp
  8045f5:	68 c4 64 80 00       	push   $0x8064c4
  8045fa:	68 aa 00 00 00       	push   $0xaa
  8045ff:	68 0b 64 80 00       	push   $0x80640b
  804604:	e8 f9 d5 ff ff       	call   801c02 <_panic>
  804609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80460c:	c1 e0 04             	shl    $0x4,%eax
  80460f:	05 64 f2 81 00       	add    $0x81f264,%eax
  804614:	8b 10                	mov    (%eax),%edx
  804616:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804619:	89 50 04             	mov    %edx,0x4(%eax)
  80461c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80461f:	8b 40 04             	mov    0x4(%eax),%eax
  804622:	85 c0                	test   %eax,%eax
  804624:	74 14                	je     80463a <alloc_block+0x2a3>
  804626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804629:	c1 e0 04             	shl    $0x4,%eax
  80462c:	05 64 f2 81 00       	add    $0x81f264,%eax
  804631:	8b 00                	mov    (%eax),%eax
  804633:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804636:	89 10                	mov    %edx,(%eax)
  804638:	eb 11                	jmp    80464b <alloc_block+0x2b4>
  80463a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80463d:	c1 e0 04             	shl    $0x4,%eax
  804640:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804646:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804649:	89 02                	mov    %eax,(%edx)
  80464b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80464e:	c1 e0 04             	shl    $0x4,%eax
  804651:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804657:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80465a:	89 02                	mov    %eax,(%edx)
  80465c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80465f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804668:	c1 e0 04             	shl    $0x4,%eax
  80466b:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804670:	8b 00                	mov    (%eax),%eax
  804672:	8d 50 01             	lea    0x1(%eax),%edx
  804675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804678:	c1 e0 04             	shl    $0x4,%eax
  80467b:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804680:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  804682:	ff 45 f4             	incl   -0xc(%ebp)
  804685:	b8 00 10 00 00       	mov    $0x1000,%eax
  80468a:	99                   	cltd   
  80468b:	f7 7d e8             	idivl  -0x18(%ebp)
  80468e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804691:	0f 8f 44 ff ff ff    	jg     8045db <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  804697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80469a:	c1 e0 04             	shl    $0x4,%eax
  80469d:	05 60 f2 81 00       	add    $0x81f260,%eax
  8046a2:	8b 00                	mov    (%eax),%eax
  8046a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8046a7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8046ab:	75 17                	jne    8046c4 <alloc_block+0x32d>
  8046ad:	83 ec 04             	sub    $0x4,%esp
  8046b0:	68 a5 64 80 00       	push   $0x8064a5
  8046b5:	68 ae 00 00 00       	push   $0xae
  8046ba:	68 0b 64 80 00       	push   $0x80640b
  8046bf:	e8 3e d5 ff ff       	call   801c02 <_panic>
  8046c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8046c7:	8b 00                	mov    (%eax),%eax
  8046c9:	85 c0                	test   %eax,%eax
  8046cb:	74 10                	je     8046dd <alloc_block+0x346>
  8046cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8046d0:	8b 00                	mov    (%eax),%eax
  8046d2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8046d5:	8b 52 04             	mov    0x4(%edx),%edx
  8046d8:	89 50 04             	mov    %edx,0x4(%eax)
  8046db:	eb 14                	jmp    8046f1 <alloc_block+0x35a>
  8046dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8046e0:	8b 40 04             	mov    0x4(%eax),%eax
  8046e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046e6:	c1 e2 04             	shl    $0x4,%edx
  8046e9:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8046ef:	89 02                	mov    %eax,(%edx)
  8046f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8046f4:	8b 40 04             	mov    0x4(%eax),%eax
  8046f7:	85 c0                	test   %eax,%eax
  8046f9:	74 0f                	je     80470a <alloc_block+0x373>
  8046fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8046fe:	8b 40 04             	mov    0x4(%eax),%eax
  804701:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804704:	8b 12                	mov    (%edx),%edx
  804706:	89 10                	mov    %edx,(%eax)
  804708:	eb 13                	jmp    80471d <alloc_block+0x386>
  80470a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80470d:	8b 00                	mov    (%eax),%eax
  80470f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804712:	c1 e2 04             	shl    $0x4,%edx
  804715:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  80471b:	89 02                	mov    %eax,(%edx)
  80471d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804726:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804729:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804733:	c1 e0 04             	shl    $0x4,%eax
  804736:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80473b:	8b 00                	mov    (%eax),%eax
  80473d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804743:	c1 e0 04             	shl    $0x4,%eax
  804746:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80474b:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80474d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804750:	83 ec 0c             	sub    $0xc,%esp
  804753:	50                   	push   %eax
  804754:	e8 a1 f9 ff ff       	call   8040fa <to_page_info>
  804759:	83 c4 10             	add    $0x10,%esp
  80475c:	89 c2                	mov    %eax,%edx
  80475e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  804762:	48                   	dec    %eax
  804763:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  804767:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80476a:	e9 1a 01 00 00       	jmp    804889 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80476f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804772:	40                   	inc    %eax
  804773:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804776:	e9 ed 00 00 00       	jmp    804868 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80477b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80477e:	c1 e0 04             	shl    $0x4,%eax
  804781:	05 60 f2 81 00       	add    $0x81f260,%eax
  804786:	8b 00                	mov    (%eax),%eax
  804788:	85 c0                	test   %eax,%eax
  80478a:	0f 84 d5 00 00 00    	je     804865 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  804790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804793:	c1 e0 04             	shl    $0x4,%eax
  804796:	05 60 f2 81 00       	add    $0x81f260,%eax
  80479b:	8b 00                	mov    (%eax),%eax
  80479d:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8047a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8047a4:	75 17                	jne    8047bd <alloc_block+0x426>
  8047a6:	83 ec 04             	sub    $0x4,%esp
  8047a9:	68 a5 64 80 00       	push   $0x8064a5
  8047ae:	68 b8 00 00 00       	push   $0xb8
  8047b3:	68 0b 64 80 00       	push   $0x80640b
  8047b8:	e8 45 d4 ff ff       	call   801c02 <_panic>
  8047bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8047c0:	8b 00                	mov    (%eax),%eax
  8047c2:	85 c0                	test   %eax,%eax
  8047c4:	74 10                	je     8047d6 <alloc_block+0x43f>
  8047c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8047c9:	8b 00                	mov    (%eax),%eax
  8047cb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8047ce:	8b 52 04             	mov    0x4(%edx),%edx
  8047d1:	89 50 04             	mov    %edx,0x4(%eax)
  8047d4:	eb 14                	jmp    8047ea <alloc_block+0x453>
  8047d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8047d9:	8b 40 04             	mov    0x4(%eax),%eax
  8047dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047df:	c1 e2 04             	shl    $0x4,%edx
  8047e2:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8047e8:	89 02                	mov    %eax,(%edx)
  8047ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8047ed:	8b 40 04             	mov    0x4(%eax),%eax
  8047f0:	85 c0                	test   %eax,%eax
  8047f2:	74 0f                	je     804803 <alloc_block+0x46c>
  8047f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8047f7:	8b 40 04             	mov    0x4(%eax),%eax
  8047fa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8047fd:	8b 12                	mov    (%edx),%edx
  8047ff:	89 10                	mov    %edx,(%eax)
  804801:	eb 13                	jmp    804816 <alloc_block+0x47f>
  804803:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804806:	8b 00                	mov    (%eax),%eax
  804808:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80480b:	c1 e2 04             	shl    $0x4,%edx
  80480e:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804814:	89 02                	mov    %eax,(%edx)
  804816:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80481f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804822:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80482c:	c1 e0 04             	shl    $0x4,%eax
  80482f:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804834:	8b 00                	mov    (%eax),%eax
  804836:	8d 50 ff             	lea    -0x1(%eax),%edx
  804839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80483c:	c1 e0 04             	shl    $0x4,%eax
  80483f:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804844:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  804846:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804849:	83 ec 0c             	sub    $0xc,%esp
  80484c:	50                   	push   %eax
  80484d:	e8 a8 f8 ff ff       	call   8040fa <to_page_info>
  804852:	83 c4 10             	add    $0x10,%esp
  804855:	89 c2                	mov    %eax,%edx
  804857:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80485b:	48                   	dec    %eax
  80485c:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  804860:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804863:	eb 24                	jmp    804889 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  804865:	ff 45 f0             	incl   -0x10(%ebp)
  804868:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80486c:	0f 8e 09 ff ff ff    	jle    80477b <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  804872:	83 ec 04             	sub    $0x4,%esp
  804875:	68 e7 64 80 00       	push   $0x8064e7
  80487a:	68 bf 00 00 00       	push   $0xbf
  80487f:	68 0b 64 80 00       	push   $0x80640b
  804884:	e8 79 d3 ff ff       	call   801c02 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804889:	c9                   	leave  
  80488a:	c3                   	ret    

0080488b <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80488b:	55                   	push   %ebp
  80488c:	89 e5                	mov    %esp,%ebp
  80488e:	83 ec 14             	sub    $0x14,%esp
  804891:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  804894:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804898:	75 07                	jne    8048a1 <log2_ceil.1520+0x16>
  80489a:	b8 00 00 00 00       	mov    $0x0,%eax
  80489f:	eb 1b                	jmp    8048bc <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8048a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8048a8:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8048ab:	eb 06                	jmp    8048b3 <log2_ceil.1520+0x28>
            x >>= 1;
  8048ad:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8048b0:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8048b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8048b7:	75 f4                	jne    8048ad <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8048b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8048bc:	c9                   	leave  
  8048bd:	c3                   	ret    

008048be <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8048be:	55                   	push   %ebp
  8048bf:	89 e5                	mov    %esp,%ebp
  8048c1:	83 ec 14             	sub    $0x14,%esp
  8048c4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8048c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8048cb:	75 07                	jne    8048d4 <log2_ceil.1547+0x16>
  8048cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8048d2:	eb 1b                	jmp    8048ef <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8048d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8048db:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8048de:	eb 06                	jmp    8048e6 <log2_ceil.1547+0x28>
			x >>= 1;
  8048e0:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8048e3:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8048e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8048ea:	75 f4                	jne    8048e0 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8048ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8048ef:	c9                   	leave  
  8048f0:	c3                   	ret    

008048f1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8048f1:	55                   	push   %ebp
  8048f2:	89 e5                	mov    %esp,%ebp
  8048f4:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8048f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8048fa:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8048ff:	39 c2                	cmp    %eax,%edx
  804901:	72 0c                	jb     80490f <free_block+0x1e>
  804903:	8b 55 08             	mov    0x8(%ebp),%edx
  804906:	a1 20 72 80 00       	mov    0x807220,%eax
  80490b:	39 c2                	cmp    %eax,%edx
  80490d:	72 19                	jb     804928 <free_block+0x37>
  80490f:	68 ec 64 80 00       	push   $0x8064ec
  804914:	68 6e 64 80 00       	push   $0x80646e
  804919:	68 d0 00 00 00       	push   $0xd0
  80491e:	68 0b 64 80 00       	push   $0x80640b
  804923:	e8 da d2 ff ff       	call   801c02 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  804928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80492c:	0f 84 42 03 00 00    	je     804c74 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  804932:	8b 55 08             	mov    0x8(%ebp),%edx
  804935:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80493a:	39 c2                	cmp    %eax,%edx
  80493c:	72 0c                	jb     80494a <free_block+0x59>
  80493e:	8b 55 08             	mov    0x8(%ebp),%edx
  804941:	a1 20 72 80 00       	mov    0x807220,%eax
  804946:	39 c2                	cmp    %eax,%edx
  804948:	72 17                	jb     804961 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80494a:	83 ec 04             	sub    $0x4,%esp
  80494d:	68 24 65 80 00       	push   $0x806524
  804952:	68 e6 00 00 00       	push   $0xe6
  804957:	68 0b 64 80 00       	push   $0x80640b
  80495c:	e8 a1 d2 ff ff       	call   801c02 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  804961:	8b 55 08             	mov    0x8(%ebp),%edx
  804964:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804969:	29 c2                	sub    %eax,%edx
  80496b:	89 d0                	mov    %edx,%eax
  80496d:	83 e0 07             	and    $0x7,%eax
  804970:	85 c0                	test   %eax,%eax
  804972:	74 17                	je     80498b <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  804974:	83 ec 04             	sub    $0x4,%esp
  804977:	68 58 65 80 00       	push   $0x806558
  80497c:	68 ea 00 00 00       	push   $0xea
  804981:	68 0b 64 80 00       	push   $0x80640b
  804986:	e8 77 d2 ff ff       	call   801c02 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80498b:	8b 45 08             	mov    0x8(%ebp),%eax
  80498e:	83 ec 0c             	sub    $0xc,%esp
  804991:	50                   	push   %eax
  804992:	e8 63 f7 ff ff       	call   8040fa <to_page_info>
  804997:	83 c4 10             	add    $0x10,%esp
  80499a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80499d:	83 ec 0c             	sub    $0xc,%esp
  8049a0:	ff 75 08             	pushl  0x8(%ebp)
  8049a3:	e8 87 f9 ff ff       	call   80432f <get_block_size>
  8049a8:	83 c4 10             	add    $0x10,%esp
  8049ab:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8049ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8049b2:	75 17                	jne    8049cb <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8049b4:	83 ec 04             	sub    $0x4,%esp
  8049b7:	68 84 65 80 00       	push   $0x806584
  8049bc:	68 f1 00 00 00       	push   $0xf1
  8049c1:	68 0b 64 80 00       	push   $0x80640b
  8049c6:	e8 37 d2 ff ff       	call   801c02 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8049cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8049ce:	83 ec 0c             	sub    $0xc,%esp
  8049d1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8049d4:	52                   	push   %edx
  8049d5:	89 c1                	mov    %eax,%ecx
  8049d7:	e8 e2 fe ff ff       	call   8048be <log2_ceil.1547>
  8049dc:	83 c4 10             	add    $0x10,%esp
  8049df:	83 e8 03             	sub    $0x3,%eax
  8049e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8049e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8049e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8049eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8049ef:	75 17                	jne    804a08 <free_block+0x117>
  8049f1:	83 ec 04             	sub    $0x4,%esp
  8049f4:	68 d0 65 80 00       	push   $0x8065d0
  8049f9:	68 f6 00 00 00       	push   $0xf6
  8049fe:	68 0b 64 80 00       	push   $0x80640b
  804a03:	e8 fa d1 ff ff       	call   801c02 <_panic>
  804a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a0b:	c1 e0 04             	shl    $0x4,%eax
  804a0e:	05 60 f2 81 00       	add    $0x81f260,%eax
  804a13:	8b 10                	mov    (%eax),%edx
  804a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a18:	89 10                	mov    %edx,(%eax)
  804a1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a1d:	8b 00                	mov    (%eax),%eax
  804a1f:	85 c0                	test   %eax,%eax
  804a21:	74 15                	je     804a38 <free_block+0x147>
  804a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a26:	c1 e0 04             	shl    $0x4,%eax
  804a29:	05 60 f2 81 00       	add    $0x81f260,%eax
  804a2e:	8b 00                	mov    (%eax),%eax
  804a30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804a33:	89 50 04             	mov    %edx,0x4(%eax)
  804a36:	eb 11                	jmp    804a49 <free_block+0x158>
  804a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a3b:	c1 e0 04             	shl    $0x4,%eax
  804a3e:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a47:	89 02                	mov    %eax,(%edx)
  804a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a4c:	c1 e0 04             	shl    $0x4,%eax
  804a4f:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a58:	89 02                	mov    %eax,(%edx)
  804a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a67:	c1 e0 04             	shl    $0x4,%eax
  804a6a:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a6f:	8b 00                	mov    (%eax),%eax
  804a71:	8d 50 01             	lea    0x1(%eax),%edx
  804a74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a77:	c1 e0 04             	shl    $0x4,%eax
  804a7a:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a7f:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  804a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a84:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804a88:	40                   	inc    %eax
  804a89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a8c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  804a90:	8b 55 08             	mov    0x8(%ebp),%edx
  804a93:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804a98:	29 c2                	sub    %eax,%edx
  804a9a:	89 d0                	mov    %edx,%eax
  804a9c:	c1 e8 0c             	shr    $0xc,%eax
  804a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  804aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804aa5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804aa9:	0f b7 c8             	movzwl %ax,%ecx
  804aac:	b8 00 10 00 00       	mov    $0x1000,%eax
  804ab1:	99                   	cltd   
  804ab2:	f7 7d e8             	idivl  -0x18(%ebp)
  804ab5:	39 c1                	cmp    %eax,%ecx
  804ab7:	0f 85 b8 01 00 00    	jne    804c75 <free_block+0x384>
    	uint32 blocks_removed = 0;
  804abd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  804ac4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ac7:	c1 e0 04             	shl    $0x4,%eax
  804aca:	05 60 f2 81 00       	add    $0x81f260,%eax
  804acf:	8b 00                	mov    (%eax),%eax
  804ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804ad4:	e9 d5 00 00 00       	jmp    804bae <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  804ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804adc:	8b 00                	mov    (%eax),%eax
  804ade:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  804ae1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804ae4:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804ae9:	29 c2                	sub    %eax,%edx
  804aeb:	89 d0                	mov    %edx,%eax
  804aed:	c1 e8 0c             	shr    $0xc,%eax
  804af0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  804af3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804af6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  804af9:	0f 85 a9 00 00 00    	jne    804ba8 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  804aff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804b03:	75 17                	jne    804b1c <free_block+0x22b>
  804b05:	83 ec 04             	sub    $0x4,%esp
  804b08:	68 a5 64 80 00       	push   $0x8064a5
  804b0d:	68 04 01 00 00       	push   $0x104
  804b12:	68 0b 64 80 00       	push   $0x80640b
  804b17:	e8 e6 d0 ff ff       	call   801c02 <_panic>
  804b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b1f:	8b 00                	mov    (%eax),%eax
  804b21:	85 c0                	test   %eax,%eax
  804b23:	74 10                	je     804b35 <free_block+0x244>
  804b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b28:	8b 00                	mov    (%eax),%eax
  804b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804b2d:	8b 52 04             	mov    0x4(%edx),%edx
  804b30:	89 50 04             	mov    %edx,0x4(%eax)
  804b33:	eb 14                	jmp    804b49 <free_block+0x258>
  804b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b38:	8b 40 04             	mov    0x4(%eax),%eax
  804b3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b3e:	c1 e2 04             	shl    $0x4,%edx
  804b41:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804b47:	89 02                	mov    %eax,(%edx)
  804b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b4c:	8b 40 04             	mov    0x4(%eax),%eax
  804b4f:	85 c0                	test   %eax,%eax
  804b51:	74 0f                	je     804b62 <free_block+0x271>
  804b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b56:	8b 40 04             	mov    0x4(%eax),%eax
  804b59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804b5c:	8b 12                	mov    (%edx),%edx
  804b5e:	89 10                	mov    %edx,(%eax)
  804b60:	eb 13                	jmp    804b75 <free_block+0x284>
  804b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b65:	8b 00                	mov    (%eax),%eax
  804b67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b6a:	c1 e2 04             	shl    $0x4,%edx
  804b6d:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804b73:	89 02                	mov    %eax,(%edx)
  804b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b8b:	c1 e0 04             	shl    $0x4,%eax
  804b8e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804b93:	8b 00                	mov    (%eax),%eax
  804b95:	8d 50 ff             	lea    -0x1(%eax),%edx
  804b98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b9b:	c1 e0 04             	shl    $0x4,%eax
  804b9e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804ba3:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804ba5:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804bae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804bb2:	0f 85 21 ff ff ff    	jne    804ad9 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  804bb8:	b8 00 10 00 00       	mov    $0x1000,%eax
  804bbd:	99                   	cltd   
  804bbe:	f7 7d e8             	idivl  -0x18(%ebp)
  804bc1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804bc4:	74 17                	je     804bdd <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  804bc6:	83 ec 04             	sub    $0x4,%esp
  804bc9:	68 f4 65 80 00       	push   $0x8065f4
  804bce:	68 0c 01 00 00       	push   $0x10c
  804bd3:	68 0b 64 80 00       	push   $0x80640b
  804bd8:	e8 25 d0 ff ff       	call   801c02 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  804bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804be0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  804be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804be9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  804bef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804bf3:	75 17                	jne    804c0c <free_block+0x31b>
  804bf5:	83 ec 04             	sub    $0x4,%esp
  804bf8:	68 c4 64 80 00       	push   $0x8064c4
  804bfd:	68 11 01 00 00       	push   $0x111
  804c02:	68 0b 64 80 00       	push   $0x80640b
  804c07:	e8 f6 cf ff ff       	call   801c02 <_panic>
  804c0c:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c15:	89 50 04             	mov    %edx,0x4(%eax)
  804c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c1b:	8b 40 04             	mov    0x4(%eax),%eax
  804c1e:	85 c0                	test   %eax,%eax
  804c20:	74 0c                	je     804c2e <free_block+0x33d>
  804c22:	a1 2c 72 80 00       	mov    0x80722c,%eax
  804c27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c2a:	89 10                	mov    %edx,(%eax)
  804c2c:	eb 08                	jmp    804c36 <free_block+0x345>
  804c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c31:	a3 28 72 80 00       	mov    %eax,0x807228
  804c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c39:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c47:	a1 34 72 80 00       	mov    0x807234,%eax
  804c4c:	40                   	inc    %eax
  804c4d:	a3 34 72 80 00       	mov    %eax,0x807234

        uint32 pp = to_page_va(page_info_e);
  804c52:	83 ec 0c             	sub    $0xc,%esp
  804c55:	ff 75 ec             	pushl  -0x14(%ebp)
  804c58:	e8 2b f4 ff ff       	call   804088 <to_page_va>
  804c5d:	83 c4 10             	add    $0x10,%esp
  804c60:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  804c63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804c66:	83 ec 0c             	sub    $0xc,%esp
  804c69:	50                   	push   %eax
  804c6a:	e8 69 e8 ff ff       	call   8034d8 <return_page>
  804c6f:	83 c4 10             	add    $0x10,%esp
  804c72:	eb 01                	jmp    804c75 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  804c74:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804c75:	c9                   	leave  
  804c76:	c3                   	ret    

00804c77 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  804c77:	55                   	push   %ebp
  804c78:	89 e5                	mov    %esp,%ebp
  804c7a:	83 ec 14             	sub    $0x14,%esp
  804c7d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  804c80:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804c84:	77 07                	ja     804c8d <nearest_pow2_ceil.1572+0x16>
      return 1;
  804c86:	b8 01 00 00 00       	mov    $0x1,%eax
  804c8b:	eb 20                	jmp    804cad <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  804c8d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  804c94:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  804c97:	eb 08                	jmp    804ca1 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  804c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804c9c:	01 c0                	add    %eax,%eax
  804c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  804ca1:	d1 6d 08             	shrl   0x8(%ebp)
  804ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804ca8:	75 ef                	jne    804c99 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  804caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  804cad:	c9                   	leave  
  804cae:	c3                   	ret    

00804caf <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  804caf:	55                   	push   %ebp
  804cb0:	89 e5                	mov    %esp,%ebp
  804cb2:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  804cb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804cb9:	75 13                	jne    804cce <realloc_block+0x1f>
    return alloc_block(new_size);
  804cbb:	83 ec 0c             	sub    $0xc,%esp
  804cbe:	ff 75 0c             	pushl  0xc(%ebp)
  804cc1:	e8 d1 f6 ff ff       	call   804397 <alloc_block>
  804cc6:	83 c4 10             	add    $0x10,%esp
  804cc9:	e9 d9 00 00 00       	jmp    804da7 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  804cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804cd2:	75 18                	jne    804cec <realloc_block+0x3d>
    free_block(va);
  804cd4:	83 ec 0c             	sub    $0xc,%esp
  804cd7:	ff 75 08             	pushl  0x8(%ebp)
  804cda:	e8 12 fc ff ff       	call   8048f1 <free_block>
  804cdf:	83 c4 10             	add    $0x10,%esp
    return NULL;
  804ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  804ce7:	e9 bb 00 00 00       	jmp    804da7 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  804cec:	83 ec 0c             	sub    $0xc,%esp
  804cef:	ff 75 08             	pushl  0x8(%ebp)
  804cf2:	e8 38 f6 ff ff       	call   80432f <get_block_size>
  804cf7:	83 c4 10             	add    $0x10,%esp
  804cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  804cfd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  804d07:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804d0a:	73 06                	jae    804d12 <realloc_block+0x63>
    new_size = min_block_size;
  804d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d0f:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  804d12:	83 ec 0c             	sub    $0xc,%esp
  804d15:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804d18:	ff 75 0c             	pushl  0xc(%ebp)
  804d1b:	89 c1                	mov    %eax,%ecx
  804d1d:	e8 55 ff ff ff       	call   804c77 <nearest_pow2_ceil.1572>
  804d22:	83 c4 10             	add    $0x10,%esp
  804d25:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  804d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d2b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804d2e:	75 05                	jne    804d35 <realloc_block+0x86>
    return va;
  804d30:	8b 45 08             	mov    0x8(%ebp),%eax
  804d33:	eb 72                	jmp    804da7 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  804d35:	83 ec 0c             	sub    $0xc,%esp
  804d38:	ff 75 0c             	pushl  0xc(%ebp)
  804d3b:	e8 57 f6 ff ff       	call   804397 <alloc_block>
  804d40:	83 c4 10             	add    $0x10,%esp
  804d43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  804d46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804d4a:	75 07                	jne    804d53 <realloc_block+0xa4>
    return NULL;
  804d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  804d51:	eb 54                	jmp    804da7 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  804d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  804d59:	39 d0                	cmp    %edx,%eax
  804d5b:	76 02                	jbe    804d5f <realloc_block+0xb0>
  804d5d:	89 d0                	mov    %edx,%eax
  804d5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  804d62:	8b 45 08             	mov    0x8(%ebp),%eax
  804d65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  804d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804d6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  804d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804d75:	eb 17                	jmp    804d8e <realloc_block+0xdf>
    dst[i] = src[i];
  804d77:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d7d:	01 c2                	add    %eax,%edx
  804d7f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  804d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d85:	01 c8                	add    %ecx,%eax
  804d87:	8a 00                	mov    (%eax),%al
  804d89:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  804d8b:	ff 45 f4             	incl   -0xc(%ebp)
  804d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d91:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804d94:	72 e1                	jb     804d77 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  804d96:	83 ec 0c             	sub    $0xc,%esp
  804d99:	ff 75 08             	pushl  0x8(%ebp)
  804d9c:	e8 50 fb ff ff       	call   8048f1 <free_block>
  804da1:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  804da7:	c9                   	leave  
  804da8:	c3                   	ret    
  804da9:	66 90                	xchg   %ax,%ax
  804dab:	90                   	nop

00804dac <__udivdi3>:
  804dac:	55                   	push   %ebp
  804dad:	57                   	push   %edi
  804dae:	56                   	push   %esi
  804daf:	53                   	push   %ebx
  804db0:	83 ec 1c             	sub    $0x1c,%esp
  804db3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804db7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804dbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804dbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804dc3:	89 ca                	mov    %ecx,%edx
  804dc5:	89 f8                	mov    %edi,%eax
  804dc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804dcb:	85 f6                	test   %esi,%esi
  804dcd:	75 2d                	jne    804dfc <__udivdi3+0x50>
  804dcf:	39 cf                	cmp    %ecx,%edi
  804dd1:	77 65                	ja     804e38 <__udivdi3+0x8c>
  804dd3:	89 fd                	mov    %edi,%ebp
  804dd5:	85 ff                	test   %edi,%edi
  804dd7:	75 0b                	jne    804de4 <__udivdi3+0x38>
  804dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  804dde:	31 d2                	xor    %edx,%edx
  804de0:	f7 f7                	div    %edi
  804de2:	89 c5                	mov    %eax,%ebp
  804de4:	31 d2                	xor    %edx,%edx
  804de6:	89 c8                	mov    %ecx,%eax
  804de8:	f7 f5                	div    %ebp
  804dea:	89 c1                	mov    %eax,%ecx
  804dec:	89 d8                	mov    %ebx,%eax
  804dee:	f7 f5                	div    %ebp
  804df0:	89 cf                	mov    %ecx,%edi
  804df2:	89 fa                	mov    %edi,%edx
  804df4:	83 c4 1c             	add    $0x1c,%esp
  804df7:	5b                   	pop    %ebx
  804df8:	5e                   	pop    %esi
  804df9:	5f                   	pop    %edi
  804dfa:	5d                   	pop    %ebp
  804dfb:	c3                   	ret    
  804dfc:	39 ce                	cmp    %ecx,%esi
  804dfe:	77 28                	ja     804e28 <__udivdi3+0x7c>
  804e00:	0f bd fe             	bsr    %esi,%edi
  804e03:	83 f7 1f             	xor    $0x1f,%edi
  804e06:	75 40                	jne    804e48 <__udivdi3+0x9c>
  804e08:	39 ce                	cmp    %ecx,%esi
  804e0a:	72 0a                	jb     804e16 <__udivdi3+0x6a>
  804e0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804e10:	0f 87 9e 00 00 00    	ja     804eb4 <__udivdi3+0x108>
  804e16:	b8 01 00 00 00       	mov    $0x1,%eax
  804e1b:	89 fa                	mov    %edi,%edx
  804e1d:	83 c4 1c             	add    $0x1c,%esp
  804e20:	5b                   	pop    %ebx
  804e21:	5e                   	pop    %esi
  804e22:	5f                   	pop    %edi
  804e23:	5d                   	pop    %ebp
  804e24:	c3                   	ret    
  804e25:	8d 76 00             	lea    0x0(%esi),%esi
  804e28:	31 ff                	xor    %edi,%edi
  804e2a:	31 c0                	xor    %eax,%eax
  804e2c:	89 fa                	mov    %edi,%edx
  804e2e:	83 c4 1c             	add    $0x1c,%esp
  804e31:	5b                   	pop    %ebx
  804e32:	5e                   	pop    %esi
  804e33:	5f                   	pop    %edi
  804e34:	5d                   	pop    %ebp
  804e35:	c3                   	ret    
  804e36:	66 90                	xchg   %ax,%ax
  804e38:	89 d8                	mov    %ebx,%eax
  804e3a:	f7 f7                	div    %edi
  804e3c:	31 ff                	xor    %edi,%edi
  804e3e:	89 fa                	mov    %edi,%edx
  804e40:	83 c4 1c             	add    $0x1c,%esp
  804e43:	5b                   	pop    %ebx
  804e44:	5e                   	pop    %esi
  804e45:	5f                   	pop    %edi
  804e46:	5d                   	pop    %ebp
  804e47:	c3                   	ret    
  804e48:	bd 20 00 00 00       	mov    $0x20,%ebp
  804e4d:	89 eb                	mov    %ebp,%ebx
  804e4f:	29 fb                	sub    %edi,%ebx
  804e51:	89 f9                	mov    %edi,%ecx
  804e53:	d3 e6                	shl    %cl,%esi
  804e55:	89 c5                	mov    %eax,%ebp
  804e57:	88 d9                	mov    %bl,%cl
  804e59:	d3 ed                	shr    %cl,%ebp
  804e5b:	89 e9                	mov    %ebp,%ecx
  804e5d:	09 f1                	or     %esi,%ecx
  804e5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804e63:	89 f9                	mov    %edi,%ecx
  804e65:	d3 e0                	shl    %cl,%eax
  804e67:	89 c5                	mov    %eax,%ebp
  804e69:	89 d6                	mov    %edx,%esi
  804e6b:	88 d9                	mov    %bl,%cl
  804e6d:	d3 ee                	shr    %cl,%esi
  804e6f:	89 f9                	mov    %edi,%ecx
  804e71:	d3 e2                	shl    %cl,%edx
  804e73:	8b 44 24 08          	mov    0x8(%esp),%eax
  804e77:	88 d9                	mov    %bl,%cl
  804e79:	d3 e8                	shr    %cl,%eax
  804e7b:	09 c2                	or     %eax,%edx
  804e7d:	89 d0                	mov    %edx,%eax
  804e7f:	89 f2                	mov    %esi,%edx
  804e81:	f7 74 24 0c          	divl   0xc(%esp)
  804e85:	89 d6                	mov    %edx,%esi
  804e87:	89 c3                	mov    %eax,%ebx
  804e89:	f7 e5                	mul    %ebp
  804e8b:	39 d6                	cmp    %edx,%esi
  804e8d:	72 19                	jb     804ea8 <__udivdi3+0xfc>
  804e8f:	74 0b                	je     804e9c <__udivdi3+0xf0>
  804e91:	89 d8                	mov    %ebx,%eax
  804e93:	31 ff                	xor    %edi,%edi
  804e95:	e9 58 ff ff ff       	jmp    804df2 <__udivdi3+0x46>
  804e9a:	66 90                	xchg   %ax,%ax
  804e9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804ea0:	89 f9                	mov    %edi,%ecx
  804ea2:	d3 e2                	shl    %cl,%edx
  804ea4:	39 c2                	cmp    %eax,%edx
  804ea6:	73 e9                	jae    804e91 <__udivdi3+0xe5>
  804ea8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804eab:	31 ff                	xor    %edi,%edi
  804ead:	e9 40 ff ff ff       	jmp    804df2 <__udivdi3+0x46>
  804eb2:	66 90                	xchg   %ax,%ax
  804eb4:	31 c0                	xor    %eax,%eax
  804eb6:	e9 37 ff ff ff       	jmp    804df2 <__udivdi3+0x46>
  804ebb:	90                   	nop

00804ebc <__umoddi3>:
  804ebc:	55                   	push   %ebp
  804ebd:	57                   	push   %edi
  804ebe:	56                   	push   %esi
  804ebf:	53                   	push   %ebx
  804ec0:	83 ec 1c             	sub    $0x1c,%esp
  804ec3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804ec7:	8b 74 24 34          	mov    0x34(%esp),%esi
  804ecb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804ecf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804ed3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804ed7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804edb:	89 f3                	mov    %esi,%ebx
  804edd:	89 fa                	mov    %edi,%edx
  804edf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804ee3:	89 34 24             	mov    %esi,(%esp)
  804ee6:	85 c0                	test   %eax,%eax
  804ee8:	75 1a                	jne    804f04 <__umoddi3+0x48>
  804eea:	39 f7                	cmp    %esi,%edi
  804eec:	0f 86 a2 00 00 00    	jbe    804f94 <__umoddi3+0xd8>
  804ef2:	89 c8                	mov    %ecx,%eax
  804ef4:	89 f2                	mov    %esi,%edx
  804ef6:	f7 f7                	div    %edi
  804ef8:	89 d0                	mov    %edx,%eax
  804efa:	31 d2                	xor    %edx,%edx
  804efc:	83 c4 1c             	add    $0x1c,%esp
  804eff:	5b                   	pop    %ebx
  804f00:	5e                   	pop    %esi
  804f01:	5f                   	pop    %edi
  804f02:	5d                   	pop    %ebp
  804f03:	c3                   	ret    
  804f04:	39 f0                	cmp    %esi,%eax
  804f06:	0f 87 ac 00 00 00    	ja     804fb8 <__umoddi3+0xfc>
  804f0c:	0f bd e8             	bsr    %eax,%ebp
  804f0f:	83 f5 1f             	xor    $0x1f,%ebp
  804f12:	0f 84 ac 00 00 00    	je     804fc4 <__umoddi3+0x108>
  804f18:	bf 20 00 00 00       	mov    $0x20,%edi
  804f1d:	29 ef                	sub    %ebp,%edi
  804f1f:	89 fe                	mov    %edi,%esi
  804f21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804f25:	89 e9                	mov    %ebp,%ecx
  804f27:	d3 e0                	shl    %cl,%eax
  804f29:	89 d7                	mov    %edx,%edi
  804f2b:	89 f1                	mov    %esi,%ecx
  804f2d:	d3 ef                	shr    %cl,%edi
  804f2f:	09 c7                	or     %eax,%edi
  804f31:	89 e9                	mov    %ebp,%ecx
  804f33:	d3 e2                	shl    %cl,%edx
  804f35:	89 14 24             	mov    %edx,(%esp)
  804f38:	89 d8                	mov    %ebx,%eax
  804f3a:	d3 e0                	shl    %cl,%eax
  804f3c:	89 c2                	mov    %eax,%edx
  804f3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804f42:	d3 e0                	shl    %cl,%eax
  804f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  804f48:	8b 44 24 08          	mov    0x8(%esp),%eax
  804f4c:	89 f1                	mov    %esi,%ecx
  804f4e:	d3 e8                	shr    %cl,%eax
  804f50:	09 d0                	or     %edx,%eax
  804f52:	d3 eb                	shr    %cl,%ebx
  804f54:	89 da                	mov    %ebx,%edx
  804f56:	f7 f7                	div    %edi
  804f58:	89 d3                	mov    %edx,%ebx
  804f5a:	f7 24 24             	mull   (%esp)
  804f5d:	89 c6                	mov    %eax,%esi
  804f5f:	89 d1                	mov    %edx,%ecx
  804f61:	39 d3                	cmp    %edx,%ebx
  804f63:	0f 82 87 00 00 00    	jb     804ff0 <__umoddi3+0x134>
  804f69:	0f 84 91 00 00 00    	je     805000 <__umoddi3+0x144>
  804f6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804f73:	29 f2                	sub    %esi,%edx
  804f75:	19 cb                	sbb    %ecx,%ebx
  804f77:	89 d8                	mov    %ebx,%eax
  804f79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804f7d:	d3 e0                	shl    %cl,%eax
  804f7f:	89 e9                	mov    %ebp,%ecx
  804f81:	d3 ea                	shr    %cl,%edx
  804f83:	09 d0                	or     %edx,%eax
  804f85:	89 e9                	mov    %ebp,%ecx
  804f87:	d3 eb                	shr    %cl,%ebx
  804f89:	89 da                	mov    %ebx,%edx
  804f8b:	83 c4 1c             	add    $0x1c,%esp
  804f8e:	5b                   	pop    %ebx
  804f8f:	5e                   	pop    %esi
  804f90:	5f                   	pop    %edi
  804f91:	5d                   	pop    %ebp
  804f92:	c3                   	ret    
  804f93:	90                   	nop
  804f94:	89 fd                	mov    %edi,%ebp
  804f96:	85 ff                	test   %edi,%edi
  804f98:	75 0b                	jne    804fa5 <__umoddi3+0xe9>
  804f9a:	b8 01 00 00 00       	mov    $0x1,%eax
  804f9f:	31 d2                	xor    %edx,%edx
  804fa1:	f7 f7                	div    %edi
  804fa3:	89 c5                	mov    %eax,%ebp
  804fa5:	89 f0                	mov    %esi,%eax
  804fa7:	31 d2                	xor    %edx,%edx
  804fa9:	f7 f5                	div    %ebp
  804fab:	89 c8                	mov    %ecx,%eax
  804fad:	f7 f5                	div    %ebp
  804faf:	89 d0                	mov    %edx,%eax
  804fb1:	e9 44 ff ff ff       	jmp    804efa <__umoddi3+0x3e>
  804fb6:	66 90                	xchg   %ax,%ax
  804fb8:	89 c8                	mov    %ecx,%eax
  804fba:	89 f2                	mov    %esi,%edx
  804fbc:	83 c4 1c             	add    $0x1c,%esp
  804fbf:	5b                   	pop    %ebx
  804fc0:	5e                   	pop    %esi
  804fc1:	5f                   	pop    %edi
  804fc2:	5d                   	pop    %ebp
  804fc3:	c3                   	ret    
  804fc4:	3b 04 24             	cmp    (%esp),%eax
  804fc7:	72 06                	jb     804fcf <__umoddi3+0x113>
  804fc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804fcd:	77 0f                	ja     804fde <__umoddi3+0x122>
  804fcf:	89 f2                	mov    %esi,%edx
  804fd1:	29 f9                	sub    %edi,%ecx
  804fd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804fd7:	89 14 24             	mov    %edx,(%esp)
  804fda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804fde:	8b 44 24 04          	mov    0x4(%esp),%eax
  804fe2:	8b 14 24             	mov    (%esp),%edx
  804fe5:	83 c4 1c             	add    $0x1c,%esp
  804fe8:	5b                   	pop    %ebx
  804fe9:	5e                   	pop    %esi
  804fea:	5f                   	pop    %edi
  804feb:	5d                   	pop    %ebp
  804fec:	c3                   	ret    
  804fed:	8d 76 00             	lea    0x0(%esi),%esi
  804ff0:	2b 04 24             	sub    (%esp),%eax
  804ff3:	19 fa                	sbb    %edi,%edx
  804ff5:	89 d1                	mov    %edx,%ecx
  804ff7:	89 c6                	mov    %eax,%esi
  804ff9:	e9 71 ff ff ff       	jmp    804f6f <__umoddi3+0xb3>
  804ffe:	66 90                	xchg   %ax,%ax
  805000:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805004:	72 ea                	jb     804ff0 <__umoddi3+0x134>
  805006:	89 d9                	mov    %ebx,%ecx
  805008:	e9 62 ff ff ff       	jmp    804f6f <__umoddi3+0xb3>
