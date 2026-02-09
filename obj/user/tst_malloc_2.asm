
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 aa 05 00 00       	call   8005e0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_dynalloc_datastruct>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_dynalloc_datastruct(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_dynalloc_datastruct+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 a0 3b 80 00       	push   $0x803ba0
  80005a:	e8 1f 0a 00 00       	call   800a7e <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_dynalloc_datastruct+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_dynalloc_datastruct+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 d0 3b 80 00       	push   $0x803bd0
  8000aa:	e8 cf 09 00 00       	call   800a7e <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	81 ec a4 00 00 00    	sub    $0xa4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000ca:	a1 40 50 80 00       	mov    0x805040,%eax
  8000cf:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  8000d5:	a1 40 50 80 00       	mov    0x805040,%eax
  8000da:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e0:	39 c2                	cmp    %eax,%edx
  8000e2:	72 14                	jb     8000f8 <_main+0x38>
			panic("Please increase the WS size");
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	68 09 3c 80 00       	push   $0x803c09
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 25 3c 80 00       	push   $0x803c25
  8000f3:	e8 98 06 00 00       	call   800790 <_panic>
#endif

	/*=================================================*/


	int eval = 0;
  8000f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800106:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  80010d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800114:	e8 bc 26 00 00       	call   8027d5 <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 69 26 00 00       	call   80278a <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 3c 3c 80 00       	push   $0x803c3c
  80012c:	e8 4d 09 00 00       	call   800a7e <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800134:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
  80013b:	c7 45 e0 04 00 00 80 	movl   $0x80000004,-0x20(%ebp)
		curTotalSize = sizeof(int);
  800142:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  800149:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800150:	e9 b6 01 00 00       	jmp    80030b <_main+0x24b>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  800155:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80015c:	e9 9a 01 00 00       	jmp    8002fb <_main+0x23b>
			{
				actualSize = allocSizes[i] - sizeOfMetaData;
  800161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800164:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80016b:	83 e8 08             	sub    $0x8,%eax
  80016e:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 bc             	pushl  -0x44(%ebp)
  800177:	e8 2d 1f 00 00       	call   8020a9 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 c2                	mov    %eax,%edx
  800181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800184:	89 14 85 80 50 80 00 	mov    %edx,0x805080(,%eax,4)
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	8b 04 85 80 50 80 00 	mov    0x805080(,%eax,4),%eax
  800195:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800198:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019b:	d1 e8                	shr    %eax
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a2:	01 c2                	add    %eax,%edx
  8001a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a7:	89 14 85 80 7c 80 00 	mov    %edx,0x807c80(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001b1:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	01 c2                	add    %eax,%edx
  8001b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bc:	89 14 85 80 66 80 00 	mov    %edx,0x806680(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c6:	83 c0 04             	add    $0x4,%eax
  8001c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				expectedSize = allocSizes[i];
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				curTotalSize += allocSizes[i] ;
  8001d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001dc:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001e3:	01 45 e4             	add    %eax,-0x1c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001e6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	48                   	dec    %eax
  8001f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800201:	f7 75 b0             	divl   -0x50(%ebp)
  800204:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800207:	29 d0                	sub    %edx,%eax
  800209:	89 45 a8             	mov    %eax,-0x58(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80020c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80020f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800212:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData  + sizeof(int) /*END block*/))
  800215:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  800219:	7e 60                	jle    80027b <_main+0x1bb>
  80021b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80021e:	83 f8 13             	cmp    $0x13,%eax
  800221:	77 58                	ja     80027b <_main+0x1bb>
				{
					cprintf("%~\n FRAGMENTATION @allocSize#%d: curVA = %x diff = %d\n", i, curVA, diff);
  800223:	ff 75 a4             	pushl  -0x5c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	68 98 3c 80 00       	push   $0x803c98
  800231:	e8 48 08 00 00       	call   800a7e <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800239:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  800240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800243:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	48                   	dec    %eax
  800249:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80024c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024f:	ba 00 00 00 00       	mov    $0x0,%edx
  800254:	f7 75 a0             	divl   -0x60(%ebp)
  800257:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80025a:	29 d0                	sub    %edx,%eax
  80025c:	83 e8 04             	sub    $0x4,%eax
  80025f:	89 45 e0             	mov    %eax,-0x20(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  800262:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800265:	83 e8 04             	sub    $0x4,%eax
  800268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  80026b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80026e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	83 e8 04             	sub    $0x4,%eax
  800276:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800279:	eb 0d                	jmp    800288 <_main+0x1c8>
				}
				else
				{
					curVA += allocSizes[i] ;
  80027b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80027e:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  800285:	01 45 e0             	add    %eax,-0x20(%ebp)
				}
				//============================================================
				if (is_correct)
  800288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80028c:	74 37                	je     8002c5 <_main+0x205>
				{
					if (check_dynalloc_datastruct(va, expectedVA, expectedSize, 1) == 0)
  80028e:	6a 01                	push   $0x1
  800290:	ff 75 e8             	pushl  -0x18(%ebp)
  800293:	ff 75 b4             	pushl  -0x4c(%ebp)
  800296:	ff 75 b8             	pushl  -0x48(%ebp)
  800299:	e8 9a fd ff ff       	call   800038 <check_dynalloc_datastruct>
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	75 20                	jne    8002c5 <_main+0x205>
					{
						if (is_correct)
  8002a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002a9:	74 1a                	je     8002c5 <_main+0x205>
						{
							is_correct = 0;
  8002ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
							cprintf("alloc_block_xx #1.%d: WRONG ALLOC\n", idx);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8002b8:	68 d0 3c 80 00       	push   $0x803cd0
  8002bd:	e8 bc 07 00 00       	call   800a7e <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
						}
					}
				}
				*(startVAs[idx]) = idx ;
  8002c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c8:	8b 14 85 80 50 80 00 	mov    0x805080(,%eax,4),%edx
  8002cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d2:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8002d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d8:	8b 14 85 80 7c 80 00 	mov    0x807c80(,%eax,4),%edx
  8002df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e2:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8002e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e8:	8b 14 85 80 66 80 00 	mov    0x806680(,%eax,4),%edx
  8002ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f2:	66 89 02             	mov    %ax,(%edx)
				idx++;
  8002f5:	ff 45 ec             	incl   -0x14(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8002f8:	ff 45 d8             	incl   -0x28(%ebp)
  8002fb:	81 7d d8 c7 00 00 00 	cmpl   $0xc7,-0x28(%ebp)
  800302:	0f 8e 59 fe ff ff    	jle    800161 <_main+0xa1>
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
  800308:	ff 45 dc             	incl   -0x24(%ebp)
  80030b:	83 7d dc 06          	cmpl   $0x6,-0x24(%ebp)
  80030f:	0f 8e 40 fe ff ff    	jle    800155 <_main+0x95>
				idx++;
			}
			//if (is_correct == 0)
			//break;
		}
		if (is_correct)
  800315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800319:	74 04                	je     80031f <_main+0x25f>
		{
			eval += 30;
  80031b:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	68 f4 3c 80 00       	push   $0x803cf4
  800327:	e8 52 07 00 00       	call   800a7e <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80032f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		for (int i = 0; i < idx; ++i)
  800336:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80033d:	eb 5b                	jmp    80039a <_main+0x2da>
		{
			if (*(startVAs[i]) != i || *(midVAs[i]) != i ||	*(endVAs[i]) != i)
  80033f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800342:	8b 04 85 80 50 80 00 	mov    0x805080(,%eax,4),%eax
  800349:	66 8b 00             	mov    (%eax),%ax
  80034c:	98                   	cwtl   
  80034d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800350:	75 26                	jne    800378 <_main+0x2b8>
  800352:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800355:	8b 04 85 80 7c 80 00 	mov    0x807c80(,%eax,4),%eax
  80035c:	66 8b 00             	mov    (%eax),%ax
  80035f:	98                   	cwtl   
  800360:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800363:	75 13                	jne    800378 <_main+0x2b8>
  800365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800368:	8b 04 85 80 66 80 00 	mov    0x806680(,%eax,4),%eax
  80036f:	66 8b 00             	mov    (%eax),%ax
  800372:	98                   	cwtl   
  800373:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800376:	74 1f                	je     800397 <_main+0x2d7>
			{
				is_correct = 0;
  800378:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 d4             	pushl  -0x2c(%ebp)
  800385:	ff 75 d4             	pushl  -0x2c(%ebp)
  800388:	68 30 3d 80 00       	push   $0x803d30
  80038d:	e8 ec 06 00 00       	call   800a7e <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
				break;
  800395:	eb 0b                	jmp    8003a2 <_main+0x2e2>
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
	{
		is_correct = 1;

		for (int i = 0; i < idx; ++i)
  800397:	ff 45 d4             	incl   -0x2c(%ebp)
  80039a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8003a0:	7c 9d                	jl     80033f <_main+0x27f>
				is_correct = 0;
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
				break;
			}
		}
		if (is_correct)
  8003a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003a6:	74 04                	je     8003ac <_main+0x2ec>
		{
			eval += 30;
  8003a8:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	/*Check page file*/
	cprintf("%~\n3: Check page file size (nothing should be allocated) [10%]\n") ;
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	68 80 3d 80 00       	push   $0x803d80
  8003b4:	e8 c5 06 00 00       	call   800a7e <cprintf>
  8003b9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003c3:	e8 0d 24 00 00       	call   8027d5 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003cb:	74 17                	je     8003e4 <_main+0x324>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	68 c0 3d 80 00       	push   $0x803dc0
  8003d5:	e8 a4 06 00 00       	call   800a7e <cprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8003dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8003e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003e8:	74 04                	je     8003ee <_main+0x32e>
		{
			eval += 10;
  8003ea:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  8003ee:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
//	for (int i = 0; i < numOfAllocs; ++i)
//	{
//		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
//	}
//	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
	expectedAllocatedSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8003f5:	c7 45 94 00 10 00 00 	movl   $0x1000,-0x6c(%ebp)
  8003fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	48                   	dec    %eax
  800405:	89 45 90             	mov    %eax,-0x70(%ebp)
  800408:	8b 45 90             	mov    -0x70(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	f7 75 94             	divl   -0x6c(%ebp)
  800413:	8b 45 90             	mov    -0x70(%ebp),%eax
  800416:	29 d0                	sub    %edx,%eax
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	c1 e8 0c             	shr    $0xc,%eax
  800421:	89 45 8c             	mov    %eax,-0x74(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  800424:	c7 45 88 00 00 40 00 	movl   $0x400000,-0x78(%ebp)
  80042b:	8b 55 98             	mov    -0x68(%ebp),%edx
  80042e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800431:	01 d0                	add    %edx,%eax
  800433:	48                   	dec    %eax
  800434:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800437:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
  80043f:	f7 75 88             	divl   -0x78(%ebp)
  800442:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800445:	29 d0                	sub    %edx,%eax
  800447:	c1 e8 16             	shr    $0x16,%eax
  80044a:	89 45 80             	mov    %eax,-0x80(%ebp)
	uint32 expectedAllocNumOfPagesForWS = ROUNDUP(expectedAllocNumOfPages * (sizeof(struct WorkingSetElement) + sizeOfMetaData), PAGE_SIZE) / PAGE_SIZE; 				/*# pages*/
  80044d:	c7 85 7c ff ff ff 00 	movl   $0x1000,-0x84(%ebp)
  800454:	10 00 00 
  800457:	8b 55 8c             	mov    -0x74(%ebp),%edx
  80045a:	89 d0                	mov    %edx,%eax
  80045c:	c1 e0 03             	shl    $0x3,%eax
  80045f:	01 d0                	add    %edx,%eax
  800461:	c1 e0 02             	shl    $0x2,%eax
  800464:	89 c2                	mov    %eax,%edx
  800466:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	48                   	dec    %eax
  80046f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800475:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80047b:	ba 00 00 00 00       	mov    $0x0,%edx
  800480:	f7 b5 7c ff ff ff    	divl   -0x84(%ebp)
  800486:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80048c:	29 d0                	sub    %edx,%eax
  80048e:	c1 e8 0c             	shr    $0xc,%eax
  800491:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	/*Check memory allocation*/
	cprintf("%~\n4: Check total allocation in RAM (for pages, tables & WS) [10%]\n") ;
  800497:	83 ec 0c             	sub    $0xc,%esp
  80049a:	68 fc 3d 80 00       	push   $0x803dfc
  80049f:	e8 da 05 00 00       	call   800a7e <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8004a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32 expected = expectedAllocNumOfPages + expectedAllocNumOfTables  + expectedAllocNumOfPagesForWS;
  8004ae:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8004b1:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004b4:	01 c2                	add    %eax,%edx
  8004b6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004bc:	01 d0                	add    %edx,%eax
  8004be:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		uint32 actual = (freeFrames - sys_calculate_free_frames()) ;
  8004c4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004c7:	e8 be 22 00 00       	call   80278a <sys_calculate_free_frames>
  8004cc:	29 c3                	sub    %eax,%ebx
  8004ce:	89 d8                	mov    %ebx,%eax
  8004d0:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		if (expected != actual)
  8004d6:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8004dc:	3b 85 6c ff ff ff    	cmp    -0x94(%ebp),%eax
  8004e2:	74 23                	je     800507 <_main+0x447>
		{
			cprintf("number of allocated pages in MEMORY not correct. Expected %d, Actual %d\n", expected, actual);
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  8004ed:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  8004f3:	68 40 3e 80 00       	push   $0x803e40
  8004f8:	e8 81 05 00 00       	call   800a7e <cprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800500:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800507:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80050b:	74 04                	je     800511 <_main+0x451>
		{
			eval += 10;
  80050d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	/*Check WS elements*/
	cprintf("%~\n5: Check content of WS [20%]\n") ;
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	68 8c 3e 80 00       	push   $0x803e8c
  800519:	e8 60 05 00 00       	call   800a7e <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800521:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800528:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80052b:	c1 e0 02             	shl    $0x2,%eax
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	50                   	push   %eax
  800532:	e8 72 1b 00 00       	call   8020a9 <malloc>
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		int i = 0;
  800540:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800547:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  80054e:	eb 24                	jmp    800574 <_main+0x4b4>
		{
			expectedVAs[i++] = va;
  800550:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800553:	8d 50 01             	lea    0x1(%eax),%edx
  800556:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800566:	01 c2                	add    %eax,%edx
  800568:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056b:	89 02                	mov    %eax,(%edx)
	cprintf("%~\n5: Check content of WS [20%]\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  80056d:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  800574:	8b 45 98             	mov    -0x68(%ebp),%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80057f:	77 cf                	ja     800550 <_main+0x490>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  800581:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800584:	6a 02                	push   $0x2
  800586:	6a 00                	push   $0x0
  800588:	50                   	push   %eax
  800589:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  80058f:	e8 b8 25 00 00       	call   802b4c <sys_check_WS_list>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80059d:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  8005a4:	74 17                	je     8005bd <_main+0x4fd>
		{
			cprintf("malloc: page is not added to WS\n");
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	68 b0 3e 80 00       	push   $0x803eb0
  8005ae:	e8 cb 04 00 00       	call   800a7e <cprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8005b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8005bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005c1:	74 04                	je     8005c7 <_main+0x507>
		{
			eval += 20;
  8005c3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}

	cprintf("%~\ntest malloc (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	68 d4 3e 80 00       	push   $0x803ed4
  8005d2:	e8 a7 04 00 00       	call   800a7e <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	57                   	push   %edi
  8005e4:	56                   	push   %esi
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005e9:	e8 65 23 00 00       	call   802953 <sys_getenvindex>
  8005ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005f4:	89 d0                	mov    %edx,%eax
  8005f6:	01 c0                	add    %eax,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	c1 e0 02             	shl    $0x2,%eax
  8005fd:	01 d0                	add    %edx,%eax
  8005ff:	c1 e0 02             	shl    $0x2,%eax
  800602:	01 d0                	add    %edx,%eax
  800604:	c1 e0 03             	shl    $0x3,%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	c1 e0 02             	shl    $0x2,%eax
  80060c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800611:	a3 40 50 80 00       	mov    %eax,0x805040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800616:	a1 40 50 80 00       	mov    0x805040,%eax
  80061b:	8a 40 20             	mov    0x20(%eax),%al
  80061e:	84 c0                	test   %al,%al
  800620:	74 0d                	je     80062f <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800622:	a1 40 50 80 00       	mov    0x805040,%eax
  800627:	83 c0 20             	add    $0x20,%eax
  80062a:	a3 20 50 80 00       	mov    %eax,0x805020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80062f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800633:	7e 0a                	jle    80063f <libmain+0x5f>
		binaryname = argv[0];
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	a3 20 50 80 00       	mov    %eax,0x805020

	// call user main routine
	_main(argc, argv);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	ff 75 0c             	pushl  0xc(%ebp)
  800645:	ff 75 08             	pushl  0x8(%ebp)
  800648:	e8 73 fa ff ff       	call   8000c0 <_main>
  80064d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800650:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800655:	85 c0                	test   %eax,%eax
  800657:	0f 84 01 01 00 00    	je     80075e <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80065d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800663:	bb 14 40 80 00       	mov    $0x804014,%ebx
  800668:	ba 0e 00 00 00       	mov    $0xe,%edx
  80066d:	89 c7                	mov    %eax,%edi
  80066f:	89 de                	mov    %ebx,%esi
  800671:	89 d1                	mov    %edx,%ecx
  800673:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800675:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800678:	b9 56 00 00 00       	mov    $0x56,%ecx
  80067d:	b0 00                	mov    $0x0,%al
  80067f:	89 d7                	mov    %edx,%edi
  800681:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800683:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80068a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	50                   	push   %eax
  800691:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800697:	50                   	push   %eax
  800698:	e8 ec 24 00 00       	call   802b89 <sys_utilities>
  80069d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006a0:	e8 35 20 00 00       	call   8026da <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006a5:	83 ec 0c             	sub    $0xc,%esp
  8006a8:	68 34 3f 80 00       	push   $0x803f34
  8006ad:	e8 cc 03 00 00       	call   800a7e <cprintf>
  8006b2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b8:	85 c0                	test   %eax,%eax
  8006ba:	74 18                	je     8006d4 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006bc:	e8 e6 24 00 00       	call   802ba7 <sys_get_optimal_num_faults>
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	50                   	push   %eax
  8006c5:	68 5c 3f 80 00       	push   $0x803f5c
  8006ca:	e8 af 03 00 00       	call   800a7e <cprintf>
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	eb 59                	jmp    80072d <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8006d9:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8006df:	a1 40 50 80 00       	mov    0x805040,%eax
  8006e4:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8006ea:	83 ec 04             	sub    $0x4,%esp
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 80 3f 80 00       	push   $0x803f80
  8006f4:	e8 85 03 00 00       	call   800a7e <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006fc:	a1 40 50 80 00       	mov    0x805040,%eax
  800701:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800707:	a1 40 50 80 00       	mov    0x805040,%eax
  80070c:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800712:	a1 40 50 80 00       	mov    0x805040,%eax
  800717:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80071d:	51                   	push   %ecx
  80071e:	52                   	push   %edx
  80071f:	50                   	push   %eax
  800720:	68 a8 3f 80 00       	push   $0x803fa8
  800725:	e8 54 03 00 00       	call   800a7e <cprintf>
  80072a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80072d:	a1 40 50 80 00       	mov    0x805040,%eax
  800732:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	50                   	push   %eax
  80073c:	68 00 40 80 00       	push   $0x804000
  800741:	e8 38 03 00 00       	call   800a7e <cprintf>
  800746:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800749:	83 ec 0c             	sub    $0xc,%esp
  80074c:	68 34 3f 80 00       	push   $0x803f34
  800751:	e8 28 03 00 00       	call   800a7e <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800759:	e8 96 1f 00 00       	call   8026f4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80075e:	e8 1f 00 00 00       	call   800782 <exit>
}
  800763:	90                   	nop
  800764:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800767:	5b                   	pop    %ebx
  800768:	5e                   	pop    %esi
  800769:	5f                   	pop    %edi
  80076a:	5d                   	pop    %ebp
  80076b:	c3                   	ret    

0080076c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800772:	83 ec 0c             	sub    $0xc,%esp
  800775:	6a 00                	push   $0x0
  800777:	e8 a3 21 00 00       	call   80291f <sys_destroy_env>
  80077c:	83 c4 10             	add    $0x10,%esp
}
  80077f:	90                   	nop
  800780:	c9                   	leave  
  800781:	c3                   	ret    

00800782 <exit>:

void
exit(void)
{
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800788:	e8 f8 21 00 00       	call   802985 <sys_exit_env>
}
  80078d:	90                   	nop
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800796:	8d 45 10             	lea    0x10(%ebp),%eax
  800799:	83 c0 04             	add    $0x4,%eax
  80079c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80079f:	a1 38 13 82 00       	mov    0x821338,%eax
  8007a4:	85 c0                	test   %eax,%eax
  8007a6:	74 16                	je     8007be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a8:	a1 38 13 82 00       	mov    0x821338,%eax
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	50                   	push   %eax
  8007b1:	68 78 40 80 00       	push   $0x804078
  8007b6:	e8 c3 02 00 00       	call   800a7e <cprintf>
  8007bb:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007be:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c3:	83 ec 0c             	sub    $0xc,%esp
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	68 80 40 80 00       	push   $0x804080
  8007d2:	6a 74                	push   $0x74
  8007d4:	e8 d2 02 00 00       	call   800aab <cprintf_colored>
  8007d9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e5:	50                   	push   %eax
  8007e6:	e8 24 02 00 00       	call   800a0f <vcprintf>
  8007eb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	6a 00                	push   $0x0
  8007f3:	68 a8 40 80 00       	push   $0x8040a8
  8007f8:	e8 12 02 00 00       	call   800a0f <vcprintf>
  8007fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800800:	e8 7d ff ff ff       	call   800782 <exit>

	// should not return here
	while (1) ;
  800805:	eb fe                	jmp    800805 <_panic+0x75>

00800807 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	53                   	push   %ebx
  80080b:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80080e:	a1 40 50 80 00       	mov    0x805040,%eax
  800813:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800819:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081c:	39 c2                	cmp    %eax,%edx
  80081e:	74 14                	je     800834 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800820:	83 ec 04             	sub    $0x4,%esp
  800823:	68 ac 40 80 00       	push   $0x8040ac
  800828:	6a 26                	push   $0x26
  80082a:	68 f8 40 80 00       	push   $0x8040f8
  80082f:	e8 5c ff ff ff       	call   800790 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800842:	e9 d9 00 00 00       	jmp    800920 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	85 c0                	test   %eax,%eax
  80085a:	75 08                	jne    800864 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80085c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80085f:	e9 b9 00 00 00       	jmp    80091d <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800864:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800872:	eb 79                	jmp    8008ed <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800874:	a1 40 50 80 00       	mov    0x805040,%eax
  800879:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80087f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800882:	89 d0                	mov    %edx,%eax
  800884:	01 c0                	add    %eax,%eax
  800886:	01 d0                	add    %edx,%eax
  800888:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80088f:	01 d8                	add    %ebx,%eax
  800891:	01 d0                	add    %edx,%eax
  800893:	01 c8                	add    %ecx,%eax
  800895:	8a 40 04             	mov    0x4(%eax),%al
  800898:	84 c0                	test   %al,%al
  80089a:	75 4e                	jne    8008ea <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80089c:	a1 40 50 80 00       	mov    0x805040,%eax
  8008a1:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8008a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008aa:	89 d0                	mov    %edx,%eax
  8008ac:	01 c0                	add    %eax,%eax
  8008ae:	01 d0                	add    %edx,%eax
  8008b0:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8008b7:	01 d8                	add    %ebx,%eax
  8008b9:	01 d0                	add    %edx,%eax
  8008bb:	01 c8                	add    %ecx,%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ca:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	01 c8                	add    %ecx,%eax
  8008db:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008dd:	39 c2                	cmp    %eax,%edx
  8008df:	75 09                	jne    8008ea <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8008e1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008e8:	eb 19                	jmp    800903 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ea:	ff 45 e8             	incl   -0x18(%ebp)
  8008ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8008f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	0f 87 71 ff ff ff    	ja     800874 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800903:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800907:	75 14                	jne    80091d <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800909:	83 ec 04             	sub    $0x4,%esp
  80090c:	68 04 41 80 00       	push   $0x804104
  800911:	6a 3a                	push   $0x3a
  800913:	68 f8 40 80 00       	push   $0x8040f8
  800918:	e8 73 fe ff ff       	call   800790 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80091d:	ff 45 f0             	incl   -0x10(%ebp)
  800920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800923:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800926:	0f 8c 1b ff ff ff    	jl     800847 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80092c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800933:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80093a:	eb 2e                	jmp    80096a <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80093c:	a1 40 50 80 00       	mov    0x805040,%eax
  800941:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800947:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80094a:	89 d0                	mov    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	01 d0                	add    %edx,%eax
  800950:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800957:	01 d8                	add    %ebx,%eax
  800959:	01 d0                	add    %edx,%eax
  80095b:	01 c8                	add    %ecx,%eax
  80095d:	8a 40 04             	mov    0x4(%eax),%al
  800960:	3c 01                	cmp    $0x1,%al
  800962:	75 03                	jne    800967 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800964:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800967:	ff 45 e0             	incl   -0x20(%ebp)
  80096a:	a1 40 50 80 00       	mov    0x805040,%eax
  80096f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	39 c2                	cmp    %eax,%edx
  80097a:	77 c0                	ja     80093c <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800982:	74 14                	je     800998 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800984:	83 ec 04             	sub    $0x4,%esp
  800987:	68 58 41 80 00       	push   $0x804158
  80098c:	6a 44                	push   $0x44
  80098e:	68 f8 40 80 00       	push   $0x8040f8
  800993:	e8 f8 fd ff ff       	call   800790 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800998:	90                   	nop
  800999:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b0:	89 0a                	mov    %ecx,(%edx)
  8009b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b5:	88 d1                	mov    %dl,%cl
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c8:	75 30                	jne    8009fa <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009ca:	8b 15 3c 13 82 00    	mov    0x82133c,%edx
  8009d0:	a0 64 50 80 00       	mov    0x805064,%al
  8009d5:	0f b6 c0             	movzbl %al,%eax
  8009d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009db:	8b 09                	mov    (%ecx),%ecx
  8009dd:	89 cb                	mov    %ecx,%ebx
  8009df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e2:	83 c1 08             	add    $0x8,%ecx
  8009e5:	52                   	push   %edx
  8009e6:	50                   	push   %eax
  8009e7:	53                   	push   %ebx
  8009e8:	51                   	push   %ecx
  8009e9:	e8 a8 1c 00 00       	call   802696 <sys_cputs>
  8009ee:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fd:	8b 40 04             	mov    0x4(%eax),%eax
  800a00:	8d 50 01             	lea    0x1(%eax),%edx
  800a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a06:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a09:	90                   	nop
  800a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a18:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a1f:	00 00 00 
	b.cnt = 0;
  800a22:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a29:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a2c:	ff 75 0c             	pushl  0xc(%ebp)
  800a2f:	ff 75 08             	pushl  0x8(%ebp)
  800a32:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a38:	50                   	push   %eax
  800a39:	68 9e 09 80 00       	push   $0x80099e
  800a3e:	e8 5a 02 00 00       	call   800c9d <vprintfmt>
  800a43:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a46:	8b 15 3c 13 82 00    	mov    0x82133c,%edx
  800a4c:	a0 64 50 80 00       	mov    0x805064,%al
  800a51:	0f b6 c0             	movzbl %al,%eax
  800a54:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a5a:	52                   	push   %edx
  800a5b:	50                   	push   %eax
  800a5c:	51                   	push   %ecx
  800a5d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a63:	83 c0 08             	add    $0x8,%eax
  800a66:	50                   	push   %eax
  800a67:	e8 2a 1c 00 00       	call   802696 <sys_cputs>
  800a6c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a6f:	c6 05 64 50 80 00 00 	movb   $0x0,0x805064
	return b.cnt;
  800a76:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a84:	c6 05 64 50 80 00 01 	movb   $0x1,0x805064
	va_start(ap, fmt);
  800a8b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	e8 6f ff ff ff       	call   800a0f <vcprintf>
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ab1:	c6 05 64 50 80 00 01 	movb   $0x1,0x805064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	c1 e0 08             	shl    $0x8,%eax
  800abe:	a3 3c 13 82 00       	mov    %eax,0x82133c
	va_start(ap, fmt);
  800ac3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad5:	50                   	push   %eax
  800ad6:	e8 34 ff ff ff       	call   800a0f <vcprintf>
  800adb:	83 c4 10             	add    $0x10,%esp
  800ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800ae1:	c7 05 3c 13 82 00 00 	movl   $0x700,0x82133c
  800ae8:	07 00 00 

	return cnt;
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800af6:	e8 df 1b 00 00       	call   8026da <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800afb:	8d 45 0c             	lea    0xc(%ebp),%eax
  800afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	50                   	push   %eax
  800b0b:	e8 ff fe ff ff       	call   800a0f <vcprintf>
  800b10:	83 c4 10             	add    $0x10,%esp
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b16:	e8 d9 1b 00 00       	call   8026f4 <sys_unlock_cons>
	return cnt;
  800b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	53                   	push   %ebx
  800b24:	83 ec 14             	sub    $0x14,%esp
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b33:	8b 45 18             	mov    0x18(%ebp),%eax
  800b36:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b3e:	77 55                	ja     800b95 <printnum+0x75>
  800b40:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b43:	72 05                	jb     800b4a <printnum+0x2a>
  800b45:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b48:	77 4b                	ja     800b95 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b4a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b4d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b50:	8b 45 18             	mov    0x18(%ebp),%eax
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	52                   	push   %edx
  800b59:	50                   	push   %eax
  800b5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b60:	e8 d3 2d 00 00       	call   803938 <__udivdi3>
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	ff 75 20             	pushl  0x20(%ebp)
  800b6e:	53                   	push   %ebx
  800b6f:	ff 75 18             	pushl  0x18(%ebp)
  800b72:	52                   	push   %edx
  800b73:	50                   	push   %eax
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 a1 ff ff ff       	call   800b20 <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
  800b82:	eb 1a                	jmp    800b9e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 20             	pushl  0x20(%ebp)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	ff d0                	call   *%eax
  800b92:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b95:	ff 4d 1c             	decl   0x1c(%ebp)
  800b98:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b9c:	7f e6                	jg     800b84 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b9e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ba1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bac:	53                   	push   %ebx
  800bad:	51                   	push   %ecx
  800bae:	52                   	push   %edx
  800baf:	50                   	push   %eax
  800bb0:	e8 93 2e 00 00       	call   803a48 <__umoddi3>
  800bb5:	83 c4 10             	add    $0x10,%esp
  800bb8:	05 d4 43 80 00       	add    $0x8043d4,%eax
  800bbd:	8a 00                	mov    (%eax),%al
  800bbf:	0f be c0             	movsbl %al,%eax
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	50                   	push   %eax
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
}
  800bd1:	90                   	nop
  800bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bda:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bde:	7e 1c                	jle    800bfc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	8d 50 08             	lea    0x8(%eax),%edx
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	89 10                	mov    %edx,(%eax)
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8b 00                	mov    (%eax),%eax
  800bf2:	83 e8 08             	sub    $0x8,%eax
  800bf5:	8b 50 04             	mov    0x4(%eax),%edx
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	eb 40                	jmp    800c3c <getuint+0x65>
	else if (lflag)
  800bfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c00:	74 1e                	je     800c20 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	8d 50 04             	lea    0x4(%eax),%edx
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 10                	mov    %edx,(%eax)
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	83 e8 04             	sub    $0x4,%eax
  800c17:	8b 00                	mov    (%eax),%eax
  800c19:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1e:	eb 1c                	jmp    800c3c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 50 04             	lea    0x4(%eax),%edx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 10                	mov    %edx,(%eax)
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	83 e8 04             	sub    $0x4,%eax
  800c35:	8b 00                	mov    (%eax),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c41:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c45:	7e 1c                	jle    800c63 <getint+0x25>
		return va_arg(*ap, long long);
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8b 00                	mov    (%eax),%eax
  800c4c:	8d 50 08             	lea    0x8(%eax),%edx
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	89 10                	mov    %edx,(%eax)
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8b 00                	mov    (%eax),%eax
  800c59:	83 e8 08             	sub    $0x8,%eax
  800c5c:	8b 50 04             	mov    0x4(%eax),%edx
  800c5f:	8b 00                	mov    (%eax),%eax
  800c61:	eb 38                	jmp    800c9b <getint+0x5d>
	else if (lflag)
  800c63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c67:	74 1a                	je     800c83 <getint+0x45>
		return va_arg(*ap, long);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 00                	mov    (%eax),%eax
  800c6e:	8d 50 04             	lea    0x4(%eax),%edx
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 10                	mov    %edx,(%eax)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	83 e8 04             	sub    $0x4,%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	99                   	cltd   
  800c81:	eb 18                	jmp    800c9b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	8d 50 04             	lea    0x4(%eax),%edx
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	89 10                	mov    %edx,(%eax)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	83 e8 04             	sub    $0x4,%eax
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	99                   	cltd   
}
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
  800ca2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca5:	eb 17                	jmp    800cbe <vprintfmt+0x21>
			if (ch == '\0')
  800ca7:	85 db                	test   %ebx,%ebx
  800ca9:	0f 84 c1 03 00 00    	je     801070 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	0f b6 d8             	movzbl %al,%ebx
  800ccc:	83 fb 25             	cmp    $0x25,%ebx
  800ccf:	75 d6                	jne    800ca7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cd1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cd5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cdc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ce3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	0f b6 d8             	movzbl %al,%ebx
  800cff:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d02:	83 f8 5b             	cmp    $0x5b,%eax
  800d05:	0f 87 3d 03 00 00    	ja     801048 <vprintfmt+0x3ab>
  800d0b:	8b 04 85 f8 43 80 00 	mov    0x8043f8(,%eax,4),%eax
  800d12:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d14:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d18:	eb d7                	jmp    800cf1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d1a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d1e:	eb d1                	jmp    800cf1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d2a:	89 d0                	mov    %edx,%eax
  800d2c:	c1 e0 02             	shl    $0x2,%eax
  800d2f:	01 d0                	add    %edx,%eax
  800d31:	01 c0                	add    %eax,%eax
  800d33:	01 d8                	add    %ebx,%eax
  800d35:	83 e8 30             	sub    $0x30,%eax
  800d38:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d43:	83 fb 2f             	cmp    $0x2f,%ebx
  800d46:	7e 3e                	jle    800d86 <vprintfmt+0xe9>
  800d48:	83 fb 39             	cmp    $0x39,%ebx
  800d4b:	7f 39                	jg     800d86 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d4d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d50:	eb d5                	jmp    800d27 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 00                	mov    (%eax),%eax
  800d63:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d66:	eb 1f                	jmp    800d87 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6c:	79 83                	jns    800cf1 <vprintfmt+0x54>
				width = 0;
  800d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d75:	e9 77 ff ff ff       	jmp    800cf1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d7a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d81:	e9 6b ff ff ff       	jmp    800cf1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d86:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8b:	0f 89 60 ff ff ff    	jns    800cf1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d97:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d9e:	e9 4e ff ff ff       	jmp    800cf1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800da3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800da6:	e9 46 ff ff ff       	jmp    800cf1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 00                	mov    (%eax),%eax
  800dbc:	83 ec 08             	sub    $0x8,%esp
  800dbf:	ff 75 0c             	pushl  0xc(%ebp)
  800dc2:	50                   	push   %eax
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	ff d0                	call   *%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
			break;
  800dcb:	e9 9b 02 00 00       	jmp    80106b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd3:	83 c0 04             	add    $0x4,%eax
  800dd6:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddc:	83 e8 04             	sub    $0x4,%eax
  800ddf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800de1:	85 db                	test   %ebx,%ebx
  800de3:	79 02                	jns    800de7 <vprintfmt+0x14a>
				err = -err;
  800de5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800de7:	83 fb 64             	cmp    $0x64,%ebx
  800dea:	7f 0b                	jg     800df7 <vprintfmt+0x15a>
  800dec:	8b 34 9d 40 42 80 00 	mov    0x804240(,%ebx,4),%esi
  800df3:	85 f6                	test   %esi,%esi
  800df5:	75 19                	jne    800e10 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800df7:	53                   	push   %ebx
  800df8:	68 e5 43 80 00       	push   $0x8043e5
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	ff 75 08             	pushl  0x8(%ebp)
  800e03:	e8 70 02 00 00       	call   801078 <printfmt>
  800e08:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e0b:	e9 5b 02 00 00       	jmp    80106b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e10:	56                   	push   %esi
  800e11:	68 ee 43 80 00       	push   $0x8043ee
  800e16:	ff 75 0c             	pushl  0xc(%ebp)
  800e19:	ff 75 08             	pushl  0x8(%ebp)
  800e1c:	e8 57 02 00 00       	call   801078 <printfmt>
  800e21:	83 c4 10             	add    $0x10,%esp
			break;
  800e24:	e9 42 02 00 00       	jmp    80106b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e29:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2c:	83 c0 04             	add    $0x4,%eax
  800e2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e32:	8b 45 14             	mov    0x14(%ebp),%eax
  800e35:	83 e8 04             	sub    $0x4,%eax
  800e38:	8b 30                	mov    (%eax),%esi
  800e3a:	85 f6                	test   %esi,%esi
  800e3c:	75 05                	jne    800e43 <vprintfmt+0x1a6>
				p = "(null)";
  800e3e:	be f1 43 80 00       	mov    $0x8043f1,%esi
			if (width > 0 && padc != '-')
  800e43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e47:	7e 6d                	jle    800eb6 <vprintfmt+0x219>
  800e49:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e4d:	74 67                	je     800eb6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e52:	83 ec 08             	sub    $0x8,%esp
  800e55:	50                   	push   %eax
  800e56:	56                   	push   %esi
  800e57:	e8 1e 03 00 00       	call   80117a <strnlen>
  800e5c:	83 c4 10             	add    $0x10,%esp
  800e5f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e62:	eb 16                	jmp    800e7a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e64:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e77:	ff 4d e4             	decl   -0x1c(%ebp)
  800e7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7e:	7f e4                	jg     800e64 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e80:	eb 34                	jmp    800eb6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e86:	74 1c                	je     800ea4 <vprintfmt+0x207>
  800e88:	83 fb 1f             	cmp    $0x1f,%ebx
  800e8b:	7e 05                	jle    800e92 <vprintfmt+0x1f5>
  800e8d:	83 fb 7e             	cmp    $0x7e,%ebx
  800e90:	7e 12                	jle    800ea4 <vprintfmt+0x207>
					putch('?', putdat);
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	ff 75 0c             	pushl  0xc(%ebp)
  800e98:	6a 3f                	push   $0x3f
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	ff d0                	call   *%eax
  800e9f:	83 c4 10             	add    $0x10,%esp
  800ea2:	eb 0f                	jmp    800eb3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ea4:	83 ec 08             	sub    $0x8,%esp
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	53                   	push   %ebx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	ff d0                	call   *%eax
  800eb0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb3:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb6:	89 f0                	mov    %esi,%eax
  800eb8:	8d 70 01             	lea    0x1(%eax),%esi
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f be d8             	movsbl %al,%ebx
  800ec0:	85 db                	test   %ebx,%ebx
  800ec2:	74 24                	je     800ee8 <vprintfmt+0x24b>
  800ec4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec8:	78 b8                	js     800e82 <vprintfmt+0x1e5>
  800eca:	ff 4d e0             	decl   -0x20(%ebp)
  800ecd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed1:	79 af                	jns    800e82 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ed3:	eb 13                	jmp    800ee8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	6a 20                	push   $0x20
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	ff d0                	call   *%eax
  800ee2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eec:	7f e7                	jg     800ed5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eee:	e9 78 01 00 00       	jmp    80106b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef9:	8d 45 14             	lea    0x14(%ebp),%eax
  800efc:	50                   	push   %eax
  800efd:	e8 3c fd ff ff       	call   800c3e <getint>
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f11:	85 d2                	test   %edx,%edx
  800f13:	79 23                	jns    800f38 <vprintfmt+0x29b>
				putch('-', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 2d                	push   $0x2d
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2b:	f7 d8                	neg    %eax
  800f2d:	83 d2 00             	adc    $0x0,%edx
  800f30:	f7 da                	neg    %edx
  800f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f38:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3f:	e9 bc 00 00 00       	jmp    801000 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	ff 75 e8             	pushl  -0x18(%ebp)
  800f4a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f4d:	50                   	push   %eax
  800f4e:	e8 84 fc ff ff       	call   800bd7 <getuint>
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f63:	e9 98 00 00 00       	jmp    801000 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f68:	83 ec 08             	sub    $0x8,%esp
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	6a 58                	push   $0x58
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	ff d0                	call   *%eax
  800f75:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	6a 58                	push   $0x58
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	ff d0                	call   *%eax
  800f85:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	6a 58                	push   $0x58
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	ff d0                	call   *%eax
  800f95:	83 c4 10             	add    $0x10,%esp
			break;
  800f98:	e9 ce 00 00 00       	jmp    80106b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 30                	push   $0x30
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	6a 78                	push   $0x78
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	ff d0                	call   *%eax
  800fba:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc0:	83 c0 04             	add    $0x4,%eax
  800fc3:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc9:	83 e8 04             	sub    $0x4,%eax
  800fcc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fd8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fdf:	eb 1f                	jmp    801000 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fe1:	83 ec 08             	sub    $0x8,%esp
  800fe4:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe7:	8d 45 14             	lea    0x14(%ebp),%eax
  800fea:	50                   	push   %eax
  800feb:	e8 e7 fb ff ff       	call   800bd7 <getuint>
  800ff0:	83 c4 10             	add    $0x10,%esp
  800ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ff9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801000:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801007:	83 ec 04             	sub    $0x4,%esp
  80100a:	52                   	push   %edx
  80100b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80100e:	50                   	push   %eax
  80100f:	ff 75 f4             	pushl  -0xc(%ebp)
  801012:	ff 75 f0             	pushl  -0x10(%ebp)
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 00 fb ff ff       	call   800b20 <printnum>
  801020:	83 c4 20             	add    $0x20,%esp
			break;
  801023:	eb 46                	jmp    80106b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	53                   	push   %ebx
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	ff d0                	call   *%eax
  801031:	83 c4 10             	add    $0x10,%esp
			break;
  801034:	eb 35                	jmp    80106b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801036:	c6 05 64 50 80 00 00 	movb   $0x0,0x805064
			break;
  80103d:	eb 2c                	jmp    80106b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80103f:	c6 05 64 50 80 00 01 	movb   $0x1,0x805064
			break;
  801046:	eb 23                	jmp    80106b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801048:	83 ec 08             	sub    $0x8,%esp
  80104b:	ff 75 0c             	pushl  0xc(%ebp)
  80104e:	6a 25                	push   $0x25
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	ff d0                	call   *%eax
  801055:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801058:	ff 4d 10             	decl   0x10(%ebp)
  80105b:	eb 03                	jmp    801060 <vprintfmt+0x3c3>
  80105d:	ff 4d 10             	decl   0x10(%ebp)
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	48                   	dec    %eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	3c 25                	cmp    $0x25,%al
  801068:	75 f3                	jne    80105d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80106a:	90                   	nop
		}
	}
  80106b:	e9 35 fc ff ff       	jmp    800ca5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801070:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801071:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80107e:	8d 45 10             	lea    0x10(%ebp),%eax
  801081:	83 c0 04             	add    $0x4,%eax
  801084:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	ff 75 f4             	pushl  -0xc(%ebp)
  80108d:	50                   	push   %eax
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	ff 75 08             	pushl  0x8(%ebp)
  801094:	e8 04 fc ff ff       	call   800c9d <vprintfmt>
  801099:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80109c:	90                   	nop
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	8b 40 08             	mov    0x8(%eax),%eax
  8010a8:	8d 50 01             	lea    0x1(%eax),%edx
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	8b 10                	mov    (%eax),%edx
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	8b 40 04             	mov    0x4(%eax),%eax
  8010bc:	39 c2                	cmp    %eax,%edx
  8010be:	73 12                	jae    8010d2 <sprintputch+0x33>
		*b->buf++ = ch;
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	8b 00                	mov    (%eax),%eax
  8010c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cb:	89 0a                	mov    %ecx,(%edx)
  8010cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d0:	88 10                	mov    %dl,(%eax)
}
  8010d2:	90                   	nop
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	01 d0                	add    %edx,%eax
  8010ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010fa:	74 06                	je     801102 <vsnprintf+0x2d>
  8010fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801100:	7f 07                	jg     801109 <vsnprintf+0x34>
		return -E_INVAL;
  801102:	b8 03 00 00 00       	mov    $0x3,%eax
  801107:	eb 20                	jmp    801129 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801109:	ff 75 14             	pushl  0x14(%ebp)
  80110c:	ff 75 10             	pushl  0x10(%ebp)
  80110f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801112:	50                   	push   %eax
  801113:	68 9f 10 80 00       	push   $0x80109f
  801118:	e8 80 fb ff ff       	call   800c9d <vprintfmt>
  80111d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801123:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801126:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801129:	c9                   	leave  
  80112a:	c3                   	ret    

0080112b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801131:	8d 45 10             	lea    0x10(%ebp),%eax
  801134:	83 c0 04             	add    $0x4,%eax
  801137:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80113a:	8b 45 10             	mov    0x10(%ebp),%eax
  80113d:	ff 75 f4             	pushl  -0xc(%ebp)
  801140:	50                   	push   %eax
  801141:	ff 75 0c             	pushl  0xc(%ebp)
  801144:	ff 75 08             	pushl  0x8(%ebp)
  801147:	e8 89 ff ff ff       	call   8010d5 <vsnprintf>
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80115d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801164:	eb 06                	jmp    80116c <strlen+0x15>
		n++;
  801166:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801169:	ff 45 08             	incl   0x8(%ebp)
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	84 c0                	test   %al,%al
  801173:	75 f1                	jne    801166 <strlen+0xf>
		n++;
	return n;
  801175:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801187:	eb 09                	jmp    801192 <strnlen+0x18>
		n++;
  801189:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	ff 4d 0c             	decl   0xc(%ebp)
  801192:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801196:	74 09                	je     8011a1 <strnlen+0x27>
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	84 c0                	test   %al,%al
  80119f:	75 e8                	jne    801189 <strnlen+0xf>
		n++;
	return n;
  8011a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011b2:	90                   	nop
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8d 50 01             	lea    0x1(%eax),%edx
  8011b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011c5:	8a 12                	mov    (%edx),%dl
  8011c7:	88 10                	mov    %dl,(%eax)
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 e4                	jne    8011b3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e7:	eb 1f                	jmp    801208 <strncpy+0x34>
		*dst++ = *src;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f5:	8a 12                	mov    (%edx),%dl
  8011f7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	84 c0                	test   %al,%al
  801200:	74 03                	je     801205 <strncpy+0x31>
			src++;
  801202:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801205:	ff 45 fc             	incl   -0x4(%ebp)
  801208:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80120e:	72 d9                	jb     8011e9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801210:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801221:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801225:	74 30                	je     801257 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801227:	eb 16                	jmp    80123f <strlcpy+0x2a>
			*dst++ = *src++;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8d 50 01             	lea    0x1(%eax),%edx
  80122f:	89 55 08             	mov    %edx,0x8(%ebp)
  801232:	8b 55 0c             	mov    0xc(%ebp),%edx
  801235:	8d 4a 01             	lea    0x1(%edx),%ecx
  801238:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80123b:	8a 12                	mov    (%edx),%dl
  80123d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80123f:	ff 4d 10             	decl   0x10(%ebp)
  801242:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801246:	74 09                	je     801251 <strlcpy+0x3c>
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	84 c0                	test   %al,%al
  80124f:	75 d8                	jne    801229 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801257:	8b 55 08             	mov    0x8(%ebp),%edx
  80125a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	c9                   	leave  
  801262:	c3                   	ret    

00801263 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801266:	eb 06                	jmp    80126e <strcmp+0xb>
		p++, q++;
  801268:	ff 45 08             	incl   0x8(%ebp)
  80126b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 0e                	je     801285 <strcmp+0x22>
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 10                	mov    (%eax),%dl
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	38 c2                	cmp    %al,%dl
  801283:	74 e3                	je     801268 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	0f b6 d0             	movzbl %al,%edx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f b6 c0             	movzbl %al,%eax
  801295:	29 c2                	sub    %eax,%edx
  801297:	89 d0                	mov    %edx,%eax
}
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80129e:	eb 09                	jmp    8012a9 <strncmp+0xe>
		n--, p++, q++;
  8012a0:	ff 4d 10             	decl   0x10(%ebp)
  8012a3:	ff 45 08             	incl   0x8(%ebp)
  8012a6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ad:	74 17                	je     8012c6 <strncmp+0x2b>
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 0e                	je     8012c6 <strncmp+0x2b>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 10                	mov    (%eax),%dl
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	38 c2                	cmp    %al,%dl
  8012c4:	74 da                	je     8012a0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ca:	75 07                	jne    8012d3 <strncmp+0x38>
		return 0;
  8012cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d1:	eb 14                	jmp    8012e7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f b6 d0             	movzbl %al,%edx
  8012db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 c0             	movzbl %al,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
}
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    

008012e9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012f5:	eb 12                	jmp    801309 <strchr+0x20>
		if (*s == c)
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ff:	75 05                	jne    801306 <strchr+0x1d>
			return (char *) s;
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	eb 11                	jmp    801317 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801306:	ff 45 08             	incl   0x8(%ebp)
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	75 e5                	jne    8012f7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801325:	eb 0d                	jmp    801334 <strfind+0x1b>
		if (*s == c)
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80132f:	74 0e                	je     80133f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801331:	ff 45 08             	incl   0x8(%ebp)
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	84 c0                	test   %al,%al
  80133b:	75 ea                	jne    801327 <strfind+0xe>
  80133d:	eb 01                	jmp    801340 <strfind+0x27>
		if (*s == c)
			break;
  80133f:	90                   	nop
	return (char *) s;
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801351:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801355:	76 63                	jbe    8013ba <memset+0x75>
		uint64 data_block = c;
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	99                   	cltd   
  80135b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80135e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801367:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80136b:	c1 e0 08             	shl    $0x8,%eax
  80136e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801371:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80137e:	c1 e0 10             	shl    $0x10,%eax
  801381:	09 45 f0             	or     %eax,-0x10(%ebp)
  801384:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138d:	89 c2                	mov    %eax,%edx
  80138f:	b8 00 00 00 00       	mov    $0x0,%eax
  801394:	09 45 f0             	or     %eax,-0x10(%ebp)
  801397:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80139a:	eb 18                	jmp    8013b4 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80139c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139f:	8d 41 08             	lea    0x8(%ecx),%eax
  8013a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8013a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ab:	89 01                	mov    %eax,(%ecx)
  8013ad:	89 51 04             	mov    %edx,0x4(%ecx)
  8013b0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8013b4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013b8:	77 e2                	ja     80139c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8013ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013be:	74 23                	je     8013e3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8013c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013c6:	eb 0e                	jmp    8013d6 <memset+0x91>
			*p8++ = (uint8)c;
  8013c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cb:	8d 50 01             	lea    0x1(%eax),%edx
  8013ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	75 e5                	jne    8013c8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8013ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8013fa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013fe:	76 24                	jbe    801424 <memcpy+0x3c>
		while(n >= 8){
  801400:	eb 1c                	jmp    80141e <memcpy+0x36>
			*d64 = *s64;
  801402:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801405:	8b 50 04             	mov    0x4(%eax),%edx
  801408:	8b 00                	mov    (%eax),%eax
  80140a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80140d:	89 01                	mov    %eax,(%ecx)
  80140f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801412:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801416:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80141a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80141e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801422:	77 de                	ja     801402 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801424:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801428:	74 31                	je     80145b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80142a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801430:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801433:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801436:	eb 16                	jmp    80144e <memcpy+0x66>
			*d8++ = *s8++;
  801438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143b:	8d 50 01             	lea    0x1(%eax),%edx
  80143e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	8d 4a 01             	lea    0x1(%edx),%ecx
  801447:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80144a:	8a 12                	mov    (%edx),%dl
  80144c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80144e:	8b 45 10             	mov    0x10(%ebp),%eax
  801451:	8d 50 ff             	lea    -0x1(%eax),%edx
  801454:	89 55 10             	mov    %edx,0x10(%ebp)
  801457:	85 c0                	test   %eax,%eax
  801459:	75 dd                	jne    801438 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801472:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801475:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801478:	73 50                	jae    8014ca <memmove+0x6a>
  80147a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147d:	8b 45 10             	mov    0x10(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801485:	76 43                	jbe    8014ca <memmove+0x6a>
		s += n;
  801487:	8b 45 10             	mov    0x10(%ebp),%eax
  80148a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801493:	eb 10                	jmp    8014a5 <memmove+0x45>
			*--d = *--s;
  801495:	ff 4d f8             	decl   -0x8(%ebp)
  801498:	ff 4d fc             	decl   -0x4(%ebp)
  80149b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149e:	8a 10                	mov    (%eax),%dl
  8014a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	75 e3                	jne    801495 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014b2:	eb 23                	jmp    8014d7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014c3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014c6:	8a 12                	mov    (%edx),%dl
  8014c8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	75 dd                	jne    8014b4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014ee:	eb 2a                	jmp    80151a <memcmp+0x3e>
		if (*s1 != *s2)
  8014f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f3:	8a 10                	mov    (%eax),%dl
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	38 c2                	cmp    %al,%dl
  8014fc:	74 16                	je     801514 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	0f b6 d0             	movzbl %al,%edx
  801506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	0f b6 c0             	movzbl %al,%eax
  80150e:	29 c2                	sub    %eax,%edx
  801510:	89 d0                	mov    %edx,%eax
  801512:	eb 18                	jmp    80152c <memcmp+0x50>
		s1++, s2++;
  801514:	ff 45 fc             	incl   -0x4(%ebp)
  801517:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801520:	89 55 10             	mov    %edx,0x10(%ebp)
  801523:	85 c0                	test   %eax,%eax
  801525:	75 c9                	jne    8014f0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801534:	8b 55 08             	mov    0x8(%ebp),%edx
  801537:	8b 45 10             	mov    0x10(%ebp),%eax
  80153a:	01 d0                	add    %edx,%eax
  80153c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80153f:	eb 15                	jmp    801556 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	0f b6 c0             	movzbl %al,%eax
  80154f:	39 c2                	cmp    %eax,%edx
  801551:	74 0d                	je     801560 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801553:	ff 45 08             	incl   0x8(%ebp)
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80155c:	72 e3                	jb     801541 <memfind+0x13>
  80155e:	eb 01                	jmp    801561 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801560:	90                   	nop
	return (void *) s;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80156c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801573:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157a:	eb 03                	jmp    80157f <strtol+0x19>
		s++;
  80157c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8a 00                	mov    (%eax),%al
  801584:	3c 20                	cmp    $0x20,%al
  801586:	74 f4                	je     80157c <strtol+0x16>
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	3c 09                	cmp    $0x9,%al
  80158f:	74 eb                	je     80157c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	3c 2b                	cmp    $0x2b,%al
  801598:	75 05                	jne    80159f <strtol+0x39>
		s++;
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	eb 13                	jmp    8015b2 <strtol+0x4c>
	else if (*s == '-')
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	3c 2d                	cmp    $0x2d,%al
  8015a6:	75 0a                	jne    8015b2 <strtol+0x4c>
		s++, neg = 1;
  8015a8:	ff 45 08             	incl   0x8(%ebp)
  8015ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b6:	74 06                	je     8015be <strtol+0x58>
  8015b8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015bc:	75 20                	jne    8015de <strtol+0x78>
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	3c 30                	cmp    $0x30,%al
  8015c5:	75 17                	jne    8015de <strtol+0x78>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	40                   	inc    %eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	3c 78                	cmp    $0x78,%al
  8015cf:	75 0d                	jne    8015de <strtol+0x78>
		s += 2, base = 16;
  8015d1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015d5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015dc:	eb 28                	jmp    801606 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015e2:	75 15                	jne    8015f9 <strtol+0x93>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 30                	cmp    $0x30,%al
  8015eb:	75 0c                	jne    8015f9 <strtol+0x93>
		s++, base = 8;
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015f7:	eb 0d                	jmp    801606 <strtol+0xa0>
	else if (base == 0)
  8015f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015fd:	75 07                	jne    801606 <strtol+0xa0>
		base = 10;
  8015ff:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	3c 2f                	cmp    $0x2f,%al
  80160d:	7e 19                	jle    801628 <strtol+0xc2>
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	3c 39                	cmp    $0x39,%al
  801616:	7f 10                	jg     801628 <strtol+0xc2>
			dig = *s - '0';
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	8a 00                	mov    (%eax),%al
  80161d:	0f be c0             	movsbl %al,%eax
  801620:	83 e8 30             	sub    $0x30,%eax
  801623:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801626:	eb 42                	jmp    80166a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	3c 60                	cmp    $0x60,%al
  80162f:	7e 19                	jle    80164a <strtol+0xe4>
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	3c 7a                	cmp    $0x7a,%al
  801638:	7f 10                	jg     80164a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	0f be c0             	movsbl %al,%eax
  801642:	83 e8 57             	sub    $0x57,%eax
  801645:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801648:	eb 20                	jmp    80166a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	8a 00                	mov    (%eax),%al
  80164f:	3c 40                	cmp    $0x40,%al
  801651:	7e 39                	jle    80168c <strtol+0x126>
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	3c 5a                	cmp    $0x5a,%al
  80165a:	7f 30                	jg     80168c <strtol+0x126>
			dig = *s - 'A' + 10;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8a 00                	mov    (%eax),%al
  801661:	0f be c0             	movsbl %al,%eax
  801664:	83 e8 37             	sub    $0x37,%eax
  801667:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801670:	7d 19                	jge    80168b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801672:	ff 45 08             	incl   0x8(%ebp)
  801675:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801678:	0f af 45 10          	imul   0x10(%ebp),%eax
  80167c:	89 c2                	mov    %eax,%edx
  80167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801681:	01 d0                	add    %edx,%eax
  801683:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801686:	e9 7b ff ff ff       	jmp    801606 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80168b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80168c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801690:	74 08                	je     80169a <strtol+0x134>
		*endptr = (char *) s;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 55 08             	mov    0x8(%ebp),%edx
  801698:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80169a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80169e:	74 07                	je     8016a7 <strtol+0x141>
  8016a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a3:	f7 d8                	neg    %eax
  8016a5:	eb 03                	jmp    8016aa <strtol+0x144>
  8016a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <ltostr>:

void
ltostr(long value, char *str)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016c4:	79 13                	jns    8016d9 <ltostr+0x2d>
	{
		neg = 1;
  8016c6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016d3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016d6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016e1:	99                   	cltd   
  8016e2:	f7 f9                	idiv   %ecx
  8016e4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ea:	8d 50 01             	lea    0x1(%eax),%edx
  8016ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f0:	89 c2                	mov    %eax,%edx
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	01 d0                	add    %edx,%eax
  8016f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016fa:	83 c2 30             	add    $0x30,%edx
  8016fd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801702:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801707:	f7 e9                	imul   %ecx
  801709:	c1 fa 02             	sar    $0x2,%edx
  80170c:	89 c8                	mov    %ecx,%eax
  80170e:	c1 f8 1f             	sar    $0x1f,%eax
  801711:	29 c2                	sub    %eax,%edx
  801713:	89 d0                	mov    %edx,%eax
  801715:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801718:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80171c:	75 bb                	jne    8016d9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80171e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801725:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801728:	48                   	dec    %eax
  801729:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80172c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801730:	74 3d                	je     80176f <ltostr+0xc3>
		start = 1 ;
  801732:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801739:	eb 34                	jmp    80176f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80173b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	8a 00                	mov    (%eax),%al
  801745:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174e:	01 c2                	add    %eax,%edx
  801750:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801753:	8b 45 0c             	mov    0xc(%ebp),%eax
  801756:	01 c8                	add    %ecx,%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80175c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80175f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801762:	01 c2                	add    %eax,%edx
  801764:	8a 45 eb             	mov    -0x15(%ebp),%al
  801767:	88 02                	mov    %al,(%edx)
		start++ ;
  801769:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80176c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801772:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801775:	7c c4                	jl     80173b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801777:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	01 d0                	add    %edx,%eax
  80177f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801782:	90                   	nop
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	e8 c4 f9 ff ff       	call   801157 <strlen>
  801793:	83 c4 04             	add    $0x4,%esp
  801796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	e8 b6 f9 ff ff       	call   801157 <strlen>
  8017a1:	83 c4 04             	add    $0x4,%esp
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b5:	eb 17                	jmp    8017ce <strcconcat+0x49>
		final[s] = str1[s] ;
  8017b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	01 c8                	add    %ecx,%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017cb:	ff 45 fc             	incl   -0x4(%ebp)
  8017ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017d4:	7c e1                	jl     8017b7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017e4:	eb 1f                	jmp    801805 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	8d 50 01             	lea    0x1(%eax),%edx
  8017ec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017ef:	89 c2                	mov    %eax,%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 c2                	add    %eax,%edx
  8017f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	01 c8                	add    %ecx,%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801802:	ff 45 f8             	incl   -0x8(%ebp)
  801805:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801808:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80180b:	7c d9                	jl     8017e6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80180d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801810:	8b 45 10             	mov    0x10(%ebp),%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	c6 00 00             	movb   $0x0,(%eax)
}
  801818:	90                   	nop
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80181e:	8b 45 14             	mov    0x14(%ebp),%eax
  801821:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801827:	8b 45 14             	mov    0x14(%ebp),%eax
  80182a:	8b 00                	mov    (%eax),%eax
  80182c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 d0                	add    %edx,%eax
  801838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80183e:	eb 0c                	jmp    80184c <strsplit+0x31>
			*string++ = 0;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8d 50 01             	lea    0x1(%eax),%edx
  801846:	89 55 08             	mov    %edx,0x8(%ebp)
  801849:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	8a 00                	mov    (%eax),%al
  801851:	84 c0                	test   %al,%al
  801853:	74 18                	je     80186d <strsplit+0x52>
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	8a 00                	mov    (%eax),%al
  80185a:	0f be c0             	movsbl %al,%eax
  80185d:	50                   	push   %eax
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	e8 83 fa ff ff       	call   8012e9 <strchr>
  801866:	83 c4 08             	add    $0x8,%esp
  801869:	85 c0                	test   %eax,%eax
  80186b:	75 d3                	jne    801840 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8a 00                	mov    (%eax),%al
  801872:	84 c0                	test   %al,%al
  801874:	74 5a                	je     8018d0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801876:	8b 45 14             	mov    0x14(%ebp),%eax
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	83 f8 0f             	cmp    $0xf,%eax
  80187e:	75 07                	jne    801887 <strsplit+0x6c>
		{
			return 0;
  801880:	b8 00 00 00 00       	mov    $0x0,%eax
  801885:	eb 66                	jmp    8018ed <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801887:	8b 45 14             	mov    0x14(%ebp),%eax
  80188a:	8b 00                	mov    (%eax),%eax
  80188c:	8d 48 01             	lea    0x1(%eax),%ecx
  80188f:	8b 55 14             	mov    0x14(%ebp),%edx
  801892:	89 0a                	mov    %ecx,(%edx)
  801894:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80189b:	8b 45 10             	mov    0x10(%ebp),%eax
  80189e:	01 c2                	add    %eax,%edx
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018a5:	eb 03                	jmp    8018aa <strsplit+0x8f>
			string++;
  8018a7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	84 c0                	test   %al,%al
  8018b1:	74 8b                	je     80183e <strsplit+0x23>
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	0f be c0             	movsbl %al,%eax
  8018bb:	50                   	push   %eax
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	e8 25 fa ff ff       	call   8012e9 <strchr>
  8018c4:	83 c4 08             	add    $0x8,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	74 dc                	je     8018a7 <strsplit+0x8c>
			string++;
	}
  8018cb:	e9 6e ff ff ff       	jmp    80183e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018d0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 d0                	add    %edx,%eax
  8018e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8018fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801902:	eb 4a                	jmp    80194e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801904:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	01 c2                	add    %eax,%edx
  80190c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	01 c8                	add    %ecx,%eax
  801914:	8a 00                	mov    (%eax),%al
  801916:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801918:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191e:	01 d0                	add    %edx,%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	3c 40                	cmp    $0x40,%al
  801924:	7e 25                	jle    80194b <str2lower+0x5c>
  801926:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 17                	jg     80194b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801934:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	01 d0                	add    %edx,%eax
  80193c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80193f:	8b 55 08             	mov    0x8(%ebp),%edx
  801942:	01 ca                	add    %ecx,%edx
  801944:	8a 12                	mov    (%edx),%dl
  801946:	83 c2 20             	add    $0x20,%edx
  801949:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80194b:	ff 45 fc             	incl   -0x4(%ebp)
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	e8 01 f8 ff ff       	call   801157 <strlen>
  801956:	83 c4 04             	add    $0x4,%esp
  801959:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80195c:	7f a6                	jg     801904 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	6a 10                	push   $0x10
  80196e:	e8 b2 15 00 00       	call   802f25 <alloc_block>
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801979:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80197d:	75 14                	jne    801993 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	68 68 45 80 00       	push   $0x804568
  801987:	6a 14                	push   $0x14
  801989:	68 91 45 80 00       	push   $0x804591
  80198e:	e8 fd ed ff ff       	call   800790 <_panic>

	node->start = start;
  801993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801996:	8b 55 08             	mov    0x8(%ebp),%edx
  801999:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80199b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a1:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8019a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8019ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8019b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019b3:	eb 18                	jmp    8019cd <insert_page_alloc+0x6a>
		if (start < it->start)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	8b 00                	mov    (%eax),%eax
  8019ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019bd:	77 37                	ja     8019f6 <insert_page_alloc+0x93>
			break;
		prev = it;
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8019c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019d1:	74 08                	je     8019db <insert_page_alloc+0x78>
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	8b 40 08             	mov    0x8(%eax),%eax
  8019d9:	eb 05                	jmp    8019e0 <insert_page_alloc+0x7d>
  8019db:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e0:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8019e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	75 c7                	jne    8019b5 <insert_page_alloc+0x52>
  8019ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f2:	75 c1                	jne    8019b5 <insert_page_alloc+0x52>
  8019f4:	eb 01                	jmp    8019f7 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8019f6:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8019f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019fb:	75 64                	jne    801a61 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8019fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a01:	75 14                	jne    801a17 <insert_page_alloc+0xb4>
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	68 a0 45 80 00       	push   $0x8045a0
  801a0b:	6a 21                	push   $0x21
  801a0d:	68 91 45 80 00       	push   $0x804591
  801a12:	e8 79 ed ff ff       	call   800790 <_panic>
  801a17:	8b 15 44 50 80 00    	mov    0x805044,%edx
  801a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a20:	89 50 08             	mov    %edx,0x8(%eax)
  801a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a26:	8b 40 08             	mov    0x8(%eax),%eax
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	74 0d                	je     801a3a <insert_page_alloc+0xd7>
  801a2d:	a1 44 50 80 00       	mov    0x805044,%eax
  801a32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a35:	89 50 0c             	mov    %edx,0xc(%eax)
  801a38:	eb 08                	jmp    801a42 <insert_page_alloc+0xdf>
  801a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3d:	a3 48 50 80 00       	mov    %eax,0x805048
  801a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a45:	a3 44 50 80 00       	mov    %eax,0x805044
  801a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a54:	a1 50 50 80 00       	mov    0x805050,%eax
  801a59:	40                   	inc    %eax
  801a5a:	a3 50 50 80 00       	mov    %eax,0x805050
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801a5f:	eb 71                	jmp    801ad2 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a65:	74 06                	je     801a6d <insert_page_alloc+0x10a>
  801a67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a6b:	75 14                	jne    801a81 <insert_page_alloc+0x11e>
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	68 c4 45 80 00       	push   $0x8045c4
  801a75:	6a 23                	push   $0x23
  801a77:	68 91 45 80 00       	push   $0x804591
  801a7c:	e8 0f ed ff ff       	call   800790 <_panic>
  801a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a84:	8b 50 08             	mov    0x8(%eax),%edx
  801a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8a:	89 50 08             	mov    %edx,0x8(%eax)
  801a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a90:	8b 40 08             	mov    0x8(%eax),%eax
  801a93:	85 c0                	test   %eax,%eax
  801a95:	74 0c                	je     801aa3 <insert_page_alloc+0x140>
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	8b 40 08             	mov    0x8(%eax),%eax
  801a9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aa0:	89 50 0c             	mov    %edx,0xc(%eax)
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aa9:	89 50 08             	mov    %edx,0x8(%eax)
  801aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab2:	89 50 0c             	mov    %edx,0xc(%eax)
  801ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab8:	8b 40 08             	mov    0x8(%eax),%eax
  801abb:	85 c0                	test   %eax,%eax
  801abd:	75 08                	jne    801ac7 <insert_page_alloc+0x164>
  801abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac2:	a3 48 50 80 00       	mov    %eax,0x805048
  801ac7:	a1 50 50 80 00       	mov    0x805050,%eax
  801acc:	40                   	inc    %eax
  801acd:	a3 50 50 80 00       	mov    %eax,0x805050
}
  801ad2:	90                   	nop
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801adb:	a1 44 50 80 00       	mov    0x805044,%eax
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	75 0c                	jne    801af0 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801ae4:	a1 30 13 82 00       	mov    0x821330,%eax
  801ae9:	a3 88 12 82 00       	mov    %eax,0x821288
		return;
  801aee:	eb 67                	jmp    801b57 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801af0:	a1 30 13 82 00       	mov    0x821330,%eax
  801af5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801af8:	a1 44 50 80 00       	mov    0x805044,%eax
  801afd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801b00:	eb 26                	jmp    801b28 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801b02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b05:	8b 10                	mov    (%eax),%edx
  801b07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0a:	8b 40 04             	mov    0x4(%eax),%eax
  801b0d:	01 d0                	add    %edx,%eax
  801b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b15:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b18:	76 06                	jbe    801b20 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b20:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b25:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801b28:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801b2c:	74 08                	je     801b36 <recompute_page_alloc_break+0x61>
  801b2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b31:	8b 40 08             	mov    0x8(%eax),%eax
  801b34:	eb 05                	jmp    801b3b <recompute_page_alloc_break+0x66>
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  801b40:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b45:	85 c0                	test   %eax,%eax
  801b47:	75 b9                	jne    801b02 <recompute_page_alloc_break+0x2d>
  801b49:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801b4d:	75 b3                	jne    801b02 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b52:	a3 88 12 82 00       	mov    %eax,0x821288
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801b5f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801b66:	8b 55 08             	mov    0x8(%ebp),%edx
  801b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b6c:	01 d0                	add    %edx,%eax
  801b6e:	48                   	dec    %eax
  801b6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801b72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b75:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7a:	f7 75 d8             	divl   -0x28(%ebp)
  801b7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b80:	29 d0                	sub    %edx,%eax
  801b82:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801b85:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801b89:	75 0a                	jne    801b95 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	e9 7e 01 00 00       	jmp    801d13 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801b9c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801ba0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801ba7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801bae:	a1 30 13 82 00       	mov    0x821330,%eax
  801bb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801bb6:	a1 44 50 80 00       	mov    0x805044,%eax
  801bbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bbe:	eb 69                	jmp    801c29 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801bc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc3:	8b 00                	mov    (%eax),%eax
  801bc5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801bc8:	76 47                	jbe    801c11 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bcd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801bd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd3:	8b 00                	mov    (%eax),%eax
  801bd5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801bd8:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801bdb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bde:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801be1:	72 2e                	jb     801c11 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801be3:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801be7:	75 14                	jne    801bfd <alloc_pages_custom_fit+0xa4>
  801be9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bec:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801bef:	75 0c                	jne    801bfd <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801bf7:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801bfb:	eb 14                	jmp    801c11 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801bfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c00:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c03:	76 0c                	jbe    801c11 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801c05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801c0b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c14:	8b 10                	mov    (%eax),%edx
  801c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c19:	8b 40 04             	mov    0x4(%eax),%eax
  801c1c:	01 d0                	add    %edx,%eax
  801c1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801c21:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c2d:	74 08                	je     801c37 <alloc_pages_custom_fit+0xde>
  801c2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c32:	8b 40 08             	mov    0x8(%eax),%eax
  801c35:	eb 05                	jmp    801c3c <alloc_pages_custom_fit+0xe3>
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  801c41:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c46:	85 c0                	test   %eax,%eax
  801c48:	0f 85 72 ff ff ff    	jne    801bc0 <alloc_pages_custom_fit+0x67>
  801c4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c52:	0f 85 68 ff ff ff    	jne    801bc0 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801c58:	a1 88 12 82 00       	mov    0x821288,%eax
  801c5d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c60:	76 47                	jbe    801ca9 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c65:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801c68:	a1 88 12 82 00       	mov    0x821288,%eax
  801c6d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801c70:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801c73:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c76:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c79:	72 2e                	jb     801ca9 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801c7b:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801c7f:	75 14                	jne    801c95 <alloc_pages_custom_fit+0x13c>
  801c81:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c84:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c87:	75 0c                	jne    801c95 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801c89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801c8f:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801c93:	eb 14                	jmp    801ca9 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801c95:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c98:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c9b:	76 0c                	jbe    801ca9 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801c9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801ca3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ca6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801ca9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801cb0:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801cb4:	74 08                	je     801cbe <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cbc:	eb 40                	jmp    801cfe <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801cbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cc2:	74 08                	je     801ccc <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cca:	eb 32                	jmp    801cfe <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801ccc:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801cd1:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801cd4:	89 c2                	mov    %eax,%edx
  801cd6:	a1 88 12 82 00       	mov    0x821288,%eax
  801cdb:	39 c2                	cmp    %eax,%edx
  801cdd:	73 07                	jae    801ce6 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce4:	eb 2d                	jmp    801d13 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801ce6:	a1 88 12 82 00       	mov    0x821288,%eax
  801ceb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801cee:	8b 15 88 12 82 00    	mov    0x821288,%edx
  801cf4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cf7:	01 d0                	add    %edx,%eax
  801cf9:	a3 88 12 82 00       	mov    %eax,0x821288
	}


	insert_page_alloc((uint32)result, required_size);
  801cfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d01:	83 ec 08             	sub    $0x8,%esp
  801d04:	ff 75 d0             	pushl  -0x30(%ebp)
  801d07:	50                   	push   %eax
  801d08:	e8 56 fc ff ff       	call   801963 <insert_page_alloc>
  801d0d:	83 c4 10             	add    $0x10,%esp

	return result;
  801d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d21:	a1 44 50 80 00       	mov    0x805044,%eax
  801d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d29:	eb 1a                	jmp    801d45 <find_allocated_size+0x30>
		if (it->start == va)
  801d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2e:	8b 00                	mov    (%eax),%eax
  801d30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d33:	75 08                	jne    801d3d <find_allocated_size+0x28>
			return it->size;
  801d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d38:	8b 40 04             	mov    0x4(%eax),%eax
  801d3b:	eb 34                	jmp    801d71 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d3d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d45:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d49:	74 08                	je     801d53 <find_allocated_size+0x3e>
  801d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d4e:	8b 40 08             	mov    0x8(%eax),%eax
  801d51:	eb 05                	jmp    801d58 <find_allocated_size+0x43>
  801d53:	b8 00 00 00 00       	mov    $0x0,%eax
  801d58:	a3 4c 50 80 00       	mov    %eax,0x80504c
  801d5d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d62:	85 c0                	test   %eax,%eax
  801d64:	75 c5                	jne    801d2b <find_allocated_size+0x16>
  801d66:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d6a:	75 bf                	jne    801d2b <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d7f:	a1 44 50 80 00       	mov    0x805044,%eax
  801d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d87:	e9 e1 01 00 00       	jmp    801f6d <free_pages+0x1fa>
		if (it->start == va) {
  801d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8f:	8b 00                	mov    (%eax),%eax
  801d91:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d94:	0f 85 cb 01 00 00    	jne    801f65 <free_pages+0x1f2>

			uint32 start = it->start;
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	8b 00                	mov    (%eax),%eax
  801d9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	8b 40 04             	mov    0x4(%eax),%eax
  801da8:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dae:	f7 d0                	not    %eax
  801db0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801db3:	73 1d                	jae    801dd2 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dbb:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbe:	68 f8 45 80 00       	push   $0x8045f8
  801dc3:	68 a5 00 00 00       	push   $0xa5
  801dc8:	68 91 45 80 00       	push   $0x804591
  801dcd:	e8 be e9 ff ff       	call   800790 <_panic>
			}

			uint32 start_end = start + size;
  801dd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd8:	01 d0                	add    %edx,%eax
  801dda:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de0:	85 c0                	test   %eax,%eax
  801de2:	79 19                	jns    801dfd <free_pages+0x8a>
  801de4:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801deb:	77 10                	ja     801dfd <free_pages+0x8a>
  801ded:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801df4:	77 07                	ja     801dfd <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 2c                	js     801e29 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	68 00 00 00 a0       	push   $0xa0000000
  801e08:	ff 75 e0             	pushl  -0x20(%ebp)
  801e0b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e0e:	ff 75 e8             	pushl  -0x18(%ebp)
  801e11:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e14:	50                   	push   %eax
  801e15:	68 3c 46 80 00       	push   $0x80463c
  801e1a:	68 ad 00 00 00       	push   $0xad
  801e1f:	68 91 45 80 00       	push   $0x804591
  801e24:	e8 67 e9 ff ff       	call   800790 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e2f:	e9 88 00 00 00       	jmp    801ebc <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801e34:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801e3b:	76 17                	jbe    801e54 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801e3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e40:	68 a0 46 80 00       	push   $0x8046a0
  801e45:	68 b4 00 00 00       	push   $0xb4
  801e4a:	68 91 45 80 00       	push   $0x804591
  801e4f:	e8 3c e9 ff ff       	call   800790 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e57:	05 00 10 00 00       	add    $0x1000,%eax
  801e5c:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	79 2e                	jns    801e94 <free_pages+0x121>
  801e66:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801e6d:	77 25                	ja     801e94 <free_pages+0x121>
  801e6f:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801e76:	77 1c                	ja     801e94 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801e78:	83 ec 08             	sub    $0x8,%esp
  801e7b:	68 00 10 00 00       	push   $0x1000
  801e80:	ff 75 f0             	pushl  -0x10(%ebp)
  801e83:	e8 38 0d 00 00       	call   802bc0 <sys_free_user_mem>
  801e88:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801e8b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801e92:	eb 28                	jmp    801ebc <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e97:	68 00 00 00 a0       	push   $0xa0000000
  801e9c:	ff 75 dc             	pushl  -0x24(%ebp)
  801e9f:	68 00 10 00 00       	push   $0x1000
  801ea4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea7:	50                   	push   %eax
  801ea8:	68 e0 46 80 00       	push   $0x8046e0
  801ead:	68 bd 00 00 00       	push   $0xbd
  801eb2:	68 91 45 80 00       	push   $0x804591
  801eb7:	e8 d4 e8 ff ff       	call   800790 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ec2:	0f 82 6c ff ff ff    	jb     801e34 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecc:	75 17                	jne    801ee5 <free_pages+0x172>
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	68 42 47 80 00       	push   $0x804742
  801ed6:	68 c1 00 00 00       	push   $0xc1
  801edb:	68 91 45 80 00       	push   $0x804591
  801ee0:	e8 ab e8 ff ff       	call   800790 <_panic>
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 40 08             	mov    0x8(%eax),%eax
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	74 11                	je     801f00 <free_pages+0x18d>
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	8b 40 08             	mov    0x8(%eax),%eax
  801ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef8:	8b 52 0c             	mov    0xc(%edx),%edx
  801efb:	89 50 0c             	mov    %edx,0xc(%eax)
  801efe:	eb 0b                	jmp    801f0b <free_pages+0x198>
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	8b 40 0c             	mov    0xc(%eax),%eax
  801f06:	a3 48 50 80 00       	mov    %eax,0x805048
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f11:	85 c0                	test   %eax,%eax
  801f13:	74 11                	je     801f26 <free_pages+0x1b3>
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1e:	8b 52 08             	mov    0x8(%edx),%edx
  801f21:	89 50 08             	mov    %edx,0x8(%eax)
  801f24:	eb 0b                	jmp    801f31 <free_pages+0x1be>
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	8b 40 08             	mov    0x8(%eax),%eax
  801f2c:	a3 44 50 80 00       	mov    %eax,0x805044
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f45:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4a:	48                   	dec    %eax
  801f4b:	a3 50 50 80 00       	mov    %eax,0x805050
			free_block(it);
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff 75 f4             	pushl  -0xc(%ebp)
  801f56:	e8 24 15 00 00       	call   80347f <free_block>
  801f5b:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801f5e:	e8 72 fb ff ff       	call   801ad5 <recompute_page_alloc_break>

			return;
  801f63:	eb 37                	jmp    801f9c <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f65:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f71:	74 08                	je     801f7b <free_pages+0x208>
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 40 08             	mov    0x8(%eax),%eax
  801f79:	eb 05                	jmp    801f80 <free_pages+0x20d>
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	a3 4c 50 80 00       	mov    %eax,0x80504c
  801f85:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	0f 85 fa fd ff ff    	jne    801d8c <free_pages+0x19>
  801f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f96:	0f 85 f0 fd ff ff    	jne    801d8c <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    

00801fa8 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801fae:	a1 24 50 80 00       	mov    0x805024,%eax
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	74 60                	je     802017 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	68 00 00 00 82       	push   $0x82000000
  801fbf:	68 00 00 00 80       	push   $0x80000000
  801fc4:	e8 0d 0d 00 00       	call   802cd6 <initialize_dynamic_allocator>
  801fc9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801fcc:	e8 f3 0a 00 00       	call   802ac4 <sys_get_uheap_strategy>
  801fd1:	a3 80 12 82 00       	mov    %eax,0x821280
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801fd6:	a1 60 50 80 00       	mov    0x805060,%eax
  801fdb:	05 00 10 00 00       	add    $0x1000,%eax
  801fe0:	a3 30 13 82 00       	mov    %eax,0x821330
		uheapPageAllocBreak = uheapPageAllocStart;
  801fe5:	a1 30 13 82 00       	mov    0x821330,%eax
  801fea:	a3 88 12 82 00       	mov    %eax,0x821288

		LIST_INIT(&page_alloc_list);
  801fef:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801ff6:	00 00 00 
  801ff9:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802000:	00 00 00 
  802003:	c7 05 50 50 80 00 00 	movl   $0x0,0x805050
  80200a:	00 00 00 

		__firstTimeFlag = 0;
  80200d:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  802014:	00 00 00 
	}
}
  802017:	90                   	nop
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80202e:	83 ec 08             	sub    $0x8,%esp
  802031:	68 06 04 00 00       	push   $0x406
  802036:	50                   	push   %eax
  802037:	e8 d2 06 00 00       	call   80270e <__sys_allocate_page>
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802046:	79 17                	jns    80205f <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 60 47 80 00       	push   $0x804760
  802050:	68 ea 00 00 00       	push   $0xea
  802055:	68 91 45 80 00       	push   $0x804591
  80205a:	e8 31 e7 ff ff       	call   800790 <_panic>
	return 0;
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80207a:	83 ec 0c             	sub    $0xc,%esp
  80207d:	50                   	push   %eax
  80207e:	e8 d2 06 00 00       	call   802755 <__sys_unmap_frame>
  802083:	83 c4 10             	add    $0x10,%esp
  802086:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802089:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80208d:	79 17                	jns    8020a6 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	68 9c 47 80 00       	push   $0x80479c
  802097:	68 f5 00 00 00       	push   $0xf5
  80209c:	68 91 45 80 00       	push   $0x804591
  8020a1:	e8 ea e6 ff ff       	call   800790 <_panic>
}
  8020a6:	90                   	nop
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8020af:	e8 f4 fe ff ff       	call   801fa8 <uheap_init>
	if (size == 0) return NULL ;
  8020b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b8:	75 0a                	jne    8020c4 <malloc+0x1b>
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	e9 67 01 00 00       	jmp    80222b <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8020c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8020cb:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8020d2:	77 16                	ja     8020ea <malloc+0x41>
		result = alloc_block(size);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 08             	pushl  0x8(%ebp)
  8020da:	e8 46 0e 00 00       	call   802f25 <alloc_block>
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e5:	e9 3e 01 00 00       	jmp    802228 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  8020ea:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f7:	01 d0                	add    %edx,%eax
  8020f9:	48                   	dec    %eax
  8020fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802100:	ba 00 00 00 00       	mov    $0x0,%edx
  802105:	f7 75 f0             	divl   -0x10(%ebp)
  802108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210b:	29 d0                	sub    %edx,%eax
  80210d:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802110:	a1 30 13 82 00       	mov    0x821330,%eax
  802115:	85 c0                	test   %eax,%eax
  802117:	75 0a                	jne    802123 <malloc+0x7a>
			return NULL;
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	e9 08 01 00 00       	jmp    80222b <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802123:	a1 88 12 82 00       	mov    0x821288,%eax
  802128:	85 c0                	test   %eax,%eax
  80212a:	74 0f                	je     80213b <malloc+0x92>
  80212c:	8b 15 88 12 82 00    	mov    0x821288,%edx
  802132:	a1 30 13 82 00       	mov    0x821330,%eax
  802137:	39 c2                	cmp    %eax,%edx
  802139:	73 0a                	jae    802145 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  80213b:	a1 30 13 82 00       	mov    0x821330,%eax
  802140:	a3 88 12 82 00       	mov    %eax,0x821288
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802145:	a1 80 12 82 00       	mov    0x821280,%eax
  80214a:	83 f8 05             	cmp    $0x5,%eax
  80214d:	75 11                	jne    802160 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	ff 75 e8             	pushl  -0x18(%ebp)
  802155:	e8 ff f9 ff ff       	call   801b59 <alloc_pages_custom_fit>
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802164:	0f 84 be 00 00 00    	je     802228 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	ff 75 f4             	pushl  -0xc(%ebp)
  802176:	e8 9a fb ff ff       	call   801d15 <find_allocated_size>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802181:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802185:	75 17                	jne    80219e <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802187:	ff 75 f4             	pushl  -0xc(%ebp)
  80218a:	68 dc 47 80 00       	push   $0x8047dc
  80218f:	68 24 01 00 00       	push   $0x124
  802194:	68 91 45 80 00       	push   $0x804591
  802199:	e8 f2 e5 ff ff       	call   800790 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  80219e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a1:	f7 d0                	not    %eax
  8021a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021a6:	73 1d                	jae    8021c5 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8021ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021b1:	68 24 48 80 00       	push   $0x804824
  8021b6:	68 29 01 00 00       	push   $0x129
  8021bb:	68 91 45 80 00       	push   $0x804591
  8021c0:	e8 cb e5 ff ff       	call   800790 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8021c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8021d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	79 2c                	jns    802203 <malloc+0x15a>
  8021d7:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  8021de:	77 23                	ja     802203 <malloc+0x15a>
  8021e0:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8021e7:	77 1a                	ja     802203 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  8021e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	79 13                	jns    802203 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  8021f0:	83 ec 08             	sub    $0x8,%esp
  8021f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8021f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021f9:	e8 de 09 00 00       	call   802bdc <sys_allocate_user_mem>
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	eb 25                	jmp    802228 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802203:	68 00 00 00 a0       	push   $0xa0000000
  802208:	ff 75 dc             	pushl  -0x24(%ebp)
  80220b:	ff 75 e0             	pushl  -0x20(%ebp)
  80220e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802211:	ff 75 f4             	pushl  -0xc(%ebp)
  802214:	68 60 48 80 00       	push   $0x804860
  802219:	68 33 01 00 00       	push   $0x133
  80221e:	68 91 45 80 00       	push   $0x804591
  802223:	e8 68 e5 ff ff       	call   800790 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802237:	0f 84 26 01 00 00    	je     802363 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	79 1c                	jns    802266 <free+0x39>
  80224a:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802251:	77 13                	ja     802266 <free+0x39>
		free_block(virtual_address);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	ff 75 08             	pushl  0x8(%ebp)
  802259:	e8 21 12 00 00       	call   80347f <free_block>
  80225e:	83 c4 10             	add    $0x10,%esp
		return;
  802261:	e9 01 01 00 00       	jmp    802367 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802266:	a1 30 13 82 00       	mov    0x821330,%eax
  80226b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80226e:	0f 82 d8 00 00 00    	jb     80234c <free+0x11f>
  802274:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  80227b:	0f 87 cb 00 00 00    	ja     80234c <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	25 ff 0f 00 00       	and    $0xfff,%eax
  802289:	85 c0                	test   %eax,%eax
  80228b:	74 17                	je     8022a4 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80228d:	ff 75 08             	pushl  0x8(%ebp)
  802290:	68 d0 48 80 00       	push   $0x8048d0
  802295:	68 57 01 00 00       	push   $0x157
  80229a:	68 91 45 80 00       	push   $0x804591
  80229f:	e8 ec e4 ff ff       	call   800790 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8022a4:	83 ec 0c             	sub    $0xc,%esp
  8022a7:	ff 75 08             	pushl  0x8(%ebp)
  8022aa:	e8 66 fa ff ff       	call   801d15 <find_allocated_size>
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8022b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b9:	0f 84 a7 00 00 00    	je     802366 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	f7 d0                	not    %eax
  8022c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022c7:	73 1d                	jae    8022e6 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8022cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d2:	68 f8 48 80 00       	push   $0x8048f8
  8022d7:	68 61 01 00 00       	push   $0x161
  8022dc:	68 91 45 80 00       	push   $0x804591
  8022e1:	e8 aa e4 ff ff       	call   800790 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8022e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ec:	01 d0                	add    %edx,%eax
  8022ee:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	79 19                	jns    802311 <free+0xe4>
  8022f8:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8022ff:	77 10                	ja     802311 <free+0xe4>
  802301:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802308:	77 07                	ja     802311 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80230a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230d:	85 c0                	test   %eax,%eax
  80230f:	78 2b                	js     80233c <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802311:	83 ec 0c             	sub    $0xc,%esp
  802314:	68 00 00 00 a0       	push   $0xa0000000
  802319:	ff 75 ec             	pushl  -0x14(%ebp)
  80231c:	ff 75 f0             	pushl  -0x10(%ebp)
  80231f:	ff 75 f4             	pushl  -0xc(%ebp)
  802322:	ff 75 f0             	pushl  -0x10(%ebp)
  802325:	ff 75 08             	pushl  0x8(%ebp)
  802328:	68 34 49 80 00       	push   $0x804934
  80232d:	68 69 01 00 00       	push   $0x169
  802332:	68 91 45 80 00       	push   $0x804591
  802337:	e8 54 e4 ff ff       	call   800790 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	ff 75 08             	pushl  0x8(%ebp)
  802342:	e8 2c fa ff ff       	call   801d73 <free_pages>
  802347:	83 c4 10             	add    $0x10,%esp
		return;
  80234a:	eb 1b                	jmp    802367 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  80234c:	ff 75 08             	pushl  0x8(%ebp)
  80234f:	68 90 49 80 00       	push   $0x804990
  802354:	68 70 01 00 00       	push   $0x170
  802359:	68 91 45 80 00       	push   $0x804591
  80235e:	e8 2d e4 ff ff       	call   800790 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802363:	90                   	nop
  802364:	eb 01                	jmp    802367 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802366:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 38             	sub    $0x38,%esp
  80236f:	8b 45 10             	mov    0x10(%ebp),%eax
  802372:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802375:	e8 2e fc ff ff       	call   801fa8 <uheap_init>
	if (size == 0) return NULL ;
  80237a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80237e:	75 0a                	jne    80238a <smalloc+0x21>
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	e9 3d 01 00 00       	jmp    8024c7 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80238a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802390:	8b 45 0c             	mov    0xc(%ebp),%eax
  802393:	25 ff 0f 00 00       	and    $0xfff,%eax
  802398:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80239b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80239f:	74 0e                	je     8023af <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8023a7:	05 00 10 00 00       	add    $0x1000,%eax
  8023ac:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	c1 e8 0c             	shr    $0xc,%eax
  8023b5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8023b8:	a1 30 13 82 00       	mov    0x821330,%eax
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	75 0a                	jne    8023cb <smalloc+0x62>
		return NULL;
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c6:	e9 fc 00 00 00       	jmp    8024c7 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8023cb:	a1 88 12 82 00       	mov    0x821288,%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0f                	je     8023e3 <smalloc+0x7a>
  8023d4:	8b 15 88 12 82 00    	mov    0x821288,%edx
  8023da:	a1 30 13 82 00       	mov    0x821330,%eax
  8023df:	39 c2                	cmp    %eax,%edx
  8023e1:	73 0a                	jae    8023ed <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8023e3:	a1 30 13 82 00       	mov    0x821330,%eax
  8023e8:	a3 88 12 82 00       	mov    %eax,0x821288

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8023ed:	a1 30 13 82 00       	mov    0x821330,%eax
  8023f2:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8023f7:	29 c2                	sub    %eax,%edx
  8023f9:	89 d0                	mov    %edx,%eax
  8023fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8023fe:	8b 15 88 12 82 00    	mov    0x821288,%edx
  802404:	a1 30 13 82 00       	mov    0x821330,%eax
  802409:	29 c2                	sub    %eax,%edx
  80240b:	89 d0                	mov    %edx,%eax
  80240d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802416:	77 13                	ja     80242b <smalloc+0xc2>
  802418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80241e:	77 0b                	ja     80242b <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802423:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802426:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802429:	73 0a                	jae    802435 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
  802430:	e9 92 00 00 00       	jmp    8024c7 <smalloc+0x15e>
	}

	void *va = NULL;
  802435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80243c:	a1 80 12 82 00       	mov    0x821280,%eax
  802441:	83 f8 05             	cmp    $0x5,%eax
  802444:	75 11                	jne    802457 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802446:	83 ec 0c             	sub    $0xc,%esp
  802449:	ff 75 f4             	pushl  -0xc(%ebp)
  80244c:	e8 08 f7 ff ff       	call   801b59 <alloc_pages_custom_fit>
  802451:	83 c4 10             	add    $0x10,%esp
  802454:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802457:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80245b:	75 27                	jne    802484 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80245d:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802464:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802467:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80246a:	89 c2                	mov    %eax,%edx
  80246c:	a1 88 12 82 00       	mov    0x821288,%eax
  802471:	39 c2                	cmp    %eax,%edx
  802473:	73 07                	jae    80247c <smalloc+0x113>
			return NULL;}
  802475:	b8 00 00 00 00       	mov    $0x0,%eax
  80247a:	eb 4b                	jmp    8024c7 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80247c:	a1 88 12 82 00       	mov    0x821288,%eax
  802481:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802484:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802488:	ff 75 f0             	pushl  -0x10(%ebp)
  80248b:	50                   	push   %eax
  80248c:	ff 75 0c             	pushl  0xc(%ebp)
  80248f:	ff 75 08             	pushl  0x8(%ebp)
  802492:	e8 cb 03 00 00       	call   802862 <sys_create_shared_object>
  802497:	83 c4 10             	add    $0x10,%esp
  80249a:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80249d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8024a1:	79 07                	jns    8024aa <smalloc+0x141>
		return NULL;
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	eb 1d                	jmp    8024c7 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8024aa:	a1 88 12 82 00       	mov    0x821288,%eax
  8024af:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8024b2:	75 10                	jne    8024c4 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8024b4:	8b 15 88 12 82 00    	mov    0x821288,%edx
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	01 d0                	add    %edx,%eax
  8024bf:	a3 88 12 82 00       	mov    %eax,0x821288
	}

	return va;
  8024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024cf:	e8 d4 fa ff ff       	call   801fa8 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8024d4:	83 ec 08             	sub    $0x8,%esp
  8024d7:	ff 75 0c             	pushl  0xc(%ebp)
  8024da:	ff 75 08             	pushl  0x8(%ebp)
  8024dd:	e8 aa 03 00 00       	call   80288c <sys_size_of_shared_object>
  8024e2:	83 c4 10             	add    $0x10,%esp
  8024e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8024e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024ec:	7f 0a                	jg     8024f8 <sget+0x2f>
		return NULL;
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	e9 32 01 00 00       	jmp    80262a <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8024f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8024fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802501:	25 ff 0f 00 00       	and    $0xfff,%eax
  802506:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802509:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80250d:	74 0e                	je     80251d <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802515:	05 00 10 00 00       	add    $0x1000,%eax
  80251a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80251d:	a1 30 13 82 00       	mov    0x821330,%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	75 0a                	jne    802530 <sget+0x67>
		return NULL;
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
  80252b:	e9 fa 00 00 00       	jmp    80262a <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802530:	a1 88 12 82 00       	mov    0x821288,%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	74 0f                	je     802548 <sget+0x7f>
  802539:	8b 15 88 12 82 00    	mov    0x821288,%edx
  80253f:	a1 30 13 82 00       	mov    0x821330,%eax
  802544:	39 c2                	cmp    %eax,%edx
  802546:	73 0a                	jae    802552 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802548:	a1 30 13 82 00       	mov    0x821330,%eax
  80254d:	a3 88 12 82 00       	mov    %eax,0x821288

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802552:	a1 30 13 82 00       	mov    0x821330,%eax
  802557:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80255c:	29 c2                	sub    %eax,%edx
  80255e:	89 d0                	mov    %edx,%eax
  802560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802563:	8b 15 88 12 82 00    	mov    0x821288,%edx
  802569:	a1 30 13 82 00       	mov    0x821330,%eax
  80256e:	29 c2                	sub    %eax,%edx
  802570:	89 d0                	mov    %edx,%eax
  802572:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80257b:	77 13                	ja     802590 <sget+0xc7>
  80257d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802580:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802583:	77 0b                	ja     802590 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802588:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80258b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80258e:	73 0a                	jae    80259a <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
  802595:	e9 90 00 00 00       	jmp    80262a <sget+0x161>

	void *va = NULL;
  80259a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8025a1:	a1 80 12 82 00       	mov    0x821280,%eax
  8025a6:	83 f8 05             	cmp    $0x5,%eax
  8025a9:	75 11                	jne    8025bc <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8025ab:	83 ec 0c             	sub    $0xc,%esp
  8025ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b1:	e8 a3 f5 ff ff       	call   801b59 <alloc_pages_custom_fit>
  8025b6:	83 c4 10             	add    $0x10,%esp
  8025b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8025bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c0:	75 27                	jne    8025e9 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8025c2:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8025c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025cc:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8025cf:	89 c2                	mov    %eax,%edx
  8025d1:	a1 88 12 82 00       	mov    0x821288,%eax
  8025d6:	39 c2                	cmp    %eax,%edx
  8025d8:	73 07                	jae    8025e1 <sget+0x118>
			return NULL;
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	eb 49                	jmp    80262a <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8025e1:	a1 88 12 82 00       	mov    0x821288,%eax
  8025e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8025e9:	83 ec 04             	sub    $0x4,%esp
  8025ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ef:	ff 75 0c             	pushl  0xc(%ebp)
  8025f2:	ff 75 08             	pushl  0x8(%ebp)
  8025f5:	e8 af 02 00 00       	call   8028a9 <sys_get_shared_object>
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802600:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802604:	79 07                	jns    80260d <sget+0x144>
		return NULL;
  802606:	b8 00 00 00 00       	mov    $0x0,%eax
  80260b:	eb 1d                	jmp    80262a <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80260d:	a1 88 12 82 00       	mov    0x821288,%eax
  802612:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802615:	75 10                	jne    802627 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802617:	8b 15 88 12 82 00    	mov    0x821288,%edx
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	01 d0                	add    %edx,%eax
  802622:	a3 88 12 82 00       	mov    %eax,0x821288

	return va;
  802627:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802632:	e8 71 f9 ff ff       	call   801fa8 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802637:	83 ec 04             	sub    $0x4,%esp
  80263a:	68 b4 49 80 00       	push   $0x8049b4
  80263f:	68 19 02 00 00       	push   $0x219
  802644:	68 91 45 80 00       	push   $0x804591
  802649:	e8 42 e1 ff ff       	call   800790 <_panic>

0080264e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 dc 49 80 00       	push   $0x8049dc
  80265c:	68 2b 02 00 00       	push   $0x22b
  802661:	68 91 45 80 00       	push   $0x804591
  802666:	e8 25 e1 ff ff       	call   800790 <_panic>

0080266b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	57                   	push   %edi
  80266f:	56                   	push   %esi
  802670:	53                   	push   %ebx
  802671:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80267d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802680:	8b 7d 18             	mov    0x18(%ebp),%edi
  802683:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802686:	cd 30                	int    $0x30
  802688:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80268e:	83 c4 10             	add    $0x10,%esp
  802691:	5b                   	pop    %ebx
  802692:	5e                   	pop    %esi
  802693:	5f                   	pop    %edi
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    

00802696 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 04             	sub    $0x4,%esp
  80269c:	8b 45 10             	mov    0x10(%ebp),%eax
  80269f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8026a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	6a 00                	push   $0x0
  8026ae:	51                   	push   %ecx
  8026af:	52                   	push   %edx
  8026b0:	ff 75 0c             	pushl  0xc(%ebp)
  8026b3:	50                   	push   %eax
  8026b4:	6a 00                	push   $0x0
  8026b6:	e8 b0 ff ff ff       	call   80266b <syscall>
  8026bb:	83 c4 18             	add    $0x18,%esp
}
  8026be:	90                   	nop
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 02                	push   $0x2
  8026d0:	e8 96 ff ff ff       	call   80266b <syscall>
  8026d5:	83 c4 18             	add    $0x18,%esp
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    

008026da <sys_lock_cons>:

void sys_lock_cons(void)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 03                	push   $0x3
  8026e9:	e8 7d ff ff ff       	call   80266b <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
}
  8026f1:	90                   	nop
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    

008026f4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 04                	push   $0x4
  802703:	e8 63 ff ff ff       	call   80266b <syscall>
  802708:	83 c4 18             	add    $0x18,%esp
}
  80270b:	90                   	nop
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802711:	8b 55 0c             	mov    0xc(%ebp),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	52                   	push   %edx
  80271e:	50                   	push   %eax
  80271f:	6a 08                	push   $0x8
  802721:	e8 45 ff ff ff       	call   80266b <syscall>
  802726:	83 c4 18             	add    $0x18,%esp
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
  80272e:	56                   	push   %esi
  80272f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802730:	8b 75 18             	mov    0x18(%ebp),%esi
  802733:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802736:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	56                   	push   %esi
  802740:	53                   	push   %ebx
  802741:	51                   	push   %ecx
  802742:	52                   	push   %edx
  802743:	50                   	push   %eax
  802744:	6a 09                	push   $0x9
  802746:	e8 20 ff ff ff       	call   80266b <syscall>
  80274b:	83 c4 18             	add    $0x18,%esp
}
  80274e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    

00802755 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	ff 75 08             	pushl  0x8(%ebp)
  802763:	6a 0a                	push   $0xa
  802765:	e8 01 ff ff ff       	call   80266b <syscall>
  80276a:	83 c4 18             	add    $0x18,%esp
}
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    

0080276f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	ff 75 0c             	pushl  0xc(%ebp)
  80277b:	ff 75 08             	pushl  0x8(%ebp)
  80277e:	6a 0b                	push   $0xb
  802780:	e8 e6 fe ff ff       	call   80266b <syscall>
  802785:	83 c4 18             	add    $0x18,%esp
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 0c                	push   $0xc
  802799:	e8 cd fe ff ff       	call   80266b <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 0d                	push   $0xd
  8027b2:	e8 b4 fe ff ff       	call   80266b <syscall>
  8027b7:	83 c4 18             	add    $0x18,%esp
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 0e                	push   $0xe
  8027cb:	e8 9b fe ff ff       	call   80266b <syscall>
  8027d0:	83 c4 18             	add    $0x18,%esp
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 0f                	push   $0xf
  8027e4:	e8 82 fe ff ff       	call   80266b <syscall>
  8027e9:	83 c4 18             	add    $0x18,%esp
}
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	ff 75 08             	pushl  0x8(%ebp)
  8027fc:	6a 10                	push   $0x10
  8027fe:	e8 68 fe ff ff       	call   80266b <syscall>
  802803:	83 c4 18             	add    $0x18,%esp
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 11                	push   $0x11
  802817:	e8 4f fe ff ff       	call   80266b <syscall>
  80281c:	83 c4 18             	add    $0x18,%esp
}
  80281f:	90                   	nop
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <sys_cputc>:

void
sys_cputc(const char c)
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 04             	sub    $0x4,%esp
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80282e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	50                   	push   %eax
  80283b:	6a 01                	push   $0x1
  80283d:	e8 29 fe ff ff       	call   80266b <syscall>
  802842:	83 c4 18             	add    $0x18,%esp
}
  802845:	90                   	nop
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 14                	push   $0x14
  802857:	e8 0f fe ff ff       	call   80266b <syscall>
  80285c:	83 c4 18             	add    $0x18,%esp
}
  80285f:	90                   	nop
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	8b 45 10             	mov    0x10(%ebp),%eax
  80286b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80286e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802871:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	6a 00                	push   $0x0
  80287a:	51                   	push   %ecx
  80287b:	52                   	push   %edx
  80287c:	ff 75 0c             	pushl  0xc(%ebp)
  80287f:	50                   	push   %eax
  802880:	6a 15                	push   $0x15
  802882:	e8 e4 fd ff ff       	call   80266b <syscall>
  802887:	83 c4 18             	add    $0x18,%esp
}
  80288a:	c9                   	leave  
  80288b:	c3                   	ret    

0080288c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80288f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	52                   	push   %edx
  80289c:	50                   	push   %eax
  80289d:	6a 16                	push   $0x16
  80289f:	e8 c7 fd ff ff       	call   80266b <syscall>
  8028a4:	83 c4 18             	add    $0x18,%esp
}
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8028ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	51                   	push   %ecx
  8028ba:	52                   	push   %edx
  8028bb:	50                   	push   %eax
  8028bc:	6a 17                	push   $0x17
  8028be:	e8 a8 fd ff ff       	call   80266b <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
}
  8028c6:	c9                   	leave  
  8028c7:	c3                   	ret    

008028c8 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	52                   	push   %edx
  8028d8:	50                   	push   %eax
  8028d9:	6a 18                	push   $0x18
  8028db:	e8 8b fd ff ff       	call   80266b <syscall>
  8028e0:	83 c4 18             	add    $0x18,%esp
}
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	6a 00                	push   $0x0
  8028ed:	ff 75 14             	pushl  0x14(%ebp)
  8028f0:	ff 75 10             	pushl  0x10(%ebp)
  8028f3:	ff 75 0c             	pushl  0xc(%ebp)
  8028f6:	50                   	push   %eax
  8028f7:	6a 19                	push   $0x19
  8028f9:	e8 6d fd ff ff       	call   80266b <syscall>
  8028fe:	83 c4 18             	add    $0x18,%esp
}
  802901:	c9                   	leave  
  802902:	c3                   	ret    

00802903 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	50                   	push   %eax
  802912:	6a 1a                	push   $0x1a
  802914:	e8 52 fd ff ff       	call   80266b <syscall>
  802919:	83 c4 18             	add    $0x18,%esp
}
  80291c:	90                   	nop
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    

0080291f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	50                   	push   %eax
  80292e:	6a 1b                	push   $0x1b
  802930:	e8 36 fd ff ff       	call   80266b <syscall>
  802935:	83 c4 18             	add    $0x18,%esp
}
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 00                	push   $0x0
  802947:	6a 05                	push   $0x5
  802949:	e8 1d fd ff ff       	call   80266b <syscall>
  80294e:	83 c4 18             	add    $0x18,%esp
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 06                	push   $0x6
  802962:	e8 04 fd ff ff       	call   80266b <syscall>
  802967:	83 c4 18             	add    $0x18,%esp
}
  80296a:	c9                   	leave  
  80296b:	c3                   	ret    

0080296c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 00                	push   $0x0
  802979:	6a 07                	push   $0x7
  80297b:	e8 eb fc ff ff       	call   80266b <syscall>
  802980:	83 c4 18             	add    $0x18,%esp
}
  802983:	c9                   	leave  
  802984:	c3                   	ret    

00802985 <sys_exit_env>:


void sys_exit_env(void)
{
  802985:	55                   	push   %ebp
  802986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802988:	6a 00                	push   $0x0
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 1c                	push   $0x1c
  802994:	e8 d2 fc ff ff       	call   80266b <syscall>
  802999:	83 c4 18             	add    $0x18,%esp
}
  80299c:	90                   	nop
  80299d:	c9                   	leave  
  80299e:	c3                   	ret    

0080299f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8029a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029a8:	8d 50 04             	lea    0x4(%eax),%edx
  8029ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 00                	push   $0x0
  8029b4:	52                   	push   %edx
  8029b5:	50                   	push   %eax
  8029b6:	6a 1d                	push   $0x1d
  8029b8:	e8 ae fc ff ff       	call   80266b <syscall>
  8029bd:	83 c4 18             	add    $0x18,%esp
	return result;
  8029c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029c9:	89 01                	mov    %eax,(%ecx)
  8029cb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	c9                   	leave  
  8029d2:	c2 04 00             	ret    $0x4

008029d5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	ff 75 10             	pushl  0x10(%ebp)
  8029df:	ff 75 0c             	pushl  0xc(%ebp)
  8029e2:	ff 75 08             	pushl  0x8(%ebp)
  8029e5:	6a 13                	push   $0x13
  8029e7:	e8 7f fc ff ff       	call   80266b <syscall>
  8029ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ef:	90                   	nop
}
  8029f0:	c9                   	leave  
  8029f1:	c3                   	ret    

008029f2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 1e                	push   $0x1e
  802a01:	e8 65 fc ff ff       	call   80266b <syscall>
  802a06:	83 c4 18             	add    $0x18,%esp
}
  802a09:	c9                   	leave  
  802a0a:	c3                   	ret    

00802a0b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a17:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	50                   	push   %eax
  802a24:	6a 1f                	push   $0x1f
  802a26:	e8 40 fc ff ff       	call   80266b <syscall>
  802a2b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a2e:	90                   	nop
}
  802a2f:	c9                   	leave  
  802a30:	c3                   	ret    

00802a31 <rsttst>:
void rsttst()
{
  802a31:	55                   	push   %ebp
  802a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 21                	push   $0x21
  802a40:	e8 26 fc ff ff       	call   80266b <syscall>
  802a45:	83 c4 18             	add    $0x18,%esp
	return ;
  802a48:	90                   	nop
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	8b 45 14             	mov    0x14(%ebp),%eax
  802a54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a57:	8b 55 18             	mov    0x18(%ebp),%edx
  802a5a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a5e:	52                   	push   %edx
  802a5f:	50                   	push   %eax
  802a60:	ff 75 10             	pushl  0x10(%ebp)
  802a63:	ff 75 0c             	pushl  0xc(%ebp)
  802a66:	ff 75 08             	pushl  0x8(%ebp)
  802a69:	6a 20                	push   $0x20
  802a6b:	e8 fb fb ff ff       	call   80266b <syscall>
  802a70:	83 c4 18             	add    $0x18,%esp
	return ;
  802a73:	90                   	nop
}
  802a74:	c9                   	leave  
  802a75:	c3                   	ret    

00802a76 <chktst>:
void chktst(uint32 n)
{
  802a76:	55                   	push   %ebp
  802a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	ff 75 08             	pushl  0x8(%ebp)
  802a84:	6a 22                	push   $0x22
  802a86:	e8 e0 fb ff ff       	call   80266b <syscall>
  802a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a8e:	90                   	nop
}
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <inctst>:

void inctst()
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 23                	push   $0x23
  802aa0:	e8 c6 fb ff ff       	call   80266b <syscall>
  802aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  802aa8:	90                   	nop
}
  802aa9:	c9                   	leave  
  802aaa:	c3                   	ret    

00802aab <gettst>:
uint32 gettst()
{
  802aab:	55                   	push   %ebp
  802aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 24                	push   $0x24
  802aba:	e8 ac fb ff ff       	call   80266b <syscall>
  802abf:	83 c4 18             	add    $0x18,%esp
}
  802ac2:	c9                   	leave  
  802ac3:	c3                   	ret    

00802ac4 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 25                	push   $0x25
  802ad3:	e8 93 fb ff ff       	call   80266b <syscall>
  802ad8:	83 c4 18             	add    $0x18,%esp
  802adb:	a3 80 12 82 00       	mov    %eax,0x821280
	return uheapPlaceStrategy ;
  802ae0:	a1 80 12 82 00       	mov    0x821280,%eax
}
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    

00802ae7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	a3 80 12 82 00       	mov    %eax,0x821280
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	ff 75 08             	pushl  0x8(%ebp)
  802afd:	6a 26                	push   $0x26
  802aff:	e8 67 fb ff ff       	call   80266b <syscall>
  802b04:	83 c4 18             	add    $0x18,%esp
	return ;
  802b07:	90                   	nop
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	6a 00                	push   $0x0
  802b1c:	53                   	push   %ebx
  802b1d:	51                   	push   %ecx
  802b1e:	52                   	push   %edx
  802b1f:	50                   	push   %eax
  802b20:	6a 27                	push   $0x27
  802b22:	e8 44 fb ff ff       	call   80266b <syscall>
  802b27:	83 c4 18             	add    $0x18,%esp
}
  802b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b2d:	c9                   	leave  
  802b2e:	c3                   	ret    

00802b2f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	52                   	push   %edx
  802b3f:	50                   	push   %eax
  802b40:	6a 28                	push   $0x28
  802b42:	e8 24 fb ff ff       	call   80266b <syscall>
  802b47:	83 c4 18             	add    $0x18,%esp
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	6a 00                	push   $0x0
  802b5a:	51                   	push   %ecx
  802b5b:	ff 75 10             	pushl  0x10(%ebp)
  802b5e:	52                   	push   %edx
  802b5f:	50                   	push   %eax
  802b60:	6a 29                	push   $0x29
  802b62:	e8 04 fb ff ff       	call   80266b <syscall>
  802b67:	83 c4 18             	add    $0x18,%esp
}
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	ff 75 10             	pushl  0x10(%ebp)
  802b76:	ff 75 0c             	pushl  0xc(%ebp)
  802b79:	ff 75 08             	pushl  0x8(%ebp)
  802b7c:	6a 12                	push   $0x12
  802b7e:	e8 e8 fa ff ff       	call   80266b <syscall>
  802b83:	83 c4 18             	add    $0x18,%esp
	return ;
  802b86:	90                   	nop
}
  802b87:	c9                   	leave  
  802b88:	c3                   	ret    

00802b89 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b89:	55                   	push   %ebp
  802b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	52                   	push   %edx
  802b99:	50                   	push   %eax
  802b9a:	6a 2a                	push   $0x2a
  802b9c:	e8 ca fa ff ff       	call   80266b <syscall>
  802ba1:	83 c4 18             	add    $0x18,%esp
	return;
  802ba4:	90                   	nop
}
  802ba5:	c9                   	leave  
  802ba6:	c3                   	ret    

00802ba7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802ba7:	55                   	push   %ebp
  802ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 2b                	push   $0x2b
  802bb6:	e8 b0 fa ff ff       	call   80266b <syscall>
  802bbb:	83 c4 18             	add    $0x18,%esp
}
  802bbe:	c9                   	leave  
  802bbf:	c3                   	ret    

00802bc0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802bc0:	55                   	push   %ebp
  802bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	ff 75 0c             	pushl  0xc(%ebp)
  802bcc:	ff 75 08             	pushl  0x8(%ebp)
  802bcf:	6a 2d                	push   $0x2d
  802bd1:	e8 95 fa ff ff       	call   80266b <syscall>
  802bd6:	83 c4 18             	add    $0x18,%esp
	return;
  802bd9:	90                   	nop
}
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    

00802bdc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	ff 75 0c             	pushl  0xc(%ebp)
  802be8:	ff 75 08             	pushl  0x8(%ebp)
  802beb:	6a 2c                	push   $0x2c
  802bed:	e8 79 fa ff ff       	call   80266b <syscall>
  802bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf5:	90                   	nop
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	52                   	push   %edx
  802c08:	50                   	push   %eax
  802c09:	6a 2e                	push   $0x2e
  802c0b:	e8 5b fa ff ff       	call   80266b <syscall>
  802c10:	83 c4 18             	add    $0x18,%esp
	return ;
  802c13:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

00802c16 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802c16:	55                   	push   %ebp
  802c17:	89 e5                	mov    %esp,%ebp
  802c19:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802c1c:	81 7d 08 80 92 80 00 	cmpl   $0x809280,0x8(%ebp)
  802c23:	72 09                	jb     802c2e <to_page_va+0x18>
  802c25:	81 7d 08 80 12 82 00 	cmpl   $0x821280,0x8(%ebp)
  802c2c:	72 14                	jb     802c42 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	68 00 4a 80 00       	push   $0x804a00
  802c36:	6a 15                	push   $0x15
  802c38:	68 2b 4a 80 00       	push   $0x804a2b
  802c3d:	e8 4e db ff ff       	call   800790 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	ba 80 92 80 00       	mov    $0x809280,%edx
  802c4a:	29 d0                	sub    %edx,%eax
  802c4c:	c1 f8 02             	sar    $0x2,%eax
  802c4f:	89 c2                	mov    %eax,%edx
  802c51:	89 d0                	mov    %edx,%eax
  802c53:	c1 e0 02             	shl    $0x2,%eax
  802c56:	01 d0                	add    %edx,%eax
  802c58:	c1 e0 02             	shl    $0x2,%eax
  802c5b:	01 d0                	add    %edx,%eax
  802c5d:	c1 e0 02             	shl    $0x2,%eax
  802c60:	01 d0                	add    %edx,%eax
  802c62:	89 c1                	mov    %eax,%ecx
  802c64:	c1 e1 08             	shl    $0x8,%ecx
  802c67:	01 c8                	add    %ecx,%eax
  802c69:	89 c1                	mov    %eax,%ecx
  802c6b:	c1 e1 10             	shl    $0x10,%ecx
  802c6e:	01 c8                	add    %ecx,%eax
  802c70:	01 c0                	add    %eax,%eax
  802c72:	01 d0                	add    %edx,%eax
  802c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	c1 e0 0c             	shl    $0xc,%eax
  802c7d:	89 c2                	mov    %eax,%edx
  802c7f:	a1 84 12 82 00       	mov    0x821284,%eax
  802c84:	01 d0                	add    %edx,%eax
}
  802c86:	c9                   	leave  
  802c87:	c3                   	ret    

00802c88 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802c88:	55                   	push   %ebp
  802c89:	89 e5                	mov    %esp,%ebp
  802c8b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802c8e:	a1 84 12 82 00       	mov    0x821284,%eax
  802c93:	8b 55 08             	mov    0x8(%ebp),%edx
  802c96:	29 c2                	sub    %eax,%edx
  802c98:	89 d0                	mov    %edx,%eax
  802c9a:	c1 e8 0c             	shr    $0xc,%eax
  802c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca4:	78 09                	js     802caf <to_page_info+0x27>
  802ca6:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802cad:	7e 14                	jle    802cc3 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	68 44 4a 80 00       	push   $0x804a44
  802cb7:	6a 22                	push   $0x22
  802cb9:	68 2b 4a 80 00       	push   $0x804a2b
  802cbe:	e8 cd da ff ff       	call   800790 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc6:	89 d0                	mov    %edx,%eax
  802cc8:	01 c0                	add    %eax,%eax
  802cca:	01 d0                	add    %edx,%eax
  802ccc:	c1 e0 02             	shl    $0x2,%eax
  802ccf:	05 80 92 80 00       	add    $0x809280,%eax
}
  802cd4:	c9                   	leave  
  802cd5:	c3                   	ret    

00802cd6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802cd6:	55                   	push   %ebp
  802cd7:	89 e5                	mov    %esp,%ebp
  802cd9:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	05 00 00 00 02       	add    $0x2000000,%eax
  802ce4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ce7:	73 16                	jae    802cff <initialize_dynamic_allocator+0x29>
  802ce9:	68 68 4a 80 00       	push   $0x804a68
  802cee:	68 8e 4a 80 00       	push   $0x804a8e
  802cf3:	6a 34                	push   $0x34
  802cf5:	68 2b 4a 80 00       	push   $0x804a2b
  802cfa:	e8 91 da ff ff       	call   800790 <_panic>
		is_initialized = 1;
  802cff:	c7 05 54 50 80 00 01 	movl   $0x1,0x805054
  802d06:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	a3 84 12 82 00       	mov    %eax,0x821284
	dynAllocEnd = daEnd;
  802d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d14:	a3 60 50 80 00       	mov    %eax,0x805060

	LIST_INIT(&freePagesList);
  802d19:	c7 05 68 50 80 00 00 	movl   $0x0,0x805068
  802d20:	00 00 00 
  802d23:	c7 05 6c 50 80 00 00 	movl   $0x0,0x80506c
  802d2a:	00 00 00 
  802d2d:	c7 05 74 50 80 00 00 	movl   $0x0,0x805074
  802d34:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802d37:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d45:	eb 36                	jmp    802d7d <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	c1 e0 04             	shl    $0x4,%eax
  802d4d:	05 a0 12 82 00       	add    $0x8212a0,%eax
  802d52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	c1 e0 04             	shl    $0x4,%eax
  802d5e:	05 a4 12 82 00       	add    $0x8212a4,%eax
  802d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	c1 e0 04             	shl    $0x4,%eax
  802d6f:	05 ac 12 82 00       	add    $0x8212ac,%eax
  802d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802d7a:	ff 45 f4             	incl   -0xc(%ebp)
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d83:	72 c2                	jb     802d47 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802d85:	8b 15 60 50 80 00    	mov    0x805060,%edx
  802d8b:	a1 84 12 82 00       	mov    0x821284,%eax
  802d90:	29 c2                	sub    %eax,%edx
  802d92:	89 d0                	mov    %edx,%eax
  802d94:	c1 e8 0c             	shr    $0xc,%eax
  802d97:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802d9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802da1:	e9 c8 00 00 00       	jmp    802e6e <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802da6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da9:	89 d0                	mov    %edx,%eax
  802dab:	01 c0                	add    %eax,%eax
  802dad:	01 d0                	add    %edx,%eax
  802daf:	c1 e0 02             	shl    $0x2,%eax
  802db2:	05 88 92 80 00       	add    $0x809288,%eax
  802db7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802dbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbf:	89 d0                	mov    %edx,%eax
  802dc1:	01 c0                	add    %eax,%eax
  802dc3:	01 d0                	add    %edx,%eax
  802dc5:	c1 e0 02             	shl    $0x2,%eax
  802dc8:	05 8a 92 80 00       	add    $0x80928a,%eax
  802dcd:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802dd2:	8b 15 6c 50 80 00    	mov    0x80506c,%edx
  802dd8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ddb:	89 c8                	mov    %ecx,%eax
  802ddd:	01 c0                	add    %eax,%eax
  802ddf:	01 c8                	add    %ecx,%eax
  802de1:	c1 e0 02             	shl    $0x2,%eax
  802de4:	05 84 92 80 00       	add    $0x809284,%eax
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dee:	89 d0                	mov    %edx,%eax
  802df0:	01 c0                	add    %eax,%eax
  802df2:	01 d0                	add    %edx,%eax
  802df4:	c1 e0 02             	shl    $0x2,%eax
  802df7:	05 84 92 80 00       	add    $0x809284,%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 1b                	je     802e1d <initialize_dynamic_allocator+0x147>
  802e02:	8b 15 6c 50 80 00    	mov    0x80506c,%edx
  802e08:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e0b:	89 c8                	mov    %ecx,%eax
  802e0d:	01 c0                	add    %eax,%eax
  802e0f:	01 c8                	add    %ecx,%eax
  802e11:	c1 e0 02             	shl    $0x2,%eax
  802e14:	05 80 92 80 00       	add    $0x809280,%eax
  802e19:	89 02                	mov    %eax,(%edx)
  802e1b:	eb 16                	jmp    802e33 <initialize_dynamic_allocator+0x15d>
  802e1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e20:	89 d0                	mov    %edx,%eax
  802e22:	01 c0                	add    %eax,%eax
  802e24:	01 d0                	add    %edx,%eax
  802e26:	c1 e0 02             	shl    $0x2,%eax
  802e29:	05 80 92 80 00       	add    $0x809280,%eax
  802e2e:	a3 68 50 80 00       	mov    %eax,0x805068
  802e33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e36:	89 d0                	mov    %edx,%eax
  802e38:	01 c0                	add    %eax,%eax
  802e3a:	01 d0                	add    %edx,%eax
  802e3c:	c1 e0 02             	shl    $0x2,%eax
  802e3f:	05 80 92 80 00       	add    $0x809280,%eax
  802e44:	a3 6c 50 80 00       	mov    %eax,0x80506c
  802e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4c:	89 d0                	mov    %edx,%eax
  802e4e:	01 c0                	add    %eax,%eax
  802e50:	01 d0                	add    %edx,%eax
  802e52:	c1 e0 02             	shl    $0x2,%eax
  802e55:	05 80 92 80 00       	add    $0x809280,%eax
  802e5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e60:	a1 74 50 80 00       	mov    0x805074,%eax
  802e65:	40                   	inc    %eax
  802e66:	a3 74 50 80 00       	mov    %eax,0x805074
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802e6b:	ff 45 f0             	incl   -0x10(%ebp)
  802e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e71:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e74:	0f 82 2c ff ff ff    	jb     802da6 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e80:	eb 2f                	jmp    802eb1 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802e82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e85:	89 d0                	mov    %edx,%eax
  802e87:	01 c0                	add    %eax,%eax
  802e89:	01 d0                	add    %edx,%eax
  802e8b:	c1 e0 02             	shl    $0x2,%eax
  802e8e:	05 88 92 80 00       	add    $0x809288,%eax
  802e93:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802e98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e9b:	89 d0                	mov    %edx,%eax
  802e9d:	01 c0                	add    %eax,%eax
  802e9f:	01 d0                	add    %edx,%eax
  802ea1:	c1 e0 02             	shl    $0x2,%eax
  802ea4:	05 8a 92 80 00       	add    $0x80928a,%eax
  802ea9:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802eae:	ff 45 ec             	incl   -0x14(%ebp)
  802eb1:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802eb8:	76 c8                	jbe    802e82 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802eba:	90                   	nop
  802ebb:	c9                   	leave  
  802ebc:	c3                   	ret    

00802ebd <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802ebd:	55                   	push   %ebp
  802ebe:	89 e5                	mov    %esp,%ebp
  802ec0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec6:	a1 84 12 82 00       	mov    0x821284,%eax
  802ecb:	29 c2                	sub    %eax,%edx
  802ecd:	89 d0                	mov    %edx,%eax
  802ecf:	c1 e8 0c             	shr    $0xc,%eax
  802ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802ed5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ed8:	89 d0                	mov    %edx,%eax
  802eda:	01 c0                	add    %eax,%eax
  802edc:	01 d0                	add    %edx,%eax
  802ede:	c1 e0 02             	shl    $0x2,%eax
  802ee1:	05 88 92 80 00       	add    $0x809288,%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802eeb:	c9                   	leave  
  802eec:	c3                   	ret    

00802eed <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802eed:	55                   	push   %ebp
  802eee:	89 e5                	mov    %esp,%ebp
  802ef0:	83 ec 14             	sub    $0x14,%esp
  802ef3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802ef6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802efa:	77 07                	ja     802f03 <nearest_pow2_ceil.1513+0x16>
  802efc:	b8 01 00 00 00       	mov    $0x1,%eax
  802f01:	eb 20                	jmp    802f23 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802f03:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802f0a:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802f0d:	eb 08                	jmp    802f17 <nearest_pow2_ceil.1513+0x2a>
  802f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f12:	01 c0                	add    %eax,%eax
  802f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802f17:	d1 6d 08             	shrl   0x8(%ebp)
  802f1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1e:	75 ef                	jne    802f0f <nearest_pow2_ceil.1513+0x22>
        return power;
  802f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802f23:	c9                   	leave  
  802f24:	c3                   	ret    

00802f25 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802f25:	55                   	push   %ebp
  802f26:	89 e5                	mov    %esp,%ebp
  802f28:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802f2b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802f32:	76 16                	jbe    802f4a <alloc_block+0x25>
  802f34:	68 a4 4a 80 00       	push   $0x804aa4
  802f39:	68 8e 4a 80 00       	push   $0x804a8e
  802f3e:	6a 72                	push   $0x72
  802f40:	68 2b 4a 80 00       	push   $0x804a2b
  802f45:	e8 46 d8 ff ff       	call   800790 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802f4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4e:	75 0a                	jne    802f5a <alloc_block+0x35>
  802f50:	b8 00 00 00 00       	mov    $0x0,%eax
  802f55:	e9 bd 04 00 00       	jmp    803417 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802f5a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f67:	73 06                	jae    802f6f <alloc_block+0x4a>
        size = min_block_size;
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802f6f:	83 ec 0c             	sub    $0xc,%esp
  802f72:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802f75:	ff 75 08             	pushl  0x8(%ebp)
  802f78:	89 c1                	mov    %eax,%ecx
  802f7a:	e8 6e ff ff ff       	call   802eed <nearest_pow2_ceil.1513>
  802f7f:	83 c4 10             	add    $0x10,%esp
  802f82:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802f85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f88:	83 ec 0c             	sub    $0xc,%esp
  802f8b:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802f8e:	52                   	push   %edx
  802f8f:	89 c1                	mov    %eax,%ecx
  802f91:	e8 83 04 00 00       	call   803419 <log2_ceil.1520>
  802f96:	83 c4 10             	add    $0x10,%esp
  802f99:	83 e8 03             	sub    $0x3,%eax
  802f9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa2:	c1 e0 04             	shl    $0x4,%eax
  802fa5:	05 a0 12 82 00       	add    $0x8212a0,%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	0f 84 d8 00 00 00    	je     80308c <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb7:	c1 e0 04             	shl    $0x4,%eax
  802fba:	05 a0 12 82 00       	add    $0x8212a0,%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802fc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fc8:	75 17                	jne    802fe1 <alloc_block+0xbc>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 c5 4a 80 00       	push   $0x804ac5
  802fd2:	68 98 00 00 00       	push   $0x98
  802fd7:	68 2b 4a 80 00       	push   $0x804a2b
  802fdc:	e8 af d7 ff ff       	call   800790 <_panic>
  802fe1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 10                	je     802ffa <alloc_block+0xd5>
  802fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff2:	8b 52 04             	mov    0x4(%edx),%edx
  802ff5:	89 50 04             	mov    %edx,0x4(%eax)
  802ff8:	eb 14                	jmp    80300e <alloc_block+0xe9>
  802ffa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803003:	c1 e2 04             	shl    $0x4,%edx
  803006:	81 c2 a4 12 82 00    	add    $0x8212a4,%edx
  80300c:	89 02                	mov    %eax,(%edx)
  80300e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	74 0f                	je     803027 <alloc_block+0x102>
  803018:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301b:	8b 40 04             	mov    0x4(%eax),%eax
  80301e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803021:	8b 12                	mov    (%edx),%edx
  803023:	89 10                	mov    %edx,(%eax)
  803025:	eb 13                	jmp    80303a <alloc_block+0x115>
  803027:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80302f:	c1 e2 04             	shl    $0x4,%edx
  803032:	81 c2 a0 12 82 00    	add    $0x8212a0,%edx
  803038:	89 02                	mov    %eax,(%edx)
  80303a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803043:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803046:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803050:	c1 e0 04             	shl    $0x4,%eax
  803053:	05 ac 12 82 00       	add    $0x8212ac,%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80305d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803060:	c1 e0 04             	shl    $0x4,%eax
  803063:	05 ac 12 82 00       	add    $0x8212ac,%eax
  803068:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80306a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306d:	83 ec 0c             	sub    $0xc,%esp
  803070:	50                   	push   %eax
  803071:	e8 12 fc ff ff       	call   802c88 <to_page_info>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	89 c2                	mov    %eax,%edx
  80307b:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80307f:	48                   	dec    %eax
  803080:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803084:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803087:	e9 8b 03 00 00       	jmp    803417 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  80308c:	a1 68 50 80 00       	mov    0x805068,%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	0f 84 64 02 00 00    	je     8032fd <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803099:	a1 68 50 80 00       	mov    0x805068,%eax
  80309e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  8030a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a5:	75 17                	jne    8030be <alloc_block+0x199>
  8030a7:	83 ec 04             	sub    $0x4,%esp
  8030aa:	68 c5 4a 80 00       	push   $0x804ac5
  8030af:	68 a0 00 00 00       	push   $0xa0
  8030b4:	68 2b 4a 80 00       	push   $0x804a2b
  8030b9:	e8 d2 d6 ff ff       	call   800790 <_panic>
  8030be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 10                	je     8030d7 <alloc_block+0x1b2>
  8030c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030cf:	8b 52 04             	mov    0x4(%edx),%edx
  8030d2:	89 50 04             	mov    %edx,0x4(%eax)
  8030d5:	eb 0b                	jmp    8030e2 <alloc_block+0x1bd>
  8030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030da:	8b 40 04             	mov    0x4(%eax),%eax
  8030dd:	a3 6c 50 80 00       	mov    %eax,0x80506c
  8030e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e5:	8b 40 04             	mov    0x4(%eax),%eax
  8030e8:	85 c0                	test   %eax,%eax
  8030ea:	74 0f                	je     8030fb <alloc_block+0x1d6>
  8030ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ef:	8b 40 04             	mov    0x4(%eax),%eax
  8030f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030f5:	8b 12                	mov    (%edx),%edx
  8030f7:	89 10                	mov    %edx,(%eax)
  8030f9:	eb 0a                	jmp    803105 <alloc_block+0x1e0>
  8030fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	a3 68 50 80 00       	mov    %eax,0x805068
  803105:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803108:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803111:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803118:	a1 74 50 80 00       	mov    0x805074,%eax
  80311d:	48                   	dec    %eax
  80311e:	a3 74 50 80 00       	mov    %eax,0x805074

        page_info_e->block_size = pow;
  803123:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803126:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803129:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  80312d:	b8 00 10 00 00       	mov    $0x1000,%eax
  803132:	99                   	cltd   
  803133:	f7 7d e8             	idivl  -0x18(%ebp)
  803136:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803139:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  80313d:	83 ec 0c             	sub    $0xc,%esp
  803140:	ff 75 dc             	pushl  -0x24(%ebp)
  803143:	e8 ce fa ff ff       	call   802c16 <to_page_va>
  803148:	83 c4 10             	add    $0x10,%esp
  80314b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  80314e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803151:	83 ec 0c             	sub    $0xc,%esp
  803154:	50                   	push   %eax
  803155:	e8 c0 ee ff ff       	call   80201a <get_page>
  80315a:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80315d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803164:	e9 aa 00 00 00       	jmp    803213 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803170:	89 c2                	mov    %eax,%edx
  803172:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803175:	01 d0                	add    %edx,%eax
  803177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  80317a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80317e:	75 17                	jne    803197 <alloc_block+0x272>
  803180:	83 ec 04             	sub    $0x4,%esp
  803183:	68 e4 4a 80 00       	push   $0x804ae4
  803188:	68 aa 00 00 00       	push   $0xaa
  80318d:	68 2b 4a 80 00       	push   $0x804a2b
  803192:	e8 f9 d5 ff ff       	call   800790 <_panic>
  803197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319a:	c1 e0 04             	shl    $0x4,%eax
  80319d:	05 a4 12 82 00       	add    $0x8212a4,%eax
  8031a2:	8b 10                	mov    (%eax),%edx
  8031a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031a7:	89 50 04             	mov    %edx,0x4(%eax)
  8031aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	74 14                	je     8031c8 <alloc_block+0x2a3>
  8031b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b7:	c1 e0 04             	shl    $0x4,%eax
  8031ba:	05 a4 12 82 00       	add    $0x8212a4,%eax
  8031bf:	8b 00                	mov    (%eax),%eax
  8031c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031c4:	89 10                	mov    %edx,(%eax)
  8031c6:	eb 11                	jmp    8031d9 <alloc_block+0x2b4>
  8031c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cb:	c1 e0 04             	shl    $0x4,%eax
  8031ce:	8d 90 a0 12 82 00    	lea    0x8212a0(%eax),%edx
  8031d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031d7:	89 02                	mov    %eax,(%edx)
  8031d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dc:	c1 e0 04             	shl    $0x4,%eax
  8031df:	8d 90 a4 12 82 00    	lea    0x8212a4(%eax),%edx
  8031e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e8:	89 02                	mov    %eax,(%edx)
  8031ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f6:	c1 e0 04             	shl    $0x4,%eax
  8031f9:	05 ac 12 82 00       	add    $0x8212ac,%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	8d 50 01             	lea    0x1(%eax),%edx
  803203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803206:	c1 e0 04             	shl    $0x4,%eax
  803209:	05 ac 12 82 00       	add    $0x8212ac,%eax
  80320e:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803210:	ff 45 f4             	incl   -0xc(%ebp)
  803213:	b8 00 10 00 00       	mov    $0x1000,%eax
  803218:	99                   	cltd   
  803219:	f7 7d e8             	idivl  -0x18(%ebp)
  80321c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80321f:	0f 8f 44 ff ff ff    	jg     803169 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803228:	c1 e0 04             	shl    $0x4,%eax
  80322b:	05 a0 12 82 00       	add    $0x8212a0,%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803235:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803239:	75 17                	jne    803252 <alloc_block+0x32d>
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	68 c5 4a 80 00       	push   $0x804ac5
  803243:	68 ae 00 00 00       	push   $0xae
  803248:	68 2b 4a 80 00       	push   $0x804a2b
  80324d:	e8 3e d5 ff ff       	call   800790 <_panic>
  803252:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 10                	je     80326b <alloc_block+0x346>
  80325b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803263:	8b 52 04             	mov    0x4(%edx),%edx
  803266:	89 50 04             	mov    %edx,0x4(%eax)
  803269:	eb 14                	jmp    80327f <alloc_block+0x35a>
  80326b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80326e:	8b 40 04             	mov    0x4(%eax),%eax
  803271:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803274:	c1 e2 04             	shl    $0x4,%edx
  803277:	81 c2 a4 12 82 00    	add    $0x8212a4,%edx
  80327d:	89 02                	mov    %eax,(%edx)
  80327f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0f                	je     803298 <alloc_block+0x373>
  803289:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803292:	8b 12                	mov    (%edx),%edx
  803294:	89 10                	mov    %edx,(%eax)
  803296:	eb 13                	jmp    8032ab <alloc_block+0x386>
  803298:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032a0:	c1 e2 04             	shl    $0x4,%edx
  8032a3:	81 c2 a0 12 82 00    	add    $0x8212a0,%edx
  8032a9:	89 02                	mov    %eax,(%edx)
  8032ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c1:	c1 e0 04             	shl    $0x4,%eax
  8032c4:	05 ac 12 82 00       	add    $0x8212ac,%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d1:	c1 e0 04             	shl    $0x4,%eax
  8032d4:	05 ac 12 82 00       	add    $0x8212ac,%eax
  8032d9:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8032db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032de:	83 ec 0c             	sub    $0xc,%esp
  8032e1:	50                   	push   %eax
  8032e2:	e8 a1 f9 ff ff       	call   802c88 <to_page_info>
  8032e7:	83 c4 10             	add    $0x10,%esp
  8032ea:	89 c2                	mov    %eax,%edx
  8032ec:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8032f0:	48                   	dec    %eax
  8032f1:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8032f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032f8:	e9 1a 01 00 00       	jmp    803417 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8032fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803300:	40                   	inc    %eax
  803301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803304:	e9 ed 00 00 00       	jmp    8033f6 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330c:	c1 e0 04             	shl    $0x4,%eax
  80330f:	05 a0 12 82 00       	add    $0x8212a0,%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	0f 84 d5 00 00 00    	je     8033f3 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  80331e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803321:	c1 e0 04             	shl    $0x4,%eax
  803324:	05 a0 12 82 00       	add    $0x8212a0,%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  80332e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803332:	75 17                	jne    80334b <alloc_block+0x426>
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 c5 4a 80 00       	push   $0x804ac5
  80333c:	68 b8 00 00 00       	push   $0xb8
  803341:	68 2b 4a 80 00       	push   $0x804a2b
  803346:	e8 45 d4 ff ff       	call   800790 <_panic>
  80334b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 10                	je     803364 <alloc_block+0x43f>
  803354:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80335c:	8b 52 04             	mov    0x4(%edx),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	eb 14                	jmp    803378 <alloc_block+0x453>
  803364:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80336d:	c1 e2 04             	shl    $0x4,%edx
  803370:	81 c2 a4 12 82 00    	add    $0x8212a4,%edx
  803376:	89 02                	mov    %eax,(%edx)
  803378:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80337b:	8b 40 04             	mov    0x4(%eax),%eax
  80337e:	85 c0                	test   %eax,%eax
  803380:	74 0f                	je     803391 <alloc_block+0x46c>
  803382:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803385:	8b 40 04             	mov    0x4(%eax),%eax
  803388:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80338b:	8b 12                	mov    (%edx),%edx
  80338d:	89 10                	mov    %edx,(%eax)
  80338f:	eb 13                	jmp    8033a4 <alloc_block+0x47f>
  803391:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803399:	c1 e2 04             	shl    $0x4,%edx
  80339c:	81 c2 a0 12 82 00    	add    $0x8212a0,%edx
  8033a2:	89 02                	mov    %eax,(%edx)
  8033a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ba:	c1 e0 04             	shl    $0x4,%eax
  8033bd:	05 ac 12 82 00       	add    $0x8212ac,%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	c1 e0 04             	shl    $0x4,%eax
  8033cd:	05 ac 12 82 00       	add    $0x8212ac,%eax
  8033d2:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8033d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033d7:	83 ec 0c             	sub    $0xc,%esp
  8033da:	50                   	push   %eax
  8033db:	e8 a8 f8 ff ff       	call   802c88 <to_page_info>
  8033e0:	83 c4 10             	add    $0x10,%esp
  8033e3:	89 c2                	mov    %eax,%edx
  8033e5:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8033e9:	48                   	dec    %eax
  8033ea:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8033ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f1:	eb 24                	jmp    803417 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8033f3:	ff 45 f0             	incl   -0x10(%ebp)
  8033f6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8033fa:	0f 8e 09 ff ff ff    	jle    803309 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803400:	83 ec 04             	sub    $0x4,%esp
  803403:	68 07 4b 80 00       	push   $0x804b07
  803408:	68 bf 00 00 00       	push   $0xbf
  80340d:	68 2b 4a 80 00       	push   $0x804a2b
  803412:	e8 79 d3 ff ff       	call   800790 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803417:	c9                   	leave  
  803418:	c3                   	ret    

00803419 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803419:	55                   	push   %ebp
  80341a:	89 e5                	mov    %esp,%ebp
  80341c:	83 ec 14             	sub    $0x14,%esp
  80341f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803426:	75 07                	jne    80342f <log2_ceil.1520+0x16>
  803428:	b8 00 00 00 00       	mov    $0x0,%eax
  80342d:	eb 1b                	jmp    80344a <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80342f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803436:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803439:	eb 06                	jmp    803441 <log2_ceil.1520+0x28>
            x >>= 1;
  80343b:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80343e:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803445:	75 f4                	jne    80343b <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803447:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  80344a:	c9                   	leave  
  80344b:	c3                   	ret    

0080344c <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80344c:	55                   	push   %ebp
  80344d:	89 e5                	mov    %esp,%ebp
  80344f:	83 ec 14             	sub    $0x14,%esp
  803452:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803455:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803459:	75 07                	jne    803462 <log2_ceil.1547+0x16>
  80345b:	b8 00 00 00 00       	mov    $0x0,%eax
  803460:	eb 1b                	jmp    80347d <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803469:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80346c:	eb 06                	jmp    803474 <log2_ceil.1547+0x28>
			x >>= 1;
  80346e:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803471:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803474:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803478:	75 f4                	jne    80346e <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80347a:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80347d:	c9                   	leave  
  80347e:	c3                   	ret    

0080347f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80347f:	55                   	push   %ebp
  803480:	89 e5                	mov    %esp,%ebp
  803482:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803485:	8b 55 08             	mov    0x8(%ebp),%edx
  803488:	a1 84 12 82 00       	mov    0x821284,%eax
  80348d:	39 c2                	cmp    %eax,%edx
  80348f:	72 0c                	jb     80349d <free_block+0x1e>
  803491:	8b 55 08             	mov    0x8(%ebp),%edx
  803494:	a1 60 50 80 00       	mov    0x805060,%eax
  803499:	39 c2                	cmp    %eax,%edx
  80349b:	72 19                	jb     8034b6 <free_block+0x37>
  80349d:	68 0c 4b 80 00       	push   $0x804b0c
  8034a2:	68 8e 4a 80 00       	push   $0x804a8e
  8034a7:	68 d0 00 00 00       	push   $0xd0
  8034ac:	68 2b 4a 80 00       	push   $0x804a2b
  8034b1:	e8 da d2 ff ff       	call   800790 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ba:	0f 84 42 03 00 00    	je     803802 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8034c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c3:	a1 84 12 82 00       	mov    0x821284,%eax
  8034c8:	39 c2                	cmp    %eax,%edx
  8034ca:	72 0c                	jb     8034d8 <free_block+0x59>
  8034cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cf:	a1 60 50 80 00       	mov    0x805060,%eax
  8034d4:	39 c2                	cmp    %eax,%edx
  8034d6:	72 17                	jb     8034ef <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	68 44 4b 80 00       	push   $0x804b44
  8034e0:	68 e6 00 00 00       	push   $0xe6
  8034e5:	68 2b 4a 80 00       	push   $0x804a2b
  8034ea:	e8 a1 d2 ff ff       	call   800790 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8034ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f2:	a1 84 12 82 00       	mov    0x821284,%eax
  8034f7:	29 c2                	sub    %eax,%edx
  8034f9:	89 d0                	mov    %edx,%eax
  8034fb:	83 e0 07             	and    $0x7,%eax
  8034fe:	85 c0                	test   %eax,%eax
  803500:	74 17                	je     803519 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803502:	83 ec 04             	sub    $0x4,%esp
  803505:	68 78 4b 80 00       	push   $0x804b78
  80350a:	68 ea 00 00 00       	push   $0xea
  80350f:	68 2b 4a 80 00       	push   $0x804a2b
  803514:	e8 77 d2 ff ff       	call   800790 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	83 ec 0c             	sub    $0xc,%esp
  80351f:	50                   	push   %eax
  803520:	e8 63 f7 ff ff       	call   802c88 <to_page_info>
  803525:	83 c4 10             	add    $0x10,%esp
  803528:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80352b:	83 ec 0c             	sub    $0xc,%esp
  80352e:	ff 75 08             	pushl  0x8(%ebp)
  803531:	e8 87 f9 ff ff       	call   802ebd <get_block_size>
  803536:	83 c4 10             	add    $0x10,%esp
  803539:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80353c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803540:	75 17                	jne    803559 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803542:	83 ec 04             	sub    $0x4,%esp
  803545:	68 a4 4b 80 00       	push   $0x804ba4
  80354a:	68 f1 00 00 00       	push   $0xf1
  80354f:	68 2b 4a 80 00       	push   $0x804a2b
  803554:	e8 37 d2 ff ff       	call   800790 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803559:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355c:	83 ec 0c             	sub    $0xc,%esp
  80355f:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803562:	52                   	push   %edx
  803563:	89 c1                	mov    %eax,%ecx
  803565:	e8 e2 fe ff ff       	call   80344c <log2_ceil.1547>
  80356a:	83 c4 10             	add    $0x10,%esp
  80356d:	83 e8 03             	sub    $0x3,%eax
  803570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803579:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80357d:	75 17                	jne    803596 <free_block+0x117>
  80357f:	83 ec 04             	sub    $0x4,%esp
  803582:	68 f0 4b 80 00       	push   $0x804bf0
  803587:	68 f6 00 00 00       	push   $0xf6
  80358c:	68 2b 4a 80 00       	push   $0x804a2b
  803591:	e8 fa d1 ff ff       	call   800790 <_panic>
  803596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803599:	c1 e0 04             	shl    $0x4,%eax
  80359c:	05 a0 12 82 00       	add    $0x8212a0,%eax
  8035a1:	8b 10                	mov    (%eax),%edx
  8035a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a6:	89 10                	mov    %edx,(%eax)
  8035a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ab:	8b 00                	mov    (%eax),%eax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	74 15                	je     8035c6 <free_block+0x147>
  8035b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b4:	c1 e0 04             	shl    $0x4,%eax
  8035b7:	05 a0 12 82 00       	add    $0x8212a0,%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035c1:	89 50 04             	mov    %edx,0x4(%eax)
  8035c4:	eb 11                	jmp    8035d7 <free_block+0x158>
  8035c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c9:	c1 e0 04             	shl    $0x4,%eax
  8035cc:	8d 90 a4 12 82 00    	lea    0x8212a4(%eax),%edx
  8035d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d5:	89 02                	mov    %eax,(%edx)
  8035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035da:	c1 e0 04             	shl    $0x4,%eax
  8035dd:	8d 90 a0 12 82 00    	lea    0x8212a0(%eax),%edx
  8035e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e6:	89 02                	mov    %eax,(%edx)
  8035e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f5:	c1 e0 04             	shl    $0x4,%eax
  8035f8:	05 ac 12 82 00       	add    $0x8212ac,%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	8d 50 01             	lea    0x1(%eax),%edx
  803602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803605:	c1 e0 04             	shl    $0x4,%eax
  803608:	05 ac 12 82 00       	add    $0x8212ac,%eax
  80360d:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80360f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803612:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803616:	40                   	inc    %eax
  803617:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80361a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80361e:	8b 55 08             	mov    0x8(%ebp),%edx
  803621:	a1 84 12 82 00       	mov    0x821284,%eax
  803626:	29 c2                	sub    %eax,%edx
  803628:	89 d0                	mov    %edx,%eax
  80362a:	c1 e8 0c             	shr    $0xc,%eax
  80362d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803633:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803637:	0f b7 c8             	movzwl %ax,%ecx
  80363a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80363f:	99                   	cltd   
  803640:	f7 7d e8             	idivl  -0x18(%ebp)
  803643:	39 c1                	cmp    %eax,%ecx
  803645:	0f 85 b8 01 00 00    	jne    803803 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80364b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803655:	c1 e0 04             	shl    $0x4,%eax
  803658:	05 a0 12 82 00       	add    $0x8212a0,%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803662:	e9 d5 00 00 00       	jmp    80373c <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80366f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803672:	a1 84 12 82 00       	mov    0x821284,%eax
  803677:	29 c2                	sub    %eax,%edx
  803679:	89 d0                	mov    %edx,%eax
  80367b:	c1 e8 0c             	shr    $0xc,%eax
  80367e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803681:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803684:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803687:	0f 85 a9 00 00 00    	jne    803736 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80368d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803691:	75 17                	jne    8036aa <free_block+0x22b>
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 c5 4a 80 00       	push   $0x804ac5
  80369b:	68 04 01 00 00       	push   $0x104
  8036a0:	68 2b 4a 80 00       	push   $0x804a2b
  8036a5:	e8 e6 d0 ff ff       	call   800790 <_panic>
  8036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 10                	je     8036c3 <free_block+0x244>
  8036b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036bb:	8b 52 04             	mov    0x4(%edx),%edx
  8036be:	89 50 04             	mov    %edx,0x4(%eax)
  8036c1:	eb 14                	jmp    8036d7 <free_block+0x258>
  8036c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c6:	8b 40 04             	mov    0x4(%eax),%eax
  8036c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036cc:	c1 e2 04             	shl    $0x4,%edx
  8036cf:	81 c2 a4 12 82 00    	add    $0x8212a4,%edx
  8036d5:	89 02                	mov    %eax,(%edx)
  8036d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	85 c0                	test   %eax,%eax
  8036df:	74 0f                	je     8036f0 <free_block+0x271>
  8036e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e4:	8b 40 04             	mov    0x4(%eax),%eax
  8036e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ea:	8b 12                	mov    (%edx),%edx
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	eb 13                	jmp    803703 <free_block+0x284>
  8036f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f8:	c1 e2 04             	shl    $0x4,%edx
  8036fb:	81 c2 a0 12 82 00    	add    $0x8212a0,%edx
  803701:	89 02                	mov    %eax,(%edx)
  803703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803719:	c1 e0 04             	shl    $0x4,%eax
  80371c:	05 ac 12 82 00       	add    $0x8212ac,%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	8d 50 ff             	lea    -0x1(%eax),%edx
  803726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803729:	c1 e0 04             	shl    $0x4,%eax
  80372c:	05 ac 12 82 00       	add    $0x8212ac,%eax
  803731:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803733:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803736:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803739:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80373c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803740:	0f 85 21 ff ff ff    	jne    803667 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803746:	b8 00 10 00 00       	mov    $0x1000,%eax
  80374b:	99                   	cltd   
  80374c:	f7 7d e8             	idivl  -0x18(%ebp)
  80374f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803752:	74 17                	je     80376b <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803754:	83 ec 04             	sub    $0x4,%esp
  803757:	68 14 4c 80 00       	push   $0x804c14
  80375c:	68 0c 01 00 00       	push   $0x10c
  803761:	68 2b 4a 80 00       	push   $0x804a2b
  803766:	e8 25 d0 ff ff       	call   800790 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80376b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803777:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80377d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803781:	75 17                	jne    80379a <free_block+0x31b>
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	68 e4 4a 80 00       	push   $0x804ae4
  80378b:	68 11 01 00 00       	push   $0x111
  803790:	68 2b 4a 80 00       	push   $0x804a2b
  803795:	e8 f6 cf ff ff       	call   800790 <_panic>
  80379a:	8b 15 6c 50 80 00    	mov    0x80506c,%edx
  8037a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a3:	89 50 04             	mov    %edx,0x4(%eax)
  8037a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ac:	85 c0                	test   %eax,%eax
  8037ae:	74 0c                	je     8037bc <free_block+0x33d>
  8037b0:	a1 6c 50 80 00       	mov    0x80506c,%eax
  8037b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b8:	89 10                	mov    %edx,(%eax)
  8037ba:	eb 08                	jmp    8037c4 <free_block+0x345>
  8037bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bf:	a3 68 50 80 00       	mov    %eax,0x805068
  8037c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c7:	a3 6c 50 80 00       	mov    %eax,0x80506c
  8037cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d5:	a1 74 50 80 00       	mov    0x805074,%eax
  8037da:	40                   	inc    %eax
  8037db:	a3 74 50 80 00       	mov    %eax,0x805074

        uint32 pp = to_page_va(page_info_e);
  8037e0:	83 ec 0c             	sub    $0xc,%esp
  8037e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8037e6:	e8 2b f4 ff ff       	call   802c16 <to_page_va>
  8037eb:	83 c4 10             	add    $0x10,%esp
  8037ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8037f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037f4:	83 ec 0c             	sub    $0xc,%esp
  8037f7:	50                   	push   %eax
  8037f8:	e8 69 e8 ff ff       	call   802066 <return_page>
  8037fd:	83 c4 10             	add    $0x10,%esp
  803800:	eb 01                	jmp    803803 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803802:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803803:	c9                   	leave  
  803804:	c3                   	ret    

00803805 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803805:	55                   	push   %ebp
  803806:	89 e5                	mov    %esp,%ebp
  803808:	83 ec 14             	sub    $0x14,%esp
  80380b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  80380e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803812:	77 07                	ja     80381b <nearest_pow2_ceil.1572+0x16>
      return 1;
  803814:	b8 01 00 00 00       	mov    $0x1,%eax
  803819:	eb 20                	jmp    80383b <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80381b:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803822:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803825:	eb 08                	jmp    80382f <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803827:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80382a:	01 c0                	add    %eax,%eax
  80382c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80382f:	d1 6d 08             	shrl   0x8(%ebp)
  803832:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803836:	75 ef                	jne    803827 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803838:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80383b:	c9                   	leave  
  80383c:	c3                   	ret    

0080383d <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80383d:	55                   	push   %ebp
  80383e:	89 e5                	mov    %esp,%ebp
  803840:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803843:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803847:	75 13                	jne    80385c <realloc_block+0x1f>
    return alloc_block(new_size);
  803849:	83 ec 0c             	sub    $0xc,%esp
  80384c:	ff 75 0c             	pushl  0xc(%ebp)
  80384f:	e8 d1 f6 ff ff       	call   802f25 <alloc_block>
  803854:	83 c4 10             	add    $0x10,%esp
  803857:	e9 d9 00 00 00       	jmp    803935 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80385c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803860:	75 18                	jne    80387a <realloc_block+0x3d>
    free_block(va);
  803862:	83 ec 0c             	sub    $0xc,%esp
  803865:	ff 75 08             	pushl  0x8(%ebp)
  803868:	e8 12 fc ff ff       	call   80347f <free_block>
  80386d:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803870:	b8 00 00 00 00       	mov    $0x0,%eax
  803875:	e9 bb 00 00 00       	jmp    803935 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  80387a:	83 ec 0c             	sub    $0xc,%esp
  80387d:	ff 75 08             	pushl  0x8(%ebp)
  803880:	e8 38 f6 ff ff       	call   802ebd <get_block_size>
  803885:	83 c4 10             	add    $0x10,%esp
  803888:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80388b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803892:	8b 45 0c             	mov    0xc(%ebp),%eax
  803895:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803898:	73 06                	jae    8038a0 <realloc_block+0x63>
    new_size = min_block_size;
  80389a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389d:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8038a0:	83 ec 0c             	sub    $0xc,%esp
  8038a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8038a6:	ff 75 0c             	pushl  0xc(%ebp)
  8038a9:	89 c1                	mov    %eax,%ecx
  8038ab:	e8 55 ff ff ff       	call   803805 <nearest_pow2_ceil.1572>
  8038b0:	83 c4 10             	add    $0x10,%esp
  8038b3:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8038b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038bc:	75 05                	jne    8038c3 <realloc_block+0x86>
    return va;
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	eb 72                	jmp    803935 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8038c3:	83 ec 0c             	sub    $0xc,%esp
  8038c6:	ff 75 0c             	pushl  0xc(%ebp)
  8038c9:	e8 57 f6 ff ff       	call   802f25 <alloc_block>
  8038ce:	83 c4 10             	add    $0x10,%esp
  8038d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8038d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038d8:	75 07                	jne    8038e1 <realloc_block+0xa4>
    return NULL;
  8038da:	b8 00 00 00 00       	mov    $0x0,%eax
  8038df:	eb 54                	jmp    803935 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8038e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e7:	39 d0                	cmp    %edx,%eax
  8038e9:	76 02                	jbe    8038ed <realloc_block+0xb0>
  8038eb:	89 d0                	mov    %edx,%eax
  8038ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8038f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8038f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8038fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803903:	eb 17                	jmp    80391c <realloc_block+0xdf>
    dst[i] = src[i];
  803905:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390b:	01 c2                	add    %eax,%edx
  80390d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803913:	01 c8                	add    %ecx,%eax
  803915:	8a 00                	mov    (%eax),%al
  803917:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803919:	ff 45 f4             	incl   -0xc(%ebp)
  80391c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803922:	72 e1                	jb     803905 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803924:	83 ec 0c             	sub    $0xc,%esp
  803927:	ff 75 08             	pushl  0x8(%ebp)
  80392a:	e8 50 fb ff ff       	call   80347f <free_block>
  80392f:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803935:	c9                   	leave  
  803936:	c3                   	ret    
  803937:	90                   	nop

00803938 <__udivdi3>:
  803938:	55                   	push   %ebp
  803939:	57                   	push   %edi
  80393a:	56                   	push   %esi
  80393b:	53                   	push   %ebx
  80393c:	83 ec 1c             	sub    $0x1c,%esp
  80393f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803943:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803947:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80394b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80394f:	89 ca                	mov    %ecx,%edx
  803951:	89 f8                	mov    %edi,%eax
  803953:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803957:	85 f6                	test   %esi,%esi
  803959:	75 2d                	jne    803988 <__udivdi3+0x50>
  80395b:	39 cf                	cmp    %ecx,%edi
  80395d:	77 65                	ja     8039c4 <__udivdi3+0x8c>
  80395f:	89 fd                	mov    %edi,%ebp
  803961:	85 ff                	test   %edi,%edi
  803963:	75 0b                	jne    803970 <__udivdi3+0x38>
  803965:	b8 01 00 00 00       	mov    $0x1,%eax
  80396a:	31 d2                	xor    %edx,%edx
  80396c:	f7 f7                	div    %edi
  80396e:	89 c5                	mov    %eax,%ebp
  803970:	31 d2                	xor    %edx,%edx
  803972:	89 c8                	mov    %ecx,%eax
  803974:	f7 f5                	div    %ebp
  803976:	89 c1                	mov    %eax,%ecx
  803978:	89 d8                	mov    %ebx,%eax
  80397a:	f7 f5                	div    %ebp
  80397c:	89 cf                	mov    %ecx,%edi
  80397e:	89 fa                	mov    %edi,%edx
  803980:	83 c4 1c             	add    $0x1c,%esp
  803983:	5b                   	pop    %ebx
  803984:	5e                   	pop    %esi
  803985:	5f                   	pop    %edi
  803986:	5d                   	pop    %ebp
  803987:	c3                   	ret    
  803988:	39 ce                	cmp    %ecx,%esi
  80398a:	77 28                	ja     8039b4 <__udivdi3+0x7c>
  80398c:	0f bd fe             	bsr    %esi,%edi
  80398f:	83 f7 1f             	xor    $0x1f,%edi
  803992:	75 40                	jne    8039d4 <__udivdi3+0x9c>
  803994:	39 ce                	cmp    %ecx,%esi
  803996:	72 0a                	jb     8039a2 <__udivdi3+0x6a>
  803998:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80399c:	0f 87 9e 00 00 00    	ja     803a40 <__udivdi3+0x108>
  8039a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a7:	89 fa                	mov    %edi,%edx
  8039a9:	83 c4 1c             	add    $0x1c,%esp
  8039ac:	5b                   	pop    %ebx
  8039ad:	5e                   	pop    %esi
  8039ae:	5f                   	pop    %edi
  8039af:	5d                   	pop    %ebp
  8039b0:	c3                   	ret    
  8039b1:	8d 76 00             	lea    0x0(%esi),%esi
  8039b4:	31 ff                	xor    %edi,%edi
  8039b6:	31 c0                	xor    %eax,%eax
  8039b8:	89 fa                	mov    %edi,%edx
  8039ba:	83 c4 1c             	add    $0x1c,%esp
  8039bd:	5b                   	pop    %ebx
  8039be:	5e                   	pop    %esi
  8039bf:	5f                   	pop    %edi
  8039c0:	5d                   	pop    %ebp
  8039c1:	c3                   	ret    
  8039c2:	66 90                	xchg   %ax,%ax
  8039c4:	89 d8                	mov    %ebx,%eax
  8039c6:	f7 f7                	div    %edi
  8039c8:	31 ff                	xor    %edi,%edi
  8039ca:	89 fa                	mov    %edi,%edx
  8039cc:	83 c4 1c             	add    $0x1c,%esp
  8039cf:	5b                   	pop    %ebx
  8039d0:	5e                   	pop    %esi
  8039d1:	5f                   	pop    %edi
  8039d2:	5d                   	pop    %ebp
  8039d3:	c3                   	ret    
  8039d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039d9:	89 eb                	mov    %ebp,%ebx
  8039db:	29 fb                	sub    %edi,%ebx
  8039dd:	89 f9                	mov    %edi,%ecx
  8039df:	d3 e6                	shl    %cl,%esi
  8039e1:	89 c5                	mov    %eax,%ebp
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 ed                	shr    %cl,%ebp
  8039e7:	89 e9                	mov    %ebp,%ecx
  8039e9:	09 f1                	or     %esi,%ecx
  8039eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039ef:	89 f9                	mov    %edi,%ecx
  8039f1:	d3 e0                	shl    %cl,%eax
  8039f3:	89 c5                	mov    %eax,%ebp
  8039f5:	89 d6                	mov    %edx,%esi
  8039f7:	88 d9                	mov    %bl,%cl
  8039f9:	d3 ee                	shr    %cl,%esi
  8039fb:	89 f9                	mov    %edi,%ecx
  8039fd:	d3 e2                	shl    %cl,%edx
  8039ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a03:	88 d9                	mov    %bl,%cl
  803a05:	d3 e8                	shr    %cl,%eax
  803a07:	09 c2                	or     %eax,%edx
  803a09:	89 d0                	mov    %edx,%eax
  803a0b:	89 f2                	mov    %esi,%edx
  803a0d:	f7 74 24 0c          	divl   0xc(%esp)
  803a11:	89 d6                	mov    %edx,%esi
  803a13:	89 c3                	mov    %eax,%ebx
  803a15:	f7 e5                	mul    %ebp
  803a17:	39 d6                	cmp    %edx,%esi
  803a19:	72 19                	jb     803a34 <__udivdi3+0xfc>
  803a1b:	74 0b                	je     803a28 <__udivdi3+0xf0>
  803a1d:	89 d8                	mov    %ebx,%eax
  803a1f:	31 ff                	xor    %edi,%edi
  803a21:	e9 58 ff ff ff       	jmp    80397e <__udivdi3+0x46>
  803a26:	66 90                	xchg   %ax,%ax
  803a28:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a2c:	89 f9                	mov    %edi,%ecx
  803a2e:	d3 e2                	shl    %cl,%edx
  803a30:	39 c2                	cmp    %eax,%edx
  803a32:	73 e9                	jae    803a1d <__udivdi3+0xe5>
  803a34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a37:	31 ff                	xor    %edi,%edi
  803a39:	e9 40 ff ff ff       	jmp    80397e <__udivdi3+0x46>
  803a3e:	66 90                	xchg   %ax,%ax
  803a40:	31 c0                	xor    %eax,%eax
  803a42:	e9 37 ff ff ff       	jmp    80397e <__udivdi3+0x46>
  803a47:	90                   	nop

00803a48 <__umoddi3>:
  803a48:	55                   	push   %ebp
  803a49:	57                   	push   %edi
  803a4a:	56                   	push   %esi
  803a4b:	53                   	push   %ebx
  803a4c:	83 ec 1c             	sub    $0x1c,%esp
  803a4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a53:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a67:	89 f3                	mov    %esi,%ebx
  803a69:	89 fa                	mov    %edi,%edx
  803a6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a6f:	89 34 24             	mov    %esi,(%esp)
  803a72:	85 c0                	test   %eax,%eax
  803a74:	75 1a                	jne    803a90 <__umoddi3+0x48>
  803a76:	39 f7                	cmp    %esi,%edi
  803a78:	0f 86 a2 00 00 00    	jbe    803b20 <__umoddi3+0xd8>
  803a7e:	89 c8                	mov    %ecx,%eax
  803a80:	89 f2                	mov    %esi,%edx
  803a82:	f7 f7                	div    %edi
  803a84:	89 d0                	mov    %edx,%eax
  803a86:	31 d2                	xor    %edx,%edx
  803a88:	83 c4 1c             	add    $0x1c,%esp
  803a8b:	5b                   	pop    %ebx
  803a8c:	5e                   	pop    %esi
  803a8d:	5f                   	pop    %edi
  803a8e:	5d                   	pop    %ebp
  803a8f:	c3                   	ret    
  803a90:	39 f0                	cmp    %esi,%eax
  803a92:	0f 87 ac 00 00 00    	ja     803b44 <__umoddi3+0xfc>
  803a98:	0f bd e8             	bsr    %eax,%ebp
  803a9b:	83 f5 1f             	xor    $0x1f,%ebp
  803a9e:	0f 84 ac 00 00 00    	je     803b50 <__umoddi3+0x108>
  803aa4:	bf 20 00 00 00       	mov    $0x20,%edi
  803aa9:	29 ef                	sub    %ebp,%edi
  803aab:	89 fe                	mov    %edi,%esi
  803aad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ab1:	89 e9                	mov    %ebp,%ecx
  803ab3:	d3 e0                	shl    %cl,%eax
  803ab5:	89 d7                	mov    %edx,%edi
  803ab7:	89 f1                	mov    %esi,%ecx
  803ab9:	d3 ef                	shr    %cl,%edi
  803abb:	09 c7                	or     %eax,%edi
  803abd:	89 e9                	mov    %ebp,%ecx
  803abf:	d3 e2                	shl    %cl,%edx
  803ac1:	89 14 24             	mov    %edx,(%esp)
  803ac4:	89 d8                	mov    %ebx,%eax
  803ac6:	d3 e0                	shl    %cl,%eax
  803ac8:	89 c2                	mov    %eax,%edx
  803aca:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ace:	d3 e0                	shl    %cl,%eax
  803ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ad4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ad8:	89 f1                	mov    %esi,%ecx
  803ada:	d3 e8                	shr    %cl,%eax
  803adc:	09 d0                	or     %edx,%eax
  803ade:	d3 eb                	shr    %cl,%ebx
  803ae0:	89 da                	mov    %ebx,%edx
  803ae2:	f7 f7                	div    %edi
  803ae4:	89 d3                	mov    %edx,%ebx
  803ae6:	f7 24 24             	mull   (%esp)
  803ae9:	89 c6                	mov    %eax,%esi
  803aeb:	89 d1                	mov    %edx,%ecx
  803aed:	39 d3                	cmp    %edx,%ebx
  803aef:	0f 82 87 00 00 00    	jb     803b7c <__umoddi3+0x134>
  803af5:	0f 84 91 00 00 00    	je     803b8c <__umoddi3+0x144>
  803afb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aff:	29 f2                	sub    %esi,%edx
  803b01:	19 cb                	sbb    %ecx,%ebx
  803b03:	89 d8                	mov    %ebx,%eax
  803b05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b09:	d3 e0                	shl    %cl,%eax
  803b0b:	89 e9                	mov    %ebp,%ecx
  803b0d:	d3 ea                	shr    %cl,%edx
  803b0f:	09 d0                	or     %edx,%eax
  803b11:	89 e9                	mov    %ebp,%ecx
  803b13:	d3 eb                	shr    %cl,%ebx
  803b15:	89 da                	mov    %ebx,%edx
  803b17:	83 c4 1c             	add    $0x1c,%esp
  803b1a:	5b                   	pop    %ebx
  803b1b:	5e                   	pop    %esi
  803b1c:	5f                   	pop    %edi
  803b1d:	5d                   	pop    %ebp
  803b1e:	c3                   	ret    
  803b1f:	90                   	nop
  803b20:	89 fd                	mov    %edi,%ebp
  803b22:	85 ff                	test   %edi,%edi
  803b24:	75 0b                	jne    803b31 <__umoddi3+0xe9>
  803b26:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2b:	31 d2                	xor    %edx,%edx
  803b2d:	f7 f7                	div    %edi
  803b2f:	89 c5                	mov    %eax,%ebp
  803b31:	89 f0                	mov    %esi,%eax
  803b33:	31 d2                	xor    %edx,%edx
  803b35:	f7 f5                	div    %ebp
  803b37:	89 c8                	mov    %ecx,%eax
  803b39:	f7 f5                	div    %ebp
  803b3b:	89 d0                	mov    %edx,%eax
  803b3d:	e9 44 ff ff ff       	jmp    803a86 <__umoddi3+0x3e>
  803b42:	66 90                	xchg   %ax,%ax
  803b44:	89 c8                	mov    %ecx,%eax
  803b46:	89 f2                	mov    %esi,%edx
  803b48:	83 c4 1c             	add    $0x1c,%esp
  803b4b:	5b                   	pop    %ebx
  803b4c:	5e                   	pop    %esi
  803b4d:	5f                   	pop    %edi
  803b4e:	5d                   	pop    %ebp
  803b4f:	c3                   	ret    
  803b50:	3b 04 24             	cmp    (%esp),%eax
  803b53:	72 06                	jb     803b5b <__umoddi3+0x113>
  803b55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b59:	77 0f                	ja     803b6a <__umoddi3+0x122>
  803b5b:	89 f2                	mov    %esi,%edx
  803b5d:	29 f9                	sub    %edi,%ecx
  803b5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b63:	89 14 24             	mov    %edx,(%esp)
  803b66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b6e:	8b 14 24             	mov    (%esp),%edx
  803b71:	83 c4 1c             	add    $0x1c,%esp
  803b74:	5b                   	pop    %ebx
  803b75:	5e                   	pop    %esi
  803b76:	5f                   	pop    %edi
  803b77:	5d                   	pop    %ebp
  803b78:	c3                   	ret    
  803b79:	8d 76 00             	lea    0x0(%esi),%esi
  803b7c:	2b 04 24             	sub    (%esp),%eax
  803b7f:	19 fa                	sbb    %edi,%edx
  803b81:	89 d1                	mov    %edx,%ecx
  803b83:	89 c6                	mov    %eax,%esi
  803b85:	e9 71 ff ff ff       	jmp    803afb <__umoddi3+0xb3>
  803b8a:	66 90                	xchg   %ax,%ax
  803b8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b90:	72 ea                	jb     803b7c <__umoddi3+0x134>
  803b92:	89 d9                	mov    %ebx,%ecx
  803b94:	e9 62 ff ff ff       	jmp    803afb <__umoddi3+0xb3>
