
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 53 06 00 00       	call   800689 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 64             	sub    $0x64,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 50 80 00       	mov    0x805020,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 20 50 80 00       	mov    0x805020,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 60 3c 80 00       	push   $0x803c60
  800061:	6a 0b                	push   $0xb
  800063:	68 7c 3c 80 00       	push   $0x803c7c
  800068:	e8 cc 07 00 00       	call   800839 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	68 94 3c 80 00       	push   $0x803c94
  80007c:	e8 a6 0a 00 00       	call   800b27 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 c8 3c 80 00       	push   $0x803cc8
  80008c:	e8 96 0a 00 00       	call   800b27 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 24 3d 80 00       	push   $0x803d24
  80009c:	e8 86 0a 00 00       	call   800b27 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000a4:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  8000ab:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int envID = sys_getenvid();
  8000b2:	e8 2c 29 00 00       	call   8029e3 <sys_getenvid>
  8000b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 58 3d 80 00       	push   $0x803d58
  8000c2:	e8 60 0a 00 00       	call   800b27 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 64 27 00 00       	call   802833 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 00 10 00 00       	push   $0x1000
  8000dc:	68 8c 3d 80 00       	push   $0x803d8c
  8000e1:	e8 2c 23 00 00       	call   802412 <smalloc>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000f2:	74 14                	je     800108 <_main+0xd0>
		{panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	68 90 3d 80 00       	push   $0x803d90
  8000fc:	6a 22                	push   $0x22
  8000fe:	68 7c 3c 80 00       	push   $0x803c7c
  800103:	e8 31 07 00 00       	call   800839 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800108:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)

		/*extra 1 page & 1 table for kernel sbrk (at max) due to sharedObject & frameStorage*/
		/*extra 1 page & 1 table for user sbrk (at max) if creating special DS to manage USER PAGE ALLOC */
		int upperLimit = expected +1+1 +1+1 ;
  80010f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800112:	83 c0 04             	add    $0x4,%eax
  800115:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80011b:	e8 13 27 00 00       	call   802833 <sys_calculate_free_frames>
  800120:	29 c3                	sub    %eax,%ebx
  800122:	89 d8                	mov    %ebx,%eax
  800124:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  800127:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80012d:	7c 08                	jl     800137 <_main+0xff>
  80012f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800132:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800135:	7e 24                	jle    80015b <_main+0x123>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80013a:	e8 f4 26 00 00       	call   802833 <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 75 dc             	pushl  -0x24(%ebp)
  800149:	50                   	push   %eax
  80014a:	68 fc 3d 80 00       	push   $0x803dfc
  80014f:	6a 2a                	push   $0x2a
  800151:	68 7c 3c 80 00       	push   $0x803c7c
  800156:	e8 de 06 00 00       	call   800839 <_panic>

		sfree(x);
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	e8 91 25 00 00       	call   8026f7 <sfree>
  800166:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  800169:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80016c:	e8 c2 26 00 00       	call   802833 <sys_calculate_free_frames>
  800171:	29 c3                	sub    %eax,%ebx
  800173:	89 d8                	mov    %ebx,%eax
  800175:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff2 !=  (diff - expected))
  800178:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800181:	74 24                	je     8001a7 <_main+0x16f>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800183:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800186:	e8 a8 26 00 00       	call   802833 <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	50                   	push   %eax
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	68 94 3e 80 00       	push   $0x803e94
  80019b:	6a 30                	push   $0x30
  80019d:	68 7c 3c 80 00       	push   $0x803c7c
  8001a2:	e8 92 06 00 00       	call   800839 <_panic>
	}
	cprintf("Step A completed!!\n\n\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 df 3e 80 00       	push   $0x803edf
  8001af:	e8 73 09 00 00       	call   800b27 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 f8 3e 80 00       	push   $0x803ef8
  8001bf:	e8 63 09 00 00       	call   800b27 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001c7:	e8 67 26 00 00       	call   802833 <sys_calculate_free_frames>
  8001cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 01                	push   $0x1
  8001d4:	68 00 10 00 00       	push   $0x1000
  8001d9:	68 2d 3f 80 00       	push   $0x803f2d
  8001de:	e8 2f 22 00 00       	call   802412 <smalloc>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	6a 01                	push   $0x1
  8001ee:	68 00 10 00 00       	push   $0x1000
  8001f3:	68 8c 3d 80 00       	push   $0x803d8c
  8001f8:	e8 15 22 00 00       	call   802412 <smalloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 c8             	mov    %eax,-0x38(%ebp)

		if(x == NULL)
  800203:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
		{panic("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 30 3f 80 00       	push   $0x803f30
  800211:	6a 3c                	push   $0x3c
  800213:	68 7c 3c 80 00       	push   $0x803c7c
  800218:	e8 1c 06 00 00       	call   800839 <_panic>

		expected = 2+1 ; /*2pages +1table*/
  80021d:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)
		/*extra 1 page for kernel sbrk (at max) due to sharedObject & frameStorage of the 2nd object "x"*/
		/*if creating special DS to manage USER PAGE ALLOC, the prev. created page from STEP A is sufficient */
		int upperLimit = expected +1 ;
  800224:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800227:	40                   	inc    %eax
  800228:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80022b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80022e:	e8 00 26 00 00       	call   802833 <sys_calculate_free_frames>
  800233:	29 c3                	sub    %eax,%ebx
  800235:	89 d8                	mov    %ebx,%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800240:	7c 08                	jl     80024a <_main+0x212>
  800242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800245:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800248:	7e 14                	jle    80025e <_main+0x226>
			{panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");}
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	68 88 3f 80 00       	push   $0x803f88
  800252:	6a 44                	push   $0x44
  800254:	68 7c 3c 80 00       	push   $0x803c7c
  800259:	e8 db 05 00 00       	call   800839 <_panic>

		sfree(z);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	ff 75 cc             	pushl  -0x34(%ebp)
  800264:	e8 8e 24 00 00       	call   8026f7 <sfree>
  800269:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  80026c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80026f:	e8 bf 25 00 00       	call   802833 <sys_calculate_free_frames>
  800274:	29 c3                	sub    %eax,%ebx
  800276:	89 d8                	mov    %ebx,%eax
  800278:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (diff2 != (diff - 1 /*1 page*/))
  80027b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027e:	48                   	dec    %eax
  80027f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800282:	74 24                	je     8002a8 <_main+0x270>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800284:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800287:	e8 a7 25 00 00       	call   802833 <sys_calculate_free_frames>
  80028c:	29 c3                	sub    %eax,%ebx
  80028e:	89 d8                	mov    %ebx,%eax
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	50                   	push   %eax
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	68 94 3e 80 00       	push   $0x803e94
  80029c:	6a 4a                	push   $0x4a
  80029e:	68 7c 3c 80 00       	push   $0x803c7c
  8002a3:	e8 91 05 00 00       	call   800839 <_panic>

		sfree(x);
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ae:	e8 44 24 00 00       	call   8026f7 <sfree>
  8002b3:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002b6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		int diff3 = (freeFrames - sys_calculate_free_frames());
  8002bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002c0:	e8 6e 25 00 00       	call   802833 <sys_calculate_free_frames>
  8002c5:	29 c3                	sub    %eax,%ebx
  8002c7:	89 d8                	mov    %ebx,%eax
  8002c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if (diff3 != (diff2 - (1+1) /*1 page + 1 table*/))
  8002cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002cf:	83 e8 02             	sub    $0x2,%eax
  8002d2:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8002d5:	74 24                	je     8002fb <_main+0x2c3>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8002d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002da:	e8 54 25 00 00       	call   802833 <sys_calculate_free_frames>
  8002df:	29 c3                	sub    %eax,%ebx
  8002e1:	89 d8                	mov    %ebx,%eax
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	68 94 3e 80 00       	push   $0x803e94
  8002ef:	6a 51                	push   $0x51
  8002f1:	68 7c 3c 80 00       	push   $0x803c7c
  8002f6:	e8 3e 05 00 00       	call   800839 <_panic>

	}
	cprintf("Step B completed!!\n\n\n");
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	68 dd 3f 80 00       	push   $0x803fdd
  800303:	e8 1f 08 00 00       	call   800b27 <cprintf>
  800308:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  80030b:	83 ec 0c             	sub    $0xc,%esp
  80030e:	68 f4 3f 80 00       	push   $0x803ff4
  800313:	e8 0f 08 00 00       	call   800b27 <cprintf>
  800318:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80031b:	e8 13 25 00 00       	call   802833 <sys_calculate_free_frames>
  800320:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	6a 01                	push   $0x1
  800328:	68 01 30 00 00       	push   $0x3001
  80032d:	68 29 40 80 00       	push   $0x804029
  800332:	e8 db 20 00 00       	call   802412 <smalloc>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	6a 01                	push   $0x1
  800342:	68 00 10 00 00       	push   $0x1000
  800347:	68 2b 40 80 00       	push   $0x80402b
  80034c:	e8 c1 20 00 00       	call   802412 <smalloc>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	89 45 b0             	mov    %eax,-0x50(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800357:	c7 45 dc 06 00 00 00 	movl   $0x6,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80035e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800361:	e8 cd 24 00 00       	call   802833 <sys_calculate_free_frames>
  800366:	29 c3                	sub    %eax,%ebx
  800368:	89 d8                	mov    %ebx,%eax
  80036a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected)
  80036d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	74 24                	je     800399 <_main+0x361>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800375:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800378:	e8 b6 24 00 00       	call   802833 <sys_calculate_free_frames>
  80037d:	29 c3                	sub    %eax,%ebx
  80037f:	89 d8                	mov    %ebx,%eax
  800381:	83 ec 0c             	sub    $0xc,%esp
  800384:	ff 75 dc             	pushl  -0x24(%ebp)
  800387:	50                   	push   %eax
  800388:	68 fc 3d 80 00       	push   $0x803dfc
  80038d:	6a 5f                	push   $0x5f
  80038f:	68 7c 3c 80 00       	push   $0x803c7c
  800394:	e8 a0 04 00 00       	call   800839 <_panic>

		sfree(w);
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80039f:	e8 53 23 00 00       	call   8026f7 <sfree>
  8003a4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003a7:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ae:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003b1:	e8 7d 24 00 00       	call   802833 <sys_calculate_free_frames>
  8003b6:	29 c3                	sub    %eax,%ebx
  8003b8:	89 d8                	mov    %ebx,%eax
  8003ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8003bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c3:	74 24                	je     8003e9 <_main+0x3b1>
  8003c5:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003c8:	e8 66 24 00 00       	call   802833 <sys_calculate_free_frames>
  8003cd:	29 c3                	sub    %eax,%ebx
  8003cf:	89 d8                	mov    %ebx,%eax
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	50                   	push   %eax
  8003d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d8:	68 94 3e 80 00       	push   $0x803e94
  8003dd:	6a 65                	push   $0x65
  8003df:	68 7c 3c 80 00       	push   $0x803c7c
  8003e4:	e8 50 04 00 00       	call   800839 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	6a 01                	push   $0x1
  8003ee:	68 ff 1f 00 00       	push   $0x1fff
  8003f3:	68 2d 40 80 00       	push   $0x80402d
  8003f8:	e8 15 20 00 00       	call   802412 <smalloc>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800403:	c7 45 dc 04 00 00 00 	movl   $0x4,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80040a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80040d:	e8 21 24 00 00       	call   802833 <sys_calculate_free_frames>
  800412:	29 c3                	sub    %eax,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected /*Exact! since it's not expected that to invloke sbrk due to the prev. sfree*/)
  800419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80041c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80041f:	74 24                	je     800445 <_main+0x40d>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800421:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800424:	e8 0a 24 00 00       	call   802833 <sys_calculate_free_frames>
  800429:	29 c3                	sub    %eax,%ebx
  80042b:	89 d8                	mov    %ebx,%eax
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff 75 dc             	pushl  -0x24(%ebp)
  800433:	50                   	push   %eax
  800434:	68 fc 3d 80 00       	push   $0x803dfc
  800439:	6a 6e                	push   $0x6e
  80043b:	68 7c 3c 80 00       	push   $0x803c7c
  800440:	e8 f4 03 00 00       	call   800839 <_panic>

		sfree(o);
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	ff 75 ac             	pushl  -0x54(%ebp)
  80044b:	e8 a7 22 00 00       	call   8026f7 <sfree>
  800450:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800453:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80045d:	e8 d1 23 00 00       	call   802833 <sys_calculate_free_frames>
  800462:	29 c3                	sub    %eax,%ebx
  800464:	89 d8                	mov    %ebx,%eax
  800466:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80046f:	74 24                	je     800495 <_main+0x45d>
  800471:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800474:	e8 ba 23 00 00       	call   802833 <sys_calculate_free_frames>
  800479:	29 c3                	sub    %eax,%ebx
  80047b:	89 d8                	mov    %ebx,%eax
  80047d:	83 ec 0c             	sub    $0xc,%esp
  800480:	50                   	push   %eax
  800481:	ff 75 dc             	pushl  -0x24(%ebp)
  800484:	68 94 3e 80 00       	push   $0x803e94
  800489:	6a 74                	push   $0x74
  80048b:	68 7c 3c 80 00       	push   $0x803c7c
  800490:	e8 a4 03 00 00       	call   800839 <_panic>

		sfree(u);
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	ff 75 b0             	pushl  -0x50(%ebp)
  80049b:	e8 57 22 00 00       	call   8026f7 <sfree>
  8004a0:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004aa:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004ad:	e8 81 23 00 00       	call   802833 <sys_calculate_free_frames>
  8004b2:	29 c3                	sub    %eax,%ebx
  8004b4:	89 d8                	mov    %ebx,%eax
  8004b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004bc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004bf:	74 24                	je     8004e5 <_main+0x4ad>
  8004c1:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004c4:	e8 6a 23 00 00       	call   802833 <sys_calculate_free_frames>
  8004c9:	29 c3                	sub    %eax,%ebx
  8004cb:	89 d8                	mov    %ebx,%eax
  8004cd:	83 ec 0c             	sub    $0xc,%esp
  8004d0:	50                   	push   %eax
  8004d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d4:	68 94 3e 80 00       	push   $0x803e94
  8004d9:	6a 7a                	push   $0x7a
  8004db:	68 7c 3c 80 00       	push   $0x803c7c
  8004e0:	e8 54 03 00 00       	call   800839 <_panic>

		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  8004e5:	e8 49 23 00 00       	call   802833 <sys_calculate_free_frames>
  8004ea:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  8004ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f0:	89 c2                	mov    %eax,%edx
  8004f2:	01 d2                	add    %edx,%edx
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	6a 01                	push   $0x1
  8004fe:	50                   	push   %eax
  8004ff:	68 29 40 80 00       	push   $0x804029
  800504:	e8 09 1f 00 00       	call   802412 <smalloc>
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	01 c0                	add    %eax,%eax
  80051a:	01 d0                	add    %edx,%eax
  80051c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	6a 01                	push   $0x1
  800524:	50                   	push   %eax
  800525:	68 2b 40 80 00       	push   $0x80402b
  80052a:	e8 e3 1e 00 00       	call   802412 <smalloc>
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	89 45 b0             	mov    %eax,-0x50(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800538:	01 c0                	add    %eax,%eax
  80053a:	89 c2                	mov    %eax,%edx
  80053c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	6a 01                	push   $0x1
  800546:	50                   	push   %eax
  800547:	68 2d 40 80 00       	push   $0x80402d
  80054c:	e8 c1 1e 00 00       	call   802412 <smalloc>
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800557:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80055e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800561:	e8 cd 22 00 00       	call   802833 <sys_calculate_free_frames>
  800566:	29 c3                	sub    %eax,%ebx
  800568:	89 d8                	mov    %ebx,%eax
  80056a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80056d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800570:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800573:	7c 0b                	jl     800580 <_main+0x548>
  800575:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800578:	83 c0 02             	add    $0x2,%eax
  80057b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80057e:	7d 27                	jge    8005a7 <_main+0x56f>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800580:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800583:	e8 ab 22 00 00       	call   802833 <sys_calculate_free_frames>
  800588:	29 c3                	sub    %eax,%ebx
  80058a:	89 d8                	mov    %ebx,%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	ff 75 dc             	pushl  -0x24(%ebp)
  800592:	50                   	push   %eax
  800593:	68 fc 3d 80 00       	push   $0x803dfc
  800598:	68 85 00 00 00       	push   $0x85
  80059d:	68 7c 3c 80 00       	push   $0x803c7c
  8005a2:	e8 92 02 00 00       	call   800839 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005a7:	e8 87 22 00 00       	call   802833 <sys_calculate_free_frames>
  8005ac:	89 45 b8             	mov    %eax,-0x48(%ebp)

		sfree(o);
  8005af:	83 ec 0c             	sub    $0xc,%esp
  8005b2:	ff 75 ac             	pushl  -0x54(%ebp)
  8005b5:	e8 3d 21 00 00       	call   8026f7 <sfree>
  8005ba:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {panic("Wrong free: check your logic");

		sfree(w);
  8005bd:	83 ec 0c             	sub    $0xc,%esp
  8005c0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8005c3:	e8 2f 21 00 00       	call   8026f7 <sfree>
  8005c8:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {panic("Wrong free: check your logic");

		sfree(u);
  8005cb:	83 ec 0c             	sub    $0xc,%esp
  8005ce:	ff 75 b0             	pushl  -0x50(%ebp)
  8005d1:	e8 21 21 00 00       	call   8026f7 <sfree>
  8005d6:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  8005d9:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  8005e0:	e8 4e 22 00 00       	call   802833 <sys_calculate_free_frames>
  8005e5:	89 c2                	mov    %eax,%edx
  8005e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ea:	29 c2                	sub    %eax,%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8005f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 27                	je     800620 <_main+0x5e8>
  8005f9:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8005fc:	e8 32 22 00 00       	call   802833 <sys_calculate_free_frames>
  800601:	29 c3                	sub    %eax,%ebx
  800603:	89 d8                	mov    %ebx,%eax
  800605:	83 ec 0c             	sub    $0xc,%esp
  800608:	50                   	push   %eax
  800609:	ff 75 dc             	pushl  -0x24(%ebp)
  80060c:	68 94 3e 80 00       	push   $0x803e94
  800611:	68 93 00 00 00       	push   $0x93
  800616:	68 7c 3c 80 00       	push   $0x803c7c
  80061b:	e8 19 02 00 00       	call   800839 <_panic>
	}
	cprintf("Step C completed!!\n\n\n");
  800620:	83 ec 0c             	sub    $0xc,%esp
  800623:	68 2f 40 80 00       	push   $0x80402f
  800628:	e8 fa 04 00 00       	call   800b27 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp

	cprintf("Test of freeSharedObjects [4] is finished!!\n\n\n");
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	68 48 40 80 00       	push   $0x804048
  800638:	e8 ea 04 00 00       	call   800b27 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800640:	e8 d0 23 00 00       	call   802a15 <sys_getparentenvid>
  800645:	89 45 a8             	mov    %eax,-0x58(%ebp)
	if(parentenvID > 0)
  800648:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  80064c:	7e 35                	jle    800683 <_main+0x64b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80064e:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	68 77 40 80 00       	push   $0x804077
  80065d:	ff 75 a8             	pushl  -0x58(%ebp)
  800660:	e8 0d 1f 00 00       	call   802572 <sget>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//Critical section to protect the shared variable
		sys_lock_cons();
  80066b:	e8 13 21 00 00       	call   802783 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800670:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	8d 50 01             	lea    0x1(%eax),%edx
  800678:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80067b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80067d:	e8 1b 21 00 00       	call   80279d <sys_unlock_cons>
	}
	return;
  800682:	90                   	nop
  800683:	90                   	nop
}
  800684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	57                   	push   %edi
  80068d:	56                   	push   %esi
  80068e:	53                   	push   %ebx
  80068f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800692:	e8 65 23 00 00       	call   8029fc <sys_getenvindex>
  800697:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80069a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80069d:	89 d0                	mov    %edx,%eax
  80069f:	01 c0                	add    %eax,%eax
  8006a1:	01 d0                	add    %edx,%eax
  8006a3:	c1 e0 02             	shl    $0x2,%eax
  8006a6:	01 d0                	add    %edx,%eax
  8006a8:	c1 e0 02             	shl    $0x2,%eax
  8006ab:	01 d0                	add    %edx,%eax
  8006ad:	c1 e0 03             	shl    $0x3,%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	c1 e0 02             	shl    $0x2,%eax
  8006b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ba:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c4:	8a 40 20             	mov    0x20(%eax),%al
  8006c7:	84 c0                	test   %al,%al
  8006c9:	74 0d                	je     8006d8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	83 c0 20             	add    $0x20,%eax
  8006d3:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006dc:	7e 0a                	jle    8006e8 <libmain+0x5f>
		binaryname = argv[0];
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	ff 75 08             	pushl  0x8(%ebp)
  8006f1:	e8 42 f9 ff ff       	call   800038 <_main>
  8006f6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006f9:	a1 00 50 80 00       	mov    0x805000,%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	0f 84 01 01 00 00    	je     800807 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800706:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80070c:	bb 80 41 80 00       	mov    $0x804180,%ebx
  800711:	ba 0e 00 00 00       	mov    $0xe,%edx
  800716:	89 c7                	mov    %eax,%edi
  800718:	89 de                	mov    %ebx,%esi
  80071a:	89 d1                	mov    %edx,%ecx
  80071c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80071e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800721:	b9 56 00 00 00       	mov    $0x56,%ecx
  800726:	b0 00                	mov    $0x0,%al
  800728:	89 d7                	mov    %edx,%edi
  80072a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80072c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800733:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	50                   	push   %eax
  80073a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	e8 ec 24 00 00       	call   802c32 <sys_utilities>
  800746:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800749:	e8 35 20 00 00       	call   802783 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80074e:	83 ec 0c             	sub    $0xc,%esp
  800751:	68 a0 40 80 00       	push   $0x8040a0
  800756:	e8 cc 03 00 00       	call   800b27 <cprintf>
  80075b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80075e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800761:	85 c0                	test   %eax,%eax
  800763:	74 18                	je     80077d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800765:	e8 e6 24 00 00       	call   802c50 <sys_get_optimal_num_faults>
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 c8 40 80 00       	push   $0x8040c8
  800773:	e8 af 03 00 00       	call   800b27 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb 59                	jmp    8007d6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80077d:	a1 20 50 80 00       	mov    0x805020,%eax
  800782:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800788:	a1 20 50 80 00       	mov    0x805020,%eax
  80078d:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800793:	83 ec 04             	sub    $0x4,%esp
  800796:	52                   	push   %edx
  800797:	50                   	push   %eax
  800798:	68 ec 40 80 00       	push   $0x8040ec
  80079d:	e8 85 03 00 00       	call   800b27 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8007aa:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8007b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b5:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8007bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c0:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8007c6:	51                   	push   %ecx
  8007c7:	52                   	push   %edx
  8007c8:	50                   	push   %eax
  8007c9:	68 14 41 80 00       	push   $0x804114
  8007ce:	e8 54 03 00 00       	call   800b27 <cprintf>
  8007d3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8007db:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	50                   	push   %eax
  8007e5:	68 6c 41 80 00       	push   $0x80416c
  8007ea:	e8 38 03 00 00       	call   800b27 <cprintf>
  8007ef:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	68 a0 40 80 00       	push   $0x8040a0
  8007fa:	e8 28 03 00 00       	call   800b27 <cprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800802:	e8 96 1f 00 00       	call   80279d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800807:	e8 1f 00 00 00       	call   80082b <exit>
}
  80080c:	90                   	nop
  80080d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800810:	5b                   	pop    %ebx
  800811:	5e                   	pop    %esi
  800812:	5f                   	pop    %edi
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	6a 00                	push   $0x0
  800820:	e8 a3 21 00 00       	call   8029c8 <sys_destroy_env>
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	90                   	nop
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <exit>:

void
exit(void)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800831:	e8 f8 21 00 00       	call   802a2e <sys_exit_env>
}
  800836:	90                   	nop
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80083f:	8d 45 10             	lea    0x10(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800848:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80084d:	85 c0                	test   %eax,%eax
  80084f:	74 16                	je     800867 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800851:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	50                   	push   %eax
  80085a:	68 e4 41 80 00       	push   $0x8041e4
  80085f:	e8 c3 02 00 00       	call   800b27 <cprintf>
  800864:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800867:	a1 04 50 80 00       	mov    0x805004,%eax
  80086c:	83 ec 0c             	sub    $0xc,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 08             	pushl  0x8(%ebp)
  800875:	50                   	push   %eax
  800876:	68 ec 41 80 00       	push   $0x8041ec
  80087b:	6a 74                	push   $0x74
  80087d:	e8 d2 02 00 00       	call   800b54 <cprintf_colored>
  800882:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800885:	8b 45 10             	mov    0x10(%ebp),%eax
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 f4             	pushl  -0xc(%ebp)
  80088e:	50                   	push   %eax
  80088f:	e8 24 02 00 00       	call   800ab8 <vcprintf>
  800894:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	6a 00                	push   $0x0
  80089c:	68 14 42 80 00       	push   $0x804214
  8008a1:	e8 12 02 00 00       	call   800ab8 <vcprintf>
  8008a6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a9:	e8 7d ff ff ff       	call   80082b <exit>

	// should not return here
	while (1) ;
  8008ae:	eb fe                	jmp    8008ae <_panic+0x75>

008008b0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	53                   	push   %ebx
  8008b4:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	74 14                	je     8008dd <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 18 42 80 00       	push   $0x804218
  8008d1:	6a 26                	push   $0x26
  8008d3:	68 64 42 80 00       	push   $0x804264
  8008d8:	e8 5c ff ff ff       	call   800839 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008eb:	e9 d9 00 00 00       	jmp    8009c9 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	85 c0                	test   %eax,%eax
  800903:	75 08                	jne    80090d <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800905:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800908:	e9 b9 00 00 00       	jmp    8009c6 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80090d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80091b:	eb 79                	jmp    800996 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800928:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800938:	01 d8                	add    %ebx,%eax
  80093a:	01 d0                	add    %edx,%eax
  80093c:	01 c8                	add    %ecx,%eax
  80093e:	8a 40 04             	mov    0x4(%eax),%al
  800941:	84 c0                	test   %al,%al
  800943:	75 4e                	jne    800993 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800945:	a1 20 50 80 00       	mov    0x805020,%eax
  80094a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800950:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800953:	89 d0                	mov    %edx,%eax
  800955:	01 c0                	add    %eax,%eax
  800957:	01 d0                	add    %edx,%eax
  800959:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800960:	01 d8                	add    %ebx,%eax
  800962:	01 d0                	add    %edx,%eax
  800964:	01 c8                	add    %ecx,%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80096b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80096e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800973:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800978:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	01 c8                	add    %ecx,%eax
  800984:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800986:	39 c2                	cmp    %eax,%edx
  800988:	75 09                	jne    800993 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80098a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800991:	eb 19                	jmp    8009ac <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800993:	ff 45 e8             	incl   -0x18(%ebp)
  800996:	a1 20 50 80 00       	mov    0x805020,%eax
  80099b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009a4:	39 c2                	cmp    %eax,%edx
  8009a6:	0f 87 71 ff ff ff    	ja     80091d <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009b0:	75 14                	jne    8009c6 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8009b2:	83 ec 04             	sub    $0x4,%esp
  8009b5:	68 70 42 80 00       	push   $0x804270
  8009ba:	6a 3a                	push   $0x3a
  8009bc:	68 64 42 80 00       	push   $0x804264
  8009c1:	e8 73 fe ff ff       	call   800839 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009c6:	ff 45 f0             	incl   -0x10(%ebp)
  8009c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009cf:	0f 8c 1b ff ff ff    	jl     8008f0 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009e3:	eb 2e                	jmp    800a13 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8009ea:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8009f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	01 c0                	add    %eax,%eax
  8009f7:	01 d0                	add    %edx,%eax
  8009f9:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a00:	01 d8                	add    %ebx,%eax
  800a02:	01 d0                	add    %edx,%eax
  800a04:	01 c8                	add    %ecx,%eax
  800a06:	8a 40 04             	mov    0x4(%eax),%al
  800a09:	3c 01                	cmp    $0x1,%al
  800a0b:	75 03                	jne    800a10 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800a0d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a10:	ff 45 e0             	incl   -0x20(%ebp)
  800a13:	a1 20 50 80 00       	mov    0x805020,%eax
  800a18:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a21:	39 c2                	cmp    %eax,%edx
  800a23:	77 c0                	ja     8009e5 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a28:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a2b:	74 14                	je     800a41 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800a2d:	83 ec 04             	sub    $0x4,%esp
  800a30:	68 c4 42 80 00       	push   $0x8042c4
  800a35:	6a 44                	push   $0x44
  800a37:	68 64 42 80 00       	push   $0x804264
  800a3c:	e8 f8 fd ff ff       	call   800839 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a41:	90                   	nop
  800a42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	53                   	push   %ebx
  800a4b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	8b 00                	mov    (%eax),%eax
  800a53:	8d 48 01             	lea    0x1(%eax),%ecx
  800a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a59:	89 0a                	mov    %ecx,(%edx)
  800a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5e:	88 d1                	mov    %dl,%cl
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a63:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a71:	75 30                	jne    800aa3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a73:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800a79:	a0 44 50 80 00       	mov    0x805044,%al
  800a7e:	0f b6 c0             	movzbl %al,%eax
  800a81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a84:	8b 09                	mov    (%ecx),%ecx
  800a86:	89 cb                	mov    %ecx,%ebx
  800a88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8b:	83 c1 08             	add    $0x8,%ecx
  800a8e:	52                   	push   %edx
  800a8f:	50                   	push   %eax
  800a90:	53                   	push   %ebx
  800a91:	51                   	push   %ecx
  800a92:	e8 a8 1c 00 00       	call   80273f <sys_cputs>
  800a97:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa6:	8b 40 04             	mov    0x4(%eax),%eax
  800aa9:	8d 50 01             	lea    0x1(%eax),%edx
  800aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaf:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ab2:	90                   	nop
  800ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ac1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ac8:	00 00 00 
	b.cnt = 0;
  800acb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ad2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ad5:	ff 75 0c             	pushl  0xc(%ebp)
  800ad8:	ff 75 08             	pushl  0x8(%ebp)
  800adb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	68 47 0a 80 00       	push   $0x800a47
  800ae7:	e8 5a 02 00 00       	call   800d46 <vprintfmt>
  800aec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800aef:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800af5:	a0 44 50 80 00       	mov    0x805044,%al
  800afa:	0f b6 c0             	movzbl %al,%eax
  800afd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800b03:	52                   	push   %edx
  800b04:	50                   	push   %eax
  800b05:	51                   	push   %ecx
  800b06:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0c:	83 c0 08             	add    $0x8,%eax
  800b0f:	50                   	push   %eax
  800b10:	e8 2a 1c 00 00       	call   80273f <sys_cputs>
  800b15:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b18:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800b1f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b2d:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800b34:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 f4             	pushl  -0xc(%ebp)
  800b43:	50                   	push   %eax
  800b44:	e8 6f ff ff ff       	call   800ab8 <vcprintf>
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    

00800b54 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b5a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	c1 e0 08             	shl    $0x8,%eax
  800b67:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800b6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b6f:	83 c0 04             	add    $0x4,%eax
  800b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7e:	50                   	push   %eax
  800b7f:	e8 34 ff ff ff       	call   800ab8 <vcprintf>
  800b84:	83 c4 10             	add    $0x10,%esp
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b8a:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800b91:	07 00 00 

	return cnt;
  800b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b9f:	e8 df 1b 00 00       	call   802783 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ba4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb3:	50                   	push   %eax
  800bb4:	e8 ff fe ff ff       	call   800ab8 <vcprintf>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800bbf:	e8 d9 1b 00 00       	call   80279d <sys_unlock_cons>
	return cnt;
  800bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	53                   	push   %ebx
  800bcd:	83 ec 14             	sub    $0x14,%esp
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bdc:	8b 45 18             	mov    0x18(%ebp),%eax
  800bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800be4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800be7:	77 55                	ja     800c3e <printnum+0x75>
  800be9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bec:	72 05                	jb     800bf3 <printnum+0x2a>
  800bee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bf1:	77 4b                	ja     800c3e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bf3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bf6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bf9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	52                   	push   %edx
  800c02:	50                   	push   %eax
  800c03:	ff 75 f4             	pushl  -0xc(%ebp)
  800c06:	ff 75 f0             	pushl  -0x10(%ebp)
  800c09:	e8 d2 2d 00 00       	call   8039e0 <__udivdi3>
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	83 ec 04             	sub    $0x4,%esp
  800c14:	ff 75 20             	pushl  0x20(%ebp)
  800c17:	53                   	push   %ebx
  800c18:	ff 75 18             	pushl  0x18(%ebp)
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	ff 75 08             	pushl  0x8(%ebp)
  800c23:	e8 a1 ff ff ff       	call   800bc9 <printnum>
  800c28:	83 c4 20             	add    $0x20,%esp
  800c2b:	eb 1a                	jmp    800c47 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	ff d0                	call   *%eax
  800c3b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c3e:	ff 4d 1c             	decl   0x1c(%ebp)
  800c41:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c45:	7f e6                	jg     800c2d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c47:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c55:	53                   	push   %ebx
  800c56:	51                   	push   %ecx
  800c57:	52                   	push   %edx
  800c58:	50                   	push   %eax
  800c59:	e8 92 2e 00 00       	call   803af0 <__umoddi3>
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	05 34 45 80 00       	add    $0x804534,%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	0f be c0             	movsbl %al,%eax
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	50                   	push   %eax
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	ff d0                	call   *%eax
  800c77:	83 c4 10             	add    $0x10,%esp
}
  800c7a:	90                   	nop
  800c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c83:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c87:	7e 1c                	jle    800ca5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	8d 50 08             	lea    0x8(%eax),%edx
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	89 10                	mov    %edx,(%eax)
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 00                	mov    (%eax),%eax
  800c9b:	83 e8 08             	sub    $0x8,%eax
  800c9e:	8b 50 04             	mov    0x4(%eax),%edx
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	eb 40                	jmp    800ce5 <getuint+0x65>
	else if (lflag)
  800ca5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca9:	74 1e                	je     800cc9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	8d 50 04             	lea    0x4(%eax),%edx
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	89 10                	mov    %edx,(%eax)
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	83 e8 04             	sub    $0x4,%eax
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc7:	eb 1c                	jmp    800ce5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8b 00                	mov    (%eax),%eax
  800cce:	8d 50 04             	lea    0x4(%eax),%edx
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	89 10                	mov    %edx,(%eax)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	83 e8 04             	sub    $0x4,%eax
  800cde:	8b 00                	mov    (%eax),%eax
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cee:	7e 1c                	jle    800d0c <getint+0x25>
		return va_arg(*ap, long long);
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8b 00                	mov    (%eax),%eax
  800cf5:	8d 50 08             	lea    0x8(%eax),%edx
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	89 10                	mov    %edx,(%eax)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8b 00                	mov    (%eax),%eax
  800d02:	83 e8 08             	sub    $0x8,%eax
  800d05:	8b 50 04             	mov    0x4(%eax),%edx
  800d08:	8b 00                	mov    (%eax),%eax
  800d0a:	eb 38                	jmp    800d44 <getint+0x5d>
	else if (lflag)
  800d0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d10:	74 1a                	je     800d2c <getint+0x45>
		return va_arg(*ap, long);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	99                   	cltd   
  800d2a:	eb 18                	jmp    800d44 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	8d 50 04             	lea    0x4(%eax),%edx
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	89 10                	mov    %edx,(%eax)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 e8 04             	sub    $0x4,%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	99                   	cltd   
}
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4e:	eb 17                	jmp    800d67 <vprintfmt+0x21>
			if (ch == '\0')
  800d50:	85 db                	test   %ebx,%ebx
  800d52:	0f 84 c1 03 00 00    	je     801119 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d58:	83 ec 08             	sub    $0x8,%esp
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	53                   	push   %ebx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	ff d0                	call   *%eax
  800d64:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	8d 50 01             	lea    0x1(%eax),%edx
  800d6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 d8             	movzbl %al,%ebx
  800d75:	83 fb 25             	cmp    $0x25,%ebx
  800d78:	75 d6                	jne    800d50 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d7a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d85:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9d:	8d 50 01             	lea    0x1(%eax),%edx
  800da0:	89 55 10             	mov    %edx,0x10(%ebp)
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	0f b6 d8             	movzbl %al,%ebx
  800da8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dab:	83 f8 5b             	cmp    $0x5b,%eax
  800dae:	0f 87 3d 03 00 00    	ja     8010f1 <vprintfmt+0x3ab>
  800db4:	8b 04 85 58 45 80 00 	mov    0x804558(,%eax,4),%eax
  800dbb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800dbd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dc1:	eb d7                	jmp    800d9a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dc3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dc7:	eb d1                	jmp    800d9a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dd3:	89 d0                	mov    %edx,%eax
  800dd5:	c1 e0 02             	shl    $0x2,%eax
  800dd8:	01 d0                	add    %edx,%eax
  800dda:	01 c0                	add    %eax,%eax
  800ddc:	01 d8                	add    %ebx,%eax
  800dde:	83 e8 30             	sub    $0x30,%eax
  800de1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dec:	83 fb 2f             	cmp    $0x2f,%ebx
  800def:	7e 3e                	jle    800e2f <vprintfmt+0xe9>
  800df1:	83 fb 39             	cmp    $0x39,%ebx
  800df4:	7f 39                	jg     800e2f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800df6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800df9:	eb d5                	jmp    800dd0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfe:	83 c0 04             	add    $0x4,%eax
  800e01:	89 45 14             	mov    %eax,0x14(%ebp)
  800e04:	8b 45 14             	mov    0x14(%ebp),%eax
  800e07:	83 e8 04             	sub    $0x4,%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e0f:	eb 1f                	jmp    800e30 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e15:	79 83                	jns    800d9a <vprintfmt+0x54>
				width = 0;
  800e17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e1e:	e9 77 ff ff ff       	jmp    800d9a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e23:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e2a:	e9 6b ff ff ff       	jmp    800d9a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e2f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	0f 89 60 ff ff ff    	jns    800d9a <vprintfmt+0x54>
				width = precision, precision = -1;
  800e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e47:	e9 4e ff ff ff       	jmp    800d9a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e4c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e4f:	e9 46 ff ff ff       	jmp    800d9a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e54:	8b 45 14             	mov    0x14(%ebp),%eax
  800e57:	83 c0 04             	add    $0x4,%eax
  800e5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	83 e8 04             	sub    $0x4,%eax
  800e63:	8b 00                	mov    (%eax),%eax
  800e65:	83 ec 08             	sub    $0x8,%esp
  800e68:	ff 75 0c             	pushl  0xc(%ebp)
  800e6b:	50                   	push   %eax
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	ff d0                	call   *%eax
  800e71:	83 c4 10             	add    $0x10,%esp
			break;
  800e74:	e9 9b 02 00 00       	jmp    801114 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e79:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7c:	83 c0 04             	add    $0x4,%eax
  800e7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e82:	8b 45 14             	mov    0x14(%ebp),%eax
  800e85:	83 e8 04             	sub    $0x4,%eax
  800e88:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e8a:	85 db                	test   %ebx,%ebx
  800e8c:	79 02                	jns    800e90 <vprintfmt+0x14a>
				err = -err;
  800e8e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e90:	83 fb 64             	cmp    $0x64,%ebx
  800e93:	7f 0b                	jg     800ea0 <vprintfmt+0x15a>
  800e95:	8b 34 9d a0 43 80 00 	mov    0x8043a0(,%ebx,4),%esi
  800e9c:	85 f6                	test   %esi,%esi
  800e9e:	75 19                	jne    800eb9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ea0:	53                   	push   %ebx
  800ea1:	68 45 45 80 00       	push   $0x804545
  800ea6:	ff 75 0c             	pushl  0xc(%ebp)
  800ea9:	ff 75 08             	pushl  0x8(%ebp)
  800eac:	e8 70 02 00 00       	call   801121 <printfmt>
  800eb1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eb4:	e9 5b 02 00 00       	jmp    801114 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800eb9:	56                   	push   %esi
  800eba:	68 4e 45 80 00       	push   $0x80454e
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	e8 57 02 00 00       	call   801121 <printfmt>
  800eca:	83 c4 10             	add    $0x10,%esp
			break;
  800ecd:	e9 42 02 00 00       	jmp    801114 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ed2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed5:	83 c0 04             	add    $0x4,%eax
  800ed8:	89 45 14             	mov    %eax,0x14(%ebp)
  800edb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ede:	83 e8 04             	sub    $0x4,%eax
  800ee1:	8b 30                	mov    (%eax),%esi
  800ee3:	85 f6                	test   %esi,%esi
  800ee5:	75 05                	jne    800eec <vprintfmt+0x1a6>
				p = "(null)";
  800ee7:	be 51 45 80 00       	mov    $0x804551,%esi
			if (width > 0 && padc != '-')
  800eec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef0:	7e 6d                	jle    800f5f <vprintfmt+0x219>
  800ef2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ef6:	74 67                	je     800f5f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	50                   	push   %eax
  800eff:	56                   	push   %esi
  800f00:	e8 1e 03 00 00       	call   801223 <strnlen>
  800f05:	83 c4 10             	add    $0x10,%esp
  800f08:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f0b:	eb 16                	jmp    800f23 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f11:	83 ec 08             	sub    $0x8,%esp
  800f14:	ff 75 0c             	pushl  0xc(%ebp)
  800f17:	50                   	push   %eax
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	ff d0                	call   *%eax
  800f1d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f20:	ff 4d e4             	decl   -0x1c(%ebp)
  800f23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f27:	7f e4                	jg     800f0d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f29:	eb 34                	jmp    800f5f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f2f:	74 1c                	je     800f4d <vprintfmt+0x207>
  800f31:	83 fb 1f             	cmp    $0x1f,%ebx
  800f34:	7e 05                	jle    800f3b <vprintfmt+0x1f5>
  800f36:	83 fb 7e             	cmp    $0x7e,%ebx
  800f39:	7e 12                	jle    800f4d <vprintfmt+0x207>
					putch('?', putdat);
  800f3b:	83 ec 08             	sub    $0x8,%esp
  800f3e:	ff 75 0c             	pushl  0xc(%ebp)
  800f41:	6a 3f                	push   $0x3f
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
  800f4b:	eb 0f                	jmp    800f5c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	53                   	push   %ebx
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	ff d0                	call   *%eax
  800f59:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5f:	89 f0                	mov    %esi,%eax
  800f61:	8d 70 01             	lea    0x1(%eax),%esi
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f be d8             	movsbl %al,%ebx
  800f69:	85 db                	test   %ebx,%ebx
  800f6b:	74 24                	je     800f91 <vprintfmt+0x24b>
  800f6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f71:	78 b8                	js     800f2b <vprintfmt+0x1e5>
  800f73:	ff 4d e0             	decl   -0x20(%ebp)
  800f76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f7a:	79 af                	jns    800f2b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f7c:	eb 13                	jmp    800f91 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f7e:	83 ec 08             	sub    $0x8,%esp
  800f81:	ff 75 0c             	pushl  0xc(%ebp)
  800f84:	6a 20                	push   $0x20
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	ff d0                	call   *%eax
  800f8b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800f91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f95:	7f e7                	jg     800f7e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f97:	e9 78 01 00 00       	jmp    801114 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800fa2:	8d 45 14             	lea    0x14(%ebp),%eax
  800fa5:	50                   	push   %eax
  800fa6:	e8 3c fd ff ff       	call   800ce7 <getint>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fba:	85 d2                	test   %edx,%edx
  800fbc:	79 23                	jns    800fe1 <vprintfmt+0x29b>
				putch('-', putdat);
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	6a 2d                	push   $0x2d
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd4:	f7 d8                	neg    %eax
  800fd6:	83 d2 00             	adc    $0x0,%edx
  800fd9:	f7 da                	neg    %edx
  800fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fe1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fe8:	e9 bc 00 00 00       	jmp    8010a9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff6:	50                   	push   %eax
  800ff7:	e8 84 fc ff ff       	call   800c80 <getuint>
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801002:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801005:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80100c:	e9 98 00 00 00       	jmp    8010a9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	6a 58                	push   $0x58
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	ff d0                	call   *%eax
  80101e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801021:	83 ec 08             	sub    $0x8,%esp
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	6a 58                	push   $0x58
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	ff d0                	call   *%eax
  80102e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	6a 58                	push   $0x58
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	ff d0                	call   *%eax
  80103e:	83 c4 10             	add    $0x10,%esp
			break;
  801041:	e9 ce 00 00 00       	jmp    801114 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	ff 75 0c             	pushl  0xc(%ebp)
  80104c:	6a 30                	push   $0x30
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	ff d0                	call   *%eax
  801053:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	6a 78                	push   $0x78
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	ff d0                	call   *%eax
  801063:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801066:	8b 45 14             	mov    0x14(%ebp),%eax
  801069:	83 c0 04             	add    $0x4,%eax
  80106c:	89 45 14             	mov    %eax,0x14(%ebp)
  80106f:	8b 45 14             	mov    0x14(%ebp),%eax
  801072:	83 e8 04             	sub    $0x4,%eax
  801075:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801077:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801081:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801088:	eb 1f                	jmp    8010a9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80108a:	83 ec 08             	sub    $0x8,%esp
  80108d:	ff 75 e8             	pushl  -0x18(%ebp)
  801090:	8d 45 14             	lea    0x14(%ebp),%eax
  801093:	50                   	push   %eax
  801094:	e8 e7 fb ff ff       	call   800c80 <getuint>
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010a2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010a9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010b0:	83 ec 04             	sub    $0x4,%esp
  8010b3:	52                   	push   %edx
  8010b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010b7:	50                   	push   %eax
  8010b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8010be:	ff 75 0c             	pushl  0xc(%ebp)
  8010c1:	ff 75 08             	pushl  0x8(%ebp)
  8010c4:	e8 00 fb ff ff       	call   800bc9 <printnum>
  8010c9:	83 c4 20             	add    $0x20,%esp
			break;
  8010cc:	eb 46                	jmp    801114 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	53                   	push   %ebx
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	ff d0                	call   *%eax
  8010da:	83 c4 10             	add    $0x10,%esp
			break;
  8010dd:	eb 35                	jmp    801114 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010df:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  8010e6:	eb 2c                	jmp    801114 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010e8:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  8010ef:	eb 23                	jmp    801114 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010f1:	83 ec 08             	sub    $0x8,%esp
  8010f4:	ff 75 0c             	pushl  0xc(%ebp)
  8010f7:	6a 25                	push   $0x25
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	ff d0                	call   *%eax
  8010fe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801101:	ff 4d 10             	decl   0x10(%ebp)
  801104:	eb 03                	jmp    801109 <vprintfmt+0x3c3>
  801106:	ff 4d 10             	decl   0x10(%ebp)
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	48                   	dec    %eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 25                	cmp    $0x25,%al
  801111:	75 f3                	jne    801106 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801113:	90                   	nop
		}
	}
  801114:	e9 35 fc ff ff       	jmp    800d4e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801119:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80111a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80111d:	5b                   	pop    %ebx
  80111e:	5e                   	pop    %esi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    

00801121 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801127:	8d 45 10             	lea    0x10(%ebp),%eax
  80112a:	83 c0 04             	add    $0x4,%eax
  80112d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	ff 75 f4             	pushl  -0xc(%ebp)
  801136:	50                   	push   %eax
  801137:	ff 75 0c             	pushl  0xc(%ebp)
  80113a:	ff 75 08             	pushl  0x8(%ebp)
  80113d:	e8 04 fc ff ff       	call   800d46 <vprintfmt>
  801142:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	8b 40 08             	mov    0x8(%eax),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80115a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115d:	8b 10                	mov    (%eax),%edx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8b 40 04             	mov    0x4(%eax),%eax
  801165:	39 c2                	cmp    %eax,%edx
  801167:	73 12                	jae    80117b <sprintputch+0x33>
		*b->buf++ = ch;
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	8b 00                	mov    (%eax),%eax
  80116e:	8d 48 01             	lea    0x1(%eax),%ecx
  801171:	8b 55 0c             	mov    0xc(%ebp),%edx
  801174:	89 0a                	mov    %ecx,(%edx)
  801176:	8b 55 08             	mov    0x8(%ebp),%edx
  801179:	88 10                	mov    %dl,(%eax)
}
  80117b:	90                   	nop
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801198:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80119f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a3:	74 06                	je     8011ab <vsnprintf+0x2d>
  8011a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a9:	7f 07                	jg     8011b2 <vsnprintf+0x34>
		return -E_INVAL;
  8011ab:	b8 03 00 00 00       	mov    $0x3,%eax
  8011b0:	eb 20                	jmp    8011d2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011b2:	ff 75 14             	pushl  0x14(%ebp)
  8011b5:	ff 75 10             	pushl  0x10(%ebp)
  8011b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011bb:	50                   	push   %eax
  8011bc:	68 48 11 80 00       	push   $0x801148
  8011c1:	e8 80 fb ff ff       	call   800d46 <vprintfmt>
  8011c6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011cc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011da:	8d 45 10             	lea    0x10(%ebp),%eax
  8011dd:	83 c0 04             	add    $0x4,%eax
  8011e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e9:	50                   	push   %eax
  8011ea:	ff 75 0c             	pushl  0xc(%ebp)
  8011ed:	ff 75 08             	pushl  0x8(%ebp)
  8011f0:	e8 89 ff ff ff       	call   80117e <vsnprintf>
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801206:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120d:	eb 06                	jmp    801215 <strlen+0x15>
		n++;
  80120f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801212:	ff 45 08             	incl   0x8(%ebp)
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	84 c0                	test   %al,%al
  80121c:	75 f1                	jne    80120f <strlen+0xf>
		n++;
	return n;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801229:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801230:	eb 09                	jmp    80123b <strnlen+0x18>
		n++;
  801232:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801235:	ff 45 08             	incl   0x8(%ebp)
  801238:	ff 4d 0c             	decl   0xc(%ebp)
  80123b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80123f:	74 09                	je     80124a <strnlen+0x27>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e8                	jne    801232 <strnlen+0xf>
		n++;
	return n;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80125b:	90                   	nop
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 08             	mov    %edx,0x8(%ebp)
  801265:	8b 55 0c             	mov    0xc(%ebp),%edx
  801268:	8d 4a 01             	lea    0x1(%edx),%ecx
  80126b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80126e:	8a 12                	mov    (%edx),%dl
  801270:	88 10                	mov    %dl,(%eax)
  801272:	8a 00                	mov    (%eax),%al
  801274:	84 c0                	test   %al,%al
  801276:	75 e4                	jne    80125c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801278:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801290:	eb 1f                	jmp    8012b1 <strncpy+0x34>
		*dst++ = *src;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8d 50 01             	lea    0x1(%eax),%edx
  801298:	89 55 08             	mov    %edx,0x8(%ebp)
  80129b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129e:	8a 12                	mov    (%edx),%dl
  8012a0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	84 c0                	test   %al,%al
  8012a9:	74 03                	je     8012ae <strncpy+0x31>
			src++;
  8012ab:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ae:	ff 45 fc             	incl   -0x4(%ebp)
  8012b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b7:	72 d9                	jb     801292 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	74 30                	je     801300 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012d0:	eb 16                	jmp    8012e8 <strlcpy+0x2a>
			*dst++ = *src++;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 08             	mov    %edx,0x8(%ebp)
  8012db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012de:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012e4:	8a 12                	mov    (%edx),%dl
  8012e6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012e8:	ff 4d 10             	decl   0x10(%ebp)
  8012eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ef:	74 09                	je     8012fa <strlcpy+0x3c>
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	75 d8                	jne    8012d2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801300:	8b 55 08             	mov    0x8(%ebp),%edx
  801303:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801306:	29 c2                	sub    %eax,%edx
  801308:	89 d0                	mov    %edx,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80130f:	eb 06                	jmp    801317 <strcmp+0xb>
		p++, q++;
  801311:	ff 45 08             	incl   0x8(%ebp)
  801314:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	84 c0                	test   %al,%al
  80131e:	74 0e                	je     80132e <strcmp+0x22>
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 10                	mov    (%eax),%dl
  801325:	8b 45 0c             	mov    0xc(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	38 c2                	cmp    %al,%dl
  80132c:	74 e3                	je     801311 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	0f b6 d0             	movzbl %al,%edx
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	0f b6 c0             	movzbl %al,%eax
  80133e:	29 c2                	sub    %eax,%edx
  801340:	89 d0                	mov    %edx,%eax
}
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    

00801344 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801347:	eb 09                	jmp    801352 <strncmp+0xe>
		n--, p++, q++;
  801349:	ff 4d 10             	decl   0x10(%ebp)
  80134c:	ff 45 08             	incl   0x8(%ebp)
  80134f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801352:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801356:	74 17                	je     80136f <strncmp+0x2b>
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	84 c0                	test   %al,%al
  80135f:	74 0e                	je     80136f <strncmp+0x2b>
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8a 10                	mov    (%eax),%dl
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	8a 00                	mov    (%eax),%al
  80136b:	38 c2                	cmp    %al,%dl
  80136d:	74 da                	je     801349 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80136f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801373:	75 07                	jne    80137c <strncmp+0x38>
		return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
  80137a:	eb 14                	jmp    801390 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	0f b6 d0             	movzbl %al,%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	0f b6 c0             	movzbl %al,%eax
  80138c:	29 c2                	sub    %eax,%edx
  80138e:	89 d0                	mov    %edx,%eax
}
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    

00801392 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80139e:	eb 12                	jmp    8013b2 <strchr+0x20>
		if (*s == c)
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013a8:	75 05                	jne    8013af <strchr+0x1d>
			return (char *) s;
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	eb 11                	jmp    8013c0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013af:	ff 45 08             	incl   0x8(%ebp)
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	84 c0                	test   %al,%al
  8013b9:	75 e5                	jne    8013a0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013ce:	eb 0d                	jmp    8013dd <strfind+0x1b>
		if (*s == c)
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d8:	74 0e                	je     8013e8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013da:	ff 45 08             	incl   0x8(%ebp)
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	84 c0                	test   %al,%al
  8013e4:	75 ea                	jne    8013d0 <strfind+0xe>
  8013e6:	eb 01                	jmp    8013e9 <strfind+0x27>
		if (*s == c)
			break;
  8013e8:	90                   	nop
	return (char *) s;
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8013fa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013fe:	76 63                	jbe    801463 <memset+0x75>
		uint64 data_block = c;
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	99                   	cltd   
  801404:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801407:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80140a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801410:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801414:	c1 e0 08             	shl    $0x8,%eax
  801417:	09 45 f0             	or     %eax,-0x10(%ebp)
  80141a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801423:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801427:	c1 e0 10             	shl    $0x10,%eax
  80142a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80142d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801433:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801436:	89 c2                	mov    %eax,%edx
  801438:	b8 00 00 00 00       	mov    $0x0,%eax
  80143d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801440:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801443:	eb 18                	jmp    80145d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801445:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801448:	8d 41 08             	lea    0x8(%ecx),%eax
  80144b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80144e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801454:	89 01                	mov    %eax,(%ecx)
  801456:	89 51 04             	mov    %edx,0x4(%ecx)
  801459:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80145d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801461:	77 e2                	ja     801445 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801463:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801467:	74 23                	je     80148c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801469:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80146f:	eb 0e                	jmp    80147f <memset+0x91>
			*p8++ = (uint8)c;
  801471:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801474:	8d 50 01             	lea    0x1(%eax),%edx
  801477:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80147f:	8b 45 10             	mov    0x10(%ebp),%eax
  801482:	8d 50 ff             	lea    -0x1(%eax),%edx
  801485:	89 55 10             	mov    %edx,0x10(%ebp)
  801488:	85 c0                	test   %eax,%eax
  80148a:	75 e5                	jne    801471 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8014a3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014a7:	76 24                	jbe    8014cd <memcpy+0x3c>
		while(n >= 8){
  8014a9:	eb 1c                	jmp    8014c7 <memcpy+0x36>
			*d64 = *s64;
  8014ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ae:	8b 50 04             	mov    0x4(%eax),%edx
  8014b1:	8b 00                	mov    (%eax),%eax
  8014b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014b6:	89 01                	mov    %eax,(%ecx)
  8014b8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8014bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8014bf:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8014c3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8014c7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014cb:	77 de                	ja     8014ab <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8014cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d1:	74 31                	je     801504 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8014d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8014df:	eb 16                	jmp    8014f7 <memcpy+0x66>
			*d8++ = *s8++;
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e4:	8d 50 01             	lea    0x1(%eax),%edx
  8014e7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8014ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8014f3:	8a 12                	mov    (%edx),%dl
  8014f5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8014f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014fd:	89 55 10             	mov    %edx,0x10(%ebp)
  801500:	85 c0                	test   %eax,%eax
  801502:	75 dd                	jne    8014e1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80151b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801521:	73 50                	jae    801573 <memmove+0x6a>
  801523:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	01 d0                	add    %edx,%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	76 43                	jbe    801573 <memmove+0x6a>
		s += n;
  801530:	8b 45 10             	mov    0x10(%ebp),%eax
  801533:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801536:	8b 45 10             	mov    0x10(%ebp),%eax
  801539:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80153c:	eb 10                	jmp    80154e <memmove+0x45>
			*--d = *--s;
  80153e:	ff 4d f8             	decl   -0x8(%ebp)
  801541:	ff 4d fc             	decl   -0x4(%ebp)
  801544:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801547:	8a 10                	mov    (%eax),%dl
  801549:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	8d 50 ff             	lea    -0x1(%eax),%edx
  801554:	89 55 10             	mov    %edx,0x10(%ebp)
  801557:	85 c0                	test   %eax,%eax
  801559:	75 e3                	jne    80153e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80155b:	eb 23                	jmp    801580 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80155d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801560:	8d 50 01             	lea    0x1(%eax),%edx
  801563:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801566:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801569:	8d 4a 01             	lea    0x1(%edx),%ecx
  80156c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80156f:	8a 12                	mov    (%edx),%dl
  801571:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	8d 50 ff             	lea    -0x1(%eax),%edx
  801579:	89 55 10             	mov    %edx,0x10(%ebp)
  80157c:	85 c0                	test   %eax,%eax
  80157e:	75 dd                	jne    80155d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801591:	8b 45 0c             	mov    0xc(%ebp),%eax
  801594:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801597:	eb 2a                	jmp    8015c3 <memcmp+0x3e>
		if (*s1 != *s2)
  801599:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159c:	8a 10                	mov    (%eax),%dl
  80159e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a1:	8a 00                	mov    (%eax),%al
  8015a3:	38 c2                	cmp    %al,%dl
  8015a5:	74 16                	je     8015bd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	0f b6 d0             	movzbl %al,%edx
  8015af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b2:	8a 00                	mov    (%eax),%al
  8015b4:	0f b6 c0             	movzbl %al,%eax
  8015b7:	29 c2                	sub    %eax,%edx
  8015b9:	89 d0                	mov    %edx,%eax
  8015bb:	eb 18                	jmp    8015d5 <memcmp+0x50>
		s1++, s2++;
  8015bd:	ff 45 fc             	incl   -0x4(%ebp)
  8015c0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	75 c9                	jne    801599 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e3:	01 d0                	add    %edx,%eax
  8015e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015e8:	eb 15                	jmp    8015ff <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	0f b6 d0             	movzbl %al,%edx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	0f b6 c0             	movzbl %al,%eax
  8015f8:	39 c2                	cmp    %eax,%edx
  8015fa:	74 0d                	je     801609 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015fc:	ff 45 08             	incl   0x8(%ebp)
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801605:	72 e3                	jb     8015ea <memfind+0x13>
  801607:	eb 01                	jmp    80160a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801609:	90                   	nop
	return (void *) s;
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801615:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80161c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801623:	eb 03                	jmp    801628 <strtol+0x19>
		s++;
  801625:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	3c 20                	cmp    $0x20,%al
  80162f:	74 f4                	je     801625 <strtol+0x16>
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	3c 09                	cmp    $0x9,%al
  801638:	74 eb                	je     801625 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	3c 2b                	cmp    $0x2b,%al
  801641:	75 05                	jne    801648 <strtol+0x39>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
  801646:	eb 13                	jmp    80165b <strtol+0x4c>
	else if (*s == '-')
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8a 00                	mov    (%eax),%al
  80164d:	3c 2d                	cmp    $0x2d,%al
  80164f:	75 0a                	jne    80165b <strtol+0x4c>
		s++, neg = 1;
  801651:	ff 45 08             	incl   0x8(%ebp)
  801654:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80165b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80165f:	74 06                	je     801667 <strtol+0x58>
  801661:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801665:	75 20                	jne    801687 <strtol+0x78>
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	3c 30                	cmp    $0x30,%al
  80166e:	75 17                	jne    801687 <strtol+0x78>
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	40                   	inc    %eax
  801674:	8a 00                	mov    (%eax),%al
  801676:	3c 78                	cmp    $0x78,%al
  801678:	75 0d                	jne    801687 <strtol+0x78>
		s += 2, base = 16;
  80167a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80167e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801685:	eb 28                	jmp    8016af <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	75 15                	jne    8016a2 <strtol+0x93>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 30                	cmp    $0x30,%al
  801694:	75 0c                	jne    8016a2 <strtol+0x93>
		s++, base = 8;
  801696:	ff 45 08             	incl   0x8(%ebp)
  801699:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016a0:	eb 0d                	jmp    8016af <strtol+0xa0>
	else if (base == 0)
  8016a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a6:	75 07                	jne    8016af <strtol+0xa0>
		base = 10;
  8016a8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 2f                	cmp    $0x2f,%al
  8016b6:	7e 19                	jle    8016d1 <strtol+0xc2>
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	3c 39                	cmp    $0x39,%al
  8016bf:	7f 10                	jg     8016d1 <strtol+0xc2>
			dig = *s - '0';
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	0f be c0             	movsbl %al,%eax
  8016c9:	83 e8 30             	sub    $0x30,%eax
  8016cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016cf:	eb 42                	jmp    801713 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	3c 60                	cmp    $0x60,%al
  8016d8:	7e 19                	jle    8016f3 <strtol+0xe4>
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	3c 7a                	cmp    $0x7a,%al
  8016e1:	7f 10                	jg     8016f3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	83 e8 57             	sub    $0x57,%eax
  8016ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f1:	eb 20                	jmp    801713 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	3c 40                	cmp    $0x40,%al
  8016fa:	7e 39                	jle    801735 <strtol+0x126>
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8a 00                	mov    (%eax),%al
  801701:	3c 5a                	cmp    $0x5a,%al
  801703:	7f 30                	jg     801735 <strtol+0x126>
			dig = *s - 'A' + 10;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	0f be c0             	movsbl %al,%eax
  80170d:	83 e8 37             	sub    $0x37,%eax
  801710:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801716:	3b 45 10             	cmp    0x10(%ebp),%eax
  801719:	7d 19                	jge    801734 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80171b:	ff 45 08             	incl   0x8(%ebp)
  80171e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801721:	0f af 45 10          	imul   0x10(%ebp),%eax
  801725:	89 c2                	mov    %eax,%edx
  801727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172a:	01 d0                	add    %edx,%eax
  80172c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80172f:	e9 7b ff ff ff       	jmp    8016af <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801734:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801735:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801739:	74 08                	je     801743 <strtol+0x134>
		*endptr = (char *) s;
  80173b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173e:	8b 55 08             	mov    0x8(%ebp),%edx
  801741:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801743:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801747:	74 07                	je     801750 <strtol+0x141>
  801749:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80174c:	f7 d8                	neg    %eax
  80174e:	eb 03                	jmp    801753 <strtol+0x144>
  801750:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <ltostr>:

void
ltostr(long value, char *str)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80175b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801762:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801769:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80176d:	79 13                	jns    801782 <ltostr+0x2d>
	{
		neg = 1;
  80176f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801776:	8b 45 0c             	mov    0xc(%ebp),%eax
  801779:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80177c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80177f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80178a:	99                   	cltd   
  80178b:	f7 f9                	idiv   %ecx
  80178d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801790:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801793:	8d 50 01             	lea    0x1(%eax),%edx
  801796:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801799:	89 c2                	mov    %eax,%edx
  80179b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179e:	01 d0                	add    %edx,%eax
  8017a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a3:	83 c2 30             	add    $0x30,%edx
  8017a6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ab:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017b0:	f7 e9                	imul   %ecx
  8017b2:	c1 fa 02             	sar    $0x2,%edx
  8017b5:	89 c8                	mov    %ecx,%eax
  8017b7:	c1 f8 1f             	sar    $0x1f,%eax
  8017ba:	29 c2                	sub    %eax,%edx
  8017bc:	89 d0                	mov    %edx,%eax
  8017be:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017c5:	75 bb                	jne    801782 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d1:	48                   	dec    %eax
  8017d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017d9:	74 3d                	je     801818 <ltostr+0xc3>
		start = 1 ;
  8017db:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017e2:	eb 34                	jmp    801818 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ea:	01 d0                	add    %edx,%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f7:	01 c2                	add    %eax,%edx
  8017f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ff:	01 c8                	add    %ecx,%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801805:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180b:	01 c2                	add    %eax,%edx
  80180d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801810:	88 02                	mov    %al,(%edx)
		start++ ;
  801812:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801815:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80181e:	7c c4                	jl     8017e4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801820:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	01 d0                	add    %edx,%eax
  801828:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801834:	ff 75 08             	pushl  0x8(%ebp)
  801837:	e8 c4 f9 ff ff       	call   801200 <strlen>
  80183c:	83 c4 04             	add    $0x4,%esp
  80183f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	e8 b6 f9 ff ff       	call   801200 <strlen>
  80184a:	83 c4 04             	add    $0x4,%esp
  80184d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801857:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80185e:	eb 17                	jmp    801877 <strcconcat+0x49>
		final[s] = str1[s] ;
  801860:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	01 c2                	add    %eax,%edx
  801868:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	01 c8                	add    %ecx,%eax
  801870:	8a 00                	mov    (%eax),%al
  801872:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801874:	ff 45 fc             	incl   -0x4(%ebp)
  801877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80187d:	7c e1                	jl     801860 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80187f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801886:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80188d:	eb 1f                	jmp    8018ae <strcconcat+0x80>
		final[s++] = str2[i] ;
  80188f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801892:	8d 50 01             	lea    0x1(%eax),%edx
  801895:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801898:	89 c2                	mov    %eax,%edx
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
  80189d:	01 c2                	add    %eax,%edx
  80189f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	01 c8                	add    %ecx,%eax
  8018a7:	8a 00                	mov    (%eax),%al
  8018a9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018ab:	ff 45 f8             	incl   -0x8(%ebp)
  8018ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018b4:	7c d9                	jl     80188f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bc:	01 d0                	add    %edx,%eax
  8018be:	c6 00 00             	movb   $0x0,(%eax)
}
  8018c1:	90                   	nop
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	01 d0                	add    %edx,%eax
  8018e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018e7:	eb 0c                	jmp    8018f5 <strsplit+0x31>
			*string++ = 0;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8d 50 01             	lea    0x1(%eax),%edx
  8018ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8018f2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	84 c0                	test   %al,%al
  8018fc:	74 18                	je     801916 <strsplit+0x52>
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8a 00                	mov    (%eax),%al
  801903:	0f be c0             	movsbl %al,%eax
  801906:	50                   	push   %eax
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	e8 83 fa ff ff       	call   801392 <strchr>
  80190f:	83 c4 08             	add    $0x8,%esp
  801912:	85 c0                	test   %eax,%eax
  801914:	75 d3                	jne    8018e9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	8a 00                	mov    (%eax),%al
  80191b:	84 c0                	test   %al,%al
  80191d:	74 5a                	je     801979 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80191f:	8b 45 14             	mov    0x14(%ebp),%eax
  801922:	8b 00                	mov    (%eax),%eax
  801924:	83 f8 0f             	cmp    $0xf,%eax
  801927:	75 07                	jne    801930 <strsplit+0x6c>
		{
			return 0;
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
  80192e:	eb 66                	jmp    801996 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	8b 00                	mov    (%eax),%eax
  801935:	8d 48 01             	lea    0x1(%eax),%ecx
  801938:	8b 55 14             	mov    0x14(%ebp),%edx
  80193b:	89 0a                	mov    %ecx,(%edx)
  80193d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
  801947:	01 c2                	add    %eax,%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80194e:	eb 03                	jmp    801953 <strsplit+0x8f>
			string++;
  801950:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 8b                	je     8018e7 <strsplit+0x23>
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	8a 00                	mov    (%eax),%al
  801961:	0f be c0             	movsbl %al,%eax
  801964:	50                   	push   %eax
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	e8 25 fa ff ff       	call   801392 <strchr>
  80196d:	83 c4 08             	add    $0x8,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	74 dc                	je     801950 <strsplit+0x8c>
			string++;
	}
  801974:	e9 6e ff ff ff       	jmp    8018e7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801979:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80197a:	8b 45 14             	mov    0x14(%ebp),%eax
  80197d:	8b 00                	mov    (%eax),%eax
  80197f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801991:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8019a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019ab:	eb 4a                	jmp    8019f7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8019ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	01 c2                	add    %eax,%edx
  8019b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bb:	01 c8                	add    %ecx,%eax
  8019bd:	8a 00                	mov    (%eax),%al
  8019bf:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8019c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c7:	01 d0                	add    %edx,%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 40                	cmp    $0x40,%al
  8019cd:	7e 25                	jle    8019f4 <str2lower+0x5c>
  8019cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d5:	01 d0                	add    %edx,%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	3c 5a                	cmp    $0x5a,%al
  8019db:	7f 17                	jg     8019f4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8019dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	01 d0                	add    %edx,%eax
  8019e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019eb:	01 ca                	add    %ecx,%edx
  8019ed:	8a 12                	mov    (%edx),%dl
  8019ef:	83 c2 20             	add    $0x20,%edx
  8019f2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8019f4:	ff 45 fc             	incl   -0x4(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	e8 01 f8 ff ff       	call   801200 <strlen>
  8019ff:	83 c4 04             	add    $0x4,%esp
  801a02:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a05:	7f a6                	jg     8019ad <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801a07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801a12:	83 ec 0c             	sub    $0xc,%esp
  801a15:	6a 10                	push   $0x10
  801a17:	e8 b2 15 00 00       	call   802fce <alloc_block>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801a22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a26:	75 14                	jne    801a3c <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	68 c8 46 80 00       	push   $0x8046c8
  801a30:	6a 14                	push   $0x14
  801a32:	68 f1 46 80 00       	push   $0x8046f1
  801a37:	e8 fd ed ff ff       	call   800839 <_panic>

	node->start = start;
  801a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a42:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801a4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801a54:	a1 24 50 80 00       	mov    0x805024,%eax
  801a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a5c:	eb 18                	jmp    801a76 <insert_page_alloc+0x6a>
		if (start < it->start)
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	8b 00                	mov    (%eax),%eax
  801a63:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a66:	77 37                	ja     801a9f <insert_page_alloc+0x93>
			break;
		prev = it;
  801a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801a6e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a7a:	74 08                	je     801a84 <insert_page_alloc+0x78>
  801a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7f:	8b 40 08             	mov    0x8(%eax),%eax
  801a82:	eb 05                	jmp    801a89 <insert_page_alloc+0x7d>
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a8e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a93:	85 c0                	test   %eax,%eax
  801a95:	75 c7                	jne    801a5e <insert_page_alloc+0x52>
  801a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a9b:	75 c1                	jne    801a5e <insert_page_alloc+0x52>
  801a9d:	eb 01                	jmp    801aa0 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801a9f:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801aa0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aa4:	75 64                	jne    801b0a <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801aa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aaa:	75 14                	jne    801ac0 <insert_page_alloc+0xb4>
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	68 00 47 80 00       	push   $0x804700
  801ab4:	6a 21                	push   $0x21
  801ab6:	68 f1 46 80 00       	push   $0x8046f1
  801abb:	e8 79 ed ff ff       	call   800839 <_panic>
  801ac0:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac9:	89 50 08             	mov    %edx,0x8(%eax)
  801acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acf:	8b 40 08             	mov    0x8(%eax),%eax
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	74 0d                	je     801ae3 <insert_page_alloc+0xd7>
  801ad6:	a1 24 50 80 00       	mov    0x805024,%eax
  801adb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ade:	89 50 0c             	mov    %edx,0xc(%eax)
  801ae1:	eb 08                	jmp    801aeb <insert_page_alloc+0xdf>
  801ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae6:	a3 28 50 80 00       	mov    %eax,0x805028
  801aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aee:	a3 24 50 80 00       	mov    %eax,0x805024
  801af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801afd:	a1 30 50 80 00       	mov    0x805030,%eax
  801b02:	40                   	inc    %eax
  801b03:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801b08:	eb 71                	jmp    801b7b <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801b0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b0e:	74 06                	je     801b16 <insert_page_alloc+0x10a>
  801b10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b14:	75 14                	jne    801b2a <insert_page_alloc+0x11e>
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	68 24 47 80 00       	push   $0x804724
  801b1e:	6a 23                	push   $0x23
  801b20:	68 f1 46 80 00       	push   $0x8046f1
  801b25:	e8 0f ed ff ff       	call   800839 <_panic>
  801b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2d:	8b 50 08             	mov    0x8(%eax),%edx
  801b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b33:	89 50 08             	mov    %edx,0x8(%eax)
  801b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b39:	8b 40 08             	mov    0x8(%eax),%eax
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	74 0c                	je     801b4c <insert_page_alloc+0x140>
  801b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b43:	8b 40 08             	mov    0x8(%eax),%eax
  801b46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b49:	89 50 0c             	mov    %edx,0xc(%eax)
  801b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	89 50 08             	mov    %edx,0x8(%eax)
  801b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b5b:	89 50 0c             	mov    %edx,0xc(%eax)
  801b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b61:	8b 40 08             	mov    0x8(%eax),%eax
  801b64:	85 c0                	test   %eax,%eax
  801b66:	75 08                	jne    801b70 <insert_page_alloc+0x164>
  801b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6b:	a3 28 50 80 00       	mov    %eax,0x805028
  801b70:	a1 30 50 80 00       	mov    0x805030,%eax
  801b75:	40                   	inc    %eax
  801b76:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801b84:	a1 24 50 80 00       	mov    0x805024,%eax
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	75 0c                	jne    801b99 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801b8d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b92:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801b97:	eb 67                	jmp    801c00 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801b99:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801b9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ba1:	a1 24 50 80 00       	mov    0x805024,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801ba9:	eb 26                	jmp    801bd1 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801bab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bae:	8b 10                	mov    (%eax),%edx
  801bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb3:	8b 40 04             	mov    0x4(%eax),%eax
  801bb6:	01 d0                	add    %edx,%eax
  801bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bc1:	76 06                	jbe    801bc9 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801bc9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801bce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801bd1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801bd5:	74 08                	je     801bdf <recompute_page_alloc_break+0x61>
  801bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bda:	8b 40 08             	mov    0x8(%eax),%eax
  801bdd:	eb 05                	jmp    801be4 <recompute_page_alloc_break+0x66>
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801be9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	75 b9                	jne    801bab <recompute_page_alloc_break+0x2d>
  801bf2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801bf6:	75 b3                	jne    801bab <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801bf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bfb:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801c08:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c15:	01 d0                	add    %edx,%eax
  801c17:	48                   	dec    %eax
  801c18:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	f7 75 d8             	divl   -0x28(%ebp)
  801c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c29:	29 d0                	sub    %edx,%eax
  801c2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801c2e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801c32:	75 0a                	jne    801c3e <alloc_pages_custom_fit+0x3c>
		return NULL;
  801c34:	b8 00 00 00 00       	mov    $0x0,%eax
  801c39:	e9 7e 01 00 00       	jmp    801dbc <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801c45:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801c49:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801c50:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801c57:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801c5f:	a1 24 50 80 00       	mov    0x805024,%eax
  801c64:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c67:	eb 69                	jmp    801cd2 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c71:	76 47                	jbe    801cba <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c76:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7c:	8b 00                	mov    (%eax),%eax
  801c7e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801c81:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801c84:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c87:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c8a:	72 2e                	jb     801cba <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801c8c:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801c90:	75 14                	jne    801ca6 <alloc_pages_custom_fit+0xa4>
  801c92:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c95:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c98:	75 0c                	jne    801ca6 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801c9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801ca0:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801ca4:	eb 14                	jmp    801cba <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801ca6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ca9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801cac:	76 0c                	jbe    801cba <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801cae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801cb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801cb7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801cba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cbd:	8b 10                	mov    (%eax),%edx
  801cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc2:	8b 40 04             	mov    0x4(%eax),%eax
  801cc5:	01 d0                	add    %edx,%eax
  801cc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801cca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ccf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801cd2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cd6:	74 08                	je     801ce0 <alloc_pages_custom_fit+0xde>
  801cd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cdb:	8b 40 08             	mov    0x8(%eax),%eax
  801cde:	eb 05                	jmp    801ce5 <alloc_pages_custom_fit+0xe3>
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801cea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	0f 85 72 ff ff ff    	jne    801c69 <alloc_pages_custom_fit+0x67>
  801cf7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cfb:	0f 85 68 ff ff ff    	jne    801c69 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801d01:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801d06:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d09:	76 47                	jbe    801d52 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801d11:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801d16:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801d19:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801d1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d1f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d22:	72 2e                	jb     801d52 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801d24:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801d28:	75 14                	jne    801d3e <alloc_pages_custom_fit+0x13c>
  801d2a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d2d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d30:	75 0c                	jne    801d3e <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801d32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801d38:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801d3c:	eb 14                	jmp    801d52 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801d3e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d41:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d44:	76 0c                	jbe    801d52 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801d46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d49:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801d4c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801d52:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801d59:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801d5d:	74 08                	je     801d67 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d65:	eb 40                	jmp    801da7 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801d67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d6b:	74 08                	je     801d75 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d70:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d73:	eb 32                	jmp    801da7 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801d75:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801d7a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801d7d:	89 c2                	mov    %eax,%edx
  801d7f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801d84:	39 c2                	cmp    %eax,%edx
  801d86:	73 07                	jae    801d8f <alloc_pages_custom_fit+0x18d>
			return NULL;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	eb 2d                	jmp    801dbc <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801d8f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801d94:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801d97:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801d9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801da0:	01 d0                	add    %edx,%eax
  801da2:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801daa:	83 ec 08             	sub    $0x8,%esp
  801dad:	ff 75 d0             	pushl  -0x30(%ebp)
  801db0:	50                   	push   %eax
  801db1:	e8 56 fc ff ff       	call   801a0c <insert_page_alloc>
  801db6:	83 c4 10             	add    $0x10,%esp

	return result;
  801db9:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801dca:	a1 24 50 80 00       	mov    0x805024,%eax
  801dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801dd2:	eb 1a                	jmp    801dee <find_allocated_size+0x30>
		if (it->start == va)
  801dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd7:	8b 00                	mov    (%eax),%eax
  801dd9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ddc:	75 08                	jne    801de6 <find_allocated_size+0x28>
			return it->size;
  801dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de1:	8b 40 04             	mov    0x4(%eax),%eax
  801de4:	eb 34                	jmp    801e1a <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801de6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801dee:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801df2:	74 08                	je     801dfc <find_allocated_size+0x3e>
  801df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df7:	8b 40 08             	mov    0x8(%eax),%eax
  801dfa:	eb 05                	jmp    801e01 <find_allocated_size+0x43>
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e06:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	75 c5                	jne    801dd4 <find_allocated_size+0x16>
  801e0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e13:	75 bf                	jne    801dd4 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801e28:	a1 24 50 80 00       	mov    0x805024,%eax
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e30:	e9 e1 01 00 00       	jmp    802016 <free_pages+0x1fa>
		if (it->start == va) {
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	8b 00                	mov    (%eax),%eax
  801e3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e3d:	0f 85 cb 01 00 00    	jne    80200e <free_pages+0x1f2>

			uint32 start = it->start;
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	8b 00                	mov    (%eax),%eax
  801e48:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	8b 40 04             	mov    0x4(%eax),%eax
  801e51:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e57:	f7 d0                	not    %eax
  801e59:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e5c:	73 1d                	jae    801e7b <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801e5e:	83 ec 0c             	sub    $0xc,%esp
  801e61:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e64:	ff 75 e8             	pushl  -0x18(%ebp)
  801e67:	68 58 47 80 00       	push   $0x804758
  801e6c:	68 a5 00 00 00       	push   $0xa5
  801e71:	68 f1 46 80 00       	push   $0x8046f1
  801e76:	e8 be e9 ff ff       	call   800839 <_panic>
			}

			uint32 start_end = start + size;
  801e7b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e81:	01 d0                	add    %edx,%eax
  801e83:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	79 19                	jns    801ea6 <free_pages+0x8a>
  801e8d:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801e94:	77 10                	ja     801ea6 <free_pages+0x8a>
  801e96:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801e9d:	77 07                	ja     801ea6 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801e9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	78 2c                	js     801ed2 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801ea6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	68 00 00 00 a0       	push   $0xa0000000
  801eb1:	ff 75 e0             	pushl  -0x20(%ebp)
  801eb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801eb7:	ff 75 e8             	pushl  -0x18(%ebp)
  801eba:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ebd:	50                   	push   %eax
  801ebe:	68 9c 47 80 00       	push   $0x80479c
  801ec3:	68 ad 00 00 00       	push   $0xad
  801ec8:	68 f1 46 80 00       	push   $0x8046f1
  801ecd:	e8 67 e9 ff ff       	call   800839 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ed8:	e9 88 00 00 00       	jmp    801f65 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801edd:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801ee4:	76 17                	jbe    801efd <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801ee6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee9:	68 00 48 80 00       	push   $0x804800
  801eee:	68 b4 00 00 00       	push   $0xb4
  801ef3:	68 f1 46 80 00       	push   $0x8046f1
  801ef8:	e8 3c e9 ff ff       	call   800839 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	05 00 10 00 00       	add    $0x1000,%eax
  801f05:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	79 2e                	jns    801f3d <free_pages+0x121>
  801f0f:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801f16:	77 25                	ja     801f3d <free_pages+0x121>
  801f18:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801f1f:	77 1c                	ja     801f3d <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	68 00 10 00 00       	push   $0x1000
  801f29:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2c:	e8 38 0d 00 00       	call   802c69 <sys_free_user_mem>
  801f31:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801f34:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f3b:	eb 28                	jmp    801f65 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f40:	68 00 00 00 a0       	push   $0xa0000000
  801f45:	ff 75 dc             	pushl  -0x24(%ebp)
  801f48:	68 00 10 00 00       	push   $0x1000
  801f4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f50:	50                   	push   %eax
  801f51:	68 40 48 80 00       	push   $0x804840
  801f56:	68 bd 00 00 00       	push   $0xbd
  801f5b:	68 f1 46 80 00       	push   $0x8046f1
  801f60:	e8 d4 e8 ff ff       	call   800839 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f68:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f6b:	0f 82 6c ff ff ff    	jb     801edd <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801f71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f75:	75 17                	jne    801f8e <free_pages+0x172>
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	68 a2 48 80 00       	push   $0x8048a2
  801f7f:	68 c1 00 00 00       	push   $0xc1
  801f84:	68 f1 46 80 00       	push   $0x8046f1
  801f89:	e8 ab e8 ff ff       	call   800839 <_panic>
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 40 08             	mov    0x8(%eax),%eax
  801f94:	85 c0                	test   %eax,%eax
  801f96:	74 11                	je     801fa9 <free_pages+0x18d>
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	8b 40 08             	mov    0x8(%eax),%eax
  801f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa1:	8b 52 0c             	mov    0xc(%edx),%edx
  801fa4:	89 50 0c             	mov    %edx,0xc(%eax)
  801fa7:	eb 0b                	jmp    801fb4 <free_pages+0x198>
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 40 0c             	mov    0xc(%eax),%eax
  801faf:	a3 28 50 80 00       	mov    %eax,0x805028
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	74 11                	je     801fcf <free_pages+0x1b3>
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc7:	8b 52 08             	mov    0x8(%edx),%edx
  801fca:	89 50 08             	mov    %edx,0x8(%eax)
  801fcd:	eb 0b                	jmp    801fda <free_pages+0x1be>
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 40 08             	mov    0x8(%eax),%eax
  801fd5:	a3 24 50 80 00       	mov    %eax,0x805024
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801fee:	a1 30 50 80 00       	mov    0x805030,%eax
  801ff3:	48                   	dec    %eax
  801ff4:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fff:	e8 24 15 00 00       	call   803528 <free_block>
  802004:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802007:	e8 72 fb ff ff       	call   801b7e <recompute_page_alloc_break>

			return;
  80200c:	eb 37                	jmp    802045 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80200e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802013:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802016:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201a:	74 08                	je     802024 <free_pages+0x208>
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	8b 40 08             	mov    0x8(%eax),%eax
  802022:	eb 05                	jmp    802029 <free_pages+0x20d>
  802024:	b8 00 00 00 00       	mov    $0x0,%eax
  802029:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80202e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802033:	85 c0                	test   %eax,%eax
  802035:	0f 85 fa fd ff ff    	jne    801e35 <free_pages+0x19>
  80203b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203f:	0f 85 f0 fd ff ff    	jne    801e35 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802057:	a1 08 50 80 00       	mov    0x805008,%eax
  80205c:	85 c0                	test   %eax,%eax
  80205e:	74 60                	je     8020c0 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802060:	83 ec 08             	sub    $0x8,%esp
  802063:	68 00 00 00 82       	push   $0x82000000
  802068:	68 00 00 00 80       	push   $0x80000000
  80206d:	e8 0d 0d 00 00       	call   802d7f <initialize_dynamic_allocator>
  802072:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802075:	e8 f3 0a 00 00       	call   802b6d <sys_get_uheap_strategy>
  80207a:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80207f:	a1 40 50 80 00       	mov    0x805040,%eax
  802084:	05 00 10 00 00       	add    $0x1000,%eax
  802089:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  80208e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802093:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  802098:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  80209f:	00 00 00 
  8020a2:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  8020a9:	00 00 00 
  8020ac:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  8020b3:	00 00 00 

		__firstTimeFlag = 0;
  8020b6:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8020bd:	00 00 00 
	}
}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8020d7:	83 ec 08             	sub    $0x8,%esp
  8020da:	68 06 04 00 00       	push   $0x406
  8020df:	50                   	push   %eax
  8020e0:	e8 d2 06 00 00       	call   8027b7 <__sys_allocate_page>
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8020eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ef:	79 17                	jns    802108 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 c0 48 80 00       	push   $0x8048c0
  8020f9:	68 ea 00 00 00       	push   $0xea
  8020fe:	68 f1 46 80 00       	push   $0x8046f1
  802103:	e8 31 e7 ff ff       	call   800839 <_panic>
	return 0;
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	50                   	push   %eax
  802127:	e8 d2 06 00 00       	call   8027fe <__sys_unmap_frame>
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802132:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802136:	79 17                	jns    80214f <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	68 fc 48 80 00       	push   $0x8048fc
  802140:	68 f5 00 00 00       	push   $0xf5
  802145:	68 f1 46 80 00       	push   $0x8046f1
  80214a:	e8 ea e6 ff ff       	call   800839 <_panic>
}
  80214f:	90                   	nop
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802158:	e8 f4 fe ff ff       	call   802051 <uheap_init>
	if (size == 0) return NULL ;
  80215d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802161:	75 0a                	jne    80216d <malloc+0x1b>
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	e9 67 01 00 00       	jmp    8022d4 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  80216d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802174:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80217b:	77 16                	ja     802193 <malloc+0x41>
		result = alloc_block(size);
  80217d:	83 ec 0c             	sub    $0xc,%esp
  802180:	ff 75 08             	pushl  0x8(%ebp)
  802183:	e8 46 0e 00 00       	call   802fce <alloc_block>
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218e:	e9 3e 01 00 00       	jmp    8022d1 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802193:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80219a:	8b 55 08             	mov    0x8(%ebp),%edx
  80219d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a0:	01 d0                	add    %edx,%eax
  8021a2:	48                   	dec    %eax
  8021a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ae:	f7 75 f0             	divl   -0x10(%ebp)
  8021b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b4:	29 d0                	sub    %edx,%eax
  8021b6:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8021b9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	75 0a                	jne    8021cc <malloc+0x7a>
			return NULL;
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	e9 08 01 00 00       	jmp    8022d4 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8021cc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	74 0f                	je     8021e4 <malloc+0x92>
  8021d5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021db:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021e0:	39 c2                	cmp    %eax,%edx
  8021e2:	73 0a                	jae    8021ee <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8021e4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021e9:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8021ee:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8021f3:	83 f8 05             	cmp    $0x5,%eax
  8021f6:	75 11                	jne    802209 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8021f8:	83 ec 0c             	sub    $0xc,%esp
  8021fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8021fe:	e8 ff f9 ff ff       	call   801c02 <alloc_pages_custom_fit>
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220d:	0f 84 be 00 00 00    	je     8022d1 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	ff 75 f4             	pushl  -0xc(%ebp)
  80221f:	e8 9a fb ff ff       	call   801dbe <find_allocated_size>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80222a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80222e:	75 17                	jne    802247 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802230:	ff 75 f4             	pushl  -0xc(%ebp)
  802233:	68 3c 49 80 00       	push   $0x80493c
  802238:	68 24 01 00 00       	push   $0x124
  80223d:	68 f1 46 80 00       	push   $0x8046f1
  802242:	e8 f2 e5 ff ff       	call   800839 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224a:	f7 d0                	not    %eax
  80224c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80224f:	73 1d                	jae    80226e <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	ff 75 e0             	pushl  -0x20(%ebp)
  802257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80225a:	68 84 49 80 00       	push   $0x804984
  80225f:	68 29 01 00 00       	push   $0x129
  802264:	68 f1 46 80 00       	push   $0x8046f1
  802269:	e8 cb e5 ff ff       	call   800839 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  80226e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802274:	01 d0                	add    %edx,%eax
  802276:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802279:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	79 2c                	jns    8022ac <malloc+0x15a>
  802280:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802287:	77 23                	ja     8022ac <malloc+0x15a>
  802289:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802290:	77 1a                	ja     8022ac <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802292:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	79 13                	jns    8022ac <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802299:	83 ec 08             	sub    $0x8,%esp
  80229c:	ff 75 e0             	pushl  -0x20(%ebp)
  80229f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022a2:	e8 de 09 00 00       	call   802c85 <sys_allocate_user_mem>
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	eb 25                	jmp    8022d1 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  8022ac:	68 00 00 00 a0       	push   $0xa0000000
  8022b1:	ff 75 dc             	pushl  -0x24(%ebp)
  8022b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8022b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8022bd:	68 c0 49 80 00       	push   $0x8049c0
  8022c2:	68 33 01 00 00       	push   $0x133
  8022c7:	68 f1 46 80 00       	push   $0x8046f1
  8022cc:	e8 68 e5 ff ff       	call   800839 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8022dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e0:	0f 84 26 01 00 00    	je     80240c <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	79 1c                	jns    80230f <free+0x39>
  8022f3:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8022fa:	77 13                	ja     80230f <free+0x39>
		free_block(virtual_address);
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	ff 75 08             	pushl  0x8(%ebp)
  802302:	e8 21 12 00 00       	call   803528 <free_block>
  802307:	83 c4 10             	add    $0x10,%esp
		return;
  80230a:	e9 01 01 00 00       	jmp    802410 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  80230f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802314:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802317:	0f 82 d8 00 00 00    	jb     8023f5 <free+0x11f>
  80231d:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802324:	0f 87 cb 00 00 00    	ja     8023f5 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	74 17                	je     80234d <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802336:	ff 75 08             	pushl  0x8(%ebp)
  802339:	68 30 4a 80 00       	push   $0x804a30
  80233e:	68 57 01 00 00       	push   $0x157
  802343:	68 f1 46 80 00       	push   $0x8046f1
  802348:	e8 ec e4 ff ff       	call   800839 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  80234d:	83 ec 0c             	sub    $0xc,%esp
  802350:	ff 75 08             	pushl  0x8(%ebp)
  802353:	e8 66 fa ff ff       	call   801dbe <find_allocated_size>
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  80235e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802362:	0f 84 a7 00 00 00    	je     80240f <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	f7 d0                	not    %eax
  80236d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802370:	73 1d                	jae    80238f <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802372:	83 ec 0c             	sub    $0xc,%esp
  802375:	ff 75 f0             	pushl  -0x10(%ebp)
  802378:	ff 75 f4             	pushl  -0xc(%ebp)
  80237b:	68 58 4a 80 00       	push   $0x804a58
  802380:	68 61 01 00 00       	push   $0x161
  802385:	68 f1 46 80 00       	push   $0x8046f1
  80238a:	e8 aa e4 ff ff       	call   800839 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  80238f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802395:	01 d0                	add    %edx,%eax
  802397:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	79 19                	jns    8023ba <free+0xe4>
  8023a1:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8023a8:	77 10                	ja     8023ba <free+0xe4>
  8023aa:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8023b1:	77 07                	ja     8023ba <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8023b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	78 2b                	js     8023e5 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8023ba:	83 ec 0c             	sub    $0xc,%esp
  8023bd:	68 00 00 00 a0       	push   $0xa0000000
  8023c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8023c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ce:	ff 75 08             	pushl  0x8(%ebp)
  8023d1:	68 94 4a 80 00       	push   $0x804a94
  8023d6:	68 69 01 00 00       	push   $0x169
  8023db:	68 f1 46 80 00       	push   $0x8046f1
  8023e0:	e8 54 e4 ff ff       	call   800839 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8023e5:	83 ec 0c             	sub    $0xc,%esp
  8023e8:	ff 75 08             	pushl  0x8(%ebp)
  8023eb:	e8 2c fa ff ff       	call   801e1c <free_pages>
  8023f0:	83 c4 10             	add    $0x10,%esp
		return;
  8023f3:	eb 1b                	jmp    802410 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8023f5:	ff 75 08             	pushl  0x8(%ebp)
  8023f8:	68 f0 4a 80 00       	push   $0x804af0
  8023fd:	68 70 01 00 00       	push   $0x170
  802402:	68 f1 46 80 00       	push   $0x8046f1
  802407:	e8 2d e4 ff ff       	call   800839 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80240c:	90                   	nop
  80240d:	eb 01                	jmp    802410 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80240f:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 38             	sub    $0x38,%esp
  802418:	8b 45 10             	mov    0x10(%ebp),%eax
  80241b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80241e:	e8 2e fc ff ff       	call   802051 <uheap_init>
	if (size == 0) return NULL ;
  802423:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802427:	75 0a                	jne    802433 <smalloc+0x21>
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
  80242e:	e9 3d 01 00 00       	jmp    802570 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802433:	8b 45 0c             	mov    0xc(%ebp),%eax
  802436:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802439:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243c:	25 ff 0f 00 00       	and    $0xfff,%eax
  802441:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802444:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802448:	74 0e                	je     802458 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802450:	05 00 10 00 00       	add    $0x1000,%eax
  802455:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	c1 e8 0c             	shr    $0xc,%eax
  80245e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802461:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802466:	85 c0                	test   %eax,%eax
  802468:	75 0a                	jne    802474 <smalloc+0x62>
		return NULL;
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
  80246f:	e9 fc 00 00 00       	jmp    802570 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802474:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	74 0f                	je     80248c <smalloc+0x7a>
  80247d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802483:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802488:	39 c2                	cmp    %eax,%edx
  80248a:	73 0a                	jae    802496 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  80248c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802491:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802496:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80249b:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8024a0:	29 c2                	sub    %eax,%edx
  8024a2:	89 d0                	mov    %edx,%eax
  8024a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8024a7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8024ad:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8024b2:	29 c2                	sub    %eax,%edx
  8024b4:	89 d0                	mov    %edx,%eax
  8024b6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8024bf:	77 13                	ja     8024d4 <smalloc+0xc2>
  8024c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8024c7:	77 0b                	ja     8024d4 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8024c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024cc:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8024cf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8024d2:	73 0a                	jae    8024de <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d9:	e9 92 00 00 00       	jmp    802570 <smalloc+0x15e>
	}

	void *va = NULL;
  8024de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8024e5:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8024ea:	83 f8 05             	cmp    $0x5,%eax
  8024ed:	75 11                	jne    802500 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8024ef:	83 ec 0c             	sub    $0xc,%esp
  8024f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f5:	e8 08 f7 ff ff       	call   801c02 <alloc_pages_custom_fit>
  8024fa:	83 c4 10             	add    $0x10,%esp
  8024fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802500:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802504:	75 27                	jne    80252d <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802506:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80250d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802510:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802513:	89 c2                	mov    %eax,%edx
  802515:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80251a:	39 c2                	cmp    %eax,%edx
  80251c:	73 07                	jae    802525 <smalloc+0x113>
			return NULL;}
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	eb 4b                	jmp    802570 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802525:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80252a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80252d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802531:	ff 75 f0             	pushl  -0x10(%ebp)
  802534:	50                   	push   %eax
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	e8 cb 03 00 00       	call   80290b <sys_create_shared_object>
  802540:	83 c4 10             	add    $0x10,%esp
  802543:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802546:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80254a:	79 07                	jns    802553 <smalloc+0x141>
		return NULL;
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
  802551:	eb 1d                	jmp    802570 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802553:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802558:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80255b:	75 10                	jne    80256d <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80255d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	01 d0                	add    %edx,%eax
  802568:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802578:	e8 d4 fa ff ff       	call   802051 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80257d:	83 ec 08             	sub    $0x8,%esp
  802580:	ff 75 0c             	pushl  0xc(%ebp)
  802583:	ff 75 08             	pushl  0x8(%ebp)
  802586:	e8 aa 03 00 00       	call   802935 <sys_size_of_shared_object>
  80258b:	83 c4 10             	add    $0x10,%esp
  80258e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802591:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802595:	7f 0a                	jg     8025a1 <sget+0x2f>
		return NULL;
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	e9 32 01 00 00       	jmp    8026d3 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8025a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8025a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8025af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8025b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025b6:	74 0e                	je     8025c6 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8025be:	05 00 10 00 00       	add    $0x1000,%eax
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8025c6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	75 0a                	jne    8025d9 <sget+0x67>
		return NULL;
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d4:	e9 fa 00 00 00       	jmp    8026d3 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8025d9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	74 0f                	je     8025f1 <sget+0x7f>
  8025e2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8025e8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025ed:	39 c2                	cmp    %eax,%edx
  8025ef:	73 0a                	jae    8025fb <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8025f1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025f6:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8025fb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802600:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802605:	29 c2                	sub    %eax,%edx
  802607:	89 d0                	mov    %edx,%eax
  802609:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80260c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802612:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802617:	29 c2                	sub    %eax,%edx
  802619:	89 d0                	mov    %edx,%eax
  80261b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802624:	77 13                	ja     802639 <sget+0xc7>
  802626:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802629:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80262c:	77 0b                	ja     802639 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80262e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802631:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802634:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802637:	73 0a                	jae    802643 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
  80263e:	e9 90 00 00 00       	jmp    8026d3 <sget+0x161>

	void *va = NULL;
  802643:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80264a:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80264f:	83 f8 05             	cmp    $0x5,%eax
  802652:	75 11                	jne    802665 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802654:	83 ec 0c             	sub    $0xc,%esp
  802657:	ff 75 f4             	pushl  -0xc(%ebp)
  80265a:	e8 a3 f5 ff ff       	call   801c02 <alloc_pages_custom_fit>
  80265f:	83 c4 10             	add    $0x10,%esp
  802662:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802665:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802669:	75 27                	jne    802692 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80266b:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802675:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802678:	89 c2                	mov    %eax,%edx
  80267a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80267f:	39 c2                	cmp    %eax,%edx
  802681:	73 07                	jae    80268a <sget+0x118>
			return NULL;
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	eb 49                	jmp    8026d3 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80268a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80268f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802692:	83 ec 04             	sub    $0x4,%esp
  802695:	ff 75 f0             	pushl  -0x10(%ebp)
  802698:	ff 75 0c             	pushl  0xc(%ebp)
  80269b:	ff 75 08             	pushl  0x8(%ebp)
  80269e:	e8 af 02 00 00       	call   802952 <sys_get_shared_object>
  8026a3:	83 c4 10             	add    $0x10,%esp
  8026a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8026a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8026ad:	79 07                	jns    8026b6 <sget+0x144>
		return NULL;
  8026af:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b4:	eb 1d                	jmp    8026d3 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8026b6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026bb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8026be:	75 10                	jne    8026d0 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8026c0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	01 d0                	add    %edx,%eax
  8026cb:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8026d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026db:	e8 71 f9 ff ff       	call   802051 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8026e0:	83 ec 04             	sub    $0x4,%esp
  8026e3:	68 14 4b 80 00       	push   $0x804b14
  8026e8:	68 19 02 00 00       	push   $0x219
  8026ed:	68 f1 46 80 00       	push   $0x8046f1
  8026f2:	e8 42 e1 ff ff       	call   800839 <_panic>

008026f7 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	68 3c 4b 80 00       	push   $0x804b3c
  802705:	68 2b 02 00 00       	push   $0x22b
  80270a:	68 f1 46 80 00       	push   $0x8046f1
  80270f:	e8 25 e1 ff ff       	call   800839 <_panic>

00802714 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	57                   	push   %edi
  802718:	56                   	push   %esi
  802719:	53                   	push   %ebx
  80271a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	8b 55 0c             	mov    0xc(%ebp),%edx
  802723:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802726:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802729:	8b 7d 18             	mov    0x18(%ebp),%edi
  80272c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80272f:	cd 30                	int    $0x30
  802731:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802734:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802737:	83 c4 10             	add    $0x10,%esp
  80273a:	5b                   	pop    %ebx
  80273b:	5e                   	pop    %esi
  80273c:	5f                   	pop    %edi
  80273d:	5d                   	pop    %ebp
  80273e:	c3                   	ret    

0080273f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
  802742:	83 ec 04             	sub    $0x4,%esp
  802745:	8b 45 10             	mov    0x10(%ebp),%eax
  802748:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80274b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80274e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	6a 00                	push   $0x0
  802757:	51                   	push   %ecx
  802758:	52                   	push   %edx
  802759:	ff 75 0c             	pushl  0xc(%ebp)
  80275c:	50                   	push   %eax
  80275d:	6a 00                	push   $0x0
  80275f:	e8 b0 ff ff ff       	call   802714 <syscall>
  802764:	83 c4 18             	add    $0x18,%esp
}
  802767:	90                   	nop
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_cgetc>:

int
sys_cgetc(void)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 02                	push   $0x2
  802779:	e8 96 ff ff ff       	call   802714 <syscall>
  80277e:	83 c4 18             	add    $0x18,%esp
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 03                	push   $0x3
  802792:	e8 7d ff ff ff       	call   802714 <syscall>
  802797:	83 c4 18             	add    $0x18,%esp
}
  80279a:	90                   	nop
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 04                	push   $0x4
  8027ac:	e8 63 ff ff ff       	call   802714 <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
}
  8027b4:	90                   	nop
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	52                   	push   %edx
  8027c7:	50                   	push   %eax
  8027c8:	6a 08                	push   $0x8
  8027ca:	e8 45 ff ff ff       	call   802714 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	56                   	push   %esi
  8027d8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8027dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	56                   	push   %esi
  8027e9:	53                   	push   %ebx
  8027ea:	51                   	push   %ecx
  8027eb:	52                   	push   %edx
  8027ec:	50                   	push   %eax
  8027ed:	6a 09                	push   $0x9
  8027ef:	e8 20 ff ff ff       	call   802714 <syscall>
  8027f4:	83 c4 18             	add    $0x18,%esp
}
  8027f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027fa:	5b                   	pop    %ebx
  8027fb:	5e                   	pop    %esi
  8027fc:	5d                   	pop    %ebp
  8027fd:	c3                   	ret    

008027fe <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 00                	push   $0x0
  802809:	ff 75 08             	pushl  0x8(%ebp)
  80280c:	6a 0a                	push   $0xa
  80280e:	e8 01 ff ff ff       	call   802714 <syscall>
  802813:	83 c4 18             	add    $0x18,%esp
}
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	ff 75 0c             	pushl  0xc(%ebp)
  802824:	ff 75 08             	pushl  0x8(%ebp)
  802827:	6a 0b                	push   $0xb
  802829:	e8 e6 fe ff ff       	call   802714 <syscall>
  80282e:	83 c4 18             	add    $0x18,%esp
}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 0c                	push   $0xc
  802842:	e8 cd fe ff ff       	call   802714 <syscall>
  802847:	83 c4 18             	add    $0x18,%esp
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	6a 0d                	push   $0xd
  80285b:	e8 b4 fe ff ff       	call   802714 <syscall>
  802860:	83 c4 18             	add    $0x18,%esp
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 0e                	push   $0xe
  802874:	e8 9b fe ff ff       	call   802714 <syscall>
  802879:	83 c4 18             	add    $0x18,%esp
}
  80287c:	c9                   	leave  
  80287d:	c3                   	ret    

0080287e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 0f                	push   $0xf
  80288d:	e8 82 fe ff ff       	call   802714 <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	ff 75 08             	pushl  0x8(%ebp)
  8028a5:	6a 10                	push   $0x10
  8028a7:	e8 68 fe ff ff       	call   802714 <syscall>
  8028ac:	83 c4 18             	add    $0x18,%esp
}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    

008028b1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 11                	push   $0x11
  8028c0:	e8 4f fe ff ff       	call   802714 <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
}
  8028c8:	90                   	nop
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <sys_cputc>:

void
sys_cputc(const char c)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	50                   	push   %eax
  8028e4:	6a 01                	push   $0x1
  8028e6:	e8 29 fe ff ff       	call   802714 <syscall>
  8028eb:	83 c4 18             	add    $0x18,%esp
}
  8028ee:	90                   	nop
  8028ef:	c9                   	leave  
  8028f0:	c3                   	ret    

008028f1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028f1:	55                   	push   %ebp
  8028f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 14                	push   $0x14
  802900:	e8 0f fe ff ff       	call   802714 <syscall>
  802905:	83 c4 18             	add    $0x18,%esp
}
  802908:	90                   	nop
  802909:	c9                   	leave  
  80290a:	c3                   	ret    

0080290b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	8b 45 10             	mov    0x10(%ebp),%eax
  802914:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802917:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80291a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	6a 00                	push   $0x0
  802923:	51                   	push   %ecx
  802924:	52                   	push   %edx
  802925:	ff 75 0c             	pushl  0xc(%ebp)
  802928:	50                   	push   %eax
  802929:	6a 15                	push   $0x15
  80292b:	e8 e4 fd ff ff       	call   802714 <syscall>
  802930:	83 c4 18             	add    $0x18,%esp
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	52                   	push   %edx
  802945:	50                   	push   %eax
  802946:	6a 16                	push   $0x16
  802948:	e8 c7 fd ff ff       	call   802714 <syscall>
  80294d:	83 c4 18             	add    $0x18,%esp
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802955:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	51                   	push   %ecx
  802963:	52                   	push   %edx
  802964:	50                   	push   %eax
  802965:	6a 17                	push   $0x17
  802967:	e8 a8 fd ff ff       	call   802714 <syscall>
  80296c:	83 c4 18             	add    $0x18,%esp
}
  80296f:	c9                   	leave  
  802970:	c3                   	ret    

00802971 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802971:	55                   	push   %ebp
  802972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802974:	8b 55 0c             	mov    0xc(%ebp),%edx
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	52                   	push   %edx
  802981:	50                   	push   %eax
  802982:	6a 18                	push   $0x18
  802984:	e8 8b fd ff ff       	call   802714 <syscall>
  802989:	83 c4 18             	add    $0x18,%esp
}
  80298c:	c9                   	leave  
  80298d:	c3                   	ret    

0080298e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80298e:	55                   	push   %ebp
  80298f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	6a 00                	push   $0x0
  802996:	ff 75 14             	pushl  0x14(%ebp)
  802999:	ff 75 10             	pushl  0x10(%ebp)
  80299c:	ff 75 0c             	pushl  0xc(%ebp)
  80299f:	50                   	push   %eax
  8029a0:	6a 19                	push   $0x19
  8029a2:	e8 6d fd ff ff       	call   802714 <syscall>
  8029a7:	83 c4 18             	add    $0x18,%esp
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <sys_run_env>:

void sys_run_env(int32 envId)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	6a 00                	push   $0x0
  8029b4:	6a 00                	push   $0x0
  8029b6:	6a 00                	push   $0x0
  8029b8:	6a 00                	push   $0x0
  8029ba:	50                   	push   %eax
  8029bb:	6a 1a                	push   $0x1a
  8029bd:	e8 52 fd ff ff       	call   802714 <syscall>
  8029c2:	83 c4 18             	add    $0x18,%esp
}
  8029c5:	90                   	nop
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	50                   	push   %eax
  8029d7:	6a 1b                	push   $0x1b
  8029d9:	e8 36 fd ff ff       	call   802714 <syscall>
  8029de:	83 c4 18             	add    $0x18,%esp
}
  8029e1:	c9                   	leave  
  8029e2:	c3                   	ret    

008029e3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029e3:	55                   	push   %ebp
  8029e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 05                	push   $0x5
  8029f2:	e8 1d fd ff ff       	call   802714 <syscall>
  8029f7:	83 c4 18             	add    $0x18,%esp
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8029ff:	6a 00                	push   $0x0
  802a01:	6a 00                	push   $0x0
  802a03:	6a 00                	push   $0x0
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 06                	push   $0x6
  802a0b:	e8 04 fd ff ff       	call   802714 <syscall>
  802a10:	83 c4 18             	add    $0x18,%esp
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 07                	push   $0x7
  802a24:	e8 eb fc ff ff       	call   802714 <syscall>
  802a29:	83 c4 18             	add    $0x18,%esp
}
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <sys_exit_env>:


void sys_exit_env(void)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 1c                	push   $0x1c
  802a3d:	e8 d2 fc ff ff       	call   802714 <syscall>
  802a42:	83 c4 18             	add    $0x18,%esp
}
  802a45:	90                   	nop
  802a46:	c9                   	leave  
  802a47:	c3                   	ret    

00802a48 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a4e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a51:	8d 50 04             	lea    0x4(%eax),%edx
  802a54:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	52                   	push   %edx
  802a5e:	50                   	push   %eax
  802a5f:	6a 1d                	push   $0x1d
  802a61:	e8 ae fc ff ff       	call   802714 <syscall>
  802a66:	83 c4 18             	add    $0x18,%esp
	return result;
  802a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a72:	89 01                	mov    %eax,(%ecx)
  802a74:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	c9                   	leave  
  802a7b:	c2 04 00             	ret    $0x4

00802a7e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a7e:	55                   	push   %ebp
  802a7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	ff 75 10             	pushl  0x10(%ebp)
  802a88:	ff 75 0c             	pushl  0xc(%ebp)
  802a8b:	ff 75 08             	pushl  0x8(%ebp)
  802a8e:	6a 13                	push   $0x13
  802a90:	e8 7f fc ff ff       	call   802714 <syscall>
  802a95:	83 c4 18             	add    $0x18,%esp
	return ;
  802a98:	90                   	nop
}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <sys_rcr2>:
uint32 sys_rcr2()
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 1e                	push   $0x1e
  802aaa:	e8 65 fc ff ff       	call   802714 <syscall>
  802aaf:	83 c4 18             	add    $0x18,%esp
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	83 ec 04             	sub    $0x4,%esp
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ac0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	50                   	push   %eax
  802acd:	6a 1f                	push   $0x1f
  802acf:	e8 40 fc ff ff       	call   802714 <syscall>
  802ad4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ad7:	90                   	nop
}
  802ad8:	c9                   	leave  
  802ad9:	c3                   	ret    

00802ada <rsttst>:
void rsttst()
{
  802ada:	55                   	push   %ebp
  802adb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802add:	6a 00                	push   $0x0
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 21                	push   $0x21
  802ae9:	e8 26 fc ff ff       	call   802714 <syscall>
  802aee:	83 c4 18             	add    $0x18,%esp
	return ;
  802af1:	90                   	nop
}
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
  802af7:	83 ec 04             	sub    $0x4,%esp
  802afa:	8b 45 14             	mov    0x14(%ebp),%eax
  802afd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b00:	8b 55 18             	mov    0x18(%ebp),%edx
  802b03:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b07:	52                   	push   %edx
  802b08:	50                   	push   %eax
  802b09:	ff 75 10             	pushl  0x10(%ebp)
  802b0c:	ff 75 0c             	pushl  0xc(%ebp)
  802b0f:	ff 75 08             	pushl  0x8(%ebp)
  802b12:	6a 20                	push   $0x20
  802b14:	e8 fb fb ff ff       	call   802714 <syscall>
  802b19:	83 c4 18             	add    $0x18,%esp
	return ;
  802b1c:	90                   	nop
}
  802b1d:	c9                   	leave  
  802b1e:	c3                   	ret    

00802b1f <chktst>:
void chktst(uint32 n)
{
  802b1f:	55                   	push   %ebp
  802b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	ff 75 08             	pushl  0x8(%ebp)
  802b2d:	6a 22                	push   $0x22
  802b2f:	e8 e0 fb ff ff       	call   802714 <syscall>
  802b34:	83 c4 18             	add    $0x18,%esp
	return ;
  802b37:	90                   	nop
}
  802b38:	c9                   	leave  
  802b39:	c3                   	ret    

00802b3a <inctst>:

void inctst()
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 23                	push   $0x23
  802b49:	e8 c6 fb ff ff       	call   802714 <syscall>
  802b4e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b51:	90                   	nop
}
  802b52:	c9                   	leave  
  802b53:	c3                   	ret    

00802b54 <gettst>:
uint32 gettst()
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 24                	push   $0x24
  802b63:	e8 ac fb ff ff       	call   802714 <syscall>
  802b68:	83 c4 18             	add    $0x18,%esp
}
  802b6b:	c9                   	leave  
  802b6c:	c3                   	ret    

00802b6d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802b6d:	55                   	push   %ebp
  802b6e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 25                	push   $0x25
  802b7c:	e8 93 fb ff ff       	call   802714 <syscall>
  802b81:	83 c4 18             	add    $0x18,%esp
  802b84:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802b89:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802b8e:	c9                   	leave  
  802b8f:	c3                   	ret    

00802b90 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	ff 75 08             	pushl  0x8(%ebp)
  802ba6:	6a 26                	push   $0x26
  802ba8:	e8 67 fb ff ff       	call   802714 <syscall>
  802bad:	83 c4 18             	add    $0x18,%esp
	return ;
  802bb0:	90                   	nop
}
  802bb1:	c9                   	leave  
  802bb2:	c3                   	ret    

00802bb3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802bb3:	55                   	push   %ebp
  802bb4:	89 e5                	mov    %esp,%ebp
  802bb6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802bb7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802bba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	6a 00                	push   $0x0
  802bc5:	53                   	push   %ebx
  802bc6:	51                   	push   %ecx
  802bc7:	52                   	push   %edx
  802bc8:	50                   	push   %eax
  802bc9:	6a 27                	push   $0x27
  802bcb:	e8 44 fb ff ff       	call   802714 <syscall>
  802bd0:	83 c4 18             	add    $0x18,%esp
}
  802bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bd6:	c9                   	leave  
  802bd7:	c3                   	ret    

00802bd8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802bd8:	55                   	push   %ebp
  802bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	52                   	push   %edx
  802be8:	50                   	push   %eax
  802be9:	6a 28                	push   $0x28
  802beb:	e8 24 fb ff ff       	call   802714 <syscall>
  802bf0:	83 c4 18             	add    $0x18,%esp
}
  802bf3:	c9                   	leave  
  802bf4:	c3                   	ret    

00802bf5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802bf5:	55                   	push   %ebp
  802bf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802bf8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	6a 00                	push   $0x0
  802c03:	51                   	push   %ecx
  802c04:	ff 75 10             	pushl  0x10(%ebp)
  802c07:	52                   	push   %edx
  802c08:	50                   	push   %eax
  802c09:	6a 29                	push   $0x29
  802c0b:	e8 04 fb ff ff       	call   802714 <syscall>
  802c10:	83 c4 18             	add    $0x18,%esp
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    

00802c15 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	ff 75 10             	pushl  0x10(%ebp)
  802c1f:	ff 75 0c             	pushl  0xc(%ebp)
  802c22:	ff 75 08             	pushl  0x8(%ebp)
  802c25:	6a 12                	push   $0x12
  802c27:	e8 e8 fa ff ff       	call   802714 <syscall>
  802c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  802c2f:	90                   	nop
}
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    

00802c32 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	52                   	push   %edx
  802c42:	50                   	push   %eax
  802c43:	6a 2a                	push   $0x2a
  802c45:	e8 ca fa ff ff       	call   802714 <syscall>
  802c4a:	83 c4 18             	add    $0x18,%esp
	return;
  802c4d:	90                   	nop
}
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	6a 00                	push   $0x0
  802c59:	6a 00                	push   $0x0
  802c5b:	6a 00                	push   $0x0
  802c5d:	6a 2b                	push   $0x2b
  802c5f:	e8 b0 fa ff ff       	call   802714 <syscall>
  802c64:	83 c4 18             	add    $0x18,%esp
}
  802c67:	c9                   	leave  
  802c68:	c3                   	ret    

00802c69 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802c6c:	6a 00                	push   $0x0
  802c6e:	6a 00                	push   $0x0
  802c70:	6a 00                	push   $0x0
  802c72:	ff 75 0c             	pushl  0xc(%ebp)
  802c75:	ff 75 08             	pushl  0x8(%ebp)
  802c78:	6a 2d                	push   $0x2d
  802c7a:	e8 95 fa ff ff       	call   802714 <syscall>
  802c7f:	83 c4 18             	add    $0x18,%esp
	return;
  802c82:	90                   	nop
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 00                	push   $0x0
  802c8c:	6a 00                	push   $0x0
  802c8e:	ff 75 0c             	pushl  0xc(%ebp)
  802c91:	ff 75 08             	pushl  0x8(%ebp)
  802c94:	6a 2c                	push   $0x2c
  802c96:	e8 79 fa ff ff       	call   802714 <syscall>
  802c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c9e:	90                   	nop
}
  802c9f:	c9                   	leave  
  802ca0:	c3                   	ret    

00802ca1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	6a 00                	push   $0x0
  802cac:	6a 00                	push   $0x0
  802cae:	6a 00                	push   $0x0
  802cb0:	52                   	push   %edx
  802cb1:	50                   	push   %eax
  802cb2:	6a 2e                	push   $0x2e
  802cb4:	e8 5b fa ff ff       	call   802714 <syscall>
  802cb9:	83 c4 18             	add    $0x18,%esp
	return ;
  802cbc:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802cbd:	c9                   	leave  
  802cbe:	c3                   	ret    

00802cbf <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802cbf:	55                   	push   %ebp
  802cc0:	89 e5                	mov    %esp,%ebp
  802cc2:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802cc5:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802ccc:	72 09                	jb     802cd7 <to_page_va+0x18>
  802cce:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802cd5:	72 14                	jb     802ceb <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802cd7:	83 ec 04             	sub    $0x4,%esp
  802cda:	68 60 4b 80 00       	push   $0x804b60
  802cdf:	6a 15                	push   $0x15
  802ce1:	68 8b 4b 80 00       	push   $0x804b8b
  802ce6:	e8 4e db ff ff       	call   800839 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	ba 60 50 80 00       	mov    $0x805060,%edx
  802cf3:	29 d0                	sub    %edx,%eax
  802cf5:	c1 f8 02             	sar    $0x2,%eax
  802cf8:	89 c2                	mov    %eax,%edx
  802cfa:	89 d0                	mov    %edx,%eax
  802cfc:	c1 e0 02             	shl    $0x2,%eax
  802cff:	01 d0                	add    %edx,%eax
  802d01:	c1 e0 02             	shl    $0x2,%eax
  802d04:	01 d0                	add    %edx,%eax
  802d06:	c1 e0 02             	shl    $0x2,%eax
  802d09:	01 d0                	add    %edx,%eax
  802d0b:	89 c1                	mov    %eax,%ecx
  802d0d:	c1 e1 08             	shl    $0x8,%ecx
  802d10:	01 c8                	add    %ecx,%eax
  802d12:	89 c1                	mov    %eax,%ecx
  802d14:	c1 e1 10             	shl    $0x10,%ecx
  802d17:	01 c8                	add    %ecx,%eax
  802d19:	01 c0                	add    %eax,%eax
  802d1b:	01 d0                	add    %edx,%eax
  802d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	c1 e0 0c             	shl    $0xc,%eax
  802d26:	89 c2                	mov    %eax,%edx
  802d28:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d2d:	01 d0                	add    %edx,%eax
}
  802d2f:	c9                   	leave  
  802d30:	c3                   	ret    

00802d31 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802d31:	55                   	push   %ebp
  802d32:	89 e5                	mov    %esp,%ebp
  802d34:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802d37:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3f:	29 c2                	sub    %eax,%edx
  802d41:	89 d0                	mov    %edx,%eax
  802d43:	c1 e8 0c             	shr    $0xc,%eax
  802d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802d49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4d:	78 09                	js     802d58 <to_page_info+0x27>
  802d4f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802d56:	7e 14                	jle    802d6c <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802d58:	83 ec 04             	sub    $0x4,%esp
  802d5b:	68 a4 4b 80 00       	push   $0x804ba4
  802d60:	6a 22                	push   $0x22
  802d62:	68 8b 4b 80 00       	push   $0x804b8b
  802d67:	e8 cd da ff ff       	call   800839 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6f:	89 d0                	mov    %edx,%eax
  802d71:	01 c0                	add    %eax,%eax
  802d73:	01 d0                	add    %edx,%eax
  802d75:	c1 e0 02             	shl    $0x2,%eax
  802d78:	05 60 50 80 00       	add    $0x805060,%eax
}
  802d7d:	c9                   	leave  
  802d7e:	c3                   	ret    

00802d7f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802d7f:	55                   	push   %ebp
  802d80:	89 e5                	mov    %esp,%ebp
  802d82:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	05 00 00 00 02       	add    $0x2000000,%eax
  802d8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d90:	73 16                	jae    802da8 <initialize_dynamic_allocator+0x29>
  802d92:	68 c8 4b 80 00       	push   $0x804bc8
  802d97:	68 ee 4b 80 00       	push   $0x804bee
  802d9c:	6a 34                	push   $0x34
  802d9e:	68 8b 4b 80 00       	push   $0x804b8b
  802da3:	e8 91 da ff ff       	call   800839 <_panic>
		is_initialized = 1;
  802da8:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802daf:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbd:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802dc2:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802dc9:	00 00 00 
  802dcc:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802dd3:	00 00 00 
  802dd6:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802ddd:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802de0:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802de7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dee:	eb 36                	jmp    802e26 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	c1 e0 04             	shl    $0x4,%eax
  802df6:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	c1 e0 04             	shl    $0x4,%eax
  802e07:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	c1 e0 04             	shl    $0x4,%eax
  802e18:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802e23:	ff 45 f4             	incl   -0xc(%ebp)
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e2c:	72 c2                	jb     802df0 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802e2e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e34:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e39:	29 c2                	sub    %eax,%edx
  802e3b:	89 d0                	mov    %edx,%eax
  802e3d:	c1 e8 0c             	shr    $0xc,%eax
  802e40:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802e43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e4a:	e9 c8 00 00 00       	jmp    802f17 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802e4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e52:	89 d0                	mov    %edx,%eax
  802e54:	01 c0                	add    %eax,%eax
  802e56:	01 d0                	add    %edx,%eax
  802e58:	c1 e0 02             	shl    $0x2,%eax
  802e5b:	05 68 50 80 00       	add    $0x805068,%eax
  802e60:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802e65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e68:	89 d0                	mov    %edx,%eax
  802e6a:	01 c0                	add    %eax,%eax
  802e6c:	01 d0                	add    %edx,%eax
  802e6e:	c1 e0 02             	shl    $0x2,%eax
  802e71:	05 6a 50 80 00       	add    $0x80506a,%eax
  802e76:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802e7b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802e81:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e84:	89 c8                	mov    %ecx,%eax
  802e86:	01 c0                	add    %eax,%eax
  802e88:	01 c8                	add    %ecx,%eax
  802e8a:	c1 e0 02             	shl    $0x2,%eax
  802e8d:	05 64 50 80 00       	add    $0x805064,%eax
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e97:	89 d0                	mov    %edx,%eax
  802e99:	01 c0                	add    %eax,%eax
  802e9b:	01 d0                	add    %edx,%eax
  802e9d:	c1 e0 02             	shl    $0x2,%eax
  802ea0:	05 64 50 80 00       	add    $0x805064,%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 1b                	je     802ec6 <initialize_dynamic_allocator+0x147>
  802eab:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802eb1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802eb4:	89 c8                	mov    %ecx,%eax
  802eb6:	01 c0                	add    %eax,%eax
  802eb8:	01 c8                	add    %ecx,%eax
  802eba:	c1 e0 02             	shl    $0x2,%eax
  802ebd:	05 60 50 80 00       	add    $0x805060,%eax
  802ec2:	89 02                	mov    %eax,(%edx)
  802ec4:	eb 16                	jmp    802edc <initialize_dynamic_allocator+0x15d>
  802ec6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec9:	89 d0                	mov    %edx,%eax
  802ecb:	01 c0                	add    %eax,%eax
  802ecd:	01 d0                	add    %edx,%eax
  802ecf:	c1 e0 02             	shl    $0x2,%eax
  802ed2:	05 60 50 80 00       	add    $0x805060,%eax
  802ed7:	a3 48 50 80 00       	mov    %eax,0x805048
  802edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edf:	89 d0                	mov    %edx,%eax
  802ee1:	01 c0                	add    %eax,%eax
  802ee3:	01 d0                	add    %edx,%eax
  802ee5:	c1 e0 02             	shl    $0x2,%eax
  802ee8:	05 60 50 80 00       	add    $0x805060,%eax
  802eed:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ef2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef5:	89 d0                	mov    %edx,%eax
  802ef7:	01 c0                	add    %eax,%eax
  802ef9:	01 d0                	add    %edx,%eax
  802efb:	c1 e0 02             	shl    $0x2,%eax
  802efe:	05 60 50 80 00       	add    $0x805060,%eax
  802f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f09:	a1 54 50 80 00       	mov    0x805054,%eax
  802f0e:	40                   	inc    %eax
  802f0f:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802f14:	ff 45 f0             	incl   -0x10(%ebp)
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f1d:	0f 82 2c ff ff ff    	jb     802e4f <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f29:	eb 2f                	jmp    802f5a <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802f2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f2e:	89 d0                	mov    %edx,%eax
  802f30:	01 c0                	add    %eax,%eax
  802f32:	01 d0                	add    %edx,%eax
  802f34:	c1 e0 02             	shl    $0x2,%eax
  802f37:	05 68 50 80 00       	add    $0x805068,%eax
  802f3c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802f41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f44:	89 d0                	mov    %edx,%eax
  802f46:	01 c0                	add    %eax,%eax
  802f48:	01 d0                	add    %edx,%eax
  802f4a:	c1 e0 02             	shl    $0x2,%eax
  802f4d:	05 6a 50 80 00       	add    $0x80506a,%eax
  802f52:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802f57:	ff 45 ec             	incl   -0x14(%ebp)
  802f5a:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802f61:	76 c8                	jbe    802f2b <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802f63:	90                   	nop
  802f64:	c9                   	leave  
  802f65:	c3                   	ret    

00802f66 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802f66:	55                   	push   %ebp
  802f67:	89 e5                	mov    %esp,%ebp
  802f69:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f74:	29 c2                	sub    %eax,%edx
  802f76:	89 d0                	mov    %edx,%eax
  802f78:	c1 e8 0c             	shr    $0xc,%eax
  802f7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802f7e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f81:	89 d0                	mov    %edx,%eax
  802f83:	01 c0                	add    %eax,%eax
  802f85:	01 d0                	add    %edx,%eax
  802f87:	c1 e0 02             	shl    $0x2,%eax
  802f8a:	05 68 50 80 00       	add    $0x805068,%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802f94:	c9                   	leave  
  802f95:	c3                   	ret    

00802f96 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802f96:	55                   	push   %ebp
  802f97:	89 e5                	mov    %esp,%ebp
  802f99:	83 ec 14             	sub    $0x14,%esp
  802f9c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802f9f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802fa3:	77 07                	ja     802fac <nearest_pow2_ceil.1513+0x16>
  802fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  802faa:	eb 20                	jmp    802fcc <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802fac:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802fb3:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802fb6:	eb 08                	jmp    802fc0 <nearest_pow2_ceil.1513+0x2a>
  802fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fbb:	01 c0                	add    %eax,%eax
  802fbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802fc0:	d1 6d 08             	shrl   0x8(%ebp)
  802fc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc7:	75 ef                	jne    802fb8 <nearest_pow2_ceil.1513+0x22>
        return power;
  802fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802fcc:	c9                   	leave  
  802fcd:	c3                   	ret    

00802fce <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802fce:	55                   	push   %ebp
  802fcf:	89 e5                	mov    %esp,%ebp
  802fd1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802fd4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802fdb:	76 16                	jbe    802ff3 <alloc_block+0x25>
  802fdd:	68 04 4c 80 00       	push   $0x804c04
  802fe2:	68 ee 4b 80 00       	push   $0x804bee
  802fe7:	6a 72                	push   $0x72
  802fe9:	68 8b 4b 80 00       	push   $0x804b8b
  802fee:	e8 46 d8 ff ff       	call   800839 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff7:	75 0a                	jne    803003 <alloc_block+0x35>
  802ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffe:	e9 bd 04 00 00       	jmp    8034c0 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803003:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803010:	73 06                	jae    803018 <alloc_block+0x4a>
        size = min_block_size;
  803012:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803015:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803018:	83 ec 0c             	sub    $0xc,%esp
  80301b:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80301e:	ff 75 08             	pushl  0x8(%ebp)
  803021:	89 c1                	mov    %eax,%ecx
  803023:	e8 6e ff ff ff       	call   802f96 <nearest_pow2_ceil.1513>
  803028:	83 c4 10             	add    $0x10,%esp
  80302b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  80302e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803031:	83 ec 0c             	sub    $0xc,%esp
  803034:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803037:	52                   	push   %edx
  803038:	89 c1                	mov    %eax,%ecx
  80303a:	e8 83 04 00 00       	call   8034c2 <log2_ceil.1520>
  80303f:	83 c4 10             	add    $0x10,%esp
  803042:	83 e8 03             	sub    $0x3,%eax
  803045:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304b:	c1 e0 04             	shl    $0x4,%eax
  80304e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	0f 84 d8 00 00 00    	je     803135 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80305d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803060:	c1 e0 04             	shl    $0x4,%eax
  803063:	05 80 d0 81 00       	add    $0x81d080,%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80306d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803071:	75 17                	jne    80308a <alloc_block+0xbc>
  803073:	83 ec 04             	sub    $0x4,%esp
  803076:	68 25 4c 80 00       	push   $0x804c25
  80307b:	68 98 00 00 00       	push   $0x98
  803080:	68 8b 4b 80 00       	push   $0x804b8b
  803085:	e8 af d7 ff ff       	call   800839 <_panic>
  80308a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 10                	je     8030a3 <alloc_block+0xd5>
  803093:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80309b:	8b 52 04             	mov    0x4(%edx),%edx
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	eb 14                	jmp    8030b7 <alloc_block+0xe9>
  8030a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a6:	8b 40 04             	mov    0x4(%eax),%eax
  8030a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ac:	c1 e2 04             	shl    $0x4,%edx
  8030af:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8030b5:	89 02                	mov    %eax,(%edx)
  8030b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 0f                	je     8030d0 <alloc_block+0x102>
  8030c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c4:	8b 40 04             	mov    0x4(%eax),%eax
  8030c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ca:	8b 12                	mov    (%edx),%edx
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	eb 13                	jmp    8030e3 <alloc_block+0x115>
  8030d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030d8:	c1 e2 04             	shl    $0x4,%edx
  8030db:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8030e1:	89 02                	mov    %eax,(%edx)
  8030e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f9:	c1 e0 04             	shl    $0x4,%eax
  8030fc:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	8d 50 ff             	lea    -0x1(%eax),%edx
  803106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803109:	c1 e0 04             	shl    $0x4,%eax
  80310c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803111:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803113:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803116:	83 ec 0c             	sub    $0xc,%esp
  803119:	50                   	push   %eax
  80311a:	e8 12 fc ff ff       	call   802d31 <to_page_info>
  80311f:	83 c4 10             	add    $0x10,%esp
  803122:	89 c2                	mov    %eax,%edx
  803124:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803128:	48                   	dec    %eax
  803129:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  80312d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803130:	e9 8b 03 00 00       	jmp    8034c0 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803135:	a1 48 50 80 00       	mov    0x805048,%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	0f 84 64 02 00 00    	je     8033a6 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803142:	a1 48 50 80 00       	mov    0x805048,%eax
  803147:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80314a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80314e:	75 17                	jne    803167 <alloc_block+0x199>
  803150:	83 ec 04             	sub    $0x4,%esp
  803153:	68 25 4c 80 00       	push   $0x804c25
  803158:	68 a0 00 00 00       	push   $0xa0
  80315d:	68 8b 4b 80 00       	push   $0x804b8b
  803162:	e8 d2 d6 ff ff       	call   800839 <_panic>
  803167:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 10                	je     803180 <alloc_block+0x1b2>
  803170:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803178:	8b 52 04             	mov    0x4(%edx),%edx
  80317b:	89 50 04             	mov    %edx,0x4(%eax)
  80317e:	eb 0b                	jmp    80318b <alloc_block+0x1bd>
  803180:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803183:	8b 40 04             	mov    0x4(%eax),%eax
  803186:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80318b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	74 0f                	je     8031a4 <alloc_block+0x1d6>
  803195:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80319e:	8b 12                	mov    (%edx),%edx
  8031a0:	89 10                	mov    %edx,(%eax)
  8031a2:	eb 0a                	jmp    8031ae <alloc_block+0x1e0>
  8031a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	a3 48 50 80 00       	mov    %eax,0x805048
  8031ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c1:	a1 54 50 80 00       	mov    0x805054,%eax
  8031c6:	48                   	dec    %eax
  8031c7:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031d2:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8031d6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8031db:	99                   	cltd   
  8031dc:	f7 7d e8             	idivl  -0x18(%ebp)
  8031df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e2:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8031e6:	83 ec 0c             	sub    $0xc,%esp
  8031e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8031ec:	e8 ce fa ff ff       	call   802cbf <to_page_va>
  8031f1:	83 c4 10             	add    $0x10,%esp
  8031f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8031f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031fa:	83 ec 0c             	sub    $0xc,%esp
  8031fd:	50                   	push   %eax
  8031fe:	e8 c0 ee ff ff       	call   8020c3 <get_page>
  803203:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80320d:	e9 aa 00 00 00       	jmp    8032bc <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803219:	89 c2                	mov    %eax,%edx
  80321b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80321e:	01 d0                	add    %edx,%eax
  803220:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803223:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803227:	75 17                	jne    803240 <alloc_block+0x272>
  803229:	83 ec 04             	sub    $0x4,%esp
  80322c:	68 44 4c 80 00       	push   $0x804c44
  803231:	68 aa 00 00 00       	push   $0xaa
  803236:	68 8b 4b 80 00       	push   $0x804b8b
  80323b:	e8 f9 d5 ff ff       	call   800839 <_panic>
  803240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803243:	c1 e0 04             	shl    $0x4,%eax
  803246:	05 84 d0 81 00       	add    $0x81d084,%eax
  80324b:	8b 10                	mov    (%eax),%edx
  80324d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803250:	89 50 04             	mov    %edx,0x4(%eax)
  803253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803256:	8b 40 04             	mov    0x4(%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	74 14                	je     803271 <alloc_block+0x2a3>
  80325d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803260:	c1 e0 04             	shl    $0x4,%eax
  803263:	05 84 d0 81 00       	add    $0x81d084,%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80326d:	89 10                	mov    %edx,(%eax)
  80326f:	eb 11                	jmp    803282 <alloc_block+0x2b4>
  803271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803274:	c1 e0 04             	shl    $0x4,%eax
  803277:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80327d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803280:	89 02                	mov    %eax,(%edx)
  803282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803285:	c1 e0 04             	shl    $0x4,%eax
  803288:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80328e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803291:	89 02                	mov    %eax,(%edx)
  803293:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329f:	c1 e0 04             	shl    $0x4,%eax
  8032a2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	8d 50 01             	lea    0x1(%eax),%edx
  8032ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032af:	c1 e0 04             	shl    $0x4,%eax
  8032b2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032b7:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8032b9:	ff 45 f4             	incl   -0xc(%ebp)
  8032bc:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032c1:	99                   	cltd   
  8032c2:	f7 7d e8             	idivl  -0x18(%ebp)
  8032c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032c8:	0f 8f 44 ff ff ff    	jg     803212 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8032ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d1:	c1 e0 04             	shl    $0x4,%eax
  8032d4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8032d9:	8b 00                	mov    (%eax),%eax
  8032db:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8032de:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032e2:	75 17                	jne    8032fb <alloc_block+0x32d>
  8032e4:	83 ec 04             	sub    $0x4,%esp
  8032e7:	68 25 4c 80 00       	push   $0x804c25
  8032ec:	68 ae 00 00 00       	push   $0xae
  8032f1:	68 8b 4b 80 00       	push   $0x804b8b
  8032f6:	e8 3e d5 ff ff       	call   800839 <_panic>
  8032fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 10                	je     803314 <alloc_block+0x346>
  803304:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80330c:	8b 52 04             	mov    0x4(%edx),%edx
  80330f:	89 50 04             	mov    %edx,0x4(%eax)
  803312:	eb 14                	jmp    803328 <alloc_block+0x35a>
  803314:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803317:	8b 40 04             	mov    0x4(%eax),%eax
  80331a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331d:	c1 e2 04             	shl    $0x4,%edx
  803320:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803326:	89 02                	mov    %eax,(%edx)
  803328:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80332b:	8b 40 04             	mov    0x4(%eax),%eax
  80332e:	85 c0                	test   %eax,%eax
  803330:	74 0f                	je     803341 <alloc_block+0x373>
  803332:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80333b:	8b 12                	mov    (%edx),%edx
  80333d:	89 10                	mov    %edx,(%eax)
  80333f:	eb 13                	jmp    803354 <alloc_block+0x386>
  803341:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803349:	c1 e2 04             	shl    $0x4,%edx
  80334c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803352:	89 02                	mov    %eax,(%edx)
  803354:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803360:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336a:	c1 e0 04             	shl    $0x4,%eax
  80336d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	8d 50 ff             	lea    -0x1(%eax),%edx
  803377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337a:	c1 e0 04             	shl    $0x4,%eax
  80337d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803382:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803384:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803387:	83 ec 0c             	sub    $0xc,%esp
  80338a:	50                   	push   %eax
  80338b:	e8 a1 f9 ff ff       	call   802d31 <to_page_info>
  803390:	83 c4 10             	add    $0x10,%esp
  803393:	89 c2                	mov    %eax,%edx
  803395:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803399:	48                   	dec    %eax
  80339a:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  80339e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033a1:	e9 1a 01 00 00       	jmp    8034c0 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8033a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a9:	40                   	inc    %eax
  8033aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8033ad:	e9 ed 00 00 00       	jmp    80349f <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b5:	c1 e0 04             	shl    $0x4,%eax
  8033b8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	0f 84 d5 00 00 00    	je     80349c <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	c1 e0 04             	shl    $0x4,%eax
  8033cd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8033d7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8033db:	75 17                	jne    8033f4 <alloc_block+0x426>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 25 4c 80 00       	push   $0x804c25
  8033e5:	68 b8 00 00 00       	push   $0xb8
  8033ea:	68 8b 4b 80 00       	push   $0x804b8b
  8033ef:	e8 45 d4 ff ff       	call   800839 <_panic>
  8033f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 10                	je     80340d <alloc_block+0x43f>
  8033fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803405:	8b 52 04             	mov    0x4(%edx),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 14                	jmp    803421 <alloc_block+0x453>
  80340d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803416:	c1 e2 04             	shl    $0x4,%edx
  803419:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80341f:	89 02                	mov    %eax,(%edx)
  803421:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803424:	8b 40 04             	mov    0x4(%eax),%eax
  803427:	85 c0                	test   %eax,%eax
  803429:	74 0f                	je     80343a <alloc_block+0x46c>
  80342b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80342e:	8b 40 04             	mov    0x4(%eax),%eax
  803431:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803434:	8b 12                	mov    (%edx),%edx
  803436:	89 10                	mov    %edx,(%eax)
  803438:	eb 13                	jmp    80344d <alloc_block+0x47f>
  80343a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803442:	c1 e2 04             	shl    $0x4,%edx
  803445:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80344b:	89 02                	mov    %eax,(%edx)
  80344d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803456:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803463:	c1 e0 04             	shl    $0x4,%eax
  803466:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803473:	c1 e0 04             	shl    $0x4,%eax
  803476:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80347b:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  80347d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803480:	83 ec 0c             	sub    $0xc,%esp
  803483:	50                   	push   %eax
  803484:	e8 a8 f8 ff ff       	call   802d31 <to_page_info>
  803489:	83 c4 10             	add    $0x10,%esp
  80348c:	89 c2                	mov    %eax,%edx
  80348e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803492:	48                   	dec    %eax
  803493:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803497:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80349a:	eb 24                	jmp    8034c0 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80349c:	ff 45 f0             	incl   -0x10(%ebp)
  80349f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8034a3:	0f 8e 09 ff ff ff    	jle    8033b2 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	68 67 4c 80 00       	push   $0x804c67
  8034b1:	68 bf 00 00 00       	push   $0xbf
  8034b6:	68 8b 4b 80 00       	push   $0x804b8b
  8034bb:	e8 79 d3 ff ff       	call   800839 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8034c0:	c9                   	leave  
  8034c1:	c3                   	ret    

008034c2 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8034c2:	55                   	push   %ebp
  8034c3:	89 e5                	mov    %esp,%ebp
  8034c5:	83 ec 14             	sub    $0x14,%esp
  8034c8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8034cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034cf:	75 07                	jne    8034d8 <log2_ceil.1520+0x16>
  8034d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d6:	eb 1b                	jmp    8034f3 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8034d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8034df:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8034e2:	eb 06                	jmp    8034ea <log2_ceil.1520+0x28>
            x >>= 1;
  8034e4:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8034e7:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8034ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ee:	75 f4                	jne    8034e4 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8034f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8034f3:	c9                   	leave  
  8034f4:	c3                   	ret    

008034f5 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8034f5:	55                   	push   %ebp
  8034f6:	89 e5                	mov    %esp,%ebp
  8034f8:	83 ec 14             	sub    $0x14,%esp
  8034fb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8034fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803502:	75 07                	jne    80350b <log2_ceil.1547+0x16>
  803504:	b8 00 00 00 00       	mov    $0x0,%eax
  803509:	eb 1b                	jmp    803526 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80350b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803512:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803515:	eb 06                	jmp    80351d <log2_ceil.1547+0x28>
			x >>= 1;
  803517:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80351a:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80351d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803521:	75 f4                	jne    803517 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803523:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803526:	c9                   	leave  
  803527:	c3                   	ret    

00803528 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803528:	55                   	push   %ebp
  803529:	89 e5                	mov    %esp,%ebp
  80352b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80352e:	8b 55 08             	mov    0x8(%ebp),%edx
  803531:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803536:	39 c2                	cmp    %eax,%edx
  803538:	72 0c                	jb     803546 <free_block+0x1e>
  80353a:	8b 55 08             	mov    0x8(%ebp),%edx
  80353d:	a1 40 50 80 00       	mov    0x805040,%eax
  803542:	39 c2                	cmp    %eax,%edx
  803544:	72 19                	jb     80355f <free_block+0x37>
  803546:	68 6c 4c 80 00       	push   $0x804c6c
  80354b:	68 ee 4b 80 00       	push   $0x804bee
  803550:	68 d0 00 00 00       	push   $0xd0
  803555:	68 8b 4b 80 00       	push   $0x804b8b
  80355a:	e8 da d2 ff ff       	call   800839 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80355f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803563:	0f 84 42 03 00 00    	je     8038ab <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803569:	8b 55 08             	mov    0x8(%ebp),%edx
  80356c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803571:	39 c2                	cmp    %eax,%edx
  803573:	72 0c                	jb     803581 <free_block+0x59>
  803575:	8b 55 08             	mov    0x8(%ebp),%edx
  803578:	a1 40 50 80 00       	mov    0x805040,%eax
  80357d:	39 c2                	cmp    %eax,%edx
  80357f:	72 17                	jb     803598 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803581:	83 ec 04             	sub    $0x4,%esp
  803584:	68 a4 4c 80 00       	push   $0x804ca4
  803589:	68 e6 00 00 00       	push   $0xe6
  80358e:	68 8b 4b 80 00       	push   $0x804b8b
  803593:	e8 a1 d2 ff ff       	call   800839 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803598:	8b 55 08             	mov    0x8(%ebp),%edx
  80359b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8035a0:	29 c2                	sub    %eax,%edx
  8035a2:	89 d0                	mov    %edx,%eax
  8035a4:	83 e0 07             	and    $0x7,%eax
  8035a7:	85 c0                	test   %eax,%eax
  8035a9:	74 17                	je     8035c2 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8035ab:	83 ec 04             	sub    $0x4,%esp
  8035ae:	68 d8 4c 80 00       	push   $0x804cd8
  8035b3:	68 ea 00 00 00       	push   $0xea
  8035b8:	68 8b 4b 80 00       	push   $0x804b8b
  8035bd:	e8 77 d2 ff ff       	call   800839 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	83 ec 0c             	sub    $0xc,%esp
  8035c8:	50                   	push   %eax
  8035c9:	e8 63 f7 ff ff       	call   802d31 <to_page_info>
  8035ce:	83 c4 10             	add    $0x10,%esp
  8035d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8035d4:	83 ec 0c             	sub    $0xc,%esp
  8035d7:	ff 75 08             	pushl  0x8(%ebp)
  8035da:	e8 87 f9 ff ff       	call   802f66 <get_block_size>
  8035df:	83 c4 10             	add    $0x10,%esp
  8035e2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8035e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035e9:	75 17                	jne    803602 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	68 04 4d 80 00       	push   $0x804d04
  8035f3:	68 f1 00 00 00       	push   $0xf1
  8035f8:	68 8b 4b 80 00       	push   $0x804b8b
  8035fd:	e8 37 d2 ff ff       	call   800839 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803602:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803605:	83 ec 0c             	sub    $0xc,%esp
  803608:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80360b:	52                   	push   %edx
  80360c:	89 c1                	mov    %eax,%ecx
  80360e:	e8 e2 fe ff ff       	call   8034f5 <log2_ceil.1547>
  803613:	83 c4 10             	add    $0x10,%esp
  803616:	83 e8 03             	sub    $0x3,%eax
  803619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803622:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803626:	75 17                	jne    80363f <free_block+0x117>
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	68 50 4d 80 00       	push   $0x804d50
  803630:	68 f6 00 00 00       	push   $0xf6
  803635:	68 8b 4b 80 00       	push   $0x804b8b
  80363a:	e8 fa d1 ff ff       	call   800839 <_panic>
  80363f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803642:	c1 e0 04             	shl    $0x4,%eax
  803645:	05 80 d0 81 00       	add    $0x81d080,%eax
  80364a:	8b 10                	mov    (%eax),%edx
  80364c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80364f:	89 10                	mov    %edx,(%eax)
  803651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	85 c0                	test   %eax,%eax
  803658:	74 15                	je     80366f <free_block+0x147>
  80365a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365d:	c1 e0 04             	shl    $0x4,%eax
  803660:	05 80 d0 81 00       	add    $0x81d080,%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80366a:	89 50 04             	mov    %edx,0x4(%eax)
  80366d:	eb 11                	jmp    803680 <free_block+0x158>
  80366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803672:	c1 e0 04             	shl    $0x4,%eax
  803675:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80367b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80367e:	89 02                	mov    %eax,(%edx)
  803680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803683:	c1 e0 04             	shl    $0x4,%eax
  803686:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80368c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80368f:	89 02                	mov    %eax,(%edx)
  803691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803694:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369e:	c1 e0 04             	shl    $0x4,%eax
  8036a1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	8d 50 01             	lea    0x1(%eax),%edx
  8036ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ae:	c1 e0 04             	shl    $0x4,%eax
  8036b1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8036b6:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8036b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036bb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8036bf:	40                   	inc    %eax
  8036c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036c3:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8036c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ca:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036cf:	29 c2                	sub    %eax,%edx
  8036d1:	89 d0                	mov    %edx,%eax
  8036d3:	c1 e8 0c             	shr    $0xc,%eax
  8036d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8036d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036dc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8036e0:	0f b7 c8             	movzwl %ax,%ecx
  8036e3:	b8 00 10 00 00       	mov    $0x1000,%eax
  8036e8:	99                   	cltd   
  8036e9:	f7 7d e8             	idivl  -0x18(%ebp)
  8036ec:	39 c1                	cmp    %eax,%ecx
  8036ee:	0f 85 b8 01 00 00    	jne    8038ac <free_block+0x384>
    	uint32 blocks_removed = 0;
  8036f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8036fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fe:	c1 e0 04             	shl    $0x4,%eax
  803701:	05 80 d0 81 00       	add    $0x81d080,%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80370b:	e9 d5 00 00 00       	jmp    8037e5 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803713:	8b 00                	mov    (%eax),%eax
  803715:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80371b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803720:	29 c2                	sub    %eax,%edx
  803722:	89 d0                	mov    %edx,%eax
  803724:	c1 e8 0c             	shr    $0xc,%eax
  803727:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80372a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803730:	0f 85 a9 00 00 00    	jne    8037df <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80373a:	75 17                	jne    803753 <free_block+0x22b>
  80373c:	83 ec 04             	sub    $0x4,%esp
  80373f:	68 25 4c 80 00       	push   $0x804c25
  803744:	68 04 01 00 00       	push   $0x104
  803749:	68 8b 4b 80 00       	push   $0x804b8b
  80374e:	e8 e6 d0 ff ff       	call   800839 <_panic>
  803753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	85 c0                	test   %eax,%eax
  80375a:	74 10                	je     80376c <free_block+0x244>
  80375c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375f:	8b 00                	mov    (%eax),%eax
  803761:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803764:	8b 52 04             	mov    0x4(%edx),%edx
  803767:	89 50 04             	mov    %edx,0x4(%eax)
  80376a:	eb 14                	jmp    803780 <free_block+0x258>
  80376c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376f:	8b 40 04             	mov    0x4(%eax),%eax
  803772:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803775:	c1 e2 04             	shl    $0x4,%edx
  803778:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80377e:	89 02                	mov    %eax,(%edx)
  803780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803783:	8b 40 04             	mov    0x4(%eax),%eax
  803786:	85 c0                	test   %eax,%eax
  803788:	74 0f                	je     803799 <free_block+0x271>
  80378a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378d:	8b 40 04             	mov    0x4(%eax),%eax
  803790:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803793:	8b 12                	mov    (%edx),%edx
  803795:	89 10                	mov    %edx,(%eax)
  803797:	eb 13                	jmp    8037ac <free_block+0x284>
  803799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a1:	c1 e2 04             	shl    $0x4,%edx
  8037a4:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8037aa:	89 02                	mov    %eax,(%edx)
  8037ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c2:	c1 e0 04             	shl    $0x4,%eax
  8037c5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037ca:	8b 00                	mov    (%eax),%eax
  8037cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d2:	c1 e0 04             	shl    $0x4,%eax
  8037d5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037da:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8037dc:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8037df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8037e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037e9:	0f 85 21 ff ff ff    	jne    803710 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8037ef:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037f4:	99                   	cltd   
  8037f5:	f7 7d e8             	idivl  -0x18(%ebp)
  8037f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037fb:	74 17                	je     803814 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8037fd:	83 ec 04             	sub    $0x4,%esp
  803800:	68 74 4d 80 00       	push   $0x804d74
  803805:	68 0c 01 00 00       	push   $0x10c
  80380a:	68 8b 4b 80 00       	push   $0x804b8b
  80380f:	e8 25 d0 ff ff       	call   800839 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803814:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803817:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80381d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803820:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803826:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80382a:	75 17                	jne    803843 <free_block+0x31b>
  80382c:	83 ec 04             	sub    $0x4,%esp
  80382f:	68 44 4c 80 00       	push   $0x804c44
  803834:	68 11 01 00 00       	push   $0x111
  803839:	68 8b 4b 80 00       	push   $0x804b8b
  80383e:	e8 f6 cf ff ff       	call   800839 <_panic>
  803843:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80384c:	89 50 04             	mov    %edx,0x4(%eax)
  80384f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	85 c0                	test   %eax,%eax
  803857:	74 0c                	je     803865 <free_block+0x33d>
  803859:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80385e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803861:	89 10                	mov    %edx,(%eax)
  803863:	eb 08                	jmp    80386d <free_block+0x345>
  803865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803868:	a3 48 50 80 00       	mov    %eax,0x805048
  80386d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803870:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387e:	a1 54 50 80 00       	mov    0x805054,%eax
  803883:	40                   	inc    %eax
  803884:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803889:	83 ec 0c             	sub    $0xc,%esp
  80388c:	ff 75 ec             	pushl  -0x14(%ebp)
  80388f:	e8 2b f4 ff ff       	call   802cbf <to_page_va>
  803894:	83 c4 10             	add    $0x10,%esp
  803897:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80389a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80389d:	83 ec 0c             	sub    $0xc,%esp
  8038a0:	50                   	push   %eax
  8038a1:	e8 69 e8 ff ff       	call   80210f <return_page>
  8038a6:	83 c4 10             	add    $0x10,%esp
  8038a9:	eb 01                	jmp    8038ac <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8038ab:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8038ac:	c9                   	leave  
  8038ad:	c3                   	ret    

008038ae <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8038ae:	55                   	push   %ebp
  8038af:	89 e5                	mov    %esp,%ebp
  8038b1:	83 ec 14             	sub    $0x14,%esp
  8038b4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8038b7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8038bb:	77 07                	ja     8038c4 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8038bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c2:	eb 20                	jmp    8038e4 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8038c4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8038cb:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8038ce:	eb 08                	jmp    8038d8 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8038d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038d3:	01 c0                	add    %eax,%eax
  8038d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8038d8:	d1 6d 08             	shrl   0x8(%ebp)
  8038db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038df:	75 ef                	jne    8038d0 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8038e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8038e4:	c9                   	leave  
  8038e5:	c3                   	ret    

008038e6 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8038e6:	55                   	push   %ebp
  8038e7:	89 e5                	mov    %esp,%ebp
  8038e9:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8038ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f0:	75 13                	jne    803905 <realloc_block+0x1f>
    return alloc_block(new_size);
  8038f2:	83 ec 0c             	sub    $0xc,%esp
  8038f5:	ff 75 0c             	pushl  0xc(%ebp)
  8038f8:	e8 d1 f6 ff ff       	call   802fce <alloc_block>
  8038fd:	83 c4 10             	add    $0x10,%esp
  803900:	e9 d9 00 00 00       	jmp    8039de <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803905:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803909:	75 18                	jne    803923 <realloc_block+0x3d>
    free_block(va);
  80390b:	83 ec 0c             	sub    $0xc,%esp
  80390e:	ff 75 08             	pushl  0x8(%ebp)
  803911:	e8 12 fc ff ff       	call   803528 <free_block>
  803916:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803919:	b8 00 00 00 00       	mov    $0x0,%eax
  80391e:	e9 bb 00 00 00       	jmp    8039de <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803923:	83 ec 0c             	sub    $0xc,%esp
  803926:	ff 75 08             	pushl  0x8(%ebp)
  803929:	e8 38 f6 ff ff       	call   802f66 <get_block_size>
  80392e:	83 c4 10             	add    $0x10,%esp
  803931:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803934:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  80393b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80393e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803941:	73 06                	jae    803949 <realloc_block+0x63>
    new_size = min_block_size;
  803943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803946:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803949:	83 ec 0c             	sub    $0xc,%esp
  80394c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80394f:	ff 75 0c             	pushl  0xc(%ebp)
  803952:	89 c1                	mov    %eax,%ecx
  803954:	e8 55 ff ff ff       	call   8038ae <nearest_pow2_ceil.1572>
  803959:	83 c4 10             	add    $0x10,%esp
  80395c:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80395f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803962:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803965:	75 05                	jne    80396c <realloc_block+0x86>
    return va;
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	eb 72                	jmp    8039de <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  80396c:	83 ec 0c             	sub    $0xc,%esp
  80396f:	ff 75 0c             	pushl  0xc(%ebp)
  803972:	e8 57 f6 ff ff       	call   802fce <alloc_block>
  803977:	83 c4 10             	add    $0x10,%esp
  80397a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80397d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803981:	75 07                	jne    80398a <realloc_block+0xa4>
    return NULL;
  803983:	b8 00 00 00 00       	mov    $0x0,%eax
  803988:	eb 54                	jmp    8039de <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80398a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80398d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803990:	39 d0                	cmp    %edx,%eax
  803992:	76 02                	jbe    803996 <realloc_block+0xb0>
  803994:	89 d0                	mov    %edx,%eax
  803996:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803999:	8b 45 08             	mov    0x8(%ebp),%eax
  80399c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  80399f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8039a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8039ac:	eb 17                	jmp    8039c5 <realloc_block+0xdf>
    dst[i] = src[i];
  8039ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b4:	01 c2                	add    %eax,%edx
  8039b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	01 c8                	add    %ecx,%eax
  8039be:	8a 00                	mov    (%eax),%al
  8039c0:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8039c2:	ff 45 f4             	incl   -0xc(%ebp)
  8039c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8039cb:	72 e1                	jb     8039ae <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8039cd:	83 ec 0c             	sub    $0xc,%esp
  8039d0:	ff 75 08             	pushl  0x8(%ebp)
  8039d3:	e8 50 fb ff ff       	call   803528 <free_block>
  8039d8:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8039db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8039de:	c9                   	leave  
  8039df:	c3                   	ret    

008039e0 <__udivdi3>:
  8039e0:	55                   	push   %ebp
  8039e1:	57                   	push   %edi
  8039e2:	56                   	push   %esi
  8039e3:	53                   	push   %ebx
  8039e4:	83 ec 1c             	sub    $0x1c,%esp
  8039e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039f7:	89 ca                	mov    %ecx,%edx
  8039f9:	89 f8                	mov    %edi,%eax
  8039fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039ff:	85 f6                	test   %esi,%esi
  803a01:	75 2d                	jne    803a30 <__udivdi3+0x50>
  803a03:	39 cf                	cmp    %ecx,%edi
  803a05:	77 65                	ja     803a6c <__udivdi3+0x8c>
  803a07:	89 fd                	mov    %edi,%ebp
  803a09:	85 ff                	test   %edi,%edi
  803a0b:	75 0b                	jne    803a18 <__udivdi3+0x38>
  803a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a12:	31 d2                	xor    %edx,%edx
  803a14:	f7 f7                	div    %edi
  803a16:	89 c5                	mov    %eax,%ebp
  803a18:	31 d2                	xor    %edx,%edx
  803a1a:	89 c8                	mov    %ecx,%eax
  803a1c:	f7 f5                	div    %ebp
  803a1e:	89 c1                	mov    %eax,%ecx
  803a20:	89 d8                	mov    %ebx,%eax
  803a22:	f7 f5                	div    %ebp
  803a24:	89 cf                	mov    %ecx,%edi
  803a26:	89 fa                	mov    %edi,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	39 ce                	cmp    %ecx,%esi
  803a32:	77 28                	ja     803a5c <__udivdi3+0x7c>
  803a34:	0f bd fe             	bsr    %esi,%edi
  803a37:	83 f7 1f             	xor    $0x1f,%edi
  803a3a:	75 40                	jne    803a7c <__udivdi3+0x9c>
  803a3c:	39 ce                	cmp    %ecx,%esi
  803a3e:	72 0a                	jb     803a4a <__udivdi3+0x6a>
  803a40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a44:	0f 87 9e 00 00 00    	ja     803ae8 <__udivdi3+0x108>
  803a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4f:	89 fa                	mov    %edi,%edx
  803a51:	83 c4 1c             	add    $0x1c,%esp
  803a54:	5b                   	pop    %ebx
  803a55:	5e                   	pop    %esi
  803a56:	5f                   	pop    %edi
  803a57:	5d                   	pop    %ebp
  803a58:	c3                   	ret    
  803a59:	8d 76 00             	lea    0x0(%esi),%esi
  803a5c:	31 ff                	xor    %edi,%edi
  803a5e:	31 c0                	xor    %eax,%eax
  803a60:	89 fa                	mov    %edi,%edx
  803a62:	83 c4 1c             	add    $0x1c,%esp
  803a65:	5b                   	pop    %ebx
  803a66:	5e                   	pop    %esi
  803a67:	5f                   	pop    %edi
  803a68:	5d                   	pop    %ebp
  803a69:	c3                   	ret    
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	89 d8                	mov    %ebx,%eax
  803a6e:	f7 f7                	div    %edi
  803a70:	31 ff                	xor    %edi,%edi
  803a72:	89 fa                	mov    %edi,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a81:	89 eb                	mov    %ebp,%ebx
  803a83:	29 fb                	sub    %edi,%ebx
  803a85:	89 f9                	mov    %edi,%ecx
  803a87:	d3 e6                	shl    %cl,%esi
  803a89:	89 c5                	mov    %eax,%ebp
  803a8b:	88 d9                	mov    %bl,%cl
  803a8d:	d3 ed                	shr    %cl,%ebp
  803a8f:	89 e9                	mov    %ebp,%ecx
  803a91:	09 f1                	or     %esi,%ecx
  803a93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a97:	89 f9                	mov    %edi,%ecx
  803a99:	d3 e0                	shl    %cl,%eax
  803a9b:	89 c5                	mov    %eax,%ebp
  803a9d:	89 d6                	mov    %edx,%esi
  803a9f:	88 d9                	mov    %bl,%cl
  803aa1:	d3 ee                	shr    %cl,%esi
  803aa3:	89 f9                	mov    %edi,%ecx
  803aa5:	d3 e2                	shl    %cl,%edx
  803aa7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aab:	88 d9                	mov    %bl,%cl
  803aad:	d3 e8                	shr    %cl,%eax
  803aaf:	09 c2                	or     %eax,%edx
  803ab1:	89 d0                	mov    %edx,%eax
  803ab3:	89 f2                	mov    %esi,%edx
  803ab5:	f7 74 24 0c          	divl   0xc(%esp)
  803ab9:	89 d6                	mov    %edx,%esi
  803abb:	89 c3                	mov    %eax,%ebx
  803abd:	f7 e5                	mul    %ebp
  803abf:	39 d6                	cmp    %edx,%esi
  803ac1:	72 19                	jb     803adc <__udivdi3+0xfc>
  803ac3:	74 0b                	je     803ad0 <__udivdi3+0xf0>
  803ac5:	89 d8                	mov    %ebx,%eax
  803ac7:	31 ff                	xor    %edi,%edi
  803ac9:	e9 58 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ad4:	89 f9                	mov    %edi,%ecx
  803ad6:	d3 e2                	shl    %cl,%edx
  803ad8:	39 c2                	cmp    %eax,%edx
  803ada:	73 e9                	jae    803ac5 <__udivdi3+0xe5>
  803adc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803adf:	31 ff                	xor    %edi,%edi
  803ae1:	e9 40 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	31 c0                	xor    %eax,%eax
  803aea:	e9 37 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803aef:	90                   	nop

00803af0 <__umoddi3>:
  803af0:	55                   	push   %ebp
  803af1:	57                   	push   %edi
  803af2:	56                   	push   %esi
  803af3:	53                   	push   %ebx
  803af4:	83 ec 1c             	sub    $0x1c,%esp
  803af7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803afb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b0f:	89 f3                	mov    %esi,%ebx
  803b11:	89 fa                	mov    %edi,%edx
  803b13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b17:	89 34 24             	mov    %esi,(%esp)
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	75 1a                	jne    803b38 <__umoddi3+0x48>
  803b1e:	39 f7                	cmp    %esi,%edi
  803b20:	0f 86 a2 00 00 00    	jbe    803bc8 <__umoddi3+0xd8>
  803b26:	89 c8                	mov    %ecx,%eax
  803b28:	89 f2                	mov    %esi,%edx
  803b2a:	f7 f7                	div    %edi
  803b2c:	89 d0                	mov    %edx,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	83 c4 1c             	add    $0x1c,%esp
  803b33:	5b                   	pop    %ebx
  803b34:	5e                   	pop    %esi
  803b35:	5f                   	pop    %edi
  803b36:	5d                   	pop    %ebp
  803b37:	c3                   	ret    
  803b38:	39 f0                	cmp    %esi,%eax
  803b3a:	0f 87 ac 00 00 00    	ja     803bec <__umoddi3+0xfc>
  803b40:	0f bd e8             	bsr    %eax,%ebp
  803b43:	83 f5 1f             	xor    $0x1f,%ebp
  803b46:	0f 84 ac 00 00 00    	je     803bf8 <__umoddi3+0x108>
  803b4c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b51:	29 ef                	sub    %ebp,%edi
  803b53:	89 fe                	mov    %edi,%esi
  803b55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 e0                	shl    %cl,%eax
  803b5d:	89 d7                	mov    %edx,%edi
  803b5f:	89 f1                	mov    %esi,%ecx
  803b61:	d3 ef                	shr    %cl,%edi
  803b63:	09 c7                	or     %eax,%edi
  803b65:	89 e9                	mov    %ebp,%ecx
  803b67:	d3 e2                	shl    %cl,%edx
  803b69:	89 14 24             	mov    %edx,(%esp)
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	d3 e0                	shl    %cl,%eax
  803b70:	89 c2                	mov    %eax,%edx
  803b72:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b76:	d3 e0                	shl    %cl,%eax
  803b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b80:	89 f1                	mov    %esi,%ecx
  803b82:	d3 e8                	shr    %cl,%eax
  803b84:	09 d0                	or     %edx,%eax
  803b86:	d3 eb                	shr    %cl,%ebx
  803b88:	89 da                	mov    %ebx,%edx
  803b8a:	f7 f7                	div    %edi
  803b8c:	89 d3                	mov    %edx,%ebx
  803b8e:	f7 24 24             	mull   (%esp)
  803b91:	89 c6                	mov    %eax,%esi
  803b93:	89 d1                	mov    %edx,%ecx
  803b95:	39 d3                	cmp    %edx,%ebx
  803b97:	0f 82 87 00 00 00    	jb     803c24 <__umoddi3+0x134>
  803b9d:	0f 84 91 00 00 00    	je     803c34 <__umoddi3+0x144>
  803ba3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ba7:	29 f2                	sub    %esi,%edx
  803ba9:	19 cb                	sbb    %ecx,%ebx
  803bab:	89 d8                	mov    %ebx,%eax
  803bad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bb1:	d3 e0                	shl    %cl,%eax
  803bb3:	89 e9                	mov    %ebp,%ecx
  803bb5:	d3 ea                	shr    %cl,%edx
  803bb7:	09 d0                	or     %edx,%eax
  803bb9:	89 e9                	mov    %ebp,%ecx
  803bbb:	d3 eb                	shr    %cl,%ebx
  803bbd:	89 da                	mov    %ebx,%edx
  803bbf:	83 c4 1c             	add    $0x1c,%esp
  803bc2:	5b                   	pop    %ebx
  803bc3:	5e                   	pop    %esi
  803bc4:	5f                   	pop    %edi
  803bc5:	5d                   	pop    %ebp
  803bc6:	c3                   	ret    
  803bc7:	90                   	nop
  803bc8:	89 fd                	mov    %edi,%ebp
  803bca:	85 ff                	test   %edi,%edi
  803bcc:	75 0b                	jne    803bd9 <__umoddi3+0xe9>
  803bce:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd3:	31 d2                	xor    %edx,%edx
  803bd5:	f7 f7                	div    %edi
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 f0                	mov    %esi,%eax
  803bdb:	31 d2                	xor    %edx,%edx
  803bdd:	f7 f5                	div    %ebp
  803bdf:	89 c8                	mov    %ecx,%eax
  803be1:	f7 f5                	div    %ebp
  803be3:	89 d0                	mov    %edx,%eax
  803be5:	e9 44 ff ff ff       	jmp    803b2e <__umoddi3+0x3e>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	89 c8                	mov    %ecx,%eax
  803bee:	89 f2                	mov    %esi,%edx
  803bf0:	83 c4 1c             	add    $0x1c,%esp
  803bf3:	5b                   	pop    %ebx
  803bf4:	5e                   	pop    %esi
  803bf5:	5f                   	pop    %edi
  803bf6:	5d                   	pop    %ebp
  803bf7:	c3                   	ret    
  803bf8:	3b 04 24             	cmp    (%esp),%eax
  803bfb:	72 06                	jb     803c03 <__umoddi3+0x113>
  803bfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c01:	77 0f                	ja     803c12 <__umoddi3+0x122>
  803c03:	89 f2                	mov    %esi,%edx
  803c05:	29 f9                	sub    %edi,%ecx
  803c07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c0b:	89 14 24             	mov    %edx,(%esp)
  803c0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c16:	8b 14 24             	mov    (%esp),%edx
  803c19:	83 c4 1c             	add    $0x1c,%esp
  803c1c:	5b                   	pop    %ebx
  803c1d:	5e                   	pop    %esi
  803c1e:	5f                   	pop    %edi
  803c1f:	5d                   	pop    %ebp
  803c20:	c3                   	ret    
  803c21:	8d 76 00             	lea    0x0(%esi),%esi
  803c24:	2b 04 24             	sub    (%esp),%eax
  803c27:	19 fa                	sbb    %edi,%edx
  803c29:	89 d1                	mov    %edx,%ecx
  803c2b:	89 c6                	mov    %eax,%esi
  803c2d:	e9 71 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c38:	72 ea                	jb     803c24 <__umoddi3+0x134>
  803c3a:	89 d9                	mov    %ebx,%ecx
  803c3c:	e9 62 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>
