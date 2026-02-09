
obj/user/tst_custom_fit_3:     file format elf32-i386


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
  800031:	e8 b0 18 00 00       	call   8018e6 <libmain>
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
  800067:	e8 24 3a 00 00       	call   803a90 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 67 3a 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 e8 32 00 00       	call   8033af <malloc>
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
  8000df:	e8 ac 39 00 00       	call   803a90 <sys_calculate_free_frames>
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
  800125:	68 c0 4e 80 00       	push   $0x804ec0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 80 1c 00 00       	call   801db1 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 a2 39 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 3c 4f 80 00       	push   $0x804f3c
  800150:	6a 0c                	push   $0xc
  800152:	e8 5a 1c 00 00       	call   801db1 <cprintf_colored>
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
  800174:	e8 17 39 00 00       	call   803a90 <sys_calculate_free_frames>
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
  8001b9:	e8 d2 38 00 00       	call   803a90 <sys_calculate_free_frames>
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
  8001f8:	68 b4 4f 80 00       	push   $0x804fb4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 ad 1b 00 00       	call   801db1 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 cf 38 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 40 50 80 00       	push   $0x805040
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 80 1b 00 00       	call   801db1 <cprintf_colored>
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
  800270:	e8 dd 3b 00 00       	call   803e52 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 b8 50 80 00       	push   $0x8050b8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 1b 1b 00 00       	call   801db1 <cprintf_colored>
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
  8002ae:	e8 dd 37 00 00       	call   803a90 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 20 38 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 62 32 00 00       	call   803533 <free>
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
  8002fc:	e8 da 37 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 f0 50 80 00       	push   $0x8050f0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 92 1a 00 00       	call   801db1 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 69 37 00 00       	call   803a90 <sys_calculate_free_frames>
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
  80035f:	68 3c 51 80 00       	push   $0x80513c
  800364:	6a 0c                	push   $0xc
  800366:	e8 46 1a 00 00       	call   801db1 <cprintf_colored>
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
  8003bd:	e8 90 3a 00 00       	call   803e52 <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 98 51 80 00       	push   $0x805198
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 ce 19 00 00       	call   801db1 <cprintf_colored>
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
  800433:	68 d0 51 80 00       	push   $0x8051d0
  800438:	6a 03                	push   $0x3
  80043a:	e8 72 19 00 00       	call   801db1 <cprintf_colored>
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
  8004fc:	68 00 52 80 00       	push   $0x805200
  800501:	6a 0c                	push   $0xc
  800503:	e8 a9 18 00 00       	call   801db1 <cprintf_colored>
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
  8005d6:	68 00 52 80 00       	push   $0x805200
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 cf 17 00 00       	call   801db1 <cprintf_colored>
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
  8006b0:	68 00 52 80 00       	push   $0x805200
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 f5 16 00 00       	call   801db1 <cprintf_colored>
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
  80078a:	68 00 52 80 00       	push   $0x805200
  80078f:	6a 0c                	push   $0xc
  800791:	e8 1b 16 00 00       	call   801db1 <cprintf_colored>
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
  800864:	68 00 52 80 00       	push   $0x805200
  800869:	6a 0c                	push   $0xc
  80086b:	e8 41 15 00 00       	call   801db1 <cprintf_colored>
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
  80093e:	68 00 52 80 00       	push   $0x805200
  800943:	6a 0c                	push   $0xc
  800945:	e8 67 14 00 00       	call   801db1 <cprintf_colored>
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
  800a33:	68 00 52 80 00       	push   $0x805200
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 72 13 00 00       	call   801db1 <cprintf_colored>
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
  800b31:	68 00 52 80 00       	push   $0x805200
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 74 12 00 00       	call   801db1 <cprintf_colored>
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
  800c2f:	68 00 52 80 00       	push   $0x805200
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 76 11 00 00       	call   801db1 <cprintf_colored>
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
  800d2d:	68 00 52 80 00       	push   $0x805200
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 78 10 00 00       	call   801db1 <cprintf_colored>
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
  800e1a:	68 00 52 80 00       	push   $0x805200
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 8b 0f 00 00       	call   801db1 <cprintf_colored>
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
  800f07:	68 00 52 80 00       	push   $0x805200
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 9e 0e 00 00       	call   801db1 <cprintf_colored>
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
  800ff4:	68 00 52 80 00       	push   $0x805200
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 b1 0d 00 00       	call   801db1 <cprintf_colored>
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
  801017:	68 52 52 80 00       	push   $0x805252
  80101c:	6a 03                	push   $0x3
  80101e:	e8 8e 0d 00 00       	call   801db1 <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 54 2a 00 00       	call   803a90 <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 94 2a 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
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
  801072:	e8 38 23 00 00       	call   8033af <malloc>
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
  8010a1:	68 70 52 80 00       	push   $0x805270
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 04 0d 00 00       	call   801db1 <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 26 2a 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 ac 52 80 00       	push   $0x8052ac
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 d8 0c 00 00       	call   801db1 <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 af 29 00 00       	call   803a90 <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 1c 53 80 00       	push   $0x80531c
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 ac 0c 00 00       	call   801db1 <cprintf_colored>
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
  801120:	53                   	push   %ebx
  801121:	83 c4 80             	add    $0xffffff80,%esp
	sys_set_uheap_strategy(UHP_PLACE_CUSTOMFIT);
  801124:	83 ec 0c             	sub    $0xc,%esp
  801127:	6a 05                	push   $0x5
  801129:	e8 bf 2c 00 00       	call   803ded <sys_set_uheap_strategy>
  80112e:	83 c4 10             	add    $0x10,%esp

	//cprintf_colored(TEXT_TESTERR_CLR, "%~1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801131:	a1 00 72 80 00       	mov    0x807200,%eax
  801136:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80113c:	a1 00 72 80 00       	mov    0x807200,%eax
  801141:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801147:	39 c2                	cmp    %eax,%edx
  801149:	72 14                	jb     80115f <_main+0x43>
			panic("Please increase the WS size");
  80114b:	83 ec 04             	sub    $0x4,%esp
  80114e:	68 64 53 80 00       	push   $0x805364
  801153:	6a 17                	push   $0x17
  801155:	68 80 53 80 00       	push   $0x805380
  80115a:	e8 37 09 00 00       	call   801a96 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80115f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801166:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	int envID = sys_getenvid();
  80116d:	e8 ce 2a 00 00       	call   803c40 <sys_getenvid>
  801172:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801175:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)

	void* ptr_allocations[20] = {0};
  80117c:	8d 55 84             	lea    -0x7c(%ebp),%edx
  80117f:	b9 14 00 00 00       	mov    $0x14,%ecx
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
  801189:	89 d7                	mov    %edx,%edi
  80118b:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames, expected, expectedUpper, diff;
	int usedDiskPages;
	//[1] Allocate all
	cprintf_colored(TEXT_cyan, "\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR [20%]\n");
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	68 98 53 80 00       	push   $0x805398
  801195:	6a 03                	push   $0x3
  801197:	e8 15 0c 00 00       	call   801db1 <cprintf_colored>
  80119c:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80119f:	e8 ec 28 00 00       	call   803a90 <sys_calculate_free_frames>
  8011a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011a7:	e8 2f 29 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  8011ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8011af:	83 ec 04             	sub    $0x4,%esp
  8011b2:	6a 01                	push   $0x1
  8011b4:	68 00 00 10 00       	push   $0x100000
  8011b9:	68 db 53 80 00       	push   $0x8053db
  8011be:	e8 ac 24 00 00       	call   80366f <smalloc>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if (ptr_allocations[0] != (uint32*)pagealloc_start)
  8011c9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  8011cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011cf:	39 c2                	cmp    %eax,%edx
  8011d1:	74 19                	je     8011ec <_main+0xd0>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8011d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011da:	83 ec 08             	sub    $0x8,%esp
  8011dd:	68 e0 53 80 00       	push   $0x8053e0
  8011e2:	6a 0c                	push   $0xc
  8011e4:	e8 c8 0b 00 00       	call   801db1 <cprintf_colored>
  8011e9:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  8011ec:	c7 45 dc 01 01 00 00 	movl   $0x101,-0x24(%ebp)
		expectedUpper = expected
  8011f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011f6:	83 c0 04             	add    $0x4,%eax
  8011f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
						+2 /*KH Block Alloc: 1 for Share object, 1 for framesStorage*/
						+2 /*UH Block Alloc: max of 1 page & 1 table*/;
		diff = (freeFrames - sys_calculate_free_frames());
  8011fc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8011ff:	e8 8c 28 00 00       	call   803a90 <sys_calculate_free_frames>
  801204:	29 c3                	sub    %eax,%ebx
  801206:	89 d8                	mov    %ebx,%eax
  801208:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	ff 75 d8             	pushl  -0x28(%ebp)
  801211:	ff 75 dc             	pushl  -0x24(%ebp)
  801214:	ff 75 d4             	pushl  -0x2c(%ebp)
  801217:	e8 1c ee ff ff       	call   800038 <inRange>
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	85 c0                	test   %eax,%eax
  801221:	75 2c                	jne    80124f <_main+0x133>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  801223:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80122a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80122d:	e8 5e 28 00 00       	call   803a90 <sys_calculate_free_frames>
  801232:	29 c3                	sub    %eax,%ebx
  801234:	89 d8                	mov    %ebx,%eax
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	ff 75 d8             	pushl  -0x28(%ebp)
  80123c:	ff 75 dc             	pushl  -0x24(%ebp)
  80123f:	50                   	push   %eax
  801240:	68 50 54 80 00       	push   $0x805450
  801245:	6a 0c                	push   $0xc
  801247:	e8 65 0b 00 00       	call   801db1 <cprintf_colored>
  80124c:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  80124f:	e8 87 28 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  801254:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801257:	74 19                	je     801272 <_main+0x156>
  801259:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801260:	83 ec 08             	sub    $0x8,%esp
  801263:	68 f0 54 80 00       	push   $0x8054f0
  801268:	6a 0c                	push   $0xc
  80126a:	e8 42 0b 00 00       	call   801db1 <cprintf_colored>
  80126f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		ptr_allocations[1] = malloc(1*Mega-kilo);
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	68 00 fc 0f 00       	push   $0xffc00
  80127a:	e8 30 21 00 00       	call   8033af <malloc>
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega))
  801285:	8b 45 88             	mov    -0x78(%ebp),%eax
  801288:	89 c2                	mov    %eax,%edx
  80128a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80128d:	05 00 00 10 00       	add    $0x100000,%eax
  801292:	39 c2                	cmp    %eax,%edx
  801294:	74 19                	je     8012af <_main+0x193>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801296:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	68 10 55 80 00       	push   $0x805510
  8012a5:	6a 0c                	push   $0xc
  8012a7:	e8 05 0b 00 00       	call   801db1 <cprintf_colored>
  8012ac:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	68 00 fc 0f 00       	push   $0xffc00
  8012b7:	e8 f3 20 00 00       	call   8033af <malloc>
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega))
  8012c2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8012c5:	89 c2                	mov    %eax,%edx
  8012c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ca:	05 00 00 20 00       	add    $0x200000,%eax
  8012cf:	39 c2                	cmp    %eax,%edx
  8012d1:	74 19                	je     8012ec <_main+0x1d0>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8012d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	68 10 55 80 00       	push   $0x805510
  8012e2:	6a 0c                	push   $0xc
  8012e4:	e8 c8 0a 00 00       	call   801db1 <cprintf_colored>
  8012e9:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	68 00 fc 0f 00       	push   $0xffc00
  8012f4:	e8 b6 20 00 00       	call   8033af <malloc>
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) )
  8012ff:	8b 45 90             	mov    -0x70(%ebp),%eax
  801302:	89 c2                	mov    %eax,%edx
  801304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801307:	05 00 00 30 00       	add    $0x300000,%eax
  80130c:	39 c2                	cmp    %eax,%edx
  80130e:	74 19                	je     801329 <_main+0x20d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801310:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	68 10 55 80 00       	push   $0x805510
  80131f:	6a 0c                	push   $0xc
  801321:	e8 8b 0a 00 00       	call   801db1 <cprintf_colored>
  801326:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[4] = malloc(2*Mega-kilo);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	68 00 fc 1f 00       	push   $0x1ffc00
  801331:	e8 79 20 00 00       	call   8033af <malloc>
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega))
  80133c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80133f:	89 c2                	mov    %eax,%edx
  801341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801344:	05 00 00 40 00       	add    $0x400000,%eax
  801349:	39 c2                	cmp    %eax,%edx
  80134b:	74 19                	je     801366 <_main+0x24a>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  80134d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801354:	83 ec 08             	sub    $0x8,%esp
  801357:	68 10 55 80 00       	push   $0x805510
  80135c:	6a 0c                	push   $0xc
  80135e:	e8 4e 0a 00 00       	call   801db1 <cprintf_colored>
  801363:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  801366:	e8 25 27 00 00       	call   803a90 <sys_calculate_free_frames>
  80136b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80136e:	e8 68 27 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  801373:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	6a 01                	push   $0x1
  80137b:	68 00 00 20 00       	push   $0x200000
  801380:	68 42 55 80 00       	push   $0x805542
  801385:	e8 e5 22 00 00       	call   80366f <smalloc>
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	89 45 98             	mov    %eax,-0x68(%ebp)
		if (ptr_allocations[5] != (uint32*)(pagealloc_start + 6*Mega))
  801390:	8b 45 98             	mov    -0x68(%ebp),%eax
  801393:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801396:	81 c2 00 00 60 00    	add    $0x600000,%edx
  80139c:	39 d0                	cmp    %edx,%eax
  80139e:	74 19                	je     8013b9 <_main+0x29d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8013a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	68 e0 53 80 00       	push   $0x8053e0
  8013af:	6a 0c                	push   $0xc
  8013b1:	e8 fb 09 00 00       	call   801db1 <cprintf_colored>
  8013b6:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  8013b9:	c7 45 dc 01 02 00 00 	movl   $0x201,-0x24(%ebp)
		expectedUpper = expected +1 /*KH Block Alloc: 1 for framesStorage*/;
  8013c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c3:	40                   	inc    %eax
  8013c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8013c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013ca:	e8 c1 26 00 00       	call   803a90 <sys_calculate_free_frames>
  8013cf:	29 c3                	sub    %eax,%ebx
  8013d1:	89 d8                	mov    %ebx,%eax
  8013d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8013dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8013df:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013e2:	e8 51 ec ff ff       	call   800038 <inRange>
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	75 2c                	jne    80141a <_main+0x2fe>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  8013ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013f5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013f8:	e8 93 26 00 00       	call   803a90 <sys_calculate_free_frames>
  8013fd:	29 c3                	sub    %eax,%ebx
  8013ff:	89 d8                	mov    %ebx,%eax
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	ff 75 d8             	pushl  -0x28(%ebp)
  801407:	ff 75 dc             	pushl  -0x24(%ebp)
  80140a:	50                   	push   %eax
  80140b:	68 50 54 80 00       	push   $0x805450
  801410:	6a 0c                	push   $0xc
  801412:	e8 9a 09 00 00       	call   801db1 <cprintf_colored>
  801417:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  80141a:	e8 bc 26 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  80141f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801422:	74 19                	je     80143d <_main+0x321>
  801424:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	68 f0 54 80 00       	push   $0x8054f0
  801433:	6a 0c                	push   $0xc
  801435:	e8 77 09 00 00       	call   801db1 <cprintf_colored>
  80143a:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		ptr_allocations[6] = malloc(3*Mega-kilo);
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	68 00 fc 2f 00       	push   $0x2ffc00
  801445:	e8 65 1f 00 00       	call   8033af <malloc>
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega))
  801450:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801453:	89 c2                	mov    %eax,%edx
  801455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801458:	05 00 00 80 00       	add    $0x800000,%eax
  80145d:	39 c2                	cmp    %eax,%edx
  80145f:	74 19                	je     80147a <_main+0x35e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801468:	83 ec 08             	sub    $0x8,%esp
  80146b:	68 10 55 80 00       	push   $0x805510
  801470:	6a 0c                	push   $0xc
  801472:	e8 3a 09 00 00       	call   801db1 <cprintf_colored>
  801477:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  80147a:	e8 11 26 00 00       	call   803a90 <sys_calculate_free_frames>
  80147f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801482:	e8 54 26 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  801487:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	6a 00                	push   $0x0
  80148f:	68 00 00 30 00       	push   $0x300000
  801494:	68 44 55 80 00       	push   $0x805544
  801499:	e8 d1 21 00 00       	call   80366f <smalloc>
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[7] != (uint32*)(pagealloc_start + 11*Mega))
  8014a4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8014a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014aa:	81 c2 00 00 b0 00    	add    $0xb00000,%edx
  8014b0:	39 d0                	cmp    %edx,%eax
  8014b2:	74 19                	je     8014cd <_main+0x3b1>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8014b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bb:	83 ec 08             	sub    $0x8,%esp
  8014be:	68 e0 53 80 00       	push   $0x8053e0
  8014c3:	6a 0c                	push   $0xc
  8014c5:	e8 e7 08 00 00       	call   801db1 <cprintf_colored>
  8014ca:	83 c4 10             	add    $0x10,%esp
		expected = 768+1; /*768pages +1table */
  8014cd:	c7 45 dc 01 03 00 00 	movl   $0x301,-0x24(%ebp)
		expectedUpper = expected +1 /*+1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/;
  8014d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d7:	40                   	inc    %eax
  8014d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8014db:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8014de:	e8 ad 25 00 00       	call   803a90 <sys_calculate_free_frames>
  8014e3:	29 c3                	sub    %eax,%ebx
  8014e5:	89 d8                	mov    %ebx,%eax
  8014e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8014ea:	83 ec 04             	sub    $0x4,%esp
  8014ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8014f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8014f3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8014f6:	e8 3d eb ff ff       	call   800038 <inRange>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	75 2c                	jne    80152e <_main+0x412>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  801502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801509:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80150c:	e8 7f 25 00 00       	call   803a90 <sys_calculate_free_frames>
  801511:	29 c3                	sub    %eax,%ebx
  801513:	89 d8                	mov    %ebx,%eax
  801515:	83 ec 0c             	sub    $0xc,%esp
  801518:	ff 75 d8             	pushl  -0x28(%ebp)
  80151b:	ff 75 dc             	pushl  -0x24(%ebp)
  80151e:	50                   	push   %eax
  80151f:	68 50 54 80 00       	push   $0x805450
  801524:	6a 0c                	push   $0xc
  801526:	e8 86 08 00 00       	call   801db1 <cprintf_colored>
  80152b:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  80152e:	e8 a8 25 00 00       	call   803adb <sys_pf_calculate_allocated_pages>
  801533:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801536:	74 19                	je     801551 <_main+0x435>
  801538:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	68 f0 54 80 00       	push   $0x8054f0
  801547:	6a 0c                	push   $0xc
  801549:	e8 63 08 00 00       	call   801db1 <cprintf_colored>
  80154e:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=20;
  801551:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801555:	74 04                	je     80155b <_main+0x43f>
  801557:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	is_correct = 1;
  80155b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[2] Free some to create holes
	cprintf_colored(TEXT_cyan, "\n%~[2] Free some to create holes\n");
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	68 48 55 80 00       	push   $0x805548
  80156a:	6a 03                	push   $0x3
  80156c:	e8 40 08 00 00       	call   801db1 <cprintf_colored>
  801571:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		free(ptr_allocations[1]);
  801574:	8b 45 88             	mov    -0x78(%ebp),%eax
  801577:	83 ec 0c             	sub    $0xc,%esp
  80157a:	50                   	push   %eax
  80157b:	e8 b3 1f 00 00       	call   803533 <free>
  801580:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		free(ptr_allocations[4]);
  801583:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801586:	83 ec 0c             	sub    $0xc,%esp
  801589:	50                   	push   %eax
  80158a:	e8 a4 1f 00 00       	call   803533 <free>
  80158f:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		free(ptr_allocations[6]);
  801592:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	50                   	push   %eax
  801599:	e8 95 1f 00 00       	call   803533 <free>
  80159e:	83 c4 10             	add    $0x10,%esp
	}

	//[3] Allocate again [test custom fit]
	cprintf_colored(TEXT_cyan, "\n%~[3] Allocate again [test custom fit] [40%]\n");
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	68 6c 55 80 00       	push   $0x80556c
  8015a9:	6a 03                	push   $0x3
  8015ab:	e8 01 08 00 00       	call   801db1 <cprintf_colored>
  8015b0:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 512 KB - should be placed in 3rd hole [WORST FIT]
		is_correct = 1;
  8015b3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[8] = smalloc("Cust1", 512*kilo - kilo, 1);
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	6a 01                	push   $0x1
  8015bf:	68 00 fc 07 00       	push   $0x7fc00
  8015c4:	68 9b 55 80 00       	push   $0x80559b
  8015c9:	e8 a1 20 00 00       	call   80366f <smalloc>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if ((uint32) ptr_allocations[8] != (pagealloc_start + 8*Mega))
  8015d4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8015d7:	89 c2                	mov    %eax,%edx
  8015d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015dc:	05 00 00 80 00       	add    $0x800000,%eax
  8015e1:	39 c2                	cmp    %eax,%edx
  8015e3:	74 19                	je     8015fe <_main+0x4e2>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8015e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8015ec:	83 ec 08             	sub    $0x8,%esp
  8015ef:	68 10 55 80 00       	push   $0x805510
  8015f4:	6a 0c                	push   $0xc
  8015f6:	e8 b6 07 00 00       	call   801db1 <cprintf_colored>
  8015fb:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  8015fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801602:	74 04                	je     801608 <_main+0x4ec>
  801604:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801608:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared 2 MB - should be placed in 2nd hole [EXACT FIT]
		is_correct = 1;
  80160f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[9] = sget(envID, "y");
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	68 42 55 80 00       	push   $0x805542
  80161e:	ff 75 ec             	pushl  -0x14(%ebp)
  801621:	e8 a9 21 00 00       	call   8037cf <sget>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 45 a8             	mov    %eax,-0x58(%ebp)
			if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega))
  80162c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80162f:	89 c2                	mov    %eax,%edx
  801631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801634:	05 00 00 40 00       	add    $0x400000,%eax
  801639:	39 c2                	cmp    %eax,%edx
  80163b:	74 19                	je     801656 <_main+0x53a>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  80163d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	68 10 55 80 00       	push   $0x805510
  80164c:	6a 0c                	push   $0xc
  80164e:	e8 5e 07 00 00       	call   801db1 <cprintf_colored>
  801653:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  801656:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80165a:	74 04                	je     801660 <_main+0x544>
  80165c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801660:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate Shared 2 MB + 512 KB - should be placed in remaining of 3rd hole [EXACT FIT]
		is_correct = 1;
  801667:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[10] = smalloc("Cust2", 2*Mega + 512*kilo, 1);
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	6a 01                	push   $0x1
  801673:	68 00 00 28 00       	push   $0x280000
  801678:	68 a1 55 80 00       	push   $0x8055a1
  80167d:	e8 ed 1f 00 00       	call   80366f <smalloc>
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if ((uint32) ptr_allocations[10] != (pagealloc_start + 8*Mega + 512*kilo))
  801688:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801690:	05 00 00 88 00       	add    $0x880000,%eax
  801695:	39 c2                	cmp    %eax,%edx
  801697:	74 19                	je     8016b2 <_main+0x596>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801699:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016a0:	83 ec 08             	sub    $0x8,%esp
  8016a3:	68 10 55 80 00       	push   $0x805510
  8016a8:	6a 0c                	push   $0xc
  8016aa:	e8 02 07 00 00       	call   801db1 <cprintf_colored>
  8016af:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=5;
  8016b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016b6:	74 04                	je     8016bc <_main+0x5a0>
  8016b8:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		is_correct = 1;
  8016bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared 512 KB - should be placed in 1st hole [WORST FIT]
		is_correct = 1;
  8016c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[11] = sget(envID, "Cust1");
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	68 9b 55 80 00       	push   $0x80559b
  8016d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8016d5:	e8 f5 20 00 00       	call   8037cf <sget>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
			if ((uint32) ptr_allocations[11] != (pagealloc_start + 1*Mega))
  8016e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8016e3:	89 c2                	mov    %eax,%edx
  8016e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e8:	05 00 00 10 00       	add    $0x100000,%eax
  8016ed:	39 c2                	cmp    %eax,%edx
  8016ef:	74 19                	je     80170a <_main+0x5ee>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8016f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	68 10 55 80 00       	push   $0x805510
  801700:	6a 0c                	push   $0xc
  801702:	e8 aa 06 00 00       	call   801db1 <cprintf_colored>
  801707:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=5;
  80170a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80170e:	74 04                	je     801714 <_main+0x5f8>
  801710:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		is_correct = 1;
  801714:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate Shared 4 MB - should be placed in end of all allocations [EXTEND]
		is_correct = 1;
  80171b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[12] = smalloc("Cust3", 4*Mega, 0);
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	6a 00                	push   $0x0
  801727:	68 00 00 40 00       	push   $0x400000
  80172c:	68 a7 55 80 00       	push   $0x8055a7
  801731:	e8 39 1f 00 00       	call   80366f <smalloc>
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega))
  80173c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80173f:	89 c2                	mov    %eax,%edx
  801741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801744:	05 00 00 e0 00       	add    $0xe00000,%eax
  801749:	39 c2                	cmp    %eax,%edx
  80174b:	74 19                	je     801766 <_main+0x64a>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  80174d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	68 10 55 80 00       	push   $0x805510
  80175c:	6a 0c                	push   $0xc
  80175e:	e8 4e 06 00 00       	call   801db1 <cprintf_colored>
  801763:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  801766:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80176a:	74 04                	je     801770 <_main+0x654>
  80176c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801770:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	//[4] Free contiguous allocations
	cprintf_colored(TEXT_cyan, "%~\n%~[4] Free contiguous allocations\n");
  801777:	83 ec 08             	sub    $0x8,%esp
  80177a:	68 b0 55 80 00       	push   $0x8055b0
  80177f:	6a 03                	push   $0x3
  801781:	e8 2b 06 00 00       	call   801db1 <cprintf_colored>
  801786:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		free(ptr_allocations[3]);
  801789:	8b 45 90             	mov    -0x70(%ebp),%eax
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	50                   	push   %eax
  801790:	e8 9e 1d 00 00       	call   803533 <free>
  801795:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 512 KB hole and next 1 MB Hole => 2MB + 512KB Hole
		free(ptr_allocations[2]);
  801798:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	50                   	push   %eax
  80179f:	e8 8f 1d 00 00       	call   803533 <free>
  8017a4:	83 c4 10             	add    $0x10,%esp
	}

	//[5] Allocate again [test custom fit]
	cprintf_colored(TEXT_cyan, "%~\n%~[5] Allocate again [test custom fit] [40%]\n");
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	68 d8 55 80 00       	push   $0x8055d8
  8017af:	6a 03                	push   $0x3
  8017b1:	e8 fb 05 00 00       	call   801db1 <cprintf_colored>
  8017b6:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 2 MB + 1 KB - should be placed in the contiguous hole (512 KB + 2 MB)
		is_correct = 1;
  8017b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[13] = smalloc("Cust4", 2*Mega + 1*kilo, 0);
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	6a 00                	push   $0x0
  8017c5:	68 00 04 20 00       	push   $0x200400
  8017ca:	68 09 56 80 00       	push   $0x805609
  8017cf:	e8 9b 1e 00 00       	call   80366f <smalloc>
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 512*kilo))
  8017da:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017dd:	89 c2                	mov    %eax,%edx
  8017df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e2:	05 00 00 18 00       	add    $0x180000,%eax
  8017e7:	39 c2                	cmp    %eax,%edx
  8017e9:	74 19                	je     801804 <_main+0x6e8>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8017eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8017f2:	83 ec 08             	sub    $0x8,%esp
  8017f5:	68 10 55 80 00       	push   $0x805510
  8017fa:	6a 0c                	push   $0xc
  8017fc:	e8 b0 05 00 00       	call   801db1 <cprintf_colored>
  801801:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=15;
  801804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801808:	74 04                	je     80180e <_main+0x6f2>
  80180a:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		is_correct = 1;
  80180e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared of 1 MB [should be placed at the end of all allocations]
		is_correct = 1;
  801815:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[14] = sget(envID, "x");
  80181c:	83 ec 08             	sub    $0x8,%esp
  80181f:	68 db 53 80 00       	push   $0x8053db
  801824:	ff 75 ec             	pushl  -0x14(%ebp)
  801827:	e8 a3 1f 00 00       	call   8037cf <sget>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if ((uint32) ptr_allocations[14] != (pagealloc_start + 18*Mega))
  801832:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801835:	89 c2                	mov    %eax,%edx
  801837:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183a:	05 00 00 20 01       	add    $0x1200000,%eax
  80183f:	39 c2                	cmp    %eax,%edx
  801841:	74 19                	je     80185c <_main+0x740>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801843:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80184a:	83 ec 08             	sub    $0x8,%esp
  80184d:	68 10 55 80 00       	push   $0x805510
  801852:	6a 0c                	push   $0xc
  801854:	e8 58 05 00 00       	call   801db1 <cprintf_colored>
  801859:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  80185c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801860:	74 04                	je     801866 <_main+0x74a>
  801862:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801866:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate shared of 508 KB [should be placed in the remaining part of the contiguous (512 KB + 2 MB) hole
		is_correct = 1;
  80186d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[15] = smalloc("Cust5", 508*kilo, 0);
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	6a 00                	push   $0x0
  801879:	68 00 f0 07 00       	push   $0x7f000
  80187e:	68 0f 56 80 00       	push   $0x80560f
  801883:	e8 e7 1d 00 00       	call   80366f <smalloc>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if ((uint32) ptr_allocations[15] != (pagealloc_start + 3*Mega + 512*kilo + 4*kilo))
  80188e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801891:	89 c2                	mov    %eax,%edx
  801893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801896:	05 00 10 38 00       	add    $0x381000,%eax
  80189b:	39 c2                	cmp    %eax,%edx
  80189d:	74 19                	je     8018b8 <_main+0x79c>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  80189f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018a6:	83 ec 08             	sub    $0x8,%esp
  8018a9:	68 10 55 80 00       	push   $0x805510
  8018ae:	6a 0c                	push   $0xc
  8018b0:	e8 fc 04 00 00       	call   801db1 <cprintf_colored>
  8018b5:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=15;
  8018b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018bc:	74 04                	je     8018c2 <_main+0x7a6>
  8018be:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		is_correct = 1;
  8018c2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	cprintf_colored(TEXT_light_green, "%~\ntest Sharing CUSTOM FIT allocation (3) completed. Eval = %d%%\n\n", eval);
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018cf:	68 18 56 80 00       	push   $0x805618
  8018d4:	6a 0a                	push   $0xa
  8018d6:	e8 d6 04 00 00       	call   801db1 <cprintf_colored>
  8018db:	83 c4 10             	add    $0x10,%esp

	return;
  8018de:	90                   	nop
}
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5f                   	pop    %edi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	57                   	push   %edi
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8018ef:	e8 65 23 00 00       	call   803c59 <sys_getenvindex>
  8018f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8018f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018fa:	89 d0                	mov    %edx,%eax
  8018fc:	01 c0                	add    %eax,%eax
  8018fe:	01 d0                	add    %edx,%eax
  801900:	c1 e0 02             	shl    $0x2,%eax
  801903:	01 d0                	add    %edx,%eax
  801905:	c1 e0 02             	shl    $0x2,%eax
  801908:	01 d0                	add    %edx,%eax
  80190a:	c1 e0 03             	shl    $0x3,%eax
  80190d:	01 d0                	add    %edx,%eax
  80190f:	c1 e0 02             	shl    $0x2,%eax
  801912:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801917:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80191c:	a1 00 72 80 00       	mov    0x807200,%eax
  801921:	8a 40 20             	mov    0x20(%eax),%al
  801924:	84 c0                	test   %al,%al
  801926:	74 0d                	je     801935 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801928:	a1 00 72 80 00       	mov    0x807200,%eax
  80192d:	83 c0 20             	add    $0x20,%eax
  801930:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801935:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801939:	7e 0a                	jle    801945 <libmain+0x5f>
		binaryname = argv[0];
  80193b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193e:	8b 00                	mov    (%eax),%eax
  801940:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	e8 c9 f7 ff ff       	call   80111c <_main>
  801953:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801956:	a1 00 70 80 00       	mov    0x807000,%eax
  80195b:	85 c0                	test   %eax,%eax
  80195d:	0f 84 01 01 00 00    	je     801a64 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801963:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801969:	bb 54 57 80 00       	mov    $0x805754,%ebx
  80196e:	ba 0e 00 00 00       	mov    $0xe,%edx
  801973:	89 c7                	mov    %eax,%edi
  801975:	89 de                	mov    %ebx,%esi
  801977:	89 d1                	mov    %edx,%ecx
  801979:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80197b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80197e:	b9 56 00 00 00       	mov    $0x56,%ecx
  801983:	b0 00                	mov    $0x0,%al
  801985:	89 d7                	mov    %edx,%edi
  801987:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801989:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801990:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	50                   	push   %eax
  801997:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80199d:	50                   	push   %eax
  80199e:	e8 ec 24 00 00       	call   803e8f <sys_utilities>
  8019a3:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8019a6:	e8 35 20 00 00       	call   8039e0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8019ab:	83 ec 0c             	sub    $0xc,%esp
  8019ae:	68 74 56 80 00       	push   $0x805674
  8019b3:	e8 cc 03 00 00       	call   801d84 <cprintf>
  8019b8:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8019bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	74 18                	je     8019da <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8019c2:	e8 e6 24 00 00       	call   803ead <sys_get_optimal_num_faults>
  8019c7:	83 ec 08             	sub    $0x8,%esp
  8019ca:	50                   	push   %eax
  8019cb:	68 9c 56 80 00       	push   $0x80569c
  8019d0:	e8 af 03 00 00       	call   801d84 <cprintf>
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	eb 59                	jmp    801a33 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8019da:	a1 00 72 80 00       	mov    0x807200,%eax
  8019df:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8019e5:	a1 00 72 80 00       	mov    0x807200,%eax
  8019ea:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	52                   	push   %edx
  8019f4:	50                   	push   %eax
  8019f5:	68 c0 56 80 00       	push   $0x8056c0
  8019fa:	e8 85 03 00 00       	call   801d84 <cprintf>
  8019ff:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801a02:	a1 00 72 80 00       	mov    0x807200,%eax
  801a07:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  801a0d:	a1 00 72 80 00       	mov    0x807200,%eax
  801a12:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  801a18:	a1 00 72 80 00       	mov    0x807200,%eax
  801a1d:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  801a23:	51                   	push   %ecx
  801a24:	52                   	push   %edx
  801a25:	50                   	push   %eax
  801a26:	68 e8 56 80 00       	push   $0x8056e8
  801a2b:	e8 54 03 00 00       	call   801d84 <cprintf>
  801a30:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801a33:	a1 00 72 80 00       	mov    0x807200,%eax
  801a38:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  801a3e:	83 ec 08             	sub    $0x8,%esp
  801a41:	50                   	push   %eax
  801a42:	68 40 57 80 00       	push   $0x805740
  801a47:	e8 38 03 00 00       	call   801d84 <cprintf>
  801a4c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	68 74 56 80 00       	push   $0x805674
  801a57:	e8 28 03 00 00       	call   801d84 <cprintf>
  801a5c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801a5f:	e8 96 1f 00 00       	call   8039fa <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801a64:	e8 1f 00 00 00       	call   801a88 <exit>
}
  801a69:	90                   	nop
  801a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a6d:	5b                   	pop    %ebx
  801a6e:	5e                   	pop    %esi
  801a6f:	5f                   	pop    %edi
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    

00801a72 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	6a 00                	push   $0x0
  801a7d:	e8 a3 21 00 00       	call   803c25 <sys_destroy_env>
  801a82:	83 c4 10             	add    $0x10,%esp
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <exit>:

void
exit(void)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801a8e:	e8 f8 21 00 00       	call   803c8b <sys_exit_env>
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a9c:	8d 45 10             	lea    0x10(%ebp),%eax
  801a9f:	83 c0 04             	add    $0x4,%eax
  801aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801aa5:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	74 16                	je     801ac4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801aae:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801ab3:	83 ec 08             	sub    $0x8,%esp
  801ab6:	50                   	push   %eax
  801ab7:	68 b8 57 80 00       	push   $0x8057b8
  801abc:	e8 c3 02 00 00       	call   801d84 <cprintf>
  801ac1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801ac4:	a1 04 70 80 00       	mov    0x807004,%eax
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	ff 75 08             	pushl  0x8(%ebp)
  801ad2:	50                   	push   %eax
  801ad3:	68 c0 57 80 00       	push   $0x8057c0
  801ad8:	6a 74                	push   $0x74
  801ada:	e8 d2 02 00 00       	call   801db1 <cprintf_colored>
  801adf:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae5:	83 ec 08             	sub    $0x8,%esp
  801ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  801aeb:	50                   	push   %eax
  801aec:	e8 24 02 00 00       	call   801d15 <vcprintf>
  801af1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	6a 00                	push   $0x0
  801af9:	68 e8 57 80 00       	push   $0x8057e8
  801afe:	e8 12 02 00 00       	call   801d15 <vcprintf>
  801b03:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b06:	e8 7d ff ff ff       	call   801a88 <exit>

	// should not return here
	while (1) ;
  801b0b:	eb fe                	jmp    801b0b <_panic+0x75>

00801b0d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
  801b11:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b14:	a1 00 72 80 00       	mov    0x807200,%eax
  801b19:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b22:	39 c2                	cmp    %eax,%edx
  801b24:	74 14                	je     801b3a <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	68 ec 57 80 00       	push   $0x8057ec
  801b2e:	6a 26                	push   $0x26
  801b30:	68 38 58 80 00       	push   $0x805838
  801b35:	e8 5c ff ff ff       	call   801a96 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b48:	e9 d9 00 00 00       	jmp    801c26 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  801b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	01 d0                	add    %edx,%eax
  801b5c:	8b 00                	mov    (%eax),%eax
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	75 08                	jne    801b6a <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b65:	e9 b9 00 00 00       	jmp    801c23 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  801b6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b78:	eb 79                	jmp    801bf3 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b7a:	a1 00 72 80 00       	mov    0x807200,%eax
  801b7f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801b85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b88:	89 d0                	mov    %edx,%eax
  801b8a:	01 c0                	add    %eax,%eax
  801b8c:	01 d0                	add    %edx,%eax
  801b8e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801b95:	01 d8                	add    %ebx,%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	01 c8                	add    %ecx,%eax
  801b9b:	8a 40 04             	mov    0x4(%eax),%al
  801b9e:	84 c0                	test   %al,%al
  801ba0:	75 4e                	jne    801bf0 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ba2:	a1 00 72 80 00       	mov    0x807200,%eax
  801ba7:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801bad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bb0:	89 d0                	mov    %edx,%eax
  801bb2:	01 c0                	add    %eax,%eax
  801bb4:	01 d0                	add    %edx,%eax
  801bb6:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801bbd:	01 d8                	add    %ebx,%eax
  801bbf:	01 d0                	add    %edx,%eax
  801bc1:	01 c8                	add    %ecx,%eax
  801bc3:	8b 00                	mov    (%eax),%eax
  801bc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801bc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	01 c8                	add    %ecx,%eax
  801be1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801be3:	39 c2                	cmp    %eax,%edx
  801be5:	75 09                	jne    801bf0 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  801be7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801bee:	eb 19                	jmp    801c09 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bf0:	ff 45 e8             	incl   -0x18(%ebp)
  801bf3:	a1 00 72 80 00       	mov    0x807200,%eax
  801bf8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c01:	39 c2                	cmp    %eax,%edx
  801c03:	0f 87 71 ff ff ff    	ja     801b7a <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c0d:	75 14                	jne    801c23 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 44 58 80 00       	push   $0x805844
  801c17:	6a 3a                	push   $0x3a
  801c19:	68 38 58 80 00       	push   $0x805838
  801c1e:	e8 73 fe ff ff       	call   801a96 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c23:	ff 45 f0             	incl   -0x10(%ebp)
  801c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c29:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c2c:	0f 8c 1b ff ff ff    	jl     801b4d <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c32:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c39:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c40:	eb 2e                	jmp    801c70 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c42:	a1 00 72 80 00       	mov    0x807200,%eax
  801c47:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801c4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c50:	89 d0                	mov    %edx,%eax
  801c52:	01 c0                	add    %eax,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801c5d:	01 d8                	add    %ebx,%eax
  801c5f:	01 d0                	add    %edx,%eax
  801c61:	01 c8                	add    %ecx,%eax
  801c63:	8a 40 04             	mov    0x4(%eax),%al
  801c66:	3c 01                	cmp    $0x1,%al
  801c68:	75 03                	jne    801c6d <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  801c6a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c6d:	ff 45 e0             	incl   -0x20(%ebp)
  801c70:	a1 00 72 80 00       	mov    0x807200,%eax
  801c75:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7e:	39 c2                	cmp    %eax,%edx
  801c80:	77 c0                	ja     801c42 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c85:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c88:	74 14                	je     801c9e <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  801c8a:	83 ec 04             	sub    $0x4,%esp
  801c8d:	68 98 58 80 00       	push   $0x805898
  801c92:	6a 44                	push   $0x44
  801c94:	68 38 58 80 00       	push   $0x805838
  801c99:	e8 f8 fd ff ff       	call   801a96 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c9e:	90                   	nop
  801c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cae:	8b 00                	mov    (%eax),%eax
  801cb0:	8d 48 01             	lea    0x1(%eax),%ecx
  801cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb6:	89 0a                	mov    %ecx,(%edx)
  801cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801cbb:	88 d1                	mov    %dl,%cl
  801cbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc7:	8b 00                	mov    (%eax),%eax
  801cc9:	3d ff 00 00 00       	cmp    $0xff,%eax
  801cce:	75 30                	jne    801d00 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801cd0:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801cd6:	a0 24 72 80 00       	mov    0x807224,%al
  801cdb:	0f b6 c0             	movzbl %al,%eax
  801cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ce1:	8b 09                	mov    (%ecx),%ecx
  801ce3:	89 cb                	mov    %ecx,%ebx
  801ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ce8:	83 c1 08             	add    $0x8,%ecx
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	53                   	push   %ebx
  801cee:	51                   	push   %ecx
  801cef:	e8 a8 1c 00 00       	call   80399c <sys_cputs>
  801cf4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	8b 40 04             	mov    0x4(%eax),%eax
  801d06:	8d 50 01             	lea    0x1(%eax),%edx
  801d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0c:	89 50 04             	mov    %edx,0x4(%eax)
}
  801d0f:	90                   	nop
  801d10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801d1e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d25:	00 00 00 
	b.cnt = 0;
  801d28:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d2f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d3e:	50                   	push   %eax
  801d3f:	68 a4 1c 80 00       	push   $0x801ca4
  801d44:	e8 5a 02 00 00       	call   801fa3 <vprintfmt>
  801d49:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801d4c:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801d52:	a0 24 72 80 00       	mov    0x807224,%al
  801d57:	0f b6 c0             	movzbl %al,%eax
  801d5a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801d60:	52                   	push   %edx
  801d61:	50                   	push   %eax
  801d62:	51                   	push   %ecx
  801d63:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d69:	83 c0 08             	add    $0x8,%eax
  801d6c:	50                   	push   %eax
  801d6d:	e8 2a 1c 00 00       	call   80399c <sys_cputs>
  801d72:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801d75:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801d7c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801d8a:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  801d91:	8d 45 0c             	lea    0xc(%ebp),%eax
  801d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801da0:	50                   	push   %eax
  801da1:	e8 6f ff ff ff       	call   801d15 <vcprintf>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801db7:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	c1 e0 08             	shl    $0x8,%eax
  801dc4:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801dc9:	8d 45 0c             	lea    0xc(%ebp),%eax
  801dcc:	83 c0 04             	add    $0x4,%eax
  801dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddb:	50                   	push   %eax
  801ddc:	e8 34 ff ff ff       	call   801d15 <vcprintf>
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801de7:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801dee:	07 00 00 

	return cnt;
  801df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801dfc:	e8 df 1b 00 00       	call   8039e0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801e01:	8d 45 0c             	lea    0xc(%ebp),%eax
  801e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	83 ec 08             	sub    $0x8,%esp
  801e0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e10:	50                   	push   %eax
  801e11:	e8 ff fe ff ff       	call   801d15 <vcprintf>
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801e1c:	e8 d9 1b 00 00       	call   8039fa <sys_unlock_cons>
	return cnt;
  801e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 14             	sub    $0x14,%esp
  801e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e33:	8b 45 14             	mov    0x14(%ebp),%eax
  801e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801e39:	8b 45 18             	mov    0x18(%ebp),%eax
  801e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e41:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801e44:	77 55                	ja     801e9b <printnum+0x75>
  801e46:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801e49:	72 05                	jb     801e50 <printnum+0x2a>
  801e4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e4e:	77 4b                	ja     801e9b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801e50:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801e53:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801e56:	8b 45 18             	mov    0x18(%ebp),%eax
  801e59:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5e:	52                   	push   %edx
  801e5f:	50                   	push   %eax
  801e60:	ff 75 f4             	pushl  -0xc(%ebp)
  801e63:	ff 75 f0             	pushl  -0x10(%ebp)
  801e66:	e8 d5 2d 00 00       	call   804c40 <__udivdi3>
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	83 ec 04             	sub    $0x4,%esp
  801e71:	ff 75 20             	pushl  0x20(%ebp)
  801e74:	53                   	push   %ebx
  801e75:	ff 75 18             	pushl  0x18(%ebp)
  801e78:	52                   	push   %edx
  801e79:	50                   	push   %eax
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	e8 a1 ff ff ff       	call   801e26 <printnum>
  801e85:	83 c4 20             	add    $0x20,%esp
  801e88:	eb 1a                	jmp    801ea4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	ff 75 20             	pushl  0x20(%ebp)
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	ff d0                	call   *%eax
  801e98:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e9b:	ff 4d 1c             	decl   0x1c(%ebp)
  801e9e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801ea2:	7f e6                	jg     801e8a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801ea4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb2:	53                   	push   %ebx
  801eb3:	51                   	push   %ecx
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	e8 95 2e 00 00       	call   804d50 <__umoddi3>
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	05 14 5b 80 00       	add    $0x805b14,%eax
  801ec3:	8a 00                	mov    (%eax),%al
  801ec5:	0f be c0             	movsbl %al,%eax
  801ec8:	83 ec 08             	sub    $0x8,%esp
  801ecb:	ff 75 0c             	pushl  0xc(%ebp)
  801ece:	50                   	push   %eax
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	ff d0                	call   *%eax
  801ed4:	83 c4 10             	add    $0x10,%esp
}
  801ed7:	90                   	nop
  801ed8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801ee0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801ee4:	7e 1c                	jle    801f02 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	8d 50 08             	lea    0x8(%eax),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	89 10                	mov    %edx,(%eax)
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	8b 00                	mov    (%eax),%eax
  801ef8:	83 e8 08             	sub    $0x8,%eax
  801efb:	8b 50 04             	mov    0x4(%eax),%edx
  801efe:	8b 00                	mov    (%eax),%eax
  801f00:	eb 40                	jmp    801f42 <getuint+0x65>
	else if (lflag)
  801f02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f06:	74 1e                	je     801f26 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	8b 00                	mov    (%eax),%eax
  801f0d:	8d 50 04             	lea    0x4(%eax),%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	89 10                	mov    %edx,(%eax)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	8b 00                	mov    (%eax),%eax
  801f1a:	83 e8 04             	sub    $0x4,%eax
  801f1d:	8b 00                	mov    (%eax),%eax
  801f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f24:	eb 1c                	jmp    801f42 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8b 00                	mov    (%eax),%eax
  801f2b:	8d 50 04             	lea    0x4(%eax),%edx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	89 10                	mov    %edx,(%eax)
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	83 e8 04             	sub    $0x4,%eax
  801f3b:	8b 00                	mov    (%eax),%eax
  801f3d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801f47:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801f4b:	7e 1c                	jle    801f69 <getint+0x25>
		return va_arg(*ap, long long);
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	8b 00                	mov    (%eax),%eax
  801f52:	8d 50 08             	lea    0x8(%eax),%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	89 10                	mov    %edx,(%eax)
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	8b 00                	mov    (%eax),%eax
  801f5f:	83 e8 08             	sub    $0x8,%eax
  801f62:	8b 50 04             	mov    0x4(%eax),%edx
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	eb 38                	jmp    801fa1 <getint+0x5d>
	else if (lflag)
  801f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f6d:	74 1a                	je     801f89 <getint+0x45>
		return va_arg(*ap, long);
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	8b 00                	mov    (%eax),%eax
  801f74:	8d 50 04             	lea    0x4(%eax),%edx
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	89 10                	mov    %edx,(%eax)
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	83 e8 04             	sub    $0x4,%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	99                   	cltd   
  801f87:	eb 18                	jmp    801fa1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8b 00                	mov    (%eax),%eax
  801f8e:	8d 50 04             	lea    0x4(%eax),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	89 10                	mov    %edx,(%eax)
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	83 e8 04             	sub    $0x4,%eax
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	99                   	cltd   
}
  801fa1:	5d                   	pop    %ebp
  801fa2:	c3                   	ret    

00801fa3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801fab:	eb 17                	jmp    801fc4 <vprintfmt+0x21>
			if (ch == '\0')
  801fad:	85 db                	test   %ebx,%ebx
  801faf:	0f 84 c1 03 00 00    	je     802376 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801fb5:	83 ec 08             	sub    $0x8,%esp
  801fb8:	ff 75 0c             	pushl  0xc(%ebp)
  801fbb:	53                   	push   %ebx
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	ff d0                	call   *%eax
  801fc1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc7:	8d 50 01             	lea    0x1(%eax),%edx
  801fca:	89 55 10             	mov    %edx,0x10(%ebp)
  801fcd:	8a 00                	mov    (%eax),%al
  801fcf:	0f b6 d8             	movzbl %al,%ebx
  801fd2:	83 fb 25             	cmp    $0x25,%ebx
  801fd5:	75 d6                	jne    801fad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801fd7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801fdb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801fe2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801fe9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ff0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffa:	8d 50 01             	lea    0x1(%eax),%edx
  801ffd:	89 55 10             	mov    %edx,0x10(%ebp)
  802000:	8a 00                	mov    (%eax),%al
  802002:	0f b6 d8             	movzbl %al,%ebx
  802005:	8d 43 dd             	lea    -0x23(%ebx),%eax
  802008:	83 f8 5b             	cmp    $0x5b,%eax
  80200b:	0f 87 3d 03 00 00    	ja     80234e <vprintfmt+0x3ab>
  802011:	8b 04 85 38 5b 80 00 	mov    0x805b38(,%eax,4),%eax
  802018:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80201a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80201e:	eb d7                	jmp    801ff7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802020:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  802024:	eb d1                	jmp    801ff7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802026:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80202d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802030:	89 d0                	mov    %edx,%eax
  802032:	c1 e0 02             	shl    $0x2,%eax
  802035:	01 d0                	add    %edx,%eax
  802037:	01 c0                	add    %eax,%eax
  802039:	01 d8                	add    %ebx,%eax
  80203b:	83 e8 30             	sub    $0x30,%eax
  80203e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  802041:	8b 45 10             	mov    0x10(%ebp),%eax
  802044:	8a 00                	mov    (%eax),%al
  802046:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802049:	83 fb 2f             	cmp    $0x2f,%ebx
  80204c:	7e 3e                	jle    80208c <vprintfmt+0xe9>
  80204e:	83 fb 39             	cmp    $0x39,%ebx
  802051:	7f 39                	jg     80208c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802053:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802056:	eb d5                	jmp    80202d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802058:	8b 45 14             	mov    0x14(%ebp),%eax
  80205b:	83 c0 04             	add    $0x4,%eax
  80205e:	89 45 14             	mov    %eax,0x14(%ebp)
  802061:	8b 45 14             	mov    0x14(%ebp),%eax
  802064:	83 e8 04             	sub    $0x4,%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80206c:	eb 1f                	jmp    80208d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80206e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802072:	79 83                	jns    801ff7 <vprintfmt+0x54>
				width = 0;
  802074:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80207b:	e9 77 ff ff ff       	jmp    801ff7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  802080:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  802087:	e9 6b ff ff ff       	jmp    801ff7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80208c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80208d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802091:	0f 89 60 ff ff ff    	jns    801ff7 <vprintfmt+0x54>
				width = precision, precision = -1;
  802097:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80209d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8020a4:	e9 4e ff ff ff       	jmp    801ff7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8020a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8020ac:	e9 46 ff ff ff       	jmp    801ff7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8020b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b4:	83 c0 04             	add    $0x4,%eax
  8020b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8020ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8020bd:	83 e8 04             	sub    $0x4,%eax
  8020c0:	8b 00                	mov    (%eax),%eax
  8020c2:	83 ec 08             	sub    $0x8,%esp
  8020c5:	ff 75 0c             	pushl  0xc(%ebp)
  8020c8:	50                   	push   %eax
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	ff d0                	call   *%eax
  8020ce:	83 c4 10             	add    $0x10,%esp
			break;
  8020d1:	e9 9b 02 00 00       	jmp    802371 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8020d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d9:	83 c0 04             	add    $0x4,%eax
  8020dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8020df:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e2:	83 e8 04             	sub    $0x4,%eax
  8020e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8020e7:	85 db                	test   %ebx,%ebx
  8020e9:	79 02                	jns    8020ed <vprintfmt+0x14a>
				err = -err;
  8020eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8020ed:	83 fb 64             	cmp    $0x64,%ebx
  8020f0:	7f 0b                	jg     8020fd <vprintfmt+0x15a>
  8020f2:	8b 34 9d 80 59 80 00 	mov    0x805980(,%ebx,4),%esi
  8020f9:	85 f6                	test   %esi,%esi
  8020fb:	75 19                	jne    802116 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8020fd:	53                   	push   %ebx
  8020fe:	68 25 5b 80 00       	push   $0x805b25
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	ff 75 08             	pushl  0x8(%ebp)
  802109:	e8 70 02 00 00       	call   80237e <printfmt>
  80210e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802111:	e9 5b 02 00 00       	jmp    802371 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802116:	56                   	push   %esi
  802117:	68 2e 5b 80 00       	push   $0x805b2e
  80211c:	ff 75 0c             	pushl  0xc(%ebp)
  80211f:	ff 75 08             	pushl  0x8(%ebp)
  802122:	e8 57 02 00 00       	call   80237e <printfmt>
  802127:	83 c4 10             	add    $0x10,%esp
			break;
  80212a:	e9 42 02 00 00       	jmp    802371 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80212f:	8b 45 14             	mov    0x14(%ebp),%eax
  802132:	83 c0 04             	add    $0x4,%eax
  802135:	89 45 14             	mov    %eax,0x14(%ebp)
  802138:	8b 45 14             	mov    0x14(%ebp),%eax
  80213b:	83 e8 04             	sub    $0x4,%eax
  80213e:	8b 30                	mov    (%eax),%esi
  802140:	85 f6                	test   %esi,%esi
  802142:	75 05                	jne    802149 <vprintfmt+0x1a6>
				p = "(null)";
  802144:	be 31 5b 80 00       	mov    $0x805b31,%esi
			if (width > 0 && padc != '-')
  802149:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80214d:	7e 6d                	jle    8021bc <vprintfmt+0x219>
  80214f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  802153:	74 67                	je     8021bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  802155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802158:	83 ec 08             	sub    $0x8,%esp
  80215b:	50                   	push   %eax
  80215c:	56                   	push   %esi
  80215d:	e8 1e 03 00 00       	call   802480 <strnlen>
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  802168:	eb 16                	jmp    802180 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80216a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80216e:	83 ec 08             	sub    $0x8,%esp
  802171:	ff 75 0c             	pushl  0xc(%ebp)
  802174:	50                   	push   %eax
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	ff d0                	call   *%eax
  80217a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80217d:	ff 4d e4             	decl   -0x1c(%ebp)
  802180:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802184:	7f e4                	jg     80216a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802186:	eb 34                	jmp    8021bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  802188:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80218c:	74 1c                	je     8021aa <vprintfmt+0x207>
  80218e:	83 fb 1f             	cmp    $0x1f,%ebx
  802191:	7e 05                	jle    802198 <vprintfmt+0x1f5>
  802193:	83 fb 7e             	cmp    $0x7e,%ebx
  802196:	7e 12                	jle    8021aa <vprintfmt+0x207>
					putch('?', putdat);
  802198:	83 ec 08             	sub    $0x8,%esp
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	6a 3f                	push   $0x3f
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	ff d0                	call   *%eax
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	eb 0f                	jmp    8021b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8021aa:	83 ec 08             	sub    $0x8,%esp
  8021ad:	ff 75 0c             	pushl  0xc(%ebp)
  8021b0:	53                   	push   %ebx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	ff d0                	call   *%eax
  8021b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8021b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8021bc:	89 f0                	mov    %esi,%eax
  8021be:	8d 70 01             	lea    0x1(%eax),%esi
  8021c1:	8a 00                	mov    (%eax),%al
  8021c3:	0f be d8             	movsbl %al,%ebx
  8021c6:	85 db                	test   %ebx,%ebx
  8021c8:	74 24                	je     8021ee <vprintfmt+0x24b>
  8021ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021ce:	78 b8                	js     802188 <vprintfmt+0x1e5>
  8021d0:	ff 4d e0             	decl   -0x20(%ebp)
  8021d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021d7:	79 af                	jns    802188 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021d9:	eb 13                	jmp    8021ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8021db:	83 ec 08             	sub    $0x8,%esp
  8021de:	ff 75 0c             	pushl  0xc(%ebp)
  8021e1:	6a 20                	push   $0x20
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	ff d0                	call   *%eax
  8021e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8021ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021f2:	7f e7                	jg     8021db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8021f4:	e9 78 01 00 00       	jmp    802371 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8021f9:	83 ec 08             	sub    $0x8,%esp
  8021fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8021ff:	8d 45 14             	lea    0x14(%ebp),%eax
  802202:	50                   	push   %eax
  802203:	e8 3c fd ff ff       	call   801f44 <getint>
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80220e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802217:	85 d2                	test   %edx,%edx
  802219:	79 23                	jns    80223e <vprintfmt+0x29b>
				putch('-', putdat);
  80221b:	83 ec 08             	sub    $0x8,%esp
  80221e:	ff 75 0c             	pushl  0xc(%ebp)
  802221:	6a 2d                	push   $0x2d
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	ff d0                	call   *%eax
  802228:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802231:	f7 d8                	neg    %eax
  802233:	83 d2 00             	adc    $0x0,%edx
  802236:	f7 da                	neg    %edx
  802238:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80223b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80223e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802245:	e9 bc 00 00 00       	jmp    802306 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80224a:	83 ec 08             	sub    $0x8,%esp
  80224d:	ff 75 e8             	pushl  -0x18(%ebp)
  802250:	8d 45 14             	lea    0x14(%ebp),%eax
  802253:	50                   	push   %eax
  802254:	e8 84 fc ff ff       	call   801edd <getuint>
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80225f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802262:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802269:	e9 98 00 00 00       	jmp    802306 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80226e:	83 ec 08             	sub    $0x8,%esp
  802271:	ff 75 0c             	pushl  0xc(%ebp)
  802274:	6a 58                	push   $0x58
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	ff d0                	call   *%eax
  80227b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80227e:	83 ec 08             	sub    $0x8,%esp
  802281:	ff 75 0c             	pushl  0xc(%ebp)
  802284:	6a 58                	push   $0x58
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	ff d0                	call   *%eax
  80228b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80228e:	83 ec 08             	sub    $0x8,%esp
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	6a 58                	push   $0x58
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	ff d0                	call   *%eax
  80229b:	83 c4 10             	add    $0x10,%esp
			break;
  80229e:	e9 ce 00 00 00       	jmp    802371 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8022a3:	83 ec 08             	sub    $0x8,%esp
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	6a 30                	push   $0x30
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	ff d0                	call   *%eax
  8022b0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8022b3:	83 ec 08             	sub    $0x8,%esp
  8022b6:	ff 75 0c             	pushl  0xc(%ebp)
  8022b9:	6a 78                	push   $0x78
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	ff d0                	call   *%eax
  8022c0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8022c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c6:	83 c0 04             	add    $0x4,%eax
  8022c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8022cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cf:	83 e8 04             	sub    $0x4,%eax
  8022d2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8022d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8022de:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8022e5:	eb 1f                	jmp    802306 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8022e7:	83 ec 08             	sub    $0x8,%esp
  8022ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8022ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8022f0:	50                   	push   %eax
  8022f1:	e8 e7 fb ff ff       	call   801edd <getuint>
  8022f6:	83 c4 10             	add    $0x10,%esp
  8022f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8022ff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802306:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80230a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	52                   	push   %edx
  802311:	ff 75 e4             	pushl  -0x1c(%ebp)
  802314:	50                   	push   %eax
  802315:	ff 75 f4             	pushl  -0xc(%ebp)
  802318:	ff 75 f0             	pushl  -0x10(%ebp)
  80231b:	ff 75 0c             	pushl  0xc(%ebp)
  80231e:	ff 75 08             	pushl  0x8(%ebp)
  802321:	e8 00 fb ff ff       	call   801e26 <printnum>
  802326:	83 c4 20             	add    $0x20,%esp
			break;
  802329:	eb 46                	jmp    802371 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80232b:	83 ec 08             	sub    $0x8,%esp
  80232e:	ff 75 0c             	pushl  0xc(%ebp)
  802331:	53                   	push   %ebx
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	ff d0                	call   *%eax
  802337:	83 c4 10             	add    $0x10,%esp
			break;
  80233a:	eb 35                	jmp    802371 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80233c:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  802343:	eb 2c                	jmp    802371 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  802345:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  80234c:	eb 23                	jmp    802371 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80234e:	83 ec 08             	sub    $0x8,%esp
  802351:	ff 75 0c             	pushl  0xc(%ebp)
  802354:	6a 25                	push   $0x25
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	ff d0                	call   *%eax
  80235b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80235e:	ff 4d 10             	decl   0x10(%ebp)
  802361:	eb 03                	jmp    802366 <vprintfmt+0x3c3>
  802363:	ff 4d 10             	decl   0x10(%ebp)
  802366:	8b 45 10             	mov    0x10(%ebp),%eax
  802369:	48                   	dec    %eax
  80236a:	8a 00                	mov    (%eax),%al
  80236c:	3c 25                	cmp    $0x25,%al
  80236e:	75 f3                	jne    802363 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  802370:	90                   	nop
		}
	}
  802371:	e9 35 fc ff ff       	jmp    801fab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802376:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802377:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80237a:	5b                   	pop    %ebx
  80237b:	5e                   	pop    %esi
  80237c:	5d                   	pop    %ebp
  80237d:	c3                   	ret    

0080237e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802384:	8d 45 10             	lea    0x10(%ebp),%eax
  802387:	83 c0 04             	add    $0x4,%eax
  80238a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80238d:	8b 45 10             	mov    0x10(%ebp),%eax
  802390:	ff 75 f4             	pushl  -0xc(%ebp)
  802393:	50                   	push   %eax
  802394:	ff 75 0c             	pushl  0xc(%ebp)
  802397:	ff 75 08             	pushl  0x8(%ebp)
  80239a:	e8 04 fc ff ff       	call   801fa3 <vprintfmt>
  80239f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8023a2:	90                   	nop
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8023a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ab:	8b 40 08             	mov    0x8(%eax),%eax
  8023ae:	8d 50 01             	lea    0x1(%eax),%edx
  8023b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8023b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ba:	8b 10                	mov    (%eax),%edx
  8023bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bf:	8b 40 04             	mov    0x4(%eax),%eax
  8023c2:	39 c2                	cmp    %eax,%edx
  8023c4:	73 12                	jae    8023d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8023ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d1:	89 0a                	mov    %ecx,(%edx)
  8023d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d6:	88 10                	mov    %dl,(%eax)
}
  8023d8:	90                   	nop
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    

008023db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8023e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	01 d0                	add    %edx,%eax
  8023f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8023fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802400:	74 06                	je     802408 <vsnprintf+0x2d>
  802402:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802406:	7f 07                	jg     80240f <vsnprintf+0x34>
		return -E_INVAL;
  802408:	b8 03 00 00 00       	mov    $0x3,%eax
  80240d:	eb 20                	jmp    80242f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80240f:	ff 75 14             	pushl  0x14(%ebp)
  802412:	ff 75 10             	pushl  0x10(%ebp)
  802415:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802418:	50                   	push   %eax
  802419:	68 a5 23 80 00       	push   $0x8023a5
  80241e:	e8 80 fb ff ff       	call   801fa3 <vprintfmt>
  802423:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802429:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802437:	8d 45 10             	lea    0x10(%ebp),%eax
  80243a:	83 c0 04             	add    $0x4,%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802440:	8b 45 10             	mov    0x10(%ebp),%eax
  802443:	ff 75 f4             	pushl  -0xc(%ebp)
  802446:	50                   	push   %eax
  802447:	ff 75 0c             	pushl  0xc(%ebp)
  80244a:	ff 75 08             	pushl  0x8(%ebp)
  80244d:	e8 89 ff ff ff       	call   8023db <vsnprintf>
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802463:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80246a:	eb 06                	jmp    802472 <strlen+0x15>
		n++;
  80246c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80246f:	ff 45 08             	incl   0x8(%ebp)
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	8a 00                	mov    (%eax),%al
  802477:	84 c0                	test   %al,%al
  802479:	75 f1                	jne    80246c <strlen+0xf>
		n++;
	return n;
  80247b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802486:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80248d:	eb 09                	jmp    802498 <strnlen+0x18>
		n++;
  80248f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802492:	ff 45 08             	incl   0x8(%ebp)
  802495:	ff 4d 0c             	decl   0xc(%ebp)
  802498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80249c:	74 09                	je     8024a7 <strnlen+0x27>
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	8a 00                	mov    (%eax),%al
  8024a3:	84 c0                	test   %al,%al
  8024a5:	75 e8                	jne    80248f <strnlen+0xf>
		n++;
	return n;
  8024a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8024b8:	90                   	nop
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8d 50 01             	lea    0x1(%eax),%edx
  8024bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8024c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8024cb:	8a 12                	mov    (%edx),%dl
  8024cd:	88 10                	mov    %dl,(%eax)
  8024cf:	8a 00                	mov    (%eax),%al
  8024d1:	84 c0                	test   %al,%al
  8024d3:	75 e4                	jne    8024b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8024d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8024e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024ed:	eb 1f                	jmp    80250e <strncpy+0x34>
		*dst++ = *src;
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	8d 50 01             	lea    0x1(%eax),%edx
  8024f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8024f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fb:	8a 12                	mov    (%edx),%dl
  8024fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8024ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802502:	8a 00                	mov    (%eax),%al
  802504:	84 c0                	test   %al,%al
  802506:	74 03                	je     80250b <strncpy+0x31>
			src++;
  802508:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80250b:	ff 45 fc             	incl   -0x4(%ebp)
  80250e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802511:	3b 45 10             	cmp    0x10(%ebp),%eax
  802514:	72 d9                	jb     8024ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802516:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80252b:	74 30                	je     80255d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80252d:	eb 16                	jmp    802545 <strlcpy+0x2a>
			*dst++ = *src++;
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	8d 50 01             	lea    0x1(%eax),%edx
  802535:	89 55 08             	mov    %edx,0x8(%ebp)
  802538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80253e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802541:	8a 12                	mov    (%edx),%dl
  802543:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802545:	ff 4d 10             	decl   0x10(%ebp)
  802548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80254c:	74 09                	je     802557 <strlcpy+0x3c>
  80254e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802551:	8a 00                	mov    (%eax),%al
  802553:	84 c0                	test   %al,%al
  802555:	75 d8                	jne    80252f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80255d:	8b 55 08             	mov    0x8(%ebp),%edx
  802560:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802563:	29 c2                	sub    %eax,%edx
  802565:	89 d0                	mov    %edx,%eax
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80256c:	eb 06                	jmp    802574 <strcmp+0xb>
		p++, q++;
  80256e:	ff 45 08             	incl   0x8(%ebp)
  802571:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	8a 00                	mov    (%eax),%al
  802579:	84 c0                	test   %al,%al
  80257b:	74 0e                	je     80258b <strcmp+0x22>
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	8a 10                	mov    (%eax),%dl
  802582:	8b 45 0c             	mov    0xc(%ebp),%eax
  802585:	8a 00                	mov    (%eax),%al
  802587:	38 c2                	cmp    %al,%dl
  802589:	74 e3                	je     80256e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	8a 00                	mov    (%eax),%al
  802590:	0f b6 d0             	movzbl %al,%edx
  802593:	8b 45 0c             	mov    0xc(%ebp),%eax
  802596:	8a 00                	mov    (%eax),%al
  802598:	0f b6 c0             	movzbl %al,%eax
  80259b:	29 c2                	sub    %eax,%edx
  80259d:	89 d0                	mov    %edx,%eax
}
  80259f:	5d                   	pop    %ebp
  8025a0:	c3                   	ret    

008025a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8025a4:	eb 09                	jmp    8025af <strncmp+0xe>
		n--, p++, q++;
  8025a6:	ff 4d 10             	decl   0x10(%ebp)
  8025a9:	ff 45 08             	incl   0x8(%ebp)
  8025ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8025af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025b3:	74 17                	je     8025cc <strncmp+0x2b>
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	8a 00                	mov    (%eax),%al
  8025ba:	84 c0                	test   %al,%al
  8025bc:	74 0e                	je     8025cc <strncmp+0x2b>
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	8a 10                	mov    (%eax),%dl
  8025c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c6:	8a 00                	mov    (%eax),%al
  8025c8:	38 c2                	cmp    %al,%dl
  8025ca:	74 da                	je     8025a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8025cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025d0:	75 07                	jne    8025d9 <strncmp+0x38>
		return 0;
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d7:	eb 14                	jmp    8025ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8a 00                	mov    (%eax),%al
  8025de:	0f b6 d0             	movzbl %al,%edx
  8025e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e4:	8a 00                	mov    (%eax),%al
  8025e6:	0f b6 c0             	movzbl %al,%eax
  8025e9:	29 c2                	sub    %eax,%edx
  8025eb:	89 d0                	mov    %edx,%eax
}
  8025ed:	5d                   	pop    %ebp
  8025ee:	c3                   	ret    

008025ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8025fb:	eb 12                	jmp    80260f <strchr+0x20>
		if (*s == c)
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	8a 00                	mov    (%eax),%al
  802602:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802605:	75 05                	jne    80260c <strchr+0x1d>
			return (char *) s;
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	eb 11                	jmp    80261d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80260c:	ff 45 08             	incl   0x8(%ebp)
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	8a 00                	mov    (%eax),%al
  802614:	84 c0                	test   %al,%al
  802616:	75 e5                	jne    8025fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	8b 45 0c             	mov    0xc(%ebp),%eax
  802628:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80262b:	eb 0d                	jmp    80263a <strfind+0x1b>
		if (*s == c)
  80262d:	8b 45 08             	mov    0x8(%ebp),%eax
  802630:	8a 00                	mov    (%eax),%al
  802632:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802635:	74 0e                	je     802645 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802637:	ff 45 08             	incl   0x8(%ebp)
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	8a 00                	mov    (%eax),%al
  80263f:	84 c0                	test   %al,%al
  802641:	75 ea                	jne    80262d <strfind+0xe>
  802643:	eb 01                	jmp    802646 <strfind+0x27>
		if (*s == c)
			break;
  802645:	90                   	nop
	return (char *) s;
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802657:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80265b:	76 63                	jbe    8026c0 <memset+0x75>
		uint64 data_block = c;
  80265d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802660:	99                   	cltd   
  802661:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802664:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802671:	c1 e0 08             	shl    $0x8,%eax
  802674:	09 45 f0             	or     %eax,-0x10(%ebp)
  802677:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802680:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802684:	c1 e0 10             	shl    $0x10,%eax
  802687:	09 45 f0             	or     %eax,-0x10(%ebp)
  80268a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80268d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802690:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802693:	89 c2                	mov    %eax,%edx
  802695:	b8 00 00 00 00       	mov    $0x0,%eax
  80269a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80269d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8026a0:	eb 18                	jmp    8026ba <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8026a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8026a5:	8d 41 08             	lea    0x8(%ecx),%eax
  8026a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	89 01                	mov    %eax,(%ecx)
  8026b3:	89 51 04             	mov    %edx,0x4(%ecx)
  8026b6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8026ba:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8026be:	77 e2                	ja     8026a2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8026c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026c4:	74 23                	je     8026e9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8026c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8026cc:	eb 0e                	jmp    8026dc <memset+0x91>
			*p8++ = (uint8)c;
  8026ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d1:	8d 50 01             	lea    0x1(%eax),%edx
  8026d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8026d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026da:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8026dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8026df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8026e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	75 e5                	jne    8026ce <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8026f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  802700:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802704:	76 24                	jbe    80272a <memcpy+0x3c>
		while(n >= 8){
  802706:	eb 1c                	jmp    802724 <memcpy+0x36>
			*d64 = *s64;
  802708:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80270b:	8b 50 04             	mov    0x4(%eax),%edx
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802713:	89 01                	mov    %eax,(%ecx)
  802715:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802718:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80271c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802720:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802724:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802728:	77 de                	ja     802708 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80272a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80272e:	74 31                	je     802761 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802730:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802733:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802736:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802739:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80273c:	eb 16                	jmp    802754 <memcpy+0x66>
			*d8++ = *s8++;
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	8d 50 01             	lea    0x1(%eax),%edx
  802744:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80274d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802750:	8a 12                	mov    (%edx),%dl
  802752:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802754:	8b 45 10             	mov    0x10(%ebp),%eax
  802757:	8d 50 ff             	lea    -0x1(%eax),%edx
  80275a:	89 55 10             	mov    %edx,0x10(%ebp)
  80275d:	85 c0                	test   %eax,%eax
  80275f:	75 dd                	jne    80273e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80276c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802772:	8b 45 08             	mov    0x8(%ebp),%eax
  802775:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802778:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80277e:	73 50                	jae    8027d0 <memmove+0x6a>
  802780:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802783:	8b 45 10             	mov    0x10(%ebp),%eax
  802786:	01 d0                	add    %edx,%eax
  802788:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80278b:	76 43                	jbe    8027d0 <memmove+0x6a>
		s += n;
  80278d:	8b 45 10             	mov    0x10(%ebp),%eax
  802790:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802793:	8b 45 10             	mov    0x10(%ebp),%eax
  802796:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802799:	eb 10                	jmp    8027ab <memmove+0x45>
			*--d = *--s;
  80279b:	ff 4d f8             	decl   -0x8(%ebp)
  80279e:	ff 4d fc             	decl   -0x4(%ebp)
  8027a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a4:	8a 10                	mov    (%eax),%dl
  8027a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8027ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	75 e3                	jne    80279b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8027b8:	eb 23                	jmp    8027dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8027ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027bd:	8d 50 01             	lea    0x1(%eax),%edx
  8027c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8027c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8027c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8027cc:	8a 12                	mov    (%edx),%dl
  8027ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8027d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8027d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	75 dd                	jne    8027ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8027ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8027f4:	eb 2a                	jmp    802820 <memcmp+0x3e>
		if (*s1 != *s2)
  8027f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f9:	8a 10                	mov    (%eax),%dl
  8027fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027fe:	8a 00                	mov    (%eax),%al
  802800:	38 c2                	cmp    %al,%dl
  802802:	74 16                	je     80281a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802804:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802807:	8a 00                	mov    (%eax),%al
  802809:	0f b6 d0             	movzbl %al,%edx
  80280c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80280f:	8a 00                	mov    (%eax),%al
  802811:	0f b6 c0             	movzbl %al,%eax
  802814:	29 c2                	sub    %eax,%edx
  802816:	89 d0                	mov    %edx,%eax
  802818:	eb 18                	jmp    802832 <memcmp+0x50>
		s1++, s2++;
  80281a:	ff 45 fc             	incl   -0x4(%ebp)
  80281d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802820:	8b 45 10             	mov    0x10(%ebp),%eax
  802823:	8d 50 ff             	lea    -0x1(%eax),%edx
  802826:	89 55 10             	mov    %edx,0x10(%ebp)
  802829:	85 c0                	test   %eax,%eax
  80282b:	75 c9                	jne    8027f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80283a:	8b 55 08             	mov    0x8(%ebp),%edx
  80283d:	8b 45 10             	mov    0x10(%ebp),%eax
  802840:	01 d0                	add    %edx,%eax
  802842:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802845:	eb 15                	jmp    80285c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	8a 00                	mov    (%eax),%al
  80284c:	0f b6 d0             	movzbl %al,%edx
  80284f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802852:	0f b6 c0             	movzbl %al,%eax
  802855:	39 c2                	cmp    %eax,%edx
  802857:	74 0d                	je     802866 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802859:	ff 45 08             	incl   0x8(%ebp)
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802862:	72 e3                	jb     802847 <memfind+0x13>
  802864:	eb 01                	jmp    802867 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802866:	90                   	nop
	return (void *) s;
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802872:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802879:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802880:	eb 03                	jmp    802885 <strtol+0x19>
		s++;
  802882:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	8a 00                	mov    (%eax),%al
  80288a:	3c 20                	cmp    $0x20,%al
  80288c:	74 f4                	je     802882 <strtol+0x16>
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	8a 00                	mov    (%eax),%al
  802893:	3c 09                	cmp    $0x9,%al
  802895:	74 eb                	je     802882 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	8a 00                	mov    (%eax),%al
  80289c:	3c 2b                	cmp    $0x2b,%al
  80289e:	75 05                	jne    8028a5 <strtol+0x39>
		s++;
  8028a0:	ff 45 08             	incl   0x8(%ebp)
  8028a3:	eb 13                	jmp    8028b8 <strtol+0x4c>
	else if (*s == '-')
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	8a 00                	mov    (%eax),%al
  8028aa:	3c 2d                	cmp    $0x2d,%al
  8028ac:	75 0a                	jne    8028b8 <strtol+0x4c>
		s++, neg = 1;
  8028ae:	ff 45 08             	incl   0x8(%ebp)
  8028b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8028b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028bc:	74 06                	je     8028c4 <strtol+0x58>
  8028be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8028c2:	75 20                	jne    8028e4 <strtol+0x78>
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8a 00                	mov    (%eax),%al
  8028c9:	3c 30                	cmp    $0x30,%al
  8028cb:	75 17                	jne    8028e4 <strtol+0x78>
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	40                   	inc    %eax
  8028d1:	8a 00                	mov    (%eax),%al
  8028d3:	3c 78                	cmp    $0x78,%al
  8028d5:	75 0d                	jne    8028e4 <strtol+0x78>
		s += 2, base = 16;
  8028d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8028db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8028e2:	eb 28                	jmp    80290c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8028e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028e8:	75 15                	jne    8028ff <strtol+0x93>
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	8a 00                	mov    (%eax),%al
  8028ef:	3c 30                	cmp    $0x30,%al
  8028f1:	75 0c                	jne    8028ff <strtol+0x93>
		s++, base = 8;
  8028f3:	ff 45 08             	incl   0x8(%ebp)
  8028f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8028fd:	eb 0d                	jmp    80290c <strtol+0xa0>
	else if (base == 0)
  8028ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802903:	75 07                	jne    80290c <strtol+0xa0>
		base = 10;
  802905:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8a 00                	mov    (%eax),%al
  802911:	3c 2f                	cmp    $0x2f,%al
  802913:	7e 19                	jle    80292e <strtol+0xc2>
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	8a 00                	mov    (%eax),%al
  80291a:	3c 39                	cmp    $0x39,%al
  80291c:	7f 10                	jg     80292e <strtol+0xc2>
			dig = *s - '0';
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	8a 00                	mov    (%eax),%al
  802923:	0f be c0             	movsbl %al,%eax
  802926:	83 e8 30             	sub    $0x30,%eax
  802929:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292c:	eb 42                	jmp    802970 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	8a 00                	mov    (%eax),%al
  802933:	3c 60                	cmp    $0x60,%al
  802935:	7e 19                	jle    802950 <strtol+0xe4>
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	8a 00                	mov    (%eax),%al
  80293c:	3c 7a                	cmp    $0x7a,%al
  80293e:	7f 10                	jg     802950 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	8a 00                	mov    (%eax),%al
  802945:	0f be c0             	movsbl %al,%eax
  802948:	83 e8 57             	sub    $0x57,%eax
  80294b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294e:	eb 20                	jmp    802970 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	8a 00                	mov    (%eax),%al
  802955:	3c 40                	cmp    $0x40,%al
  802957:	7e 39                	jle    802992 <strtol+0x126>
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	8a 00                	mov    (%eax),%al
  80295e:	3c 5a                	cmp    $0x5a,%al
  802960:	7f 30                	jg     802992 <strtol+0x126>
			dig = *s - 'A' + 10;
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	8a 00                	mov    (%eax),%al
  802967:	0f be c0             	movsbl %al,%eax
  80296a:	83 e8 37             	sub    $0x37,%eax
  80296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	3b 45 10             	cmp    0x10(%ebp),%eax
  802976:	7d 19                	jge    802991 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802978:	ff 45 08             	incl   0x8(%ebp)
  80297b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80297e:	0f af 45 10          	imul   0x10(%ebp),%eax
  802982:	89 c2                	mov    %eax,%edx
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	01 d0                	add    %edx,%eax
  802989:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80298c:	e9 7b ff ff ff       	jmp    80290c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802991:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802992:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802996:	74 08                	je     8029a0 <strtol+0x134>
		*endptr = (char *) s;
  802998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80299b:	8b 55 08             	mov    0x8(%ebp),%edx
  80299e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8029a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029a4:	74 07                	je     8029ad <strtol+0x141>
  8029a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029a9:	f7 d8                	neg    %eax
  8029ab:	eb 03                	jmp    8029b0 <strtol+0x144>
  8029ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8029b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8029bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8029c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ca:	79 13                	jns    8029df <ltostr+0x2d>
	{
		neg = 1;
  8029cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8029d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8029d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8029dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8029e7:	99                   	cltd   
  8029e8:	f7 f9                	idiv   %ecx
  8029ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8029ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029f0:	8d 50 01             	lea    0x1(%eax),%edx
  8029f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8029f6:	89 c2                	mov    %eax,%edx
  8029f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029fb:	01 d0                	add    %edx,%eax
  8029fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a00:	83 c2 30             	add    $0x30,%edx
  802a03:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802a05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a08:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802a0d:	f7 e9                	imul   %ecx
  802a0f:	c1 fa 02             	sar    $0x2,%edx
  802a12:	89 c8                	mov    %ecx,%eax
  802a14:	c1 f8 1f             	sar    $0x1f,%eax
  802a17:	29 c2                	sub    %eax,%edx
  802a19:	89 d0                	mov    %edx,%eax
  802a1b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802a1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a22:	75 bb                	jne    8029df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802a24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a2e:	48                   	dec    %eax
  802a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802a32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a36:	74 3d                	je     802a75 <ltostr+0xc3>
		start = 1 ;
  802a38:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802a3f:	eb 34                	jmp    802a75 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a47:	01 d0                	add    %edx,%eax
  802a49:	8a 00                	mov    (%eax),%al
  802a4b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a54:	01 c2                	add    %eax,%edx
  802a56:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a5c:	01 c8                	add    %ecx,%eax
  802a5e:	8a 00                	mov    (%eax),%al
  802a60:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802a62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a68:	01 c2                	add    %eax,%edx
  802a6a:	8a 45 eb             	mov    -0x15(%ebp),%al
  802a6d:	88 02                	mov    %al,(%edx)
		start++ ;
  802a6f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802a72:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a7b:	7c c4                	jl     802a41 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802a7d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a83:	01 d0                	add    %edx,%eax
  802a85:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802a88:	90                   	nop
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802a91:	ff 75 08             	pushl  0x8(%ebp)
  802a94:	e8 c4 f9 ff ff       	call   80245d <strlen>
  802a99:	83 c4 04             	add    $0x4,%esp
  802a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802a9f:	ff 75 0c             	pushl  0xc(%ebp)
  802aa2:	e8 b6 f9 ff ff       	call   80245d <strlen>
  802aa7:	83 c4 04             	add    $0x4,%esp
  802aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802aad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802ab4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802abb:	eb 17                	jmp    802ad4 <strcconcat+0x49>
		final[s] = str1[s] ;
  802abd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ac3:	01 c2                	add    %eax,%edx
  802ac5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	01 c8                	add    %ecx,%eax
  802acd:	8a 00                	mov    (%eax),%al
  802acf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802ad1:	ff 45 fc             	incl   -0x4(%ebp)
  802ad4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ad7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ada:	7c e1                	jl     802abd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802adc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802ae3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802aea:	eb 1f                	jmp    802b0b <strcconcat+0x80>
		final[s++] = str2[i] ;
  802aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aef:	8d 50 01             	lea    0x1(%eax),%edx
  802af2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802af5:	89 c2                	mov    %eax,%edx
  802af7:	8b 45 10             	mov    0x10(%ebp),%eax
  802afa:	01 c2                	add    %eax,%edx
  802afc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b02:	01 c8                	add    %ecx,%eax
  802b04:	8a 00                	mov    (%eax),%al
  802b06:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802b08:	ff 45 f8             	incl   -0x8(%ebp)
  802b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b11:	7c d9                	jl     802aec <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802b13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b16:	8b 45 10             	mov    0x10(%ebp),%eax
  802b19:	01 d0                	add    %edx,%eax
  802b1b:	c6 00 00             	movb   $0x0,(%eax)
}
  802b1e:	90                   	nop
  802b1f:	c9                   	leave  
  802b20:	c3                   	ret    

00802b21 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802b24:	8b 45 14             	mov    0x14(%ebp),%eax
  802b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802b39:	8b 45 10             	mov    0x10(%ebp),%eax
  802b3c:	01 d0                	add    %edx,%eax
  802b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802b44:	eb 0c                	jmp    802b52 <strsplit+0x31>
			*string++ = 0;
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8d 50 01             	lea    0x1(%eax),%edx
  802b4c:	89 55 08             	mov    %edx,0x8(%ebp)
  802b4f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	8a 00                	mov    (%eax),%al
  802b57:	84 c0                	test   %al,%al
  802b59:	74 18                	je     802b73 <strsplit+0x52>
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	8a 00                	mov    (%eax),%al
  802b60:	0f be c0             	movsbl %al,%eax
  802b63:	50                   	push   %eax
  802b64:	ff 75 0c             	pushl  0xc(%ebp)
  802b67:	e8 83 fa ff ff       	call   8025ef <strchr>
  802b6c:	83 c4 08             	add    $0x8,%esp
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	75 d3                	jne    802b46 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	8a 00                	mov    (%eax),%al
  802b78:	84 c0                	test   %al,%al
  802b7a:	74 5a                	je     802bd6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	83 f8 0f             	cmp    $0xf,%eax
  802b84:	75 07                	jne    802b8d <strsplit+0x6c>
		{
			return 0;
  802b86:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8b:	eb 66                	jmp    802bf3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802b8d:	8b 45 14             	mov    0x14(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	8d 48 01             	lea    0x1(%eax),%ecx
  802b95:	8b 55 14             	mov    0x14(%ebp),%edx
  802b98:	89 0a                	mov    %ecx,(%edx)
  802b9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ba4:	01 c2                	add    %eax,%edx
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802bab:	eb 03                	jmp    802bb0 <strsplit+0x8f>
			string++;
  802bad:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8a 00                	mov    (%eax),%al
  802bb5:	84 c0                	test   %al,%al
  802bb7:	74 8b                	je     802b44 <strsplit+0x23>
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	8a 00                	mov    (%eax),%al
  802bbe:	0f be c0             	movsbl %al,%eax
  802bc1:	50                   	push   %eax
  802bc2:	ff 75 0c             	pushl  0xc(%ebp)
  802bc5:	e8 25 fa ff ff       	call   8025ef <strchr>
  802bca:	83 c4 08             	add    $0x8,%esp
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	74 dc                	je     802bad <strsplit+0x8c>
			string++;
	}
  802bd1:	e9 6e ff ff ff       	jmp    802b44 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802bd6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802be3:	8b 45 10             	mov    0x10(%ebp),%eax
  802be6:	01 d0                	add    %edx,%eax
  802be8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802bee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802bf3:	c9                   	leave  
  802bf4:	c3                   	ret    

00802bf5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802bf5:	55                   	push   %ebp
  802bf6:	89 e5                	mov    %esp,%ebp
  802bf8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802c01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802c08:	eb 4a                	jmp    802c54 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802c0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	01 c2                	add    %eax,%edx
  802c12:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c18:	01 c8                	add    %ecx,%eax
  802c1a:	8a 00                	mov    (%eax),%al
  802c1c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802c1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c24:	01 d0                	add    %edx,%eax
  802c26:	8a 00                	mov    (%eax),%al
  802c28:	3c 40                	cmp    $0x40,%al
  802c2a:	7e 25                	jle    802c51 <str2lower+0x5c>
  802c2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c32:	01 d0                	add    %edx,%eax
  802c34:	8a 00                	mov    (%eax),%al
  802c36:	3c 5a                	cmp    $0x5a,%al
  802c38:	7f 17                	jg     802c51 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802c3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	01 d0                	add    %edx,%eax
  802c42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802c45:	8b 55 08             	mov    0x8(%ebp),%edx
  802c48:	01 ca                	add    %ecx,%edx
  802c4a:	8a 12                	mov    (%edx),%dl
  802c4c:	83 c2 20             	add    $0x20,%edx
  802c4f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802c51:	ff 45 fc             	incl   -0x4(%ebp)
  802c54:	ff 75 0c             	pushl  0xc(%ebp)
  802c57:	e8 01 f8 ff ff       	call   80245d <strlen>
  802c5c:	83 c4 04             	add    $0x4,%esp
  802c5f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802c62:	7f a6                	jg     802c0a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802c67:	c9                   	leave  
  802c68:	c3                   	ret    

00802c69 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
  802c6c:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  802c6f:	83 ec 0c             	sub    $0xc,%esp
  802c72:	6a 10                	push   $0x10
  802c74:	e8 b2 15 00 00       	call   80422b <alloc_block>
  802c79:	83 c4 10             	add    $0x10,%esp
  802c7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  802c7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c83:	75 14                	jne    802c99 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	68 a8 5c 80 00       	push   $0x805ca8
  802c8d:	6a 14                	push   $0x14
  802c8f:	68 d1 5c 80 00       	push   $0x805cd1
  802c94:	e8 fd ed ff ff       	call   801a96 <_panic>

	node->start = start;
  802c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9f:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  802ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca7:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  802cb1:	a1 04 72 80 00       	mov    0x807204,%eax
  802cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb9:	eb 18                	jmp    802cd3 <insert_page_alloc+0x6a>
		if (start < it->start)
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc3:	77 37                	ja     802cfc <insert_page_alloc+0x93>
			break;
		prev = it;
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  802ccb:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd7:	74 08                	je     802ce1 <insert_page_alloc+0x78>
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 08             	mov    0x8(%eax),%eax
  802cdf:	eb 05                	jmp    802ce6 <insert_page_alloc+0x7d>
  802ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce6:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802ceb:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	75 c7                	jne    802cbb <insert_page_alloc+0x52>
  802cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf8:	75 c1                	jne    802cbb <insert_page_alloc+0x52>
  802cfa:	eb 01                	jmp    802cfd <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  802cfc:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  802cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d01:	75 64                	jne    802d67 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  802d03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d07:	75 14                	jne    802d1d <insert_page_alloc+0xb4>
  802d09:	83 ec 04             	sub    $0x4,%esp
  802d0c:	68 e0 5c 80 00       	push   $0x805ce0
  802d11:	6a 21                	push   $0x21
  802d13:	68 d1 5c 80 00       	push   $0x805cd1
  802d18:	e8 79 ed ff ff       	call   801a96 <_panic>
  802d1d:	8b 15 04 72 80 00    	mov    0x807204,%edx
  802d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d26:	89 50 08             	mov    %edx,0x8(%eax)
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	8b 40 08             	mov    0x8(%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 0d                	je     802d40 <insert_page_alloc+0xd7>
  802d33:	a1 04 72 80 00       	mov    0x807204,%eax
  802d38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d3b:	89 50 0c             	mov    %edx,0xc(%eax)
  802d3e:	eb 08                	jmp    802d48 <insert_page_alloc+0xdf>
  802d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d43:	a3 08 72 80 00       	mov    %eax,0x807208
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	a3 04 72 80 00       	mov    %eax,0x807204
  802d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d53:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d5a:	a1 10 72 80 00       	mov    0x807210,%eax
  802d5f:	40                   	inc    %eax
  802d60:	a3 10 72 80 00       	mov    %eax,0x807210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  802d65:	eb 71                	jmp    802dd8 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802d67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6b:	74 06                	je     802d73 <insert_page_alloc+0x10a>
  802d6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d71:	75 14                	jne    802d87 <insert_page_alloc+0x11e>
  802d73:	83 ec 04             	sub    $0x4,%esp
  802d76:	68 04 5d 80 00       	push   $0x805d04
  802d7b:	6a 23                	push   $0x23
  802d7d:	68 d1 5c 80 00       	push   $0x805cd1
  802d82:	e8 0f ed ff ff       	call   801a96 <_panic>
  802d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8a:	8b 50 08             	mov    0x8(%eax),%edx
  802d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d90:	89 50 08             	mov    %edx,0x8(%eax)
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	8b 40 08             	mov    0x8(%eax),%eax
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 0c                	je     802da9 <insert_page_alloc+0x140>
  802d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da0:	8b 40 08             	mov    0x8(%eax),%eax
  802da3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da6:	89 50 0c             	mov    %edx,0xc(%eax)
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802daf:	89 50 08             	mov    %edx,0x8(%eax)
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db8:	89 50 0c             	mov    %edx,0xc(%eax)
  802dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbe:	8b 40 08             	mov    0x8(%eax),%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	75 08                	jne    802dcd <insert_page_alloc+0x164>
  802dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc8:	a3 08 72 80 00       	mov    %eax,0x807208
  802dcd:	a1 10 72 80 00       	mov    0x807210,%eax
  802dd2:	40                   	inc    %eax
  802dd3:	a3 10 72 80 00       	mov    %eax,0x807210
}
  802dd8:	90                   	nop
  802dd9:	c9                   	leave  
  802dda:	c3                   	ret    

00802ddb <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
  802dde:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  802de1:	a1 04 72 80 00       	mov    0x807204,%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	75 0c                	jne    802df6 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  802dea:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802def:	a3 50 f2 81 00       	mov    %eax,0x81f250
		return;
  802df4:	eb 67                	jmp    802e5d <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  802df6:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802dfe:	a1 04 72 80 00       	mov    0x807204,%eax
  802e03:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802e06:	eb 26                	jmp    802e2e <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  802e08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e0b:	8b 10                	mov    (%eax),%edx
  802e0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e10:	8b 40 04             	mov    0x4(%eax),%eax
  802e13:	01 d0                	add    %edx,%eax
  802e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802e1e:	76 06                	jbe    802e26 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802e26:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802e2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802e2e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802e32:	74 08                	je     802e3c <recompute_page_alloc_break+0x61>
  802e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e37:	8b 40 08             	mov    0x8(%eax),%eax
  802e3a:	eb 05                	jmp    802e41 <recompute_page_alloc_break+0x66>
  802e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e41:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802e46:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	75 b9                	jne    802e08 <recompute_page_alloc_break+0x2d>
  802e4f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802e53:	75 b3                	jne    802e08 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  802e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e58:	a3 50 f2 81 00       	mov    %eax,0x81f250
}
  802e5d:	c9                   	leave  
  802e5e:	c3                   	ret    

00802e5f <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
  802e62:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  802e65:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e72:	01 d0                	add    %edx,%eax
  802e74:	48                   	dec    %eax
  802e75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e80:	f7 75 d8             	divl   -0x28(%ebp)
  802e83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e86:	29 d0                	sub    %edx,%eax
  802e88:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  802e8b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802e8f:	75 0a                	jne    802e9b <alloc_pages_custom_fit+0x3c>
		return NULL;
  802e91:	b8 00 00 00 00       	mov    $0x0,%eax
  802e96:	e9 7e 01 00 00       	jmp    803019 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  802e9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  802ea2:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802ea6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  802ead:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  802eb4:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802eb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802ebc:	a1 04 72 80 00       	mov    0x807204,%eax
  802ec1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802ec4:	eb 69                	jmp    802f2f <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ece:	76 47                	jbe    802f17 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  802ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  802ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ede:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  802ee1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ee4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802ee7:	72 2e                	jb     802f17 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  802ee9:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802eed:	75 14                	jne    802f03 <alloc_pages_custom_fit+0xa4>
  802eef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ef2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802ef5:	75 0c                	jne    802f03 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  802ef7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  802efd:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802f01:	eb 14                	jmp    802f17 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802f03:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f06:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f09:	76 0c                	jbe    802f17 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802f0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  802f11:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f14:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1a:	8b 10                	mov    (%eax),%edx
  802f1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1f:	8b 40 04             	mov    0x4(%eax),%eax
  802f22:	01 d0                	add    %edx,%eax
  802f24:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802f27:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802f2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802f2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f33:	74 08                	je     802f3d <alloc_pages_custom_fit+0xde>
  802f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f38:	8b 40 08             	mov    0x8(%eax),%eax
  802f3b:	eb 05                	jmp    802f42 <alloc_pages_custom_fit+0xe3>
  802f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f42:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802f47:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	0f 85 72 ff ff ff    	jne    802ec6 <alloc_pages_custom_fit+0x67>
  802f54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f58:	0f 85 68 ff ff ff    	jne    802ec6 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802f5e:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802f63:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f66:	76 47                	jbe    802faf <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802f6e:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802f73:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802f76:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802f79:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f7c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802f7f:	72 2e                	jb     802faf <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802f81:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802f85:	75 14                	jne    802f9b <alloc_pages_custom_fit+0x13c>
  802f87:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f8a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802f8d:	75 0c                	jne    802f9b <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802f8f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802f95:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802f99:	eb 14                	jmp    802faf <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802f9b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f9e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fa1:	76 0c                	jbe    802faf <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802fa3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802fa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fac:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802faf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802fb6:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802fba:	74 08                	je     802fc4 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fc2:	eb 40                	jmp    803004 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802fc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fc8:	74 08                	je     802fd2 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fd0:	eb 32                	jmp    803004 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802fd2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802fd7:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802fda:	89 c2                	mov    %eax,%edx
  802fdc:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802fe1:	39 c2                	cmp    %eax,%edx
  802fe3:	73 07                	jae    802fec <alloc_pages_custom_fit+0x18d>
			return NULL;
  802fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  802fea:	eb 2d                	jmp    803019 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802fec:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802ff1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802ff4:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802ffa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ffd:	01 d0                	add    %edx,%eax
  802fff:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}


	insert_page_alloc((uint32)result, required_size);
  803004:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803007:	83 ec 08             	sub    $0x8,%esp
  80300a:	ff 75 d0             	pushl  -0x30(%ebp)
  80300d:	50                   	push   %eax
  80300e:	e8 56 fc ff ff       	call   802c69 <insert_page_alloc>
  803013:	83 c4 10             	add    $0x10,%esp

	return result;
  803016:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  803027:	a1 04 72 80 00       	mov    0x807204,%eax
  80302c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80302f:	eb 1a                	jmp    80304b <find_allocated_size+0x30>
		if (it->start == va)
  803031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803039:	75 08                	jne    803043 <find_allocated_size+0x28>
			return it->size;
  80303b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80303e:	8b 40 04             	mov    0x4(%eax),%eax
  803041:	eb 34                	jmp    803077 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  803043:	a1 0c 72 80 00       	mov    0x80720c,%eax
  803048:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80304b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80304f:	74 08                	je     803059 <find_allocated_size+0x3e>
  803051:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803054:	8b 40 08             	mov    0x8(%eax),%eax
  803057:	eb 05                	jmp    80305e <find_allocated_size+0x43>
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	a3 0c 72 80 00       	mov    %eax,0x80720c
  803063:	a1 0c 72 80 00       	mov    0x80720c,%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	75 c5                	jne    803031 <find_allocated_size+0x16>
  80306c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803070:	75 bf                	jne    803031 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  803072:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803077:	c9                   	leave  
  803078:	c3                   	ret    

00803079 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  803079:	55                   	push   %ebp
  80307a:	89 e5                	mov    %esp,%ebp
  80307c:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  803085:	a1 04 72 80 00       	mov    0x807204,%eax
  80308a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80308d:	e9 e1 01 00 00       	jmp    803273 <free_pages+0x1fa>
		if (it->start == va) {
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80309a:	0f 85 cb 01 00 00    	jne    80326b <free_pages+0x1f2>

			uint32 start = it->start;
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 40 04             	mov    0x4(%eax),%eax
  8030ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  8030b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b4:	f7 d0                	not    %eax
  8030b6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030b9:	73 1d                	jae    8030d8 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  8030bb:	83 ec 0c             	sub    $0xc,%esp
  8030be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8030c4:	68 38 5d 80 00       	push   $0x805d38
  8030c9:	68 a5 00 00 00       	push   $0xa5
  8030ce:	68 d1 5c 80 00       	push   $0x805cd1
  8030d3:	e8 be e9 ff ff       	call   801a96 <_panic>
			}

			uint32 start_end = start + size;
  8030d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030de:	01 d0                	add    %edx,%eax
  8030e0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  8030e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	79 19                	jns    803103 <free_pages+0x8a>
  8030ea:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8030f1:	77 10                	ja     803103 <free_pages+0x8a>
  8030f3:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  8030fa:	77 07                	ja     803103 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  8030fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	78 2c                	js     80312f <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	83 ec 0c             	sub    $0xc,%esp
  803109:	68 00 00 00 a0       	push   $0xa0000000
  80310e:	ff 75 e0             	pushl  -0x20(%ebp)
  803111:	ff 75 e4             	pushl  -0x1c(%ebp)
  803114:	ff 75 e8             	pushl  -0x18(%ebp)
  803117:	ff 75 e4             	pushl  -0x1c(%ebp)
  80311a:	50                   	push   %eax
  80311b:	68 7c 5d 80 00       	push   $0x805d7c
  803120:	68 ad 00 00 00       	push   $0xad
  803125:	68 d1 5c 80 00       	push   $0x805cd1
  80312a:	e8 67 e9 ff ff       	call   801a96 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803135:	e9 88 00 00 00       	jmp    8031c2 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  80313a:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  803141:	76 17                	jbe    80315a <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  803143:	ff 75 f0             	pushl  -0x10(%ebp)
  803146:	68 e0 5d 80 00       	push   $0x805de0
  80314b:	68 b4 00 00 00       	push   $0xb4
  803150:	68 d1 5c 80 00       	push   $0x805cd1
  803155:	e8 3c e9 ff ff       	call   801a96 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  80315a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315d:	05 00 10 00 00       	add    $0x1000,%eax
  803162:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  803165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	79 2e                	jns    80319a <free_pages+0x121>
  80316c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  803173:	77 25                	ja     80319a <free_pages+0x121>
  803175:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  80317c:	77 1c                	ja     80319a <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  80317e:	83 ec 08             	sub    $0x8,%esp
  803181:	68 00 10 00 00       	push   $0x1000
  803186:	ff 75 f0             	pushl  -0x10(%ebp)
  803189:	e8 38 0d 00 00       	call   803ec6 <sys_free_user_mem>
  80318e:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  803191:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  803198:	eb 28                	jmp    8031c2 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	68 00 00 00 a0       	push   $0xa0000000
  8031a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8031a5:	68 00 10 00 00       	push   $0x1000
  8031aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ad:	50                   	push   %eax
  8031ae:	68 20 5e 80 00       	push   $0x805e20
  8031b3:	68 bd 00 00 00       	push   $0xbd
  8031b8:	68 d1 5c 80 00       	push   $0x805cd1
  8031bd:	e8 d4 e8 ff ff       	call   801a96 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8031c8:	0f 82 6c ff ff ff    	jb     80313a <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  8031ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d2:	75 17                	jne    8031eb <free_pages+0x172>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 82 5e 80 00       	push   $0x805e82
  8031dc:	68 c1 00 00 00       	push   $0xc1
  8031e1:	68 d1 5c 80 00       	push   $0x805cd1
  8031e6:	e8 ab e8 ff ff       	call   801a96 <_panic>
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	8b 40 08             	mov    0x8(%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 11                	je     803206 <free_pages+0x18d>
  8031f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f8:	8b 40 08             	mov    0x8(%eax),%eax
  8031fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031fe:	8b 52 0c             	mov    0xc(%edx),%edx
  803201:	89 50 0c             	mov    %edx,0xc(%eax)
  803204:	eb 0b                	jmp    803211 <free_pages+0x198>
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 40 0c             	mov    0xc(%eax),%eax
  80320c:	a3 08 72 80 00       	mov    %eax,0x807208
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 40 0c             	mov    0xc(%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 11                	je     80322c <free_pages+0x1b3>
  80321b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321e:	8b 40 0c             	mov    0xc(%eax),%eax
  803221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803224:	8b 52 08             	mov    0x8(%edx),%edx
  803227:	89 50 08             	mov    %edx,0x8(%eax)
  80322a:	eb 0b                	jmp    803237 <free_pages+0x1be>
  80322c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322f:	8b 40 08             	mov    0x8(%eax),%eax
  803232:	a3 04 72 80 00       	mov    %eax,0x807204
  803237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80324b:	a1 10 72 80 00       	mov    0x807210,%eax
  803250:	48                   	dec    %eax
  803251:	a3 10 72 80 00       	mov    %eax,0x807210
			free_block(it);
  803256:	83 ec 0c             	sub    $0xc,%esp
  803259:	ff 75 f4             	pushl  -0xc(%ebp)
  80325c:	e8 24 15 00 00       	call   804785 <free_block>
  803261:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  803264:	e8 72 fb ff ff       	call   802ddb <recompute_page_alloc_break>

			return;
  803269:	eb 37                	jmp    8032a2 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80326b:	a1 0c 72 80 00       	mov    0x80720c,%eax
  803270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803273:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803277:	74 08                	je     803281 <free_pages+0x208>
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 40 08             	mov    0x8(%eax),%eax
  80327f:	eb 05                	jmp    803286 <free_pages+0x20d>
  803281:	b8 00 00 00 00       	mov    $0x0,%eax
  803286:	a3 0c 72 80 00       	mov    %eax,0x80720c
  80328b:	a1 0c 72 80 00       	mov    0x80720c,%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	0f 85 fa fd ff ff    	jne    803092 <free_pages+0x19>
  803298:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329c:	0f 85 f0 fd ff ff    	jne    803092 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  8032a2:	c9                   	leave  
  8032a3:	c3                   	ret    

008032a4 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  8032a4:	55                   	push   %ebp
  8032a5:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  8032a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ac:	5d                   	pop    %ebp
  8032ad:	c3                   	ret    

008032ae <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8032ae:	55                   	push   %ebp
  8032af:	89 e5                	mov    %esp,%ebp
  8032b1:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8032b4:	a1 08 70 80 00       	mov    0x807008,%eax
  8032b9:	85 c0                	test   %eax,%eax
  8032bb:	74 60                	je     80331d <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8032bd:	83 ec 08             	sub    $0x8,%esp
  8032c0:	68 00 00 00 82       	push   $0x82000000
  8032c5:	68 00 00 00 80       	push   $0x80000000
  8032ca:	e8 0d 0d 00 00       	call   803fdc <initialize_dynamic_allocator>
  8032cf:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8032d2:	e8 f3 0a 00 00       	call   803dca <sys_get_uheap_strategy>
  8032d7:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8032dc:	a1 20 72 80 00       	mov    0x807220,%eax
  8032e1:	05 00 10 00 00       	add    $0x1000,%eax
  8032e6:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  8032eb:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8032f0:	a3 50 f2 81 00       	mov    %eax,0x81f250

		LIST_INIT(&page_alloc_list);
  8032f5:	c7 05 04 72 80 00 00 	movl   $0x0,0x807204
  8032fc:	00 00 00 
  8032ff:	c7 05 08 72 80 00 00 	movl   $0x0,0x807208
  803306:	00 00 00 
  803309:	c7 05 10 72 80 00 00 	movl   $0x0,0x807210
  803310:	00 00 00 

		__firstTimeFlag = 0;
  803313:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  80331a:	00 00 00 
	}
}
  80331d:	90                   	nop
  80331e:	c9                   	leave  
  80331f:	c3                   	ret    

00803320 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
  803323:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803334:	83 ec 08             	sub    $0x8,%esp
  803337:	68 06 04 00 00       	push   $0x406
  80333c:	50                   	push   %eax
  80333d:	e8 d2 06 00 00       	call   803a14 <__sys_allocate_page>
  803342:	83 c4 10             	add    $0x10,%esp
  803345:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  803348:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80334c:	79 17                	jns    803365 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  80334e:	83 ec 04             	sub    $0x4,%esp
  803351:	68 a0 5e 80 00       	push   $0x805ea0
  803356:	68 ea 00 00 00       	push   $0xea
  80335b:	68 d1 5c 80 00       	push   $0x805cd1
  803360:	e8 31 e7 ff ff       	call   801a96 <_panic>
	return 0;
  803365:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80336a:	c9                   	leave  
  80336b:	c3                   	ret    

0080336c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80336c:	55                   	push   %ebp
  80336d:	89 e5                	mov    %esp,%ebp
  80336f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803380:	83 ec 0c             	sub    $0xc,%esp
  803383:	50                   	push   %eax
  803384:	e8 d2 06 00 00       	call   803a5b <__sys_unmap_frame>
  803389:	83 c4 10             	add    $0x10,%esp
  80338c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80338f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803393:	79 17                	jns    8033ac <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  803395:	83 ec 04             	sub    $0x4,%esp
  803398:	68 dc 5e 80 00       	push   $0x805edc
  80339d:	68 f5 00 00 00       	push   $0xf5
  8033a2:	68 d1 5c 80 00       	push   $0x805cd1
  8033a7:	e8 ea e6 ff ff       	call   801a96 <_panic>
}
  8033ac:	90                   	nop
  8033ad:	c9                   	leave  
  8033ae:	c3                   	ret    

008033af <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
  8033b2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8033b5:	e8 f4 fe ff ff       	call   8032ae <uheap_init>
	if (size == 0) return NULL ;
  8033ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033be:	75 0a                	jne    8033ca <malloc+0x1b>
  8033c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c5:	e9 67 01 00 00       	jmp    803531 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8033ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8033d1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8033d8:	77 16                	ja     8033f0 <malloc+0x41>
		result = alloc_block(size);
  8033da:	83 ec 0c             	sub    $0xc,%esp
  8033dd:	ff 75 08             	pushl  0x8(%ebp)
  8033e0:	e8 46 0e 00 00       	call   80422b <alloc_block>
  8033e5:	83 c4 10             	add    $0x10,%esp
  8033e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033eb:	e9 3e 01 00 00       	jmp    80352e <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  8033f0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8033f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fd:	01 d0                	add    %edx,%eax
  8033ff:	48                   	dec    %eax
  803400:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803406:	ba 00 00 00 00       	mov    $0x0,%edx
  80340b:	f7 75 f0             	divl   -0x10(%ebp)
  80340e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803411:	29 d0                	sub    %edx,%eax
  803413:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  803416:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	75 0a                	jne    803429 <malloc+0x7a>
			return NULL;
  80341f:	b8 00 00 00 00       	mov    $0x0,%eax
  803424:	e9 08 01 00 00       	jmp    803531 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  803429:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80342e:	85 c0                	test   %eax,%eax
  803430:	74 0f                	je     803441 <malloc+0x92>
  803432:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803438:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80343d:	39 c2                	cmp    %eax,%edx
  80343f:	73 0a                	jae    80344b <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  803441:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803446:	a3 50 f2 81 00       	mov    %eax,0x81f250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80344b:	a1 44 f2 81 00       	mov    0x81f244,%eax
  803450:	83 f8 05             	cmp    $0x5,%eax
  803453:	75 11                	jne    803466 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  803455:	83 ec 0c             	sub    $0xc,%esp
  803458:	ff 75 e8             	pushl  -0x18(%ebp)
  80345b:	e8 ff f9 ff ff       	call   802e5f <alloc_pages_custom_fit>
  803460:	83 c4 10             	add    $0x10,%esp
  803463:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  803466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346a:	0f 84 be 00 00 00    	je     80352e <malloc+0x17f>
			uint32 result_va = (uint32)result;
  803470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  803476:	83 ec 0c             	sub    $0xc,%esp
  803479:	ff 75 f4             	pushl  -0xc(%ebp)
  80347c:	e8 9a fb ff ff       	call   80301b <find_allocated_size>
  803481:	83 c4 10             	add    $0x10,%esp
  803484:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  803487:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80348b:	75 17                	jne    8034a4 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  80348d:	ff 75 f4             	pushl  -0xc(%ebp)
  803490:	68 1c 5f 80 00       	push   $0x805f1c
  803495:	68 24 01 00 00       	push   $0x124
  80349a:	68 d1 5c 80 00       	push   $0x805cd1
  80349f:	e8 f2 e5 ff ff       	call   801a96 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8034a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a7:	f7 d0                	not    %eax
  8034a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034ac:	73 1d                	jae    8034cb <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8034ae:	83 ec 0c             	sub    $0xc,%esp
  8034b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8034b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b7:	68 64 5f 80 00       	push   $0x805f64
  8034bc:	68 29 01 00 00       	push   $0x129
  8034c1:	68 d1 5c 80 00       	push   $0x805cd1
  8034c6:	e8 cb e5 ff ff       	call   801a96 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8034cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d1:	01 d0                	add    %edx,%eax
  8034d3:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8034d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d9:	85 c0                	test   %eax,%eax
  8034db:	79 2c                	jns    803509 <malloc+0x15a>
  8034dd:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  8034e4:	77 23                	ja     803509 <malloc+0x15a>
  8034e6:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8034ed:	77 1a                	ja     803509 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  8034ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	79 13                	jns    803509 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  8034f6:	83 ec 08             	sub    $0x8,%esp
  8034f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8034fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034ff:	e8 de 09 00 00       	call   803ee2 <sys_allocate_user_mem>
  803504:	83 c4 10             	add    $0x10,%esp
  803507:	eb 25                	jmp    80352e <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  803509:	68 00 00 00 a0       	push   $0xa0000000
  80350e:	ff 75 dc             	pushl  -0x24(%ebp)
  803511:	ff 75 e0             	pushl  -0x20(%ebp)
  803514:	ff 75 e4             	pushl  -0x1c(%ebp)
  803517:	ff 75 f4             	pushl  -0xc(%ebp)
  80351a:	68 a0 5f 80 00       	push   $0x805fa0
  80351f:	68 33 01 00 00       	push   $0x133
  803524:	68 d1 5c 80 00       	push   $0x805cd1
  803529:	e8 68 e5 ff ff       	call   801a96 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  803531:	c9                   	leave  
  803532:	c3                   	ret    

00803533 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  803533:	55                   	push   %ebp
  803534:	89 e5                	mov    %esp,%ebp
  803536:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803539:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353d:	0f 84 26 01 00 00    	je     803669 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	85 c0                	test   %eax,%eax
  80354e:	79 1c                	jns    80356c <free+0x39>
  803550:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  803557:	77 13                	ja     80356c <free+0x39>
		free_block(virtual_address);
  803559:	83 ec 0c             	sub    $0xc,%esp
  80355c:	ff 75 08             	pushl  0x8(%ebp)
  80355f:	e8 21 12 00 00       	call   804785 <free_block>
  803564:	83 c4 10             	add    $0x10,%esp
		return;
  803567:	e9 01 01 00 00       	jmp    80366d <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  80356c:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803571:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  803574:	0f 82 d8 00 00 00    	jb     803652 <free+0x11f>
  80357a:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  803581:	0f 87 cb 00 00 00    	ja     803652 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  803587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	74 17                	je     8035aa <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  803593:	ff 75 08             	pushl  0x8(%ebp)
  803596:	68 10 60 80 00       	push   $0x806010
  80359b:	68 57 01 00 00       	push   $0x157
  8035a0:	68 d1 5c 80 00       	push   $0x805cd1
  8035a5:	e8 ec e4 ff ff       	call   801a96 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8035aa:	83 ec 0c             	sub    $0xc,%esp
  8035ad:	ff 75 08             	pushl  0x8(%ebp)
  8035b0:	e8 66 fa ff ff       	call   80301b <find_allocated_size>
  8035b5:	83 c4 10             	add    $0x10,%esp
  8035b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8035bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035bf:	0f 84 a7 00 00 00    	je     80366c <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	f7 d0                	not    %eax
  8035ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035cd:	73 1d                	jae    8035ec <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8035cf:	83 ec 0c             	sub    $0xc,%esp
  8035d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8035d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8035d8:	68 38 60 80 00       	push   $0x806038
  8035dd:	68 61 01 00 00       	push   $0x161
  8035e2:	68 d1 5c 80 00       	push   $0x805cd1
  8035e7:	e8 aa e4 ff ff       	call   801a96 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8035ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f2:	01 d0                	add    %edx,%eax
  8035f4:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	85 c0                	test   %eax,%eax
  8035fc:	79 19                	jns    803617 <free+0xe4>
  8035fe:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  803605:	77 10                	ja     803617 <free+0xe4>
  803607:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80360e:	77 07                	ja     803617 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  803610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	78 2b                	js     803642 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  803617:	83 ec 0c             	sub    $0xc,%esp
  80361a:	68 00 00 00 a0       	push   $0xa0000000
  80361f:	ff 75 ec             	pushl  -0x14(%ebp)
  803622:	ff 75 f0             	pushl  -0x10(%ebp)
  803625:	ff 75 f4             	pushl  -0xc(%ebp)
  803628:	ff 75 f0             	pushl  -0x10(%ebp)
  80362b:	ff 75 08             	pushl  0x8(%ebp)
  80362e:	68 74 60 80 00       	push   $0x806074
  803633:	68 69 01 00 00       	push   $0x169
  803638:	68 d1 5c 80 00       	push   $0x805cd1
  80363d:	e8 54 e4 ff ff       	call   801a96 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  803642:	83 ec 0c             	sub    $0xc,%esp
  803645:	ff 75 08             	pushl  0x8(%ebp)
  803648:	e8 2c fa ff ff       	call   803079 <free_pages>
  80364d:	83 c4 10             	add    $0x10,%esp
		return;
  803650:	eb 1b                	jmp    80366d <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  803652:	ff 75 08             	pushl  0x8(%ebp)
  803655:	68 d0 60 80 00       	push   $0x8060d0
  80365a:	68 70 01 00 00       	push   $0x170
  80365f:	68 d1 5c 80 00       	push   $0x805cd1
  803664:	e8 2d e4 ff ff       	call   801a96 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803669:	90                   	nop
  80366a:	eb 01                	jmp    80366d <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80366c:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  80366d:	c9                   	leave  
  80366e:	c3                   	ret    

0080366f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80366f:	55                   	push   %ebp
  803670:	89 e5                	mov    %esp,%ebp
  803672:	83 ec 38             	sub    $0x38,%esp
  803675:	8b 45 10             	mov    0x10(%ebp),%eax
  803678:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80367b:	e8 2e fc ff ff       	call   8032ae <uheap_init>
	if (size == 0) return NULL ;
  803680:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803684:	75 0a                	jne    803690 <smalloc+0x21>
  803686:	b8 00 00 00 00       	mov    $0x0,%eax
  80368b:	e9 3d 01 00 00       	jmp    8037cd <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  803690:	8b 45 0c             	mov    0xc(%ebp),%eax
  803693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  803696:	8b 45 0c             	mov    0xc(%ebp),%eax
  803699:	25 ff 0f 00 00       	and    $0xfff,%eax
  80369e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8036a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036a5:	74 0e                	je     8036b5 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8036a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036aa:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8036ad:	05 00 10 00 00       	add    $0x1000,%eax
  8036b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	c1 e8 0c             	shr    $0xc,%eax
  8036bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8036be:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	75 0a                	jne    8036d1 <smalloc+0x62>
		return NULL;
  8036c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cc:	e9 fc 00 00 00       	jmp    8037cd <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8036d1:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8036d6:	85 c0                	test   %eax,%eax
  8036d8:	74 0f                	je     8036e9 <smalloc+0x7a>
  8036da:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8036e0:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8036e5:	39 c2                	cmp    %eax,%edx
  8036e7:	73 0a                	jae    8036f3 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8036e9:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8036ee:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8036f3:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8036f8:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8036fd:	29 c2                	sub    %eax,%edx
  8036ff:	89 d0                	mov    %edx,%eax
  803701:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803704:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80370a:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80370f:	29 c2                	sub    %eax,%edx
  803711:	89 d0                	mov    %edx,%eax
  803713:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80371c:	77 13                	ja     803731 <smalloc+0xc2>
  80371e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803721:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803724:	77 0b                	ja     803731 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  803726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803729:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80372c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80372f:	73 0a                	jae    80373b <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  803731:	b8 00 00 00 00       	mov    $0x0,%eax
  803736:	e9 92 00 00 00       	jmp    8037cd <smalloc+0x15e>
	}

	void *va = NULL;
  80373b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  803742:	a1 44 f2 81 00       	mov    0x81f244,%eax
  803747:	83 f8 05             	cmp    $0x5,%eax
  80374a:	75 11                	jne    80375d <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80374c:	83 ec 0c             	sub    $0xc,%esp
  80374f:	ff 75 f4             	pushl  -0xc(%ebp)
  803752:	e8 08 f7 ff ff       	call   802e5f <alloc_pages_custom_fit>
  803757:	83 c4 10             	add    $0x10,%esp
  80375a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80375d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803761:	75 27                	jne    80378a <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803763:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80376a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803770:	89 c2                	mov    %eax,%edx
  803772:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803777:	39 c2                	cmp    %eax,%edx
  803779:	73 07                	jae    803782 <smalloc+0x113>
			return NULL;}
  80377b:	b8 00 00 00 00       	mov    $0x0,%eax
  803780:	eb 4b                	jmp    8037cd <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  803782:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803787:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80378a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80378e:	ff 75 f0             	pushl  -0x10(%ebp)
  803791:	50                   	push   %eax
  803792:	ff 75 0c             	pushl  0xc(%ebp)
  803795:	ff 75 08             	pushl  0x8(%ebp)
  803798:	e8 cb 03 00 00       	call   803b68 <sys_create_shared_object>
  80379d:	83 c4 10             	add    $0x10,%esp
  8037a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8037a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8037a7:	79 07                	jns    8037b0 <smalloc+0x141>
		return NULL;
  8037a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ae:	eb 1d                	jmp    8037cd <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8037b0:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8037b5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8037b8:	75 10                	jne    8037ca <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8037ba:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	01 d0                	add    %edx,%eax
  8037c5:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}

	return va;
  8037ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8037cd:	c9                   	leave  
  8037ce:	c3                   	ret    

008037cf <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8037cf:	55                   	push   %ebp
  8037d0:	89 e5                	mov    %esp,%ebp
  8037d2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8037d5:	e8 d4 fa ff ff       	call   8032ae <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8037da:	83 ec 08             	sub    $0x8,%esp
  8037dd:	ff 75 0c             	pushl  0xc(%ebp)
  8037e0:	ff 75 08             	pushl  0x8(%ebp)
  8037e3:	e8 aa 03 00 00       	call   803b92 <sys_size_of_shared_object>
  8037e8:	83 c4 10             	add    $0x10,%esp
  8037eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8037ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037f2:	7f 0a                	jg     8037fe <sget+0x2f>
		return NULL;
  8037f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f9:	e9 32 01 00 00       	jmp    803930 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8037fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803801:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  803804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803807:	25 ff 0f 00 00       	and    $0xfff,%eax
  80380c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80380f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803813:	74 0e                	je     803823 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  803815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803818:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80381b:	05 00 10 00 00       	add    $0x1000,%eax
  803820:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  803823:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803828:	85 c0                	test   %eax,%eax
  80382a:	75 0a                	jne    803836 <sget+0x67>
		return NULL;
  80382c:	b8 00 00 00 00       	mov    $0x0,%eax
  803831:	e9 fa 00 00 00       	jmp    803930 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  803836:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 0f                	je     80384e <sget+0x7f>
  80383f:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803845:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80384a:	39 c2                	cmp    %eax,%edx
  80384c:	73 0a                	jae    803858 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80384e:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803853:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803858:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80385d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803862:	29 c2                	sub    %eax,%edx
  803864:	89 d0                	mov    %edx,%eax
  803866:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803869:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80386f:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803874:	29 c2                	sub    %eax,%edx
  803876:	89 d0                	mov    %edx,%eax
  803878:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803881:	77 13                	ja     803896 <sget+0xc7>
  803883:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803886:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803889:	77 0b                	ja     803896 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388e:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  803891:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803894:	73 0a                	jae    8038a0 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  803896:	b8 00 00 00 00       	mov    $0x0,%eax
  80389b:	e9 90 00 00 00       	jmp    803930 <sget+0x161>

	void *va = NULL;
  8038a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8038a7:	a1 44 f2 81 00       	mov    0x81f244,%eax
  8038ac:	83 f8 05             	cmp    $0x5,%eax
  8038af:	75 11                	jne    8038c2 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8038b1:	83 ec 0c             	sub    $0xc,%esp
  8038b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8038b7:	e8 a3 f5 ff ff       	call   802e5f <alloc_pages_custom_fit>
  8038bc:	83 c4 10             	add    $0x10,%esp
  8038bf:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8038c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038c6:	75 27                	jne    8038ef <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8038c8:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8038cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8038d5:	89 c2                	mov    %eax,%edx
  8038d7:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8038dc:	39 c2                	cmp    %eax,%edx
  8038de:	73 07                	jae    8038e7 <sget+0x118>
			return NULL;
  8038e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e5:	eb 49                	jmp    803930 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8038e7:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8038ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8038ef:	83 ec 04             	sub    $0x4,%esp
  8038f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8038f5:	ff 75 0c             	pushl  0xc(%ebp)
  8038f8:	ff 75 08             	pushl  0x8(%ebp)
  8038fb:	e8 af 02 00 00       	call   803baf <sys_get_shared_object>
  803900:	83 c4 10             	add    $0x10,%esp
  803903:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  803906:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80390a:	79 07                	jns    803913 <sget+0x144>
		return NULL;
  80390c:	b8 00 00 00 00       	mov    $0x0,%eax
  803911:	eb 1d                	jmp    803930 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  803913:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803918:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80391b:	75 10                	jne    80392d <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80391d:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803926:	01 d0                	add    %edx,%eax
  803928:	a3 50 f2 81 00       	mov    %eax,0x81f250

	return va;
  80392d:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  803930:	c9                   	leave  
  803931:	c3                   	ret    

00803932 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803932:	55                   	push   %ebp
  803933:	89 e5                	mov    %esp,%ebp
  803935:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803938:	e8 71 f9 ff ff       	call   8032ae <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80393d:	83 ec 04             	sub    $0x4,%esp
  803940:	68 f4 60 80 00       	push   $0x8060f4
  803945:	68 19 02 00 00       	push   $0x219
  80394a:	68 d1 5c 80 00       	push   $0x805cd1
  80394f:	e8 42 e1 ff ff       	call   801a96 <_panic>

00803954 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803954:	55                   	push   %ebp
  803955:	89 e5                	mov    %esp,%ebp
  803957:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	68 1c 61 80 00       	push   $0x80611c
  803962:	68 2b 02 00 00       	push   $0x22b
  803967:	68 d1 5c 80 00       	push   $0x805cd1
  80396c:	e8 25 e1 ff ff       	call   801a96 <_panic>

00803971 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803971:	55                   	push   %ebp
  803972:	89 e5                	mov    %esp,%ebp
  803974:	57                   	push   %edi
  803975:	56                   	push   %esi
  803976:	53                   	push   %ebx
  803977:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80397a:	8b 45 08             	mov    0x8(%ebp),%eax
  80397d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803980:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803983:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803986:	8b 7d 18             	mov    0x18(%ebp),%edi
  803989:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80398c:	cd 30                	int    $0x30
  80398e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803991:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803994:	83 c4 10             	add    $0x10,%esp
  803997:	5b                   	pop    %ebx
  803998:	5e                   	pop    %esi
  803999:	5f                   	pop    %edi
  80399a:	5d                   	pop    %ebp
  80399b:	c3                   	ret    

0080399c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80399c:	55                   	push   %ebp
  80399d:	89 e5                	mov    %esp,%ebp
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8039a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8039a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8039ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8039af:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b2:	6a 00                	push   $0x0
  8039b4:	51                   	push   %ecx
  8039b5:	52                   	push   %edx
  8039b6:	ff 75 0c             	pushl  0xc(%ebp)
  8039b9:	50                   	push   %eax
  8039ba:	6a 00                	push   $0x0
  8039bc:	e8 b0 ff ff ff       	call   803971 <syscall>
  8039c1:	83 c4 18             	add    $0x18,%esp
}
  8039c4:	90                   	nop
  8039c5:	c9                   	leave  
  8039c6:	c3                   	ret    

008039c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8039c7:	55                   	push   %ebp
  8039c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8039ca:	6a 00                	push   $0x0
  8039cc:	6a 00                	push   $0x0
  8039ce:	6a 00                	push   $0x0
  8039d0:	6a 00                	push   $0x0
  8039d2:	6a 00                	push   $0x0
  8039d4:	6a 02                	push   $0x2
  8039d6:	e8 96 ff ff ff       	call   803971 <syscall>
  8039db:	83 c4 18             	add    $0x18,%esp
}
  8039de:	c9                   	leave  
  8039df:	c3                   	ret    

008039e0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8039e0:	55                   	push   %ebp
  8039e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8039e3:	6a 00                	push   $0x0
  8039e5:	6a 00                	push   $0x0
  8039e7:	6a 00                	push   $0x0
  8039e9:	6a 00                	push   $0x0
  8039eb:	6a 00                	push   $0x0
  8039ed:	6a 03                	push   $0x3
  8039ef:	e8 7d ff ff ff       	call   803971 <syscall>
  8039f4:	83 c4 18             	add    $0x18,%esp
}
  8039f7:	90                   	nop
  8039f8:	c9                   	leave  
  8039f9:	c3                   	ret    

008039fa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8039fd:	6a 00                	push   $0x0
  8039ff:	6a 00                	push   $0x0
  803a01:	6a 00                	push   $0x0
  803a03:	6a 00                	push   $0x0
  803a05:	6a 00                	push   $0x0
  803a07:	6a 04                	push   $0x4
  803a09:	e8 63 ff ff ff       	call   803971 <syscall>
  803a0e:	83 c4 18             	add    $0x18,%esp
}
  803a11:	90                   	nop
  803a12:	c9                   	leave  
  803a13:	c3                   	ret    

00803a14 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803a14:	55                   	push   %ebp
  803a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1d:	6a 00                	push   $0x0
  803a1f:	6a 00                	push   $0x0
  803a21:	6a 00                	push   $0x0
  803a23:	52                   	push   %edx
  803a24:	50                   	push   %eax
  803a25:	6a 08                	push   $0x8
  803a27:	e8 45 ff ff ff       	call   803971 <syscall>
  803a2c:	83 c4 18             	add    $0x18,%esp
}
  803a2f:	c9                   	leave  
  803a30:	c3                   	ret    

00803a31 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803a31:	55                   	push   %ebp
  803a32:	89 e5                	mov    %esp,%ebp
  803a34:	56                   	push   %esi
  803a35:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803a36:	8b 75 18             	mov    0x18(%ebp),%esi
  803a39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803a3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a42:	8b 45 08             	mov    0x8(%ebp),%eax
  803a45:	56                   	push   %esi
  803a46:	53                   	push   %ebx
  803a47:	51                   	push   %ecx
  803a48:	52                   	push   %edx
  803a49:	50                   	push   %eax
  803a4a:	6a 09                	push   $0x9
  803a4c:	e8 20 ff ff ff       	call   803971 <syscall>
  803a51:	83 c4 18             	add    $0x18,%esp
}
  803a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803a57:	5b                   	pop    %ebx
  803a58:	5e                   	pop    %esi
  803a59:	5d                   	pop    %ebp
  803a5a:	c3                   	ret    

00803a5b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803a5b:	55                   	push   %ebp
  803a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803a5e:	6a 00                	push   $0x0
  803a60:	6a 00                	push   $0x0
  803a62:	6a 00                	push   $0x0
  803a64:	6a 00                	push   $0x0
  803a66:	ff 75 08             	pushl  0x8(%ebp)
  803a69:	6a 0a                	push   $0xa
  803a6b:	e8 01 ff ff ff       	call   803971 <syscall>
  803a70:	83 c4 18             	add    $0x18,%esp
}
  803a73:	c9                   	leave  
  803a74:	c3                   	ret    

00803a75 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803a75:	55                   	push   %ebp
  803a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803a78:	6a 00                	push   $0x0
  803a7a:	6a 00                	push   $0x0
  803a7c:	6a 00                	push   $0x0
  803a7e:	ff 75 0c             	pushl  0xc(%ebp)
  803a81:	ff 75 08             	pushl  0x8(%ebp)
  803a84:	6a 0b                	push   $0xb
  803a86:	e8 e6 fe ff ff       	call   803971 <syscall>
  803a8b:	83 c4 18             	add    $0x18,%esp
}
  803a8e:	c9                   	leave  
  803a8f:	c3                   	ret    

00803a90 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803a90:	55                   	push   %ebp
  803a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803a93:	6a 00                	push   $0x0
  803a95:	6a 00                	push   $0x0
  803a97:	6a 00                	push   $0x0
  803a99:	6a 00                	push   $0x0
  803a9b:	6a 00                	push   $0x0
  803a9d:	6a 0c                	push   $0xc
  803a9f:	e8 cd fe ff ff       	call   803971 <syscall>
  803aa4:	83 c4 18             	add    $0x18,%esp
}
  803aa7:	c9                   	leave  
  803aa8:	c3                   	ret    

00803aa9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803aa9:	55                   	push   %ebp
  803aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803aac:	6a 00                	push   $0x0
  803aae:	6a 00                	push   $0x0
  803ab0:	6a 00                	push   $0x0
  803ab2:	6a 00                	push   $0x0
  803ab4:	6a 00                	push   $0x0
  803ab6:	6a 0d                	push   $0xd
  803ab8:	e8 b4 fe ff ff       	call   803971 <syscall>
  803abd:	83 c4 18             	add    $0x18,%esp
}
  803ac0:	c9                   	leave  
  803ac1:	c3                   	ret    

00803ac2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803ac2:	55                   	push   %ebp
  803ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803ac5:	6a 00                	push   $0x0
  803ac7:	6a 00                	push   $0x0
  803ac9:	6a 00                	push   $0x0
  803acb:	6a 00                	push   $0x0
  803acd:	6a 00                	push   $0x0
  803acf:	6a 0e                	push   $0xe
  803ad1:	e8 9b fe ff ff       	call   803971 <syscall>
  803ad6:	83 c4 18             	add    $0x18,%esp
}
  803ad9:	c9                   	leave  
  803ada:	c3                   	ret    

00803adb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803adb:	55                   	push   %ebp
  803adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803ade:	6a 00                	push   $0x0
  803ae0:	6a 00                	push   $0x0
  803ae2:	6a 00                	push   $0x0
  803ae4:	6a 00                	push   $0x0
  803ae6:	6a 00                	push   $0x0
  803ae8:	6a 0f                	push   $0xf
  803aea:	e8 82 fe ff ff       	call   803971 <syscall>
  803aef:	83 c4 18             	add    $0x18,%esp
}
  803af2:	c9                   	leave  
  803af3:	c3                   	ret    

00803af4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803af4:	55                   	push   %ebp
  803af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803af7:	6a 00                	push   $0x0
  803af9:	6a 00                	push   $0x0
  803afb:	6a 00                	push   $0x0
  803afd:	6a 00                	push   $0x0
  803aff:	ff 75 08             	pushl  0x8(%ebp)
  803b02:	6a 10                	push   $0x10
  803b04:	e8 68 fe ff ff       	call   803971 <syscall>
  803b09:	83 c4 18             	add    $0x18,%esp
}
  803b0c:	c9                   	leave  
  803b0d:	c3                   	ret    

00803b0e <sys_scarce_memory>:

void sys_scarce_memory()
{
  803b0e:	55                   	push   %ebp
  803b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803b11:	6a 00                	push   $0x0
  803b13:	6a 00                	push   $0x0
  803b15:	6a 00                	push   $0x0
  803b17:	6a 00                	push   $0x0
  803b19:	6a 00                	push   $0x0
  803b1b:	6a 11                	push   $0x11
  803b1d:	e8 4f fe ff ff       	call   803971 <syscall>
  803b22:	83 c4 18             	add    $0x18,%esp
}
  803b25:	90                   	nop
  803b26:	c9                   	leave  
  803b27:	c3                   	ret    

00803b28 <sys_cputc>:

void
sys_cputc(const char c)
{
  803b28:	55                   	push   %ebp
  803b29:	89 e5                	mov    %esp,%ebp
  803b2b:	83 ec 04             	sub    $0x4,%esp
  803b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803b34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803b38:	6a 00                	push   $0x0
  803b3a:	6a 00                	push   $0x0
  803b3c:	6a 00                	push   $0x0
  803b3e:	6a 00                	push   $0x0
  803b40:	50                   	push   %eax
  803b41:	6a 01                	push   $0x1
  803b43:	e8 29 fe ff ff       	call   803971 <syscall>
  803b48:	83 c4 18             	add    $0x18,%esp
}
  803b4b:	90                   	nop
  803b4c:	c9                   	leave  
  803b4d:	c3                   	ret    

00803b4e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803b4e:	55                   	push   %ebp
  803b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803b51:	6a 00                	push   $0x0
  803b53:	6a 00                	push   $0x0
  803b55:	6a 00                	push   $0x0
  803b57:	6a 00                	push   $0x0
  803b59:	6a 00                	push   $0x0
  803b5b:	6a 14                	push   $0x14
  803b5d:	e8 0f fe ff ff       	call   803971 <syscall>
  803b62:	83 c4 18             	add    $0x18,%esp
}
  803b65:	90                   	nop
  803b66:	c9                   	leave  
  803b67:	c3                   	ret    

00803b68 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803b68:	55                   	push   %ebp
  803b69:	89 e5                	mov    %esp,%ebp
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  803b71:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803b74:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803b77:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7e:	6a 00                	push   $0x0
  803b80:	51                   	push   %ecx
  803b81:	52                   	push   %edx
  803b82:	ff 75 0c             	pushl  0xc(%ebp)
  803b85:	50                   	push   %eax
  803b86:	6a 15                	push   $0x15
  803b88:	e8 e4 fd ff ff       	call   803971 <syscall>
  803b8d:	83 c4 18             	add    $0x18,%esp
}
  803b90:	c9                   	leave  
  803b91:	c3                   	ret    

00803b92 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803b92:	55                   	push   %ebp
  803b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b98:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9b:	6a 00                	push   $0x0
  803b9d:	6a 00                	push   $0x0
  803b9f:	6a 00                	push   $0x0
  803ba1:	52                   	push   %edx
  803ba2:	50                   	push   %eax
  803ba3:	6a 16                	push   $0x16
  803ba5:	e8 c7 fd ff ff       	call   803971 <syscall>
  803baa:	83 c4 18             	add    $0x18,%esp
}
  803bad:	c9                   	leave  
  803bae:	c3                   	ret    

00803baf <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803baf:	55                   	push   %ebp
  803bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803bb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbb:	6a 00                	push   $0x0
  803bbd:	6a 00                	push   $0x0
  803bbf:	51                   	push   %ecx
  803bc0:	52                   	push   %edx
  803bc1:	50                   	push   %eax
  803bc2:	6a 17                	push   $0x17
  803bc4:	e8 a8 fd ff ff       	call   803971 <syscall>
  803bc9:	83 c4 18             	add    $0x18,%esp
}
  803bcc:	c9                   	leave  
  803bcd:	c3                   	ret    

00803bce <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803bce:	55                   	push   %ebp
  803bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd7:	6a 00                	push   $0x0
  803bd9:	6a 00                	push   $0x0
  803bdb:	6a 00                	push   $0x0
  803bdd:	52                   	push   %edx
  803bde:	50                   	push   %eax
  803bdf:	6a 18                	push   $0x18
  803be1:	e8 8b fd ff ff       	call   803971 <syscall>
  803be6:	83 c4 18             	add    $0x18,%esp
}
  803be9:	c9                   	leave  
  803bea:	c3                   	ret    

00803beb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803beb:	55                   	push   %ebp
  803bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803bee:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf1:	6a 00                	push   $0x0
  803bf3:	ff 75 14             	pushl  0x14(%ebp)
  803bf6:	ff 75 10             	pushl  0x10(%ebp)
  803bf9:	ff 75 0c             	pushl  0xc(%ebp)
  803bfc:	50                   	push   %eax
  803bfd:	6a 19                	push   $0x19
  803bff:	e8 6d fd ff ff       	call   803971 <syscall>
  803c04:	83 c4 18             	add    $0x18,%esp
}
  803c07:	c9                   	leave  
  803c08:	c3                   	ret    

00803c09 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803c09:	55                   	push   %ebp
  803c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0f:	6a 00                	push   $0x0
  803c11:	6a 00                	push   $0x0
  803c13:	6a 00                	push   $0x0
  803c15:	6a 00                	push   $0x0
  803c17:	50                   	push   %eax
  803c18:	6a 1a                	push   $0x1a
  803c1a:	e8 52 fd ff ff       	call   803971 <syscall>
  803c1f:	83 c4 18             	add    $0x18,%esp
}
  803c22:	90                   	nop
  803c23:	c9                   	leave  
  803c24:	c3                   	ret    

00803c25 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803c25:	55                   	push   %ebp
  803c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803c28:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2b:	6a 00                	push   $0x0
  803c2d:	6a 00                	push   $0x0
  803c2f:	6a 00                	push   $0x0
  803c31:	6a 00                	push   $0x0
  803c33:	50                   	push   %eax
  803c34:	6a 1b                	push   $0x1b
  803c36:	e8 36 fd ff ff       	call   803971 <syscall>
  803c3b:	83 c4 18             	add    $0x18,%esp
}
  803c3e:	c9                   	leave  
  803c3f:	c3                   	ret    

00803c40 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803c40:	55                   	push   %ebp
  803c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803c43:	6a 00                	push   $0x0
  803c45:	6a 00                	push   $0x0
  803c47:	6a 00                	push   $0x0
  803c49:	6a 00                	push   $0x0
  803c4b:	6a 00                	push   $0x0
  803c4d:	6a 05                	push   $0x5
  803c4f:	e8 1d fd ff ff       	call   803971 <syscall>
  803c54:	83 c4 18             	add    $0x18,%esp
}
  803c57:	c9                   	leave  
  803c58:	c3                   	ret    

00803c59 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803c59:	55                   	push   %ebp
  803c5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803c5c:	6a 00                	push   $0x0
  803c5e:	6a 00                	push   $0x0
  803c60:	6a 00                	push   $0x0
  803c62:	6a 00                	push   $0x0
  803c64:	6a 00                	push   $0x0
  803c66:	6a 06                	push   $0x6
  803c68:	e8 04 fd ff ff       	call   803971 <syscall>
  803c6d:	83 c4 18             	add    $0x18,%esp
}
  803c70:	c9                   	leave  
  803c71:	c3                   	ret    

00803c72 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803c72:	55                   	push   %ebp
  803c73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803c75:	6a 00                	push   $0x0
  803c77:	6a 00                	push   $0x0
  803c79:	6a 00                	push   $0x0
  803c7b:	6a 00                	push   $0x0
  803c7d:	6a 00                	push   $0x0
  803c7f:	6a 07                	push   $0x7
  803c81:	e8 eb fc ff ff       	call   803971 <syscall>
  803c86:	83 c4 18             	add    $0x18,%esp
}
  803c89:	c9                   	leave  
  803c8a:	c3                   	ret    

00803c8b <sys_exit_env>:


void sys_exit_env(void)
{
  803c8b:	55                   	push   %ebp
  803c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803c8e:	6a 00                	push   $0x0
  803c90:	6a 00                	push   $0x0
  803c92:	6a 00                	push   $0x0
  803c94:	6a 00                	push   $0x0
  803c96:	6a 00                	push   $0x0
  803c98:	6a 1c                	push   $0x1c
  803c9a:	e8 d2 fc ff ff       	call   803971 <syscall>
  803c9f:	83 c4 18             	add    $0x18,%esp
}
  803ca2:	90                   	nop
  803ca3:	c9                   	leave  
  803ca4:	c3                   	ret    

00803ca5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803ca5:	55                   	push   %ebp
  803ca6:	89 e5                	mov    %esp,%ebp
  803ca8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803cab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803cae:	8d 50 04             	lea    0x4(%eax),%edx
  803cb1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803cb4:	6a 00                	push   $0x0
  803cb6:	6a 00                	push   $0x0
  803cb8:	6a 00                	push   $0x0
  803cba:	52                   	push   %edx
  803cbb:	50                   	push   %eax
  803cbc:	6a 1d                	push   $0x1d
  803cbe:	e8 ae fc ff ff       	call   803971 <syscall>
  803cc3:	83 c4 18             	add    $0x18,%esp
	return result;
  803cc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803cc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803ccc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ccf:	89 01                	mov    %eax,(%ecx)
  803cd1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd7:	c9                   	leave  
  803cd8:	c2 04 00             	ret    $0x4

00803cdb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803cdb:	55                   	push   %ebp
  803cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803cde:	6a 00                	push   $0x0
  803ce0:	6a 00                	push   $0x0
  803ce2:	ff 75 10             	pushl  0x10(%ebp)
  803ce5:	ff 75 0c             	pushl  0xc(%ebp)
  803ce8:	ff 75 08             	pushl  0x8(%ebp)
  803ceb:	6a 13                	push   $0x13
  803ced:	e8 7f fc ff ff       	call   803971 <syscall>
  803cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  803cf5:	90                   	nop
}
  803cf6:	c9                   	leave  
  803cf7:	c3                   	ret    

00803cf8 <sys_rcr2>:
uint32 sys_rcr2()
{
  803cf8:	55                   	push   %ebp
  803cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803cfb:	6a 00                	push   $0x0
  803cfd:	6a 00                	push   $0x0
  803cff:	6a 00                	push   $0x0
  803d01:	6a 00                	push   $0x0
  803d03:	6a 00                	push   $0x0
  803d05:	6a 1e                	push   $0x1e
  803d07:	e8 65 fc ff ff       	call   803971 <syscall>
  803d0c:	83 c4 18             	add    $0x18,%esp
}
  803d0f:	c9                   	leave  
  803d10:	c3                   	ret    

00803d11 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803d11:	55                   	push   %ebp
  803d12:	89 e5                	mov    %esp,%ebp
  803d14:	83 ec 04             	sub    $0x4,%esp
  803d17:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803d1d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803d21:	6a 00                	push   $0x0
  803d23:	6a 00                	push   $0x0
  803d25:	6a 00                	push   $0x0
  803d27:	6a 00                	push   $0x0
  803d29:	50                   	push   %eax
  803d2a:	6a 1f                	push   $0x1f
  803d2c:	e8 40 fc ff ff       	call   803971 <syscall>
  803d31:	83 c4 18             	add    $0x18,%esp
	return ;
  803d34:	90                   	nop
}
  803d35:	c9                   	leave  
  803d36:	c3                   	ret    

00803d37 <rsttst>:
void rsttst()
{
  803d37:	55                   	push   %ebp
  803d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803d3a:	6a 00                	push   $0x0
  803d3c:	6a 00                	push   $0x0
  803d3e:	6a 00                	push   $0x0
  803d40:	6a 00                	push   $0x0
  803d42:	6a 00                	push   $0x0
  803d44:	6a 21                	push   $0x21
  803d46:	e8 26 fc ff ff       	call   803971 <syscall>
  803d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  803d4e:	90                   	nop
}
  803d4f:	c9                   	leave  
  803d50:	c3                   	ret    

00803d51 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803d51:	55                   	push   %ebp
  803d52:	89 e5                	mov    %esp,%ebp
  803d54:	83 ec 04             	sub    $0x4,%esp
  803d57:	8b 45 14             	mov    0x14(%ebp),%eax
  803d5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803d5d:	8b 55 18             	mov    0x18(%ebp),%edx
  803d60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803d64:	52                   	push   %edx
  803d65:	50                   	push   %eax
  803d66:	ff 75 10             	pushl  0x10(%ebp)
  803d69:	ff 75 0c             	pushl  0xc(%ebp)
  803d6c:	ff 75 08             	pushl  0x8(%ebp)
  803d6f:	6a 20                	push   $0x20
  803d71:	e8 fb fb ff ff       	call   803971 <syscall>
  803d76:	83 c4 18             	add    $0x18,%esp
	return ;
  803d79:	90                   	nop
}
  803d7a:	c9                   	leave  
  803d7b:	c3                   	ret    

00803d7c <chktst>:
void chktst(uint32 n)
{
  803d7c:	55                   	push   %ebp
  803d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803d7f:	6a 00                	push   $0x0
  803d81:	6a 00                	push   $0x0
  803d83:	6a 00                	push   $0x0
  803d85:	6a 00                	push   $0x0
  803d87:	ff 75 08             	pushl  0x8(%ebp)
  803d8a:	6a 22                	push   $0x22
  803d8c:	e8 e0 fb ff ff       	call   803971 <syscall>
  803d91:	83 c4 18             	add    $0x18,%esp
	return ;
  803d94:	90                   	nop
}
  803d95:	c9                   	leave  
  803d96:	c3                   	ret    

00803d97 <inctst>:

void inctst()
{
  803d97:	55                   	push   %ebp
  803d98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803d9a:	6a 00                	push   $0x0
  803d9c:	6a 00                	push   $0x0
  803d9e:	6a 00                	push   $0x0
  803da0:	6a 00                	push   $0x0
  803da2:	6a 00                	push   $0x0
  803da4:	6a 23                	push   $0x23
  803da6:	e8 c6 fb ff ff       	call   803971 <syscall>
  803dab:	83 c4 18             	add    $0x18,%esp
	return ;
  803dae:	90                   	nop
}
  803daf:	c9                   	leave  
  803db0:	c3                   	ret    

00803db1 <gettst>:
uint32 gettst()
{
  803db1:	55                   	push   %ebp
  803db2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803db4:	6a 00                	push   $0x0
  803db6:	6a 00                	push   $0x0
  803db8:	6a 00                	push   $0x0
  803dba:	6a 00                	push   $0x0
  803dbc:	6a 00                	push   $0x0
  803dbe:	6a 24                	push   $0x24
  803dc0:	e8 ac fb ff ff       	call   803971 <syscall>
  803dc5:	83 c4 18             	add    $0x18,%esp
}
  803dc8:	c9                   	leave  
  803dc9:	c3                   	ret    

00803dca <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803dca:	55                   	push   %ebp
  803dcb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803dcd:	6a 00                	push   $0x0
  803dcf:	6a 00                	push   $0x0
  803dd1:	6a 00                	push   $0x0
  803dd3:	6a 00                	push   $0x0
  803dd5:	6a 00                	push   $0x0
  803dd7:	6a 25                	push   $0x25
  803dd9:	e8 93 fb ff ff       	call   803971 <syscall>
  803dde:	83 c4 18             	add    $0x18,%esp
  803de1:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  803de6:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  803deb:	c9                   	leave  
  803dec:	c3                   	ret    

00803ded <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803ded:	55                   	push   %ebp
  803dee:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803df0:	8b 45 08             	mov    0x8(%ebp),%eax
  803df3:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803df8:	6a 00                	push   $0x0
  803dfa:	6a 00                	push   $0x0
  803dfc:	6a 00                	push   $0x0
  803dfe:	6a 00                	push   $0x0
  803e00:	ff 75 08             	pushl  0x8(%ebp)
  803e03:	6a 26                	push   $0x26
  803e05:	e8 67 fb ff ff       	call   803971 <syscall>
  803e0a:	83 c4 18             	add    $0x18,%esp
	return ;
  803e0d:	90                   	nop
}
  803e0e:	c9                   	leave  
  803e0f:	c3                   	ret    

00803e10 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803e10:	55                   	push   %ebp
  803e11:	89 e5                	mov    %esp,%ebp
  803e13:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803e14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803e17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	6a 00                	push   $0x0
  803e22:	53                   	push   %ebx
  803e23:	51                   	push   %ecx
  803e24:	52                   	push   %edx
  803e25:	50                   	push   %eax
  803e26:	6a 27                	push   $0x27
  803e28:	e8 44 fb ff ff       	call   803971 <syscall>
  803e2d:	83 c4 18             	add    $0x18,%esp
}
  803e30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803e33:	c9                   	leave  
  803e34:	c3                   	ret    

00803e35 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803e35:	55                   	push   %ebp
  803e36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3e:	6a 00                	push   $0x0
  803e40:	6a 00                	push   $0x0
  803e42:	6a 00                	push   $0x0
  803e44:	52                   	push   %edx
  803e45:	50                   	push   %eax
  803e46:	6a 28                	push   $0x28
  803e48:	e8 24 fb ff ff       	call   803971 <syscall>
  803e4d:	83 c4 18             	add    $0x18,%esp
}
  803e50:	c9                   	leave  
  803e51:	c3                   	ret    

00803e52 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803e52:	55                   	push   %ebp
  803e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803e55:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5e:	6a 00                	push   $0x0
  803e60:	51                   	push   %ecx
  803e61:	ff 75 10             	pushl  0x10(%ebp)
  803e64:	52                   	push   %edx
  803e65:	50                   	push   %eax
  803e66:	6a 29                	push   $0x29
  803e68:	e8 04 fb ff ff       	call   803971 <syscall>
  803e6d:	83 c4 18             	add    $0x18,%esp
}
  803e70:	c9                   	leave  
  803e71:	c3                   	ret    

00803e72 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803e72:	55                   	push   %ebp
  803e73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803e75:	6a 00                	push   $0x0
  803e77:	6a 00                	push   $0x0
  803e79:	ff 75 10             	pushl  0x10(%ebp)
  803e7c:	ff 75 0c             	pushl  0xc(%ebp)
  803e7f:	ff 75 08             	pushl  0x8(%ebp)
  803e82:	6a 12                	push   $0x12
  803e84:	e8 e8 fa ff ff       	call   803971 <syscall>
  803e89:	83 c4 18             	add    $0x18,%esp
	return ;
  803e8c:	90                   	nop
}
  803e8d:	c9                   	leave  
  803e8e:	c3                   	ret    

00803e8f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803e8f:	55                   	push   %ebp
  803e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e95:	8b 45 08             	mov    0x8(%ebp),%eax
  803e98:	6a 00                	push   $0x0
  803e9a:	6a 00                	push   $0x0
  803e9c:	6a 00                	push   $0x0
  803e9e:	52                   	push   %edx
  803e9f:	50                   	push   %eax
  803ea0:	6a 2a                	push   $0x2a
  803ea2:	e8 ca fa ff ff       	call   803971 <syscall>
  803ea7:	83 c4 18             	add    $0x18,%esp
	return;
  803eaa:	90                   	nop
}
  803eab:	c9                   	leave  
  803eac:	c3                   	ret    

00803ead <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803ead:	55                   	push   %ebp
  803eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803eb0:	6a 00                	push   $0x0
  803eb2:	6a 00                	push   $0x0
  803eb4:	6a 00                	push   $0x0
  803eb6:	6a 00                	push   $0x0
  803eb8:	6a 00                	push   $0x0
  803eba:	6a 2b                	push   $0x2b
  803ebc:	e8 b0 fa ff ff       	call   803971 <syscall>
  803ec1:	83 c4 18             	add    $0x18,%esp
}
  803ec4:	c9                   	leave  
  803ec5:	c3                   	ret    

00803ec6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803ec6:	55                   	push   %ebp
  803ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803ec9:	6a 00                	push   $0x0
  803ecb:	6a 00                	push   $0x0
  803ecd:	6a 00                	push   $0x0
  803ecf:	ff 75 0c             	pushl  0xc(%ebp)
  803ed2:	ff 75 08             	pushl  0x8(%ebp)
  803ed5:	6a 2d                	push   $0x2d
  803ed7:	e8 95 fa ff ff       	call   803971 <syscall>
  803edc:	83 c4 18             	add    $0x18,%esp
	return;
  803edf:	90                   	nop
}
  803ee0:	c9                   	leave  
  803ee1:	c3                   	ret    

00803ee2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803ee2:	55                   	push   %ebp
  803ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803ee5:	6a 00                	push   $0x0
  803ee7:	6a 00                	push   $0x0
  803ee9:	6a 00                	push   $0x0
  803eeb:	ff 75 0c             	pushl  0xc(%ebp)
  803eee:	ff 75 08             	pushl  0x8(%ebp)
  803ef1:	6a 2c                	push   $0x2c
  803ef3:	e8 79 fa ff ff       	call   803971 <syscall>
  803ef8:	83 c4 18             	add    $0x18,%esp
	return ;
  803efb:	90                   	nop
}
  803efc:	c9                   	leave  
  803efd:	c3                   	ret    

00803efe <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803efe:	55                   	push   %ebp
  803eff:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f04:	8b 45 08             	mov    0x8(%ebp),%eax
  803f07:	6a 00                	push   $0x0
  803f09:	6a 00                	push   $0x0
  803f0b:	6a 00                	push   $0x0
  803f0d:	52                   	push   %edx
  803f0e:	50                   	push   %eax
  803f0f:	6a 2e                	push   $0x2e
  803f11:	e8 5b fa ff ff       	call   803971 <syscall>
  803f16:	83 c4 18             	add    $0x18,%esp
	return ;
  803f19:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803f1a:	c9                   	leave  
  803f1b:	c3                   	ret    

00803f1c <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803f1c:	55                   	push   %ebp
  803f1d:	89 e5                	mov    %esp,%ebp
  803f1f:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803f22:	81 7d 08 40 72 80 00 	cmpl   $0x807240,0x8(%ebp)
  803f29:	72 09                	jb     803f34 <to_page_va+0x18>
  803f2b:	81 7d 08 40 f2 81 00 	cmpl   $0x81f240,0x8(%ebp)
  803f32:	72 14                	jb     803f48 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803f34:	83 ec 04             	sub    $0x4,%esp
  803f37:	68 40 61 80 00       	push   $0x806140
  803f3c:	6a 15                	push   $0x15
  803f3e:	68 6b 61 80 00       	push   $0x80616b
  803f43:	e8 4e db ff ff       	call   801a96 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803f48:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4b:	ba 40 72 80 00       	mov    $0x807240,%edx
  803f50:	29 d0                	sub    %edx,%eax
  803f52:	c1 f8 02             	sar    $0x2,%eax
  803f55:	89 c2                	mov    %eax,%edx
  803f57:	89 d0                	mov    %edx,%eax
  803f59:	c1 e0 02             	shl    $0x2,%eax
  803f5c:	01 d0                	add    %edx,%eax
  803f5e:	c1 e0 02             	shl    $0x2,%eax
  803f61:	01 d0                	add    %edx,%eax
  803f63:	c1 e0 02             	shl    $0x2,%eax
  803f66:	01 d0                	add    %edx,%eax
  803f68:	89 c1                	mov    %eax,%ecx
  803f6a:	c1 e1 08             	shl    $0x8,%ecx
  803f6d:	01 c8                	add    %ecx,%eax
  803f6f:	89 c1                	mov    %eax,%ecx
  803f71:	c1 e1 10             	shl    $0x10,%ecx
  803f74:	01 c8                	add    %ecx,%eax
  803f76:	01 c0                	add    %eax,%eax
  803f78:	01 d0                	add    %edx,%eax
  803f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f80:	c1 e0 0c             	shl    $0xc,%eax
  803f83:	89 c2                	mov    %eax,%edx
  803f85:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803f8a:	01 d0                	add    %edx,%eax
}
  803f8c:	c9                   	leave  
  803f8d:	c3                   	ret    

00803f8e <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803f8e:	55                   	push   %ebp
  803f8f:	89 e5                	mov    %esp,%ebp
  803f91:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803f94:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803f99:	8b 55 08             	mov    0x8(%ebp),%edx
  803f9c:	29 c2                	sub    %eax,%edx
  803f9e:	89 d0                	mov    %edx,%eax
  803fa0:	c1 e8 0c             	shr    $0xc,%eax
  803fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803faa:	78 09                	js     803fb5 <to_page_info+0x27>
  803fac:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803fb3:	7e 14                	jle    803fc9 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803fb5:	83 ec 04             	sub    $0x4,%esp
  803fb8:	68 84 61 80 00       	push   $0x806184
  803fbd:	6a 22                	push   $0x22
  803fbf:	68 6b 61 80 00       	push   $0x80616b
  803fc4:	e8 cd da ff ff       	call   801a96 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fcc:	89 d0                	mov    %edx,%eax
  803fce:	01 c0                	add    %eax,%eax
  803fd0:	01 d0                	add    %edx,%eax
  803fd2:	c1 e0 02             	shl    $0x2,%eax
  803fd5:	05 40 72 80 00       	add    $0x807240,%eax
}
  803fda:	c9                   	leave  
  803fdb:	c3                   	ret    

00803fdc <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803fdc:	55                   	push   %ebp
  803fdd:	89 e5                	mov    %esp,%ebp
  803fdf:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe5:	05 00 00 00 02       	add    $0x2000000,%eax
  803fea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803fed:	73 16                	jae    804005 <initialize_dynamic_allocator+0x29>
  803fef:	68 a8 61 80 00       	push   $0x8061a8
  803ff4:	68 ce 61 80 00       	push   $0x8061ce
  803ff9:	6a 34                	push   $0x34
  803ffb:	68 6b 61 80 00       	push   $0x80616b
  804000:	e8 91 da ff ff       	call   801a96 <_panic>
		is_initialized = 1;
  804005:	c7 05 14 72 80 00 01 	movl   $0x1,0x807214
  80400c:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  80400f:	8b 45 08             	mov    0x8(%ebp),%eax
  804012:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd = daEnd;
  804017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80401a:	a3 20 72 80 00       	mov    %eax,0x807220

	LIST_INIT(&freePagesList);
  80401f:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  804026:	00 00 00 
  804029:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  804030:	00 00 00 
  804033:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  80403a:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  80403d:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  804044:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80404b:	eb 36                	jmp    804083 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  80404d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804050:	c1 e0 04             	shl    $0x4,%eax
  804053:	05 60 f2 81 00       	add    $0x81f260,%eax
  804058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80405e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804061:	c1 e0 04             	shl    $0x4,%eax
  804064:	05 64 f2 81 00       	add    $0x81f264,%eax
  804069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80406f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804072:	c1 e0 04             	shl    $0x4,%eax
  804075:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80407a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  804080:	ff 45 f4             	incl   -0xc(%ebp)
  804083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804086:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804089:	72 c2                	jb     80404d <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  80408b:	8b 15 20 72 80 00    	mov    0x807220,%edx
  804091:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804096:	29 c2                	sub    %eax,%edx
  804098:	89 d0                	mov    %edx,%eax
  80409a:	c1 e8 0c             	shr    $0xc,%eax
  80409d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  8040a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8040a7:	e9 c8 00 00 00       	jmp    804174 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  8040ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040af:	89 d0                	mov    %edx,%eax
  8040b1:	01 c0                	add    %eax,%eax
  8040b3:	01 d0                	add    %edx,%eax
  8040b5:	c1 e0 02             	shl    $0x2,%eax
  8040b8:	05 48 72 80 00       	add    $0x807248,%eax
  8040bd:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8040c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040c5:	89 d0                	mov    %edx,%eax
  8040c7:	01 c0                	add    %eax,%eax
  8040c9:	01 d0                	add    %edx,%eax
  8040cb:	c1 e0 02             	shl    $0x2,%eax
  8040ce:	05 4a 72 80 00       	add    $0x80724a,%eax
  8040d3:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8040d8:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8040de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8040e1:	89 c8                	mov    %ecx,%eax
  8040e3:	01 c0                	add    %eax,%eax
  8040e5:	01 c8                	add    %ecx,%eax
  8040e7:	c1 e0 02             	shl    $0x2,%eax
  8040ea:	05 44 72 80 00       	add    $0x807244,%eax
  8040ef:	89 10                	mov    %edx,(%eax)
  8040f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040f4:	89 d0                	mov    %edx,%eax
  8040f6:	01 c0                	add    %eax,%eax
  8040f8:	01 d0                	add    %edx,%eax
  8040fa:	c1 e0 02             	shl    $0x2,%eax
  8040fd:	05 44 72 80 00       	add    $0x807244,%eax
  804102:	8b 00                	mov    (%eax),%eax
  804104:	85 c0                	test   %eax,%eax
  804106:	74 1b                	je     804123 <initialize_dynamic_allocator+0x147>
  804108:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80410e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804111:	89 c8                	mov    %ecx,%eax
  804113:	01 c0                	add    %eax,%eax
  804115:	01 c8                	add    %ecx,%eax
  804117:	c1 e0 02             	shl    $0x2,%eax
  80411a:	05 40 72 80 00       	add    $0x807240,%eax
  80411f:	89 02                	mov    %eax,(%edx)
  804121:	eb 16                	jmp    804139 <initialize_dynamic_allocator+0x15d>
  804123:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804126:	89 d0                	mov    %edx,%eax
  804128:	01 c0                	add    %eax,%eax
  80412a:	01 d0                	add    %edx,%eax
  80412c:	c1 e0 02             	shl    $0x2,%eax
  80412f:	05 40 72 80 00       	add    $0x807240,%eax
  804134:	a3 28 72 80 00       	mov    %eax,0x807228
  804139:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80413c:	89 d0                	mov    %edx,%eax
  80413e:	01 c0                	add    %eax,%eax
  804140:	01 d0                	add    %edx,%eax
  804142:	c1 e0 02             	shl    $0x2,%eax
  804145:	05 40 72 80 00       	add    $0x807240,%eax
  80414a:	a3 2c 72 80 00       	mov    %eax,0x80722c
  80414f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804152:	89 d0                	mov    %edx,%eax
  804154:	01 c0                	add    %eax,%eax
  804156:	01 d0                	add    %edx,%eax
  804158:	c1 e0 02             	shl    $0x2,%eax
  80415b:	05 40 72 80 00       	add    $0x807240,%eax
  804160:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804166:	a1 34 72 80 00       	mov    0x807234,%eax
  80416b:	40                   	inc    %eax
  80416c:	a3 34 72 80 00       	mov    %eax,0x807234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  804171:	ff 45 f0             	incl   -0x10(%ebp)
  804174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804177:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80417a:	0f 82 2c ff ff ff    	jb     8040ac <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  804180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804183:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804186:	eb 2f                	jmp    8041b7 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  804188:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80418b:	89 d0                	mov    %edx,%eax
  80418d:	01 c0                	add    %eax,%eax
  80418f:	01 d0                	add    %edx,%eax
  804191:	c1 e0 02             	shl    $0x2,%eax
  804194:	05 48 72 80 00       	add    $0x807248,%eax
  804199:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  80419e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041a1:	89 d0                	mov    %edx,%eax
  8041a3:	01 c0                	add    %eax,%eax
  8041a5:	01 d0                	add    %edx,%eax
  8041a7:	c1 e0 02             	shl    $0x2,%eax
  8041aa:	05 4a 72 80 00       	add    $0x80724a,%eax
  8041af:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  8041b4:	ff 45 ec             	incl   -0x14(%ebp)
  8041b7:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  8041be:	76 c8                	jbe    804188 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8041c0:	90                   	nop
  8041c1:	c9                   	leave  
  8041c2:	c3                   	ret    

008041c3 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8041c3:	55                   	push   %ebp
  8041c4:	89 e5                	mov    %esp,%ebp
  8041c6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  8041c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8041cc:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8041d1:	29 c2                	sub    %eax,%edx
  8041d3:	89 d0                	mov    %edx,%eax
  8041d5:	c1 e8 0c             	shr    $0xc,%eax
  8041d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  8041db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8041de:	89 d0                	mov    %edx,%eax
  8041e0:	01 c0                	add    %eax,%eax
  8041e2:	01 d0                	add    %edx,%eax
  8041e4:	c1 e0 02             	shl    $0x2,%eax
  8041e7:	05 48 72 80 00       	add    $0x807248,%eax
  8041ec:	8b 00                	mov    (%eax),%eax
  8041ee:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8041f1:	c9                   	leave  
  8041f2:	c3                   	ret    

008041f3 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8041f3:	55                   	push   %ebp
  8041f4:	89 e5                	mov    %esp,%ebp
  8041f6:	83 ec 14             	sub    $0x14,%esp
  8041f9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  8041fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804200:	77 07                	ja     804209 <nearest_pow2_ceil.1513+0x16>
  804202:	b8 01 00 00 00       	mov    $0x1,%eax
  804207:	eb 20                	jmp    804229 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  804209:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  804210:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  804213:	eb 08                	jmp    80421d <nearest_pow2_ceil.1513+0x2a>
  804215:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804218:	01 c0                	add    %eax,%eax
  80421a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80421d:	d1 6d 08             	shrl   0x8(%ebp)
  804220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804224:	75 ef                	jne    804215 <nearest_pow2_ceil.1513+0x22>
        return power;
  804226:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  804229:	c9                   	leave  
  80422a:	c3                   	ret    

0080422b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80422b:	55                   	push   %ebp
  80422c:	89 e5                	mov    %esp,%ebp
  80422e:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  804231:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  804238:	76 16                	jbe    804250 <alloc_block+0x25>
  80423a:	68 e4 61 80 00       	push   $0x8061e4
  80423f:	68 ce 61 80 00       	push   $0x8061ce
  804244:	6a 72                	push   $0x72
  804246:	68 6b 61 80 00       	push   $0x80616b
  80424b:	e8 46 d8 ff ff       	call   801a96 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  804250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804254:	75 0a                	jne    804260 <alloc_block+0x35>
  804256:	b8 00 00 00 00       	mov    $0x0,%eax
  80425b:	e9 bd 04 00 00       	jmp    80471d <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  804260:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  804267:	8b 45 08             	mov    0x8(%ebp),%eax
  80426a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80426d:	73 06                	jae    804275 <alloc_block+0x4a>
        size = min_block_size;
  80426f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804272:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  804275:	83 ec 0c             	sub    $0xc,%esp
  804278:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80427b:	ff 75 08             	pushl  0x8(%ebp)
  80427e:	89 c1                	mov    %eax,%ecx
  804280:	e8 6e ff ff ff       	call   8041f3 <nearest_pow2_ceil.1513>
  804285:	83 c4 10             	add    $0x10,%esp
  804288:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  80428b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80428e:	83 ec 0c             	sub    $0xc,%esp
  804291:	8d 45 cc             	lea    -0x34(%ebp),%eax
  804294:	52                   	push   %edx
  804295:	89 c1                	mov    %eax,%ecx
  804297:	e8 83 04 00 00       	call   80471f <log2_ceil.1520>
  80429c:	83 c4 10             	add    $0x10,%esp
  80429f:	83 e8 03             	sub    $0x3,%eax
  8042a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  8042a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042a8:	c1 e0 04             	shl    $0x4,%eax
  8042ab:	05 60 f2 81 00       	add    $0x81f260,%eax
  8042b0:	8b 00                	mov    (%eax),%eax
  8042b2:	85 c0                	test   %eax,%eax
  8042b4:	0f 84 d8 00 00 00    	je     804392 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8042ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042bd:	c1 e0 04             	shl    $0x4,%eax
  8042c0:	05 60 f2 81 00       	add    $0x81f260,%eax
  8042c5:	8b 00                	mov    (%eax),%eax
  8042c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8042ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8042ce:	75 17                	jne    8042e7 <alloc_block+0xbc>
  8042d0:	83 ec 04             	sub    $0x4,%esp
  8042d3:	68 05 62 80 00       	push   $0x806205
  8042d8:	68 98 00 00 00       	push   $0x98
  8042dd:	68 6b 61 80 00       	push   $0x80616b
  8042e2:	e8 af d7 ff ff       	call   801a96 <_panic>
  8042e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042ea:	8b 00                	mov    (%eax),%eax
  8042ec:	85 c0                	test   %eax,%eax
  8042ee:	74 10                	je     804300 <alloc_block+0xd5>
  8042f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042f3:	8b 00                	mov    (%eax),%eax
  8042f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8042f8:	8b 52 04             	mov    0x4(%edx),%edx
  8042fb:	89 50 04             	mov    %edx,0x4(%eax)
  8042fe:	eb 14                	jmp    804314 <alloc_block+0xe9>
  804300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804303:	8b 40 04             	mov    0x4(%eax),%eax
  804306:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804309:	c1 e2 04             	shl    $0x4,%edx
  80430c:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804312:	89 02                	mov    %eax,(%edx)
  804314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804317:	8b 40 04             	mov    0x4(%eax),%eax
  80431a:	85 c0                	test   %eax,%eax
  80431c:	74 0f                	je     80432d <alloc_block+0x102>
  80431e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804321:	8b 40 04             	mov    0x4(%eax),%eax
  804324:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804327:	8b 12                	mov    (%edx),%edx
  804329:	89 10                	mov    %edx,(%eax)
  80432b:	eb 13                	jmp    804340 <alloc_block+0x115>
  80432d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804330:	8b 00                	mov    (%eax),%eax
  804332:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804335:	c1 e2 04             	shl    $0x4,%edx
  804338:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  80433e:	89 02                	mov    %eax,(%edx)
  804340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80434c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804356:	c1 e0 04             	shl    $0x4,%eax
  804359:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80435e:	8b 00                	mov    (%eax),%eax
  804360:	8d 50 ff             	lea    -0x1(%eax),%edx
  804363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804366:	c1 e0 04             	shl    $0x4,%eax
  804369:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80436e:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  804370:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804373:	83 ec 0c             	sub    $0xc,%esp
  804376:	50                   	push   %eax
  804377:	e8 12 fc ff ff       	call   803f8e <to_page_info>
  80437c:	83 c4 10             	add    $0x10,%esp
  80437f:	89 c2                	mov    %eax,%edx
  804381:	66 8b 42 0a          	mov    0xa(%edx),%ax
  804385:	48                   	dec    %eax
  804386:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  80438a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80438d:	e9 8b 03 00 00       	jmp    80471d <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  804392:	a1 28 72 80 00       	mov    0x807228,%eax
  804397:	85 c0                	test   %eax,%eax
  804399:	0f 84 64 02 00 00    	je     804603 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  80439f:	a1 28 72 80 00       	mov    0x807228,%eax
  8043a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8043a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8043ab:	75 17                	jne    8043c4 <alloc_block+0x199>
  8043ad:	83 ec 04             	sub    $0x4,%esp
  8043b0:	68 05 62 80 00       	push   $0x806205
  8043b5:	68 a0 00 00 00       	push   $0xa0
  8043ba:	68 6b 61 80 00       	push   $0x80616b
  8043bf:	e8 d2 d6 ff ff       	call   801a96 <_panic>
  8043c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043c7:	8b 00                	mov    (%eax),%eax
  8043c9:	85 c0                	test   %eax,%eax
  8043cb:	74 10                	je     8043dd <alloc_block+0x1b2>
  8043cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043d0:	8b 00                	mov    (%eax),%eax
  8043d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8043d5:	8b 52 04             	mov    0x4(%edx),%edx
  8043d8:	89 50 04             	mov    %edx,0x4(%eax)
  8043db:	eb 0b                	jmp    8043e8 <alloc_block+0x1bd>
  8043dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043e0:	8b 40 04             	mov    0x4(%eax),%eax
  8043e3:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8043e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043eb:	8b 40 04             	mov    0x4(%eax),%eax
  8043ee:	85 c0                	test   %eax,%eax
  8043f0:	74 0f                	je     804401 <alloc_block+0x1d6>
  8043f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043f5:	8b 40 04             	mov    0x4(%eax),%eax
  8043f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8043fb:	8b 12                	mov    (%edx),%edx
  8043fd:	89 10                	mov    %edx,(%eax)
  8043ff:	eb 0a                	jmp    80440b <alloc_block+0x1e0>
  804401:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804404:	8b 00                	mov    (%eax),%eax
  804406:	a3 28 72 80 00       	mov    %eax,0x807228
  80440b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80440e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804414:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804417:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80441e:	a1 34 72 80 00       	mov    0x807234,%eax
  804423:	48                   	dec    %eax
  804424:	a3 34 72 80 00       	mov    %eax,0x807234

        page_info_e->block_size = pow;
  804429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80442c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80442f:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  804433:	b8 00 10 00 00       	mov    $0x1000,%eax
  804438:	99                   	cltd   
  804439:	f7 7d e8             	idivl  -0x18(%ebp)
  80443c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80443f:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  804443:	83 ec 0c             	sub    $0xc,%esp
  804446:	ff 75 dc             	pushl  -0x24(%ebp)
  804449:	e8 ce fa ff ff       	call   803f1c <to_page_va>
  80444e:	83 c4 10             	add    $0x10,%esp
  804451:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  804454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804457:	83 ec 0c             	sub    $0xc,%esp
  80445a:	50                   	push   %eax
  80445b:	e8 c0 ee ff ff       	call   803320 <get_page>
  804460:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  804463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80446a:	e9 aa 00 00 00       	jmp    804519 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  80446f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804472:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  804476:	89 c2                	mov    %eax,%edx
  804478:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80447b:	01 d0                	add    %edx,%eax
  80447d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  804480:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804484:	75 17                	jne    80449d <alloc_block+0x272>
  804486:	83 ec 04             	sub    $0x4,%esp
  804489:	68 24 62 80 00       	push   $0x806224
  80448e:	68 aa 00 00 00       	push   $0xaa
  804493:	68 6b 61 80 00       	push   $0x80616b
  804498:	e8 f9 d5 ff ff       	call   801a96 <_panic>
  80449d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044a0:	c1 e0 04             	shl    $0x4,%eax
  8044a3:	05 64 f2 81 00       	add    $0x81f264,%eax
  8044a8:	8b 10                	mov    (%eax),%edx
  8044aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044ad:	89 50 04             	mov    %edx,0x4(%eax)
  8044b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044b3:	8b 40 04             	mov    0x4(%eax),%eax
  8044b6:	85 c0                	test   %eax,%eax
  8044b8:	74 14                	je     8044ce <alloc_block+0x2a3>
  8044ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044bd:	c1 e0 04             	shl    $0x4,%eax
  8044c0:	05 64 f2 81 00       	add    $0x81f264,%eax
  8044c5:	8b 00                	mov    (%eax),%eax
  8044c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8044ca:	89 10                	mov    %edx,(%eax)
  8044cc:	eb 11                	jmp    8044df <alloc_block+0x2b4>
  8044ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044d1:	c1 e0 04             	shl    $0x4,%eax
  8044d4:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  8044da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044dd:	89 02                	mov    %eax,(%edx)
  8044df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044e2:	c1 e0 04             	shl    $0x4,%eax
  8044e5:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  8044eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044ee:	89 02                	mov    %eax,(%edx)
  8044f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044fc:	c1 e0 04             	shl    $0x4,%eax
  8044ff:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804504:	8b 00                	mov    (%eax),%eax
  804506:	8d 50 01             	lea    0x1(%eax),%edx
  804509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80450c:	c1 e0 04             	shl    $0x4,%eax
  80450f:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804514:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  804516:	ff 45 f4             	incl   -0xc(%ebp)
  804519:	b8 00 10 00 00       	mov    $0x1000,%eax
  80451e:	99                   	cltd   
  80451f:	f7 7d e8             	idivl  -0x18(%ebp)
  804522:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804525:	0f 8f 44 ff ff ff    	jg     80446f <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80452b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80452e:	c1 e0 04             	shl    $0x4,%eax
  804531:	05 60 f2 81 00       	add    $0x81f260,%eax
  804536:	8b 00                	mov    (%eax),%eax
  804538:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80453b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80453f:	75 17                	jne    804558 <alloc_block+0x32d>
  804541:	83 ec 04             	sub    $0x4,%esp
  804544:	68 05 62 80 00       	push   $0x806205
  804549:	68 ae 00 00 00       	push   $0xae
  80454e:	68 6b 61 80 00       	push   $0x80616b
  804553:	e8 3e d5 ff ff       	call   801a96 <_panic>
  804558:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80455b:	8b 00                	mov    (%eax),%eax
  80455d:	85 c0                	test   %eax,%eax
  80455f:	74 10                	je     804571 <alloc_block+0x346>
  804561:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804564:	8b 00                	mov    (%eax),%eax
  804566:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804569:	8b 52 04             	mov    0x4(%edx),%edx
  80456c:	89 50 04             	mov    %edx,0x4(%eax)
  80456f:	eb 14                	jmp    804585 <alloc_block+0x35a>
  804571:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804574:	8b 40 04             	mov    0x4(%eax),%eax
  804577:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80457a:	c1 e2 04             	shl    $0x4,%edx
  80457d:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804583:	89 02                	mov    %eax,(%edx)
  804585:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804588:	8b 40 04             	mov    0x4(%eax),%eax
  80458b:	85 c0                	test   %eax,%eax
  80458d:	74 0f                	je     80459e <alloc_block+0x373>
  80458f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804592:	8b 40 04             	mov    0x4(%eax),%eax
  804595:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804598:	8b 12                	mov    (%edx),%edx
  80459a:	89 10                	mov    %edx,(%eax)
  80459c:	eb 13                	jmp    8045b1 <alloc_block+0x386>
  80459e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045a1:	8b 00                	mov    (%eax),%eax
  8045a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045a6:	c1 e2 04             	shl    $0x4,%edx
  8045a9:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8045af:	89 02                	mov    %eax,(%edx)
  8045b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c7:	c1 e0 04             	shl    $0x4,%eax
  8045ca:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8045cf:	8b 00                	mov    (%eax),%eax
  8045d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8045d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045d7:	c1 e0 04             	shl    $0x4,%eax
  8045da:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8045df:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8045e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045e4:	83 ec 0c             	sub    $0xc,%esp
  8045e7:	50                   	push   %eax
  8045e8:	e8 a1 f9 ff ff       	call   803f8e <to_page_info>
  8045ed:	83 c4 10             	add    $0x10,%esp
  8045f0:	89 c2                	mov    %eax,%edx
  8045f2:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8045f6:	48                   	dec    %eax
  8045f7:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8045fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045fe:	e9 1a 01 00 00       	jmp    80471d <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  804603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804606:	40                   	inc    %eax
  804607:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80460a:	e9 ed 00 00 00       	jmp    8046fc <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80460f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804612:	c1 e0 04             	shl    $0x4,%eax
  804615:	05 60 f2 81 00       	add    $0x81f260,%eax
  80461a:	8b 00                	mov    (%eax),%eax
  80461c:	85 c0                	test   %eax,%eax
  80461e:	0f 84 d5 00 00 00    	je     8046f9 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  804624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804627:	c1 e0 04             	shl    $0x4,%eax
  80462a:	05 60 f2 81 00       	add    $0x81f260,%eax
  80462f:	8b 00                	mov    (%eax),%eax
  804631:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  804634:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804638:	75 17                	jne    804651 <alloc_block+0x426>
  80463a:	83 ec 04             	sub    $0x4,%esp
  80463d:	68 05 62 80 00       	push   $0x806205
  804642:	68 b8 00 00 00       	push   $0xb8
  804647:	68 6b 61 80 00       	push   $0x80616b
  80464c:	e8 45 d4 ff ff       	call   801a96 <_panic>
  804651:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804654:	8b 00                	mov    (%eax),%eax
  804656:	85 c0                	test   %eax,%eax
  804658:	74 10                	je     80466a <alloc_block+0x43f>
  80465a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80465d:	8b 00                	mov    (%eax),%eax
  80465f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804662:	8b 52 04             	mov    0x4(%edx),%edx
  804665:	89 50 04             	mov    %edx,0x4(%eax)
  804668:	eb 14                	jmp    80467e <alloc_block+0x453>
  80466a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80466d:	8b 40 04             	mov    0x4(%eax),%eax
  804670:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804673:	c1 e2 04             	shl    $0x4,%edx
  804676:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  80467c:	89 02                	mov    %eax,(%edx)
  80467e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804681:	8b 40 04             	mov    0x4(%eax),%eax
  804684:	85 c0                	test   %eax,%eax
  804686:	74 0f                	je     804697 <alloc_block+0x46c>
  804688:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80468b:	8b 40 04             	mov    0x4(%eax),%eax
  80468e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804691:	8b 12                	mov    (%edx),%edx
  804693:	89 10                	mov    %edx,(%eax)
  804695:	eb 13                	jmp    8046aa <alloc_block+0x47f>
  804697:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80469a:	8b 00                	mov    (%eax),%eax
  80469c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80469f:	c1 e2 04             	shl    $0x4,%edx
  8046a2:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8046a8:	89 02                	mov    %eax,(%edx)
  8046aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8046ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8046b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8046b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046c0:	c1 e0 04             	shl    $0x4,%eax
  8046c3:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8046c8:	8b 00                	mov    (%eax),%eax
  8046ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8046cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046d0:	c1 e0 04             	shl    $0x4,%eax
  8046d3:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8046d8:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8046da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8046dd:	83 ec 0c             	sub    $0xc,%esp
  8046e0:	50                   	push   %eax
  8046e1:	e8 a8 f8 ff ff       	call   803f8e <to_page_info>
  8046e6:	83 c4 10             	add    $0x10,%esp
  8046e9:	89 c2                	mov    %eax,%edx
  8046eb:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8046ef:	48                   	dec    %eax
  8046f0:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8046f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8046f7:	eb 24                	jmp    80471d <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8046f9:	ff 45 f0             	incl   -0x10(%ebp)
  8046fc:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  804700:	0f 8e 09 ff ff ff    	jle    80460f <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  804706:	83 ec 04             	sub    $0x4,%esp
  804709:	68 47 62 80 00       	push   $0x806247
  80470e:	68 bf 00 00 00       	push   $0xbf
  804713:	68 6b 61 80 00       	push   $0x80616b
  804718:	e8 79 d3 ff ff       	call   801a96 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80471d:	c9                   	leave  
  80471e:	c3                   	ret    

0080471f <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80471f:	55                   	push   %ebp
  804720:	89 e5                	mov    %esp,%ebp
  804722:	83 ec 14             	sub    $0x14,%esp
  804725:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  804728:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80472c:	75 07                	jne    804735 <log2_ceil.1520+0x16>
  80472e:	b8 00 00 00 00       	mov    $0x0,%eax
  804733:	eb 1b                	jmp    804750 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  804735:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80473c:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80473f:	eb 06                	jmp    804747 <log2_ceil.1520+0x28>
            x >>= 1;
  804741:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  804744:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  804747:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80474b:	75 f4                	jne    804741 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  80474d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  804750:	c9                   	leave  
  804751:	c3                   	ret    

00804752 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  804752:	55                   	push   %ebp
  804753:	89 e5                	mov    %esp,%ebp
  804755:	83 ec 14             	sub    $0x14,%esp
  804758:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80475b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80475f:	75 07                	jne    804768 <log2_ceil.1547+0x16>
  804761:	b8 00 00 00 00       	mov    $0x0,%eax
  804766:	eb 1b                	jmp    804783 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  804768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80476f:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  804772:	eb 06                	jmp    80477a <log2_ceil.1547+0x28>
			x >>= 1;
  804774:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  804777:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80477a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80477e:	75 f4                	jne    804774 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  804780:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  804783:	c9                   	leave  
  804784:	c3                   	ret    

00804785 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804785:	55                   	push   %ebp
  804786:	89 e5                	mov    %esp,%ebp
  804788:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80478b:	8b 55 08             	mov    0x8(%ebp),%edx
  80478e:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804793:	39 c2                	cmp    %eax,%edx
  804795:	72 0c                	jb     8047a3 <free_block+0x1e>
  804797:	8b 55 08             	mov    0x8(%ebp),%edx
  80479a:	a1 20 72 80 00       	mov    0x807220,%eax
  80479f:	39 c2                	cmp    %eax,%edx
  8047a1:	72 19                	jb     8047bc <free_block+0x37>
  8047a3:	68 4c 62 80 00       	push   $0x80624c
  8047a8:	68 ce 61 80 00       	push   $0x8061ce
  8047ad:	68 d0 00 00 00       	push   $0xd0
  8047b2:	68 6b 61 80 00       	push   $0x80616b
  8047b7:	e8 da d2 ff ff       	call   801a96 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8047bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8047c0:	0f 84 42 03 00 00    	je     804b08 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8047c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8047c9:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8047ce:	39 c2                	cmp    %eax,%edx
  8047d0:	72 0c                	jb     8047de <free_block+0x59>
  8047d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8047d5:	a1 20 72 80 00       	mov    0x807220,%eax
  8047da:	39 c2                	cmp    %eax,%edx
  8047dc:	72 17                	jb     8047f5 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8047de:	83 ec 04             	sub    $0x4,%esp
  8047e1:	68 84 62 80 00       	push   $0x806284
  8047e6:	68 e6 00 00 00       	push   $0xe6
  8047eb:	68 6b 61 80 00       	push   $0x80616b
  8047f0:	e8 a1 d2 ff ff       	call   801a96 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8047f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8047f8:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8047fd:	29 c2                	sub    %eax,%edx
  8047ff:	89 d0                	mov    %edx,%eax
  804801:	83 e0 07             	and    $0x7,%eax
  804804:	85 c0                	test   %eax,%eax
  804806:	74 17                	je     80481f <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  804808:	83 ec 04             	sub    $0x4,%esp
  80480b:	68 b8 62 80 00       	push   $0x8062b8
  804810:	68 ea 00 00 00       	push   $0xea
  804815:	68 6b 61 80 00       	push   $0x80616b
  80481a:	e8 77 d2 ff ff       	call   801a96 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80481f:	8b 45 08             	mov    0x8(%ebp),%eax
  804822:	83 ec 0c             	sub    $0xc,%esp
  804825:	50                   	push   %eax
  804826:	e8 63 f7 ff ff       	call   803f8e <to_page_info>
  80482b:	83 c4 10             	add    $0x10,%esp
  80482e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  804831:	83 ec 0c             	sub    $0xc,%esp
  804834:	ff 75 08             	pushl  0x8(%ebp)
  804837:	e8 87 f9 ff ff       	call   8041c3 <get_block_size>
  80483c:	83 c4 10             	add    $0x10,%esp
  80483f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  804842:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804846:	75 17                	jne    80485f <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  804848:	83 ec 04             	sub    $0x4,%esp
  80484b:	68 e4 62 80 00       	push   $0x8062e4
  804850:	68 f1 00 00 00       	push   $0xf1
  804855:	68 6b 61 80 00       	push   $0x80616b
  80485a:	e8 37 d2 ff ff       	call   801a96 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80485f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804862:	83 ec 0c             	sub    $0xc,%esp
  804865:	8d 45 d0             	lea    -0x30(%ebp),%eax
  804868:	52                   	push   %edx
  804869:	89 c1                	mov    %eax,%ecx
  80486b:	e8 e2 fe ff ff       	call   804752 <log2_ceil.1547>
  804870:	83 c4 10             	add    $0x10,%esp
  804873:	83 e8 03             	sub    $0x3,%eax
  804876:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  804879:	8b 45 08             	mov    0x8(%ebp),%eax
  80487c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80487f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804883:	75 17                	jne    80489c <free_block+0x117>
  804885:	83 ec 04             	sub    $0x4,%esp
  804888:	68 30 63 80 00       	push   $0x806330
  80488d:	68 f6 00 00 00       	push   $0xf6
  804892:	68 6b 61 80 00       	push   $0x80616b
  804897:	e8 fa d1 ff ff       	call   801a96 <_panic>
  80489c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80489f:	c1 e0 04             	shl    $0x4,%eax
  8048a2:	05 60 f2 81 00       	add    $0x81f260,%eax
  8048a7:	8b 10                	mov    (%eax),%edx
  8048a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8048ac:	89 10                	mov    %edx,(%eax)
  8048ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8048b1:	8b 00                	mov    (%eax),%eax
  8048b3:	85 c0                	test   %eax,%eax
  8048b5:	74 15                	je     8048cc <free_block+0x147>
  8048b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048ba:	c1 e0 04             	shl    $0x4,%eax
  8048bd:	05 60 f2 81 00       	add    $0x81f260,%eax
  8048c2:	8b 00                	mov    (%eax),%eax
  8048c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8048c7:	89 50 04             	mov    %edx,0x4(%eax)
  8048ca:	eb 11                	jmp    8048dd <free_block+0x158>
  8048cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048cf:	c1 e0 04             	shl    $0x4,%eax
  8048d2:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  8048d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8048db:	89 02                	mov    %eax,(%edx)
  8048dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048e0:	c1 e0 04             	shl    $0x4,%eax
  8048e3:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  8048e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8048ec:	89 02                	mov    %eax,(%edx)
  8048ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8048f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048fb:	c1 e0 04             	shl    $0x4,%eax
  8048fe:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804903:	8b 00                	mov    (%eax),%eax
  804905:	8d 50 01             	lea    0x1(%eax),%edx
  804908:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80490b:	c1 e0 04             	shl    $0x4,%eax
  80490e:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804913:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  804915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804918:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80491c:	40                   	inc    %eax
  80491d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804920:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  804924:	8b 55 08             	mov    0x8(%ebp),%edx
  804927:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80492c:	29 c2                	sub    %eax,%edx
  80492e:	89 d0                	mov    %edx,%eax
  804930:	c1 e8 0c             	shr    $0xc,%eax
  804933:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  804936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804939:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80493d:	0f b7 c8             	movzwl %ax,%ecx
  804940:	b8 00 10 00 00       	mov    $0x1000,%eax
  804945:	99                   	cltd   
  804946:	f7 7d e8             	idivl  -0x18(%ebp)
  804949:	39 c1                	cmp    %eax,%ecx
  80494b:	0f 85 b8 01 00 00    	jne    804b09 <free_block+0x384>
    	uint32 blocks_removed = 0;
  804951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  804958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80495b:	c1 e0 04             	shl    $0x4,%eax
  80495e:	05 60 f2 81 00       	add    $0x81f260,%eax
  804963:	8b 00                	mov    (%eax),%eax
  804965:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804968:	e9 d5 00 00 00       	jmp    804a42 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80496d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804970:	8b 00                	mov    (%eax),%eax
  804972:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  804975:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804978:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80497d:	29 c2                	sub    %eax,%edx
  80497f:	89 d0                	mov    %edx,%eax
  804981:	c1 e8 0c             	shr    $0xc,%eax
  804984:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  804987:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80498a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80498d:	0f 85 a9 00 00 00    	jne    804a3c <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  804993:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804997:	75 17                	jne    8049b0 <free_block+0x22b>
  804999:	83 ec 04             	sub    $0x4,%esp
  80499c:	68 05 62 80 00       	push   $0x806205
  8049a1:	68 04 01 00 00       	push   $0x104
  8049a6:	68 6b 61 80 00       	push   $0x80616b
  8049ab:	e8 e6 d0 ff ff       	call   801a96 <_panic>
  8049b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049b3:	8b 00                	mov    (%eax),%eax
  8049b5:	85 c0                	test   %eax,%eax
  8049b7:	74 10                	je     8049c9 <free_block+0x244>
  8049b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049bc:	8b 00                	mov    (%eax),%eax
  8049be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049c1:	8b 52 04             	mov    0x4(%edx),%edx
  8049c4:	89 50 04             	mov    %edx,0x4(%eax)
  8049c7:	eb 14                	jmp    8049dd <free_block+0x258>
  8049c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049cc:	8b 40 04             	mov    0x4(%eax),%eax
  8049cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049d2:	c1 e2 04             	shl    $0x4,%edx
  8049d5:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8049db:	89 02                	mov    %eax,(%edx)
  8049dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049e0:	8b 40 04             	mov    0x4(%eax),%eax
  8049e3:	85 c0                	test   %eax,%eax
  8049e5:	74 0f                	je     8049f6 <free_block+0x271>
  8049e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049ea:	8b 40 04             	mov    0x4(%eax),%eax
  8049ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049f0:	8b 12                	mov    (%edx),%edx
  8049f2:	89 10                	mov    %edx,(%eax)
  8049f4:	eb 13                	jmp    804a09 <free_block+0x284>
  8049f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049f9:	8b 00                	mov    (%eax),%eax
  8049fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049fe:	c1 e2 04             	shl    $0x4,%edx
  804a01:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804a07:	89 02                	mov    %eax,(%edx)
  804a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804a0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804a15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a1f:	c1 e0 04             	shl    $0x4,%eax
  804a22:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a27:	8b 00                	mov    (%eax),%eax
  804a29:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a2f:	c1 e0 04             	shl    $0x4,%eax
  804a32:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a37:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804a39:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804a3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804a46:	0f 85 21 ff ff ff    	jne    80496d <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  804a4c:	b8 00 10 00 00       	mov    $0x1000,%eax
  804a51:	99                   	cltd   
  804a52:	f7 7d e8             	idivl  -0x18(%ebp)
  804a55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804a58:	74 17                	je     804a71 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  804a5a:	83 ec 04             	sub    $0x4,%esp
  804a5d:	68 54 63 80 00       	push   $0x806354
  804a62:	68 0c 01 00 00       	push   $0x10c
  804a67:	68 6b 61 80 00       	push   $0x80616b
  804a6c:	e8 25 d0 ff ff       	call   801a96 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  804a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a74:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  804a7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a7d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  804a83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804a87:	75 17                	jne    804aa0 <free_block+0x31b>
  804a89:	83 ec 04             	sub    $0x4,%esp
  804a8c:	68 24 62 80 00       	push   $0x806224
  804a91:	68 11 01 00 00       	push   $0x111
  804a96:	68 6b 61 80 00       	push   $0x80616b
  804a9b:	e8 f6 cf ff ff       	call   801a96 <_panic>
  804aa0:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804aa9:	89 50 04             	mov    %edx,0x4(%eax)
  804aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804aaf:	8b 40 04             	mov    0x4(%eax),%eax
  804ab2:	85 c0                	test   %eax,%eax
  804ab4:	74 0c                	je     804ac2 <free_block+0x33d>
  804ab6:	a1 2c 72 80 00       	mov    0x80722c,%eax
  804abb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804abe:	89 10                	mov    %edx,(%eax)
  804ac0:	eb 08                	jmp    804aca <free_block+0x345>
  804ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ac5:	a3 28 72 80 00       	mov    %eax,0x807228
  804aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804acd:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ad5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804adb:	a1 34 72 80 00       	mov    0x807234,%eax
  804ae0:	40                   	inc    %eax
  804ae1:	a3 34 72 80 00       	mov    %eax,0x807234

        uint32 pp = to_page_va(page_info_e);
  804ae6:	83 ec 0c             	sub    $0xc,%esp
  804ae9:	ff 75 ec             	pushl  -0x14(%ebp)
  804aec:	e8 2b f4 ff ff       	call   803f1c <to_page_va>
  804af1:	83 c4 10             	add    $0x10,%esp
  804af4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  804af7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804afa:	83 ec 0c             	sub    $0xc,%esp
  804afd:	50                   	push   %eax
  804afe:	e8 69 e8 ff ff       	call   80336c <return_page>
  804b03:	83 c4 10             	add    $0x10,%esp
  804b06:	eb 01                	jmp    804b09 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  804b08:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804b09:	c9                   	leave  
  804b0a:	c3                   	ret    

00804b0b <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  804b0b:	55                   	push   %ebp
  804b0c:	89 e5                	mov    %esp,%ebp
  804b0e:	83 ec 14             	sub    $0x14,%esp
  804b11:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  804b14:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804b18:	77 07                	ja     804b21 <nearest_pow2_ceil.1572+0x16>
      return 1;
  804b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  804b1f:	eb 20                	jmp    804b41 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  804b21:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  804b28:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  804b2b:	eb 08                	jmp    804b35 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  804b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804b30:	01 c0                	add    %eax,%eax
  804b32:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  804b35:	d1 6d 08             	shrl   0x8(%ebp)
  804b38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804b3c:	75 ef                	jne    804b2d <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  804b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  804b41:	c9                   	leave  
  804b42:	c3                   	ret    

00804b43 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  804b43:	55                   	push   %ebp
  804b44:	89 e5                	mov    %esp,%ebp
  804b46:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  804b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804b4d:	75 13                	jne    804b62 <realloc_block+0x1f>
    return alloc_block(new_size);
  804b4f:	83 ec 0c             	sub    $0xc,%esp
  804b52:	ff 75 0c             	pushl  0xc(%ebp)
  804b55:	e8 d1 f6 ff ff       	call   80422b <alloc_block>
  804b5a:	83 c4 10             	add    $0x10,%esp
  804b5d:	e9 d9 00 00 00       	jmp    804c3b <realloc_block+0xf8>
  }

  if (new_size == 0) {
  804b62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804b66:	75 18                	jne    804b80 <realloc_block+0x3d>
    free_block(va);
  804b68:	83 ec 0c             	sub    $0xc,%esp
  804b6b:	ff 75 08             	pushl  0x8(%ebp)
  804b6e:	e8 12 fc ff ff       	call   804785 <free_block>
  804b73:	83 c4 10             	add    $0x10,%esp
    return NULL;
  804b76:	b8 00 00 00 00       	mov    $0x0,%eax
  804b7b:	e9 bb 00 00 00       	jmp    804c3b <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  804b80:	83 ec 0c             	sub    $0xc,%esp
  804b83:	ff 75 08             	pushl  0x8(%ebp)
  804b86:	e8 38 f6 ff ff       	call   8041c3 <get_block_size>
  804b8b:	83 c4 10             	add    $0x10,%esp
  804b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  804b91:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  804b9b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804b9e:	73 06                	jae    804ba6 <realloc_block+0x63>
    new_size = min_block_size;
  804ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ba3:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  804ba6:	83 ec 0c             	sub    $0xc,%esp
  804ba9:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804bac:	ff 75 0c             	pushl  0xc(%ebp)
  804baf:	89 c1                	mov    %eax,%ecx
  804bb1:	e8 55 ff ff ff       	call   804b0b <nearest_pow2_ceil.1572>
  804bb6:	83 c4 10             	add    $0x10,%esp
  804bb9:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  804bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bbf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804bc2:	75 05                	jne    804bc9 <realloc_block+0x86>
    return va;
  804bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  804bc7:	eb 72                	jmp    804c3b <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  804bc9:	83 ec 0c             	sub    $0xc,%esp
  804bcc:	ff 75 0c             	pushl  0xc(%ebp)
  804bcf:	e8 57 f6 ff ff       	call   80422b <alloc_block>
  804bd4:	83 c4 10             	add    $0x10,%esp
  804bd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  804bda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804bde:	75 07                	jne    804be7 <realloc_block+0xa4>
    return NULL;
  804be0:	b8 00 00 00 00       	mov    $0x0,%eax
  804be5:	eb 54                	jmp    804c3b <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  804be7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  804bed:	39 d0                	cmp    %edx,%eax
  804bef:	76 02                	jbe    804bf3 <realloc_block+0xb0>
  804bf1:	89 d0                	mov    %edx,%eax
  804bf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  804bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  804bf9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  804bfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  804c02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804c09:	eb 17                	jmp    804c22 <realloc_block+0xdf>
    dst[i] = src[i];
  804c0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c11:	01 c2                	add    %eax,%edx
  804c13:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  804c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c19:	01 c8                	add    %ecx,%eax
  804c1b:	8a 00                	mov    (%eax),%al
  804c1d:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  804c1f:	ff 45 f4             	incl   -0xc(%ebp)
  804c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c25:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804c28:	72 e1                	jb     804c0b <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  804c2a:	83 ec 0c             	sub    $0xc,%esp
  804c2d:	ff 75 08             	pushl  0x8(%ebp)
  804c30:	e8 50 fb ff ff       	call   804785 <free_block>
  804c35:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  804c3b:	c9                   	leave  
  804c3c:	c3                   	ret    
  804c3d:	66 90                	xchg   %ax,%ax
  804c3f:	90                   	nop

00804c40 <__udivdi3>:
  804c40:	55                   	push   %ebp
  804c41:	57                   	push   %edi
  804c42:	56                   	push   %esi
  804c43:	53                   	push   %ebx
  804c44:	83 ec 1c             	sub    $0x1c,%esp
  804c47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804c4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804c4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804c53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804c57:	89 ca                	mov    %ecx,%edx
  804c59:	89 f8                	mov    %edi,%eax
  804c5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804c5f:	85 f6                	test   %esi,%esi
  804c61:	75 2d                	jne    804c90 <__udivdi3+0x50>
  804c63:	39 cf                	cmp    %ecx,%edi
  804c65:	77 65                	ja     804ccc <__udivdi3+0x8c>
  804c67:	89 fd                	mov    %edi,%ebp
  804c69:	85 ff                	test   %edi,%edi
  804c6b:	75 0b                	jne    804c78 <__udivdi3+0x38>
  804c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  804c72:	31 d2                	xor    %edx,%edx
  804c74:	f7 f7                	div    %edi
  804c76:	89 c5                	mov    %eax,%ebp
  804c78:	31 d2                	xor    %edx,%edx
  804c7a:	89 c8                	mov    %ecx,%eax
  804c7c:	f7 f5                	div    %ebp
  804c7e:	89 c1                	mov    %eax,%ecx
  804c80:	89 d8                	mov    %ebx,%eax
  804c82:	f7 f5                	div    %ebp
  804c84:	89 cf                	mov    %ecx,%edi
  804c86:	89 fa                	mov    %edi,%edx
  804c88:	83 c4 1c             	add    $0x1c,%esp
  804c8b:	5b                   	pop    %ebx
  804c8c:	5e                   	pop    %esi
  804c8d:	5f                   	pop    %edi
  804c8e:	5d                   	pop    %ebp
  804c8f:	c3                   	ret    
  804c90:	39 ce                	cmp    %ecx,%esi
  804c92:	77 28                	ja     804cbc <__udivdi3+0x7c>
  804c94:	0f bd fe             	bsr    %esi,%edi
  804c97:	83 f7 1f             	xor    $0x1f,%edi
  804c9a:	75 40                	jne    804cdc <__udivdi3+0x9c>
  804c9c:	39 ce                	cmp    %ecx,%esi
  804c9e:	72 0a                	jb     804caa <__udivdi3+0x6a>
  804ca0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804ca4:	0f 87 9e 00 00 00    	ja     804d48 <__udivdi3+0x108>
  804caa:	b8 01 00 00 00       	mov    $0x1,%eax
  804caf:	89 fa                	mov    %edi,%edx
  804cb1:	83 c4 1c             	add    $0x1c,%esp
  804cb4:	5b                   	pop    %ebx
  804cb5:	5e                   	pop    %esi
  804cb6:	5f                   	pop    %edi
  804cb7:	5d                   	pop    %ebp
  804cb8:	c3                   	ret    
  804cb9:	8d 76 00             	lea    0x0(%esi),%esi
  804cbc:	31 ff                	xor    %edi,%edi
  804cbe:	31 c0                	xor    %eax,%eax
  804cc0:	89 fa                	mov    %edi,%edx
  804cc2:	83 c4 1c             	add    $0x1c,%esp
  804cc5:	5b                   	pop    %ebx
  804cc6:	5e                   	pop    %esi
  804cc7:	5f                   	pop    %edi
  804cc8:	5d                   	pop    %ebp
  804cc9:	c3                   	ret    
  804cca:	66 90                	xchg   %ax,%ax
  804ccc:	89 d8                	mov    %ebx,%eax
  804cce:	f7 f7                	div    %edi
  804cd0:	31 ff                	xor    %edi,%edi
  804cd2:	89 fa                	mov    %edi,%edx
  804cd4:	83 c4 1c             	add    $0x1c,%esp
  804cd7:	5b                   	pop    %ebx
  804cd8:	5e                   	pop    %esi
  804cd9:	5f                   	pop    %edi
  804cda:	5d                   	pop    %ebp
  804cdb:	c3                   	ret    
  804cdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  804ce1:	89 eb                	mov    %ebp,%ebx
  804ce3:	29 fb                	sub    %edi,%ebx
  804ce5:	89 f9                	mov    %edi,%ecx
  804ce7:	d3 e6                	shl    %cl,%esi
  804ce9:	89 c5                	mov    %eax,%ebp
  804ceb:	88 d9                	mov    %bl,%cl
  804ced:	d3 ed                	shr    %cl,%ebp
  804cef:	89 e9                	mov    %ebp,%ecx
  804cf1:	09 f1                	or     %esi,%ecx
  804cf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804cf7:	89 f9                	mov    %edi,%ecx
  804cf9:	d3 e0                	shl    %cl,%eax
  804cfb:	89 c5                	mov    %eax,%ebp
  804cfd:	89 d6                	mov    %edx,%esi
  804cff:	88 d9                	mov    %bl,%cl
  804d01:	d3 ee                	shr    %cl,%esi
  804d03:	89 f9                	mov    %edi,%ecx
  804d05:	d3 e2                	shl    %cl,%edx
  804d07:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d0b:	88 d9                	mov    %bl,%cl
  804d0d:	d3 e8                	shr    %cl,%eax
  804d0f:	09 c2                	or     %eax,%edx
  804d11:	89 d0                	mov    %edx,%eax
  804d13:	89 f2                	mov    %esi,%edx
  804d15:	f7 74 24 0c          	divl   0xc(%esp)
  804d19:	89 d6                	mov    %edx,%esi
  804d1b:	89 c3                	mov    %eax,%ebx
  804d1d:	f7 e5                	mul    %ebp
  804d1f:	39 d6                	cmp    %edx,%esi
  804d21:	72 19                	jb     804d3c <__udivdi3+0xfc>
  804d23:	74 0b                	je     804d30 <__udivdi3+0xf0>
  804d25:	89 d8                	mov    %ebx,%eax
  804d27:	31 ff                	xor    %edi,%edi
  804d29:	e9 58 ff ff ff       	jmp    804c86 <__udivdi3+0x46>
  804d2e:	66 90                	xchg   %ax,%ax
  804d30:	8b 54 24 08          	mov    0x8(%esp),%edx
  804d34:	89 f9                	mov    %edi,%ecx
  804d36:	d3 e2                	shl    %cl,%edx
  804d38:	39 c2                	cmp    %eax,%edx
  804d3a:	73 e9                	jae    804d25 <__udivdi3+0xe5>
  804d3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804d3f:	31 ff                	xor    %edi,%edi
  804d41:	e9 40 ff ff ff       	jmp    804c86 <__udivdi3+0x46>
  804d46:	66 90                	xchg   %ax,%ax
  804d48:	31 c0                	xor    %eax,%eax
  804d4a:	e9 37 ff ff ff       	jmp    804c86 <__udivdi3+0x46>
  804d4f:	90                   	nop

00804d50 <__umoddi3>:
  804d50:	55                   	push   %ebp
  804d51:	57                   	push   %edi
  804d52:	56                   	push   %esi
  804d53:	53                   	push   %ebx
  804d54:	83 ec 1c             	sub    $0x1c,%esp
  804d57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804d5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  804d5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804d63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804d6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804d6f:	89 f3                	mov    %esi,%ebx
  804d71:	89 fa                	mov    %edi,%edx
  804d73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804d77:	89 34 24             	mov    %esi,(%esp)
  804d7a:	85 c0                	test   %eax,%eax
  804d7c:	75 1a                	jne    804d98 <__umoddi3+0x48>
  804d7e:	39 f7                	cmp    %esi,%edi
  804d80:	0f 86 a2 00 00 00    	jbe    804e28 <__umoddi3+0xd8>
  804d86:	89 c8                	mov    %ecx,%eax
  804d88:	89 f2                	mov    %esi,%edx
  804d8a:	f7 f7                	div    %edi
  804d8c:	89 d0                	mov    %edx,%eax
  804d8e:	31 d2                	xor    %edx,%edx
  804d90:	83 c4 1c             	add    $0x1c,%esp
  804d93:	5b                   	pop    %ebx
  804d94:	5e                   	pop    %esi
  804d95:	5f                   	pop    %edi
  804d96:	5d                   	pop    %ebp
  804d97:	c3                   	ret    
  804d98:	39 f0                	cmp    %esi,%eax
  804d9a:	0f 87 ac 00 00 00    	ja     804e4c <__umoddi3+0xfc>
  804da0:	0f bd e8             	bsr    %eax,%ebp
  804da3:	83 f5 1f             	xor    $0x1f,%ebp
  804da6:	0f 84 ac 00 00 00    	je     804e58 <__umoddi3+0x108>
  804dac:	bf 20 00 00 00       	mov    $0x20,%edi
  804db1:	29 ef                	sub    %ebp,%edi
  804db3:	89 fe                	mov    %edi,%esi
  804db5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804db9:	89 e9                	mov    %ebp,%ecx
  804dbb:	d3 e0                	shl    %cl,%eax
  804dbd:	89 d7                	mov    %edx,%edi
  804dbf:	89 f1                	mov    %esi,%ecx
  804dc1:	d3 ef                	shr    %cl,%edi
  804dc3:	09 c7                	or     %eax,%edi
  804dc5:	89 e9                	mov    %ebp,%ecx
  804dc7:	d3 e2                	shl    %cl,%edx
  804dc9:	89 14 24             	mov    %edx,(%esp)
  804dcc:	89 d8                	mov    %ebx,%eax
  804dce:	d3 e0                	shl    %cl,%eax
  804dd0:	89 c2                	mov    %eax,%edx
  804dd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  804dd6:	d3 e0                	shl    %cl,%eax
  804dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  804ddc:	8b 44 24 08          	mov    0x8(%esp),%eax
  804de0:	89 f1                	mov    %esi,%ecx
  804de2:	d3 e8                	shr    %cl,%eax
  804de4:	09 d0                	or     %edx,%eax
  804de6:	d3 eb                	shr    %cl,%ebx
  804de8:	89 da                	mov    %ebx,%edx
  804dea:	f7 f7                	div    %edi
  804dec:	89 d3                	mov    %edx,%ebx
  804dee:	f7 24 24             	mull   (%esp)
  804df1:	89 c6                	mov    %eax,%esi
  804df3:	89 d1                	mov    %edx,%ecx
  804df5:	39 d3                	cmp    %edx,%ebx
  804df7:	0f 82 87 00 00 00    	jb     804e84 <__umoddi3+0x134>
  804dfd:	0f 84 91 00 00 00    	je     804e94 <__umoddi3+0x144>
  804e03:	8b 54 24 04          	mov    0x4(%esp),%edx
  804e07:	29 f2                	sub    %esi,%edx
  804e09:	19 cb                	sbb    %ecx,%ebx
  804e0b:	89 d8                	mov    %ebx,%eax
  804e0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804e11:	d3 e0                	shl    %cl,%eax
  804e13:	89 e9                	mov    %ebp,%ecx
  804e15:	d3 ea                	shr    %cl,%edx
  804e17:	09 d0                	or     %edx,%eax
  804e19:	89 e9                	mov    %ebp,%ecx
  804e1b:	d3 eb                	shr    %cl,%ebx
  804e1d:	89 da                	mov    %ebx,%edx
  804e1f:	83 c4 1c             	add    $0x1c,%esp
  804e22:	5b                   	pop    %ebx
  804e23:	5e                   	pop    %esi
  804e24:	5f                   	pop    %edi
  804e25:	5d                   	pop    %ebp
  804e26:	c3                   	ret    
  804e27:	90                   	nop
  804e28:	89 fd                	mov    %edi,%ebp
  804e2a:	85 ff                	test   %edi,%edi
  804e2c:	75 0b                	jne    804e39 <__umoddi3+0xe9>
  804e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  804e33:	31 d2                	xor    %edx,%edx
  804e35:	f7 f7                	div    %edi
  804e37:	89 c5                	mov    %eax,%ebp
  804e39:	89 f0                	mov    %esi,%eax
  804e3b:	31 d2                	xor    %edx,%edx
  804e3d:	f7 f5                	div    %ebp
  804e3f:	89 c8                	mov    %ecx,%eax
  804e41:	f7 f5                	div    %ebp
  804e43:	89 d0                	mov    %edx,%eax
  804e45:	e9 44 ff ff ff       	jmp    804d8e <__umoddi3+0x3e>
  804e4a:	66 90                	xchg   %ax,%ax
  804e4c:	89 c8                	mov    %ecx,%eax
  804e4e:	89 f2                	mov    %esi,%edx
  804e50:	83 c4 1c             	add    $0x1c,%esp
  804e53:	5b                   	pop    %ebx
  804e54:	5e                   	pop    %esi
  804e55:	5f                   	pop    %edi
  804e56:	5d                   	pop    %ebp
  804e57:	c3                   	ret    
  804e58:	3b 04 24             	cmp    (%esp),%eax
  804e5b:	72 06                	jb     804e63 <__umoddi3+0x113>
  804e5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804e61:	77 0f                	ja     804e72 <__umoddi3+0x122>
  804e63:	89 f2                	mov    %esi,%edx
  804e65:	29 f9                	sub    %edi,%ecx
  804e67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804e6b:	89 14 24             	mov    %edx,(%esp)
  804e6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804e72:	8b 44 24 04          	mov    0x4(%esp),%eax
  804e76:	8b 14 24             	mov    (%esp),%edx
  804e79:	83 c4 1c             	add    $0x1c,%esp
  804e7c:	5b                   	pop    %ebx
  804e7d:	5e                   	pop    %esi
  804e7e:	5f                   	pop    %edi
  804e7f:	5d                   	pop    %ebp
  804e80:	c3                   	ret    
  804e81:	8d 76 00             	lea    0x0(%esi),%esi
  804e84:	2b 04 24             	sub    (%esp),%eax
  804e87:	19 fa                	sbb    %edi,%edx
  804e89:	89 d1                	mov    %edx,%ecx
  804e8b:	89 c6                	mov    %eax,%esi
  804e8d:	e9 71 ff ff ff       	jmp    804e03 <__umoddi3+0xb3>
  804e92:	66 90                	xchg   %ax,%ax
  804e94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804e98:	72 ea                	jb     804e84 <__umoddi3+0x134>
  804e9a:	89 d9                	mov    %ebx,%ecx
  804e9c:	e9 62 ff ff ff       	jmp    804e03 <__umoddi3+0xb3>
