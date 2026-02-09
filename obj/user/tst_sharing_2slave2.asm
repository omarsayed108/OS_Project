
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 9d 13 00 00       	call   8013d3 <libmain>
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
  800067:	e8 11 35 00 00       	call   80357d <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 54 35 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 d5 2d 00 00       	call   802e9c <malloc>
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
  8000df:	e8 99 34 00 00       	call   80357d <sys_calculate_free_frames>
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
  800125:	68 a0 49 80 00       	push   $0x8049a0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 6d 17 00 00       	call   80189e <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 8f 34 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 1c 4a 80 00       	push   $0x804a1c
  800150:	6a 0c                	push   $0xc
  800152:	e8 47 17 00 00       	call   80189e <cprintf_colored>
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
  800174:	e8 04 34 00 00       	call   80357d <sys_calculate_free_frames>
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
  8001b9:	e8 bf 33 00 00       	call   80357d <sys_calculate_free_frames>
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
  8001f8:	68 94 4a 80 00       	push   $0x804a94
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 9a 16 00 00       	call   80189e <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 bc 33 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 20 4b 80 00       	push   $0x804b20
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 6d 16 00 00       	call   80189e <cprintf_colored>
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
  800270:	e8 ca 36 00 00       	call   80393f <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 98 4b 80 00       	push   $0x804b98
  80028f:	6a 0c                	push   $0xc
  800291:	e8 08 16 00 00       	call   80189e <cprintf_colored>
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
  8002ae:	e8 ca 32 00 00       	call   80357d <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 0d 33 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 4f 2d 00 00       	call   803020 <free>
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
  8002fc:	e8 c7 32 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 d0 4b 80 00       	push   $0x804bd0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 7f 15 00 00       	call   80189e <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp

	int actualNumOfFrames = (sys_calculate_free_frames() - freeFrames) ;
  800322:	e8 56 32 00 00       	call   80357d <sys_calculate_free_frames>
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
  80035f:	68 1c 4c 80 00       	push   $0x804c1c
  800364:	6a 0c                	push   $0xc
  800366:	e8 33 15 00 00       	call   80189e <cprintf_colored>
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
  8003bd:	e8 7d 35 00 00       	call   80393f <sys_check_WS_list>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	83 f8 01             	cmp    $0x1,%eax
  8003c8:	74 1c                	je     8003e6 <freeSpaceInPageAlloc+0x145>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 08             	pushl  0x8(%ebp)
  8003d7:	68 78 4c 80 00       	push   $0x804c78
  8003dc:	6a 0c                	push   $0xc
  8003de:	e8 bb 14 00 00       	call   80189e <cprintf_colored>
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
  800433:	68 b0 4c 80 00       	push   $0x804cb0
  800438:	6a 03                	push   $0x3
  80043a:	e8 5f 14 00 00       	call   80189e <cprintf_colored>
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
  8004fc:	68 e0 4c 80 00       	push   $0x804ce0
  800501:	6a 0c                	push   $0xc
  800503:	e8 96 13 00 00       	call   80189e <cprintf_colored>
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
  8005d6:	68 e0 4c 80 00       	push   $0x804ce0
  8005db:	6a 0c                	push   $0xc
  8005dd:	e8 bc 12 00 00       	call   80189e <cprintf_colored>
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
  8006b0:	68 e0 4c 80 00       	push   $0x804ce0
  8006b5:	6a 0c                	push   $0xc
  8006b7:	e8 e2 11 00 00       	call   80189e <cprintf_colored>
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
  80078a:	68 e0 4c 80 00       	push   $0x804ce0
  80078f:	6a 0c                	push   $0xc
  800791:	e8 08 11 00 00       	call   80189e <cprintf_colored>
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
  800864:	68 e0 4c 80 00       	push   $0x804ce0
  800869:	6a 0c                	push   $0xc
  80086b:	e8 2e 10 00 00       	call   80189e <cprintf_colored>
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
  80093e:	68 e0 4c 80 00       	push   $0x804ce0
  800943:	6a 0c                	push   $0xc
  800945:	e8 54 0f 00 00       	call   80189e <cprintf_colored>
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
  800a33:	68 e0 4c 80 00       	push   $0x804ce0
  800a38:	6a 0c                	push   $0xc
  800a3a:	e8 5f 0e 00 00       	call   80189e <cprintf_colored>
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
  800b31:	68 e0 4c 80 00       	push   $0x804ce0
  800b36:	6a 0c                	push   $0xc
  800b38:	e8 61 0d 00 00       	call   80189e <cprintf_colored>
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
  800c2f:	68 e0 4c 80 00       	push   $0x804ce0
  800c34:	6a 0c                	push   $0xc
  800c36:	e8 63 0c 00 00       	call   80189e <cprintf_colored>
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
  800d2d:	68 e0 4c 80 00       	push   $0x804ce0
  800d32:	6a 0c                	push   $0xc
  800d34:	e8 65 0b 00 00       	call   80189e <cprintf_colored>
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
  800e1a:	68 e0 4c 80 00       	push   $0x804ce0
  800e1f:	6a 0c                	push   $0xc
  800e21:	e8 78 0a 00 00       	call   80189e <cprintf_colored>
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
  800f07:	68 e0 4c 80 00       	push   $0x804ce0
  800f0c:	6a 0c                	push   $0xc
  800f0e:	e8 8b 09 00 00       	call   80189e <cprintf_colored>
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
  800ff4:	68 e0 4c 80 00       	push   $0x804ce0
  800ff9:	6a 0c                	push   $0xc
  800ffb:	e8 9e 08 00 00       	call   80189e <cprintf_colored>
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
  801017:	68 32 4d 80 00       	push   $0x804d32
  80101c:	6a 03                	push   $0x3
  80101e:	e8 7b 08 00 00       	call   80189e <cprintf_colored>
  801023:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801026:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  80102d:	00 00 00 
		expectedVA = 0;
  801030:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  801037:	e8 41 25 00 00       	call   80357d <sys_calculate_free_frames>
  80103c:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801042:	e8 81 25 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
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
  801072:	e8 25 1e 00 00       	call   802e9c <malloc>
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
  8010a1:	68 50 4d 80 00       	push   $0x804d50
  8010a6:	6a 0c                	push   $0xc
  8010a8:	e8 f1 07 00 00       	call   80189e <cprintf_colored>
  8010ad:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  8010b0:	e8 13 25 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  8010b5:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  8010bb:	74 1f                	je     8010dc <initial_page_allocations+0xcf1>
  8010bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010c4:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	50                   	push   %eax
  8010cd:	68 8c 4d 80 00       	push   $0x804d8c
  8010d2:	6a 0c                	push   $0xc
  8010d4:	e8 c5 07 00 00       	call   80189e <cprintf_colored>
  8010d9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010dc:	e8 9c 24 00 00       	call   80357d <sys_calculate_free_frames>
  8010e1:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010e7:	74 1f                	je     801108 <initial_page_allocations+0xd1d>
  8010e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f0:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	50                   	push   %eax
  8010f9:	68 fc 4d 80 00       	push   $0x804dfc
  8010fe:	6a 0c                	push   $0xc
  801100:	e8 99 07 00 00       	call   80189e <cprintf_colored>
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
#include <user/tst_malloc_helpers.h>
extern volatile bool printStats;

void
_main(void)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
  801121:	83 ec 30             	sub    $0x30,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801124:	a1 00 62 80 00       	mov    0x806200,%eax
  801129:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80112f:	a1 00 62 80 00       	mov    0x806200,%eax
  801134:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	72 14                	jb     801152 <_main+0x36>
			panic("Please increase the WS size");
  80113e:	83 ec 04             	sub    $0x4,%esp
  801141:	68 44 4e 80 00       	push   $0x804e44
  801146:	6a 0f                	push   $0xf
  801148:	68 60 4e 80 00       	push   $0x804e60
  80114d:	e8 31 04 00 00       	call   801583 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801152:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  801159:	e8 01 26 00 00       	call   80375f <sys_getparentenvid>
  80115e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int diff, expected;
	int freeFrames, usedDiskPages ;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_lock_cons();
  801161:	e8 67 23 00 00       	call   8034cd <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801166:	e8 12 24 00 00       	call   80357d <sys_calculate_free_frames>
  80116b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80116e:	e8 55 24 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  801173:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = sget(parentenvID,"z");
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	68 7b 4e 80 00       	push   $0x804e7b
  80117e:	ff 75 f0             	pushl  -0x10(%ebp)
  801181:	e8 36 21 00 00       	call   8032bc <sget>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  801192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801195:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801198:	74 1a                	je     8011b4 <_main+0x98>
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8011a3:	68 80 4e 80 00       	push   $0x804e80
  8011a8:	6a 26                	push   $0x26
  8011aa:	68 60 4e 80 00       	push   $0x804e60
  8011af:	e8 cf 03 00 00       	call   801583 <_panic>
		expected = 1 ; /* 1 table in UH*/
  8011b4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8011bb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8011be:	e8 ba 23 00 00       	call   80357d <sys_calculate_free_frames>
  8011c3:	29 c3                	sub    %eax,%ebx
  8011c5:	89 d8                	mov    %ebx,%eax
  8011c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  8011ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011cd:	83 c0 02             	add    $0x2,%eax
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	50                   	push   %eax
  8011d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8011d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8011da:	e8 59 ee ff ff       	call   800038 <inRange>
  8011df:	83 c4 10             	add    $0x10,%esp
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	75 2b                	jne    801211 <_main+0xf5>
			panic("Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +2);
  8011e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011e9:	8d 58 02             	lea    0x2(%eax),%ebx
  8011ec:	8b 75 ec             	mov    -0x14(%ebp),%esi
  8011ef:	e8 89 23 00 00       	call   80357d <sys_calculate_free_frames>
  8011f4:	29 c6                	sub    %eax,%esi
  8011f6:	89 f0                	mov    %esi,%eax
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	53                   	push   %ebx
  8011fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8011ff:	50                   	push   %eax
  801200:	68 fc 4e 80 00       	push   $0x804efc
  801205:	6a 2a                	push   $0x2a
  801207:	68 60 4e 80 00       	push   $0x804e60
  80120c:	e8 72 03 00 00       	call   801583 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801211:	e8 b2 23 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  801216:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801219:	74 14                	je     80122f <_main+0x113>
		{panic("Wrong page file allocation: ");}
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	68 9a 4f 80 00       	push   $0x804f9a
  801223:	6a 2c                	push   $0x2c
  801225:	68 60 4e 80 00       	push   $0x804e60
  80122a:	e8 54 03 00 00       	call   801583 <_panic>
	}
	sys_unlock_cons();
  80122f:	e8 b3 22 00 00       	call   8034e7 <sys_unlock_cons>

	sys_lock_cons();
  801234:	e8 94 22 00 00       	call   8034cd <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  801239:	e8 3f 23 00 00       	call   80357d <sys_calculate_free_frames>
  80123e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801241:	e8 82 23 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  801246:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = sget(parentenvID,"x");
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	68 b7 4f 80 00       	push   $0x804fb7
  801251:	ff 75 f0             	pushl  -0x10(%ebp)
  801254:	e8 63 20 00 00       	call   8032bc <sget>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  80125f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801262:	05 00 10 00 00       	add    $0x1000,%eax
  801267:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  80126a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80126d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801270:	74 1a                	je     80128c <_main+0x170>
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	ff 75 d4             	pushl  -0x2c(%ebp)
  801278:	ff 75 e0             	pushl  -0x20(%ebp)
  80127b:	68 80 4e 80 00       	push   $0x804e80
  801280:	6a 36                	push   $0x36
  801282:	68 60 4e 80 00       	push   $0x804e60
  801287:	e8 f7 02 00 00       	call   801583 <_panic>
		expected = 0;
  80128c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  801293:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  801296:	e8 e2 22 00 00       	call   80357d <sys_calculate_free_frames>
  80129b:	29 c3                	sub    %eax,%ebx
  80129d:	89 d8                	mov    %ebx,%eax
  80129f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8012a2:	83 ec 04             	sub    $0x4,%esp
  8012a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8012a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8012ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8012ae:	e8 85 ed ff ff       	call   800038 <inRange>
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 24                	jne    8012de <_main+0x1c2>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8012ba:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8012bd:	e8 bb 22 00 00       	call   80357d <sys_calculate_free_frames>
  8012c2:	29 c3                	sub    %eax,%ebx
  8012c4:	89 d8                	mov    %ebx,%eax
  8012c6:	83 ec 0c             	sub    $0xc,%esp
  8012c9:	ff 75 dc             	pushl  -0x24(%ebp)
  8012cc:	50                   	push   %eax
  8012cd:	68 bc 4f 80 00       	push   $0x804fbc
  8012d2:	6a 3a                	push   $0x3a
  8012d4:	68 60 4e 80 00       	push   $0x804e60
  8012d9:	e8 a5 02 00 00       	call   801583 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8012de:	e8 e5 22 00 00       	call   8035c8 <sys_pf_calculate_allocated_pages>
  8012e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012e6:	74 14                	je     8012fc <_main+0x1e0>
		{panic("Wrong page file allocation: ");}
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	68 9a 4f 80 00       	push   $0x804f9a
  8012f0:	6a 3c                	push   $0x3c
  8012f2:	68 60 4e 80 00       	push   $0x804e60
  8012f7:	e8 87 02 00 00       	call   801583 <_panic>
	}
	sys_unlock_cons();
  8012fc:	e8 e6 21 00 00       	call   8034e7 <sys_unlock_cons>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  801301:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801304:	8b 00                	mov    (%eax),%eax
  801306:	83 f8 0a             	cmp    $0xa,%eax
  801309:	74 14                	je     80131f <_main+0x203>
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	68 54 50 80 00       	push   $0x805054
  801313:	6a 40                	push   $0x40
  801315:	68 60 4e 80 00       	push   $0x804e60
  80131a:	e8 64 02 00 00       	call   801583 <_panic>

	//Edit the writable object
	*z = 50;
  80131f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801322:	c7 00 32 00 00 00    	movl   $0x32,(%eax)
	if (*z != 50) panic("Get(): Shared Variable is not created or got correctly") ;
  801328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80132b:	8b 00                	mov    (%eax),%eax
  80132d:	83 f8 32             	cmp    $0x32,%eax
  801330:	74 14                	je     801346 <_main+0x22a>
  801332:	83 ec 04             	sub    $0x4,%esp
  801335:	68 54 50 80 00       	push   $0x805054
  80133a:	6a 44                	push   $0x44
  80133c:	68 60 4e 80 00       	push   $0x804e60
  801341:	e8 3d 02 00 00       	call   801583 <_panic>

	inctst();
  801346:	e8 39 25 00 00       	call   803884 <inctst>

	//sync with master
	while (gettst() != 5) ;
  80134b:	90                   	nop
  80134c:	e8 4d 25 00 00       	call   80389e <gettst>
  801351:	83 f8 05             	cmp    $0x5,%eax
  801354:	75 f6                	jne    80134c <_main+0x230>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	6a 06                	push   $0x6
  80135b:	e8 9e 24 00 00       	call   8037fe <sys_bypassPageFault>
  801360:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	ff 75 d4             	pushl  -0x2c(%ebp)
  801369:	68 8c 50 80 00       	push   $0x80508c
  80136e:	e8 70 05 00 00       	call   8018e3 <atomic_cprintf>
  801373:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  801376:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801379:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	6a 00                	push   $0x0
  801384:	e8 75 24 00 00       	call   8037fe <sys_bypassPageFault>
  801389:	83 c4 10             	add    $0x10,%esp

	inctst();
  80138c:	e8 f3 24 00 00       	call   803884 <inctst>
	if (*x == 100)
  801391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801394:	8b 00                	mov    (%eax),%eax
  801396:	83 f8 64             	cmp    $0x64,%eax
  801399:	75 14                	jne    8013af <_main+0x293>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	68 bc 50 80 00       	push   $0x8050bc
  8013a3:	6a 54                	push   $0x54
  8013a5:	68 60 4e 80 00       	push   $0x804e60
  8013aa:	e8 d4 01 00 00       	call   801583 <_panic>

	cprintf_colored(TEXT_green, "Slave2 completed.\n");
  8013af:	83 ec 08             	sub    $0x8,%esp
  8013b2:	68 03 51 80 00       	push   $0x805103
  8013b7:	6a 02                	push   $0x2
  8013b9:	e8 e0 04 00 00       	call   80189e <cprintf_colored>
  8013be:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  8013c1:	c7 05 00 60 80 00 00 	movl   $0x0,0x806000
  8013c8:	00 00 00 

	return;
  8013cb:	90                   	nop
}
  8013cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013cf:	5b                   	pop    %ebx
  8013d0:	5e                   	pop    %esi
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	57                   	push   %edi
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8013dc:	e8 65 23 00 00       	call   803746 <sys_getenvindex>
  8013e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8013e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013e7:	89 d0                	mov    %edx,%eax
  8013e9:	01 c0                	add    %eax,%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c1 e0 02             	shl    $0x2,%eax
  8013f0:	01 d0                	add    %edx,%eax
  8013f2:	c1 e0 02             	shl    $0x2,%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	c1 e0 03             	shl    $0x3,%eax
  8013fa:	01 d0                	add    %edx,%eax
  8013fc:	c1 e0 02             	shl    $0x2,%eax
  8013ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801404:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801409:	a1 00 62 80 00       	mov    0x806200,%eax
  80140e:	8a 40 20             	mov    0x20(%eax),%al
  801411:	84 c0                	test   %al,%al
  801413:	74 0d                	je     801422 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801415:	a1 00 62 80 00       	mov    0x806200,%eax
  80141a:	83 c0 20             	add    $0x20,%eax
  80141d:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801426:	7e 0a                	jle    801432 <libmain+0x5f>
		binaryname = argv[0];
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	8b 00                	mov    (%eax),%eax
  80142d:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801432:	83 ec 08             	sub    $0x8,%esp
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	ff 75 08             	pushl  0x8(%ebp)
  80143b:	e8 dc fc ff ff       	call   80111c <_main>
  801440:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801443:	a1 00 60 80 00       	mov    0x806000,%eax
  801448:	85 c0                	test   %eax,%eax
  80144a:	0f 84 01 01 00 00    	je     801551 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801450:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801456:	bb 10 52 80 00       	mov    $0x805210,%ebx
  80145b:	ba 0e 00 00 00       	mov    $0xe,%edx
  801460:	89 c7                	mov    %eax,%edi
  801462:	89 de                	mov    %ebx,%esi
  801464:	89 d1                	mov    %edx,%ecx
  801466:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801468:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80146b:	b9 56 00 00 00       	mov    $0x56,%ecx
  801470:	b0 00                	mov    $0x0,%al
  801472:	89 d7                	mov    %edx,%edi
  801474:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801476:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80147d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801480:	83 ec 08             	sub    $0x8,%esp
  801483:	50                   	push   %eax
  801484:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80148a:	50                   	push   %eax
  80148b:	e8 ec 24 00 00       	call   80397c <sys_utilities>
  801490:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801493:	e8 35 20 00 00       	call   8034cd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	68 30 51 80 00       	push   $0x805130
  8014a0:	e8 cc 03 00 00       	call   801871 <cprintf>
  8014a5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8014a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	74 18                	je     8014c7 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8014af:	e8 e6 24 00 00       	call   80399a <sys_get_optimal_num_faults>
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	50                   	push   %eax
  8014b8:	68 58 51 80 00       	push   $0x805158
  8014bd:	e8 af 03 00 00       	call   801871 <cprintf>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	eb 59                	jmp    801520 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014c7:	a1 00 62 80 00       	mov    0x806200,%eax
  8014cc:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8014d2:	a1 00 62 80 00       	mov    0x806200,%eax
  8014d7:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	52                   	push   %edx
  8014e1:	50                   	push   %eax
  8014e2:	68 7c 51 80 00       	push   $0x80517c
  8014e7:	e8 85 03 00 00       	call   801871 <cprintf>
  8014ec:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8014ef:	a1 00 62 80 00       	mov    0x806200,%eax
  8014f4:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8014fa:	a1 00 62 80 00       	mov    0x806200,%eax
  8014ff:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  801505:	a1 00 62 80 00       	mov    0x806200,%eax
  80150a:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  801510:	51                   	push   %ecx
  801511:	52                   	push   %edx
  801512:	50                   	push   %eax
  801513:	68 a4 51 80 00       	push   $0x8051a4
  801518:	e8 54 03 00 00       	call   801871 <cprintf>
  80151d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801520:	a1 00 62 80 00       	mov    0x806200,%eax
  801525:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	50                   	push   %eax
  80152f:	68 fc 51 80 00       	push   $0x8051fc
  801534:	e8 38 03 00 00       	call   801871 <cprintf>
  801539:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80153c:	83 ec 0c             	sub    $0xc,%esp
  80153f:	68 30 51 80 00       	push   $0x805130
  801544:	e8 28 03 00 00       	call   801871 <cprintf>
  801549:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80154c:	e8 96 1f 00 00       	call   8034e7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801551:	e8 1f 00 00 00       	call   801575 <exit>
}
  801556:	90                   	nop
  801557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5f                   	pop    %edi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	6a 00                	push   $0x0
  80156a:	e8 a3 21 00 00       	call   803712 <sys_destroy_env>
  80156f:	83 c4 10             	add    $0x10,%esp
}
  801572:	90                   	nop
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <exit>:

void
exit(void)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80157b:	e8 f8 21 00 00       	call   803778 <sys_exit_env>
}
  801580:	90                   	nop
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801589:	8d 45 10             	lea    0x10(%ebp),%eax
  80158c:	83 c0 04             	add    $0x4,%eax
  80158f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801592:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801597:	85 c0                	test   %eax,%eax
  801599:	74 16                	je     8015b1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80159b:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	50                   	push   %eax
  8015a4:	68 74 52 80 00       	push   $0x805274
  8015a9:	e8 c3 02 00 00       	call   801871 <cprintf>
  8015ae:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8015b1:	a1 04 60 80 00       	mov    0x806004,%eax
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	ff 75 0c             	pushl  0xc(%ebp)
  8015bc:	ff 75 08             	pushl  0x8(%ebp)
  8015bf:	50                   	push   %eax
  8015c0:	68 7c 52 80 00       	push   $0x80527c
  8015c5:	6a 74                	push   $0x74
  8015c7:	e8 d2 02 00 00       	call   80189e <cprintf_colored>
  8015cc:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8015cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d8:	50                   	push   %eax
  8015d9:	e8 24 02 00 00       	call   801802 <vcprintf>
  8015de:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	6a 00                	push   $0x0
  8015e6:	68 a4 52 80 00       	push   $0x8052a4
  8015eb:	e8 12 02 00 00       	call   801802 <vcprintf>
  8015f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015f3:	e8 7d ff ff ff       	call   801575 <exit>

	// should not return here
	while (1) ;
  8015f8:	eb fe                	jmp    8015f8 <_panic+0x75>

008015fa <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801601:	a1 00 62 80 00       	mov    0x806200,%eax
  801606:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	39 c2                	cmp    %eax,%edx
  801611:	74 14                	je     801627 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	68 a8 52 80 00       	push   $0x8052a8
  80161b:	6a 26                	push   $0x26
  80161d:	68 f4 52 80 00       	push   $0x8052f4
  801622:	e8 5c ff ff ff       	call   801583 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80162e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801635:	e9 d9 00 00 00       	jmp    801713 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	01 d0                	add    %edx,%eax
  801649:	8b 00                	mov    (%eax),%eax
  80164b:	85 c0                	test   %eax,%eax
  80164d:	75 08                	jne    801657 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80164f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801652:	e9 b9 00 00 00       	jmp    801710 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  801657:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80165e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801665:	eb 79                	jmp    8016e0 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801667:	a1 00 62 80 00       	mov    0x806200,%eax
  80166c:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801672:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801675:	89 d0                	mov    %edx,%eax
  801677:	01 c0                	add    %eax,%eax
  801679:	01 d0                	add    %edx,%eax
  80167b:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801682:	01 d8                	add    %ebx,%eax
  801684:	01 d0                	add    %edx,%eax
  801686:	01 c8                	add    %ecx,%eax
  801688:	8a 40 04             	mov    0x4(%eax),%al
  80168b:	84 c0                	test   %al,%al
  80168d:	75 4e                	jne    8016dd <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80168f:	a1 00 62 80 00       	mov    0x806200,%eax
  801694:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80169a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80169d:	89 d0                	mov    %edx,%eax
  80169f:	01 c0                	add    %eax,%eax
  8016a1:	01 d0                	add    %edx,%eax
  8016a3:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8016aa:	01 d8                	add    %ebx,%eax
  8016ac:	01 d0                	add    %edx,%eax
  8016ae:	01 c8                	add    %ecx,%eax
  8016b0:	8b 00                	mov    (%eax),%eax
  8016b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016bd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	01 c8                	add    %ecx,%eax
  8016ce:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016d0:	39 c2                	cmp    %eax,%edx
  8016d2:	75 09                	jne    8016dd <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8016d4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016db:	eb 19                	jmp    8016f6 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016dd:	ff 45 e8             	incl   -0x18(%ebp)
  8016e0:	a1 00 62 80 00       	mov    0x806200,%eax
  8016e5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ee:	39 c2                	cmp    %eax,%edx
  8016f0:	0f 87 71 ff ff ff    	ja     801667 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016fa:	75 14                	jne    801710 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	68 00 53 80 00       	push   $0x805300
  801704:	6a 3a                	push   $0x3a
  801706:	68 f4 52 80 00       	push   $0x8052f4
  80170b:	e8 73 fe ff ff       	call   801583 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801710:	ff 45 f0             	incl   -0x10(%ebp)
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801716:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801719:	0f 8c 1b ff ff ff    	jl     80163a <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80171f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801726:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80172d:	eb 2e                	jmp    80175d <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80172f:	a1 00 62 80 00       	mov    0x806200,%eax
  801734:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80173a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80173d:	89 d0                	mov    %edx,%eax
  80173f:	01 c0                	add    %eax,%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80174a:	01 d8                	add    %ebx,%eax
  80174c:	01 d0                	add    %edx,%eax
  80174e:	01 c8                	add    %ecx,%eax
  801750:	8a 40 04             	mov    0x4(%eax),%al
  801753:	3c 01                	cmp    $0x1,%al
  801755:	75 03                	jne    80175a <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  801757:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80175a:	ff 45 e0             	incl   -0x20(%ebp)
  80175d:	a1 00 62 80 00       	mov    0x806200,%eax
  801762:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801768:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80176b:	39 c2                	cmp    %eax,%edx
  80176d:	77 c0                	ja     80172f <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801772:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801775:	74 14                	je     80178b <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 54 53 80 00       	push   $0x805354
  80177f:	6a 44                	push   $0x44
  801781:	68 f4 52 80 00       	push   $0x8052f4
  801786:	e8 f8 fd ff ff       	call   801583 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80178b:	90                   	nop
  80178c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	53                   	push   %ebx
  801795:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179b:	8b 00                	mov    (%eax),%eax
  80179d:	8d 48 01             	lea    0x1(%eax),%ecx
  8017a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a3:	89 0a                	mov    %ecx,(%edx)
  8017a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a8:	88 d1                	mov    %dl,%cl
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b4:	8b 00                	mov    (%eax),%eax
  8017b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017bb:	75 30                	jne    8017ed <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8017bd:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  8017c3:	a0 24 62 80 00       	mov    0x806224,%al
  8017c8:	0f b6 c0             	movzbl %al,%eax
  8017cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ce:	8b 09                	mov    (%ecx),%ecx
  8017d0:	89 cb                	mov    %ecx,%ebx
  8017d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d5:	83 c1 08             	add    $0x8,%ecx
  8017d8:	52                   	push   %edx
  8017d9:	50                   	push   %eax
  8017da:	53                   	push   %ebx
  8017db:	51                   	push   %ecx
  8017dc:	e8 a8 1c 00 00       	call   803489 <sys_cputs>
  8017e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	8b 40 04             	mov    0x4(%eax),%eax
  8017f3:	8d 50 01             	lea    0x1(%eax),%edx
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017fc:	90                   	nop
  8017fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80180b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801812:	00 00 00 
	b.cnt = 0;
  801815:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80181c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80182b:	50                   	push   %eax
  80182c:	68 91 17 80 00       	push   $0x801791
  801831:	e8 5a 02 00 00       	call   801a90 <vprintfmt>
  801836:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801839:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  80183f:	a0 24 62 80 00       	mov    0x806224,%al
  801844:	0f b6 c0             	movzbl %al,%eax
  801847:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80184d:	52                   	push   %edx
  80184e:	50                   	push   %eax
  80184f:	51                   	push   %ecx
  801850:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801856:	83 c0 08             	add    $0x8,%eax
  801859:	50                   	push   %eax
  80185a:	e8 2a 1c 00 00       	call   803489 <sys_cputs>
  80185f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801862:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  801869:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801877:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  80187e:	8d 45 0c             	lea    0xc(%ebp),%eax
  801881:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	ff 75 f4             	pushl  -0xc(%ebp)
  80188d:	50                   	push   %eax
  80188e:	e8 6f ff ff ff       	call   801802 <vcprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018a4:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	c1 e0 08             	shl    $0x8,%eax
  8018b1:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  8018b6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018b9:	83 c0 04             	add    $0x4,%eax
  8018bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	50                   	push   %eax
  8018c9:	e8 34 ff ff ff       	call   801802 <vcprintf>
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8018d4:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  8018db:	07 00 00 

	return cnt;
  8018de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018e9:	e8 df 1b 00 00       	call   8034cd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	e8 ff fe ff ff       	call   801802 <vcprintf>
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801909:	e8 d9 1b 00 00       	call   8034e7 <sys_unlock_cons>
	return cnt;
  80190e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	53                   	push   %ebx
  801917:	83 ec 14             	sub    $0x14,%esp
  80191a:	8b 45 10             	mov    0x10(%ebp),%eax
  80191d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801920:	8b 45 14             	mov    0x14(%ebp),%eax
  801923:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801926:	8b 45 18             	mov    0x18(%ebp),%eax
  801929:	ba 00 00 00 00       	mov    $0x0,%edx
  80192e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801931:	77 55                	ja     801988 <printnum+0x75>
  801933:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801936:	72 05                	jb     80193d <printnum+0x2a>
  801938:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80193b:	77 4b                	ja     801988 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80193d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801940:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801943:	8b 45 18             	mov    0x18(%ebp),%eax
  801946:	ba 00 00 00 00       	mov    $0x0,%edx
  80194b:	52                   	push   %edx
  80194c:	50                   	push   %eax
  80194d:	ff 75 f4             	pushl  -0xc(%ebp)
  801950:	ff 75 f0             	pushl  -0x10(%ebp)
  801953:	e8 d4 2d 00 00       	call   80472c <__udivdi3>
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	ff 75 20             	pushl  0x20(%ebp)
  801961:	53                   	push   %ebx
  801962:	ff 75 18             	pushl  0x18(%ebp)
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	e8 a1 ff ff ff       	call   801913 <printnum>
  801972:	83 c4 20             	add    $0x20,%esp
  801975:	eb 1a                	jmp    801991 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801977:	83 ec 08             	sub    $0x8,%esp
  80197a:	ff 75 0c             	pushl  0xc(%ebp)
  80197d:	ff 75 20             	pushl  0x20(%ebp)
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	ff d0                	call   *%eax
  801985:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801988:	ff 4d 1c             	decl   0x1c(%ebp)
  80198b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80198f:	7f e6                	jg     801977 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801991:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801994:	bb 00 00 00 00       	mov    $0x0,%ebx
  801999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199f:	53                   	push   %ebx
  8019a0:	51                   	push   %ecx
  8019a1:	52                   	push   %edx
  8019a2:	50                   	push   %eax
  8019a3:	e8 94 2e 00 00       	call   80483c <__umoddi3>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	05 b4 55 80 00       	add    $0x8055b4,%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	0f be c0             	movsbl %al,%eax
  8019b5:	83 ec 08             	sub    $0x8,%esp
  8019b8:	ff 75 0c             	pushl  0xc(%ebp)
  8019bb:	50                   	push   %eax
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	ff d0                	call   *%eax
  8019c1:	83 c4 10             	add    $0x10,%esp
}
  8019c4:	90                   	nop
  8019c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019cd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019d1:	7e 1c                	jle    8019ef <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8b 00                	mov    (%eax),%eax
  8019d8:	8d 50 08             	lea    0x8(%eax),%edx
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	89 10                	mov    %edx,(%eax)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	83 e8 08             	sub    $0x8,%eax
  8019e8:	8b 50 04             	mov    0x4(%eax),%edx
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	eb 40                	jmp    801a2f <getuint+0x65>
	else if (lflag)
  8019ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019f3:	74 1e                	je     801a13 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	8b 00                	mov    (%eax),%eax
  8019fa:	8d 50 04             	lea    0x4(%eax),%edx
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	89 10                	mov    %edx,(%eax)
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8b 00                	mov    (%eax),%eax
  801a07:	83 e8 04             	sub    $0x4,%eax
  801a0a:	8b 00                	mov    (%eax),%eax
  801a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a11:	eb 1c                	jmp    801a2f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8b 00                	mov    (%eax),%eax
  801a18:	8d 50 04             	lea    0x4(%eax),%edx
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	89 10                	mov    %edx,(%eax)
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8b 00                	mov    (%eax),%eax
  801a25:	83 e8 04             	sub    $0x4,%eax
  801a28:	8b 00                	mov    (%eax),%eax
  801a2a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    

00801a31 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a34:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a38:	7e 1c                	jle    801a56 <getint+0x25>
		return va_arg(*ap, long long);
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	8d 50 08             	lea    0x8(%eax),%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	89 10                	mov    %edx,(%eax)
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	83 e8 08             	sub    $0x8,%eax
  801a4f:	8b 50 04             	mov    0x4(%eax),%edx
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	eb 38                	jmp    801a8e <getint+0x5d>
	else if (lflag)
  801a56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a5a:	74 1a                	je     801a76 <getint+0x45>
		return va_arg(*ap, long);
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8b 00                	mov    (%eax),%eax
  801a61:	8d 50 04             	lea    0x4(%eax),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	89 10                	mov    %edx,(%eax)
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8b 00                	mov    (%eax),%eax
  801a6e:	83 e8 04             	sub    $0x4,%eax
  801a71:	8b 00                	mov    (%eax),%eax
  801a73:	99                   	cltd   
  801a74:	eb 18                	jmp    801a8e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	8d 50 04             	lea    0x4(%eax),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	89 10                	mov    %edx,(%eax)
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	8b 00                	mov    (%eax),%eax
  801a88:	83 e8 04             	sub    $0x4,%eax
  801a8b:	8b 00                	mov    (%eax),%eax
  801a8d:	99                   	cltd   
}
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    

00801a90 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
  801a95:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a98:	eb 17                	jmp    801ab1 <vprintfmt+0x21>
			if (ch == '\0')
  801a9a:	85 db                	test   %ebx,%ebx
  801a9c:	0f 84 c1 03 00 00    	je     801e63 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801aa2:	83 ec 08             	sub    $0x8,%esp
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	53                   	push   %ebx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	ff d0                	call   *%eax
  801aae:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	8d 50 01             	lea    0x1(%eax),%edx
  801ab7:	89 55 10             	mov    %edx,0x10(%ebp)
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f b6 d8             	movzbl %al,%ebx
  801abf:	83 fb 25             	cmp    $0x25,%ebx
  801ac2:	75 d6                	jne    801a9a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801ac4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801ac8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801acf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801ad6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801add:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ae4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae7:	8d 50 01             	lea    0x1(%eax),%edx
  801aea:	89 55 10             	mov    %edx,0x10(%ebp)
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	0f b6 d8             	movzbl %al,%ebx
  801af2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801af5:	83 f8 5b             	cmp    $0x5b,%eax
  801af8:	0f 87 3d 03 00 00    	ja     801e3b <vprintfmt+0x3ab>
  801afe:	8b 04 85 d8 55 80 00 	mov    0x8055d8(,%eax,4),%eax
  801b05:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b07:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b0b:	eb d7                	jmp    801ae4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b0d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b11:	eb d1                	jmp    801ae4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	c1 e0 02             	shl    $0x2,%eax
  801b22:	01 d0                	add    %edx,%eax
  801b24:	01 c0                	add    %eax,%eax
  801b26:	01 d8                	add    %ebx,%eax
  801b28:	83 e8 30             	sub    $0x30,%eax
  801b2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b31:	8a 00                	mov    (%eax),%al
  801b33:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b36:	83 fb 2f             	cmp    $0x2f,%ebx
  801b39:	7e 3e                	jle    801b79 <vprintfmt+0xe9>
  801b3b:	83 fb 39             	cmp    $0x39,%ebx
  801b3e:	7f 39                	jg     801b79 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b40:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b43:	eb d5                	jmp    801b1a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b45:	8b 45 14             	mov    0x14(%ebp),%eax
  801b48:	83 c0 04             	add    $0x4,%eax
  801b4b:	89 45 14             	mov    %eax,0x14(%ebp)
  801b4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b51:	83 e8 04             	sub    $0x4,%eax
  801b54:	8b 00                	mov    (%eax),%eax
  801b56:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b59:	eb 1f                	jmp    801b7a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b5f:	79 83                	jns    801ae4 <vprintfmt+0x54>
				width = 0;
  801b61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b68:	e9 77 ff ff ff       	jmp    801ae4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b6d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b74:	e9 6b ff ff ff       	jmp    801ae4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b79:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b7e:	0f 89 60 ff ff ff    	jns    801ae4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b8a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b91:	e9 4e ff ff ff       	jmp    801ae4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b96:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b99:	e9 46 ff ff ff       	jmp    801ae4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba1:	83 c0 04             	add    $0x4,%eax
  801ba4:	89 45 14             	mov    %eax,0x14(%ebp)
  801ba7:	8b 45 14             	mov    0x14(%ebp),%eax
  801baa:	83 e8 04             	sub    $0x4,%eax
  801bad:	8b 00                	mov    (%eax),%eax
  801baf:	83 ec 08             	sub    $0x8,%esp
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	50                   	push   %eax
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	ff d0                	call   *%eax
  801bbb:	83 c4 10             	add    $0x10,%esp
			break;
  801bbe:	e9 9b 02 00 00       	jmp    801e5e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc6:	83 c0 04             	add    $0x4,%eax
  801bc9:	89 45 14             	mov    %eax,0x14(%ebp)
  801bcc:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcf:	83 e8 04             	sub    $0x4,%eax
  801bd2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801bd4:	85 db                	test   %ebx,%ebx
  801bd6:	79 02                	jns    801bda <vprintfmt+0x14a>
				err = -err;
  801bd8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801bda:	83 fb 64             	cmp    $0x64,%ebx
  801bdd:	7f 0b                	jg     801bea <vprintfmt+0x15a>
  801bdf:	8b 34 9d 20 54 80 00 	mov    0x805420(,%ebx,4),%esi
  801be6:	85 f6                	test   %esi,%esi
  801be8:	75 19                	jne    801c03 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bea:	53                   	push   %ebx
  801beb:	68 c5 55 80 00       	push   $0x8055c5
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	e8 70 02 00 00       	call   801e6b <printfmt>
  801bfb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bfe:	e9 5b 02 00 00       	jmp    801e5e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c03:	56                   	push   %esi
  801c04:	68 ce 55 80 00       	push   $0x8055ce
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	e8 57 02 00 00       	call   801e6b <printfmt>
  801c14:	83 c4 10             	add    $0x10,%esp
			break;
  801c17:	e9 42 02 00 00       	jmp    801e5e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1f:	83 c0 04             	add    $0x4,%eax
  801c22:	89 45 14             	mov    %eax,0x14(%ebp)
  801c25:	8b 45 14             	mov    0x14(%ebp),%eax
  801c28:	83 e8 04             	sub    $0x4,%eax
  801c2b:	8b 30                	mov    (%eax),%esi
  801c2d:	85 f6                	test   %esi,%esi
  801c2f:	75 05                	jne    801c36 <vprintfmt+0x1a6>
				p = "(null)";
  801c31:	be d1 55 80 00       	mov    $0x8055d1,%esi
			if (width > 0 && padc != '-')
  801c36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c3a:	7e 6d                	jle    801ca9 <vprintfmt+0x219>
  801c3c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c40:	74 67                	je     801ca9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	50                   	push   %eax
  801c49:	56                   	push   %esi
  801c4a:	e8 1e 03 00 00       	call   801f6d <strnlen>
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c55:	eb 16                	jmp    801c6d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c5b:	83 ec 08             	sub    $0x8,%esp
  801c5e:	ff 75 0c             	pushl  0xc(%ebp)
  801c61:	50                   	push   %eax
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	ff d0                	call   *%eax
  801c67:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c6a:	ff 4d e4             	decl   -0x1c(%ebp)
  801c6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c71:	7f e4                	jg     801c57 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c73:	eb 34                	jmp    801ca9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c79:	74 1c                	je     801c97 <vprintfmt+0x207>
  801c7b:	83 fb 1f             	cmp    $0x1f,%ebx
  801c7e:	7e 05                	jle    801c85 <vprintfmt+0x1f5>
  801c80:	83 fb 7e             	cmp    $0x7e,%ebx
  801c83:	7e 12                	jle    801c97 <vprintfmt+0x207>
					putch('?', putdat);
  801c85:	83 ec 08             	sub    $0x8,%esp
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	6a 3f                	push   $0x3f
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	ff d0                	call   *%eax
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	eb 0f                	jmp    801ca6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c97:	83 ec 08             	sub    $0x8,%esp
  801c9a:	ff 75 0c             	pushl  0xc(%ebp)
  801c9d:	53                   	push   %ebx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	ff d0                	call   *%eax
  801ca3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ca6:	ff 4d e4             	decl   -0x1c(%ebp)
  801ca9:	89 f0                	mov    %esi,%eax
  801cab:	8d 70 01             	lea    0x1(%eax),%esi
  801cae:	8a 00                	mov    (%eax),%al
  801cb0:	0f be d8             	movsbl %al,%ebx
  801cb3:	85 db                	test   %ebx,%ebx
  801cb5:	74 24                	je     801cdb <vprintfmt+0x24b>
  801cb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cbb:	78 b8                	js     801c75 <vprintfmt+0x1e5>
  801cbd:	ff 4d e0             	decl   -0x20(%ebp)
  801cc0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cc4:	79 af                	jns    801c75 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cc6:	eb 13                	jmp    801cdb <vprintfmt+0x24b>
				putch(' ', putdat);
  801cc8:	83 ec 08             	sub    $0x8,%esp
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	6a 20                	push   $0x20
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	ff d0                	call   *%eax
  801cd5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cd8:	ff 4d e4             	decl   -0x1c(%ebp)
  801cdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cdf:	7f e7                	jg     801cc8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ce1:	e9 78 01 00 00       	jmp    801e5e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	ff 75 e8             	pushl  -0x18(%ebp)
  801cec:	8d 45 14             	lea    0x14(%ebp),%eax
  801cef:	50                   	push   %eax
  801cf0:	e8 3c fd ff ff       	call   801a31 <getint>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d04:	85 d2                	test   %edx,%edx
  801d06:	79 23                	jns    801d2b <vprintfmt+0x29b>
				putch('-', putdat);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	6a 2d                	push   $0x2d
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	ff d0                	call   *%eax
  801d15:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1e:	f7 d8                	neg    %eax
  801d20:	83 d2 00             	adc    $0x0,%edx
  801d23:	f7 da                	neg    %edx
  801d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d32:	e9 bc 00 00 00       	jmp    801df3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d37:	83 ec 08             	sub    $0x8,%esp
  801d3a:	ff 75 e8             	pushl  -0x18(%ebp)
  801d3d:	8d 45 14             	lea    0x14(%ebp),%eax
  801d40:	50                   	push   %eax
  801d41:	e8 84 fc ff ff       	call   8019ca <getuint>
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d56:	e9 98 00 00 00       	jmp    801df3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d5b:	83 ec 08             	sub    $0x8,%esp
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	6a 58                	push   $0x58
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	ff d0                	call   *%eax
  801d68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d6b:	83 ec 08             	sub    $0x8,%esp
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	6a 58                	push   $0x58
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	ff d0                	call   *%eax
  801d78:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d7b:	83 ec 08             	sub    $0x8,%esp
  801d7e:	ff 75 0c             	pushl  0xc(%ebp)
  801d81:	6a 58                	push   $0x58
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	ff d0                	call   *%eax
  801d88:	83 c4 10             	add    $0x10,%esp
			break;
  801d8b:	e9 ce 00 00 00       	jmp    801e5e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d90:	83 ec 08             	sub    $0x8,%esp
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	6a 30                	push   $0x30
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	ff d0                	call   *%eax
  801d9d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801da0:	83 ec 08             	sub    $0x8,%esp
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	6a 78                	push   $0x78
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	ff d0                	call   *%eax
  801dad:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801db0:	8b 45 14             	mov    0x14(%ebp),%eax
  801db3:	83 c0 04             	add    $0x4,%eax
  801db6:	89 45 14             	mov    %eax,0x14(%ebp)
  801db9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbc:	83 e8 04             	sub    $0x4,%eax
  801dbf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801dcb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801dd2:	eb 1f                	jmp    801df3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801dd4:	83 ec 08             	sub    $0x8,%esp
  801dd7:	ff 75 e8             	pushl  -0x18(%ebp)
  801dda:	8d 45 14             	lea    0x14(%ebp),%eax
  801ddd:	50                   	push   %eax
  801dde:	e8 e7 fb ff ff       	call   8019ca <getuint>
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801de9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801dec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801df3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	52                   	push   %edx
  801dfe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e01:	50                   	push   %eax
  801e02:	ff 75 f4             	pushl  -0xc(%ebp)
  801e05:	ff 75 f0             	pushl  -0x10(%ebp)
  801e08:	ff 75 0c             	pushl  0xc(%ebp)
  801e0b:	ff 75 08             	pushl  0x8(%ebp)
  801e0e:	e8 00 fb ff ff       	call   801913 <printnum>
  801e13:	83 c4 20             	add    $0x20,%esp
			break;
  801e16:	eb 46                	jmp    801e5e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e18:	83 ec 08             	sub    $0x8,%esp
  801e1b:	ff 75 0c             	pushl  0xc(%ebp)
  801e1e:	53                   	push   %ebx
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	ff d0                	call   *%eax
  801e24:	83 c4 10             	add    $0x10,%esp
			break;
  801e27:	eb 35                	jmp    801e5e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801e29:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  801e30:	eb 2c                	jmp    801e5e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801e32:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  801e39:	eb 23                	jmp    801e5e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e3b:	83 ec 08             	sub    $0x8,%esp
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	6a 25                	push   $0x25
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	ff d0                	call   *%eax
  801e48:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e4b:	ff 4d 10             	decl   0x10(%ebp)
  801e4e:	eb 03                	jmp    801e53 <vprintfmt+0x3c3>
  801e50:	ff 4d 10             	decl   0x10(%ebp)
  801e53:	8b 45 10             	mov    0x10(%ebp),%eax
  801e56:	48                   	dec    %eax
  801e57:	8a 00                	mov    (%eax),%al
  801e59:	3c 25                	cmp    $0x25,%al
  801e5b:	75 f3                	jne    801e50 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e5d:	90                   	nop
		}
	}
  801e5e:	e9 35 fc ff ff       	jmp    801a98 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e63:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    

00801e6b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e71:	8d 45 10             	lea    0x10(%ebp),%eax
  801e74:	83 c0 04             	add    $0x4,%eax
  801e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e80:	50                   	push   %eax
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	e8 04 fc ff ff       	call   801a90 <vprintfmt>
  801e8c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e8f:	90                   	nop
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8b 40 08             	mov    0x8(%eax),%eax
  801e9b:	8d 50 01             	lea    0x1(%eax),%edx
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea7:	8b 10                	mov    (%eax),%edx
  801ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eac:	8b 40 04             	mov    0x4(%eax),%eax
  801eaf:	39 c2                	cmp    %eax,%edx
  801eb1:	73 12                	jae    801ec5 <sprintputch+0x33>
		*b->buf++ = ch;
  801eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb6:	8b 00                	mov    (%eax),%eax
  801eb8:	8d 48 01             	lea    0x1(%eax),%ecx
  801ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebe:	89 0a                	mov    %ecx,(%edx)
  801ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec3:	88 10                	mov    %dl,(%eax)
}
  801ec5:	90                   	nop
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    

00801ec8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	01 d0                	add    %edx,%eax
  801edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ee2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ee9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eed:	74 06                	je     801ef5 <vsnprintf+0x2d>
  801eef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ef3:	7f 07                	jg     801efc <vsnprintf+0x34>
		return -E_INVAL;
  801ef5:	b8 03 00 00 00       	mov    $0x3,%eax
  801efa:	eb 20                	jmp    801f1c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801efc:	ff 75 14             	pushl  0x14(%ebp)
  801eff:	ff 75 10             	pushl  0x10(%ebp)
  801f02:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f05:	50                   	push   %eax
  801f06:	68 92 1e 80 00       	push   $0x801e92
  801f0b:	e8 80 fb ff ff       	call   801a90 <vprintfmt>
  801f10:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f16:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f24:	8d 45 10             	lea    0x10(%ebp),%eax
  801f27:	83 c0 04             	add    $0x4,%eax
  801f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f30:	ff 75 f4             	pushl  -0xc(%ebp)
  801f33:	50                   	push   %eax
  801f34:	ff 75 0c             	pushl  0xc(%ebp)
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	e8 89 ff ff ff       	call   801ec8 <vsnprintf>
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f57:	eb 06                	jmp    801f5f <strlen+0x15>
		n++;
  801f59:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f5c:	ff 45 08             	incl   0x8(%ebp)
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	8a 00                	mov    (%eax),%al
  801f64:	84 c0                	test   %al,%al
  801f66:	75 f1                	jne    801f59 <strlen+0xf>
		n++;
	return n;
  801f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f7a:	eb 09                	jmp    801f85 <strnlen+0x18>
		n++;
  801f7c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f7f:	ff 45 08             	incl   0x8(%ebp)
  801f82:	ff 4d 0c             	decl   0xc(%ebp)
  801f85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f89:	74 09                	je     801f94 <strnlen+0x27>
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	8a 00                	mov    (%eax),%al
  801f90:	84 c0                	test   %al,%al
  801f92:	75 e8                	jne    801f7c <strnlen+0xf>
		n++;
	return n;
  801f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801fa5:	90                   	nop
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	8d 50 01             	lea    0x1(%eax),%edx
  801fac:	89 55 08             	mov    %edx,0x8(%ebp)
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fb5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fb8:	8a 12                	mov    (%edx),%dl
  801fba:	88 10                	mov    %dl,(%eax)
  801fbc:	8a 00                	mov    (%eax),%al
  801fbe:	84 c0                	test   %al,%al
  801fc0:	75 e4                	jne    801fa6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fda:	eb 1f                	jmp    801ffb <strncpy+0x34>
		*dst++ = *src;
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8d 50 01             	lea    0x1(%eax),%edx
  801fe2:	89 55 08             	mov    %edx,0x8(%ebp)
  801fe5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe8:	8a 12                	mov    (%edx),%dl
  801fea:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fef:	8a 00                	mov    (%eax),%al
  801ff1:	84 c0                	test   %al,%al
  801ff3:	74 03                	je     801ff8 <strncpy+0x31>
			src++;
  801ff5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ff8:	ff 45 fc             	incl   -0x4(%ebp)
  801ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffe:	3b 45 10             	cmp    0x10(%ebp),%eax
  802001:	72 d9                	jb     801fdc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802003:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802014:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802018:	74 30                	je     80204a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80201a:	eb 16                	jmp    802032 <strlcpy+0x2a>
			*dst++ = *src++;
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	8d 50 01             	lea    0x1(%eax),%edx
  802022:	89 55 08             	mov    %edx,0x8(%ebp)
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	8d 4a 01             	lea    0x1(%edx),%ecx
  80202b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80202e:	8a 12                	mov    (%edx),%dl
  802030:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802032:	ff 4d 10             	decl   0x10(%ebp)
  802035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802039:	74 09                	je     802044 <strlcpy+0x3c>
  80203b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203e:	8a 00                	mov    (%eax),%al
  802040:	84 c0                	test   %al,%al
  802042:	75 d8                	jne    80201c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80204a:	8b 55 08             	mov    0x8(%ebp),%edx
  80204d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802050:	29 c2                	sub    %eax,%edx
  802052:	89 d0                	mov    %edx,%eax
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802059:	eb 06                	jmp    802061 <strcmp+0xb>
		p++, q++;
  80205b:	ff 45 08             	incl   0x8(%ebp)
  80205e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	8a 00                	mov    (%eax),%al
  802066:	84 c0                	test   %al,%al
  802068:	74 0e                	je     802078 <strcmp+0x22>
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	8a 10                	mov    (%eax),%dl
  80206f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802072:	8a 00                	mov    (%eax),%al
  802074:	38 c2                	cmp    %al,%dl
  802076:	74 e3                	je     80205b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	8a 00                	mov    (%eax),%al
  80207d:	0f b6 d0             	movzbl %al,%edx
  802080:	8b 45 0c             	mov    0xc(%ebp),%eax
  802083:	8a 00                	mov    (%eax),%al
  802085:	0f b6 c0             	movzbl %al,%eax
  802088:	29 c2                	sub    %eax,%edx
  80208a:	89 d0                	mov    %edx,%eax
}
  80208c:	5d                   	pop    %ebp
  80208d:	c3                   	ret    

0080208e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802091:	eb 09                	jmp    80209c <strncmp+0xe>
		n--, p++, q++;
  802093:	ff 4d 10             	decl   0x10(%ebp)
  802096:	ff 45 08             	incl   0x8(%ebp)
  802099:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80209c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020a0:	74 17                	je     8020b9 <strncmp+0x2b>
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8a 00                	mov    (%eax),%al
  8020a7:	84 c0                	test   %al,%al
  8020a9:	74 0e                	je     8020b9 <strncmp+0x2b>
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	8a 10                	mov    (%eax),%dl
  8020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b3:	8a 00                	mov    (%eax),%al
  8020b5:	38 c2                	cmp    %al,%dl
  8020b7:	74 da                	je     802093 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8020b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020bd:	75 07                	jne    8020c6 <strncmp+0x38>
		return 0;
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	eb 14                	jmp    8020da <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	8a 00                	mov    (%eax),%al
  8020cb:	0f b6 d0             	movzbl %al,%edx
  8020ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d1:	8a 00                	mov    (%eax),%al
  8020d3:	0f b6 c0             	movzbl %al,%eax
  8020d6:	29 c2                	sub    %eax,%edx
  8020d8:	89 d0                	mov    %edx,%eax
}
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    

008020dc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020e8:	eb 12                	jmp    8020fc <strchr+0x20>
		if (*s == c)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020f2:	75 05                	jne    8020f9 <strchr+0x1d>
			return (char *) s;
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	eb 11                	jmp    80210a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020f9:	ff 45 08             	incl   0x8(%ebp)
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	8a 00                	mov    (%eax),%al
  802101:	84 c0                	test   %al,%al
  802103:	75 e5                	jne    8020ea <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	8b 45 0c             	mov    0xc(%ebp),%eax
  802115:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802118:	eb 0d                	jmp    802127 <strfind+0x1b>
		if (*s == c)
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8a 00                	mov    (%eax),%al
  80211f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802122:	74 0e                	je     802132 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802124:	ff 45 08             	incl   0x8(%ebp)
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	8a 00                	mov    (%eax),%al
  80212c:	84 c0                	test   %al,%al
  80212e:	75 ea                	jne    80211a <strfind+0xe>
  802130:	eb 01                	jmp    802133 <strfind+0x27>
		if (*s == c)
			break;
  802132:	90                   	nop
	return (char *) s;
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802144:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802148:	76 63                	jbe    8021ad <memset+0x75>
		uint64 data_block = c;
  80214a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214d:	99                   	cltd   
  80214e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802151:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215a:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80215e:	c1 e0 08             	shl    $0x8,%eax
  802161:	09 45 f0             	or     %eax,-0x10(%ebp)
  802164:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802171:	c1 e0 10             	shl    $0x10,%eax
  802174:	09 45 f0             	or     %eax,-0x10(%ebp)
  802177:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80217a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	89 c2                	mov    %eax,%edx
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	09 45 f0             	or     %eax,-0x10(%ebp)
  80218a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80218d:	eb 18                	jmp    8021a7 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80218f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802192:	8d 41 08             	lea    0x8(%ecx),%eax
  802195:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219e:	89 01                	mov    %eax,(%ecx)
  8021a0:	89 51 04             	mov    %edx,0x4(%ecx)
  8021a3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8021a7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021ab:	77 e2                	ja     80218f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8021ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021b1:	74 23                	je     8021d6 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8021b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021b9:	eb 0e                	jmp    8021c9 <memset+0x91>
			*p8++ = (uint8)c;
  8021bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021be:	8d 50 01             	lea    0x1(%eax),%edx
  8021c1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c7:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8021c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	75 e5                	jne    8021bb <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8021e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8021ed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8021f1:	76 24                	jbe    802217 <memcpy+0x3c>
		while(n >= 8){
  8021f3:	eb 1c                	jmp    802211 <memcpy+0x36>
			*d64 = *s64;
  8021f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f8:	8b 50 04             	mov    0x4(%eax),%edx
  8021fb:	8b 00                	mov    (%eax),%eax
  8021fd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802200:	89 01                	mov    %eax,(%ecx)
  802202:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802205:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802209:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80220d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  802211:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802215:	77 de                	ja     8021f5 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802217:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80221b:	74 31                	je     80224e <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80221d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802223:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802226:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802229:	eb 16                	jmp    802241 <memcpy+0x66>
			*d8++ = *s8++;
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	8d 50 01             	lea    0x1(%eax),%edx
  802231:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802237:	8d 4a 01             	lea    0x1(%edx),%ecx
  80223a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80223d:	8a 12                	mov    (%edx),%dl
  80223f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802241:	8b 45 10             	mov    0x10(%ebp),%eax
  802244:	8d 50 ff             	lea    -0x1(%eax),%edx
  802247:	89 55 10             	mov    %edx,0x10(%ebp)
  80224a:	85 c0                	test   %eax,%eax
  80224c:	75 dd                	jne    80222b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802265:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802268:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80226b:	73 50                	jae    8022bd <memmove+0x6a>
  80226d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802270:	8b 45 10             	mov    0x10(%ebp),%eax
  802273:	01 d0                	add    %edx,%eax
  802275:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802278:	76 43                	jbe    8022bd <memmove+0x6a>
		s += n;
  80227a:	8b 45 10             	mov    0x10(%ebp),%eax
  80227d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802280:	8b 45 10             	mov    0x10(%ebp),%eax
  802283:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802286:	eb 10                	jmp    802298 <memmove+0x45>
			*--d = *--s;
  802288:	ff 4d f8             	decl   -0x8(%ebp)
  80228b:	ff 4d fc             	decl   -0x4(%ebp)
  80228e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802291:	8a 10                	mov    (%eax),%dl
  802293:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802296:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802298:	8b 45 10             	mov    0x10(%ebp),%eax
  80229b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80229e:	89 55 10             	mov    %edx,0x10(%ebp)
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	75 e3                	jne    802288 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8022a5:	eb 23                	jmp    8022ca <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8022a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022aa:	8d 50 01             	lea    0x1(%eax),%edx
  8022ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022b6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8022b9:	8a 12                	mov    (%edx),%dl
  8022bb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8022bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	75 dd                	jne    8022a7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8022db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022de:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8022e1:	eb 2a                	jmp    80230d <memcmp+0x3e>
		if (*s1 != *s2)
  8022e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e6:	8a 10                	mov    (%eax),%dl
  8022e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022eb:	8a 00                	mov    (%eax),%al
  8022ed:	38 c2                	cmp    %al,%dl
  8022ef:	74 16                	je     802307 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8022f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f4:	8a 00                	mov    (%eax),%al
  8022f6:	0f b6 d0             	movzbl %al,%edx
  8022f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022fc:	8a 00                	mov    (%eax),%al
  8022fe:	0f b6 c0             	movzbl %al,%eax
  802301:	29 c2                	sub    %eax,%edx
  802303:	89 d0                	mov    %edx,%eax
  802305:	eb 18                	jmp    80231f <memcmp+0x50>
		s1++, s2++;
  802307:	ff 45 fc             	incl   -0x4(%ebp)
  80230a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80230d:	8b 45 10             	mov    0x10(%ebp),%eax
  802310:	8d 50 ff             	lea    -0x1(%eax),%edx
  802313:	89 55 10             	mov    %edx,0x10(%ebp)
  802316:	85 c0                	test   %eax,%eax
  802318:	75 c9                	jne    8022e3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80231a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802327:	8b 55 08             	mov    0x8(%ebp),%edx
  80232a:	8b 45 10             	mov    0x10(%ebp),%eax
  80232d:	01 d0                	add    %edx,%eax
  80232f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802332:	eb 15                	jmp    802349 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	8a 00                	mov    (%eax),%al
  802339:	0f b6 d0             	movzbl %al,%edx
  80233c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233f:	0f b6 c0             	movzbl %al,%eax
  802342:	39 c2                	cmp    %eax,%edx
  802344:	74 0d                	je     802353 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802346:	ff 45 08             	incl   0x8(%ebp)
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80234f:	72 e3                	jb     802334 <memfind+0x13>
  802351:	eb 01                	jmp    802354 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802353:	90                   	nop
	return (void *) s;
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80235f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802366:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80236d:	eb 03                	jmp    802372 <strtol+0x19>
		s++;
  80236f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	8a 00                	mov    (%eax),%al
  802377:	3c 20                	cmp    $0x20,%al
  802379:	74 f4                	je     80236f <strtol+0x16>
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	8a 00                	mov    (%eax),%al
  802380:	3c 09                	cmp    $0x9,%al
  802382:	74 eb                	je     80236f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	8a 00                	mov    (%eax),%al
  802389:	3c 2b                	cmp    $0x2b,%al
  80238b:	75 05                	jne    802392 <strtol+0x39>
		s++;
  80238d:	ff 45 08             	incl   0x8(%ebp)
  802390:	eb 13                	jmp    8023a5 <strtol+0x4c>
	else if (*s == '-')
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8a 00                	mov    (%eax),%al
  802397:	3c 2d                	cmp    $0x2d,%al
  802399:	75 0a                	jne    8023a5 <strtol+0x4c>
		s++, neg = 1;
  80239b:	ff 45 08             	incl   0x8(%ebp)
  80239e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023a9:	74 06                	je     8023b1 <strtol+0x58>
  8023ab:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8023af:	75 20                	jne    8023d1 <strtol+0x78>
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8a 00                	mov    (%eax),%al
  8023b6:	3c 30                	cmp    $0x30,%al
  8023b8:	75 17                	jne    8023d1 <strtol+0x78>
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	40                   	inc    %eax
  8023be:	8a 00                	mov    (%eax),%al
  8023c0:	3c 78                	cmp    $0x78,%al
  8023c2:	75 0d                	jne    8023d1 <strtol+0x78>
		s += 2, base = 16;
  8023c4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8023c8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8023cf:	eb 28                	jmp    8023f9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8023d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d5:	75 15                	jne    8023ec <strtol+0x93>
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	8a 00                	mov    (%eax),%al
  8023dc:	3c 30                	cmp    $0x30,%al
  8023de:	75 0c                	jne    8023ec <strtol+0x93>
		s++, base = 8;
  8023e0:	ff 45 08             	incl   0x8(%ebp)
  8023e3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8023ea:	eb 0d                	jmp    8023f9 <strtol+0xa0>
	else if (base == 0)
  8023ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f0:	75 07                	jne    8023f9 <strtol+0xa0>
		base = 10;
  8023f2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	8a 00                	mov    (%eax),%al
  8023fe:	3c 2f                	cmp    $0x2f,%al
  802400:	7e 19                	jle    80241b <strtol+0xc2>
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8a 00                	mov    (%eax),%al
  802407:	3c 39                	cmp    $0x39,%al
  802409:	7f 10                	jg     80241b <strtol+0xc2>
			dig = *s - '0';
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	8a 00                	mov    (%eax),%al
  802410:	0f be c0             	movsbl %al,%eax
  802413:	83 e8 30             	sub    $0x30,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	eb 42                	jmp    80245d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	8a 00                	mov    (%eax),%al
  802420:	3c 60                	cmp    $0x60,%al
  802422:	7e 19                	jle    80243d <strtol+0xe4>
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8a 00                	mov    (%eax),%al
  802429:	3c 7a                	cmp    $0x7a,%al
  80242b:	7f 10                	jg     80243d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	8a 00                	mov    (%eax),%al
  802432:	0f be c0             	movsbl %al,%eax
  802435:	83 e8 57             	sub    $0x57,%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243b:	eb 20                	jmp    80245d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8a 00                	mov    (%eax),%al
  802442:	3c 40                	cmp    $0x40,%al
  802444:	7e 39                	jle    80247f <strtol+0x126>
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	8a 00                	mov    (%eax),%al
  80244b:	3c 5a                	cmp    $0x5a,%al
  80244d:	7f 30                	jg     80247f <strtol+0x126>
			dig = *s - 'A' + 10;
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	8a 00                	mov    (%eax),%al
  802454:	0f be c0             	movsbl %al,%eax
  802457:	83 e8 37             	sub    $0x37,%eax
  80245a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	3b 45 10             	cmp    0x10(%ebp),%eax
  802463:	7d 19                	jge    80247e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802465:	ff 45 08             	incl   0x8(%ebp)
  802468:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80246b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80246f:	89 c2                	mov    %eax,%edx
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	01 d0                	add    %edx,%eax
  802476:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802479:	e9 7b ff ff ff       	jmp    8023f9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80247e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80247f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802483:	74 08                	je     80248d <strtol+0x134>
		*endptr = (char *) s;
  802485:	8b 45 0c             	mov    0xc(%ebp),%eax
  802488:	8b 55 08             	mov    0x8(%ebp),%edx
  80248b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80248d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802491:	74 07                	je     80249a <strtol+0x141>
  802493:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802496:	f7 d8                	neg    %eax
  802498:	eb 03                	jmp    80249d <strtol+0x144>
  80249a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <ltostr>:

void
ltostr(long value, char *str)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8024a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8024ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8024b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b7:	79 13                	jns    8024cc <ltostr+0x2d>
	{
		neg = 1;
  8024b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8024c6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8024c9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8024d4:	99                   	cltd   
  8024d5:	f7 f9                	idiv   %ecx
  8024d7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8024da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024dd:	8d 50 01             	lea    0x1(%eax),%edx
  8024e0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024e3:	89 c2                	mov    %eax,%edx
  8024e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e8:	01 d0                	add    %edx,%eax
  8024ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024ed:	83 c2 30             	add    $0x30,%edx
  8024f0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8024f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8024fa:	f7 e9                	imul   %ecx
  8024fc:	c1 fa 02             	sar    $0x2,%edx
  8024ff:	89 c8                	mov    %ecx,%eax
  802501:	c1 f8 1f             	sar    $0x1f,%eax
  802504:	29 c2                	sub    %eax,%edx
  802506:	89 d0                	mov    %edx,%eax
  802508:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80250b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250f:	75 bb                	jne    8024cc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80251b:	48                   	dec    %eax
  80251c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80251f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802523:	74 3d                	je     802562 <ltostr+0xc3>
		start = 1 ;
  802525:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80252c:	eb 34                	jmp    802562 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80252e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802531:	8b 45 0c             	mov    0xc(%ebp),%eax
  802534:	01 d0                	add    %edx,%eax
  802536:	8a 00                	mov    (%eax),%al
  802538:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80253b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802541:	01 c2                	add    %eax,%edx
  802543:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802546:	8b 45 0c             	mov    0xc(%ebp),%eax
  802549:	01 c8                	add    %ecx,%eax
  80254b:	8a 00                	mov    (%eax),%al
  80254d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80254f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802552:	8b 45 0c             	mov    0xc(%ebp),%eax
  802555:	01 c2                	add    %eax,%edx
  802557:	8a 45 eb             	mov    -0x15(%ebp),%al
  80255a:	88 02                	mov    %al,(%edx)
		start++ ;
  80255c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80255f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802568:	7c c4                	jl     80252e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80256a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80256d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802570:	01 d0                	add    %edx,%eax
  802572:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802575:	90                   	nop
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80257e:	ff 75 08             	pushl  0x8(%ebp)
  802581:	e8 c4 f9 ff ff       	call   801f4a <strlen>
  802586:	83 c4 04             	add    $0x4,%esp
  802589:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80258c:	ff 75 0c             	pushl  0xc(%ebp)
  80258f:	e8 b6 f9 ff ff       	call   801f4a <strlen>
  802594:	83 c4 04             	add    $0x4,%esp
  802597:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80259a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8025a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8025a8:	eb 17                	jmp    8025c1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8025aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b0:	01 c2                	add    %eax,%edx
  8025b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	01 c8                	add    %ecx,%eax
  8025ba:	8a 00                	mov    (%eax),%al
  8025bc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8025be:	ff 45 fc             	incl   -0x4(%ebp)
  8025c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025c7:	7c e1                	jl     8025aa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8025c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8025d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8025d7:	eb 1f                	jmp    8025f8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8025d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025dc:	8d 50 01             	lea    0x1(%eax),%edx
  8025df:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8025e2:	89 c2                	mov    %eax,%edx
  8025e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e7:	01 c2                	add    %eax,%edx
  8025e9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8025ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ef:	01 c8                	add    %ecx,%eax
  8025f1:	8a 00                	mov    (%eax),%al
  8025f3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8025f5:	ff 45 f8             	incl   -0x8(%ebp)
  8025f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025fe:	7c d9                	jl     8025d9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802600:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802603:	8b 45 10             	mov    0x10(%ebp),%eax
  802606:	01 d0                	add    %edx,%eax
  802608:	c6 00 00             	movb   $0x0,(%eax)
}
  80260b:	90                   	nop
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802611:	8b 45 14             	mov    0x14(%ebp),%eax
  802614:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80261a:	8b 45 14             	mov    0x14(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802626:	8b 45 10             	mov    0x10(%ebp),%eax
  802629:	01 d0                	add    %edx,%eax
  80262b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802631:	eb 0c                	jmp    80263f <strsplit+0x31>
			*string++ = 0;
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	8d 50 01             	lea    0x1(%eax),%edx
  802639:	89 55 08             	mov    %edx,0x8(%ebp)
  80263c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	8a 00                	mov    (%eax),%al
  802644:	84 c0                	test   %al,%al
  802646:	74 18                	je     802660 <strsplit+0x52>
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	8a 00                	mov    (%eax),%al
  80264d:	0f be c0             	movsbl %al,%eax
  802650:	50                   	push   %eax
  802651:	ff 75 0c             	pushl  0xc(%ebp)
  802654:	e8 83 fa ff ff       	call   8020dc <strchr>
  802659:	83 c4 08             	add    $0x8,%esp
  80265c:	85 c0                	test   %eax,%eax
  80265e:	75 d3                	jne    802633 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8a 00                	mov    (%eax),%al
  802665:	84 c0                	test   %al,%al
  802667:	74 5a                	je     8026c3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802669:	8b 45 14             	mov    0x14(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	83 f8 0f             	cmp    $0xf,%eax
  802671:	75 07                	jne    80267a <strsplit+0x6c>
		{
			return 0;
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
  802678:	eb 66                	jmp    8026e0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80267a:	8b 45 14             	mov    0x14(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	8d 48 01             	lea    0x1(%eax),%ecx
  802682:	8b 55 14             	mov    0x14(%ebp),%edx
  802685:	89 0a                	mov    %ecx,(%edx)
  802687:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80268e:	8b 45 10             	mov    0x10(%ebp),%eax
  802691:	01 c2                	add    %eax,%edx
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802698:	eb 03                	jmp    80269d <strsplit+0x8f>
			string++;
  80269a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	8a 00                	mov    (%eax),%al
  8026a2:	84 c0                	test   %al,%al
  8026a4:	74 8b                	je     802631 <strsplit+0x23>
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	8a 00                	mov    (%eax),%al
  8026ab:	0f be c0             	movsbl %al,%eax
  8026ae:	50                   	push   %eax
  8026af:	ff 75 0c             	pushl  0xc(%ebp)
  8026b2:	e8 25 fa ff ff       	call   8020dc <strchr>
  8026b7:	83 c4 08             	add    $0x8,%esp
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	74 dc                	je     80269a <strsplit+0x8c>
			string++;
	}
  8026be:	e9 6e ff ff ff       	jmp    802631 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8026c3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8026c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8026d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d3:	01 d0                	add    %edx,%eax
  8026d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8026db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8026ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026f5:	eb 4a                	jmp    802741 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8026f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	01 c2                	add    %eax,%edx
  8026ff:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802702:	8b 45 0c             	mov    0xc(%ebp),%eax
  802705:	01 c8                	add    %ecx,%eax
  802707:	8a 00                	mov    (%eax),%al
  802709:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80270b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80270e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802711:	01 d0                	add    %edx,%eax
  802713:	8a 00                	mov    (%eax),%al
  802715:	3c 40                	cmp    $0x40,%al
  802717:	7e 25                	jle    80273e <str2lower+0x5c>
  802719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80271c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271f:	01 d0                	add    %edx,%eax
  802721:	8a 00                	mov    (%eax),%al
  802723:	3c 5a                	cmp    $0x5a,%al
  802725:	7f 17                	jg     80273e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802727:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	01 d0                	add    %edx,%eax
  80272f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802732:	8b 55 08             	mov    0x8(%ebp),%edx
  802735:	01 ca                	add    %ecx,%edx
  802737:	8a 12                	mov    (%edx),%dl
  802739:	83 c2 20             	add    $0x20,%edx
  80273c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80273e:	ff 45 fc             	incl   -0x4(%ebp)
  802741:	ff 75 0c             	pushl  0xc(%ebp)
  802744:	e8 01 f8 ff ff       	call   801f4a <strlen>
  802749:	83 c4 04             	add    $0x4,%esp
  80274c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80274f:	7f a6                	jg     8026f7 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802751:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  80275c:	83 ec 0c             	sub    $0xc,%esp
  80275f:	6a 10                	push   $0x10
  802761:	e8 b2 15 00 00       	call   803d18 <alloc_block>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  80276c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802770:	75 14                	jne    802786 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  802772:	83 ec 04             	sub    $0x4,%esp
  802775:	68 48 57 80 00       	push   $0x805748
  80277a:	6a 14                	push   $0x14
  80277c:	68 71 57 80 00       	push   $0x805771
  802781:	e8 fd ed ff ff       	call   801583 <_panic>

	node->start = start;
  802786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802789:	8b 55 08             	mov    0x8(%ebp),%edx
  80278c:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80278e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802791:	8b 55 0c             	mov    0xc(%ebp),%edx
  802794:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802797:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80279e:	a1 04 62 80 00       	mov    0x806204,%eax
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a6:	eb 18                	jmp    8027c0 <insert_page_alloc+0x6a>
		if (start < it->start)
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b0:	77 37                	ja     8027e9 <insert_page_alloc+0x93>
			break;
		prev = it;
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8027b8:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8027bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c4:	74 08                	je     8027ce <insert_page_alloc+0x78>
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 40 08             	mov    0x8(%eax),%eax
  8027cc:	eb 05                	jmp    8027d3 <insert_page_alloc+0x7d>
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d3:	a3 0c 62 80 00       	mov    %eax,0x80620c
  8027d8:	a1 0c 62 80 00       	mov    0x80620c,%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	75 c7                	jne    8027a8 <insert_page_alloc+0x52>
  8027e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e5:	75 c1                	jne    8027a8 <insert_page_alloc+0x52>
  8027e7:	eb 01                	jmp    8027ea <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8027e9:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8027ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ee:	75 64                	jne    802854 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8027f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027f4:	75 14                	jne    80280a <insert_page_alloc+0xb4>
  8027f6:	83 ec 04             	sub    $0x4,%esp
  8027f9:	68 80 57 80 00       	push   $0x805780
  8027fe:	6a 21                	push   $0x21
  802800:	68 71 57 80 00       	push   $0x805771
  802805:	e8 79 ed ff ff       	call   801583 <_panic>
  80280a:	8b 15 04 62 80 00    	mov    0x806204,%edx
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	89 50 08             	mov    %edx,0x8(%eax)
  802816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802819:	8b 40 08             	mov    0x8(%eax),%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	74 0d                	je     80282d <insert_page_alloc+0xd7>
  802820:	a1 04 62 80 00       	mov    0x806204,%eax
  802825:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802828:	89 50 0c             	mov    %edx,0xc(%eax)
  80282b:	eb 08                	jmp    802835 <insert_page_alloc+0xdf>
  80282d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802830:	a3 08 62 80 00       	mov    %eax,0x806208
  802835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802838:	a3 04 62 80 00       	mov    %eax,0x806204
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802847:	a1 10 62 80 00       	mov    0x806210,%eax
  80284c:	40                   	inc    %eax
  80284d:	a3 10 62 80 00       	mov    %eax,0x806210
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  802852:	eb 71                	jmp    8028c5 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802854:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802858:	74 06                	je     802860 <insert_page_alloc+0x10a>
  80285a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80285e:	75 14                	jne    802874 <insert_page_alloc+0x11e>
  802860:	83 ec 04             	sub    $0x4,%esp
  802863:	68 a4 57 80 00       	push   $0x8057a4
  802868:	6a 23                	push   $0x23
  80286a:	68 71 57 80 00       	push   $0x805771
  80286f:	e8 0f ed ff ff       	call   801583 <_panic>
  802874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802877:	8b 50 08             	mov    0x8(%eax),%edx
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	89 50 08             	mov    %edx,0x8(%eax)
  802880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802883:	8b 40 08             	mov    0x8(%eax),%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	74 0c                	je     802896 <insert_page_alloc+0x140>
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 40 08             	mov    0x8(%eax),%eax
  802890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802893:	89 50 0c             	mov    %edx,0xc(%eax)
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80289c:	89 50 08             	mov    %edx,0x8(%eax)
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a5:	89 50 0c             	mov    %edx,0xc(%eax)
  8028a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ab:	8b 40 08             	mov    0x8(%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	75 08                	jne    8028ba <insert_page_alloc+0x164>
  8028b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b5:	a3 08 62 80 00       	mov    %eax,0x806208
  8028ba:	a1 10 62 80 00       	mov    0x806210,%eax
  8028bf:	40                   	inc    %eax
  8028c0:	a3 10 62 80 00       	mov    %eax,0x806210
}
  8028c5:	90                   	nop
  8028c6:	c9                   	leave  
  8028c7:	c3                   	ret    

008028c8 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
  8028cb:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8028ce:	a1 04 62 80 00       	mov    0x806204,%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	75 0c                	jne    8028e3 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8028d7:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8028dc:	a3 50 e2 81 00       	mov    %eax,0x81e250
		return;
  8028e1:	eb 67                	jmp    80294a <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8028e3:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8028e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8028eb:	a1 04 62 80 00       	mov    0x806204,%eax
  8028f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8028f3:	eb 26                	jmp    80291b <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8028f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028f8:	8b 10                	mov    (%eax),%edx
  8028fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	01 d0                	add    %edx,%eax
  802902:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80290b:	76 06                	jbe    802913 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802913:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802918:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80291b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80291f:	74 08                	je     802929 <recompute_page_alloc_break+0x61>
  802921:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802924:	8b 40 08             	mov    0x8(%eax),%eax
  802927:	eb 05                	jmp    80292e <recompute_page_alloc_break+0x66>
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
  80292e:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802933:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	75 b9                	jne    8028f5 <recompute_page_alloc_break+0x2d>
  80293c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802940:	75 b3                	jne    8028f5 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  802942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802945:	a3 50 e2 81 00       	mov    %eax,0x81e250
}
  80294a:	c9                   	leave  
  80294b:	c3                   	ret    

0080294c <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  802952:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802959:	8b 55 08             	mov    0x8(%ebp),%edx
  80295c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80295f:	01 d0                	add    %edx,%eax
  802961:	48                   	dec    %eax
  802962:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802968:	ba 00 00 00 00       	mov    $0x0,%edx
  80296d:	f7 75 d8             	divl   -0x28(%ebp)
  802970:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802973:	29 d0                	sub    %edx,%eax
  802975:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  802978:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80297c:	75 0a                	jne    802988 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
  802983:	e9 7e 01 00 00       	jmp    802b06 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  802988:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80298f:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  802993:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  80299a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8029a1:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8029a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8029a9:	a1 04 62 80 00       	mov    0x806204,%eax
  8029ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8029b1:	eb 69                	jmp    802a1c <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8029b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8029bb:	76 47                	jbe    802a04 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8029bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8029c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029cb:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8029ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029d1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8029d4:	72 2e                	jb     802a04 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8029d6:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8029da:	75 14                	jne    8029f0 <alloc_pages_custom_fit+0xa4>
  8029dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029df:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8029e2:	75 0c                	jne    8029f0 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8029e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8029ea:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8029ee:	eb 14                	jmp    802a04 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8029f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029f3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029f6:	76 0c                	jbe    802a04 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8029f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8029fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a01:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a07:	8b 10                	mov    (%eax),%edx
  802a09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0c:	8b 40 04             	mov    0x4(%eax),%eax
  802a0f:	01 d0                	add    %edx,%eax
  802a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802a14:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802a19:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802a1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a20:	74 08                	je     802a2a <alloc_pages_custom_fit+0xde>
  802a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a25:	8b 40 08             	mov    0x8(%eax),%eax
  802a28:	eb 05                	jmp    802a2f <alloc_pages_custom_fit+0xe3>
  802a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2f:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802a34:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	0f 85 72 ff ff ff    	jne    8029b3 <alloc_pages_custom_fit+0x67>
  802a41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a45:	0f 85 68 ff ff ff    	jne    8029b3 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802a4b:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802a50:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a53:	76 47                	jbe    802a9c <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a58:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802a5b:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802a60:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a63:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802a66:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a69:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a6c:	72 2e                	jb     802a9c <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802a6e:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802a72:	75 14                	jne    802a88 <alloc_pages_custom_fit+0x13c>
  802a74:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a77:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a7a:	75 0c                	jne    802a88 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802a7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802a82:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802a86:	eb 14                	jmp    802a9c <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802a88:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a8b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a8e:	76 0c                	jbe    802a9c <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802a90:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a93:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802a96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a99:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802a9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  802aa3:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802aa7:	74 08                	je     802ab1 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802aaf:	eb 40                	jmp    802af1 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab5:	74 08                	je     802abf <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  802ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802abd:	eb 32                	jmp    802af1 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802abf:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802ac4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802ac7:	89 c2                	mov    %eax,%edx
  802ac9:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802ace:	39 c2                	cmp    %eax,%edx
  802ad0:	73 07                	jae    802ad9 <alloc_pages_custom_fit+0x18d>
			return NULL;
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad7:	eb 2d                	jmp    802b06 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802ad9:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802ade:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802ae1:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802ae7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802aea:	01 d0                	add    %edx,%eax
  802aec:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}


	insert_page_alloc((uint32)result, required_size);
  802af1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802af4:	83 ec 08             	sub    $0x8,%esp
  802af7:	ff 75 d0             	pushl  -0x30(%ebp)
  802afa:	50                   	push   %eax
  802afb:	e8 56 fc ff ff       	call   802756 <insert_page_alloc>
  802b00:	83 c4 10             	add    $0x10,%esp

	return result;
  802b03:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
  802b0b:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b14:	a1 04 62 80 00       	mov    0x806204,%eax
  802b19:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b1c:	eb 1a                	jmp    802b38 <find_allocated_size+0x30>
		if (it->start == va)
  802b1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802b26:	75 08                	jne    802b30 <find_allocated_size+0x28>
			return it->size;
  802b28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b2b:	8b 40 04             	mov    0x4(%eax),%eax
  802b2e:	eb 34                	jmp    802b64 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b30:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802b35:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b38:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b3c:	74 08                	je     802b46 <find_allocated_size+0x3e>
  802b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	eb 05                	jmp    802b4b <find_allocated_size+0x43>
  802b46:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4b:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802b50:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	75 c5                	jne    802b1e <find_allocated_size+0x16>
  802b59:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b5d:	75 bf                	jne    802b1e <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b72:	a1 04 62 80 00       	mov    0x806204,%eax
  802b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7a:	e9 e1 01 00 00       	jmp    802d60 <free_pages+0x1fa>
		if (it->start == va) {
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b87:	0f 85 cb 01 00 00    	jne    802d58 <free_pages+0x1f2>

			uint32 start = it->start;
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba1:	f7 d0                	not    %eax
  802ba3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ba6:	73 1d                	jae    802bc5 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  802ba8:	83 ec 0c             	sub    $0xc,%esp
  802bab:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bae:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb1:	68 d8 57 80 00       	push   $0x8057d8
  802bb6:	68 a5 00 00 00       	push   $0xa5
  802bbb:	68 71 57 80 00       	push   $0x805771
  802bc0:	e8 be e9 ff ff       	call   801583 <_panic>
			}

			uint32 start_end = start + size;
  802bc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcb:	01 d0                	add    %edx,%eax
  802bcd:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	79 19                	jns    802bf0 <free_pages+0x8a>
  802bd7:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802bde:	77 10                	ja     802bf0 <free_pages+0x8a>
  802be0:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  802be7:	77 07                	ja     802bf0 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	78 2c                	js     802c1c <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf3:	83 ec 0c             	sub    $0xc,%esp
  802bf6:	68 00 00 00 a0       	push   $0xa0000000
  802bfb:	ff 75 e0             	pushl  -0x20(%ebp)
  802bfe:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c01:	ff 75 e8             	pushl  -0x18(%ebp)
  802c04:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c07:	50                   	push   %eax
  802c08:	68 1c 58 80 00       	push   $0x80581c
  802c0d:	68 ad 00 00 00       	push   $0xad
  802c12:	68 71 57 80 00       	push   $0x805771
  802c17:	e8 67 e9 ff ff       	call   801583 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c22:	e9 88 00 00 00       	jmp    802caf <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802c27:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802c2e:	76 17                	jbe    802c47 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802c30:	ff 75 f0             	pushl  -0x10(%ebp)
  802c33:	68 80 58 80 00       	push   $0x805880
  802c38:	68 b4 00 00 00       	push   $0xb4
  802c3d:	68 71 57 80 00       	push   $0x805771
  802c42:	e8 3c e9 ff ff       	call   801583 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	05 00 10 00 00       	add    $0x1000,%eax
  802c4f:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	79 2e                	jns    802c87 <free_pages+0x121>
  802c59:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802c60:	77 25                	ja     802c87 <free_pages+0x121>
  802c62:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802c69:	77 1c                	ja     802c87 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802c6b:	83 ec 08             	sub    $0x8,%esp
  802c6e:	68 00 10 00 00       	push   $0x1000
  802c73:	ff 75 f0             	pushl  -0x10(%ebp)
  802c76:	e8 38 0d 00 00       	call   8039b3 <sys_free_user_mem>
  802c7b:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802c7e:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802c85:	eb 28                	jmp    802caf <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	68 00 00 00 a0       	push   $0xa0000000
  802c8f:	ff 75 dc             	pushl  -0x24(%ebp)
  802c92:	68 00 10 00 00       	push   $0x1000
  802c97:	ff 75 f0             	pushl  -0x10(%ebp)
  802c9a:	50                   	push   %eax
  802c9b:	68 c0 58 80 00       	push   $0x8058c0
  802ca0:	68 bd 00 00 00       	push   $0xbd
  802ca5:	68 71 57 80 00       	push   $0x805771
  802caa:	e8 d4 e8 ff ff       	call   801583 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cb5:	0f 82 6c ff ff ff    	jb     802c27 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbf:	75 17                	jne    802cd8 <free_pages+0x172>
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	68 22 59 80 00       	push   $0x805922
  802cc9:	68 c1 00 00 00       	push   $0xc1
  802cce:	68 71 57 80 00       	push   $0x805771
  802cd3:	e8 ab e8 ff ff       	call   801583 <_panic>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 40 08             	mov    0x8(%eax),%eax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	74 11                	je     802cf3 <free_pages+0x18d>
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 08             	mov    0x8(%eax),%eax
  802ce8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ceb:	8b 52 0c             	mov    0xc(%edx),%edx
  802cee:	89 50 0c             	mov    %edx,0xc(%eax)
  802cf1:	eb 0b                	jmp    802cfe <free_pages+0x198>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	a3 08 62 80 00       	mov    %eax,0x806208
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 40 0c             	mov    0xc(%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 11                	je     802d19 <free_pages+0x1b3>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d11:	8b 52 08             	mov    0x8(%edx),%edx
  802d14:	89 50 08             	mov    %edx,0x8(%eax)
  802d17:	eb 0b                	jmp    802d24 <free_pages+0x1be>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 08             	mov    0x8(%eax),%eax
  802d1f:	a3 04 62 80 00       	mov    %eax,0x806204
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d38:	a1 10 62 80 00       	mov    0x806210,%eax
  802d3d:	48                   	dec    %eax
  802d3e:	a3 10 62 80 00       	mov    %eax,0x806210
			free_block(it);
  802d43:	83 ec 0c             	sub    $0xc,%esp
  802d46:	ff 75 f4             	pushl  -0xc(%ebp)
  802d49:	e8 24 15 00 00       	call   804272 <free_block>
  802d4e:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802d51:	e8 72 fb ff ff       	call   8028c8 <recompute_page_alloc_break>

			return;
  802d56:	eb 37                	jmp    802d8f <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802d58:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d64:	74 08                	je     802d6e <free_pages+0x208>
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 08             	mov    0x8(%eax),%eax
  802d6c:	eb 05                	jmp    802d73 <free_pages+0x20d>
  802d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d73:	a3 0c 62 80 00       	mov    %eax,0x80620c
  802d78:	a1 0c 62 80 00       	mov    0x80620c,%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	0f 85 fa fd ff ff    	jne    802b7f <free_pages+0x19>
  802d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d89:	0f 85 f0 fd ff ff    	jne    802b7f <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802d8f:	c9                   	leave  
  802d90:	c3                   	ret    

00802d91 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802d91:	55                   	push   %ebp
  802d92:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802d94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d99:	5d                   	pop    %ebp
  802d9a:	c3                   	ret    

00802d9b <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802d9b:	55                   	push   %ebp
  802d9c:	89 e5                	mov    %esp,%ebp
  802d9e:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802da1:	a1 08 60 80 00       	mov    0x806008,%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 60                	je     802e0a <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802daa:	83 ec 08             	sub    $0x8,%esp
  802dad:	68 00 00 00 82       	push   $0x82000000
  802db2:	68 00 00 00 80       	push   $0x80000000
  802db7:	e8 0d 0d 00 00       	call   803ac9 <initialize_dynamic_allocator>
  802dbc:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802dbf:	e8 f3 0a 00 00       	call   8038b7 <sys_get_uheap_strategy>
  802dc4:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802dc9:	a1 20 62 80 00       	mov    0x806220,%eax
  802dce:	05 00 10 00 00       	add    $0x1000,%eax
  802dd3:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802dd8:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802ddd:	a3 50 e2 81 00       	mov    %eax,0x81e250

		LIST_INIT(&page_alloc_list);
  802de2:	c7 05 04 62 80 00 00 	movl   $0x0,0x806204
  802de9:	00 00 00 
  802dec:	c7 05 08 62 80 00 00 	movl   $0x0,0x806208
  802df3:	00 00 00 
  802df6:	c7 05 10 62 80 00 00 	movl   $0x0,0x806210
  802dfd:	00 00 00 

		__firstTimeFlag = 0;
  802e00:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802e07:	00 00 00 
	}
}
  802e0a:	90                   	nop
  802e0b:	c9                   	leave  
  802e0c:	c3                   	ret    

00802e0d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
  802e10:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e21:	83 ec 08             	sub    $0x8,%esp
  802e24:	68 06 04 00 00       	push   $0x406
  802e29:	50                   	push   %eax
  802e2a:	e8 d2 06 00 00       	call   803501 <__sys_allocate_page>
  802e2f:	83 c4 10             	add    $0x10,%esp
  802e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802e35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e39:	79 17                	jns    802e52 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	68 40 59 80 00       	push   $0x805940
  802e43:	68 ea 00 00 00       	push   $0xea
  802e48:	68 71 57 80 00       	push   $0x805771
  802e4d:	e8 31 e7 ff ff       	call   801583 <_panic>
	return 0;
  802e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
  802e5c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e6d:	83 ec 0c             	sub    $0xc,%esp
  802e70:	50                   	push   %eax
  802e71:	e8 d2 06 00 00       	call   803548 <__sys_unmap_frame>
  802e76:	83 c4 10             	add    $0x10,%esp
  802e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802e7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e80:	79 17                	jns    802e99 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802e82:	83 ec 04             	sub    $0x4,%esp
  802e85:	68 7c 59 80 00       	push   $0x80597c
  802e8a:	68 f5 00 00 00       	push   $0xf5
  802e8f:	68 71 57 80 00       	push   $0x805771
  802e94:	e8 ea e6 ff ff       	call   801583 <_panic>
}
  802e99:	90                   	nop
  802e9a:	c9                   	leave  
  802e9b:	c3                   	ret    

00802e9c <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802e9c:	55                   	push   %ebp
  802e9d:	89 e5                	mov    %esp,%ebp
  802e9f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802ea2:	e8 f4 fe ff ff       	call   802d9b <uheap_init>
	if (size == 0) return NULL ;
  802ea7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eab:	75 0a                	jne    802eb7 <malloc+0x1b>
  802ead:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb2:	e9 67 01 00 00       	jmp    80301e <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802eb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802ebe:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802ec5:	77 16                	ja     802edd <malloc+0x41>
		result = alloc_block(size);
  802ec7:	83 ec 0c             	sub    $0xc,%esp
  802eca:	ff 75 08             	pushl  0x8(%ebp)
  802ecd:	e8 46 0e 00 00       	call   803d18 <alloc_block>
  802ed2:	83 c4 10             	add    $0x10,%esp
  802ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed8:	e9 3e 01 00 00       	jmp    80301b <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802edd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eea:	01 d0                	add    %edx,%eax
  802eec:	48                   	dec    %eax
  802eed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef8:	f7 75 f0             	divl   -0x10(%ebp)
  802efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efe:	29 d0                	sub    %edx,%eax
  802f00:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802f03:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	75 0a                	jne    802f16 <malloc+0x7a>
			return NULL;
  802f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f11:	e9 08 01 00 00       	jmp    80301e <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802f16:	a1 50 e2 81 00       	mov    0x81e250,%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0f                	je     802f2e <malloc+0x92>
  802f1f:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  802f25:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802f2a:	39 c2                	cmp    %eax,%edx
  802f2c:	73 0a                	jae    802f38 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802f2e:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802f33:	a3 50 e2 81 00       	mov    %eax,0x81e250
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802f38:	a1 44 e2 81 00       	mov    0x81e244,%eax
  802f3d:	83 f8 05             	cmp    $0x5,%eax
  802f40:	75 11                	jne    802f53 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802f42:	83 ec 0c             	sub    $0xc,%esp
  802f45:	ff 75 e8             	pushl  -0x18(%ebp)
  802f48:	e8 ff f9 ff ff       	call   80294c <alloc_pages_custom_fit>
  802f4d:	83 c4 10             	add    $0x10,%esp
  802f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802f53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f57:	0f 84 be 00 00 00    	je     80301b <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802f63:	83 ec 0c             	sub    $0xc,%esp
  802f66:	ff 75 f4             	pushl  -0xc(%ebp)
  802f69:	e8 9a fb ff ff       	call   802b08 <find_allocated_size>
  802f6e:	83 c4 10             	add    $0x10,%esp
  802f71:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802f74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f78:	75 17                	jne    802f91 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802f7a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f7d:	68 bc 59 80 00       	push   $0x8059bc
  802f82:	68 24 01 00 00       	push   $0x124
  802f87:	68 71 57 80 00       	push   $0x805771
  802f8c:	e8 f2 e5 ff ff       	call   801583 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802f91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f94:	f7 d0                	not    %eax
  802f96:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f99:	73 1d                	jae    802fb8 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802f9b:	83 ec 0c             	sub    $0xc,%esp
  802f9e:	ff 75 e0             	pushl  -0x20(%ebp)
  802fa1:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fa4:	68 04 5a 80 00       	push   $0x805a04
  802fa9:	68 29 01 00 00       	push   $0x129
  802fae:	68 71 57 80 00       	push   $0x805771
  802fb3:	e8 cb e5 ff ff       	call   801583 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802fb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbe:	01 d0                	add    %edx,%eax
  802fc0:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	79 2c                	jns    802ff6 <malloc+0x15a>
  802fca:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802fd1:	77 23                	ja     802ff6 <malloc+0x15a>
  802fd3:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802fda:	77 1a                	ja     802ff6 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	79 13                	jns    802ff6 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802fe3:	83 ec 08             	sub    $0x8,%esp
  802fe6:	ff 75 e0             	pushl  -0x20(%ebp)
  802fe9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fec:	e8 de 09 00 00       	call   8039cf <sys_allocate_user_mem>
  802ff1:	83 c4 10             	add    $0x10,%esp
  802ff4:	eb 25                	jmp    80301b <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802ff6:	68 00 00 00 a0       	push   $0xa0000000
  802ffb:	ff 75 dc             	pushl  -0x24(%ebp)
  802ffe:	ff 75 e0             	pushl  -0x20(%ebp)
  803001:	ff 75 e4             	pushl  -0x1c(%ebp)
  803004:	ff 75 f4             	pushl  -0xc(%ebp)
  803007:	68 40 5a 80 00       	push   $0x805a40
  80300c:	68 33 01 00 00       	push   $0x133
  803011:	68 71 57 80 00       	push   $0x805771
  803016:	e8 68 e5 ff ff       	call   801583 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  80301e:	c9                   	leave  
  80301f:	c3                   	ret    

00803020 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
  803023:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803026:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302a:	0f 84 26 01 00 00    	je     803156 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	79 1c                	jns    803059 <free+0x39>
  80303d:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  803044:	77 13                	ja     803059 <free+0x39>
		free_block(virtual_address);
  803046:	83 ec 0c             	sub    $0xc,%esp
  803049:	ff 75 08             	pushl  0x8(%ebp)
  80304c:	e8 21 12 00 00       	call   804272 <free_block>
  803051:	83 c4 10             	add    $0x10,%esp
		return;
  803054:	e9 01 01 00 00       	jmp    80315a <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  803059:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80305e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  803061:	0f 82 d8 00 00 00    	jb     80313f <free+0x11f>
  803067:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  80306e:	0f 87 cb 00 00 00    	ja     80313f <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	25 ff 0f 00 00       	and    $0xfff,%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	74 17                	je     803097 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  803080:	ff 75 08             	pushl  0x8(%ebp)
  803083:	68 b0 5a 80 00       	push   $0x805ab0
  803088:	68 57 01 00 00       	push   $0x157
  80308d:	68 71 57 80 00       	push   $0x805771
  803092:	e8 ec e4 ff ff       	call   801583 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  803097:	83 ec 0c             	sub    $0xc,%esp
  80309a:	ff 75 08             	pushl  0x8(%ebp)
  80309d:	e8 66 fa ff ff       	call   802b08 <find_allocated_size>
  8030a2:	83 c4 10             	add    $0x10,%esp
  8030a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8030a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ac:	0f 84 a7 00 00 00    	je     803159 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	f7 d0                	not    %eax
  8030b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8030ba:	73 1d                	jae    8030d9 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8030bc:	83 ec 0c             	sub    $0xc,%esp
  8030bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8030c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8030c5:	68 d8 5a 80 00       	push   $0x805ad8
  8030ca:	68 61 01 00 00       	push   $0x161
  8030cf:	68 71 57 80 00       	push   $0x805771
  8030d4:	e8 aa e4 ff ff       	call   801583 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8030d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030df:	01 d0                	add    %edx,%eax
  8030e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	79 19                	jns    803104 <free+0xe4>
  8030eb:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8030f2:	77 10                	ja     803104 <free+0xe4>
  8030f4:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8030fb:	77 07                	ja     803104 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8030fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	78 2b                	js     80312f <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  803104:	83 ec 0c             	sub    $0xc,%esp
  803107:	68 00 00 00 a0       	push   $0xa0000000
  80310c:	ff 75 ec             	pushl  -0x14(%ebp)
  80310f:	ff 75 f0             	pushl  -0x10(%ebp)
  803112:	ff 75 f4             	pushl  -0xc(%ebp)
  803115:	ff 75 f0             	pushl  -0x10(%ebp)
  803118:	ff 75 08             	pushl  0x8(%ebp)
  80311b:	68 14 5b 80 00       	push   $0x805b14
  803120:	68 69 01 00 00       	push   $0x169
  803125:	68 71 57 80 00       	push   $0x805771
  80312a:	e8 54 e4 ff ff       	call   801583 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80312f:	83 ec 0c             	sub    $0xc,%esp
  803132:	ff 75 08             	pushl  0x8(%ebp)
  803135:	e8 2c fa ff ff       	call   802b66 <free_pages>
  80313a:	83 c4 10             	add    $0x10,%esp
		return;
  80313d:	eb 1b                	jmp    80315a <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80313f:	ff 75 08             	pushl  0x8(%ebp)
  803142:	68 70 5b 80 00       	push   $0x805b70
  803147:	68 70 01 00 00       	push   $0x170
  80314c:	68 71 57 80 00       	push   $0x805771
  803151:	e8 2d e4 ff ff       	call   801583 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  803156:	90                   	nop
  803157:	eb 01                	jmp    80315a <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  803159:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  80315a:	c9                   	leave  
  80315b:	c3                   	ret    

0080315c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80315c:	55                   	push   %ebp
  80315d:	89 e5                	mov    %esp,%ebp
  80315f:	83 ec 38             	sub    $0x38,%esp
  803162:	8b 45 10             	mov    0x10(%ebp),%eax
  803165:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803168:	e8 2e fc ff ff       	call   802d9b <uheap_init>
	if (size == 0) return NULL ;
  80316d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803171:	75 0a                	jne    80317d <smalloc+0x21>
  803173:	b8 00 00 00 00       	mov    $0x0,%eax
  803178:	e9 3d 01 00 00       	jmp    8032ba <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80317d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803180:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  803183:	8b 45 0c             	mov    0xc(%ebp),%eax
  803186:	25 ff 0f 00 00       	and    $0xfff,%eax
  80318b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80318e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803192:	74 0e                	je     8031a2 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80319a:	05 00 10 00 00       	add    $0x1000,%eax
  80319f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8031a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a5:	c1 e8 0c             	shr    $0xc,%eax
  8031a8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8031ab:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	75 0a                	jne    8031be <smalloc+0x62>
		return NULL;
  8031b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b9:	e9 fc 00 00 00       	jmp    8032ba <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8031be:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	74 0f                	je     8031d6 <smalloc+0x7a>
  8031c7:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8031cd:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8031d2:	39 c2                	cmp    %eax,%edx
  8031d4:	73 0a                	jae    8031e0 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8031d6:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8031db:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8031e0:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8031e5:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8031ea:	29 c2                	sub    %eax,%edx
  8031ec:	89 d0                	mov    %edx,%eax
  8031ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8031f1:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8031f7:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  8031fc:	29 c2                	sub    %eax,%edx
  8031fe:	89 d0                	mov    %edx,%eax
  803200:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803209:	77 13                	ja     80321e <smalloc+0xc2>
  80320b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803211:	77 0b                	ja     80321e <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  803213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803216:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803219:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80321c:	73 0a                	jae    803228 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80321e:	b8 00 00 00 00       	mov    $0x0,%eax
  803223:	e9 92 00 00 00       	jmp    8032ba <smalloc+0x15e>
	}

	void *va = NULL;
  803228:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80322f:	a1 44 e2 81 00       	mov    0x81e244,%eax
  803234:	83 f8 05             	cmp    $0x5,%eax
  803237:	75 11                	jne    80324a <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  803239:	83 ec 0c             	sub    $0xc,%esp
  80323c:	ff 75 f4             	pushl  -0xc(%ebp)
  80323f:	e8 08 f7 ff ff       	call   80294c <alloc_pages_custom_fit>
  803244:	83 c4 10             	add    $0x10,%esp
  803247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  80324a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80324e:	75 27                	jne    803277 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  803250:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  803257:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325a:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80325d:	89 c2                	mov    %eax,%edx
  80325f:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803264:	39 c2                	cmp    %eax,%edx
  803266:	73 07                	jae    80326f <smalloc+0x113>
			return NULL;}
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
  80326d:	eb 4b                	jmp    8032ba <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80326f:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  803277:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80327b:	ff 75 f0             	pushl  -0x10(%ebp)
  80327e:	50                   	push   %eax
  80327f:	ff 75 0c             	pushl  0xc(%ebp)
  803282:	ff 75 08             	pushl  0x8(%ebp)
  803285:	e8 cb 03 00 00       	call   803655 <sys_create_shared_object>
  80328a:	83 c4 10             	add    $0x10,%esp
  80328d:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  803290:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803294:	79 07                	jns    80329d <smalloc+0x141>
		return NULL;
  803296:	b8 00 00 00 00       	mov    $0x0,%eax
  80329b:	eb 1d                	jmp    8032ba <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80329d:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8032a2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8032a5:	75 10                	jne    8032b7 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8032a7:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	01 d0                	add    %edx,%eax
  8032b2:	a3 50 e2 81 00       	mov    %eax,0x81e250
	}

	return va;
  8032b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8032ba:	c9                   	leave  
  8032bb:	c3                   	ret    

008032bc <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8032bc:	55                   	push   %ebp
  8032bd:	89 e5                	mov    %esp,%ebp
  8032bf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8032c2:	e8 d4 fa ff ff       	call   802d9b <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8032c7:	83 ec 08             	sub    $0x8,%esp
  8032ca:	ff 75 0c             	pushl  0xc(%ebp)
  8032cd:	ff 75 08             	pushl  0x8(%ebp)
  8032d0:	e8 aa 03 00 00       	call   80367f <sys_size_of_shared_object>
  8032d5:	83 c4 10             	add    $0x10,%esp
  8032d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8032db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032df:	7f 0a                	jg     8032eb <sget+0x2f>
		return NULL;
  8032e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e6:	e9 32 01 00 00       	jmp    80341d <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8032eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8032f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8032f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8032fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803300:	74 0e                	je     803310 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803308:	05 00 10 00 00       	add    $0x1000,%eax
  80330d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  803310:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	75 0a                	jne    803323 <sget+0x67>
		return NULL;
  803319:	b8 00 00 00 00       	mov    $0x0,%eax
  80331e:	e9 fa 00 00 00       	jmp    80341d <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  803323:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	74 0f                	je     80333b <sget+0x7f>
  80332c:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  803332:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803337:	39 c2                	cmp    %eax,%edx
  803339:	73 0a                	jae    803345 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  80333b:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803340:	a3 50 e2 81 00       	mov    %eax,0x81e250

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803345:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  80334a:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80334f:	29 c2                	sub    %eax,%edx
  803351:	89 d0                	mov    %edx,%eax
  803353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803356:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  80335c:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  803361:	29 c2                	sub    %eax,%edx
  803363:	89 d0                	mov    %edx,%eax
  803365:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80336e:	77 13                	ja     803383 <sget+0xc7>
  803370:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803373:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803376:	77 0b                	ja     803383 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  803378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337b:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80337e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803381:	73 0a                	jae    80338d <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  803383:	b8 00 00 00 00       	mov    $0x0,%eax
  803388:	e9 90 00 00 00       	jmp    80341d <sget+0x161>

	void *va = NULL;
  80338d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  803394:	a1 44 e2 81 00       	mov    0x81e244,%eax
  803399:	83 f8 05             	cmp    $0x5,%eax
  80339c:	75 11                	jne    8033af <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8033a4:	e8 a3 f5 ff ff       	call   80294c <alloc_pages_custom_fit>
  8033a9:	83 c4 10             	add    $0x10,%esp
  8033ac:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8033af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033b3:	75 27                	jne    8033dc <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8033b5:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8033bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033bf:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8033c2:	89 c2                	mov    %eax,%edx
  8033c4:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8033c9:	39 c2                	cmp    %eax,%edx
  8033cb:	73 07                	jae    8033d4 <sget+0x118>
			return NULL;
  8033cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d2:	eb 49                	jmp    80341d <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8033d4:	a1 50 e2 81 00       	mov    0x81e250,%eax
  8033d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	ff 75 f0             	pushl  -0x10(%ebp)
  8033e2:	ff 75 0c             	pushl  0xc(%ebp)
  8033e5:	ff 75 08             	pushl  0x8(%ebp)
  8033e8:	e8 af 02 00 00       	call   80369c <sys_get_shared_object>
  8033ed:	83 c4 10             	add    $0x10,%esp
  8033f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8033f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8033f7:	79 07                	jns    803400 <sget+0x144>
		return NULL;
  8033f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fe:	eb 1d                	jmp    80341d <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  803400:	a1 50 e2 81 00       	mov    0x81e250,%eax
  803405:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803408:	75 10                	jne    80341a <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  80340a:	8b 15 50 e2 81 00    	mov    0x81e250,%edx
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	01 d0                	add    %edx,%eax
  803415:	a3 50 e2 81 00       	mov    %eax,0x81e250

	return va;
  80341a:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80341d:	c9                   	leave  
  80341e:	c3                   	ret    

0080341f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80341f:	55                   	push   %ebp
  803420:	89 e5                	mov    %esp,%ebp
  803422:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803425:	e8 71 f9 ff ff       	call   802d9b <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80342a:	83 ec 04             	sub    $0x4,%esp
  80342d:	68 94 5b 80 00       	push   $0x805b94
  803432:	68 19 02 00 00       	push   $0x219
  803437:	68 71 57 80 00       	push   $0x805771
  80343c:	e8 42 e1 ff ff       	call   801583 <_panic>

00803441 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803441:	55                   	push   %ebp
  803442:	89 e5                	mov    %esp,%ebp
  803444:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803447:	83 ec 04             	sub    $0x4,%esp
  80344a:	68 bc 5b 80 00       	push   $0x805bbc
  80344f:	68 2b 02 00 00       	push   $0x22b
  803454:	68 71 57 80 00       	push   $0x805771
  803459:	e8 25 e1 ff ff       	call   801583 <_panic>

0080345e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80345e:	55                   	push   %ebp
  80345f:	89 e5                	mov    %esp,%ebp
  803461:	57                   	push   %edi
  803462:	56                   	push   %esi
  803463:	53                   	push   %ebx
  803464:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80346d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803470:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803473:	8b 7d 18             	mov    0x18(%ebp),%edi
  803476:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803479:	cd 30                	int    $0x30
  80347b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80347e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803481:	83 c4 10             	add    $0x10,%esp
  803484:	5b                   	pop    %ebx
  803485:	5e                   	pop    %esi
  803486:	5f                   	pop    %edi
  803487:	5d                   	pop    %ebp
  803488:	c3                   	ret    

00803489 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803489:	55                   	push   %ebp
  80348a:	89 e5                	mov    %esp,%ebp
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	8b 45 10             	mov    0x10(%ebp),%eax
  803492:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803495:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803498:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	6a 00                	push   $0x0
  8034a1:	51                   	push   %ecx
  8034a2:	52                   	push   %edx
  8034a3:	ff 75 0c             	pushl  0xc(%ebp)
  8034a6:	50                   	push   %eax
  8034a7:	6a 00                	push   $0x0
  8034a9:	e8 b0 ff ff ff       	call   80345e <syscall>
  8034ae:	83 c4 18             	add    $0x18,%esp
}
  8034b1:	90                   	nop
  8034b2:	c9                   	leave  
  8034b3:	c3                   	ret    

008034b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8034b4:	55                   	push   %ebp
  8034b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8034b7:	6a 00                	push   $0x0
  8034b9:	6a 00                	push   $0x0
  8034bb:	6a 00                	push   $0x0
  8034bd:	6a 00                	push   $0x0
  8034bf:	6a 00                	push   $0x0
  8034c1:	6a 02                	push   $0x2
  8034c3:	e8 96 ff ff ff       	call   80345e <syscall>
  8034c8:	83 c4 18             	add    $0x18,%esp
}
  8034cb:	c9                   	leave  
  8034cc:	c3                   	ret    

008034cd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8034cd:	55                   	push   %ebp
  8034ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8034d0:	6a 00                	push   $0x0
  8034d2:	6a 00                	push   $0x0
  8034d4:	6a 00                	push   $0x0
  8034d6:	6a 00                	push   $0x0
  8034d8:	6a 00                	push   $0x0
  8034da:	6a 03                	push   $0x3
  8034dc:	e8 7d ff ff ff       	call   80345e <syscall>
  8034e1:	83 c4 18             	add    $0x18,%esp
}
  8034e4:	90                   	nop
  8034e5:	c9                   	leave  
  8034e6:	c3                   	ret    

008034e7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8034e7:	55                   	push   %ebp
  8034e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8034ea:	6a 00                	push   $0x0
  8034ec:	6a 00                	push   $0x0
  8034ee:	6a 00                	push   $0x0
  8034f0:	6a 00                	push   $0x0
  8034f2:	6a 00                	push   $0x0
  8034f4:	6a 04                	push   $0x4
  8034f6:	e8 63 ff ff ff       	call   80345e <syscall>
  8034fb:	83 c4 18             	add    $0x18,%esp
}
  8034fe:	90                   	nop
  8034ff:	c9                   	leave  
  803500:	c3                   	ret    

00803501 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803501:	55                   	push   %ebp
  803502:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803504:	8b 55 0c             	mov    0xc(%ebp),%edx
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	6a 00                	push   $0x0
  80350c:	6a 00                	push   $0x0
  80350e:	6a 00                	push   $0x0
  803510:	52                   	push   %edx
  803511:	50                   	push   %eax
  803512:	6a 08                	push   $0x8
  803514:	e8 45 ff ff ff       	call   80345e <syscall>
  803519:	83 c4 18             	add    $0x18,%esp
}
  80351c:	c9                   	leave  
  80351d:	c3                   	ret    

0080351e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80351e:	55                   	push   %ebp
  80351f:	89 e5                	mov    %esp,%ebp
  803521:	56                   	push   %esi
  803522:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803523:	8b 75 18             	mov    0x18(%ebp),%esi
  803526:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803529:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80352c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	56                   	push   %esi
  803533:	53                   	push   %ebx
  803534:	51                   	push   %ecx
  803535:	52                   	push   %edx
  803536:	50                   	push   %eax
  803537:	6a 09                	push   $0x9
  803539:	e8 20 ff ff ff       	call   80345e <syscall>
  80353e:	83 c4 18             	add    $0x18,%esp
}
  803541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    

00803548 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803548:	55                   	push   %ebp
  803549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80354b:	6a 00                	push   $0x0
  80354d:	6a 00                	push   $0x0
  80354f:	6a 00                	push   $0x0
  803551:	6a 00                	push   $0x0
  803553:	ff 75 08             	pushl  0x8(%ebp)
  803556:	6a 0a                	push   $0xa
  803558:	e8 01 ff ff ff       	call   80345e <syscall>
  80355d:	83 c4 18             	add    $0x18,%esp
}
  803560:	c9                   	leave  
  803561:	c3                   	ret    

00803562 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803562:	55                   	push   %ebp
  803563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803565:	6a 00                	push   $0x0
  803567:	6a 00                	push   $0x0
  803569:	6a 00                	push   $0x0
  80356b:	ff 75 0c             	pushl  0xc(%ebp)
  80356e:	ff 75 08             	pushl  0x8(%ebp)
  803571:	6a 0b                	push   $0xb
  803573:	e8 e6 fe ff ff       	call   80345e <syscall>
  803578:	83 c4 18             	add    $0x18,%esp
}
  80357b:	c9                   	leave  
  80357c:	c3                   	ret    

0080357d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80357d:	55                   	push   %ebp
  80357e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803580:	6a 00                	push   $0x0
  803582:	6a 00                	push   $0x0
  803584:	6a 00                	push   $0x0
  803586:	6a 00                	push   $0x0
  803588:	6a 00                	push   $0x0
  80358a:	6a 0c                	push   $0xc
  80358c:	e8 cd fe ff ff       	call   80345e <syscall>
  803591:	83 c4 18             	add    $0x18,%esp
}
  803594:	c9                   	leave  
  803595:	c3                   	ret    

00803596 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803596:	55                   	push   %ebp
  803597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803599:	6a 00                	push   $0x0
  80359b:	6a 00                	push   $0x0
  80359d:	6a 00                	push   $0x0
  80359f:	6a 00                	push   $0x0
  8035a1:	6a 00                	push   $0x0
  8035a3:	6a 0d                	push   $0xd
  8035a5:	e8 b4 fe ff ff       	call   80345e <syscall>
  8035aa:	83 c4 18             	add    $0x18,%esp
}
  8035ad:	c9                   	leave  
  8035ae:	c3                   	ret    

008035af <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8035af:	55                   	push   %ebp
  8035b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8035b2:	6a 00                	push   $0x0
  8035b4:	6a 00                	push   $0x0
  8035b6:	6a 00                	push   $0x0
  8035b8:	6a 00                	push   $0x0
  8035ba:	6a 00                	push   $0x0
  8035bc:	6a 0e                	push   $0xe
  8035be:	e8 9b fe ff ff       	call   80345e <syscall>
  8035c3:	83 c4 18             	add    $0x18,%esp
}
  8035c6:	c9                   	leave  
  8035c7:	c3                   	ret    

008035c8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8035c8:	55                   	push   %ebp
  8035c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8035cb:	6a 00                	push   $0x0
  8035cd:	6a 00                	push   $0x0
  8035cf:	6a 00                	push   $0x0
  8035d1:	6a 00                	push   $0x0
  8035d3:	6a 00                	push   $0x0
  8035d5:	6a 0f                	push   $0xf
  8035d7:	e8 82 fe ff ff       	call   80345e <syscall>
  8035dc:	83 c4 18             	add    $0x18,%esp
}
  8035df:	c9                   	leave  
  8035e0:	c3                   	ret    

008035e1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8035e1:	55                   	push   %ebp
  8035e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8035e4:	6a 00                	push   $0x0
  8035e6:	6a 00                	push   $0x0
  8035e8:	6a 00                	push   $0x0
  8035ea:	6a 00                	push   $0x0
  8035ec:	ff 75 08             	pushl  0x8(%ebp)
  8035ef:	6a 10                	push   $0x10
  8035f1:	e8 68 fe ff ff       	call   80345e <syscall>
  8035f6:	83 c4 18             	add    $0x18,%esp
}
  8035f9:	c9                   	leave  
  8035fa:	c3                   	ret    

008035fb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8035fb:	55                   	push   %ebp
  8035fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8035fe:	6a 00                	push   $0x0
  803600:	6a 00                	push   $0x0
  803602:	6a 00                	push   $0x0
  803604:	6a 00                	push   $0x0
  803606:	6a 00                	push   $0x0
  803608:	6a 11                	push   $0x11
  80360a:	e8 4f fe ff ff       	call   80345e <syscall>
  80360f:	83 c4 18             	add    $0x18,%esp
}
  803612:	90                   	nop
  803613:	c9                   	leave  
  803614:	c3                   	ret    

00803615 <sys_cputc>:

void
sys_cputc(const char c)
{
  803615:	55                   	push   %ebp
  803616:	89 e5                	mov    %esp,%ebp
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803621:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803625:	6a 00                	push   $0x0
  803627:	6a 00                	push   $0x0
  803629:	6a 00                	push   $0x0
  80362b:	6a 00                	push   $0x0
  80362d:	50                   	push   %eax
  80362e:	6a 01                	push   $0x1
  803630:	e8 29 fe ff ff       	call   80345e <syscall>
  803635:	83 c4 18             	add    $0x18,%esp
}
  803638:	90                   	nop
  803639:	c9                   	leave  
  80363a:	c3                   	ret    

0080363b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80363b:	55                   	push   %ebp
  80363c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80363e:	6a 00                	push   $0x0
  803640:	6a 00                	push   $0x0
  803642:	6a 00                	push   $0x0
  803644:	6a 00                	push   $0x0
  803646:	6a 00                	push   $0x0
  803648:	6a 14                	push   $0x14
  80364a:	e8 0f fe ff ff       	call   80345e <syscall>
  80364f:	83 c4 18             	add    $0x18,%esp
}
  803652:	90                   	nop
  803653:	c9                   	leave  
  803654:	c3                   	ret    

00803655 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803655:	55                   	push   %ebp
  803656:	89 e5                	mov    %esp,%ebp
  803658:	83 ec 04             	sub    $0x4,%esp
  80365b:	8b 45 10             	mov    0x10(%ebp),%eax
  80365e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803661:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803664:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	6a 00                	push   $0x0
  80366d:	51                   	push   %ecx
  80366e:	52                   	push   %edx
  80366f:	ff 75 0c             	pushl  0xc(%ebp)
  803672:	50                   	push   %eax
  803673:	6a 15                	push   $0x15
  803675:	e8 e4 fd ff ff       	call   80345e <syscall>
  80367a:	83 c4 18             	add    $0x18,%esp
}
  80367d:	c9                   	leave  
  80367e:	c3                   	ret    

0080367f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80367f:	55                   	push   %ebp
  803680:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803682:	8b 55 0c             	mov    0xc(%ebp),%edx
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	6a 00                	push   $0x0
  80368a:	6a 00                	push   $0x0
  80368c:	6a 00                	push   $0x0
  80368e:	52                   	push   %edx
  80368f:	50                   	push   %eax
  803690:	6a 16                	push   $0x16
  803692:	e8 c7 fd ff ff       	call   80345e <syscall>
  803697:	83 c4 18             	add    $0x18,%esp
}
  80369a:	c9                   	leave  
  80369b:	c3                   	ret    

0080369c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80369c:	55                   	push   %ebp
  80369d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80369f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	6a 00                	push   $0x0
  8036aa:	6a 00                	push   $0x0
  8036ac:	51                   	push   %ecx
  8036ad:	52                   	push   %edx
  8036ae:	50                   	push   %eax
  8036af:	6a 17                	push   $0x17
  8036b1:	e8 a8 fd ff ff       	call   80345e <syscall>
  8036b6:	83 c4 18             	add    $0x18,%esp
}
  8036b9:	c9                   	leave  
  8036ba:	c3                   	ret    

008036bb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8036bb:	55                   	push   %ebp
  8036bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8036be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c4:	6a 00                	push   $0x0
  8036c6:	6a 00                	push   $0x0
  8036c8:	6a 00                	push   $0x0
  8036ca:	52                   	push   %edx
  8036cb:	50                   	push   %eax
  8036cc:	6a 18                	push   $0x18
  8036ce:	e8 8b fd ff ff       	call   80345e <syscall>
  8036d3:	83 c4 18             	add    $0x18,%esp
}
  8036d6:	c9                   	leave  
  8036d7:	c3                   	ret    

008036d8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8036d8:	55                   	push   %ebp
  8036d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8036db:	8b 45 08             	mov    0x8(%ebp),%eax
  8036de:	6a 00                	push   $0x0
  8036e0:	ff 75 14             	pushl  0x14(%ebp)
  8036e3:	ff 75 10             	pushl  0x10(%ebp)
  8036e6:	ff 75 0c             	pushl  0xc(%ebp)
  8036e9:	50                   	push   %eax
  8036ea:	6a 19                	push   $0x19
  8036ec:	e8 6d fd ff ff       	call   80345e <syscall>
  8036f1:	83 c4 18             	add    $0x18,%esp
}
  8036f4:	c9                   	leave  
  8036f5:	c3                   	ret    

008036f6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8036f6:	55                   	push   %ebp
  8036f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8036f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fc:	6a 00                	push   $0x0
  8036fe:	6a 00                	push   $0x0
  803700:	6a 00                	push   $0x0
  803702:	6a 00                	push   $0x0
  803704:	50                   	push   %eax
  803705:	6a 1a                	push   $0x1a
  803707:	e8 52 fd ff ff       	call   80345e <syscall>
  80370c:	83 c4 18             	add    $0x18,%esp
}
  80370f:	90                   	nop
  803710:	c9                   	leave  
  803711:	c3                   	ret    

00803712 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803712:	55                   	push   %ebp
  803713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	6a 00                	push   $0x0
  80371a:	6a 00                	push   $0x0
  80371c:	6a 00                	push   $0x0
  80371e:	6a 00                	push   $0x0
  803720:	50                   	push   %eax
  803721:	6a 1b                	push   $0x1b
  803723:	e8 36 fd ff ff       	call   80345e <syscall>
  803728:	83 c4 18             	add    $0x18,%esp
}
  80372b:	c9                   	leave  
  80372c:	c3                   	ret    

0080372d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80372d:	55                   	push   %ebp
  80372e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803730:	6a 00                	push   $0x0
  803732:	6a 00                	push   $0x0
  803734:	6a 00                	push   $0x0
  803736:	6a 00                	push   $0x0
  803738:	6a 00                	push   $0x0
  80373a:	6a 05                	push   $0x5
  80373c:	e8 1d fd ff ff       	call   80345e <syscall>
  803741:	83 c4 18             	add    $0x18,%esp
}
  803744:	c9                   	leave  
  803745:	c3                   	ret    

00803746 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803746:	55                   	push   %ebp
  803747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803749:	6a 00                	push   $0x0
  80374b:	6a 00                	push   $0x0
  80374d:	6a 00                	push   $0x0
  80374f:	6a 00                	push   $0x0
  803751:	6a 00                	push   $0x0
  803753:	6a 06                	push   $0x6
  803755:	e8 04 fd ff ff       	call   80345e <syscall>
  80375a:	83 c4 18             	add    $0x18,%esp
}
  80375d:	c9                   	leave  
  80375e:	c3                   	ret    

0080375f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80375f:	55                   	push   %ebp
  803760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803762:	6a 00                	push   $0x0
  803764:	6a 00                	push   $0x0
  803766:	6a 00                	push   $0x0
  803768:	6a 00                	push   $0x0
  80376a:	6a 00                	push   $0x0
  80376c:	6a 07                	push   $0x7
  80376e:	e8 eb fc ff ff       	call   80345e <syscall>
  803773:	83 c4 18             	add    $0x18,%esp
}
  803776:	c9                   	leave  
  803777:	c3                   	ret    

00803778 <sys_exit_env>:


void sys_exit_env(void)
{
  803778:	55                   	push   %ebp
  803779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80377b:	6a 00                	push   $0x0
  80377d:	6a 00                	push   $0x0
  80377f:	6a 00                	push   $0x0
  803781:	6a 00                	push   $0x0
  803783:	6a 00                	push   $0x0
  803785:	6a 1c                	push   $0x1c
  803787:	e8 d2 fc ff ff       	call   80345e <syscall>
  80378c:	83 c4 18             	add    $0x18,%esp
}
  80378f:	90                   	nop
  803790:	c9                   	leave  
  803791:	c3                   	ret    

00803792 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803792:	55                   	push   %ebp
  803793:	89 e5                	mov    %esp,%ebp
  803795:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803798:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80379b:	8d 50 04             	lea    0x4(%eax),%edx
  80379e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8037a1:	6a 00                	push   $0x0
  8037a3:	6a 00                	push   $0x0
  8037a5:	6a 00                	push   $0x0
  8037a7:	52                   	push   %edx
  8037a8:	50                   	push   %eax
  8037a9:	6a 1d                	push   $0x1d
  8037ab:	e8 ae fc ff ff       	call   80345e <syscall>
  8037b0:	83 c4 18             	add    $0x18,%esp
	return result;
  8037b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8037b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8037b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037bc:	89 01                	mov    %eax,(%ecx)
  8037be:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8037c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c4:	c9                   	leave  
  8037c5:	c2 04 00             	ret    $0x4

008037c8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8037c8:	55                   	push   %ebp
  8037c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8037cb:	6a 00                	push   $0x0
  8037cd:	6a 00                	push   $0x0
  8037cf:	ff 75 10             	pushl  0x10(%ebp)
  8037d2:	ff 75 0c             	pushl  0xc(%ebp)
  8037d5:	ff 75 08             	pushl  0x8(%ebp)
  8037d8:	6a 13                	push   $0x13
  8037da:	e8 7f fc ff ff       	call   80345e <syscall>
  8037df:	83 c4 18             	add    $0x18,%esp
	return ;
  8037e2:	90                   	nop
}
  8037e3:	c9                   	leave  
  8037e4:	c3                   	ret    

008037e5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8037e5:	55                   	push   %ebp
  8037e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8037e8:	6a 00                	push   $0x0
  8037ea:	6a 00                	push   $0x0
  8037ec:	6a 00                	push   $0x0
  8037ee:	6a 00                	push   $0x0
  8037f0:	6a 00                	push   $0x0
  8037f2:	6a 1e                	push   $0x1e
  8037f4:	e8 65 fc ff ff       	call   80345e <syscall>
  8037f9:	83 c4 18             	add    $0x18,%esp
}
  8037fc:	c9                   	leave  
  8037fd:	c3                   	ret    

008037fe <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8037fe:	55                   	push   %ebp
  8037ff:	89 e5                	mov    %esp,%ebp
  803801:	83 ec 04             	sub    $0x4,%esp
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80380a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80380e:	6a 00                	push   $0x0
  803810:	6a 00                	push   $0x0
  803812:	6a 00                	push   $0x0
  803814:	6a 00                	push   $0x0
  803816:	50                   	push   %eax
  803817:	6a 1f                	push   $0x1f
  803819:	e8 40 fc ff ff       	call   80345e <syscall>
  80381e:	83 c4 18             	add    $0x18,%esp
	return ;
  803821:	90                   	nop
}
  803822:	c9                   	leave  
  803823:	c3                   	ret    

00803824 <rsttst>:
void rsttst()
{
  803824:	55                   	push   %ebp
  803825:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803827:	6a 00                	push   $0x0
  803829:	6a 00                	push   $0x0
  80382b:	6a 00                	push   $0x0
  80382d:	6a 00                	push   $0x0
  80382f:	6a 00                	push   $0x0
  803831:	6a 21                	push   $0x21
  803833:	e8 26 fc ff ff       	call   80345e <syscall>
  803838:	83 c4 18             	add    $0x18,%esp
	return ;
  80383b:	90                   	nop
}
  80383c:	c9                   	leave  
  80383d:	c3                   	ret    

0080383e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80383e:	55                   	push   %ebp
  80383f:	89 e5                	mov    %esp,%ebp
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	8b 45 14             	mov    0x14(%ebp),%eax
  803847:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80384a:	8b 55 18             	mov    0x18(%ebp),%edx
  80384d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803851:	52                   	push   %edx
  803852:	50                   	push   %eax
  803853:	ff 75 10             	pushl  0x10(%ebp)
  803856:	ff 75 0c             	pushl  0xc(%ebp)
  803859:	ff 75 08             	pushl  0x8(%ebp)
  80385c:	6a 20                	push   $0x20
  80385e:	e8 fb fb ff ff       	call   80345e <syscall>
  803863:	83 c4 18             	add    $0x18,%esp
	return ;
  803866:	90                   	nop
}
  803867:	c9                   	leave  
  803868:	c3                   	ret    

00803869 <chktst>:
void chktst(uint32 n)
{
  803869:	55                   	push   %ebp
  80386a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80386c:	6a 00                	push   $0x0
  80386e:	6a 00                	push   $0x0
  803870:	6a 00                	push   $0x0
  803872:	6a 00                	push   $0x0
  803874:	ff 75 08             	pushl  0x8(%ebp)
  803877:	6a 22                	push   $0x22
  803879:	e8 e0 fb ff ff       	call   80345e <syscall>
  80387e:	83 c4 18             	add    $0x18,%esp
	return ;
  803881:	90                   	nop
}
  803882:	c9                   	leave  
  803883:	c3                   	ret    

00803884 <inctst>:

void inctst()
{
  803884:	55                   	push   %ebp
  803885:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803887:	6a 00                	push   $0x0
  803889:	6a 00                	push   $0x0
  80388b:	6a 00                	push   $0x0
  80388d:	6a 00                	push   $0x0
  80388f:	6a 00                	push   $0x0
  803891:	6a 23                	push   $0x23
  803893:	e8 c6 fb ff ff       	call   80345e <syscall>
  803898:	83 c4 18             	add    $0x18,%esp
	return ;
  80389b:	90                   	nop
}
  80389c:	c9                   	leave  
  80389d:	c3                   	ret    

0080389e <gettst>:
uint32 gettst()
{
  80389e:	55                   	push   %ebp
  80389f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8038a1:	6a 00                	push   $0x0
  8038a3:	6a 00                	push   $0x0
  8038a5:	6a 00                	push   $0x0
  8038a7:	6a 00                	push   $0x0
  8038a9:	6a 00                	push   $0x0
  8038ab:	6a 24                	push   $0x24
  8038ad:	e8 ac fb ff ff       	call   80345e <syscall>
  8038b2:	83 c4 18             	add    $0x18,%esp
}
  8038b5:	c9                   	leave  
  8038b6:	c3                   	ret    

008038b7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8038b7:	55                   	push   %ebp
  8038b8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8038ba:	6a 00                	push   $0x0
  8038bc:	6a 00                	push   $0x0
  8038be:	6a 00                	push   $0x0
  8038c0:	6a 00                	push   $0x0
  8038c2:	6a 00                	push   $0x0
  8038c4:	6a 25                	push   $0x25
  8038c6:	e8 93 fb ff ff       	call   80345e <syscall>
  8038cb:	83 c4 18             	add    $0x18,%esp
  8038ce:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  8038d3:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  8038d8:	c9                   	leave  
  8038d9:	c3                   	ret    

008038da <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8038da:	55                   	push   %ebp
  8038db:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8038dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e0:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8038e5:	6a 00                	push   $0x0
  8038e7:	6a 00                	push   $0x0
  8038e9:	6a 00                	push   $0x0
  8038eb:	6a 00                	push   $0x0
  8038ed:	ff 75 08             	pushl  0x8(%ebp)
  8038f0:	6a 26                	push   $0x26
  8038f2:	e8 67 fb ff ff       	call   80345e <syscall>
  8038f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8038fa:	90                   	nop
}
  8038fb:	c9                   	leave  
  8038fc:	c3                   	ret    

008038fd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8038fd:	55                   	push   %ebp
  8038fe:	89 e5                	mov    %esp,%ebp
  803900:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803901:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803904:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80390a:	8b 45 08             	mov    0x8(%ebp),%eax
  80390d:	6a 00                	push   $0x0
  80390f:	53                   	push   %ebx
  803910:	51                   	push   %ecx
  803911:	52                   	push   %edx
  803912:	50                   	push   %eax
  803913:	6a 27                	push   $0x27
  803915:	e8 44 fb ff ff       	call   80345e <syscall>
  80391a:	83 c4 18             	add    $0x18,%esp
}
  80391d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803920:	c9                   	leave  
  803921:	c3                   	ret    

00803922 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803922:	55                   	push   %ebp
  803923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803925:	8b 55 0c             	mov    0xc(%ebp),%edx
  803928:	8b 45 08             	mov    0x8(%ebp),%eax
  80392b:	6a 00                	push   $0x0
  80392d:	6a 00                	push   $0x0
  80392f:	6a 00                	push   $0x0
  803931:	52                   	push   %edx
  803932:	50                   	push   %eax
  803933:	6a 28                	push   $0x28
  803935:	e8 24 fb ff ff       	call   80345e <syscall>
  80393a:	83 c4 18             	add    $0x18,%esp
}
  80393d:	c9                   	leave  
  80393e:	c3                   	ret    

0080393f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80393f:	55                   	push   %ebp
  803940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803942:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803945:	8b 55 0c             	mov    0xc(%ebp),%edx
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	6a 00                	push   $0x0
  80394d:	51                   	push   %ecx
  80394e:	ff 75 10             	pushl  0x10(%ebp)
  803951:	52                   	push   %edx
  803952:	50                   	push   %eax
  803953:	6a 29                	push   $0x29
  803955:	e8 04 fb ff ff       	call   80345e <syscall>
  80395a:	83 c4 18             	add    $0x18,%esp
}
  80395d:	c9                   	leave  
  80395e:	c3                   	ret    

0080395f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80395f:	55                   	push   %ebp
  803960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803962:	6a 00                	push   $0x0
  803964:	6a 00                	push   $0x0
  803966:	ff 75 10             	pushl  0x10(%ebp)
  803969:	ff 75 0c             	pushl  0xc(%ebp)
  80396c:	ff 75 08             	pushl  0x8(%ebp)
  80396f:	6a 12                	push   $0x12
  803971:	e8 e8 fa ff ff       	call   80345e <syscall>
  803976:	83 c4 18             	add    $0x18,%esp
	return ;
  803979:	90                   	nop
}
  80397a:	c9                   	leave  
  80397b:	c3                   	ret    

0080397c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80397c:	55                   	push   %ebp
  80397d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80397f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803982:	8b 45 08             	mov    0x8(%ebp),%eax
  803985:	6a 00                	push   $0x0
  803987:	6a 00                	push   $0x0
  803989:	6a 00                	push   $0x0
  80398b:	52                   	push   %edx
  80398c:	50                   	push   %eax
  80398d:	6a 2a                	push   $0x2a
  80398f:	e8 ca fa ff ff       	call   80345e <syscall>
  803994:	83 c4 18             	add    $0x18,%esp
	return;
  803997:	90                   	nop
}
  803998:	c9                   	leave  
  803999:	c3                   	ret    

0080399a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80399a:	55                   	push   %ebp
  80399b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80399d:	6a 00                	push   $0x0
  80399f:	6a 00                	push   $0x0
  8039a1:	6a 00                	push   $0x0
  8039a3:	6a 00                	push   $0x0
  8039a5:	6a 00                	push   $0x0
  8039a7:	6a 2b                	push   $0x2b
  8039a9:	e8 b0 fa ff ff       	call   80345e <syscall>
  8039ae:	83 c4 18             	add    $0x18,%esp
}
  8039b1:	c9                   	leave  
  8039b2:	c3                   	ret    

008039b3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8039b3:	55                   	push   %ebp
  8039b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8039b6:	6a 00                	push   $0x0
  8039b8:	6a 00                	push   $0x0
  8039ba:	6a 00                	push   $0x0
  8039bc:	ff 75 0c             	pushl  0xc(%ebp)
  8039bf:	ff 75 08             	pushl  0x8(%ebp)
  8039c2:	6a 2d                	push   $0x2d
  8039c4:	e8 95 fa ff ff       	call   80345e <syscall>
  8039c9:	83 c4 18             	add    $0x18,%esp
	return;
  8039cc:	90                   	nop
}
  8039cd:	c9                   	leave  
  8039ce:	c3                   	ret    

008039cf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8039cf:	55                   	push   %ebp
  8039d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8039d2:	6a 00                	push   $0x0
  8039d4:	6a 00                	push   $0x0
  8039d6:	6a 00                	push   $0x0
  8039d8:	ff 75 0c             	pushl  0xc(%ebp)
  8039db:	ff 75 08             	pushl  0x8(%ebp)
  8039de:	6a 2c                	push   $0x2c
  8039e0:	e8 79 fa ff ff       	call   80345e <syscall>
  8039e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8039e8:	90                   	nop
}
  8039e9:	c9                   	leave  
  8039ea:	c3                   	ret    

008039eb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8039eb:	55                   	push   %ebp
  8039ec:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8039ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f4:	6a 00                	push   $0x0
  8039f6:	6a 00                	push   $0x0
  8039f8:	6a 00                	push   $0x0
  8039fa:	52                   	push   %edx
  8039fb:	50                   	push   %eax
  8039fc:	6a 2e                	push   $0x2e
  8039fe:	e8 5b fa ff ff       	call   80345e <syscall>
  803a03:	83 c4 18             	add    $0x18,%esp
	return ;
  803a06:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803a07:	c9                   	leave  
  803a08:	c3                   	ret    

00803a09 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
  803a0c:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803a0f:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  803a16:	72 09                	jb     803a21 <to_page_va+0x18>
  803a18:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  803a1f:	72 14                	jb     803a35 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803a21:	83 ec 04             	sub    $0x4,%esp
  803a24:	68 e0 5b 80 00       	push   $0x805be0
  803a29:	6a 15                	push   $0x15
  803a2b:	68 0b 5c 80 00       	push   $0x805c0b
  803a30:	e8 4e db ff ff       	call   801583 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803a35:	8b 45 08             	mov    0x8(%ebp),%eax
  803a38:	ba 40 62 80 00       	mov    $0x806240,%edx
  803a3d:	29 d0                	sub    %edx,%eax
  803a3f:	c1 f8 02             	sar    $0x2,%eax
  803a42:	89 c2                	mov    %eax,%edx
  803a44:	89 d0                	mov    %edx,%eax
  803a46:	c1 e0 02             	shl    $0x2,%eax
  803a49:	01 d0                	add    %edx,%eax
  803a4b:	c1 e0 02             	shl    $0x2,%eax
  803a4e:	01 d0                	add    %edx,%eax
  803a50:	c1 e0 02             	shl    $0x2,%eax
  803a53:	01 d0                	add    %edx,%eax
  803a55:	89 c1                	mov    %eax,%ecx
  803a57:	c1 e1 08             	shl    $0x8,%ecx
  803a5a:	01 c8                	add    %ecx,%eax
  803a5c:	89 c1                	mov    %eax,%ecx
  803a5e:	c1 e1 10             	shl    $0x10,%ecx
  803a61:	01 c8                	add    %ecx,%eax
  803a63:	01 c0                	add    %eax,%eax
  803a65:	01 d0                	add    %edx,%eax
  803a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6d:	c1 e0 0c             	shl    $0xc,%eax
  803a70:	89 c2                	mov    %eax,%edx
  803a72:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803a77:	01 d0                	add    %edx,%eax
}
  803a79:	c9                   	leave  
  803a7a:	c3                   	ret    

00803a7b <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803a7b:	55                   	push   %ebp
  803a7c:	89 e5                	mov    %esp,%ebp
  803a7e:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803a81:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803a86:	8b 55 08             	mov    0x8(%ebp),%edx
  803a89:	29 c2                	sub    %eax,%edx
  803a8b:	89 d0                	mov    %edx,%eax
  803a8d:	c1 e8 0c             	shr    $0xc,%eax
  803a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a97:	78 09                	js     803aa2 <to_page_info+0x27>
  803a99:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803aa0:	7e 14                	jle    803ab6 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803aa2:	83 ec 04             	sub    $0x4,%esp
  803aa5:	68 24 5c 80 00       	push   $0x805c24
  803aaa:	6a 22                	push   $0x22
  803aac:	68 0b 5c 80 00       	push   $0x805c0b
  803ab1:	e8 cd da ff ff       	call   801583 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ab9:	89 d0                	mov    %edx,%eax
  803abb:	01 c0                	add    %eax,%eax
  803abd:	01 d0                	add    %edx,%eax
  803abf:	c1 e0 02             	shl    $0x2,%eax
  803ac2:	05 40 62 80 00       	add    $0x806240,%eax
}
  803ac7:	c9                   	leave  
  803ac8:	c3                   	ret    

00803ac9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803ac9:	55                   	push   %ebp
  803aca:	89 e5                	mov    %esp,%ebp
  803acc:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	05 00 00 00 02       	add    $0x2000000,%eax
  803ad7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ada:	73 16                	jae    803af2 <initialize_dynamic_allocator+0x29>
  803adc:	68 48 5c 80 00       	push   $0x805c48
  803ae1:	68 6e 5c 80 00       	push   $0x805c6e
  803ae6:	6a 34                	push   $0x34
  803ae8:	68 0b 5c 80 00       	push   $0x805c0b
  803aed:	e8 91 da ff ff       	call   801583 <_panic>
		is_initialized = 1;
  803af2:	c7 05 14 62 80 00 01 	movl   $0x1,0x806214
  803af9:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  803afc:	8b 45 08             	mov    0x8(%ebp),%eax
  803aff:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  803b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b07:	a3 20 62 80 00       	mov    %eax,0x806220

	LIST_INIT(&freePagesList);
  803b0c:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  803b13:	00 00 00 
  803b16:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  803b1d:	00 00 00 
  803b20:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  803b27:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803b2a:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  803b31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b38:	eb 36                	jmp    803b70 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3d:	c1 e0 04             	shl    $0x4,%eax
  803b40:	05 60 e2 81 00       	add    $0x81e260,%eax
  803b45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4e:	c1 e0 04             	shl    $0x4,%eax
  803b51:	05 64 e2 81 00       	add    $0x81e264,%eax
  803b56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5f:	c1 e0 04             	shl    $0x4,%eax
  803b62:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803b67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803b6d:	ff 45 f4             	incl   -0xc(%ebp)
  803b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b73:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b76:	72 c2                	jb     803b3a <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803b78:	8b 15 20 62 80 00    	mov    0x806220,%edx
  803b7e:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803b83:	29 c2                	sub    %eax,%edx
  803b85:	89 d0                	mov    %edx,%eax
  803b87:	c1 e8 0c             	shr    $0xc,%eax
  803b8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803b8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b94:	e9 c8 00 00 00       	jmp    803c61 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803b99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b9c:	89 d0                	mov    %edx,%eax
  803b9e:	01 c0                	add    %eax,%eax
  803ba0:	01 d0                	add    %edx,%eax
  803ba2:	c1 e0 02             	shl    $0x2,%eax
  803ba5:	05 48 62 80 00       	add    $0x806248,%eax
  803baa:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803baf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bb2:	89 d0                	mov    %edx,%eax
  803bb4:	01 c0                	add    %eax,%eax
  803bb6:	01 d0                	add    %edx,%eax
  803bb8:	c1 e0 02             	shl    $0x2,%eax
  803bbb:	05 4a 62 80 00       	add    $0x80624a,%eax
  803bc0:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803bc5:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803bcb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803bce:	89 c8                	mov    %ecx,%eax
  803bd0:	01 c0                	add    %eax,%eax
  803bd2:	01 c8                	add    %ecx,%eax
  803bd4:	c1 e0 02             	shl    $0x2,%eax
  803bd7:	05 44 62 80 00       	add    $0x806244,%eax
  803bdc:	89 10                	mov    %edx,(%eax)
  803bde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803be1:	89 d0                	mov    %edx,%eax
  803be3:	01 c0                	add    %eax,%eax
  803be5:	01 d0                	add    %edx,%eax
  803be7:	c1 e0 02             	shl    $0x2,%eax
  803bea:	05 44 62 80 00       	add    $0x806244,%eax
  803bef:	8b 00                	mov    (%eax),%eax
  803bf1:	85 c0                	test   %eax,%eax
  803bf3:	74 1b                	je     803c10 <initialize_dynamic_allocator+0x147>
  803bf5:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803bfb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803bfe:	89 c8                	mov    %ecx,%eax
  803c00:	01 c0                	add    %eax,%eax
  803c02:	01 c8                	add    %ecx,%eax
  803c04:	c1 e0 02             	shl    $0x2,%eax
  803c07:	05 40 62 80 00       	add    $0x806240,%eax
  803c0c:	89 02                	mov    %eax,(%edx)
  803c0e:	eb 16                	jmp    803c26 <initialize_dynamic_allocator+0x15d>
  803c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c13:	89 d0                	mov    %edx,%eax
  803c15:	01 c0                	add    %eax,%eax
  803c17:	01 d0                	add    %edx,%eax
  803c19:	c1 e0 02             	shl    $0x2,%eax
  803c1c:	05 40 62 80 00       	add    $0x806240,%eax
  803c21:	a3 28 62 80 00       	mov    %eax,0x806228
  803c26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c29:	89 d0                	mov    %edx,%eax
  803c2b:	01 c0                	add    %eax,%eax
  803c2d:	01 d0                	add    %edx,%eax
  803c2f:	c1 e0 02             	shl    $0x2,%eax
  803c32:	05 40 62 80 00       	add    $0x806240,%eax
  803c37:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803c3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c3f:	89 d0                	mov    %edx,%eax
  803c41:	01 c0                	add    %eax,%eax
  803c43:	01 d0                	add    %edx,%eax
  803c45:	c1 e0 02             	shl    $0x2,%eax
  803c48:	05 40 62 80 00       	add    $0x806240,%eax
  803c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c53:	a1 34 62 80 00       	mov    0x806234,%eax
  803c58:	40                   	inc    %eax
  803c59:	a3 34 62 80 00       	mov    %eax,0x806234
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803c5e:	ff 45 f0             	incl   -0x10(%ebp)
  803c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c64:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c67:	0f 82 2c ff ff ff    	jb     803b99 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c73:	eb 2f                	jmp    803ca4 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803c75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c78:	89 d0                	mov    %edx,%eax
  803c7a:	01 c0                	add    %eax,%eax
  803c7c:	01 d0                	add    %edx,%eax
  803c7e:	c1 e0 02             	shl    $0x2,%eax
  803c81:	05 48 62 80 00       	add    $0x806248,%eax
  803c86:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803c8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c8e:	89 d0                	mov    %edx,%eax
  803c90:	01 c0                	add    %eax,%eax
  803c92:	01 d0                	add    %edx,%eax
  803c94:	c1 e0 02             	shl    $0x2,%eax
  803c97:	05 4a 62 80 00       	add    $0x80624a,%eax
  803c9c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803ca1:	ff 45 ec             	incl   -0x14(%ebp)
  803ca4:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803cab:	76 c8                	jbe    803c75 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803cad:	90                   	nop
  803cae:	c9                   	leave  
  803caf:	c3                   	ret    

00803cb0 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803cb0:	55                   	push   %ebp
  803cb1:	89 e5                	mov    %esp,%ebp
  803cb3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  803cb9:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803cbe:	29 c2                	sub    %eax,%edx
  803cc0:	89 d0                	mov    %edx,%eax
  803cc2:	c1 e8 0c             	shr    $0xc,%eax
  803cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803cc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ccb:	89 d0                	mov    %edx,%eax
  803ccd:	01 c0                	add    %eax,%eax
  803ccf:	01 d0                	add    %edx,%eax
  803cd1:	c1 e0 02             	shl    $0x2,%eax
  803cd4:	05 48 62 80 00       	add    $0x806248,%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803cde:	c9                   	leave  
  803cdf:	c3                   	ret    

00803ce0 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803ce0:	55                   	push   %ebp
  803ce1:	89 e5                	mov    %esp,%ebp
  803ce3:	83 ec 14             	sub    $0x14,%esp
  803ce6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803ce9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803ced:	77 07                	ja     803cf6 <nearest_pow2_ceil.1513+0x16>
  803cef:	b8 01 00 00 00       	mov    $0x1,%eax
  803cf4:	eb 20                	jmp    803d16 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803cf6:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803cfd:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803d00:	eb 08                	jmp    803d0a <nearest_pow2_ceil.1513+0x2a>
  803d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803d05:	01 c0                	add    %eax,%eax
  803d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803d0a:	d1 6d 08             	shrl   0x8(%ebp)
  803d0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d11:	75 ef                	jne    803d02 <nearest_pow2_ceil.1513+0x22>
        return power;
  803d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803d16:	c9                   	leave  
  803d17:	c3                   	ret    

00803d18 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803d18:	55                   	push   %ebp
  803d19:	89 e5                	mov    %esp,%ebp
  803d1b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803d1e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803d25:	76 16                	jbe    803d3d <alloc_block+0x25>
  803d27:	68 84 5c 80 00       	push   $0x805c84
  803d2c:	68 6e 5c 80 00       	push   $0x805c6e
  803d31:	6a 72                	push   $0x72
  803d33:	68 0b 5c 80 00       	push   $0x805c0b
  803d38:	e8 46 d8 ff ff       	call   801583 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803d3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d41:	75 0a                	jne    803d4d <alloc_block+0x35>
  803d43:	b8 00 00 00 00       	mov    $0x0,%eax
  803d48:	e9 bd 04 00 00       	jmp    80420a <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803d4d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803d54:	8b 45 08             	mov    0x8(%ebp),%eax
  803d57:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d5a:	73 06                	jae    803d62 <alloc_block+0x4a>
        size = min_block_size;
  803d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d5f:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803d62:	83 ec 0c             	sub    $0xc,%esp
  803d65:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803d68:	ff 75 08             	pushl  0x8(%ebp)
  803d6b:	89 c1                	mov    %eax,%ecx
  803d6d:	e8 6e ff ff ff       	call   803ce0 <nearest_pow2_ceil.1513>
  803d72:	83 c4 10             	add    $0x10,%esp
  803d75:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803d78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d7b:	83 ec 0c             	sub    $0xc,%esp
  803d7e:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803d81:	52                   	push   %edx
  803d82:	89 c1                	mov    %eax,%ecx
  803d84:	e8 83 04 00 00       	call   80420c <log2_ceil.1520>
  803d89:	83 c4 10             	add    $0x10,%esp
  803d8c:	83 e8 03             	sub    $0x3,%eax
  803d8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d95:	c1 e0 04             	shl    $0x4,%eax
  803d98:	05 60 e2 81 00       	add    $0x81e260,%eax
  803d9d:	8b 00                	mov    (%eax),%eax
  803d9f:	85 c0                	test   %eax,%eax
  803da1:	0f 84 d8 00 00 00    	je     803e7f <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803daa:	c1 e0 04             	shl    $0x4,%eax
  803dad:	05 60 e2 81 00       	add    $0x81e260,%eax
  803db2:	8b 00                	mov    (%eax),%eax
  803db4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803db7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803dbb:	75 17                	jne    803dd4 <alloc_block+0xbc>
  803dbd:	83 ec 04             	sub    $0x4,%esp
  803dc0:	68 a5 5c 80 00       	push   $0x805ca5
  803dc5:	68 98 00 00 00       	push   $0x98
  803dca:	68 0b 5c 80 00       	push   $0x805c0b
  803dcf:	e8 af d7 ff ff       	call   801583 <_panic>
  803dd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dd7:	8b 00                	mov    (%eax),%eax
  803dd9:	85 c0                	test   %eax,%eax
  803ddb:	74 10                	je     803ded <alloc_block+0xd5>
  803ddd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803de0:	8b 00                	mov    (%eax),%eax
  803de2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803de5:	8b 52 04             	mov    0x4(%edx),%edx
  803de8:	89 50 04             	mov    %edx,0x4(%eax)
  803deb:	eb 14                	jmp    803e01 <alloc_block+0xe9>
  803ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803df0:	8b 40 04             	mov    0x4(%eax),%eax
  803df3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803df6:	c1 e2 04             	shl    $0x4,%edx
  803df9:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803dff:	89 02                	mov    %eax,(%edx)
  803e01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e04:	8b 40 04             	mov    0x4(%eax),%eax
  803e07:	85 c0                	test   %eax,%eax
  803e09:	74 0f                	je     803e1a <alloc_block+0x102>
  803e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e0e:	8b 40 04             	mov    0x4(%eax),%eax
  803e11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e14:	8b 12                	mov    (%edx),%edx
  803e16:	89 10                	mov    %edx,(%eax)
  803e18:	eb 13                	jmp    803e2d <alloc_block+0x115>
  803e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e1d:	8b 00                	mov    (%eax),%eax
  803e1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e22:	c1 e2 04             	shl    $0x4,%edx
  803e25:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803e2b:	89 02                	mov    %eax,(%edx)
  803e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e43:	c1 e0 04             	shl    $0x4,%eax
  803e46:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803e4b:	8b 00                	mov    (%eax),%eax
  803e4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e53:	c1 e0 04             	shl    $0x4,%eax
  803e56:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803e5b:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e60:	83 ec 0c             	sub    $0xc,%esp
  803e63:	50                   	push   %eax
  803e64:	e8 12 fc ff ff       	call   803a7b <to_page_info>
  803e69:	83 c4 10             	add    $0x10,%esp
  803e6c:	89 c2                	mov    %eax,%edx
  803e6e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803e72:	48                   	dec    %eax
  803e73:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803e77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e7a:	e9 8b 03 00 00       	jmp    80420a <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803e7f:	a1 28 62 80 00       	mov    0x806228,%eax
  803e84:	85 c0                	test   %eax,%eax
  803e86:	0f 84 64 02 00 00    	je     8040f0 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803e8c:	a1 28 62 80 00       	mov    0x806228,%eax
  803e91:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803e94:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e98:	75 17                	jne    803eb1 <alloc_block+0x199>
  803e9a:	83 ec 04             	sub    $0x4,%esp
  803e9d:	68 a5 5c 80 00       	push   $0x805ca5
  803ea2:	68 a0 00 00 00       	push   $0xa0
  803ea7:	68 0b 5c 80 00       	push   $0x805c0b
  803eac:	e8 d2 d6 ff ff       	call   801583 <_panic>
  803eb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb4:	8b 00                	mov    (%eax),%eax
  803eb6:	85 c0                	test   %eax,%eax
  803eb8:	74 10                	je     803eca <alloc_block+0x1b2>
  803eba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ebd:	8b 00                	mov    (%eax),%eax
  803ebf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ec2:	8b 52 04             	mov    0x4(%edx),%edx
  803ec5:	89 50 04             	mov    %edx,0x4(%eax)
  803ec8:	eb 0b                	jmp    803ed5 <alloc_block+0x1bd>
  803eca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ecd:	8b 40 04             	mov    0x4(%eax),%eax
  803ed0:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803ed5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ed8:	8b 40 04             	mov    0x4(%eax),%eax
  803edb:	85 c0                	test   %eax,%eax
  803edd:	74 0f                	je     803eee <alloc_block+0x1d6>
  803edf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ee2:	8b 40 04             	mov    0x4(%eax),%eax
  803ee5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ee8:	8b 12                	mov    (%edx),%edx
  803eea:	89 10                	mov    %edx,(%eax)
  803eec:	eb 0a                	jmp    803ef8 <alloc_block+0x1e0>
  803eee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ef1:	8b 00                	mov    (%eax),%eax
  803ef3:	a3 28 62 80 00       	mov    %eax,0x806228
  803ef8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803efb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f0b:	a1 34 62 80 00       	mov    0x806234,%eax
  803f10:	48                   	dec    %eax
  803f11:	a3 34 62 80 00       	mov    %eax,0x806234

        page_info_e->block_size = pow;
  803f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f19:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f1c:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803f20:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f25:	99                   	cltd   
  803f26:	f7 7d e8             	idivl  -0x18(%ebp)
  803f29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f2c:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803f30:	83 ec 0c             	sub    $0xc,%esp
  803f33:	ff 75 dc             	pushl  -0x24(%ebp)
  803f36:	e8 ce fa ff ff       	call   803a09 <to_page_va>
  803f3b:	83 c4 10             	add    $0x10,%esp
  803f3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803f41:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f44:	83 ec 0c             	sub    $0xc,%esp
  803f47:	50                   	push   %eax
  803f48:	e8 c0 ee ff ff       	call   802e0d <get_page>
  803f4d:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803f50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803f57:	e9 aa 00 00 00       	jmp    804006 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5f:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803f63:	89 c2                	mov    %eax,%edx
  803f65:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f68:	01 d0                	add    %edx,%eax
  803f6a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803f6d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f71:	75 17                	jne    803f8a <alloc_block+0x272>
  803f73:	83 ec 04             	sub    $0x4,%esp
  803f76:	68 c4 5c 80 00       	push   $0x805cc4
  803f7b:	68 aa 00 00 00       	push   $0xaa
  803f80:	68 0b 5c 80 00       	push   $0x805c0b
  803f85:	e8 f9 d5 ff ff       	call   801583 <_panic>
  803f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8d:	c1 e0 04             	shl    $0x4,%eax
  803f90:	05 64 e2 81 00       	add    $0x81e264,%eax
  803f95:	8b 10                	mov    (%eax),%edx
  803f97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f9a:	89 50 04             	mov    %edx,0x4(%eax)
  803f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa0:	8b 40 04             	mov    0x4(%eax),%eax
  803fa3:	85 c0                	test   %eax,%eax
  803fa5:	74 14                	je     803fbb <alloc_block+0x2a3>
  803fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803faa:	c1 e0 04             	shl    $0x4,%eax
  803fad:	05 64 e2 81 00       	add    $0x81e264,%eax
  803fb2:	8b 00                	mov    (%eax),%eax
  803fb4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fb7:	89 10                	mov    %edx,(%eax)
  803fb9:	eb 11                	jmp    803fcc <alloc_block+0x2b4>
  803fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbe:	c1 e0 04             	shl    $0x4,%eax
  803fc1:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  803fc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fca:	89 02                	mov    %eax,(%edx)
  803fcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcf:	c1 e0 04             	shl    $0x4,%eax
  803fd2:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803fd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fdb:	89 02                	mov    %eax,(%edx)
  803fdd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fe0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe9:	c1 e0 04             	shl    $0x4,%eax
  803fec:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ff1:	8b 00                	mov    (%eax),%eax
  803ff3:	8d 50 01             	lea    0x1(%eax),%edx
  803ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff9:	c1 e0 04             	shl    $0x4,%eax
  803ffc:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804001:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  804003:	ff 45 f4             	incl   -0xc(%ebp)
  804006:	b8 00 10 00 00       	mov    $0x1000,%eax
  80400b:	99                   	cltd   
  80400c:	f7 7d e8             	idivl  -0x18(%ebp)
  80400f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804012:	0f 8f 44 ff ff ff    	jg     803f5c <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  804018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80401b:	c1 e0 04             	shl    $0x4,%eax
  80401e:	05 60 e2 81 00       	add    $0x81e260,%eax
  804023:	8b 00                	mov    (%eax),%eax
  804025:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  804028:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80402c:	75 17                	jne    804045 <alloc_block+0x32d>
  80402e:	83 ec 04             	sub    $0x4,%esp
  804031:	68 a5 5c 80 00       	push   $0x805ca5
  804036:	68 ae 00 00 00       	push   $0xae
  80403b:	68 0b 5c 80 00       	push   $0x805c0b
  804040:	e8 3e d5 ff ff       	call   801583 <_panic>
  804045:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804048:	8b 00                	mov    (%eax),%eax
  80404a:	85 c0                	test   %eax,%eax
  80404c:	74 10                	je     80405e <alloc_block+0x346>
  80404e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804051:	8b 00                	mov    (%eax),%eax
  804053:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804056:	8b 52 04             	mov    0x4(%edx),%edx
  804059:	89 50 04             	mov    %edx,0x4(%eax)
  80405c:	eb 14                	jmp    804072 <alloc_block+0x35a>
  80405e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804061:	8b 40 04             	mov    0x4(%eax),%eax
  804064:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804067:	c1 e2 04             	shl    $0x4,%edx
  80406a:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  804070:	89 02                	mov    %eax,(%edx)
  804072:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804075:	8b 40 04             	mov    0x4(%eax),%eax
  804078:	85 c0                	test   %eax,%eax
  80407a:	74 0f                	je     80408b <alloc_block+0x373>
  80407c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80407f:	8b 40 04             	mov    0x4(%eax),%eax
  804082:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804085:	8b 12                	mov    (%edx),%edx
  804087:	89 10                	mov    %edx,(%eax)
  804089:	eb 13                	jmp    80409e <alloc_block+0x386>
  80408b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80408e:	8b 00                	mov    (%eax),%eax
  804090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804093:	c1 e2 04             	shl    $0x4,%edx
  804096:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  80409c:	89 02                	mov    %eax,(%edx)
  80409e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b4:	c1 e0 04             	shl    $0x4,%eax
  8040b7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8040bc:	8b 00                	mov    (%eax),%eax
  8040be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c4:	c1 e0 04             	shl    $0x4,%eax
  8040c7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8040cc:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8040ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040d1:	83 ec 0c             	sub    $0xc,%esp
  8040d4:	50                   	push   %eax
  8040d5:	e8 a1 f9 ff ff       	call   803a7b <to_page_info>
  8040da:	83 c4 10             	add    $0x10,%esp
  8040dd:	89 c2                	mov    %eax,%edx
  8040df:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8040e3:	48                   	dec    %eax
  8040e4:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8040e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040eb:	e9 1a 01 00 00       	jmp    80420a <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8040f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f3:	40                   	inc    %eax
  8040f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8040f7:	e9 ed 00 00 00       	jmp    8041e9 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8040fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040ff:	c1 e0 04             	shl    $0x4,%eax
  804102:	05 60 e2 81 00       	add    $0x81e260,%eax
  804107:	8b 00                	mov    (%eax),%eax
  804109:	85 c0                	test   %eax,%eax
  80410b:	0f 84 d5 00 00 00    	je     8041e6 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  804111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804114:	c1 e0 04             	shl    $0x4,%eax
  804117:	05 60 e2 81 00       	add    $0x81e260,%eax
  80411c:	8b 00                	mov    (%eax),%eax
  80411e:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  804121:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804125:	75 17                	jne    80413e <alloc_block+0x426>
  804127:	83 ec 04             	sub    $0x4,%esp
  80412a:	68 a5 5c 80 00       	push   $0x805ca5
  80412f:	68 b8 00 00 00       	push   $0xb8
  804134:	68 0b 5c 80 00       	push   $0x805c0b
  804139:	e8 45 d4 ff ff       	call   801583 <_panic>
  80413e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804141:	8b 00                	mov    (%eax),%eax
  804143:	85 c0                	test   %eax,%eax
  804145:	74 10                	je     804157 <alloc_block+0x43f>
  804147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80414a:	8b 00                	mov    (%eax),%eax
  80414c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80414f:	8b 52 04             	mov    0x4(%edx),%edx
  804152:	89 50 04             	mov    %edx,0x4(%eax)
  804155:	eb 14                	jmp    80416b <alloc_block+0x453>
  804157:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80415a:	8b 40 04             	mov    0x4(%eax),%eax
  80415d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804160:	c1 e2 04             	shl    $0x4,%edx
  804163:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  804169:	89 02                	mov    %eax,(%edx)
  80416b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80416e:	8b 40 04             	mov    0x4(%eax),%eax
  804171:	85 c0                	test   %eax,%eax
  804173:	74 0f                	je     804184 <alloc_block+0x46c>
  804175:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804178:	8b 40 04             	mov    0x4(%eax),%eax
  80417b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80417e:	8b 12                	mov    (%edx),%edx
  804180:	89 10                	mov    %edx,(%eax)
  804182:	eb 13                	jmp    804197 <alloc_block+0x47f>
  804184:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804187:	8b 00                	mov    (%eax),%eax
  804189:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80418c:	c1 e2 04             	shl    $0x4,%edx
  80418f:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  804195:	89 02                	mov    %eax,(%edx)
  804197:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80419a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041ad:	c1 e0 04             	shl    $0x4,%eax
  8041b0:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8041b5:	8b 00                	mov    (%eax),%eax
  8041b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8041ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041bd:	c1 e0 04             	shl    $0x4,%eax
  8041c0:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8041c5:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8041c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041ca:	83 ec 0c             	sub    $0xc,%esp
  8041cd:	50                   	push   %eax
  8041ce:	e8 a8 f8 ff ff       	call   803a7b <to_page_info>
  8041d3:	83 c4 10             	add    $0x10,%esp
  8041d6:	89 c2                	mov    %eax,%edx
  8041d8:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8041dc:	48                   	dec    %eax
  8041dd:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8041e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8041e4:	eb 24                	jmp    80420a <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8041e6:	ff 45 f0             	incl   -0x10(%ebp)
  8041e9:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8041ed:	0f 8e 09 ff ff ff    	jle    8040fc <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8041f3:	83 ec 04             	sub    $0x4,%esp
  8041f6:	68 e7 5c 80 00       	push   $0x805ce7
  8041fb:	68 bf 00 00 00       	push   $0xbf
  804200:	68 0b 5c 80 00       	push   $0x805c0b
  804205:	e8 79 d3 ff ff       	call   801583 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  80420a:	c9                   	leave  
  80420b:	c3                   	ret    

0080420c <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80420c:	55                   	push   %ebp
  80420d:	89 e5                	mov    %esp,%ebp
  80420f:	83 ec 14             	sub    $0x14,%esp
  804212:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  804215:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804219:	75 07                	jne    804222 <log2_ceil.1520+0x16>
  80421b:	b8 00 00 00 00       	mov    $0x0,%eax
  804220:	eb 1b                	jmp    80423d <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  804222:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  804229:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  80422c:	eb 06                	jmp    804234 <log2_ceil.1520+0x28>
            x >>= 1;
  80422e:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  804231:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  804234:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804238:	75 f4                	jne    80422e <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  80423a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80423d:	c9                   	leave  
  80423e:	c3                   	ret    

0080423f <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80423f:	55                   	push   %ebp
  804240:	89 e5                	mov    %esp,%ebp
  804242:	83 ec 14             	sub    $0x14,%esp
  804245:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  804248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80424c:	75 07                	jne    804255 <log2_ceil.1547+0x16>
  80424e:	b8 00 00 00 00       	mov    $0x0,%eax
  804253:	eb 1b                	jmp    804270 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  804255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80425c:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80425f:	eb 06                	jmp    804267 <log2_ceil.1547+0x28>
			x >>= 1;
  804261:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  804264:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  804267:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80426b:	75 f4                	jne    804261 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80426d:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  804270:	c9                   	leave  
  804271:	c3                   	ret    

00804272 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804272:	55                   	push   %ebp
  804273:	89 e5                	mov    %esp,%ebp
  804275:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804278:	8b 55 08             	mov    0x8(%ebp),%edx
  80427b:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804280:	39 c2                	cmp    %eax,%edx
  804282:	72 0c                	jb     804290 <free_block+0x1e>
  804284:	8b 55 08             	mov    0x8(%ebp),%edx
  804287:	a1 20 62 80 00       	mov    0x806220,%eax
  80428c:	39 c2                	cmp    %eax,%edx
  80428e:	72 19                	jb     8042a9 <free_block+0x37>
  804290:	68 ec 5c 80 00       	push   $0x805cec
  804295:	68 6e 5c 80 00       	push   $0x805c6e
  80429a:	68 d0 00 00 00       	push   $0xd0
  80429f:	68 0b 5c 80 00       	push   $0x805c0b
  8042a4:	e8 da d2 ff ff       	call   801583 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8042a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042ad:	0f 84 42 03 00 00    	je     8045f5 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8042b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8042b6:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8042bb:	39 c2                	cmp    %eax,%edx
  8042bd:	72 0c                	jb     8042cb <free_block+0x59>
  8042bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8042c2:	a1 20 62 80 00       	mov    0x806220,%eax
  8042c7:	39 c2                	cmp    %eax,%edx
  8042c9:	72 17                	jb     8042e2 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8042cb:	83 ec 04             	sub    $0x4,%esp
  8042ce:	68 24 5d 80 00       	push   $0x805d24
  8042d3:	68 e6 00 00 00       	push   $0xe6
  8042d8:	68 0b 5c 80 00       	push   $0x805c0b
  8042dd:	e8 a1 d2 ff ff       	call   801583 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8042e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8042e5:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8042ea:	29 c2                	sub    %eax,%edx
  8042ec:	89 d0                	mov    %edx,%eax
  8042ee:	83 e0 07             	and    $0x7,%eax
  8042f1:	85 c0                	test   %eax,%eax
  8042f3:	74 17                	je     80430c <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8042f5:	83 ec 04             	sub    $0x4,%esp
  8042f8:	68 58 5d 80 00       	push   $0x805d58
  8042fd:	68 ea 00 00 00       	push   $0xea
  804302:	68 0b 5c 80 00       	push   $0x805c0b
  804307:	e8 77 d2 ff ff       	call   801583 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80430c:	8b 45 08             	mov    0x8(%ebp),%eax
  80430f:	83 ec 0c             	sub    $0xc,%esp
  804312:	50                   	push   %eax
  804313:	e8 63 f7 ff ff       	call   803a7b <to_page_info>
  804318:	83 c4 10             	add    $0x10,%esp
  80431b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80431e:	83 ec 0c             	sub    $0xc,%esp
  804321:	ff 75 08             	pushl  0x8(%ebp)
  804324:	e8 87 f9 ff ff       	call   803cb0 <get_block_size>
  804329:	83 c4 10             	add    $0x10,%esp
  80432c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80432f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804333:	75 17                	jne    80434c <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  804335:	83 ec 04             	sub    $0x4,%esp
  804338:	68 84 5d 80 00       	push   $0x805d84
  80433d:	68 f1 00 00 00       	push   $0xf1
  804342:	68 0b 5c 80 00       	push   $0x805c0b
  804347:	e8 37 d2 ff ff       	call   801583 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80434c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80434f:	83 ec 0c             	sub    $0xc,%esp
  804352:	8d 45 d0             	lea    -0x30(%ebp),%eax
  804355:	52                   	push   %edx
  804356:	89 c1                	mov    %eax,%ecx
  804358:	e8 e2 fe ff ff       	call   80423f <log2_ceil.1547>
  80435d:	83 c4 10             	add    $0x10,%esp
  804360:	83 e8 03             	sub    $0x3,%eax
  804363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  804366:	8b 45 08             	mov    0x8(%ebp),%eax
  804369:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80436c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804370:	75 17                	jne    804389 <free_block+0x117>
  804372:	83 ec 04             	sub    $0x4,%esp
  804375:	68 d0 5d 80 00       	push   $0x805dd0
  80437a:	68 f6 00 00 00       	push   $0xf6
  80437f:	68 0b 5c 80 00       	push   $0x805c0b
  804384:	e8 fa d1 ff ff       	call   801583 <_panic>
  804389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80438c:	c1 e0 04             	shl    $0x4,%eax
  80438f:	05 60 e2 81 00       	add    $0x81e260,%eax
  804394:	8b 10                	mov    (%eax),%edx
  804396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804399:	89 10                	mov    %edx,(%eax)
  80439b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80439e:	8b 00                	mov    (%eax),%eax
  8043a0:	85 c0                	test   %eax,%eax
  8043a2:	74 15                	je     8043b9 <free_block+0x147>
  8043a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043a7:	c1 e0 04             	shl    $0x4,%eax
  8043aa:	05 60 e2 81 00       	add    $0x81e260,%eax
  8043af:	8b 00                	mov    (%eax),%eax
  8043b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043b4:	89 50 04             	mov    %edx,0x4(%eax)
  8043b7:	eb 11                	jmp    8043ca <free_block+0x158>
  8043b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043bc:	c1 e0 04             	shl    $0x4,%eax
  8043bf:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  8043c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043c8:	89 02                	mov    %eax,(%edx)
  8043ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043cd:	c1 e0 04             	shl    $0x4,%eax
  8043d0:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  8043d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043d9:	89 02                	mov    %eax,(%edx)
  8043db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043e8:	c1 e0 04             	shl    $0x4,%eax
  8043eb:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8043f0:	8b 00                	mov    (%eax),%eax
  8043f2:	8d 50 01             	lea    0x1(%eax),%edx
  8043f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043f8:	c1 e0 04             	shl    $0x4,%eax
  8043fb:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804400:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  804402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804405:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804409:	40                   	inc    %eax
  80440a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80440d:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  804411:	8b 55 08             	mov    0x8(%ebp),%edx
  804414:	a1 48 e2 81 00       	mov    0x81e248,%eax
  804419:	29 c2                	sub    %eax,%edx
  80441b:	89 d0                	mov    %edx,%eax
  80441d:	c1 e8 0c             	shr    $0xc,%eax
  804420:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  804423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804426:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80442a:	0f b7 c8             	movzwl %ax,%ecx
  80442d:	b8 00 10 00 00       	mov    $0x1000,%eax
  804432:	99                   	cltd   
  804433:	f7 7d e8             	idivl  -0x18(%ebp)
  804436:	39 c1                	cmp    %eax,%ecx
  804438:	0f 85 b8 01 00 00    	jne    8045f6 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80443e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  804445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804448:	c1 e0 04             	shl    $0x4,%eax
  80444b:	05 60 e2 81 00       	add    $0x81e260,%eax
  804450:	8b 00                	mov    (%eax),%eax
  804452:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804455:	e9 d5 00 00 00       	jmp    80452f <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  80445a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80445d:	8b 00                	mov    (%eax),%eax
  80445f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  804462:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804465:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80446a:	29 c2                	sub    %eax,%edx
  80446c:	89 d0                	mov    %edx,%eax
  80446e:	c1 e8 0c             	shr    $0xc,%eax
  804471:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  804474:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804477:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80447a:	0f 85 a9 00 00 00    	jne    804529 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  804480:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804484:	75 17                	jne    80449d <free_block+0x22b>
  804486:	83 ec 04             	sub    $0x4,%esp
  804489:	68 a5 5c 80 00       	push   $0x805ca5
  80448e:	68 04 01 00 00       	push   $0x104
  804493:	68 0b 5c 80 00       	push   $0x805c0b
  804498:	e8 e6 d0 ff ff       	call   801583 <_panic>
  80449d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044a0:	8b 00                	mov    (%eax),%eax
  8044a2:	85 c0                	test   %eax,%eax
  8044a4:	74 10                	je     8044b6 <free_block+0x244>
  8044a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044a9:	8b 00                	mov    (%eax),%eax
  8044ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044ae:	8b 52 04             	mov    0x4(%edx),%edx
  8044b1:	89 50 04             	mov    %edx,0x4(%eax)
  8044b4:	eb 14                	jmp    8044ca <free_block+0x258>
  8044b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044b9:	8b 40 04             	mov    0x4(%eax),%eax
  8044bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044bf:	c1 e2 04             	shl    $0x4,%edx
  8044c2:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8044c8:	89 02                	mov    %eax,(%edx)
  8044ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044cd:	8b 40 04             	mov    0x4(%eax),%eax
  8044d0:	85 c0                	test   %eax,%eax
  8044d2:	74 0f                	je     8044e3 <free_block+0x271>
  8044d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044d7:	8b 40 04             	mov    0x4(%eax),%eax
  8044da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044dd:	8b 12                	mov    (%edx),%edx
  8044df:	89 10                	mov    %edx,(%eax)
  8044e1:	eb 13                	jmp    8044f6 <free_block+0x284>
  8044e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044e6:	8b 00                	mov    (%eax),%eax
  8044e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8044eb:	c1 e2 04             	shl    $0x4,%edx
  8044ee:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  8044f4:	89 02                	mov    %eax,(%edx)
  8044f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80450c:	c1 e0 04             	shl    $0x4,%eax
  80450f:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804514:	8b 00                	mov    (%eax),%eax
  804516:	8d 50 ff             	lea    -0x1(%eax),%edx
  804519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80451c:	c1 e0 04             	shl    $0x4,%eax
  80451f:	05 6c e2 81 00       	add    $0x81e26c,%eax
  804524:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804526:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804529:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80452c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80452f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804533:	0f 85 21 ff ff ff    	jne    80445a <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  804539:	b8 00 10 00 00       	mov    $0x1000,%eax
  80453e:	99                   	cltd   
  80453f:	f7 7d e8             	idivl  -0x18(%ebp)
  804542:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804545:	74 17                	je     80455e <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  804547:	83 ec 04             	sub    $0x4,%esp
  80454a:	68 f4 5d 80 00       	push   $0x805df4
  80454f:	68 0c 01 00 00       	push   $0x10c
  804554:	68 0b 5c 80 00       	push   $0x805c0b
  804559:	e8 25 d0 ff ff       	call   801583 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80455e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804561:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  804567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80456a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  804570:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804574:	75 17                	jne    80458d <free_block+0x31b>
  804576:	83 ec 04             	sub    $0x4,%esp
  804579:	68 c4 5c 80 00       	push   $0x805cc4
  80457e:	68 11 01 00 00       	push   $0x111
  804583:	68 0b 5c 80 00       	push   $0x805c0b
  804588:	e8 f6 cf ff ff       	call   801583 <_panic>
  80458d:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  804593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804596:	89 50 04             	mov    %edx,0x4(%eax)
  804599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80459c:	8b 40 04             	mov    0x4(%eax),%eax
  80459f:	85 c0                	test   %eax,%eax
  8045a1:	74 0c                	je     8045af <free_block+0x33d>
  8045a3:	a1 2c 62 80 00       	mov    0x80622c,%eax
  8045a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045ab:	89 10                	mov    %edx,(%eax)
  8045ad:	eb 08                	jmp    8045b7 <free_block+0x345>
  8045af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045b2:	a3 28 62 80 00       	mov    %eax,0x806228
  8045b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045ba:	a3 2c 62 80 00       	mov    %eax,0x80622c
  8045bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045c8:	a1 34 62 80 00       	mov    0x806234,%eax
  8045cd:	40                   	inc    %eax
  8045ce:	a3 34 62 80 00       	mov    %eax,0x806234

        uint32 pp = to_page_va(page_info_e);
  8045d3:	83 ec 0c             	sub    $0xc,%esp
  8045d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8045d9:	e8 2b f4 ff ff       	call   803a09 <to_page_va>
  8045de:	83 c4 10             	add    $0x10,%esp
  8045e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8045e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045e7:	83 ec 0c             	sub    $0xc,%esp
  8045ea:	50                   	push   %eax
  8045eb:	e8 69 e8 ff ff       	call   802e59 <return_page>
  8045f0:	83 c4 10             	add    $0x10,%esp
  8045f3:	eb 01                	jmp    8045f6 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8045f5:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8045f6:	c9                   	leave  
  8045f7:	c3                   	ret    

008045f8 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8045f8:	55                   	push   %ebp
  8045f9:	89 e5                	mov    %esp,%ebp
  8045fb:	83 ec 14             	sub    $0x14,%esp
  8045fe:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  804601:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804605:	77 07                	ja     80460e <nearest_pow2_ceil.1572+0x16>
      return 1;
  804607:	b8 01 00 00 00       	mov    $0x1,%eax
  80460c:	eb 20                	jmp    80462e <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80460e:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  804615:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  804618:	eb 08                	jmp    804622 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  80461a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80461d:	01 c0                	add    %eax,%eax
  80461f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  804622:	d1 6d 08             	shrl   0x8(%ebp)
  804625:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804629:	75 ef                	jne    80461a <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  80462b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80462e:	c9                   	leave  
  80462f:	c3                   	ret    

00804630 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  804630:	55                   	push   %ebp
  804631:	89 e5                	mov    %esp,%ebp
  804633:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  804636:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80463a:	75 13                	jne    80464f <realloc_block+0x1f>
    return alloc_block(new_size);
  80463c:	83 ec 0c             	sub    $0xc,%esp
  80463f:	ff 75 0c             	pushl  0xc(%ebp)
  804642:	e8 d1 f6 ff ff       	call   803d18 <alloc_block>
  804647:	83 c4 10             	add    $0x10,%esp
  80464a:	e9 d9 00 00 00       	jmp    804728 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80464f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804653:	75 18                	jne    80466d <realloc_block+0x3d>
    free_block(va);
  804655:	83 ec 0c             	sub    $0xc,%esp
  804658:	ff 75 08             	pushl  0x8(%ebp)
  80465b:	e8 12 fc ff ff       	call   804272 <free_block>
  804660:	83 c4 10             	add    $0x10,%esp
    return NULL;
  804663:	b8 00 00 00 00       	mov    $0x0,%eax
  804668:	e9 bb 00 00 00       	jmp    804728 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80466d:	83 ec 0c             	sub    $0xc,%esp
  804670:	ff 75 08             	pushl  0x8(%ebp)
  804673:	e8 38 f6 ff ff       	call   803cb0 <get_block_size>
  804678:	83 c4 10             	add    $0x10,%esp
  80467b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80467e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804685:	8b 45 0c             	mov    0xc(%ebp),%eax
  804688:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80468b:	73 06                	jae    804693 <realloc_block+0x63>
    new_size = min_block_size;
  80468d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804690:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  804693:	83 ec 0c             	sub    $0xc,%esp
  804696:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804699:	ff 75 0c             	pushl  0xc(%ebp)
  80469c:	89 c1                	mov    %eax,%ecx
  80469e:	e8 55 ff ff ff       	call   8045f8 <nearest_pow2_ceil.1572>
  8046a3:	83 c4 10             	add    $0x10,%esp
  8046a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8046a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8046af:	75 05                	jne    8046b6 <realloc_block+0x86>
    return va;
  8046b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8046b4:	eb 72                	jmp    804728 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8046b6:	83 ec 0c             	sub    $0xc,%esp
  8046b9:	ff 75 0c             	pushl  0xc(%ebp)
  8046bc:	e8 57 f6 ff ff       	call   803d18 <alloc_block>
  8046c1:	83 c4 10             	add    $0x10,%esp
  8046c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8046c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046cb:	75 07                	jne    8046d4 <realloc_block+0xa4>
    return NULL;
  8046cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d2:	eb 54                	jmp    804728 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8046d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8046d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046da:	39 d0                	cmp    %edx,%eax
  8046dc:	76 02                	jbe    8046e0 <realloc_block+0xb0>
  8046de:	89 d0                	mov    %edx,%eax
  8046e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8046e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8046e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8046e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8046ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8046f6:	eb 17                	jmp    80470f <realloc_block+0xdf>
    dst[i] = src[i];
  8046f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8046fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046fe:	01 c2                	add    %eax,%edx
  804700:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  804703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804706:	01 c8                	add    %ecx,%eax
  804708:	8a 00                	mov    (%eax),%al
  80470a:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80470c:	ff 45 f4             	incl   -0xc(%ebp)
  80470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804712:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804715:	72 e1                	jb     8046f8 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  804717:	83 ec 0c             	sub    $0xc,%esp
  80471a:	ff 75 08             	pushl  0x8(%ebp)
  80471d:	e8 50 fb ff ff       	call   804272 <free_block>
  804722:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  804728:	c9                   	leave  
  804729:	c3                   	ret    
  80472a:	66 90                	xchg   %ax,%ax

0080472c <__udivdi3>:
  80472c:	55                   	push   %ebp
  80472d:	57                   	push   %edi
  80472e:	56                   	push   %esi
  80472f:	53                   	push   %ebx
  804730:	83 ec 1c             	sub    $0x1c,%esp
  804733:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804737:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80473b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80473f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804743:	89 ca                	mov    %ecx,%edx
  804745:	89 f8                	mov    %edi,%eax
  804747:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80474b:	85 f6                	test   %esi,%esi
  80474d:	75 2d                	jne    80477c <__udivdi3+0x50>
  80474f:	39 cf                	cmp    %ecx,%edi
  804751:	77 65                	ja     8047b8 <__udivdi3+0x8c>
  804753:	89 fd                	mov    %edi,%ebp
  804755:	85 ff                	test   %edi,%edi
  804757:	75 0b                	jne    804764 <__udivdi3+0x38>
  804759:	b8 01 00 00 00       	mov    $0x1,%eax
  80475e:	31 d2                	xor    %edx,%edx
  804760:	f7 f7                	div    %edi
  804762:	89 c5                	mov    %eax,%ebp
  804764:	31 d2                	xor    %edx,%edx
  804766:	89 c8                	mov    %ecx,%eax
  804768:	f7 f5                	div    %ebp
  80476a:	89 c1                	mov    %eax,%ecx
  80476c:	89 d8                	mov    %ebx,%eax
  80476e:	f7 f5                	div    %ebp
  804770:	89 cf                	mov    %ecx,%edi
  804772:	89 fa                	mov    %edi,%edx
  804774:	83 c4 1c             	add    $0x1c,%esp
  804777:	5b                   	pop    %ebx
  804778:	5e                   	pop    %esi
  804779:	5f                   	pop    %edi
  80477a:	5d                   	pop    %ebp
  80477b:	c3                   	ret    
  80477c:	39 ce                	cmp    %ecx,%esi
  80477e:	77 28                	ja     8047a8 <__udivdi3+0x7c>
  804780:	0f bd fe             	bsr    %esi,%edi
  804783:	83 f7 1f             	xor    $0x1f,%edi
  804786:	75 40                	jne    8047c8 <__udivdi3+0x9c>
  804788:	39 ce                	cmp    %ecx,%esi
  80478a:	72 0a                	jb     804796 <__udivdi3+0x6a>
  80478c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804790:	0f 87 9e 00 00 00    	ja     804834 <__udivdi3+0x108>
  804796:	b8 01 00 00 00       	mov    $0x1,%eax
  80479b:	89 fa                	mov    %edi,%edx
  80479d:	83 c4 1c             	add    $0x1c,%esp
  8047a0:	5b                   	pop    %ebx
  8047a1:	5e                   	pop    %esi
  8047a2:	5f                   	pop    %edi
  8047a3:	5d                   	pop    %ebp
  8047a4:	c3                   	ret    
  8047a5:	8d 76 00             	lea    0x0(%esi),%esi
  8047a8:	31 ff                	xor    %edi,%edi
  8047aa:	31 c0                	xor    %eax,%eax
  8047ac:	89 fa                	mov    %edi,%edx
  8047ae:	83 c4 1c             	add    $0x1c,%esp
  8047b1:	5b                   	pop    %ebx
  8047b2:	5e                   	pop    %esi
  8047b3:	5f                   	pop    %edi
  8047b4:	5d                   	pop    %ebp
  8047b5:	c3                   	ret    
  8047b6:	66 90                	xchg   %ax,%ax
  8047b8:	89 d8                	mov    %ebx,%eax
  8047ba:	f7 f7                	div    %edi
  8047bc:	31 ff                	xor    %edi,%edi
  8047be:	89 fa                	mov    %edi,%edx
  8047c0:	83 c4 1c             	add    $0x1c,%esp
  8047c3:	5b                   	pop    %ebx
  8047c4:	5e                   	pop    %esi
  8047c5:	5f                   	pop    %edi
  8047c6:	5d                   	pop    %ebp
  8047c7:	c3                   	ret    
  8047c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8047cd:	89 eb                	mov    %ebp,%ebx
  8047cf:	29 fb                	sub    %edi,%ebx
  8047d1:	89 f9                	mov    %edi,%ecx
  8047d3:	d3 e6                	shl    %cl,%esi
  8047d5:	89 c5                	mov    %eax,%ebp
  8047d7:	88 d9                	mov    %bl,%cl
  8047d9:	d3 ed                	shr    %cl,%ebp
  8047db:	89 e9                	mov    %ebp,%ecx
  8047dd:	09 f1                	or     %esi,%ecx
  8047df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047e3:	89 f9                	mov    %edi,%ecx
  8047e5:	d3 e0                	shl    %cl,%eax
  8047e7:	89 c5                	mov    %eax,%ebp
  8047e9:	89 d6                	mov    %edx,%esi
  8047eb:	88 d9                	mov    %bl,%cl
  8047ed:	d3 ee                	shr    %cl,%esi
  8047ef:	89 f9                	mov    %edi,%ecx
  8047f1:	d3 e2                	shl    %cl,%edx
  8047f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047f7:	88 d9                	mov    %bl,%cl
  8047f9:	d3 e8                	shr    %cl,%eax
  8047fb:	09 c2                	or     %eax,%edx
  8047fd:	89 d0                	mov    %edx,%eax
  8047ff:	89 f2                	mov    %esi,%edx
  804801:	f7 74 24 0c          	divl   0xc(%esp)
  804805:	89 d6                	mov    %edx,%esi
  804807:	89 c3                	mov    %eax,%ebx
  804809:	f7 e5                	mul    %ebp
  80480b:	39 d6                	cmp    %edx,%esi
  80480d:	72 19                	jb     804828 <__udivdi3+0xfc>
  80480f:	74 0b                	je     80481c <__udivdi3+0xf0>
  804811:	89 d8                	mov    %ebx,%eax
  804813:	31 ff                	xor    %edi,%edi
  804815:	e9 58 ff ff ff       	jmp    804772 <__udivdi3+0x46>
  80481a:	66 90                	xchg   %ax,%ax
  80481c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804820:	89 f9                	mov    %edi,%ecx
  804822:	d3 e2                	shl    %cl,%edx
  804824:	39 c2                	cmp    %eax,%edx
  804826:	73 e9                	jae    804811 <__udivdi3+0xe5>
  804828:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80482b:	31 ff                	xor    %edi,%edi
  80482d:	e9 40 ff ff ff       	jmp    804772 <__udivdi3+0x46>
  804832:	66 90                	xchg   %ax,%ax
  804834:	31 c0                	xor    %eax,%eax
  804836:	e9 37 ff ff ff       	jmp    804772 <__udivdi3+0x46>
  80483b:	90                   	nop

0080483c <__umoddi3>:
  80483c:	55                   	push   %ebp
  80483d:	57                   	push   %edi
  80483e:	56                   	push   %esi
  80483f:	53                   	push   %ebx
  804840:	83 ec 1c             	sub    $0x1c,%esp
  804843:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804847:	8b 74 24 34          	mov    0x34(%esp),%esi
  80484b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80484f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804853:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804857:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80485b:	89 f3                	mov    %esi,%ebx
  80485d:	89 fa                	mov    %edi,%edx
  80485f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804863:	89 34 24             	mov    %esi,(%esp)
  804866:	85 c0                	test   %eax,%eax
  804868:	75 1a                	jne    804884 <__umoddi3+0x48>
  80486a:	39 f7                	cmp    %esi,%edi
  80486c:	0f 86 a2 00 00 00    	jbe    804914 <__umoddi3+0xd8>
  804872:	89 c8                	mov    %ecx,%eax
  804874:	89 f2                	mov    %esi,%edx
  804876:	f7 f7                	div    %edi
  804878:	89 d0                	mov    %edx,%eax
  80487a:	31 d2                	xor    %edx,%edx
  80487c:	83 c4 1c             	add    $0x1c,%esp
  80487f:	5b                   	pop    %ebx
  804880:	5e                   	pop    %esi
  804881:	5f                   	pop    %edi
  804882:	5d                   	pop    %ebp
  804883:	c3                   	ret    
  804884:	39 f0                	cmp    %esi,%eax
  804886:	0f 87 ac 00 00 00    	ja     804938 <__umoddi3+0xfc>
  80488c:	0f bd e8             	bsr    %eax,%ebp
  80488f:	83 f5 1f             	xor    $0x1f,%ebp
  804892:	0f 84 ac 00 00 00    	je     804944 <__umoddi3+0x108>
  804898:	bf 20 00 00 00       	mov    $0x20,%edi
  80489d:	29 ef                	sub    %ebp,%edi
  80489f:	89 fe                	mov    %edi,%esi
  8048a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8048a5:	89 e9                	mov    %ebp,%ecx
  8048a7:	d3 e0                	shl    %cl,%eax
  8048a9:	89 d7                	mov    %edx,%edi
  8048ab:	89 f1                	mov    %esi,%ecx
  8048ad:	d3 ef                	shr    %cl,%edi
  8048af:	09 c7                	or     %eax,%edi
  8048b1:	89 e9                	mov    %ebp,%ecx
  8048b3:	d3 e2                	shl    %cl,%edx
  8048b5:	89 14 24             	mov    %edx,(%esp)
  8048b8:	89 d8                	mov    %ebx,%eax
  8048ba:	d3 e0                	shl    %cl,%eax
  8048bc:	89 c2                	mov    %eax,%edx
  8048be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048c2:	d3 e0                	shl    %cl,%eax
  8048c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048cc:	89 f1                	mov    %esi,%ecx
  8048ce:	d3 e8                	shr    %cl,%eax
  8048d0:	09 d0                	or     %edx,%eax
  8048d2:	d3 eb                	shr    %cl,%ebx
  8048d4:	89 da                	mov    %ebx,%edx
  8048d6:	f7 f7                	div    %edi
  8048d8:	89 d3                	mov    %edx,%ebx
  8048da:	f7 24 24             	mull   (%esp)
  8048dd:	89 c6                	mov    %eax,%esi
  8048df:	89 d1                	mov    %edx,%ecx
  8048e1:	39 d3                	cmp    %edx,%ebx
  8048e3:	0f 82 87 00 00 00    	jb     804970 <__umoddi3+0x134>
  8048e9:	0f 84 91 00 00 00    	je     804980 <__umoddi3+0x144>
  8048ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8048f3:	29 f2                	sub    %esi,%edx
  8048f5:	19 cb                	sbb    %ecx,%ebx
  8048f7:	89 d8                	mov    %ebx,%eax
  8048f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8048fd:	d3 e0                	shl    %cl,%eax
  8048ff:	89 e9                	mov    %ebp,%ecx
  804901:	d3 ea                	shr    %cl,%edx
  804903:	09 d0                	or     %edx,%eax
  804905:	89 e9                	mov    %ebp,%ecx
  804907:	d3 eb                	shr    %cl,%ebx
  804909:	89 da                	mov    %ebx,%edx
  80490b:	83 c4 1c             	add    $0x1c,%esp
  80490e:	5b                   	pop    %ebx
  80490f:	5e                   	pop    %esi
  804910:	5f                   	pop    %edi
  804911:	5d                   	pop    %ebp
  804912:	c3                   	ret    
  804913:	90                   	nop
  804914:	89 fd                	mov    %edi,%ebp
  804916:	85 ff                	test   %edi,%edi
  804918:	75 0b                	jne    804925 <__umoddi3+0xe9>
  80491a:	b8 01 00 00 00       	mov    $0x1,%eax
  80491f:	31 d2                	xor    %edx,%edx
  804921:	f7 f7                	div    %edi
  804923:	89 c5                	mov    %eax,%ebp
  804925:	89 f0                	mov    %esi,%eax
  804927:	31 d2                	xor    %edx,%edx
  804929:	f7 f5                	div    %ebp
  80492b:	89 c8                	mov    %ecx,%eax
  80492d:	f7 f5                	div    %ebp
  80492f:	89 d0                	mov    %edx,%eax
  804931:	e9 44 ff ff ff       	jmp    80487a <__umoddi3+0x3e>
  804936:	66 90                	xchg   %ax,%ax
  804938:	89 c8                	mov    %ecx,%eax
  80493a:	89 f2                	mov    %esi,%edx
  80493c:	83 c4 1c             	add    $0x1c,%esp
  80493f:	5b                   	pop    %ebx
  804940:	5e                   	pop    %esi
  804941:	5f                   	pop    %edi
  804942:	5d                   	pop    %ebp
  804943:	c3                   	ret    
  804944:	3b 04 24             	cmp    (%esp),%eax
  804947:	72 06                	jb     80494f <__umoddi3+0x113>
  804949:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80494d:	77 0f                	ja     80495e <__umoddi3+0x122>
  80494f:	89 f2                	mov    %esi,%edx
  804951:	29 f9                	sub    %edi,%ecx
  804953:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804957:	89 14 24             	mov    %edx,(%esp)
  80495a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80495e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804962:	8b 14 24             	mov    (%esp),%edx
  804965:	83 c4 1c             	add    $0x1c,%esp
  804968:	5b                   	pop    %ebx
  804969:	5e                   	pop    %esi
  80496a:	5f                   	pop    %edi
  80496b:	5d                   	pop    %ebp
  80496c:	c3                   	ret    
  80496d:	8d 76 00             	lea    0x0(%esi),%esi
  804970:	2b 04 24             	sub    (%esp),%eax
  804973:	19 fa                	sbb    %edi,%edx
  804975:	89 d1                	mov    %edx,%ecx
  804977:	89 c6                	mov    %eax,%esi
  804979:	e9 71 ff ff ff       	jmp    8048ef <__umoddi3+0xb3>
  80497e:	66 90                	xchg   %ax,%ax
  804980:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804984:	72 ea                	jb     804970 <__umoddi3+0x134>
  804986:	89 d9                	mov    %ebx,%ecx
  804988:	e9 62 ff ff ff       	jmp    8048ef <__umoddi3+0xb3>
