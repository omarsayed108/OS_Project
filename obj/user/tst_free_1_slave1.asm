
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 7f 12 00 00       	call   8012b5 <libmain>
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
  800067:	e8 f3 33 00 00       	call   80345f <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 36 34 00 00       	call   8034aa <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 b7 2c 00 00       	call   802d7e <malloc>
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
  8000df:	e8 7b 33 00 00       	call   80345f <sys_calculate_free_frames>
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
  80012c:	e8 4f 16 00 00       	call   801780 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 71 33 00 00       	call   8034aa <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 fc 48 80 00       	push   $0x8048fc
  800150:	6a 0c                	push   $0xc
  800152:	e8 29 16 00 00       	call   801780 <cprintf_colored>
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
  800174:	e8 e6 32 00 00       	call   80345f <sys_calculate_free_frames>
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
  8001b9:	e8 a1 32 00 00       	call   80345f <sys_calculate_free_frames>
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
  8001ff:	e8 7c 15 00 00       	call   801780 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 9e 32 00 00       	call   8034aa <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 00 4a 80 00       	push   $0x804a00
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 4f 15 00 00       	call   801780 <cprintf_colored>
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
  800270:	e8 ac 35 00 00       	call   803821 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 78 4a 80 00       	push   $0x804a78
  80028f:	6a 0c                	push   $0xc
  800291:	e8 ea 14 00 00       	call   801780 <cprintf_colored>
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
  8002ae:	e8 ac 31 00 00       	call   80345f <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 ef 31 00 00       	call   8034aa <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 31 2c 00 00       	call   802f02 <free>
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
  8002fc:	e8 a9 31 00 00       	call   8034aa <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 b0 4a 80 00       	push   $0x804ab0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 61 14 00 00       	call   801780 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 38 31 00 00       	call   80345f <sys_calculate_free_frames>
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
  800366:	e8 15 14 00 00       	call   801780 <cprintf_colored>
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
  8003bd:	e8 5f 34 00 00       	call   803821 <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 58 4b 80 00       	push   $0x804b58
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 9d 13 00 00       	call   801780 <cprintf_colored>
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
  80043a:	e8 41 13 00 00       	call   801780 <cprintf_colored>
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
  800503:	e8 78 12 00 00       	call   801780 <cprintf_colored>
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
  8005dd:	e8 9e 11 00 00       	call   801780 <cprintf_colored>
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
  8006b7:	e8 c4 10 00 00       	call   801780 <cprintf_colored>
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
  800791:	e8 ea 0f 00 00       	call   801780 <cprintf_colored>
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
  80086b:	e8 10 0f 00 00       	call   801780 <cprintf_colored>
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
  800945:	e8 36 0e 00 00       	call   801780 <cprintf_colored>
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
  800a3a:	e8 41 0d 00 00       	call   801780 <cprintf_colored>
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
  800b38:	e8 43 0c 00 00       	call   801780 <cprintf_colored>
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
  800c36:	e8 45 0b 00 00       	call   801780 <cprintf_colored>
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
  800d34:	e8 47 0a 00 00       	call   801780 <cprintf_colored>
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
  800e21:	e8 5a 09 00 00       	call   801780 <cprintf_colored>
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
  800f0e:	e8 6d 08 00 00       	call   801780 <cprintf_colored>
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
  800ffb:	e8 80 07 00 00       	call   801780 <cprintf_colored>
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
  80101e:	e8 5d 07 00 00       	call   801780 <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 23 24 00 00       	call   80345f <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 63 24 00 00       	call   8034aa <sys_pf_calculate_allocated_pages>
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
  801072:	e8 07 1d 00 00       	call   802d7e <malloc>
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
  8010a8:	e8 d3 06 00 00       	call   801780 <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 f5 23 00 00       	call   8034aa <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 6c 4c 80 00       	push   $0x804c6c
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 a7 06 00 00       	call   801780 <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 7e 23 00 00       	call   80345f <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 dc 4c 80 00       	push   $0x804cdc
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 7b 06 00 00       	call   801780 <cprintf_colored>
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
	 *********************************************************/
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
  801148:	6a 12                	push   $0x12
  80114a:	68 40 4d 80 00       	push   $0x804d40
  80114f:	e8 11 03 00 00       	call   801465 <_panic>
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
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
  80124c:	e8 2f 05 00 00       	call   801780 <cprintf_colored>
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
  80126a:	74 43                	je     8012af <_main+0x193>
	{
		return;
	}

	inctst(); //to ensure that it reached here
  80126c:	e8 f5 24 00 00       	call   803766 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  801271:	90                   	nop
  801272:	e8 09 25 00 00       	call   803780 <gettst>
  801277:	83 f8 03             	cmp    $0x3,%eax
  80127a:	75 f6                	jne    801272 <_main+0x156>

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		char* byteArr = (char *) ptr_allocations[allocIndex];
  80127c:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  801281:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  801288:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[8*kilo] = maxByte ;
  80128b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80128e:	05 00 20 00 00       	add    $0x2000,%eax
  801293:	c6 00 7f             	movb   $0x7f,(%eax)
		inctst();
  801296:	e8 cb 24 00 00       	call   803766 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  80129b:	83 ec 04             	sub    $0x4,%esp
  80129e:	68 5c 4d 80 00       	push   $0x804d5c
  8012a3:	6a 4c                	push   $0x4c
  8012a5:	68 40 4d 80 00       	push   $0x804d40
  8012aa:	e8 b6 01 00 00       	call   801465 <_panic>
			correct = freeSpaceInPageAlloc(0, 1);
		}
	}
	if (!correct)
	{
		return;
  8012af:	90                   	nop
		inctst();
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
	}

	return;
}
  8012b0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8012be:	e8 65 23 00 00       	call   803628 <sys_getenvindex>
  8012c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8012c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012c9:	89 d0                	mov    %edx,%eax
  8012cb:	01 c0                	add    %eax,%eax
  8012cd:	01 d0                	add    %edx,%eax
  8012cf:	c1 e0 02             	shl    $0x2,%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	c1 e0 02             	shl    $0x2,%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	c1 e0 03             	shl    $0x3,%eax
  8012dc:	01 d0                	add    %edx,%eax
  8012de:	c1 e0 02             	shl    $0x2,%eax
  8012e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012e6:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8012eb:	a1 00 62 80 00       	mov    0x806200,%eax
  8012f0:	8a 40 20             	mov    0x20(%eax),%al
  8012f3:	84 c0                	test   %al,%al
  8012f5:	74 0d                	je     801304 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8012f7:	a1 00 62 80 00       	mov    0x806200,%eax
  8012fc:	83 c0 20             	add    $0x20,%eax
  8012ff:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801308:	7e 0a                	jle    801314 <libmain+0x5f>
		binaryname = argv[0];
  80130a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130d:	8b 00                	mov    (%eax),%eax
  80130f:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801314:	83 ec 08             	sub    $0x8,%esp
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	ff 75 08             	pushl  0x8(%ebp)
  80131d:	e8 fa fd ff ff       	call   80111c <_main>
  801322:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801325:	a1 00 60 80 00       	mov    0x806000,%eax
  80132a:	85 c0                	test   %eax,%eax
  80132c:	0f 84 01 01 00 00    	je     801433 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801332:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801338:	bb a0 4e 80 00       	mov    $0x804ea0,%ebx
  80133d:	ba 0e 00 00 00       	mov    $0xe,%edx
  801342:	89 c7                	mov    %eax,%edi
  801344:	89 de                	mov    %ebx,%esi
  801346:	89 d1                	mov    %edx,%ecx
  801348:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80134a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80134d:	b9 56 00 00 00       	mov    $0x56,%ecx
  801352:	b0 00                	mov    $0x0,%al
  801354:	89 d7                	mov    %edx,%edi
  801356:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801358:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80135f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	50                   	push   %eax
  801366:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	e8 ec 24 00 00       	call   80385e <sys_utilities>
  801372:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801375:	e8 35 20 00 00       	call   8033af <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80137a:	83 ec 0c             	sub    $0xc,%esp
  80137d:	68 c0 4d 80 00       	push   $0x804dc0
  801382:	e8 cc 03 00 00       	call   801753 <cprintf>
  801387:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80138a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80138d:	85 c0                	test   %eax,%eax
  80138f:	74 18                	je     8013a9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801391:	e8 e6 24 00 00       	call   80387c <sys_get_optimal_num_faults>
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	50                   	push   %eax
  80139a:	68 e8 4d 80 00       	push   $0x804de8
  80139f:	e8 af 03 00 00       	call   801753 <cprintf>
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	eb 59                	jmp    801402 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8013a9:	a1 00 62 80 00       	mov    0x806200,%eax
  8013ae:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8013b4:	a1 00 62 80 00       	mov    0x806200,%eax
  8013b9:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	52                   	push   %edx
  8013c3:	50                   	push   %eax
  8013c4:	68 0c 4e 80 00       	push   $0x804e0c
  8013c9:	e8 85 03 00 00       	call   801753 <cprintf>
  8013ce:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8013d1:	a1 00 62 80 00       	mov    0x806200,%eax
  8013d6:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8013dc:	a1 00 62 80 00       	mov    0x806200,%eax
  8013e1:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8013e7:	a1 00 62 80 00       	mov    0x806200,%eax
  8013ec:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8013f2:	51                   	push   %ecx
  8013f3:	52                   	push   %edx
  8013f4:	50                   	push   %eax
  8013f5:	68 34 4e 80 00       	push   $0x804e34
  8013fa:	e8 54 03 00 00       	call   801753 <cprintf>
  8013ff:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801402:	a1 00 62 80 00       	mov    0x806200,%eax
  801407:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	50                   	push   %eax
  801411:	68 8c 4e 80 00       	push   $0x804e8c
  801416:	e8 38 03 00 00       	call   801753 <cprintf>
  80141b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	68 c0 4d 80 00       	push   $0x804dc0
  801426:	e8 28 03 00 00       	call   801753 <cprintf>
  80142b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80142e:	e8 96 1f 00 00       	call   8033c9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801433:	e8 1f 00 00 00       	call   801457 <exit>
}
  801438:	90                   	nop
  801439:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    

00801441 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	6a 00                	push   $0x0
  80144c:	e8 a3 21 00 00       	call   8035f4 <sys_destroy_env>
  801451:	83 c4 10             	add    $0x10,%esp
}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <exit>:

void
exit(void)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80145d:	e8 f8 21 00 00       	call   80365a <sys_exit_env>
}
  801462:	90                   	nop
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80146b:	8d 45 10             	lea    0x10(%ebp),%eax
  80146e:	83 c0 04             	add    $0x4,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801474:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801479:	85 c0                	test   %eax,%eax
  80147b:	74 16                	je     801493 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80147d:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	50                   	push   %eax
  801486:	68 04 4f 80 00       	push   $0x804f04
  80148b:	e8 c3 02 00 00       	call   801753 <cprintf>
  801490:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801493:	a1 04 60 80 00       	mov    0x806004,%eax
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	ff 75 08             	pushl  0x8(%ebp)
  8014a1:	50                   	push   %eax
  8014a2:	68 0c 4f 80 00       	push   $0x804f0c
  8014a7:	6a 74                	push   $0x74
  8014a9:	e8 d2 02 00 00       	call   801780 <cprintf_colored>
  8014ae:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8014b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ba:	50                   	push   %eax
  8014bb:	e8 24 02 00 00       	call   8016e4 <vcprintf>
  8014c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	6a 00                	push   $0x0
  8014c8:	68 34 4f 80 00       	push   $0x804f34
  8014cd:	e8 12 02 00 00       	call   8016e4 <vcprintf>
  8014d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8014d5:	e8 7d ff ff ff       	call   801457 <exit>

	// should not return here
	while (1) ;
  8014da:	eb fe                	jmp    8014da <_panic+0x75>

008014dc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	53                   	push   %ebx
  8014e0:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014e3:	a1 00 62 80 00       	mov    0x806200,%eax
  8014e8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8014ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f1:	39 c2                	cmp    %eax,%edx
  8014f3:	74 14                	je     801509 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014f5:	83 ec 04             	sub    $0x4,%esp
  8014f8:	68 38 4f 80 00       	push   $0x804f38
  8014fd:	6a 26                	push   $0x26
  8014ff:	68 84 4f 80 00       	push   $0x804f84
  801504:	e8 5c ff ff ff       	call   801465 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801517:	e9 d9 00 00 00       	jmp    8015f5 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80151c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	01 d0                	add    %edx,%eax
  80152b:	8b 00                	mov    (%eax),%eax
  80152d:	85 c0                	test   %eax,%eax
  80152f:	75 08                	jne    801539 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  801531:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801534:	e9 b9 00 00 00       	jmp    8015f2 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  801539:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801540:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801547:	eb 79                	jmp    8015c2 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801549:	a1 00 62 80 00       	mov    0x806200,%eax
  80154e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801554:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801557:	89 d0                	mov    %edx,%eax
  801559:	01 c0                	add    %eax,%eax
  80155b:	01 d0                	add    %edx,%eax
  80155d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801564:	01 d8                	add    %ebx,%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	01 c8                	add    %ecx,%eax
  80156a:	8a 40 04             	mov    0x4(%eax),%al
  80156d:	84 c0                	test   %al,%al
  80156f:	75 4e                	jne    8015bf <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801571:	a1 00 62 80 00       	mov    0x806200,%eax
  801576:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80157c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80157f:	89 d0                	mov    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80158c:	01 d8                	add    %ebx,%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	01 c8                	add    %ecx,%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80159a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	01 c8                	add    %ecx,%eax
  8015b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8015b2:	39 c2                	cmp    %eax,%edx
  8015b4:	75 09                	jne    8015bf <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8015b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8015bd:	eb 19                	jmp    8015d8 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015bf:	ff 45 e8             	incl   -0x18(%ebp)
  8015c2:	a1 00 62 80 00       	mov    0x806200,%eax
  8015c7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8015cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d0:	39 c2                	cmp    %eax,%edx
  8015d2:	0f 87 71 ff ff ff    	ja     801549 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8015d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015dc:	75 14                	jne    8015f2 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 90 4f 80 00       	push   $0x804f90
  8015e6:	6a 3a                	push   $0x3a
  8015e8:	68 84 4f 80 00       	push   $0x804f84
  8015ed:	e8 73 fe ff ff       	call   801465 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8015f2:	ff 45 f0             	incl   -0x10(%ebp)
  8015f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8015fb:	0f 8c 1b ff ff ff    	jl     80151c <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801601:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801608:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80160f:	eb 2e                	jmp    80163f <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801611:	a1 00 62 80 00       	mov    0x806200,%eax
  801616:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80161c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80161f:	89 d0                	mov    %edx,%eax
  801621:	01 c0                	add    %eax,%eax
  801623:	01 d0                	add    %edx,%eax
  801625:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80162c:	01 d8                	add    %ebx,%eax
  80162e:	01 d0                	add    %edx,%eax
  801630:	01 c8                	add    %ecx,%eax
  801632:	8a 40 04             	mov    0x4(%eax),%al
  801635:	3c 01                	cmp    $0x1,%al
  801637:	75 03                	jne    80163c <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  801639:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80163c:	ff 45 e0             	incl   -0x20(%ebp)
  80163f:	a1 00 62 80 00       	mov    0x806200,%eax
  801644:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80164a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164d:	39 c2                	cmp    %eax,%edx
  80164f:	77 c0                	ja     801611 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801657:	74 14                	je     80166d <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	68 e4 4f 80 00       	push   $0x804fe4
  801661:	6a 44                	push   $0x44
  801663:	68 84 4f 80 00       	push   $0x804f84
  801668:	e8 f8 fd ff ff       	call   801465 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80166d:	90                   	nop
  80166e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	53                   	push   %ebx
  801677:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	8b 00                	mov    (%eax),%eax
  80167f:	8d 48 01             	lea    0x1(%eax),%ecx
  801682:	8b 55 0c             	mov    0xc(%ebp),%edx
  801685:	89 0a                	mov    %ecx,(%edx)
  801687:	8b 55 08             	mov    0x8(%ebp),%edx
  80168a:	88 d1                	mov    %dl,%cl
  80168c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	8b 00                	mov    (%eax),%eax
  801698:	3d ff 00 00 00       	cmp    $0xff,%eax
  80169d:	75 30                	jne    8016cf <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80169f:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  8016a5:	a0 24 62 80 00       	mov    0x806224,%al
  8016aa:	0f b6 c0             	movzbl %al,%eax
  8016ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b0:	8b 09                	mov    (%ecx),%ecx
  8016b2:	89 cb                	mov    %ecx,%ebx
  8016b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b7:	83 c1 08             	add    $0x8,%ecx
  8016ba:	52                   	push   %edx
  8016bb:	50                   	push   %eax
  8016bc:	53                   	push   %ebx
  8016bd:	51                   	push   %ecx
  8016be:	e8 a8 1c 00 00       	call   80336b <sys_cputs>
  8016c3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8016c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d2:	8b 40 04             	mov    0x4(%eax),%eax
  8016d5:	8d 50 01             	lea    0x1(%eax),%edx
  8016d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016db:	89 50 04             	mov    %edx,0x4(%eax)
}
  8016de:	90                   	nop
  8016df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8016ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016f4:	00 00 00 
	b.cnt = 0;
  8016f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8016fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80170d:	50                   	push   %eax
  80170e:	68 73 16 80 00       	push   $0x801673
  801713:	e8 5a 02 00 00       	call   801972 <vprintfmt>
  801718:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80171b:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801721:	a0 24 62 80 00       	mov    0x806224,%al
  801726:	0f b6 c0             	movzbl %al,%eax
  801729:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80172f:	52                   	push   %edx
  801730:	50                   	push   %eax
  801731:	51                   	push   %ecx
  801732:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801738:	83 c0 08             	add    $0x8,%eax
  80173b:	50                   	push   %eax
  80173c:	e8 2a 1c 00 00       	call   80336b <sys_cputs>
  801741:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801744:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  80174b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801759:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  801760:	8d 45 0c             	lea    0xc(%ebp),%eax
  801763:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	ff 75 f4             	pushl  -0xc(%ebp)
  80176f:	50                   	push   %eax
  801770:	e8 6f ff ff ff       	call   8016e4 <vcprintf>
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801786:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	c1 e0 08             	shl    $0x8,%eax
  801793:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  801798:	8d 45 0c             	lea    0xc(%ebp),%eax
  80179b:	83 c0 04             	add    $0x4,%eax
  80179e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017aa:	50                   	push   %eax
  8017ab:	e8 34 ff ff ff       	call   8016e4 <vcprintf>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8017b6:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  8017bd:	07 00 00 

	return cnt;
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8017cb:	e8 df 1b 00 00       	call   8033af <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8017d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8017d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	83 ec 08             	sub    $0x8,%esp
  8017dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8017df:	50                   	push   %eax
  8017e0:	e8 ff fe ff ff       	call   8016e4 <vcprintf>
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8017eb:	e8 d9 1b 00 00       	call   8033c9 <sys_unlock_cons>
	return cnt;
  8017f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 14             	sub    $0x14,%esp
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801802:	8b 45 14             	mov    0x14(%ebp),%eax
  801805:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801808:	8b 45 18             	mov    0x18(%ebp),%eax
  80180b:	ba 00 00 00 00       	mov    $0x0,%edx
  801810:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801813:	77 55                	ja     80186a <printnum+0x75>
  801815:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801818:	72 05                	jb     80181f <printnum+0x2a>
  80181a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80181d:	77 4b                	ja     80186a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80181f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801822:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801825:	8b 45 18             	mov    0x18(%ebp),%eax
  801828:	ba 00 00 00 00       	mov    $0x0,%edx
  80182d:	52                   	push   %edx
  80182e:	50                   	push   %eax
  80182f:	ff 75 f4             	pushl  -0xc(%ebp)
  801832:	ff 75 f0             	pushl  -0x10(%ebp)
  801835:	e8 d2 2d 00 00       	call   80460c <__udivdi3>
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	ff 75 20             	pushl  0x20(%ebp)
  801843:	53                   	push   %ebx
  801844:	ff 75 18             	pushl  0x18(%ebp)
  801847:	52                   	push   %edx
  801848:	50                   	push   %eax
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	e8 a1 ff ff ff       	call   8017f5 <printnum>
  801854:	83 c4 20             	add    $0x20,%esp
  801857:	eb 1a                	jmp    801873 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 20             	pushl  0x20(%ebp)
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	ff d0                	call   *%eax
  801867:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80186a:	ff 4d 1c             	decl   0x1c(%ebp)
  80186d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801871:	7f e6                	jg     801859 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801873:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801876:	bb 00 00 00 00       	mov    $0x0,%ebx
  80187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801881:	53                   	push   %ebx
  801882:	51                   	push   %ecx
  801883:	52                   	push   %edx
  801884:	50                   	push   %eax
  801885:	e8 92 2e 00 00       	call   80471c <__umoddi3>
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	05 54 52 80 00       	add    $0x805254,%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	0f be c0             	movsbl %al,%eax
  801897:	83 ec 08             	sub    $0x8,%esp
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	50                   	push   %eax
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	ff d0                	call   *%eax
  8018a3:	83 c4 10             	add    $0x10,%esp
}
  8018a6:	90                   	nop
  8018a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8018af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8018b3:	7e 1c                	jle    8018d1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8b 00                	mov    (%eax),%eax
  8018ba:	8d 50 08             	lea    0x8(%eax),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	89 10                	mov    %edx,(%eax)
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	8b 00                	mov    (%eax),%eax
  8018c7:	83 e8 08             	sub    $0x8,%eax
  8018ca:	8b 50 04             	mov    0x4(%eax),%edx
  8018cd:	8b 00                	mov    (%eax),%eax
  8018cf:	eb 40                	jmp    801911 <getuint+0x65>
	else if (lflag)
  8018d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018d5:	74 1e                	je     8018f5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	8b 00                	mov    (%eax),%eax
  8018dc:	8d 50 04             	lea    0x4(%eax),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	89 10                	mov    %edx,(%eax)
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	8b 00                	mov    (%eax),%eax
  8018e9:	83 e8 04             	sub    $0x4,%eax
  8018ec:	8b 00                	mov    (%eax),%eax
  8018ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f3:	eb 1c                	jmp    801911 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8b 00                	mov    (%eax),%eax
  8018fa:	8d 50 04             	lea    0x4(%eax),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	89 10                	mov    %edx,(%eax)
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	83 e8 04             	sub    $0x4,%eax
  80190a:	8b 00                	mov    (%eax),%eax
  80190c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801916:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80191a:	7e 1c                	jle    801938 <getint+0x25>
		return va_arg(*ap, long long);
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	8b 00                	mov    (%eax),%eax
  801921:	8d 50 08             	lea    0x8(%eax),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	89 10                	mov    %edx,(%eax)
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8b 00                	mov    (%eax),%eax
  80192e:	83 e8 08             	sub    $0x8,%eax
  801931:	8b 50 04             	mov    0x4(%eax),%edx
  801934:	8b 00                	mov    (%eax),%eax
  801936:	eb 38                	jmp    801970 <getint+0x5d>
	else if (lflag)
  801938:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80193c:	74 1a                	je     801958 <getint+0x45>
		return va_arg(*ap, long);
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	8b 00                	mov    (%eax),%eax
  801943:	8d 50 04             	lea    0x4(%eax),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	89 10                	mov    %edx,(%eax)
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 e8 04             	sub    $0x4,%eax
  801953:	8b 00                	mov    (%eax),%eax
  801955:	99                   	cltd   
  801956:	eb 18                	jmp    801970 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8b 00                	mov    (%eax),%eax
  80195d:	8d 50 04             	lea    0x4(%eax),%edx
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	89 10                	mov    %edx,(%eax)
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	8b 00                	mov    (%eax),%eax
  80196a:	83 e8 04             	sub    $0x4,%eax
  80196d:	8b 00                	mov    (%eax),%eax
  80196f:	99                   	cltd   
}
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    

00801972 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	56                   	push   %esi
  801976:	53                   	push   %ebx
  801977:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80197a:	eb 17                	jmp    801993 <vprintfmt+0x21>
			if (ch == '\0')
  80197c:	85 db                	test   %ebx,%ebx
  80197e:	0f 84 c1 03 00 00    	je     801d45 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	53                   	push   %ebx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	ff d0                	call   *%eax
  801990:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801993:	8b 45 10             	mov    0x10(%ebp),%eax
  801996:	8d 50 01             	lea    0x1(%eax),%edx
  801999:	89 55 10             	mov    %edx,0x10(%ebp)
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d8             	movzbl %al,%ebx
  8019a1:	83 fb 25             	cmp    $0x25,%ebx
  8019a4:	75 d6                	jne    80197c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8019a6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8019aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8019b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8019bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8019c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c9:	8d 50 01             	lea    0x1(%eax),%edx
  8019cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d8             	movzbl %al,%ebx
  8019d4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8019d7:	83 f8 5b             	cmp    $0x5b,%eax
  8019da:	0f 87 3d 03 00 00    	ja     801d1d <vprintfmt+0x3ab>
  8019e0:	8b 04 85 78 52 80 00 	mov    0x805278(,%eax,4),%eax
  8019e7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8019e9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8019ed:	eb d7                	jmp    8019c6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8019ef:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8019f3:	eb d1                	jmp    8019c6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8019fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ff:	89 d0                	mov    %edx,%eax
  801a01:	c1 e0 02             	shl    $0x2,%eax
  801a04:	01 d0                	add    %edx,%eax
  801a06:	01 c0                	add    %eax,%eax
  801a08:	01 d8                	add    %ebx,%eax
  801a0a:	83 e8 30             	sub    $0x30,%eax
  801a0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	8a 00                	mov    (%eax),%al
  801a15:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801a18:	83 fb 2f             	cmp    $0x2f,%ebx
  801a1b:	7e 3e                	jle    801a5b <vprintfmt+0xe9>
  801a1d:	83 fb 39             	cmp    $0x39,%ebx
  801a20:	7f 39                	jg     801a5b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a22:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801a25:	eb d5                	jmp    8019fc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801a27:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2a:	83 c0 04             	add    $0x4,%eax
  801a2d:	89 45 14             	mov    %eax,0x14(%ebp)
  801a30:	8b 45 14             	mov    0x14(%ebp),%eax
  801a33:	83 e8 04             	sub    $0x4,%eax
  801a36:	8b 00                	mov    (%eax),%eax
  801a38:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801a3b:	eb 1f                	jmp    801a5c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801a3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a41:	79 83                	jns    8019c6 <vprintfmt+0x54>
				width = 0;
  801a43:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801a4a:	e9 77 ff ff ff       	jmp    8019c6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801a4f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801a56:	e9 6b ff ff ff       	jmp    8019c6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801a5b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801a5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a60:	0f 89 60 ff ff ff    	jns    8019c6 <vprintfmt+0x54>
				width = precision, precision = -1;
  801a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a6c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801a73:	e9 4e ff ff ff       	jmp    8019c6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a78:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801a7b:	e9 46 ff ff ff       	jmp    8019c6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801a80:	8b 45 14             	mov    0x14(%ebp),%eax
  801a83:	83 c0 04             	add    $0x4,%eax
  801a86:	89 45 14             	mov    %eax,0x14(%ebp)
  801a89:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8c:	83 e8 04             	sub    $0x4,%eax
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	83 ec 08             	sub    $0x8,%esp
  801a94:	ff 75 0c             	pushl  0xc(%ebp)
  801a97:	50                   	push   %eax
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	ff d0                	call   *%eax
  801a9d:	83 c4 10             	add    $0x10,%esp
			break;
  801aa0:	e9 9b 02 00 00       	jmp    801d40 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa8:	83 c0 04             	add    $0x4,%eax
  801aab:	89 45 14             	mov    %eax,0x14(%ebp)
  801aae:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab1:	83 e8 04             	sub    $0x4,%eax
  801ab4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801ab6:	85 db                	test   %ebx,%ebx
  801ab8:	79 02                	jns    801abc <vprintfmt+0x14a>
				err = -err;
  801aba:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801abc:	83 fb 64             	cmp    $0x64,%ebx
  801abf:	7f 0b                	jg     801acc <vprintfmt+0x15a>
  801ac1:	8b 34 9d c0 50 80 00 	mov    0x8050c0(,%ebx,4),%esi
  801ac8:	85 f6                	test   %esi,%esi
  801aca:	75 19                	jne    801ae5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801acc:	53                   	push   %ebx
  801acd:	68 65 52 80 00       	push   $0x805265
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	ff 75 08             	pushl  0x8(%ebp)
  801ad8:	e8 70 02 00 00       	call   801d4d <printfmt>
  801add:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801ae0:	e9 5b 02 00 00       	jmp    801d40 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801ae5:	56                   	push   %esi
  801ae6:	68 6e 52 80 00       	push   $0x80526e
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	ff 75 08             	pushl  0x8(%ebp)
  801af1:	e8 57 02 00 00       	call   801d4d <printfmt>
  801af6:	83 c4 10             	add    $0x10,%esp
			break;
  801af9:	e9 42 02 00 00       	jmp    801d40 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801afe:	8b 45 14             	mov    0x14(%ebp),%eax
  801b01:	83 c0 04             	add    $0x4,%eax
  801b04:	89 45 14             	mov    %eax,0x14(%ebp)
  801b07:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0a:	83 e8 04             	sub    $0x4,%eax
  801b0d:	8b 30                	mov    (%eax),%esi
  801b0f:	85 f6                	test   %esi,%esi
  801b11:	75 05                	jne    801b18 <vprintfmt+0x1a6>
				p = "(null)";
  801b13:	be 71 52 80 00       	mov    $0x805271,%esi
			if (width > 0 && padc != '-')
  801b18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b1c:	7e 6d                	jle    801b8b <vprintfmt+0x219>
  801b1e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801b22:	74 67                	je     801b8b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	50                   	push   %eax
  801b2b:	56                   	push   %esi
  801b2c:	e8 1e 03 00 00       	call   801e4f <strnlen>
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801b37:	eb 16                	jmp    801b4f <vprintfmt+0x1dd>
					putch(padc, putdat);
  801b39:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	ff d0                	call   *%eax
  801b49:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b4c:	ff 4d e4             	decl   -0x1c(%ebp)
  801b4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b53:	7f e4                	jg     801b39 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b55:	eb 34                	jmp    801b8b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801b57:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b5b:	74 1c                	je     801b79 <vprintfmt+0x207>
  801b5d:	83 fb 1f             	cmp    $0x1f,%ebx
  801b60:	7e 05                	jle    801b67 <vprintfmt+0x1f5>
  801b62:	83 fb 7e             	cmp    $0x7e,%ebx
  801b65:	7e 12                	jle    801b79 <vprintfmt+0x207>
					putch('?', putdat);
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	6a 3f                	push   $0x3f
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	ff d0                	call   *%eax
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	eb 0f                	jmp    801b88 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801b79:	83 ec 08             	sub    $0x8,%esp
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	53                   	push   %ebx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	ff d0                	call   *%eax
  801b85:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b88:	ff 4d e4             	decl   -0x1c(%ebp)
  801b8b:	89 f0                	mov    %esi,%eax
  801b8d:	8d 70 01             	lea    0x1(%eax),%esi
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	0f be d8             	movsbl %al,%ebx
  801b95:	85 db                	test   %ebx,%ebx
  801b97:	74 24                	je     801bbd <vprintfmt+0x24b>
  801b99:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b9d:	78 b8                	js     801b57 <vprintfmt+0x1e5>
  801b9f:	ff 4d e0             	decl   -0x20(%ebp)
  801ba2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ba6:	79 af                	jns    801b57 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ba8:	eb 13                	jmp    801bbd <vprintfmt+0x24b>
				putch(' ', putdat);
  801baa:	83 ec 08             	sub    $0x8,%esp
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	6a 20                	push   $0x20
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	ff d0                	call   *%eax
  801bb7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801bba:	ff 4d e4             	decl   -0x1c(%ebp)
  801bbd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bc1:	7f e7                	jg     801baa <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801bc3:	e9 78 01 00 00       	jmp    801d40 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	ff 75 e8             	pushl  -0x18(%ebp)
  801bce:	8d 45 14             	lea    0x14(%ebp),%eax
  801bd1:	50                   	push   %eax
  801bd2:	e8 3c fd ff ff       	call   801913 <getint>
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bdd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be6:	85 d2                	test   %edx,%edx
  801be8:	79 23                	jns    801c0d <vprintfmt+0x29b>
				putch('-', putdat);
  801bea:	83 ec 08             	sub    $0x8,%esp
  801bed:	ff 75 0c             	pushl  0xc(%ebp)
  801bf0:	6a 2d                	push   $0x2d
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	ff d0                	call   *%eax
  801bf7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c00:	f7 d8                	neg    %eax
  801c02:	83 d2 00             	adc    $0x0,%edx
  801c05:	f7 da                	neg    %edx
  801c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801c0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801c14:	e9 bc 00 00 00       	jmp    801cd5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801c19:	83 ec 08             	sub    $0x8,%esp
  801c1c:	ff 75 e8             	pushl  -0x18(%ebp)
  801c1f:	8d 45 14             	lea    0x14(%ebp),%eax
  801c22:	50                   	push   %eax
  801c23:	e8 84 fc ff ff       	call   8018ac <getuint>
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801c31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801c38:	e9 98 00 00 00       	jmp    801cd5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801c3d:	83 ec 08             	sub    $0x8,%esp
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	6a 58                	push   $0x58
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	ff d0                	call   *%eax
  801c4a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801c4d:	83 ec 08             	sub    $0x8,%esp
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	6a 58                	push   $0x58
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	ff d0                	call   *%eax
  801c5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	6a 58                	push   $0x58
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	ff d0                	call   *%eax
  801c6a:	83 c4 10             	add    $0x10,%esp
			break;
  801c6d:	e9 ce 00 00 00       	jmp    801d40 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801c72:	83 ec 08             	sub    $0x8,%esp
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	6a 30                	push   $0x30
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	ff d0                	call   *%eax
  801c7f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801c82:	83 ec 08             	sub    $0x8,%esp
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	6a 78                	push   $0x78
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	ff d0                	call   *%eax
  801c8f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801c92:	8b 45 14             	mov    0x14(%ebp),%eax
  801c95:	83 c0 04             	add    $0x4,%eax
  801c98:	89 45 14             	mov    %eax,0x14(%ebp)
  801c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9e:	83 e8 04             	sub    $0x4,%eax
  801ca1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ca6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801cad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801cb4:	eb 1f                	jmp    801cd5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801cb6:	83 ec 08             	sub    $0x8,%esp
  801cb9:	ff 75 e8             	pushl  -0x18(%ebp)
  801cbc:	8d 45 14             	lea    0x14(%ebp),%eax
  801cbf:	50                   	push   %eax
  801cc0:	e8 e7 fb ff ff       	call   8018ac <getuint>
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ccb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801cce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cd5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cdc:	83 ec 04             	sub    $0x4,%esp
  801cdf:	52                   	push   %edx
  801ce0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ce3:	50                   	push   %eax
  801ce4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce7:	ff 75 f0             	pushl  -0x10(%ebp)
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	e8 00 fb ff ff       	call   8017f5 <printnum>
  801cf5:	83 c4 20             	add    $0x20,%esp
			break;
  801cf8:	eb 46                	jmp    801d40 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cfa:	83 ec 08             	sub    $0x8,%esp
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	53                   	push   %ebx
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	ff d0                	call   *%eax
  801d06:	83 c4 10             	add    $0x10,%esp
			break;
  801d09:	eb 35                	jmp    801d40 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801d0b:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  801d12:	eb 2c                	jmp    801d40 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801d14:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  801d1b:	eb 23                	jmp    801d40 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d1d:	83 ec 08             	sub    $0x8,%esp
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	6a 25                	push   $0x25
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff d0                	call   *%eax
  801d2a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d2d:	ff 4d 10             	decl   0x10(%ebp)
  801d30:	eb 03                	jmp    801d35 <vprintfmt+0x3c3>
  801d32:	ff 4d 10             	decl   0x10(%ebp)
  801d35:	8b 45 10             	mov    0x10(%ebp),%eax
  801d38:	48                   	dec    %eax
  801d39:	8a 00                	mov    (%eax),%al
  801d3b:	3c 25                	cmp    $0x25,%al
  801d3d:	75 f3                	jne    801d32 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801d3f:	90                   	nop
		}
	}
  801d40:	e9 35 fc ff ff       	jmp    80197a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801d45:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d49:	5b                   	pop    %ebx
  801d4a:	5e                   	pop    %esi
  801d4b:	5d                   	pop    %ebp
  801d4c:	c3                   	ret    

00801d4d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801d53:	8d 45 10             	lea    0x10(%ebp),%eax
  801d56:	83 c0 04             	add    $0x4,%eax
  801d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d62:	50                   	push   %eax
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	ff 75 08             	pushl  0x8(%ebp)
  801d69:	e8 04 fc ff ff       	call   801972 <vprintfmt>
  801d6e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801d71:	90                   	nop
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7a:	8b 40 08             	mov    0x8(%eax),%eax
  801d7d:	8d 50 01             	lea    0x1(%eax),%edx
  801d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d83:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	8b 10                	mov    (%eax),%edx
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	8b 40 04             	mov    0x4(%eax),%eax
  801d91:	39 c2                	cmp    %eax,%edx
  801d93:	73 12                	jae    801da7 <sprintputch+0x33>
		*b->buf++ = ch;
  801d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d98:	8b 00                	mov    (%eax),%eax
  801d9a:	8d 48 01             	lea    0x1(%eax),%ecx
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	89 0a                	mov    %ecx,(%edx)
  801da2:	8b 55 08             	mov    0x8(%ebp),%edx
  801da5:	88 10                	mov    %dl,(%eax)
}
  801da7:	90                   	nop
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    

00801daa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	01 d0                	add    %edx,%eax
  801dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801dcb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dcf:	74 06                	je     801dd7 <vsnprintf+0x2d>
  801dd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dd5:	7f 07                	jg     801dde <vsnprintf+0x34>
		return -E_INVAL;
  801dd7:	b8 03 00 00 00       	mov    $0x3,%eax
  801ddc:	eb 20                	jmp    801dfe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801dde:	ff 75 14             	pushl  0x14(%ebp)
  801de1:	ff 75 10             	pushl  0x10(%ebp)
  801de4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801de7:	50                   	push   %eax
  801de8:	68 74 1d 80 00       	push   $0x801d74
  801ded:	e8 80 fb ff ff       	call   801972 <vprintfmt>
  801df2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e06:	8d 45 10             	lea    0x10(%ebp),%eax
  801e09:	83 c0 04             	add    $0x4,%eax
  801e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e12:	ff 75 f4             	pushl  -0xc(%ebp)
  801e15:	50                   	push   %eax
  801e16:	ff 75 0c             	pushl  0xc(%ebp)
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	e8 89 ff ff ff       	call   801daa <vsnprintf>
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e39:	eb 06                	jmp    801e41 <strlen+0x15>
		n++;
  801e3b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801e3e:	ff 45 08             	incl   0x8(%ebp)
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	8a 00                	mov    (%eax),%al
  801e46:	84 c0                	test   %al,%al
  801e48:	75 f1                	jne    801e3b <strlen+0xf>
		n++;
	return n;
  801e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801e55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e5c:	eb 09                	jmp    801e67 <strnlen+0x18>
		n++;
  801e5e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801e61:	ff 45 08             	incl   0x8(%ebp)
  801e64:	ff 4d 0c             	decl   0xc(%ebp)
  801e67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e6b:	74 09                	je     801e76 <strnlen+0x27>
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	8a 00                	mov    (%eax),%al
  801e72:	84 c0                	test   %al,%al
  801e74:	75 e8                	jne    801e5e <strnlen+0xf>
		n++;
	return n;
  801e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801e87:	90                   	nop
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	8d 50 01             	lea    0x1(%eax),%edx
  801e8e:	89 55 08             	mov    %edx,0x8(%ebp)
  801e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e94:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e97:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e9a:	8a 12                	mov    (%edx),%dl
  801e9c:	88 10                	mov    %dl,(%eax)
  801e9e:	8a 00                	mov    (%eax),%al
  801ea0:	84 c0                	test   %al,%al
  801ea2:	75 e4                	jne    801e88 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ebc:	eb 1f                	jmp    801edd <strncpy+0x34>
		*dst++ = *src;
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	8d 50 01             	lea    0x1(%eax),%edx
  801ec4:	89 55 08             	mov    %edx,0x8(%ebp)
  801ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eca:	8a 12                	mov    (%edx),%dl
  801ecc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	8a 00                	mov    (%eax),%al
  801ed3:	84 c0                	test   %al,%al
  801ed5:	74 03                	je     801eda <strncpy+0x31>
			src++;
  801ed7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801eda:	ff 45 fc             	incl   -0x4(%ebp)
  801edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee0:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ee3:	72 d9                	jb     801ebe <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801ef6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801efa:	74 30                	je     801f2c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801efc:	eb 16                	jmp    801f14 <strlcpy+0x2a>
			*dst++ = *src++;
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	8d 50 01             	lea    0x1(%eax),%edx
  801f04:	89 55 08             	mov    %edx,0x8(%ebp)
  801f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f0d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f10:	8a 12                	mov    (%edx),%dl
  801f12:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f14:	ff 4d 10             	decl   0x10(%ebp)
  801f17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f1b:	74 09                	je     801f26 <strlcpy+0x3c>
  801f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f20:	8a 00                	mov    (%eax),%al
  801f22:	84 c0                	test   %al,%al
  801f24:	75 d8                	jne    801efe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f32:	29 c2                	sub    %eax,%edx
  801f34:	89 d0                	mov    %edx,%eax
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801f3b:	eb 06                	jmp    801f43 <strcmp+0xb>
		p++, q++;
  801f3d:	ff 45 08             	incl   0x8(%ebp)
  801f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	8a 00                	mov    (%eax),%al
  801f48:	84 c0                	test   %al,%al
  801f4a:	74 0e                	je     801f5a <strcmp+0x22>
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	8a 10                	mov    (%eax),%dl
  801f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f54:	8a 00                	mov    (%eax),%al
  801f56:	38 c2                	cmp    %al,%dl
  801f58:	74 e3                	je     801f3d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	8a 00                	mov    (%eax),%al
  801f5f:	0f b6 d0             	movzbl %al,%edx
  801f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	0f b6 c0             	movzbl %al,%eax
  801f6a:	29 c2                	sub    %eax,%edx
  801f6c:	89 d0                	mov    %edx,%eax
}
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    

00801f70 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801f73:	eb 09                	jmp    801f7e <strncmp+0xe>
		n--, p++, q++;
  801f75:	ff 4d 10             	decl   0x10(%ebp)
  801f78:	ff 45 08             	incl   0x8(%ebp)
  801f7b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801f7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f82:	74 17                	je     801f9b <strncmp+0x2b>
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	8a 00                	mov    (%eax),%al
  801f89:	84 c0                	test   %al,%al
  801f8b:	74 0e                	je     801f9b <strncmp+0x2b>
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	8a 10                	mov    (%eax),%dl
  801f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f95:	8a 00                	mov    (%eax),%al
  801f97:	38 c2                	cmp    %al,%dl
  801f99:	74 da                	je     801f75 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801f9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f9f:	75 07                	jne    801fa8 <strncmp+0x38>
		return 0;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	eb 14                	jmp    801fbc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	8a 00                	mov    (%eax),%al
  801fad:	0f b6 d0             	movzbl %al,%edx
  801fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb3:	8a 00                	mov    (%eax),%al
  801fb5:	0f b6 c0             	movzbl %al,%eax
  801fb8:	29 c2                	sub    %eax,%edx
  801fba:	89 d0                	mov    %edx,%eax
}
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    

00801fbe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801fca:	eb 12                	jmp    801fde <strchr+0x20>
		if (*s == c)
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	8a 00                	mov    (%eax),%al
  801fd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801fd4:	75 05                	jne    801fdb <strchr+0x1d>
			return (char *) s;
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	eb 11                	jmp    801fec <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801fdb:	ff 45 08             	incl   0x8(%ebp)
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	8a 00                	mov    (%eax),%al
  801fe3:	84 c0                	test   %al,%al
  801fe5:	75 e5                	jne    801fcc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ffa:	eb 0d                	jmp    802009 <strfind+0x1b>
		if (*s == c)
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	8a 00                	mov    (%eax),%al
  802001:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802004:	74 0e                	je     802014 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802006:	ff 45 08             	incl   0x8(%ebp)
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	8a 00                	mov    (%eax),%al
  80200e:	84 c0                	test   %al,%al
  802010:	75 ea                	jne    801ffc <strfind+0xe>
  802012:	eb 01                	jmp    802015 <strfind+0x27>
		if (*s == c)
			break;
  802014:	90                   	nop
	return (char *) s;
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802026:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80202a:	76 63                	jbe    80208f <memset+0x75>
		uint64 data_block = c;
  80202c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202f:	99                   	cltd   
  802030:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802033:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802040:	c1 e0 08             	shl    $0x8,%eax
  802043:	09 45 f0             	or     %eax,-0x10(%ebp)
  802046:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802053:	c1 e0 10             	shl    $0x10,%eax
  802056:	09 45 f0             	or     %eax,-0x10(%ebp)
  802059:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802062:	89 c2                	mov    %eax,%edx
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	09 45 f0             	or     %eax,-0x10(%ebp)
  80206c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80206f:	eb 18                	jmp    802089 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802071:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802074:	8d 41 08             	lea    0x8(%ecx),%eax
  802077:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802080:	89 01                	mov    %eax,(%ecx)
  802082:	89 51 04             	mov    %edx,0x4(%ecx)
  802085:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802089:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80208d:	77 e2                	ja     802071 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80208f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802093:	74 23                	je     8020b8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802095:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802098:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80209b:	eb 0e                	jmp    8020ab <memset+0x91>
			*p8++ = (uint8)c;
  80209d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020a0:	8d 50 01             	lea    0x1(%eax),%edx
  8020a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8020ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	75 e5                	jne    80209d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8020c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8020cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8020d3:	76 24                	jbe    8020f9 <memcpy+0x3c>
		while(n >= 8){
  8020d5:	eb 1c                	jmp    8020f3 <memcpy+0x36>
			*d64 = *s64;
  8020d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020da:	8b 50 04             	mov    0x4(%eax),%edx
  8020dd:	8b 00                	mov    (%eax),%eax
  8020df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8020e2:	89 01                	mov    %eax,(%ecx)
  8020e4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8020e7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8020eb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8020ef:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8020f3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8020f7:	77 de                	ja     8020d7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8020f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020fd:	74 31                	je     802130 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8020ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802102:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802108:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80210b:	eb 16                	jmp    802123 <memcpy+0x66>
			*d8++ = *s8++;
  80210d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802110:	8d 50 01             	lea    0x1(%eax),%edx
  802113:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802119:	8d 4a 01             	lea    0x1(%edx),%ecx
  80211c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80211f:	8a 12                	mov    (%edx),%dl
  802121:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802123:	8b 45 10             	mov    0x10(%ebp),%eax
  802126:	8d 50 ff             	lea    -0x1(%eax),%edx
  802129:	89 55 10             	mov    %edx,0x10(%ebp)
  80212c:	85 c0                	test   %eax,%eax
  80212e:	75 dd                	jne    80210d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80213b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80214a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80214d:	73 50                	jae    80219f <memmove+0x6a>
  80214f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802152:	8b 45 10             	mov    0x10(%ebp),%eax
  802155:	01 d0                	add    %edx,%eax
  802157:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80215a:	76 43                	jbe    80219f <memmove+0x6a>
		s += n;
  80215c:	8b 45 10             	mov    0x10(%ebp),%eax
  80215f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802162:	8b 45 10             	mov    0x10(%ebp),%eax
  802165:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802168:	eb 10                	jmp    80217a <memmove+0x45>
			*--d = *--s;
  80216a:	ff 4d f8             	decl   -0x8(%ebp)
  80216d:	ff 4d fc             	decl   -0x4(%ebp)
  802170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802173:	8a 10                	mov    (%eax),%dl
  802175:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802178:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80217a:	8b 45 10             	mov    0x10(%ebp),%eax
  80217d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802180:	89 55 10             	mov    %edx,0x10(%ebp)
  802183:	85 c0                	test   %eax,%eax
  802185:	75 e3                	jne    80216a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802187:	eb 23                	jmp    8021ac <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80218c:	8d 50 01             	lea    0x1(%eax),%edx
  80218f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802192:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802195:	8d 4a 01             	lea    0x1(%edx),%ecx
  802198:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80219b:	8a 12                	mov    (%edx),%dl
  80219d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80219f:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	75 dd                	jne    802189 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021c3:	eb 2a                	jmp    8021ef <memcmp+0x3e>
		if (*s1 != *s2)
  8021c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c8:	8a 10                	mov    (%eax),%dl
  8021ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021cd:	8a 00                	mov    (%eax),%al
  8021cf:	38 c2                	cmp    %al,%dl
  8021d1:	74 16                	je     8021e9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d6:	8a 00                	mov    (%eax),%al
  8021d8:	0f b6 d0             	movzbl %al,%edx
  8021db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021de:	8a 00                	mov    (%eax),%al
  8021e0:	0f b6 c0             	movzbl %al,%eax
  8021e3:	29 c2                	sub    %eax,%edx
  8021e5:	89 d0                	mov    %edx,%eax
  8021e7:	eb 18                	jmp    802201 <memcmp+0x50>
		s1++, s2++;
  8021e9:	ff 45 fc             	incl   -0x4(%ebp)
  8021ec:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8021ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	75 c9                	jne    8021c5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802209:	8b 55 08             	mov    0x8(%ebp),%edx
  80220c:	8b 45 10             	mov    0x10(%ebp),%eax
  80220f:	01 d0                	add    %edx,%eax
  802211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802214:	eb 15                	jmp    80222b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8a 00                	mov    (%eax),%al
  80221b:	0f b6 d0             	movzbl %al,%edx
  80221e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802221:	0f b6 c0             	movzbl %al,%eax
  802224:	39 c2                	cmp    %eax,%edx
  802226:	74 0d                	je     802235 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802228:	ff 45 08             	incl   0x8(%ebp)
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802231:	72 e3                	jb     802216 <memfind+0x13>
  802233:	eb 01                	jmp    802236 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802235:	90                   	nop
	return (void *) s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802248:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80224f:	eb 03                	jmp    802254 <strtol+0x19>
		s++;
  802251:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8a 00                	mov    (%eax),%al
  802259:	3c 20                	cmp    $0x20,%al
  80225b:	74 f4                	je     802251 <strtol+0x16>
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	8a 00                	mov    (%eax),%al
  802262:	3c 09                	cmp    $0x9,%al
  802264:	74 eb                	je     802251 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	3c 2b                	cmp    $0x2b,%al
  80226d:	75 05                	jne    802274 <strtol+0x39>
		s++;
  80226f:	ff 45 08             	incl   0x8(%ebp)
  802272:	eb 13                	jmp    802287 <strtol+0x4c>
	else if (*s == '-')
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8a 00                	mov    (%eax),%al
  802279:	3c 2d                	cmp    $0x2d,%al
  80227b:	75 0a                	jne    802287 <strtol+0x4c>
		s++, neg = 1;
  80227d:	ff 45 08             	incl   0x8(%ebp)
  802280:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80228b:	74 06                	je     802293 <strtol+0x58>
  80228d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802291:	75 20                	jne    8022b3 <strtol+0x78>
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	8a 00                	mov    (%eax),%al
  802298:	3c 30                	cmp    $0x30,%al
  80229a:	75 17                	jne    8022b3 <strtol+0x78>
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	40                   	inc    %eax
  8022a0:	8a 00                	mov    (%eax),%al
  8022a2:	3c 78                	cmp    $0x78,%al
  8022a4:	75 0d                	jne    8022b3 <strtol+0x78>
		s += 2, base = 16;
  8022a6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022aa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8022b1:	eb 28                	jmp    8022db <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8022b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b7:	75 15                	jne    8022ce <strtol+0x93>
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	8a 00                	mov    (%eax),%al
  8022be:	3c 30                	cmp    $0x30,%al
  8022c0:	75 0c                	jne    8022ce <strtol+0x93>
		s++, base = 8;
  8022c2:	ff 45 08             	incl   0x8(%ebp)
  8022c5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022cc:	eb 0d                	jmp    8022db <strtol+0xa0>
	else if (base == 0)
  8022ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d2:	75 07                	jne    8022db <strtol+0xa0>
		base = 10;
  8022d4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	8a 00                	mov    (%eax),%al
  8022e0:	3c 2f                	cmp    $0x2f,%al
  8022e2:	7e 19                	jle    8022fd <strtol+0xc2>
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	8a 00                	mov    (%eax),%al
  8022e9:	3c 39                	cmp    $0x39,%al
  8022eb:	7f 10                	jg     8022fd <strtol+0xc2>
			dig = *s - '0';
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	8a 00                	mov    (%eax),%al
  8022f2:	0f be c0             	movsbl %al,%eax
  8022f5:	83 e8 30             	sub    $0x30,%eax
  8022f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fb:	eb 42                	jmp    80233f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8a 00                	mov    (%eax),%al
  802302:	3c 60                	cmp    $0x60,%al
  802304:	7e 19                	jle    80231f <strtol+0xe4>
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	8a 00                	mov    (%eax),%al
  80230b:	3c 7a                	cmp    $0x7a,%al
  80230d:	7f 10                	jg     80231f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	8a 00                	mov    (%eax),%al
  802314:	0f be c0             	movsbl %al,%eax
  802317:	83 e8 57             	sub    $0x57,%eax
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231d:	eb 20                	jmp    80233f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	8a 00                	mov    (%eax),%al
  802324:	3c 40                	cmp    $0x40,%al
  802326:	7e 39                	jle    802361 <strtol+0x126>
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8a 00                	mov    (%eax),%al
  80232d:	3c 5a                	cmp    $0x5a,%al
  80232f:	7f 30                	jg     802361 <strtol+0x126>
			dig = *s - 'A' + 10;
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8a 00                	mov    (%eax),%al
  802336:	0f be c0             	movsbl %al,%eax
  802339:	83 e8 37             	sub    $0x37,%eax
  80233c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	3b 45 10             	cmp    0x10(%ebp),%eax
  802345:	7d 19                	jge    802360 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802347:	ff 45 08             	incl   0x8(%ebp)
  80234a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80234d:	0f af 45 10          	imul   0x10(%ebp),%eax
  802351:	89 c2                	mov    %eax,%edx
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	01 d0                	add    %edx,%eax
  802358:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80235b:	e9 7b ff ff ff       	jmp    8022db <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802360:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802361:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802365:	74 08                	je     80236f <strtol+0x134>
		*endptr = (char *) s;
  802367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236a:	8b 55 08             	mov    0x8(%ebp),%edx
  80236d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80236f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802373:	74 07                	je     80237c <strtol+0x141>
  802375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802378:	f7 d8                	neg    %eax
  80237a:	eb 03                	jmp    80237f <strtol+0x144>
  80237c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <ltostr>:

void
ltostr(long value, char *str)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802387:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80238e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802399:	79 13                	jns    8023ae <ltostr+0x2d>
	{
		neg = 1;
  80239b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8023a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023a8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023ab:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023b6:	99                   	cltd   
  8023b7:	f7 f9                	idiv   %ecx
  8023b9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023bf:	8d 50 01             	lea    0x1(%eax),%edx
  8023c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023c5:	89 c2                	mov    %eax,%edx
  8023c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ca:	01 d0                	add    %edx,%eax
  8023cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023cf:	83 c2 30             	add    $0x30,%edx
  8023d2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023dc:	f7 e9                	imul   %ecx
  8023de:	c1 fa 02             	sar    $0x2,%edx
  8023e1:	89 c8                	mov    %ecx,%eax
  8023e3:	c1 f8 1f             	sar    $0x1f,%eax
  8023e6:	29 c2                	sub    %eax,%edx
  8023e8:	89 d0                	mov    %edx,%eax
  8023ea:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8023ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f1:	75 bb                	jne    8023ae <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8023f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8023fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023fd:	48                   	dec    %eax
  8023fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802401:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802405:	74 3d                	je     802444 <ltostr+0xc3>
		start = 1 ;
  802407:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80240e:	eb 34                	jmp    802444 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802413:	8b 45 0c             	mov    0xc(%ebp),%eax
  802416:	01 d0                	add    %edx,%eax
  802418:	8a 00                	mov    (%eax),%al
  80241a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80241d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802420:	8b 45 0c             	mov    0xc(%ebp),%eax
  802423:	01 c2                	add    %eax,%edx
  802425:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242b:	01 c8                	add    %ecx,%eax
  80242d:	8a 00                	mov    (%eax),%al
  80242f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802431:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802434:	8b 45 0c             	mov    0xc(%ebp),%eax
  802437:	01 c2                	add    %eax,%edx
  802439:	8a 45 eb             	mov    -0x15(%ebp),%al
  80243c:	88 02                	mov    %al,(%edx)
		start++ ;
  80243e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802441:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80244a:	7c c4                	jl     802410 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80244c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80244f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802452:	01 d0                	add    %edx,%eax
  802454:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802457:	90                   	nop
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802460:	ff 75 08             	pushl  0x8(%ebp)
  802463:	e8 c4 f9 ff ff       	call   801e2c <strlen>
  802468:	83 c4 04             	add    $0x4,%esp
  80246b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80246e:	ff 75 0c             	pushl  0xc(%ebp)
  802471:	e8 b6 f9 ff ff       	call   801e2c <strlen>
  802476:	83 c4 04             	add    $0x4,%esp
  802479:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80247c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80248a:	eb 17                	jmp    8024a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80248c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80248f:	8b 45 10             	mov    0x10(%ebp),%eax
  802492:	01 c2                	add    %eax,%edx
  802494:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	01 c8                	add    %ecx,%eax
  80249c:	8a 00                	mov    (%eax),%al
  80249e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024a0:	ff 45 fc             	incl   -0x4(%ebp)
  8024a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024a9:	7c e1                	jl     80248c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024b9:	eb 1f                	jmp    8024da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024be:	8d 50 01             	lea    0x1(%eax),%edx
  8024c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024c4:	89 c2                	mov    %eax,%edx
  8024c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c9:	01 c2                	add    %eax,%edx
  8024cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d1:	01 c8                	add    %ecx,%eax
  8024d3:	8a 00                	mov    (%eax),%al
  8024d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024d7:	ff 45 f8             	incl   -0x8(%ebp)
  8024da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e0:	7c d9                	jl     8024bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8024e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e8:	01 d0                	add    %edx,%eax
  8024ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8024ed:	90                   	nop
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8024f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8024fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802508:	8b 45 10             	mov    0x10(%ebp),%eax
  80250b:	01 d0                	add    %edx,%eax
  80250d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802513:	eb 0c                	jmp    802521 <strsplit+0x31>
			*string++ = 0;
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	8d 50 01             	lea    0x1(%eax),%edx
  80251b:	89 55 08             	mov    %edx,0x8(%ebp)
  80251e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	8a 00                	mov    (%eax),%al
  802526:	84 c0                	test   %al,%al
  802528:	74 18                	je     802542 <strsplit+0x52>
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	8a 00                	mov    (%eax),%al
  80252f:	0f be c0             	movsbl %al,%eax
  802532:	50                   	push   %eax
  802533:	ff 75 0c             	pushl  0xc(%ebp)
  802536:	e8 83 fa ff ff       	call   801fbe <strchr>
  80253b:	83 c4 08             	add    $0x8,%esp
  80253e:	85 c0                	test   %eax,%eax
  802540:	75 d3                	jne    802515 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	8a 00                	mov    (%eax),%al
  802547:	84 c0                	test   %al,%al
  802549:	74 5a                	je     8025a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80254b:	8b 45 14             	mov    0x14(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	83 f8 0f             	cmp    $0xf,%eax
  802553:	75 07                	jne    80255c <strsplit+0x6c>
		{
			return 0;
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
  80255a:	eb 66                	jmp    8025c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80255c:	8b 45 14             	mov    0x14(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	8d 48 01             	lea    0x1(%eax),%ecx
  802564:	8b 55 14             	mov    0x14(%ebp),%edx
  802567:	89 0a                	mov    %ecx,(%edx)
  802569:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802570:	8b 45 10             	mov    0x10(%ebp),%eax
  802573:	01 c2                	add    %eax,%edx
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80257a:	eb 03                	jmp    80257f <strsplit+0x8f>
			string++;
  80257c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	8a 00                	mov    (%eax),%al
  802584:	84 c0                	test   %al,%al
  802586:	74 8b                	je     802513 <strsplit+0x23>
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8a 00                	mov    (%eax),%al
  80258d:	0f be c0             	movsbl %al,%eax
  802590:	50                   	push   %eax
  802591:	ff 75 0c             	pushl  0xc(%ebp)
  802594:	e8 25 fa ff ff       	call   801fbe <strchr>
  802599:	83 c4 08             	add    $0x8,%esp
  80259c:	85 c0                	test   %eax,%eax
  80259e:	74 dc                	je     80257c <strsplit+0x8c>
			string++;
	}
  8025a0:	e9 6e ff ff ff       	jmp    802513 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b5:	01 d0                	add    %edx,%eax
  8025b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8025d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025d7:	eb 4a                	jmp    802623 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8025d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	01 c2                	add    %eax,%edx
  8025e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e7:	01 c8                	add    %ecx,%eax
  8025e9:	8a 00                	mov    (%eax),%al
  8025eb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8025ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f3:	01 d0                	add    %edx,%eax
  8025f5:	8a 00                	mov    (%eax),%al
  8025f7:	3c 40                	cmp    $0x40,%al
  8025f9:	7e 25                	jle    802620 <str2lower+0x5c>
  8025fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802601:	01 d0                	add    %edx,%eax
  802603:	8a 00                	mov    (%eax),%al
  802605:	3c 5a                	cmp    $0x5a,%al
  802607:	7f 17                	jg     802620 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802609:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	01 d0                	add    %edx,%eax
  802611:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802614:	8b 55 08             	mov    0x8(%ebp),%edx
  802617:	01 ca                	add    %ecx,%edx
  802619:	8a 12                	mov    (%edx),%dl
  80261b:	83 c2 20             	add    $0x20,%edx
  80261e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802620:	ff 45 fc             	incl   -0x4(%ebp)
  802623:	ff 75 0c             	pushl  0xc(%ebp)
  802626:	e8 01 f8 ff ff       	call   801e2c <strlen>
  80262b:	83 c4 04             	add    $0x4,%esp
  80262e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802631:	7f a6                	jg     8025d9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80263e:	83 ec 0c             	sub    $0xc,%esp
  802641:	6a 10                	push   $0x10
  802643:	e8 b2 15 00 00       	call   803bfa <alloc_block>
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80264e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802652:	75 14                	jne    802668 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 e8 53 80 00       	push   $0x8053e8
  80265c:	6a 14                	push   $0x14
  80265e:	68 11 54 80 00       	push   $0x805411
  802663:	e8 fd ed ff ff       	call   801465 <_panic>

	node->start = start;
  802668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266b:	8b 55 08             	mov    0x8(%ebp),%edx
  80266e:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  802670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802673:	8b 55 0c             	mov    0xc(%ebp),%edx
  802676:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802679:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  802680:	a1 04 62 80 00       	mov    0x806204,%eax
  802685:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802688:	eb 18                	jmp    8026a2 <insert_page_alloc+0x6a>
		if (start < it->start)
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802692:	77 37                	ja     8026cb <insert_page_alloc+0x93>
			break;
		prev = it;
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80269a:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a6:	74 08                	je     8026b0 <insert_page_alloc+0x78>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 08             	mov    0x8(%eax),%eax
  8026ae:	eb 05                	jmp    8026b5 <insert_page_alloc+0x7d>
  8026b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b5:	a3 0c 62 80 00       	mov    %eax,0x80620c
  8026ba:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	75 c7                	jne    80268a <insert_page_alloc+0x52>
  8026c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c7:	75 c1                	jne    80268a <insert_page_alloc+0x52>
  8026c9:	eb 01                	jmp    8026cc <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8026cb:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8026cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d0:	75 64                	jne    802736 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8026d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026d6:	75 14                	jne    8026ec <insert_page_alloc+0xb4>
  8026d8:	83 ec 04             	sub    $0x4,%esp
  8026db:	68 20 54 80 00       	push   $0x805420
  8026e0:	6a 21                	push   $0x21
  8026e2:	68 11 54 80 00       	push   $0x805411
  8026e7:	e8 79 ed ff ff       	call   801465 <_panic>
  8026ec:	8b 15 04 62 80 00    	mov    0x806204,%edx
  8026f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f5:	89 50 08             	mov    %edx,0x8(%eax)
  8026f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fb:	8b 40 08             	mov    0x8(%eax),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 0d                	je     80270f <insert_page_alloc+0xd7>
  802702:	a1 04 62 80 00       	mov    0x806204,%eax
  802707:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80270a:	89 50 0c             	mov    %edx,0xc(%eax)
  80270d:	eb 08                	jmp    802717 <insert_page_alloc+0xdf>
  80270f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802712:	a3 08 62 80 00       	mov    %eax,0x806208
  802717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271a:	a3 04 62 80 00       	mov    %eax,0x806204
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802729:	a1 10 62 80 00       	mov    0x806210,%eax
  80272e:	40                   	inc    %eax
  80272f:	a3 10 62 80 00       	mov    %eax,0x806210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  802734:	eb 71                	jmp    8027a7 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80273a:	74 06                	je     802742 <insert_page_alloc+0x10a>
  80273c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802740:	75 14                	jne    802756 <insert_page_alloc+0x11e>
  802742:	83 ec 04             	sub    $0x4,%esp
  802745:	68 44 54 80 00       	push   $0x805444
  80274a:	6a 23                	push   $0x23
  80274c:	68 11 54 80 00       	push   $0x805411
  802751:	e8 0f ed ff ff       	call   801465 <_panic>
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 50 08             	mov    0x8(%eax),%edx
  80275c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275f:	89 50 08             	mov    %edx,0x8(%eax)
  802762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802765:	8b 40 08             	mov    0x8(%eax),%eax
  802768:	85 c0                	test   %eax,%eax
  80276a:	74 0c                	je     802778 <insert_page_alloc+0x140>
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	8b 40 08             	mov    0x8(%eax),%eax
  802772:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802775:	89 50 0c             	mov    %edx,0xc(%eax)
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277e:	89 50 08             	mov    %edx,0x8(%eax)
  802781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802784:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802787:	89 50 0c             	mov    %edx,0xc(%eax)
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	8b 40 08             	mov    0x8(%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	75 08                	jne    80279c <insert_page_alloc+0x164>
  802794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802797:	a3 08 62 80 00       	mov    %eax,0x806208
  80279c:	a1 10 62 80 00       	mov    0x806210,%eax
  8027a1:	40                   	inc    %eax
  8027a2:	a3 10 62 80 00       	mov    %eax,0x806210
}
  8027a7:	90                   	nop
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8027b0:	a1 04 62 80 00       	mov    0x806204,%eax
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	75 0c                	jne    8027c5 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8027b9:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8027be:	a3 50 e2 81 00       	mov    %eax,0x81e250
		return;
  8027c3:	eb 67                	jmp    80282c <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8027c5:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8027ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8027cd:	a1 04 62 80 00       	mov    0x806204,%eax
  8027d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8027d5:	eb 26                	jmp    8027fd <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8027d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027da:	8b 10                	mov    (%eax),%edx
  8027dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	01 d0                	add    %edx,%eax
  8027e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8027ed:	76 06                	jbe    8027f5 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8027f5:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8027fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8027fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802801:	74 08                	je     80280b <recompute_page_alloc_break+0x61>
  802803:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802806:	8b 40 08             	mov    0x8(%eax),%eax
  802809:	eb 05                	jmp    802810 <recompute_page_alloc_break+0x66>
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
  802810:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802815:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	75 b9                	jne    8027d7 <recompute_page_alloc_break+0x2d>
  80281e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802822:	75 b3                	jne    8027d7 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  802824:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802827:	a3 50 e2 81 00       	mov    %eax,0x81e250
}
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  802834:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80283b:	8b 55 08             	mov    0x8(%ebp),%edx
  80283e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802841:	01 d0                	add    %edx,%eax
  802843:	48                   	dec    %eax
  802844:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802847:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80284a:	ba 00 00 00 00       	mov    $0x0,%edx
  80284f:	f7 75 d8             	divl   -0x28(%ebp)
  802852:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802855:	29 d0                	sub    %edx,%eax
  802857:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80285a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80285e:	75 0a                	jne    80286a <alloc_pages_custom_fit+0x3c>
		return NULL;
  802860:	b8 00 00 00 00       	mov    $0x0,%eax
  802865:	e9 7e 01 00 00       	jmp    8029e8 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80286a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  802871:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802875:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  80287c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  802883:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802888:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80288b:	a1 04 62 80 00       	mov    0x806204,%eax
  802890:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802893:	eb 69                	jmp    8028fe <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  802895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80289d:	76 47                	jbe    8028e6 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80289f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8028a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8028ad:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8028b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028b3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8028b6:	72 2e                	jb     8028e6 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8028b8:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8028bc:	75 14                	jne    8028d2 <alloc_pages_custom_fit+0xa4>
  8028be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028c1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8028c4:	75 0c                	jne    8028d2 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8028c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8028cc:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8028d0:	eb 14                	jmp    8028e6 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8028d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028d5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028d8:	76 0c                	jbe    8028e6 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8028da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8028e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8028e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e9:	8b 10                	mov    (%eax),%edx
  8028eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8028f6:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8028fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8028fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802902:	74 08                	je     80290c <alloc_pages_custom_fit+0xde>
  802904:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802907:	8b 40 08             	mov    0x8(%eax),%eax
  80290a:	eb 05                	jmp    802911 <alloc_pages_custom_fit+0xe3>
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
  802911:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802916:	a1 0c 62 80 00       	mov    0x80620c,%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	0f 85 72 ff ff ff    	jne    802895 <alloc_pages_custom_fit+0x67>
  802923:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802927:	0f 85 68 ff ff ff    	jne    802895 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  80292d:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802932:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802935:	76 47                	jbe    80297e <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  80293d:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802942:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802945:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802948:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80294b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80294e:	72 2e                	jb     80297e <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802950:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802954:	75 14                	jne    80296a <alloc_pages_custom_fit+0x13c>
  802956:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802959:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80295c:	75 0c                	jne    80296a <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  80295e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802961:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802964:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802968:	eb 14                	jmp    80297e <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  80296a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80296d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802970:	76 0c                	jbe    80297e <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802972:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802975:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802978:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80297b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  80297e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802985:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802989:	74 08                	je     802993 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802991:	eb 40                	jmp    8029d3 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802993:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802997:	74 08                	je     8029a1 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80299f:	eb 32                	jmp    8029d3 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8029a1:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8029a6:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8029a9:	89 c2                	mov    %eax,%edx
  8029ab:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8029b0:	39 c2                	cmp    %eax,%edx
  8029b2:	73 07                	jae    8029bb <alloc_pages_custom_fit+0x18d>
			return NULL;
  8029b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b9:	eb 2d                	jmp    8029e8 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8029bb:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8029c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8029c3:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8029c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029cc:	01 d0                	add    %edx,%eax
  8029ce:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}


	insert_page_alloc((uint32)result, required_size);
  8029d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029d6:	83 ec 08             	sub    $0x8,%esp
  8029d9:	ff 75 d0             	pushl  -0x30(%ebp)
  8029dc:	50                   	push   %eax
  8029dd:	e8 56 fc ff ff       	call   802638 <insert_page_alloc>
  8029e2:	83 c4 10             	add    $0x10,%esp

	return result;
  8029e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8029e8:	c9                   	leave  
  8029e9:	c3                   	ret    

008029ea <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
  8029ed:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8029f6:	a1 04 62 80 00       	mov    0x806204,%eax
  8029fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029fe:	eb 1a                	jmp    802a1a <find_allocated_size+0x30>
		if (it->start == va)
  802a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802a08:	75 08                	jne    802a12 <find_allocated_size+0x28>
			return it->size;
  802a0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	eb 34                	jmp    802a46 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802a12:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802a17:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a1e:	74 08                	je     802a28 <find_allocated_size+0x3e>
  802a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	eb 05                	jmp    802a2d <find_allocated_size+0x43>
  802a28:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2d:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802a32:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	75 c5                	jne    802a00 <find_allocated_size+0x16>
  802a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a3f:	75 bf                	jne    802a00 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a46:	c9                   	leave  
  802a47:	c3                   	ret    

00802a48 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802a54:	a1 04 62 80 00       	mov    0x806204,%eax
  802a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5c:	e9 e1 01 00 00       	jmp    802c42 <free_pages+0x1fa>
		if (it->start == va) {
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a69:	0f 85 cb 01 00 00    	jne    802c3a <free_pages+0x1f2>

			uint32 start = it->start;
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a83:	f7 d0                	not    %eax
  802a85:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a88:	73 1d                	jae    802aa7 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802a8a:	83 ec 0c             	sub    $0xc,%esp
  802a8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a90:	ff 75 e8             	pushl  -0x18(%ebp)
  802a93:	68 78 54 80 00       	push   $0x805478
  802a98:	68 a5 00 00 00       	push   $0xa5
  802a9d:	68 11 54 80 00       	push   $0x805411
  802aa2:	e8 be e9 ff ff       	call   801465 <_panic>
			}

			uint32 start_end = start + size;
  802aa7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	79 19                	jns    802ad2 <free_pages+0x8a>
  802ab9:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802ac0:	77 10                	ja     802ad2 <free_pages+0x8a>
  802ac2:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802ac9:	77 07                	ja     802ad2 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	78 2c                	js     802afe <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad5:	83 ec 0c             	sub    $0xc,%esp
  802ad8:	68 00 00 00 a0       	push   $0xa0000000
  802add:	ff 75 e0             	pushl  -0x20(%ebp)
  802ae0:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  802ae6:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ae9:	50                   	push   %eax
  802aea:	68 bc 54 80 00       	push   $0x8054bc
  802aef:	68 ad 00 00 00       	push   $0xad
  802af4:	68 11 54 80 00       	push   $0x805411
  802af9:	e8 67 e9 ff ff       	call   801465 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b04:	e9 88 00 00 00       	jmp    802b91 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802b09:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802b10:	76 17                	jbe    802b29 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802b12:	ff 75 f0             	pushl  -0x10(%ebp)
  802b15:	68 20 55 80 00       	push   $0x805520
  802b1a:	68 b4 00 00 00       	push   $0xb4
  802b1f:	68 11 54 80 00       	push   $0x805411
  802b24:	e8 3c e9 ff ff       	call   801465 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	05 00 10 00 00       	add    $0x1000,%eax
  802b31:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	79 2e                	jns    802b69 <free_pages+0x121>
  802b3b:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802b42:	77 25                	ja     802b69 <free_pages+0x121>
  802b44:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802b4b:	77 1c                	ja     802b69 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802b4d:	83 ec 08             	sub    $0x8,%esp
  802b50:	68 00 10 00 00       	push   $0x1000
  802b55:	ff 75 f0             	pushl  -0x10(%ebp)
  802b58:	e8 38 0d 00 00       	call   803895 <sys_free_user_mem>
  802b5d:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802b60:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802b67:	eb 28                	jmp    802b91 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	68 00 00 00 a0       	push   $0xa0000000
  802b71:	ff 75 dc             	pushl  -0x24(%ebp)
  802b74:	68 00 10 00 00       	push   $0x1000
  802b79:	ff 75 f0             	pushl  -0x10(%ebp)
  802b7c:	50                   	push   %eax
  802b7d:	68 60 55 80 00       	push   $0x805560
  802b82:	68 bd 00 00 00       	push   $0xbd
  802b87:	68 11 54 80 00       	push   $0x805411
  802b8c:	e8 d4 e8 ff ff       	call   801465 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b94:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b97:	0f 82 6c ff ff ff    	jb     802b09 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba1:	75 17                	jne    802bba <free_pages+0x172>
  802ba3:	83 ec 04             	sub    $0x4,%esp
  802ba6:	68 c2 55 80 00       	push   $0x8055c2
  802bab:	68 c1 00 00 00       	push   $0xc1
  802bb0:	68 11 54 80 00       	push   $0x805411
  802bb5:	e8 ab e8 ff ff       	call   801465 <_panic>
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 08             	mov    0x8(%eax),%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	74 11                	je     802bd5 <free_pages+0x18d>
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 08             	mov    0x8(%eax),%eax
  802bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcd:	8b 52 0c             	mov    0xc(%edx),%edx
  802bd0:	89 50 0c             	mov    %edx,0xc(%eax)
  802bd3:	eb 0b                	jmp    802be0 <free_pages+0x198>
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdb:	a3 08 62 80 00       	mov    %eax,0x806208
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 40 0c             	mov    0xc(%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 11                	je     802bfb <free_pages+0x1b3>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf3:	8b 52 08             	mov    0x8(%edx),%edx
  802bf6:	89 50 08             	mov    %edx,0x8(%eax)
  802bf9:	eb 0b                	jmp    802c06 <free_pages+0x1be>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	a3 04 62 80 00       	mov    %eax,0x806204
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c1a:	a1 10 62 80 00       	mov    0x806210,%eax
  802c1f:	48                   	dec    %eax
  802c20:	a3 10 62 80 00       	mov    %eax,0x806210
			free_block(it);
  802c25:	83 ec 0c             	sub    $0xc,%esp
  802c28:	ff 75 f4             	pushl  -0xc(%ebp)
  802c2b:	e8 24 15 00 00       	call   804154 <free_block>
  802c30:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802c33:	e8 72 fb ff ff       	call   8027aa <recompute_page_alloc_break>

			return;
  802c38:	eb 37                	jmp    802c71 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802c3a:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c46:	74 08                	je     802c50 <free_pages+0x208>
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 08             	mov    0x8(%eax),%eax
  802c4e:	eb 05                	jmp    802c55 <free_pages+0x20d>
  802c50:	b8 00 00 00 00       	mov    $0x0,%eax
  802c55:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802c5a:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	0f 85 fa fd ff ff    	jne    802a61 <free_pages+0x19>
  802c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6b:	0f 85 f0 fd ff ff    	jne    802a61 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802c71:	c9                   	leave  
  802c72:	c3                   	ret    

00802c73 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c7b:	5d                   	pop    %ebp
  802c7c:	c3                   	ret    

00802c7d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802c7d:	55                   	push   %ebp
  802c7e:	89 e5                	mov    %esp,%ebp
  802c80:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802c83:	a1 08 60 80 00       	mov    0x806008,%eax
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	74 60                	je     802cec <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802c8c:	83 ec 08             	sub    $0x8,%esp
  802c8f:	68 00 00 00 82       	push   $0x82000000
  802c94:	68 00 00 00 80       	push   $0x80000000
  802c99:	e8 0d 0d 00 00       	call   8039ab <initialize_dynamic_allocator>
  802c9e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802ca1:	e8 f3 0a 00 00       	call   803799 <sys_get_uheap_strategy>
  802ca6:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802cab:	a1 20 62 80 00       	mov    0x806220,%eax
  802cb0:	05 00 10 00 00       	add    $0x1000,%eax
  802cb5:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802cba:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802cbf:	a3 50 e2 81 00       	mov    %eax,0x81e250

		LIST_INIT(&page_alloc_list);
  802cc4:	c7 05 04 62 80 00 00 	movl   $0x0,0x806204
  802ccb:	00 00 00 
  802cce:	c7 05 08 62 80 00 00 	movl   $0x0,0x806208
  802cd5:	00 00 00 
  802cd8:	c7 05 10 62 80 00 00 	movl   $0x0,0x806210
  802cdf:	00 00 00 

		__firstTimeFlag = 0;
  802ce2:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802ce9:	00 00 00 
	}
}
  802cec:	90                   	nop
  802ced:	c9                   	leave  
  802cee:	c3                   	ret    

00802cef <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802cef:	55                   	push   %ebp
  802cf0:	89 e5                	mov    %esp,%ebp
  802cf2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d03:	83 ec 08             	sub    $0x8,%esp
  802d06:	68 06 04 00 00       	push   $0x406
  802d0b:	50                   	push   %eax
  802d0c:	e8 d2 06 00 00       	call   8033e3 <__sys_allocate_page>
  802d11:	83 c4 10             	add    $0x10,%esp
  802d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1b:	79 17                	jns    802d34 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802d1d:	83 ec 04             	sub    $0x4,%esp
  802d20:	68 e0 55 80 00       	push   $0x8055e0
  802d25:	68 ea 00 00 00       	push   $0xea
  802d2a:	68 11 54 80 00       	push   $0x805411
  802d2f:	e8 31 e7 ff ff       	call   801465 <_panic>
	return 0;
  802d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d39:	c9                   	leave  
  802d3a:	c3                   	ret    

00802d3b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802d3b:	55                   	push   %ebp
  802d3c:	89 e5                	mov    %esp,%ebp
  802d3e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d4f:	83 ec 0c             	sub    $0xc,%esp
  802d52:	50                   	push   %eax
  802d53:	e8 d2 06 00 00       	call   80342a <__sys_unmap_frame>
  802d58:	83 c4 10             	add    $0x10,%esp
  802d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802d5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d62:	79 17                	jns    802d7b <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 1c 56 80 00       	push   $0x80561c
  802d6c:	68 f5 00 00 00       	push   $0xf5
  802d71:	68 11 54 80 00       	push   $0x805411
  802d76:	e8 ea e6 ff ff       	call   801465 <_panic>
}
  802d7b:	90                   	nop
  802d7c:	c9                   	leave  
  802d7d:	c3                   	ret    

00802d7e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802d7e:	55                   	push   %ebp
  802d7f:	89 e5                	mov    %esp,%ebp
  802d81:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d84:	e8 f4 fe ff ff       	call   802c7d <uheap_init>
	if (size == 0) return NULL ;
  802d89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8d:	75 0a                	jne    802d99 <malloc+0x1b>
  802d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d94:	e9 67 01 00 00       	jmp    802f00 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802d99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802da0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802da7:	77 16                	ja     802dbf <malloc+0x41>
		result = alloc_block(size);
  802da9:	83 ec 0c             	sub    $0xc,%esp
  802dac:	ff 75 08             	pushl  0x8(%ebp)
  802daf:	e8 46 0e 00 00       	call   803bfa <alloc_block>
  802db4:	83 c4 10             	add    $0x10,%esp
  802db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dba:	e9 3e 01 00 00       	jmp    802efd <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802dbf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcc:	01 d0                	add    %edx,%eax
  802dce:	48                   	dec    %eax
  802dcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802dda:	f7 75 f0             	divl   -0x10(%ebp)
  802ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de0:	29 d0                	sub    %edx,%eax
  802de2:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802de5:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	75 0a                	jne    802df8 <malloc+0x7a>
			return NULL;
  802dee:	b8 00 00 00 00       	mov    $0x0,%eax
  802df3:	e9 08 01 00 00       	jmp    802f00 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802df8:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0f                	je     802e10 <malloc+0x92>
  802e01:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802e07:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802e0c:	39 c2                	cmp    %eax,%edx
  802e0e:	73 0a                	jae    802e1a <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802e10:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802e15:	a3 50 e2 81 00       	mov    %eax,0x81e250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802e1a:	a1 44 e2 81 00       	mov    0x81e244,%eax
  802e1f:	83 f8 05             	cmp    $0x5,%eax
  802e22:	75 11                	jne    802e35 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802e24:	83 ec 0c             	sub    $0xc,%esp
  802e27:	ff 75 e8             	pushl  -0x18(%ebp)
  802e2a:	e8 ff f9 ff ff       	call   80282e <alloc_pages_custom_fit>
  802e2f:	83 c4 10             	add    $0x10,%esp
  802e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e39:	0f 84 be 00 00 00    	je     802efd <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802e45:	83 ec 0c             	sub    $0xc,%esp
  802e48:	ff 75 f4             	pushl  -0xc(%ebp)
  802e4b:	e8 9a fb ff ff       	call   8029ea <find_allocated_size>
  802e50:	83 c4 10             	add    $0x10,%esp
  802e53:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802e56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e5a:	75 17                	jne    802e73 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802e5c:	ff 75 f4             	pushl  -0xc(%ebp)
  802e5f:	68 5c 56 80 00       	push   $0x80565c
  802e64:	68 24 01 00 00       	push   $0x124
  802e69:	68 11 54 80 00       	push   $0x805411
  802e6e:	e8 f2 e5 ff ff       	call   801465 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802e73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e76:	f7 d0                	not    %eax
  802e78:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e7b:	73 1d                	jae    802e9a <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802e7d:	83 ec 0c             	sub    $0xc,%esp
  802e80:	ff 75 e0             	pushl  -0x20(%ebp)
  802e83:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e86:	68 a4 56 80 00       	push   $0x8056a4
  802e8b:	68 29 01 00 00       	push   $0x129
  802e90:	68 11 54 80 00       	push   $0x805411
  802e95:	e8 cb e5 ff ff       	call   801465 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802e9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea0:	01 d0                	add    %edx,%eax
  802ea2:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	79 2c                	jns    802ed8 <malloc+0x15a>
  802eac:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802eb3:	77 23                	ja     802ed8 <malloc+0x15a>
  802eb5:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802ebc:	77 1a                	ja     802ed8 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802ebe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	79 13                	jns    802ed8 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802ec5:	83 ec 08             	sub    $0x8,%esp
  802ec8:	ff 75 e0             	pushl  -0x20(%ebp)
  802ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ece:	e8 de 09 00 00       	call   8038b1 <sys_allocate_user_mem>
  802ed3:	83 c4 10             	add    $0x10,%esp
  802ed6:	eb 25                	jmp    802efd <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802ed8:	68 00 00 00 a0       	push   $0xa0000000
  802edd:	ff 75 dc             	pushl  -0x24(%ebp)
  802ee0:	ff 75 e0             	pushl  -0x20(%ebp)
  802ee3:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee9:	68 e0 56 80 00       	push   $0x8056e0
  802eee:	68 33 01 00 00       	push   $0x133
  802ef3:	68 11 54 80 00       	push   $0x805411
  802ef8:	e8 68 e5 ff ff       	call   801465 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802f00:	c9                   	leave  
  802f01:	c3                   	ret    

00802f02 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802f02:	55                   	push   %ebp
  802f03:	89 e5                	mov    %esp,%ebp
  802f05:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802f08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0c:	0f 84 26 01 00 00    	je     803038 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	79 1c                	jns    802f3b <free+0x39>
  802f1f:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802f26:	77 13                	ja     802f3b <free+0x39>
		free_block(virtual_address);
  802f28:	83 ec 0c             	sub    $0xc,%esp
  802f2b:	ff 75 08             	pushl  0x8(%ebp)
  802f2e:	e8 21 12 00 00       	call   804154 <free_block>
  802f33:	83 c4 10             	add    $0x10,%esp
		return;
  802f36:	e9 01 01 00 00       	jmp    80303c <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802f3b:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802f40:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802f43:	0f 82 d8 00 00 00    	jb     803021 <free+0x11f>
  802f49:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802f50:	0f 87 cb 00 00 00    	ja     803021 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	25 ff 0f 00 00       	and    $0xfff,%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 17                	je     802f79 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802f62:	ff 75 08             	pushl  0x8(%ebp)
  802f65:	68 50 57 80 00       	push   $0x805750
  802f6a:	68 57 01 00 00       	push   $0x157
  802f6f:	68 11 54 80 00       	push   $0x805411
  802f74:	e8 ec e4 ff ff       	call   801465 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802f79:	83 ec 0c             	sub    $0xc,%esp
  802f7c:	ff 75 08             	pushl  0x8(%ebp)
  802f7f:	e8 66 fa ff ff       	call   8029ea <find_allocated_size>
  802f84:	83 c4 10             	add    $0x10,%esp
  802f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802f8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f8e:	0f 84 a7 00 00 00    	je     80303b <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	f7 d0                	not    %eax
  802f99:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f9c:	73 1d                	jae    802fbb <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802f9e:	83 ec 0c             	sub    $0xc,%esp
  802fa1:	ff 75 f0             	pushl  -0x10(%ebp)
  802fa4:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa7:	68 78 57 80 00       	push   $0x805778
  802fac:	68 61 01 00 00       	push   $0x161
  802fb1:	68 11 54 80 00       	push   $0x805411
  802fb6:	e8 aa e4 ff ff       	call   801465 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802fbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	01 d0                	add    %edx,%eax
  802fc3:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	79 19                	jns    802fe6 <free+0xe4>
  802fcd:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802fd4:	77 10                	ja     802fe6 <free+0xe4>
  802fd6:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802fdd:	77 07                	ja     802fe6 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	78 2b                	js     803011 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802fe6:	83 ec 0c             	sub    $0xc,%esp
  802fe9:	68 00 00 00 a0       	push   $0xa0000000
  802fee:	ff 75 ec             	pushl  -0x14(%ebp)
  802ff1:	ff 75 f0             	pushl  -0x10(%ebp)
  802ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  802ff7:	ff 75 f0             	pushl  -0x10(%ebp)
  802ffa:	ff 75 08             	pushl  0x8(%ebp)
  802ffd:	68 b4 57 80 00       	push   $0x8057b4
  803002:	68 69 01 00 00       	push   $0x169
  803007:	68 11 54 80 00       	push   $0x805411
  80300c:	e8 54 e4 ff ff       	call   801465 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  803011:	83 ec 0c             	sub    $0xc,%esp
  803014:	ff 75 08             	pushl  0x8(%ebp)
  803017:	e8 2c fa ff ff       	call   802a48 <free_pages>
  80301c:	83 c4 10             	add    $0x10,%esp
		return;
  80301f:	eb 1b                	jmp    80303c <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  803021:	ff 75 08             	pushl  0x8(%ebp)
  803024:	68 10 58 80 00       	push   $0x805810
  803029:	68 70 01 00 00       	push   $0x170
  80302e:	68 11 54 80 00       	push   $0x805411
  803033:	e8 2d e4 ff ff       	call   801465 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803038:	90                   	nop
  803039:	eb 01                	jmp    80303c <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80303b:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  80303c:	c9                   	leave  
  80303d:	c3                   	ret    

0080303e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80303e:	55                   	push   %ebp
  80303f:	89 e5                	mov    %esp,%ebp
  803041:	83 ec 38             	sub    $0x38,%esp
  803044:	8b 45 10             	mov    0x10(%ebp),%eax
  803047:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80304a:	e8 2e fc ff ff       	call   802c7d <uheap_init>
	if (size == 0) return NULL ;
  80304f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803053:	75 0a                	jne    80305f <smalloc+0x21>
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
  80305a:	e9 3d 01 00 00       	jmp    80319c <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80305f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803062:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  803065:	8b 45 0c             	mov    0xc(%ebp),%eax
  803068:	25 ff 0f 00 00       	and    $0xfff,%eax
  80306d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  803070:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803074:	74 0e                	je     803084 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80307c:	05 00 10 00 00       	add    $0x1000,%eax
  803081:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	c1 e8 0c             	shr    $0xc,%eax
  80308a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  80308d:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	75 0a                	jne    8030a0 <smalloc+0x62>
		return NULL;
  803096:	b8 00 00 00 00       	mov    $0x0,%eax
  80309b:	e9 fc 00 00 00       	jmp    80319c <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8030a0:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 0f                	je     8030b8 <smalloc+0x7a>
  8030a9:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8030af:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030b4:	39 c2                	cmp    %eax,%edx
  8030b6:	73 0a                	jae    8030c2 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8030b8:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030bd:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8030c2:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030c7:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8030cc:	29 c2                	sub    %eax,%edx
  8030ce:	89 d0                	mov    %edx,%eax
  8030d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8030d3:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8030d9:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8030de:	29 c2                	sub    %eax,%edx
  8030e0:	89 d0                	mov    %edx,%eax
  8030e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030eb:	77 13                	ja     803100 <smalloc+0xc2>
  8030ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030f3:	77 0b                	ja     803100 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8030f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f8:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8030fb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030fe:	73 0a                	jae    80310a <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  803100:	b8 00 00 00 00       	mov    $0x0,%eax
  803105:	e9 92 00 00 00       	jmp    80319c <smalloc+0x15e>
	}

	void *va = NULL;
  80310a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  803111:	a1 44 e2 81 00       	mov    0x81e244,%eax
  803116:	83 f8 05             	cmp    $0x5,%eax
  803119:	75 11                	jne    80312c <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80311b:	83 ec 0c             	sub    $0xc,%esp
  80311e:	ff 75 f4             	pushl  -0xc(%ebp)
  803121:	e8 08 f7 ff ff       	call   80282e <alloc_pages_custom_fit>
  803126:	83 c4 10             	add    $0x10,%esp
  803129:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80312c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803130:	75 27                	jne    803159 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803132:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  803139:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80313f:	89 c2                	mov    %eax,%edx
  803141:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803146:	39 c2                	cmp    %eax,%edx
  803148:	73 07                	jae    803151 <smalloc+0x113>
			return NULL;}
  80314a:	b8 00 00 00 00       	mov    $0x0,%eax
  80314f:	eb 4b                	jmp    80319c <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  803151:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803156:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  803159:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80315d:	ff 75 f0             	pushl  -0x10(%ebp)
  803160:	50                   	push   %eax
  803161:	ff 75 0c             	pushl  0xc(%ebp)
  803164:	ff 75 08             	pushl  0x8(%ebp)
  803167:	e8 cb 03 00 00       	call   803537 <sys_create_shared_object>
  80316c:	83 c4 10             	add    $0x10,%esp
  80316f:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  803172:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803176:	79 07                	jns    80317f <smalloc+0x141>
		return NULL;
  803178:	b8 00 00 00 00       	mov    $0x0,%eax
  80317d:	eb 1d                	jmp    80319c <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80317f:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803184:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803187:	75 10                	jne    803199 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  803189:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	01 d0                	add    %edx,%eax
  803194:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}

	return va;
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  80319c:	c9                   	leave  
  80319d:	c3                   	ret    

0080319e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80319e:	55                   	push   %ebp
  80319f:	89 e5                	mov    %esp,%ebp
  8031a1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8031a4:	e8 d4 fa ff ff       	call   802c7d <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8031a9:	83 ec 08             	sub    $0x8,%esp
  8031ac:	ff 75 0c             	pushl  0xc(%ebp)
  8031af:	ff 75 08             	pushl  0x8(%ebp)
  8031b2:	e8 aa 03 00 00       	call   803561 <sys_size_of_shared_object>
  8031b7:	83 c4 10             	add    $0x10,%esp
  8031ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8031bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031c1:	7f 0a                	jg     8031cd <sget+0x2f>
		return NULL;
  8031c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c8:	e9 32 01 00 00       	jmp    8032ff <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8031cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8031d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8031db:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8031de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e2:	74 0e                	je     8031f2 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8031ea:	05 00 10 00 00       	add    $0x1000,%eax
  8031ef:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8031f2:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	75 0a                	jne    803205 <sget+0x67>
		return NULL;
  8031fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803200:	e9 fa 00 00 00       	jmp    8032ff <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  803205:	a1 50 e2 81 00       	mov    0x81e250,%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	74 0f                	je     80321d <sget+0x7f>
  80320e:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  803214:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803219:	39 c2                	cmp    %eax,%edx
  80321b:	73 0a                	jae    803227 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80321d:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803222:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803227:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80322c:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  803231:	29 c2                	sub    %eax,%edx
  803233:	89 d0                	mov    %edx,%eax
  803235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803238:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80323e:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803243:	29 c2                	sub    %eax,%edx
  803245:	89 d0                	mov    %edx,%eax
  803247:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803250:	77 13                	ja     803265 <sget+0xc7>
  803252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803255:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803258:	77 0b                	ja     803265 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80325a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325d:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  803260:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803263:	73 0a                	jae    80326f <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  803265:	b8 00 00 00 00       	mov    $0x0,%eax
  80326a:	e9 90 00 00 00       	jmp    8032ff <sget+0x161>

	void *va = NULL;
  80326f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  803276:	a1 44 e2 81 00       	mov    0x81e244,%eax
  80327b:	83 f8 05             	cmp    $0x5,%eax
  80327e:	75 11                	jne    803291 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  803280:	83 ec 0c             	sub    $0xc,%esp
  803283:	ff 75 f4             	pushl  -0xc(%ebp)
  803286:	e8 a3 f5 ff ff       	call   80282e <alloc_pages_custom_fit>
  80328b:	83 c4 10             	add    $0x10,%esp
  80328e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  803291:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803295:	75 27                	jne    8032be <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803297:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80329e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8032a4:	89 c2                	mov    %eax,%edx
  8032a6:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032ab:	39 c2                	cmp    %eax,%edx
  8032ad:	73 07                	jae    8032b6 <sget+0x118>
			return NULL;
  8032af:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b4:	eb 49                	jmp    8032ff <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8032b6:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8032c4:	ff 75 0c             	pushl  0xc(%ebp)
  8032c7:	ff 75 08             	pushl  0x8(%ebp)
  8032ca:	e8 af 02 00 00       	call   80357e <sys_get_shared_object>
  8032cf:	83 c4 10             	add    $0x10,%esp
  8032d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8032d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032d9:	79 07                	jns    8032e2 <sget+0x144>
		return NULL;
  8032db:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e0:	eb 1d                	jmp    8032ff <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8032e2:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032e7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8032ea:	75 10                	jne    8032fc <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8032ec:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	01 d0                	add    %edx,%eax
  8032f7:	a3 50 e2 81 00       	mov    %eax,0x81e250

	return va;
  8032fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8032ff:	c9                   	leave  
  803300:	c3                   	ret    

00803301 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803301:	55                   	push   %ebp
  803302:	89 e5                	mov    %esp,%ebp
  803304:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803307:	e8 71 f9 ff ff       	call   802c7d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	68 34 58 80 00       	push   $0x805834
  803314:	68 19 02 00 00       	push   $0x219
  803319:	68 11 54 80 00       	push   $0x805411
  80331e:	e8 42 e1 ff ff       	call   801465 <_panic>

00803323 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803323:	55                   	push   %ebp
  803324:	89 e5                	mov    %esp,%ebp
  803326:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 5c 58 80 00       	push   $0x80585c
  803331:	68 2b 02 00 00       	push   $0x22b
  803336:	68 11 54 80 00       	push   $0x805411
  80333b:	e8 25 e1 ff ff       	call   801465 <_panic>

00803340 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803340:	55                   	push   %ebp
  803341:	89 e5                	mov    %esp,%ebp
  803343:	57                   	push   %edi
  803344:	56                   	push   %esi
  803345:	53                   	push   %ebx
  803346:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80334f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803352:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803355:	8b 7d 18             	mov    0x18(%ebp),%edi
  803358:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80335b:	cd 30                	int    $0x30
  80335d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803360:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803363:	83 c4 10             	add    $0x10,%esp
  803366:	5b                   	pop    %ebx
  803367:	5e                   	pop    %esi
  803368:	5f                   	pop    %edi
  803369:	5d                   	pop    %ebp
  80336a:	c3                   	ret    

0080336b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80336b:	55                   	push   %ebp
  80336c:	89 e5                	mov    %esp,%ebp
  80336e:	83 ec 04             	sub    $0x4,%esp
  803371:	8b 45 10             	mov    0x10(%ebp),%eax
  803374:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803377:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80337a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	6a 00                	push   $0x0
  803383:	51                   	push   %ecx
  803384:	52                   	push   %edx
  803385:	ff 75 0c             	pushl  0xc(%ebp)
  803388:	50                   	push   %eax
  803389:	6a 00                	push   $0x0
  80338b:	e8 b0 ff ff ff       	call   803340 <syscall>
  803390:	83 c4 18             	add    $0x18,%esp
}
  803393:	90                   	nop
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <sys_cgetc>:

int
sys_cgetc(void)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803399:	6a 00                	push   $0x0
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 02                	push   $0x2
  8033a5:	e8 96 ff ff ff       	call   803340 <syscall>
  8033aa:	83 c4 18             	add    $0x18,%esp
}
  8033ad:	c9                   	leave  
  8033ae:	c3                   	ret    

008033af <sys_lock_cons>:

void sys_lock_cons(void)
{
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8033b2:	6a 00                	push   $0x0
  8033b4:	6a 00                	push   $0x0
  8033b6:	6a 00                	push   $0x0
  8033b8:	6a 00                	push   $0x0
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 03                	push   $0x3
  8033be:	e8 7d ff ff ff       	call   803340 <syscall>
  8033c3:	83 c4 18             	add    $0x18,%esp
}
  8033c6:	90                   	nop
  8033c7:	c9                   	leave  
  8033c8:	c3                   	ret    

008033c9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8033c9:	55                   	push   %ebp
  8033ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8033cc:	6a 00                	push   $0x0
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	6a 04                	push   $0x4
  8033d8:	e8 63 ff ff ff       	call   803340 <syscall>
  8033dd:	83 c4 18             	add    $0x18,%esp
}
  8033e0:	90                   	nop
  8033e1:	c9                   	leave  
  8033e2:	c3                   	ret    

008033e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8033e3:	55                   	push   %ebp
  8033e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8033e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	6a 00                	push   $0x0
  8033ee:	6a 00                	push   $0x0
  8033f0:	6a 00                	push   $0x0
  8033f2:	52                   	push   %edx
  8033f3:	50                   	push   %eax
  8033f4:	6a 08                	push   $0x8
  8033f6:	e8 45 ff ff ff       	call   803340 <syscall>
  8033fb:	83 c4 18             	add    $0x18,%esp
}
  8033fe:	c9                   	leave  
  8033ff:	c3                   	ret    

00803400 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803400:	55                   	push   %ebp
  803401:	89 e5                	mov    %esp,%ebp
  803403:	56                   	push   %esi
  803404:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803405:	8b 75 18             	mov    0x18(%ebp),%esi
  803408:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80340b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80340e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803411:	8b 45 08             	mov    0x8(%ebp),%eax
  803414:	56                   	push   %esi
  803415:	53                   	push   %ebx
  803416:	51                   	push   %ecx
  803417:	52                   	push   %edx
  803418:	50                   	push   %eax
  803419:	6a 09                	push   $0x9
  80341b:	e8 20 ff ff ff       	call   803340 <syscall>
  803420:	83 c4 18             	add    $0x18,%esp
}
  803423:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803426:	5b                   	pop    %ebx
  803427:	5e                   	pop    %esi
  803428:	5d                   	pop    %ebp
  803429:	c3                   	ret    

0080342a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80342a:	55                   	push   %ebp
  80342b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80342d:	6a 00                	push   $0x0
  80342f:	6a 00                	push   $0x0
  803431:	6a 00                	push   $0x0
  803433:	6a 00                	push   $0x0
  803435:	ff 75 08             	pushl  0x8(%ebp)
  803438:	6a 0a                	push   $0xa
  80343a:	e8 01 ff ff ff       	call   803340 <syscall>
  80343f:	83 c4 18             	add    $0x18,%esp
}
  803442:	c9                   	leave  
  803443:	c3                   	ret    

00803444 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803447:	6a 00                	push   $0x0
  803449:	6a 00                	push   $0x0
  80344b:	6a 00                	push   $0x0
  80344d:	ff 75 0c             	pushl  0xc(%ebp)
  803450:	ff 75 08             	pushl  0x8(%ebp)
  803453:	6a 0b                	push   $0xb
  803455:	e8 e6 fe ff ff       	call   803340 <syscall>
  80345a:	83 c4 18             	add    $0x18,%esp
}
  80345d:	c9                   	leave  
  80345e:	c3                   	ret    

0080345f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80345f:	55                   	push   %ebp
  803460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803462:	6a 00                	push   $0x0
  803464:	6a 00                	push   $0x0
  803466:	6a 00                	push   $0x0
  803468:	6a 00                	push   $0x0
  80346a:	6a 00                	push   $0x0
  80346c:	6a 0c                	push   $0xc
  80346e:	e8 cd fe ff ff       	call   803340 <syscall>
  803473:	83 c4 18             	add    $0x18,%esp
}
  803476:	c9                   	leave  
  803477:	c3                   	ret    

00803478 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803478:	55                   	push   %ebp
  803479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80347b:	6a 00                	push   $0x0
  80347d:	6a 00                	push   $0x0
  80347f:	6a 00                	push   $0x0
  803481:	6a 00                	push   $0x0
  803483:	6a 00                	push   $0x0
  803485:	6a 0d                	push   $0xd
  803487:	e8 b4 fe ff ff       	call   803340 <syscall>
  80348c:	83 c4 18             	add    $0x18,%esp
}
  80348f:	c9                   	leave  
  803490:	c3                   	ret    

00803491 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803491:	55                   	push   %ebp
  803492:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803494:	6a 00                	push   $0x0
  803496:	6a 00                	push   $0x0
  803498:	6a 00                	push   $0x0
  80349a:	6a 00                	push   $0x0
  80349c:	6a 00                	push   $0x0
  80349e:	6a 0e                	push   $0xe
  8034a0:	e8 9b fe ff ff       	call   803340 <syscall>
  8034a5:	83 c4 18             	add    $0x18,%esp
}
  8034a8:	c9                   	leave  
  8034a9:	c3                   	ret    

008034aa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8034aa:	55                   	push   %ebp
  8034ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8034ad:	6a 00                	push   $0x0
  8034af:	6a 00                	push   $0x0
  8034b1:	6a 00                	push   $0x0
  8034b3:	6a 00                	push   $0x0
  8034b5:	6a 00                	push   $0x0
  8034b7:	6a 0f                	push   $0xf
  8034b9:	e8 82 fe ff ff       	call   803340 <syscall>
  8034be:	83 c4 18             	add    $0x18,%esp
}
  8034c1:	c9                   	leave  
  8034c2:	c3                   	ret    

008034c3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8034c3:	55                   	push   %ebp
  8034c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8034c6:	6a 00                	push   $0x0
  8034c8:	6a 00                	push   $0x0
  8034ca:	6a 00                	push   $0x0
  8034cc:	6a 00                	push   $0x0
  8034ce:	ff 75 08             	pushl  0x8(%ebp)
  8034d1:	6a 10                	push   $0x10
  8034d3:	e8 68 fe ff ff       	call   803340 <syscall>
  8034d8:	83 c4 18             	add    $0x18,%esp
}
  8034db:	c9                   	leave  
  8034dc:	c3                   	ret    

008034dd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8034dd:	55                   	push   %ebp
  8034de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8034e0:	6a 00                	push   $0x0
  8034e2:	6a 00                	push   $0x0
  8034e4:	6a 00                	push   $0x0
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 00                	push   $0x0
  8034ea:	6a 11                	push   $0x11
  8034ec:	e8 4f fe ff ff       	call   803340 <syscall>
  8034f1:	83 c4 18             	add    $0x18,%esp
}
  8034f4:	90                   	nop
  8034f5:	c9                   	leave  
  8034f6:	c3                   	ret    

008034f7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8034f7:	55                   	push   %ebp
  8034f8:	89 e5                	mov    %esp,%ebp
  8034fa:	83 ec 04             	sub    $0x4,%esp
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803503:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803507:	6a 00                	push   $0x0
  803509:	6a 00                	push   $0x0
  80350b:	6a 00                	push   $0x0
  80350d:	6a 00                	push   $0x0
  80350f:	50                   	push   %eax
  803510:	6a 01                	push   $0x1
  803512:	e8 29 fe ff ff       	call   803340 <syscall>
  803517:	83 c4 18             	add    $0x18,%esp
}
  80351a:	90                   	nop
  80351b:	c9                   	leave  
  80351c:	c3                   	ret    

0080351d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80351d:	55                   	push   %ebp
  80351e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803520:	6a 00                	push   $0x0
  803522:	6a 00                	push   $0x0
  803524:	6a 00                	push   $0x0
  803526:	6a 00                	push   $0x0
  803528:	6a 00                	push   $0x0
  80352a:	6a 14                	push   $0x14
  80352c:	e8 0f fe ff ff       	call   803340 <syscall>
  803531:	83 c4 18             	add    $0x18,%esp
}
  803534:	90                   	nop
  803535:	c9                   	leave  
  803536:	c3                   	ret    

00803537 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803537:	55                   	push   %ebp
  803538:	89 e5                	mov    %esp,%ebp
  80353a:	83 ec 04             	sub    $0x4,%esp
  80353d:	8b 45 10             	mov    0x10(%ebp),%eax
  803540:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803543:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803546:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	6a 00                	push   $0x0
  80354f:	51                   	push   %ecx
  803550:	52                   	push   %edx
  803551:	ff 75 0c             	pushl  0xc(%ebp)
  803554:	50                   	push   %eax
  803555:	6a 15                	push   $0x15
  803557:	e8 e4 fd ff ff       	call   803340 <syscall>
  80355c:	83 c4 18             	add    $0x18,%esp
}
  80355f:	c9                   	leave  
  803560:	c3                   	ret    

00803561 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803564:	8b 55 0c             	mov    0xc(%ebp),%edx
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	6a 00                	push   $0x0
  80356c:	6a 00                	push   $0x0
  80356e:	6a 00                	push   $0x0
  803570:	52                   	push   %edx
  803571:	50                   	push   %eax
  803572:	6a 16                	push   $0x16
  803574:	e8 c7 fd ff ff       	call   803340 <syscall>
  803579:	83 c4 18             	add    $0x18,%esp
}
  80357c:	c9                   	leave  
  80357d:	c3                   	ret    

0080357e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803581:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803584:	8b 55 0c             	mov    0xc(%ebp),%edx
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	6a 00                	push   $0x0
  80358c:	6a 00                	push   $0x0
  80358e:	51                   	push   %ecx
  80358f:	52                   	push   %edx
  803590:	50                   	push   %eax
  803591:	6a 17                	push   $0x17
  803593:	e8 a8 fd ff ff       	call   803340 <syscall>
  803598:	83 c4 18             	add    $0x18,%esp
}
  80359b:	c9                   	leave  
  80359c:	c3                   	ret    

0080359d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80359d:	55                   	push   %ebp
  80359e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8035a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	6a 00                	push   $0x0
  8035a8:	6a 00                	push   $0x0
  8035aa:	6a 00                	push   $0x0
  8035ac:	52                   	push   %edx
  8035ad:	50                   	push   %eax
  8035ae:	6a 18                	push   $0x18
  8035b0:	e8 8b fd ff ff       	call   803340 <syscall>
  8035b5:	83 c4 18             	add    $0x18,%esp
}
  8035b8:	c9                   	leave  
  8035b9:	c3                   	ret    

008035ba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8035ba:	55                   	push   %ebp
  8035bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	6a 00                	push   $0x0
  8035c2:	ff 75 14             	pushl  0x14(%ebp)
  8035c5:	ff 75 10             	pushl  0x10(%ebp)
  8035c8:	ff 75 0c             	pushl  0xc(%ebp)
  8035cb:	50                   	push   %eax
  8035cc:	6a 19                	push   $0x19
  8035ce:	e8 6d fd ff ff       	call   803340 <syscall>
  8035d3:	83 c4 18             	add    $0x18,%esp
}
  8035d6:	c9                   	leave  
  8035d7:	c3                   	ret    

008035d8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8035d8:	55                   	push   %ebp
  8035d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	6a 00                	push   $0x0
  8035e0:	6a 00                	push   $0x0
  8035e2:	6a 00                	push   $0x0
  8035e4:	6a 00                	push   $0x0
  8035e6:	50                   	push   %eax
  8035e7:	6a 1a                	push   $0x1a
  8035e9:	e8 52 fd ff ff       	call   803340 <syscall>
  8035ee:	83 c4 18             	add    $0x18,%esp
}
  8035f1:	90                   	nop
  8035f2:	c9                   	leave  
  8035f3:	c3                   	ret    

008035f4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8035f4:	55                   	push   %ebp
  8035f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	6a 00                	push   $0x0
  8035fc:	6a 00                	push   $0x0
  8035fe:	6a 00                	push   $0x0
  803600:	6a 00                	push   $0x0
  803602:	50                   	push   %eax
  803603:	6a 1b                	push   $0x1b
  803605:	e8 36 fd ff ff       	call   803340 <syscall>
  80360a:	83 c4 18             	add    $0x18,%esp
}
  80360d:	c9                   	leave  
  80360e:	c3                   	ret    

0080360f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80360f:	55                   	push   %ebp
  803610:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803612:	6a 00                	push   $0x0
  803614:	6a 00                	push   $0x0
  803616:	6a 00                	push   $0x0
  803618:	6a 00                	push   $0x0
  80361a:	6a 00                	push   $0x0
  80361c:	6a 05                	push   $0x5
  80361e:	e8 1d fd ff ff       	call   803340 <syscall>
  803623:	83 c4 18             	add    $0x18,%esp
}
  803626:	c9                   	leave  
  803627:	c3                   	ret    

00803628 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803628:	55                   	push   %ebp
  803629:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80362b:	6a 00                	push   $0x0
  80362d:	6a 00                	push   $0x0
  80362f:	6a 00                	push   $0x0
  803631:	6a 00                	push   $0x0
  803633:	6a 00                	push   $0x0
  803635:	6a 06                	push   $0x6
  803637:	e8 04 fd ff ff       	call   803340 <syscall>
  80363c:	83 c4 18             	add    $0x18,%esp
}
  80363f:	c9                   	leave  
  803640:	c3                   	ret    

00803641 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803641:	55                   	push   %ebp
  803642:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803644:	6a 00                	push   $0x0
  803646:	6a 00                	push   $0x0
  803648:	6a 00                	push   $0x0
  80364a:	6a 00                	push   $0x0
  80364c:	6a 00                	push   $0x0
  80364e:	6a 07                	push   $0x7
  803650:	e8 eb fc ff ff       	call   803340 <syscall>
  803655:	83 c4 18             	add    $0x18,%esp
}
  803658:	c9                   	leave  
  803659:	c3                   	ret    

0080365a <sys_exit_env>:


void sys_exit_env(void)
{
  80365a:	55                   	push   %ebp
  80365b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80365d:	6a 00                	push   $0x0
  80365f:	6a 00                	push   $0x0
  803661:	6a 00                	push   $0x0
  803663:	6a 00                	push   $0x0
  803665:	6a 00                	push   $0x0
  803667:	6a 1c                	push   $0x1c
  803669:	e8 d2 fc ff ff       	call   803340 <syscall>
  80366e:	83 c4 18             	add    $0x18,%esp
}
  803671:	90                   	nop
  803672:	c9                   	leave  
  803673:	c3                   	ret    

00803674 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803674:	55                   	push   %ebp
  803675:	89 e5                	mov    %esp,%ebp
  803677:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80367a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80367d:	8d 50 04             	lea    0x4(%eax),%edx
  803680:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803683:	6a 00                	push   $0x0
  803685:	6a 00                	push   $0x0
  803687:	6a 00                	push   $0x0
  803689:	52                   	push   %edx
  80368a:	50                   	push   %eax
  80368b:	6a 1d                	push   $0x1d
  80368d:	e8 ae fc ff ff       	call   803340 <syscall>
  803692:	83 c4 18             	add    $0x18,%esp
	return result;
  803695:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80369b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80369e:	89 01                	mov    %eax,(%ecx)
  8036a0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8036a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a6:	c9                   	leave  
  8036a7:	c2 04 00             	ret    $0x4

008036aa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8036aa:	55                   	push   %ebp
  8036ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8036ad:	6a 00                	push   $0x0
  8036af:	6a 00                	push   $0x0
  8036b1:	ff 75 10             	pushl  0x10(%ebp)
  8036b4:	ff 75 0c             	pushl  0xc(%ebp)
  8036b7:	ff 75 08             	pushl  0x8(%ebp)
  8036ba:	6a 13                	push   $0x13
  8036bc:	e8 7f fc ff ff       	call   803340 <syscall>
  8036c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8036c4:	90                   	nop
}
  8036c5:	c9                   	leave  
  8036c6:	c3                   	ret    

008036c7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8036c7:	55                   	push   %ebp
  8036c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8036ca:	6a 00                	push   $0x0
  8036cc:	6a 00                	push   $0x0
  8036ce:	6a 00                	push   $0x0
  8036d0:	6a 00                	push   $0x0
  8036d2:	6a 00                	push   $0x0
  8036d4:	6a 1e                	push   $0x1e
  8036d6:	e8 65 fc ff ff       	call   803340 <syscall>
  8036db:	83 c4 18             	add    $0x18,%esp
}
  8036de:	c9                   	leave  
  8036df:	c3                   	ret    

008036e0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8036e0:	55                   	push   %ebp
  8036e1:	89 e5                	mov    %esp,%ebp
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8036ec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8036f0:	6a 00                	push   $0x0
  8036f2:	6a 00                	push   $0x0
  8036f4:	6a 00                	push   $0x0
  8036f6:	6a 00                	push   $0x0
  8036f8:	50                   	push   %eax
  8036f9:	6a 1f                	push   $0x1f
  8036fb:	e8 40 fc ff ff       	call   803340 <syscall>
  803700:	83 c4 18             	add    $0x18,%esp
	return ;
  803703:	90                   	nop
}
  803704:	c9                   	leave  
  803705:	c3                   	ret    

00803706 <rsttst>:
void rsttst()
{
  803706:	55                   	push   %ebp
  803707:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803709:	6a 00                	push   $0x0
  80370b:	6a 00                	push   $0x0
  80370d:	6a 00                	push   $0x0
  80370f:	6a 00                	push   $0x0
  803711:	6a 00                	push   $0x0
  803713:	6a 21                	push   $0x21
  803715:	e8 26 fc ff ff       	call   803340 <syscall>
  80371a:	83 c4 18             	add    $0x18,%esp
	return ;
  80371d:	90                   	nop
}
  80371e:	c9                   	leave  
  80371f:	c3                   	ret    

00803720 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803720:	55                   	push   %ebp
  803721:	89 e5                	mov    %esp,%ebp
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	8b 45 14             	mov    0x14(%ebp),%eax
  803729:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80372c:	8b 55 18             	mov    0x18(%ebp),%edx
  80372f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803733:	52                   	push   %edx
  803734:	50                   	push   %eax
  803735:	ff 75 10             	pushl  0x10(%ebp)
  803738:	ff 75 0c             	pushl  0xc(%ebp)
  80373b:	ff 75 08             	pushl  0x8(%ebp)
  80373e:	6a 20                	push   $0x20
  803740:	e8 fb fb ff ff       	call   803340 <syscall>
  803745:	83 c4 18             	add    $0x18,%esp
	return ;
  803748:	90                   	nop
}
  803749:	c9                   	leave  
  80374a:	c3                   	ret    

0080374b <chktst>:
void chktst(uint32 n)
{
  80374b:	55                   	push   %ebp
  80374c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80374e:	6a 00                	push   $0x0
  803750:	6a 00                	push   $0x0
  803752:	6a 00                	push   $0x0
  803754:	6a 00                	push   $0x0
  803756:	ff 75 08             	pushl  0x8(%ebp)
  803759:	6a 22                	push   $0x22
  80375b:	e8 e0 fb ff ff       	call   803340 <syscall>
  803760:	83 c4 18             	add    $0x18,%esp
	return ;
  803763:	90                   	nop
}
  803764:	c9                   	leave  
  803765:	c3                   	ret    

00803766 <inctst>:

void inctst()
{
  803766:	55                   	push   %ebp
  803767:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803769:	6a 00                	push   $0x0
  80376b:	6a 00                	push   $0x0
  80376d:	6a 00                	push   $0x0
  80376f:	6a 00                	push   $0x0
  803771:	6a 00                	push   $0x0
  803773:	6a 23                	push   $0x23
  803775:	e8 c6 fb ff ff       	call   803340 <syscall>
  80377a:	83 c4 18             	add    $0x18,%esp
	return ;
  80377d:	90                   	nop
}
  80377e:	c9                   	leave  
  80377f:	c3                   	ret    

00803780 <gettst>:
uint32 gettst()
{
  803780:	55                   	push   %ebp
  803781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803783:	6a 00                	push   $0x0
  803785:	6a 00                	push   $0x0
  803787:	6a 00                	push   $0x0
  803789:	6a 00                	push   $0x0
  80378b:	6a 00                	push   $0x0
  80378d:	6a 24                	push   $0x24
  80378f:	e8 ac fb ff ff       	call   803340 <syscall>
  803794:	83 c4 18             	add    $0x18,%esp
}
  803797:	c9                   	leave  
  803798:	c3                   	ret    

00803799 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803799:	55                   	push   %ebp
  80379a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80379c:	6a 00                	push   $0x0
  80379e:	6a 00                	push   $0x0
  8037a0:	6a 00                	push   $0x0
  8037a2:	6a 00                	push   $0x0
  8037a4:	6a 00                	push   $0x0
  8037a6:	6a 25                	push   $0x25
  8037a8:	e8 93 fb ff ff       	call   803340 <syscall>
  8037ad:	83 c4 18             	add    $0x18,%esp
  8037b0:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  8037b5:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  8037ba:	c9                   	leave  
  8037bb:	c3                   	ret    

008037bc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8037bc:	55                   	push   %ebp
  8037bd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8037bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c2:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8037c7:	6a 00                	push   $0x0
  8037c9:	6a 00                	push   $0x0
  8037cb:	6a 00                	push   $0x0
  8037cd:	6a 00                	push   $0x0
  8037cf:	ff 75 08             	pushl  0x8(%ebp)
  8037d2:	6a 26                	push   $0x26
  8037d4:	e8 67 fb ff ff       	call   803340 <syscall>
  8037d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8037dc:	90                   	nop
}
  8037dd:	c9                   	leave  
  8037de:	c3                   	ret    

008037df <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8037df:	55                   	push   %ebp
  8037e0:	89 e5                	mov    %esp,%ebp
  8037e2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8037e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8037e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8037e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	6a 00                	push   $0x0
  8037f1:	53                   	push   %ebx
  8037f2:	51                   	push   %ecx
  8037f3:	52                   	push   %edx
  8037f4:	50                   	push   %eax
  8037f5:	6a 27                	push   $0x27
  8037f7:	e8 44 fb ff ff       	call   803340 <syscall>
  8037fc:	83 c4 18             	add    $0x18,%esp
}
  8037ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803802:	c9                   	leave  
  803803:	c3                   	ret    

00803804 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803804:	55                   	push   %ebp
  803805:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	6a 00                	push   $0x0
  80380f:	6a 00                	push   $0x0
  803811:	6a 00                	push   $0x0
  803813:	52                   	push   %edx
  803814:	50                   	push   %eax
  803815:	6a 28                	push   $0x28
  803817:	e8 24 fb ff ff       	call   803340 <syscall>
  80381c:	83 c4 18             	add    $0x18,%esp
}
  80381f:	c9                   	leave  
  803820:	c3                   	ret    

00803821 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803821:	55                   	push   %ebp
  803822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803824:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80382a:	8b 45 08             	mov    0x8(%ebp),%eax
  80382d:	6a 00                	push   $0x0
  80382f:	51                   	push   %ecx
  803830:	ff 75 10             	pushl  0x10(%ebp)
  803833:	52                   	push   %edx
  803834:	50                   	push   %eax
  803835:	6a 29                	push   $0x29
  803837:	e8 04 fb ff ff       	call   803340 <syscall>
  80383c:	83 c4 18             	add    $0x18,%esp
}
  80383f:	c9                   	leave  
  803840:	c3                   	ret    

00803841 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803841:	55                   	push   %ebp
  803842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803844:	6a 00                	push   $0x0
  803846:	6a 00                	push   $0x0
  803848:	ff 75 10             	pushl  0x10(%ebp)
  80384b:	ff 75 0c             	pushl  0xc(%ebp)
  80384e:	ff 75 08             	pushl  0x8(%ebp)
  803851:	6a 12                	push   $0x12
  803853:	e8 e8 fa ff ff       	call   803340 <syscall>
  803858:	83 c4 18             	add    $0x18,%esp
	return ;
  80385b:	90                   	nop
}
  80385c:	c9                   	leave  
  80385d:	c3                   	ret    

0080385e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803861:	8b 55 0c             	mov    0xc(%ebp),%edx
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	6a 00                	push   $0x0
  803869:	6a 00                	push   $0x0
  80386b:	6a 00                	push   $0x0
  80386d:	52                   	push   %edx
  80386e:	50                   	push   %eax
  80386f:	6a 2a                	push   $0x2a
  803871:	e8 ca fa ff ff       	call   803340 <syscall>
  803876:	83 c4 18             	add    $0x18,%esp
	return;
  803879:	90                   	nop
}
  80387a:	c9                   	leave  
  80387b:	c3                   	ret    

0080387c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80387c:	55                   	push   %ebp
  80387d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80387f:	6a 00                	push   $0x0
  803881:	6a 00                	push   $0x0
  803883:	6a 00                	push   $0x0
  803885:	6a 00                	push   $0x0
  803887:	6a 00                	push   $0x0
  803889:	6a 2b                	push   $0x2b
  80388b:	e8 b0 fa ff ff       	call   803340 <syscall>
  803890:	83 c4 18             	add    $0x18,%esp
}
  803893:	c9                   	leave  
  803894:	c3                   	ret    

00803895 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803895:	55                   	push   %ebp
  803896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803898:	6a 00                	push   $0x0
  80389a:	6a 00                	push   $0x0
  80389c:	6a 00                	push   $0x0
  80389e:	ff 75 0c             	pushl  0xc(%ebp)
  8038a1:	ff 75 08             	pushl  0x8(%ebp)
  8038a4:	6a 2d                	push   $0x2d
  8038a6:	e8 95 fa ff ff       	call   803340 <syscall>
  8038ab:	83 c4 18             	add    $0x18,%esp
	return;
  8038ae:	90                   	nop
}
  8038af:	c9                   	leave  
  8038b0:	c3                   	ret    

008038b1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8038b1:	55                   	push   %ebp
  8038b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8038b4:	6a 00                	push   $0x0
  8038b6:	6a 00                	push   $0x0
  8038b8:	6a 00                	push   $0x0
  8038ba:	ff 75 0c             	pushl  0xc(%ebp)
  8038bd:	ff 75 08             	pushl  0x8(%ebp)
  8038c0:	6a 2c                	push   $0x2c
  8038c2:	e8 79 fa ff ff       	call   803340 <syscall>
  8038c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8038ca:	90                   	nop
}
  8038cb:	c9                   	leave  
  8038cc:	c3                   	ret    

008038cd <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8038cd:	55                   	push   %ebp
  8038ce:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8038d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	6a 00                	push   $0x0
  8038d8:	6a 00                	push   $0x0
  8038da:	6a 00                	push   $0x0
  8038dc:	52                   	push   %edx
  8038dd:	50                   	push   %eax
  8038de:	6a 2e                	push   $0x2e
  8038e0:	e8 5b fa ff ff       	call   803340 <syscall>
  8038e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8038e8:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8038e9:	c9                   	leave  
  8038ea:	c3                   	ret    

008038eb <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8038eb:	55                   	push   %ebp
  8038ec:	89 e5                	mov    %esp,%ebp
  8038ee:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8038f1:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  8038f8:	72 09                	jb     803903 <to_page_va+0x18>
  8038fa:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  803901:	72 14                	jb     803917 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803903:	83 ec 04             	sub    $0x4,%esp
  803906:	68 80 58 80 00       	push   $0x805880
  80390b:	6a 15                	push   $0x15
  80390d:	68 ab 58 80 00       	push   $0x8058ab
  803912:	e8 4e db ff ff       	call   801465 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803917:	8b 45 08             	mov    0x8(%ebp),%eax
  80391a:	ba 40 62 80 00       	mov    $0x806240,%edx
  80391f:	29 d0                	sub    %edx,%eax
  803921:	c1 f8 02             	sar    $0x2,%eax
  803924:	89 c2                	mov    %eax,%edx
  803926:	89 d0                	mov    %edx,%eax
  803928:	c1 e0 02             	shl    $0x2,%eax
  80392b:	01 d0                	add    %edx,%eax
  80392d:	c1 e0 02             	shl    $0x2,%eax
  803930:	01 d0                	add    %edx,%eax
  803932:	c1 e0 02             	shl    $0x2,%eax
  803935:	01 d0                	add    %edx,%eax
  803937:	89 c1                	mov    %eax,%ecx
  803939:	c1 e1 08             	shl    $0x8,%ecx
  80393c:	01 c8                	add    %ecx,%eax
  80393e:	89 c1                	mov    %eax,%ecx
  803940:	c1 e1 10             	shl    $0x10,%ecx
  803943:	01 c8                	add    %ecx,%eax
  803945:	01 c0                	add    %eax,%eax
  803947:	01 d0                	add    %edx,%eax
  803949:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80394c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394f:	c1 e0 0c             	shl    $0xc,%eax
  803952:	89 c2                	mov    %eax,%edx
  803954:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803959:	01 d0                	add    %edx,%eax
}
  80395b:	c9                   	leave  
  80395c:	c3                   	ret    

0080395d <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80395d:	55                   	push   %ebp
  80395e:	89 e5                	mov    %esp,%ebp
  803960:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803963:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803968:	8b 55 08             	mov    0x8(%ebp),%edx
  80396b:	29 c2                	sub    %eax,%edx
  80396d:	89 d0                	mov    %edx,%eax
  80396f:	c1 e8 0c             	shr    $0xc,%eax
  803972:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803975:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803979:	78 09                	js     803984 <to_page_info+0x27>
  80397b:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803982:	7e 14                	jle    803998 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803984:	83 ec 04             	sub    $0x4,%esp
  803987:	68 c4 58 80 00       	push   $0x8058c4
  80398c:	6a 22                	push   $0x22
  80398e:	68 ab 58 80 00       	push   $0x8058ab
  803993:	e8 cd da ff ff       	call   801465 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80399b:	89 d0                	mov    %edx,%eax
  80399d:	01 c0                	add    %eax,%eax
  80399f:	01 d0                	add    %edx,%eax
  8039a1:	c1 e0 02             	shl    $0x2,%eax
  8039a4:	05 40 62 80 00       	add    $0x806240,%eax
}
  8039a9:	c9                   	leave  
  8039aa:	c3                   	ret    

008039ab <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8039ab:	55                   	push   %ebp
  8039ac:	89 e5                	mov    %esp,%ebp
  8039ae:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8039b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b4:	05 00 00 00 02       	add    $0x2000000,%eax
  8039b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039bc:	73 16                	jae    8039d4 <initialize_dynamic_allocator+0x29>
  8039be:	68 e8 58 80 00       	push   $0x8058e8
  8039c3:	68 0e 59 80 00       	push   $0x80590e
  8039c8:	6a 34                	push   $0x34
  8039ca:	68 ab 58 80 00       	push   $0x8058ab
  8039cf:	e8 91 da ff ff       	call   801465 <_panic>
		is_initialized = 1;
  8039d4:	c7 05 14 62 80 00 01 	movl   $0x1,0x806214
  8039db:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e1:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  8039e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e9:	a3 20 62 80 00       	mov    %eax,0x806220

	LIST_INIT(&freePagesList);
  8039ee:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  8039f5:	00 00 00 
  8039f8:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  8039ff:	00 00 00 
  803a02:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  803a09:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803a0c:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a1a:	eb 36                	jmp    803a52 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	c1 e0 04             	shl    $0x4,%eax
  803a22:	05 60 e2 81 00       	add    $0x81e260,%eax
  803a27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a30:	c1 e0 04             	shl    $0x4,%eax
  803a33:	05 64 e2 81 00       	add    $0x81e264,%eax
  803a38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a41:	c1 e0 04             	shl    $0x4,%eax
  803a44:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803a4f:	ff 45 f4             	incl   -0xc(%ebp)
  803a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a55:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a58:	72 c2                	jb     803a1c <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803a5a:	8b 15 20 62 80 00    	mov    0x806220,%edx
  803a60:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803a65:	29 c2                	sub    %eax,%edx
  803a67:	89 d0                	mov    %edx,%eax
  803a69:	c1 e8 0c             	shr    $0xc,%eax
  803a6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803a6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a76:	e9 c8 00 00 00       	jmp    803b43 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a7e:	89 d0                	mov    %edx,%eax
  803a80:	01 c0                	add    %eax,%eax
  803a82:	01 d0                	add    %edx,%eax
  803a84:	c1 e0 02             	shl    $0x2,%eax
  803a87:	05 48 62 80 00       	add    $0x806248,%eax
  803a8c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a94:	89 d0                	mov    %edx,%eax
  803a96:	01 c0                	add    %eax,%eax
  803a98:	01 d0                	add    %edx,%eax
  803a9a:	c1 e0 02             	shl    $0x2,%eax
  803a9d:	05 4a 62 80 00       	add    $0x80624a,%eax
  803aa2:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803aa7:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803aad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803ab0:	89 c8                	mov    %ecx,%eax
  803ab2:	01 c0                	add    %eax,%eax
  803ab4:	01 c8                	add    %ecx,%eax
  803ab6:	c1 e0 02             	shl    $0x2,%eax
  803ab9:	05 44 62 80 00       	add    $0x806244,%eax
  803abe:	89 10                	mov    %edx,(%eax)
  803ac0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ac3:	89 d0                	mov    %edx,%eax
  803ac5:	01 c0                	add    %eax,%eax
  803ac7:	01 d0                	add    %edx,%eax
  803ac9:	c1 e0 02             	shl    $0x2,%eax
  803acc:	05 44 62 80 00       	add    $0x806244,%eax
  803ad1:	8b 00                	mov    (%eax),%eax
  803ad3:	85 c0                	test   %eax,%eax
  803ad5:	74 1b                	je     803af2 <initialize_dynamic_allocator+0x147>
  803ad7:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803add:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803ae0:	89 c8                	mov    %ecx,%eax
  803ae2:	01 c0                	add    %eax,%eax
  803ae4:	01 c8                	add    %ecx,%eax
  803ae6:	c1 e0 02             	shl    $0x2,%eax
  803ae9:	05 40 62 80 00       	add    $0x806240,%eax
  803aee:	89 02                	mov    %eax,(%edx)
  803af0:	eb 16                	jmp    803b08 <initialize_dynamic_allocator+0x15d>
  803af2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803af5:	89 d0                	mov    %edx,%eax
  803af7:	01 c0                	add    %eax,%eax
  803af9:	01 d0                	add    %edx,%eax
  803afb:	c1 e0 02             	shl    $0x2,%eax
  803afe:	05 40 62 80 00       	add    $0x806240,%eax
  803b03:	a3 28 62 80 00       	mov    %eax,0x806228
  803b08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b0b:	89 d0                	mov    %edx,%eax
  803b0d:	01 c0                	add    %eax,%eax
  803b0f:	01 d0                	add    %edx,%eax
  803b11:	c1 e0 02             	shl    $0x2,%eax
  803b14:	05 40 62 80 00       	add    $0x806240,%eax
  803b19:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803b1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b21:	89 d0                	mov    %edx,%eax
  803b23:	01 c0                	add    %eax,%eax
  803b25:	01 d0                	add    %edx,%eax
  803b27:	c1 e0 02             	shl    $0x2,%eax
  803b2a:	05 40 62 80 00       	add    $0x806240,%eax
  803b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b35:	a1 34 62 80 00       	mov    0x806234,%eax
  803b3a:	40                   	inc    %eax
  803b3b:	a3 34 62 80 00       	mov    %eax,0x806234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803b40:	ff 45 f0             	incl   -0x10(%ebp)
  803b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b46:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b49:	0f 82 2c ff ff ff    	jb     803a7b <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b55:	eb 2f                	jmp    803b86 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803b57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b5a:	89 d0                	mov    %edx,%eax
  803b5c:	01 c0                	add    %eax,%eax
  803b5e:	01 d0                	add    %edx,%eax
  803b60:	c1 e0 02             	shl    $0x2,%eax
  803b63:	05 48 62 80 00       	add    $0x806248,%eax
  803b68:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803b6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b70:	89 d0                	mov    %edx,%eax
  803b72:	01 c0                	add    %eax,%eax
  803b74:	01 d0                	add    %edx,%eax
  803b76:	c1 e0 02             	shl    $0x2,%eax
  803b79:	05 4a 62 80 00       	add    $0x80624a,%eax
  803b7e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803b83:	ff 45 ec             	incl   -0x14(%ebp)
  803b86:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803b8d:	76 c8                	jbe    803b57 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803b8f:	90                   	nop
  803b90:	c9                   	leave  
  803b91:	c3                   	ret    

00803b92 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803b92:	55                   	push   %ebp
  803b93:	89 e5                	mov    %esp,%ebp
  803b95:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803b98:	8b 55 08             	mov    0x8(%ebp),%edx
  803b9b:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803ba0:	29 c2                	sub    %eax,%edx
  803ba2:	89 d0                	mov    %edx,%eax
  803ba4:	c1 e8 0c             	shr    $0xc,%eax
  803ba7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803baa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803bad:	89 d0                	mov    %edx,%eax
  803baf:	01 c0                	add    %eax,%eax
  803bb1:	01 d0                	add    %edx,%eax
  803bb3:	c1 e0 02             	shl    $0x2,%eax
  803bb6:	05 48 62 80 00       	add    $0x806248,%eax
  803bbb:	8b 00                	mov    (%eax),%eax
  803bbd:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803bc0:	c9                   	leave  
  803bc1:	c3                   	ret    

00803bc2 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803bc2:	55                   	push   %ebp
  803bc3:	89 e5                	mov    %esp,%ebp
  803bc5:	83 ec 14             	sub    $0x14,%esp
  803bc8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803bcb:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803bcf:	77 07                	ja     803bd8 <nearest_pow2_ceil.1513+0x16>
  803bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd6:	eb 20                	jmp    803bf8 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803bd8:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803bdf:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803be2:	eb 08                	jmp    803bec <nearest_pow2_ceil.1513+0x2a>
  803be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803be7:	01 c0                	add    %eax,%eax
  803be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803bec:	d1 6d 08             	shrl   0x8(%ebp)
  803bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bf3:	75 ef                	jne    803be4 <nearest_pow2_ceil.1513+0x22>
        return power;
  803bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803bf8:	c9                   	leave  
  803bf9:	c3                   	ret    

00803bfa <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803bfa:	55                   	push   %ebp
  803bfb:	89 e5                	mov    %esp,%ebp
  803bfd:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c00:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c07:	76 16                	jbe    803c1f <alloc_block+0x25>
  803c09:	68 24 59 80 00       	push   $0x805924
  803c0e:	68 0e 59 80 00       	push   $0x80590e
  803c13:	6a 72                	push   $0x72
  803c15:	68 ab 58 80 00       	push   $0x8058ab
  803c1a:	e8 46 d8 ff ff       	call   801465 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c23:	75 0a                	jne    803c2f <alloc_block+0x35>
  803c25:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2a:	e9 bd 04 00 00       	jmp    8040ec <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803c2f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803c36:	8b 45 08             	mov    0x8(%ebp),%eax
  803c39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c3c:	73 06                	jae    803c44 <alloc_block+0x4a>
        size = min_block_size;
  803c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c41:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803c44:	83 ec 0c             	sub    $0xc,%esp
  803c47:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803c4a:	ff 75 08             	pushl  0x8(%ebp)
  803c4d:	89 c1                	mov    %eax,%ecx
  803c4f:	e8 6e ff ff ff       	call   803bc2 <nearest_pow2_ceil.1513>
  803c54:	83 c4 10             	add    $0x10,%esp
  803c57:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803c5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c5d:	83 ec 0c             	sub    $0xc,%esp
  803c60:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803c63:	52                   	push   %edx
  803c64:	89 c1                	mov    %eax,%ecx
  803c66:	e8 83 04 00 00       	call   8040ee <log2_ceil.1520>
  803c6b:	83 c4 10             	add    $0x10,%esp
  803c6e:	83 e8 03             	sub    $0x3,%eax
  803c71:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c77:	c1 e0 04             	shl    $0x4,%eax
  803c7a:	05 60 e2 81 00       	add    $0x81e260,%eax
  803c7f:	8b 00                	mov    (%eax),%eax
  803c81:	85 c0                	test   %eax,%eax
  803c83:	0f 84 d8 00 00 00    	je     803d61 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8c:	c1 e0 04             	shl    $0x4,%eax
  803c8f:	05 60 e2 81 00       	add    $0x81e260,%eax
  803c94:	8b 00                	mov    (%eax),%eax
  803c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803c99:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c9d:	75 17                	jne    803cb6 <alloc_block+0xbc>
  803c9f:	83 ec 04             	sub    $0x4,%esp
  803ca2:	68 45 59 80 00       	push   $0x805945
  803ca7:	68 98 00 00 00       	push   $0x98
  803cac:	68 ab 58 80 00       	push   $0x8058ab
  803cb1:	e8 af d7 ff ff       	call   801465 <_panic>
  803cb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb9:	8b 00                	mov    (%eax),%eax
  803cbb:	85 c0                	test   %eax,%eax
  803cbd:	74 10                	je     803ccf <alloc_block+0xd5>
  803cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cc7:	8b 52 04             	mov    0x4(%edx),%edx
  803cca:	89 50 04             	mov    %edx,0x4(%eax)
  803ccd:	eb 14                	jmp    803ce3 <alloc_block+0xe9>
  803ccf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cd2:	8b 40 04             	mov    0x4(%eax),%eax
  803cd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cd8:	c1 e2 04             	shl    $0x4,%edx
  803cdb:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803ce1:	89 02                	mov    %eax,(%edx)
  803ce3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce6:	8b 40 04             	mov    0x4(%eax),%eax
  803ce9:	85 c0                	test   %eax,%eax
  803ceb:	74 0f                	je     803cfc <alloc_block+0x102>
  803ced:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cf0:	8b 40 04             	mov    0x4(%eax),%eax
  803cf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cf6:	8b 12                	mov    (%edx),%edx
  803cf8:	89 10                	mov    %edx,(%eax)
  803cfa:	eb 13                	jmp    803d0f <alloc_block+0x115>
  803cfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cff:	8b 00                	mov    (%eax),%eax
  803d01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d04:	c1 e2 04             	shl    $0x4,%edx
  803d07:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803d0d:	89 02                	mov    %eax,(%edx)
  803d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d25:	c1 e0 04             	shl    $0x4,%eax
  803d28:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803d2d:	8b 00                	mov    (%eax),%eax
  803d2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d35:	c1 e0 04             	shl    $0x4,%eax
  803d38:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803d3d:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d42:	83 ec 0c             	sub    $0xc,%esp
  803d45:	50                   	push   %eax
  803d46:	e8 12 fc ff ff       	call   80395d <to_page_info>
  803d4b:	83 c4 10             	add    $0x10,%esp
  803d4e:	89 c2                	mov    %eax,%edx
  803d50:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803d54:	48                   	dec    %eax
  803d55:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d5c:	e9 8b 03 00 00       	jmp    8040ec <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803d61:	a1 28 62 80 00       	mov    0x806228,%eax
  803d66:	85 c0                	test   %eax,%eax
  803d68:	0f 84 64 02 00 00    	je     803fd2 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803d6e:	a1 28 62 80 00       	mov    0x806228,%eax
  803d73:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803d76:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d7a:	75 17                	jne    803d93 <alloc_block+0x199>
  803d7c:	83 ec 04             	sub    $0x4,%esp
  803d7f:	68 45 59 80 00       	push   $0x805945
  803d84:	68 a0 00 00 00       	push   $0xa0
  803d89:	68 ab 58 80 00       	push   $0x8058ab
  803d8e:	e8 d2 d6 ff ff       	call   801465 <_panic>
  803d93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d96:	8b 00                	mov    (%eax),%eax
  803d98:	85 c0                	test   %eax,%eax
  803d9a:	74 10                	je     803dac <alloc_block+0x1b2>
  803d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9f:	8b 00                	mov    (%eax),%eax
  803da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803da4:	8b 52 04             	mov    0x4(%edx),%edx
  803da7:	89 50 04             	mov    %edx,0x4(%eax)
  803daa:	eb 0b                	jmp    803db7 <alloc_block+0x1bd>
  803dac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803daf:	8b 40 04             	mov    0x4(%eax),%eax
  803db2:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803db7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dba:	8b 40 04             	mov    0x4(%eax),%eax
  803dbd:	85 c0                	test   %eax,%eax
  803dbf:	74 0f                	je     803dd0 <alloc_block+0x1d6>
  803dc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc4:	8b 40 04             	mov    0x4(%eax),%eax
  803dc7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dca:	8b 12                	mov    (%edx),%edx
  803dcc:	89 10                	mov    %edx,(%eax)
  803dce:	eb 0a                	jmp    803dda <alloc_block+0x1e0>
  803dd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd3:	8b 00                	mov    (%eax),%eax
  803dd5:	a3 28 62 80 00       	mov    %eax,0x806228
  803dda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ddd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ded:	a1 34 62 80 00       	mov    0x806234,%eax
  803df2:	48                   	dec    %eax
  803df3:	a3 34 62 80 00       	mov    %eax,0x806234

        page_info_e->block_size = pow;
  803df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dfe:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803e02:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e07:	99                   	cltd   
  803e08:	f7 7d e8             	idivl  -0x18(%ebp)
  803e0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e0e:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803e12:	83 ec 0c             	sub    $0xc,%esp
  803e15:	ff 75 dc             	pushl  -0x24(%ebp)
  803e18:	e8 ce fa ff ff       	call   8038eb <to_page_va>
  803e1d:	83 c4 10             	add    $0x10,%esp
  803e20:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803e23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e26:	83 ec 0c             	sub    $0xc,%esp
  803e29:	50                   	push   %eax
  803e2a:	e8 c0 ee ff ff       	call   802cef <get_page>
  803e2f:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803e32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803e39:	e9 aa 00 00 00       	jmp    803ee8 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e41:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803e45:	89 c2                	mov    %eax,%edx
  803e47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e4a:	01 d0                	add    %edx,%eax
  803e4c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803e4f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e53:	75 17                	jne    803e6c <alloc_block+0x272>
  803e55:	83 ec 04             	sub    $0x4,%esp
  803e58:	68 64 59 80 00       	push   $0x805964
  803e5d:	68 aa 00 00 00       	push   $0xaa
  803e62:	68 ab 58 80 00       	push   $0x8058ab
  803e67:	e8 f9 d5 ff ff       	call   801465 <_panic>
  803e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6f:	c1 e0 04             	shl    $0x4,%eax
  803e72:	05 64 e2 81 00       	add    $0x81e264,%eax
  803e77:	8b 10                	mov    (%eax),%edx
  803e79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7c:	89 50 04             	mov    %edx,0x4(%eax)
  803e7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e82:	8b 40 04             	mov    0x4(%eax),%eax
  803e85:	85 c0                	test   %eax,%eax
  803e87:	74 14                	je     803e9d <alloc_block+0x2a3>
  803e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8c:	c1 e0 04             	shl    $0x4,%eax
  803e8f:	05 64 e2 81 00       	add    $0x81e264,%eax
  803e94:	8b 00                	mov    (%eax),%eax
  803e96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e99:	89 10                	mov    %edx,(%eax)
  803e9b:	eb 11                	jmp    803eae <alloc_block+0x2b4>
  803e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea0:	c1 e0 04             	shl    $0x4,%eax
  803ea3:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  803ea9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eac:	89 02                	mov    %eax,(%edx)
  803eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb1:	c1 e0 04             	shl    $0x4,%eax
  803eb4:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803eba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ebd:	89 02                	mov    %eax,(%edx)
  803ebf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecb:	c1 e0 04             	shl    $0x4,%eax
  803ece:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ed3:	8b 00                	mov    (%eax),%eax
  803ed5:	8d 50 01             	lea    0x1(%eax),%edx
  803ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803edb:	c1 e0 04             	shl    $0x4,%eax
  803ede:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ee3:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803ee5:	ff 45 f4             	incl   -0xc(%ebp)
  803ee8:	b8 00 10 00 00       	mov    $0x1000,%eax
  803eed:	99                   	cltd   
  803eee:	f7 7d e8             	idivl  -0x18(%ebp)
  803ef1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803ef4:	0f 8f 44 ff ff ff    	jg     803e3e <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efd:	c1 e0 04             	shl    $0x4,%eax
  803f00:	05 60 e2 81 00       	add    $0x81e260,%eax
  803f05:	8b 00                	mov    (%eax),%eax
  803f07:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803f0a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f0e:	75 17                	jne    803f27 <alloc_block+0x32d>
  803f10:	83 ec 04             	sub    $0x4,%esp
  803f13:	68 45 59 80 00       	push   $0x805945
  803f18:	68 ae 00 00 00       	push   $0xae
  803f1d:	68 ab 58 80 00       	push   $0x8058ab
  803f22:	e8 3e d5 ff ff       	call   801465 <_panic>
  803f27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f2a:	8b 00                	mov    (%eax),%eax
  803f2c:	85 c0                	test   %eax,%eax
  803f2e:	74 10                	je     803f40 <alloc_block+0x346>
  803f30:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f33:	8b 00                	mov    (%eax),%eax
  803f35:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f38:	8b 52 04             	mov    0x4(%edx),%edx
  803f3b:	89 50 04             	mov    %edx,0x4(%eax)
  803f3e:	eb 14                	jmp    803f54 <alloc_block+0x35a>
  803f40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f43:	8b 40 04             	mov    0x4(%eax),%eax
  803f46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f49:	c1 e2 04             	shl    $0x4,%edx
  803f4c:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803f52:	89 02                	mov    %eax,(%edx)
  803f54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f57:	8b 40 04             	mov    0x4(%eax),%eax
  803f5a:	85 c0                	test   %eax,%eax
  803f5c:	74 0f                	je     803f6d <alloc_block+0x373>
  803f5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f61:	8b 40 04             	mov    0x4(%eax),%eax
  803f64:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f67:	8b 12                	mov    (%edx),%edx
  803f69:	89 10                	mov    %edx,(%eax)
  803f6b:	eb 13                	jmp    803f80 <alloc_block+0x386>
  803f6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f75:	c1 e2 04             	shl    $0x4,%edx
  803f78:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803f7e:	89 02                	mov    %eax,(%edx)
  803f80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f96:	c1 e0 04             	shl    $0x4,%eax
  803f99:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803f9e:	8b 00                	mov    (%eax),%eax
  803fa0:	8d 50 ff             	lea    -0x1(%eax),%edx
  803fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa6:	c1 e0 04             	shl    $0x4,%eax
  803fa9:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803fae:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803fb0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fb3:	83 ec 0c             	sub    $0xc,%esp
  803fb6:	50                   	push   %eax
  803fb7:	e8 a1 f9 ff ff       	call   80395d <to_page_info>
  803fbc:	83 c4 10             	add    $0x10,%esp
  803fbf:	89 c2                	mov    %eax,%edx
  803fc1:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803fc5:	48                   	dec    %eax
  803fc6:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fcd:	e9 1a 01 00 00       	jmp    8040ec <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd5:	40                   	inc    %eax
  803fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803fd9:	e9 ed 00 00 00       	jmp    8040cb <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe1:	c1 e0 04             	shl    $0x4,%eax
  803fe4:	05 60 e2 81 00       	add    $0x81e260,%eax
  803fe9:	8b 00                	mov    (%eax),%eax
  803feb:	85 c0                	test   %eax,%eax
  803fed:	0f 84 d5 00 00 00    	je     8040c8 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff6:	c1 e0 04             	shl    $0x4,%eax
  803ff9:	05 60 e2 81 00       	add    $0x81e260,%eax
  803ffe:	8b 00                	mov    (%eax),%eax
  804000:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  804003:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804007:	75 17                	jne    804020 <alloc_block+0x426>
  804009:	83 ec 04             	sub    $0x4,%esp
  80400c:	68 45 59 80 00       	push   $0x805945
  804011:	68 b8 00 00 00       	push   $0xb8
  804016:	68 ab 58 80 00       	push   $0x8058ab
  80401b:	e8 45 d4 ff ff       	call   801465 <_panic>
  804020:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804023:	8b 00                	mov    (%eax),%eax
  804025:	85 c0                	test   %eax,%eax
  804027:	74 10                	je     804039 <alloc_block+0x43f>
  804029:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80402c:	8b 00                	mov    (%eax),%eax
  80402e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804031:	8b 52 04             	mov    0x4(%edx),%edx
  804034:	89 50 04             	mov    %edx,0x4(%eax)
  804037:	eb 14                	jmp    80404d <alloc_block+0x453>
  804039:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80403c:	8b 40 04             	mov    0x4(%eax),%eax
  80403f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804042:	c1 e2 04             	shl    $0x4,%edx
  804045:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  80404b:	89 02                	mov    %eax,(%edx)
  80404d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804050:	8b 40 04             	mov    0x4(%eax),%eax
  804053:	85 c0                	test   %eax,%eax
  804055:	74 0f                	je     804066 <alloc_block+0x46c>
  804057:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80405a:	8b 40 04             	mov    0x4(%eax),%eax
  80405d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804060:	8b 12                	mov    (%edx),%edx
  804062:	89 10                	mov    %edx,(%eax)
  804064:	eb 13                	jmp    804079 <alloc_block+0x47f>
  804066:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804069:	8b 00                	mov    (%eax),%eax
  80406b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80406e:	c1 e2 04             	shl    $0x4,%edx
  804071:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  804077:	89 02                	mov    %eax,(%edx)
  804079:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80407c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804082:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804085:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80408c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80408f:	c1 e0 04             	shl    $0x4,%eax
  804092:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804097:	8b 00                	mov    (%eax),%eax
  804099:	8d 50 ff             	lea    -0x1(%eax),%edx
  80409c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409f:	c1 e0 04             	shl    $0x4,%eax
  8040a2:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8040a7:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8040a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040ac:	83 ec 0c             	sub    $0xc,%esp
  8040af:	50                   	push   %eax
  8040b0:	e8 a8 f8 ff ff       	call   80395d <to_page_info>
  8040b5:	83 c4 10             	add    $0x10,%esp
  8040b8:	89 c2                	mov    %eax,%edx
  8040ba:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8040be:	48                   	dec    %eax
  8040bf:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8040c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8040c6:	eb 24                	jmp    8040ec <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8040c8:	ff 45 f0             	incl   -0x10(%ebp)
  8040cb:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8040cf:	0f 8e 09 ff ff ff    	jle    803fde <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8040d5:	83 ec 04             	sub    $0x4,%esp
  8040d8:	68 87 59 80 00       	push   $0x805987
  8040dd:	68 bf 00 00 00       	push   $0xbf
  8040e2:	68 ab 58 80 00       	push   $0x8058ab
  8040e7:	e8 79 d3 ff ff       	call   801465 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8040ec:	c9                   	leave  
  8040ed:	c3                   	ret    

008040ee <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8040ee:	55                   	push   %ebp
  8040ef:	89 e5                	mov    %esp,%ebp
  8040f1:	83 ec 14             	sub    $0x14,%esp
  8040f4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8040f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040fb:	75 07                	jne    804104 <log2_ceil.1520+0x16>
  8040fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804102:	eb 1b                	jmp    80411f <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  804104:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  80410b:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80410e:	eb 06                	jmp    804116 <log2_ceil.1520+0x28>
            x >>= 1;
  804110:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  804113:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  804116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80411a:	75 f4                	jne    804110 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  80411c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80411f:	c9                   	leave  
  804120:	c3                   	ret    

00804121 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  804121:	55                   	push   %ebp
  804122:	89 e5                	mov    %esp,%ebp
  804124:	83 ec 14             	sub    $0x14,%esp
  804127:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80412a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80412e:	75 07                	jne    804137 <log2_ceil.1547+0x16>
  804130:	b8 00 00 00 00       	mov    $0x0,%eax
  804135:	eb 1b                	jmp    804152 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  804137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80413e:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  804141:	eb 06                	jmp    804149 <log2_ceil.1547+0x28>
			x >>= 1;
  804143:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  804146:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  804149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80414d:	75 f4                	jne    804143 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80414f:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  804152:	c9                   	leave  
  804153:	c3                   	ret    

00804154 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804154:	55                   	push   %ebp
  804155:	89 e5                	mov    %esp,%ebp
  804157:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80415a:	8b 55 08             	mov    0x8(%ebp),%edx
  80415d:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804162:	39 c2                	cmp    %eax,%edx
  804164:	72 0c                	jb     804172 <free_block+0x1e>
  804166:	8b 55 08             	mov    0x8(%ebp),%edx
  804169:	a1 20 62 80 00       	mov    0x806220,%eax
  80416e:	39 c2                	cmp    %eax,%edx
  804170:	72 19                	jb     80418b <free_block+0x37>
  804172:	68 8c 59 80 00       	push   $0x80598c
  804177:	68 0e 59 80 00       	push   $0x80590e
  80417c:	68 d0 00 00 00       	push   $0xd0
  804181:	68 ab 58 80 00       	push   $0x8058ab
  804186:	e8 da d2 ff ff       	call   801465 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80418b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80418f:	0f 84 42 03 00 00    	je     8044d7 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  804195:	8b 55 08             	mov    0x8(%ebp),%edx
  804198:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80419d:	39 c2                	cmp    %eax,%edx
  80419f:	72 0c                	jb     8041ad <free_block+0x59>
  8041a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8041a4:	a1 20 62 80 00       	mov    0x806220,%eax
  8041a9:	39 c2                	cmp    %eax,%edx
  8041ab:	72 17                	jb     8041c4 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8041ad:	83 ec 04             	sub    $0x4,%esp
  8041b0:	68 c4 59 80 00       	push   $0x8059c4
  8041b5:	68 e6 00 00 00       	push   $0xe6
  8041ba:	68 ab 58 80 00       	push   $0x8058ab
  8041bf:	e8 a1 d2 ff ff       	call   801465 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8041c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8041c7:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8041cc:	29 c2                	sub    %eax,%edx
  8041ce:	89 d0                	mov    %edx,%eax
  8041d0:	83 e0 07             	and    $0x7,%eax
  8041d3:	85 c0                	test   %eax,%eax
  8041d5:	74 17                	je     8041ee <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8041d7:	83 ec 04             	sub    $0x4,%esp
  8041da:	68 f8 59 80 00       	push   $0x8059f8
  8041df:	68 ea 00 00 00       	push   $0xea
  8041e4:	68 ab 58 80 00       	push   $0x8058ab
  8041e9:	e8 77 d2 ff ff       	call   801465 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8041ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f1:	83 ec 0c             	sub    $0xc,%esp
  8041f4:	50                   	push   %eax
  8041f5:	e8 63 f7 ff ff       	call   80395d <to_page_info>
  8041fa:	83 c4 10             	add    $0x10,%esp
  8041fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  804200:	83 ec 0c             	sub    $0xc,%esp
  804203:	ff 75 08             	pushl  0x8(%ebp)
  804206:	e8 87 f9 ff ff       	call   803b92 <get_block_size>
  80420b:	83 c4 10             	add    $0x10,%esp
  80420e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  804211:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804215:	75 17                	jne    80422e <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  804217:	83 ec 04             	sub    $0x4,%esp
  80421a:	68 24 5a 80 00       	push   $0x805a24
  80421f:	68 f1 00 00 00       	push   $0xf1
  804224:	68 ab 58 80 00       	push   $0x8058ab
  804229:	e8 37 d2 ff ff       	call   801465 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80422e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804231:	83 ec 0c             	sub    $0xc,%esp
  804234:	8d 45 d0             	lea    -0x30(%ebp),%eax
  804237:	52                   	push   %edx
  804238:	89 c1                	mov    %eax,%ecx
  80423a:	e8 e2 fe ff ff       	call   804121 <log2_ceil.1547>
  80423f:	83 c4 10             	add    $0x10,%esp
  804242:	83 e8 03             	sub    $0x3,%eax
  804245:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  804248:	8b 45 08             	mov    0x8(%ebp),%eax
  80424b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80424e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804252:	75 17                	jne    80426b <free_block+0x117>
  804254:	83 ec 04             	sub    $0x4,%esp
  804257:	68 70 5a 80 00       	push   $0x805a70
  80425c:	68 f6 00 00 00       	push   $0xf6
  804261:	68 ab 58 80 00       	push   $0x8058ab
  804266:	e8 fa d1 ff ff       	call   801465 <_panic>
  80426b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80426e:	c1 e0 04             	shl    $0x4,%eax
  804271:	05 60 e2 81 00       	add    $0x81e260,%eax
  804276:	8b 10                	mov    (%eax),%edx
  804278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80427b:	89 10                	mov    %edx,(%eax)
  80427d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804280:	8b 00                	mov    (%eax),%eax
  804282:	85 c0                	test   %eax,%eax
  804284:	74 15                	je     80429b <free_block+0x147>
  804286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804289:	c1 e0 04             	shl    $0x4,%eax
  80428c:	05 60 e2 81 00       	add    $0x81e260,%eax
  804291:	8b 00                	mov    (%eax),%eax
  804293:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804296:	89 50 04             	mov    %edx,0x4(%eax)
  804299:	eb 11                	jmp    8042ac <free_block+0x158>
  80429b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80429e:	c1 e0 04             	shl    $0x4,%eax
  8042a1:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  8042a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042aa:	89 02                	mov    %eax,(%edx)
  8042ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042af:	c1 e0 04             	shl    $0x4,%eax
  8042b2:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  8042b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042bb:	89 02                	mov    %eax,(%edx)
  8042bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042ca:	c1 e0 04             	shl    $0x4,%eax
  8042cd:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8042d2:	8b 00                	mov    (%eax),%eax
  8042d4:	8d 50 01             	lea    0x1(%eax),%edx
  8042d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042da:	c1 e0 04             	shl    $0x4,%eax
  8042dd:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8042e2:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8042e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042e7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8042eb:	40                   	inc    %eax
  8042ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8042ef:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8042f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8042f6:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8042fb:	29 c2                	sub    %eax,%edx
  8042fd:	89 d0                	mov    %edx,%eax
  8042ff:	c1 e8 0c             	shr    $0xc,%eax
  804302:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  804305:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804308:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80430c:	0f b7 c8             	movzwl %ax,%ecx
  80430f:	b8 00 10 00 00       	mov    $0x1000,%eax
  804314:	99                   	cltd   
  804315:	f7 7d e8             	idivl  -0x18(%ebp)
  804318:	39 c1                	cmp    %eax,%ecx
  80431a:	0f 85 b8 01 00 00    	jne    8044d8 <free_block+0x384>
    	uint32 blocks_removed = 0;
  804320:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  804327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80432a:	c1 e0 04             	shl    $0x4,%eax
  80432d:	05 60 e2 81 00       	add    $0x81e260,%eax
  804332:	8b 00                	mov    (%eax),%eax
  804334:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804337:	e9 d5 00 00 00       	jmp    804411 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80433c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433f:	8b 00                	mov    (%eax),%eax
  804341:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  804344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804347:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80434c:	29 c2                	sub    %eax,%edx
  80434e:	89 d0                	mov    %edx,%eax
  804350:	c1 e8 0c             	shr    $0xc,%eax
  804353:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  804356:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804359:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80435c:	0f 85 a9 00 00 00    	jne    80440b <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  804362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804366:	75 17                	jne    80437f <free_block+0x22b>
  804368:	83 ec 04             	sub    $0x4,%esp
  80436b:	68 45 59 80 00       	push   $0x805945
  804370:	68 04 01 00 00       	push   $0x104
  804375:	68 ab 58 80 00       	push   $0x8058ab
  80437a:	e8 e6 d0 ff ff       	call   801465 <_panic>
  80437f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804382:	8b 00                	mov    (%eax),%eax
  804384:	85 c0                	test   %eax,%eax
  804386:	74 10                	je     804398 <free_block+0x244>
  804388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80438b:	8b 00                	mov    (%eax),%eax
  80438d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804390:	8b 52 04             	mov    0x4(%edx),%edx
  804393:	89 50 04             	mov    %edx,0x4(%eax)
  804396:	eb 14                	jmp    8043ac <free_block+0x258>
  804398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80439b:	8b 40 04             	mov    0x4(%eax),%eax
  80439e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043a1:	c1 e2 04             	shl    $0x4,%edx
  8043a4:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8043aa:	89 02                	mov    %eax,(%edx)
  8043ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043af:	8b 40 04             	mov    0x4(%eax),%eax
  8043b2:	85 c0                	test   %eax,%eax
  8043b4:	74 0f                	je     8043c5 <free_block+0x271>
  8043b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b9:	8b 40 04             	mov    0x4(%eax),%eax
  8043bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043bf:	8b 12                	mov    (%edx),%edx
  8043c1:	89 10                	mov    %edx,(%eax)
  8043c3:	eb 13                	jmp    8043d8 <free_block+0x284>
  8043c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c8:	8b 00                	mov    (%eax),%eax
  8043ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043cd:	c1 e2 04             	shl    $0x4,%edx
  8043d0:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  8043d6:	89 02                	mov    %eax,(%edx)
  8043d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ee:	c1 e0 04             	shl    $0x4,%eax
  8043f1:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8043f6:	8b 00                	mov    (%eax),%eax
  8043f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8043fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043fe:	c1 e0 04             	shl    $0x4,%eax
  804401:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804406:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804408:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  80440b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80440e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804415:	0f 85 21 ff ff ff    	jne    80433c <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80441b:	b8 00 10 00 00       	mov    $0x1000,%eax
  804420:	99                   	cltd   
  804421:	f7 7d e8             	idivl  -0x18(%ebp)
  804424:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804427:	74 17                	je     804440 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  804429:	83 ec 04             	sub    $0x4,%esp
  80442c:	68 94 5a 80 00       	push   $0x805a94
  804431:	68 0c 01 00 00       	push   $0x10c
  804436:	68 ab 58 80 00       	push   $0x8058ab
  80443b:	e8 25 d0 ff ff       	call   801465 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  804440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804443:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  804449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80444c:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  804452:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804456:	75 17                	jne    80446f <free_block+0x31b>
  804458:	83 ec 04             	sub    $0x4,%esp
  80445b:	68 64 59 80 00       	push   $0x805964
  804460:	68 11 01 00 00       	push   $0x111
  804465:	68 ab 58 80 00       	push   $0x8058ab
  80446a:	e8 f6 cf ff ff       	call   801465 <_panic>
  80446f:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  804475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804478:	89 50 04             	mov    %edx,0x4(%eax)
  80447b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80447e:	8b 40 04             	mov    0x4(%eax),%eax
  804481:	85 c0                	test   %eax,%eax
  804483:	74 0c                	je     804491 <free_block+0x33d>
  804485:	a1 2c 62 80 00       	mov    0x80622c,%eax
  80448a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80448d:	89 10                	mov    %edx,(%eax)
  80448f:	eb 08                	jmp    804499 <free_block+0x345>
  804491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804494:	a3 28 62 80 00       	mov    %eax,0x806228
  804499:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80449c:	a3 2c 62 80 00       	mov    %eax,0x80622c
  8044a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044aa:	a1 34 62 80 00       	mov    0x806234,%eax
  8044af:	40                   	inc    %eax
  8044b0:	a3 34 62 80 00       	mov    %eax,0x806234

        uint32 pp = to_page_va(page_info_e);
  8044b5:	83 ec 0c             	sub    $0xc,%esp
  8044b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8044bb:	e8 2b f4 ff ff       	call   8038eb <to_page_va>
  8044c0:	83 c4 10             	add    $0x10,%esp
  8044c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8044c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8044c9:	83 ec 0c             	sub    $0xc,%esp
  8044cc:	50                   	push   %eax
  8044cd:	e8 69 e8 ff ff       	call   802d3b <return_page>
  8044d2:	83 c4 10             	add    $0x10,%esp
  8044d5:	eb 01                	jmp    8044d8 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8044d7:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8044d8:	c9                   	leave  
  8044d9:	c3                   	ret    

008044da <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8044da:	55                   	push   %ebp
  8044db:	89 e5                	mov    %esp,%ebp
  8044dd:	83 ec 14             	sub    $0x14,%esp
  8044e0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8044e3:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8044e7:	77 07                	ja     8044f0 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8044e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8044ee:	eb 20                	jmp    804510 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8044f0:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8044f7:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8044fa:	eb 08                	jmp    804504 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8044fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8044ff:	01 c0                	add    %eax,%eax
  804501:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  804504:	d1 6d 08             	shrl   0x8(%ebp)
  804507:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80450b:	75 ef                	jne    8044fc <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80450d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  804510:	c9                   	leave  
  804511:	c3                   	ret    

00804512 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  804512:	55                   	push   %ebp
  804513:	89 e5                	mov    %esp,%ebp
  804515:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  804518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80451c:	75 13                	jne    804531 <realloc_block+0x1f>
    return alloc_block(new_size);
  80451e:	83 ec 0c             	sub    $0xc,%esp
  804521:	ff 75 0c             	pushl  0xc(%ebp)
  804524:	e8 d1 f6 ff ff       	call   803bfa <alloc_block>
  804529:	83 c4 10             	add    $0x10,%esp
  80452c:	e9 d9 00 00 00       	jmp    80460a <realloc_block+0xf8>
  }

  if (new_size == 0) {
  804531:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804535:	75 18                	jne    80454f <realloc_block+0x3d>
    free_block(va);
  804537:	83 ec 0c             	sub    $0xc,%esp
  80453a:	ff 75 08             	pushl  0x8(%ebp)
  80453d:	e8 12 fc ff ff       	call   804154 <free_block>
  804542:	83 c4 10             	add    $0x10,%esp
    return NULL;
  804545:	b8 00 00 00 00       	mov    $0x0,%eax
  80454a:	e9 bb 00 00 00       	jmp    80460a <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80454f:	83 ec 0c             	sub    $0xc,%esp
  804552:	ff 75 08             	pushl  0x8(%ebp)
  804555:	e8 38 f6 ff ff       	call   803b92 <get_block_size>
  80455a:	83 c4 10             	add    $0x10,%esp
  80455d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  804560:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80456a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80456d:	73 06                	jae    804575 <realloc_block+0x63>
    new_size = min_block_size;
  80456f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804572:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  804575:	83 ec 0c             	sub    $0xc,%esp
  804578:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80457b:	ff 75 0c             	pushl  0xc(%ebp)
  80457e:	89 c1                	mov    %eax,%ecx
  804580:	e8 55 ff ff ff       	call   8044da <nearest_pow2_ceil.1572>
  804585:	83 c4 10             	add    $0x10,%esp
  804588:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80458b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80458e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804591:	75 05                	jne    804598 <realloc_block+0x86>
    return va;
  804593:	8b 45 08             	mov    0x8(%ebp),%eax
  804596:	eb 72                	jmp    80460a <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  804598:	83 ec 0c             	sub    $0xc,%esp
  80459b:	ff 75 0c             	pushl  0xc(%ebp)
  80459e:	e8 57 f6 ff ff       	call   803bfa <alloc_block>
  8045a3:	83 c4 10             	add    $0x10,%esp
  8045a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8045a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045ad:	75 07                	jne    8045b6 <realloc_block+0xa4>
    return NULL;
  8045af:	b8 00 00 00 00       	mov    $0x0,%eax
  8045b4:	eb 54                	jmp    80460a <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8045b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045bc:	39 d0                	cmp    %edx,%eax
  8045be:	76 02                	jbe    8045c2 <realloc_block+0xb0>
  8045c0:	89 d0                	mov    %edx,%eax
  8045c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8045c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8045cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8045d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8045d8:	eb 17                	jmp    8045f1 <realloc_block+0xdf>
    dst[i] = src[i];
  8045da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e0:	01 c2                	add    %eax,%edx
  8045e2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8045e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e8:	01 c8                	add    %ecx,%eax
  8045ea:	8a 00                	mov    (%eax),%al
  8045ec:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8045ee:	ff 45 f4             	incl   -0xc(%ebp)
  8045f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8045f7:	72 e1                	jb     8045da <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8045f9:	83 ec 0c             	sub    $0xc,%esp
  8045fc:	ff 75 08             	pushl  0x8(%ebp)
  8045ff:	e8 50 fb ff ff       	call   804154 <free_block>
  804604:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80460a:	c9                   	leave  
  80460b:	c3                   	ret    

0080460c <__udivdi3>:
  80460c:	55                   	push   %ebp
  80460d:	57                   	push   %edi
  80460e:	56                   	push   %esi
  80460f:	53                   	push   %ebx
  804610:	83 ec 1c             	sub    $0x1c,%esp
  804613:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804617:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80461b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80461f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804623:	89 ca                	mov    %ecx,%edx
  804625:	89 f8                	mov    %edi,%eax
  804627:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80462b:	85 f6                	test   %esi,%esi
  80462d:	75 2d                	jne    80465c <__udivdi3+0x50>
  80462f:	39 cf                	cmp    %ecx,%edi
  804631:	77 65                	ja     804698 <__udivdi3+0x8c>
  804633:	89 fd                	mov    %edi,%ebp
  804635:	85 ff                	test   %edi,%edi
  804637:	75 0b                	jne    804644 <__udivdi3+0x38>
  804639:	b8 01 00 00 00       	mov    $0x1,%eax
  80463e:	31 d2                	xor    %edx,%edx
  804640:	f7 f7                	div    %edi
  804642:	89 c5                	mov    %eax,%ebp
  804644:	31 d2                	xor    %edx,%edx
  804646:	89 c8                	mov    %ecx,%eax
  804648:	f7 f5                	div    %ebp
  80464a:	89 c1                	mov    %eax,%ecx
  80464c:	89 d8                	mov    %ebx,%eax
  80464e:	f7 f5                	div    %ebp
  804650:	89 cf                	mov    %ecx,%edi
  804652:	89 fa                	mov    %edi,%edx
  804654:	83 c4 1c             	add    $0x1c,%esp
  804657:	5b                   	pop    %ebx
  804658:	5e                   	pop    %esi
  804659:	5f                   	pop    %edi
  80465a:	5d                   	pop    %ebp
  80465b:	c3                   	ret    
  80465c:	39 ce                	cmp    %ecx,%esi
  80465e:	77 28                	ja     804688 <__udivdi3+0x7c>
  804660:	0f bd fe             	bsr    %esi,%edi
  804663:	83 f7 1f             	xor    $0x1f,%edi
  804666:	75 40                	jne    8046a8 <__udivdi3+0x9c>
  804668:	39 ce                	cmp    %ecx,%esi
  80466a:	72 0a                	jb     804676 <__udivdi3+0x6a>
  80466c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804670:	0f 87 9e 00 00 00    	ja     804714 <__udivdi3+0x108>
  804676:	b8 01 00 00 00       	mov    $0x1,%eax
  80467b:	89 fa                	mov    %edi,%edx
  80467d:	83 c4 1c             	add    $0x1c,%esp
  804680:	5b                   	pop    %ebx
  804681:	5e                   	pop    %esi
  804682:	5f                   	pop    %edi
  804683:	5d                   	pop    %ebp
  804684:	c3                   	ret    
  804685:	8d 76 00             	lea    0x0(%esi),%esi
  804688:	31 ff                	xor    %edi,%edi
  80468a:	31 c0                	xor    %eax,%eax
  80468c:	89 fa                	mov    %edi,%edx
  80468e:	83 c4 1c             	add    $0x1c,%esp
  804691:	5b                   	pop    %ebx
  804692:	5e                   	pop    %esi
  804693:	5f                   	pop    %edi
  804694:	5d                   	pop    %ebp
  804695:	c3                   	ret    
  804696:	66 90                	xchg   %ax,%ax
  804698:	89 d8                	mov    %ebx,%eax
  80469a:	f7 f7                	div    %edi
  80469c:	31 ff                	xor    %edi,%edi
  80469e:	89 fa                	mov    %edi,%edx
  8046a0:	83 c4 1c             	add    $0x1c,%esp
  8046a3:	5b                   	pop    %ebx
  8046a4:	5e                   	pop    %esi
  8046a5:	5f                   	pop    %edi
  8046a6:	5d                   	pop    %ebp
  8046a7:	c3                   	ret    
  8046a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046ad:	89 eb                	mov    %ebp,%ebx
  8046af:	29 fb                	sub    %edi,%ebx
  8046b1:	89 f9                	mov    %edi,%ecx
  8046b3:	d3 e6                	shl    %cl,%esi
  8046b5:	89 c5                	mov    %eax,%ebp
  8046b7:	88 d9                	mov    %bl,%cl
  8046b9:	d3 ed                	shr    %cl,%ebp
  8046bb:	89 e9                	mov    %ebp,%ecx
  8046bd:	09 f1                	or     %esi,%ecx
  8046bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046c3:	89 f9                	mov    %edi,%ecx
  8046c5:	d3 e0                	shl    %cl,%eax
  8046c7:	89 c5                	mov    %eax,%ebp
  8046c9:	89 d6                	mov    %edx,%esi
  8046cb:	88 d9                	mov    %bl,%cl
  8046cd:	d3 ee                	shr    %cl,%esi
  8046cf:	89 f9                	mov    %edi,%ecx
  8046d1:	d3 e2                	shl    %cl,%edx
  8046d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046d7:	88 d9                	mov    %bl,%cl
  8046d9:	d3 e8                	shr    %cl,%eax
  8046db:	09 c2                	or     %eax,%edx
  8046dd:	89 d0                	mov    %edx,%eax
  8046df:	89 f2                	mov    %esi,%edx
  8046e1:	f7 74 24 0c          	divl   0xc(%esp)
  8046e5:	89 d6                	mov    %edx,%esi
  8046e7:	89 c3                	mov    %eax,%ebx
  8046e9:	f7 e5                	mul    %ebp
  8046eb:	39 d6                	cmp    %edx,%esi
  8046ed:	72 19                	jb     804708 <__udivdi3+0xfc>
  8046ef:	74 0b                	je     8046fc <__udivdi3+0xf0>
  8046f1:	89 d8                	mov    %ebx,%eax
  8046f3:	31 ff                	xor    %edi,%edi
  8046f5:	e9 58 ff ff ff       	jmp    804652 <__udivdi3+0x46>
  8046fa:	66 90                	xchg   %ax,%ax
  8046fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  804700:	89 f9                	mov    %edi,%ecx
  804702:	d3 e2                	shl    %cl,%edx
  804704:	39 c2                	cmp    %eax,%edx
  804706:	73 e9                	jae    8046f1 <__udivdi3+0xe5>
  804708:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80470b:	31 ff                	xor    %edi,%edi
  80470d:	e9 40 ff ff ff       	jmp    804652 <__udivdi3+0x46>
  804712:	66 90                	xchg   %ax,%ax
  804714:	31 c0                	xor    %eax,%eax
  804716:	e9 37 ff ff ff       	jmp    804652 <__udivdi3+0x46>
  80471b:	90                   	nop

0080471c <__umoddi3>:
  80471c:	55                   	push   %ebp
  80471d:	57                   	push   %edi
  80471e:	56                   	push   %esi
  80471f:	53                   	push   %ebx
  804720:	83 ec 1c             	sub    $0x1c,%esp
  804723:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804727:	8b 74 24 34          	mov    0x34(%esp),%esi
  80472b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80472f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804733:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804737:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80473b:	89 f3                	mov    %esi,%ebx
  80473d:	89 fa                	mov    %edi,%edx
  80473f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804743:	89 34 24             	mov    %esi,(%esp)
  804746:	85 c0                	test   %eax,%eax
  804748:	75 1a                	jne    804764 <__umoddi3+0x48>
  80474a:	39 f7                	cmp    %esi,%edi
  80474c:	0f 86 a2 00 00 00    	jbe    8047f4 <__umoddi3+0xd8>
  804752:	89 c8                	mov    %ecx,%eax
  804754:	89 f2                	mov    %esi,%edx
  804756:	f7 f7                	div    %edi
  804758:	89 d0                	mov    %edx,%eax
  80475a:	31 d2                	xor    %edx,%edx
  80475c:	83 c4 1c             	add    $0x1c,%esp
  80475f:	5b                   	pop    %ebx
  804760:	5e                   	pop    %esi
  804761:	5f                   	pop    %edi
  804762:	5d                   	pop    %ebp
  804763:	c3                   	ret    
  804764:	39 f0                	cmp    %esi,%eax
  804766:	0f 87 ac 00 00 00    	ja     804818 <__umoddi3+0xfc>
  80476c:	0f bd e8             	bsr    %eax,%ebp
  80476f:	83 f5 1f             	xor    $0x1f,%ebp
  804772:	0f 84 ac 00 00 00    	je     804824 <__umoddi3+0x108>
  804778:	bf 20 00 00 00       	mov    $0x20,%edi
  80477d:	29 ef                	sub    %ebp,%edi
  80477f:	89 fe                	mov    %edi,%esi
  804781:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804785:	89 e9                	mov    %ebp,%ecx
  804787:	d3 e0                	shl    %cl,%eax
  804789:	89 d7                	mov    %edx,%edi
  80478b:	89 f1                	mov    %esi,%ecx
  80478d:	d3 ef                	shr    %cl,%edi
  80478f:	09 c7                	or     %eax,%edi
  804791:	89 e9                	mov    %ebp,%ecx
  804793:	d3 e2                	shl    %cl,%edx
  804795:	89 14 24             	mov    %edx,(%esp)
  804798:	89 d8                	mov    %ebx,%eax
  80479a:	d3 e0                	shl    %cl,%eax
  80479c:	89 c2                	mov    %eax,%edx
  80479e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047a2:	d3 e0                	shl    %cl,%eax
  8047a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047ac:	89 f1                	mov    %esi,%ecx
  8047ae:	d3 e8                	shr    %cl,%eax
  8047b0:	09 d0                	or     %edx,%eax
  8047b2:	d3 eb                	shr    %cl,%ebx
  8047b4:	89 da                	mov    %ebx,%edx
  8047b6:	f7 f7                	div    %edi
  8047b8:	89 d3                	mov    %edx,%ebx
  8047ba:	f7 24 24             	mull   (%esp)
  8047bd:	89 c6                	mov    %eax,%esi
  8047bf:	89 d1                	mov    %edx,%ecx
  8047c1:	39 d3                	cmp    %edx,%ebx
  8047c3:	0f 82 87 00 00 00    	jb     804850 <__umoddi3+0x134>
  8047c9:	0f 84 91 00 00 00    	je     804860 <__umoddi3+0x144>
  8047cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047d3:	29 f2                	sub    %esi,%edx
  8047d5:	19 cb                	sbb    %ecx,%ebx
  8047d7:	89 d8                	mov    %ebx,%eax
  8047d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047dd:	d3 e0                	shl    %cl,%eax
  8047df:	89 e9                	mov    %ebp,%ecx
  8047e1:	d3 ea                	shr    %cl,%edx
  8047e3:	09 d0                	or     %edx,%eax
  8047e5:	89 e9                	mov    %ebp,%ecx
  8047e7:	d3 eb                	shr    %cl,%ebx
  8047e9:	89 da                	mov    %ebx,%edx
  8047eb:	83 c4 1c             	add    $0x1c,%esp
  8047ee:	5b                   	pop    %ebx
  8047ef:	5e                   	pop    %esi
  8047f0:	5f                   	pop    %edi
  8047f1:	5d                   	pop    %ebp
  8047f2:	c3                   	ret    
  8047f3:	90                   	nop
  8047f4:	89 fd                	mov    %edi,%ebp
  8047f6:	85 ff                	test   %edi,%edi
  8047f8:	75 0b                	jne    804805 <__umoddi3+0xe9>
  8047fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8047ff:	31 d2                	xor    %edx,%edx
  804801:	f7 f7                	div    %edi
  804803:	89 c5                	mov    %eax,%ebp
  804805:	89 f0                	mov    %esi,%eax
  804807:	31 d2                	xor    %edx,%edx
  804809:	f7 f5                	div    %ebp
  80480b:	89 c8                	mov    %ecx,%eax
  80480d:	f7 f5                	div    %ebp
  80480f:	89 d0                	mov    %edx,%eax
  804811:	e9 44 ff ff ff       	jmp    80475a <__umoddi3+0x3e>
  804816:	66 90                	xchg   %ax,%ax
  804818:	89 c8                	mov    %ecx,%eax
  80481a:	89 f2                	mov    %esi,%edx
  80481c:	83 c4 1c             	add    $0x1c,%esp
  80481f:	5b                   	pop    %ebx
  804820:	5e                   	pop    %esi
  804821:	5f                   	pop    %edi
  804822:	5d                   	pop    %ebp
  804823:	c3                   	ret    
  804824:	3b 04 24             	cmp    (%esp),%eax
  804827:	72 06                	jb     80482f <__umoddi3+0x113>
  804829:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80482d:	77 0f                	ja     80483e <__umoddi3+0x122>
  80482f:	89 f2                	mov    %esi,%edx
  804831:	29 f9                	sub    %edi,%ecx
  804833:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804837:	89 14 24             	mov    %edx,(%esp)
  80483a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80483e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804842:	8b 14 24             	mov    (%esp),%edx
  804845:	83 c4 1c             	add    $0x1c,%esp
  804848:	5b                   	pop    %ebx
  804849:	5e                   	pop    %esi
  80484a:	5f                   	pop    %edi
  80484b:	5d                   	pop    %ebp
  80484c:	c3                   	ret    
  80484d:	8d 76 00             	lea    0x0(%esi),%esi
  804850:	2b 04 24             	sub    (%esp),%eax
  804853:	19 fa                	sbb    %edi,%edx
  804855:	89 d1                	mov    %edx,%ecx
  804857:	89 c6                	mov    %eax,%esi
  804859:	e9 71 ff ff ff       	jmp    8047cf <__umoddi3+0xb3>
  80485e:	66 90                	xchg   %ax,%ax
  804860:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804864:	72 ea                	jb     804850 <__umoddi3+0x134>
  804866:	89 d9                	mov    %ebx,%ecx
  804868:	e9 62 ff ff ff       	jmp    8047cf <__umoddi3+0xb3>
