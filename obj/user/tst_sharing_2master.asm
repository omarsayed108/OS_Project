
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 e3 15 00 00       	call   801619 <libmain>
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
  800067:	e8 57 37 00 00       	call   8037c3 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 9a 37 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 1b 30 00 00       	call   8030e2 <malloc>
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
  8000df:	e8 df 36 00 00       	call   8037c3 <sys_calculate_free_frames>
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
  800125:	68 e0 4b 80 00       	push   $0x804be0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 b3 19 00 00       	call   801ae4 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 d5 36 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 5c 4c 80 00       	push   $0x804c5c
  800150:	6a 0c                	push   $0xc
  800152:	e8 8d 19 00 00       	call   801ae4 <cprintf_colored>
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
  800174:	e8 4a 36 00 00       	call   8037c3 <sys_calculate_free_frames>
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
  8001b9:	e8 05 36 00 00       	call   8037c3 <sys_calculate_free_frames>
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
  8001f8:	68 d4 4c 80 00       	push   $0x804cd4
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 e0 18 00 00       	call   801ae4 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 02 36 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 60 4d 80 00       	push   $0x804d60
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 b3 18 00 00       	call   801ae4 <cprintf_colored>
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
  800270:	e8 10 39 00 00       	call   803b85 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 d8 4d 80 00       	push   $0x804dd8
  80028f:	6a 0c                	push   $0xc
  800291:	e8 4e 18 00 00       	call   801ae4 <cprintf_colored>
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
  8002ae:	e8 10 35 00 00       	call   8037c3 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 53 35 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 95 2f 00 00       	call   803266 <free>
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
  8002fc:	e8 0d 35 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 10 4e 80 00       	push   $0x804e10
  800318:	6a 0c                	push   $0xc
  80031a:	e8 c5 17 00 00       	call   801ae4 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 9c 34 00 00       	call   8037c3 <sys_calculate_free_frames>
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
  80035f:	68 5c 4e 80 00       	push   $0x804e5c
  800364:	6a 0c                	push   $0xc
  800366:	e8 79 17 00 00       	call   801ae4 <cprintf_colored>
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
  8003bd:	e8 c3 37 00 00       	call   803b85 <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 b8 4e 80 00       	push   $0x804eb8
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 01 17 00 00       	call   801ae4 <cprintf_colored>
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
  800433:	68 f0 4e 80 00       	push   $0x804ef0
  800438:	6a 03                	push   $0x3
  80043a:	e8 a5 16 00 00       	call   801ae4 <cprintf_colored>
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
  8004fc:	68 20 4f 80 00       	push   $0x804f20
  800501:	6a 0c                	push   $0xc
  800503:	e8 dc 15 00 00       	call   801ae4 <cprintf_colored>
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
  8005d6:	68 20 4f 80 00       	push   $0x804f20
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 02 15 00 00       	call   801ae4 <cprintf_colored>
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
  8006b0:	68 20 4f 80 00       	push   $0x804f20
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 28 14 00 00       	call   801ae4 <cprintf_colored>
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
  80078a:	68 20 4f 80 00       	push   $0x804f20
  80078f:	6a 0c                	push   $0xc
  800791:	e8 4e 13 00 00       	call   801ae4 <cprintf_colored>
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
  800864:	68 20 4f 80 00       	push   $0x804f20
  800869:	6a 0c                	push   $0xc
  80086b:	e8 74 12 00 00       	call   801ae4 <cprintf_colored>
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
  80093e:	68 20 4f 80 00       	push   $0x804f20
  800943:	6a 0c                	push   $0xc
  800945:	e8 9a 11 00 00       	call   801ae4 <cprintf_colored>
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
  800a33:	68 20 4f 80 00       	push   $0x804f20
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 a5 10 00 00       	call   801ae4 <cprintf_colored>
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
  800b31:	68 20 4f 80 00       	push   $0x804f20
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 a7 0f 00 00       	call   801ae4 <cprintf_colored>
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
  800c2f:	68 20 4f 80 00       	push   $0x804f20
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 a9 0e 00 00       	call   801ae4 <cprintf_colored>
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
  800d2d:	68 20 4f 80 00       	push   $0x804f20
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 ab 0d 00 00       	call   801ae4 <cprintf_colored>
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
  800e1a:	68 20 4f 80 00       	push   $0x804f20
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 be 0c 00 00       	call   801ae4 <cprintf_colored>
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
  800f07:	68 20 4f 80 00       	push   $0x804f20
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 d1 0b 00 00       	call   801ae4 <cprintf_colored>
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
  800ff4:	68 20 4f 80 00       	push   $0x804f20
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 e4 0a 00 00       	call   801ae4 <cprintf_colored>
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
  801017:	68 72 4f 80 00       	push   $0x804f72
  80101c:	6a 03                	push   $0x3
  80101e:	e8 c1 0a 00 00       	call   801ae4 <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 87 27 00 00       	call   8037c3 <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 c7 27 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
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
  801072:	e8 6b 20 00 00       	call   8030e2 <malloc>
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
  8010a1:	68 90 4f 80 00       	push   $0x804f90
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 37 0a 00 00       	call   801ae4 <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 59 27 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 cc 4f 80 00       	push   $0x804fcc
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 0b 0a 00 00       	call   801ae4 <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 e2 26 00 00       	call   8037c3 <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 3c 50 80 00       	push   $0x80503c
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 df 09 00 00       	call   801ae4 <cprintf_colored>
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
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
  801121:	83 ec 40             	sub    $0x40,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL BLOCK ALLOCATOR OR USER
	 * BLOCK ALLOCATOR DUE TO DIFFERENT MANAGEMENT OF USER HEAP
	 *********************************************************/
	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	68 84 50 80 00       	push   $0x805084
  80112c:	6a 0e                	push   $0xe
  80112e:	e8 b1 09 00 00       	call   801ae4 <cprintf_colored>
  801133:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801136:	83 ec 08             	sub    $0x8,%esp
  801139:	68 b8 50 80 00       	push   $0x8050b8
  80113e:	6a 0e                	push   $0xe
  801140:	e8 9f 09 00 00       	call   801ae4 <cprintf_colored>
  801145:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	68 14 51 80 00       	push   $0x805114
  801150:	6a 0e                	push   $0xe
  801152:	e8 8d 09 00 00       	call   801ae4 <cprintf_colored>
  801157:	83 c4 10             	add    $0x10,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80115a:	a1 00 72 80 00       	mov    0x807200,%eax
  80115f:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801165:	a1 00 72 80 00       	mov    0x807200,%eax
  80116a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801170:	39 c2                	cmp    %eax,%edx
  801172:	72 14                	jb     801188 <_main+0x6c>
			panic("Please increase the WS size");
  801174:	83 ec 04             	sub    $0x4,%esp
  801177:	68 4a 51 80 00       	push   $0x80514a
  80117c:	6a 18                	push   $0x18
  80117e:	68 66 51 80 00       	push   $0x805166
  801183:	e8 41 06 00 00       	call   8017c9 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  801188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80118f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801196:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;
	int freeFrames, usedDiskPages ;

	//x: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80119d:	e8 21 26 00 00       	call   8037c3 <sys_calculate_free_frames>
  8011a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8011a5:	e8 64 26 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  8011aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	x = smalloc("x", 4, 0);
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 04                	push   $0x4
  8011b4:	68 81 51 80 00       	push   $0x805181
  8011b9:	e8 e4 21 00 00       	call   8033a2 <smalloc>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)pagealloc_start)
  8011c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011c7:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8011ca:	74 19                	je     8011e5 <_main+0xc9>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nCreate(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8011cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	68 84 51 80 00       	push   $0x805184
  8011db:	6a 0c                	push   $0xc
  8011dd:	e8 02 09 00 00       	call   801ae4 <cprintf_colored>
  8011e2:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8011e5:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8011ec:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8011ef:	e8 cf 25 00 00       	call   8037c3 <sys_calculate_free_frames>
  8011f4:	29 c3                	sub    %eax,%ebx
  8011f6:	89 d8                	mov    %ebx,%eax
  8011f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (!inRange(diff, expected, expected + 1 /*KH Block Alloc: 1 page for Share object*/ + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  8011fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011fe:	83 c0 03             	add    $0x3,%eax
  801201:	83 ec 04             	sub    $0x4,%esp
  801204:	50                   	push   %eax
  801205:	ff 75 dc             	pushl  -0x24(%ebp)
  801208:	ff 75 d8             	pushl  -0x28(%ebp)
  80120b:	e8 28 ee ff ff       	call   800038 <inRange>
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 30                	jne    801247 <_main+0x12b>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nWrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +1 +2);}
  801217:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80121e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801221:	8d 58 03             	lea    0x3(%eax),%ebx
  801224:	8b 75 e8             	mov    -0x18(%ebp),%esi
  801227:	e8 97 25 00 00       	call   8037c3 <sys_calculate_free_frames>
  80122c:	29 c6                	sub    %eax,%esi
  80122e:	89 f0                	mov    %esi,%eax
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	53                   	push   %ebx
  801234:	ff 75 dc             	pushl  -0x24(%ebp)
  801237:	50                   	push   %eax
  801238:	68 e8 51 80 00       	push   $0x8051e8
  80123d:	6a 0c                	push   $0xc
  80123f:	e8 a0 08 00 00       	call   801ae4 <cprintf_colored>
  801244:	83 c4 20             	add    $0x20,%esp
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801247:	e8 c2 25 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  80124c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80124f:	74 19                	je     80126a <_main+0x14e>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "Wrong page file allocation: ");}
  801251:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	68 87 52 80 00       	push   $0x805287
  801260:	6a 0c                	push   $0xc
  801262:	e8 7d 08 00 00       	call   801ae4 <cprintf_colored>
  801267:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80126a:	e8 54 25 00 00       	call   8037c3 <sys_calculate_free_frames>
  80126f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  801272:	e8 97 25 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  801277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	y = smalloc("y", 4, 0);
  80127a:	83 ec 04             	sub    $0x4,%esp
  80127d:	6a 00                	push   $0x0
  80127f:	6a 04                	push   $0x4
  801281:	68 a4 52 80 00       	push   $0x8052a4
  801286:	e8 17 21 00 00       	call   8033a2 <smalloc>
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE))
  801291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801294:	05 00 10 00 00       	add    $0x1000,%eax
  801299:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80129c:	74 19                	je     8012b7 <_main+0x19b>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nCreate(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80129e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012a5:	83 ec 08             	sub    $0x8,%esp
  8012a8:	68 84 51 80 00       	push   $0x805184
  8012ad:	6a 0c                	push   $0xc
  8012af:	e8 30 08 00 00       	call   801ae4 <cprintf_colored>
  8012b4:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8012b7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8012be:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8012c1:	e8 fd 24 00 00       	call   8037c3 <sys_calculate_free_frames>
  8012c6:	29 c3                	sub    %eax,%ebx
  8012c8:	89 d8                	mov    %ebx,%eax
  8012ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8012cd:	83 ec 04             	sub    $0x4,%esp
  8012d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8012d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8012d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8012d9:	e8 5a ed ff ff       	call   800038 <inRange>
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	75 26                	jne    80130b <_main+0x1ef>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nWrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8012e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012ec:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8012ef:	e8 cf 24 00 00       	call   8037c3 <sys_calculate_free_frames>
  8012f4:	29 c3                	sub    %eax,%ebx
  8012f6:	89 d8                	mov    %ebx,%eax
  8012f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8012fb:	50                   	push   %eax
  8012fc:	68 a8 52 80 00       	push   $0x8052a8
  801301:	6a 0c                	push   $0xc
  801303:	e8 dc 07 00 00       	call   801ae4 <cprintf_colored>
  801308:	83 c4 10             	add    $0x10,%esp
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  80130b:	e8 fe 24 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  801310:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801313:	74 19                	je     80132e <_main+0x212>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "Wrong page file allocation: ");}
  801315:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	68 87 52 80 00       	push   $0x805287
  801324:	6a 0c                	push   $0xc
  801326:	e8 b9 07 00 00       	call   801ae4 <cprintf_colored>
  80132b:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80132e:	e8 90 24 00 00       	call   8037c3 <sys_calculate_free_frames>
  801333:	89 45 e8             	mov    %eax,-0x18(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  801336:	e8 d3 24 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  80133b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	z = smalloc("z", 4, 1);
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	6a 01                	push   $0x1
  801343:	6a 04                	push   $0x4
  801345:	68 41 53 80 00       	push   $0x805341
  80134a:	e8 53 20 00 00       	call   8033a2 <smalloc>
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nCreate(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  801355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801358:	05 00 20 00 00       	add    $0x2000,%eax
  80135d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801360:	74 19                	je     80137b <_main+0x25f>
  801362:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801369:	83 ec 08             	sub    $0x8,%esp
  80136c:	68 84 51 80 00       	push   $0x805184
  801371:	6a 0c                	push   $0xc
  801373:	e8 6c 07 00 00       	call   801ae4 <cprintf_colored>
  801378:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  80137b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  801382:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  801385:	e8 39 24 00 00       	call   8037c3 <sys_calculate_free_frames>
  80138a:	29 c3                	sub    %eax,%ebx
  80138c:	89 d8                	mov    %ebx,%eax
  80138e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	ff 75 dc             	pushl  -0x24(%ebp)
  801397:	ff 75 dc             	pushl  -0x24(%ebp)
  80139a:	ff 75 d8             	pushl  -0x28(%ebp)
  80139d:	e8 96 ec ff ff       	call   800038 <inRange>
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	75 26                	jne    8013cf <_main+0x2b3>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nWrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8013a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013b0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8013b3:	e8 0b 24 00 00       	call   8037c3 <sys_calculate_free_frames>
  8013b8:	29 c3                	sub    %eax,%ebx
  8013ba:	89 d8                	mov    %ebx,%eax
  8013bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8013bf:	50                   	push   %eax
  8013c0:	68 a8 52 80 00       	push   $0x8052a8
  8013c5:	6a 0c                	push   $0xc
  8013c7:	e8 18 07 00 00       	call   801ae4 <cprintf_colored>
  8013cc:	83 c4 10             	add    $0x10,%esp
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8013cf:	e8 3a 24 00 00       	call   80380e <sys_pf_calculate_allocated_pages>
  8013d4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8013d7:	74 19                	je     8013f2 <_main+0x2d6>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "Wrong page file allocation: ");}
  8013d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	68 87 52 80 00       	push   $0x805287
  8013e8:	6a 0c                	push   $0xc
  8013ea:	e8 f5 06 00 00       	call   801ae4 <cprintf_colored>
  8013ef:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8013f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f6:	74 04                	je     8013fc <_main+0x2e0>
  8013f8:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8013fc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	*x = 10 ;
  801403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801406:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  80140c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80140f:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  801415:	a1 00 72 80 00       	mov    0x807200,%eax
  80141a:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  801420:	a1 00 72 80 00       	mov    0x807200,%eax
  801425:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80142b:	89 c1                	mov    %eax,%ecx
  80142d:	a1 00 72 80 00       	mov    0x807200,%eax
  801432:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801438:	52                   	push   %edx
  801439:	51                   	push   %ecx
  80143a:	50                   	push   %eax
  80143b:	68 43 53 80 00       	push   $0x805343
  801440:	e8 d9 24 00 00       	call   80391e <sys_create_env>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	89 45 cc             	mov    %eax,-0x34(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80144b:	a1 00 72 80 00       	mov    0x807200,%eax
  801450:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  801456:	a1 00 72 80 00       	mov    0x807200,%eax
  80145b:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  801461:	89 c1                	mov    %eax,%ecx
  801463:	a1 00 72 80 00       	mov    0x807200,%eax
  801468:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80146e:	52                   	push   %edx
  80146f:	51                   	push   %ecx
  801470:	50                   	push   %eax
  801471:	68 43 53 80 00       	push   $0x805343
  801476:	e8 a3 24 00 00       	call   80391e <sys_create_env>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801481:	a1 00 72 80 00       	mov    0x807200,%eax
  801486:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  80148c:	a1 00 72 80 00       	mov    0x807200,%eax
  801491:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  801497:	89 c1                	mov    %eax,%ecx
  801499:	a1 00 72 80 00       	mov    0x807200,%eax
  80149e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8014a4:	52                   	push   %edx
  8014a5:	51                   	push   %ecx
  8014a6:	50                   	push   %eax
  8014a7:	68 43 53 80 00       	push   $0x805343
  8014ac:	e8 6d 24 00 00       	call   80391e <sys_create_env>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8014b7:	e8 ae 25 00 00       	call   803a6a <rsttst>

	sys_run_env(id1);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	ff 75 cc             	pushl  -0x34(%ebp)
  8014c2:	e8 75 24 00 00       	call   80393c <sys_run_env>
  8014c7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8014ca:	83 ec 0c             	sub    $0xc,%esp
  8014cd:	ff 75 c8             	pushl  -0x38(%ebp)
  8014d0:	e8 67 24 00 00       	call   80393c <sys_run_env>
  8014d5:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 c4             	pushl  -0x3c(%ebp)
  8014de:	e8 59 24 00 00       	call   80393c <sys_run_env>
  8014e3:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  8014e6:	90                   	nop
  8014e7:	e8 f8 25 00 00       	call   803ae4 <gettst>
  8014ec:	83 f8 03             	cmp    $0x3,%eax
  8014ef:	75 f6                	jne    8014e7 <_main+0x3cb>


	if (*z != 30)
  8014f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	83 f8 1e             	cmp    $0x1e,%eax
  8014f9:	74 19                	je     801514 <_main+0x3f8>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nError!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8014fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801502:	83 ec 08             	sub    $0x8,%esp
  801505:	68 50 53 80 00       	push   $0x805350
  80150a:	6a 0c                	push   $0xc
  80150c:	e8 d3 05 00 00       	call   801ae4 <cprintf_colored>
  801511:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  801514:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801518:	74 04                	je     80151e <_main+0x402>
  80151a:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  80151e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	atomic_cprintf("\n%@Now, attempting to write a ReadOnly variable\n\n\n");
  801525:	83 ec 0c             	sub    $0xc,%esp
  801528:	68 a0 53 80 00       	push   $0x8053a0
  80152d:	e8 f7 05 00 00       	call   801b29 <atomic_cprintf>
  801532:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  801535:	a1 00 72 80 00       	mov    0x807200,%eax
  80153a:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  801540:	a1 00 72 80 00       	mov    0x807200,%eax
  801545:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80154b:	89 c1                	mov    %eax,%ecx
  80154d:	a1 00 72 80 00       	mov    0x807200,%eax
  801552:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801558:	52                   	push   %edx
  801559:	51                   	push   %ecx
  80155a:	50                   	push   %eax
  80155b:	68 d3 53 80 00       	push   $0x8053d3
  801560:	e8 b9 23 00 00       	call   80391e <sys_create_env>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	89 45 cc             	mov    %eax,-0x34(%ebp)

	sys_run_env(id1);
  80156b:	83 ec 0c             	sub    $0xc,%esp
  80156e:	ff 75 cc             	pushl  -0x34(%ebp)
  801571:	e8 c6 23 00 00       	call   80393c <sys_run_env>
  801576:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  801579:	90                   	nop
  80157a:	e8 65 25 00 00       	call   803ae4 <gettst>
  80157f:	83 f8 04             	cmp    $0x4,%eax
  801582:	75 f6                	jne    80157a <_main+0x45e>

	if (*z != 50)
  801584:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801587:	8b 00                	mov    (%eax),%eax
  801589:	83 f8 32             	cmp    $0x32,%eax
  80158c:	74 19                	je     8015a7 <_main+0x48b>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nError!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  80158e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	68 50 53 80 00       	push   $0x805350
  80159d:	6a 0c                	push   $0xc
  80159f:	e8 40 05 00 00       	call   801ae4 <cprintf_colored>
  8015a4:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8015a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ab:	74 04                	je     8015b1 <_main+0x495>
  8015ad:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8015b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Signal slave2
	inctst();
  8015b8:	e8 0d 25 00 00       	call   803aca <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8015bd:	90                   	nop
  8015be:	e8 21 25 00 00       	call   803ae4 <gettst>
  8015c3:	83 f8 06             	cmp    $0x6,%eax
  8015c6:	75 f6                	jne    8015be <_main+0x4a2>

	if (*x != 10)
  8015c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015cb:	8b 00                	mov    (%eax),%eax
  8015cd:	83 f8 0a             	cmp    $0xa,%eax
  8015d0:	74 19                	je     8015eb <_main+0x4cf>
	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "\nError!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8015d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	68 50 53 80 00       	push   $0x805350
  8015e1:	6a 0c                	push   $0xc
  8015e3:	e8 fc 04 00 00       	call   801ae4 <cprintf_colored>
  8015e8:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8015eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ef:	74 04                	je     8015f5 <_main+0x4d9>
  8015f1:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8015f5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf_colored(TEXT_light_green, "\n\n%~Test of Shared Variables [Create & Get] completed. Eval = %d%%\n\n", eval);
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801602:	68 e0 53 80 00       	push   $0x8053e0
  801607:	6a 0a                	push   $0xa
  801609:	e8 d6 04 00 00       	call   801ae4 <cprintf_colored>
  80160e:	83 c4 10             	add    $0x10,%esp
	return;
  801611:	90                   	nop
}
  801612:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801615:	5b                   	pop    %ebx
  801616:	5e                   	pop    %esi
  801617:	5d                   	pop    %ebp
  801618:	c3                   	ret    

00801619 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	57                   	push   %edi
  80161d:	56                   	push   %esi
  80161e:	53                   	push   %ebx
  80161f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801622:	e8 65 23 00 00       	call   80398c <sys_getenvindex>
  801627:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80162a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80162d:	89 d0                	mov    %edx,%eax
  80162f:	01 c0                	add    %eax,%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c1 e0 02             	shl    $0x2,%eax
  801636:	01 d0                	add    %edx,%eax
  801638:	c1 e0 02             	shl    $0x2,%eax
  80163b:	01 d0                	add    %edx,%eax
  80163d:	c1 e0 03             	shl    $0x3,%eax
  801640:	01 d0                	add    %edx,%eax
  801642:	c1 e0 02             	shl    $0x2,%eax
  801645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80164a:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80164f:	a1 00 72 80 00       	mov    0x807200,%eax
  801654:	8a 40 20             	mov    0x20(%eax),%al
  801657:	84 c0                	test   %al,%al
  801659:	74 0d                	je     801668 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80165b:	a1 00 72 80 00       	mov    0x807200,%eax
  801660:	83 c0 20             	add    $0x20,%eax
  801663:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801668:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80166c:	7e 0a                	jle    801678 <libmain+0x5f>
		binaryname = argv[0];
  80166e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801671:	8b 00                	mov    (%eax),%eax
  801673:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	ff 75 08             	pushl  0x8(%ebp)
  801681:	e8 96 fa ff ff       	call   80111c <_main>
  801686:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801689:	a1 00 70 80 00       	mov    0x807000,%eax
  80168e:	85 c0                	test   %eax,%eax
  801690:	0f 84 01 01 00 00    	je     801797 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801696:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80169c:	bb 20 55 80 00       	mov    $0x805520,%ebx
  8016a1:	ba 0e 00 00 00       	mov    $0xe,%edx
  8016a6:	89 c7                	mov    %eax,%edi
  8016a8:	89 de                	mov    %ebx,%esi
  8016aa:	89 d1                	mov    %edx,%ecx
  8016ac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8016ae:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8016b1:	b9 56 00 00 00       	mov    $0x56,%ecx
  8016b6:	b0 00                	mov    $0x0,%al
  8016b8:	89 d7                	mov    %edx,%edi
  8016ba:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8016bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8016c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	50                   	push   %eax
  8016ca:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8016d0:	50                   	push   %eax
  8016d1:	e8 ec 24 00 00       	call   803bc2 <sys_utilities>
  8016d6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8016d9:	e8 35 20 00 00       	call   803713 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8016de:	83 ec 0c             	sub    $0xc,%esp
  8016e1:	68 40 54 80 00       	push   $0x805440
  8016e6:	e8 cc 03 00 00       	call   801ab7 <cprintf>
  8016eb:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8016ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	74 18                	je     80170d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8016f5:	e8 e6 24 00 00       	call   803be0 <sys_get_optimal_num_faults>
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	50                   	push   %eax
  8016fe:	68 68 54 80 00       	push   $0x805468
  801703:	e8 af 03 00 00       	call   801ab7 <cprintf>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	eb 59                	jmp    801766 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80170d:	a1 00 72 80 00       	mov    0x807200,%eax
  801712:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  801718:	a1 00 72 80 00       	mov    0x807200,%eax
  80171d:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	68 8c 54 80 00       	push   $0x80548c
  80172d:	e8 85 03 00 00       	call   801ab7 <cprintf>
  801732:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801735:	a1 00 72 80 00       	mov    0x807200,%eax
  80173a:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  801740:	a1 00 72 80 00       	mov    0x807200,%eax
  801745:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80174b:	a1 00 72 80 00       	mov    0x807200,%eax
  801750:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  801756:	51                   	push   %ecx
  801757:	52                   	push   %edx
  801758:	50                   	push   %eax
  801759:	68 b4 54 80 00       	push   $0x8054b4
  80175e:	e8 54 03 00 00       	call   801ab7 <cprintf>
  801763:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801766:	a1 00 72 80 00       	mov    0x807200,%eax
  80176b:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  801771:	83 ec 08             	sub    $0x8,%esp
  801774:	50                   	push   %eax
  801775:	68 0c 55 80 00       	push   $0x80550c
  80177a:	e8 38 03 00 00       	call   801ab7 <cprintf>
  80177f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	68 40 54 80 00       	push   $0x805440
  80178a:	e8 28 03 00 00       	call   801ab7 <cprintf>
  80178f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801792:	e8 96 1f 00 00       	call   80372d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801797:	e8 1f 00 00 00       	call   8017bb <exit>
}
  80179c:	90                   	nop
  80179d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5f                   	pop    %edi
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    

008017a5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	6a 00                	push   $0x0
  8017b0:	e8 a3 21 00 00       	call   803958 <sys_destroy_env>
  8017b5:	83 c4 10             	add    $0x10,%esp
}
  8017b8:	90                   	nop
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <exit>:

void
exit(void)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8017c1:	e8 f8 21 00 00       	call   8039be <sys_exit_env>
}
  8017c6:	90                   	nop
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d2:	83 c0 04             	add    $0x4,%eax
  8017d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017d8:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	74 16                	je     8017f7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017e1:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	50                   	push   %eax
  8017ea:	68 84 55 80 00       	push   $0x805584
  8017ef:	e8 c3 02 00 00       	call   801ab7 <cprintf>
  8017f4:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017f7:	a1 04 70 80 00       	mov    0x807004,%eax
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	50                   	push   %eax
  801806:	68 8c 55 80 00       	push   $0x80558c
  80180b:	6a 74                	push   $0x74
  80180d:	e8 d2 02 00 00       	call   801ae4 <cprintf_colored>
  801812:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	ff 75 f4             	pushl  -0xc(%ebp)
  80181e:	50                   	push   %eax
  80181f:	e8 24 02 00 00       	call   801a48 <vcprintf>
  801824:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801827:	83 ec 08             	sub    $0x8,%esp
  80182a:	6a 00                	push   $0x0
  80182c:	68 b4 55 80 00       	push   $0x8055b4
  801831:	e8 12 02 00 00       	call   801a48 <vcprintf>
  801836:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801839:	e8 7d ff ff ff       	call   8017bb <exit>

	// should not return here
	while (1) ;
  80183e:	eb fe                	jmp    80183e <_panic+0x75>

00801840 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	53                   	push   %ebx
  801844:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801847:	a1 00 72 80 00       	mov    0x807200,%eax
  80184c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801852:	8b 45 0c             	mov    0xc(%ebp),%eax
  801855:	39 c2                	cmp    %eax,%edx
  801857:	74 14                	je     80186d <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	68 b8 55 80 00       	push   $0x8055b8
  801861:	6a 26                	push   $0x26
  801863:	68 04 56 80 00       	push   $0x805604
  801868:	e8 5c ff ff ff       	call   8017c9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80186d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801874:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80187b:	e9 d9 00 00 00       	jmp    801959 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801883:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	01 d0                	add    %edx,%eax
  80188f:	8b 00                	mov    (%eax),%eax
  801891:	85 c0                	test   %eax,%eax
  801893:	75 08                	jne    80189d <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  801895:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801898:	e9 b9 00 00 00       	jmp    801956 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80189d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018ab:	eb 79                	jmp    801926 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018ad:	a1 00 72 80 00       	mov    0x807200,%eax
  8018b2:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8018b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018bb:	89 d0                	mov    %edx,%eax
  8018bd:	01 c0                	add    %eax,%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8018c8:	01 d8                	add    %ebx,%eax
  8018ca:	01 d0                	add    %edx,%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 40 04             	mov    0x4(%eax),%al
  8018d1:	84 c0                	test   %al,%al
  8018d3:	75 4e                	jne    801923 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018d5:	a1 00 72 80 00       	mov    0x807200,%eax
  8018da:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8018e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e3:	89 d0                	mov    %edx,%eax
  8018e5:	01 c0                	add    %eax,%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8018f0:	01 d8                	add    %ebx,%eax
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	01 c8                	add    %ecx,%eax
  8018f6:	8b 00                	mov    (%eax),%eax
  8018f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801903:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801908:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	01 c8                	add    %ecx,%eax
  801914:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801916:	39 c2                	cmp    %eax,%edx
  801918:	75 09                	jne    801923 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80191a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801921:	eb 19                	jmp    80193c <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801923:	ff 45 e8             	incl   -0x18(%ebp)
  801926:	a1 00 72 80 00       	mov    0x807200,%eax
  80192b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801934:	39 c2                	cmp    %eax,%edx
  801936:	0f 87 71 ff ff ff    	ja     8018ad <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80193c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801940:	75 14                	jne    801956 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	68 10 56 80 00       	push   $0x805610
  80194a:	6a 3a                	push   $0x3a
  80194c:	68 04 56 80 00       	push   $0x805604
  801951:	e8 73 fe ff ff       	call   8017c9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801956:	ff 45 f0             	incl   -0x10(%ebp)
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80195f:	0f 8c 1b ff ff ff    	jl     801880 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801965:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80196c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801973:	eb 2e                	jmp    8019a3 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801975:	a1 00 72 80 00       	mov    0x807200,%eax
  80197a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801980:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801983:	89 d0                	mov    %edx,%eax
  801985:	01 c0                	add    %eax,%eax
  801987:	01 d0                	add    %edx,%eax
  801989:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801990:	01 d8                	add    %ebx,%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	01 c8                	add    %ecx,%eax
  801996:	8a 40 04             	mov    0x4(%eax),%al
  801999:	3c 01                	cmp    $0x1,%al
  80199b:	75 03                	jne    8019a0 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80199d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019a0:	ff 45 e0             	incl   -0x20(%ebp)
  8019a3:	a1 00 72 80 00       	mov    0x807200,%eax
  8019a8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b1:	39 c2                	cmp    %eax,%edx
  8019b3:	77 c0                	ja     801975 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019bb:	74 14                	je     8019d1 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 64 56 80 00       	push   $0x805664
  8019c5:	6a 44                	push   $0x44
  8019c7:	68 04 56 80 00       	push   $0x805604
  8019cc:	e8 f8 fd ff ff       	call   8017c9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019d1:	90                   	nop
  8019d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	53                   	push   %ebx
  8019db:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8019de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e1:	8b 00                	mov    (%eax),%eax
  8019e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	89 0a                	mov    %ecx,(%edx)
  8019eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ee:	88 d1                	mov    %dl,%cl
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8019f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fa:	8b 00                	mov    (%eax),%eax
  8019fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a01:	75 30                	jne    801a33 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801a03:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801a09:	a0 24 72 80 00       	mov    0x807224,%al
  801a0e:	0f b6 c0             	movzbl %al,%eax
  801a11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a14:	8b 09                	mov    (%ecx),%ecx
  801a16:	89 cb                	mov    %ecx,%ebx
  801a18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a1b:	83 c1 08             	add    $0x8,%ecx
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	53                   	push   %ebx
  801a21:	51                   	push   %ecx
  801a22:	e8 a8 1c 00 00       	call   8036cf <sys_cputs>
  801a27:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a36:	8b 40 04             	mov    0x4(%eax),%eax
  801a39:	8d 50 01             	lea    0x1(%eax),%edx
  801a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3f:	89 50 04             	mov    %edx,0x4(%eax)
}
  801a42:	90                   	nop
  801a43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801a51:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a58:	00 00 00 
	b.cnt = 0;
  801a5b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801a62:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a71:	50                   	push   %eax
  801a72:	68 d7 19 80 00       	push   $0x8019d7
  801a77:	e8 5a 02 00 00       	call   801cd6 <vprintfmt>
  801a7c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801a7f:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801a85:	a0 24 72 80 00       	mov    0x807224,%al
  801a8a:	0f b6 c0             	movzbl %al,%eax
  801a8d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801a93:	52                   	push   %edx
  801a94:	50                   	push   %eax
  801a95:	51                   	push   %ecx
  801a96:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a9c:	83 c0 08             	add    $0x8,%eax
  801a9f:	50                   	push   %eax
  801aa0:	e8 2a 1c 00 00       	call   8036cf <sys_cputs>
  801aa5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801aa8:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801aaf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801abd:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  801ac4:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	83 ec 08             	sub    $0x8,%esp
  801ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad3:	50                   	push   %eax
  801ad4:	e8 6f ff ff ff       	call   801a48 <vcprintf>
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801aea:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	c1 e0 08             	shl    $0x8,%eax
  801af7:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801afc:	8d 45 0c             	lea    0xc(%ebp),%eax
  801aff:	83 c0 04             	add    $0x4,%eax
  801b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b08:	83 ec 08             	sub    $0x8,%esp
  801b0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b0e:	50                   	push   %eax
  801b0f:	e8 34 ff ff ff       	call   801a48 <vcprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801b1a:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801b21:	07 00 00 

	return cnt;
  801b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801b2f:	e8 df 1b 00 00       	call   803713 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801b34:	8d 45 0c             	lea    0xc(%ebp),%eax
  801b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	ff 75 f4             	pushl  -0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	e8 ff fe ff ff       	call   801a48 <vcprintf>
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801b4f:	e8 d9 1b 00 00       	call   80372d <sys_unlock_cons>
	return cnt;
  801b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	53                   	push   %ebx
  801b5d:	83 ec 14             	sub    $0x14,%esp
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b66:	8b 45 14             	mov    0x14(%ebp),%eax
  801b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801b6c:	8b 45 18             	mov    0x18(%ebp),%eax
  801b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b74:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b77:	77 55                	ja     801bce <printnum+0x75>
  801b79:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b7c:	72 05                	jb     801b83 <printnum+0x2a>
  801b7e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b81:	77 4b                	ja     801bce <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b83:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801b86:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b89:	8b 45 18             	mov    0x18(%ebp),%eax
  801b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b91:	52                   	push   %edx
  801b92:	50                   	push   %eax
  801b93:	ff 75 f4             	pushl  -0xc(%ebp)
  801b96:	ff 75 f0             	pushl  -0x10(%ebp)
  801b99:	e8 d2 2d 00 00       	call   804970 <__udivdi3>
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	ff 75 20             	pushl  0x20(%ebp)
  801ba7:	53                   	push   %ebx
  801ba8:	ff 75 18             	pushl  0x18(%ebp)
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	ff 75 08             	pushl  0x8(%ebp)
  801bb3:	e8 a1 ff ff ff       	call   801b59 <printnum>
  801bb8:	83 c4 20             	add    $0x20,%esp
  801bbb:	eb 1a                	jmp    801bd7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801bbd:	83 ec 08             	sub    $0x8,%esp
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	ff 75 20             	pushl  0x20(%ebp)
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	ff d0                	call   *%eax
  801bcb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801bce:	ff 4d 1c             	decl   0x1c(%ebp)
  801bd1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801bd5:	7f e6                	jg     801bbd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801bd7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801bda:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be5:	53                   	push   %ebx
  801be6:	51                   	push   %ecx
  801be7:	52                   	push   %edx
  801be8:	50                   	push   %eax
  801be9:	e8 92 2e 00 00       	call   804a80 <__umoddi3>
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	05 d4 58 80 00       	add    $0x8058d4,%eax
  801bf6:	8a 00                	mov    (%eax),%al
  801bf8:	0f be c0             	movsbl %al,%eax
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	50                   	push   %eax
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	ff d0                	call   *%eax
  801c07:	83 c4 10             	add    $0x10,%esp
}
  801c0a:	90                   	nop
  801c0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c17:	7e 1c                	jle    801c35 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8b 00                	mov    (%eax),%eax
  801c1e:	8d 50 08             	lea    0x8(%eax),%edx
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	89 10                	mov    %edx,(%eax)
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	8b 00                	mov    (%eax),%eax
  801c2b:	83 e8 08             	sub    $0x8,%eax
  801c2e:	8b 50 04             	mov    0x4(%eax),%edx
  801c31:	8b 00                	mov    (%eax),%eax
  801c33:	eb 40                	jmp    801c75 <getuint+0x65>
	else if (lflag)
  801c35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c39:	74 1e                	je     801c59 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	8b 00                	mov    (%eax),%eax
  801c40:	8d 50 04             	lea    0x4(%eax),%edx
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	89 10                	mov    %edx,(%eax)
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	8b 00                	mov    (%eax),%eax
  801c4d:	83 e8 04             	sub    $0x4,%eax
  801c50:	8b 00                	mov    (%eax),%eax
  801c52:	ba 00 00 00 00       	mov    $0x0,%edx
  801c57:	eb 1c                	jmp    801c75 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8b 00                	mov    (%eax),%eax
  801c5e:	8d 50 04             	lea    0x4(%eax),%edx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	89 10                	mov    %edx,(%eax)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8b 00                	mov    (%eax),%eax
  801c6b:	83 e8 04             	sub    $0x4,%eax
  801c6e:	8b 00                	mov    (%eax),%eax
  801c70:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c75:	5d                   	pop    %ebp
  801c76:	c3                   	ret    

00801c77 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c7a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c7e:	7e 1c                	jle    801c9c <getint+0x25>
		return va_arg(*ap, long long);
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 50 08             	lea    0x8(%eax),%edx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	89 10                	mov    %edx,(%eax)
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	8b 00                	mov    (%eax),%eax
  801c92:	83 e8 08             	sub    $0x8,%eax
  801c95:	8b 50 04             	mov    0x4(%eax),%edx
  801c98:	8b 00                	mov    (%eax),%eax
  801c9a:	eb 38                	jmp    801cd4 <getint+0x5d>
	else if (lflag)
  801c9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ca0:	74 1a                	je     801cbc <getint+0x45>
		return va_arg(*ap, long);
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	8b 00                	mov    (%eax),%eax
  801ca7:	8d 50 04             	lea    0x4(%eax),%edx
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	89 10                	mov    %edx,(%eax)
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8b 00                	mov    (%eax),%eax
  801cb4:	83 e8 04             	sub    $0x4,%eax
  801cb7:	8b 00                	mov    (%eax),%eax
  801cb9:	99                   	cltd   
  801cba:	eb 18                	jmp    801cd4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	8b 00                	mov    (%eax),%eax
  801cc1:	8d 50 04             	lea    0x4(%eax),%edx
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	89 10                	mov    %edx,(%eax)
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8b 00                	mov    (%eax),%eax
  801cce:	83 e8 04             	sub    $0x4,%eax
  801cd1:	8b 00                	mov    (%eax),%eax
  801cd3:	99                   	cltd   
}
  801cd4:	5d                   	pop    %ebp
  801cd5:	c3                   	ret    

00801cd6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	56                   	push   %esi
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801cde:	eb 17                	jmp    801cf7 <vprintfmt+0x21>
			if (ch == '\0')
  801ce0:	85 db                	test   %ebx,%ebx
  801ce2:	0f 84 c1 03 00 00    	je     8020a9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801ce8:	83 ec 08             	sub    $0x8,%esp
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	53                   	push   %ebx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	ff d0                	call   *%eax
  801cf4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfa:	8d 50 01             	lea    0x1(%eax),%edx
  801cfd:	89 55 10             	mov    %edx,0x10(%ebp)
  801d00:	8a 00                	mov    (%eax),%al
  801d02:	0f b6 d8             	movzbl %al,%ebx
  801d05:	83 fb 25             	cmp    $0x25,%ebx
  801d08:	75 d6                	jne    801ce0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801d0a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801d0e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801d15:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801d23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2d:	8d 50 01             	lea    0x1(%eax),%edx
  801d30:	89 55 10             	mov    %edx,0x10(%ebp)
  801d33:	8a 00                	mov    (%eax),%al
  801d35:	0f b6 d8             	movzbl %al,%ebx
  801d38:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801d3b:	83 f8 5b             	cmp    $0x5b,%eax
  801d3e:	0f 87 3d 03 00 00    	ja     802081 <vprintfmt+0x3ab>
  801d44:	8b 04 85 f8 58 80 00 	mov    0x8058f8(,%eax,4),%eax
  801d4b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801d4d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801d51:	eb d7                	jmp    801d2a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801d53:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801d57:	eb d1                	jmp    801d2a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801d60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d63:	89 d0                	mov    %edx,%eax
  801d65:	c1 e0 02             	shl    $0x2,%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	01 c0                	add    %eax,%eax
  801d6c:	01 d8                	add    %ebx,%eax
  801d6e:	83 e8 30             	sub    $0x30,%eax
  801d71:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801d74:	8b 45 10             	mov    0x10(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801d7c:	83 fb 2f             	cmp    $0x2f,%ebx
  801d7f:	7e 3e                	jle    801dbf <vprintfmt+0xe9>
  801d81:	83 fb 39             	cmp    $0x39,%ebx
  801d84:	7f 39                	jg     801dbf <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d86:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d89:	eb d5                	jmp    801d60 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8e:	83 c0 04             	add    $0x4,%eax
  801d91:	89 45 14             	mov    %eax,0x14(%ebp)
  801d94:	8b 45 14             	mov    0x14(%ebp),%eax
  801d97:	83 e8 04             	sub    $0x4,%eax
  801d9a:	8b 00                	mov    (%eax),%eax
  801d9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d9f:	eb 1f                	jmp    801dc0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801da1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801da5:	79 83                	jns    801d2a <vprintfmt+0x54>
				width = 0;
  801da7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801dae:	e9 77 ff ff ff       	jmp    801d2a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801db3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801dba:	e9 6b ff ff ff       	jmp    801d2a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801dbf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801dc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dc4:	0f 89 60 ff ff ff    	jns    801d2a <vprintfmt+0x54>
				width = precision, precision = -1;
  801dca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801dd7:	e9 4e ff ff ff       	jmp    801d2a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ddc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ddf:	e9 46 ff ff ff       	jmp    801d2a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	83 c0 04             	add    $0x4,%eax
  801dea:	89 45 14             	mov    %eax,0x14(%ebp)
  801ded:	8b 45 14             	mov    0x14(%ebp),%eax
  801df0:	83 e8 04             	sub    $0x4,%eax
  801df3:	8b 00                	mov    (%eax),%eax
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	50                   	push   %eax
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	ff d0                	call   *%eax
  801e01:	83 c4 10             	add    $0x10,%esp
			break;
  801e04:	e9 9b 02 00 00       	jmp    8020a4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801e09:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0c:	83 c0 04             	add    $0x4,%eax
  801e0f:	89 45 14             	mov    %eax,0x14(%ebp)
  801e12:	8b 45 14             	mov    0x14(%ebp),%eax
  801e15:	83 e8 04             	sub    $0x4,%eax
  801e18:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801e1a:	85 db                	test   %ebx,%ebx
  801e1c:	79 02                	jns    801e20 <vprintfmt+0x14a>
				err = -err;
  801e1e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801e20:	83 fb 64             	cmp    $0x64,%ebx
  801e23:	7f 0b                	jg     801e30 <vprintfmt+0x15a>
  801e25:	8b 34 9d 40 57 80 00 	mov    0x805740(,%ebx,4),%esi
  801e2c:	85 f6                	test   %esi,%esi
  801e2e:	75 19                	jne    801e49 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801e30:	53                   	push   %ebx
  801e31:	68 e5 58 80 00       	push   $0x8058e5
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	e8 70 02 00 00       	call   8020b1 <printfmt>
  801e41:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801e44:	e9 5b 02 00 00       	jmp    8020a4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801e49:	56                   	push   %esi
  801e4a:	68 ee 58 80 00       	push   $0x8058ee
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	e8 57 02 00 00       	call   8020b1 <printfmt>
  801e5a:	83 c4 10             	add    $0x10,%esp
			break;
  801e5d:	e9 42 02 00 00       	jmp    8020a4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801e62:	8b 45 14             	mov    0x14(%ebp),%eax
  801e65:	83 c0 04             	add    $0x4,%eax
  801e68:	89 45 14             	mov    %eax,0x14(%ebp)
  801e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6e:	83 e8 04             	sub    $0x4,%eax
  801e71:	8b 30                	mov    (%eax),%esi
  801e73:	85 f6                	test   %esi,%esi
  801e75:	75 05                	jne    801e7c <vprintfmt+0x1a6>
				p = "(null)";
  801e77:	be f1 58 80 00       	mov    $0x8058f1,%esi
			if (width > 0 && padc != '-')
  801e7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e80:	7e 6d                	jle    801eef <vprintfmt+0x219>
  801e82:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801e86:	74 67                	je     801eef <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e8b:	83 ec 08             	sub    $0x8,%esp
  801e8e:	50                   	push   %eax
  801e8f:	56                   	push   %esi
  801e90:	e8 1e 03 00 00       	call   8021b3 <strnlen>
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e9b:	eb 16                	jmp    801eb3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e9d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801ea1:	83 ec 08             	sub    $0x8,%esp
  801ea4:	ff 75 0c             	pushl  0xc(%ebp)
  801ea7:	50                   	push   %eax
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	ff d0                	call   *%eax
  801ead:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801eb0:	ff 4d e4             	decl   -0x1c(%ebp)
  801eb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801eb7:	7f e4                	jg     801e9d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801eb9:	eb 34                	jmp    801eef <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801ebb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ebf:	74 1c                	je     801edd <vprintfmt+0x207>
  801ec1:	83 fb 1f             	cmp    $0x1f,%ebx
  801ec4:	7e 05                	jle    801ecb <vprintfmt+0x1f5>
  801ec6:	83 fb 7e             	cmp    $0x7e,%ebx
  801ec9:	7e 12                	jle    801edd <vprintfmt+0x207>
					putch('?', putdat);
  801ecb:	83 ec 08             	sub    $0x8,%esp
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	6a 3f                	push   $0x3f
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	ff d0                	call   *%eax
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	eb 0f                	jmp    801eec <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801edd:	83 ec 08             	sub    $0x8,%esp
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	53                   	push   %ebx
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	ff d0                	call   *%eax
  801ee9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801eec:	ff 4d e4             	decl   -0x1c(%ebp)
  801eef:	89 f0                	mov    %esi,%eax
  801ef1:	8d 70 01             	lea    0x1(%eax),%esi
  801ef4:	8a 00                	mov    (%eax),%al
  801ef6:	0f be d8             	movsbl %al,%ebx
  801ef9:	85 db                	test   %ebx,%ebx
  801efb:	74 24                	je     801f21 <vprintfmt+0x24b>
  801efd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f01:	78 b8                	js     801ebb <vprintfmt+0x1e5>
  801f03:	ff 4d e0             	decl   -0x20(%ebp)
  801f06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f0a:	79 af                	jns    801ebb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801f0c:	eb 13                	jmp    801f21 <vprintfmt+0x24b>
				putch(' ', putdat);
  801f0e:	83 ec 08             	sub    $0x8,%esp
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	6a 20                	push   $0x20
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	ff d0                	call   *%eax
  801f1b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801f1e:	ff 4d e4             	decl   -0x1c(%ebp)
  801f21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f25:	7f e7                	jg     801f0e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801f27:	e9 78 01 00 00       	jmp    8020a4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801f2c:	83 ec 08             	sub    $0x8,%esp
  801f2f:	ff 75 e8             	pushl  -0x18(%ebp)
  801f32:	8d 45 14             	lea    0x14(%ebp),%eax
  801f35:	50                   	push   %eax
  801f36:	e8 3c fd ff ff       	call   801c77 <getint>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4a:	85 d2                	test   %edx,%edx
  801f4c:	79 23                	jns    801f71 <vprintfmt+0x29b>
				putch('-', putdat);
  801f4e:	83 ec 08             	sub    $0x8,%esp
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	6a 2d                	push   $0x2d
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	ff d0                	call   *%eax
  801f5b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f64:	f7 d8                	neg    %eax
  801f66:	83 d2 00             	adc    $0x0,%edx
  801f69:	f7 da                	neg    %edx
  801f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801f71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f78:	e9 bc 00 00 00       	jmp    802039 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801f7d:	83 ec 08             	sub    $0x8,%esp
  801f80:	ff 75 e8             	pushl  -0x18(%ebp)
  801f83:	8d 45 14             	lea    0x14(%ebp),%eax
  801f86:	50                   	push   %eax
  801f87:	e8 84 fc ff ff       	call   801c10 <getuint>
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f9c:	e9 98 00 00 00       	jmp    802039 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801fa1:	83 ec 08             	sub    $0x8,%esp
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	6a 58                	push   $0x58
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	ff d0                	call   *%eax
  801fae:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801fb1:	83 ec 08             	sub    $0x8,%esp
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	6a 58                	push   $0x58
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	ff d0                	call   *%eax
  801fbe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	6a 58                	push   $0x58
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	ff d0                	call   *%eax
  801fce:	83 c4 10             	add    $0x10,%esp
			break;
  801fd1:	e9 ce 00 00 00       	jmp    8020a4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801fd6:	83 ec 08             	sub    $0x8,%esp
  801fd9:	ff 75 0c             	pushl  0xc(%ebp)
  801fdc:	6a 30                	push   $0x30
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	ff d0                	call   *%eax
  801fe3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801fe6:	83 ec 08             	sub    $0x8,%esp
  801fe9:	ff 75 0c             	pushl  0xc(%ebp)
  801fec:	6a 78                	push   $0x78
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	ff d0                	call   *%eax
  801ff3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff9:	83 c0 04             	add    $0x4,%eax
  801ffc:	89 45 14             	mov    %eax,0x14(%ebp)
  801fff:	8b 45 14             	mov    0x14(%ebp),%eax
  802002:	83 e8 04             	sub    $0x4,%eax
  802005:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802007:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80200a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  802011:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802018:	eb 1f                	jmp    802039 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80201a:	83 ec 08             	sub    $0x8,%esp
  80201d:	ff 75 e8             	pushl  -0x18(%ebp)
  802020:	8d 45 14             	lea    0x14(%ebp),%eax
  802023:	50                   	push   %eax
  802024:	e8 e7 fb ff ff       	call   801c10 <getuint>
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80202f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802032:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802039:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80203d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	52                   	push   %edx
  802044:	ff 75 e4             	pushl  -0x1c(%ebp)
  802047:	50                   	push   %eax
  802048:	ff 75 f4             	pushl  -0xc(%ebp)
  80204b:	ff 75 f0             	pushl  -0x10(%ebp)
  80204e:	ff 75 0c             	pushl  0xc(%ebp)
  802051:	ff 75 08             	pushl  0x8(%ebp)
  802054:	e8 00 fb ff ff       	call   801b59 <printnum>
  802059:	83 c4 20             	add    $0x20,%esp
			break;
  80205c:	eb 46                	jmp    8020a4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80205e:	83 ec 08             	sub    $0x8,%esp
  802061:	ff 75 0c             	pushl  0xc(%ebp)
  802064:	53                   	push   %ebx
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	ff d0                	call   *%eax
  80206a:	83 c4 10             	add    $0x10,%esp
			break;
  80206d:	eb 35                	jmp    8020a4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80206f:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  802076:	eb 2c                	jmp    8020a4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  802078:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  80207f:	eb 23                	jmp    8020a4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802081:	83 ec 08             	sub    $0x8,%esp
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	6a 25                	push   $0x25
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	ff d0                	call   *%eax
  80208e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802091:	ff 4d 10             	decl   0x10(%ebp)
  802094:	eb 03                	jmp    802099 <vprintfmt+0x3c3>
  802096:	ff 4d 10             	decl   0x10(%ebp)
  802099:	8b 45 10             	mov    0x10(%ebp),%eax
  80209c:	48                   	dec    %eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	3c 25                	cmp    $0x25,%al
  8020a1:	75 f3                	jne    802096 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8020a3:	90                   	nop
		}
	}
  8020a4:	e9 35 fc ff ff       	jmp    801cde <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8020a9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8020aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5e                   	pop    %esi
  8020af:	5d                   	pop    %ebp
  8020b0:	c3                   	ret    

008020b1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8020b7:	8d 45 10             	lea    0x10(%ebp),%eax
  8020ba:	83 c0 04             	add    $0x4,%eax
  8020bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8020c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c6:	50                   	push   %eax
  8020c7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ca:	ff 75 08             	pushl  0x8(%ebp)
  8020cd:	e8 04 fc ff ff       	call   801cd6 <vprintfmt>
  8020d2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8020d5:	90                   	nop
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8020db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	8d 50 01             	lea    0x1(%eax),%edx
  8020e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8020ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ed:	8b 10                	mov    (%eax),%edx
  8020ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f2:	8b 40 04             	mov    0x4(%eax),%eax
  8020f5:	39 c2                	cmp    %eax,%edx
  8020f7:	73 12                	jae    80210b <sprintputch+0x33>
		*b->buf++ = ch;
  8020f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	8d 48 01             	lea    0x1(%eax),%ecx
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	89 0a                	mov    %ecx,(%edx)
  802106:	8b 55 08             	mov    0x8(%ebp),%edx
  802109:	88 10                	mov    %dl,(%eax)
}
  80210b:	90                   	nop
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    

0080210e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80211a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	01 d0                	add    %edx,%eax
  802125:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80212f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802133:	74 06                	je     80213b <vsnprintf+0x2d>
  802135:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802139:	7f 07                	jg     802142 <vsnprintf+0x34>
		return -E_INVAL;
  80213b:	b8 03 00 00 00       	mov    $0x3,%eax
  802140:	eb 20                	jmp    802162 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802142:	ff 75 14             	pushl  0x14(%ebp)
  802145:	ff 75 10             	pushl  0x10(%ebp)
  802148:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80214b:	50                   	push   %eax
  80214c:	68 d8 20 80 00       	push   $0x8020d8
  802151:	e8 80 fb ff ff       	call   801cd6 <vprintfmt>
  802156:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80216a:	8d 45 10             	lea    0x10(%ebp),%eax
  80216d:	83 c0 04             	add    $0x4,%eax
  802170:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802173:	8b 45 10             	mov    0x10(%ebp),%eax
  802176:	ff 75 f4             	pushl  -0xc(%ebp)
  802179:	50                   	push   %eax
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	ff 75 08             	pushl  0x8(%ebp)
  802180:	e8 89 ff ff ff       	call   80210e <vsnprintf>
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80218b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80219d:	eb 06                	jmp    8021a5 <strlen+0x15>
		n++;
  80219f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8021a2:	ff 45 08             	incl   0x8(%ebp)
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	8a 00                	mov    (%eax),%al
  8021aa:	84 c0                	test   %al,%al
  8021ac:	75 f1                	jne    80219f <strlen+0xf>
		n++;
	return n;
  8021ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8021b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021c0:	eb 09                	jmp    8021cb <strnlen+0x18>
		n++;
  8021c2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8021c5:	ff 45 08             	incl   0x8(%ebp)
  8021c8:	ff 4d 0c             	decl   0xc(%ebp)
  8021cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021cf:	74 09                	je     8021da <strnlen+0x27>
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8a 00                	mov    (%eax),%al
  8021d6:	84 c0                	test   %al,%al
  8021d8:	75 e8                	jne    8021c2 <strnlen+0xf>
		n++;
	return n;
  8021da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8021eb:	90                   	nop
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8d 50 01             	lea    0x1(%eax),%edx
  8021f2:	89 55 08             	mov    %edx,0x8(%ebp)
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021fb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021fe:	8a 12                	mov    (%edx),%dl
  802200:	88 10                	mov    %dl,(%eax)
  802202:	8a 00                	mov    (%eax),%al
  802204:	84 c0                	test   %al,%al
  802206:	75 e4                	jne    8021ec <strcpy+0xd>
		/* do nothing */;
	return ret;
  802208:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802219:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802220:	eb 1f                	jmp    802241 <strncpy+0x34>
		*dst++ = *src;
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	8d 50 01             	lea    0x1(%eax),%edx
  802228:	89 55 08             	mov    %edx,0x8(%ebp)
  80222b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222e:	8a 12                	mov    (%edx),%dl
  802230:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802232:	8b 45 0c             	mov    0xc(%ebp),%eax
  802235:	8a 00                	mov    (%eax),%al
  802237:	84 c0                	test   %al,%al
  802239:	74 03                	je     80223e <strncpy+0x31>
			src++;
  80223b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80223e:	ff 45 fc             	incl   -0x4(%ebp)
  802241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802244:	3b 45 10             	cmp    0x10(%ebp),%eax
  802247:	72 d9                	jb     802222 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802249:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80225a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80225e:	74 30                	je     802290 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802260:	eb 16                	jmp    802278 <strlcpy+0x2a>
			*dst++ = *src++;
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	8d 50 01             	lea    0x1(%eax),%edx
  802268:	89 55 08             	mov    %edx,0x8(%ebp)
  80226b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802271:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802274:	8a 12                	mov    (%edx),%dl
  802276:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802278:	ff 4d 10             	decl   0x10(%ebp)
  80227b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80227f:	74 09                	je     80228a <strlcpy+0x3c>
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	8a 00                	mov    (%eax),%al
  802286:	84 c0                	test   %al,%al
  802288:	75 d8                	jne    802262 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802290:	8b 55 08             	mov    0x8(%ebp),%edx
  802293:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802296:	29 c2                	sub    %eax,%edx
  802298:	89 d0                	mov    %edx,%eax
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80229f:	eb 06                	jmp    8022a7 <strcmp+0xb>
		p++, q++;
  8022a1:	ff 45 08             	incl   0x8(%ebp)
  8022a4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	8a 00                	mov    (%eax),%al
  8022ac:	84 c0                	test   %al,%al
  8022ae:	74 0e                	je     8022be <strcmp+0x22>
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	8a 10                	mov    (%eax),%dl
  8022b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b8:	8a 00                	mov    (%eax),%al
  8022ba:	38 c2                	cmp    %al,%dl
  8022bc:	74 e3                	je     8022a1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	8a 00                	mov    (%eax),%al
  8022c3:	0f b6 d0             	movzbl %al,%edx
  8022c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c9:	8a 00                	mov    (%eax),%al
  8022cb:	0f b6 c0             	movzbl %al,%eax
  8022ce:	29 c2                	sub    %eax,%edx
  8022d0:	89 d0                	mov    %edx,%eax
}
  8022d2:	5d                   	pop    %ebp
  8022d3:	c3                   	ret    

008022d4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8022d7:	eb 09                	jmp    8022e2 <strncmp+0xe>
		n--, p++, q++;
  8022d9:	ff 4d 10             	decl   0x10(%ebp)
  8022dc:	ff 45 08             	incl   0x8(%ebp)
  8022df:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8022e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022e6:	74 17                	je     8022ff <strncmp+0x2b>
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	8a 00                	mov    (%eax),%al
  8022ed:	84 c0                	test   %al,%al
  8022ef:	74 0e                	je     8022ff <strncmp+0x2b>
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8a 10                	mov    (%eax),%dl
  8022f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f9:	8a 00                	mov    (%eax),%al
  8022fb:	38 c2                	cmp    %al,%dl
  8022fd:	74 da                	je     8022d9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8022ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802303:	75 07                	jne    80230c <strncmp+0x38>
		return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
  80230a:	eb 14                	jmp    802320 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8a 00                	mov    (%eax),%al
  802311:	0f b6 d0             	movzbl %al,%edx
  802314:	8b 45 0c             	mov    0xc(%ebp),%eax
  802317:	8a 00                	mov    (%eax),%al
  802319:	0f b6 c0             	movzbl %al,%eax
  80231c:	29 c2                	sub    %eax,%edx
  80231e:	89 d0                	mov    %edx,%eax
}
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    

00802322 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80232e:	eb 12                	jmp    802342 <strchr+0x20>
		if (*s == c)
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	8a 00                	mov    (%eax),%al
  802335:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802338:	75 05                	jne    80233f <strchr+0x1d>
			return (char *) s;
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	eb 11                	jmp    802350 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80233f:	ff 45 08             	incl   0x8(%ebp)
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	8a 00                	mov    (%eax),%al
  802347:	84 c0                	test   %al,%al
  802349:	75 e5                	jne    802330 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80235e:	eb 0d                	jmp    80236d <strfind+0x1b>
		if (*s == c)
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8a 00                	mov    (%eax),%al
  802365:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802368:	74 0e                	je     802378 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80236a:	ff 45 08             	incl   0x8(%ebp)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8a 00                	mov    (%eax),%al
  802372:	84 c0                	test   %al,%al
  802374:	75 ea                	jne    802360 <strfind+0xe>
  802376:	eb 01                	jmp    802379 <strfind+0x27>
		if (*s == c)
			break;
  802378:	90                   	nop
	return (char *) s;
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80238a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80238e:	76 63                	jbe    8023f3 <memset+0x75>
		uint64 data_block = c;
  802390:	8b 45 0c             	mov    0xc(%ebp),%eax
  802393:	99                   	cltd   
  802394:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802397:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80239a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8023a4:	c1 e0 08             	shl    $0x8,%eax
  8023a7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8023aa:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8023b7:	c1 e0 10             	shl    $0x10,%eax
  8023ba:	09 45 f0             	or     %eax,-0x10(%ebp)
  8023bd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c6:	89 c2                	mov    %eax,%edx
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cd:	09 45 f0             	or     %eax,-0x10(%ebp)
  8023d0:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8023d3:	eb 18                	jmp    8023ed <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8023d5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8023d8:	8d 41 08             	lea    0x8(%ecx),%eax
  8023db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e4:	89 01                	mov    %eax,(%ecx)
  8023e6:	89 51 04             	mov    %edx,0x4(%ecx)
  8023e9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8023ed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023f1:	77 e2                	ja     8023d5 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8023f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f7:	74 23                	je     80241c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8023f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8023ff:	eb 0e                	jmp    80240f <memset+0x91>
			*p8++ = (uint8)c;
  802401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802404:	8d 50 01             	lea    0x1(%eax),%edx
  802407:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80240a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80240f:	8b 45 10             	mov    0x10(%ebp),%eax
  802412:	8d 50 ff             	lea    -0x1(%eax),%edx
  802415:	89 55 10             	mov    %edx,0x10(%ebp)
  802418:	85 c0                	test   %eax,%eax
  80241a:	75 e5                	jne    802401 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  802427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  802433:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802437:	76 24                	jbe    80245d <memcpy+0x3c>
		while(n >= 8){
  802439:	eb 1c                	jmp    802457 <memcpy+0x36>
			*d64 = *s64;
  80243b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80243e:	8b 50 04             	mov    0x4(%eax),%edx
  802441:	8b 00                	mov    (%eax),%eax
  802443:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802446:	89 01                	mov    %eax,(%ecx)
  802448:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80244b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80244f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802453:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802457:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80245b:	77 de                	ja     80243b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80245d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802461:	74 31                	je     802494 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802463:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802469:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80246c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80246f:	eb 16                	jmp    802487 <memcpy+0x66>
			*d8++ = *s8++;
  802471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802474:	8d 50 01             	lea    0x1(%eax),%edx
  802477:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80247a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247d:	8d 4a 01             	lea    0x1(%edx),%ecx
  802480:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802483:	8a 12                	mov    (%edx),%dl
  802485:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802487:	8b 45 10             	mov    0x10(%ebp),%eax
  80248a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80248d:	89 55 10             	mov    %edx,0x10(%ebp)
  802490:	85 c0                	test   %eax,%eax
  802492:	75 dd                	jne    802471 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80249f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8024ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024b1:	73 50                	jae    802503 <memmove+0x6a>
  8024b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024be:	76 43                	jbe    802503 <memmove+0x6a>
		s += n;
  8024c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8024c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8024cc:	eb 10                	jmp    8024de <memmove+0x45>
			*--d = *--s;
  8024ce:	ff 4d f8             	decl   -0x8(%ebp)
  8024d1:	ff 4d fc             	decl   -0x4(%ebp)
  8024d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d7:	8a 10                	mov    (%eax),%dl
  8024d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024dc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8024de:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	75 e3                	jne    8024ce <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8024eb:	eb 23                	jmp    802510 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8024ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024f0:	8d 50 01             	lea    0x1(%eax),%edx
  8024f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024fc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024ff:	8a 12                	mov    (%edx),%dl
  802501:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802503:	8b 45 10             	mov    0x10(%ebp),%eax
  802506:	8d 50 ff             	lea    -0x1(%eax),%edx
  802509:	89 55 10             	mov    %edx,0x10(%ebp)
  80250c:	85 c0                	test   %eax,%eax
  80250e:	75 dd                	jne    8024ed <memmove+0x54>
			*d++ = *s++;

	return dst;
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802521:	8b 45 0c             	mov    0xc(%ebp),%eax
  802524:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802527:	eb 2a                	jmp    802553 <memcmp+0x3e>
		if (*s1 != *s2)
  802529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252c:	8a 10                	mov    (%eax),%dl
  80252e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802531:	8a 00                	mov    (%eax),%al
  802533:	38 c2                	cmp    %al,%dl
  802535:	74 16                	je     80254d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802537:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253a:	8a 00                	mov    (%eax),%al
  80253c:	0f b6 d0             	movzbl %al,%edx
  80253f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802542:	8a 00                	mov    (%eax),%al
  802544:	0f b6 c0             	movzbl %al,%eax
  802547:	29 c2                	sub    %eax,%edx
  802549:	89 d0                	mov    %edx,%eax
  80254b:	eb 18                	jmp    802565 <memcmp+0x50>
		s1++, s2++;
  80254d:	ff 45 fc             	incl   -0x4(%ebp)
  802550:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802553:	8b 45 10             	mov    0x10(%ebp),%eax
  802556:	8d 50 ff             	lea    -0x1(%eax),%edx
  802559:	89 55 10             	mov    %edx,0x10(%ebp)
  80255c:	85 c0                	test   %eax,%eax
  80255e:	75 c9                	jne    802529 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80256d:	8b 55 08             	mov    0x8(%ebp),%edx
  802570:	8b 45 10             	mov    0x10(%ebp),%eax
  802573:	01 d0                	add    %edx,%eax
  802575:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802578:	eb 15                	jmp    80258f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	8a 00                	mov    (%eax),%al
  80257f:	0f b6 d0             	movzbl %al,%edx
  802582:	8b 45 0c             	mov    0xc(%ebp),%eax
  802585:	0f b6 c0             	movzbl %al,%eax
  802588:	39 c2                	cmp    %eax,%edx
  80258a:	74 0d                	je     802599 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80258c:	ff 45 08             	incl   0x8(%ebp)
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802595:	72 e3                	jb     80257a <memfind+0x13>
  802597:	eb 01                	jmp    80259a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802599:	90                   	nop
	return (void *) s;
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8025a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8025ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025b3:	eb 03                	jmp    8025b8 <strtol+0x19>
		s++;
  8025b5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	8a 00                	mov    (%eax),%al
  8025bd:	3c 20                	cmp    $0x20,%al
  8025bf:	74 f4                	je     8025b5 <strtol+0x16>
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	8a 00                	mov    (%eax),%al
  8025c6:	3c 09                	cmp    $0x9,%al
  8025c8:	74 eb                	je     8025b5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	8a 00                	mov    (%eax),%al
  8025cf:	3c 2b                	cmp    $0x2b,%al
  8025d1:	75 05                	jne    8025d8 <strtol+0x39>
		s++;
  8025d3:	ff 45 08             	incl   0x8(%ebp)
  8025d6:	eb 13                	jmp    8025eb <strtol+0x4c>
	else if (*s == '-')
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	8a 00                	mov    (%eax),%al
  8025dd:	3c 2d                	cmp    $0x2d,%al
  8025df:	75 0a                	jne    8025eb <strtol+0x4c>
		s++, neg = 1;
  8025e1:	ff 45 08             	incl   0x8(%ebp)
  8025e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025ef:	74 06                	je     8025f7 <strtol+0x58>
  8025f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8025f5:	75 20                	jne    802617 <strtol+0x78>
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	8a 00                	mov    (%eax),%al
  8025fc:	3c 30                	cmp    $0x30,%al
  8025fe:	75 17                	jne    802617 <strtol+0x78>
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	40                   	inc    %eax
  802604:	8a 00                	mov    (%eax),%al
  802606:	3c 78                	cmp    $0x78,%al
  802608:	75 0d                	jne    802617 <strtol+0x78>
		s += 2, base = 16;
  80260a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80260e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802615:	eb 28                	jmp    80263f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80261b:	75 15                	jne    802632 <strtol+0x93>
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	8a 00                	mov    (%eax),%al
  802622:	3c 30                	cmp    $0x30,%al
  802624:	75 0c                	jne    802632 <strtol+0x93>
		s++, base = 8;
  802626:	ff 45 08             	incl   0x8(%ebp)
  802629:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802630:	eb 0d                	jmp    80263f <strtol+0xa0>
	else if (base == 0)
  802632:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802636:	75 07                	jne    80263f <strtol+0xa0>
		base = 10;
  802638:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	8a 00                	mov    (%eax),%al
  802644:	3c 2f                	cmp    $0x2f,%al
  802646:	7e 19                	jle    802661 <strtol+0xc2>
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	8a 00                	mov    (%eax),%al
  80264d:	3c 39                	cmp    $0x39,%al
  80264f:	7f 10                	jg     802661 <strtol+0xc2>
			dig = *s - '0';
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	8a 00                	mov    (%eax),%al
  802656:	0f be c0             	movsbl %al,%eax
  802659:	83 e8 30             	sub    $0x30,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265f:	eb 42                	jmp    8026a3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	8a 00                	mov    (%eax),%al
  802666:	3c 60                	cmp    $0x60,%al
  802668:	7e 19                	jle    802683 <strtol+0xe4>
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	8a 00                	mov    (%eax),%al
  80266f:	3c 7a                	cmp    $0x7a,%al
  802671:	7f 10                	jg     802683 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	8a 00                	mov    (%eax),%al
  802678:	0f be c0             	movsbl %al,%eax
  80267b:	83 e8 57             	sub    $0x57,%eax
  80267e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802681:	eb 20                	jmp    8026a3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	8a 00                	mov    (%eax),%al
  802688:	3c 40                	cmp    $0x40,%al
  80268a:	7e 39                	jle    8026c5 <strtol+0x126>
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	8a 00                	mov    (%eax),%al
  802691:	3c 5a                	cmp    $0x5a,%al
  802693:	7f 30                	jg     8026c5 <strtol+0x126>
			dig = *s - 'A' + 10;
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	8a 00                	mov    (%eax),%al
  80269a:	0f be c0             	movsbl %al,%eax
  80269d:	83 e8 37             	sub    $0x37,%eax
  8026a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8026a9:	7d 19                	jge    8026c4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8026ab:	ff 45 08             	incl   0x8(%ebp)
  8026ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026b1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8026b5:	89 c2                	mov    %eax,%edx
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	01 d0                	add    %edx,%eax
  8026bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8026bf:	e9 7b ff ff ff       	jmp    80263f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8026c4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8026c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026c9:	74 08                	je     8026d3 <strtol+0x134>
		*endptr = (char *) s;
  8026cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8026d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026d7:	74 07                	je     8026e0 <strtol+0x141>
  8026d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026dc:	f7 d8                	neg    %eax
  8026de:	eb 03                	jmp    8026e3 <strtol+0x144>
  8026e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <ltostr>:

void
ltostr(long value, char *str)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8026eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8026f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8026f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026fd:	79 13                	jns    802712 <ltostr+0x2d>
	{
		neg = 1;
  8026ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802706:	8b 45 0c             	mov    0xc(%ebp),%eax
  802709:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80270c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80270f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80271a:	99                   	cltd   
  80271b:	f7 f9                	idiv   %ecx
  80271d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802720:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802723:	8d 50 01             	lea    0x1(%eax),%edx
  802726:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802729:	89 c2                	mov    %eax,%edx
  80272b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272e:	01 d0                	add    %edx,%eax
  802730:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802733:	83 c2 30             	add    $0x30,%edx
  802736:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802738:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80273b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802740:	f7 e9                	imul   %ecx
  802742:	c1 fa 02             	sar    $0x2,%edx
  802745:	89 c8                	mov    %ecx,%eax
  802747:	c1 f8 1f             	sar    $0x1f,%eax
  80274a:	29 c2                	sub    %eax,%edx
  80274c:	89 d0                	mov    %edx,%eax
  80274e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802751:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802755:	75 bb                	jne    802712 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80275e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802761:	48                   	dec    %eax
  802762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802765:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802769:	74 3d                	je     8027a8 <ltostr+0xc3>
		start = 1 ;
  80276b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802772:	eb 34                	jmp    8027a8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277a:	01 d0                	add    %edx,%eax
  80277c:	8a 00                	mov    (%eax),%al
  80277e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802781:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802784:	8b 45 0c             	mov    0xc(%ebp),%eax
  802787:	01 c2                	add    %eax,%edx
  802789:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80278c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278f:	01 c8                	add    %ecx,%eax
  802791:	8a 00                	mov    (%eax),%al
  802793:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802795:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279b:	01 c2                	add    %eax,%edx
  80279d:	8a 45 eb             	mov    -0x15(%ebp),%al
  8027a0:	88 02                	mov    %al,(%edx)
		start++ ;
  8027a2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8027a5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027ae:	7c c4                	jl     802774 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8027b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8027b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8027bb:	90                   	nop
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8027c4:	ff 75 08             	pushl  0x8(%ebp)
  8027c7:	e8 c4 f9 ff ff       	call   802190 <strlen>
  8027cc:	83 c4 04             	add    $0x4,%esp
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8027d2:	ff 75 0c             	pushl  0xc(%ebp)
  8027d5:	e8 b6 f9 ff ff       	call   802190 <strlen>
  8027da:	83 c4 04             	add    $0x4,%esp
  8027dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8027e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8027e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8027ee:	eb 17                	jmp    802807 <strcconcat+0x49>
		final[s] = str1[s] ;
  8027f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f6:	01 c2                	add    %eax,%edx
  8027f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	01 c8                	add    %ecx,%eax
  802800:	8a 00                	mov    (%eax),%al
  802802:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802804:	ff 45 fc             	incl   -0x4(%ebp)
  802807:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80280a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80280d:	7c e1                	jl     8027f0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80280f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802816:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80281d:	eb 1f                	jmp    80283e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80281f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802822:	8d 50 01             	lea    0x1(%eax),%edx
  802825:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802828:	89 c2                	mov    %eax,%edx
  80282a:	8b 45 10             	mov    0x10(%ebp),%eax
  80282d:	01 c2                	add    %eax,%edx
  80282f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802832:	8b 45 0c             	mov    0xc(%ebp),%eax
  802835:	01 c8                	add    %ecx,%eax
  802837:	8a 00                	mov    (%eax),%al
  802839:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80283b:	ff 45 f8             	incl   -0x8(%ebp)
  80283e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802841:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802844:	7c d9                	jl     80281f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802846:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802849:	8b 45 10             	mov    0x10(%ebp),%eax
  80284c:	01 d0                	add    %edx,%eax
  80284e:	c6 00 00             	movb   $0x0,(%eax)
}
  802851:	90                   	nop
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802857:	8b 45 14             	mov    0x14(%ebp),%eax
  80285a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802860:	8b 45 14             	mov    0x14(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80286c:	8b 45 10             	mov    0x10(%ebp),%eax
  80286f:	01 d0                	add    %edx,%eax
  802871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802877:	eb 0c                	jmp    802885 <strsplit+0x31>
			*string++ = 0;
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	8d 50 01             	lea    0x1(%eax),%edx
  80287f:	89 55 08             	mov    %edx,0x8(%ebp)
  802882:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	8a 00                	mov    (%eax),%al
  80288a:	84 c0                	test   %al,%al
  80288c:	74 18                	je     8028a6 <strsplit+0x52>
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	8a 00                	mov    (%eax),%al
  802893:	0f be c0             	movsbl %al,%eax
  802896:	50                   	push   %eax
  802897:	ff 75 0c             	pushl  0xc(%ebp)
  80289a:	e8 83 fa ff ff       	call   802322 <strchr>
  80289f:	83 c4 08             	add    $0x8,%esp
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	75 d3                	jne    802879 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	8a 00                	mov    (%eax),%al
  8028ab:	84 c0                	test   %al,%al
  8028ad:	74 5a                	je     802909 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8028af:	8b 45 14             	mov    0x14(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	83 f8 0f             	cmp    $0xf,%eax
  8028b7:	75 07                	jne    8028c0 <strsplit+0x6c>
		{
			return 0;
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	eb 66                	jmp    802926 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8028c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8028c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8028cb:	89 0a                	mov    %ecx,(%edx)
  8028cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d7:	01 c2                	add    %eax,%edx
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8028de:	eb 03                	jmp    8028e3 <strsplit+0x8f>
			string++;
  8028e0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	8a 00                	mov    (%eax),%al
  8028e8:	84 c0                	test   %al,%al
  8028ea:	74 8b                	je     802877 <strsplit+0x23>
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	8a 00                	mov    (%eax),%al
  8028f1:	0f be c0             	movsbl %al,%eax
  8028f4:	50                   	push   %eax
  8028f5:	ff 75 0c             	pushl  0xc(%ebp)
  8028f8:	e8 25 fa ff ff       	call   802322 <strchr>
  8028fd:	83 c4 08             	add    $0x8,%esp
  802900:	85 c0                	test   %eax,%eax
  802902:	74 dc                	je     8028e0 <strsplit+0x8c>
			string++;
	}
  802904:	e9 6e ff ff ff       	jmp    802877 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802909:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80290a:	8b 45 14             	mov    0x14(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802916:	8b 45 10             	mov    0x10(%ebp),%eax
  802919:	01 d0                	add    %edx,%eax
  80291b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802921:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802926:	c9                   	leave  
  802927:	c3                   	ret    

00802928 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
  80292b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802934:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80293b:	eb 4a                	jmp    802987 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80293d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	01 c2                	add    %eax,%edx
  802945:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294b:	01 c8                	add    %ecx,%eax
  80294d:	8a 00                	mov    (%eax),%al
  80294f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802951:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802954:	8b 45 0c             	mov    0xc(%ebp),%eax
  802957:	01 d0                	add    %edx,%eax
  802959:	8a 00                	mov    (%eax),%al
  80295b:	3c 40                	cmp    $0x40,%al
  80295d:	7e 25                	jle    802984 <str2lower+0x5c>
  80295f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802962:	8b 45 0c             	mov    0xc(%ebp),%eax
  802965:	01 d0                	add    %edx,%eax
  802967:	8a 00                	mov    (%eax),%al
  802969:	3c 5a                	cmp    $0x5a,%al
  80296b:	7f 17                	jg     802984 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80296d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	01 d0                	add    %edx,%eax
  802975:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802978:	8b 55 08             	mov    0x8(%ebp),%edx
  80297b:	01 ca                	add    %ecx,%edx
  80297d:	8a 12                	mov    (%edx),%dl
  80297f:	83 c2 20             	add    $0x20,%edx
  802982:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802984:	ff 45 fc             	incl   -0x4(%ebp)
  802987:	ff 75 0c             	pushl  0xc(%ebp)
  80298a:	e8 01 f8 ff ff       	call   802190 <strlen>
  80298f:	83 c4 04             	add    $0x4,%esp
  802992:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802995:	7f a6                	jg     80293d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802997:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8029a2:	83 ec 0c             	sub    $0xc,%esp
  8029a5:	6a 10                	push   $0x10
  8029a7:	e8 b2 15 00 00       	call   803f5e <alloc_block>
  8029ac:	83 c4 10             	add    $0x10,%esp
  8029af:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8029b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029b6:	75 14                	jne    8029cc <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8029b8:	83 ec 04             	sub    $0x4,%esp
  8029bb:	68 68 5a 80 00       	push   $0x805a68
  8029c0:	6a 14                	push   $0x14
  8029c2:	68 91 5a 80 00       	push   $0x805a91
  8029c7:	e8 fd ed ff ff       	call   8017c9 <_panic>

	node->start = start;
  8029cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d2:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8029dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8029e4:	a1 04 72 80 00       	mov    0x807204,%eax
  8029e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ec:	eb 18                	jmp    802a06 <insert_page_alloc+0x6a>
		if (start < it->start)
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f6:	77 37                	ja     802a2f <insert_page_alloc+0x93>
			break;
		prev = it;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8029fe:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0a:	74 08                	je     802a14 <insert_page_alloc+0x78>
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 40 08             	mov    0x8(%eax),%eax
  802a12:	eb 05                	jmp    802a19 <insert_page_alloc+0x7d>
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
  802a19:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802a1e:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	75 c7                	jne    8029ee <insert_page_alloc+0x52>
  802a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2b:	75 c1                	jne    8029ee <insert_page_alloc+0x52>
  802a2d:	eb 01                	jmp    802a30 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  802a2f:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  802a30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a34:	75 64                	jne    802a9a <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  802a36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a3a:	75 14                	jne    802a50 <insert_page_alloc+0xb4>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 a0 5a 80 00       	push   $0x805aa0
  802a44:	6a 21                	push   $0x21
  802a46:	68 91 5a 80 00       	push   $0x805a91
  802a4b:	e8 79 ed ff ff       	call   8017c9 <_panic>
  802a50:	8b 15 04 72 80 00    	mov    0x807204,%edx
  802a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a59:	89 50 08             	mov    %edx,0x8(%eax)
  802a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5f:	8b 40 08             	mov    0x8(%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	74 0d                	je     802a73 <insert_page_alloc+0xd7>
  802a66:	a1 04 72 80 00       	mov    0x807204,%eax
  802a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a6e:	89 50 0c             	mov    %edx,0xc(%eax)
  802a71:	eb 08                	jmp    802a7b <insert_page_alloc+0xdf>
  802a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a76:	a3 08 72 80 00       	mov    %eax,0x807208
  802a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7e:	a3 04 72 80 00       	mov    %eax,0x807204
  802a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a86:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a8d:	a1 10 72 80 00       	mov    0x807210,%eax
  802a92:	40                   	inc    %eax
  802a93:	a3 10 72 80 00       	mov    %eax,0x807210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  802a98:	eb 71                	jmp    802b0b <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802a9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a9e:	74 06                	je     802aa6 <insert_page_alloc+0x10a>
  802aa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa4:	75 14                	jne    802aba <insert_page_alloc+0x11e>
  802aa6:	83 ec 04             	sub    $0x4,%esp
  802aa9:	68 c4 5a 80 00       	push   $0x805ac4
  802aae:	6a 23                	push   $0x23
  802ab0:	68 91 5a 80 00       	push   $0x805a91
  802ab5:	e8 0f ed ff ff       	call   8017c9 <_panic>
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	8b 50 08             	mov    0x8(%eax),%edx
  802ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac3:	89 50 08             	mov    %edx,0x8(%eax)
  802ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac9:	8b 40 08             	mov    0x8(%eax),%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	74 0c                	je     802adc <insert_page_alloc+0x140>
  802ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad3:	8b 40 08             	mov    0x8(%eax),%eax
  802ad6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad9:	89 50 0c             	mov    %edx,0xc(%eax)
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae2:	89 50 08             	mov    %edx,0x8(%eax)
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aeb:	89 50 0c             	mov    %edx,0xc(%eax)
  802aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af1:	8b 40 08             	mov    0x8(%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	75 08                	jne    802b00 <insert_page_alloc+0x164>
  802af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afb:	a3 08 72 80 00       	mov    %eax,0x807208
  802b00:	a1 10 72 80 00       	mov    0x807210,%eax
  802b05:	40                   	inc    %eax
  802b06:	a3 10 72 80 00       	mov    %eax,0x807210
}
  802b0b:	90                   	nop
  802b0c:	c9                   	leave  
  802b0d:	c3                   	ret    

00802b0e <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  802b0e:	55                   	push   %ebp
  802b0f:	89 e5                	mov    %esp,%ebp
  802b11:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  802b14:	a1 04 72 80 00       	mov    0x807204,%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	75 0c                	jne    802b29 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  802b1d:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802b22:	a3 50 f2 81 00       	mov    %eax,0x81f250
		return;
  802b27:	eb 67                	jmp    802b90 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  802b29:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b31:	a1 04 72 80 00       	mov    0x807204,%eax
  802b36:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802b39:	eb 26                	jmp    802b61 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  802b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b3e:	8b 10                	mov    (%eax),%edx
  802b40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	01 d0                	add    %edx,%eax
  802b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802b51:	76 06                	jbe    802b59 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b59:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802b5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802b61:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802b65:	74 08                	je     802b6f <recompute_page_alloc_break+0x61>
  802b67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b6a:	8b 40 08             	mov    0x8(%eax),%eax
  802b6d:	eb 05                	jmp    802b74 <recompute_page_alloc_break+0x66>
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802b79:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	75 b9                	jne    802b3b <recompute_page_alloc_break+0x2d>
  802b82:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802b86:	75 b3                	jne    802b3b <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  802b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b8b:	a3 50 f2 81 00       	mov    %eax,0x81f250
}
  802b90:	c9                   	leave  
  802b91:	c3                   	ret    

00802b92 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  802b92:	55                   	push   %ebp
  802b93:	89 e5                	mov    %esp,%ebp
  802b95:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  802b98:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ba5:	01 d0                	add    %edx,%eax
  802ba7:	48                   	dec    %eax
  802ba8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802bab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bae:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb3:	f7 75 d8             	divl   -0x28(%ebp)
  802bb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bb9:	29 d0                	sub    %edx,%eax
  802bbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  802bbe:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802bc2:	75 0a                	jne    802bce <alloc_pages_custom_fit+0x3c>
		return NULL;
  802bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc9:	e9 7e 01 00 00       	jmp    802d4c <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  802bce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  802bd5:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802bd9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  802be0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  802be7:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802bec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802bef:	a1 04 72 80 00       	mov    0x807204,%eax
  802bf4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802bf7:	eb 69                	jmp    802c62 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802bf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c01:	76 47                	jbe    802c4a <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  802c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c06:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  802c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c11:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  802c14:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c17:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802c1a:	72 2e                	jb     802c4a <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  802c1c:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802c20:	75 14                	jne    802c36 <alloc_pages_custom_fit+0xa4>
  802c22:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c25:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802c28:	75 0c                	jne    802c36 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  802c2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  802c30:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802c34:	eb 14                	jmp    802c4a <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802c36:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c39:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c3c:	76 0c                	jbe    802c4a <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802c3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c41:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  802c44:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c47:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4d:	8b 10                	mov    (%eax),%edx
  802c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	01 d0                	add    %edx,%eax
  802c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802c5a:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802c5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802c62:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c66:	74 08                	je     802c70 <alloc_pages_custom_fit+0xde>
  802c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6b:	8b 40 08             	mov    0x8(%eax),%eax
  802c6e:	eb 05                	jmp    802c75 <alloc_pages_custom_fit+0xe3>
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
  802c75:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802c7a:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	0f 85 72 ff ff ff    	jne    802bf9 <alloc_pages_custom_fit+0x67>
  802c87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c8b:	0f 85 68 ff ff ff    	jne    802bf9 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802c91:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802c96:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c99:	76 47                	jbe    802ce2 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802c9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802ca1:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802ca6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802ca9:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802cac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802caf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802cb2:	72 2e                	jb     802ce2 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802cb4:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802cb8:	75 14                	jne    802cce <alloc_pages_custom_fit+0x13c>
  802cba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cbd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802cc0:	75 0c                	jne    802cce <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802cc2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802cc8:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802ccc:	eb 14                	jmp    802ce2 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802cce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cd1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802cd4:	76 0c                	jbe    802ce2 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802cd6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802cdc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802ce2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802ce9:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802ced:	74 08                	je     802cf7 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802cf5:	eb 40                	jmp    802d37 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802cf7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cfb:	74 08                	je     802d05 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d00:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d03:	eb 32                	jmp    802d37 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802d05:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802d0a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802d0d:	89 c2                	mov    %eax,%edx
  802d0f:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802d14:	39 c2                	cmp    %eax,%edx
  802d16:	73 07                	jae    802d1f <alloc_pages_custom_fit+0x18d>
			return NULL;
  802d18:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1d:	eb 2d                	jmp    802d4c <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802d1f:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802d24:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802d27:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802d2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d30:	01 d0                	add    %edx,%eax
  802d32:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}


	insert_page_alloc((uint32)result, required_size);
  802d37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d3a:	83 ec 08             	sub    $0x8,%esp
  802d3d:	ff 75 d0             	pushl  -0x30(%ebp)
  802d40:	50                   	push   %eax
  802d41:	e8 56 fc ff ff       	call   80299c <insert_page_alloc>
  802d46:	83 c4 10             	add    $0x10,%esp

	return result;
  802d49:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802d4c:	c9                   	leave  
  802d4d:	c3                   	ret    

00802d4e <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802d4e:	55                   	push   %ebp
  802d4f:	89 e5                	mov    %esp,%ebp
  802d51:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802d5a:	a1 04 72 80 00       	mov    0x807204,%eax
  802d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d62:	eb 1a                	jmp    802d7e <find_allocated_size+0x30>
		if (it->start == va)
  802d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802d6c:	75 08                	jne    802d76 <find_allocated_size+0x28>
			return it->size;
  802d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d71:	8b 40 04             	mov    0x4(%eax),%eax
  802d74:	eb 34                	jmp    802daa <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802d76:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d82:	74 08                	je     802d8c <find_allocated_size+0x3e>
  802d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	eb 05                	jmp    802d91 <find_allocated_size+0x43>
  802d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d91:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802d96:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	75 c5                	jne    802d64 <find_allocated_size+0x16>
  802d9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802da3:	75 bf                	jne    802d64 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802daa:	c9                   	leave  
  802dab:	c3                   	ret    

00802dac <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802dac:	55                   	push   %ebp
  802dad:	89 e5                	mov    %esp,%ebp
  802daf:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802db8:	a1 04 72 80 00       	mov    0x807204,%eax
  802dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc0:	e9 e1 01 00 00       	jmp    802fa6 <free_pages+0x1fa>
		if (it->start == va) {
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802dcd:	0f 85 cb 01 00 00    	jne    802f9e <free_pages+0x1f2>

			uint32 start = it->start;
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de7:	f7 d0                	not    %eax
  802de9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802dec:	73 1d                	jae    802e0b <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802dee:	83 ec 0c             	sub    $0xc,%esp
  802df1:	ff 75 e4             	pushl  -0x1c(%ebp)
  802df4:	ff 75 e8             	pushl  -0x18(%ebp)
  802df7:	68 f8 5a 80 00       	push   $0x805af8
  802dfc:	68 a5 00 00 00       	push   $0xa5
  802e01:	68 91 5a 80 00       	push   $0x805a91
  802e06:	e8 be e9 ff ff       	call   8017c9 <_panic>
			}

			uint32 start_end = start + size;
  802e0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e11:	01 d0                	add    %edx,%eax
  802e13:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802e16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	79 19                	jns    802e36 <free_pages+0x8a>
  802e1d:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802e24:	77 10                	ja     802e36 <free_pages+0x8a>
  802e26:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802e2d:	77 07                	ja     802e36 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e32:	85 c0                	test   %eax,%eax
  802e34:	78 2c                	js     802e62 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802e36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e39:	83 ec 0c             	sub    $0xc,%esp
  802e3c:	68 00 00 00 a0       	push   $0xa0000000
  802e41:	ff 75 e0             	pushl  -0x20(%ebp)
  802e44:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e47:	ff 75 e8             	pushl  -0x18(%ebp)
  802e4a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e4d:	50                   	push   %eax
  802e4e:	68 3c 5b 80 00       	push   $0x805b3c
  802e53:	68 ad 00 00 00       	push   $0xad
  802e58:	68 91 5a 80 00       	push   $0x805a91
  802e5d:	e8 67 e9 ff ff       	call   8017c9 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802e62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e68:	e9 88 00 00 00       	jmp    802ef5 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802e6d:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802e74:	76 17                	jbe    802e8d <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802e76:	ff 75 f0             	pushl  -0x10(%ebp)
  802e79:	68 a0 5b 80 00       	push   $0x805ba0
  802e7e:	68 b4 00 00 00       	push   $0xb4
  802e83:	68 91 5a 80 00       	push   $0x805a91
  802e88:	e8 3c e9 ff ff       	call   8017c9 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e90:	05 00 10 00 00       	add    $0x1000,%eax
  802e95:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	79 2e                	jns    802ecd <free_pages+0x121>
  802e9f:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802ea6:	77 25                	ja     802ecd <free_pages+0x121>
  802ea8:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802eaf:	77 1c                	ja     802ecd <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802eb1:	83 ec 08             	sub    $0x8,%esp
  802eb4:	68 00 10 00 00       	push   $0x1000
  802eb9:	ff 75 f0             	pushl  -0x10(%ebp)
  802ebc:	e8 38 0d 00 00       	call   803bf9 <sys_free_user_mem>
  802ec1:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802ec4:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802ecb:	eb 28                	jmp    802ef5 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed0:	68 00 00 00 a0       	push   $0xa0000000
  802ed5:	ff 75 dc             	pushl  -0x24(%ebp)
  802ed8:	68 00 10 00 00       	push   $0x1000
  802edd:	ff 75 f0             	pushl  -0x10(%ebp)
  802ee0:	50                   	push   %eax
  802ee1:	68 e0 5b 80 00       	push   $0x805be0
  802ee6:	68 bd 00 00 00       	push   $0xbd
  802eeb:	68 91 5a 80 00       	push   $0x805a91
  802ef0:	e8 d4 e8 ff ff       	call   8017c9 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802efb:	0f 82 6c ff ff ff    	jb     802e6d <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802f01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f05:	75 17                	jne    802f1e <free_pages+0x172>
  802f07:	83 ec 04             	sub    $0x4,%esp
  802f0a:	68 42 5c 80 00       	push   $0x805c42
  802f0f:	68 c1 00 00 00       	push   $0xc1
  802f14:	68 91 5a 80 00       	push   $0x805a91
  802f19:	e8 ab e8 ff ff       	call   8017c9 <_panic>
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 40 08             	mov    0x8(%eax),%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	74 11                	je     802f39 <free_pages+0x18d>
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 40 08             	mov    0x8(%eax),%eax
  802f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f31:	8b 52 0c             	mov    0xc(%edx),%edx
  802f34:	89 50 0c             	mov    %edx,0xc(%eax)
  802f37:	eb 0b                	jmp    802f44 <free_pages+0x198>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3f:	a3 08 72 80 00       	mov    %eax,0x807208
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 11                	je     802f5f <free_pages+0x1b3>
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 0c             	mov    0xc(%eax),%eax
  802f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f57:	8b 52 08             	mov    0x8(%edx),%edx
  802f5a:	89 50 08             	mov    %edx,0x8(%eax)
  802f5d:	eb 0b                	jmp    802f6a <free_pages+0x1be>
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 40 08             	mov    0x8(%eax),%eax
  802f65:	a3 04 72 80 00       	mov    %eax,0x807204
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f7e:	a1 10 72 80 00       	mov    0x807210,%eax
  802f83:	48                   	dec    %eax
  802f84:	a3 10 72 80 00       	mov    %eax,0x807210
			free_block(it);
  802f89:	83 ec 0c             	sub    $0xc,%esp
  802f8c:	ff 75 f4             	pushl  -0xc(%ebp)
  802f8f:	e8 24 15 00 00       	call   8044b8 <free_block>
  802f94:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802f97:	e8 72 fb ff ff       	call   802b0e <recompute_page_alloc_break>

			return;
  802f9c:	eb 37                	jmp    802fd5 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802f9e:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802faa:	74 08                	je     802fb4 <free_pages+0x208>
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 40 08             	mov    0x8(%eax),%eax
  802fb2:	eb 05                	jmp    802fb9 <free_pages+0x20d>
  802fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb9:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802fbe:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	0f 85 fa fd ff ff    	jne    802dc5 <free_pages+0x19>
  802fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcf:	0f 85 f0 fd ff ff    	jne    802dc5 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802fd5:	c9                   	leave  
  802fd6:	c3                   	ret    

00802fd7 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802fda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fdf:	5d                   	pop    %ebp
  802fe0:	c3                   	ret    

00802fe1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802fe1:	55                   	push   %ebp
  802fe2:	89 e5                	mov    %esp,%ebp
  802fe4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802fe7:	a1 08 70 80 00       	mov    0x807008,%eax
  802fec:	85 c0                	test   %eax,%eax
  802fee:	74 60                	je     803050 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802ff0:	83 ec 08             	sub    $0x8,%esp
  802ff3:	68 00 00 00 82       	push   $0x82000000
  802ff8:	68 00 00 00 80       	push   $0x80000000
  802ffd:	e8 0d 0d 00 00       	call   803d0f <initialize_dynamic_allocator>
  803002:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  803005:	e8 f3 0a 00 00       	call   803afd <sys_get_uheap_strategy>
  80300a:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80300f:	a1 20 72 80 00       	mov    0x807220,%eax
  803014:	05 00 10 00 00       	add    $0x1000,%eax
  803019:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  80301e:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803023:	a3 50 f2 81 00       	mov    %eax,0x81f250

		LIST_INIT(&page_alloc_list);
  803028:	c7 05 04 72 80 00 00 	movl   $0x0,0x807204
  80302f:	00 00 00 
  803032:	c7 05 08 72 80 00 00 	movl   $0x0,0x807208
  803039:	00 00 00 
  80303c:	c7 05 10 72 80 00 00 	movl   $0x0,0x807210
  803043:	00 00 00 

		__firstTimeFlag = 0;
  803046:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  80304d:	00 00 00 
	}
}
  803050:	90                   	nop
  803051:	c9                   	leave  
  803052:	c3                   	ret    

00803053 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  803053:	55                   	push   %ebp
  803054:	89 e5                	mov    %esp,%ebp
  803056:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803067:	83 ec 08             	sub    $0x8,%esp
  80306a:	68 06 04 00 00       	push   $0x406
  80306f:	50                   	push   %eax
  803070:	e8 d2 06 00 00       	call   803747 <__sys_allocate_page>
  803075:	83 c4 10             	add    $0x10,%esp
  803078:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80307b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307f:	79 17                	jns    803098 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	68 60 5c 80 00       	push   $0x805c60
  803089:	68 ea 00 00 00       	push   $0xea
  80308e:	68 91 5a 80 00       	push   $0x805a91
  803093:	e8 31 e7 ff ff       	call   8017c9 <_panic>
	return 0;
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80309d:	c9                   	leave  
  80309e:	c3                   	ret    

0080309f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80309f:	55                   	push   %ebp
  8030a0:	89 e5                	mov    %esp,%ebp
  8030a2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8030b3:	83 ec 0c             	sub    $0xc,%esp
  8030b6:	50                   	push   %eax
  8030b7:	e8 d2 06 00 00       	call   80378e <__sys_unmap_frame>
  8030bc:	83 c4 10             	add    $0x10,%esp
  8030bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8030c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c6:	79 17                	jns    8030df <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  8030c8:	83 ec 04             	sub    $0x4,%esp
  8030cb:	68 9c 5c 80 00       	push   $0x805c9c
  8030d0:	68 f5 00 00 00       	push   $0xf5
  8030d5:	68 91 5a 80 00       	push   $0x805a91
  8030da:	e8 ea e6 ff ff       	call   8017c9 <_panic>
}
  8030df:	90                   	nop
  8030e0:	c9                   	leave  
  8030e1:	c3                   	ret    

008030e2 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8030e2:	55                   	push   %ebp
  8030e3:	89 e5                	mov    %esp,%ebp
  8030e5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8030e8:	e8 f4 fe ff ff       	call   802fe1 <uheap_init>
	if (size == 0) return NULL ;
  8030ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f1:	75 0a                	jne    8030fd <malloc+0x1b>
  8030f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f8:	e9 67 01 00 00       	jmp    803264 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8030fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  803104:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80310b:	77 16                	ja     803123 <malloc+0x41>
		result = alloc_block(size);
  80310d:	83 ec 0c             	sub    $0xc,%esp
  803110:	ff 75 08             	pushl  0x8(%ebp)
  803113:	e8 46 0e 00 00       	call   803f5e <alloc_block>
  803118:	83 c4 10             	add    $0x10,%esp
  80311b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311e:	e9 3e 01 00 00       	jmp    803261 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  803123:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80312a:	8b 55 08             	mov    0x8(%ebp),%edx
  80312d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803130:	01 d0                	add    %edx,%eax
  803132:	48                   	dec    %eax
  803133:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803139:	ba 00 00 00 00       	mov    $0x0,%edx
  80313e:	f7 75 f0             	divl   -0x10(%ebp)
  803141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803144:	29 d0                	sub    %edx,%eax
  803146:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  803149:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80314e:	85 c0                	test   %eax,%eax
  803150:	75 0a                	jne    80315c <malloc+0x7a>
			return NULL;
  803152:	b8 00 00 00 00       	mov    $0x0,%eax
  803157:	e9 08 01 00 00       	jmp    803264 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  80315c:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803161:	85 c0                	test   %eax,%eax
  803163:	74 0f                	je     803174 <malloc+0x92>
  803165:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80316b:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803170:	39 c2                	cmp    %eax,%edx
  803172:	73 0a                	jae    80317e <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  803174:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803179:	a3 50 f2 81 00       	mov    %eax,0x81f250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80317e:	a1 44 f2 81 00       	mov    0x81f244,%eax
  803183:	83 f8 05             	cmp    $0x5,%eax
  803186:	75 11                	jne    803199 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  803188:	83 ec 0c             	sub    $0xc,%esp
  80318b:	ff 75 e8             	pushl  -0x18(%ebp)
  80318e:	e8 ff f9 ff ff       	call   802b92 <alloc_pages_custom_fit>
  803193:	83 c4 10             	add    $0x10,%esp
  803196:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  803199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319d:	0f 84 be 00 00 00    	je     803261 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  8031a9:	83 ec 0c             	sub    $0xc,%esp
  8031ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8031af:	e8 9a fb ff ff       	call   802d4e <find_allocated_size>
  8031b4:	83 c4 10             	add    $0x10,%esp
  8031b7:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8031ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031be:	75 17                	jne    8031d7 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8031c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8031c3:	68 dc 5c 80 00       	push   $0x805cdc
  8031c8:	68 24 01 00 00       	push   $0x124
  8031cd:	68 91 5a 80 00       	push   $0x805a91
  8031d2:	e8 f2 e5 ff ff       	call   8017c9 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8031d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031da:	f7 d0                	not    %eax
  8031dc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8031df:	73 1d                	jae    8031fe <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8031e1:	83 ec 0c             	sub    $0xc,%esp
  8031e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8031e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031ea:	68 24 5d 80 00       	push   $0x805d24
  8031ef:	68 29 01 00 00       	push   $0x129
  8031f4:	68 91 5a 80 00       	push   $0x805a91
  8031f9:	e8 cb e5 ff ff       	call   8017c9 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8031fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803201:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803204:	01 d0                	add    %edx,%eax
  803206:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  803209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	79 2c                	jns    80323c <malloc+0x15a>
  803210:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  803217:	77 23                	ja     80323c <malloc+0x15a>
  803219:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  803220:	77 1a                	ja     80323c <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  803222:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	79 13                	jns    80323c <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  803229:	83 ec 08             	sub    $0x8,%esp
  80322c:	ff 75 e0             	pushl  -0x20(%ebp)
  80322f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803232:	e8 de 09 00 00       	call   803c15 <sys_allocate_user_mem>
  803237:	83 c4 10             	add    $0x10,%esp
  80323a:	eb 25                	jmp    803261 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  80323c:	68 00 00 00 a0       	push   $0xa0000000
  803241:	ff 75 dc             	pushl  -0x24(%ebp)
  803244:	ff 75 e0             	pushl  -0x20(%ebp)
  803247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80324a:	ff 75 f4             	pushl  -0xc(%ebp)
  80324d:	68 60 5d 80 00       	push   $0x805d60
  803252:	68 33 01 00 00       	push   $0x133
  803257:	68 91 5a 80 00       	push   $0x805a91
  80325c:	e8 68 e5 ff ff       	call   8017c9 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  803264:	c9                   	leave  
  803265:	c3                   	ret    

00803266 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  803266:	55                   	push   %ebp
  803267:	89 e5                	mov    %esp,%ebp
  803269:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80326c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803270:	0f 84 26 01 00 00    	je     80339c <free+0x136>

	uint32 addr = (uint32)virtual_address;
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	79 1c                	jns    80329f <free+0x39>
  803283:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80328a:	77 13                	ja     80329f <free+0x39>
		free_block(virtual_address);
  80328c:	83 ec 0c             	sub    $0xc,%esp
  80328f:	ff 75 08             	pushl  0x8(%ebp)
  803292:	e8 21 12 00 00       	call   8044b8 <free_block>
  803297:	83 c4 10             	add    $0x10,%esp
		return;
  80329a:	e9 01 01 00 00       	jmp    8033a0 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  80329f:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8032a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8032a7:	0f 82 d8 00 00 00    	jb     803385 <free+0x11f>
  8032ad:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8032b4:	0f 87 cb 00 00 00    	ja     803385 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	25 ff 0f 00 00       	and    $0xfff,%eax
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	74 17                	je     8032dd <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8032c6:	ff 75 08             	pushl  0x8(%ebp)
  8032c9:	68 d0 5d 80 00       	push   $0x805dd0
  8032ce:	68 57 01 00 00       	push   $0x157
  8032d3:	68 91 5a 80 00       	push   $0x805a91
  8032d8:	e8 ec e4 ff ff       	call   8017c9 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8032dd:	83 ec 0c             	sub    $0xc,%esp
  8032e0:	ff 75 08             	pushl  0x8(%ebp)
  8032e3:	e8 66 fa ff ff       	call   802d4e <find_allocated_size>
  8032e8:	83 c4 10             	add    $0x10,%esp
  8032eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8032ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f2:	0f 84 a7 00 00 00    	je     80339f <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8032f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fb:	f7 d0                	not    %eax
  8032fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803300:	73 1d                	jae    80331f <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  803302:	83 ec 0c             	sub    $0xc,%esp
  803305:	ff 75 f0             	pushl  -0x10(%ebp)
  803308:	ff 75 f4             	pushl  -0xc(%ebp)
  80330b:	68 f8 5d 80 00       	push   $0x805df8
  803310:	68 61 01 00 00       	push   $0x161
  803315:	68 91 5a 80 00       	push   $0x805a91
  80331a:	e8 aa e4 ff ff       	call   8017c9 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80331f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803325:	01 d0                	add    %edx,%eax
  803327:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	85 c0                	test   %eax,%eax
  80332f:	79 19                	jns    80334a <free+0xe4>
  803331:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  803338:	77 10                	ja     80334a <free+0xe4>
  80333a:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  803341:	77 07                	ja     80334a <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  803343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	78 2b                	js     803375 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  80334a:	83 ec 0c             	sub    $0xc,%esp
  80334d:	68 00 00 00 a0       	push   $0xa0000000
  803352:	ff 75 ec             	pushl  -0x14(%ebp)
  803355:	ff 75 f0             	pushl  -0x10(%ebp)
  803358:	ff 75 f4             	pushl  -0xc(%ebp)
  80335b:	ff 75 f0             	pushl  -0x10(%ebp)
  80335e:	ff 75 08             	pushl  0x8(%ebp)
  803361:	68 34 5e 80 00       	push   $0x805e34
  803366:	68 69 01 00 00       	push   $0x169
  80336b:	68 91 5a 80 00       	push   $0x805a91
  803370:	e8 54 e4 ff ff       	call   8017c9 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  803375:	83 ec 0c             	sub    $0xc,%esp
  803378:	ff 75 08             	pushl  0x8(%ebp)
  80337b:	e8 2c fa ff ff       	call   802dac <free_pages>
  803380:	83 c4 10             	add    $0x10,%esp
		return;
  803383:	eb 1b                	jmp    8033a0 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  803385:	ff 75 08             	pushl  0x8(%ebp)
  803388:	68 90 5e 80 00       	push   $0x805e90
  80338d:	68 70 01 00 00       	push   $0x170
  803392:	68 91 5a 80 00       	push   $0x805a91
  803397:	e8 2d e4 ff ff       	call   8017c9 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80339c:	90                   	nop
  80339d:	eb 01                	jmp    8033a0 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80339f:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8033a0:	c9                   	leave  
  8033a1:	c3                   	ret    

008033a2 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8033a2:	55                   	push   %ebp
  8033a3:	89 e5                	mov    %esp,%ebp
  8033a5:	83 ec 38             	sub    $0x38,%esp
  8033a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ab:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8033ae:	e8 2e fc ff ff       	call   802fe1 <uheap_init>
	if (size == 0) return NULL ;
  8033b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033b7:	75 0a                	jne    8033c3 <smalloc+0x21>
  8033b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033be:	e9 3d 01 00 00       	jmp    803500 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8033c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8033c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033cc:	25 ff 0f 00 00       	and    $0xfff,%eax
  8033d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8033d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033d8:	74 0e                	je     8033e8 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8033e0:	05 00 10 00 00       	add    $0x1000,%eax
  8033e5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	c1 e8 0c             	shr    $0xc,%eax
  8033ee:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8033f1:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	75 0a                	jne    803404 <smalloc+0x62>
		return NULL;
  8033fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ff:	e9 fc 00 00 00       	jmp    803500 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  803404:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	74 0f                	je     80341c <smalloc+0x7a>
  80340d:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803413:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803418:	39 c2                	cmp    %eax,%edx
  80341a:	73 0a                	jae    803426 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  80341c:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803421:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803426:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80342b:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803430:	29 c2                	sub    %eax,%edx
  803432:	89 d0                	mov    %edx,%eax
  803434:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803437:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80343d:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803442:	29 c2                	sub    %eax,%edx
  803444:	89 d0                	mov    %edx,%eax
  803446:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80344f:	77 13                	ja     803464 <smalloc+0xc2>
  803451:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803457:	77 0b                	ja     803464 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  803459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345c:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80345f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803462:	73 0a                	jae    80346e <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  803464:	b8 00 00 00 00       	mov    $0x0,%eax
  803469:	e9 92 00 00 00       	jmp    803500 <smalloc+0x15e>
	}

	void *va = NULL;
  80346e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  803475:	a1 44 f2 81 00       	mov    0x81f244,%eax
  80347a:	83 f8 05             	cmp    $0x5,%eax
  80347d:	75 11                	jne    803490 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80347f:	83 ec 0c             	sub    $0xc,%esp
  803482:	ff 75 f4             	pushl  -0xc(%ebp)
  803485:	e8 08 f7 ff ff       	call   802b92 <alloc_pages_custom_fit>
  80348a:	83 c4 10             	add    $0x10,%esp
  80348d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  803490:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803494:	75 27                	jne    8034bd <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803496:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80349d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8034a3:	89 c2                	mov    %eax,%edx
  8034a5:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8034aa:	39 c2                	cmp    %eax,%edx
  8034ac:	73 07                	jae    8034b5 <smalloc+0x113>
			return NULL;}
  8034ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b3:	eb 4b                	jmp    803500 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8034b5:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8034ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8034bd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8034c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8034c4:	50                   	push   %eax
  8034c5:	ff 75 0c             	pushl  0xc(%ebp)
  8034c8:	ff 75 08             	pushl  0x8(%ebp)
  8034cb:	e8 cb 03 00 00       	call   80389b <sys_create_shared_object>
  8034d0:	83 c4 10             	add    $0x10,%esp
  8034d3:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8034d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8034da:	79 07                	jns    8034e3 <smalloc+0x141>
		return NULL;
  8034dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e1:	eb 1d                	jmp    803500 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8034e3:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8034e8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8034eb:	75 10                	jne    8034fd <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8034ed:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	01 d0                	add    %edx,%eax
  8034f8:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}

	return va;
  8034fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  803500:	c9                   	leave  
  803501:	c3                   	ret    

00803502 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803502:	55                   	push   %ebp
  803503:	89 e5                	mov    %esp,%ebp
  803505:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803508:	e8 d4 fa ff ff       	call   802fe1 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80350d:	83 ec 08             	sub    $0x8,%esp
  803510:	ff 75 0c             	pushl  0xc(%ebp)
  803513:	ff 75 08             	pushl  0x8(%ebp)
  803516:	e8 aa 03 00 00       	call   8038c5 <sys_size_of_shared_object>
  80351b:	83 c4 10             	add    $0x10,%esp
  80351e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  803521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803525:	7f 0a                	jg     803531 <sget+0x2f>
		return NULL;
  803527:	b8 00 00 00 00       	mov    $0x0,%eax
  80352c:	e9 32 01 00 00       	jmp    803663 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  803531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803534:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  803537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80353f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  803542:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803546:	74 0e                	je     803556 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80354e:	05 00 10 00 00       	add    $0x1000,%eax
  803553:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  803556:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80355b:	85 c0                	test   %eax,%eax
  80355d:	75 0a                	jne    803569 <sget+0x67>
		return NULL;
  80355f:	b8 00 00 00 00       	mov    $0x0,%eax
  803564:	e9 fa 00 00 00       	jmp    803663 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  803569:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80356e:	85 c0                	test   %eax,%eax
  803570:	74 0f                	je     803581 <sget+0x7f>
  803572:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803578:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80357d:	39 c2                	cmp    %eax,%edx
  80357f:	73 0a                	jae    80358b <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  803581:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803586:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80358b:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803590:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803595:	29 c2                	sub    %eax,%edx
  803597:	89 d0                	mov    %edx,%eax
  803599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80359c:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8035a2:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8035a7:	29 c2                	sub    %eax,%edx
  8035a9:	89 d0                	mov    %edx,%eax
  8035ab:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035b4:	77 13                	ja     8035c9 <sget+0xc7>
  8035b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035bc:	77 0b                	ja     8035c9 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8035be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c1:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8035c4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035c7:	73 0a                	jae    8035d3 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8035c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ce:	e9 90 00 00 00       	jmp    803663 <sget+0x161>

	void *va = NULL;
  8035d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8035da:	a1 44 f2 81 00       	mov    0x81f244,%eax
  8035df:	83 f8 05             	cmp    $0x5,%eax
  8035e2:	75 11                	jne    8035f5 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8035e4:	83 ec 0c             	sub    $0xc,%esp
  8035e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8035ea:	e8 a3 f5 ff ff       	call   802b92 <alloc_pages_custom_fit>
  8035ef:	83 c4 10             	add    $0x10,%esp
  8035f2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8035f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035f9:	75 27                	jne    803622 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8035fb:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  803602:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803605:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803608:	89 c2                	mov    %eax,%edx
  80360a:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80360f:	39 c2                	cmp    %eax,%edx
  803611:	73 07                	jae    80361a <sget+0x118>
			return NULL;
  803613:	b8 00 00 00 00       	mov    $0x0,%eax
  803618:	eb 49                	jmp    803663 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80361a:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80361f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	ff 75 f0             	pushl  -0x10(%ebp)
  803628:	ff 75 0c             	pushl  0xc(%ebp)
  80362b:	ff 75 08             	pushl  0x8(%ebp)
  80362e:	e8 af 02 00 00       	call   8038e2 <sys_get_shared_object>
  803633:	83 c4 10             	add    $0x10,%esp
  803636:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  803639:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80363d:	79 07                	jns    803646 <sget+0x144>
		return NULL;
  80363f:	b8 00 00 00 00       	mov    $0x0,%eax
  803644:	eb 1d                	jmp    803663 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  803646:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80364b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80364e:	75 10                	jne    803660 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  803650:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803659:	01 d0                	add    %edx,%eax
  80365b:	a3 50 f2 81 00       	mov    %eax,0x81f250

	return va;
  803660:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  803663:	c9                   	leave  
  803664:	c3                   	ret    

00803665 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803665:	55                   	push   %ebp
  803666:	89 e5                	mov    %esp,%ebp
  803668:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80366b:	e8 71 f9 ff ff       	call   802fe1 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803670:	83 ec 04             	sub    $0x4,%esp
  803673:	68 b4 5e 80 00       	push   $0x805eb4
  803678:	68 19 02 00 00       	push   $0x219
  80367d:	68 91 5a 80 00       	push   $0x805a91
  803682:	e8 42 e1 ff ff       	call   8017c9 <_panic>

00803687 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80368d:	83 ec 04             	sub    $0x4,%esp
  803690:	68 dc 5e 80 00       	push   $0x805edc
  803695:	68 2b 02 00 00       	push   $0x22b
  80369a:	68 91 5a 80 00       	push   $0x805a91
  80369f:	e8 25 e1 ff ff       	call   8017c9 <_panic>

008036a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8036a4:	55                   	push   %ebp
  8036a5:	89 e5                	mov    %esp,%ebp
  8036a7:	57                   	push   %edi
  8036a8:	56                   	push   %esi
  8036a9:	53                   	push   %ebx
  8036aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8036b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8036bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8036bf:	cd 30                	int    $0x30
  8036c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8036c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8036c7:	83 c4 10             	add    $0x10,%esp
  8036ca:	5b                   	pop    %ebx
  8036cb:	5e                   	pop    %esi
  8036cc:	5f                   	pop    %edi
  8036cd:	5d                   	pop    %ebp
  8036ce:	c3                   	ret    

008036cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8036cf:	55                   	push   %ebp
  8036d0:	89 e5                	mov    %esp,%ebp
  8036d2:	83 ec 04             	sub    $0x4,%esp
  8036d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8036d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8036db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8036de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	6a 00                	push   $0x0
  8036e7:	51                   	push   %ecx
  8036e8:	52                   	push   %edx
  8036e9:	ff 75 0c             	pushl  0xc(%ebp)
  8036ec:	50                   	push   %eax
  8036ed:	6a 00                	push   $0x0
  8036ef:	e8 b0 ff ff ff       	call   8036a4 <syscall>
  8036f4:	83 c4 18             	add    $0x18,%esp
}
  8036f7:	90                   	nop
  8036f8:	c9                   	leave  
  8036f9:	c3                   	ret    

008036fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8036fa:	55                   	push   %ebp
  8036fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8036fd:	6a 00                	push   $0x0
  8036ff:	6a 00                	push   $0x0
  803701:	6a 00                	push   $0x0
  803703:	6a 00                	push   $0x0
  803705:	6a 00                	push   $0x0
  803707:	6a 02                	push   $0x2
  803709:	e8 96 ff ff ff       	call   8036a4 <syscall>
  80370e:	83 c4 18             	add    $0x18,%esp
}
  803711:	c9                   	leave  
  803712:	c3                   	ret    

00803713 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803713:	55                   	push   %ebp
  803714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803716:	6a 00                	push   $0x0
  803718:	6a 00                	push   $0x0
  80371a:	6a 00                	push   $0x0
  80371c:	6a 00                	push   $0x0
  80371e:	6a 00                	push   $0x0
  803720:	6a 03                	push   $0x3
  803722:	e8 7d ff ff ff       	call   8036a4 <syscall>
  803727:	83 c4 18             	add    $0x18,%esp
}
  80372a:	90                   	nop
  80372b:	c9                   	leave  
  80372c:	c3                   	ret    

0080372d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80372d:	55                   	push   %ebp
  80372e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803730:	6a 00                	push   $0x0
  803732:	6a 00                	push   $0x0
  803734:	6a 00                	push   $0x0
  803736:	6a 00                	push   $0x0
  803738:	6a 00                	push   $0x0
  80373a:	6a 04                	push   $0x4
  80373c:	e8 63 ff ff ff       	call   8036a4 <syscall>
  803741:	83 c4 18             	add    $0x18,%esp
}
  803744:	90                   	nop
  803745:	c9                   	leave  
  803746:	c3                   	ret    

00803747 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803747:	55                   	push   %ebp
  803748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80374a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	6a 00                	push   $0x0
  803752:	6a 00                	push   $0x0
  803754:	6a 00                	push   $0x0
  803756:	52                   	push   %edx
  803757:	50                   	push   %eax
  803758:	6a 08                	push   $0x8
  80375a:	e8 45 ff ff ff       	call   8036a4 <syscall>
  80375f:	83 c4 18             	add    $0x18,%esp
}
  803762:	c9                   	leave  
  803763:	c3                   	ret    

00803764 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803764:	55                   	push   %ebp
  803765:	89 e5                	mov    %esp,%ebp
  803767:	56                   	push   %esi
  803768:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803769:	8b 75 18             	mov    0x18(%ebp),%esi
  80376c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80376f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803772:	8b 55 0c             	mov    0xc(%ebp),%edx
  803775:	8b 45 08             	mov    0x8(%ebp),%eax
  803778:	56                   	push   %esi
  803779:	53                   	push   %ebx
  80377a:	51                   	push   %ecx
  80377b:	52                   	push   %edx
  80377c:	50                   	push   %eax
  80377d:	6a 09                	push   $0x9
  80377f:	e8 20 ff ff ff       	call   8036a4 <syscall>
  803784:	83 c4 18             	add    $0x18,%esp
}
  803787:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80378a:	5b                   	pop    %ebx
  80378b:	5e                   	pop    %esi
  80378c:	5d                   	pop    %ebp
  80378d:	c3                   	ret    

0080378e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80378e:	55                   	push   %ebp
  80378f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803791:	6a 00                	push   $0x0
  803793:	6a 00                	push   $0x0
  803795:	6a 00                	push   $0x0
  803797:	6a 00                	push   $0x0
  803799:	ff 75 08             	pushl  0x8(%ebp)
  80379c:	6a 0a                	push   $0xa
  80379e:	e8 01 ff ff ff       	call   8036a4 <syscall>
  8037a3:	83 c4 18             	add    $0x18,%esp
}
  8037a6:	c9                   	leave  
  8037a7:	c3                   	ret    

008037a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8037a8:	55                   	push   %ebp
  8037a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8037ab:	6a 00                	push   $0x0
  8037ad:	6a 00                	push   $0x0
  8037af:	6a 00                	push   $0x0
  8037b1:	ff 75 0c             	pushl  0xc(%ebp)
  8037b4:	ff 75 08             	pushl  0x8(%ebp)
  8037b7:	6a 0b                	push   $0xb
  8037b9:	e8 e6 fe ff ff       	call   8036a4 <syscall>
  8037be:	83 c4 18             	add    $0x18,%esp
}
  8037c1:	c9                   	leave  
  8037c2:	c3                   	ret    

008037c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8037c3:	55                   	push   %ebp
  8037c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 00                	push   $0x0
  8037cc:	6a 00                	push   $0x0
  8037ce:	6a 00                	push   $0x0
  8037d0:	6a 0c                	push   $0xc
  8037d2:	e8 cd fe ff ff       	call   8036a4 <syscall>
  8037d7:	83 c4 18             	add    $0x18,%esp
}
  8037da:	c9                   	leave  
  8037db:	c3                   	ret    

008037dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8037dc:	55                   	push   %ebp
  8037dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8037df:	6a 00                	push   $0x0
  8037e1:	6a 00                	push   $0x0
  8037e3:	6a 00                	push   $0x0
  8037e5:	6a 00                	push   $0x0
  8037e7:	6a 00                	push   $0x0
  8037e9:	6a 0d                	push   $0xd
  8037eb:	e8 b4 fe ff ff       	call   8036a4 <syscall>
  8037f0:	83 c4 18             	add    $0x18,%esp
}
  8037f3:	c9                   	leave  
  8037f4:	c3                   	ret    

008037f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8037f5:	55                   	push   %ebp
  8037f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8037f8:	6a 00                	push   $0x0
  8037fa:	6a 00                	push   $0x0
  8037fc:	6a 00                	push   $0x0
  8037fe:	6a 00                	push   $0x0
  803800:	6a 00                	push   $0x0
  803802:	6a 0e                	push   $0xe
  803804:	e8 9b fe ff ff       	call   8036a4 <syscall>
  803809:	83 c4 18             	add    $0x18,%esp
}
  80380c:	c9                   	leave  
  80380d:	c3                   	ret    

0080380e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80380e:	55                   	push   %ebp
  80380f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803811:	6a 00                	push   $0x0
  803813:	6a 00                	push   $0x0
  803815:	6a 00                	push   $0x0
  803817:	6a 00                	push   $0x0
  803819:	6a 00                	push   $0x0
  80381b:	6a 0f                	push   $0xf
  80381d:	e8 82 fe ff ff       	call   8036a4 <syscall>
  803822:	83 c4 18             	add    $0x18,%esp
}
  803825:	c9                   	leave  
  803826:	c3                   	ret    

00803827 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803827:	55                   	push   %ebp
  803828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80382a:	6a 00                	push   $0x0
  80382c:	6a 00                	push   $0x0
  80382e:	6a 00                	push   $0x0
  803830:	6a 00                	push   $0x0
  803832:	ff 75 08             	pushl  0x8(%ebp)
  803835:	6a 10                	push   $0x10
  803837:	e8 68 fe ff ff       	call   8036a4 <syscall>
  80383c:	83 c4 18             	add    $0x18,%esp
}
  80383f:	c9                   	leave  
  803840:	c3                   	ret    

00803841 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803841:	55                   	push   %ebp
  803842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803844:	6a 00                	push   $0x0
  803846:	6a 00                	push   $0x0
  803848:	6a 00                	push   $0x0
  80384a:	6a 00                	push   $0x0
  80384c:	6a 00                	push   $0x0
  80384e:	6a 11                	push   $0x11
  803850:	e8 4f fe ff ff       	call   8036a4 <syscall>
  803855:	83 c4 18             	add    $0x18,%esp
}
  803858:	90                   	nop
  803859:	c9                   	leave  
  80385a:	c3                   	ret    

0080385b <sys_cputc>:

void
sys_cputc(const char c)
{
  80385b:	55                   	push   %ebp
  80385c:	89 e5                	mov    %esp,%ebp
  80385e:	83 ec 04             	sub    $0x4,%esp
  803861:	8b 45 08             	mov    0x8(%ebp),%eax
  803864:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803867:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80386b:	6a 00                	push   $0x0
  80386d:	6a 00                	push   $0x0
  80386f:	6a 00                	push   $0x0
  803871:	6a 00                	push   $0x0
  803873:	50                   	push   %eax
  803874:	6a 01                	push   $0x1
  803876:	e8 29 fe ff ff       	call   8036a4 <syscall>
  80387b:	83 c4 18             	add    $0x18,%esp
}
  80387e:	90                   	nop
  80387f:	c9                   	leave  
  803880:	c3                   	ret    

00803881 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803881:	55                   	push   %ebp
  803882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803884:	6a 00                	push   $0x0
  803886:	6a 00                	push   $0x0
  803888:	6a 00                	push   $0x0
  80388a:	6a 00                	push   $0x0
  80388c:	6a 00                	push   $0x0
  80388e:	6a 14                	push   $0x14
  803890:	e8 0f fe ff ff       	call   8036a4 <syscall>
  803895:	83 c4 18             	add    $0x18,%esp
}
  803898:	90                   	nop
  803899:	c9                   	leave  
  80389a:	c3                   	ret    

0080389b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80389b:	55                   	push   %ebp
  80389c:	89 e5                	mov    %esp,%ebp
  80389e:	83 ec 04             	sub    $0x4,%esp
  8038a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8038a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8038a7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8038aa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	6a 00                	push   $0x0
  8038b3:	51                   	push   %ecx
  8038b4:	52                   	push   %edx
  8038b5:	ff 75 0c             	pushl  0xc(%ebp)
  8038b8:	50                   	push   %eax
  8038b9:	6a 15                	push   $0x15
  8038bb:	e8 e4 fd ff ff       	call   8036a4 <syscall>
  8038c0:	83 c4 18             	add    $0x18,%esp
}
  8038c3:	c9                   	leave  
  8038c4:	c3                   	ret    

008038c5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8038c5:	55                   	push   %ebp
  8038c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8038c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	6a 00                	push   $0x0
  8038d0:	6a 00                	push   $0x0
  8038d2:	6a 00                	push   $0x0
  8038d4:	52                   	push   %edx
  8038d5:	50                   	push   %eax
  8038d6:	6a 16                	push   $0x16
  8038d8:	e8 c7 fd ff ff       	call   8036a4 <syscall>
  8038dd:	83 c4 18             	add    $0x18,%esp
}
  8038e0:	c9                   	leave  
  8038e1:	c3                   	ret    

008038e2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8038e2:	55                   	push   %ebp
  8038e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8038e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8038e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	6a 00                	push   $0x0
  8038f0:	6a 00                	push   $0x0
  8038f2:	51                   	push   %ecx
  8038f3:	52                   	push   %edx
  8038f4:	50                   	push   %eax
  8038f5:	6a 17                	push   $0x17
  8038f7:	e8 a8 fd ff ff       	call   8036a4 <syscall>
  8038fc:	83 c4 18             	add    $0x18,%esp
}
  8038ff:	c9                   	leave  
  803900:	c3                   	ret    

00803901 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803901:	55                   	push   %ebp
  803902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803904:	8b 55 0c             	mov    0xc(%ebp),%edx
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	6a 00                	push   $0x0
  80390c:	6a 00                	push   $0x0
  80390e:	6a 00                	push   $0x0
  803910:	52                   	push   %edx
  803911:	50                   	push   %eax
  803912:	6a 18                	push   $0x18
  803914:	e8 8b fd ff ff       	call   8036a4 <syscall>
  803919:	83 c4 18             	add    $0x18,%esp
}
  80391c:	c9                   	leave  
  80391d:	c3                   	ret    

0080391e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80391e:	55                   	push   %ebp
  80391f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	6a 00                	push   $0x0
  803926:	ff 75 14             	pushl  0x14(%ebp)
  803929:	ff 75 10             	pushl  0x10(%ebp)
  80392c:	ff 75 0c             	pushl  0xc(%ebp)
  80392f:	50                   	push   %eax
  803930:	6a 19                	push   $0x19
  803932:	e8 6d fd ff ff       	call   8036a4 <syscall>
  803937:	83 c4 18             	add    $0x18,%esp
}
  80393a:	c9                   	leave  
  80393b:	c3                   	ret    

0080393c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80393c:	55                   	push   %ebp
  80393d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80393f:	8b 45 08             	mov    0x8(%ebp),%eax
  803942:	6a 00                	push   $0x0
  803944:	6a 00                	push   $0x0
  803946:	6a 00                	push   $0x0
  803948:	6a 00                	push   $0x0
  80394a:	50                   	push   %eax
  80394b:	6a 1a                	push   $0x1a
  80394d:	e8 52 fd ff ff       	call   8036a4 <syscall>
  803952:	83 c4 18             	add    $0x18,%esp
}
  803955:	90                   	nop
  803956:	c9                   	leave  
  803957:	c3                   	ret    

00803958 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803958:	55                   	push   %ebp
  803959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	6a 00                	push   $0x0
  803960:	6a 00                	push   $0x0
  803962:	6a 00                	push   $0x0
  803964:	6a 00                	push   $0x0
  803966:	50                   	push   %eax
  803967:	6a 1b                	push   $0x1b
  803969:	e8 36 fd ff ff       	call   8036a4 <syscall>
  80396e:	83 c4 18             	add    $0x18,%esp
}
  803971:	c9                   	leave  
  803972:	c3                   	ret    

00803973 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803973:	55                   	push   %ebp
  803974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803976:	6a 00                	push   $0x0
  803978:	6a 00                	push   $0x0
  80397a:	6a 00                	push   $0x0
  80397c:	6a 00                	push   $0x0
  80397e:	6a 00                	push   $0x0
  803980:	6a 05                	push   $0x5
  803982:	e8 1d fd ff ff       	call   8036a4 <syscall>
  803987:	83 c4 18             	add    $0x18,%esp
}
  80398a:	c9                   	leave  
  80398b:	c3                   	ret    

0080398c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80398c:	55                   	push   %ebp
  80398d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80398f:	6a 00                	push   $0x0
  803991:	6a 00                	push   $0x0
  803993:	6a 00                	push   $0x0
  803995:	6a 00                	push   $0x0
  803997:	6a 00                	push   $0x0
  803999:	6a 06                	push   $0x6
  80399b:	e8 04 fd ff ff       	call   8036a4 <syscall>
  8039a0:	83 c4 18             	add    $0x18,%esp
}
  8039a3:	c9                   	leave  
  8039a4:	c3                   	ret    

008039a5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8039a5:	55                   	push   %ebp
  8039a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8039a8:	6a 00                	push   $0x0
  8039aa:	6a 00                	push   $0x0
  8039ac:	6a 00                	push   $0x0
  8039ae:	6a 00                	push   $0x0
  8039b0:	6a 00                	push   $0x0
  8039b2:	6a 07                	push   $0x7
  8039b4:	e8 eb fc ff ff       	call   8036a4 <syscall>
  8039b9:	83 c4 18             	add    $0x18,%esp
}
  8039bc:	c9                   	leave  
  8039bd:	c3                   	ret    

008039be <sys_exit_env>:


void sys_exit_env(void)
{
  8039be:	55                   	push   %ebp
  8039bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8039c1:	6a 00                	push   $0x0
  8039c3:	6a 00                	push   $0x0
  8039c5:	6a 00                	push   $0x0
  8039c7:	6a 00                	push   $0x0
  8039c9:	6a 00                	push   $0x0
  8039cb:	6a 1c                	push   $0x1c
  8039cd:	e8 d2 fc ff ff       	call   8036a4 <syscall>
  8039d2:	83 c4 18             	add    $0x18,%esp
}
  8039d5:	90                   	nop
  8039d6:	c9                   	leave  
  8039d7:	c3                   	ret    

008039d8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8039d8:	55                   	push   %ebp
  8039d9:	89 e5                	mov    %esp,%ebp
  8039db:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8039de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8039e1:	8d 50 04             	lea    0x4(%eax),%edx
  8039e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8039e7:	6a 00                	push   $0x0
  8039e9:	6a 00                	push   $0x0
  8039eb:	6a 00                	push   $0x0
  8039ed:	52                   	push   %edx
  8039ee:	50                   	push   %eax
  8039ef:	6a 1d                	push   $0x1d
  8039f1:	e8 ae fc ff ff       	call   8036a4 <syscall>
  8039f6:	83 c4 18             	add    $0x18,%esp
	return result;
  8039f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8039fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8039ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a02:	89 01                	mov    %eax,(%ecx)
  803a04:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	c9                   	leave  
  803a0b:	c2 04 00             	ret    $0x4

00803a0e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803a0e:	55                   	push   %ebp
  803a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803a11:	6a 00                	push   $0x0
  803a13:	6a 00                	push   $0x0
  803a15:	ff 75 10             	pushl  0x10(%ebp)
  803a18:	ff 75 0c             	pushl  0xc(%ebp)
  803a1b:	ff 75 08             	pushl  0x8(%ebp)
  803a1e:	6a 13                	push   $0x13
  803a20:	e8 7f fc ff ff       	call   8036a4 <syscall>
  803a25:	83 c4 18             	add    $0x18,%esp
	return ;
  803a28:	90                   	nop
}
  803a29:	c9                   	leave  
  803a2a:	c3                   	ret    

00803a2b <sys_rcr2>:
uint32 sys_rcr2()
{
  803a2b:	55                   	push   %ebp
  803a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803a2e:	6a 00                	push   $0x0
  803a30:	6a 00                	push   $0x0
  803a32:	6a 00                	push   $0x0
  803a34:	6a 00                	push   $0x0
  803a36:	6a 00                	push   $0x0
  803a38:	6a 1e                	push   $0x1e
  803a3a:	e8 65 fc ff ff       	call   8036a4 <syscall>
  803a3f:	83 c4 18             	add    $0x18,%esp
}
  803a42:	c9                   	leave  
  803a43:	c3                   	ret    

00803a44 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803a44:	55                   	push   %ebp
  803a45:	89 e5                	mov    %esp,%ebp
  803a47:	83 ec 04             	sub    $0x4,%esp
  803a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803a50:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803a54:	6a 00                	push   $0x0
  803a56:	6a 00                	push   $0x0
  803a58:	6a 00                	push   $0x0
  803a5a:	6a 00                	push   $0x0
  803a5c:	50                   	push   %eax
  803a5d:	6a 1f                	push   $0x1f
  803a5f:	e8 40 fc ff ff       	call   8036a4 <syscall>
  803a64:	83 c4 18             	add    $0x18,%esp
	return ;
  803a67:	90                   	nop
}
  803a68:	c9                   	leave  
  803a69:	c3                   	ret    

00803a6a <rsttst>:
void rsttst()
{
  803a6a:	55                   	push   %ebp
  803a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803a6d:	6a 00                	push   $0x0
  803a6f:	6a 00                	push   $0x0
  803a71:	6a 00                	push   $0x0
  803a73:	6a 00                	push   $0x0
  803a75:	6a 00                	push   $0x0
  803a77:	6a 21                	push   $0x21
  803a79:	e8 26 fc ff ff       	call   8036a4 <syscall>
  803a7e:	83 c4 18             	add    $0x18,%esp
	return ;
  803a81:	90                   	nop
}
  803a82:	c9                   	leave  
  803a83:	c3                   	ret    

00803a84 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803a84:	55                   	push   %ebp
  803a85:	89 e5                	mov    %esp,%ebp
  803a87:	83 ec 04             	sub    $0x4,%esp
  803a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  803a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803a90:	8b 55 18             	mov    0x18(%ebp),%edx
  803a93:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803a97:	52                   	push   %edx
  803a98:	50                   	push   %eax
  803a99:	ff 75 10             	pushl  0x10(%ebp)
  803a9c:	ff 75 0c             	pushl  0xc(%ebp)
  803a9f:	ff 75 08             	pushl  0x8(%ebp)
  803aa2:	6a 20                	push   $0x20
  803aa4:	e8 fb fb ff ff       	call   8036a4 <syscall>
  803aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  803aac:	90                   	nop
}
  803aad:	c9                   	leave  
  803aae:	c3                   	ret    

00803aaf <chktst>:
void chktst(uint32 n)
{
  803aaf:	55                   	push   %ebp
  803ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803ab2:	6a 00                	push   $0x0
  803ab4:	6a 00                	push   $0x0
  803ab6:	6a 00                	push   $0x0
  803ab8:	6a 00                	push   $0x0
  803aba:	ff 75 08             	pushl  0x8(%ebp)
  803abd:	6a 22                	push   $0x22
  803abf:	e8 e0 fb ff ff       	call   8036a4 <syscall>
  803ac4:	83 c4 18             	add    $0x18,%esp
	return ;
  803ac7:	90                   	nop
}
  803ac8:	c9                   	leave  
  803ac9:	c3                   	ret    

00803aca <inctst>:

void inctst()
{
  803aca:	55                   	push   %ebp
  803acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803acd:	6a 00                	push   $0x0
  803acf:	6a 00                	push   $0x0
  803ad1:	6a 00                	push   $0x0
  803ad3:	6a 00                	push   $0x0
  803ad5:	6a 00                	push   $0x0
  803ad7:	6a 23                	push   $0x23
  803ad9:	e8 c6 fb ff ff       	call   8036a4 <syscall>
  803ade:	83 c4 18             	add    $0x18,%esp
	return ;
  803ae1:	90                   	nop
}
  803ae2:	c9                   	leave  
  803ae3:	c3                   	ret    

00803ae4 <gettst>:
uint32 gettst()
{
  803ae4:	55                   	push   %ebp
  803ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803ae7:	6a 00                	push   $0x0
  803ae9:	6a 00                	push   $0x0
  803aeb:	6a 00                	push   $0x0
  803aed:	6a 00                	push   $0x0
  803aef:	6a 00                	push   $0x0
  803af1:	6a 24                	push   $0x24
  803af3:	e8 ac fb ff ff       	call   8036a4 <syscall>
  803af8:	83 c4 18             	add    $0x18,%esp
}
  803afb:	c9                   	leave  
  803afc:	c3                   	ret    

00803afd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803afd:	55                   	push   %ebp
  803afe:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803b00:	6a 00                	push   $0x0
  803b02:	6a 00                	push   $0x0
  803b04:	6a 00                	push   $0x0
  803b06:	6a 00                	push   $0x0
  803b08:	6a 00                	push   $0x0
  803b0a:	6a 25                	push   $0x25
  803b0c:	e8 93 fb ff ff       	call   8036a4 <syscall>
  803b11:	83 c4 18             	add    $0x18,%esp
  803b14:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  803b19:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  803b1e:	c9                   	leave  
  803b1f:	c3                   	ret    

00803b20 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803b20:	55                   	push   %ebp
  803b21:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803b2b:	6a 00                	push   $0x0
  803b2d:	6a 00                	push   $0x0
  803b2f:	6a 00                	push   $0x0
  803b31:	6a 00                	push   $0x0
  803b33:	ff 75 08             	pushl  0x8(%ebp)
  803b36:	6a 26                	push   $0x26
  803b38:	e8 67 fb ff ff       	call   8036a4 <syscall>
  803b3d:	83 c4 18             	add    $0x18,%esp
	return ;
  803b40:	90                   	nop
}
  803b41:	c9                   	leave  
  803b42:	c3                   	ret    

00803b43 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803b43:	55                   	push   %ebp
  803b44:	89 e5                	mov    %esp,%ebp
  803b46:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803b47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803b4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b50:	8b 45 08             	mov    0x8(%ebp),%eax
  803b53:	6a 00                	push   $0x0
  803b55:	53                   	push   %ebx
  803b56:	51                   	push   %ecx
  803b57:	52                   	push   %edx
  803b58:	50                   	push   %eax
  803b59:	6a 27                	push   $0x27
  803b5b:	e8 44 fb ff ff       	call   8036a4 <syscall>
  803b60:	83 c4 18             	add    $0x18,%esp
}
  803b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b66:	c9                   	leave  
  803b67:	c3                   	ret    

00803b68 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803b68:	55                   	push   %ebp
  803b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b71:	6a 00                	push   $0x0
  803b73:	6a 00                	push   $0x0
  803b75:	6a 00                	push   $0x0
  803b77:	52                   	push   %edx
  803b78:	50                   	push   %eax
  803b79:	6a 28                	push   $0x28
  803b7b:	e8 24 fb ff ff       	call   8036a4 <syscall>
  803b80:	83 c4 18             	add    $0x18,%esp
}
  803b83:	c9                   	leave  
  803b84:	c3                   	ret    

00803b85 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803b85:	55                   	push   %ebp
  803b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803b88:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b91:	6a 00                	push   $0x0
  803b93:	51                   	push   %ecx
  803b94:	ff 75 10             	pushl  0x10(%ebp)
  803b97:	52                   	push   %edx
  803b98:	50                   	push   %eax
  803b99:	6a 29                	push   $0x29
  803b9b:	e8 04 fb ff ff       	call   8036a4 <syscall>
  803ba0:	83 c4 18             	add    $0x18,%esp
}
  803ba3:	c9                   	leave  
  803ba4:	c3                   	ret    

00803ba5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803ba5:	55                   	push   %ebp
  803ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803ba8:	6a 00                	push   $0x0
  803baa:	6a 00                	push   $0x0
  803bac:	ff 75 10             	pushl  0x10(%ebp)
  803baf:	ff 75 0c             	pushl  0xc(%ebp)
  803bb2:	ff 75 08             	pushl  0x8(%ebp)
  803bb5:	6a 12                	push   $0x12
  803bb7:	e8 e8 fa ff ff       	call   8036a4 <syscall>
  803bbc:	83 c4 18             	add    $0x18,%esp
	return ;
  803bbf:	90                   	nop
}
  803bc0:	c9                   	leave  
  803bc1:	c3                   	ret    

00803bc2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803bc2:	55                   	push   %ebp
  803bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcb:	6a 00                	push   $0x0
  803bcd:	6a 00                	push   $0x0
  803bcf:	6a 00                	push   $0x0
  803bd1:	52                   	push   %edx
  803bd2:	50                   	push   %eax
  803bd3:	6a 2a                	push   $0x2a
  803bd5:	e8 ca fa ff ff       	call   8036a4 <syscall>
  803bda:	83 c4 18             	add    $0x18,%esp
	return;
  803bdd:	90                   	nop
}
  803bde:	c9                   	leave  
  803bdf:	c3                   	ret    

00803be0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803be0:	55                   	push   %ebp
  803be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803be3:	6a 00                	push   $0x0
  803be5:	6a 00                	push   $0x0
  803be7:	6a 00                	push   $0x0
  803be9:	6a 00                	push   $0x0
  803beb:	6a 00                	push   $0x0
  803bed:	6a 2b                	push   $0x2b
  803bef:	e8 b0 fa ff ff       	call   8036a4 <syscall>
  803bf4:	83 c4 18             	add    $0x18,%esp
}
  803bf7:	c9                   	leave  
  803bf8:	c3                   	ret    

00803bf9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803bf9:	55                   	push   %ebp
  803bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803bfc:	6a 00                	push   $0x0
  803bfe:	6a 00                	push   $0x0
  803c00:	6a 00                	push   $0x0
  803c02:	ff 75 0c             	pushl  0xc(%ebp)
  803c05:	ff 75 08             	pushl  0x8(%ebp)
  803c08:	6a 2d                	push   $0x2d
  803c0a:	e8 95 fa ff ff       	call   8036a4 <syscall>
  803c0f:	83 c4 18             	add    $0x18,%esp
	return;
  803c12:	90                   	nop
}
  803c13:	c9                   	leave  
  803c14:	c3                   	ret    

00803c15 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803c15:	55                   	push   %ebp
  803c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803c18:	6a 00                	push   $0x0
  803c1a:	6a 00                	push   $0x0
  803c1c:	6a 00                	push   $0x0
  803c1e:	ff 75 0c             	pushl  0xc(%ebp)
  803c21:	ff 75 08             	pushl  0x8(%ebp)
  803c24:	6a 2c                	push   $0x2c
  803c26:	e8 79 fa ff ff       	call   8036a4 <syscall>
  803c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  803c2e:	90                   	nop
}
  803c2f:	c9                   	leave  
  803c30:	c3                   	ret    

00803c31 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803c31:	55                   	push   %ebp
  803c32:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c37:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3a:	6a 00                	push   $0x0
  803c3c:	6a 00                	push   $0x0
  803c3e:	6a 00                	push   $0x0
  803c40:	52                   	push   %edx
  803c41:	50                   	push   %eax
  803c42:	6a 2e                	push   $0x2e
  803c44:	e8 5b fa ff ff       	call   8036a4 <syscall>
  803c49:	83 c4 18             	add    $0x18,%esp
	return ;
  803c4c:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803c4d:	c9                   	leave  
  803c4e:	c3                   	ret    

00803c4f <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803c4f:	55                   	push   %ebp
  803c50:	89 e5                	mov    %esp,%ebp
  803c52:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803c55:	81 7d 08 40 72 80 00 	cmpl   $0x807240,0x8(%ebp)
  803c5c:	72 09                	jb     803c67 <to_page_va+0x18>
  803c5e:	81 7d 08 40 f2 81 00 	cmpl   $0x81f240,0x8(%ebp)
  803c65:	72 14                	jb     803c7b <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803c67:	83 ec 04             	sub    $0x4,%esp
  803c6a:	68 00 5f 80 00       	push   $0x805f00
  803c6f:	6a 15                	push   $0x15
  803c71:	68 2b 5f 80 00       	push   $0x805f2b
  803c76:	e8 4e db ff ff       	call   8017c9 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7e:	ba 40 72 80 00       	mov    $0x807240,%edx
  803c83:	29 d0                	sub    %edx,%eax
  803c85:	c1 f8 02             	sar    $0x2,%eax
  803c88:	89 c2                	mov    %eax,%edx
  803c8a:	89 d0                	mov    %edx,%eax
  803c8c:	c1 e0 02             	shl    $0x2,%eax
  803c8f:	01 d0                	add    %edx,%eax
  803c91:	c1 e0 02             	shl    $0x2,%eax
  803c94:	01 d0                	add    %edx,%eax
  803c96:	c1 e0 02             	shl    $0x2,%eax
  803c99:	01 d0                	add    %edx,%eax
  803c9b:	89 c1                	mov    %eax,%ecx
  803c9d:	c1 e1 08             	shl    $0x8,%ecx
  803ca0:	01 c8                	add    %ecx,%eax
  803ca2:	89 c1                	mov    %eax,%ecx
  803ca4:	c1 e1 10             	shl    $0x10,%ecx
  803ca7:	01 c8                	add    %ecx,%eax
  803ca9:	01 c0                	add    %eax,%eax
  803cab:	01 d0                	add    %edx,%eax
  803cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb3:	c1 e0 0c             	shl    $0xc,%eax
  803cb6:	89 c2                	mov    %eax,%edx
  803cb8:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803cbd:	01 d0                	add    %edx,%eax
}
  803cbf:	c9                   	leave  
  803cc0:	c3                   	ret    

00803cc1 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803cc1:	55                   	push   %ebp
  803cc2:	89 e5                	mov    %esp,%ebp
  803cc4:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803cc7:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  803ccf:	29 c2                	sub    %eax,%edx
  803cd1:	89 d0                	mov    %edx,%eax
  803cd3:	c1 e8 0c             	shr    $0xc,%eax
  803cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cdd:	78 09                	js     803ce8 <to_page_info+0x27>
  803cdf:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803ce6:	7e 14                	jle    803cfc <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803ce8:	83 ec 04             	sub    $0x4,%esp
  803ceb:	68 44 5f 80 00       	push   $0x805f44
  803cf0:	6a 22                	push   $0x22
  803cf2:	68 2b 5f 80 00       	push   $0x805f2b
  803cf7:	e8 cd da ff ff       	call   8017c9 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cff:	89 d0                	mov    %edx,%eax
  803d01:	01 c0                	add    %eax,%eax
  803d03:	01 d0                	add    %edx,%eax
  803d05:	c1 e0 02             	shl    $0x2,%eax
  803d08:	05 40 72 80 00       	add    $0x807240,%eax
}
  803d0d:	c9                   	leave  
  803d0e:	c3                   	ret    

00803d0f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803d0f:	55                   	push   %ebp
  803d10:	89 e5                	mov    %esp,%ebp
  803d12:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803d15:	8b 45 08             	mov    0x8(%ebp),%eax
  803d18:	05 00 00 00 02       	add    $0x2000000,%eax
  803d1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d20:	73 16                	jae    803d38 <initialize_dynamic_allocator+0x29>
  803d22:	68 68 5f 80 00       	push   $0x805f68
  803d27:	68 8e 5f 80 00       	push   $0x805f8e
  803d2c:	6a 34                	push   $0x34
  803d2e:	68 2b 5f 80 00       	push   $0x805f2b
  803d33:	e8 91 da ff ff       	call   8017c9 <_panic>
		is_initialized = 1;
  803d38:	c7 05 14 72 80 00 01 	movl   $0x1,0x807214
  803d3f:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803d42:	8b 45 08             	mov    0x8(%ebp),%eax
  803d45:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd = daEnd;
  803d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d4d:	a3 20 72 80 00       	mov    %eax,0x807220

	LIST_INIT(&freePagesList);
  803d52:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  803d59:	00 00 00 
  803d5c:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  803d63:	00 00 00 
  803d66:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  803d6d:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803d70:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803d77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d7e:	eb 36                	jmp    803db6 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d83:	c1 e0 04             	shl    $0x4,%eax
  803d86:	05 60 f2 81 00       	add    $0x81f260,%eax
  803d8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d94:	c1 e0 04             	shl    $0x4,%eax
  803d97:	05 64 f2 81 00       	add    $0x81f264,%eax
  803d9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da5:	c1 e0 04             	shl    $0x4,%eax
  803da8:	05 6c f2 81 00       	add    $0x81f26c,%eax
  803dad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803db3:	ff 45 f4             	incl   -0xc(%ebp)
  803db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803dbc:	72 c2                	jb     803d80 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803dbe:	8b 15 20 72 80 00    	mov    0x807220,%edx
  803dc4:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803dc9:	29 c2                	sub    %eax,%edx
  803dcb:	89 d0                	mov    %edx,%eax
  803dcd:	c1 e8 0c             	shr    $0xc,%eax
  803dd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803dd3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803dda:	e9 c8 00 00 00       	jmp    803ea7 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803ddf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803de2:	89 d0                	mov    %edx,%eax
  803de4:	01 c0                	add    %eax,%eax
  803de6:	01 d0                	add    %edx,%eax
  803de8:	c1 e0 02             	shl    $0x2,%eax
  803deb:	05 48 72 80 00       	add    $0x807248,%eax
  803df0:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803df5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803df8:	89 d0                	mov    %edx,%eax
  803dfa:	01 c0                	add    %eax,%eax
  803dfc:	01 d0                	add    %edx,%eax
  803dfe:	c1 e0 02             	shl    $0x2,%eax
  803e01:	05 4a 72 80 00       	add    $0x80724a,%eax
  803e06:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803e0b:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  803e11:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803e14:	89 c8                	mov    %ecx,%eax
  803e16:	01 c0                	add    %eax,%eax
  803e18:	01 c8                	add    %ecx,%eax
  803e1a:	c1 e0 02             	shl    $0x2,%eax
  803e1d:	05 44 72 80 00       	add    $0x807244,%eax
  803e22:	89 10                	mov    %edx,(%eax)
  803e24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e27:	89 d0                	mov    %edx,%eax
  803e29:	01 c0                	add    %eax,%eax
  803e2b:	01 d0                	add    %edx,%eax
  803e2d:	c1 e0 02             	shl    $0x2,%eax
  803e30:	05 44 72 80 00       	add    $0x807244,%eax
  803e35:	8b 00                	mov    (%eax),%eax
  803e37:	85 c0                	test   %eax,%eax
  803e39:	74 1b                	je     803e56 <initialize_dynamic_allocator+0x147>
  803e3b:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  803e41:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803e44:	89 c8                	mov    %ecx,%eax
  803e46:	01 c0                	add    %eax,%eax
  803e48:	01 c8                	add    %ecx,%eax
  803e4a:	c1 e0 02             	shl    $0x2,%eax
  803e4d:	05 40 72 80 00       	add    $0x807240,%eax
  803e52:	89 02                	mov    %eax,(%edx)
  803e54:	eb 16                	jmp    803e6c <initialize_dynamic_allocator+0x15d>
  803e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e59:	89 d0                	mov    %edx,%eax
  803e5b:	01 c0                	add    %eax,%eax
  803e5d:	01 d0                	add    %edx,%eax
  803e5f:	c1 e0 02             	shl    $0x2,%eax
  803e62:	05 40 72 80 00       	add    $0x807240,%eax
  803e67:	a3 28 72 80 00       	mov    %eax,0x807228
  803e6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e6f:	89 d0                	mov    %edx,%eax
  803e71:	01 c0                	add    %eax,%eax
  803e73:	01 d0                	add    %edx,%eax
  803e75:	c1 e0 02             	shl    $0x2,%eax
  803e78:	05 40 72 80 00       	add    $0x807240,%eax
  803e7d:	a3 2c 72 80 00       	mov    %eax,0x80722c
  803e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e85:	89 d0                	mov    %edx,%eax
  803e87:	01 c0                	add    %eax,%eax
  803e89:	01 d0                	add    %edx,%eax
  803e8b:	c1 e0 02             	shl    $0x2,%eax
  803e8e:	05 40 72 80 00       	add    $0x807240,%eax
  803e93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e99:	a1 34 72 80 00       	mov    0x807234,%eax
  803e9e:	40                   	inc    %eax
  803e9f:	a3 34 72 80 00       	mov    %eax,0x807234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803ea4:	ff 45 f0             	incl   -0x10(%ebp)
  803ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eaa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ead:	0f 82 2c ff ff ff    	jb     803ddf <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803eb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803eb9:	eb 2f                	jmp    803eea <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ebe:	89 d0                	mov    %edx,%eax
  803ec0:	01 c0                	add    %eax,%eax
  803ec2:	01 d0                	add    %edx,%eax
  803ec4:	c1 e0 02             	shl    $0x2,%eax
  803ec7:	05 48 72 80 00       	add    $0x807248,%eax
  803ecc:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803ed1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ed4:	89 d0                	mov    %edx,%eax
  803ed6:	01 c0                	add    %eax,%eax
  803ed8:	01 d0                	add    %edx,%eax
  803eda:	c1 e0 02             	shl    $0x2,%eax
  803edd:	05 4a 72 80 00       	add    $0x80724a,%eax
  803ee2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803ee7:	ff 45 ec             	incl   -0x14(%ebp)
  803eea:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803ef1:	76 c8                	jbe    803ebb <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803ef3:	90                   	nop
  803ef4:	c9                   	leave  
  803ef5:	c3                   	ret    

00803ef6 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803ef6:	55                   	push   %ebp
  803ef7:	89 e5                	mov    %esp,%ebp
  803ef9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803efc:	8b 55 08             	mov    0x8(%ebp),%edx
  803eff:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803f04:	29 c2                	sub    %eax,%edx
  803f06:	89 d0                	mov    %edx,%eax
  803f08:	c1 e8 0c             	shr    $0xc,%eax
  803f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803f11:	89 d0                	mov    %edx,%eax
  803f13:	01 c0                	add    %eax,%eax
  803f15:	01 d0                	add    %edx,%eax
  803f17:	c1 e0 02             	shl    $0x2,%eax
  803f1a:	05 48 72 80 00       	add    $0x807248,%eax
  803f1f:	8b 00                	mov    (%eax),%eax
  803f21:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803f24:	c9                   	leave  
  803f25:	c3                   	ret    

00803f26 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803f26:	55                   	push   %ebp
  803f27:	89 e5                	mov    %esp,%ebp
  803f29:	83 ec 14             	sub    $0x14,%esp
  803f2c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803f2f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803f33:	77 07                	ja     803f3c <nearest_pow2_ceil.1513+0x16>
  803f35:	b8 01 00 00 00       	mov    $0x1,%eax
  803f3a:	eb 20                	jmp    803f5c <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803f3c:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803f43:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803f46:	eb 08                	jmp    803f50 <nearest_pow2_ceil.1513+0x2a>
  803f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f4b:	01 c0                	add    %eax,%eax
  803f4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803f50:	d1 6d 08             	shrl   0x8(%ebp)
  803f53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f57:	75 ef                	jne    803f48 <nearest_pow2_ceil.1513+0x22>
        return power;
  803f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803f5c:	c9                   	leave  
  803f5d:	c3                   	ret    

00803f5e <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803f5e:	55                   	push   %ebp
  803f5f:	89 e5                	mov    %esp,%ebp
  803f61:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803f64:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803f6b:	76 16                	jbe    803f83 <alloc_block+0x25>
  803f6d:	68 a4 5f 80 00       	push   $0x805fa4
  803f72:	68 8e 5f 80 00       	push   $0x805f8e
  803f77:	6a 72                	push   $0x72
  803f79:	68 2b 5f 80 00       	push   $0x805f2b
  803f7e:	e8 46 d8 ff ff       	call   8017c9 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803f83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f87:	75 0a                	jne    803f93 <alloc_block+0x35>
  803f89:	b8 00 00 00 00       	mov    $0x0,%eax
  803f8e:	e9 bd 04 00 00       	jmp    804450 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803f93:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803fa0:	73 06                	jae    803fa8 <alloc_block+0x4a>
        size = min_block_size;
  803fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fa5:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803fa8:	83 ec 0c             	sub    $0xc,%esp
  803fab:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803fae:	ff 75 08             	pushl  0x8(%ebp)
  803fb1:	89 c1                	mov    %eax,%ecx
  803fb3:	e8 6e ff ff ff       	call   803f26 <nearest_pow2_ceil.1513>
  803fb8:	83 c4 10             	add    $0x10,%esp
  803fbb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803fbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fc1:	83 ec 0c             	sub    $0xc,%esp
  803fc4:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803fc7:	52                   	push   %edx
  803fc8:	89 c1                	mov    %eax,%ecx
  803fca:	e8 83 04 00 00       	call   804452 <log2_ceil.1520>
  803fcf:	83 c4 10             	add    $0x10,%esp
  803fd2:	83 e8 03             	sub    $0x3,%eax
  803fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fdb:	c1 e0 04             	shl    $0x4,%eax
  803fde:	05 60 f2 81 00       	add    $0x81f260,%eax
  803fe3:	8b 00                	mov    (%eax),%eax
  803fe5:	85 c0                	test   %eax,%eax
  803fe7:	0f 84 d8 00 00 00    	je     8040c5 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803fed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff0:	c1 e0 04             	shl    $0x4,%eax
  803ff3:	05 60 f2 81 00       	add    $0x81f260,%eax
  803ff8:	8b 00                	mov    (%eax),%eax
  803ffa:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803ffd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804001:	75 17                	jne    80401a <alloc_block+0xbc>
  804003:	83 ec 04             	sub    $0x4,%esp
  804006:	68 c5 5f 80 00       	push   $0x805fc5
  80400b:	68 98 00 00 00       	push   $0x98
  804010:	68 2b 5f 80 00       	push   $0x805f2b
  804015:	e8 af d7 ff ff       	call   8017c9 <_panic>
  80401a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80401d:	8b 00                	mov    (%eax),%eax
  80401f:	85 c0                	test   %eax,%eax
  804021:	74 10                	je     804033 <alloc_block+0xd5>
  804023:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804026:	8b 00                	mov    (%eax),%eax
  804028:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80402b:	8b 52 04             	mov    0x4(%edx),%edx
  80402e:	89 50 04             	mov    %edx,0x4(%eax)
  804031:	eb 14                	jmp    804047 <alloc_block+0xe9>
  804033:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804036:	8b 40 04             	mov    0x4(%eax),%eax
  804039:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80403c:	c1 e2 04             	shl    $0x4,%edx
  80403f:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804045:	89 02                	mov    %eax,(%edx)
  804047:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80404a:	8b 40 04             	mov    0x4(%eax),%eax
  80404d:	85 c0                	test   %eax,%eax
  80404f:	74 0f                	je     804060 <alloc_block+0x102>
  804051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804054:	8b 40 04             	mov    0x4(%eax),%eax
  804057:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80405a:	8b 12                	mov    (%edx),%edx
  80405c:	89 10                	mov    %edx,(%eax)
  80405e:	eb 13                	jmp    804073 <alloc_block+0x115>
  804060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804063:	8b 00                	mov    (%eax),%eax
  804065:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804068:	c1 e2 04             	shl    $0x4,%edx
  80406b:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804071:	89 02                	mov    %eax,(%edx)
  804073:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80407c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80407f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804089:	c1 e0 04             	shl    $0x4,%eax
  80408c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804091:	8b 00                	mov    (%eax),%eax
  804093:	8d 50 ff             	lea    -0x1(%eax),%edx
  804096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804099:	c1 e0 04             	shl    $0x4,%eax
  80409c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8040a1:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8040a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040a6:	83 ec 0c             	sub    $0xc,%esp
  8040a9:	50                   	push   %eax
  8040aa:	e8 12 fc ff ff       	call   803cc1 <to_page_info>
  8040af:	83 c4 10             	add    $0x10,%esp
  8040b2:	89 c2                	mov    %eax,%edx
  8040b4:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8040b8:	48                   	dec    %eax
  8040b9:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  8040bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040c0:	e9 8b 03 00 00       	jmp    804450 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  8040c5:	a1 28 72 80 00       	mov    0x807228,%eax
  8040ca:	85 c0                	test   %eax,%eax
  8040cc:	0f 84 64 02 00 00    	je     804336 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  8040d2:	a1 28 72 80 00       	mov    0x807228,%eax
  8040d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8040da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8040de:	75 17                	jne    8040f7 <alloc_block+0x199>
  8040e0:	83 ec 04             	sub    $0x4,%esp
  8040e3:	68 c5 5f 80 00       	push   $0x805fc5
  8040e8:	68 a0 00 00 00       	push   $0xa0
  8040ed:	68 2b 5f 80 00       	push   $0x805f2b
  8040f2:	e8 d2 d6 ff ff       	call   8017c9 <_panic>
  8040f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040fa:	8b 00                	mov    (%eax),%eax
  8040fc:	85 c0                	test   %eax,%eax
  8040fe:	74 10                	je     804110 <alloc_block+0x1b2>
  804100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804103:	8b 00                	mov    (%eax),%eax
  804105:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804108:	8b 52 04             	mov    0x4(%edx),%edx
  80410b:	89 50 04             	mov    %edx,0x4(%eax)
  80410e:	eb 0b                	jmp    80411b <alloc_block+0x1bd>
  804110:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804113:	8b 40 04             	mov    0x4(%eax),%eax
  804116:	a3 2c 72 80 00       	mov    %eax,0x80722c
  80411b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80411e:	8b 40 04             	mov    0x4(%eax),%eax
  804121:	85 c0                	test   %eax,%eax
  804123:	74 0f                	je     804134 <alloc_block+0x1d6>
  804125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804128:	8b 40 04             	mov    0x4(%eax),%eax
  80412b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80412e:	8b 12                	mov    (%edx),%edx
  804130:	89 10                	mov    %edx,(%eax)
  804132:	eb 0a                	jmp    80413e <alloc_block+0x1e0>
  804134:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804137:	8b 00                	mov    (%eax),%eax
  804139:	a3 28 72 80 00       	mov    %eax,0x807228
  80413e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804141:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804147:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80414a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804151:	a1 34 72 80 00       	mov    0x807234,%eax
  804156:	48                   	dec    %eax
  804157:	a3 34 72 80 00       	mov    %eax,0x807234

        page_info_e->block_size = pow;
  80415c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80415f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804162:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  804166:	b8 00 10 00 00       	mov    $0x1000,%eax
  80416b:	99                   	cltd   
  80416c:	f7 7d e8             	idivl  -0x18(%ebp)
  80416f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804172:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  804176:	83 ec 0c             	sub    $0xc,%esp
  804179:	ff 75 dc             	pushl  -0x24(%ebp)
  80417c:	e8 ce fa ff ff       	call   803c4f <to_page_va>
  804181:	83 c4 10             	add    $0x10,%esp
  804184:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  804187:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80418a:	83 ec 0c             	sub    $0xc,%esp
  80418d:	50                   	push   %eax
  80418e:	e8 c0 ee ff ff       	call   803053 <get_page>
  804193:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  804196:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80419d:	e9 aa 00 00 00       	jmp    80424c <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  8041a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041a5:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  8041a9:	89 c2                	mov    %eax,%edx
  8041ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8041ae:	01 d0                	add    %edx,%eax
  8041b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8041b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8041b7:	75 17                	jne    8041d0 <alloc_block+0x272>
  8041b9:	83 ec 04             	sub    $0x4,%esp
  8041bc:	68 e4 5f 80 00       	push   $0x805fe4
  8041c1:	68 aa 00 00 00       	push   $0xaa
  8041c6:	68 2b 5f 80 00       	push   $0x805f2b
  8041cb:	e8 f9 d5 ff ff       	call   8017c9 <_panic>
  8041d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d3:	c1 e0 04             	shl    $0x4,%eax
  8041d6:	05 64 f2 81 00       	add    $0x81f264,%eax
  8041db:	8b 10                	mov    (%eax),%edx
  8041dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e0:	89 50 04             	mov    %edx,0x4(%eax)
  8041e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e6:	8b 40 04             	mov    0x4(%eax),%eax
  8041e9:	85 c0                	test   %eax,%eax
  8041eb:	74 14                	je     804201 <alloc_block+0x2a3>
  8041ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f0:	c1 e0 04             	shl    $0x4,%eax
  8041f3:	05 64 f2 81 00       	add    $0x81f264,%eax
  8041f8:	8b 00                	mov    (%eax),%eax
  8041fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041fd:	89 10                	mov    %edx,(%eax)
  8041ff:	eb 11                	jmp    804212 <alloc_block+0x2b4>
  804201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804204:	c1 e0 04             	shl    $0x4,%eax
  804207:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  80420d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804210:	89 02                	mov    %eax,(%edx)
  804212:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804215:	c1 e0 04             	shl    $0x4,%eax
  804218:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  80421e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804221:	89 02                	mov    %eax,(%edx)
  804223:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80422c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80422f:	c1 e0 04             	shl    $0x4,%eax
  804232:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804237:	8b 00                	mov    (%eax),%eax
  804239:	8d 50 01             	lea    0x1(%eax),%edx
  80423c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423f:	c1 e0 04             	shl    $0x4,%eax
  804242:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804247:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  804249:	ff 45 f4             	incl   -0xc(%ebp)
  80424c:	b8 00 10 00 00       	mov    $0x1000,%eax
  804251:	99                   	cltd   
  804252:	f7 7d e8             	idivl  -0x18(%ebp)
  804255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804258:	0f 8f 44 ff ff ff    	jg     8041a2 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80425e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804261:	c1 e0 04             	shl    $0x4,%eax
  804264:	05 60 f2 81 00       	add    $0x81f260,%eax
  804269:	8b 00                	mov    (%eax),%eax
  80426b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80426e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804272:	75 17                	jne    80428b <alloc_block+0x32d>
  804274:	83 ec 04             	sub    $0x4,%esp
  804277:	68 c5 5f 80 00       	push   $0x805fc5
  80427c:	68 ae 00 00 00       	push   $0xae
  804281:	68 2b 5f 80 00       	push   $0x805f2b
  804286:	e8 3e d5 ff ff       	call   8017c9 <_panic>
  80428b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80428e:	8b 00                	mov    (%eax),%eax
  804290:	85 c0                	test   %eax,%eax
  804292:	74 10                	je     8042a4 <alloc_block+0x346>
  804294:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804297:	8b 00                	mov    (%eax),%eax
  804299:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80429c:	8b 52 04             	mov    0x4(%edx),%edx
  80429f:	89 50 04             	mov    %edx,0x4(%eax)
  8042a2:	eb 14                	jmp    8042b8 <alloc_block+0x35a>
  8042a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042a7:	8b 40 04             	mov    0x4(%eax),%eax
  8042aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042ad:	c1 e2 04             	shl    $0x4,%edx
  8042b0:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8042b6:	89 02                	mov    %eax,(%edx)
  8042b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042bb:	8b 40 04             	mov    0x4(%eax),%eax
  8042be:	85 c0                	test   %eax,%eax
  8042c0:	74 0f                	je     8042d1 <alloc_block+0x373>
  8042c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042c5:	8b 40 04             	mov    0x4(%eax),%eax
  8042c8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8042cb:	8b 12                	mov    (%edx),%edx
  8042cd:	89 10                	mov    %edx,(%eax)
  8042cf:	eb 13                	jmp    8042e4 <alloc_block+0x386>
  8042d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042d4:	8b 00                	mov    (%eax),%eax
  8042d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042d9:	c1 e2 04             	shl    $0x4,%edx
  8042dc:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8042e2:	89 02                	mov    %eax,(%edx)
  8042e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042fa:	c1 e0 04             	shl    $0x4,%eax
  8042fd:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804302:	8b 00                	mov    (%eax),%eax
  804304:	8d 50 ff             	lea    -0x1(%eax),%edx
  804307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80430a:	c1 e0 04             	shl    $0x4,%eax
  80430d:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804312:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  804314:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804317:	83 ec 0c             	sub    $0xc,%esp
  80431a:	50                   	push   %eax
  80431b:	e8 a1 f9 ff ff       	call   803cc1 <to_page_info>
  804320:	83 c4 10             	add    $0x10,%esp
  804323:	89 c2                	mov    %eax,%edx
  804325:	66 8b 42 0a          	mov    0xa(%edx),%ax
  804329:	48                   	dec    %eax
  80432a:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  80432e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804331:	e9 1a 01 00 00       	jmp    804450 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  804336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804339:	40                   	inc    %eax
  80433a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80433d:	e9 ed 00 00 00       	jmp    80442f <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  804342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804345:	c1 e0 04             	shl    $0x4,%eax
  804348:	05 60 f2 81 00       	add    $0x81f260,%eax
  80434d:	8b 00                	mov    (%eax),%eax
  80434f:	85 c0                	test   %eax,%eax
  804351:	0f 84 d5 00 00 00    	je     80442c <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  804357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80435a:	c1 e0 04             	shl    $0x4,%eax
  80435d:	05 60 f2 81 00       	add    $0x81f260,%eax
  804362:	8b 00                	mov    (%eax),%eax
  804364:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  804367:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80436b:	75 17                	jne    804384 <alloc_block+0x426>
  80436d:	83 ec 04             	sub    $0x4,%esp
  804370:	68 c5 5f 80 00       	push   $0x805fc5
  804375:	68 b8 00 00 00       	push   $0xb8
  80437a:	68 2b 5f 80 00       	push   $0x805f2b
  80437f:	e8 45 d4 ff ff       	call   8017c9 <_panic>
  804384:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804387:	8b 00                	mov    (%eax),%eax
  804389:	85 c0                	test   %eax,%eax
  80438b:	74 10                	je     80439d <alloc_block+0x43f>
  80438d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804390:	8b 00                	mov    (%eax),%eax
  804392:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804395:	8b 52 04             	mov    0x4(%edx),%edx
  804398:	89 50 04             	mov    %edx,0x4(%eax)
  80439b:	eb 14                	jmp    8043b1 <alloc_block+0x453>
  80439d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043a0:	8b 40 04             	mov    0x4(%eax),%eax
  8043a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043a6:	c1 e2 04             	shl    $0x4,%edx
  8043a9:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8043af:	89 02                	mov    %eax,(%edx)
  8043b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043b4:	8b 40 04             	mov    0x4(%eax),%eax
  8043b7:	85 c0                	test   %eax,%eax
  8043b9:	74 0f                	je     8043ca <alloc_block+0x46c>
  8043bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043be:	8b 40 04             	mov    0x4(%eax),%eax
  8043c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8043c4:	8b 12                	mov    (%edx),%edx
  8043c6:	89 10                	mov    %edx,(%eax)
  8043c8:	eb 13                	jmp    8043dd <alloc_block+0x47f>
  8043ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043cd:	8b 00                	mov    (%eax),%eax
  8043cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043d2:	c1 e2 04             	shl    $0x4,%edx
  8043d5:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8043db:	89 02                	mov    %eax,(%edx)
  8043dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043f3:	c1 e0 04             	shl    $0x4,%eax
  8043f6:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8043fb:	8b 00                	mov    (%eax),%eax
  8043fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  804400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804403:	c1 e0 04             	shl    $0x4,%eax
  804406:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80440b:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  80440d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804410:	83 ec 0c             	sub    $0xc,%esp
  804413:	50                   	push   %eax
  804414:	e8 a8 f8 ff ff       	call   803cc1 <to_page_info>
  804419:	83 c4 10             	add    $0x10,%esp
  80441c:	89 c2                	mov    %eax,%edx
  80441e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  804422:	48                   	dec    %eax
  804423:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  804427:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80442a:	eb 24                	jmp    804450 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80442c:	ff 45 f0             	incl   -0x10(%ebp)
  80442f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  804433:	0f 8e 09 ff ff ff    	jle    804342 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  804439:	83 ec 04             	sub    $0x4,%esp
  80443c:	68 07 60 80 00       	push   $0x806007
  804441:	68 bf 00 00 00       	push   $0xbf
  804446:	68 2b 5f 80 00       	push   $0x805f2b
  80444b:	e8 79 d3 ff ff       	call   8017c9 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804450:	c9                   	leave  
  804451:	c3                   	ret    

00804452 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  804452:	55                   	push   %ebp
  804453:	89 e5                	mov    %esp,%ebp
  804455:	83 ec 14             	sub    $0x14,%esp
  804458:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  80445b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80445f:	75 07                	jne    804468 <log2_ceil.1520+0x16>
  804461:	b8 00 00 00 00       	mov    $0x0,%eax
  804466:	eb 1b                	jmp    804483 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  804468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80446f:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  804472:	eb 06                	jmp    80447a <log2_ceil.1520+0x28>
            x >>= 1;
  804474:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  804477:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80447a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80447e:	75 f4                	jne    804474 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  804480:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  804483:	c9                   	leave  
  804484:	c3                   	ret    

00804485 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  804485:	55                   	push   %ebp
  804486:	89 e5                	mov    %esp,%ebp
  804488:	83 ec 14             	sub    $0x14,%esp
  80448b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80448e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804492:	75 07                	jne    80449b <log2_ceil.1547+0x16>
  804494:	b8 00 00 00 00       	mov    $0x0,%eax
  804499:	eb 1b                	jmp    8044b6 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80449b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8044a2:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8044a5:	eb 06                	jmp    8044ad <log2_ceil.1547+0x28>
			x >>= 1;
  8044a7:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8044aa:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8044ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044b1:	75 f4                	jne    8044a7 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8044b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8044b6:	c9                   	leave  
  8044b7:	c3                   	ret    

008044b8 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8044b8:	55                   	push   %ebp
  8044b9:	89 e5                	mov    %esp,%ebp
  8044bb:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8044be:	8b 55 08             	mov    0x8(%ebp),%edx
  8044c1:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8044c6:	39 c2                	cmp    %eax,%edx
  8044c8:	72 0c                	jb     8044d6 <free_block+0x1e>
  8044ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8044cd:	a1 20 72 80 00       	mov    0x807220,%eax
  8044d2:	39 c2                	cmp    %eax,%edx
  8044d4:	72 19                	jb     8044ef <free_block+0x37>
  8044d6:	68 0c 60 80 00       	push   $0x80600c
  8044db:	68 8e 5f 80 00       	push   $0x805f8e
  8044e0:	68 d0 00 00 00       	push   $0xd0
  8044e5:	68 2b 5f 80 00       	push   $0x805f2b
  8044ea:	e8 da d2 ff ff       	call   8017c9 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8044ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044f3:	0f 84 42 03 00 00    	je     80483b <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8044f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8044fc:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804501:	39 c2                	cmp    %eax,%edx
  804503:	72 0c                	jb     804511 <free_block+0x59>
  804505:	8b 55 08             	mov    0x8(%ebp),%edx
  804508:	a1 20 72 80 00       	mov    0x807220,%eax
  80450d:	39 c2                	cmp    %eax,%edx
  80450f:	72 17                	jb     804528 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  804511:	83 ec 04             	sub    $0x4,%esp
  804514:	68 44 60 80 00       	push   $0x806044
  804519:	68 e6 00 00 00       	push   $0xe6
  80451e:	68 2b 5f 80 00       	push   $0x805f2b
  804523:	e8 a1 d2 ff ff       	call   8017c9 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  804528:	8b 55 08             	mov    0x8(%ebp),%edx
  80452b:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804530:	29 c2                	sub    %eax,%edx
  804532:	89 d0                	mov    %edx,%eax
  804534:	83 e0 07             	and    $0x7,%eax
  804537:	85 c0                	test   %eax,%eax
  804539:	74 17                	je     804552 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80453b:	83 ec 04             	sub    $0x4,%esp
  80453e:	68 78 60 80 00       	push   $0x806078
  804543:	68 ea 00 00 00       	push   $0xea
  804548:	68 2b 5f 80 00       	push   $0x805f2b
  80454d:	e8 77 d2 ff ff       	call   8017c9 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  804552:	8b 45 08             	mov    0x8(%ebp),%eax
  804555:	83 ec 0c             	sub    $0xc,%esp
  804558:	50                   	push   %eax
  804559:	e8 63 f7 ff ff       	call   803cc1 <to_page_info>
  80455e:	83 c4 10             	add    $0x10,%esp
  804561:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  804564:	83 ec 0c             	sub    $0xc,%esp
  804567:	ff 75 08             	pushl  0x8(%ebp)
  80456a:	e8 87 f9 ff ff       	call   803ef6 <get_block_size>
  80456f:	83 c4 10             	add    $0x10,%esp
  804572:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  804575:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804579:	75 17                	jne    804592 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80457b:	83 ec 04             	sub    $0x4,%esp
  80457e:	68 a4 60 80 00       	push   $0x8060a4
  804583:	68 f1 00 00 00       	push   $0xf1
  804588:	68 2b 5f 80 00       	push   $0x805f2b
  80458d:	e8 37 d2 ff ff       	call   8017c9 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  804592:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804595:	83 ec 0c             	sub    $0xc,%esp
  804598:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80459b:	52                   	push   %edx
  80459c:	89 c1                	mov    %eax,%ecx
  80459e:	e8 e2 fe ff ff       	call   804485 <log2_ceil.1547>
  8045a3:	83 c4 10             	add    $0x10,%esp
  8045a6:	83 e8 03             	sub    $0x3,%eax
  8045a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8045ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8045af:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8045b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8045b6:	75 17                	jne    8045cf <free_block+0x117>
  8045b8:	83 ec 04             	sub    $0x4,%esp
  8045bb:	68 f0 60 80 00       	push   $0x8060f0
  8045c0:	68 f6 00 00 00       	push   $0xf6
  8045c5:	68 2b 5f 80 00       	push   $0x805f2b
  8045ca:	e8 fa d1 ff ff       	call   8017c9 <_panic>
  8045cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045d2:	c1 e0 04             	shl    $0x4,%eax
  8045d5:	05 60 f2 81 00       	add    $0x81f260,%eax
  8045da:	8b 10                	mov    (%eax),%edx
  8045dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045df:	89 10                	mov    %edx,(%eax)
  8045e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045e4:	8b 00                	mov    (%eax),%eax
  8045e6:	85 c0                	test   %eax,%eax
  8045e8:	74 15                	je     8045ff <free_block+0x147>
  8045ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ed:	c1 e0 04             	shl    $0x4,%eax
  8045f0:	05 60 f2 81 00       	add    $0x81f260,%eax
  8045f5:	8b 00                	mov    (%eax),%eax
  8045f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8045fa:	89 50 04             	mov    %edx,0x4(%eax)
  8045fd:	eb 11                	jmp    804610 <free_block+0x158>
  8045ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804602:	c1 e0 04             	shl    $0x4,%eax
  804605:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  80460b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80460e:	89 02                	mov    %eax,(%edx)
  804610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804613:	c1 e0 04             	shl    $0x4,%eax
  804616:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  80461c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80461f:	89 02                	mov    %eax,(%edx)
  804621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804624:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80462b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80462e:	c1 e0 04             	shl    $0x4,%eax
  804631:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804636:	8b 00                	mov    (%eax),%eax
  804638:	8d 50 01             	lea    0x1(%eax),%edx
  80463b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80463e:	c1 e0 04             	shl    $0x4,%eax
  804641:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804646:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  804648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80464b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80464f:	40                   	inc    %eax
  804650:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804653:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  804657:	8b 55 08             	mov    0x8(%ebp),%edx
  80465a:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80465f:	29 c2                	sub    %eax,%edx
  804661:	89 d0                	mov    %edx,%eax
  804663:	c1 e8 0c             	shr    $0xc,%eax
  804666:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  804669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80466c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804670:	0f b7 c8             	movzwl %ax,%ecx
  804673:	b8 00 10 00 00       	mov    $0x1000,%eax
  804678:	99                   	cltd   
  804679:	f7 7d e8             	idivl  -0x18(%ebp)
  80467c:	39 c1                	cmp    %eax,%ecx
  80467e:	0f 85 b8 01 00 00    	jne    80483c <free_block+0x384>
    	uint32 blocks_removed = 0;
  804684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80468b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80468e:	c1 e0 04             	shl    $0x4,%eax
  804691:	05 60 f2 81 00       	add    $0x81f260,%eax
  804696:	8b 00                	mov    (%eax),%eax
  804698:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80469b:	e9 d5 00 00 00       	jmp    804775 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8046a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046a3:	8b 00                	mov    (%eax),%eax
  8046a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8046a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8046ab:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8046b0:	29 c2                	sub    %eax,%edx
  8046b2:	89 d0                	mov    %edx,%eax
  8046b4:	c1 e8 0c             	shr    $0xc,%eax
  8046b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8046ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046bd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8046c0:	0f 85 a9 00 00 00    	jne    80476f <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8046c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8046ca:	75 17                	jne    8046e3 <free_block+0x22b>
  8046cc:	83 ec 04             	sub    $0x4,%esp
  8046cf:	68 c5 5f 80 00       	push   $0x805fc5
  8046d4:	68 04 01 00 00       	push   $0x104
  8046d9:	68 2b 5f 80 00       	push   $0x805f2b
  8046de:	e8 e6 d0 ff ff       	call   8017c9 <_panic>
  8046e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046e6:	8b 00                	mov    (%eax),%eax
  8046e8:	85 c0                	test   %eax,%eax
  8046ea:	74 10                	je     8046fc <free_block+0x244>
  8046ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046ef:	8b 00                	mov    (%eax),%eax
  8046f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8046f4:	8b 52 04             	mov    0x4(%edx),%edx
  8046f7:	89 50 04             	mov    %edx,0x4(%eax)
  8046fa:	eb 14                	jmp    804710 <free_block+0x258>
  8046fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046ff:	8b 40 04             	mov    0x4(%eax),%eax
  804702:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804705:	c1 e2 04             	shl    $0x4,%edx
  804708:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  80470e:	89 02                	mov    %eax,(%edx)
  804710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804713:	8b 40 04             	mov    0x4(%eax),%eax
  804716:	85 c0                	test   %eax,%eax
  804718:	74 0f                	je     804729 <free_block+0x271>
  80471a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80471d:	8b 40 04             	mov    0x4(%eax),%eax
  804720:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804723:	8b 12                	mov    (%edx),%edx
  804725:	89 10                	mov    %edx,(%eax)
  804727:	eb 13                	jmp    80473c <free_block+0x284>
  804729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80472c:	8b 00                	mov    (%eax),%eax
  80472e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804731:	c1 e2 04             	shl    $0x4,%edx
  804734:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  80473a:	89 02                	mov    %eax,(%edx)
  80473c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80473f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804748:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80474f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804752:	c1 e0 04             	shl    $0x4,%eax
  804755:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80475a:	8b 00                	mov    (%eax),%eax
  80475c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80475f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804762:	c1 e0 04             	shl    $0x4,%eax
  804765:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80476a:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80476c:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80476f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804772:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804779:	0f 85 21 ff ff ff    	jne    8046a0 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80477f:	b8 00 10 00 00       	mov    $0x1000,%eax
  804784:	99                   	cltd   
  804785:	f7 7d e8             	idivl  -0x18(%ebp)
  804788:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80478b:	74 17                	je     8047a4 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80478d:	83 ec 04             	sub    $0x4,%esp
  804790:	68 14 61 80 00       	push   $0x806114
  804795:	68 0c 01 00 00       	push   $0x10c
  80479a:	68 2b 5f 80 00       	push   $0x805f2b
  80479f:	e8 25 d0 ff ff       	call   8017c9 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8047a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047a7:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8047ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047b0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8047b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8047ba:	75 17                	jne    8047d3 <free_block+0x31b>
  8047bc:	83 ec 04             	sub    $0x4,%esp
  8047bf:	68 e4 5f 80 00       	push   $0x805fe4
  8047c4:	68 11 01 00 00       	push   $0x111
  8047c9:	68 2b 5f 80 00       	push   $0x805f2b
  8047ce:	e8 f6 cf ff ff       	call   8017c9 <_panic>
  8047d3:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  8047d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047dc:	89 50 04             	mov    %edx,0x4(%eax)
  8047df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047e2:	8b 40 04             	mov    0x4(%eax),%eax
  8047e5:	85 c0                	test   %eax,%eax
  8047e7:	74 0c                	je     8047f5 <free_block+0x33d>
  8047e9:	a1 2c 72 80 00       	mov    0x80722c,%eax
  8047ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8047f1:	89 10                	mov    %edx,(%eax)
  8047f3:	eb 08                	jmp    8047fd <free_block+0x345>
  8047f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047f8:	a3 28 72 80 00       	mov    %eax,0x807228
  8047fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804800:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80480e:	a1 34 72 80 00       	mov    0x807234,%eax
  804813:	40                   	inc    %eax
  804814:	a3 34 72 80 00       	mov    %eax,0x807234

        uint32 pp = to_page_va(page_info_e);
  804819:	83 ec 0c             	sub    $0xc,%esp
  80481c:	ff 75 ec             	pushl  -0x14(%ebp)
  80481f:	e8 2b f4 ff ff       	call   803c4f <to_page_va>
  804824:	83 c4 10             	add    $0x10,%esp
  804827:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80482a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80482d:	83 ec 0c             	sub    $0xc,%esp
  804830:	50                   	push   %eax
  804831:	e8 69 e8 ff ff       	call   80309f <return_page>
  804836:	83 c4 10             	add    $0x10,%esp
  804839:	eb 01                	jmp    80483c <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80483b:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80483c:	c9                   	leave  
  80483d:	c3                   	ret    

0080483e <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80483e:	55                   	push   %ebp
  80483f:	89 e5                	mov    %esp,%ebp
  804841:	83 ec 14             	sub    $0x14,%esp
  804844:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  804847:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80484b:	77 07                	ja     804854 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80484d:	b8 01 00 00 00       	mov    $0x1,%eax
  804852:	eb 20                	jmp    804874 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  804854:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80485b:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  80485e:	eb 08                	jmp    804868 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  804860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804863:	01 c0                	add    %eax,%eax
  804865:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  804868:	d1 6d 08             	shrl   0x8(%ebp)
  80486b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80486f:	75 ef                	jne    804860 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  804871:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  804874:	c9                   	leave  
  804875:	c3                   	ret    

00804876 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  804876:	55                   	push   %ebp
  804877:	89 e5                	mov    %esp,%ebp
  804879:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80487c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804880:	75 13                	jne    804895 <realloc_block+0x1f>
    return alloc_block(new_size);
  804882:	83 ec 0c             	sub    $0xc,%esp
  804885:	ff 75 0c             	pushl  0xc(%ebp)
  804888:	e8 d1 f6 ff ff       	call   803f5e <alloc_block>
  80488d:	83 c4 10             	add    $0x10,%esp
  804890:	e9 d9 00 00 00       	jmp    80496e <realloc_block+0xf8>
  }

  if (new_size == 0) {
  804895:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804899:	75 18                	jne    8048b3 <realloc_block+0x3d>
    free_block(va);
  80489b:	83 ec 0c             	sub    $0xc,%esp
  80489e:	ff 75 08             	pushl  0x8(%ebp)
  8048a1:	e8 12 fc ff ff       	call   8044b8 <free_block>
  8048a6:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8048a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ae:	e9 bb 00 00 00       	jmp    80496e <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8048b3:	83 ec 0c             	sub    $0xc,%esp
  8048b6:	ff 75 08             	pushl  0x8(%ebp)
  8048b9:	e8 38 f6 ff ff       	call   803ef6 <get_block_size>
  8048be:	83 c4 10             	add    $0x10,%esp
  8048c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8048c4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8048cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8048ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8048d1:	73 06                	jae    8048d9 <realloc_block+0x63>
    new_size = min_block_size;
  8048d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8048d6:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8048d9:	83 ec 0c             	sub    $0xc,%esp
  8048dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8048df:	ff 75 0c             	pushl  0xc(%ebp)
  8048e2:	89 c1                	mov    %eax,%ecx
  8048e4:	e8 55 ff ff ff       	call   80483e <nearest_pow2_ceil.1572>
  8048e9:	83 c4 10             	add    $0x10,%esp
  8048ec:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8048ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8048f5:	75 05                	jne    8048fc <realloc_block+0x86>
    return va;
  8048f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8048fa:	eb 72                	jmp    80496e <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8048fc:	83 ec 0c             	sub    $0xc,%esp
  8048ff:	ff 75 0c             	pushl  0xc(%ebp)
  804902:	e8 57 f6 ff ff       	call   803f5e <alloc_block>
  804907:	83 c4 10             	add    $0x10,%esp
  80490a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80490d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804911:	75 07                	jne    80491a <realloc_block+0xa4>
    return NULL;
  804913:	b8 00 00 00 00       	mov    $0x0,%eax
  804918:	eb 54                	jmp    80496e <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80491a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80491d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804920:	39 d0                	cmp    %edx,%eax
  804922:	76 02                	jbe    804926 <realloc_block+0xb0>
  804924:	89 d0                	mov    %edx,%eax
  804926:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  804929:	8b 45 08             	mov    0x8(%ebp),%eax
  80492c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  80492f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804932:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  804935:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80493c:	eb 17                	jmp    804955 <realloc_block+0xdf>
    dst[i] = src[i];
  80493e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804944:	01 c2                	add    %eax,%edx
  804946:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  804949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80494c:	01 c8                	add    %ecx,%eax
  80494e:	8a 00                	mov    (%eax),%al
  804950:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  804952:	ff 45 f4             	incl   -0xc(%ebp)
  804955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804958:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80495b:	72 e1                	jb     80493e <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80495d:	83 ec 0c             	sub    $0xc,%esp
  804960:	ff 75 08             	pushl  0x8(%ebp)
  804963:	e8 50 fb ff ff       	call   8044b8 <free_block>
  804968:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80496b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80496e:	c9                   	leave  
  80496f:	c3                   	ret    

00804970 <__udivdi3>:
  804970:	55                   	push   %ebp
  804971:	57                   	push   %edi
  804972:	56                   	push   %esi
  804973:	53                   	push   %ebx
  804974:	83 ec 1c             	sub    $0x1c,%esp
  804977:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80497b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80497f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804983:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804987:	89 ca                	mov    %ecx,%edx
  804989:	89 f8                	mov    %edi,%eax
  80498b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80498f:	85 f6                	test   %esi,%esi
  804991:	75 2d                	jne    8049c0 <__udivdi3+0x50>
  804993:	39 cf                	cmp    %ecx,%edi
  804995:	77 65                	ja     8049fc <__udivdi3+0x8c>
  804997:	89 fd                	mov    %edi,%ebp
  804999:	85 ff                	test   %edi,%edi
  80499b:	75 0b                	jne    8049a8 <__udivdi3+0x38>
  80499d:	b8 01 00 00 00       	mov    $0x1,%eax
  8049a2:	31 d2                	xor    %edx,%edx
  8049a4:	f7 f7                	div    %edi
  8049a6:	89 c5                	mov    %eax,%ebp
  8049a8:	31 d2                	xor    %edx,%edx
  8049aa:	89 c8                	mov    %ecx,%eax
  8049ac:	f7 f5                	div    %ebp
  8049ae:	89 c1                	mov    %eax,%ecx
  8049b0:	89 d8                	mov    %ebx,%eax
  8049b2:	f7 f5                	div    %ebp
  8049b4:	89 cf                	mov    %ecx,%edi
  8049b6:	89 fa                	mov    %edi,%edx
  8049b8:	83 c4 1c             	add    $0x1c,%esp
  8049bb:	5b                   	pop    %ebx
  8049bc:	5e                   	pop    %esi
  8049bd:	5f                   	pop    %edi
  8049be:	5d                   	pop    %ebp
  8049bf:	c3                   	ret    
  8049c0:	39 ce                	cmp    %ecx,%esi
  8049c2:	77 28                	ja     8049ec <__udivdi3+0x7c>
  8049c4:	0f bd fe             	bsr    %esi,%edi
  8049c7:	83 f7 1f             	xor    $0x1f,%edi
  8049ca:	75 40                	jne    804a0c <__udivdi3+0x9c>
  8049cc:	39 ce                	cmp    %ecx,%esi
  8049ce:	72 0a                	jb     8049da <__udivdi3+0x6a>
  8049d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8049d4:	0f 87 9e 00 00 00    	ja     804a78 <__udivdi3+0x108>
  8049da:	b8 01 00 00 00       	mov    $0x1,%eax
  8049df:	89 fa                	mov    %edi,%edx
  8049e1:	83 c4 1c             	add    $0x1c,%esp
  8049e4:	5b                   	pop    %ebx
  8049e5:	5e                   	pop    %esi
  8049e6:	5f                   	pop    %edi
  8049e7:	5d                   	pop    %ebp
  8049e8:	c3                   	ret    
  8049e9:	8d 76 00             	lea    0x0(%esi),%esi
  8049ec:	31 ff                	xor    %edi,%edi
  8049ee:	31 c0                	xor    %eax,%eax
  8049f0:	89 fa                	mov    %edi,%edx
  8049f2:	83 c4 1c             	add    $0x1c,%esp
  8049f5:	5b                   	pop    %ebx
  8049f6:	5e                   	pop    %esi
  8049f7:	5f                   	pop    %edi
  8049f8:	5d                   	pop    %ebp
  8049f9:	c3                   	ret    
  8049fa:	66 90                	xchg   %ax,%ax
  8049fc:	89 d8                	mov    %ebx,%eax
  8049fe:	f7 f7                	div    %edi
  804a00:	31 ff                	xor    %edi,%edi
  804a02:	89 fa                	mov    %edi,%edx
  804a04:	83 c4 1c             	add    $0x1c,%esp
  804a07:	5b                   	pop    %ebx
  804a08:	5e                   	pop    %esi
  804a09:	5f                   	pop    %edi
  804a0a:	5d                   	pop    %ebp
  804a0b:	c3                   	ret    
  804a0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804a11:	89 eb                	mov    %ebp,%ebx
  804a13:	29 fb                	sub    %edi,%ebx
  804a15:	89 f9                	mov    %edi,%ecx
  804a17:	d3 e6                	shl    %cl,%esi
  804a19:	89 c5                	mov    %eax,%ebp
  804a1b:	88 d9                	mov    %bl,%cl
  804a1d:	d3 ed                	shr    %cl,%ebp
  804a1f:	89 e9                	mov    %ebp,%ecx
  804a21:	09 f1                	or     %esi,%ecx
  804a23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804a27:	89 f9                	mov    %edi,%ecx
  804a29:	d3 e0                	shl    %cl,%eax
  804a2b:	89 c5                	mov    %eax,%ebp
  804a2d:	89 d6                	mov    %edx,%esi
  804a2f:	88 d9                	mov    %bl,%cl
  804a31:	d3 ee                	shr    %cl,%esi
  804a33:	89 f9                	mov    %edi,%ecx
  804a35:	d3 e2                	shl    %cl,%edx
  804a37:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a3b:	88 d9                	mov    %bl,%cl
  804a3d:	d3 e8                	shr    %cl,%eax
  804a3f:	09 c2                	or     %eax,%edx
  804a41:	89 d0                	mov    %edx,%eax
  804a43:	89 f2                	mov    %esi,%edx
  804a45:	f7 74 24 0c          	divl   0xc(%esp)
  804a49:	89 d6                	mov    %edx,%esi
  804a4b:	89 c3                	mov    %eax,%ebx
  804a4d:	f7 e5                	mul    %ebp
  804a4f:	39 d6                	cmp    %edx,%esi
  804a51:	72 19                	jb     804a6c <__udivdi3+0xfc>
  804a53:	74 0b                	je     804a60 <__udivdi3+0xf0>
  804a55:	89 d8                	mov    %ebx,%eax
  804a57:	31 ff                	xor    %edi,%edi
  804a59:	e9 58 ff ff ff       	jmp    8049b6 <__udivdi3+0x46>
  804a5e:	66 90                	xchg   %ax,%ax
  804a60:	8b 54 24 08          	mov    0x8(%esp),%edx
  804a64:	89 f9                	mov    %edi,%ecx
  804a66:	d3 e2                	shl    %cl,%edx
  804a68:	39 c2                	cmp    %eax,%edx
  804a6a:	73 e9                	jae    804a55 <__udivdi3+0xe5>
  804a6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804a6f:	31 ff                	xor    %edi,%edi
  804a71:	e9 40 ff ff ff       	jmp    8049b6 <__udivdi3+0x46>
  804a76:	66 90                	xchg   %ax,%ax
  804a78:	31 c0                	xor    %eax,%eax
  804a7a:	e9 37 ff ff ff       	jmp    8049b6 <__udivdi3+0x46>
  804a7f:	90                   	nop

00804a80 <__umoddi3>:
  804a80:	55                   	push   %ebp
  804a81:	57                   	push   %edi
  804a82:	56                   	push   %esi
  804a83:	53                   	push   %ebx
  804a84:	83 ec 1c             	sub    $0x1c,%esp
  804a87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804a8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  804a8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804a93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804a97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804a9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804a9f:	89 f3                	mov    %esi,%ebx
  804aa1:	89 fa                	mov    %edi,%edx
  804aa3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804aa7:	89 34 24             	mov    %esi,(%esp)
  804aaa:	85 c0                	test   %eax,%eax
  804aac:	75 1a                	jne    804ac8 <__umoddi3+0x48>
  804aae:	39 f7                	cmp    %esi,%edi
  804ab0:	0f 86 a2 00 00 00    	jbe    804b58 <__umoddi3+0xd8>
  804ab6:	89 c8                	mov    %ecx,%eax
  804ab8:	89 f2                	mov    %esi,%edx
  804aba:	f7 f7                	div    %edi
  804abc:	89 d0                	mov    %edx,%eax
  804abe:	31 d2                	xor    %edx,%edx
  804ac0:	83 c4 1c             	add    $0x1c,%esp
  804ac3:	5b                   	pop    %ebx
  804ac4:	5e                   	pop    %esi
  804ac5:	5f                   	pop    %edi
  804ac6:	5d                   	pop    %ebp
  804ac7:	c3                   	ret    
  804ac8:	39 f0                	cmp    %esi,%eax
  804aca:	0f 87 ac 00 00 00    	ja     804b7c <__umoddi3+0xfc>
  804ad0:	0f bd e8             	bsr    %eax,%ebp
  804ad3:	83 f5 1f             	xor    $0x1f,%ebp
  804ad6:	0f 84 ac 00 00 00    	je     804b88 <__umoddi3+0x108>
  804adc:	bf 20 00 00 00       	mov    $0x20,%edi
  804ae1:	29 ef                	sub    %ebp,%edi
  804ae3:	89 fe                	mov    %edi,%esi
  804ae5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804ae9:	89 e9                	mov    %ebp,%ecx
  804aeb:	d3 e0                	shl    %cl,%eax
  804aed:	89 d7                	mov    %edx,%edi
  804aef:	89 f1                	mov    %esi,%ecx
  804af1:	d3 ef                	shr    %cl,%edi
  804af3:	09 c7                	or     %eax,%edi
  804af5:	89 e9                	mov    %ebp,%ecx
  804af7:	d3 e2                	shl    %cl,%edx
  804af9:	89 14 24             	mov    %edx,(%esp)
  804afc:	89 d8                	mov    %ebx,%eax
  804afe:	d3 e0                	shl    %cl,%eax
  804b00:	89 c2                	mov    %eax,%edx
  804b02:	8b 44 24 08          	mov    0x8(%esp),%eax
  804b06:	d3 e0                	shl    %cl,%eax
  804b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  804b0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804b10:	89 f1                	mov    %esi,%ecx
  804b12:	d3 e8                	shr    %cl,%eax
  804b14:	09 d0                	or     %edx,%eax
  804b16:	d3 eb                	shr    %cl,%ebx
  804b18:	89 da                	mov    %ebx,%edx
  804b1a:	f7 f7                	div    %edi
  804b1c:	89 d3                	mov    %edx,%ebx
  804b1e:	f7 24 24             	mull   (%esp)
  804b21:	89 c6                	mov    %eax,%esi
  804b23:	89 d1                	mov    %edx,%ecx
  804b25:	39 d3                	cmp    %edx,%ebx
  804b27:	0f 82 87 00 00 00    	jb     804bb4 <__umoddi3+0x134>
  804b2d:	0f 84 91 00 00 00    	je     804bc4 <__umoddi3+0x144>
  804b33:	8b 54 24 04          	mov    0x4(%esp),%edx
  804b37:	29 f2                	sub    %esi,%edx
  804b39:	19 cb                	sbb    %ecx,%ebx
  804b3b:	89 d8                	mov    %ebx,%eax
  804b3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804b41:	d3 e0                	shl    %cl,%eax
  804b43:	89 e9                	mov    %ebp,%ecx
  804b45:	d3 ea                	shr    %cl,%edx
  804b47:	09 d0                	or     %edx,%eax
  804b49:	89 e9                	mov    %ebp,%ecx
  804b4b:	d3 eb                	shr    %cl,%ebx
  804b4d:	89 da                	mov    %ebx,%edx
  804b4f:	83 c4 1c             	add    $0x1c,%esp
  804b52:	5b                   	pop    %ebx
  804b53:	5e                   	pop    %esi
  804b54:	5f                   	pop    %edi
  804b55:	5d                   	pop    %ebp
  804b56:	c3                   	ret    
  804b57:	90                   	nop
  804b58:	89 fd                	mov    %edi,%ebp
  804b5a:	85 ff                	test   %edi,%edi
  804b5c:	75 0b                	jne    804b69 <__umoddi3+0xe9>
  804b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  804b63:	31 d2                	xor    %edx,%edx
  804b65:	f7 f7                	div    %edi
  804b67:	89 c5                	mov    %eax,%ebp
  804b69:	89 f0                	mov    %esi,%eax
  804b6b:	31 d2                	xor    %edx,%edx
  804b6d:	f7 f5                	div    %ebp
  804b6f:	89 c8                	mov    %ecx,%eax
  804b71:	f7 f5                	div    %ebp
  804b73:	89 d0                	mov    %edx,%eax
  804b75:	e9 44 ff ff ff       	jmp    804abe <__umoddi3+0x3e>
  804b7a:	66 90                	xchg   %ax,%ax
  804b7c:	89 c8                	mov    %ecx,%eax
  804b7e:	89 f2                	mov    %esi,%edx
  804b80:	83 c4 1c             	add    $0x1c,%esp
  804b83:	5b                   	pop    %ebx
  804b84:	5e                   	pop    %esi
  804b85:	5f                   	pop    %edi
  804b86:	5d                   	pop    %ebp
  804b87:	c3                   	ret    
  804b88:	3b 04 24             	cmp    (%esp),%eax
  804b8b:	72 06                	jb     804b93 <__umoddi3+0x113>
  804b8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804b91:	77 0f                	ja     804ba2 <__umoddi3+0x122>
  804b93:	89 f2                	mov    %esi,%edx
  804b95:	29 f9                	sub    %edi,%ecx
  804b97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804b9b:	89 14 24             	mov    %edx,(%esp)
  804b9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804ba2:	8b 44 24 04          	mov    0x4(%esp),%eax
  804ba6:	8b 14 24             	mov    (%esp),%edx
  804ba9:	83 c4 1c             	add    $0x1c,%esp
  804bac:	5b                   	pop    %ebx
  804bad:	5e                   	pop    %esi
  804bae:	5f                   	pop    %edi
  804baf:	5d                   	pop    %ebp
  804bb0:	c3                   	ret    
  804bb1:	8d 76 00             	lea    0x0(%esi),%esi
  804bb4:	2b 04 24             	sub    (%esp),%eax
  804bb7:	19 fa                	sbb    %edi,%edx
  804bb9:	89 d1                	mov    %edx,%ecx
  804bbb:	89 c6                	mov    %eax,%esi
  804bbd:	e9 71 ff ff ff       	jmp    804b33 <__umoddi3+0xb3>
  804bc2:	66 90                	xchg   %ax,%ax
  804bc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804bc8:	72 ea                	jb     804bb4 <__umoddi3+0x134>
  804bca:	89 d9                	mov    %ebx,%ecx
  804bcc:	e9 62 ff ff ff       	jmp    804b33 <__umoddi3+0xb3>
