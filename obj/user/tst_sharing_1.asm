
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 98 15 00 00       	call   8015ce <libmain>
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
  800067:	e8 0c 37 00 00       	call   803778 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 4f 37 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 d0 2f 00 00       	call   803097 <malloc>
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
  8000df:	e8 94 36 00 00       	call   803778 <sys_calculate_free_frames>
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
  800125:	68 a0 4b 80 00       	push   $0x804ba0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 68 19 00 00       	call   801a99 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 8a 36 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 1c 4c 80 00       	push   $0x804c1c
  800150:	6a 0c                	push   $0xc
  800152:	e8 42 19 00 00       	call   801a99 <cprintf_colored>
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
  800174:	e8 ff 35 00 00       	call   803778 <sys_calculate_free_frames>
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
  8001b9:	e8 ba 35 00 00       	call   803778 <sys_calculate_free_frames>
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
  8001f8:	68 94 4c 80 00       	push   $0x804c94
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 95 18 00 00       	call   801a99 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 b7 35 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 20 4d 80 00       	push   $0x804d20
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 68 18 00 00       	call   801a99 <cprintf_colored>
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
  800270:	e8 c5 38 00 00       	call   803b3a <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 98 4d 80 00       	push   $0x804d98
  80028f:	6a 0c                	push   $0xc
  800291:	e8 03 18 00 00       	call   801a99 <cprintf_colored>
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
  8002ae:	e8 c5 34 00 00       	call   803778 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 08 35 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 4a 2f 00 00       	call   80321b <free>
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
  8002fc:	e8 c2 34 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 d0 4d 80 00       	push   $0x804dd0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 7a 17 00 00       	call   801a99 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 51 34 00 00       	call   803778 <sys_calculate_free_frames>
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
  80035f:	68 1c 4e 80 00       	push   $0x804e1c
  800364:	6a 0c                	push   $0xc
  800366:	e8 2e 17 00 00       	call   801a99 <cprintf_colored>
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
  8003bd:	e8 78 37 00 00       	call   803b3a <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 78 4e 80 00       	push   $0x804e78
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 b6 16 00 00       	call   801a99 <cprintf_colored>
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
  800433:	68 b0 4e 80 00       	push   $0x804eb0
  800438:	6a 03                	push   $0x3
  80043a:	e8 5a 16 00 00       	call   801a99 <cprintf_colored>
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
  8004fc:	68 e0 4e 80 00       	push   $0x804ee0
  800501:	6a 0c                	push   $0xc
  800503:	e8 91 15 00 00       	call   801a99 <cprintf_colored>
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
  8005d6:	68 e0 4e 80 00       	push   $0x804ee0
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 b7 14 00 00       	call   801a99 <cprintf_colored>
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
  8006b0:	68 e0 4e 80 00       	push   $0x804ee0
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 dd 13 00 00       	call   801a99 <cprintf_colored>
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
  80078a:	68 e0 4e 80 00       	push   $0x804ee0
  80078f:	6a 0c                	push   $0xc
  800791:	e8 03 13 00 00       	call   801a99 <cprintf_colored>
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
  800864:	68 e0 4e 80 00       	push   $0x804ee0
  800869:	6a 0c                	push   $0xc
  80086b:	e8 29 12 00 00       	call   801a99 <cprintf_colored>
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
  80093e:	68 e0 4e 80 00       	push   $0x804ee0
  800943:	6a 0c                	push   $0xc
  800945:	e8 4f 11 00 00       	call   801a99 <cprintf_colored>
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
  800a33:	68 e0 4e 80 00       	push   $0x804ee0
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 5a 10 00 00       	call   801a99 <cprintf_colored>
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
  800b31:	68 e0 4e 80 00       	push   $0x804ee0
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 5c 0f 00 00       	call   801a99 <cprintf_colored>
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
  800c2f:	68 e0 4e 80 00       	push   $0x804ee0
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 5e 0e 00 00       	call   801a99 <cprintf_colored>
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
  800d2d:	68 e0 4e 80 00       	push   $0x804ee0
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 60 0d 00 00       	call   801a99 <cprintf_colored>
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
  800e1a:	68 e0 4e 80 00       	push   $0x804ee0
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 73 0c 00 00       	call   801a99 <cprintf_colored>
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
  800f07:	68 e0 4e 80 00       	push   $0x804ee0
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 86 0b 00 00       	call   801a99 <cprintf_colored>
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
  800ff4:	68 e0 4e 80 00       	push   $0x804ee0
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 99 0a 00 00       	call   801a99 <cprintf_colored>
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
  801017:	68 32 4f 80 00       	push   $0x804f32
  80101c:	6a 03                	push   $0x3
  80101e:	e8 76 0a 00 00       	call   801a99 <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 3c 27 00 00       	call   803778 <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 7c 27 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
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
  801072:	e8 20 20 00 00       	call   803097 <malloc>
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
  8010a1:	68 50 4f 80 00       	push   $0x804f50
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 ec 09 00 00       	call   801a99 <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 0e 27 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 8c 4f 80 00       	push   $0x804f8c
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 c0 09 00 00       	call   801a99 <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 97 26 00 00       	call   803778 <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 fc 4f 80 00       	push   $0x804ffc
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 94 09 00 00       	call   801a99 <cprintf_colored>
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
  801121:	83 ec 30             	sub    $0x30,%esp
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL BLOCK ALLOCATOR OR USER
	 * BLOCK ALLOCATOR DUE TO DIFFERENT MANAGEMENT OF USER HEAP
	 *********************************************************/

	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	68 44 50 80 00       	push   $0x805044
  80112c:	6a 0e                	push   $0xe
  80112e:	e8 66 09 00 00       	call   801a99 <cprintf_colored>
  801133:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801136:	83 ec 08             	sub    $0x8,%esp
  801139:	68 78 50 80 00       	push   $0x805078
  80113e:	6a 0e                	push   $0xe
  801140:	e8 54 09 00 00       	call   801a99 <cprintf_colored>
  801145:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	68 d4 50 80 00       	push   $0x8050d4
  801150:	6a 0e                	push   $0xe
  801152:	e8 42 09 00 00       	call   801a99 <cprintf_colored>
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
  801177:	68 0a 51 80 00       	push   $0x80510a
  80117c:	6a 18                	push   $0x18
  80117e:	68 26 51 80 00       	push   $0x805126
  801183:	e8 f6 05 00 00       	call   80177e <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  801188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80118f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801196:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)
	int freeFrames, usedDiskPages ;

	cprintf_colored(TEXT_cyan, "\n%~STEP A: checking the creation of shared variables... [60%]\n");
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	68 3c 51 80 00       	push   $0x80513c
  8011a5:	6a 03                	push   $0x3
  8011a7:	e8 ed 08 00 00       	call   801a99 <cprintf_colored>
  8011ac:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8011af:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8011b6:	e8 bd 25 00 00       	call   803778 <sys_calculate_free_frames>
  8011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011be:	e8 00 26 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  8011c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8011c6:	83 ec 04             	sub    $0x4,%esp
  8011c9:	6a 01                	push   $0x1
  8011cb:	68 00 10 00 00       	push   $0x1000
  8011d0:	68 7b 51 80 00       	push   $0x80517b
  8011d5:	e8 7d 21 00 00       	call   803357 <smalloc>
  8011da:	83 c4 10             	add    $0x10,%esp
  8011dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)pagealloc_start)
  8011e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011e3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8011e6:	74 19                	je     801201 <_main+0xe5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8011e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011ef:	83 ec 08             	sub    $0x8,%esp
  8011f2:	68 80 51 80 00       	push   $0x805180
  8011f7:	6a 0c                	push   $0xc
  8011f9:	e8 9b 08 00 00       	call   801a99 <cprintf_colored>
  8011fe:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  801201:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  801208:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80120b:	e8 68 25 00 00       	call   803778 <sys_calculate_free_frames>
  801210:	29 c3                	sub    %eax,%ebx
  801212:	89 d8                	mov    %ebx,%eax
  801214:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected + 1 /*KH Block Alloc: 1 page for Share object*/ + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  801217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80121a:	83 c0 03             	add    $0x3,%eax
  80121d:	89 c2                	mov    %eax,%edx
  80121f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801222:	83 ec 04             	sub    $0x4,%esp
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	ff 75 d4             	pushl  -0x2c(%ebp)
  80122a:	e8 09 ee ff ff       	call   800038 <inRange>
  80122f:	83 c4 10             	add    $0x10,%esp
  801232:	85 c0                	test   %eax,%eax
  801234:	75 30                	jne    801266 <_main+0x14a>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Wrong allocation (actual=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +1 +2);}
  801236:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80123d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801240:	8d 58 03             	lea    0x3(%eax),%ebx
  801243:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801246:	e8 2d 25 00 00       	call   803778 <sys_calculate_free_frames>
  80124b:	29 c6                	sub    %eax,%esi
  80124d:	89 f0                	mov    %esi,%eax
  80124f:	83 ec 0c             	sub    $0xc,%esp
  801252:	53                   	push   %ebx
  801253:	ff 75 d8             	pushl  -0x28(%ebp)
  801256:	50                   	push   %eax
  801257:	68 f0 51 80 00       	push   $0x8051f0
  80125c:	6a 0c                	push   $0xc
  80125e:	e8 36 08 00 00       	call   801a99 <cprintf_colored>
  801263:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801266:	e8 58 25 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  80126b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80126e:	74 19                	je     801289 <_main+0x16d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Wrong page file allocation: ");}
  801270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	68 94 52 80 00       	push   $0x805294
  80127f:	6a 0c                	push   $0xc
  801281:	e8 13 08 00 00       	call   801a99 <cprintf_colored>
  801286:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  801289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128d:	74 04                	je     801293 <_main+0x177>
  80128f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  801293:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80129a:	e8 d9 24 00 00       	call   803778 <sys_calculate_free_frames>
  80129f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8012a2:	e8 1c 25 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  8012a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  8012aa:	83 ec 04             	sub    $0x4,%esp
  8012ad:	6a 01                	push   $0x1
  8012af:	68 04 10 00 00       	push   $0x1004
  8012b4:	68 b5 52 80 00       	push   $0x8052b5
  8012b9:	e8 99 20 00 00       	call   803357 <smalloc>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE))
  8012c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012c7:	05 00 10 00 00       	add    $0x1000,%eax
  8012cc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8012cf:	74 19                	je     8012ea <_main+0x1ce>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8012d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	68 b8 52 80 00       	push   $0x8052b8
  8012e0:	6a 0c                	push   $0xc
  8012e2:	e8 b2 07 00 00       	call   801a99 <cprintf_colored>
  8012e7:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2 pages*/
  8012ea:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8012f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8012f4:	e8 7f 24 00 00       	call   803778 <sys_calculate_free_frames>
  8012f9:	29 c3                	sub    %eax,%ebx
  8012fb:	89 d8                	mov    %ebx,%eax
  8012fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  801300:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801303:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801306:	83 ec 04             	sub    $0x4,%esp
  801309:	52                   	push   %edx
  80130a:	50                   	push   %eax
  80130b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80130e:	e8 25 ed ff ff       	call   800038 <inRange>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	75 26                	jne    801340 <_main+0x224>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80131a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  801324:	e8 4f 24 00 00       	call   803778 <sys_calculate_free_frames>
  801329:	29 c3                	sub    %eax,%ebx
  80132b:	89 d8                	mov    %ebx,%eax
  80132d:	ff 75 d8             	pushl  -0x28(%ebp)
  801330:	50                   	push   %eax
  801331:	68 28 53 80 00       	push   $0x805328
  801336:	6a 0c                	push   $0xc
  801338:	e8 5c 07 00 00       	call   801a99 <cprintf_colored>
  80133d:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801340:	e8 7e 24 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  801345:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801348:	74 19                	je     801363 <_main+0x247>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Wrong page file allocation: ");}
  80134a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	68 c4 53 80 00       	push   $0x8053c4
  801359:	6a 0c                	push   $0xc
  80135b:	e8 39 07 00 00       	call   801a99 <cprintf_colored>
  801360:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  801363:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801367:	74 04                	je     80136d <_main+0x251>
  801369:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  80136d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  801374:	e8 ff 23 00 00       	call   803778 <sys_calculate_free_frames>
  801379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80137c:	e8 42 24 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  801381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		y = smalloc("y", 4, 1);
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	6a 01                	push   $0x1
  801389:	6a 04                	push   $0x4
  80138b:	68 e5 53 80 00       	push   $0x8053e5
  801390:	e8 c2 1f 00 00       	call   803357 <smalloc>
  801395:	83 c4 10             	add    $0x10,%esp
  801398:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE))
  80139b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139e:	05 00 30 00 00       	add    $0x3000,%eax
  8013a3:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8013a6:	74 19                	je     8013c1 <_main+0x2a5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8013a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013af:	83 ec 08             	sub    $0x8,%esp
  8013b2:	68 e8 53 80 00       	push   $0x8053e8
  8013b7:	6a 0c                	push   $0xc
  8013b9:	e8 db 06 00 00       	call   801a99 <cprintf_colored>
  8013be:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1 page*/
  8013c1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8013c8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013cb:	e8 a8 23 00 00       	call   803778 <sys_calculate_free_frames>
  8013d0:	29 c3                	sub    %eax,%ebx
  8013d2:	89 d8                	mov    %ebx,%eax
  8013d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8013d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	52                   	push   %edx
  8013e1:	50                   	push   %eax
  8013e2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013e5:	e8 4e ec ff ff       	call   800038 <inRange>
  8013ea:	83 c4 10             	add    $0x10,%esp
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	75 26                	jne    801417 <_main+0x2fb>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8013f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013f8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013fb:	e8 78 23 00 00       	call   803778 <sys_calculate_free_frames>
  801400:	29 c3                	sub    %eax,%ebx
  801402:	89 d8                	mov    %ebx,%eax
  801404:	ff 75 d8             	pushl  -0x28(%ebp)
  801407:	50                   	push   %eax
  801408:	68 58 54 80 00       	push   $0x805458
  80140d:	6a 0c                	push   $0xc
  80140f:	e8 85 06 00 00       	call   801a99 <cprintf_colored>
  801414:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801417:	e8 a7 23 00 00       	call   8037c3 <sys_pf_calculate_allocated_pages>
  80141c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80141f:	74 19                	je     80143a <_main+0x31e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Wrong page file allocation: ");}
  801421:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	68 f4 54 80 00       	push   $0x8054f4
  801430:	6a 0c                	push   $0xc
  801432:	e8 62 06 00 00       	call   801a99 <cprintf_colored>
  801437:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80143a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80143e:	74 04                	je     801444 <_main+0x328>
  801440:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}

	is_correct = 1;
  801444:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking reading & writing... [40%]\n");
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	68 18 55 80 00       	push   $0x805518
  801453:	6a 03                	push   $0x3
  801455:	e8 3f 06 00 00       	call   801a99 <cprintf_colored>
  80145a:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80145d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  801464:	eb 2d                	jmp    801493 <_main+0x377>
		{
			x[i] = -1;
  801466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801470:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80147b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801485:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

	is_correct = 1;
	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  801490:	ff 45 ec             	incl   -0x14(%ebp)
  801493:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80149a:	7e ca                	jle    801466 <_main+0x34a>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80149c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  8014a3:	eb 18                	jmp    8014bd <_main+0x3a1>
		{
			z[i] = -1;
  8014a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014b2:	01 d0                	add    %edx,%eax
  8014b4:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  8014ba:	ff 45 ec             	incl   -0x14(%ebp)
  8014bd:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  8014c4:	7e df                	jle    8014a5 <_main+0x389>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c9:	8b 00                	mov    (%eax),%eax
  8014cb:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014ce:	74 19                	je     8014e9 <_main+0x3cd>
  8014d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	68 48 55 80 00       	push   $0x805548
  8014df:	6a 0c                	push   $0xc
  8014e1:	e8 b3 05 00 00       	call   801a99 <cprintf_colored>
  8014e6:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ec:	05 fc 0f 00 00       	add    $0xffc,%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014f6:	74 19                	je     801511 <_main+0x3f5>
  8014f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	68 48 55 80 00       	push   $0x805548
  801507:	6a 0c                	push   $0xc
  801509:	e8 8b 05 00 00       	call   801a99 <cprintf_colored>
  80150e:	83 c4 10             	add    $0x10,%esp

		if( y[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  801511:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801514:	8b 00                	mov    (%eax),%eax
  801516:	83 f8 ff             	cmp    $0xffffffff,%eax
  801519:	74 19                	je     801534 <_main+0x418>
  80151b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	68 48 55 80 00       	push   $0x805548
  80152a:	6a 0c                	push   $0xc
  80152c:	e8 68 05 00 00       	call   801a99 <cprintf_colored>
  801531:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  801534:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801537:	05 fc 0f 00 00       	add    $0xffc,%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	83 f8 ff             	cmp    $0xffffffff,%eax
  801541:	74 19                	je     80155c <_main+0x440>
  801543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	68 48 55 80 00       	push   $0x805548
  801552:	6a 0c                	push   $0xc
  801554:	e8 40 05 00 00       	call   801a99 <cprintf_colored>
  801559:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  80155c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80155f:	8b 00                	mov    (%eax),%eax
  801561:	83 f8 ff             	cmp    $0xffffffff,%eax
  801564:	74 19                	je     80157f <_main+0x463>
  801566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80156d:	83 ec 08             	sub    $0x8,%esp
  801570:	68 48 55 80 00       	push   $0x805548
  801575:	6a 0c                	push   $0xc
  801577:	e8 1d 05 00 00       	call   801a99 <cprintf_colored>
  80157c:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  80157f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801582:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  801587:	8b 00                	mov    (%eax),%eax
  801589:	83 f8 ff             	cmp    $0xffffffff,%eax
  80158c:	74 19                	je     8015a7 <_main+0x48b>
  80158e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	68 48 55 80 00       	push   $0x805548
  80159d:	6a 0c                	push   $0xc
  80159f:	e8 f5 04 00 00       	call   801a99 <cprintf_colored>
  8015a4:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8015a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ab:	74 04                	je     8015b1 <_main+0x495>
		eval += 40 ;
  8015ad:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf_colored(TEXT_light_green, "%~\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b7:	68 78 55 80 00       	push   $0x805578
  8015bc:	6a 0a                	push   $0xa
  8015be:	e8 d6 04 00 00       	call   801a99 <cprintf_colored>
  8015c3:	83 c4 10             	add    $0x10,%esp

	return;
  8015c6:	90                   	nop
}
  8015c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	57                   	push   %edi
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8015d7:	e8 65 23 00 00       	call   803941 <sys_getenvindex>
  8015dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8015df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015e2:	89 d0                	mov    %edx,%eax
  8015e4:	01 c0                	add    %eax,%eax
  8015e6:	01 d0                	add    %edx,%eax
  8015e8:	c1 e0 02             	shl    $0x2,%eax
  8015eb:	01 d0                	add    %edx,%eax
  8015ed:	c1 e0 02             	shl    $0x2,%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	c1 e0 03             	shl    $0x3,%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	c1 e0 02             	shl    $0x2,%eax
  8015fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015ff:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801604:	a1 00 72 80 00       	mov    0x807200,%eax
  801609:	8a 40 20             	mov    0x20(%eax),%al
  80160c:	84 c0                	test   %al,%al
  80160e:	74 0d                	je     80161d <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801610:	a1 00 72 80 00       	mov    0x807200,%eax
  801615:	83 c0 20             	add    $0x20,%eax
  801618:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80161d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801621:	7e 0a                	jle    80162d <libmain+0x5f>
		binaryname = argv[0];
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	8b 00                	mov    (%eax),%eax
  801628:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	ff 75 0c             	pushl  0xc(%ebp)
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 e1 fa ff ff       	call   80111c <_main>
  80163b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80163e:	a1 00 70 80 00       	mov    0x807000,%eax
  801643:	85 c0                	test   %eax,%eax
  801645:	0f 84 01 01 00 00    	je     80174c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80164b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801651:	bb b4 56 80 00       	mov    $0x8056b4,%ebx
  801656:	ba 0e 00 00 00       	mov    $0xe,%edx
  80165b:	89 c7                	mov    %eax,%edi
  80165d:	89 de                	mov    %ebx,%esi
  80165f:	89 d1                	mov    %edx,%ecx
  801661:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801663:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801666:	b9 56 00 00 00       	mov    $0x56,%ecx
  80166b:	b0 00                	mov    $0x0,%al
  80166d:	89 d7                	mov    %edx,%edi
  80166f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801671:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801678:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	50                   	push   %eax
  80167f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801685:	50                   	push   %eax
  801686:	e8 ec 24 00 00       	call   803b77 <sys_utilities>
  80168b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80168e:	e8 35 20 00 00       	call   8036c8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801693:	83 ec 0c             	sub    $0xc,%esp
  801696:	68 d4 55 80 00       	push   $0x8055d4
  80169b:	e8 cc 03 00 00       	call   801a6c <cprintf>
  8016a0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8016a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	74 18                	je     8016c2 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8016aa:	e8 e6 24 00 00       	call   803b95 <sys_get_optimal_num_faults>
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	50                   	push   %eax
  8016b3:	68 fc 55 80 00       	push   $0x8055fc
  8016b8:	e8 af 03 00 00       	call   801a6c <cprintf>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	eb 59                	jmp    80171b <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8016c2:	a1 00 72 80 00       	mov    0x807200,%eax
  8016c7:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8016cd:	a1 00 72 80 00       	mov    0x807200,%eax
  8016d2:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	52                   	push   %edx
  8016dc:	50                   	push   %eax
  8016dd:	68 20 56 80 00       	push   $0x805620
  8016e2:	e8 85 03 00 00       	call   801a6c <cprintf>
  8016e7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8016ea:	a1 00 72 80 00       	mov    0x807200,%eax
  8016ef:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8016f5:	a1 00 72 80 00       	mov    0x807200,%eax
  8016fa:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  801700:	a1 00 72 80 00       	mov    0x807200,%eax
  801705:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80170b:	51                   	push   %ecx
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	68 48 56 80 00       	push   $0x805648
  801713:	e8 54 03 00 00       	call   801a6c <cprintf>
  801718:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80171b:	a1 00 72 80 00       	mov    0x807200,%eax
  801720:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  801726:	83 ec 08             	sub    $0x8,%esp
  801729:	50                   	push   %eax
  80172a:	68 a0 56 80 00       	push   $0x8056a0
  80172f:	e8 38 03 00 00       	call   801a6c <cprintf>
  801734:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801737:	83 ec 0c             	sub    $0xc,%esp
  80173a:	68 d4 55 80 00       	push   $0x8055d4
  80173f:	e8 28 03 00 00       	call   801a6c <cprintf>
  801744:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801747:	e8 96 1f 00 00       	call   8036e2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80174c:	e8 1f 00 00 00       	call   801770 <exit>
}
  801751:	90                   	nop
  801752:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5f                   	pop    %edi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801760:	83 ec 0c             	sub    $0xc,%esp
  801763:	6a 00                	push   $0x0
  801765:	e8 a3 21 00 00       	call   80390d <sys_destroy_env>
  80176a:	83 c4 10             	add    $0x10,%esp
}
  80176d:	90                   	nop
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <exit>:

void
exit(void)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801776:	e8 f8 21 00 00       	call   803973 <sys_exit_env>
}
  80177b:	90                   	nop
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801784:	8d 45 10             	lea    0x10(%ebp),%eax
  801787:	83 c0 04             	add    $0x4,%eax
  80178a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80178d:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801792:	85 c0                	test   %eax,%eax
  801794:	74 16                	je     8017ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  801796:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  80179b:	83 ec 08             	sub    $0x8,%esp
  80179e:	50                   	push   %eax
  80179f:	68 18 57 80 00       	push   $0x805718
  8017a4:	e8 c3 02 00 00       	call   801a6c <cprintf>
  8017a9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017ac:	a1 04 70 80 00       	mov    0x807004,%eax
  8017b1:	83 ec 0c             	sub    $0xc,%esp
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	50                   	push   %eax
  8017bb:	68 20 57 80 00       	push   $0x805720
  8017c0:	6a 74                	push   $0x74
  8017c2:	e8 d2 02 00 00       	call   801a99 <cprintf_colored>
  8017c7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cd:	83 ec 08             	sub    $0x8,%esp
  8017d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	e8 24 02 00 00       	call   8019fd <vcprintf>
  8017d9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	6a 00                	push   $0x0
  8017e1:	68 48 57 80 00       	push   $0x805748
  8017e6:	e8 12 02 00 00       	call   8019fd <vcprintf>
  8017eb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017ee:	e8 7d ff ff ff       	call   801770 <exit>

	// should not return here
	while (1) ;
  8017f3:	eb fe                	jmp    8017f3 <_panic+0x75>

008017f5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017fc:	a1 00 72 80 00       	mov    0x807200,%eax
  801801:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	39 c2                	cmp    %eax,%edx
  80180c:	74 14                	je     801822 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 4c 57 80 00       	push   $0x80574c
  801816:	6a 26                	push   $0x26
  801818:	68 98 57 80 00       	push   $0x805798
  80181d:	e8 5c ff ff ff       	call   80177e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801822:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801829:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801830:	e9 d9 00 00 00       	jmp    80190e <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  801835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801838:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	01 d0                	add    %edx,%eax
  801844:	8b 00                	mov    (%eax),%eax
  801846:	85 c0                	test   %eax,%eax
  801848:	75 08                	jne    801852 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80184a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80184d:	e9 b9 00 00 00       	jmp    80190b <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  801852:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801859:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801860:	eb 79                	jmp    8018db <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801862:	a1 00 72 80 00       	mov    0x807200,%eax
  801867:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80186d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801870:	89 d0                	mov    %edx,%eax
  801872:	01 c0                	add    %eax,%eax
  801874:	01 d0                	add    %edx,%eax
  801876:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80187d:	01 d8                	add    %ebx,%eax
  80187f:	01 d0                	add    %edx,%eax
  801881:	01 c8                	add    %ecx,%eax
  801883:	8a 40 04             	mov    0x4(%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	75 4e                	jne    8018d8 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80188a:	a1 00 72 80 00       	mov    0x807200,%eax
  80188f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801895:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801898:	89 d0                	mov    %edx,%eax
  80189a:	01 c0                	add    %eax,%eax
  80189c:	01 d0                	add    %edx,%eax
  80189e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8018a5:	01 d8                	add    %ebx,%eax
  8018a7:	01 d0                	add    %edx,%eax
  8018a9:	01 c8                	add    %ecx,%eax
  8018ab:	8b 00                	mov    (%eax),%eax
  8018ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018b8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	01 c8                	add    %ecx,%eax
  8018c9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018cb:	39 c2                	cmp    %eax,%edx
  8018cd:	75 09                	jne    8018d8 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8018cf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018d6:	eb 19                	jmp    8018f1 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018d8:	ff 45 e8             	incl   -0x18(%ebp)
  8018db:	a1 00 72 80 00       	mov    0x807200,%eax
  8018e0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e9:	39 c2                	cmp    %eax,%edx
  8018eb:	0f 87 71 ff ff ff    	ja     801862 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018f5:	75 14                	jne    80190b <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	68 a4 57 80 00       	push   $0x8057a4
  8018ff:	6a 3a                	push   $0x3a
  801901:	68 98 57 80 00       	push   $0x805798
  801906:	e8 73 fe ff ff       	call   80177e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80190b:	ff 45 f0             	incl   -0x10(%ebp)
  80190e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801911:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801914:	0f 8c 1b ff ff ff    	jl     801835 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80191a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801921:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801928:	eb 2e                	jmp    801958 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80192a:	a1 00 72 80 00       	mov    0x807200,%eax
  80192f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801935:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801938:	89 d0                	mov    %edx,%eax
  80193a:	01 c0                	add    %eax,%eax
  80193c:	01 d0                	add    %edx,%eax
  80193e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801945:	01 d8                	add    %ebx,%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	01 c8                	add    %ecx,%eax
  80194b:	8a 40 04             	mov    0x4(%eax),%al
  80194e:	3c 01                	cmp    $0x1,%al
  801950:	75 03                	jne    801955 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  801952:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801955:	ff 45 e0             	incl   -0x20(%ebp)
  801958:	a1 00 72 80 00       	mov    0x807200,%eax
  80195d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801963:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801966:	39 c2                	cmp    %eax,%edx
  801968:	77 c0                	ja     80192a <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801970:	74 14                	je     801986 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	68 f8 57 80 00       	push   $0x8057f8
  80197a:	6a 44                	push   $0x44
  80197c:	68 98 57 80 00       	push   $0x805798
  801981:	e8 f8 fd ff ff       	call   80177e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801986:	90                   	nop
  801987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	53                   	push   %ebx
  801990:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	8b 00                	mov    (%eax),%eax
  801998:	8d 48 01             	lea    0x1(%eax),%ecx
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	89 0a                	mov    %ecx,(%edx)
  8019a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a3:	88 d1                	mov    %dl,%cl
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8019ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019af:	8b 00                	mov    (%eax),%eax
  8019b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8019b6:	75 30                	jne    8019e8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8019b8:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  8019be:	a0 24 72 80 00       	mov    0x807224,%al
  8019c3:	0f b6 c0             	movzbl %al,%eax
  8019c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019c9:	8b 09                	mov    (%ecx),%ecx
  8019cb:	89 cb                	mov    %ecx,%ebx
  8019cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019d0:	83 c1 08             	add    $0x8,%ecx
  8019d3:	52                   	push   %edx
  8019d4:	50                   	push   %eax
  8019d5:	53                   	push   %ebx
  8019d6:	51                   	push   %ecx
  8019d7:	e8 a8 1c 00 00       	call   803684 <sys_cputs>
  8019dc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8019df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8019e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019eb:	8b 40 04             	mov    0x4(%eax),%eax
  8019ee:	8d 50 01             	lea    0x1(%eax),%edx
  8019f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8019f7:	90                   	nop
  8019f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801a06:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a0d:	00 00 00 
	b.cnt = 0;
  801a10:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801a17:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a26:	50                   	push   %eax
  801a27:	68 8c 19 80 00       	push   $0x80198c
  801a2c:	e8 5a 02 00 00       	call   801c8b <vprintfmt>
  801a31:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801a34:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801a3a:	a0 24 72 80 00       	mov    0x807224,%al
  801a3f:	0f b6 c0             	movzbl %al,%eax
  801a42:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801a48:	52                   	push   %edx
  801a49:	50                   	push   %eax
  801a4a:	51                   	push   %ecx
  801a4b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a51:	83 c0 08             	add    $0x8,%eax
  801a54:	50                   	push   %eax
  801a55:	e8 2a 1c 00 00       	call   803684 <sys_cputs>
  801a5a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801a5d:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801a64:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a72:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  801a79:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 f4             	pushl  -0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	e8 6f ff ff ff       	call   8019fd <vcprintf>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a9f:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	c1 e0 08             	shl    $0x8,%eax
  801aac:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801ab1:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ab4:	83 c0 04             	add    $0x4,%eax
  801ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac3:	50                   	push   %eax
  801ac4:	e8 34 ff ff ff       	call   8019fd <vcprintf>
  801ac9:	83 c4 10             	add    $0x10,%esp
  801acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801acf:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801ad6:	07 00 00 

	return cnt;
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801ae4:	e8 df 1b 00 00       	call   8036c8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801ae9:	8d 45 0c             	lea    0xc(%ebp),%eax
  801aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	ff 75 f4             	pushl  -0xc(%ebp)
  801af8:	50                   	push   %eax
  801af9:	e8 ff fe ff ff       	call   8019fd <vcprintf>
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801b04:	e8 d9 1b 00 00       	call   8036e2 <sys_unlock_cons>
	return cnt;
  801b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	53                   	push   %ebx
  801b12:	83 ec 14             	sub    $0x14,%esp
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801b21:	8b 45 18             	mov    0x18(%ebp),%eax
  801b24:	ba 00 00 00 00       	mov    $0x0,%edx
  801b29:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b2c:	77 55                	ja     801b83 <printnum+0x75>
  801b2e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b31:	72 05                	jb     801b38 <printnum+0x2a>
  801b33:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b36:	77 4b                	ja     801b83 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b38:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801b3b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b3e:	8b 45 18             	mov    0x18(%ebp),%eax
  801b41:	ba 00 00 00 00       	mov    $0x0,%edx
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4b:	ff 75 f0             	pushl  -0x10(%ebp)
  801b4e:	e8 d5 2d 00 00       	call   804928 <__udivdi3>
  801b53:	83 c4 10             	add    $0x10,%esp
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	ff 75 20             	pushl  0x20(%ebp)
  801b5c:	53                   	push   %ebx
  801b5d:	ff 75 18             	pushl  0x18(%ebp)
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	ff 75 08             	pushl  0x8(%ebp)
  801b68:	e8 a1 ff ff ff       	call   801b0e <printnum>
  801b6d:	83 c4 20             	add    $0x20,%esp
  801b70:	eb 1a                	jmp    801b8c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b72:	83 ec 08             	sub    $0x8,%esp
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 20             	pushl  0x20(%ebp)
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	ff d0                	call   *%eax
  801b80:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b83:	ff 4d 1c             	decl   0x1c(%ebp)
  801b86:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b8a:	7f e6                	jg     801b72 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b8c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9a:	53                   	push   %ebx
  801b9b:	51                   	push   %ecx
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	e8 95 2e 00 00       	call   804a38 <__umoddi3>
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	05 74 5a 80 00       	add    $0x805a74,%eax
  801bab:	8a 00                	mov    (%eax),%al
  801bad:	0f be c0             	movsbl %al,%eax
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	ff d0                	call   *%eax
  801bbc:	83 c4 10             	add    $0x10,%esp
}
  801bbf:	90                   	nop
  801bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bc8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bcc:	7e 1c                	jle    801bea <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	8b 00                	mov    (%eax),%eax
  801bd3:	8d 50 08             	lea    0x8(%eax),%edx
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	89 10                	mov    %edx,(%eax)
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	8b 00                	mov    (%eax),%eax
  801be0:	83 e8 08             	sub    $0x8,%eax
  801be3:	8b 50 04             	mov    0x4(%eax),%edx
  801be6:	8b 00                	mov    (%eax),%eax
  801be8:	eb 40                	jmp    801c2a <getuint+0x65>
	else if (lflag)
  801bea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bee:	74 1e                	je     801c0e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	8b 00                	mov    (%eax),%eax
  801bf5:	8d 50 04             	lea    0x4(%eax),%edx
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	89 10                	mov    %edx,(%eax)
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	83 e8 04             	sub    $0x4,%eax
  801c05:	8b 00                	mov    (%eax),%eax
  801c07:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0c:	eb 1c                	jmp    801c2a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	8b 00                	mov    (%eax),%eax
  801c13:	8d 50 04             	lea    0x4(%eax),%edx
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	89 10                	mov    %edx,(%eax)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	8b 00                	mov    (%eax),%eax
  801c20:	83 e8 04             	sub    $0x4,%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    

00801c2c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c2f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c33:	7e 1c                	jle    801c51 <getint+0x25>
		return va_arg(*ap, long long);
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	8b 00                	mov    (%eax),%eax
  801c3a:	8d 50 08             	lea    0x8(%eax),%edx
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	89 10                	mov    %edx,(%eax)
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	8b 00                	mov    (%eax),%eax
  801c47:	83 e8 08             	sub    $0x8,%eax
  801c4a:	8b 50 04             	mov    0x4(%eax),%edx
  801c4d:	8b 00                	mov    (%eax),%eax
  801c4f:	eb 38                	jmp    801c89 <getint+0x5d>
	else if (lflag)
  801c51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c55:	74 1a                	je     801c71 <getint+0x45>
		return va_arg(*ap, long);
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	8b 00                	mov    (%eax),%eax
  801c5c:	8d 50 04             	lea    0x4(%eax),%edx
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	89 10                	mov    %edx,(%eax)
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	83 e8 04             	sub    $0x4,%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	99                   	cltd   
  801c6f:	eb 18                	jmp    801c89 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	8b 00                	mov    (%eax),%eax
  801c76:	8d 50 04             	lea    0x4(%eax),%edx
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	89 10                	mov    %edx,(%eax)
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	8b 00                	mov    (%eax),%eax
  801c83:	83 e8 04             	sub    $0x4,%eax
  801c86:	8b 00                	mov    (%eax),%eax
  801c88:	99                   	cltd   
}
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    

00801c8b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c93:	eb 17                	jmp    801cac <vprintfmt+0x21>
			if (ch == '\0')
  801c95:	85 db                	test   %ebx,%ebx
  801c97:	0f 84 c1 03 00 00    	je     80205e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	ff 75 0c             	pushl  0xc(%ebp)
  801ca3:	53                   	push   %ebx
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	ff d0                	call   *%eax
  801ca9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801cac:	8b 45 10             	mov    0x10(%ebp),%eax
  801caf:	8d 50 01             	lea    0x1(%eax),%edx
  801cb2:	89 55 10             	mov    %edx,0x10(%ebp)
  801cb5:	8a 00                	mov    (%eax),%al
  801cb7:	0f b6 d8             	movzbl %al,%ebx
  801cba:	83 fb 25             	cmp    $0x25,%ebx
  801cbd:	75 d6                	jne    801c95 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801cbf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801cc3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801cca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801cd1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801cd8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce2:	8d 50 01             	lea    0x1(%eax),%edx
  801ce5:	89 55 10             	mov    %edx,0x10(%ebp)
  801ce8:	8a 00                	mov    (%eax),%al
  801cea:	0f b6 d8             	movzbl %al,%ebx
  801ced:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801cf0:	83 f8 5b             	cmp    $0x5b,%eax
  801cf3:	0f 87 3d 03 00 00    	ja     802036 <vprintfmt+0x3ab>
  801cf9:	8b 04 85 98 5a 80 00 	mov    0x805a98(,%eax,4),%eax
  801d00:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801d02:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801d06:	eb d7                	jmp    801cdf <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801d08:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801d0c:	eb d1                	jmp    801cdf <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801d15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d18:	89 d0                	mov    %edx,%eax
  801d1a:	c1 e0 02             	shl    $0x2,%eax
  801d1d:	01 d0                	add    %edx,%eax
  801d1f:	01 c0                	add    %eax,%eax
  801d21:	01 d8                	add    %ebx,%eax
  801d23:	83 e8 30             	sub    $0x30,%eax
  801d26:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801d29:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2c:	8a 00                	mov    (%eax),%al
  801d2e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801d31:	83 fb 2f             	cmp    $0x2f,%ebx
  801d34:	7e 3e                	jle    801d74 <vprintfmt+0xe9>
  801d36:	83 fb 39             	cmp    $0x39,%ebx
  801d39:	7f 39                	jg     801d74 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d3b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d3e:	eb d5                	jmp    801d15 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d40:	8b 45 14             	mov    0x14(%ebp),%eax
  801d43:	83 c0 04             	add    $0x4,%eax
  801d46:	89 45 14             	mov    %eax,0x14(%ebp)
  801d49:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4c:	83 e8 04             	sub    $0x4,%eax
  801d4f:	8b 00                	mov    (%eax),%eax
  801d51:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d54:	eb 1f                	jmp    801d75 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801d56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d5a:	79 83                	jns    801cdf <vprintfmt+0x54>
				width = 0;
  801d5c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d63:	e9 77 ff ff ff       	jmp    801cdf <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801d68:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d6f:	e9 6b ff ff ff       	jmp    801cdf <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d74:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d79:	0f 89 60 ff ff ff    	jns    801cdf <vprintfmt+0x54>
				width = precision, precision = -1;
  801d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d85:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d8c:	e9 4e ff ff ff       	jmp    801cdf <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d91:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801d94:	e9 46 ff ff ff       	jmp    801cdf <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d99:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9c:	83 c0 04             	add    $0x4,%eax
  801d9f:	89 45 14             	mov    %eax,0x14(%ebp)
  801da2:	8b 45 14             	mov    0x14(%ebp),%eax
  801da5:	83 e8 04             	sub    $0x4,%eax
  801da8:	8b 00                	mov    (%eax),%eax
  801daa:	83 ec 08             	sub    $0x8,%esp
  801dad:	ff 75 0c             	pushl  0xc(%ebp)
  801db0:	50                   	push   %eax
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	ff d0                	call   *%eax
  801db6:	83 c4 10             	add    $0x10,%esp
			break;
  801db9:	e9 9b 02 00 00       	jmp    802059 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc1:	83 c0 04             	add    $0x4,%eax
  801dc4:	89 45 14             	mov    %eax,0x14(%ebp)
  801dc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dca:	83 e8 04             	sub    $0x4,%eax
  801dcd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801dcf:	85 db                	test   %ebx,%ebx
  801dd1:	79 02                	jns    801dd5 <vprintfmt+0x14a>
				err = -err;
  801dd3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801dd5:	83 fb 64             	cmp    $0x64,%ebx
  801dd8:	7f 0b                	jg     801de5 <vprintfmt+0x15a>
  801dda:	8b 34 9d e0 58 80 00 	mov    0x8058e0(,%ebx,4),%esi
  801de1:	85 f6                	test   %esi,%esi
  801de3:	75 19                	jne    801dfe <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801de5:	53                   	push   %ebx
  801de6:	68 85 5a 80 00       	push   $0x805a85
  801deb:	ff 75 0c             	pushl  0xc(%ebp)
  801dee:	ff 75 08             	pushl  0x8(%ebp)
  801df1:	e8 70 02 00 00       	call   802066 <printfmt>
  801df6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801df9:	e9 5b 02 00 00       	jmp    802059 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801dfe:	56                   	push   %esi
  801dff:	68 8e 5a 80 00       	push   $0x805a8e
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	ff 75 08             	pushl  0x8(%ebp)
  801e0a:	e8 57 02 00 00       	call   802066 <printfmt>
  801e0f:	83 c4 10             	add    $0x10,%esp
			break;
  801e12:	e9 42 02 00 00       	jmp    802059 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801e17:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1a:	83 c0 04             	add    $0x4,%eax
  801e1d:	89 45 14             	mov    %eax,0x14(%ebp)
  801e20:	8b 45 14             	mov    0x14(%ebp),%eax
  801e23:	83 e8 04             	sub    $0x4,%eax
  801e26:	8b 30                	mov    (%eax),%esi
  801e28:	85 f6                	test   %esi,%esi
  801e2a:	75 05                	jne    801e31 <vprintfmt+0x1a6>
				p = "(null)";
  801e2c:	be 91 5a 80 00       	mov    $0x805a91,%esi
			if (width > 0 && padc != '-')
  801e31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e35:	7e 6d                	jle    801ea4 <vprintfmt+0x219>
  801e37:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801e3b:	74 67                	je     801ea4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	50                   	push   %eax
  801e44:	56                   	push   %esi
  801e45:	e8 1e 03 00 00       	call   802168 <strnlen>
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e50:	eb 16                	jmp    801e68 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e52:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	50                   	push   %eax
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	ff d0                	call   *%eax
  801e62:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801e65:	ff 4d e4             	decl   -0x1c(%ebp)
  801e68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e6c:	7f e4                	jg     801e52 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e6e:	eb 34                	jmp    801ea4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801e70:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e74:	74 1c                	je     801e92 <vprintfmt+0x207>
  801e76:	83 fb 1f             	cmp    $0x1f,%ebx
  801e79:	7e 05                	jle    801e80 <vprintfmt+0x1f5>
  801e7b:	83 fb 7e             	cmp    $0x7e,%ebx
  801e7e:	7e 12                	jle    801e92 <vprintfmt+0x207>
					putch('?', putdat);
  801e80:	83 ec 08             	sub    $0x8,%esp
  801e83:	ff 75 0c             	pushl  0xc(%ebp)
  801e86:	6a 3f                	push   $0x3f
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	ff d0                	call   *%eax
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	eb 0f                	jmp    801ea1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	ff 75 0c             	pushl  0xc(%ebp)
  801e98:	53                   	push   %ebx
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	ff d0                	call   *%eax
  801e9e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ea1:	ff 4d e4             	decl   -0x1c(%ebp)
  801ea4:	89 f0                	mov    %esi,%eax
  801ea6:	8d 70 01             	lea    0x1(%eax),%esi
  801ea9:	8a 00                	mov    (%eax),%al
  801eab:	0f be d8             	movsbl %al,%ebx
  801eae:	85 db                	test   %ebx,%ebx
  801eb0:	74 24                	je     801ed6 <vprintfmt+0x24b>
  801eb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801eb6:	78 b8                	js     801e70 <vprintfmt+0x1e5>
  801eb8:	ff 4d e0             	decl   -0x20(%ebp)
  801ebb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ebf:	79 af                	jns    801e70 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ec1:	eb 13                	jmp    801ed6 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ec3:	83 ec 08             	sub    $0x8,%esp
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	6a 20                	push   $0x20
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	ff d0                	call   *%eax
  801ed0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ed3:	ff 4d e4             	decl   -0x1c(%ebp)
  801ed6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801eda:	7f e7                	jg     801ec3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801edc:	e9 78 01 00 00       	jmp    802059 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ee1:	83 ec 08             	sub    $0x8,%esp
  801ee4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ee7:	8d 45 14             	lea    0x14(%ebp),%eax
  801eea:	50                   	push   %eax
  801eeb:	e8 3c fd ff ff       	call   801c2c <getint>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ef6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eff:	85 d2                	test   %edx,%edx
  801f01:	79 23                	jns    801f26 <vprintfmt+0x29b>
				putch('-', putdat);
  801f03:	83 ec 08             	sub    $0x8,%esp
  801f06:	ff 75 0c             	pushl  0xc(%ebp)
  801f09:	6a 2d                	push   $0x2d
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	ff d0                	call   *%eax
  801f10:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f19:	f7 d8                	neg    %eax
  801f1b:	83 d2 00             	adc    $0x0,%edx
  801f1e:	f7 da                	neg    %edx
  801f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f23:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801f26:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f2d:	e9 bc 00 00 00       	jmp    801fee <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801f32:	83 ec 08             	sub    $0x8,%esp
  801f35:	ff 75 e8             	pushl  -0x18(%ebp)
  801f38:	8d 45 14             	lea    0x14(%ebp),%eax
  801f3b:	50                   	push   %eax
  801f3c:	e8 84 fc ff ff       	call   801bc5 <getuint>
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f4a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f51:	e9 98 00 00 00       	jmp    801fee <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	ff 75 0c             	pushl  0xc(%ebp)
  801f5c:	6a 58                	push   $0x58
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	ff d0                	call   *%eax
  801f63:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f66:	83 ec 08             	sub    $0x8,%esp
  801f69:	ff 75 0c             	pushl  0xc(%ebp)
  801f6c:	6a 58                	push   $0x58
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	ff d0                	call   *%eax
  801f73:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	6a 58                	push   $0x58
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	ff d0                	call   *%eax
  801f83:	83 c4 10             	add    $0x10,%esp
			break;
  801f86:	e9 ce 00 00 00       	jmp    802059 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	6a 30                	push   $0x30
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	ff d0                	call   *%eax
  801f98:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	6a 78                	push   $0x78
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	ff d0                	call   *%eax
  801fa8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801fab:	8b 45 14             	mov    0x14(%ebp),%eax
  801fae:	83 c0 04             	add    $0x4,%eax
  801fb1:	89 45 14             	mov    %eax,0x14(%ebp)
  801fb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb7:	83 e8 04             	sub    $0x4,%eax
  801fba:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801fc6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801fcd:	eb 1f                	jmp    801fee <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	ff 75 e8             	pushl  -0x18(%ebp)
  801fd5:	8d 45 14             	lea    0x14(%ebp),%eax
  801fd8:	50                   	push   %eax
  801fd9:	e8 e7 fb ff ff       	call   801bc5 <getuint>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801fe7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801fee:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	52                   	push   %edx
  801ff9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ffc:	50                   	push   %eax
  801ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  802000:	ff 75 f0             	pushl  -0x10(%ebp)
  802003:	ff 75 0c             	pushl  0xc(%ebp)
  802006:	ff 75 08             	pushl  0x8(%ebp)
  802009:	e8 00 fb ff ff       	call   801b0e <printnum>
  80200e:	83 c4 20             	add    $0x20,%esp
			break;
  802011:	eb 46                	jmp    802059 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802013:	83 ec 08             	sub    $0x8,%esp
  802016:	ff 75 0c             	pushl  0xc(%ebp)
  802019:	53                   	push   %ebx
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	ff d0                	call   *%eax
  80201f:	83 c4 10             	add    $0x10,%esp
			break;
  802022:	eb 35                	jmp    802059 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  802024:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  80202b:	eb 2c                	jmp    802059 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80202d:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  802034:	eb 23                	jmp    802059 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	6a 25                	push   $0x25
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	ff d0                	call   *%eax
  802043:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802046:	ff 4d 10             	decl   0x10(%ebp)
  802049:	eb 03                	jmp    80204e <vprintfmt+0x3c3>
  80204b:	ff 4d 10             	decl   0x10(%ebp)
  80204e:	8b 45 10             	mov    0x10(%ebp),%eax
  802051:	48                   	dec    %eax
  802052:	8a 00                	mov    (%eax),%al
  802054:	3c 25                	cmp    $0x25,%al
  802056:	75 f3                	jne    80204b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  802058:	90                   	nop
		}
	}
  802059:	e9 35 fc ff ff       	jmp    801c93 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80205e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80205f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802062:	5b                   	pop    %ebx
  802063:	5e                   	pop    %esi
  802064:	5d                   	pop    %ebp
  802065:	c3                   	ret    

00802066 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80206c:	8d 45 10             	lea    0x10(%ebp),%eax
  80206f:	83 c0 04             	add    $0x4,%eax
  802072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802075:	8b 45 10             	mov    0x10(%ebp),%eax
  802078:	ff 75 f4             	pushl  -0xc(%ebp)
  80207b:	50                   	push   %eax
  80207c:	ff 75 0c             	pushl  0xc(%ebp)
  80207f:	ff 75 08             	pushl  0x8(%ebp)
  802082:	e8 04 fc ff ff       	call   801c8b <vprintfmt>
  802087:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80208a:	90                   	nop
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802090:	8b 45 0c             	mov    0xc(%ebp),%eax
  802093:	8b 40 08             	mov    0x8(%eax),%eax
  802096:	8d 50 01             	lea    0x1(%eax),%edx
  802099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80209f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a2:	8b 10                	mov    (%eax),%edx
  8020a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a7:	8b 40 04             	mov    0x4(%eax),%eax
  8020aa:	39 c2                	cmp    %eax,%edx
  8020ac:	73 12                	jae    8020c0 <sprintputch+0x33>
		*b->buf++ = ch;
  8020ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b1:	8b 00                	mov    (%eax),%eax
  8020b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8020b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b9:	89 0a                	mov    %ecx,(%edx)
  8020bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8020be:	88 10                	mov    %dl,(%eax)
}
  8020c0:	90                   	nop
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	01 d0                	add    %edx,%eax
  8020da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e8:	74 06                	je     8020f0 <vsnprintf+0x2d>
  8020ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ee:	7f 07                	jg     8020f7 <vsnprintf+0x34>
		return -E_INVAL;
  8020f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8020f5:	eb 20                	jmp    802117 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8020f7:	ff 75 14             	pushl  0x14(%ebp)
  8020fa:	ff 75 10             	pushl  0x10(%ebp)
  8020fd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802100:	50                   	push   %eax
  802101:	68 8d 20 80 00       	push   $0x80208d
  802106:	e8 80 fb ff ff       	call   801c8b <vprintfmt>
  80210b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802111:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80211f:	8d 45 10             	lea    0x10(%ebp),%eax
  802122:	83 c0 04             	add    $0x4,%eax
  802125:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802128:	8b 45 10             	mov    0x10(%ebp),%eax
  80212b:	ff 75 f4             	pushl  -0xc(%ebp)
  80212e:	50                   	push   %eax
  80212f:	ff 75 0c             	pushl  0xc(%ebp)
  802132:	ff 75 08             	pushl  0x8(%ebp)
  802135:	e8 89 ff ff ff       	call   8020c3 <vsnprintf>
  80213a:	83 c4 10             	add    $0x10,%esp
  80213d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802140:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80214b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802152:	eb 06                	jmp    80215a <strlen+0x15>
		n++;
  802154:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802157:	ff 45 08             	incl   0x8(%ebp)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8a 00                	mov    (%eax),%al
  80215f:	84 c0                	test   %al,%al
  802161:	75 f1                	jne    802154 <strlen+0xf>
		n++;
	return n;
  802163:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80216e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802175:	eb 09                	jmp    802180 <strnlen+0x18>
		n++;
  802177:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80217a:	ff 45 08             	incl   0x8(%ebp)
  80217d:	ff 4d 0c             	decl   0xc(%ebp)
  802180:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802184:	74 09                	je     80218f <strnlen+0x27>
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8a 00                	mov    (%eax),%al
  80218b:	84 c0                	test   %al,%al
  80218d:	75 e8                	jne    802177 <strnlen+0xf>
		n++;
	return n;
  80218f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8021a0:	90                   	nop
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	8d 50 01             	lea    0x1(%eax),%edx
  8021a7:	89 55 08             	mov    %edx,0x8(%ebp)
  8021aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021b0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021b3:	8a 12                	mov    (%edx),%dl
  8021b5:	88 10                	mov    %dl,(%eax)
  8021b7:	8a 00                	mov    (%eax),%al
  8021b9:	84 c0                	test   %al,%al
  8021bb:	75 e4                	jne    8021a1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8021ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021d5:	eb 1f                	jmp    8021f6 <strncpy+0x34>
		*dst++ = *src;
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	8d 50 01             	lea    0x1(%eax),%edx
  8021dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8021e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e3:	8a 12                	mov    (%edx),%dl
  8021e5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	8a 00                	mov    (%eax),%al
  8021ec:	84 c0                	test   %al,%al
  8021ee:	74 03                	je     8021f3 <strncpy+0x31>
			src++;
  8021f0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8021f3:	ff 45 fc             	incl   -0x4(%ebp)
  8021f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021fc:	72 d9                	jb     8021d7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80220f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802213:	74 30                	je     802245 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802215:	eb 16                	jmp    80222d <strlcpy+0x2a>
			*dst++ = *src++;
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8d 50 01             	lea    0x1(%eax),%edx
  80221d:	89 55 08             	mov    %edx,0x8(%ebp)
  802220:	8b 55 0c             	mov    0xc(%ebp),%edx
  802223:	8d 4a 01             	lea    0x1(%edx),%ecx
  802226:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802229:	8a 12                	mov    (%edx),%dl
  80222b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80222d:	ff 4d 10             	decl   0x10(%ebp)
  802230:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802234:	74 09                	je     80223f <strlcpy+0x3c>
  802236:	8b 45 0c             	mov    0xc(%ebp),%eax
  802239:	8a 00                	mov    (%eax),%al
  80223b:	84 c0                	test   %al,%al
  80223d:	75 d8                	jne    802217 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802245:	8b 55 08             	mov    0x8(%ebp),%edx
  802248:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224b:	29 c2                	sub    %eax,%edx
  80224d:	89 d0                	mov    %edx,%eax
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802254:	eb 06                	jmp    80225c <strcmp+0xb>
		p++, q++;
  802256:	ff 45 08             	incl   0x8(%ebp)
  802259:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	8a 00                	mov    (%eax),%al
  802261:	84 c0                	test   %al,%al
  802263:	74 0e                	je     802273 <strcmp+0x22>
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	8a 10                	mov    (%eax),%dl
  80226a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226d:	8a 00                	mov    (%eax),%al
  80226f:	38 c2                	cmp    %al,%dl
  802271:	74 e3                	je     802256 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8a 00                	mov    (%eax),%al
  802278:	0f b6 d0             	movzbl %al,%edx
  80227b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227e:	8a 00                	mov    (%eax),%al
  802280:	0f b6 c0             	movzbl %al,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
}
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80228c:	eb 09                	jmp    802297 <strncmp+0xe>
		n--, p++, q++;
  80228e:	ff 4d 10             	decl   0x10(%ebp)
  802291:	ff 45 08             	incl   0x8(%ebp)
  802294:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802297:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80229b:	74 17                	je     8022b4 <strncmp+0x2b>
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8a 00                	mov    (%eax),%al
  8022a2:	84 c0                	test   %al,%al
  8022a4:	74 0e                	je     8022b4 <strncmp+0x2b>
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8a 10                	mov    (%eax),%dl
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	8a 00                	mov    (%eax),%al
  8022b0:	38 c2                	cmp    %al,%dl
  8022b2:	74 da                	je     80228e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8022b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b8:	75 07                	jne    8022c1 <strncmp+0x38>
		return 0;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bf:	eb 14                	jmp    8022d5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8a 00                	mov    (%eax),%al
  8022c6:	0f b6 d0             	movzbl %al,%edx
  8022c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cc:	8a 00                	mov    (%eax),%al
  8022ce:	0f b6 c0             	movzbl %al,%eax
  8022d1:	29 c2                	sub    %eax,%edx
  8022d3:	89 d0                	mov    %edx,%eax
}
  8022d5:	5d                   	pop    %ebp
  8022d6:	c3                   	ret    

008022d7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022e3:	eb 12                	jmp    8022f7 <strchr+0x20>
		if (*s == c)
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8a 00                	mov    (%eax),%al
  8022ea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022ed:	75 05                	jne    8022f4 <strchr+0x1d>
			return (char *) s;
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	eb 11                	jmp    802305 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8022f4:	ff 45 08             	incl   0x8(%ebp)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8a 00                	mov    (%eax),%al
  8022fc:	84 c0                	test   %al,%al
  8022fe:	75 e5                	jne    8022e5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802310:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802313:	eb 0d                	jmp    802322 <strfind+0x1b>
		if (*s == c)
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	8a 00                	mov    (%eax),%al
  80231a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80231d:	74 0e                	je     80232d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80231f:	ff 45 08             	incl   0x8(%ebp)
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	8a 00                	mov    (%eax),%al
  802327:	84 c0                	test   %al,%al
  802329:	75 ea                	jne    802315 <strfind+0xe>
  80232b:	eb 01                	jmp    80232e <strfind+0x27>
		if (*s == c)
			break;
  80232d:	90                   	nop
	return (char *) s;
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80233f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802343:	76 63                	jbe    8023a8 <memset+0x75>
		uint64 data_block = c;
  802345:	8b 45 0c             	mov    0xc(%ebp),%eax
  802348:	99                   	cltd   
  802349:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80234c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802355:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802359:	c1 e0 08             	shl    $0x8,%eax
  80235c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80235f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802368:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80236c:	c1 e0 10             	shl    $0x10,%eax
  80236f:	09 45 f0             	or     %eax,-0x10(%ebp)
  802372:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	89 c2                	mov    %eax,%edx
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
  802382:	09 45 f0             	or     %eax,-0x10(%ebp)
  802385:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802388:	eb 18                	jmp    8023a2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80238a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80238d:	8d 41 08             	lea    0x8(%ecx),%eax
  802390:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802396:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802399:	89 01                	mov    %eax,(%ecx)
  80239b:	89 51 04             	mov    %edx,0x4(%ecx)
  80239e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8023a2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023a6:	77 e2                	ja     80238a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8023a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023ac:	74 23                	je     8023d1 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8023ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8023b4:	eb 0e                	jmp    8023c4 <memset+0x91>
			*p8++ = (uint8)c;
  8023b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023b9:	8d 50 01             	lea    0x1(%eax),%edx
  8023bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c2:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8023c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	75 e5                	jne    8023b6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8023dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8023e8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023ec:	76 24                	jbe    802412 <memcpy+0x3c>
		while(n >= 8){
  8023ee:	eb 1c                	jmp    80240c <memcpy+0x36>
			*d64 = *s64;
  8023f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023f3:	8b 50 04             	mov    0x4(%eax),%edx
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023fb:	89 01                	mov    %eax,(%ecx)
  8023fd:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802400:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802404:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802408:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80240c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802410:	77 de                	ja     8023f0 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802412:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802416:	74 31                	je     802449 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802418:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80241b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80241e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802421:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802424:	eb 16                	jmp    80243c <memcpy+0x66>
			*d8++ = *s8++;
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	8d 50 01             	lea    0x1(%eax),%edx
  80242c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80242f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802432:	8d 4a 01             	lea    0x1(%edx),%ecx
  802435:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802438:	8a 12                	mov    (%edx),%dl
  80243a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80243c:	8b 45 10             	mov    0x10(%ebp),%eax
  80243f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802442:	89 55 10             	mov    %edx,0x10(%ebp)
  802445:	85 c0                	test   %eax,%eax
  802447:	75 dd                	jne    802426 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802454:	8b 45 0c             	mov    0xc(%ebp),%eax
  802457:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802463:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802466:	73 50                	jae    8024b8 <memmove+0x6a>
  802468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246b:	8b 45 10             	mov    0x10(%ebp),%eax
  80246e:	01 d0                	add    %edx,%eax
  802470:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802473:	76 43                	jbe    8024b8 <memmove+0x6a>
		s += n;
  802475:	8b 45 10             	mov    0x10(%ebp),%eax
  802478:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80247b:	8b 45 10             	mov    0x10(%ebp),%eax
  80247e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802481:	eb 10                	jmp    802493 <memmove+0x45>
			*--d = *--s;
  802483:	ff 4d f8             	decl   -0x8(%ebp)
  802486:	ff 4d fc             	decl   -0x4(%ebp)
  802489:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80248c:	8a 10                	mov    (%eax),%dl
  80248e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802491:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802493:	8b 45 10             	mov    0x10(%ebp),%eax
  802496:	8d 50 ff             	lea    -0x1(%eax),%edx
  802499:	89 55 10             	mov    %edx,0x10(%ebp)
  80249c:	85 c0                	test   %eax,%eax
  80249e:	75 e3                	jne    802483 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8024a0:	eb 23                	jmp    8024c5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8024a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a5:	8d 50 01             	lea    0x1(%eax),%edx
  8024a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024b1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024b4:	8a 12                	mov    (%edx),%dl
  8024b6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8024b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024be:	89 55 10             	mov    %edx,0x10(%ebp)
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	75 dd                	jne    8024a2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8024c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8024d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8024dc:	eb 2a                	jmp    802508 <memcmp+0x3e>
		if (*s1 != *s2)
  8024de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e1:	8a 10                	mov    (%eax),%dl
  8024e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e6:	8a 00                	mov    (%eax),%al
  8024e8:	38 c2                	cmp    %al,%dl
  8024ea:	74 16                	je     802502 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8024ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ef:	8a 00                	mov    (%eax),%al
  8024f1:	0f b6 d0             	movzbl %al,%edx
  8024f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024f7:	8a 00                	mov    (%eax),%al
  8024f9:	0f b6 c0             	movzbl %al,%eax
  8024fc:	29 c2                	sub    %eax,%edx
  8024fe:	89 d0                	mov    %edx,%eax
  802500:	eb 18                	jmp    80251a <memcmp+0x50>
		s1++, s2++;
  802502:	ff 45 fc             	incl   -0x4(%ebp)
  802505:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802508:	8b 45 10             	mov    0x10(%ebp),%eax
  80250b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80250e:	89 55 10             	mov    %edx,0x10(%ebp)
  802511:	85 c0                	test   %eax,%eax
  802513:	75 c9                	jne    8024de <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802522:	8b 55 08             	mov    0x8(%ebp),%edx
  802525:	8b 45 10             	mov    0x10(%ebp),%eax
  802528:	01 d0                	add    %edx,%eax
  80252a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80252d:	eb 15                	jmp    802544 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	8a 00                	mov    (%eax),%al
  802534:	0f b6 d0             	movzbl %al,%edx
  802537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253a:	0f b6 c0             	movzbl %al,%eax
  80253d:	39 c2                	cmp    %eax,%edx
  80253f:	74 0d                	je     80254e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802541:	ff 45 08             	incl   0x8(%ebp)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80254a:	72 e3                	jb     80252f <memfind+0x13>
  80254c:	eb 01                	jmp    80254f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80254e:	90                   	nop
	return (void *) s;
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80255a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802561:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802568:	eb 03                	jmp    80256d <strtol+0x19>
		s++;
  80256a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80256d:	8b 45 08             	mov    0x8(%ebp),%eax
  802570:	8a 00                	mov    (%eax),%al
  802572:	3c 20                	cmp    $0x20,%al
  802574:	74 f4                	je     80256a <strtol+0x16>
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	8a 00                	mov    (%eax),%al
  80257b:	3c 09                	cmp    $0x9,%al
  80257d:	74 eb                	je     80256a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	8a 00                	mov    (%eax),%al
  802584:	3c 2b                	cmp    $0x2b,%al
  802586:	75 05                	jne    80258d <strtol+0x39>
		s++;
  802588:	ff 45 08             	incl   0x8(%ebp)
  80258b:	eb 13                	jmp    8025a0 <strtol+0x4c>
	else if (*s == '-')
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	8a 00                	mov    (%eax),%al
  802592:	3c 2d                	cmp    $0x2d,%al
  802594:	75 0a                	jne    8025a0 <strtol+0x4c>
		s++, neg = 1;
  802596:	ff 45 08             	incl   0x8(%ebp)
  802599:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025a4:	74 06                	je     8025ac <strtol+0x58>
  8025a6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8025aa:	75 20                	jne    8025cc <strtol+0x78>
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	8a 00                	mov    (%eax),%al
  8025b1:	3c 30                	cmp    $0x30,%al
  8025b3:	75 17                	jne    8025cc <strtol+0x78>
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	40                   	inc    %eax
  8025b9:	8a 00                	mov    (%eax),%al
  8025bb:	3c 78                	cmp    $0x78,%al
  8025bd:	75 0d                	jne    8025cc <strtol+0x78>
		s += 2, base = 16;
  8025bf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8025c3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8025ca:	eb 28                	jmp    8025f4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8025cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025d0:	75 15                	jne    8025e7 <strtol+0x93>
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	8a 00                	mov    (%eax),%al
  8025d7:	3c 30                	cmp    $0x30,%al
  8025d9:	75 0c                	jne    8025e7 <strtol+0x93>
		s++, base = 8;
  8025db:	ff 45 08             	incl   0x8(%ebp)
  8025de:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8025e5:	eb 0d                	jmp    8025f4 <strtol+0xa0>
	else if (base == 0)
  8025e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025eb:	75 07                	jne    8025f4 <strtol+0xa0>
		base = 10;
  8025ed:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	8a 00                	mov    (%eax),%al
  8025f9:	3c 2f                	cmp    $0x2f,%al
  8025fb:	7e 19                	jle    802616 <strtol+0xc2>
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	8a 00                	mov    (%eax),%al
  802602:	3c 39                	cmp    $0x39,%al
  802604:	7f 10                	jg     802616 <strtol+0xc2>
			dig = *s - '0';
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	8a 00                	mov    (%eax),%al
  80260b:	0f be c0             	movsbl %al,%eax
  80260e:	83 e8 30             	sub    $0x30,%eax
  802611:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802614:	eb 42                	jmp    802658 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	8a 00                	mov    (%eax),%al
  80261b:	3c 60                	cmp    $0x60,%al
  80261d:	7e 19                	jle    802638 <strtol+0xe4>
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	8a 00                	mov    (%eax),%al
  802624:	3c 7a                	cmp    $0x7a,%al
  802626:	7f 10                	jg     802638 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	8a 00                	mov    (%eax),%al
  80262d:	0f be c0             	movsbl %al,%eax
  802630:	83 e8 57             	sub    $0x57,%eax
  802633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802636:	eb 20                	jmp    802658 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	8a 00                	mov    (%eax),%al
  80263d:	3c 40                	cmp    $0x40,%al
  80263f:	7e 39                	jle    80267a <strtol+0x126>
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	8a 00                	mov    (%eax),%al
  802646:	3c 5a                	cmp    $0x5a,%al
  802648:	7f 30                	jg     80267a <strtol+0x126>
			dig = *s - 'A' + 10;
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	8a 00                	mov    (%eax),%al
  80264f:	0f be c0             	movsbl %al,%eax
  802652:	83 e8 37             	sub    $0x37,%eax
  802655:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80265e:	7d 19                	jge    802679 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802660:	ff 45 08             	incl   0x8(%ebp)
  802663:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802666:	0f af 45 10          	imul   0x10(%ebp),%eax
  80266a:	89 c2                	mov    %eax,%edx
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	01 d0                	add    %edx,%eax
  802671:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802674:	e9 7b ff ff ff       	jmp    8025f4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802679:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80267a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80267e:	74 08                	je     802688 <strtol+0x134>
		*endptr = (char *) s;
  802680:	8b 45 0c             	mov    0xc(%ebp),%eax
  802683:	8b 55 08             	mov    0x8(%ebp),%edx
  802686:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802688:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80268c:	74 07                	je     802695 <strtol+0x141>
  80268e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802691:	f7 d8                	neg    %eax
  802693:	eb 03                	jmp    802698 <strtol+0x144>
  802695:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <ltostr>:

void
ltostr(long value, char *str)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8026a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8026a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8026ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026b2:	79 13                	jns    8026c7 <ltostr+0x2d>
	{
		neg = 1;
  8026b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8026bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026be:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8026c1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8026c4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8026cf:	99                   	cltd   
  8026d0:	f7 f9                	idiv   %ecx
  8026d2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8026d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d8:	8d 50 01             	lea    0x1(%eax),%edx
  8026db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8026de:	89 c2                	mov    %eax,%edx
  8026e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026e3:	01 d0                	add    %edx,%eax
  8026e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e8:	83 c2 30             	add    $0x30,%edx
  8026eb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8026ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026f0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8026f5:	f7 e9                	imul   %ecx
  8026f7:	c1 fa 02             	sar    $0x2,%edx
  8026fa:	89 c8                	mov    %ecx,%eax
  8026fc:	c1 f8 1f             	sar    $0x1f,%eax
  8026ff:	29 c2                	sub    %eax,%edx
  802701:	89 d0                	mov    %edx,%eax
  802703:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802706:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80270a:	75 bb                	jne    8026c7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80270c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802716:	48                   	dec    %eax
  802717:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80271a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80271e:	74 3d                	je     80275d <ltostr+0xc3>
		start = 1 ;
  802720:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802727:	eb 34                	jmp    80275d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802729:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272f:	01 d0                	add    %edx,%eax
  802731:	8a 00                	mov    (%eax),%al
  802733:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273c:	01 c2                	add    %eax,%edx
  80273e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802741:	8b 45 0c             	mov    0xc(%ebp),%eax
  802744:	01 c8                	add    %ecx,%eax
  802746:	8a 00                	mov    (%eax),%al
  802748:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80274a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802750:	01 c2                	add    %eax,%edx
  802752:	8a 45 eb             	mov    -0x15(%ebp),%al
  802755:	88 02                	mov    %al,(%edx)
		start++ ;
  802757:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80275a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802763:	7c c4                	jl     802729 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802765:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276b:	01 d0                	add    %edx,%eax
  80276d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802770:	90                   	nop
  802771:	c9                   	leave  
  802772:	c3                   	ret    

00802773 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802779:	ff 75 08             	pushl  0x8(%ebp)
  80277c:	e8 c4 f9 ff ff       	call   802145 <strlen>
  802781:	83 c4 04             	add    $0x4,%esp
  802784:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802787:	ff 75 0c             	pushl  0xc(%ebp)
  80278a:	e8 b6 f9 ff ff       	call   802145 <strlen>
  80278f:	83 c4 04             	add    $0x4,%esp
  802792:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802795:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80279c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8027a3:	eb 17                	jmp    8027bc <strcconcat+0x49>
		final[s] = str1[s] ;
  8027a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ab:	01 c2                	add    %eax,%edx
  8027ad:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b3:	01 c8                	add    %ecx,%eax
  8027b5:	8a 00                	mov    (%eax),%al
  8027b7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8027b9:	ff 45 fc             	incl   -0x4(%ebp)
  8027bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027c2:	7c e1                	jl     8027a5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8027c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8027cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8027d2:	eb 1f                	jmp    8027f3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8027d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027d7:	8d 50 01             	lea    0x1(%eax),%edx
  8027da:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8027dd:	89 c2                	mov    %eax,%edx
  8027df:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e2:	01 c2                	add    %eax,%edx
  8027e4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8027e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ea:	01 c8                	add    %ecx,%eax
  8027ec:	8a 00                	mov    (%eax),%al
  8027ee:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8027f0:	ff 45 f8             	incl   -0x8(%ebp)
  8027f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027f9:	7c d9                	jl     8027d4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8027fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802801:	01 d0                	add    %edx,%eax
  802803:	c6 00 00             	movb   $0x0,(%eax)
}
  802806:	90                   	nop
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80280c:	8b 45 14             	mov    0x14(%ebp),%eax
  80280f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802815:	8b 45 14             	mov    0x14(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802821:	8b 45 10             	mov    0x10(%ebp),%eax
  802824:	01 d0                	add    %edx,%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80282c:	eb 0c                	jmp    80283a <strsplit+0x31>
			*string++ = 0;
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	8d 50 01             	lea    0x1(%eax),%edx
  802834:	89 55 08             	mov    %edx,0x8(%ebp)
  802837:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80283a:	8b 45 08             	mov    0x8(%ebp),%eax
  80283d:	8a 00                	mov    (%eax),%al
  80283f:	84 c0                	test   %al,%al
  802841:	74 18                	je     80285b <strsplit+0x52>
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	8a 00                	mov    (%eax),%al
  802848:	0f be c0             	movsbl %al,%eax
  80284b:	50                   	push   %eax
  80284c:	ff 75 0c             	pushl  0xc(%ebp)
  80284f:	e8 83 fa ff ff       	call   8022d7 <strchr>
  802854:	83 c4 08             	add    $0x8,%esp
  802857:	85 c0                	test   %eax,%eax
  802859:	75 d3                	jne    80282e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	8a 00                	mov    (%eax),%al
  802860:	84 c0                	test   %al,%al
  802862:	74 5a                	je     8028be <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802864:	8b 45 14             	mov    0x14(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	83 f8 0f             	cmp    $0xf,%eax
  80286c:	75 07                	jne    802875 <strsplit+0x6c>
		{
			return 0;
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
  802873:	eb 66                	jmp    8028db <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802875:	8b 45 14             	mov    0x14(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	8d 48 01             	lea    0x1(%eax),%ecx
  80287d:	8b 55 14             	mov    0x14(%ebp),%edx
  802880:	89 0a                	mov    %ecx,(%edx)
  802882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	01 c2                	add    %eax,%edx
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802893:	eb 03                	jmp    802898 <strsplit+0x8f>
			string++;
  802895:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	8a 00                	mov    (%eax),%al
  80289d:	84 c0                	test   %al,%al
  80289f:	74 8b                	je     80282c <strsplit+0x23>
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	8a 00                	mov    (%eax),%al
  8028a6:	0f be c0             	movsbl %al,%eax
  8028a9:	50                   	push   %eax
  8028aa:	ff 75 0c             	pushl  0xc(%ebp)
  8028ad:	e8 25 fa ff ff       	call   8022d7 <strchr>
  8028b2:	83 c4 08             	add    $0x8,%esp
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	74 dc                	je     802895 <strsplit+0x8c>
			string++;
	}
  8028b9:	e9 6e ff ff ff       	jmp    80282c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8028be:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8028bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8028d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8028e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8028f0:	eb 4a                	jmp    80293c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8028f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	01 c2                	add    %eax,%edx
  8028fa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8028fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802900:	01 c8                	add    %ecx,%eax
  802902:	8a 00                	mov    (%eax),%al
  802904:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802906:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	8a 00                	mov    (%eax),%al
  802910:	3c 40                	cmp    $0x40,%al
  802912:	7e 25                	jle    802939 <str2lower+0x5c>
  802914:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291a:	01 d0                	add    %edx,%eax
  80291c:	8a 00                	mov    (%eax),%al
  80291e:	3c 5a                	cmp    $0x5a,%al
  802920:	7f 17                	jg     802939 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802922:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	01 d0                	add    %edx,%eax
  80292a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80292d:	8b 55 08             	mov    0x8(%ebp),%edx
  802930:	01 ca                	add    %ecx,%edx
  802932:	8a 12                	mov    (%edx),%dl
  802934:	83 c2 20             	add    $0x20,%edx
  802937:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802939:	ff 45 fc             	incl   -0x4(%ebp)
  80293c:	ff 75 0c             	pushl  0xc(%ebp)
  80293f:	e8 01 f8 ff ff       	call   802145 <strlen>
  802944:	83 c4 04             	add    $0x4,%esp
  802947:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80294a:	7f a6                	jg     8028f2 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80294c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80294f:	c9                   	leave  
  802950:	c3                   	ret    

00802951 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  802957:	83 ec 0c             	sub    $0xc,%esp
  80295a:	6a 10                	push   $0x10
  80295c:	e8 b2 15 00 00       	call   803f13 <alloc_block>
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  802967:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80296b:	75 14                	jne    802981 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 08 5c 80 00       	push   $0x805c08
  802975:	6a 14                	push   $0x14
  802977:	68 31 5c 80 00       	push   $0x805c31
  80297c:	e8 fd ed ff ff       	call   80177e <_panic>

	node->start = start;
  802981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802984:	8b 55 08             	mov    0x8(%ebp),%edx
  802987:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  802989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802992:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  802999:	a1 04 72 80 00       	mov    0x807204,%eax
  80299e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a1:	eb 18                	jmp    8029bb <insert_page_alloc+0x6a>
		if (start < it->start)
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ab:	77 37                	ja     8029e4 <insert_page_alloc+0x93>
			break;
		prev = it;
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8029b3:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8029b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bf:	74 08                	je     8029c9 <insert_page_alloc+0x78>
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 40 08             	mov    0x8(%eax),%eax
  8029c7:	eb 05                	jmp    8029ce <insert_page_alloc+0x7d>
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ce:	a3 0c 72 80 00       	mov    %eax,0x80720c
  8029d3:	a1 0c 72 80 00       	mov    0x80720c,%eax
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	75 c7                	jne    8029a3 <insert_page_alloc+0x52>
  8029dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e0:	75 c1                	jne    8029a3 <insert_page_alloc+0x52>
  8029e2:	eb 01                	jmp    8029e5 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8029e4:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8029e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e9:	75 64                	jne    802a4f <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8029eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ef:	75 14                	jne    802a05 <insert_page_alloc+0xb4>
  8029f1:	83 ec 04             	sub    $0x4,%esp
  8029f4:	68 40 5c 80 00       	push   $0x805c40
  8029f9:	6a 21                	push   $0x21
  8029fb:	68 31 5c 80 00       	push   $0x805c31
  802a00:	e8 79 ed ff ff       	call   80177e <_panic>
  802a05:	8b 15 04 72 80 00    	mov    0x807204,%edx
  802a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0e:	89 50 08             	mov    %edx,0x8(%eax)
  802a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a14:	8b 40 08             	mov    0x8(%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0d                	je     802a28 <insert_page_alloc+0xd7>
  802a1b:	a1 04 72 80 00       	mov    0x807204,%eax
  802a20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a23:	89 50 0c             	mov    %edx,0xc(%eax)
  802a26:	eb 08                	jmp    802a30 <insert_page_alloc+0xdf>
  802a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2b:	a3 08 72 80 00       	mov    %eax,0x807208
  802a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a33:	a3 04 72 80 00       	mov    %eax,0x807204
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a42:	a1 10 72 80 00       	mov    0x807210,%eax
  802a47:	40                   	inc    %eax
  802a48:	a3 10 72 80 00       	mov    %eax,0x807210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  802a4d:	eb 71                	jmp    802ac0 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802a4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a53:	74 06                	je     802a5b <insert_page_alloc+0x10a>
  802a55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a59:	75 14                	jne    802a6f <insert_page_alloc+0x11e>
  802a5b:	83 ec 04             	sub    $0x4,%esp
  802a5e:	68 64 5c 80 00       	push   $0x805c64
  802a63:	6a 23                	push   $0x23
  802a65:	68 31 5c 80 00       	push   $0x805c31
  802a6a:	e8 0f ed ff ff       	call   80177e <_panic>
  802a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a72:	8b 50 08             	mov    0x8(%eax),%edx
  802a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a78:	89 50 08             	mov    %edx,0x8(%eax)
  802a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 0c                	je     802a91 <insert_page_alloc+0x140>
  802a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a88:	8b 40 08             	mov    0x8(%eax),%eax
  802a8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a8e:	89 50 0c             	mov    %edx,0xc(%eax)
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a97:	89 50 08             	mov    %edx,0x8(%eax)
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa0:	89 50 0c             	mov    %edx,0xc(%eax)
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	8b 40 08             	mov    0x8(%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	75 08                	jne    802ab5 <insert_page_alloc+0x164>
  802aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab0:	a3 08 72 80 00       	mov    %eax,0x807208
  802ab5:	a1 10 72 80 00       	mov    0x807210,%eax
  802aba:	40                   	inc    %eax
  802abb:	a3 10 72 80 00       	mov    %eax,0x807210
}
  802ac0:	90                   	nop
  802ac1:	c9                   	leave  
  802ac2:	c3                   	ret    

00802ac3 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  802ac3:	55                   	push   %ebp
  802ac4:	89 e5                	mov    %esp,%ebp
  802ac6:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  802ac9:	a1 04 72 80 00       	mov    0x807204,%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	75 0c                	jne    802ade <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  802ad2:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802ad7:	a3 50 f2 81 00       	mov    %eax,0x81f250
		return;
  802adc:	eb 67                	jmp    802b45 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  802ade:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802ae6:	a1 04 72 80 00       	mov    0x807204,%eax
  802aeb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802aee:	eb 26                	jmp    802b16 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  802af0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802af3:	8b 10                	mov    (%eax),%edx
  802af5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	01 d0                	add    %edx,%eax
  802afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802b06:	76 06                	jbe    802b0e <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b0e:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802b13:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802b16:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802b1a:	74 08                	je     802b24 <recompute_page_alloc_break+0x61>
  802b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b1f:	8b 40 08             	mov    0x8(%eax),%eax
  802b22:	eb 05                	jmp    802b29 <recompute_page_alloc_break+0x66>
  802b24:	b8 00 00 00 00       	mov    $0x0,%eax
  802b29:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802b2e:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	75 b9                	jne    802af0 <recompute_page_alloc_break+0x2d>
  802b37:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802b3b:	75 b3                	jne    802af0 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  802b3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b40:	a3 50 f2 81 00       	mov    %eax,0x81f250
}
  802b45:	c9                   	leave  
  802b46:	c3                   	ret    

00802b47 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  802b47:	55                   	push   %ebp
  802b48:	89 e5                	mov    %esp,%ebp
  802b4a:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  802b4d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b54:	8b 55 08             	mov    0x8(%ebp),%edx
  802b57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b5a:	01 d0                	add    %edx,%eax
  802b5c:	48                   	dec    %eax
  802b5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b63:	ba 00 00 00 00       	mov    $0x0,%edx
  802b68:	f7 75 d8             	divl   -0x28(%ebp)
  802b6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b6e:	29 d0                	sub    %edx,%eax
  802b70:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  802b73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802b77:	75 0a                	jne    802b83 <alloc_pages_custom_fit+0x3c>
		return NULL;
  802b79:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7e:	e9 7e 01 00 00       	jmp    802d01 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  802b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  802b8a:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802b8e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  802b95:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  802b9c:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802ba4:	a1 04 72 80 00       	mov    0x807204,%eax
  802ba9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802bac:	eb 69                	jmp    802c17 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802bb6:	76 47                	jbe    802bff <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  802bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  802bbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802bc6:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  802bc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bcc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802bcf:	72 2e                	jb     802bff <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  802bd1:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802bd5:	75 14                	jne    802beb <alloc_pages_custom_fit+0xa4>
  802bd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bda:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802bdd:	75 0c                	jne    802beb <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  802bdf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  802be5:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802be9:	eb 14                	jmp    802bff <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802beb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bee:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802bf1:	76 0c                	jbe    802bff <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  802bf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  802bf9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bfc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c02:	8b 10                	mov    (%eax),%edx
  802c04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	01 d0                	add    %edx,%eax
  802c0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802c0f:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802c14:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802c17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c1b:	74 08                	je     802c25 <alloc_pages_custom_fit+0xde>
  802c1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c20:	8b 40 08             	mov    0x8(%eax),%eax
  802c23:	eb 05                	jmp    802c2a <alloc_pages_custom_fit+0xe3>
  802c25:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2a:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802c2f:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	0f 85 72 ff ff ff    	jne    802bae <alloc_pages_custom_fit+0x67>
  802c3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c40:	0f 85 68 ff ff ff    	jne    802bae <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802c46:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802c4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c4e:	76 47                	jbe    802c97 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802c56:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802c5b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c5e:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802c61:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c64:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802c67:	72 2e                	jb     802c97 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802c69:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802c6d:	75 14                	jne    802c83 <alloc_pages_custom_fit+0x13c>
  802c6f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c72:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802c75:	75 0c                	jne    802c83 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802c77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802c7d:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802c81:	eb 14                	jmp    802c97 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802c83:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c86:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c89:	76 0c                	jbe    802c97 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802c8b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802c91:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c94:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802c9e:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802ca2:	74 08                	je     802cac <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802caa:	eb 40                	jmp    802cec <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802cac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb0:	74 08                	je     802cba <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802cb8:	eb 32                	jmp    802cec <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802cba:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802cbf:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802cc2:	89 c2                	mov    %eax,%edx
  802cc4:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802cc9:	39 c2                	cmp    %eax,%edx
  802ccb:	73 07                	jae    802cd4 <alloc_pages_custom_fit+0x18d>
			return NULL;
  802ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd2:	eb 2d                	jmp    802d01 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802cd4:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802cd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802cdc:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802ce2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ce5:	01 d0                	add    %edx,%eax
  802ce7:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}


	insert_page_alloc((uint32)result, required_size);
  802cec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cef:	83 ec 08             	sub    $0x8,%esp
  802cf2:	ff 75 d0             	pushl  -0x30(%ebp)
  802cf5:	50                   	push   %eax
  802cf6:	e8 56 fc ff ff       	call   802951 <insert_page_alloc>
  802cfb:	83 c4 10             	add    $0x10,%esp

	return result;
  802cfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802d01:	c9                   	leave  
  802d02:	c3                   	ret    

00802d03 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802d03:	55                   	push   %ebp
  802d04:	89 e5                	mov    %esp,%ebp
  802d06:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802d0f:	a1 04 72 80 00       	mov    0x807204,%eax
  802d14:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d17:	eb 1a                	jmp    802d33 <find_allocated_size+0x30>
		if (it->start == va)
  802d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802d21:	75 08                	jne    802d2b <find_allocated_size+0x28>
			return it->size;
  802d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	eb 34                	jmp    802d5f <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802d2b:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d37:	74 08                	je     802d41 <find_allocated_size+0x3e>
  802d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d3c:	8b 40 08             	mov    0x8(%eax),%eax
  802d3f:	eb 05                	jmp    802d46 <find_allocated_size+0x43>
  802d41:	b8 00 00 00 00       	mov    $0x0,%eax
  802d46:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802d4b:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	75 c5                	jne    802d19 <find_allocated_size+0x16>
  802d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d58:	75 bf                	jne    802d19 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5f:	c9                   	leave  
  802d60:	c3                   	ret    

00802d61 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
  802d64:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802d6d:	a1 04 72 80 00       	mov    0x807204,%eax
  802d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d75:	e9 e1 01 00 00       	jmp    802f5b <free_pages+0x1fa>
		if (it->start == va) {
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d82:	0f 85 cb 01 00 00    	jne    802f53 <free_pages+0x1f2>

			uint32 start = it->start;
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 00                	mov    (%eax),%eax
  802d8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9c:	f7 d0                	not    %eax
  802d9e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802da1:	73 1d                	jae    802dc0 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802da3:	83 ec 0c             	sub    $0xc,%esp
  802da6:	ff 75 e4             	pushl  -0x1c(%ebp)
  802da9:	ff 75 e8             	pushl  -0x18(%ebp)
  802dac:	68 98 5c 80 00       	push   $0x805c98
  802db1:	68 a5 00 00 00       	push   $0xa5
  802db6:	68 31 5c 80 00       	push   $0x805c31
  802dbb:	e8 be e9 ff ff       	call   80177e <_panic>
			}

			uint32 start_end = start + size;
  802dc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc6:	01 d0                	add    %edx,%eax
  802dc8:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	79 19                	jns    802deb <free_pages+0x8a>
  802dd2:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802dd9:	77 10                	ja     802deb <free_pages+0x8a>
  802ddb:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802de2:	77 07                	ja     802deb <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	78 2c                	js     802e17 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dee:	83 ec 0c             	sub    $0xc,%esp
  802df1:	68 00 00 00 a0       	push   $0xa0000000
  802df6:	ff 75 e0             	pushl  -0x20(%ebp)
  802df9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dfc:	ff 75 e8             	pushl  -0x18(%ebp)
  802dff:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e02:	50                   	push   %eax
  802e03:	68 dc 5c 80 00       	push   $0x805cdc
  802e08:	68 ad 00 00 00       	push   $0xad
  802e0d:	68 31 5c 80 00       	push   $0x805c31
  802e12:	e8 67 e9 ff ff       	call   80177e <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e1d:	e9 88 00 00 00       	jmp    802eaa <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802e22:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802e29:	76 17                	jbe    802e42 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802e2b:	ff 75 f0             	pushl  -0x10(%ebp)
  802e2e:	68 40 5d 80 00       	push   $0x805d40
  802e33:	68 b4 00 00 00       	push   $0xb4
  802e38:	68 31 5c 80 00       	push   $0x805c31
  802e3d:	e8 3c e9 ff ff       	call   80177e <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e45:	05 00 10 00 00       	add    $0x1000,%eax
  802e4a:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	79 2e                	jns    802e82 <free_pages+0x121>
  802e54:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802e5b:	77 25                	ja     802e82 <free_pages+0x121>
  802e5d:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802e64:	77 1c                	ja     802e82 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802e66:	83 ec 08             	sub    $0x8,%esp
  802e69:	68 00 10 00 00       	push   $0x1000
  802e6e:	ff 75 f0             	pushl  -0x10(%ebp)
  802e71:	e8 38 0d 00 00       	call   803bae <sys_free_user_mem>
  802e76:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802e79:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802e80:	eb 28                	jmp    802eaa <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	68 00 00 00 a0       	push   $0xa0000000
  802e8a:	ff 75 dc             	pushl  -0x24(%ebp)
  802e8d:	68 00 10 00 00       	push   $0x1000
  802e92:	ff 75 f0             	pushl  -0x10(%ebp)
  802e95:	50                   	push   %eax
  802e96:	68 80 5d 80 00       	push   $0x805d80
  802e9b:	68 bd 00 00 00       	push   $0xbd
  802ea0:	68 31 5c 80 00       	push   $0x805c31
  802ea5:	e8 d4 e8 ff ff       	call   80177e <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802eb0:	0f 82 6c ff ff ff    	jb     802e22 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802eb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eba:	75 17                	jne    802ed3 <free_pages+0x172>
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	68 e2 5d 80 00       	push   $0x805de2
  802ec4:	68 c1 00 00 00       	push   $0xc1
  802ec9:	68 31 5c 80 00       	push   $0x805c31
  802ece:	e8 ab e8 ff ff       	call   80177e <_panic>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 08             	mov    0x8(%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 11                	je     802eee <free_pages+0x18d>
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 40 08             	mov    0x8(%eax),%eax
  802ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee6:	8b 52 0c             	mov    0xc(%edx),%edx
  802ee9:	89 50 0c             	mov    %edx,0xc(%eax)
  802eec:	eb 0b                	jmp    802ef9 <free_pages+0x198>
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	a3 08 72 80 00       	mov    %eax,0x807208
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 40 0c             	mov    0xc(%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 11                	je     802f14 <free_pages+0x1b3>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 40 0c             	mov    0xc(%eax),%eax
  802f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0c:	8b 52 08             	mov    0x8(%edx),%edx
  802f0f:	89 50 08             	mov    %edx,0x8(%eax)
  802f12:	eb 0b                	jmp    802f1f <free_pages+0x1be>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	a3 04 72 80 00       	mov    %eax,0x807204
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f33:	a1 10 72 80 00       	mov    0x807210,%eax
  802f38:	48                   	dec    %eax
  802f39:	a3 10 72 80 00       	mov    %eax,0x807210
			free_block(it);
  802f3e:	83 ec 0c             	sub    $0xc,%esp
  802f41:	ff 75 f4             	pushl  -0xc(%ebp)
  802f44:	e8 24 15 00 00       	call   80446d <free_block>
  802f49:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802f4c:	e8 72 fb ff ff       	call   802ac3 <recompute_page_alloc_break>

			return;
  802f51:	eb 37                	jmp    802f8a <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802f53:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5f:	74 08                	je     802f69 <free_pages+0x208>
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 40 08             	mov    0x8(%eax),%eax
  802f67:	eb 05                	jmp    802f6e <free_pages+0x20d>
  802f69:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6e:	a3 0c 72 80 00       	mov    %eax,0x80720c
  802f73:	a1 0c 72 80 00       	mov    0x80720c,%eax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	0f 85 fa fd ff ff    	jne    802d7a <free_pages+0x19>
  802f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f84:	0f 85 f0 fd ff ff    	jne    802d7a <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802f8a:	c9                   	leave  
  802f8b:	c3                   	ret    

00802f8c <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802f8c:	55                   	push   %ebp
  802f8d:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f94:	5d                   	pop    %ebp
  802f95:	c3                   	ret    

00802f96 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802f96:	55                   	push   %ebp
  802f97:	89 e5                	mov    %esp,%ebp
  802f99:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802f9c:	a1 08 70 80 00       	mov    0x807008,%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 60                	je     803005 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802fa5:	83 ec 08             	sub    $0x8,%esp
  802fa8:	68 00 00 00 82       	push   $0x82000000
  802fad:	68 00 00 00 80       	push   $0x80000000
  802fb2:	e8 0d 0d 00 00       	call   803cc4 <initialize_dynamic_allocator>
  802fb7:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802fba:	e8 f3 0a 00 00       	call   803ab2 <sys_get_uheap_strategy>
  802fbf:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802fc4:	a1 20 72 80 00       	mov    0x807220,%eax
  802fc9:	05 00 10 00 00       	add    $0x1000,%eax
  802fce:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802fd3:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802fd8:	a3 50 f2 81 00       	mov    %eax,0x81f250

		LIST_INIT(&page_alloc_list);
  802fdd:	c7 05 04 72 80 00 00 	movl   $0x0,0x807204
  802fe4:	00 00 00 
  802fe7:	c7 05 08 72 80 00 00 	movl   $0x0,0x807208
  802fee:	00 00 00 
  802ff1:	c7 05 10 72 80 00 00 	movl   $0x0,0x807210
  802ff8:	00 00 00 

		__firstTimeFlag = 0;
  802ffb:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  803002:	00 00 00 
	}
}
  803005:	90                   	nop
  803006:	c9                   	leave  
  803007:	c3                   	ret    

00803008 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  803008:	55                   	push   %ebp
  803009:	89 e5                	mov    %esp,%ebp
  80300b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80301c:	83 ec 08             	sub    $0x8,%esp
  80301f:	68 06 04 00 00       	push   $0x406
  803024:	50                   	push   %eax
  803025:	e8 d2 06 00 00       	call   8036fc <__sys_allocate_page>
  80302a:	83 c4 10             	add    $0x10,%esp
  80302d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  803030:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803034:	79 17                	jns    80304d <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	68 00 5e 80 00       	push   $0x805e00
  80303e:	68 ea 00 00 00       	push   $0xea
  803043:	68 31 5c 80 00       	push   $0x805c31
  803048:	e8 31 e7 ff ff       	call   80177e <_panic>
	return 0;
  80304d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803052:	c9                   	leave  
  803053:	c3                   	ret    

00803054 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  803054:	55                   	push   %ebp
  803055:	89 e5                	mov    %esp,%ebp
  803057:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803068:	83 ec 0c             	sub    $0xc,%esp
  80306b:	50                   	push   %eax
  80306c:	e8 d2 06 00 00       	call   803743 <__sys_unmap_frame>
  803071:	83 c4 10             	add    $0x10,%esp
  803074:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  803077:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307b:	79 17                	jns    803094 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 3c 5e 80 00       	push   $0x805e3c
  803085:	68 f5 00 00 00       	push   $0xf5
  80308a:	68 31 5c 80 00       	push   $0x805c31
  80308f:	e8 ea e6 ff ff       	call   80177e <_panic>
}
  803094:	90                   	nop
  803095:	c9                   	leave  
  803096:	c3                   	ret    

00803097 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  803097:	55                   	push   %ebp
  803098:	89 e5                	mov    %esp,%ebp
  80309a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80309d:	e8 f4 fe ff ff       	call   802f96 <uheap_init>
	if (size == 0) return NULL ;
  8030a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a6:	75 0a                	jne    8030b2 <malloc+0x1b>
  8030a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ad:	e9 67 01 00 00       	jmp    803219 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8030b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8030b9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8030c0:	77 16                	ja     8030d8 <malloc+0x41>
		result = alloc_block(size);
  8030c2:	83 ec 0c             	sub    $0xc,%esp
  8030c5:	ff 75 08             	pushl  0x8(%ebp)
  8030c8:	e8 46 0e 00 00       	call   803f13 <alloc_block>
  8030cd:	83 c4 10             	add    $0x10,%esp
  8030d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d3:	e9 3e 01 00 00       	jmp    803216 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  8030d8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8030df:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e5:	01 d0                	add    %edx,%eax
  8030e7:	48                   	dec    %eax
  8030e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8030eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8030f3:	f7 75 f0             	divl   -0x10(%ebp)
  8030f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f9:	29 d0                	sub    %edx,%eax
  8030fb:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8030fe:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	75 0a                	jne    803111 <malloc+0x7a>
			return NULL;
  803107:	b8 00 00 00 00       	mov    $0x0,%eax
  80310c:	e9 08 01 00 00       	jmp    803219 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  803111:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803116:	85 c0                	test   %eax,%eax
  803118:	74 0f                	je     803129 <malloc+0x92>
  80311a:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803120:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803125:	39 c2                	cmp    %eax,%edx
  803127:	73 0a                	jae    803133 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  803129:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80312e:	a3 50 f2 81 00       	mov    %eax,0x81f250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  803133:	a1 44 f2 81 00       	mov    0x81f244,%eax
  803138:	83 f8 05             	cmp    $0x5,%eax
  80313b:	75 11                	jne    80314e <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  80313d:	83 ec 0c             	sub    $0xc,%esp
  803140:	ff 75 e8             	pushl  -0x18(%ebp)
  803143:	e8 ff f9 ff ff       	call   802b47 <alloc_pages_custom_fit>
  803148:	83 c4 10             	add    $0x10,%esp
  80314b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  80314e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803152:	0f 84 be 00 00 00    	je     803216 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80315e:	83 ec 0c             	sub    $0xc,%esp
  803161:	ff 75 f4             	pushl  -0xc(%ebp)
  803164:	e8 9a fb ff ff       	call   802d03 <find_allocated_size>
  803169:	83 c4 10             	add    $0x10,%esp
  80316c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80316f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803173:	75 17                	jne    80318c <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  803175:	ff 75 f4             	pushl  -0xc(%ebp)
  803178:	68 7c 5e 80 00       	push   $0x805e7c
  80317d:	68 24 01 00 00       	push   $0x124
  803182:	68 31 5c 80 00       	push   $0x805c31
  803187:	e8 f2 e5 ff ff       	call   80177e <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  80318c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318f:	f7 d0                	not    %eax
  803191:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803194:	73 1d                	jae    8031b3 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  803196:	83 ec 0c             	sub    $0xc,%esp
  803199:	ff 75 e0             	pushl  -0x20(%ebp)
  80319c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80319f:	68 c4 5e 80 00       	push   $0x805ec4
  8031a4:	68 29 01 00 00       	push   $0x129
  8031a9:	68 31 5c 80 00       	push   $0x805c31
  8031ae:	e8 cb e5 ff ff       	call   80177e <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8031b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b9:	01 d0                	add    %edx,%eax
  8031bb:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8031be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	79 2c                	jns    8031f1 <malloc+0x15a>
  8031c5:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  8031cc:	77 23                	ja     8031f1 <malloc+0x15a>
  8031ce:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8031d5:	77 1a                	ja     8031f1 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  8031d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	79 13                	jns    8031f1 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  8031de:	83 ec 08             	sub    $0x8,%esp
  8031e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8031e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031e7:	e8 de 09 00 00       	call   803bca <sys_allocate_user_mem>
  8031ec:	83 c4 10             	add    $0x10,%esp
  8031ef:	eb 25                	jmp    803216 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  8031f1:	68 00 00 00 a0       	push   $0xa0000000
  8031f6:	ff 75 dc             	pushl  -0x24(%ebp)
  8031f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8031fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031ff:	ff 75 f4             	pushl  -0xc(%ebp)
  803202:	68 00 5f 80 00       	push   $0x805f00
  803207:	68 33 01 00 00       	push   $0x133
  80320c:	68 31 5c 80 00       	push   $0x805c31
  803211:	e8 68 e5 ff ff       	call   80177e <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  803219:	c9                   	leave  
  80321a:	c3                   	ret    

0080321b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80321b:	55                   	push   %ebp
  80321c:	89 e5                	mov    %esp,%ebp
  80321e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803225:	0f 84 26 01 00 00    	je     803351 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	85 c0                	test   %eax,%eax
  803236:	79 1c                	jns    803254 <free+0x39>
  803238:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80323f:	77 13                	ja     803254 <free+0x39>
		free_block(virtual_address);
  803241:	83 ec 0c             	sub    $0xc,%esp
  803244:	ff 75 08             	pushl  0x8(%ebp)
  803247:	e8 21 12 00 00       	call   80446d <free_block>
  80324c:	83 c4 10             	add    $0x10,%esp
		return;
  80324f:	e9 01 01 00 00       	jmp    803355 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  803254:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803259:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80325c:	0f 82 d8 00 00 00    	jb     80333a <free+0x11f>
  803262:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  803269:	0f 87 cb 00 00 00    	ja     80333a <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	25 ff 0f 00 00       	and    $0xfff,%eax
  803277:	85 c0                	test   %eax,%eax
  803279:	74 17                	je     803292 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80327b:	ff 75 08             	pushl  0x8(%ebp)
  80327e:	68 70 5f 80 00       	push   $0x805f70
  803283:	68 57 01 00 00       	push   $0x157
  803288:	68 31 5c 80 00       	push   $0x805c31
  80328d:	e8 ec e4 ff ff       	call   80177e <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  803292:	83 ec 0c             	sub    $0xc,%esp
  803295:	ff 75 08             	pushl  0x8(%ebp)
  803298:	e8 66 fa ff ff       	call   802d03 <find_allocated_size>
  80329d:	83 c4 10             	add    $0x10,%esp
  8032a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8032a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a7:	0f 84 a7 00 00 00    	je     803354 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8032ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b0:	f7 d0                	not    %eax
  8032b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032b5:	73 1d                	jae    8032d4 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8032b7:	83 ec 0c             	sub    $0xc,%esp
  8032ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8032bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8032c0:	68 98 5f 80 00       	push   $0x805f98
  8032c5:	68 61 01 00 00       	push   $0x161
  8032ca:	68 31 5c 80 00       	push   $0x805c31
  8032cf:	e8 aa e4 ff ff       	call   80177e <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8032d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	01 d0                	add    %edx,%eax
  8032dc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8032df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	79 19                	jns    8032ff <free+0xe4>
  8032e6:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8032ed:	77 10                	ja     8032ff <free+0xe4>
  8032ef:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8032f6:	77 07                	ja     8032ff <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fb:	85 c0                	test   %eax,%eax
  8032fd:	78 2b                	js     80332a <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8032ff:	83 ec 0c             	sub    $0xc,%esp
  803302:	68 00 00 00 a0       	push   $0xa0000000
  803307:	ff 75 ec             	pushl  -0x14(%ebp)
  80330a:	ff 75 f0             	pushl  -0x10(%ebp)
  80330d:	ff 75 f4             	pushl  -0xc(%ebp)
  803310:	ff 75 f0             	pushl  -0x10(%ebp)
  803313:	ff 75 08             	pushl  0x8(%ebp)
  803316:	68 d4 5f 80 00       	push   $0x805fd4
  80331b:	68 69 01 00 00       	push   $0x169
  803320:	68 31 5c 80 00       	push   $0x805c31
  803325:	e8 54 e4 ff ff       	call   80177e <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80332a:	83 ec 0c             	sub    $0xc,%esp
  80332d:	ff 75 08             	pushl  0x8(%ebp)
  803330:	e8 2c fa ff ff       	call   802d61 <free_pages>
  803335:	83 c4 10             	add    $0x10,%esp
		return;
  803338:	eb 1b                	jmp    803355 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80333a:	ff 75 08             	pushl  0x8(%ebp)
  80333d:	68 30 60 80 00       	push   $0x806030
  803342:	68 70 01 00 00       	push   $0x170
  803347:	68 31 5c 80 00       	push   $0x805c31
  80334c:	e8 2d e4 ff ff       	call   80177e <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803351:	90                   	nop
  803352:	eb 01                	jmp    803355 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  803354:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  803355:	c9                   	leave  
  803356:	c3                   	ret    

00803357 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  803357:	55                   	push   %ebp
  803358:	89 e5                	mov    %esp,%ebp
  80335a:	83 ec 38             	sub    $0x38,%esp
  80335d:	8b 45 10             	mov    0x10(%ebp),%eax
  803360:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803363:	e8 2e fc ff ff       	call   802f96 <uheap_init>
	if (size == 0) return NULL ;
  803368:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80336c:	75 0a                	jne    803378 <smalloc+0x21>
  80336e:	b8 00 00 00 00       	mov    $0x0,%eax
  803373:	e9 3d 01 00 00       	jmp    8034b5 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  803378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80337e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803381:	25 ff 0f 00 00       	and    $0xfff,%eax
  803386:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  803389:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80338d:	74 0e                	je     80339d <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803395:	05 00 10 00 00       	add    $0x1000,%eax
  80339a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a0:	c1 e8 0c             	shr    $0xc,%eax
  8033a3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8033a6:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	75 0a                	jne    8033b9 <smalloc+0x62>
		return NULL;
  8033af:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b4:	e9 fc 00 00 00       	jmp    8034b5 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8033b9:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8033be:	85 c0                	test   %eax,%eax
  8033c0:	74 0f                	je     8033d1 <smalloc+0x7a>
  8033c2:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8033c8:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8033cd:	39 c2                	cmp    %eax,%edx
  8033cf:	73 0a                	jae    8033db <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8033d1:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8033d6:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8033db:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8033e0:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8033e5:	29 c2                	sub    %eax,%edx
  8033e7:	89 d0                	mov    %edx,%eax
  8033e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8033ec:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8033f2:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  8033f7:	29 c2                	sub    %eax,%edx
  8033f9:	89 d0                	mov    %edx,%eax
  8033fb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803401:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803404:	77 13                	ja     803419 <smalloc+0xc2>
  803406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803409:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80340c:	77 0b                	ja     803419 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80340e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803411:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803414:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803417:	73 0a                	jae    803423 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  803419:	b8 00 00 00 00       	mov    $0x0,%eax
  80341e:	e9 92 00 00 00       	jmp    8034b5 <smalloc+0x15e>
	}

	void *va = NULL;
  803423:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80342a:	a1 44 f2 81 00       	mov    0x81f244,%eax
  80342f:	83 f8 05             	cmp    $0x5,%eax
  803432:	75 11                	jne    803445 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  803434:	83 ec 0c             	sub    $0xc,%esp
  803437:	ff 75 f4             	pushl  -0xc(%ebp)
  80343a:	e8 08 f7 ff ff       	call   802b47 <alloc_pages_custom_fit>
  80343f:	83 c4 10             	add    $0x10,%esp
  803442:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  803445:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803449:	75 27                	jne    803472 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80344b:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  803452:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803455:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803458:	89 c2                	mov    %eax,%edx
  80345a:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80345f:	39 c2                	cmp    %eax,%edx
  803461:	73 07                	jae    80346a <smalloc+0x113>
			return NULL;}
  803463:	b8 00 00 00 00       	mov    $0x0,%eax
  803468:	eb 4b                	jmp    8034b5 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80346a:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80346f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  803472:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  803476:	ff 75 f0             	pushl  -0x10(%ebp)
  803479:	50                   	push   %eax
  80347a:	ff 75 0c             	pushl  0xc(%ebp)
  80347d:	ff 75 08             	pushl  0x8(%ebp)
  803480:	e8 cb 03 00 00       	call   803850 <sys_create_shared_object>
  803485:	83 c4 10             	add    $0x10,%esp
  803488:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80348b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80348f:	79 07                	jns    803498 <smalloc+0x141>
		return NULL;
  803491:	b8 00 00 00 00       	mov    $0x0,%eax
  803496:	eb 1d                	jmp    8034b5 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  803498:	a1 50 f2 81 00       	mov    0x81f250,%eax
  80349d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8034a0:	75 10                	jne    8034b2 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8034a2:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  8034a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ab:	01 d0                	add    %edx,%eax
  8034ad:	a3 50 f2 81 00       	mov    %eax,0x81f250
	}

	return va;
  8034b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    

008034b7 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
  8034ba:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8034bd:	e8 d4 fa ff ff       	call   802f96 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8034c2:	83 ec 08             	sub    $0x8,%esp
  8034c5:	ff 75 0c             	pushl  0xc(%ebp)
  8034c8:	ff 75 08             	pushl  0x8(%ebp)
  8034cb:	e8 aa 03 00 00       	call   80387a <sys_size_of_shared_object>
  8034d0:	83 c4 10             	add    $0x10,%esp
  8034d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8034d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034da:	7f 0a                	jg     8034e6 <sget+0x2f>
		return NULL;
  8034dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e1:	e9 32 01 00 00       	jmp    803618 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8034e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8034ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ef:	25 ff 0f 00 00       	and    $0xfff,%eax
  8034f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8034f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034fb:	74 0e                	je     80350b <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8034fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803500:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803503:	05 00 10 00 00       	add    $0x1000,%eax
  803508:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80350b:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803510:	85 c0                	test   %eax,%eax
  803512:	75 0a                	jne    80351e <sget+0x67>
		return NULL;
  803514:	b8 00 00 00 00       	mov    $0x0,%eax
  803519:	e9 fa 00 00 00       	jmp    803618 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80351e:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803523:	85 c0                	test   %eax,%eax
  803525:	74 0f                	je     803536 <sget+0x7f>
  803527:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80352d:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803532:	39 c2                	cmp    %eax,%edx
  803534:	73 0a                	jae    803540 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  803536:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80353b:	a3 50 f2 81 00       	mov    %eax,0x81f250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803540:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  803545:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80354a:	29 c2                	sub    %eax,%edx
  80354c:	89 d0                	mov    %edx,%eax
  80354e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803551:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803557:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  80355c:	29 c2                	sub    %eax,%edx
  80355e:	89 d0                	mov    %edx,%eax
  803560:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803569:	77 13                	ja     80357e <sget+0xc7>
  80356b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803571:	77 0b                	ja     80357e <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  803573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803576:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  803579:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80357c:	73 0a                	jae    803588 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80357e:	b8 00 00 00 00       	mov    $0x0,%eax
  803583:	e9 90 00 00 00       	jmp    803618 <sget+0x161>

	void *va = NULL;
  803588:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80358f:	a1 44 f2 81 00       	mov    0x81f244,%eax
  803594:	83 f8 05             	cmp    $0x5,%eax
  803597:	75 11                	jne    8035aa <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  803599:	83 ec 0c             	sub    $0xc,%esp
  80359c:	ff 75 f4             	pushl  -0xc(%ebp)
  80359f:	e8 a3 f5 ff ff       	call   802b47 <alloc_pages_custom_fit>
  8035a4:	83 c4 10             	add    $0x10,%esp
  8035a7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8035aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ae:	75 27                	jne    8035d7 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8035b0:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8035b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ba:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8035bd:	89 c2                	mov    %eax,%edx
  8035bf:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8035c4:	39 c2                	cmp    %eax,%edx
  8035c6:	73 07                	jae    8035cf <sget+0x118>
			return NULL;
  8035c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cd:	eb 49                	jmp    803618 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8035cf:	a1 50 f2 81 00       	mov    0x81f250,%eax
  8035d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	ff 75 f0             	pushl  -0x10(%ebp)
  8035dd:	ff 75 0c             	pushl  0xc(%ebp)
  8035e0:	ff 75 08             	pushl  0x8(%ebp)
  8035e3:	e8 af 02 00 00       	call   803897 <sys_get_shared_object>
  8035e8:	83 c4 10             	add    $0x10,%esp
  8035eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8035ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8035f2:	79 07                	jns    8035fb <sget+0x144>
		return NULL;
  8035f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f9:	eb 1d                	jmp    803618 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8035fb:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803600:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803603:	75 10                	jne    803615 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  803605:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80360b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360e:	01 d0                	add    %edx,%eax
  803610:	a3 50 f2 81 00       	mov    %eax,0x81f250

	return va;
  803615:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  803618:	c9                   	leave  
  803619:	c3                   	ret    

0080361a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80361a:	55                   	push   %ebp
  80361b:	89 e5                	mov    %esp,%ebp
  80361d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803620:	e8 71 f9 ff ff       	call   802f96 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	68 54 60 80 00       	push   $0x806054
  80362d:	68 19 02 00 00       	push   $0x219
  803632:	68 31 5c 80 00       	push   $0x805c31
  803637:	e8 42 e1 ff ff       	call   80177e <_panic>

0080363c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
  80363f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803642:	83 ec 04             	sub    $0x4,%esp
  803645:	68 7c 60 80 00       	push   $0x80607c
  80364a:	68 2b 02 00 00       	push   $0x22b
  80364f:	68 31 5c 80 00       	push   $0x805c31
  803654:	e8 25 e1 ff ff       	call   80177e <_panic>

00803659 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803659:	55                   	push   %ebp
  80365a:	89 e5                	mov    %esp,%ebp
  80365c:	57                   	push   %edi
  80365d:	56                   	push   %esi
  80365e:	53                   	push   %ebx
  80365f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	8b 55 0c             	mov    0xc(%ebp),%edx
  803668:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80366b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80366e:	8b 7d 18             	mov    0x18(%ebp),%edi
  803671:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803674:	cd 30                	int    $0x30
  803676:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80367c:	83 c4 10             	add    $0x10,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    

00803684 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803684:	55                   	push   %ebp
  803685:	89 e5                	mov    %esp,%ebp
  803687:	83 ec 04             	sub    $0x4,%esp
  80368a:	8b 45 10             	mov    0x10(%ebp),%eax
  80368d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803690:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803693:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	6a 00                	push   $0x0
  80369c:	51                   	push   %ecx
  80369d:	52                   	push   %edx
  80369e:	ff 75 0c             	pushl  0xc(%ebp)
  8036a1:	50                   	push   %eax
  8036a2:	6a 00                	push   $0x0
  8036a4:	e8 b0 ff ff ff       	call   803659 <syscall>
  8036a9:	83 c4 18             	add    $0x18,%esp
}
  8036ac:	90                   	nop
  8036ad:	c9                   	leave  
  8036ae:	c3                   	ret    

008036af <sys_cgetc>:

int
sys_cgetc(void)
{
  8036af:	55                   	push   %ebp
  8036b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8036b2:	6a 00                	push   $0x0
  8036b4:	6a 00                	push   $0x0
  8036b6:	6a 00                	push   $0x0
  8036b8:	6a 00                	push   $0x0
  8036ba:	6a 00                	push   $0x0
  8036bc:	6a 02                	push   $0x2
  8036be:	e8 96 ff ff ff       	call   803659 <syscall>
  8036c3:	83 c4 18             	add    $0x18,%esp
}
  8036c6:	c9                   	leave  
  8036c7:	c3                   	ret    

008036c8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8036c8:	55                   	push   %ebp
  8036c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8036cb:	6a 00                	push   $0x0
  8036cd:	6a 00                	push   $0x0
  8036cf:	6a 00                	push   $0x0
  8036d1:	6a 00                	push   $0x0
  8036d3:	6a 00                	push   $0x0
  8036d5:	6a 03                	push   $0x3
  8036d7:	e8 7d ff ff ff       	call   803659 <syscall>
  8036dc:	83 c4 18             	add    $0x18,%esp
}
  8036df:	90                   	nop
  8036e0:	c9                   	leave  
  8036e1:	c3                   	ret    

008036e2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8036e2:	55                   	push   %ebp
  8036e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8036e5:	6a 00                	push   $0x0
  8036e7:	6a 00                	push   $0x0
  8036e9:	6a 00                	push   $0x0
  8036eb:	6a 00                	push   $0x0
  8036ed:	6a 00                	push   $0x0
  8036ef:	6a 04                	push   $0x4
  8036f1:	e8 63 ff ff ff       	call   803659 <syscall>
  8036f6:	83 c4 18             	add    $0x18,%esp
}
  8036f9:	90                   	nop
  8036fa:	c9                   	leave  
  8036fb:	c3                   	ret    

008036fc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8036fc:	55                   	push   %ebp
  8036fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8036ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	6a 00                	push   $0x0
  803707:	6a 00                	push   $0x0
  803709:	6a 00                	push   $0x0
  80370b:	52                   	push   %edx
  80370c:	50                   	push   %eax
  80370d:	6a 08                	push   $0x8
  80370f:	e8 45 ff ff ff       	call   803659 <syscall>
  803714:	83 c4 18             	add    $0x18,%esp
}
  803717:	c9                   	leave  
  803718:	c3                   	ret    

00803719 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803719:	55                   	push   %ebp
  80371a:	89 e5                	mov    %esp,%ebp
  80371c:	56                   	push   %esi
  80371d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80371e:	8b 75 18             	mov    0x18(%ebp),%esi
  803721:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803724:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	56                   	push   %esi
  80372e:	53                   	push   %ebx
  80372f:	51                   	push   %ecx
  803730:	52                   	push   %edx
  803731:	50                   	push   %eax
  803732:	6a 09                	push   $0x9
  803734:	e8 20 ff ff ff       	call   803659 <syscall>
  803739:	83 c4 18             	add    $0x18,%esp
}
  80373c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80373f:	5b                   	pop    %ebx
  803740:	5e                   	pop    %esi
  803741:	5d                   	pop    %ebp
  803742:	c3                   	ret    

00803743 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803743:	55                   	push   %ebp
  803744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803746:	6a 00                	push   $0x0
  803748:	6a 00                	push   $0x0
  80374a:	6a 00                	push   $0x0
  80374c:	6a 00                	push   $0x0
  80374e:	ff 75 08             	pushl  0x8(%ebp)
  803751:	6a 0a                	push   $0xa
  803753:	e8 01 ff ff ff       	call   803659 <syscall>
  803758:	83 c4 18             	add    $0x18,%esp
}
  80375b:	c9                   	leave  
  80375c:	c3                   	ret    

0080375d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80375d:	55                   	push   %ebp
  80375e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803760:	6a 00                	push   $0x0
  803762:	6a 00                	push   $0x0
  803764:	6a 00                	push   $0x0
  803766:	ff 75 0c             	pushl  0xc(%ebp)
  803769:	ff 75 08             	pushl  0x8(%ebp)
  80376c:	6a 0b                	push   $0xb
  80376e:	e8 e6 fe ff ff       	call   803659 <syscall>
  803773:	83 c4 18             	add    $0x18,%esp
}
  803776:	c9                   	leave  
  803777:	c3                   	ret    

00803778 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803778:	55                   	push   %ebp
  803779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80377b:	6a 00                	push   $0x0
  80377d:	6a 00                	push   $0x0
  80377f:	6a 00                	push   $0x0
  803781:	6a 00                	push   $0x0
  803783:	6a 00                	push   $0x0
  803785:	6a 0c                	push   $0xc
  803787:	e8 cd fe ff ff       	call   803659 <syscall>
  80378c:	83 c4 18             	add    $0x18,%esp
}
  80378f:	c9                   	leave  
  803790:	c3                   	ret    

00803791 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803791:	55                   	push   %ebp
  803792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803794:	6a 00                	push   $0x0
  803796:	6a 00                	push   $0x0
  803798:	6a 00                	push   $0x0
  80379a:	6a 00                	push   $0x0
  80379c:	6a 00                	push   $0x0
  80379e:	6a 0d                	push   $0xd
  8037a0:	e8 b4 fe ff ff       	call   803659 <syscall>
  8037a5:	83 c4 18             	add    $0x18,%esp
}
  8037a8:	c9                   	leave  
  8037a9:	c3                   	ret    

008037aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8037aa:	55                   	push   %ebp
  8037ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8037ad:	6a 00                	push   $0x0
  8037af:	6a 00                	push   $0x0
  8037b1:	6a 00                	push   $0x0
  8037b3:	6a 00                	push   $0x0
  8037b5:	6a 00                	push   $0x0
  8037b7:	6a 0e                	push   $0xe
  8037b9:	e8 9b fe ff ff       	call   803659 <syscall>
  8037be:	83 c4 18             	add    $0x18,%esp
}
  8037c1:	c9                   	leave  
  8037c2:	c3                   	ret    

008037c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8037c3:	55                   	push   %ebp
  8037c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 00                	push   $0x0
  8037cc:	6a 00                	push   $0x0
  8037ce:	6a 00                	push   $0x0
  8037d0:	6a 0f                	push   $0xf
  8037d2:	e8 82 fe ff ff       	call   803659 <syscall>
  8037d7:	83 c4 18             	add    $0x18,%esp
}
  8037da:	c9                   	leave  
  8037db:	c3                   	ret    

008037dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8037dc:	55                   	push   %ebp
  8037dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8037df:	6a 00                	push   $0x0
  8037e1:	6a 00                	push   $0x0
  8037e3:	6a 00                	push   $0x0
  8037e5:	6a 00                	push   $0x0
  8037e7:	ff 75 08             	pushl  0x8(%ebp)
  8037ea:	6a 10                	push   $0x10
  8037ec:	e8 68 fe ff ff       	call   803659 <syscall>
  8037f1:	83 c4 18             	add    $0x18,%esp
}
  8037f4:	c9                   	leave  
  8037f5:	c3                   	ret    

008037f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8037f6:	55                   	push   %ebp
  8037f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8037f9:	6a 00                	push   $0x0
  8037fb:	6a 00                	push   $0x0
  8037fd:	6a 00                	push   $0x0
  8037ff:	6a 00                	push   $0x0
  803801:	6a 00                	push   $0x0
  803803:	6a 11                	push   $0x11
  803805:	e8 4f fe ff ff       	call   803659 <syscall>
  80380a:	83 c4 18             	add    $0x18,%esp
}
  80380d:	90                   	nop
  80380e:	c9                   	leave  
  80380f:	c3                   	ret    

00803810 <sys_cputc>:

void
sys_cputc(const char c)
{
  803810:	55                   	push   %ebp
  803811:	89 e5                	mov    %esp,%ebp
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80381c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803820:	6a 00                	push   $0x0
  803822:	6a 00                	push   $0x0
  803824:	6a 00                	push   $0x0
  803826:	6a 00                	push   $0x0
  803828:	50                   	push   %eax
  803829:	6a 01                	push   $0x1
  80382b:	e8 29 fe ff ff       	call   803659 <syscall>
  803830:	83 c4 18             	add    $0x18,%esp
}
  803833:	90                   	nop
  803834:	c9                   	leave  
  803835:	c3                   	ret    

00803836 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803836:	55                   	push   %ebp
  803837:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803839:	6a 00                	push   $0x0
  80383b:	6a 00                	push   $0x0
  80383d:	6a 00                	push   $0x0
  80383f:	6a 00                	push   $0x0
  803841:	6a 00                	push   $0x0
  803843:	6a 14                	push   $0x14
  803845:	e8 0f fe ff ff       	call   803659 <syscall>
  80384a:	83 c4 18             	add    $0x18,%esp
}
  80384d:	90                   	nop
  80384e:	c9                   	leave  
  80384f:	c3                   	ret    

00803850 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803850:	55                   	push   %ebp
  803851:	89 e5                	mov    %esp,%ebp
  803853:	83 ec 04             	sub    $0x4,%esp
  803856:	8b 45 10             	mov    0x10(%ebp),%eax
  803859:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80385c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80385f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	6a 00                	push   $0x0
  803868:	51                   	push   %ecx
  803869:	52                   	push   %edx
  80386a:	ff 75 0c             	pushl  0xc(%ebp)
  80386d:	50                   	push   %eax
  80386e:	6a 15                	push   $0x15
  803870:	e8 e4 fd ff ff       	call   803659 <syscall>
  803875:	83 c4 18             	add    $0x18,%esp
}
  803878:	c9                   	leave  
  803879:	c3                   	ret    

0080387a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80387a:	55                   	push   %ebp
  80387b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80387d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	6a 00                	push   $0x0
  803885:	6a 00                	push   $0x0
  803887:	6a 00                	push   $0x0
  803889:	52                   	push   %edx
  80388a:	50                   	push   %eax
  80388b:	6a 16                	push   $0x16
  80388d:	e8 c7 fd ff ff       	call   803659 <syscall>
  803892:	83 c4 18             	add    $0x18,%esp
}
  803895:	c9                   	leave  
  803896:	c3                   	ret    

00803897 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803897:	55                   	push   %ebp
  803898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80389a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80389d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	6a 00                	push   $0x0
  8038a5:	6a 00                	push   $0x0
  8038a7:	51                   	push   %ecx
  8038a8:	52                   	push   %edx
  8038a9:	50                   	push   %eax
  8038aa:	6a 17                	push   $0x17
  8038ac:	e8 a8 fd ff ff       	call   803659 <syscall>
  8038b1:	83 c4 18             	add    $0x18,%esp
}
  8038b4:	c9                   	leave  
  8038b5:	c3                   	ret    

008038b6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8038b6:	55                   	push   %ebp
  8038b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8038b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bf:	6a 00                	push   $0x0
  8038c1:	6a 00                	push   $0x0
  8038c3:	6a 00                	push   $0x0
  8038c5:	52                   	push   %edx
  8038c6:	50                   	push   %eax
  8038c7:	6a 18                	push   $0x18
  8038c9:	e8 8b fd ff ff       	call   803659 <syscall>
  8038ce:	83 c4 18             	add    $0x18,%esp
}
  8038d1:	c9                   	leave  
  8038d2:	c3                   	ret    

008038d3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8038d3:	55                   	push   %ebp
  8038d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	6a 00                	push   $0x0
  8038db:	ff 75 14             	pushl  0x14(%ebp)
  8038de:	ff 75 10             	pushl  0x10(%ebp)
  8038e1:	ff 75 0c             	pushl  0xc(%ebp)
  8038e4:	50                   	push   %eax
  8038e5:	6a 19                	push   $0x19
  8038e7:	e8 6d fd ff ff       	call   803659 <syscall>
  8038ec:	83 c4 18             	add    $0x18,%esp
}
  8038ef:	c9                   	leave  
  8038f0:	c3                   	ret    

008038f1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8038f1:	55                   	push   %ebp
  8038f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8038f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f7:	6a 00                	push   $0x0
  8038f9:	6a 00                	push   $0x0
  8038fb:	6a 00                	push   $0x0
  8038fd:	6a 00                	push   $0x0
  8038ff:	50                   	push   %eax
  803900:	6a 1a                	push   $0x1a
  803902:	e8 52 fd ff ff       	call   803659 <syscall>
  803907:	83 c4 18             	add    $0x18,%esp
}
  80390a:	90                   	nop
  80390b:	c9                   	leave  
  80390c:	c3                   	ret    

0080390d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80390d:	55                   	push   %ebp
  80390e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	6a 00                	push   $0x0
  803915:	6a 00                	push   $0x0
  803917:	6a 00                	push   $0x0
  803919:	6a 00                	push   $0x0
  80391b:	50                   	push   %eax
  80391c:	6a 1b                	push   $0x1b
  80391e:	e8 36 fd ff ff       	call   803659 <syscall>
  803923:	83 c4 18             	add    $0x18,%esp
}
  803926:	c9                   	leave  
  803927:	c3                   	ret    

00803928 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803928:	55                   	push   %ebp
  803929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80392b:	6a 00                	push   $0x0
  80392d:	6a 00                	push   $0x0
  80392f:	6a 00                	push   $0x0
  803931:	6a 00                	push   $0x0
  803933:	6a 00                	push   $0x0
  803935:	6a 05                	push   $0x5
  803937:	e8 1d fd ff ff       	call   803659 <syscall>
  80393c:	83 c4 18             	add    $0x18,%esp
}
  80393f:	c9                   	leave  
  803940:	c3                   	ret    

00803941 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803941:	55                   	push   %ebp
  803942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803944:	6a 00                	push   $0x0
  803946:	6a 00                	push   $0x0
  803948:	6a 00                	push   $0x0
  80394a:	6a 00                	push   $0x0
  80394c:	6a 00                	push   $0x0
  80394e:	6a 06                	push   $0x6
  803950:	e8 04 fd ff ff       	call   803659 <syscall>
  803955:	83 c4 18             	add    $0x18,%esp
}
  803958:	c9                   	leave  
  803959:	c3                   	ret    

0080395a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80395a:	55                   	push   %ebp
  80395b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80395d:	6a 00                	push   $0x0
  80395f:	6a 00                	push   $0x0
  803961:	6a 00                	push   $0x0
  803963:	6a 00                	push   $0x0
  803965:	6a 00                	push   $0x0
  803967:	6a 07                	push   $0x7
  803969:	e8 eb fc ff ff       	call   803659 <syscall>
  80396e:	83 c4 18             	add    $0x18,%esp
}
  803971:	c9                   	leave  
  803972:	c3                   	ret    

00803973 <sys_exit_env>:


void sys_exit_env(void)
{
  803973:	55                   	push   %ebp
  803974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803976:	6a 00                	push   $0x0
  803978:	6a 00                	push   $0x0
  80397a:	6a 00                	push   $0x0
  80397c:	6a 00                	push   $0x0
  80397e:	6a 00                	push   $0x0
  803980:	6a 1c                	push   $0x1c
  803982:	e8 d2 fc ff ff       	call   803659 <syscall>
  803987:	83 c4 18             	add    $0x18,%esp
}
  80398a:	90                   	nop
  80398b:	c9                   	leave  
  80398c:	c3                   	ret    

0080398d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80398d:	55                   	push   %ebp
  80398e:	89 e5                	mov    %esp,%ebp
  803990:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803993:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803996:	8d 50 04             	lea    0x4(%eax),%edx
  803999:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80399c:	6a 00                	push   $0x0
  80399e:	6a 00                	push   $0x0
  8039a0:	6a 00                	push   $0x0
  8039a2:	52                   	push   %edx
  8039a3:	50                   	push   %eax
  8039a4:	6a 1d                	push   $0x1d
  8039a6:	e8 ae fc ff ff       	call   803659 <syscall>
  8039ab:	83 c4 18             	add    $0x18,%esp
	return result;
  8039ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8039b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8039b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8039b7:	89 01                	mov    %eax,(%ecx)
  8039b9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8039bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bf:	c9                   	leave  
  8039c0:	c2 04 00             	ret    $0x4

008039c3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8039c3:	55                   	push   %ebp
  8039c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8039c6:	6a 00                	push   $0x0
  8039c8:	6a 00                	push   $0x0
  8039ca:	ff 75 10             	pushl  0x10(%ebp)
  8039cd:	ff 75 0c             	pushl  0xc(%ebp)
  8039d0:	ff 75 08             	pushl  0x8(%ebp)
  8039d3:	6a 13                	push   $0x13
  8039d5:	e8 7f fc ff ff       	call   803659 <syscall>
  8039da:	83 c4 18             	add    $0x18,%esp
	return ;
  8039dd:	90                   	nop
}
  8039de:	c9                   	leave  
  8039df:	c3                   	ret    

008039e0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8039e0:	55                   	push   %ebp
  8039e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8039e3:	6a 00                	push   $0x0
  8039e5:	6a 00                	push   $0x0
  8039e7:	6a 00                	push   $0x0
  8039e9:	6a 00                	push   $0x0
  8039eb:	6a 00                	push   $0x0
  8039ed:	6a 1e                	push   $0x1e
  8039ef:	e8 65 fc ff ff       	call   803659 <syscall>
  8039f4:	83 c4 18             	add    $0x18,%esp
}
  8039f7:	c9                   	leave  
  8039f8:	c3                   	ret    

008039f9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8039f9:	55                   	push   %ebp
  8039fa:	89 e5                	mov    %esp,%ebp
  8039fc:	83 ec 04             	sub    $0x4,%esp
  8039ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803a02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803a05:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803a09:	6a 00                	push   $0x0
  803a0b:	6a 00                	push   $0x0
  803a0d:	6a 00                	push   $0x0
  803a0f:	6a 00                	push   $0x0
  803a11:	50                   	push   %eax
  803a12:	6a 1f                	push   $0x1f
  803a14:	e8 40 fc ff ff       	call   803659 <syscall>
  803a19:	83 c4 18             	add    $0x18,%esp
	return ;
  803a1c:	90                   	nop
}
  803a1d:	c9                   	leave  
  803a1e:	c3                   	ret    

00803a1f <rsttst>:
void rsttst()
{
  803a1f:	55                   	push   %ebp
  803a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803a22:	6a 00                	push   $0x0
  803a24:	6a 00                	push   $0x0
  803a26:	6a 00                	push   $0x0
  803a28:	6a 00                	push   $0x0
  803a2a:	6a 00                	push   $0x0
  803a2c:	6a 21                	push   $0x21
  803a2e:	e8 26 fc ff ff       	call   803659 <syscall>
  803a33:	83 c4 18             	add    $0x18,%esp
	return ;
  803a36:	90                   	nop
}
  803a37:	c9                   	leave  
  803a38:	c3                   	ret    

00803a39 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803a39:	55                   	push   %ebp
  803a3a:	89 e5                	mov    %esp,%ebp
  803a3c:	83 ec 04             	sub    $0x4,%esp
  803a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  803a42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803a45:	8b 55 18             	mov    0x18(%ebp),%edx
  803a48:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803a4c:	52                   	push   %edx
  803a4d:	50                   	push   %eax
  803a4e:	ff 75 10             	pushl  0x10(%ebp)
  803a51:	ff 75 0c             	pushl  0xc(%ebp)
  803a54:	ff 75 08             	pushl  0x8(%ebp)
  803a57:	6a 20                	push   $0x20
  803a59:	e8 fb fb ff ff       	call   803659 <syscall>
  803a5e:	83 c4 18             	add    $0x18,%esp
	return ;
  803a61:	90                   	nop
}
  803a62:	c9                   	leave  
  803a63:	c3                   	ret    

00803a64 <chktst>:
void chktst(uint32 n)
{
  803a64:	55                   	push   %ebp
  803a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803a67:	6a 00                	push   $0x0
  803a69:	6a 00                	push   $0x0
  803a6b:	6a 00                	push   $0x0
  803a6d:	6a 00                	push   $0x0
  803a6f:	ff 75 08             	pushl  0x8(%ebp)
  803a72:	6a 22                	push   $0x22
  803a74:	e8 e0 fb ff ff       	call   803659 <syscall>
  803a79:	83 c4 18             	add    $0x18,%esp
	return ;
  803a7c:	90                   	nop
}
  803a7d:	c9                   	leave  
  803a7e:	c3                   	ret    

00803a7f <inctst>:

void inctst()
{
  803a7f:	55                   	push   %ebp
  803a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803a82:	6a 00                	push   $0x0
  803a84:	6a 00                	push   $0x0
  803a86:	6a 00                	push   $0x0
  803a88:	6a 00                	push   $0x0
  803a8a:	6a 00                	push   $0x0
  803a8c:	6a 23                	push   $0x23
  803a8e:	e8 c6 fb ff ff       	call   803659 <syscall>
  803a93:	83 c4 18             	add    $0x18,%esp
	return ;
  803a96:	90                   	nop
}
  803a97:	c9                   	leave  
  803a98:	c3                   	ret    

00803a99 <gettst>:
uint32 gettst()
{
  803a99:	55                   	push   %ebp
  803a9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803a9c:	6a 00                	push   $0x0
  803a9e:	6a 00                	push   $0x0
  803aa0:	6a 00                	push   $0x0
  803aa2:	6a 00                	push   $0x0
  803aa4:	6a 00                	push   $0x0
  803aa6:	6a 24                	push   $0x24
  803aa8:	e8 ac fb ff ff       	call   803659 <syscall>
  803aad:	83 c4 18             	add    $0x18,%esp
}
  803ab0:	c9                   	leave  
  803ab1:	c3                   	ret    

00803ab2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803ab2:	55                   	push   %ebp
  803ab3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803ab5:	6a 00                	push   $0x0
  803ab7:	6a 00                	push   $0x0
  803ab9:	6a 00                	push   $0x0
  803abb:	6a 00                	push   $0x0
  803abd:	6a 00                	push   $0x0
  803abf:	6a 25                	push   $0x25
  803ac1:	e8 93 fb ff ff       	call   803659 <syscall>
  803ac6:	83 c4 18             	add    $0x18,%esp
  803ac9:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  803ace:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  803ad3:	c9                   	leave  
  803ad4:	c3                   	ret    

00803ad5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803ad5:	55                   	push   %ebp
  803ad6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  803adb:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803ae0:	6a 00                	push   $0x0
  803ae2:	6a 00                	push   $0x0
  803ae4:	6a 00                	push   $0x0
  803ae6:	6a 00                	push   $0x0
  803ae8:	ff 75 08             	pushl  0x8(%ebp)
  803aeb:	6a 26                	push   $0x26
  803aed:	e8 67 fb ff ff       	call   803659 <syscall>
  803af2:	83 c4 18             	add    $0x18,%esp
	return ;
  803af5:	90                   	nop
}
  803af6:	c9                   	leave  
  803af7:	c3                   	ret    

00803af8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803af8:	55                   	push   %ebp
  803af9:	89 e5                	mov    %esp,%ebp
  803afb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803afc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b05:	8b 45 08             	mov    0x8(%ebp),%eax
  803b08:	6a 00                	push   $0x0
  803b0a:	53                   	push   %ebx
  803b0b:	51                   	push   %ecx
  803b0c:	52                   	push   %edx
  803b0d:	50                   	push   %eax
  803b0e:	6a 27                	push   $0x27
  803b10:	e8 44 fb ff ff       	call   803659 <syscall>
  803b15:	83 c4 18             	add    $0x18,%esp
}
  803b18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b1b:	c9                   	leave  
  803b1c:	c3                   	ret    

00803b1d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803b1d:	55                   	push   %ebp
  803b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	6a 00                	push   $0x0
  803b28:	6a 00                	push   $0x0
  803b2a:	6a 00                	push   $0x0
  803b2c:	52                   	push   %edx
  803b2d:	50                   	push   %eax
  803b2e:	6a 28                	push   $0x28
  803b30:	e8 24 fb ff ff       	call   803659 <syscall>
  803b35:	83 c4 18             	add    $0x18,%esp
}
  803b38:	c9                   	leave  
  803b39:	c3                   	ret    

00803b3a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803b3a:	55                   	push   %ebp
  803b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803b3d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b43:	8b 45 08             	mov    0x8(%ebp),%eax
  803b46:	6a 00                	push   $0x0
  803b48:	51                   	push   %ecx
  803b49:	ff 75 10             	pushl  0x10(%ebp)
  803b4c:	52                   	push   %edx
  803b4d:	50                   	push   %eax
  803b4e:	6a 29                	push   $0x29
  803b50:	e8 04 fb ff ff       	call   803659 <syscall>
  803b55:	83 c4 18             	add    $0x18,%esp
}
  803b58:	c9                   	leave  
  803b59:	c3                   	ret    

00803b5a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803b5a:	55                   	push   %ebp
  803b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803b5d:	6a 00                	push   $0x0
  803b5f:	6a 00                	push   $0x0
  803b61:	ff 75 10             	pushl  0x10(%ebp)
  803b64:	ff 75 0c             	pushl  0xc(%ebp)
  803b67:	ff 75 08             	pushl  0x8(%ebp)
  803b6a:	6a 12                	push   $0x12
  803b6c:	e8 e8 fa ff ff       	call   803659 <syscall>
  803b71:	83 c4 18             	add    $0x18,%esp
	return ;
  803b74:	90                   	nop
}
  803b75:	c9                   	leave  
  803b76:	c3                   	ret    

00803b77 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803b77:	55                   	push   %ebp
  803b78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b80:	6a 00                	push   $0x0
  803b82:	6a 00                	push   $0x0
  803b84:	6a 00                	push   $0x0
  803b86:	52                   	push   %edx
  803b87:	50                   	push   %eax
  803b88:	6a 2a                	push   $0x2a
  803b8a:	e8 ca fa ff ff       	call   803659 <syscall>
  803b8f:	83 c4 18             	add    $0x18,%esp
	return;
  803b92:	90                   	nop
}
  803b93:	c9                   	leave  
  803b94:	c3                   	ret    

00803b95 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803b95:	55                   	push   %ebp
  803b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803b98:	6a 00                	push   $0x0
  803b9a:	6a 00                	push   $0x0
  803b9c:	6a 00                	push   $0x0
  803b9e:	6a 00                	push   $0x0
  803ba0:	6a 00                	push   $0x0
  803ba2:	6a 2b                	push   $0x2b
  803ba4:	e8 b0 fa ff ff       	call   803659 <syscall>
  803ba9:	83 c4 18             	add    $0x18,%esp
}
  803bac:	c9                   	leave  
  803bad:	c3                   	ret    

00803bae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803bae:	55                   	push   %ebp
  803baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803bb1:	6a 00                	push   $0x0
  803bb3:	6a 00                	push   $0x0
  803bb5:	6a 00                	push   $0x0
  803bb7:	ff 75 0c             	pushl  0xc(%ebp)
  803bba:	ff 75 08             	pushl  0x8(%ebp)
  803bbd:	6a 2d                	push   $0x2d
  803bbf:	e8 95 fa ff ff       	call   803659 <syscall>
  803bc4:	83 c4 18             	add    $0x18,%esp
	return;
  803bc7:	90                   	nop
}
  803bc8:	c9                   	leave  
  803bc9:	c3                   	ret    

00803bca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803bca:	55                   	push   %ebp
  803bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803bcd:	6a 00                	push   $0x0
  803bcf:	6a 00                	push   $0x0
  803bd1:	6a 00                	push   $0x0
  803bd3:	ff 75 0c             	pushl  0xc(%ebp)
  803bd6:	ff 75 08             	pushl  0x8(%ebp)
  803bd9:	6a 2c                	push   $0x2c
  803bdb:	e8 79 fa ff ff       	call   803659 <syscall>
  803be0:	83 c4 18             	add    $0x18,%esp
	return ;
  803be3:	90                   	nop
}
  803be4:	c9                   	leave  
  803be5:	c3                   	ret    

00803be6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803be6:	55                   	push   %ebp
  803be7:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bec:	8b 45 08             	mov    0x8(%ebp),%eax
  803bef:	6a 00                	push   $0x0
  803bf1:	6a 00                	push   $0x0
  803bf3:	6a 00                	push   $0x0
  803bf5:	52                   	push   %edx
  803bf6:	50                   	push   %eax
  803bf7:	6a 2e                	push   $0x2e
  803bf9:	e8 5b fa ff ff       	call   803659 <syscall>
  803bfe:	83 c4 18             	add    $0x18,%esp
	return ;
  803c01:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803c02:	c9                   	leave  
  803c03:	c3                   	ret    

00803c04 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803c04:	55                   	push   %ebp
  803c05:	89 e5                	mov    %esp,%ebp
  803c07:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803c0a:	81 7d 08 40 72 80 00 	cmpl   $0x807240,0x8(%ebp)
  803c11:	72 09                	jb     803c1c <to_page_va+0x18>
  803c13:	81 7d 08 40 f2 81 00 	cmpl   $0x81f240,0x8(%ebp)
  803c1a:	72 14                	jb     803c30 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803c1c:	83 ec 04             	sub    $0x4,%esp
  803c1f:	68 a0 60 80 00       	push   $0x8060a0
  803c24:	6a 15                	push   $0x15
  803c26:	68 cb 60 80 00       	push   $0x8060cb
  803c2b:	e8 4e db ff ff       	call   80177e <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803c30:	8b 45 08             	mov    0x8(%ebp),%eax
  803c33:	ba 40 72 80 00       	mov    $0x807240,%edx
  803c38:	29 d0                	sub    %edx,%eax
  803c3a:	c1 f8 02             	sar    $0x2,%eax
  803c3d:	89 c2                	mov    %eax,%edx
  803c3f:	89 d0                	mov    %edx,%eax
  803c41:	c1 e0 02             	shl    $0x2,%eax
  803c44:	01 d0                	add    %edx,%eax
  803c46:	c1 e0 02             	shl    $0x2,%eax
  803c49:	01 d0                	add    %edx,%eax
  803c4b:	c1 e0 02             	shl    $0x2,%eax
  803c4e:	01 d0                	add    %edx,%eax
  803c50:	89 c1                	mov    %eax,%ecx
  803c52:	c1 e1 08             	shl    $0x8,%ecx
  803c55:	01 c8                	add    %ecx,%eax
  803c57:	89 c1                	mov    %eax,%ecx
  803c59:	c1 e1 10             	shl    $0x10,%ecx
  803c5c:	01 c8                	add    %ecx,%eax
  803c5e:	01 c0                	add    %eax,%eax
  803c60:	01 d0                	add    %edx,%eax
  803c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c68:	c1 e0 0c             	shl    $0xc,%eax
  803c6b:	89 c2                	mov    %eax,%edx
  803c6d:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803c72:	01 d0                	add    %edx,%eax
}
  803c74:	c9                   	leave  
  803c75:	c3                   	ret    

00803c76 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803c76:	55                   	push   %ebp
  803c77:	89 e5                	mov    %esp,%ebp
  803c79:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803c7c:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803c81:	8b 55 08             	mov    0x8(%ebp),%edx
  803c84:	29 c2                	sub    %eax,%edx
  803c86:	89 d0                	mov    %edx,%eax
  803c88:	c1 e8 0c             	shr    $0xc,%eax
  803c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c92:	78 09                	js     803c9d <to_page_info+0x27>
  803c94:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803c9b:	7e 14                	jle    803cb1 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803c9d:	83 ec 04             	sub    $0x4,%esp
  803ca0:	68 e4 60 80 00       	push   $0x8060e4
  803ca5:	6a 22                	push   $0x22
  803ca7:	68 cb 60 80 00       	push   $0x8060cb
  803cac:	e8 cd da ff ff       	call   80177e <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cb4:	89 d0                	mov    %edx,%eax
  803cb6:	01 c0                	add    %eax,%eax
  803cb8:	01 d0                	add    %edx,%eax
  803cba:	c1 e0 02             	shl    $0x2,%eax
  803cbd:	05 40 72 80 00       	add    $0x807240,%eax
}
  803cc2:	c9                   	leave  
  803cc3:	c3                   	ret    

00803cc4 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803cc4:	55                   	push   %ebp
  803cc5:	89 e5                	mov    %esp,%ebp
  803cc7:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803cca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccd:	05 00 00 00 02       	add    $0x2000000,%eax
  803cd2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803cd5:	73 16                	jae    803ced <initialize_dynamic_allocator+0x29>
  803cd7:	68 08 61 80 00       	push   $0x806108
  803cdc:	68 2e 61 80 00       	push   $0x80612e
  803ce1:	6a 34                	push   $0x34
  803ce3:	68 cb 60 80 00       	push   $0x8060cb
  803ce8:	e8 91 da ff ff       	call   80177e <_panic>
		is_initialized = 1;
  803ced:	c7 05 14 72 80 00 01 	movl   $0x1,0x807214
  803cf4:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfa:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd = daEnd;
  803cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d02:	a3 20 72 80 00       	mov    %eax,0x807220

	LIST_INIT(&freePagesList);
  803d07:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  803d0e:	00 00 00 
  803d11:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  803d18:	00 00 00 
  803d1b:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  803d22:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803d25:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803d2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d33:	eb 36                	jmp    803d6b <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d38:	c1 e0 04             	shl    $0x4,%eax
  803d3b:	05 60 f2 81 00       	add    $0x81f260,%eax
  803d40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d49:	c1 e0 04             	shl    $0x4,%eax
  803d4c:	05 64 f2 81 00       	add    $0x81f264,%eax
  803d51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5a:	c1 e0 04             	shl    $0x4,%eax
  803d5d:	05 6c f2 81 00       	add    $0x81f26c,%eax
  803d62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803d68:	ff 45 f4             	incl   -0xc(%ebp)
  803d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d71:	72 c2                	jb     803d35 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803d73:	8b 15 20 72 80 00    	mov    0x807220,%edx
  803d79:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803d7e:	29 c2                	sub    %eax,%edx
  803d80:	89 d0                	mov    %edx,%eax
  803d82:	c1 e8 0c             	shr    $0xc,%eax
  803d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803d88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803d8f:	e9 c8 00 00 00       	jmp    803e5c <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803d94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d97:	89 d0                	mov    %edx,%eax
  803d99:	01 c0                	add    %eax,%eax
  803d9b:	01 d0                	add    %edx,%eax
  803d9d:	c1 e0 02             	shl    $0x2,%eax
  803da0:	05 48 72 80 00       	add    $0x807248,%eax
  803da5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803daa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dad:	89 d0                	mov    %edx,%eax
  803daf:	01 c0                	add    %eax,%eax
  803db1:	01 d0                	add    %edx,%eax
  803db3:	c1 e0 02             	shl    $0x2,%eax
  803db6:	05 4a 72 80 00       	add    $0x80724a,%eax
  803dbb:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803dc0:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  803dc6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803dc9:	89 c8                	mov    %ecx,%eax
  803dcb:	01 c0                	add    %eax,%eax
  803dcd:	01 c8                	add    %ecx,%eax
  803dcf:	c1 e0 02             	shl    $0x2,%eax
  803dd2:	05 44 72 80 00       	add    $0x807244,%eax
  803dd7:	89 10                	mov    %edx,(%eax)
  803dd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ddc:	89 d0                	mov    %edx,%eax
  803dde:	01 c0                	add    %eax,%eax
  803de0:	01 d0                	add    %edx,%eax
  803de2:	c1 e0 02             	shl    $0x2,%eax
  803de5:	05 44 72 80 00       	add    $0x807244,%eax
  803dea:	8b 00                	mov    (%eax),%eax
  803dec:	85 c0                	test   %eax,%eax
  803dee:	74 1b                	je     803e0b <initialize_dynamic_allocator+0x147>
  803df0:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  803df6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803df9:	89 c8                	mov    %ecx,%eax
  803dfb:	01 c0                	add    %eax,%eax
  803dfd:	01 c8                	add    %ecx,%eax
  803dff:	c1 e0 02             	shl    $0x2,%eax
  803e02:	05 40 72 80 00       	add    $0x807240,%eax
  803e07:	89 02                	mov    %eax,(%edx)
  803e09:	eb 16                	jmp    803e21 <initialize_dynamic_allocator+0x15d>
  803e0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e0e:	89 d0                	mov    %edx,%eax
  803e10:	01 c0                	add    %eax,%eax
  803e12:	01 d0                	add    %edx,%eax
  803e14:	c1 e0 02             	shl    $0x2,%eax
  803e17:	05 40 72 80 00       	add    $0x807240,%eax
  803e1c:	a3 28 72 80 00       	mov    %eax,0x807228
  803e21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e24:	89 d0                	mov    %edx,%eax
  803e26:	01 c0                	add    %eax,%eax
  803e28:	01 d0                	add    %edx,%eax
  803e2a:	c1 e0 02             	shl    $0x2,%eax
  803e2d:	05 40 72 80 00       	add    $0x807240,%eax
  803e32:	a3 2c 72 80 00       	mov    %eax,0x80722c
  803e37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e3a:	89 d0                	mov    %edx,%eax
  803e3c:	01 c0                	add    %eax,%eax
  803e3e:	01 d0                	add    %edx,%eax
  803e40:	c1 e0 02             	shl    $0x2,%eax
  803e43:	05 40 72 80 00       	add    $0x807240,%eax
  803e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e4e:	a1 34 72 80 00       	mov    0x807234,%eax
  803e53:	40                   	inc    %eax
  803e54:	a3 34 72 80 00       	mov    %eax,0x807234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803e59:	ff 45 f0             	incl   -0x10(%ebp)
  803e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803e62:	0f 82 2c ff ff ff    	jb     803d94 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803e6e:	eb 2f                	jmp    803e9f <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803e70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e73:	89 d0                	mov    %edx,%eax
  803e75:	01 c0                	add    %eax,%eax
  803e77:	01 d0                	add    %edx,%eax
  803e79:	c1 e0 02             	shl    $0x2,%eax
  803e7c:	05 48 72 80 00       	add    $0x807248,%eax
  803e81:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803e86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e89:	89 d0                	mov    %edx,%eax
  803e8b:	01 c0                	add    %eax,%eax
  803e8d:	01 d0                	add    %edx,%eax
  803e8f:	c1 e0 02             	shl    $0x2,%eax
  803e92:	05 4a 72 80 00       	add    $0x80724a,%eax
  803e97:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803e9c:	ff 45 ec             	incl   -0x14(%ebp)
  803e9f:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803ea6:	76 c8                	jbe    803e70 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803ea8:	90                   	nop
  803ea9:	c9                   	leave  
  803eaa:	c3                   	ret    

00803eab <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803eab:	55                   	push   %ebp
  803eac:	89 e5                	mov    %esp,%ebp
  803eae:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  803eb4:	a1 48 f2 81 00       	mov    0x81f248,%eax
  803eb9:	29 c2                	sub    %eax,%edx
  803ebb:	89 d0                	mov    %edx,%eax
  803ebd:	c1 e8 0c             	shr    $0xc,%eax
  803ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803ec3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ec6:	89 d0                	mov    %edx,%eax
  803ec8:	01 c0                	add    %eax,%eax
  803eca:	01 d0                	add    %edx,%eax
  803ecc:	c1 e0 02             	shl    $0x2,%eax
  803ecf:	05 48 72 80 00       	add    $0x807248,%eax
  803ed4:	8b 00                	mov    (%eax),%eax
  803ed6:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803ed9:	c9                   	leave  
  803eda:	c3                   	ret    

00803edb <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803edb:	55                   	push   %ebp
  803edc:	89 e5                	mov    %esp,%ebp
  803ede:	83 ec 14             	sub    $0x14,%esp
  803ee1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803ee4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803ee8:	77 07                	ja     803ef1 <nearest_pow2_ceil.1513+0x16>
  803eea:	b8 01 00 00 00       	mov    $0x1,%eax
  803eef:	eb 20                	jmp    803f11 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803ef1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803ef8:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803efb:	eb 08                	jmp    803f05 <nearest_pow2_ceil.1513+0x2a>
  803efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f00:	01 c0                	add    %eax,%eax
  803f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803f05:	d1 6d 08             	shrl   0x8(%ebp)
  803f08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f0c:	75 ef                	jne    803efd <nearest_pow2_ceil.1513+0x22>
        return power;
  803f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803f11:	c9                   	leave  
  803f12:	c3                   	ret    

00803f13 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803f13:	55                   	push   %ebp
  803f14:	89 e5                	mov    %esp,%ebp
  803f16:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803f19:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803f20:	76 16                	jbe    803f38 <alloc_block+0x25>
  803f22:	68 44 61 80 00       	push   $0x806144
  803f27:	68 2e 61 80 00       	push   $0x80612e
  803f2c:	6a 72                	push   $0x72
  803f2e:	68 cb 60 80 00       	push   $0x8060cb
  803f33:	e8 46 d8 ff ff       	call   80177e <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803f38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f3c:	75 0a                	jne    803f48 <alloc_block+0x35>
  803f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f43:	e9 bd 04 00 00       	jmp    804405 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803f48:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f52:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803f55:	73 06                	jae    803f5d <alloc_block+0x4a>
        size = min_block_size;
  803f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f5a:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803f5d:	83 ec 0c             	sub    $0xc,%esp
  803f60:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803f63:	ff 75 08             	pushl  0x8(%ebp)
  803f66:	89 c1                	mov    %eax,%ecx
  803f68:	e8 6e ff ff ff       	call   803edb <nearest_pow2_ceil.1513>
  803f6d:	83 c4 10             	add    $0x10,%esp
  803f70:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803f73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f76:	83 ec 0c             	sub    $0xc,%esp
  803f79:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803f7c:	52                   	push   %edx
  803f7d:	89 c1                	mov    %eax,%ecx
  803f7f:	e8 83 04 00 00       	call   804407 <log2_ceil.1520>
  803f84:	83 c4 10             	add    $0x10,%esp
  803f87:	83 e8 03             	sub    $0x3,%eax
  803f8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803f8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f90:	c1 e0 04             	shl    $0x4,%eax
  803f93:	05 60 f2 81 00       	add    $0x81f260,%eax
  803f98:	8b 00                	mov    (%eax),%eax
  803f9a:	85 c0                	test   %eax,%eax
  803f9c:	0f 84 d8 00 00 00    	je     80407a <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa5:	c1 e0 04             	shl    $0x4,%eax
  803fa8:	05 60 f2 81 00       	add    $0x81f260,%eax
  803fad:	8b 00                	mov    (%eax),%eax
  803faf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803fb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803fb6:	75 17                	jne    803fcf <alloc_block+0xbc>
  803fb8:	83 ec 04             	sub    $0x4,%esp
  803fbb:	68 65 61 80 00       	push   $0x806165
  803fc0:	68 98 00 00 00       	push   $0x98
  803fc5:	68 cb 60 80 00       	push   $0x8060cb
  803fca:	e8 af d7 ff ff       	call   80177e <_panic>
  803fcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fd2:	8b 00                	mov    (%eax),%eax
  803fd4:	85 c0                	test   %eax,%eax
  803fd6:	74 10                	je     803fe8 <alloc_block+0xd5>
  803fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fdb:	8b 00                	mov    (%eax),%eax
  803fdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803fe0:	8b 52 04             	mov    0x4(%edx),%edx
  803fe3:	89 50 04             	mov    %edx,0x4(%eax)
  803fe6:	eb 14                	jmp    803ffc <alloc_block+0xe9>
  803fe8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803feb:	8b 40 04             	mov    0x4(%eax),%eax
  803fee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ff1:	c1 e2 04             	shl    $0x4,%edx
  803ff4:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  803ffa:	89 02                	mov    %eax,(%edx)
  803ffc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fff:	8b 40 04             	mov    0x4(%eax),%eax
  804002:	85 c0                	test   %eax,%eax
  804004:	74 0f                	je     804015 <alloc_block+0x102>
  804006:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804009:	8b 40 04             	mov    0x4(%eax),%eax
  80400c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80400f:	8b 12                	mov    (%edx),%edx
  804011:	89 10                	mov    %edx,(%eax)
  804013:	eb 13                	jmp    804028 <alloc_block+0x115>
  804015:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804018:	8b 00                	mov    (%eax),%eax
  80401a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80401d:	c1 e2 04             	shl    $0x4,%edx
  804020:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804026:	89 02                	mov    %eax,(%edx)
  804028:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80402b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804031:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80403b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403e:	c1 e0 04             	shl    $0x4,%eax
  804041:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804046:	8b 00                	mov    (%eax),%eax
  804048:	8d 50 ff             	lea    -0x1(%eax),%edx
  80404b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404e:	c1 e0 04             	shl    $0x4,%eax
  804051:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804056:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  804058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80405b:	83 ec 0c             	sub    $0xc,%esp
  80405e:	50                   	push   %eax
  80405f:	e8 12 fc ff ff       	call   803c76 <to_page_info>
  804064:	83 c4 10             	add    $0x10,%esp
  804067:	89 c2                	mov    %eax,%edx
  804069:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80406d:	48                   	dec    %eax
  80406e:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  804072:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804075:	e9 8b 03 00 00       	jmp    804405 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  80407a:	a1 28 72 80 00       	mov    0x807228,%eax
  80407f:	85 c0                	test   %eax,%eax
  804081:	0f 84 64 02 00 00    	je     8042eb <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  804087:	a1 28 72 80 00       	mov    0x807228,%eax
  80408c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80408f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804093:	75 17                	jne    8040ac <alloc_block+0x199>
  804095:	83 ec 04             	sub    $0x4,%esp
  804098:	68 65 61 80 00       	push   $0x806165
  80409d:	68 a0 00 00 00       	push   $0xa0
  8040a2:	68 cb 60 80 00       	push   $0x8060cb
  8040a7:	e8 d2 d6 ff ff       	call   80177e <_panic>
  8040ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040af:	8b 00                	mov    (%eax),%eax
  8040b1:	85 c0                	test   %eax,%eax
  8040b3:	74 10                	je     8040c5 <alloc_block+0x1b2>
  8040b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040b8:	8b 00                	mov    (%eax),%eax
  8040ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040bd:	8b 52 04             	mov    0x4(%edx),%edx
  8040c0:	89 50 04             	mov    %edx,0x4(%eax)
  8040c3:	eb 0b                	jmp    8040d0 <alloc_block+0x1bd>
  8040c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040c8:	8b 40 04             	mov    0x4(%eax),%eax
  8040cb:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8040d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040d3:	8b 40 04             	mov    0x4(%eax),%eax
  8040d6:	85 c0                	test   %eax,%eax
  8040d8:	74 0f                	je     8040e9 <alloc_block+0x1d6>
  8040da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040dd:	8b 40 04             	mov    0x4(%eax),%eax
  8040e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040e3:	8b 12                	mov    (%edx),%edx
  8040e5:	89 10                	mov    %edx,(%eax)
  8040e7:	eb 0a                	jmp    8040f3 <alloc_block+0x1e0>
  8040e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040ec:	8b 00                	mov    (%eax),%eax
  8040ee:	a3 28 72 80 00       	mov    %eax,0x807228
  8040f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804106:	a1 34 72 80 00       	mov    0x807234,%eax
  80410b:	48                   	dec    %eax
  80410c:	a3 34 72 80 00       	mov    %eax,0x807234

        page_info_e->block_size = pow;
  804111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804114:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804117:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  80411b:	b8 00 10 00 00       	mov    $0x1000,%eax
  804120:	99                   	cltd   
  804121:	f7 7d e8             	idivl  -0x18(%ebp)
  804124:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804127:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  80412b:	83 ec 0c             	sub    $0xc,%esp
  80412e:	ff 75 dc             	pushl  -0x24(%ebp)
  804131:	e8 ce fa ff ff       	call   803c04 <to_page_va>
  804136:	83 c4 10             	add    $0x10,%esp
  804139:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  80413c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80413f:	83 ec 0c             	sub    $0xc,%esp
  804142:	50                   	push   %eax
  804143:	e8 c0 ee ff ff       	call   803008 <get_page>
  804148:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80414b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804152:	e9 aa 00 00 00       	jmp    804201 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  804157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80415a:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80415e:	89 c2                	mov    %eax,%edx
  804160:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804163:	01 d0                	add    %edx,%eax
  804165:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  804168:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80416c:	75 17                	jne    804185 <alloc_block+0x272>
  80416e:	83 ec 04             	sub    $0x4,%esp
  804171:	68 84 61 80 00       	push   $0x806184
  804176:	68 aa 00 00 00       	push   $0xaa
  80417b:	68 cb 60 80 00       	push   $0x8060cb
  804180:	e8 f9 d5 ff ff       	call   80177e <_panic>
  804185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804188:	c1 e0 04             	shl    $0x4,%eax
  80418b:	05 64 f2 81 00       	add    $0x81f264,%eax
  804190:	8b 10                	mov    (%eax),%edx
  804192:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804195:	89 50 04             	mov    %edx,0x4(%eax)
  804198:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80419b:	8b 40 04             	mov    0x4(%eax),%eax
  80419e:	85 c0                	test   %eax,%eax
  8041a0:	74 14                	je     8041b6 <alloc_block+0x2a3>
  8041a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a5:	c1 e0 04             	shl    $0x4,%eax
  8041a8:	05 64 f2 81 00       	add    $0x81f264,%eax
  8041ad:	8b 00                	mov    (%eax),%eax
  8041af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041b2:	89 10                	mov    %edx,(%eax)
  8041b4:	eb 11                	jmp    8041c7 <alloc_block+0x2b4>
  8041b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b9:	c1 e0 04             	shl    $0x4,%eax
  8041bc:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  8041c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c5:	89 02                	mov    %eax,(%edx)
  8041c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ca:	c1 e0 04             	shl    $0x4,%eax
  8041cd:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  8041d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041d6:	89 02                	mov    %eax,(%edx)
  8041d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e4:	c1 e0 04             	shl    $0x4,%eax
  8041e7:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8041ec:	8b 00                	mov    (%eax),%eax
  8041ee:	8d 50 01             	lea    0x1(%eax),%edx
  8041f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f4:	c1 e0 04             	shl    $0x4,%eax
  8041f7:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8041fc:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8041fe:	ff 45 f4             	incl   -0xc(%ebp)
  804201:	b8 00 10 00 00       	mov    $0x1000,%eax
  804206:	99                   	cltd   
  804207:	f7 7d e8             	idivl  -0x18(%ebp)
  80420a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80420d:	0f 8f 44 ff ff ff    	jg     804157 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  804213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804216:	c1 e0 04             	shl    $0x4,%eax
  804219:	05 60 f2 81 00       	add    $0x81f260,%eax
  80421e:	8b 00                	mov    (%eax),%eax
  804220:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  804223:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804227:	75 17                	jne    804240 <alloc_block+0x32d>
  804229:	83 ec 04             	sub    $0x4,%esp
  80422c:	68 65 61 80 00       	push   $0x806165
  804231:	68 ae 00 00 00       	push   $0xae
  804236:	68 cb 60 80 00       	push   $0x8060cb
  80423b:	e8 3e d5 ff ff       	call   80177e <_panic>
  804240:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804243:	8b 00                	mov    (%eax),%eax
  804245:	85 c0                	test   %eax,%eax
  804247:	74 10                	je     804259 <alloc_block+0x346>
  804249:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80424c:	8b 00                	mov    (%eax),%eax
  80424e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804251:	8b 52 04             	mov    0x4(%edx),%edx
  804254:	89 50 04             	mov    %edx,0x4(%eax)
  804257:	eb 14                	jmp    80426d <alloc_block+0x35a>
  804259:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80425c:	8b 40 04             	mov    0x4(%eax),%eax
  80425f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804262:	c1 e2 04             	shl    $0x4,%edx
  804265:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  80426b:	89 02                	mov    %eax,(%edx)
  80426d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804270:	8b 40 04             	mov    0x4(%eax),%eax
  804273:	85 c0                	test   %eax,%eax
  804275:	74 0f                	je     804286 <alloc_block+0x373>
  804277:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80427a:	8b 40 04             	mov    0x4(%eax),%eax
  80427d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804280:	8b 12                	mov    (%edx),%edx
  804282:	89 10                	mov    %edx,(%eax)
  804284:	eb 13                	jmp    804299 <alloc_block+0x386>
  804286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804289:	8b 00                	mov    (%eax),%eax
  80428b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80428e:	c1 e2 04             	shl    $0x4,%edx
  804291:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804297:	89 02                	mov    %eax,(%edx)
  804299:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80429c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042af:	c1 e0 04             	shl    $0x4,%eax
  8042b2:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8042b7:	8b 00                	mov    (%eax),%eax
  8042b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8042bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042bf:	c1 e0 04             	shl    $0x4,%eax
  8042c2:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8042c7:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8042c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042cc:	83 ec 0c             	sub    $0xc,%esp
  8042cf:	50                   	push   %eax
  8042d0:	e8 a1 f9 ff ff       	call   803c76 <to_page_info>
  8042d5:	83 c4 10             	add    $0x10,%esp
  8042d8:	89 c2                	mov    %eax,%edx
  8042da:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8042de:	48                   	dec    %eax
  8042df:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8042e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042e6:	e9 1a 01 00 00       	jmp    804405 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8042eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042ee:	40                   	inc    %eax
  8042ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8042f2:	e9 ed 00 00 00       	jmp    8043e4 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8042f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042fa:	c1 e0 04             	shl    $0x4,%eax
  8042fd:	05 60 f2 81 00       	add    $0x81f260,%eax
  804302:	8b 00                	mov    (%eax),%eax
  804304:	85 c0                	test   %eax,%eax
  804306:	0f 84 d5 00 00 00    	je     8043e1 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  80430c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80430f:	c1 e0 04             	shl    $0x4,%eax
  804312:	05 60 f2 81 00       	add    $0x81f260,%eax
  804317:	8b 00                	mov    (%eax),%eax
  804319:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  80431c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804320:	75 17                	jne    804339 <alloc_block+0x426>
  804322:	83 ec 04             	sub    $0x4,%esp
  804325:	68 65 61 80 00       	push   $0x806165
  80432a:	68 b8 00 00 00       	push   $0xb8
  80432f:	68 cb 60 80 00       	push   $0x8060cb
  804334:	e8 45 d4 ff ff       	call   80177e <_panic>
  804339:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80433c:	8b 00                	mov    (%eax),%eax
  80433e:	85 c0                	test   %eax,%eax
  804340:	74 10                	je     804352 <alloc_block+0x43f>
  804342:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804345:	8b 00                	mov    (%eax),%eax
  804347:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80434a:	8b 52 04             	mov    0x4(%edx),%edx
  80434d:	89 50 04             	mov    %edx,0x4(%eax)
  804350:	eb 14                	jmp    804366 <alloc_block+0x453>
  804352:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804355:	8b 40 04             	mov    0x4(%eax),%eax
  804358:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80435b:	c1 e2 04             	shl    $0x4,%edx
  80435e:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804364:	89 02                	mov    %eax,(%edx)
  804366:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804369:	8b 40 04             	mov    0x4(%eax),%eax
  80436c:	85 c0                	test   %eax,%eax
  80436e:	74 0f                	je     80437f <alloc_block+0x46c>
  804370:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804373:	8b 40 04             	mov    0x4(%eax),%eax
  804376:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804379:	8b 12                	mov    (%edx),%edx
  80437b:	89 10                	mov    %edx,(%eax)
  80437d:	eb 13                	jmp    804392 <alloc_block+0x47f>
  80437f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804382:	8b 00                	mov    (%eax),%eax
  804384:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804387:	c1 e2 04             	shl    $0x4,%edx
  80438a:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804390:	89 02                	mov    %eax,(%edx)
  804392:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80439b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80439e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043a8:	c1 e0 04             	shl    $0x4,%eax
  8043ab:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8043b0:	8b 00                	mov    (%eax),%eax
  8043b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8043b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b8:	c1 e0 04             	shl    $0x4,%eax
  8043bb:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8043c0:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8043c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043c5:	83 ec 0c             	sub    $0xc,%esp
  8043c8:	50                   	push   %eax
  8043c9:	e8 a8 f8 ff ff       	call   803c76 <to_page_info>
  8043ce:	83 c4 10             	add    $0x10,%esp
  8043d1:	89 c2                	mov    %eax,%edx
  8043d3:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8043d7:	48                   	dec    %eax
  8043d8:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8043dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8043df:	eb 24                	jmp    804405 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8043e1:	ff 45 f0             	incl   -0x10(%ebp)
  8043e4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8043e8:	0f 8e 09 ff ff ff    	jle    8042f7 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8043ee:	83 ec 04             	sub    $0x4,%esp
  8043f1:	68 a7 61 80 00       	push   $0x8061a7
  8043f6:	68 bf 00 00 00       	push   $0xbf
  8043fb:	68 cb 60 80 00       	push   $0x8060cb
  804400:	e8 79 d3 ff ff       	call   80177e <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804405:	c9                   	leave  
  804406:	c3                   	ret    

00804407 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  804407:	55                   	push   %ebp
  804408:	89 e5                	mov    %esp,%ebp
  80440a:	83 ec 14             	sub    $0x14,%esp
  80440d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  804410:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804414:	75 07                	jne    80441d <log2_ceil.1520+0x16>
  804416:	b8 00 00 00 00       	mov    $0x0,%eax
  80441b:	eb 1b                	jmp    804438 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80441d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  804424:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  804427:	eb 06                	jmp    80442f <log2_ceil.1520+0x28>
            x >>= 1;
  804429:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80442c:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80442f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804433:	75 f4                	jne    804429 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  804435:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  804438:	c9                   	leave  
  804439:	c3                   	ret    

0080443a <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80443a:	55                   	push   %ebp
  80443b:	89 e5                	mov    %esp,%ebp
  80443d:	83 ec 14             	sub    $0x14,%esp
  804440:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  804443:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804447:	75 07                	jne    804450 <log2_ceil.1547+0x16>
  804449:	b8 00 00 00 00       	mov    $0x0,%eax
  80444e:	eb 1b                	jmp    80446b <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  804450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  804457:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80445a:	eb 06                	jmp    804462 <log2_ceil.1547+0x28>
			x >>= 1;
  80445c:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80445f:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  804462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804466:	75 f4                	jne    80445c <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  804468:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80446b:	c9                   	leave  
  80446c:	c3                   	ret    

0080446d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80446d:	55                   	push   %ebp
  80446e:	89 e5                	mov    %esp,%ebp
  804470:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804473:	8b 55 08             	mov    0x8(%ebp),%edx
  804476:	a1 48 f2 81 00       	mov    0x81f248,%eax
  80447b:	39 c2                	cmp    %eax,%edx
  80447d:	72 0c                	jb     80448b <free_block+0x1e>
  80447f:	8b 55 08             	mov    0x8(%ebp),%edx
  804482:	a1 20 72 80 00       	mov    0x807220,%eax
  804487:	39 c2                	cmp    %eax,%edx
  804489:	72 19                	jb     8044a4 <free_block+0x37>
  80448b:	68 ac 61 80 00       	push   $0x8061ac
  804490:	68 2e 61 80 00       	push   $0x80612e
  804495:	68 d0 00 00 00       	push   $0xd0
  80449a:	68 cb 60 80 00       	push   $0x8060cb
  80449f:	e8 da d2 ff ff       	call   80177e <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8044a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044a8:	0f 84 42 03 00 00    	je     8047f0 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8044ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8044b1:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8044b6:	39 c2                	cmp    %eax,%edx
  8044b8:	72 0c                	jb     8044c6 <free_block+0x59>
  8044ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8044bd:	a1 20 72 80 00       	mov    0x807220,%eax
  8044c2:	39 c2                	cmp    %eax,%edx
  8044c4:	72 17                	jb     8044dd <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8044c6:	83 ec 04             	sub    $0x4,%esp
  8044c9:	68 e4 61 80 00       	push   $0x8061e4
  8044ce:	68 e6 00 00 00       	push   $0xe6
  8044d3:	68 cb 60 80 00       	push   $0x8060cb
  8044d8:	e8 a1 d2 ff ff       	call   80177e <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8044dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8044e0:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8044e5:	29 c2                	sub    %eax,%edx
  8044e7:	89 d0                	mov    %edx,%eax
  8044e9:	83 e0 07             	and    $0x7,%eax
  8044ec:	85 c0                	test   %eax,%eax
  8044ee:	74 17                	je     804507 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8044f0:	83 ec 04             	sub    $0x4,%esp
  8044f3:	68 18 62 80 00       	push   $0x806218
  8044f8:	68 ea 00 00 00       	push   $0xea
  8044fd:	68 cb 60 80 00       	push   $0x8060cb
  804502:	e8 77 d2 ff ff       	call   80177e <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  804507:	8b 45 08             	mov    0x8(%ebp),%eax
  80450a:	83 ec 0c             	sub    $0xc,%esp
  80450d:	50                   	push   %eax
  80450e:	e8 63 f7 ff ff       	call   803c76 <to_page_info>
  804513:	83 c4 10             	add    $0x10,%esp
  804516:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  804519:	83 ec 0c             	sub    $0xc,%esp
  80451c:	ff 75 08             	pushl  0x8(%ebp)
  80451f:	e8 87 f9 ff ff       	call   803eab <get_block_size>
  804524:	83 c4 10             	add    $0x10,%esp
  804527:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80452a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80452e:	75 17                	jne    804547 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  804530:	83 ec 04             	sub    $0x4,%esp
  804533:	68 44 62 80 00       	push   $0x806244
  804538:	68 f1 00 00 00       	push   $0xf1
  80453d:	68 cb 60 80 00       	push   $0x8060cb
  804542:	e8 37 d2 ff ff       	call   80177e <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  804547:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80454a:	83 ec 0c             	sub    $0xc,%esp
  80454d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  804550:	52                   	push   %edx
  804551:	89 c1                	mov    %eax,%ecx
  804553:	e8 e2 fe ff ff       	call   80443a <log2_ceil.1547>
  804558:	83 c4 10             	add    $0x10,%esp
  80455b:	83 e8 03             	sub    $0x3,%eax
  80455e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  804561:	8b 45 08             	mov    0x8(%ebp),%eax
  804564:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  804567:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80456b:	75 17                	jne    804584 <free_block+0x117>
  80456d:	83 ec 04             	sub    $0x4,%esp
  804570:	68 90 62 80 00       	push   $0x806290
  804575:	68 f6 00 00 00       	push   $0xf6
  80457a:	68 cb 60 80 00       	push   $0x8060cb
  80457f:	e8 fa d1 ff ff       	call   80177e <_panic>
  804584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804587:	c1 e0 04             	shl    $0x4,%eax
  80458a:	05 60 f2 81 00       	add    $0x81f260,%eax
  80458f:	8b 10                	mov    (%eax),%edx
  804591:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804594:	89 10                	mov    %edx,(%eax)
  804596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804599:	8b 00                	mov    (%eax),%eax
  80459b:	85 c0                	test   %eax,%eax
  80459d:	74 15                	je     8045b4 <free_block+0x147>
  80459f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045a2:	c1 e0 04             	shl    $0x4,%eax
  8045a5:	05 60 f2 81 00       	add    $0x81f260,%eax
  8045aa:	8b 00                	mov    (%eax),%eax
  8045ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8045af:	89 50 04             	mov    %edx,0x4(%eax)
  8045b2:	eb 11                	jmp    8045c5 <free_block+0x158>
  8045b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045b7:	c1 e0 04             	shl    $0x4,%eax
  8045ba:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  8045c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045c3:	89 02                	mov    %eax,(%edx)
  8045c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c8:	c1 e0 04             	shl    $0x4,%eax
  8045cb:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  8045d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045d4:	89 02                	mov    %eax,(%edx)
  8045d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045e3:	c1 e0 04             	shl    $0x4,%eax
  8045e6:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8045eb:	8b 00                	mov    (%eax),%eax
  8045ed:	8d 50 01             	lea    0x1(%eax),%edx
  8045f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f3:	c1 e0 04             	shl    $0x4,%eax
  8045f6:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8045fb:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8045fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804600:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804604:	40                   	inc    %eax
  804605:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804608:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80460c:	8b 55 08             	mov    0x8(%ebp),%edx
  80460f:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804614:	29 c2                	sub    %eax,%edx
  804616:	89 d0                	mov    %edx,%eax
  804618:	c1 e8 0c             	shr    $0xc,%eax
  80461b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80461e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804621:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804625:	0f b7 c8             	movzwl %ax,%ecx
  804628:	b8 00 10 00 00       	mov    $0x1000,%eax
  80462d:	99                   	cltd   
  80462e:	f7 7d e8             	idivl  -0x18(%ebp)
  804631:	39 c1                	cmp    %eax,%ecx
  804633:	0f 85 b8 01 00 00    	jne    8047f1 <free_block+0x384>
    	uint32 blocks_removed = 0;
  804639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  804640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804643:	c1 e0 04             	shl    $0x4,%eax
  804646:	05 60 f2 81 00       	add    $0x81f260,%eax
  80464b:	8b 00                	mov    (%eax),%eax
  80464d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804650:	e9 d5 00 00 00       	jmp    80472a <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  804655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804658:	8b 00                	mov    (%eax),%eax
  80465a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80465d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804660:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804665:	29 c2                	sub    %eax,%edx
  804667:	89 d0                	mov    %edx,%eax
  804669:	c1 e8 0c             	shr    $0xc,%eax
  80466c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80466f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804672:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  804675:	0f 85 a9 00 00 00    	jne    804724 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80467b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80467f:	75 17                	jne    804698 <free_block+0x22b>
  804681:	83 ec 04             	sub    $0x4,%esp
  804684:	68 65 61 80 00       	push   $0x806165
  804689:	68 04 01 00 00       	push   $0x104
  80468e:	68 cb 60 80 00       	push   $0x8060cb
  804693:	e8 e6 d0 ff ff       	call   80177e <_panic>
  804698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80469b:	8b 00                	mov    (%eax),%eax
  80469d:	85 c0                	test   %eax,%eax
  80469f:	74 10                	je     8046b1 <free_block+0x244>
  8046a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046a4:	8b 00                	mov    (%eax),%eax
  8046a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8046a9:	8b 52 04             	mov    0x4(%edx),%edx
  8046ac:	89 50 04             	mov    %edx,0x4(%eax)
  8046af:	eb 14                	jmp    8046c5 <free_block+0x258>
  8046b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046b4:	8b 40 04             	mov    0x4(%eax),%eax
  8046b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046ba:	c1 e2 04             	shl    $0x4,%edx
  8046bd:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  8046c3:	89 02                	mov    %eax,(%edx)
  8046c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046c8:	8b 40 04             	mov    0x4(%eax),%eax
  8046cb:	85 c0                	test   %eax,%eax
  8046cd:	74 0f                	je     8046de <free_block+0x271>
  8046cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046d2:	8b 40 04             	mov    0x4(%eax),%eax
  8046d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8046d8:	8b 12                	mov    (%edx),%edx
  8046da:	89 10                	mov    %edx,(%eax)
  8046dc:	eb 13                	jmp    8046f1 <free_block+0x284>
  8046de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046e1:	8b 00                	mov    (%eax),%eax
  8046e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046e6:	c1 e2 04             	shl    $0x4,%edx
  8046e9:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  8046ef:	89 02                	mov    %eax,(%edx)
  8046f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8046fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804707:	c1 e0 04             	shl    $0x4,%eax
  80470a:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80470f:	8b 00                	mov    (%eax),%eax
  804711:	8d 50 ff             	lea    -0x1(%eax),%edx
  804714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804717:	c1 e0 04             	shl    $0x4,%eax
  80471a:	05 6c f2 81 00       	add    $0x81f26c,%eax
  80471f:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804721:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804724:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804727:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80472a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80472e:	0f 85 21 ff ff ff    	jne    804655 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  804734:	b8 00 10 00 00       	mov    $0x1000,%eax
  804739:	99                   	cltd   
  80473a:	f7 7d e8             	idivl  -0x18(%ebp)
  80473d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804740:	74 17                	je     804759 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  804742:	83 ec 04             	sub    $0x4,%esp
  804745:	68 b4 62 80 00       	push   $0x8062b4
  80474a:	68 0c 01 00 00       	push   $0x10c
  80474f:	68 cb 60 80 00       	push   $0x8060cb
  804754:	e8 25 d0 ff ff       	call   80177e <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  804759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80475c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  804762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804765:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80476b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80476f:	75 17                	jne    804788 <free_block+0x31b>
  804771:	83 ec 04             	sub    $0x4,%esp
  804774:	68 84 61 80 00       	push   $0x806184
  804779:	68 11 01 00 00       	push   $0x111
  80477e:	68 cb 60 80 00       	push   $0x8060cb
  804783:	e8 f6 cf ff ff       	call   80177e <_panic>
  804788:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  80478e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804791:	89 50 04             	mov    %edx,0x4(%eax)
  804794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804797:	8b 40 04             	mov    0x4(%eax),%eax
  80479a:	85 c0                	test   %eax,%eax
  80479c:	74 0c                	je     8047aa <free_block+0x33d>
  80479e:	a1 2c 72 80 00       	mov    0x80722c,%eax
  8047a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8047a6:	89 10                	mov    %edx,(%eax)
  8047a8:	eb 08                	jmp    8047b2 <free_block+0x345>
  8047aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047ad:	a3 28 72 80 00       	mov    %eax,0x807228
  8047b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047b5:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8047ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047c3:	a1 34 72 80 00       	mov    0x807234,%eax
  8047c8:	40                   	inc    %eax
  8047c9:	a3 34 72 80 00       	mov    %eax,0x807234

        uint32 pp = to_page_va(page_info_e);
  8047ce:	83 ec 0c             	sub    $0xc,%esp
  8047d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8047d4:	e8 2b f4 ff ff       	call   803c04 <to_page_va>
  8047d9:	83 c4 10             	add    $0x10,%esp
  8047dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8047df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8047e2:	83 ec 0c             	sub    $0xc,%esp
  8047e5:	50                   	push   %eax
  8047e6:	e8 69 e8 ff ff       	call   803054 <return_page>
  8047eb:	83 c4 10             	add    $0x10,%esp
  8047ee:	eb 01                	jmp    8047f1 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8047f0:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8047f1:	c9                   	leave  
  8047f2:	c3                   	ret    

008047f3 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8047f3:	55                   	push   %ebp
  8047f4:	89 e5                	mov    %esp,%ebp
  8047f6:	83 ec 14             	sub    $0x14,%esp
  8047f9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8047fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804800:	77 07                	ja     804809 <nearest_pow2_ceil.1572+0x16>
      return 1;
  804802:	b8 01 00 00 00       	mov    $0x1,%eax
  804807:	eb 20                	jmp    804829 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  804809:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  804810:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  804813:	eb 08                	jmp    80481d <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  804815:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804818:	01 c0                	add    %eax,%eax
  80481a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80481d:	d1 6d 08             	shrl   0x8(%ebp)
  804820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804824:	75 ef                	jne    804815 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  804826:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  804829:	c9                   	leave  
  80482a:	c3                   	ret    

0080482b <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80482b:	55                   	push   %ebp
  80482c:	89 e5                	mov    %esp,%ebp
  80482e:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  804831:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804835:	75 13                	jne    80484a <realloc_block+0x1f>
    return alloc_block(new_size);
  804837:	83 ec 0c             	sub    $0xc,%esp
  80483a:	ff 75 0c             	pushl  0xc(%ebp)
  80483d:	e8 d1 f6 ff ff       	call   803f13 <alloc_block>
  804842:	83 c4 10             	add    $0x10,%esp
  804845:	e9 d9 00 00 00       	jmp    804923 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80484a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80484e:	75 18                	jne    804868 <realloc_block+0x3d>
    free_block(va);
  804850:	83 ec 0c             	sub    $0xc,%esp
  804853:	ff 75 08             	pushl  0x8(%ebp)
  804856:	e8 12 fc ff ff       	call   80446d <free_block>
  80485b:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80485e:	b8 00 00 00 00       	mov    $0x0,%eax
  804863:	e9 bb 00 00 00       	jmp    804923 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  804868:	83 ec 0c             	sub    $0xc,%esp
  80486b:	ff 75 08             	pushl  0x8(%ebp)
  80486e:	e8 38 f6 ff ff       	call   803eab <get_block_size>
  804873:	83 c4 10             	add    $0x10,%esp
  804876:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  804879:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804880:	8b 45 0c             	mov    0xc(%ebp),%eax
  804883:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804886:	73 06                	jae    80488e <realloc_block+0x63>
    new_size = min_block_size;
  804888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80488b:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80488e:	83 ec 0c             	sub    $0xc,%esp
  804891:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804894:	ff 75 0c             	pushl  0xc(%ebp)
  804897:	89 c1                	mov    %eax,%ecx
  804899:	e8 55 ff ff ff       	call   8047f3 <nearest_pow2_ceil.1572>
  80489e:	83 c4 10             	add    $0x10,%esp
  8048a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8048a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8048aa:	75 05                	jne    8048b1 <realloc_block+0x86>
    return va;
  8048ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8048af:	eb 72                	jmp    804923 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8048b1:	83 ec 0c             	sub    $0xc,%esp
  8048b4:	ff 75 0c             	pushl  0xc(%ebp)
  8048b7:	e8 57 f6 ff ff       	call   803f13 <alloc_block>
  8048bc:	83 c4 10             	add    $0x10,%esp
  8048bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8048c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8048c6:	75 07                	jne    8048cf <realloc_block+0xa4>
    return NULL;
  8048c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8048cd:	eb 54                	jmp    804923 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8048cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8048d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8048d5:	39 d0                	cmp    %edx,%eax
  8048d7:	76 02                	jbe    8048db <realloc_block+0xb0>
  8048d9:	89 d0                	mov    %edx,%eax
  8048db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8048de:	8b 45 08             	mov    0x8(%ebp),%eax
  8048e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8048e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8048e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8048ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8048f1:	eb 17                	jmp    80490a <realloc_block+0xdf>
    dst[i] = src[i];
  8048f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048f9:	01 c2                	add    %eax,%edx
  8048fb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8048fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804901:	01 c8                	add    %ecx,%eax
  804903:	8a 00                	mov    (%eax),%al
  804905:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  804907:	ff 45 f4             	incl   -0xc(%ebp)
  80490a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80490d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804910:	72 e1                	jb     8048f3 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  804912:	83 ec 0c             	sub    $0xc,%esp
  804915:	ff 75 08             	pushl  0x8(%ebp)
  804918:	e8 50 fb ff ff       	call   80446d <free_block>
  80491d:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  804923:	c9                   	leave  
  804924:	c3                   	ret    
  804925:	66 90                	xchg   %ax,%ax
  804927:	90                   	nop

00804928 <__udivdi3>:
  804928:	55                   	push   %ebp
  804929:	57                   	push   %edi
  80492a:	56                   	push   %esi
  80492b:	53                   	push   %ebx
  80492c:	83 ec 1c             	sub    $0x1c,%esp
  80492f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804933:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804937:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80493b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80493f:	89 ca                	mov    %ecx,%edx
  804941:	89 f8                	mov    %edi,%eax
  804943:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804947:	85 f6                	test   %esi,%esi
  804949:	75 2d                	jne    804978 <__udivdi3+0x50>
  80494b:	39 cf                	cmp    %ecx,%edi
  80494d:	77 65                	ja     8049b4 <__udivdi3+0x8c>
  80494f:	89 fd                	mov    %edi,%ebp
  804951:	85 ff                	test   %edi,%edi
  804953:	75 0b                	jne    804960 <__udivdi3+0x38>
  804955:	b8 01 00 00 00       	mov    $0x1,%eax
  80495a:	31 d2                	xor    %edx,%edx
  80495c:	f7 f7                	div    %edi
  80495e:	89 c5                	mov    %eax,%ebp
  804960:	31 d2                	xor    %edx,%edx
  804962:	89 c8                	mov    %ecx,%eax
  804964:	f7 f5                	div    %ebp
  804966:	89 c1                	mov    %eax,%ecx
  804968:	89 d8                	mov    %ebx,%eax
  80496a:	f7 f5                	div    %ebp
  80496c:	89 cf                	mov    %ecx,%edi
  80496e:	89 fa                	mov    %edi,%edx
  804970:	83 c4 1c             	add    $0x1c,%esp
  804973:	5b                   	pop    %ebx
  804974:	5e                   	pop    %esi
  804975:	5f                   	pop    %edi
  804976:	5d                   	pop    %ebp
  804977:	c3                   	ret    
  804978:	39 ce                	cmp    %ecx,%esi
  80497a:	77 28                	ja     8049a4 <__udivdi3+0x7c>
  80497c:	0f bd fe             	bsr    %esi,%edi
  80497f:	83 f7 1f             	xor    $0x1f,%edi
  804982:	75 40                	jne    8049c4 <__udivdi3+0x9c>
  804984:	39 ce                	cmp    %ecx,%esi
  804986:	72 0a                	jb     804992 <__udivdi3+0x6a>
  804988:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80498c:	0f 87 9e 00 00 00    	ja     804a30 <__udivdi3+0x108>
  804992:	b8 01 00 00 00       	mov    $0x1,%eax
  804997:	89 fa                	mov    %edi,%edx
  804999:	83 c4 1c             	add    $0x1c,%esp
  80499c:	5b                   	pop    %ebx
  80499d:	5e                   	pop    %esi
  80499e:	5f                   	pop    %edi
  80499f:	5d                   	pop    %ebp
  8049a0:	c3                   	ret    
  8049a1:	8d 76 00             	lea    0x0(%esi),%esi
  8049a4:	31 ff                	xor    %edi,%edi
  8049a6:	31 c0                	xor    %eax,%eax
  8049a8:	89 fa                	mov    %edi,%edx
  8049aa:	83 c4 1c             	add    $0x1c,%esp
  8049ad:	5b                   	pop    %ebx
  8049ae:	5e                   	pop    %esi
  8049af:	5f                   	pop    %edi
  8049b0:	5d                   	pop    %ebp
  8049b1:	c3                   	ret    
  8049b2:	66 90                	xchg   %ax,%ax
  8049b4:	89 d8                	mov    %ebx,%eax
  8049b6:	f7 f7                	div    %edi
  8049b8:	31 ff                	xor    %edi,%edi
  8049ba:	89 fa                	mov    %edi,%edx
  8049bc:	83 c4 1c             	add    $0x1c,%esp
  8049bf:	5b                   	pop    %ebx
  8049c0:	5e                   	pop    %esi
  8049c1:	5f                   	pop    %edi
  8049c2:	5d                   	pop    %ebp
  8049c3:	c3                   	ret    
  8049c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8049c9:	89 eb                	mov    %ebp,%ebx
  8049cb:	29 fb                	sub    %edi,%ebx
  8049cd:	89 f9                	mov    %edi,%ecx
  8049cf:	d3 e6                	shl    %cl,%esi
  8049d1:	89 c5                	mov    %eax,%ebp
  8049d3:	88 d9                	mov    %bl,%cl
  8049d5:	d3 ed                	shr    %cl,%ebp
  8049d7:	89 e9                	mov    %ebp,%ecx
  8049d9:	09 f1                	or     %esi,%ecx
  8049db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8049df:	89 f9                	mov    %edi,%ecx
  8049e1:	d3 e0                	shl    %cl,%eax
  8049e3:	89 c5                	mov    %eax,%ebp
  8049e5:	89 d6                	mov    %edx,%esi
  8049e7:	88 d9                	mov    %bl,%cl
  8049e9:	d3 ee                	shr    %cl,%esi
  8049eb:	89 f9                	mov    %edi,%ecx
  8049ed:	d3 e2                	shl    %cl,%edx
  8049ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049f3:	88 d9                	mov    %bl,%cl
  8049f5:	d3 e8                	shr    %cl,%eax
  8049f7:	09 c2                	or     %eax,%edx
  8049f9:	89 d0                	mov    %edx,%eax
  8049fb:	89 f2                	mov    %esi,%edx
  8049fd:	f7 74 24 0c          	divl   0xc(%esp)
  804a01:	89 d6                	mov    %edx,%esi
  804a03:	89 c3                	mov    %eax,%ebx
  804a05:	f7 e5                	mul    %ebp
  804a07:	39 d6                	cmp    %edx,%esi
  804a09:	72 19                	jb     804a24 <__udivdi3+0xfc>
  804a0b:	74 0b                	je     804a18 <__udivdi3+0xf0>
  804a0d:	89 d8                	mov    %ebx,%eax
  804a0f:	31 ff                	xor    %edi,%edi
  804a11:	e9 58 ff ff ff       	jmp    80496e <__udivdi3+0x46>
  804a16:	66 90                	xchg   %ax,%ax
  804a18:	8b 54 24 08          	mov    0x8(%esp),%edx
  804a1c:	89 f9                	mov    %edi,%ecx
  804a1e:	d3 e2                	shl    %cl,%edx
  804a20:	39 c2                	cmp    %eax,%edx
  804a22:	73 e9                	jae    804a0d <__udivdi3+0xe5>
  804a24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804a27:	31 ff                	xor    %edi,%edi
  804a29:	e9 40 ff ff ff       	jmp    80496e <__udivdi3+0x46>
  804a2e:	66 90                	xchg   %ax,%ax
  804a30:	31 c0                	xor    %eax,%eax
  804a32:	e9 37 ff ff ff       	jmp    80496e <__udivdi3+0x46>
  804a37:	90                   	nop

00804a38 <__umoddi3>:
  804a38:	55                   	push   %ebp
  804a39:	57                   	push   %edi
  804a3a:	56                   	push   %esi
  804a3b:	53                   	push   %ebx
  804a3c:	83 ec 1c             	sub    $0x1c,%esp
  804a3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804a43:	8b 74 24 34          	mov    0x34(%esp),%esi
  804a47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804a4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804a4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804a53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804a57:	89 f3                	mov    %esi,%ebx
  804a59:	89 fa                	mov    %edi,%edx
  804a5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a5f:	89 34 24             	mov    %esi,(%esp)
  804a62:	85 c0                	test   %eax,%eax
  804a64:	75 1a                	jne    804a80 <__umoddi3+0x48>
  804a66:	39 f7                	cmp    %esi,%edi
  804a68:	0f 86 a2 00 00 00    	jbe    804b10 <__umoddi3+0xd8>
  804a6e:	89 c8                	mov    %ecx,%eax
  804a70:	89 f2                	mov    %esi,%edx
  804a72:	f7 f7                	div    %edi
  804a74:	89 d0                	mov    %edx,%eax
  804a76:	31 d2                	xor    %edx,%edx
  804a78:	83 c4 1c             	add    $0x1c,%esp
  804a7b:	5b                   	pop    %ebx
  804a7c:	5e                   	pop    %esi
  804a7d:	5f                   	pop    %edi
  804a7e:	5d                   	pop    %ebp
  804a7f:	c3                   	ret    
  804a80:	39 f0                	cmp    %esi,%eax
  804a82:	0f 87 ac 00 00 00    	ja     804b34 <__umoddi3+0xfc>
  804a88:	0f bd e8             	bsr    %eax,%ebp
  804a8b:	83 f5 1f             	xor    $0x1f,%ebp
  804a8e:	0f 84 ac 00 00 00    	je     804b40 <__umoddi3+0x108>
  804a94:	bf 20 00 00 00       	mov    $0x20,%edi
  804a99:	29 ef                	sub    %ebp,%edi
  804a9b:	89 fe                	mov    %edi,%esi
  804a9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804aa1:	89 e9                	mov    %ebp,%ecx
  804aa3:	d3 e0                	shl    %cl,%eax
  804aa5:	89 d7                	mov    %edx,%edi
  804aa7:	89 f1                	mov    %esi,%ecx
  804aa9:	d3 ef                	shr    %cl,%edi
  804aab:	09 c7                	or     %eax,%edi
  804aad:	89 e9                	mov    %ebp,%ecx
  804aaf:	d3 e2                	shl    %cl,%edx
  804ab1:	89 14 24             	mov    %edx,(%esp)
  804ab4:	89 d8                	mov    %ebx,%eax
  804ab6:	d3 e0                	shl    %cl,%eax
  804ab8:	89 c2                	mov    %eax,%edx
  804aba:	8b 44 24 08          	mov    0x8(%esp),%eax
  804abe:	d3 e0                	shl    %cl,%eax
  804ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  804ac4:	8b 44 24 08          	mov    0x8(%esp),%eax
  804ac8:	89 f1                	mov    %esi,%ecx
  804aca:	d3 e8                	shr    %cl,%eax
  804acc:	09 d0                	or     %edx,%eax
  804ace:	d3 eb                	shr    %cl,%ebx
  804ad0:	89 da                	mov    %ebx,%edx
  804ad2:	f7 f7                	div    %edi
  804ad4:	89 d3                	mov    %edx,%ebx
  804ad6:	f7 24 24             	mull   (%esp)
  804ad9:	89 c6                	mov    %eax,%esi
  804adb:	89 d1                	mov    %edx,%ecx
  804add:	39 d3                	cmp    %edx,%ebx
  804adf:	0f 82 87 00 00 00    	jb     804b6c <__umoddi3+0x134>
  804ae5:	0f 84 91 00 00 00    	je     804b7c <__umoddi3+0x144>
  804aeb:	8b 54 24 04          	mov    0x4(%esp),%edx
  804aef:	29 f2                	sub    %esi,%edx
  804af1:	19 cb                	sbb    %ecx,%ebx
  804af3:	89 d8                	mov    %ebx,%eax
  804af5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804af9:	d3 e0                	shl    %cl,%eax
  804afb:	89 e9                	mov    %ebp,%ecx
  804afd:	d3 ea                	shr    %cl,%edx
  804aff:	09 d0                	or     %edx,%eax
  804b01:	89 e9                	mov    %ebp,%ecx
  804b03:	d3 eb                	shr    %cl,%ebx
  804b05:	89 da                	mov    %ebx,%edx
  804b07:	83 c4 1c             	add    $0x1c,%esp
  804b0a:	5b                   	pop    %ebx
  804b0b:	5e                   	pop    %esi
  804b0c:	5f                   	pop    %edi
  804b0d:	5d                   	pop    %ebp
  804b0e:	c3                   	ret    
  804b0f:	90                   	nop
  804b10:	89 fd                	mov    %edi,%ebp
  804b12:	85 ff                	test   %edi,%edi
  804b14:	75 0b                	jne    804b21 <__umoddi3+0xe9>
  804b16:	b8 01 00 00 00       	mov    $0x1,%eax
  804b1b:	31 d2                	xor    %edx,%edx
  804b1d:	f7 f7                	div    %edi
  804b1f:	89 c5                	mov    %eax,%ebp
  804b21:	89 f0                	mov    %esi,%eax
  804b23:	31 d2                	xor    %edx,%edx
  804b25:	f7 f5                	div    %ebp
  804b27:	89 c8                	mov    %ecx,%eax
  804b29:	f7 f5                	div    %ebp
  804b2b:	89 d0                	mov    %edx,%eax
  804b2d:	e9 44 ff ff ff       	jmp    804a76 <__umoddi3+0x3e>
  804b32:	66 90                	xchg   %ax,%ax
  804b34:	89 c8                	mov    %ecx,%eax
  804b36:	89 f2                	mov    %esi,%edx
  804b38:	83 c4 1c             	add    $0x1c,%esp
  804b3b:	5b                   	pop    %ebx
  804b3c:	5e                   	pop    %esi
  804b3d:	5f                   	pop    %edi
  804b3e:	5d                   	pop    %ebp
  804b3f:	c3                   	ret    
  804b40:	3b 04 24             	cmp    (%esp),%eax
  804b43:	72 06                	jb     804b4b <__umoddi3+0x113>
  804b45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804b49:	77 0f                	ja     804b5a <__umoddi3+0x122>
  804b4b:	89 f2                	mov    %esi,%edx
  804b4d:	29 f9                	sub    %edi,%ecx
  804b4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804b53:	89 14 24             	mov    %edx,(%esp)
  804b56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804b5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804b5e:	8b 14 24             	mov    (%esp),%edx
  804b61:	83 c4 1c             	add    $0x1c,%esp
  804b64:	5b                   	pop    %ebx
  804b65:	5e                   	pop    %esi
  804b66:	5f                   	pop    %edi
  804b67:	5d                   	pop    %ebp
  804b68:	c3                   	ret    
  804b69:	8d 76 00             	lea    0x0(%esi),%esi
  804b6c:	2b 04 24             	sub    (%esp),%eax
  804b6f:	19 fa                	sbb    %edi,%edx
  804b71:	89 d1                	mov    %edx,%ecx
  804b73:	89 c6                	mov    %eax,%esi
  804b75:	e9 71 ff ff ff       	jmp    804aeb <__umoddi3+0xb3>
  804b7a:	66 90                	xchg   %ax,%ax
  804b7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804b80:	72 ea                	jb     804b6c <__umoddi3+0x134>
  804b82:	89 d9                	mov    %ebx,%ecx
  804b84:	e9 62 ff ff ff       	jmp    804aeb <__umoddi3+0xb3>
