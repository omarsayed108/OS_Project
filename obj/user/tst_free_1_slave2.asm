
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 7a 12 00 00       	call   8012b0 <libmain>
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
  800067:	e8 ee 33 00 00       	call   80345a <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 31 34 00 00       	call   8034a5 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 b2 2c 00 00       	call   802d79 <malloc>
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
  8000df:	e8 76 33 00 00       	call   80345a <sys_calculate_free_frames>
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
  800125:	68 80 48 80 00       	push   $0x804880
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 4a 16 00 00       	call   80177b <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 6c 33 00 00       	call   8034a5 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 fc 48 80 00       	push   $0x8048fc
  800150:	6a 0c                	push   $0xc
  800152:	e8 24 16 00 00       	call   80177b <cprintf_colored>
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
  800174:	e8 e1 32 00 00       	call   80345a <sys_calculate_free_frames>
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
  8001b9:	e8 9c 32 00 00       	call   80345a <sys_calculate_free_frames>
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
  8001f8:	68 74 49 80 00       	push   $0x804974
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 77 15 00 00       	call   80177b <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 99 32 00 00       	call   8034a5 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 00 4a 80 00       	push   $0x804a00
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 4a 15 00 00       	call   80177b <cprintf_colored>
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
  800270:	e8 a7 35 00 00       	call   80381c <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 78 4a 80 00       	push   $0x804a78
  80028f:	6a 0c                	push   $0xc
  800291:	e8 e5 14 00 00       	call   80177b <cprintf_colored>
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
  8002ae:	e8 a7 31 00 00       	call   80345a <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 ea 31 00 00       	call   8034a5 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 2c 2c 00 00       	call   802efd <free>
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
  8002fc:	e8 a4 31 00 00       	call   8034a5 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 b0 4a 80 00       	push   $0x804ab0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 5c 14 00 00       	call   80177b <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 33 31 00 00       	call   80345a <sys_calculate_free_frames>
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
  80035f:	68 fc 4a 80 00       	push   $0x804afc
  800364:	6a 0c                	push   $0xc
  800366:	e8 10 14 00 00       	call   80177b <cprintf_colored>
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
  8003bd:	e8 5a 34 00 00       	call   80381c <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 58 4b 80 00       	push   $0x804b58
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 98 13 00 00       	call   80177b <cprintf_colored>
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
  800433:	68 90 4b 80 00       	push   $0x804b90
  800438:	6a 03                	push   $0x3
  80043a:	e8 3c 13 00 00       	call   80177b <cprintf_colored>
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
  8004fc:	68 c0 4b 80 00       	push   $0x804bc0
  800501:	6a 0c                	push   $0xc
  800503:	e8 73 12 00 00       	call   80177b <cprintf_colored>
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
  8005d6:	68 c0 4b 80 00       	push   $0x804bc0
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 99 11 00 00       	call   80177b <cprintf_colored>
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
  8006b0:	68 c0 4b 80 00       	push   $0x804bc0
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 bf 10 00 00       	call   80177b <cprintf_colored>
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
  80078a:	68 c0 4b 80 00       	push   $0x804bc0
  80078f:	6a 0c                	push   $0xc
  800791:	e8 e5 0f 00 00       	call   80177b <cprintf_colored>
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
  800864:	68 c0 4b 80 00       	push   $0x804bc0
  800869:	6a 0c                	push   $0xc
  80086b:	e8 0b 0f 00 00       	call   80177b <cprintf_colored>
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
  80093e:	68 c0 4b 80 00       	push   $0x804bc0
  800943:	6a 0c                	push   $0xc
  800945:	e8 31 0e 00 00       	call   80177b <cprintf_colored>
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
  800a33:	68 c0 4b 80 00       	push   $0x804bc0
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 3c 0d 00 00       	call   80177b <cprintf_colored>
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
  800b31:	68 c0 4b 80 00       	push   $0x804bc0
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 3e 0c 00 00       	call   80177b <cprintf_colored>
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
  800c2f:	68 c0 4b 80 00       	push   $0x804bc0
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 40 0b 00 00       	call   80177b <cprintf_colored>
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
  800d2d:	68 c0 4b 80 00       	push   $0x804bc0
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 42 0a 00 00       	call   80177b <cprintf_colored>
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
  800e1a:	68 c0 4b 80 00       	push   $0x804bc0
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 55 09 00 00       	call   80177b <cprintf_colored>
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
  800f07:	68 c0 4b 80 00       	push   $0x804bc0
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 68 08 00 00       	call   80177b <cprintf_colored>
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
  800ff4:	68 c0 4b 80 00       	push   $0x804bc0
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 7b 07 00 00       	call   80177b <cprintf_colored>
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
  801017:	68 12 4c 80 00       	push   $0x804c12
  80101c:	6a 03                	push   $0x3
  80101e:	e8 58 07 00 00       	call   80177b <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 1e 24 00 00       	call   80345a <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 5e 24 00 00       	call   8034a5 <sys_pf_calculate_allocated_pages>
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
  801072:	e8 02 1d 00 00       	call   802d79 <malloc>
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
  8010a1:	68 30 4c 80 00       	push   $0x804c30
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 ce 06 00 00       	call   80177b <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 f0 23 00 00       	call   8034a5 <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 6c 4c 80 00       	push   $0x804c6c
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 a2 06 00 00       	call   80177b <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 79 23 00 00       	call   80345a <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 dc 4c 80 00       	push   $0x804cdc
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 76 06 00 00       	call   80177b <cprintf_colored>
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
  801120:	81 ec 84 00 00 00    	sub    $0x84,%esp
#if USE_KHEAP

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
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
  801143:	68 24 4d 80 00       	push   $0x804d24
  801148:	6a 13                	push   $0x13
  80114a:	68 40 4d 80 00       	push   $0x804d40
  80114f:	e8 0c 03 00 00       	call   801460 <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#endif
	uint32 expectedVA = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801154:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	//malloc some spaces
	int i, freeFrames, usedDiskPages, expectedNumOfTables ;
	uint32 size = 0;
  80115b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char* ptr;
	int sums[20] = {0};
  801162:	8d 55 80             	lea    -0x80(%ebp),%edx
  801165:	b9 14 00 00 00       	mov    $0x14,%ecx
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
  80116f:	89 d7                	mov    %edx,%edi
  801171:	f3 ab                	rep stos %eax,%es:(%edi)
	totalRequestedSize = 0;
  801173:	c7 05 40 e2 81 00 00 	movl   $0x0,0x81e240
  80117a:	00 00 00 

	int eval = 0;
  80117d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool correct ;

	correct = 1;
  801184:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)

	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			allocIndex = 0;
  80118b:	c7 05 4c e2 81 00 00 	movl   $0x0,0x81e24c
  801192:	00 00 00 
			expectedVA += ROUNDUP(size, PAGE_SIZE);
  801195:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80119c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80119f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a2:	01 d0                	add    %edx,%eax
  8011a4:	48                   	dec    %eax
  8011a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b0:	f7 75 e4             	divl   -0x1c(%ebp)
  8011b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b6:	29 d0                	sub    %edx,%eax
  8011b8:	01 45 f4             	add    %eax,-0xc(%ebp)
			size = 2*Mega - kilo;
  8011bb:	c7 45 f0 00 fc 1f 00 	movl   $0x1ffc00,-0x10(%ebp)
			totalRequestedSize += ROUNDUP(size, PAGE_SIZE);
  8011c2:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8011c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	48                   	dec    %eax
  8011d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011dd:	f7 75 dc             	divl   -0x24(%ebp)
  8011e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011e3:	29 d0                	sub    %edx,%eax
  8011e5:	89 c2                	mov    %eax,%edx
  8011e7:	a1 40 e2 81 00       	mov    0x81e240,%eax
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	a3 40 e2 81 00       	mov    %eax,0x81e240
			expectedNumOfTables = 1;
  8011f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			correct = allocSpaceInPageAlloc(allocIndex, size, 1, expectedNumOfTables);
  8011fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8011fd:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801202:	52                   	push   %edx
  801203:	6a 01                	push   $0x1
  801205:	ff 75 f0             	pushl  -0x10(%ebp)
  801208:	50                   	push   %eax
  801209:	e8 4b ee ff ff       	call   800059 <allocSpaceInPageAlloc>
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if ((uint32) ptr_allocations[allocIndex] != (expectedVA)) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong start address for the allocated space... Expected = %x, Actual = %x\n", allocIndex, expectedVA, ptr_allocations[allocIndex]); }
  801214:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801219:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801220:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801223:	74 2f                	je     801254 <_main+0x138>
  801225:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80122c:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801231:	8b 14 85 20 60 80 00 	mov    0x806020(,%eax,4),%edx
  801238:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	52                   	push   %edx
  801241:	ff 75 f4             	pushl  -0xc(%ebp)
  801244:	50                   	push   %eax
  801245:	68 c0 4b 80 00       	push   $0x804bc0
  80124a:	6a 0c                	push   $0xc
  80124c:	e8 2a 05 00 00       	call   80177b <cprintf_colored>
  801251:	83 c4 20             	add    $0x20,%esp

	//FREE IT
	{
		//Free 2 MB
		{
			correct = freeSpaceInPageAlloc(0, 1);
  801254:	83 ec 08             	sub    $0x8,%esp
  801257:	6a 01                	push   $0x1
  801259:	6a 00                	push   $0x0
  80125b:	e8 41 f0 ff ff       	call   8002a1 <freeSpaceInPageAlloc>
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
	}
	if (!correct)
  801266:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80126a:	74 3e                	je     8012aa <_main+0x18e>
	{
		return;
	}

	inctst(); //to ensure that it reached here
  80126c:	e8 f0 24 00 00       	call   803761 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  801271:	90                   	nop
  801272:	e8 04 25 00 00       	call   80377b <gettst>
  801277:	83 f8 03             	cmp    $0x3,%eax
  80127a:	75 f6                	jne    801272 <_main+0x156>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		char* byteArr = (char *) ptr_allocations[allocIndex];
  80127c:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801281:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801288:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = maxByte ;
  80128b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80128e:	c6 00 7f             	movb   $0x7f,(%eax)
		inctst();
  801291:	e8 cb 24 00 00       	call   803761 <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	68 5c 4d 80 00       	push   $0x804d5c
  80129e:	6a 4c                	push   $0x4c
  8012a0:	68 40 4d 80 00       	push   $0x804d40
  8012a5:	e8 b6 01 00 00       	call   801460 <_panic>
			correct = freeSpaceInPageAlloc(0, 1);
		}
	}
	if (!correct)
	{
		return;
  8012aa:	90                   	nop
		inctst();
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
	}

	return;
}
  8012ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8012b9:	e8 65 23 00 00       	call   803623 <sys_getenvindex>
  8012be:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8012c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012c4:	89 d0                	mov    %edx,%eax
  8012c6:	01 c0                	add    %eax,%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c1 e0 02             	shl    $0x2,%eax
  8012cd:	01 d0                	add    %edx,%eax
  8012cf:	c1 e0 02             	shl    $0x2,%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	c1 e0 03             	shl    $0x3,%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	c1 e0 02             	shl    $0x2,%eax
  8012dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012e1:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8012e6:	a1 00 62 80 00       	mov    0x806200,%eax
  8012eb:	8a 40 20             	mov    0x20(%eax),%al
  8012ee:	84 c0                	test   %al,%al
  8012f0:	74 0d                	je     8012ff <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8012f2:	a1 00 62 80 00       	mov    0x806200,%eax
  8012f7:	83 c0 20             	add    $0x20,%eax
  8012fa:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801303:	7e 0a                	jle    80130f <libmain+0x5f>
		binaryname = argv[0];
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	8b 00                	mov    (%eax),%eax
  80130a:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80130f:	83 ec 08             	sub    $0x8,%esp
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	ff 75 08             	pushl  0x8(%ebp)
  801318:	e8 ff fd ff ff       	call   80111c <_main>
  80131d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801320:	a1 00 60 80 00       	mov    0x806000,%eax
  801325:	85 c0                	test   %eax,%eax
  801327:	0f 84 01 01 00 00    	je     80142e <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80132d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801333:	bb a0 4e 80 00       	mov    $0x804ea0,%ebx
  801338:	ba 0e 00 00 00       	mov    $0xe,%edx
  80133d:	89 c7                	mov    %eax,%edi
  80133f:	89 de                	mov    %ebx,%esi
  801341:	89 d1                	mov    %edx,%ecx
  801343:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801345:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801348:	b9 56 00 00 00       	mov    $0x56,%ecx
  80134d:	b0 00                	mov    $0x0,%al
  80134f:	89 d7                	mov    %edx,%edi
  801351:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801353:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80135a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	50                   	push   %eax
  801361:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801367:	50                   	push   %eax
  801368:	e8 ec 24 00 00       	call   803859 <sys_utilities>
  80136d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801370:	e8 35 20 00 00       	call   8033aa <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	68 c0 4d 80 00       	push   $0x804dc0
  80137d:	e8 cc 03 00 00       	call   80174e <cprintf>
  801382:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801385:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801388:	85 c0                	test   %eax,%eax
  80138a:	74 18                	je     8013a4 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80138c:	e8 e6 24 00 00       	call   803877 <sys_get_optimal_num_faults>
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	50                   	push   %eax
  801395:	68 e8 4d 80 00       	push   $0x804de8
  80139a:	e8 af 03 00 00       	call   80174e <cprintf>
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	eb 59                	jmp    8013fd <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8013a4:	a1 00 62 80 00       	mov    0x806200,%eax
  8013a9:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8013af:	a1 00 62 80 00       	mov    0x806200,%eax
  8013b4:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8013ba:	83 ec 04             	sub    $0x4,%esp
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 0c 4e 80 00       	push   $0x804e0c
  8013c4:	e8 85 03 00 00       	call   80174e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8013cc:	a1 00 62 80 00       	mov    0x806200,%eax
  8013d1:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8013d7:	a1 00 62 80 00       	mov    0x806200,%eax
  8013dc:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8013e2:	a1 00 62 80 00       	mov    0x806200,%eax
  8013e7:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8013ed:	51                   	push   %ecx
  8013ee:	52                   	push   %edx
  8013ef:	50                   	push   %eax
  8013f0:	68 34 4e 80 00       	push   $0x804e34
  8013f5:	e8 54 03 00 00       	call   80174e <cprintf>
  8013fa:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013fd:	a1 00 62 80 00       	mov    0x806200,%eax
  801402:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	50                   	push   %eax
  80140c:	68 8c 4e 80 00       	push   $0x804e8c
  801411:	e8 38 03 00 00       	call   80174e <cprintf>
  801416:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801419:	83 ec 0c             	sub    $0xc,%esp
  80141c:	68 c0 4d 80 00       	push   $0x804dc0
  801421:	e8 28 03 00 00       	call   80174e <cprintf>
  801426:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801429:	e8 96 1f 00 00       	call   8033c4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80142e:	e8 1f 00 00 00       	call   801452 <exit>
}
  801433:	90                   	nop
  801434:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801437:	5b                   	pop    %ebx
  801438:	5e                   	pop    %esi
  801439:	5f                   	pop    %edi
  80143a:	5d                   	pop    %ebp
  80143b:	c3                   	ret    

0080143c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801442:	83 ec 0c             	sub    $0xc,%esp
  801445:	6a 00                	push   $0x0
  801447:	e8 a3 21 00 00       	call   8035ef <sys_destroy_env>
  80144c:	83 c4 10             	add    $0x10,%esp
}
  80144f:	90                   	nop
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <exit>:

void
exit(void)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801458:	e8 f8 21 00 00       	call   803655 <sys_exit_env>
}
  80145d:	90                   	nop
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801466:	8d 45 10             	lea    0x10(%ebp),%eax
  801469:	83 c0 04             	add    $0x4,%eax
  80146c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80146f:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801474:	85 c0                	test   %eax,%eax
  801476:	74 16                	je     80148e <_panic+0x2e>
		cprintf("%s: ", argv0);
  801478:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  80147d:	83 ec 08             	sub    $0x8,%esp
  801480:	50                   	push   %eax
  801481:	68 04 4f 80 00       	push   $0x804f04
  801486:	e8 c3 02 00 00       	call   80174e <cprintf>
  80148b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80148e:	a1 04 60 80 00       	mov    0x806004,%eax
  801493:	83 ec 0c             	sub    $0xc,%esp
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	ff 75 08             	pushl  0x8(%ebp)
  80149c:	50                   	push   %eax
  80149d:	68 0c 4f 80 00       	push   $0x804f0c
  8014a2:	6a 74                	push   $0x74
  8014a4:	e8 d2 02 00 00       	call   80177b <cprintf_colored>
  8014a9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b5:	50                   	push   %eax
  8014b6:	e8 24 02 00 00       	call   8016df <vcprintf>
  8014bb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	6a 00                	push   $0x0
  8014c3:	68 34 4f 80 00       	push   $0x804f34
  8014c8:	e8 12 02 00 00       	call   8016df <vcprintf>
  8014cd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8014d0:	e8 7d ff ff ff       	call   801452 <exit>

	// should not return here
	while (1) ;
  8014d5:	eb fe                	jmp    8014d5 <_panic+0x75>

008014d7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	53                   	push   %ebx
  8014db:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014de:	a1 00 62 80 00       	mov    0x806200,%eax
  8014e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8014e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ec:	39 c2                	cmp    %eax,%edx
  8014ee:	74 14                	je     801504 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	68 38 4f 80 00       	push   $0x804f38
  8014f8:	6a 26                	push   $0x26
  8014fa:	68 84 4f 80 00       	push   $0x804f84
  8014ff:	e8 5c ff ff ff       	call   801460 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80150b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801512:	e9 d9 00 00 00       	jmp    8015f0 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	01 d0                	add    %edx,%eax
  801526:	8b 00                	mov    (%eax),%eax
  801528:	85 c0                	test   %eax,%eax
  80152a:	75 08                	jne    801534 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80152c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80152f:	e9 b9 00 00 00       	jmp    8015ed <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  801534:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80153b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801542:	eb 79                	jmp    8015bd <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801544:	a1 00 62 80 00       	mov    0x806200,%eax
  801549:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80154f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801552:	89 d0                	mov    %edx,%eax
  801554:	01 c0                	add    %eax,%eax
  801556:	01 d0                	add    %edx,%eax
  801558:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80155f:	01 d8                	add    %ebx,%eax
  801561:	01 d0                	add    %edx,%eax
  801563:	01 c8                	add    %ecx,%eax
  801565:	8a 40 04             	mov    0x4(%eax),%al
  801568:	84 c0                	test   %al,%al
  80156a:	75 4e                	jne    8015ba <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80156c:	a1 00 62 80 00       	mov    0x806200,%eax
  801571:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801577:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	01 c0                	add    %eax,%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801587:	01 d8                	add    %ebx,%eax
  801589:	01 d0                	add    %edx,%eax
  80158b:	01 c8                	add    %ecx,%eax
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801592:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80159c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	01 c8                	add    %ecx,%eax
  8015ab:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8015ad:	39 c2                	cmp    %eax,%edx
  8015af:	75 09                	jne    8015ba <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8015b1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8015b8:	eb 19                	jmp    8015d3 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ba:	ff 45 e8             	incl   -0x18(%ebp)
  8015bd:	a1 00 62 80 00       	mov    0x806200,%eax
  8015c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8015c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015cb:	39 c2                	cmp    %eax,%edx
  8015cd:	0f 87 71 ff ff ff    	ja     801544 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8015d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d7:	75 14                	jne    8015ed <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 90 4f 80 00       	push   $0x804f90
  8015e1:	6a 3a                	push   $0x3a
  8015e3:	68 84 4f 80 00       	push   $0x804f84
  8015e8:	e8 73 fe ff ff       	call   801460 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8015ed:	ff 45 f0             	incl   -0x10(%ebp)
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8015f6:	0f 8c 1b ff ff ff    	jl     801517 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801603:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80160a:	eb 2e                	jmp    80163a <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80160c:	a1 00 62 80 00       	mov    0x806200,%eax
  801611:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801617:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80161a:	89 d0                	mov    %edx,%eax
  80161c:	01 c0                	add    %eax,%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801627:	01 d8                	add    %ebx,%eax
  801629:	01 d0                	add    %edx,%eax
  80162b:	01 c8                	add    %ecx,%eax
  80162d:	8a 40 04             	mov    0x4(%eax),%al
  801630:	3c 01                	cmp    $0x1,%al
  801632:	75 03                	jne    801637 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  801634:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801637:	ff 45 e0             	incl   -0x20(%ebp)
  80163a:	a1 00 62 80 00       	mov    0x806200,%eax
  80163f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801648:	39 c2                	cmp    %eax,%edx
  80164a:	77 c0                	ja     80160c <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801652:	74 14                	je     801668 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	68 e4 4f 80 00       	push   $0x804fe4
  80165c:	6a 44                	push   $0x44
  80165e:	68 84 4f 80 00       	push   $0x804f84
  801663:	e8 f8 fd ff ff       	call   801460 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801668:	90                   	nop
  801669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	53                   	push   %ebx
  801672:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801675:	8b 45 0c             	mov    0xc(%ebp),%eax
  801678:	8b 00                	mov    (%eax),%eax
  80167a:	8d 48 01             	lea    0x1(%eax),%ecx
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	89 0a                	mov    %ecx,(%edx)
  801682:	8b 55 08             	mov    0x8(%ebp),%edx
  801685:	88 d1                	mov    %dl,%cl
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80168e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801691:	8b 00                	mov    (%eax),%eax
  801693:	3d ff 00 00 00       	cmp    $0xff,%eax
  801698:	75 30                	jne    8016ca <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80169a:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  8016a0:	a0 24 62 80 00       	mov    0x806224,%al
  8016a5:	0f b6 c0             	movzbl %al,%eax
  8016a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ab:	8b 09                	mov    (%ecx),%ecx
  8016ad:	89 cb                	mov    %ecx,%ebx
  8016af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b2:	83 c1 08             	add    $0x8,%ecx
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	53                   	push   %ebx
  8016b8:	51                   	push   %ecx
  8016b9:	e8 a8 1c 00 00       	call   803366 <sys_cputs>
  8016be:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	8b 40 04             	mov    0x4(%eax),%eax
  8016d0:	8d 50 01             	lea    0x1(%eax),%edx
  8016d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8016d9:	90                   	nop
  8016da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016ef:	00 00 00 
	b.cnt = 0;
  8016f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016f9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801708:	50                   	push   %eax
  801709:	68 6e 16 80 00       	push   $0x80166e
  80170e:	e8 5a 02 00 00       	call   80196d <vprintfmt>
  801713:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801716:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  80171c:	a0 24 62 80 00       	mov    0x806224,%al
  801721:	0f b6 c0             	movzbl %al,%eax
  801724:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	51                   	push   %ecx
  80172d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801733:	83 c0 08             	add    $0x8,%eax
  801736:	50                   	push   %eax
  801737:	e8 2a 1c 00 00       	call   803366 <sys_cputs>
  80173c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80173f:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  801746:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801754:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  80175b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80175e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	83 ec 08             	sub    $0x8,%esp
  801767:	ff 75 f4             	pushl  -0xc(%ebp)
  80176a:	50                   	push   %eax
  80176b:	e8 6f ff ff ff       	call   8016df <vcprintf>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801776:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801781:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	c1 e0 08             	shl    $0x8,%eax
  80178e:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  801793:	8d 45 0c             	lea    0xc(%ebp),%eax
  801796:	83 c0 04             	add    $0x4,%eax
  801799:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80179c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a5:	50                   	push   %eax
  8017a6:	e8 34 ff ff ff       	call   8016df <vcprintf>
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8017b1:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  8017b8:	07 00 00 

	return cnt;
  8017bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8017c6:	e8 df 1b 00 00       	call   8033aa <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8017cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8017ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017da:	50                   	push   %eax
  8017db:	e8 ff fe ff ff       	call   8016df <vcprintf>
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8017e6:	e8 d9 1b 00 00       	call   8033c4 <sys_unlock_cons>
	return cnt;
  8017eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 14             	sub    $0x14,%esp
  8017f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801800:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801803:	8b 45 18             	mov    0x18(%ebp),%eax
  801806:	ba 00 00 00 00       	mov    $0x0,%edx
  80180b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80180e:	77 55                	ja     801865 <printnum+0x75>
  801810:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801813:	72 05                	jb     80181a <printnum+0x2a>
  801815:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801818:	77 4b                	ja     801865 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80181a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80181d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801820:	8b 45 18             	mov    0x18(%ebp),%eax
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	52                   	push   %edx
  801829:	50                   	push   %eax
  80182a:	ff 75 f4             	pushl  -0xc(%ebp)
  80182d:	ff 75 f0             	pushl  -0x10(%ebp)
  801830:	e8 d3 2d 00 00       	call   804608 <__udivdi3>
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	ff 75 20             	pushl  0x20(%ebp)
  80183e:	53                   	push   %ebx
  80183f:	ff 75 18             	pushl  0x18(%ebp)
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	e8 a1 ff ff ff       	call   8017f0 <printnum>
  80184f:	83 c4 20             	add    $0x20,%esp
  801852:	eb 1a                	jmp    80186e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801854:	83 ec 08             	sub    $0x8,%esp
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	ff 75 20             	pushl  0x20(%ebp)
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	ff d0                	call   *%eax
  801862:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801865:	ff 4d 1c             	decl   0x1c(%ebp)
  801868:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80186c:	7f e6                	jg     801854 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80186e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801871:	bb 00 00 00 00       	mov    $0x0,%ebx
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187c:	53                   	push   %ebx
  80187d:	51                   	push   %ecx
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	e8 93 2e 00 00       	call   804718 <__umoddi3>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	05 54 52 80 00       	add    $0x805254,%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	0f be c0             	movsbl %al,%eax
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	50                   	push   %eax
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	ff d0                	call   *%eax
  80189e:	83 c4 10             	add    $0x10,%esp
}
  8018a1:	90                   	nop
  8018a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8018aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8018ae:	7e 1c                	jle    8018cc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	8d 50 08             	lea    0x8(%eax),%edx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	89 10                	mov    %edx,(%eax)
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	8b 00                	mov    (%eax),%eax
  8018c2:	83 e8 08             	sub    $0x8,%eax
  8018c5:	8b 50 04             	mov    0x4(%eax),%edx
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	eb 40                	jmp    80190c <getuint+0x65>
	else if (lflag)
  8018cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018d0:	74 1e                	je     8018f0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	8b 00                	mov    (%eax),%eax
  8018d7:	8d 50 04             	lea    0x4(%eax),%edx
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	89 10                	mov    %edx,(%eax)
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8b 00                	mov    (%eax),%eax
  8018e4:	83 e8 04             	sub    $0x4,%eax
  8018e7:	8b 00                	mov    (%eax),%eax
  8018e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ee:	eb 1c                	jmp    80190c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8b 00                	mov    (%eax),%eax
  8018f5:	8d 50 04             	lea    0x4(%eax),%edx
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	89 10                	mov    %edx,(%eax)
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8b 00                	mov    (%eax),%eax
  801902:	83 e8 04             	sub    $0x4,%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    

0080190e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801911:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801915:	7e 1c                	jle    801933 <getint+0x25>
		return va_arg(*ap, long long);
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	8b 00                	mov    (%eax),%eax
  80191c:	8d 50 08             	lea    0x8(%eax),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	89 10                	mov    %edx,(%eax)
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	8b 00                	mov    (%eax),%eax
  801929:	83 e8 08             	sub    $0x8,%eax
  80192c:	8b 50 04             	mov    0x4(%eax),%edx
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	eb 38                	jmp    80196b <getint+0x5d>
	else if (lflag)
  801933:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801937:	74 1a                	je     801953 <getint+0x45>
		return va_arg(*ap, long);
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8b 00                	mov    (%eax),%eax
  80193e:	8d 50 04             	lea    0x4(%eax),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	89 10                	mov    %edx,(%eax)
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	8b 00                	mov    (%eax),%eax
  80194b:	83 e8 04             	sub    $0x4,%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	99                   	cltd   
  801951:	eb 18                	jmp    80196b <getint+0x5d>
	else
		return va_arg(*ap, int);
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 00                	mov    (%eax),%eax
  801958:	8d 50 04             	lea    0x4(%eax),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	89 10                	mov    %edx,(%eax)
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	83 e8 04             	sub    $0x4,%eax
  801968:	8b 00                	mov    (%eax),%eax
  80196a:	99                   	cltd   
}
  80196b:	5d                   	pop    %ebp
  80196c:	c3                   	ret    

0080196d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
  801972:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801975:	eb 17                	jmp    80198e <vprintfmt+0x21>
			if (ch == '\0')
  801977:	85 db                	test   %ebx,%ebx
  801979:	0f 84 c1 03 00 00    	je     801d40 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80197f:	83 ec 08             	sub    $0x8,%esp
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	53                   	push   %ebx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	ff d0                	call   *%eax
  80198b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80198e:	8b 45 10             	mov    0x10(%ebp),%eax
  801991:	8d 50 01             	lea    0x1(%eax),%edx
  801994:	89 55 10             	mov    %edx,0x10(%ebp)
  801997:	8a 00                	mov    (%eax),%al
  801999:	0f b6 d8             	movzbl %al,%ebx
  80199c:	83 fb 25             	cmp    $0x25,%ebx
  80199f:	75 d6                	jne    801977 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8019a1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8019a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8019ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8019b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8019ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8019c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c4:	8d 50 01             	lea    0x1(%eax),%edx
  8019c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	0f b6 d8             	movzbl %al,%ebx
  8019cf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8019d2:	83 f8 5b             	cmp    $0x5b,%eax
  8019d5:	0f 87 3d 03 00 00    	ja     801d18 <vprintfmt+0x3ab>
  8019db:	8b 04 85 78 52 80 00 	mov    0x805278(,%eax,4),%eax
  8019e2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8019e4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8019e8:	eb d7                	jmp    8019c1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8019ea:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8019ee:	eb d1                	jmp    8019c1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8019f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019fa:	89 d0                	mov    %edx,%eax
  8019fc:	c1 e0 02             	shl    $0x2,%eax
  8019ff:	01 d0                	add    %edx,%eax
  801a01:	01 c0                	add    %eax,%eax
  801a03:	01 d8                	add    %ebx,%eax
  801a05:	83 e8 30             	sub    $0x30,%eax
  801a08:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801a13:	83 fb 2f             	cmp    $0x2f,%ebx
  801a16:	7e 3e                	jle    801a56 <vprintfmt+0xe9>
  801a18:	83 fb 39             	cmp    $0x39,%ebx
  801a1b:	7f 39                	jg     801a56 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a1d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801a20:	eb d5                	jmp    8019f7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	83 c0 04             	add    $0x4,%eax
  801a28:	89 45 14             	mov    %eax,0x14(%ebp)
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	83 e8 04             	sub    $0x4,%eax
  801a31:	8b 00                	mov    (%eax),%eax
  801a33:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801a36:	eb 1f                	jmp    801a57 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801a38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a3c:	79 83                	jns    8019c1 <vprintfmt+0x54>
				width = 0;
  801a3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801a45:	e9 77 ff ff ff       	jmp    8019c1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801a4a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801a51:	e9 6b ff ff ff       	jmp    8019c1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801a56:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a5b:	0f 89 60 ff ff ff    	jns    8019c1 <vprintfmt+0x54>
				width = precision, precision = -1;
  801a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a67:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801a6e:	e9 4e ff ff ff       	jmp    8019c1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a73:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801a76:	e9 46 ff ff ff       	jmp    8019c1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7e:	83 c0 04             	add    $0x4,%eax
  801a81:	89 45 14             	mov    %eax,0x14(%ebp)
  801a84:	8b 45 14             	mov    0x14(%ebp),%eax
  801a87:	83 e8 04             	sub    $0x4,%eax
  801a8a:	8b 00                	mov    (%eax),%eax
  801a8c:	83 ec 08             	sub    $0x8,%esp
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	50                   	push   %eax
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	ff d0                	call   *%eax
  801a98:	83 c4 10             	add    $0x10,%esp
			break;
  801a9b:	e9 9b 02 00 00       	jmp    801d3b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa3:	83 c0 04             	add    $0x4,%eax
  801aa6:	89 45 14             	mov    %eax,0x14(%ebp)
  801aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  801aac:	83 e8 04             	sub    $0x4,%eax
  801aaf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801ab1:	85 db                	test   %ebx,%ebx
  801ab3:	79 02                	jns    801ab7 <vprintfmt+0x14a>
				err = -err;
  801ab5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801ab7:	83 fb 64             	cmp    $0x64,%ebx
  801aba:	7f 0b                	jg     801ac7 <vprintfmt+0x15a>
  801abc:	8b 34 9d c0 50 80 00 	mov    0x8050c0(,%ebx,4),%esi
  801ac3:	85 f6                	test   %esi,%esi
  801ac5:	75 19                	jne    801ae0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801ac7:	53                   	push   %ebx
  801ac8:	68 65 52 80 00       	push   $0x805265
  801acd:	ff 75 0c             	pushl  0xc(%ebp)
  801ad0:	ff 75 08             	pushl  0x8(%ebp)
  801ad3:	e8 70 02 00 00       	call   801d48 <printfmt>
  801ad8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801adb:	e9 5b 02 00 00       	jmp    801d3b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801ae0:	56                   	push   %esi
  801ae1:	68 6e 52 80 00       	push   $0x80526e
  801ae6:	ff 75 0c             	pushl  0xc(%ebp)
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	e8 57 02 00 00       	call   801d48 <printfmt>
  801af1:	83 c4 10             	add    $0x10,%esp
			break;
  801af4:	e9 42 02 00 00       	jmp    801d3b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801af9:	8b 45 14             	mov    0x14(%ebp),%eax
  801afc:	83 c0 04             	add    $0x4,%eax
  801aff:	89 45 14             	mov    %eax,0x14(%ebp)
  801b02:	8b 45 14             	mov    0x14(%ebp),%eax
  801b05:	83 e8 04             	sub    $0x4,%eax
  801b08:	8b 30                	mov    (%eax),%esi
  801b0a:	85 f6                	test   %esi,%esi
  801b0c:	75 05                	jne    801b13 <vprintfmt+0x1a6>
				p = "(null)";
  801b0e:	be 71 52 80 00       	mov    $0x805271,%esi
			if (width > 0 && padc != '-')
  801b13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b17:	7e 6d                	jle    801b86 <vprintfmt+0x219>
  801b19:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801b1d:	74 67                	je     801b86 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b22:	83 ec 08             	sub    $0x8,%esp
  801b25:	50                   	push   %eax
  801b26:	56                   	push   %esi
  801b27:	e8 1e 03 00 00       	call   801e4a <strnlen>
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801b32:	eb 16                	jmp    801b4a <vprintfmt+0x1dd>
					putch(padc, putdat);
  801b34:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801b38:	83 ec 08             	sub    $0x8,%esp
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	50                   	push   %eax
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	ff d0                	call   *%eax
  801b44:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b47:	ff 4d e4             	decl   -0x1c(%ebp)
  801b4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b4e:	7f e4                	jg     801b34 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b50:	eb 34                	jmp    801b86 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801b52:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b56:	74 1c                	je     801b74 <vprintfmt+0x207>
  801b58:	83 fb 1f             	cmp    $0x1f,%ebx
  801b5b:	7e 05                	jle    801b62 <vprintfmt+0x1f5>
  801b5d:	83 fb 7e             	cmp    $0x7e,%ebx
  801b60:	7e 12                	jle    801b74 <vprintfmt+0x207>
					putch('?', putdat);
  801b62:	83 ec 08             	sub    $0x8,%esp
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	6a 3f                	push   $0x3f
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	ff d0                	call   *%eax
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	eb 0f                	jmp    801b83 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801b74:	83 ec 08             	sub    $0x8,%esp
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	53                   	push   %ebx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	ff d0                	call   *%eax
  801b80:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b83:	ff 4d e4             	decl   -0x1c(%ebp)
  801b86:	89 f0                	mov    %esi,%eax
  801b88:	8d 70 01             	lea    0x1(%eax),%esi
  801b8b:	8a 00                	mov    (%eax),%al
  801b8d:	0f be d8             	movsbl %al,%ebx
  801b90:	85 db                	test   %ebx,%ebx
  801b92:	74 24                	je     801bb8 <vprintfmt+0x24b>
  801b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b98:	78 b8                	js     801b52 <vprintfmt+0x1e5>
  801b9a:	ff 4d e0             	decl   -0x20(%ebp)
  801b9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ba1:	79 af                	jns    801b52 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ba3:	eb 13                	jmp    801bb8 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ba5:	83 ec 08             	sub    $0x8,%esp
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	6a 20                	push   $0x20
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	ff d0                	call   *%eax
  801bb2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801bb5:	ff 4d e4             	decl   -0x1c(%ebp)
  801bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bbc:	7f e7                	jg     801ba5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801bbe:	e9 78 01 00 00       	jmp    801d3b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801bc3:	83 ec 08             	sub    $0x8,%esp
  801bc6:	ff 75 e8             	pushl  -0x18(%ebp)
  801bc9:	8d 45 14             	lea    0x14(%ebp),%eax
  801bcc:	50                   	push   %eax
  801bcd:	e8 3c fd ff ff       	call   80190e <getint>
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be1:	85 d2                	test   %edx,%edx
  801be3:	79 23                	jns    801c08 <vprintfmt+0x29b>
				putch('-', putdat);
  801be5:	83 ec 08             	sub    $0x8,%esp
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	6a 2d                	push   $0x2d
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	ff d0                	call   *%eax
  801bf2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfb:	f7 d8                	neg    %eax
  801bfd:	83 d2 00             	adc    $0x0,%edx
  801c00:	f7 da                	neg    %edx
  801c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801c0f:	e9 bc 00 00 00       	jmp    801cd0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801c14:	83 ec 08             	sub    $0x8,%esp
  801c17:	ff 75 e8             	pushl  -0x18(%ebp)
  801c1a:	8d 45 14             	lea    0x14(%ebp),%eax
  801c1d:	50                   	push   %eax
  801c1e:	e8 84 fc ff ff       	call   8018a7 <getuint>
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801c2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801c33:	e9 98 00 00 00       	jmp    801cd0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801c38:	83 ec 08             	sub    $0x8,%esp
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	6a 58                	push   $0x58
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	ff d0                	call   *%eax
  801c45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	6a 58                	push   $0x58
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	ff d0                	call   *%eax
  801c55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801c58:	83 ec 08             	sub    $0x8,%esp
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	6a 58                	push   $0x58
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	ff d0                	call   *%eax
  801c65:	83 c4 10             	add    $0x10,%esp
			break;
  801c68:	e9 ce 00 00 00       	jmp    801d3b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801c6d:	83 ec 08             	sub    $0x8,%esp
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	6a 30                	push   $0x30
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	ff d0                	call   *%eax
  801c7a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	6a 78                	push   $0x78
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	ff d0                	call   *%eax
  801c8a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c90:	83 c0 04             	add    $0x4,%eax
  801c93:	89 45 14             	mov    %eax,0x14(%ebp)
  801c96:	8b 45 14             	mov    0x14(%ebp),%eax
  801c99:	83 e8 04             	sub    $0x4,%eax
  801c9c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ca1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801ca8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801caf:	eb 1f                	jmp    801cd0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb7:	8d 45 14             	lea    0x14(%ebp),%eax
  801cba:	50                   	push   %eax
  801cbb:	e8 e7 fb ff ff       	call   8018a7 <getuint>
  801cc0:	83 c4 10             	add    $0x10,%esp
  801cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801cc9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cd0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	52                   	push   %edx
  801cdb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cde:	50                   	push   %eax
  801cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce5:	ff 75 0c             	pushl  0xc(%ebp)
  801ce8:	ff 75 08             	pushl  0x8(%ebp)
  801ceb:	e8 00 fb ff ff       	call   8017f0 <printnum>
  801cf0:	83 c4 20             	add    $0x20,%esp
			break;
  801cf3:	eb 46                	jmp    801d3b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cf5:	83 ec 08             	sub    $0x8,%esp
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	53                   	push   %ebx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	ff d0                	call   *%eax
  801d01:	83 c4 10             	add    $0x10,%esp
			break;
  801d04:	eb 35                	jmp    801d3b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801d06:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  801d0d:	eb 2c                	jmp    801d3b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801d0f:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  801d16:	eb 23                	jmp    801d3b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d18:	83 ec 08             	sub    $0x8,%esp
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	6a 25                	push   $0x25
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	ff d0                	call   *%eax
  801d25:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d28:	ff 4d 10             	decl   0x10(%ebp)
  801d2b:	eb 03                	jmp    801d30 <vprintfmt+0x3c3>
  801d2d:	ff 4d 10             	decl   0x10(%ebp)
  801d30:	8b 45 10             	mov    0x10(%ebp),%eax
  801d33:	48                   	dec    %eax
  801d34:	8a 00                	mov    (%eax),%al
  801d36:	3c 25                	cmp    $0x25,%al
  801d38:	75 f3                	jne    801d2d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801d3a:	90                   	nop
		}
	}
  801d3b:	e9 35 fc ff ff       	jmp    801975 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801d40:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801d41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    

00801d48 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801d4e:	8d 45 10             	lea    0x10(%ebp),%eax
  801d51:	83 c0 04             	add    $0x4,%eax
  801d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801d57:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5d:	50                   	push   %eax
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	e8 04 fc ff ff       	call   80196d <vprintfmt>
  801d69:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801d6c:	90                   	nop
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d75:	8b 40 08             	mov    0x8(%eax),%eax
  801d78:	8d 50 01             	lea    0x1(%eax),%edx
  801d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d84:	8b 10                	mov    (%eax),%edx
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	8b 40 04             	mov    0x4(%eax),%eax
  801d8c:	39 c2                	cmp    %eax,%edx
  801d8e:	73 12                	jae    801da2 <sprintputch+0x33>
		*b->buf++ = ch;
  801d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d93:	8b 00                	mov    (%eax),%eax
  801d95:	8d 48 01             	lea    0x1(%eax),%ecx
  801d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9b:	89 0a                	mov    %ecx,(%edx)
  801d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801da0:	88 10                	mov    %dl,(%eax)
}
  801da2:	90                   	nop
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    

00801da5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801dc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dca:	74 06                	je     801dd2 <vsnprintf+0x2d>
  801dcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dd0:	7f 07                	jg     801dd9 <vsnprintf+0x34>
		return -E_INVAL;
  801dd2:	b8 03 00 00 00       	mov    $0x3,%eax
  801dd7:	eb 20                	jmp    801df9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801dd9:	ff 75 14             	pushl  0x14(%ebp)
  801ddc:	ff 75 10             	pushl  0x10(%ebp)
  801ddf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801de2:	50                   	push   %eax
  801de3:	68 6f 1d 80 00       	push   $0x801d6f
  801de8:	e8 80 fb ff ff       	call   80196d <vprintfmt>
  801ded:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e01:	8d 45 10             	lea    0x10(%ebp),%eax
  801e04:	83 c0 04             	add    $0x4,%eax
  801e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e10:	50                   	push   %eax
  801e11:	ff 75 0c             	pushl  0xc(%ebp)
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	e8 89 ff ff ff       	call   801da5 <vsnprintf>
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801e2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e34:	eb 06                	jmp    801e3c <strlen+0x15>
		n++;
  801e36:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801e39:	ff 45 08             	incl   0x8(%ebp)
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	8a 00                	mov    (%eax),%al
  801e41:	84 c0                	test   %al,%al
  801e43:	75 f1                	jne    801e36 <strlen+0xf>
		n++;
	return n;
  801e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801e50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e57:	eb 09                	jmp    801e62 <strnlen+0x18>
		n++;
  801e59:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801e5c:	ff 45 08             	incl   0x8(%ebp)
  801e5f:	ff 4d 0c             	decl   0xc(%ebp)
  801e62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e66:	74 09                	je     801e71 <strnlen+0x27>
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	8a 00                	mov    (%eax),%al
  801e6d:	84 c0                	test   %al,%al
  801e6f:	75 e8                	jne    801e59 <strnlen+0xf>
		n++;
	return n;
  801e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801e82:	90                   	nop
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	8d 50 01             	lea    0x1(%eax),%edx
  801e89:	89 55 08             	mov    %edx,0x8(%ebp)
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e92:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e95:	8a 12                	mov    (%edx),%dl
  801e97:	88 10                	mov    %dl,(%eax)
  801e99:	8a 00                	mov    (%eax),%al
  801e9b:	84 c0                	test   %al,%al
  801e9d:	75 e4                	jne    801e83 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801eb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801eb7:	eb 1f                	jmp    801ed8 <strncpy+0x34>
		*dst++ = *src;
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	8d 50 01             	lea    0x1(%eax),%edx
  801ebf:	89 55 08             	mov    %edx,0x8(%ebp)
  801ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec5:	8a 12                	mov    (%edx),%dl
  801ec7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecc:	8a 00                	mov    (%eax),%al
  801ece:	84 c0                	test   %al,%al
  801ed0:	74 03                	je     801ed5 <strncpy+0x31>
			src++;
  801ed2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ed5:	ff 45 fc             	incl   -0x4(%ebp)
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ede:	72 d9                	jb     801eb9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801ef1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ef5:	74 30                	je     801f27 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801ef7:	eb 16                	jmp    801f0f <strlcpy+0x2a>
			*dst++ = *src++;
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	8d 50 01             	lea    0x1(%eax),%edx
  801eff:	89 55 08             	mov    %edx,0x8(%ebp)
  801f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f08:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f0b:	8a 12                	mov    (%edx),%dl
  801f0d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f0f:	ff 4d 10             	decl   0x10(%ebp)
  801f12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f16:	74 09                	je     801f21 <strlcpy+0x3c>
  801f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1b:	8a 00                	mov    (%eax),%al
  801f1d:	84 c0                	test   %al,%al
  801f1f:	75 d8                	jne    801ef9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801f27:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2d:	29 c2                	sub    %eax,%edx
  801f2f:	89 d0                	mov    %edx,%eax
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801f36:	eb 06                	jmp    801f3e <strcmp+0xb>
		p++, q++;
  801f38:	ff 45 08             	incl   0x8(%ebp)
  801f3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	8a 00                	mov    (%eax),%al
  801f43:	84 c0                	test   %al,%al
  801f45:	74 0e                	je     801f55 <strcmp+0x22>
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	8a 10                	mov    (%eax),%dl
  801f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4f:	8a 00                	mov    (%eax),%al
  801f51:	38 c2                	cmp    %al,%dl
  801f53:	74 e3                	je     801f38 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8a 00                	mov    (%eax),%al
  801f5a:	0f b6 d0             	movzbl %al,%edx
  801f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f60:	8a 00                	mov    (%eax),%al
  801f62:	0f b6 c0             	movzbl %al,%eax
  801f65:	29 c2                	sub    %eax,%edx
  801f67:	89 d0                	mov    %edx,%eax
}
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801f6e:	eb 09                	jmp    801f79 <strncmp+0xe>
		n--, p++, q++;
  801f70:	ff 4d 10             	decl   0x10(%ebp)
  801f73:	ff 45 08             	incl   0x8(%ebp)
  801f76:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f7d:	74 17                	je     801f96 <strncmp+0x2b>
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	8a 00                	mov    (%eax),%al
  801f84:	84 c0                	test   %al,%al
  801f86:	74 0e                	je     801f96 <strncmp+0x2b>
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	8a 10                	mov    (%eax),%dl
  801f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f90:	8a 00                	mov    (%eax),%al
  801f92:	38 c2                	cmp    %al,%dl
  801f94:	74 da                	je     801f70 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801f96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f9a:	75 07                	jne    801fa3 <strncmp+0x38>
		return 0;
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	eb 14                	jmp    801fb7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	8a 00                	mov    (%eax),%al
  801fa8:	0f b6 d0             	movzbl %al,%edx
  801fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fae:	8a 00                	mov    (%eax),%al
  801fb0:	0f b6 c0             	movzbl %al,%eax
  801fb3:	29 c2                	sub    %eax,%edx
  801fb5:	89 d0                	mov    %edx,%eax
}
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801fc5:	eb 12                	jmp    801fd9 <strchr+0x20>
		if (*s == c)
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	8a 00                	mov    (%eax),%al
  801fcc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801fcf:	75 05                	jne    801fd6 <strchr+0x1d>
			return (char *) s;
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	eb 11                	jmp    801fe7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801fd6:	ff 45 08             	incl   0x8(%ebp)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	8a 00                	mov    (%eax),%al
  801fde:	84 c0                	test   %al,%al
  801fe0:	75 e5                	jne    801fc7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ff5:	eb 0d                	jmp    802004 <strfind+0x1b>
		if (*s == c)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	8a 00                	mov    (%eax),%al
  801ffc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801fff:	74 0e                	je     80200f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802001:	ff 45 08             	incl   0x8(%ebp)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	8a 00                	mov    (%eax),%al
  802009:	84 c0                	test   %al,%al
  80200b:	75 ea                	jne    801ff7 <strfind+0xe>
  80200d:	eb 01                	jmp    802010 <strfind+0x27>
		if (*s == c)
			break;
  80200f:	90                   	nop
	return (char *) s;
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802021:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802025:	76 63                	jbe    80208a <memset+0x75>
		uint64 data_block = c;
  802027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202a:	99                   	cltd   
  80202b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80202e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802037:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80203b:	c1 e0 08             	shl    $0x8,%eax
  80203e:	09 45 f0             	or     %eax,-0x10(%ebp)
  802041:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802047:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80204e:	c1 e0 10             	shl    $0x10,%eax
  802051:	09 45 f0             	or     %eax,-0x10(%ebp)
  802054:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205d:	89 c2                	mov    %eax,%edx
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
  802064:	09 45 f0             	or     %eax,-0x10(%ebp)
  802067:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80206a:	eb 18                	jmp    802084 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80206c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80206f:	8d 41 08             	lea    0x8(%ecx),%eax
  802072:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207b:	89 01                	mov    %eax,(%ecx)
  80207d:	89 51 04             	mov    %edx,0x4(%ecx)
  802080:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802084:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802088:	77 e2                	ja     80206c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80208a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208e:	74 23                	je     8020b3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802093:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802096:	eb 0e                	jmp    8020a6 <memset+0x91>
			*p8++ = (uint8)c;
  802098:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80209b:	8d 50 01             	lea    0x1(%eax),%edx
  80209e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8020a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	75 e5                	jne    802098 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8020be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8020ca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8020ce:	76 24                	jbe    8020f4 <memcpy+0x3c>
		while(n >= 8){
  8020d0:	eb 1c                	jmp    8020ee <memcpy+0x36>
			*d64 = *s64;
  8020d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d5:	8b 50 04             	mov    0x4(%eax),%edx
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8020dd:	89 01                	mov    %eax,(%ecx)
  8020df:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8020e2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8020e6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8020ea:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8020ee:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8020f2:	77 de                	ja     8020d2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8020f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f8:	74 31                	je     80212b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8020fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802103:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802106:	eb 16                	jmp    80211e <memcpy+0x66>
			*d8++ = *s8++;
  802108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210b:	8d 50 01             	lea    0x1(%eax),%edx
  80210e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802114:	8d 4a 01             	lea    0x1(%edx),%ecx
  802117:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80211a:	8a 12                	mov    (%edx),%dl
  80211c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80211e:	8b 45 10             	mov    0x10(%ebp),%eax
  802121:	8d 50 ff             	lea    -0x1(%eax),%edx
  802124:	89 55 10             	mov    %edx,0x10(%ebp)
  802127:	85 c0                	test   %eax,%eax
  802129:	75 dd                	jne    802108 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802136:	8b 45 0c             	mov    0xc(%ebp),%eax
  802139:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802145:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802148:	73 50                	jae    80219a <memmove+0x6a>
  80214a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80214d:	8b 45 10             	mov    0x10(%ebp),%eax
  802150:	01 d0                	add    %edx,%eax
  802152:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802155:	76 43                	jbe    80219a <memmove+0x6a>
		s += n;
  802157:	8b 45 10             	mov    0x10(%ebp),%eax
  80215a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80215d:	8b 45 10             	mov    0x10(%ebp),%eax
  802160:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802163:	eb 10                	jmp    802175 <memmove+0x45>
			*--d = *--s;
  802165:	ff 4d f8             	decl   -0x8(%ebp)
  802168:	ff 4d fc             	decl   -0x4(%ebp)
  80216b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216e:	8a 10                	mov    (%eax),%dl
  802170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802173:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802175:	8b 45 10             	mov    0x10(%ebp),%eax
  802178:	8d 50 ff             	lea    -0x1(%eax),%edx
  80217b:	89 55 10             	mov    %edx,0x10(%ebp)
  80217e:	85 c0                	test   %eax,%eax
  802180:	75 e3                	jne    802165 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802182:	eb 23                	jmp    8021a7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802184:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802187:	8d 50 01             	lea    0x1(%eax),%edx
  80218a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80218d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802190:	8d 4a 01             	lea    0x1(%edx),%ecx
  802193:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802196:	8a 12                	mov    (%edx),%dl
  802198:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80219a:	8b 45 10             	mov    0x10(%ebp),%eax
  80219d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	75 dd                	jne    802184 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021be:	eb 2a                	jmp    8021ea <memcmp+0x3e>
		if (*s1 != *s2)
  8021c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c3:	8a 10                	mov    (%eax),%dl
  8021c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c8:	8a 00                	mov    (%eax),%al
  8021ca:	38 c2                	cmp    %al,%dl
  8021cc:	74 16                	je     8021e4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d1:	8a 00                	mov    (%eax),%al
  8021d3:	0f b6 d0             	movzbl %al,%edx
  8021d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d9:	8a 00                	mov    (%eax),%al
  8021db:	0f b6 c0             	movzbl %al,%eax
  8021de:	29 c2                	sub    %eax,%edx
  8021e0:	89 d0                	mov    %edx,%eax
  8021e2:	eb 18                	jmp    8021fc <memcmp+0x50>
		s1++, s2++;
  8021e4:	ff 45 fc             	incl   -0x4(%ebp)
  8021e7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	75 c9                	jne    8021c0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802204:	8b 55 08             	mov    0x8(%ebp),%edx
  802207:	8b 45 10             	mov    0x10(%ebp),%eax
  80220a:	01 d0                	add    %edx,%eax
  80220c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80220f:	eb 15                	jmp    802226 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	8a 00                	mov    (%eax),%al
  802216:	0f b6 d0             	movzbl %al,%edx
  802219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221c:	0f b6 c0             	movzbl %al,%eax
  80221f:	39 c2                	cmp    %eax,%edx
  802221:	74 0d                	je     802230 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802223:	ff 45 08             	incl   0x8(%ebp)
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80222c:	72 e3                	jb     802211 <memfind+0x13>
  80222e:	eb 01                	jmp    802231 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802230:	90                   	nop
	return (void *) s;
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80223c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802243:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80224a:	eb 03                	jmp    80224f <strtol+0x19>
		s++;
  80224c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	8a 00                	mov    (%eax),%al
  802254:	3c 20                	cmp    $0x20,%al
  802256:	74 f4                	je     80224c <strtol+0x16>
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	8a 00                	mov    (%eax),%al
  80225d:	3c 09                	cmp    $0x9,%al
  80225f:	74 eb                	je     80224c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8a 00                	mov    (%eax),%al
  802266:	3c 2b                	cmp    $0x2b,%al
  802268:	75 05                	jne    80226f <strtol+0x39>
		s++;
  80226a:	ff 45 08             	incl   0x8(%ebp)
  80226d:	eb 13                	jmp    802282 <strtol+0x4c>
	else if (*s == '-')
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8a 00                	mov    (%eax),%al
  802274:	3c 2d                	cmp    $0x2d,%al
  802276:	75 0a                	jne    802282 <strtol+0x4c>
		s++, neg = 1;
  802278:	ff 45 08             	incl   0x8(%ebp)
  80227b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802286:	74 06                	je     80228e <strtol+0x58>
  802288:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80228c:	75 20                	jne    8022ae <strtol+0x78>
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	8a 00                	mov    (%eax),%al
  802293:	3c 30                	cmp    $0x30,%al
  802295:	75 17                	jne    8022ae <strtol+0x78>
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	40                   	inc    %eax
  80229b:	8a 00                	mov    (%eax),%al
  80229d:	3c 78                	cmp    $0x78,%al
  80229f:	75 0d                	jne    8022ae <strtol+0x78>
		s += 2, base = 16;
  8022a1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022a5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8022ac:	eb 28                	jmp    8022d6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8022ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b2:	75 15                	jne    8022c9 <strtol+0x93>
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	8a 00                	mov    (%eax),%al
  8022b9:	3c 30                	cmp    $0x30,%al
  8022bb:	75 0c                	jne    8022c9 <strtol+0x93>
		s++, base = 8;
  8022bd:	ff 45 08             	incl   0x8(%ebp)
  8022c0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022c7:	eb 0d                	jmp    8022d6 <strtol+0xa0>
	else if (base == 0)
  8022c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022cd:	75 07                	jne    8022d6 <strtol+0xa0>
		base = 10;
  8022cf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	8a 00                	mov    (%eax),%al
  8022db:	3c 2f                	cmp    $0x2f,%al
  8022dd:	7e 19                	jle    8022f8 <strtol+0xc2>
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8a 00                	mov    (%eax),%al
  8022e4:	3c 39                	cmp    $0x39,%al
  8022e6:	7f 10                	jg     8022f8 <strtol+0xc2>
			dig = *s - '0';
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	8a 00                	mov    (%eax),%al
  8022ed:	0f be c0             	movsbl %al,%eax
  8022f0:	83 e8 30             	sub    $0x30,%eax
  8022f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f6:	eb 42                	jmp    80233a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8a 00                	mov    (%eax),%al
  8022fd:	3c 60                	cmp    $0x60,%al
  8022ff:	7e 19                	jle    80231a <strtol+0xe4>
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	8a 00                	mov    (%eax),%al
  802306:	3c 7a                	cmp    $0x7a,%al
  802308:	7f 10                	jg     80231a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	8a 00                	mov    (%eax),%al
  80230f:	0f be c0             	movsbl %al,%eax
  802312:	83 e8 57             	sub    $0x57,%eax
  802315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802318:	eb 20                	jmp    80233a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	8a 00                	mov    (%eax),%al
  80231f:	3c 40                	cmp    $0x40,%al
  802321:	7e 39                	jle    80235c <strtol+0x126>
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	8a 00                	mov    (%eax),%al
  802328:	3c 5a                	cmp    $0x5a,%al
  80232a:	7f 30                	jg     80235c <strtol+0x126>
			dig = *s - 'A' + 10;
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8a 00                	mov    (%eax),%al
  802331:	0f be c0             	movsbl %al,%eax
  802334:	83 e8 37             	sub    $0x37,%eax
  802337:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802340:	7d 19                	jge    80235b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802342:	ff 45 08             	incl   0x8(%ebp)
  802345:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802348:	0f af 45 10          	imul   0x10(%ebp),%eax
  80234c:	89 c2                	mov    %eax,%edx
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	01 d0                	add    %edx,%eax
  802353:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802356:	e9 7b ff ff ff       	jmp    8022d6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80235b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80235c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802360:	74 08                	je     80236a <strtol+0x134>
		*endptr = (char *) s;
  802362:	8b 45 0c             	mov    0xc(%ebp),%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80236a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80236e:	74 07                	je     802377 <strtol+0x141>
  802370:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802373:	f7 d8                	neg    %eax
  802375:	eb 03                	jmp    80237a <strtol+0x144>
  802377:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <ltostr>:

void
ltostr(long value, char *str)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802389:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802394:	79 13                	jns    8023a9 <ltostr+0x2d>
	{
		neg = 1;
  802396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80239d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023a3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023a6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023b1:	99                   	cltd   
  8023b2:	f7 f9                	idiv   %ecx
  8023b4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ba:	8d 50 01             	lea    0x1(%eax),%edx
  8023bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023c0:	89 c2                	mov    %eax,%edx
  8023c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c5:	01 d0                	add    %edx,%eax
  8023c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ca:	83 c2 30             	add    $0x30,%edx
  8023cd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023d7:	f7 e9                	imul   %ecx
  8023d9:	c1 fa 02             	sar    $0x2,%edx
  8023dc:	89 c8                	mov    %ecx,%eax
  8023de:	c1 f8 1f             	sar    $0x1f,%eax
  8023e1:	29 c2                	sub    %eax,%edx
  8023e3:	89 d0                	mov    %edx,%eax
  8023e5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8023e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ec:	75 bb                	jne    8023a9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8023ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8023f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023f8:	48                   	dec    %eax
  8023f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8023fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802400:	74 3d                	je     80243f <ltostr+0xc3>
		start = 1 ;
  802402:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802409:	eb 34                	jmp    80243f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80240b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802411:	01 d0                	add    %edx,%eax
  802413:	8a 00                	mov    (%eax),%al
  802415:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241e:	01 c2                	add    %eax,%edx
  802420:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802423:	8b 45 0c             	mov    0xc(%ebp),%eax
  802426:	01 c8                	add    %ecx,%eax
  802428:	8a 00                	mov    (%eax),%al
  80242a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80242c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80242f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802432:	01 c2                	add    %eax,%edx
  802434:	8a 45 eb             	mov    -0x15(%ebp),%al
  802437:	88 02                	mov    %al,(%edx)
		start++ ;
  802439:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80243c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802445:	7c c4                	jl     80240b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802447:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80244a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244d:	01 d0                	add    %edx,%eax
  80244f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802452:	90                   	nop
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80245b:	ff 75 08             	pushl  0x8(%ebp)
  80245e:	e8 c4 f9 ff ff       	call   801e27 <strlen>
  802463:	83 c4 04             	add    $0x4,%esp
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802469:	ff 75 0c             	pushl  0xc(%ebp)
  80246c:	e8 b6 f9 ff ff       	call   801e27 <strlen>
  802471:	83 c4 04             	add    $0x4,%esp
  802474:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802477:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80247e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802485:	eb 17                	jmp    80249e <strcconcat+0x49>
		final[s] = str1[s] ;
  802487:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80248a:	8b 45 10             	mov    0x10(%ebp),%eax
  80248d:	01 c2                	add    %eax,%edx
  80248f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	01 c8                	add    %ecx,%eax
  802497:	8a 00                	mov    (%eax),%al
  802499:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80249b:	ff 45 fc             	incl   -0x4(%ebp)
  80249e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024a4:	7c e1                	jl     802487 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024b4:	eb 1f                	jmp    8024d5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024b9:	8d 50 01             	lea    0x1(%eax),%edx
  8024bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024bf:	89 c2                	mov    %eax,%edx
  8024c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c4:	01 c2                	add    %eax,%edx
  8024c6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024cc:	01 c8                	add    %ecx,%eax
  8024ce:	8a 00                	mov    (%eax),%al
  8024d0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024d2:	ff 45 f8             	incl   -0x8(%ebp)
  8024d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024db:	7c d9                	jl     8024b6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8024dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e3:	01 d0                	add    %edx,%eax
  8024e5:	c6 00 00             	movb   $0x0,(%eax)
}
  8024e8:	90                   	nop
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8024ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8024f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8024fa:	8b 00                	mov    (%eax),%eax
  8024fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802503:	8b 45 10             	mov    0x10(%ebp),%eax
  802506:	01 d0                	add    %edx,%eax
  802508:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80250e:	eb 0c                	jmp    80251c <strsplit+0x31>
			*string++ = 0;
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	8d 50 01             	lea    0x1(%eax),%edx
  802516:	89 55 08             	mov    %edx,0x8(%ebp)
  802519:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	8a 00                	mov    (%eax),%al
  802521:	84 c0                	test   %al,%al
  802523:	74 18                	je     80253d <strsplit+0x52>
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	8a 00                	mov    (%eax),%al
  80252a:	0f be c0             	movsbl %al,%eax
  80252d:	50                   	push   %eax
  80252e:	ff 75 0c             	pushl  0xc(%ebp)
  802531:	e8 83 fa ff ff       	call   801fb9 <strchr>
  802536:	83 c4 08             	add    $0x8,%esp
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 d3                	jne    802510 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	8a 00                	mov    (%eax),%al
  802542:	84 c0                	test   %al,%al
  802544:	74 5a                	je     8025a0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802546:	8b 45 14             	mov    0x14(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	83 f8 0f             	cmp    $0xf,%eax
  80254e:	75 07                	jne    802557 <strsplit+0x6c>
		{
			return 0;
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	eb 66                	jmp    8025bd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802557:	8b 45 14             	mov    0x14(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	8d 48 01             	lea    0x1(%eax),%ecx
  80255f:	8b 55 14             	mov    0x14(%ebp),%edx
  802562:	89 0a                	mov    %ecx,(%edx)
  802564:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80256b:	8b 45 10             	mov    0x10(%ebp),%eax
  80256e:	01 c2                	add    %eax,%edx
  802570:	8b 45 08             	mov    0x8(%ebp),%eax
  802573:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802575:	eb 03                	jmp    80257a <strsplit+0x8f>
			string++;
  802577:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	8a 00                	mov    (%eax),%al
  80257f:	84 c0                	test   %al,%al
  802581:	74 8b                	je     80250e <strsplit+0x23>
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	8a 00                	mov    (%eax),%al
  802588:	0f be c0             	movsbl %al,%eax
  80258b:	50                   	push   %eax
  80258c:	ff 75 0c             	pushl  0xc(%ebp)
  80258f:	e8 25 fa ff ff       	call   801fb9 <strchr>
  802594:	83 c4 08             	add    $0x8,%esp
  802597:	85 c0                	test   %eax,%eax
  802599:	74 dc                	je     802577 <strsplit+0x8c>
			string++;
	}
  80259b:	e9 6e ff ff ff       	jmp    80250e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025a0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8025a4:	8b 00                	mov    (%eax),%eax
  8025a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b0:	01 d0                	add    %edx,%eax
  8025b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025b8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    

008025bf <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8025cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025d2:	eb 4a                	jmp    80261e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8025d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	01 c2                	add    %eax,%edx
  8025dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e2:	01 c8                	add    %ecx,%eax
  8025e4:	8a 00                	mov    (%eax),%al
  8025e6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8025e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ee:	01 d0                	add    %edx,%eax
  8025f0:	8a 00                	mov    (%eax),%al
  8025f2:	3c 40                	cmp    $0x40,%al
  8025f4:	7e 25                	jle    80261b <str2lower+0x5c>
  8025f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025fc:	01 d0                	add    %edx,%eax
  8025fe:	8a 00                	mov    (%eax),%al
  802600:	3c 5a                	cmp    $0x5a,%al
  802602:	7f 17                	jg     80261b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802604:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	01 d0                	add    %edx,%eax
  80260c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80260f:	8b 55 08             	mov    0x8(%ebp),%edx
  802612:	01 ca                	add    %ecx,%edx
  802614:	8a 12                	mov    (%edx),%dl
  802616:	83 c2 20             	add    $0x20,%edx
  802619:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80261b:	ff 45 fc             	incl   -0x4(%ebp)
  80261e:	ff 75 0c             	pushl  0xc(%ebp)
  802621:	e8 01 f8 ff ff       	call   801e27 <strlen>
  802626:	83 c4 04             	add    $0x4,%esp
  802629:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80262c:	7f a6                	jg     8025d4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80262e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  802639:	83 ec 0c             	sub    $0xc,%esp
  80263c:	6a 10                	push   $0x10
  80263e:	e8 b2 15 00 00       	call   803bf5 <alloc_block>
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  802649:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80264d:	75 14                	jne    802663 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80264f:	83 ec 04             	sub    $0x4,%esp
  802652:	68 e8 53 80 00       	push   $0x8053e8
  802657:	6a 14                	push   $0x14
  802659:	68 11 54 80 00       	push   $0x805411
  80265e:	e8 fd ed ff ff       	call   801460 <_panic>

	node->start = start;
  802663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802666:	8b 55 08             	mov    0x8(%ebp),%edx
  802669:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80266b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802671:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802674:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80267b:	a1 04 62 80 00       	mov    0x806204,%eax
  802680:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802683:	eb 18                	jmp    80269d <insert_page_alloc+0x6a>
		if (start < it->start)
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268d:	77 37                	ja     8026c6 <insert_page_alloc+0x93>
			break;
		prev = it;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  802695:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80269a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a1:	74 08                	je     8026ab <insert_page_alloc+0x78>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 40 08             	mov    0x8(%eax),%eax
  8026a9:	eb 05                	jmp    8026b0 <insert_page_alloc+0x7d>
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	a3 0c 62 80 00       	mov    %eax,0x80620c
  8026b5:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	75 c7                	jne    802685 <insert_page_alloc+0x52>
  8026be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c2:	75 c1                	jne    802685 <insert_page_alloc+0x52>
  8026c4:	eb 01                	jmp    8026c7 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8026c6:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8026c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026cb:	75 64                	jne    802731 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8026cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026d1:	75 14                	jne    8026e7 <insert_page_alloc+0xb4>
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	68 20 54 80 00       	push   $0x805420
  8026db:	6a 21                	push   $0x21
  8026dd:	68 11 54 80 00       	push   $0x805411
  8026e2:	e8 79 ed ff ff       	call   801460 <_panic>
  8026e7:	8b 15 04 62 80 00    	mov    0x806204,%edx
  8026ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f0:	89 50 08             	mov    %edx,0x8(%eax)
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	8b 40 08             	mov    0x8(%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 0d                	je     80270a <insert_page_alloc+0xd7>
  8026fd:	a1 04 62 80 00       	mov    0x806204,%eax
  802702:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802705:	89 50 0c             	mov    %edx,0xc(%eax)
  802708:	eb 08                	jmp    802712 <insert_page_alloc+0xdf>
  80270a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270d:	a3 08 62 80 00       	mov    %eax,0x806208
  802712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802715:	a3 04 62 80 00       	mov    %eax,0x806204
  80271a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802724:	a1 10 62 80 00       	mov    0x806210,%eax
  802729:	40                   	inc    %eax
  80272a:	a3 10 62 80 00       	mov    %eax,0x806210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  80272f:	eb 71                	jmp    8027a2 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802731:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802735:	74 06                	je     80273d <insert_page_alloc+0x10a>
  802737:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80273b:	75 14                	jne    802751 <insert_page_alloc+0x11e>
  80273d:	83 ec 04             	sub    $0x4,%esp
  802740:	68 44 54 80 00       	push   $0x805444
  802745:	6a 23                	push   $0x23
  802747:	68 11 54 80 00       	push   $0x805411
  80274c:	e8 0f ed ff ff       	call   801460 <_panic>
  802751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802754:	8b 50 08             	mov    0x8(%eax),%edx
  802757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275a:	89 50 08             	mov    %edx,0x8(%eax)
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 40 08             	mov    0x8(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0c                	je     802773 <insert_page_alloc+0x140>
  802767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802770:	89 50 0c             	mov    %edx,0xc(%eax)
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802779:	89 50 08             	mov    %edx,0x8(%eax)
  80277c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802782:	89 50 0c             	mov    %edx,0xc(%eax)
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	8b 40 08             	mov    0x8(%eax),%eax
  80278b:	85 c0                	test   %eax,%eax
  80278d:	75 08                	jne    802797 <insert_page_alloc+0x164>
  80278f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802792:	a3 08 62 80 00       	mov    %eax,0x806208
  802797:	a1 10 62 80 00       	mov    0x806210,%eax
  80279c:	40                   	inc    %eax
  80279d:	a3 10 62 80 00       	mov    %eax,0x806210
}
  8027a2:	90                   	nop
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8027ab:	a1 04 62 80 00       	mov    0x806204,%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	75 0c                	jne    8027c0 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8027b4:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8027b9:	a3 50 e2 81 00       	mov    %eax,0x81e250
		return;
  8027be:	eb 67                	jmp    802827 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8027c0:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8027c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8027c8:	a1 04 62 80 00       	mov    0x806204,%eax
  8027cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8027d0:	eb 26                	jmp    8027f8 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8027d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027d5:	8b 10                	mov    (%eax),%edx
  8027d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027da:	8b 40 04             	mov    0x4(%eax),%eax
  8027dd:	01 d0                	add    %edx,%eax
  8027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8027e8:	76 06                	jbe    8027f0 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8027f0:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8027f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8027f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8027fc:	74 08                	je     802806 <recompute_page_alloc_break+0x61>
  8027fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802801:	8b 40 08             	mov    0x8(%eax),%eax
  802804:	eb 05                	jmp    80280b <recompute_page_alloc_break+0x66>
  802806:	b8 00 00 00 00       	mov    $0x0,%eax
  80280b:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802810:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	75 b9                	jne    8027d2 <recompute_page_alloc_break+0x2d>
  802819:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80281d:	75 b3                	jne    8027d2 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  80281f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802822:	a3 50 e2 81 00       	mov    %eax,0x81e250
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
  80282c:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  80282f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802836:	8b 55 08             	mov    0x8(%ebp),%edx
  802839:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80283c:	01 d0                	add    %edx,%eax
  80283e:	48                   	dec    %eax
  80283f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802845:	ba 00 00 00 00       	mov    $0x0,%edx
  80284a:	f7 75 d8             	divl   -0x28(%ebp)
  80284d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802850:	29 d0                	sub    %edx,%eax
  802852:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  802855:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802859:	75 0a                	jne    802865 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
  802860:	e9 7e 01 00 00       	jmp    8029e3 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  802865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80286c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802870:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  802877:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80287e:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802883:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802886:	a1 04 62 80 00       	mov    0x806204,%eax
  80288b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80288e:	eb 69                	jmp    8028f9 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802890:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802898:	76 47                	jbe    8028e1 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80289a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8028a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8028a8:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8028ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028ae:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8028b1:	72 2e                	jb     8028e1 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8028b3:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8028b7:	75 14                	jne    8028cd <alloc_pages_custom_fit+0xa4>
  8028b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028bc:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8028bf:	75 0c                	jne    8028cd <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8028c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8028c7:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8028cb:	eb 14                	jmp    8028e1 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8028cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028d3:	76 0c                	jbe    8028e1 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8028d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8028db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028de:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8028e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e4:	8b 10                	mov    (%eax),%edx
  8028e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8028f1:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8028f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8028f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028fd:	74 08                	je     802907 <alloc_pages_custom_fit+0xde>
  8028ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802902:	8b 40 08             	mov    0x8(%eax),%eax
  802905:	eb 05                	jmp    80290c <alloc_pages_custom_fit+0xe3>
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
  80290c:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802911:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	0f 85 72 ff ff ff    	jne    802890 <alloc_pages_custom_fit+0x67>
  80291e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802922:	0f 85 68 ff ff ff    	jne    802890 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802928:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80292d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802930:	76 47                	jbe    802979 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802935:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802938:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80293d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802940:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802943:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802946:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802949:	72 2e                	jb     802979 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80294b:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80294f:	75 14                	jne    802965 <alloc_pages_custom_fit+0x13c>
  802951:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802954:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802957:	75 0c                	jne    802965 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802959:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80295c:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  80295f:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802963:	eb 14                	jmp    802979 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802965:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802968:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80296b:	76 0c                	jbe    802979 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80296d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802970:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802973:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802976:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802979:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802980:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802984:	74 08                	je     80298e <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80298c:	eb 40                	jmp    8029ce <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80298e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802992:	74 08                	je     80299c <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80299a:	eb 32                	jmp    8029ce <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80299c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8029a1:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8029a4:	89 c2                	mov    %eax,%edx
  8029a6:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8029ab:	39 c2                	cmp    %eax,%edx
  8029ad:	73 07                	jae    8029b6 <alloc_pages_custom_fit+0x18d>
			return NULL;
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	eb 2d                	jmp    8029e3 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8029b6:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8029bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8029be:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8029c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c7:	01 d0                	add    %edx,%eax
  8029c9:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}


	insert_page_alloc((uint32)result, required_size);
  8029ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029d1:	83 ec 08             	sub    $0x8,%esp
  8029d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8029d7:	50                   	push   %eax
  8029d8:	e8 56 fc ff ff       	call   802633 <insert_page_alloc>
  8029dd:	83 c4 10             	add    $0x10,%esp

	return result;
  8029e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8029f1:	a1 04 62 80 00       	mov    0x806204,%eax
  8029f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029f9:	eb 1a                	jmp    802a15 <find_allocated_size+0x30>
		if (it->start == va)
  8029fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802a03:	75 08                	jne    802a0d <find_allocated_size+0x28>
			return it->size;
  802a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a08:	8b 40 04             	mov    0x4(%eax),%eax
  802a0b:	eb 34                	jmp    802a41 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802a0d:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802a12:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a15:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a19:	74 08                	je     802a23 <find_allocated_size+0x3e>
  802a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a1e:	8b 40 08             	mov    0x8(%eax),%eax
  802a21:	eb 05                	jmp    802a28 <find_allocated_size+0x43>
  802a23:	b8 00 00 00 00       	mov    $0x0,%eax
  802a28:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802a2d:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	75 c5                	jne    8029fb <find_allocated_size+0x16>
  802a36:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a3a:	75 bf                	jne    8029fb <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802a4f:	a1 04 62 80 00       	mov    0x806204,%eax
  802a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a57:	e9 e1 01 00 00       	jmp    802c3d <free_pages+0x1fa>
		if (it->start == va) {
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a64:	0f 85 cb 01 00 00    	jne    802c35 <free_pages+0x1f2>

			uint32 start = it->start;
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 04             	mov    0x4(%eax),%eax
  802a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7e:	f7 d0                	not    %eax
  802a80:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a83:	73 1d                	jae    802aa2 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802a85:	83 ec 0c             	sub    $0xc,%esp
  802a88:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  802a8e:	68 78 54 80 00       	push   $0x805478
  802a93:	68 a5 00 00 00       	push   $0xa5
  802a98:	68 11 54 80 00       	push   $0x805411
  802a9d:	e8 be e9 ff ff       	call   801460 <_panic>
			}

			uint32 start_end = start + size;
  802aa2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa8:	01 d0                	add    %edx,%eax
  802aaa:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	79 19                	jns    802acd <free_pages+0x8a>
  802ab4:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802abb:	77 10                	ja     802acd <free_pages+0x8a>
  802abd:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802ac4:	77 07                	ja     802acd <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	78 2c                	js     802af9 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad0:	83 ec 0c             	sub    $0xc,%esp
  802ad3:	68 00 00 00 a0       	push   $0xa0000000
  802ad8:	ff 75 e0             	pushl  -0x20(%ebp)
  802adb:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ade:	ff 75 e8             	pushl  -0x18(%ebp)
  802ae1:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ae4:	50                   	push   %eax
  802ae5:	68 bc 54 80 00       	push   $0x8054bc
  802aea:	68 ad 00 00 00       	push   $0xad
  802aef:	68 11 54 80 00       	push   $0x805411
  802af4:	e8 67 e9 ff ff       	call   801460 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802aff:	e9 88 00 00 00       	jmp    802b8c <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802b04:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802b0b:	76 17                	jbe    802b24 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802b0d:	ff 75 f0             	pushl  -0x10(%ebp)
  802b10:	68 20 55 80 00       	push   $0x805520
  802b15:	68 b4 00 00 00       	push   $0xb4
  802b1a:	68 11 54 80 00       	push   $0x805411
  802b1f:	e8 3c e9 ff ff       	call   801460 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	05 00 10 00 00       	add    $0x1000,%eax
  802b2c:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	79 2e                	jns    802b64 <free_pages+0x121>
  802b36:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802b3d:	77 25                	ja     802b64 <free_pages+0x121>
  802b3f:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802b46:	77 1c                	ja     802b64 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802b48:	83 ec 08             	sub    $0x8,%esp
  802b4b:	68 00 10 00 00       	push   $0x1000
  802b50:	ff 75 f0             	pushl  -0x10(%ebp)
  802b53:	e8 38 0d 00 00       	call   803890 <sys_free_user_mem>
  802b58:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802b5b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802b62:	eb 28                	jmp    802b8c <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	68 00 00 00 a0       	push   $0xa0000000
  802b6c:	ff 75 dc             	pushl  -0x24(%ebp)
  802b6f:	68 00 10 00 00       	push   $0x1000
  802b74:	ff 75 f0             	pushl  -0x10(%ebp)
  802b77:	50                   	push   %eax
  802b78:	68 60 55 80 00       	push   $0x805560
  802b7d:	68 bd 00 00 00       	push   $0xbd
  802b82:	68 11 54 80 00       	push   $0x805411
  802b87:	e8 d4 e8 ff ff       	call   801460 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b92:	0f 82 6c ff ff ff    	jb     802b04 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802b98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9c:	75 17                	jne    802bb5 <free_pages+0x172>
  802b9e:	83 ec 04             	sub    $0x4,%esp
  802ba1:	68 c2 55 80 00       	push   $0x8055c2
  802ba6:	68 c1 00 00 00       	push   $0xc1
  802bab:	68 11 54 80 00       	push   $0x805411
  802bb0:	e8 ab e8 ff ff       	call   801460 <_panic>
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	74 11                	je     802bd0 <free_pages+0x18d>
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 08             	mov    0x8(%eax),%eax
  802bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc8:	8b 52 0c             	mov    0xc(%edx),%edx
  802bcb:	89 50 0c             	mov    %edx,0xc(%eax)
  802bce:	eb 0b                	jmp    802bdb <free_pages+0x198>
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd6:	a3 08 62 80 00       	mov    %eax,0x806208
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 0c             	mov    0xc(%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 11                	je     802bf6 <free_pages+0x1b3>
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 0c             	mov    0xc(%eax),%eax
  802beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bee:	8b 52 08             	mov    0x8(%edx),%edx
  802bf1:	89 50 08             	mov    %edx,0x8(%eax)
  802bf4:	eb 0b                	jmp    802c01 <free_pages+0x1be>
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 08             	mov    0x8(%eax),%eax
  802bfc:	a3 04 62 80 00       	mov    %eax,0x806204
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c15:	a1 10 62 80 00       	mov    0x806210,%eax
  802c1a:	48                   	dec    %eax
  802c1b:	a3 10 62 80 00       	mov    %eax,0x806210
			free_block(it);
  802c20:	83 ec 0c             	sub    $0xc,%esp
  802c23:	ff 75 f4             	pushl  -0xc(%ebp)
  802c26:	e8 24 15 00 00       	call   80414f <free_block>
  802c2b:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802c2e:	e8 72 fb ff ff       	call   8027a5 <recompute_page_alloc_break>

			return;
  802c33:	eb 37                	jmp    802c6c <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802c35:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	74 08                	je     802c4b <free_pages+0x208>
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 40 08             	mov    0x8(%eax),%eax
  802c49:	eb 05                	jmp    802c50 <free_pages+0x20d>
  802c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c50:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802c55:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	0f 85 fa fd ff ff    	jne    802a5c <free_pages+0x19>
  802c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c66:	0f 85 f0 fd ff ff    	jne    802a5c <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802c6c:	c9                   	leave  
  802c6d:	c3                   	ret    

00802c6e <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c76:	5d                   	pop    %ebp
  802c77:	c3                   	ret    

00802c78 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802c78:	55                   	push   %ebp
  802c79:	89 e5                	mov    %esp,%ebp
  802c7b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802c7e:	a1 08 60 80 00       	mov    0x806008,%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 60                	je     802ce7 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802c87:	83 ec 08             	sub    $0x8,%esp
  802c8a:	68 00 00 00 82       	push   $0x82000000
  802c8f:	68 00 00 00 80       	push   $0x80000000
  802c94:	e8 0d 0d 00 00       	call   8039a6 <initialize_dynamic_allocator>
  802c99:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802c9c:	e8 f3 0a 00 00       	call   803794 <sys_get_uheap_strategy>
  802ca1:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802ca6:	a1 20 62 80 00       	mov    0x806220,%eax
  802cab:	05 00 10 00 00       	add    $0x1000,%eax
  802cb0:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802cb5:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802cba:	a3 50 e2 81 00       	mov    %eax,0x81e250

		LIST_INIT(&page_alloc_list);
  802cbf:	c7 05 04 62 80 00 00 	movl   $0x0,0x806204
  802cc6:	00 00 00 
  802cc9:	c7 05 08 62 80 00 00 	movl   $0x0,0x806208
  802cd0:	00 00 00 
  802cd3:	c7 05 10 62 80 00 00 	movl   $0x0,0x806210
  802cda:	00 00 00 

		__firstTimeFlag = 0;
  802cdd:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802ce4:	00 00 00 
	}
}
  802ce7:	90                   	nop
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
  802ced:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802cfe:	83 ec 08             	sub    $0x8,%esp
  802d01:	68 06 04 00 00       	push   $0x406
  802d06:	50                   	push   %eax
  802d07:	e8 d2 06 00 00       	call   8033de <__sys_allocate_page>
  802d0c:	83 c4 10             	add    $0x10,%esp
  802d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802d12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d16:	79 17                	jns    802d2f <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 e0 55 80 00       	push   $0x8055e0
  802d20:	68 ea 00 00 00       	push   $0xea
  802d25:	68 11 54 80 00       	push   $0x805411
  802d2a:	e8 31 e7 ff ff       	call   801460 <_panic>
	return 0;
  802d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d34:	c9                   	leave  
  802d35:	c3                   	ret    

00802d36 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802d36:	55                   	push   %ebp
  802d37:	89 e5                	mov    %esp,%ebp
  802d39:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d4a:	83 ec 0c             	sub    $0xc,%esp
  802d4d:	50                   	push   %eax
  802d4e:	e8 d2 06 00 00       	call   803425 <__sys_unmap_frame>
  802d53:	83 c4 10             	add    $0x10,%esp
  802d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802d59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5d:	79 17                	jns    802d76 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 1c 56 80 00       	push   $0x80561c
  802d67:	68 f5 00 00 00       	push   $0xf5
  802d6c:	68 11 54 80 00       	push   $0x805411
  802d71:	e8 ea e6 ff ff       	call   801460 <_panic>
}
  802d76:	90                   	nop
  802d77:	c9                   	leave  
  802d78:	c3                   	ret    

00802d79 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
  802d7c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d7f:	e8 f4 fe ff ff       	call   802c78 <uheap_init>
	if (size == 0) return NULL ;
  802d84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d88:	75 0a                	jne    802d94 <malloc+0x1b>
  802d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8f:	e9 67 01 00 00       	jmp    802efb <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802d94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802d9b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802da2:	77 16                	ja     802dba <malloc+0x41>
		result = alloc_block(size);
  802da4:	83 ec 0c             	sub    $0xc,%esp
  802da7:	ff 75 08             	pushl  0x8(%ebp)
  802daa:	e8 46 0e 00 00       	call   803bf5 <alloc_block>
  802daf:	83 c4 10             	add    $0x10,%esp
  802db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db5:	e9 3e 01 00 00       	jmp    802ef8 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802dba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	01 d0                	add    %edx,%eax
  802dc9:	48                   	dec    %eax
  802dca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd5:	f7 75 f0             	divl   -0x10(%ebp)
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	29 d0                	sub    %edx,%eax
  802ddd:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802de0:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	75 0a                	jne    802df3 <malloc+0x7a>
			return NULL;
  802de9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dee:	e9 08 01 00 00       	jmp    802efb <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802df3:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0f                	je     802e0b <malloc+0x92>
  802dfc:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802e02:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802e07:	39 c2                	cmp    %eax,%edx
  802e09:	73 0a                	jae    802e15 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802e0b:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802e10:	a3 50 e2 81 00       	mov    %eax,0x81e250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802e15:	a1 44 e2 81 00       	mov    0x81e244,%eax
  802e1a:	83 f8 05             	cmp    $0x5,%eax
  802e1d:	75 11                	jne    802e30 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802e1f:	83 ec 0c             	sub    $0xc,%esp
  802e22:	ff 75 e8             	pushl  -0x18(%ebp)
  802e25:	e8 ff f9 ff ff       	call   802829 <alloc_pages_custom_fit>
  802e2a:	83 c4 10             	add    $0x10,%esp
  802e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802e30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e34:	0f 84 be 00 00 00    	je     802ef8 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802e40:	83 ec 0c             	sub    $0xc,%esp
  802e43:	ff 75 f4             	pushl  -0xc(%ebp)
  802e46:	e8 9a fb ff ff       	call   8029e5 <find_allocated_size>
  802e4b:	83 c4 10             	add    $0x10,%esp
  802e4e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802e51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e55:	75 17                	jne    802e6e <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802e57:	ff 75 f4             	pushl  -0xc(%ebp)
  802e5a:	68 5c 56 80 00       	push   $0x80565c
  802e5f:	68 24 01 00 00       	push   $0x124
  802e64:	68 11 54 80 00       	push   $0x805411
  802e69:	e8 f2 e5 ff ff       	call   801460 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802e6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e71:	f7 d0                	not    %eax
  802e73:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e76:	73 1d                	jae    802e95 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802e78:	83 ec 0c             	sub    $0xc,%esp
  802e7b:	ff 75 e0             	pushl  -0x20(%ebp)
  802e7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e81:	68 a4 56 80 00       	push   $0x8056a4
  802e86:	68 29 01 00 00       	push   $0x129
  802e8b:	68 11 54 80 00       	push   $0x805411
  802e90:	e8 cb e5 ff ff       	call   801460 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802e95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9b:	01 d0                	add    %edx,%eax
  802e9d:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	79 2c                	jns    802ed3 <malloc+0x15a>
  802ea7:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802eae:	77 23                	ja     802ed3 <malloc+0x15a>
  802eb0:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802eb7:	77 1a                	ja     802ed3 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	79 13                	jns    802ed3 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802ec0:	83 ec 08             	sub    $0x8,%esp
  802ec3:	ff 75 e0             	pushl  -0x20(%ebp)
  802ec6:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ec9:	e8 de 09 00 00       	call   8038ac <sys_allocate_user_mem>
  802ece:	83 c4 10             	add    $0x10,%esp
  802ed1:	eb 25                	jmp    802ef8 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802ed3:	68 00 00 00 a0       	push   $0xa0000000
  802ed8:	ff 75 dc             	pushl  -0x24(%ebp)
  802edb:	ff 75 e0             	pushl  -0x20(%ebp)
  802ede:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee4:	68 e0 56 80 00       	push   $0x8056e0
  802ee9:	68 33 01 00 00       	push   $0x133
  802eee:	68 11 54 80 00       	push   $0x805411
  802ef3:	e8 68 e5 ff ff       	call   801460 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802efb:	c9                   	leave  
  802efc:	c3                   	ret    

00802efd <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802efd:	55                   	push   %ebp
  802efe:	89 e5                	mov    %esp,%ebp
  802f00:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f07:	0f 84 26 01 00 00    	je     803033 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	79 1c                	jns    802f36 <free+0x39>
  802f1a:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802f21:	77 13                	ja     802f36 <free+0x39>
		free_block(virtual_address);
  802f23:	83 ec 0c             	sub    $0xc,%esp
  802f26:	ff 75 08             	pushl  0x8(%ebp)
  802f29:	e8 21 12 00 00       	call   80414f <free_block>
  802f2e:	83 c4 10             	add    $0x10,%esp
		return;
  802f31:	e9 01 01 00 00       	jmp    803037 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802f36:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802f3b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802f3e:	0f 82 d8 00 00 00    	jb     80301c <free+0x11f>
  802f44:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802f4b:	0f 87 cb 00 00 00    	ja     80301c <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	25 ff 0f 00 00       	and    $0xfff,%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	74 17                	je     802f74 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802f5d:	ff 75 08             	pushl  0x8(%ebp)
  802f60:	68 50 57 80 00       	push   $0x805750
  802f65:	68 57 01 00 00       	push   $0x157
  802f6a:	68 11 54 80 00       	push   $0x805411
  802f6f:	e8 ec e4 ff ff       	call   801460 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802f74:	83 ec 0c             	sub    $0xc,%esp
  802f77:	ff 75 08             	pushl  0x8(%ebp)
  802f7a:	e8 66 fa ff ff       	call   8029e5 <find_allocated_size>
  802f7f:	83 c4 10             	add    $0x10,%esp
  802f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802f85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f89:	0f 84 a7 00 00 00    	je     803036 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	f7 d0                	not    %eax
  802f94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f97:	73 1d                	jae    802fb6 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802f99:	83 ec 0c             	sub    $0xc,%esp
  802f9c:	ff 75 f0             	pushl  -0x10(%ebp)
  802f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa2:	68 78 57 80 00       	push   $0x805778
  802fa7:	68 61 01 00 00       	push   $0x161
  802fac:	68 11 54 80 00       	push   $0x805411
  802fb1:	e8 aa e4 ff ff       	call   801460 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	01 d0                	add    %edx,%eax
  802fbe:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	79 19                	jns    802fe1 <free+0xe4>
  802fc8:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802fcf:	77 10                	ja     802fe1 <free+0xe4>
  802fd1:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802fd8:	77 07                	ja     802fe1 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	78 2b                	js     80300c <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	68 00 00 00 a0       	push   $0xa0000000
  802fe9:	ff 75 ec             	pushl  -0x14(%ebp)
  802fec:	ff 75 f0             	pushl  -0x10(%ebp)
  802fef:	ff 75 f4             	pushl  -0xc(%ebp)
  802ff2:	ff 75 f0             	pushl  -0x10(%ebp)
  802ff5:	ff 75 08             	pushl  0x8(%ebp)
  802ff8:	68 b4 57 80 00       	push   $0x8057b4
  802ffd:	68 69 01 00 00       	push   $0x169
  803002:	68 11 54 80 00       	push   $0x805411
  803007:	e8 54 e4 ff ff       	call   801460 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80300c:	83 ec 0c             	sub    $0xc,%esp
  80300f:	ff 75 08             	pushl  0x8(%ebp)
  803012:	e8 2c fa ff ff       	call   802a43 <free_pages>
  803017:	83 c4 10             	add    $0x10,%esp
		return;
  80301a:	eb 1b                	jmp    803037 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80301c:	ff 75 08             	pushl  0x8(%ebp)
  80301f:	68 10 58 80 00       	push   $0x805810
  803024:	68 70 01 00 00       	push   $0x170
  803029:	68 11 54 80 00       	push   $0x805411
  80302e:	e8 2d e4 ff ff       	call   801460 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803033:	90                   	nop
  803034:	eb 01                	jmp    803037 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  803036:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  803037:	c9                   	leave  
  803038:	c3                   	ret    

00803039 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  803039:	55                   	push   %ebp
  80303a:	89 e5                	mov    %esp,%ebp
  80303c:	83 ec 38             	sub    $0x38,%esp
  80303f:	8b 45 10             	mov    0x10(%ebp),%eax
  803042:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803045:	e8 2e fc ff ff       	call   802c78 <uheap_init>
	if (size == 0) return NULL ;
  80304a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80304e:	75 0a                	jne    80305a <smalloc+0x21>
  803050:	b8 00 00 00 00       	mov    $0x0,%eax
  803055:	e9 3d 01 00 00       	jmp    803197 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80305a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  803060:	8b 45 0c             	mov    0xc(%ebp),%eax
  803063:	25 ff 0f 00 00       	and    $0xfff,%eax
  803068:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80306b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80306f:	74 0e                	je     80307f <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803077:	05 00 10 00 00       	add    $0x1000,%eax
  80307c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	c1 e8 0c             	shr    $0xc,%eax
  803085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  803088:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80308d:	85 c0                	test   %eax,%eax
  80308f:	75 0a                	jne    80309b <smalloc+0x62>
		return NULL;
  803091:	b8 00 00 00 00       	mov    $0x0,%eax
  803096:	e9 fc 00 00 00       	jmp    803197 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80309b:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 0f                	je     8030b3 <smalloc+0x7a>
  8030a4:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8030aa:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030af:	39 c2                	cmp    %eax,%edx
  8030b1:	73 0a                	jae    8030bd <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8030b3:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030b8:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8030bd:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030c2:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8030c7:	29 c2                	sub    %eax,%edx
  8030c9:	89 d0                	mov    %edx,%eax
  8030cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8030ce:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8030d4:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030d9:	29 c2                	sub    %eax,%edx
  8030db:	89 d0                	mov    %edx,%eax
  8030dd:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030e6:	77 13                	ja     8030fb <smalloc+0xc2>
  8030e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030eb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030ee:	77 0b                	ja     8030fb <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8030f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f3:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8030f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030f9:	73 0a                	jae    803105 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8030fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803100:	e9 92 00 00 00       	jmp    803197 <smalloc+0x15e>
	}

	void *va = NULL;
  803105:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80310c:	a1 44 e2 81 00       	mov    0x81e244,%eax
  803111:	83 f8 05             	cmp    $0x5,%eax
  803114:	75 11                	jne    803127 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  803116:	83 ec 0c             	sub    $0xc,%esp
  803119:	ff 75 f4             	pushl  -0xc(%ebp)
  80311c:	e8 08 f7 ff ff       	call   802829 <alloc_pages_custom_fit>
  803121:	83 c4 10             	add    $0x10,%esp
  803124:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  803127:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80312b:	75 27                	jne    803154 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80312d:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  803134:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803137:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80313a:	89 c2                	mov    %eax,%edx
  80313c:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803141:	39 c2                	cmp    %eax,%edx
  803143:	73 07                	jae    80314c <smalloc+0x113>
			return NULL;}
  803145:	b8 00 00 00 00       	mov    $0x0,%eax
  80314a:	eb 4b                	jmp    803197 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80314c:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803151:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  803154:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  803158:	ff 75 f0             	pushl  -0x10(%ebp)
  80315b:	50                   	push   %eax
  80315c:	ff 75 0c             	pushl  0xc(%ebp)
  80315f:	ff 75 08             	pushl  0x8(%ebp)
  803162:	e8 cb 03 00 00       	call   803532 <sys_create_shared_object>
  803167:	83 c4 10             	add    $0x10,%esp
  80316a:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80316d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803171:	79 07                	jns    80317a <smalloc+0x141>
		return NULL;
  803173:	b8 00 00 00 00       	mov    $0x0,%eax
  803178:	eb 1d                	jmp    803197 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80317a:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80317f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803182:	75 10                	jne    803194 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  803184:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	01 d0                	add    %edx,%eax
  80318f:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}

	return va;
  803194:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  803197:	c9                   	leave  
  803198:	c3                   	ret    

00803199 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803199:	55                   	push   %ebp
  80319a:	89 e5                	mov    %esp,%ebp
  80319c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80319f:	e8 d4 fa ff ff       	call   802c78 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8031a4:	83 ec 08             	sub    $0x8,%esp
  8031a7:	ff 75 0c             	pushl  0xc(%ebp)
  8031aa:	ff 75 08             	pushl  0x8(%ebp)
  8031ad:	e8 aa 03 00 00       	call   80355c <sys_size_of_shared_object>
  8031b2:	83 c4 10             	add    $0x10,%esp
  8031b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8031b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031bc:	7f 0a                	jg     8031c8 <sget+0x2f>
		return NULL;
  8031be:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c3:	e9 32 01 00 00       	jmp    8032fa <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8031c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8031ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d1:	25 ff 0f 00 00       	and    $0xfff,%eax
  8031d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8031d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031dd:	74 0e                	je     8031ed <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8031e5:	05 00 10 00 00       	add    $0x1000,%eax
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8031ed:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	75 0a                	jne    803200 <sget+0x67>
		return NULL;
  8031f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fb:	e9 fa 00 00 00       	jmp    8032fa <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  803200:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 0f                	je     803218 <sget+0x7f>
  803209:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80320f:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803214:	39 c2                	cmp    %eax,%edx
  803216:	73 0a                	jae    803222 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  803218:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80321d:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803222:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803227:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80322c:	29 c2                	sub    %eax,%edx
  80322e:	89 d0                	mov    %edx,%eax
  803230:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803233:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  803239:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80323e:	29 c2                	sub    %eax,%edx
  803240:	89 d0                	mov    %edx,%eax
  803242:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  803245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803248:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80324b:	77 13                	ja     803260 <sget+0xc7>
  80324d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803250:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803253:	77 0b                	ja     803260 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  803255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803258:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80325b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80325e:	73 0a                	jae    80326a <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  803260:	b8 00 00 00 00       	mov    $0x0,%eax
  803265:	e9 90 00 00 00       	jmp    8032fa <sget+0x161>

	void *va = NULL;
  80326a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  803271:	a1 44 e2 81 00       	mov    0x81e244,%eax
  803276:	83 f8 05             	cmp    $0x5,%eax
  803279:	75 11                	jne    80328c <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80327b:	83 ec 0c             	sub    $0xc,%esp
  80327e:	ff 75 f4             	pushl  -0xc(%ebp)
  803281:	e8 a3 f5 ff ff       	call   802829 <alloc_pages_custom_fit>
  803286:	83 c4 10             	add    $0x10,%esp
  803289:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80328c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803290:	75 27                	jne    8032b9 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803292:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  803299:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80329f:	89 c2                	mov    %eax,%edx
  8032a1:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032a6:	39 c2                	cmp    %eax,%edx
  8032a8:	73 07                	jae    8032b1 <sget+0x118>
			return NULL;
  8032aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032af:	eb 49                	jmp    8032fa <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8032b1:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8032b9:	83 ec 04             	sub    $0x4,%esp
  8032bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8032bf:	ff 75 0c             	pushl  0xc(%ebp)
  8032c2:	ff 75 08             	pushl  0x8(%ebp)
  8032c5:	e8 af 02 00 00       	call   803579 <sys_get_shared_object>
  8032ca:	83 c4 10             	add    $0x10,%esp
  8032cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8032d0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032d4:	79 07                	jns    8032dd <sget+0x144>
		return NULL;
  8032d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032db:	eb 1d                	jmp    8032fa <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8032dd:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032e2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8032e5:	75 10                	jne    8032f7 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8032e7:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	01 d0                	add    %edx,%eax
  8032f2:	a3 50 e2 81 00       	mov    %eax,0x81e250

	return va;
  8032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8032fa:	c9                   	leave  
  8032fb:	c3                   	ret    

008032fc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8032fc:	55                   	push   %ebp
  8032fd:	89 e5                	mov    %esp,%ebp
  8032ff:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803302:	e8 71 f9 ff ff       	call   802c78 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803307:	83 ec 04             	sub    $0x4,%esp
  80330a:	68 34 58 80 00       	push   $0x805834
  80330f:	68 19 02 00 00       	push   $0x219
  803314:	68 11 54 80 00       	push   $0x805411
  803319:	e8 42 e1 ff ff       	call   801460 <_panic>

0080331e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80331e:	55                   	push   %ebp
  80331f:	89 e5                	mov    %esp,%ebp
  803321:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803324:	83 ec 04             	sub    $0x4,%esp
  803327:	68 5c 58 80 00       	push   $0x80585c
  80332c:	68 2b 02 00 00       	push   $0x22b
  803331:	68 11 54 80 00       	push   $0x805411
  803336:	e8 25 e1 ff ff       	call   801460 <_panic>

0080333b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80333b:	55                   	push   %ebp
  80333c:	89 e5                	mov    %esp,%ebp
  80333e:	57                   	push   %edi
  80333f:	56                   	push   %esi
  803340:	53                   	push   %ebx
  803341:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80334a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80334d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803350:	8b 7d 18             	mov    0x18(%ebp),%edi
  803353:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803356:	cd 30                	int    $0x30
  803358:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80335b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80335e:	83 c4 10             	add    $0x10,%esp
  803361:	5b                   	pop    %ebx
  803362:	5e                   	pop    %esi
  803363:	5f                   	pop    %edi
  803364:	5d                   	pop    %ebp
  803365:	c3                   	ret    

00803366 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803366:	55                   	push   %ebp
  803367:	89 e5                	mov    %esp,%ebp
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	8b 45 10             	mov    0x10(%ebp),%eax
  80336f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803372:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803375:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	6a 00                	push   $0x0
  80337e:	51                   	push   %ecx
  80337f:	52                   	push   %edx
  803380:	ff 75 0c             	pushl  0xc(%ebp)
  803383:	50                   	push   %eax
  803384:	6a 00                	push   $0x0
  803386:	e8 b0 ff ff ff       	call   80333b <syscall>
  80338b:	83 c4 18             	add    $0x18,%esp
}
  80338e:	90                   	nop
  80338f:	c9                   	leave  
  803390:	c3                   	ret    

00803391 <sys_cgetc>:

int
sys_cgetc(void)
{
  803391:	55                   	push   %ebp
  803392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803394:	6a 00                	push   $0x0
  803396:	6a 00                	push   $0x0
  803398:	6a 00                	push   $0x0
  80339a:	6a 00                	push   $0x0
  80339c:	6a 00                	push   $0x0
  80339e:	6a 02                	push   $0x2
  8033a0:	e8 96 ff ff ff       	call   80333b <syscall>
  8033a5:	83 c4 18             	add    $0x18,%esp
}
  8033a8:	c9                   	leave  
  8033a9:	c3                   	ret    

008033aa <sys_lock_cons>:

void sys_lock_cons(void)
{
  8033aa:	55                   	push   %ebp
  8033ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8033ad:	6a 00                	push   $0x0
  8033af:	6a 00                	push   $0x0
  8033b1:	6a 00                	push   $0x0
  8033b3:	6a 00                	push   $0x0
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 03                	push   $0x3
  8033b9:	e8 7d ff ff ff       	call   80333b <syscall>
  8033be:	83 c4 18             	add    $0x18,%esp
}
  8033c1:	90                   	nop
  8033c2:	c9                   	leave  
  8033c3:	c3                   	ret    

008033c4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8033c4:	55                   	push   %ebp
  8033c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8033c7:	6a 00                	push   $0x0
  8033c9:	6a 00                	push   $0x0
  8033cb:	6a 00                	push   $0x0
  8033cd:	6a 00                	push   $0x0
  8033cf:	6a 00                	push   $0x0
  8033d1:	6a 04                	push   $0x4
  8033d3:	e8 63 ff ff ff       	call   80333b <syscall>
  8033d8:	83 c4 18             	add    $0x18,%esp
}
  8033db:	90                   	nop
  8033dc:	c9                   	leave  
  8033dd:	c3                   	ret    

008033de <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8033de:	55                   	push   %ebp
  8033df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8033e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	6a 00                	push   $0x0
  8033e9:	6a 00                	push   $0x0
  8033eb:	6a 00                	push   $0x0
  8033ed:	52                   	push   %edx
  8033ee:	50                   	push   %eax
  8033ef:	6a 08                	push   $0x8
  8033f1:	e8 45 ff ff ff       	call   80333b <syscall>
  8033f6:	83 c4 18             	add    $0x18,%esp
}
  8033f9:	c9                   	leave  
  8033fa:	c3                   	ret    

008033fb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8033fb:	55                   	push   %ebp
  8033fc:	89 e5                	mov    %esp,%ebp
  8033fe:	56                   	push   %esi
  8033ff:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803400:	8b 75 18             	mov    0x18(%ebp),%esi
  803403:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803406:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803409:	8b 55 0c             	mov    0xc(%ebp),%edx
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	56                   	push   %esi
  803410:	53                   	push   %ebx
  803411:	51                   	push   %ecx
  803412:	52                   	push   %edx
  803413:	50                   	push   %eax
  803414:	6a 09                	push   $0x9
  803416:	e8 20 ff ff ff       	call   80333b <syscall>
  80341b:	83 c4 18             	add    $0x18,%esp
}
  80341e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803421:	5b                   	pop    %ebx
  803422:	5e                   	pop    %esi
  803423:	5d                   	pop    %ebp
  803424:	c3                   	ret    

00803425 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803425:	55                   	push   %ebp
  803426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803428:	6a 00                	push   $0x0
  80342a:	6a 00                	push   $0x0
  80342c:	6a 00                	push   $0x0
  80342e:	6a 00                	push   $0x0
  803430:	ff 75 08             	pushl  0x8(%ebp)
  803433:	6a 0a                	push   $0xa
  803435:	e8 01 ff ff ff       	call   80333b <syscall>
  80343a:	83 c4 18             	add    $0x18,%esp
}
  80343d:	c9                   	leave  
  80343e:	c3                   	ret    

0080343f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80343f:	55                   	push   %ebp
  803440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803442:	6a 00                	push   $0x0
  803444:	6a 00                	push   $0x0
  803446:	6a 00                	push   $0x0
  803448:	ff 75 0c             	pushl  0xc(%ebp)
  80344b:	ff 75 08             	pushl  0x8(%ebp)
  80344e:	6a 0b                	push   $0xb
  803450:	e8 e6 fe ff ff       	call   80333b <syscall>
  803455:	83 c4 18             	add    $0x18,%esp
}
  803458:	c9                   	leave  
  803459:	c3                   	ret    

0080345a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80345a:	55                   	push   %ebp
  80345b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80345d:	6a 00                	push   $0x0
  80345f:	6a 00                	push   $0x0
  803461:	6a 00                	push   $0x0
  803463:	6a 00                	push   $0x0
  803465:	6a 00                	push   $0x0
  803467:	6a 0c                	push   $0xc
  803469:	e8 cd fe ff ff       	call   80333b <syscall>
  80346e:	83 c4 18             	add    $0x18,%esp
}
  803471:	c9                   	leave  
  803472:	c3                   	ret    

00803473 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803473:	55                   	push   %ebp
  803474:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803476:	6a 00                	push   $0x0
  803478:	6a 00                	push   $0x0
  80347a:	6a 00                	push   $0x0
  80347c:	6a 00                	push   $0x0
  80347e:	6a 00                	push   $0x0
  803480:	6a 0d                	push   $0xd
  803482:	e8 b4 fe ff ff       	call   80333b <syscall>
  803487:	83 c4 18             	add    $0x18,%esp
}
  80348a:	c9                   	leave  
  80348b:	c3                   	ret    

0080348c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80348c:	55                   	push   %ebp
  80348d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80348f:	6a 00                	push   $0x0
  803491:	6a 00                	push   $0x0
  803493:	6a 00                	push   $0x0
  803495:	6a 00                	push   $0x0
  803497:	6a 00                	push   $0x0
  803499:	6a 0e                	push   $0xe
  80349b:	e8 9b fe ff ff       	call   80333b <syscall>
  8034a0:	83 c4 18             	add    $0x18,%esp
}
  8034a3:	c9                   	leave  
  8034a4:	c3                   	ret    

008034a5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8034a5:	55                   	push   %ebp
  8034a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8034a8:	6a 00                	push   $0x0
  8034aa:	6a 00                	push   $0x0
  8034ac:	6a 00                	push   $0x0
  8034ae:	6a 00                	push   $0x0
  8034b0:	6a 00                	push   $0x0
  8034b2:	6a 0f                	push   $0xf
  8034b4:	e8 82 fe ff ff       	call   80333b <syscall>
  8034b9:	83 c4 18             	add    $0x18,%esp
}
  8034bc:	c9                   	leave  
  8034bd:	c3                   	ret    

008034be <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8034be:	55                   	push   %ebp
  8034bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8034c1:	6a 00                	push   $0x0
  8034c3:	6a 00                	push   $0x0
  8034c5:	6a 00                	push   $0x0
  8034c7:	6a 00                	push   $0x0
  8034c9:	ff 75 08             	pushl  0x8(%ebp)
  8034cc:	6a 10                	push   $0x10
  8034ce:	e8 68 fe ff ff       	call   80333b <syscall>
  8034d3:	83 c4 18             	add    $0x18,%esp
}
  8034d6:	c9                   	leave  
  8034d7:	c3                   	ret    

008034d8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8034d8:	55                   	push   %ebp
  8034d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8034db:	6a 00                	push   $0x0
  8034dd:	6a 00                	push   $0x0
  8034df:	6a 00                	push   $0x0
  8034e1:	6a 00                	push   $0x0
  8034e3:	6a 00                	push   $0x0
  8034e5:	6a 11                	push   $0x11
  8034e7:	e8 4f fe ff ff       	call   80333b <syscall>
  8034ec:	83 c4 18             	add    $0x18,%esp
}
  8034ef:	90                   	nop
  8034f0:	c9                   	leave  
  8034f1:	c3                   	ret    

008034f2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8034f2:	55                   	push   %ebp
  8034f3:	89 e5                	mov    %esp,%ebp
  8034f5:	83 ec 04             	sub    $0x4,%esp
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8034fe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803502:	6a 00                	push   $0x0
  803504:	6a 00                	push   $0x0
  803506:	6a 00                	push   $0x0
  803508:	6a 00                	push   $0x0
  80350a:	50                   	push   %eax
  80350b:	6a 01                	push   $0x1
  80350d:	e8 29 fe ff ff       	call   80333b <syscall>
  803512:	83 c4 18             	add    $0x18,%esp
}
  803515:	90                   	nop
  803516:	c9                   	leave  
  803517:	c3                   	ret    

00803518 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803518:	55                   	push   %ebp
  803519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80351b:	6a 00                	push   $0x0
  80351d:	6a 00                	push   $0x0
  80351f:	6a 00                	push   $0x0
  803521:	6a 00                	push   $0x0
  803523:	6a 00                	push   $0x0
  803525:	6a 14                	push   $0x14
  803527:	e8 0f fe ff ff       	call   80333b <syscall>
  80352c:	83 c4 18             	add    $0x18,%esp
}
  80352f:	90                   	nop
  803530:	c9                   	leave  
  803531:	c3                   	ret    

00803532 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803532:	55                   	push   %ebp
  803533:	89 e5                	mov    %esp,%ebp
  803535:	83 ec 04             	sub    $0x4,%esp
  803538:	8b 45 10             	mov    0x10(%ebp),%eax
  80353b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80353e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803541:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	6a 00                	push   $0x0
  80354a:	51                   	push   %ecx
  80354b:	52                   	push   %edx
  80354c:	ff 75 0c             	pushl  0xc(%ebp)
  80354f:	50                   	push   %eax
  803550:	6a 15                	push   $0x15
  803552:	e8 e4 fd ff ff       	call   80333b <syscall>
  803557:	83 c4 18             	add    $0x18,%esp
}
  80355a:	c9                   	leave  
  80355b:	c3                   	ret    

0080355c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80355c:	55                   	push   %ebp
  80355d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80355f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	6a 00                	push   $0x0
  803567:	6a 00                	push   $0x0
  803569:	6a 00                	push   $0x0
  80356b:	52                   	push   %edx
  80356c:	50                   	push   %eax
  80356d:	6a 16                	push   $0x16
  80356f:	e8 c7 fd ff ff       	call   80333b <syscall>
  803574:	83 c4 18             	add    $0x18,%esp
}
  803577:	c9                   	leave  
  803578:	c3                   	ret    

00803579 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803579:	55                   	push   %ebp
  80357a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80357c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80357f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	6a 00                	push   $0x0
  803587:	6a 00                	push   $0x0
  803589:	51                   	push   %ecx
  80358a:	52                   	push   %edx
  80358b:	50                   	push   %eax
  80358c:	6a 17                	push   $0x17
  80358e:	e8 a8 fd ff ff       	call   80333b <syscall>
  803593:	83 c4 18             	add    $0x18,%esp
}
  803596:	c9                   	leave  
  803597:	c3                   	ret    

00803598 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803598:	55                   	push   %ebp
  803599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80359b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	6a 00                	push   $0x0
  8035a3:	6a 00                	push   $0x0
  8035a5:	6a 00                	push   $0x0
  8035a7:	52                   	push   %edx
  8035a8:	50                   	push   %eax
  8035a9:	6a 18                	push   $0x18
  8035ab:	e8 8b fd ff ff       	call   80333b <syscall>
  8035b0:	83 c4 18             	add    $0x18,%esp
}
  8035b3:	c9                   	leave  
  8035b4:	c3                   	ret    

008035b5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8035b5:	55                   	push   %ebp
  8035b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	6a 00                	push   $0x0
  8035bd:	ff 75 14             	pushl  0x14(%ebp)
  8035c0:	ff 75 10             	pushl  0x10(%ebp)
  8035c3:	ff 75 0c             	pushl  0xc(%ebp)
  8035c6:	50                   	push   %eax
  8035c7:	6a 19                	push   $0x19
  8035c9:	e8 6d fd ff ff       	call   80333b <syscall>
  8035ce:	83 c4 18             	add    $0x18,%esp
}
  8035d1:	c9                   	leave  
  8035d2:	c3                   	ret    

008035d3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8035d3:	55                   	push   %ebp
  8035d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	6a 00                	push   $0x0
  8035db:	6a 00                	push   $0x0
  8035dd:	6a 00                	push   $0x0
  8035df:	6a 00                	push   $0x0
  8035e1:	50                   	push   %eax
  8035e2:	6a 1a                	push   $0x1a
  8035e4:	e8 52 fd ff ff       	call   80333b <syscall>
  8035e9:	83 c4 18             	add    $0x18,%esp
}
  8035ec:	90                   	nop
  8035ed:	c9                   	leave  
  8035ee:	c3                   	ret    

008035ef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8035ef:	55                   	push   %ebp
  8035f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	6a 00                	push   $0x0
  8035f7:	6a 00                	push   $0x0
  8035f9:	6a 00                	push   $0x0
  8035fb:	6a 00                	push   $0x0
  8035fd:	50                   	push   %eax
  8035fe:	6a 1b                	push   $0x1b
  803600:	e8 36 fd ff ff       	call   80333b <syscall>
  803605:	83 c4 18             	add    $0x18,%esp
}
  803608:	c9                   	leave  
  803609:	c3                   	ret    

0080360a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80360a:	55                   	push   %ebp
  80360b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80360d:	6a 00                	push   $0x0
  80360f:	6a 00                	push   $0x0
  803611:	6a 00                	push   $0x0
  803613:	6a 00                	push   $0x0
  803615:	6a 00                	push   $0x0
  803617:	6a 05                	push   $0x5
  803619:	e8 1d fd ff ff       	call   80333b <syscall>
  80361e:	83 c4 18             	add    $0x18,%esp
}
  803621:	c9                   	leave  
  803622:	c3                   	ret    

00803623 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803623:	55                   	push   %ebp
  803624:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803626:	6a 00                	push   $0x0
  803628:	6a 00                	push   $0x0
  80362a:	6a 00                	push   $0x0
  80362c:	6a 00                	push   $0x0
  80362e:	6a 00                	push   $0x0
  803630:	6a 06                	push   $0x6
  803632:	e8 04 fd ff ff       	call   80333b <syscall>
  803637:	83 c4 18             	add    $0x18,%esp
}
  80363a:	c9                   	leave  
  80363b:	c3                   	ret    

0080363c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80363f:	6a 00                	push   $0x0
  803641:	6a 00                	push   $0x0
  803643:	6a 00                	push   $0x0
  803645:	6a 00                	push   $0x0
  803647:	6a 00                	push   $0x0
  803649:	6a 07                	push   $0x7
  80364b:	e8 eb fc ff ff       	call   80333b <syscall>
  803650:	83 c4 18             	add    $0x18,%esp
}
  803653:	c9                   	leave  
  803654:	c3                   	ret    

00803655 <sys_exit_env>:


void sys_exit_env(void)
{
  803655:	55                   	push   %ebp
  803656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803658:	6a 00                	push   $0x0
  80365a:	6a 00                	push   $0x0
  80365c:	6a 00                	push   $0x0
  80365e:	6a 00                	push   $0x0
  803660:	6a 00                	push   $0x0
  803662:	6a 1c                	push   $0x1c
  803664:	e8 d2 fc ff ff       	call   80333b <syscall>
  803669:	83 c4 18             	add    $0x18,%esp
}
  80366c:	90                   	nop
  80366d:	c9                   	leave  
  80366e:	c3                   	ret    

0080366f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80366f:	55                   	push   %ebp
  803670:	89 e5                	mov    %esp,%ebp
  803672:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803675:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803678:	8d 50 04             	lea    0x4(%eax),%edx
  80367b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80367e:	6a 00                	push   $0x0
  803680:	6a 00                	push   $0x0
  803682:	6a 00                	push   $0x0
  803684:	52                   	push   %edx
  803685:	50                   	push   %eax
  803686:	6a 1d                	push   $0x1d
  803688:	e8 ae fc ff ff       	call   80333b <syscall>
  80368d:	83 c4 18             	add    $0x18,%esp
	return result;
  803690:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803693:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803696:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803699:	89 01                	mov    %eax,(%ecx)
  80369b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80369e:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a1:	c9                   	leave  
  8036a2:	c2 04 00             	ret    $0x4

008036a5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8036a5:	55                   	push   %ebp
  8036a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8036a8:	6a 00                	push   $0x0
  8036aa:	6a 00                	push   $0x0
  8036ac:	ff 75 10             	pushl  0x10(%ebp)
  8036af:	ff 75 0c             	pushl  0xc(%ebp)
  8036b2:	ff 75 08             	pushl  0x8(%ebp)
  8036b5:	6a 13                	push   $0x13
  8036b7:	e8 7f fc ff ff       	call   80333b <syscall>
  8036bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8036bf:	90                   	nop
}
  8036c0:	c9                   	leave  
  8036c1:	c3                   	ret    

008036c2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8036c2:	55                   	push   %ebp
  8036c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8036c5:	6a 00                	push   $0x0
  8036c7:	6a 00                	push   $0x0
  8036c9:	6a 00                	push   $0x0
  8036cb:	6a 00                	push   $0x0
  8036cd:	6a 00                	push   $0x0
  8036cf:	6a 1e                	push   $0x1e
  8036d1:	e8 65 fc ff ff       	call   80333b <syscall>
  8036d6:	83 c4 18             	add    $0x18,%esp
}
  8036d9:	c9                   	leave  
  8036da:	c3                   	ret    

008036db <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8036db:	55                   	push   %ebp
  8036dc:	89 e5                	mov    %esp,%ebp
  8036de:	83 ec 04             	sub    $0x4,%esp
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8036e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8036eb:	6a 00                	push   $0x0
  8036ed:	6a 00                	push   $0x0
  8036ef:	6a 00                	push   $0x0
  8036f1:	6a 00                	push   $0x0
  8036f3:	50                   	push   %eax
  8036f4:	6a 1f                	push   $0x1f
  8036f6:	e8 40 fc ff ff       	call   80333b <syscall>
  8036fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8036fe:	90                   	nop
}
  8036ff:	c9                   	leave  
  803700:	c3                   	ret    

00803701 <rsttst>:
void rsttst()
{
  803701:	55                   	push   %ebp
  803702:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803704:	6a 00                	push   $0x0
  803706:	6a 00                	push   $0x0
  803708:	6a 00                	push   $0x0
  80370a:	6a 00                	push   $0x0
  80370c:	6a 00                	push   $0x0
  80370e:	6a 21                	push   $0x21
  803710:	e8 26 fc ff ff       	call   80333b <syscall>
  803715:	83 c4 18             	add    $0x18,%esp
	return ;
  803718:	90                   	nop
}
  803719:	c9                   	leave  
  80371a:	c3                   	ret    

0080371b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80371b:	55                   	push   %ebp
  80371c:	89 e5                	mov    %esp,%ebp
  80371e:	83 ec 04             	sub    $0x4,%esp
  803721:	8b 45 14             	mov    0x14(%ebp),%eax
  803724:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803727:	8b 55 18             	mov    0x18(%ebp),%edx
  80372a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80372e:	52                   	push   %edx
  80372f:	50                   	push   %eax
  803730:	ff 75 10             	pushl  0x10(%ebp)
  803733:	ff 75 0c             	pushl  0xc(%ebp)
  803736:	ff 75 08             	pushl  0x8(%ebp)
  803739:	6a 20                	push   $0x20
  80373b:	e8 fb fb ff ff       	call   80333b <syscall>
  803740:	83 c4 18             	add    $0x18,%esp
	return ;
  803743:	90                   	nop
}
  803744:	c9                   	leave  
  803745:	c3                   	ret    

00803746 <chktst>:
void chktst(uint32 n)
{
  803746:	55                   	push   %ebp
  803747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803749:	6a 00                	push   $0x0
  80374b:	6a 00                	push   $0x0
  80374d:	6a 00                	push   $0x0
  80374f:	6a 00                	push   $0x0
  803751:	ff 75 08             	pushl  0x8(%ebp)
  803754:	6a 22                	push   $0x22
  803756:	e8 e0 fb ff ff       	call   80333b <syscall>
  80375b:	83 c4 18             	add    $0x18,%esp
	return ;
  80375e:	90                   	nop
}
  80375f:	c9                   	leave  
  803760:	c3                   	ret    

00803761 <inctst>:

void inctst()
{
  803761:	55                   	push   %ebp
  803762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803764:	6a 00                	push   $0x0
  803766:	6a 00                	push   $0x0
  803768:	6a 00                	push   $0x0
  80376a:	6a 00                	push   $0x0
  80376c:	6a 00                	push   $0x0
  80376e:	6a 23                	push   $0x23
  803770:	e8 c6 fb ff ff       	call   80333b <syscall>
  803775:	83 c4 18             	add    $0x18,%esp
	return ;
  803778:	90                   	nop
}
  803779:	c9                   	leave  
  80377a:	c3                   	ret    

0080377b <gettst>:
uint32 gettst()
{
  80377b:	55                   	push   %ebp
  80377c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80377e:	6a 00                	push   $0x0
  803780:	6a 00                	push   $0x0
  803782:	6a 00                	push   $0x0
  803784:	6a 00                	push   $0x0
  803786:	6a 00                	push   $0x0
  803788:	6a 24                	push   $0x24
  80378a:	e8 ac fb ff ff       	call   80333b <syscall>
  80378f:	83 c4 18             	add    $0x18,%esp
}
  803792:	c9                   	leave  
  803793:	c3                   	ret    

00803794 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803794:	55                   	push   %ebp
  803795:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803797:	6a 00                	push   $0x0
  803799:	6a 00                	push   $0x0
  80379b:	6a 00                	push   $0x0
  80379d:	6a 00                	push   $0x0
  80379f:	6a 00                	push   $0x0
  8037a1:	6a 25                	push   $0x25
  8037a3:	e8 93 fb ff ff       	call   80333b <syscall>
  8037a8:	83 c4 18             	add    $0x18,%esp
  8037ab:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  8037b0:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  8037b5:	c9                   	leave  
  8037b6:	c3                   	ret    

008037b7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8037b7:	55                   	push   %ebp
  8037b8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8037ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bd:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8037c2:	6a 00                	push   $0x0
  8037c4:	6a 00                	push   $0x0
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	ff 75 08             	pushl  0x8(%ebp)
  8037cd:	6a 26                	push   $0x26
  8037cf:	e8 67 fb ff ff       	call   80333b <syscall>
  8037d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8037d7:	90                   	nop
}
  8037d8:	c9                   	leave  
  8037d9:	c3                   	ret    

008037da <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8037da:	55                   	push   %ebp
  8037db:	89 e5                	mov    %esp,%ebp
  8037dd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8037de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8037e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8037e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ea:	6a 00                	push   $0x0
  8037ec:	53                   	push   %ebx
  8037ed:	51                   	push   %ecx
  8037ee:	52                   	push   %edx
  8037ef:	50                   	push   %eax
  8037f0:	6a 27                	push   $0x27
  8037f2:	e8 44 fb ff ff       	call   80333b <syscall>
  8037f7:	83 c4 18             	add    $0x18,%esp
}
  8037fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037fd:	c9                   	leave  
  8037fe:	c3                   	ret    

008037ff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8037ff:	55                   	push   %ebp
  803800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803802:	8b 55 0c             	mov    0xc(%ebp),%edx
  803805:	8b 45 08             	mov    0x8(%ebp),%eax
  803808:	6a 00                	push   $0x0
  80380a:	6a 00                	push   $0x0
  80380c:	6a 00                	push   $0x0
  80380e:	52                   	push   %edx
  80380f:	50                   	push   %eax
  803810:	6a 28                	push   $0x28
  803812:	e8 24 fb ff ff       	call   80333b <syscall>
  803817:	83 c4 18             	add    $0x18,%esp
}
  80381a:	c9                   	leave  
  80381b:	c3                   	ret    

0080381c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80381c:	55                   	push   %ebp
  80381d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80381f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803822:	8b 55 0c             	mov    0xc(%ebp),%edx
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	6a 00                	push   $0x0
  80382a:	51                   	push   %ecx
  80382b:	ff 75 10             	pushl  0x10(%ebp)
  80382e:	52                   	push   %edx
  80382f:	50                   	push   %eax
  803830:	6a 29                	push   $0x29
  803832:	e8 04 fb ff ff       	call   80333b <syscall>
  803837:	83 c4 18             	add    $0x18,%esp
}
  80383a:	c9                   	leave  
  80383b:	c3                   	ret    

0080383c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80383c:	55                   	push   %ebp
  80383d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80383f:	6a 00                	push   $0x0
  803841:	6a 00                	push   $0x0
  803843:	ff 75 10             	pushl  0x10(%ebp)
  803846:	ff 75 0c             	pushl  0xc(%ebp)
  803849:	ff 75 08             	pushl  0x8(%ebp)
  80384c:	6a 12                	push   $0x12
  80384e:	e8 e8 fa ff ff       	call   80333b <syscall>
  803853:	83 c4 18             	add    $0x18,%esp
	return ;
  803856:	90                   	nop
}
  803857:	c9                   	leave  
  803858:	c3                   	ret    

00803859 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803859:	55                   	push   %ebp
  80385a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80385c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	6a 00                	push   $0x0
  803864:	6a 00                	push   $0x0
  803866:	6a 00                	push   $0x0
  803868:	52                   	push   %edx
  803869:	50                   	push   %eax
  80386a:	6a 2a                	push   $0x2a
  80386c:	e8 ca fa ff ff       	call   80333b <syscall>
  803871:	83 c4 18             	add    $0x18,%esp
	return;
  803874:	90                   	nop
}
  803875:	c9                   	leave  
  803876:	c3                   	ret    

00803877 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803877:	55                   	push   %ebp
  803878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80387a:	6a 00                	push   $0x0
  80387c:	6a 00                	push   $0x0
  80387e:	6a 00                	push   $0x0
  803880:	6a 00                	push   $0x0
  803882:	6a 00                	push   $0x0
  803884:	6a 2b                	push   $0x2b
  803886:	e8 b0 fa ff ff       	call   80333b <syscall>
  80388b:	83 c4 18             	add    $0x18,%esp
}
  80388e:	c9                   	leave  
  80388f:	c3                   	ret    

00803890 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803890:	55                   	push   %ebp
  803891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803893:	6a 00                	push   $0x0
  803895:	6a 00                	push   $0x0
  803897:	6a 00                	push   $0x0
  803899:	ff 75 0c             	pushl  0xc(%ebp)
  80389c:	ff 75 08             	pushl  0x8(%ebp)
  80389f:	6a 2d                	push   $0x2d
  8038a1:	e8 95 fa ff ff       	call   80333b <syscall>
  8038a6:	83 c4 18             	add    $0x18,%esp
	return;
  8038a9:	90                   	nop
}
  8038aa:	c9                   	leave  
  8038ab:	c3                   	ret    

008038ac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8038ac:	55                   	push   %ebp
  8038ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8038af:	6a 00                	push   $0x0
  8038b1:	6a 00                	push   $0x0
  8038b3:	6a 00                	push   $0x0
  8038b5:	ff 75 0c             	pushl  0xc(%ebp)
  8038b8:	ff 75 08             	pushl  0x8(%ebp)
  8038bb:	6a 2c                	push   $0x2c
  8038bd:	e8 79 fa ff ff       	call   80333b <syscall>
  8038c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8038c5:	90                   	nop
}
  8038c6:	c9                   	leave  
  8038c7:	c3                   	ret    

008038c8 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8038c8:	55                   	push   %ebp
  8038c9:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8038cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d1:	6a 00                	push   $0x0
  8038d3:	6a 00                	push   $0x0
  8038d5:	6a 00                	push   $0x0
  8038d7:	52                   	push   %edx
  8038d8:	50                   	push   %eax
  8038d9:	6a 2e                	push   $0x2e
  8038db:	e8 5b fa ff ff       	call   80333b <syscall>
  8038e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8038e3:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8038e4:	c9                   	leave  
  8038e5:	c3                   	ret    

008038e6 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8038e6:	55                   	push   %ebp
  8038e7:	89 e5                	mov    %esp,%ebp
  8038e9:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8038ec:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  8038f3:	72 09                	jb     8038fe <to_page_va+0x18>
  8038f5:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  8038fc:	72 14                	jb     803912 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8038fe:	83 ec 04             	sub    $0x4,%esp
  803901:	68 80 58 80 00       	push   $0x805880
  803906:	6a 15                	push   $0x15
  803908:	68 ab 58 80 00       	push   $0x8058ab
  80390d:	e8 4e db ff ff       	call   801460 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803912:	8b 45 08             	mov    0x8(%ebp),%eax
  803915:	ba 40 62 80 00       	mov    $0x806240,%edx
  80391a:	29 d0                	sub    %edx,%eax
  80391c:	c1 f8 02             	sar    $0x2,%eax
  80391f:	89 c2                	mov    %eax,%edx
  803921:	89 d0                	mov    %edx,%eax
  803923:	c1 e0 02             	shl    $0x2,%eax
  803926:	01 d0                	add    %edx,%eax
  803928:	c1 e0 02             	shl    $0x2,%eax
  80392b:	01 d0                	add    %edx,%eax
  80392d:	c1 e0 02             	shl    $0x2,%eax
  803930:	01 d0                	add    %edx,%eax
  803932:	89 c1                	mov    %eax,%ecx
  803934:	c1 e1 08             	shl    $0x8,%ecx
  803937:	01 c8                	add    %ecx,%eax
  803939:	89 c1                	mov    %eax,%ecx
  80393b:	c1 e1 10             	shl    $0x10,%ecx
  80393e:	01 c8                	add    %ecx,%eax
  803940:	01 c0                	add    %eax,%eax
  803942:	01 d0                	add    %edx,%eax
  803944:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394a:	c1 e0 0c             	shl    $0xc,%eax
  80394d:	89 c2                	mov    %eax,%edx
  80394f:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803954:	01 d0                	add    %edx,%eax
}
  803956:	c9                   	leave  
  803957:	c3                   	ret    

00803958 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803958:	55                   	push   %ebp
  803959:	89 e5                	mov    %esp,%ebp
  80395b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80395e:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803963:	8b 55 08             	mov    0x8(%ebp),%edx
  803966:	29 c2                	sub    %eax,%edx
  803968:	89 d0                	mov    %edx,%eax
  80396a:	c1 e8 0c             	shr    $0xc,%eax
  80396d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803974:	78 09                	js     80397f <to_page_info+0x27>
  803976:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80397d:	7e 14                	jle    803993 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	68 c4 58 80 00       	push   $0x8058c4
  803987:	6a 22                	push   $0x22
  803989:	68 ab 58 80 00       	push   $0x8058ab
  80398e:	e8 cd da ff ff       	call   801460 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803993:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803996:	89 d0                	mov    %edx,%eax
  803998:	01 c0                	add    %eax,%eax
  80399a:	01 d0                	add    %edx,%eax
  80399c:	c1 e0 02             	shl    $0x2,%eax
  80399f:	05 40 62 80 00       	add    $0x806240,%eax
}
  8039a4:	c9                   	leave  
  8039a5:	c3                   	ret    

008039a6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8039a6:	55                   	push   %ebp
  8039a7:	89 e5                	mov    %esp,%ebp
  8039a9:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	05 00 00 00 02       	add    $0x2000000,%eax
  8039b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039b7:	73 16                	jae    8039cf <initialize_dynamic_allocator+0x29>
  8039b9:	68 e8 58 80 00       	push   $0x8058e8
  8039be:	68 0e 59 80 00       	push   $0x80590e
  8039c3:	6a 34                	push   $0x34
  8039c5:	68 ab 58 80 00       	push   $0x8058ab
  8039ca:	e8 91 da ff ff       	call   801460 <_panic>
		is_initialized = 1;
  8039cf:	c7 05 14 62 80 00 01 	movl   $0x1,0x806214
  8039d6:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8039d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dc:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  8039e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e4:	a3 20 62 80 00       	mov    %eax,0x806220

	LIST_INIT(&freePagesList);
  8039e9:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  8039f0:	00 00 00 
  8039f3:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  8039fa:	00 00 00 
  8039fd:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  803a04:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803a07:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803a0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a15:	eb 36                	jmp    803a4d <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1a:	c1 e0 04             	shl    $0x4,%eax
  803a1d:	05 60 e2 81 00       	add    $0x81e260,%eax
  803a22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2b:	c1 e0 04             	shl    $0x4,%eax
  803a2e:	05 64 e2 81 00       	add    $0x81e264,%eax
  803a33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3c:	c1 e0 04             	shl    $0x4,%eax
  803a3f:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803a4a:	ff 45 f4             	incl   -0xc(%ebp)
  803a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a50:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a53:	72 c2                	jb     803a17 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803a55:	8b 15 20 62 80 00    	mov    0x806220,%edx
  803a5b:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803a60:	29 c2                	sub    %eax,%edx
  803a62:	89 d0                	mov    %edx,%eax
  803a64:	c1 e8 0c             	shr    $0xc,%eax
  803a67:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803a6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a71:	e9 c8 00 00 00       	jmp    803b3e <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803a76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a79:	89 d0                	mov    %edx,%eax
  803a7b:	01 c0                	add    %eax,%eax
  803a7d:	01 d0                	add    %edx,%eax
  803a7f:	c1 e0 02             	shl    $0x2,%eax
  803a82:	05 48 62 80 00       	add    $0x806248,%eax
  803a87:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803a8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a8f:	89 d0                	mov    %edx,%eax
  803a91:	01 c0                	add    %eax,%eax
  803a93:	01 d0                	add    %edx,%eax
  803a95:	c1 e0 02             	shl    $0x2,%eax
  803a98:	05 4a 62 80 00       	add    $0x80624a,%eax
  803a9d:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803aa2:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803aa8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803aab:	89 c8                	mov    %ecx,%eax
  803aad:	01 c0                	add    %eax,%eax
  803aaf:	01 c8                	add    %ecx,%eax
  803ab1:	c1 e0 02             	shl    $0x2,%eax
  803ab4:	05 44 62 80 00       	add    $0x806244,%eax
  803ab9:	89 10                	mov    %edx,(%eax)
  803abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803abe:	89 d0                	mov    %edx,%eax
  803ac0:	01 c0                	add    %eax,%eax
  803ac2:	01 d0                	add    %edx,%eax
  803ac4:	c1 e0 02             	shl    $0x2,%eax
  803ac7:	05 44 62 80 00       	add    $0x806244,%eax
  803acc:	8b 00                	mov    (%eax),%eax
  803ace:	85 c0                	test   %eax,%eax
  803ad0:	74 1b                	je     803aed <initialize_dynamic_allocator+0x147>
  803ad2:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803ad8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803adb:	89 c8                	mov    %ecx,%eax
  803add:	01 c0                	add    %eax,%eax
  803adf:	01 c8                	add    %ecx,%eax
  803ae1:	c1 e0 02             	shl    $0x2,%eax
  803ae4:	05 40 62 80 00       	add    $0x806240,%eax
  803ae9:	89 02                	mov    %eax,(%edx)
  803aeb:	eb 16                	jmp    803b03 <initialize_dynamic_allocator+0x15d>
  803aed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803af0:	89 d0                	mov    %edx,%eax
  803af2:	01 c0                	add    %eax,%eax
  803af4:	01 d0                	add    %edx,%eax
  803af6:	c1 e0 02             	shl    $0x2,%eax
  803af9:	05 40 62 80 00       	add    $0x806240,%eax
  803afe:	a3 28 62 80 00       	mov    %eax,0x806228
  803b03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b06:	89 d0                	mov    %edx,%eax
  803b08:	01 c0                	add    %eax,%eax
  803b0a:	01 d0                	add    %edx,%eax
  803b0c:	c1 e0 02             	shl    $0x2,%eax
  803b0f:	05 40 62 80 00       	add    $0x806240,%eax
  803b14:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803b19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b1c:	89 d0                	mov    %edx,%eax
  803b1e:	01 c0                	add    %eax,%eax
  803b20:	01 d0                	add    %edx,%eax
  803b22:	c1 e0 02             	shl    $0x2,%eax
  803b25:	05 40 62 80 00       	add    $0x806240,%eax
  803b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b30:	a1 34 62 80 00       	mov    0x806234,%eax
  803b35:	40                   	inc    %eax
  803b36:	a3 34 62 80 00       	mov    %eax,0x806234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803b3b:	ff 45 f0             	incl   -0x10(%ebp)
  803b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b41:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b44:	0f 82 2c ff ff ff    	jb     803a76 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803b4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b50:	eb 2f                	jmp    803b81 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803b52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b55:	89 d0                	mov    %edx,%eax
  803b57:	01 c0                	add    %eax,%eax
  803b59:	01 d0                	add    %edx,%eax
  803b5b:	c1 e0 02             	shl    $0x2,%eax
  803b5e:	05 48 62 80 00       	add    $0x806248,%eax
  803b63:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803b68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b6b:	89 d0                	mov    %edx,%eax
  803b6d:	01 c0                	add    %eax,%eax
  803b6f:	01 d0                	add    %edx,%eax
  803b71:	c1 e0 02             	shl    $0x2,%eax
  803b74:	05 4a 62 80 00       	add    $0x80624a,%eax
  803b79:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803b7e:	ff 45 ec             	incl   -0x14(%ebp)
  803b81:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803b88:	76 c8                	jbe    803b52 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803b8a:	90                   	nop
  803b8b:	c9                   	leave  
  803b8c:	c3                   	ret    

00803b8d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803b8d:	55                   	push   %ebp
  803b8e:	89 e5                	mov    %esp,%ebp
  803b90:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803b93:	8b 55 08             	mov    0x8(%ebp),%edx
  803b96:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803b9b:	29 c2                	sub    %eax,%edx
  803b9d:	89 d0                	mov    %edx,%eax
  803b9f:	c1 e8 0c             	shr    $0xc,%eax
  803ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803ba5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ba8:	89 d0                	mov    %edx,%eax
  803baa:	01 c0                	add    %eax,%eax
  803bac:	01 d0                	add    %edx,%eax
  803bae:	c1 e0 02             	shl    $0x2,%eax
  803bb1:	05 48 62 80 00       	add    $0x806248,%eax
  803bb6:	8b 00                	mov    (%eax),%eax
  803bb8:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803bbb:	c9                   	leave  
  803bbc:	c3                   	ret    

00803bbd <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803bbd:	55                   	push   %ebp
  803bbe:	89 e5                	mov    %esp,%ebp
  803bc0:	83 ec 14             	sub    $0x14,%esp
  803bc3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803bc6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803bca:	77 07                	ja     803bd3 <nearest_pow2_ceil.1513+0x16>
  803bcc:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd1:	eb 20                	jmp    803bf3 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803bd3:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803bda:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803bdd:	eb 08                	jmp    803be7 <nearest_pow2_ceil.1513+0x2a>
  803bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803be2:	01 c0                	add    %eax,%eax
  803be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803be7:	d1 6d 08             	shrl   0x8(%ebp)
  803bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bee:	75 ef                	jne    803bdf <nearest_pow2_ceil.1513+0x22>
        return power;
  803bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803bf3:	c9                   	leave  
  803bf4:	c3                   	ret    

00803bf5 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803bf5:	55                   	push   %ebp
  803bf6:	89 e5                	mov    %esp,%ebp
  803bf8:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803bfb:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c02:	76 16                	jbe    803c1a <alloc_block+0x25>
  803c04:	68 24 59 80 00       	push   $0x805924
  803c09:	68 0e 59 80 00       	push   $0x80590e
  803c0e:	6a 72                	push   $0x72
  803c10:	68 ab 58 80 00       	push   $0x8058ab
  803c15:	e8 46 d8 ff ff       	call   801460 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c1e:	75 0a                	jne    803c2a <alloc_block+0x35>
  803c20:	b8 00 00 00 00       	mov    $0x0,%eax
  803c25:	e9 bd 04 00 00       	jmp    8040e7 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803c2a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803c31:	8b 45 08             	mov    0x8(%ebp),%eax
  803c34:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c37:	73 06                	jae    803c3f <alloc_block+0x4a>
        size = min_block_size;
  803c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c3c:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803c3f:	83 ec 0c             	sub    $0xc,%esp
  803c42:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803c45:	ff 75 08             	pushl  0x8(%ebp)
  803c48:	89 c1                	mov    %eax,%ecx
  803c4a:	e8 6e ff ff ff       	call   803bbd <nearest_pow2_ceil.1513>
  803c4f:	83 c4 10             	add    $0x10,%esp
  803c52:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803c55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c58:	83 ec 0c             	sub    $0xc,%esp
  803c5b:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803c5e:	52                   	push   %edx
  803c5f:	89 c1                	mov    %eax,%ecx
  803c61:	e8 83 04 00 00       	call   8040e9 <log2_ceil.1520>
  803c66:	83 c4 10             	add    $0x10,%esp
  803c69:	83 e8 03             	sub    $0x3,%eax
  803c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803c6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c72:	c1 e0 04             	shl    $0x4,%eax
  803c75:	05 60 e2 81 00       	add    $0x81e260,%eax
  803c7a:	8b 00                	mov    (%eax),%eax
  803c7c:	85 c0                	test   %eax,%eax
  803c7e:	0f 84 d8 00 00 00    	je     803d5c <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803c84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c87:	c1 e0 04             	shl    $0x4,%eax
  803c8a:	05 60 e2 81 00       	add    $0x81e260,%eax
  803c8f:	8b 00                	mov    (%eax),%eax
  803c91:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803c94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c98:	75 17                	jne    803cb1 <alloc_block+0xbc>
  803c9a:	83 ec 04             	sub    $0x4,%esp
  803c9d:	68 45 59 80 00       	push   $0x805945
  803ca2:	68 98 00 00 00       	push   $0x98
  803ca7:	68 ab 58 80 00       	push   $0x8058ab
  803cac:	e8 af d7 ff ff       	call   801460 <_panic>
  803cb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb4:	8b 00                	mov    (%eax),%eax
  803cb6:	85 c0                	test   %eax,%eax
  803cb8:	74 10                	je     803cca <alloc_block+0xd5>
  803cba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cbd:	8b 00                	mov    (%eax),%eax
  803cbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cc2:	8b 52 04             	mov    0x4(%edx),%edx
  803cc5:	89 50 04             	mov    %edx,0x4(%eax)
  803cc8:	eb 14                	jmp    803cde <alloc_block+0xe9>
  803cca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ccd:	8b 40 04             	mov    0x4(%eax),%eax
  803cd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd3:	c1 e2 04             	shl    $0x4,%edx
  803cd6:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803cdc:	89 02                	mov    %eax,(%edx)
  803cde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce1:	8b 40 04             	mov    0x4(%eax),%eax
  803ce4:	85 c0                	test   %eax,%eax
  803ce6:	74 0f                	je     803cf7 <alloc_block+0x102>
  803ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ceb:	8b 40 04             	mov    0x4(%eax),%eax
  803cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cf1:	8b 12                	mov    (%edx),%edx
  803cf3:	89 10                	mov    %edx,(%eax)
  803cf5:	eb 13                	jmp    803d0a <alloc_block+0x115>
  803cf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cfa:	8b 00                	mov    (%eax),%eax
  803cfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cff:	c1 e2 04             	shl    $0x4,%edx
  803d02:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803d08:	89 02                	mov    %eax,(%edx)
  803d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d20:	c1 e0 04             	shl    $0x4,%eax
  803d23:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d30:	c1 e0 04             	shl    $0x4,%eax
  803d33:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803d38:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803d3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d3d:	83 ec 0c             	sub    $0xc,%esp
  803d40:	50                   	push   %eax
  803d41:	e8 12 fc ff ff       	call   803958 <to_page_info>
  803d46:	83 c4 10             	add    $0x10,%esp
  803d49:	89 c2                	mov    %eax,%edx
  803d4b:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803d4f:	48                   	dec    %eax
  803d50:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d57:	e9 8b 03 00 00       	jmp    8040e7 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803d5c:	a1 28 62 80 00       	mov    0x806228,%eax
  803d61:	85 c0                	test   %eax,%eax
  803d63:	0f 84 64 02 00 00    	je     803fcd <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803d69:	a1 28 62 80 00       	mov    0x806228,%eax
  803d6e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803d71:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d75:	75 17                	jne    803d8e <alloc_block+0x199>
  803d77:	83 ec 04             	sub    $0x4,%esp
  803d7a:	68 45 59 80 00       	push   $0x805945
  803d7f:	68 a0 00 00 00       	push   $0xa0
  803d84:	68 ab 58 80 00       	push   $0x8058ab
  803d89:	e8 d2 d6 ff ff       	call   801460 <_panic>
  803d8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d91:	8b 00                	mov    (%eax),%eax
  803d93:	85 c0                	test   %eax,%eax
  803d95:	74 10                	je     803da7 <alloc_block+0x1b2>
  803d97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9a:	8b 00                	mov    (%eax),%eax
  803d9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d9f:	8b 52 04             	mov    0x4(%edx),%edx
  803da2:	89 50 04             	mov    %edx,0x4(%eax)
  803da5:	eb 0b                	jmp    803db2 <alloc_block+0x1bd>
  803da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803daa:	8b 40 04             	mov    0x4(%eax),%eax
  803dad:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803db2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db5:	8b 40 04             	mov    0x4(%eax),%eax
  803db8:	85 c0                	test   %eax,%eax
  803dba:	74 0f                	je     803dcb <alloc_block+0x1d6>
  803dbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dbf:	8b 40 04             	mov    0x4(%eax),%eax
  803dc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dc5:	8b 12                	mov    (%edx),%edx
  803dc7:	89 10                	mov    %edx,(%eax)
  803dc9:	eb 0a                	jmp    803dd5 <alloc_block+0x1e0>
  803dcb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dce:	8b 00                	mov    (%eax),%eax
  803dd0:	a3 28 62 80 00       	mov    %eax,0x806228
  803dd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803de8:	a1 34 62 80 00       	mov    0x806234,%eax
  803ded:	48                   	dec    %eax
  803dee:	a3 34 62 80 00       	mov    %eax,0x806234

        page_info_e->block_size = pow;
  803df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803df9:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803dfd:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e02:	99                   	cltd   
  803e03:	f7 7d e8             	idivl  -0x18(%ebp)
  803e06:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e09:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803e0d:	83 ec 0c             	sub    $0xc,%esp
  803e10:	ff 75 dc             	pushl  -0x24(%ebp)
  803e13:	e8 ce fa ff ff       	call   8038e6 <to_page_va>
  803e18:	83 c4 10             	add    $0x10,%esp
  803e1b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803e1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e21:	83 ec 0c             	sub    $0xc,%esp
  803e24:	50                   	push   %eax
  803e25:	e8 c0 ee ff ff       	call   802cea <get_page>
  803e2a:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803e34:	e9 aa 00 00 00       	jmp    803ee3 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3c:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803e40:	89 c2                	mov    %eax,%edx
  803e42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e45:	01 d0                	add    %edx,%eax
  803e47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803e4a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e4e:	75 17                	jne    803e67 <alloc_block+0x272>
  803e50:	83 ec 04             	sub    $0x4,%esp
  803e53:	68 64 59 80 00       	push   $0x805964
  803e58:	68 aa 00 00 00       	push   $0xaa
  803e5d:	68 ab 58 80 00       	push   $0x8058ab
  803e62:	e8 f9 d5 ff ff       	call   801460 <_panic>
  803e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6a:	c1 e0 04             	shl    $0x4,%eax
  803e6d:	05 64 e2 81 00       	add    $0x81e264,%eax
  803e72:	8b 10                	mov    (%eax),%edx
  803e74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e77:	89 50 04             	mov    %edx,0x4(%eax)
  803e7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7d:	8b 40 04             	mov    0x4(%eax),%eax
  803e80:	85 c0                	test   %eax,%eax
  803e82:	74 14                	je     803e98 <alloc_block+0x2a3>
  803e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e87:	c1 e0 04             	shl    $0x4,%eax
  803e8a:	05 64 e2 81 00       	add    $0x81e264,%eax
  803e8f:	8b 00                	mov    (%eax),%eax
  803e91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e94:	89 10                	mov    %edx,(%eax)
  803e96:	eb 11                	jmp    803ea9 <alloc_block+0x2b4>
  803e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9b:	c1 e0 04             	shl    $0x4,%eax
  803e9e:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  803ea4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea7:	89 02                	mov    %eax,(%edx)
  803ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eac:	c1 e0 04             	shl    $0x4,%eax
  803eaf:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803eb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb8:	89 02                	mov    %eax,(%edx)
  803eba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ebd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec6:	c1 e0 04             	shl    $0x4,%eax
  803ec9:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ece:	8b 00                	mov    (%eax),%eax
  803ed0:	8d 50 01             	lea    0x1(%eax),%edx
  803ed3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed6:	c1 e0 04             	shl    $0x4,%eax
  803ed9:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ede:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803ee0:	ff 45 f4             	incl   -0xc(%ebp)
  803ee3:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ee8:	99                   	cltd   
  803ee9:	f7 7d e8             	idivl  -0x18(%ebp)
  803eec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803eef:	0f 8f 44 ff ff ff    	jg     803e39 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803ef5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef8:	c1 e0 04             	shl    $0x4,%eax
  803efb:	05 60 e2 81 00       	add    $0x81e260,%eax
  803f00:	8b 00                	mov    (%eax),%eax
  803f02:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803f05:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f09:	75 17                	jne    803f22 <alloc_block+0x32d>
  803f0b:	83 ec 04             	sub    $0x4,%esp
  803f0e:	68 45 59 80 00       	push   $0x805945
  803f13:	68 ae 00 00 00       	push   $0xae
  803f18:	68 ab 58 80 00       	push   $0x8058ab
  803f1d:	e8 3e d5 ff ff       	call   801460 <_panic>
  803f22:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f25:	8b 00                	mov    (%eax),%eax
  803f27:	85 c0                	test   %eax,%eax
  803f29:	74 10                	je     803f3b <alloc_block+0x346>
  803f2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f2e:	8b 00                	mov    (%eax),%eax
  803f30:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f33:	8b 52 04             	mov    0x4(%edx),%edx
  803f36:	89 50 04             	mov    %edx,0x4(%eax)
  803f39:	eb 14                	jmp    803f4f <alloc_block+0x35a>
  803f3b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f3e:	8b 40 04             	mov    0x4(%eax),%eax
  803f41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f44:	c1 e2 04             	shl    $0x4,%edx
  803f47:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803f4d:	89 02                	mov    %eax,(%edx)
  803f4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f52:	8b 40 04             	mov    0x4(%eax),%eax
  803f55:	85 c0                	test   %eax,%eax
  803f57:	74 0f                	je     803f68 <alloc_block+0x373>
  803f59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f5c:	8b 40 04             	mov    0x4(%eax),%eax
  803f5f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f62:	8b 12                	mov    (%edx),%edx
  803f64:	89 10                	mov    %edx,(%eax)
  803f66:	eb 13                	jmp    803f7b <alloc_block+0x386>
  803f68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f6b:	8b 00                	mov    (%eax),%eax
  803f6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f70:	c1 e2 04             	shl    $0x4,%edx
  803f73:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803f79:	89 02                	mov    %eax,(%edx)
  803f7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f84:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f91:	c1 e0 04             	shl    $0x4,%eax
  803f94:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803f99:	8b 00                	mov    (%eax),%eax
  803f9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa1:	c1 e0 04             	shl    $0x4,%eax
  803fa4:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803fa9:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803fab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fae:	83 ec 0c             	sub    $0xc,%esp
  803fb1:	50                   	push   %eax
  803fb2:	e8 a1 f9 ff ff       	call   803958 <to_page_info>
  803fb7:	83 c4 10             	add    $0x10,%esp
  803fba:	89 c2                	mov    %eax,%edx
  803fbc:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803fc0:	48                   	dec    %eax
  803fc1:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fc8:	e9 1a 01 00 00       	jmp    8040e7 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803fcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd0:	40                   	inc    %eax
  803fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803fd4:	e9 ed 00 00 00       	jmp    8040c6 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fdc:	c1 e0 04             	shl    $0x4,%eax
  803fdf:	05 60 e2 81 00       	add    $0x81e260,%eax
  803fe4:	8b 00                	mov    (%eax),%eax
  803fe6:	85 c0                	test   %eax,%eax
  803fe8:	0f 84 d5 00 00 00    	je     8040c3 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff1:	c1 e0 04             	shl    $0x4,%eax
  803ff4:	05 60 e2 81 00       	add    $0x81e260,%eax
  803ff9:	8b 00                	mov    (%eax),%eax
  803ffb:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803ffe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804002:	75 17                	jne    80401b <alloc_block+0x426>
  804004:	83 ec 04             	sub    $0x4,%esp
  804007:	68 45 59 80 00       	push   $0x805945
  80400c:	68 b8 00 00 00       	push   $0xb8
  804011:	68 ab 58 80 00       	push   $0x8058ab
  804016:	e8 45 d4 ff ff       	call   801460 <_panic>
  80401b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80401e:	8b 00                	mov    (%eax),%eax
  804020:	85 c0                	test   %eax,%eax
  804022:	74 10                	je     804034 <alloc_block+0x43f>
  804024:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804027:	8b 00                	mov    (%eax),%eax
  804029:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80402c:	8b 52 04             	mov    0x4(%edx),%edx
  80402f:	89 50 04             	mov    %edx,0x4(%eax)
  804032:	eb 14                	jmp    804048 <alloc_block+0x453>
  804034:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804037:	8b 40 04             	mov    0x4(%eax),%eax
  80403a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80403d:	c1 e2 04             	shl    $0x4,%edx
  804040:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  804046:	89 02                	mov    %eax,(%edx)
  804048:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80404b:	8b 40 04             	mov    0x4(%eax),%eax
  80404e:	85 c0                	test   %eax,%eax
  804050:	74 0f                	je     804061 <alloc_block+0x46c>
  804052:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804055:	8b 40 04             	mov    0x4(%eax),%eax
  804058:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80405b:	8b 12                	mov    (%edx),%edx
  80405d:	89 10                	mov    %edx,(%eax)
  80405f:	eb 13                	jmp    804074 <alloc_block+0x47f>
  804061:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804064:	8b 00                	mov    (%eax),%eax
  804066:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804069:	c1 e2 04             	shl    $0x4,%edx
  80406c:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  804072:	89 02                	mov    %eax,(%edx)
  804074:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80407d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80408a:	c1 e0 04             	shl    $0x4,%eax
  80408d:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804092:	8b 00                	mov    (%eax),%eax
  804094:	8d 50 ff             	lea    -0x1(%eax),%edx
  804097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409a:	c1 e0 04             	shl    $0x4,%eax
  80409d:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8040a2:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8040a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040a7:	83 ec 0c             	sub    $0xc,%esp
  8040aa:	50                   	push   %eax
  8040ab:	e8 a8 f8 ff ff       	call   803958 <to_page_info>
  8040b0:	83 c4 10             	add    $0x10,%esp
  8040b3:	89 c2                	mov    %eax,%edx
  8040b5:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8040b9:	48                   	dec    %eax
  8040ba:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8040be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040c1:	eb 24                	jmp    8040e7 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8040c3:	ff 45 f0             	incl   -0x10(%ebp)
  8040c6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8040ca:	0f 8e 09 ff ff ff    	jle    803fd9 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8040d0:	83 ec 04             	sub    $0x4,%esp
  8040d3:	68 87 59 80 00       	push   $0x805987
  8040d8:	68 bf 00 00 00       	push   $0xbf
  8040dd:	68 ab 58 80 00       	push   $0x8058ab
  8040e2:	e8 79 d3 ff ff       	call   801460 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8040e7:	c9                   	leave  
  8040e8:	c3                   	ret    

008040e9 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8040e9:	55                   	push   %ebp
  8040ea:	89 e5                	mov    %esp,%ebp
  8040ec:	83 ec 14             	sub    $0x14,%esp
  8040ef:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8040f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040f6:	75 07                	jne    8040ff <log2_ceil.1520+0x16>
  8040f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040fd:	eb 1b                	jmp    80411a <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8040ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  804106:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  804109:	eb 06                	jmp    804111 <log2_ceil.1520+0x28>
            x >>= 1;
  80410b:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80410e:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  804111:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804115:	75 f4                	jne    80410b <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  804117:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80411a:	c9                   	leave  
  80411b:	c3                   	ret    

0080411c <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80411c:	55                   	push   %ebp
  80411d:	89 e5                	mov    %esp,%ebp
  80411f:	83 ec 14             	sub    $0x14,%esp
  804122:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  804125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804129:	75 07                	jne    804132 <log2_ceil.1547+0x16>
  80412b:	b8 00 00 00 00       	mov    $0x0,%eax
  804130:	eb 1b                	jmp    80414d <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  804132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  804139:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80413c:	eb 06                	jmp    804144 <log2_ceil.1547+0x28>
			x >>= 1;
  80413e:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  804141:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  804144:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804148:	75 f4                	jne    80413e <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80414a:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80414d:	c9                   	leave  
  80414e:	c3                   	ret    

0080414f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80414f:	55                   	push   %ebp
  804150:	89 e5                	mov    %esp,%ebp
  804152:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804155:	8b 55 08             	mov    0x8(%ebp),%edx
  804158:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80415d:	39 c2                	cmp    %eax,%edx
  80415f:	72 0c                	jb     80416d <free_block+0x1e>
  804161:	8b 55 08             	mov    0x8(%ebp),%edx
  804164:	a1 20 62 80 00       	mov    0x806220,%eax
  804169:	39 c2                	cmp    %eax,%edx
  80416b:	72 19                	jb     804186 <free_block+0x37>
  80416d:	68 8c 59 80 00       	push   $0x80598c
  804172:	68 0e 59 80 00       	push   $0x80590e
  804177:	68 d0 00 00 00       	push   $0xd0
  80417c:	68 ab 58 80 00       	push   $0x8058ab
  804181:	e8 da d2 ff ff       	call   801460 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  804186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80418a:	0f 84 42 03 00 00    	je     8044d2 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  804190:	8b 55 08             	mov    0x8(%ebp),%edx
  804193:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804198:	39 c2                	cmp    %eax,%edx
  80419a:	72 0c                	jb     8041a8 <free_block+0x59>
  80419c:	8b 55 08             	mov    0x8(%ebp),%edx
  80419f:	a1 20 62 80 00       	mov    0x806220,%eax
  8041a4:	39 c2                	cmp    %eax,%edx
  8041a6:	72 17                	jb     8041bf <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8041a8:	83 ec 04             	sub    $0x4,%esp
  8041ab:	68 c4 59 80 00       	push   $0x8059c4
  8041b0:	68 e6 00 00 00       	push   $0xe6
  8041b5:	68 ab 58 80 00       	push   $0x8058ab
  8041ba:	e8 a1 d2 ff ff       	call   801460 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8041bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8041c2:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8041c7:	29 c2                	sub    %eax,%edx
  8041c9:	89 d0                	mov    %edx,%eax
  8041cb:	83 e0 07             	and    $0x7,%eax
  8041ce:	85 c0                	test   %eax,%eax
  8041d0:	74 17                	je     8041e9 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8041d2:	83 ec 04             	sub    $0x4,%esp
  8041d5:	68 f8 59 80 00       	push   $0x8059f8
  8041da:	68 ea 00 00 00       	push   $0xea
  8041df:	68 ab 58 80 00       	push   $0x8058ab
  8041e4:	e8 77 d2 ff ff       	call   801460 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8041e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ec:	83 ec 0c             	sub    $0xc,%esp
  8041ef:	50                   	push   %eax
  8041f0:	e8 63 f7 ff ff       	call   803958 <to_page_info>
  8041f5:	83 c4 10             	add    $0x10,%esp
  8041f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8041fb:	83 ec 0c             	sub    $0xc,%esp
  8041fe:	ff 75 08             	pushl  0x8(%ebp)
  804201:	e8 87 f9 ff ff       	call   803b8d <get_block_size>
  804206:	83 c4 10             	add    $0x10,%esp
  804209:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80420c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804210:	75 17                	jne    804229 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  804212:	83 ec 04             	sub    $0x4,%esp
  804215:	68 24 5a 80 00       	push   $0x805a24
  80421a:	68 f1 00 00 00       	push   $0xf1
  80421f:	68 ab 58 80 00       	push   $0x8058ab
  804224:	e8 37 d2 ff ff       	call   801460 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  804229:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80422c:	83 ec 0c             	sub    $0xc,%esp
  80422f:	8d 45 d0             	lea    -0x30(%ebp),%eax
  804232:	52                   	push   %edx
  804233:	89 c1                	mov    %eax,%ecx
  804235:	e8 e2 fe ff ff       	call   80411c <log2_ceil.1547>
  80423a:	83 c4 10             	add    $0x10,%esp
  80423d:	83 e8 03             	sub    $0x3,%eax
  804240:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  804243:	8b 45 08             	mov    0x8(%ebp),%eax
  804246:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  804249:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80424d:	75 17                	jne    804266 <free_block+0x117>
  80424f:	83 ec 04             	sub    $0x4,%esp
  804252:	68 70 5a 80 00       	push   $0x805a70
  804257:	68 f6 00 00 00       	push   $0xf6
  80425c:	68 ab 58 80 00       	push   $0x8058ab
  804261:	e8 fa d1 ff ff       	call   801460 <_panic>
  804266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804269:	c1 e0 04             	shl    $0x4,%eax
  80426c:	05 60 e2 81 00       	add    $0x81e260,%eax
  804271:	8b 10                	mov    (%eax),%edx
  804273:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804276:	89 10                	mov    %edx,(%eax)
  804278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80427b:	8b 00                	mov    (%eax),%eax
  80427d:	85 c0                	test   %eax,%eax
  80427f:	74 15                	je     804296 <free_block+0x147>
  804281:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804284:	c1 e0 04             	shl    $0x4,%eax
  804287:	05 60 e2 81 00       	add    $0x81e260,%eax
  80428c:	8b 00                	mov    (%eax),%eax
  80428e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804291:	89 50 04             	mov    %edx,0x4(%eax)
  804294:	eb 11                	jmp    8042a7 <free_block+0x158>
  804296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804299:	c1 e0 04             	shl    $0x4,%eax
  80429c:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  8042a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042a5:	89 02                	mov    %eax,(%edx)
  8042a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042aa:	c1 e0 04             	shl    $0x4,%eax
  8042ad:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  8042b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042b6:	89 02                	mov    %eax,(%edx)
  8042b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042c5:	c1 e0 04             	shl    $0x4,%eax
  8042c8:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8042cd:	8b 00                	mov    (%eax),%eax
  8042cf:	8d 50 01             	lea    0x1(%eax),%edx
  8042d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042d5:	c1 e0 04             	shl    $0x4,%eax
  8042d8:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8042dd:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8042df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042e2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8042e6:	40                   	inc    %eax
  8042e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8042ea:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8042ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8042f1:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8042f6:	29 c2                	sub    %eax,%edx
  8042f8:	89 d0                	mov    %edx,%eax
  8042fa:	c1 e8 0c             	shr    $0xc,%eax
  8042fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  804300:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804303:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804307:	0f b7 c8             	movzwl %ax,%ecx
  80430a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80430f:	99                   	cltd   
  804310:	f7 7d e8             	idivl  -0x18(%ebp)
  804313:	39 c1                	cmp    %eax,%ecx
  804315:	0f 85 b8 01 00 00    	jne    8044d3 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80431b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  804322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804325:	c1 e0 04             	shl    $0x4,%eax
  804328:	05 60 e2 81 00       	add    $0x81e260,%eax
  80432d:	8b 00                	mov    (%eax),%eax
  80432f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804332:	e9 d5 00 00 00       	jmp    80440c <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  804337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433a:	8b 00                	mov    (%eax),%eax
  80433c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80433f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804342:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804347:	29 c2                	sub    %eax,%edx
  804349:	89 d0                	mov    %edx,%eax
  80434b:	c1 e8 0c             	shr    $0xc,%eax
  80434e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  804351:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804354:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  804357:	0f 85 a9 00 00 00    	jne    804406 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80435d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804361:	75 17                	jne    80437a <free_block+0x22b>
  804363:	83 ec 04             	sub    $0x4,%esp
  804366:	68 45 59 80 00       	push   $0x805945
  80436b:	68 04 01 00 00       	push   $0x104
  804370:	68 ab 58 80 00       	push   $0x8058ab
  804375:	e8 e6 d0 ff ff       	call   801460 <_panic>
  80437a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80437d:	8b 00                	mov    (%eax),%eax
  80437f:	85 c0                	test   %eax,%eax
  804381:	74 10                	je     804393 <free_block+0x244>
  804383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804386:	8b 00                	mov    (%eax),%eax
  804388:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80438b:	8b 52 04             	mov    0x4(%edx),%edx
  80438e:	89 50 04             	mov    %edx,0x4(%eax)
  804391:	eb 14                	jmp    8043a7 <free_block+0x258>
  804393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804396:	8b 40 04             	mov    0x4(%eax),%eax
  804399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80439c:	c1 e2 04             	shl    $0x4,%edx
  80439f:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8043a5:	89 02                	mov    %eax,(%edx)
  8043a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043aa:	8b 40 04             	mov    0x4(%eax),%eax
  8043ad:	85 c0                	test   %eax,%eax
  8043af:	74 0f                	je     8043c0 <free_block+0x271>
  8043b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b4:	8b 40 04             	mov    0x4(%eax),%eax
  8043b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043ba:	8b 12                	mov    (%edx),%edx
  8043bc:	89 10                	mov    %edx,(%eax)
  8043be:	eb 13                	jmp    8043d3 <free_block+0x284>
  8043c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c3:	8b 00                	mov    (%eax),%eax
  8043c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043c8:	c1 e2 04             	shl    $0x4,%edx
  8043cb:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  8043d1:	89 02                	mov    %eax,(%edx)
  8043d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043e9:	c1 e0 04             	shl    $0x4,%eax
  8043ec:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8043f1:	8b 00                	mov    (%eax),%eax
  8043f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8043f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043f9:	c1 e0 04             	shl    $0x4,%eax
  8043fc:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804401:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804403:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804406:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804409:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80440c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804410:	0f 85 21 ff ff ff    	jne    804337 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  804416:	b8 00 10 00 00       	mov    $0x1000,%eax
  80441b:	99                   	cltd   
  80441c:	f7 7d e8             	idivl  -0x18(%ebp)
  80441f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804422:	74 17                	je     80443b <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  804424:	83 ec 04             	sub    $0x4,%esp
  804427:	68 94 5a 80 00       	push   $0x805a94
  80442c:	68 0c 01 00 00       	push   $0x10c
  804431:	68 ab 58 80 00       	push   $0x8058ab
  804436:	e8 25 d0 ff ff       	call   801460 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80443b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80443e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  804444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804447:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80444d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804451:	75 17                	jne    80446a <free_block+0x31b>
  804453:	83 ec 04             	sub    $0x4,%esp
  804456:	68 64 59 80 00       	push   $0x805964
  80445b:	68 11 01 00 00       	push   $0x111
  804460:	68 ab 58 80 00       	push   $0x8058ab
  804465:	e8 f6 cf ff ff       	call   801460 <_panic>
  80446a:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  804470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804473:	89 50 04             	mov    %edx,0x4(%eax)
  804476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804479:	8b 40 04             	mov    0x4(%eax),%eax
  80447c:	85 c0                	test   %eax,%eax
  80447e:	74 0c                	je     80448c <free_block+0x33d>
  804480:	a1 2c 62 80 00       	mov    0x80622c,%eax
  804485:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804488:	89 10                	mov    %edx,(%eax)
  80448a:	eb 08                	jmp    804494 <free_block+0x345>
  80448c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80448f:	a3 28 62 80 00       	mov    %eax,0x806228
  804494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804497:	a3 2c 62 80 00       	mov    %eax,0x80622c
  80449c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80449f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044a5:	a1 34 62 80 00       	mov    0x806234,%eax
  8044aa:	40                   	inc    %eax
  8044ab:	a3 34 62 80 00       	mov    %eax,0x806234

        uint32 pp = to_page_va(page_info_e);
  8044b0:	83 ec 0c             	sub    $0xc,%esp
  8044b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8044b6:	e8 2b f4 ff ff       	call   8038e6 <to_page_va>
  8044bb:	83 c4 10             	add    $0x10,%esp
  8044be:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8044c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8044c4:	83 ec 0c             	sub    $0xc,%esp
  8044c7:	50                   	push   %eax
  8044c8:	e8 69 e8 ff ff       	call   802d36 <return_page>
  8044cd:	83 c4 10             	add    $0x10,%esp
  8044d0:	eb 01                	jmp    8044d3 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8044d2:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8044d3:	c9                   	leave  
  8044d4:	c3                   	ret    

008044d5 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8044d5:	55                   	push   %ebp
  8044d6:	89 e5                	mov    %esp,%ebp
  8044d8:	83 ec 14             	sub    $0x14,%esp
  8044db:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8044de:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8044e2:	77 07                	ja     8044eb <nearest_pow2_ceil.1572+0x16>
      return 1;
  8044e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8044e9:	eb 20                	jmp    80450b <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8044eb:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8044f2:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8044f5:	eb 08                	jmp    8044ff <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8044f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8044fa:	01 c0                	add    %eax,%eax
  8044fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8044ff:	d1 6d 08             	shrl   0x8(%ebp)
  804502:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804506:	75 ef                	jne    8044f7 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  804508:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80450b:	c9                   	leave  
  80450c:	c3                   	ret    

0080450d <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80450d:	55                   	push   %ebp
  80450e:	89 e5                	mov    %esp,%ebp
  804510:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  804513:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804517:	75 13                	jne    80452c <realloc_block+0x1f>
    return alloc_block(new_size);
  804519:	83 ec 0c             	sub    $0xc,%esp
  80451c:	ff 75 0c             	pushl  0xc(%ebp)
  80451f:	e8 d1 f6 ff ff       	call   803bf5 <alloc_block>
  804524:	83 c4 10             	add    $0x10,%esp
  804527:	e9 d9 00 00 00       	jmp    804605 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80452c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804530:	75 18                	jne    80454a <realloc_block+0x3d>
    free_block(va);
  804532:	83 ec 0c             	sub    $0xc,%esp
  804535:	ff 75 08             	pushl  0x8(%ebp)
  804538:	e8 12 fc ff ff       	call   80414f <free_block>
  80453d:	83 c4 10             	add    $0x10,%esp
    return NULL;
  804540:	b8 00 00 00 00       	mov    $0x0,%eax
  804545:	e9 bb 00 00 00       	jmp    804605 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80454a:	83 ec 0c             	sub    $0xc,%esp
  80454d:	ff 75 08             	pushl  0x8(%ebp)
  804550:	e8 38 f6 ff ff       	call   803b8d <get_block_size>
  804555:	83 c4 10             	add    $0x10,%esp
  804558:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80455b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804562:	8b 45 0c             	mov    0xc(%ebp),%eax
  804565:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804568:	73 06                	jae    804570 <realloc_block+0x63>
    new_size = min_block_size;
  80456a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80456d:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  804570:	83 ec 0c             	sub    $0xc,%esp
  804573:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804576:	ff 75 0c             	pushl  0xc(%ebp)
  804579:	89 c1                	mov    %eax,%ecx
  80457b:	e8 55 ff ff ff       	call   8044d5 <nearest_pow2_ceil.1572>
  804580:	83 c4 10             	add    $0x10,%esp
  804583:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  804586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804589:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80458c:	75 05                	jne    804593 <realloc_block+0x86>
    return va;
  80458e:	8b 45 08             	mov    0x8(%ebp),%eax
  804591:	eb 72                	jmp    804605 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  804593:	83 ec 0c             	sub    $0xc,%esp
  804596:	ff 75 0c             	pushl  0xc(%ebp)
  804599:	e8 57 f6 ff ff       	call   803bf5 <alloc_block>
  80459e:	83 c4 10             	add    $0x10,%esp
  8045a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8045a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045a8:	75 07                	jne    8045b1 <realloc_block+0xa4>
    return NULL;
  8045aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8045af:	eb 54                	jmp    804605 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8045b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045b7:	39 d0                	cmp    %edx,%eax
  8045b9:	76 02                	jbe    8045bd <realloc_block+0xb0>
  8045bb:	89 d0                	mov    %edx,%eax
  8045bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8045c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8045c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8045cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8045d3:	eb 17                	jmp    8045ec <realloc_block+0xdf>
    dst[i] = src[i];
  8045d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045db:	01 c2                	add    %eax,%edx
  8045dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e3:	01 c8                	add    %ecx,%eax
  8045e5:	8a 00                	mov    (%eax),%al
  8045e7:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8045e9:	ff 45 f4             	incl   -0xc(%ebp)
  8045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045ef:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8045f2:	72 e1                	jb     8045d5 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8045f4:	83 ec 0c             	sub    $0xc,%esp
  8045f7:	ff 75 08             	pushl  0x8(%ebp)
  8045fa:	e8 50 fb ff ff       	call   80414f <free_block>
  8045ff:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  804605:	c9                   	leave  
  804606:	c3                   	ret    
  804607:	90                   	nop

00804608 <__udivdi3>:
  804608:	55                   	push   %ebp
  804609:	57                   	push   %edi
  80460a:	56                   	push   %esi
  80460b:	53                   	push   %ebx
  80460c:	83 ec 1c             	sub    $0x1c,%esp
  80460f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804613:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80461b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80461f:	89 ca                	mov    %ecx,%edx
  804621:	89 f8                	mov    %edi,%eax
  804623:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804627:	85 f6                	test   %esi,%esi
  804629:	75 2d                	jne    804658 <__udivdi3+0x50>
  80462b:	39 cf                	cmp    %ecx,%edi
  80462d:	77 65                	ja     804694 <__udivdi3+0x8c>
  80462f:	89 fd                	mov    %edi,%ebp
  804631:	85 ff                	test   %edi,%edi
  804633:	75 0b                	jne    804640 <__udivdi3+0x38>
  804635:	b8 01 00 00 00       	mov    $0x1,%eax
  80463a:	31 d2                	xor    %edx,%edx
  80463c:	f7 f7                	div    %edi
  80463e:	89 c5                	mov    %eax,%ebp
  804640:	31 d2                	xor    %edx,%edx
  804642:	89 c8                	mov    %ecx,%eax
  804644:	f7 f5                	div    %ebp
  804646:	89 c1                	mov    %eax,%ecx
  804648:	89 d8                	mov    %ebx,%eax
  80464a:	f7 f5                	div    %ebp
  80464c:	89 cf                	mov    %ecx,%edi
  80464e:	89 fa                	mov    %edi,%edx
  804650:	83 c4 1c             	add    $0x1c,%esp
  804653:	5b                   	pop    %ebx
  804654:	5e                   	pop    %esi
  804655:	5f                   	pop    %edi
  804656:	5d                   	pop    %ebp
  804657:	c3                   	ret    
  804658:	39 ce                	cmp    %ecx,%esi
  80465a:	77 28                	ja     804684 <__udivdi3+0x7c>
  80465c:	0f bd fe             	bsr    %esi,%edi
  80465f:	83 f7 1f             	xor    $0x1f,%edi
  804662:	75 40                	jne    8046a4 <__udivdi3+0x9c>
  804664:	39 ce                	cmp    %ecx,%esi
  804666:	72 0a                	jb     804672 <__udivdi3+0x6a>
  804668:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80466c:	0f 87 9e 00 00 00    	ja     804710 <__udivdi3+0x108>
  804672:	b8 01 00 00 00       	mov    $0x1,%eax
  804677:	89 fa                	mov    %edi,%edx
  804679:	83 c4 1c             	add    $0x1c,%esp
  80467c:	5b                   	pop    %ebx
  80467d:	5e                   	pop    %esi
  80467e:	5f                   	pop    %edi
  80467f:	5d                   	pop    %ebp
  804680:	c3                   	ret    
  804681:	8d 76 00             	lea    0x0(%esi),%esi
  804684:	31 ff                	xor    %edi,%edi
  804686:	31 c0                	xor    %eax,%eax
  804688:	89 fa                	mov    %edi,%edx
  80468a:	83 c4 1c             	add    $0x1c,%esp
  80468d:	5b                   	pop    %ebx
  80468e:	5e                   	pop    %esi
  80468f:	5f                   	pop    %edi
  804690:	5d                   	pop    %ebp
  804691:	c3                   	ret    
  804692:	66 90                	xchg   %ax,%ax
  804694:	89 d8                	mov    %ebx,%eax
  804696:	f7 f7                	div    %edi
  804698:	31 ff                	xor    %edi,%edi
  80469a:	89 fa                	mov    %edi,%edx
  80469c:	83 c4 1c             	add    $0x1c,%esp
  80469f:	5b                   	pop    %ebx
  8046a0:	5e                   	pop    %esi
  8046a1:	5f                   	pop    %edi
  8046a2:	5d                   	pop    %ebp
  8046a3:	c3                   	ret    
  8046a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046a9:	89 eb                	mov    %ebp,%ebx
  8046ab:	29 fb                	sub    %edi,%ebx
  8046ad:	89 f9                	mov    %edi,%ecx
  8046af:	d3 e6                	shl    %cl,%esi
  8046b1:	89 c5                	mov    %eax,%ebp
  8046b3:	88 d9                	mov    %bl,%cl
  8046b5:	d3 ed                	shr    %cl,%ebp
  8046b7:	89 e9                	mov    %ebp,%ecx
  8046b9:	09 f1                	or     %esi,%ecx
  8046bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046bf:	89 f9                	mov    %edi,%ecx
  8046c1:	d3 e0                	shl    %cl,%eax
  8046c3:	89 c5                	mov    %eax,%ebp
  8046c5:	89 d6                	mov    %edx,%esi
  8046c7:	88 d9                	mov    %bl,%cl
  8046c9:	d3 ee                	shr    %cl,%esi
  8046cb:	89 f9                	mov    %edi,%ecx
  8046cd:	d3 e2                	shl    %cl,%edx
  8046cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046d3:	88 d9                	mov    %bl,%cl
  8046d5:	d3 e8                	shr    %cl,%eax
  8046d7:	09 c2                	or     %eax,%edx
  8046d9:	89 d0                	mov    %edx,%eax
  8046db:	89 f2                	mov    %esi,%edx
  8046dd:	f7 74 24 0c          	divl   0xc(%esp)
  8046e1:	89 d6                	mov    %edx,%esi
  8046e3:	89 c3                	mov    %eax,%ebx
  8046e5:	f7 e5                	mul    %ebp
  8046e7:	39 d6                	cmp    %edx,%esi
  8046e9:	72 19                	jb     804704 <__udivdi3+0xfc>
  8046eb:	74 0b                	je     8046f8 <__udivdi3+0xf0>
  8046ed:	89 d8                	mov    %ebx,%eax
  8046ef:	31 ff                	xor    %edi,%edi
  8046f1:	e9 58 ff ff ff       	jmp    80464e <__udivdi3+0x46>
  8046f6:	66 90                	xchg   %ax,%ax
  8046f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8046fc:	89 f9                	mov    %edi,%ecx
  8046fe:	d3 e2                	shl    %cl,%edx
  804700:	39 c2                	cmp    %eax,%edx
  804702:	73 e9                	jae    8046ed <__udivdi3+0xe5>
  804704:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804707:	31 ff                	xor    %edi,%edi
  804709:	e9 40 ff ff ff       	jmp    80464e <__udivdi3+0x46>
  80470e:	66 90                	xchg   %ax,%ax
  804710:	31 c0                	xor    %eax,%eax
  804712:	e9 37 ff ff ff       	jmp    80464e <__udivdi3+0x46>
  804717:	90                   	nop

00804718 <__umoddi3>:
  804718:	55                   	push   %ebp
  804719:	57                   	push   %edi
  80471a:	56                   	push   %esi
  80471b:	53                   	push   %ebx
  80471c:	83 ec 1c             	sub    $0x1c,%esp
  80471f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804723:	8b 74 24 34          	mov    0x34(%esp),%esi
  804727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80472b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80472f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804733:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804737:	89 f3                	mov    %esi,%ebx
  804739:	89 fa                	mov    %edi,%edx
  80473b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80473f:	89 34 24             	mov    %esi,(%esp)
  804742:	85 c0                	test   %eax,%eax
  804744:	75 1a                	jne    804760 <__umoddi3+0x48>
  804746:	39 f7                	cmp    %esi,%edi
  804748:	0f 86 a2 00 00 00    	jbe    8047f0 <__umoddi3+0xd8>
  80474e:	89 c8                	mov    %ecx,%eax
  804750:	89 f2                	mov    %esi,%edx
  804752:	f7 f7                	div    %edi
  804754:	89 d0                	mov    %edx,%eax
  804756:	31 d2                	xor    %edx,%edx
  804758:	83 c4 1c             	add    $0x1c,%esp
  80475b:	5b                   	pop    %ebx
  80475c:	5e                   	pop    %esi
  80475d:	5f                   	pop    %edi
  80475e:	5d                   	pop    %ebp
  80475f:	c3                   	ret    
  804760:	39 f0                	cmp    %esi,%eax
  804762:	0f 87 ac 00 00 00    	ja     804814 <__umoddi3+0xfc>
  804768:	0f bd e8             	bsr    %eax,%ebp
  80476b:	83 f5 1f             	xor    $0x1f,%ebp
  80476e:	0f 84 ac 00 00 00    	je     804820 <__umoddi3+0x108>
  804774:	bf 20 00 00 00       	mov    $0x20,%edi
  804779:	29 ef                	sub    %ebp,%edi
  80477b:	89 fe                	mov    %edi,%esi
  80477d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804781:	89 e9                	mov    %ebp,%ecx
  804783:	d3 e0                	shl    %cl,%eax
  804785:	89 d7                	mov    %edx,%edi
  804787:	89 f1                	mov    %esi,%ecx
  804789:	d3 ef                	shr    %cl,%edi
  80478b:	09 c7                	or     %eax,%edi
  80478d:	89 e9                	mov    %ebp,%ecx
  80478f:	d3 e2                	shl    %cl,%edx
  804791:	89 14 24             	mov    %edx,(%esp)
  804794:	89 d8                	mov    %ebx,%eax
  804796:	d3 e0                	shl    %cl,%eax
  804798:	89 c2                	mov    %eax,%edx
  80479a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80479e:	d3 e0                	shl    %cl,%eax
  8047a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047a8:	89 f1                	mov    %esi,%ecx
  8047aa:	d3 e8                	shr    %cl,%eax
  8047ac:	09 d0                	or     %edx,%eax
  8047ae:	d3 eb                	shr    %cl,%ebx
  8047b0:	89 da                	mov    %ebx,%edx
  8047b2:	f7 f7                	div    %edi
  8047b4:	89 d3                	mov    %edx,%ebx
  8047b6:	f7 24 24             	mull   (%esp)
  8047b9:	89 c6                	mov    %eax,%esi
  8047bb:	89 d1                	mov    %edx,%ecx
  8047bd:	39 d3                	cmp    %edx,%ebx
  8047bf:	0f 82 87 00 00 00    	jb     80484c <__umoddi3+0x134>
  8047c5:	0f 84 91 00 00 00    	je     80485c <__umoddi3+0x144>
  8047cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047cf:	29 f2                	sub    %esi,%edx
  8047d1:	19 cb                	sbb    %ecx,%ebx
  8047d3:	89 d8                	mov    %ebx,%eax
  8047d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047d9:	d3 e0                	shl    %cl,%eax
  8047db:	89 e9                	mov    %ebp,%ecx
  8047dd:	d3 ea                	shr    %cl,%edx
  8047df:	09 d0                	or     %edx,%eax
  8047e1:	89 e9                	mov    %ebp,%ecx
  8047e3:	d3 eb                	shr    %cl,%ebx
  8047e5:	89 da                	mov    %ebx,%edx
  8047e7:	83 c4 1c             	add    $0x1c,%esp
  8047ea:	5b                   	pop    %ebx
  8047eb:	5e                   	pop    %esi
  8047ec:	5f                   	pop    %edi
  8047ed:	5d                   	pop    %ebp
  8047ee:	c3                   	ret    
  8047ef:	90                   	nop
  8047f0:	89 fd                	mov    %edi,%ebp
  8047f2:	85 ff                	test   %edi,%edi
  8047f4:	75 0b                	jne    804801 <__umoddi3+0xe9>
  8047f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8047fb:	31 d2                	xor    %edx,%edx
  8047fd:	f7 f7                	div    %edi
  8047ff:	89 c5                	mov    %eax,%ebp
  804801:	89 f0                	mov    %esi,%eax
  804803:	31 d2                	xor    %edx,%edx
  804805:	f7 f5                	div    %ebp
  804807:	89 c8                	mov    %ecx,%eax
  804809:	f7 f5                	div    %ebp
  80480b:	89 d0                	mov    %edx,%eax
  80480d:	e9 44 ff ff ff       	jmp    804756 <__umoddi3+0x3e>
  804812:	66 90                	xchg   %ax,%ax
  804814:	89 c8                	mov    %ecx,%eax
  804816:	89 f2                	mov    %esi,%edx
  804818:	83 c4 1c             	add    $0x1c,%esp
  80481b:	5b                   	pop    %ebx
  80481c:	5e                   	pop    %esi
  80481d:	5f                   	pop    %edi
  80481e:	5d                   	pop    %ebp
  80481f:	c3                   	ret    
  804820:	3b 04 24             	cmp    (%esp),%eax
  804823:	72 06                	jb     80482b <__umoddi3+0x113>
  804825:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804829:	77 0f                	ja     80483a <__umoddi3+0x122>
  80482b:	89 f2                	mov    %esi,%edx
  80482d:	29 f9                	sub    %edi,%ecx
  80482f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804833:	89 14 24             	mov    %edx,(%esp)
  804836:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80483a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80483e:	8b 14 24             	mov    (%esp),%edx
  804841:	83 c4 1c             	add    $0x1c,%esp
  804844:	5b                   	pop    %ebx
  804845:	5e                   	pop    %esi
  804846:	5f                   	pop    %edi
  804847:	5d                   	pop    %ebp
  804848:	c3                   	ret    
  804849:	8d 76 00             	lea    0x0(%esi),%esi
  80484c:	2b 04 24             	sub    (%esp),%eax
  80484f:	19 fa                	sbb    %edi,%edx
  804851:	89 d1                	mov    %edx,%ecx
  804853:	89 c6                	mov    %eax,%esi
  804855:	e9 71 ff ff ff       	jmp    8047cb <__umoddi3+0xb3>
  80485a:	66 90                	xchg   %ax,%ax
  80485c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804860:	72 ea                	jb     80484c <__umoddi3+0x134>
  804862:	89 d9                	mov    %ebx,%ecx
  804864:	e9 62 ff ff ff       	jmp    8047cb <__umoddi3+0xb3>
