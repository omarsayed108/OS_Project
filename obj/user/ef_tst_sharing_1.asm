
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 73 03 00 00       	call   8003a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#endif
//	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f0 00 10 00 82 	movl   $0x82001000,-0x10(%ebp)

	cprintf("STEP A: checking the creation of shared variables...\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 39 80 00       	push   $0x803980
  80004e:	e8 f4 07 00 00       	call   800847 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800056:	e8 f8 24 00 00       	call   802553 <sys_calculate_free_frames>
  80005b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	68 00 10 00 00       	push   $0x1000
  800068:	68 b6 39 80 00       	push   $0x8039b6
  80006d:	e8 c0 20 00 00       	call   802132 <smalloc>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != (uint32*)pagealloc_start) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80007e:	74 14                	je     800094 <_main+0x5c>
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	68 b8 39 80 00       	push   $0x8039b8
  800088:	6a 1a                	push   $0x1a
  80008a:	68 24 3a 80 00       	push   $0x803a24
  80008f:	e8 c5 04 00 00       	call   800559 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800094:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80009b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80009e:	e8 b0 24 00 00       	call   802553 <sys_calculate_free_frames>
  8000a3:	29 c3                	sub    %eax,%ebx
  8000a5:	89 d8                	mov    %ebx,%eax
  8000a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b0:	72 0d                	jb     8000bf <_main+0x87>
  8000b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b5:	8d 50 02             	lea    0x2(%eax),%edx
  8000b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000bb:	39 c2                	cmp    %eax,%edx
  8000bd:	73 24                	jae    8000e3 <_main+0xab>
  8000bf:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000c2:	e8 8c 24 00 00       	call   802553 <sys_calculate_free_frames>
  8000c7:	29 c3                	sub    %eax,%ebx
  8000c9:	89 d8                	mov    %ebx,%eax
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d1:	50                   	push   %eax
  8000d2:	68 3c 3a 80 00       	push   $0x803a3c
  8000d7:	6a 1d                	push   $0x1d
  8000d9:	68 24 3a 80 00       	push   $0x803a24
  8000de:	e8 76 04 00 00       	call   800559 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8000e3:	e8 6b 24 00 00       	call   802553 <sys_calculate_free_frames>
  8000e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	6a 01                	push   $0x1
  8000f0:	68 04 10 00 00       	push   $0x1004
  8000f5:	68 d4 3a 80 00       	push   $0x803ad4
  8000fa:	e8 33 20 00 00       	call   802132 <smalloc>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800108:	05 00 10 00 00       	add    $0x1000,%eax
  80010d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800110:	74 14                	je     800126 <_main+0xee>
  800112:	83 ec 04             	sub    $0x4,%esp
  800115:	68 b8 39 80 00       	push   $0x8039b8
  80011a:	6a 21                	push   $0x21
  80011c:	68 24 3a 80 00       	push   $0x803a24
  800121:	e8 33 04 00 00       	call   800559 <_panic>
		expected = 2 ; /*2pages*/
  800126:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80012d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800130:	e8 1e 24 00 00       	call   802553 <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	72 0d                	jb     800151 <_main+0x119>
  800144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800147:	8d 50 02             	lea    0x2(%eax),%edx
  80014a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	73 24                	jae    800175 <_main+0x13d>
  800151:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800154:	e8 fa 23 00 00       	call   802553 <sys_calculate_free_frames>
  800159:	29 c3                	sub    %eax,%ebx
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	ff 75 e4             	pushl  -0x1c(%ebp)
  800163:	50                   	push   %eax
  800164:	68 3c 3a 80 00       	push   $0x803a3c
  800169:	6a 24                	push   $0x24
  80016b:	68 24 3a 80 00       	push   $0x803a24
  800170:	e8 e4 03 00 00       	call   800559 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800175:	e8 d9 23 00 00       	call   802553 <sys_calculate_free_frames>
  80017a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = smalloc("y", 4, 1);
  80017d:	83 ec 04             	sub    $0x4,%esp
  800180:	6a 01                	push   $0x1
  800182:	6a 04                	push   $0x4
  800184:	68 d6 3a 80 00       	push   $0x803ad6
  800189:	e8 a4 1f 00 00       	call   802132 <smalloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800197:	05 00 30 00 00       	add    $0x3000,%eax
  80019c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80019f:	74 14                	je     8001b5 <_main+0x17d>
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	68 b8 39 80 00       	push   $0x8039b8
  8001a9:	6a 28                	push   $0x28
  8001ab:	68 24 3a 80 00       	push   $0x803a24
  8001b0:	e8 a4 03 00 00       	call   800559 <_panic>
		expected = 1 ; /*1page*/
  8001b5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001bc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001bf:	e8 8f 23 00 00       	call   802553 <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001d1:	72 0d                	jb     8001e0 <_main+0x1a8>
  8001d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d6:	8d 50 02             	lea    0x2(%eax),%edx
  8001d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dc:	39 c2                	cmp    %eax,%edx
  8001de:	73 24                	jae    800204 <_main+0x1cc>
  8001e0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001e3:	e8 6b 23 00 00       	call   802553 <sys_calculate_free_frames>
  8001e8:	29 c3                	sub    %eax,%ebx
  8001ea:	89 d8                	mov    %ebx,%eax
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	50                   	push   %eax
  8001f3:	68 3c 3a 80 00       	push   $0x803a3c
  8001f8:	6a 2b                	push   $0x2b
  8001fa:	68 24 3a 80 00       	push   $0x803a24
  8001ff:	e8 55 03 00 00       	call   800559 <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 d8 3a 80 00       	push   $0x803ad8
  80020c:	e8 36 06 00 00       	call   800847 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 f0 3a 80 00       	push   $0x803af0
  80021c:	e8 26 06 00 00       	call   800847 <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  800224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  80022b:	eb 2d                	jmp    80025a <_main+0x222>
		{
			x[i] = -1;
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80024f:	01 d0                	add    %edx,%eax
  800251:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800257:	ff 45 f4             	incl   -0xc(%ebp)
  80025a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  800261:	7e ca                	jle    80022d <_main+0x1f5>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80026a:	eb 18                	jmp    800284 <_main+0x24c>
		{
			z[i] = -1;
  80026c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800276:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800279:	01 d0                	add    %edx,%eax
  80027b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800281:	ff 45 f4             	incl   -0xc(%ebp)
  800284:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80028b:	7e df                	jle    80026c <_main+0x234>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80028d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800290:	8b 00                	mov    (%eax),%eax
  800292:	83 f8 ff             	cmp    $0xffffffff,%eax
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 18 3b 80 00       	push   $0x803b18
  80029f:	6a 3f                	push   $0x3f
  8002a1:	68 24 3a 80 00       	push   $0x803a24
  8002a6:	e8 ae 02 00 00       	call   800559 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b8:	74 14                	je     8002ce <_main+0x296>
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 18 3b 80 00       	push   $0x803b18
  8002c2:	6a 40                	push   $0x40
  8002c4:	68 24 3a 80 00       	push   $0x803a24
  8002c9:	e8 8b 02 00 00       	call   800559 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d1:	8b 00                	mov    (%eax),%eax
  8002d3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d6:	74 14                	je     8002ec <_main+0x2b4>
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	68 18 3b 80 00       	push   $0x803b18
  8002e0:	6a 42                	push   $0x42
  8002e2:	68 24 3a 80 00       	push   $0x803a24
  8002e7:	e8 6d 02 00 00       	call   800559 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ef:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 18 3b 80 00       	push   $0x803b18
  800303:	6a 43                	push   $0x43
  800305:	68 24 3a 80 00       	push   $0x803a24
  80030a:	e8 4a 02 00 00       	call   800559 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 f8 ff             	cmp    $0xffffffff,%eax
  800317:	74 14                	je     80032d <_main+0x2f5>
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	68 18 3b 80 00       	push   $0x803b18
  800321:	6a 45                	push   $0x45
  800323:	68 24 3a 80 00       	push   $0x803a24
  800328:	e8 2c 02 00 00       	call   800559 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80032d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800330:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	83 f8 ff             	cmp    $0xffffffff,%eax
  80033a:	74 14                	je     800350 <_main+0x318>
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	68 18 3b 80 00       	push   $0x803b18
  800344:	6a 46                	push   $0x46
  800346:	68 24 3a 80 00       	push   $0x803a24
  80034b:	e8 09 02 00 00       	call   800559 <_panic>
	}

	cprintf("test sharing 1 [Create] is finished!!\n\n\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 44 3b 80 00       	push   $0x803b44
  800358:	e8 ea 04 00 00       	call   800847 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800360:	e8 d0 23 00 00       	call   802735 <sys_getparentenvid>
  800365:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(parentenvID > 0)
  800368:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80036c:	7e 35                	jle    8003a3 <_main+0x36b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80036e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	68 6d 3b 80 00       	push   $0x803b6d
  80037d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800380:	e8 0d 1f 00 00       	call   802292 <sget>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 d0             	mov    %eax,-0x30(%ebp)
		sys_lock_cons();
  80038b:	e8 13 21 00 00       	call   8024a3 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800390:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	8d 50 01             	lea    0x1(%eax),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80039d:	e8 1b 21 00 00       	call   8024bd <sys_unlock_cons>
	}

	return;
  8003a2:	90                   	nop
  8003a3:	90                   	nop
}
  8003a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003b2:	e8 65 23 00 00       	call   80271c <sys_getenvindex>
  8003b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 02             	shl    $0x2,%eax
  8003c6:	01 d0                	add    %edx,%eax
  8003c8:	c1 e0 02             	shl    $0x2,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	c1 e0 03             	shl    $0x3,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	c1 e0 02             	shl    $0x2,%eax
  8003d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003da:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003df:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e4:	8a 40 20             	mov    0x20(%eax),%al
  8003e7:	84 c0                	test   %al,%al
  8003e9:	74 0d                	je     8003f8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8003eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f0:	83 c0 20             	add    $0x20,%eax
  8003f3:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003fc:	7e 0a                	jle    800408 <libmain+0x5f>
		binaryname = argv[0];
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	ff 75 0c             	pushl  0xc(%ebp)
  80040e:	ff 75 08             	pushl  0x8(%ebp)
  800411:	e8 22 fc ff ff       	call   800038 <_main>
  800416:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800419:	a1 00 50 80 00       	mov    0x805000,%eax
  80041e:	85 c0                	test   %eax,%eax
  800420:	0f 84 01 01 00 00    	je     800527 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800426:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80042c:	bb 74 3c 80 00       	mov    $0x803c74,%ebx
  800431:	ba 0e 00 00 00       	mov    $0xe,%edx
  800436:	89 c7                	mov    %eax,%edi
  800438:	89 de                	mov    %ebx,%esi
  80043a:	89 d1                	mov    %edx,%ecx
  80043c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80043e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800441:	b9 56 00 00 00       	mov    $0x56,%ecx
  800446:	b0 00                	mov    $0x0,%al
  800448:	89 d7                	mov    %edx,%edi
  80044a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80044c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800453:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	50                   	push   %eax
  80045a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800460:	50                   	push   %eax
  800461:	e8 ec 24 00 00       	call   802952 <sys_utilities>
  800466:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800469:	e8 35 20 00 00       	call   8024a3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80046e:	83 ec 0c             	sub    $0xc,%esp
  800471:	68 94 3b 80 00       	push   $0x803b94
  800476:	e8 cc 03 00 00       	call   800847 <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80047e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	74 18                	je     80049d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800485:	e8 e6 24 00 00       	call   802970 <sys_get_optimal_num_faults>
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	50                   	push   %eax
  80048e:	68 bc 3b 80 00       	push   $0x803bbc
  800493:	e8 af 03 00 00       	call   800847 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	eb 59                	jmp    8004f6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80049d:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a2:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8004a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ad:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8004b3:	83 ec 04             	sub    $0x4,%esp
  8004b6:	52                   	push   %edx
  8004b7:	50                   	push   %eax
  8004b8:	68 e0 3b 80 00       	push   $0x803be0
  8004bd:	e8 85 03 00 00       	call   800847 <cprintf>
  8004c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ca:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8004d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d5:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8004db:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e0:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8004e6:	51                   	push   %ecx
  8004e7:	52                   	push   %edx
  8004e8:	50                   	push   %eax
  8004e9:	68 08 3c 80 00       	push   $0x803c08
  8004ee:	e8 54 03 00 00       	call   800847 <cprintf>
  8004f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fb:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	50                   	push   %eax
  800505:	68 60 3c 80 00       	push   $0x803c60
  80050a:	e8 38 03 00 00       	call   800847 <cprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800512:	83 ec 0c             	sub    $0xc,%esp
  800515:	68 94 3b 80 00       	push   $0x803b94
  80051a:	e8 28 03 00 00       	call   800847 <cprintf>
  80051f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800522:	e8 96 1f 00 00       	call   8024bd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800527:	e8 1f 00 00 00       	call   80054b <exit>
}
  80052c:	90                   	nop
  80052d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800530:	5b                   	pop    %ebx
  800531:	5e                   	pop    %esi
  800532:	5f                   	pop    %edi
  800533:	5d                   	pop    %ebp
  800534:	c3                   	ret    

00800535 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80053b:	83 ec 0c             	sub    $0xc,%esp
  80053e:	6a 00                	push   $0x0
  800540:	e8 a3 21 00 00       	call   8026e8 <sys_destroy_env>
  800545:	83 c4 10             	add    $0x10,%esp
}
  800548:	90                   	nop
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <exit>:

void
exit(void)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800551:	e8 f8 21 00 00       	call   80274e <sys_exit_env>
}
  800556:	90                   	nop
  800557:	c9                   	leave  
  800558:	c3                   	ret    

00800559 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80055f:	8d 45 10             	lea    0x10(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800568:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80056d:	85 c0                	test   %eax,%eax
  80056f:	74 16                	je     800587 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800571:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	50                   	push   %eax
  80057a:	68 d8 3c 80 00       	push   $0x803cd8
  80057f:	e8 c3 02 00 00       	call   800847 <cprintf>
  800584:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800587:	a1 04 50 80 00       	mov    0x805004,%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	ff 75 0c             	pushl  0xc(%ebp)
  800592:	ff 75 08             	pushl  0x8(%ebp)
  800595:	50                   	push   %eax
  800596:	68 e0 3c 80 00       	push   $0x803ce0
  80059b:	6a 74                	push   $0x74
  80059d:	e8 d2 02 00 00       	call   800874 <cprintf_colored>
  8005a2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8005a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ae:	50                   	push   %eax
  8005af:	e8 24 02 00 00       	call   8007d8 <vcprintf>
  8005b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	6a 00                	push   $0x0
  8005bc:	68 08 3d 80 00       	push   $0x803d08
  8005c1:	e8 12 02 00 00       	call   8007d8 <vcprintf>
  8005c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005c9:	e8 7d ff ff ff       	call   80054b <exit>

	// should not return here
	while (1) ;
  8005ce:	eb fe                	jmp    8005ce <_panic+0x75>

008005d0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	53                   	push   %ebx
  8005d4:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	39 c2                	cmp    %eax,%edx
  8005e7:	74 14                	je     8005fd <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	68 0c 3d 80 00       	push   $0x803d0c
  8005f1:	6a 26                	push   $0x26
  8005f3:	68 58 3d 80 00       	push   $0x803d58
  8005f8:	e8 5c ff ff ff       	call   800559 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	e9 d9 00 00 00       	jmp    8006e9 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800613:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	01 d0                	add    %edx,%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	85 c0                	test   %eax,%eax
  800623:	75 08                	jne    80062d <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800625:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800628:	e9 b9 00 00 00       	jmp    8006e6 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80062d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800634:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80063b:	eb 79                	jmp    8006b6 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80063d:	a1 20 50 80 00       	mov    0x805020,%eax
  800642:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800648:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80064b:	89 d0                	mov    %edx,%eax
  80064d:	01 c0                	add    %eax,%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800658:	01 d8                	add    %ebx,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8a 40 04             	mov    0x4(%eax),%al
  800661:	84 c0                	test   %al,%al
  800663:	75 4e                	jne    8006b3 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800665:	a1 20 50 80 00       	mov    0x805020,%eax
  80066a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800670:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800673:	89 d0                	mov    %edx,%eax
  800675:	01 c0                	add    %eax,%eax
  800677:	01 d0                	add    %edx,%eax
  800679:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800680:	01 d8                	add    %ebx,%eax
  800682:	01 d0                	add    %edx,%eax
  800684:	01 c8                	add    %ecx,%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80068b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80068e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800693:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800698:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	01 c8                	add    %ecx,%eax
  8006a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 09                	jne    8006b3 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8006aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006b1:	eb 19                	jmp    8006cc <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b3:	ff 45 e8             	incl   -0x18(%ebp)
  8006b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c4:	39 c2                	cmp    %eax,%edx
  8006c6:	0f 87 71 ff ff ff    	ja     80063d <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006d0:	75 14                	jne    8006e6 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8006d2:	83 ec 04             	sub    $0x4,%esp
  8006d5:	68 64 3d 80 00       	push   $0x803d64
  8006da:	6a 3a                	push   $0x3a
  8006dc:	68 58 3d 80 00       	push   $0x803d58
  8006e1:	e8 73 fe ff ff       	call   800559 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006e6:	ff 45 f0             	incl   -0x10(%ebp)
  8006e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	0f 8c 1b ff ff ff    	jl     800610 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800703:	eb 2e                	jmp    800733 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800705:	a1 20 50 80 00       	mov    0x805020,%eax
  80070a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800710:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800713:	89 d0                	mov    %edx,%eax
  800715:	01 c0                	add    %eax,%eax
  800717:	01 d0                	add    %edx,%eax
  800719:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800720:	01 d8                	add    %ebx,%eax
  800722:	01 d0                	add    %edx,%eax
  800724:	01 c8                	add    %ecx,%eax
  800726:	8a 40 04             	mov    0x4(%eax),%al
  800729:	3c 01                	cmp    $0x1,%al
  80072b:	75 03                	jne    800730 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80072d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800730:	ff 45 e0             	incl   -0x20(%ebp)
  800733:	a1 20 50 80 00       	mov    0x805020,%eax
  800738:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80073e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800741:	39 c2                	cmp    %eax,%edx
  800743:	77 c0                	ja     800705 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800748:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80074b:	74 14                	je     800761 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	68 b8 3d 80 00       	push   $0x803db8
  800755:	6a 44                	push   $0x44
  800757:	68 58 3d 80 00       	push   $0x803d58
  80075c:	e8 f8 fd ff ff       	call   800559 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800761:	90                   	nop
  800762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	53                   	push   %ebx
  80076b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	8d 48 01             	lea    0x1(%eax),%ecx
  800776:	8b 55 0c             	mov    0xc(%ebp),%edx
  800779:	89 0a                	mov    %ecx,(%edx)
  80077b:	8b 55 08             	mov    0x8(%ebp),%edx
  80077e:	88 d1                	mov    %dl,%cl
  800780:	8b 55 0c             	mov    0xc(%ebp),%edx
  800783:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800791:	75 30                	jne    8007c3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800793:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800799:	a0 44 50 80 00       	mov    0x805044,%al
  80079e:	0f b6 c0             	movzbl %al,%eax
  8007a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a4:	8b 09                	mov    (%ecx),%ecx
  8007a6:	89 cb                	mov    %ecx,%ebx
  8007a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ab:	83 c1 08             	add    $0x8,%ecx
  8007ae:	52                   	push   %edx
  8007af:	50                   	push   %eax
  8007b0:	53                   	push   %ebx
  8007b1:	51                   	push   %ecx
  8007b2:	e8 a8 1c 00 00       	call   80245f <sys_cputs>
  8007b7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c6:	8b 40 04             	mov    0x4(%eax),%eax
  8007c9:	8d 50 01             	lea    0x1(%eax),%edx
  8007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cf:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007d2:	90                   	nop
  8007d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007e8:	00 00 00 
	b.cnt = 0;
  8007eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	ff 75 08             	pushl  0x8(%ebp)
  8007fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800801:	50                   	push   %eax
  800802:	68 67 07 80 00       	push   $0x800767
  800807:	e8 5a 02 00 00       	call   800a66 <vprintfmt>
  80080c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80080f:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800815:	a0 44 50 80 00       	mov    0x805044,%al
  80081a:	0f b6 c0             	movzbl %al,%eax
  80081d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800823:	52                   	push   %edx
  800824:	50                   	push   %eax
  800825:	51                   	push   %ecx
  800826:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80082c:	83 c0 08             	add    $0x8,%eax
  80082f:	50                   	push   %eax
  800830:	e8 2a 1c 00 00       	call   80245f <sys_cputs>
  800835:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800838:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80083f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80084d:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800854:	8d 45 0c             	lea    0xc(%ebp),%eax
  800857:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 f4             	pushl  -0xc(%ebp)
  800863:	50                   	push   %eax
  800864:	e8 6f ff ff ff       	call   8007d8 <vcprintf>
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80087a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	c1 e0 08             	shl    $0x8,%eax
  800887:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  80088c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80088f:	83 c0 04             	add    $0x4,%eax
  800892:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800895:	8b 45 0c             	mov    0xc(%ebp),%eax
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 f4             	pushl  -0xc(%ebp)
  80089e:	50                   	push   %eax
  80089f:	e8 34 ff ff ff       	call   8007d8 <vcprintf>
  8008a4:	83 c4 10             	add    $0x10,%esp
  8008a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8008aa:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  8008b1:	07 00 00 

	return cnt;
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8008bf:	e8 df 1b 00 00       	call   8024a3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8008c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d3:	50                   	push   %eax
  8008d4:	e8 ff fe ff ff       	call   8007d8 <vcprintf>
  8008d9:	83 c4 10             	add    $0x10,%esp
  8008dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008df:	e8 d9 1b 00 00       	call   8024bd <sys_unlock_cons>
	return cnt;
  8008e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008e7:	c9                   	leave  
  8008e8:	c3                   	ret    

008008e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	83 ec 14             	sub    $0x14,%esp
  8008f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8008ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800904:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800907:	77 55                	ja     80095e <printnum+0x75>
  800909:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80090c:	72 05                	jb     800913 <printnum+0x2a>
  80090e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800911:	77 4b                	ja     80095e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800913:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800916:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800919:	8b 45 18             	mov    0x18(%ebp),%eax
  80091c:	ba 00 00 00 00       	mov    $0x0,%edx
  800921:	52                   	push   %edx
  800922:	50                   	push   %eax
  800923:	ff 75 f4             	pushl  -0xc(%ebp)
  800926:	ff 75 f0             	pushl  -0x10(%ebp)
  800929:	e8 d2 2d 00 00       	call   803700 <__udivdi3>
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	83 ec 04             	sub    $0x4,%esp
  800934:	ff 75 20             	pushl  0x20(%ebp)
  800937:	53                   	push   %ebx
  800938:	ff 75 18             	pushl  0x18(%ebp)
  80093b:	52                   	push   %edx
  80093c:	50                   	push   %eax
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	ff 75 08             	pushl  0x8(%ebp)
  800943:	e8 a1 ff ff ff       	call   8008e9 <printnum>
  800948:	83 c4 20             	add    $0x20,%esp
  80094b:	eb 1a                	jmp    800967 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	ff 75 20             	pushl  0x20(%ebp)
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	ff d0                	call   *%eax
  80095b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80095e:	ff 4d 1c             	decl   0x1c(%ebp)
  800961:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800965:	7f e6                	jg     80094d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800967:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80096a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80096f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800972:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800975:	53                   	push   %ebx
  800976:	51                   	push   %ecx
  800977:	52                   	push   %edx
  800978:	50                   	push   %eax
  800979:	e8 92 2e 00 00       	call   803810 <__umoddi3>
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	05 34 40 80 00       	add    $0x804034,%eax
  800986:	8a 00                	mov    (%eax),%al
  800988:	0f be c0             	movsbl %al,%eax
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	ff 75 0c             	pushl  0xc(%ebp)
  800991:	50                   	push   %eax
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	ff d0                	call   *%eax
  800997:	83 c4 10             	add    $0x10,%esp
}
  80099a:	90                   	nop
  80099b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099e:	c9                   	leave  
  80099f:	c3                   	ret    

008009a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009a7:	7e 1c                	jle    8009c5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	8d 50 08             	lea    0x8(%eax),%edx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	89 10                	mov    %edx,(%eax)
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	83 e8 08             	sub    $0x8,%eax
  8009be:	8b 50 04             	mov    0x4(%eax),%edx
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	eb 40                	jmp    800a05 <getuint+0x65>
	else if (lflag)
  8009c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c9:	74 1e                	je     8009e9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	8d 50 04             	lea    0x4(%eax),%edx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	89 10                	mov    %edx,(%eax)
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	83 e8 04             	sub    $0x4,%eax
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e7:	eb 1c                	jmp    800a05 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	8d 50 04             	lea    0x4(%eax),%edx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	89 10                	mov    %edx,(%eax)
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	83 e8 04             	sub    $0x4,%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a0a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a0e:	7e 1c                	jle    800a2c <getint+0x25>
		return va_arg(*ap, long long);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	8d 50 08             	lea    0x8(%eax),%edx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	89 10                	mov    %edx,(%eax)
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	83 e8 08             	sub    $0x8,%eax
  800a25:	8b 50 04             	mov    0x4(%eax),%edx
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	eb 38                	jmp    800a64 <getint+0x5d>
	else if (lflag)
  800a2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a30:	74 1a                	je     800a4c <getint+0x45>
		return va_arg(*ap, long);
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	8d 50 04             	lea    0x4(%eax),%edx
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	89 10                	mov    %edx,(%eax)
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	83 e8 04             	sub    $0x4,%eax
  800a47:	8b 00                	mov    (%eax),%eax
  800a49:	99                   	cltd   
  800a4a:	eb 18                	jmp    800a64 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	8d 50 04             	lea    0x4(%eax),%edx
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	89 10                	mov    %edx,(%eax)
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 00                	mov    (%eax),%eax
  800a5e:	83 e8 04             	sub    $0x4,%eax
  800a61:	8b 00                	mov    (%eax),%eax
  800a63:	99                   	cltd   
}
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
  800a6b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a6e:	eb 17                	jmp    800a87 <vprintfmt+0x21>
			if (ch == '\0')
  800a70:	85 db                	test   %ebx,%ebx
  800a72:	0f 84 c1 03 00 00    	je     800e39 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a87:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8a:	8d 50 01             	lea    0x1(%eax),%edx
  800a8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800a90:	8a 00                	mov    (%eax),%al
  800a92:	0f b6 d8             	movzbl %al,%ebx
  800a95:	83 fb 25             	cmp    $0x25,%ebx
  800a98:	75 d6                	jne    800a70 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a9a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a9e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800aa5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800aac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ab3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aba:	8b 45 10             	mov    0x10(%ebp),%eax
  800abd:	8d 50 01             	lea    0x1(%eax),%edx
  800ac0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	0f b6 d8             	movzbl %al,%ebx
  800ac8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800acb:	83 f8 5b             	cmp    $0x5b,%eax
  800ace:	0f 87 3d 03 00 00    	ja     800e11 <vprintfmt+0x3ab>
  800ad4:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
  800adb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800add:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ae1:	eb d7                	jmp    800aba <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ae3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ae7:	eb d1                	jmp    800aba <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800af0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800af3:	89 d0                	mov    %edx,%eax
  800af5:	c1 e0 02             	shl    $0x2,%eax
  800af8:	01 d0                	add    %edx,%eax
  800afa:	01 c0                	add    %eax,%eax
  800afc:	01 d8                	add    %ebx,%eax
  800afe:	83 e8 30             	sub    $0x30,%eax
  800b01:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b04:	8b 45 10             	mov    0x10(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b0c:	83 fb 2f             	cmp    $0x2f,%ebx
  800b0f:	7e 3e                	jle    800b4f <vprintfmt+0xe9>
  800b11:	83 fb 39             	cmp    $0x39,%ebx
  800b14:	7f 39                	jg     800b4f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b16:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b19:	eb d5                	jmp    800af0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1e:	83 c0 04             	add    $0x4,%eax
  800b21:	89 45 14             	mov    %eax,0x14(%ebp)
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	83 e8 04             	sub    $0x4,%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b2f:	eb 1f                	jmp    800b50 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b35:	79 83                	jns    800aba <vprintfmt+0x54>
				width = 0;
  800b37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b3e:	e9 77 ff ff ff       	jmp    800aba <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b43:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b4a:	e9 6b ff ff ff       	jmp    800aba <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b4f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b54:	0f 89 60 ff ff ff    	jns    800aba <vprintfmt+0x54>
				width = precision, precision = -1;
  800b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b60:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b67:	e9 4e ff ff ff       	jmp    800aba <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b6c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b6f:	e9 46 ff ff ff       	jmp    800aba <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b74:	8b 45 14             	mov    0x14(%ebp),%eax
  800b77:	83 c0 04             	add    $0x4,%eax
  800b7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 e8 04             	sub    $0x4,%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 ec 08             	sub    $0x8,%esp
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	50                   	push   %eax
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	ff d0                	call   *%eax
  800b91:	83 c4 10             	add    $0x10,%esp
			break;
  800b94:	e9 9b 02 00 00       	jmp    800e34 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b99:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9c:	83 c0 04             	add    $0x4,%eax
  800b9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 e8 04             	sub    $0x4,%eax
  800ba8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800baa:	85 db                	test   %ebx,%ebx
  800bac:	79 02                	jns    800bb0 <vprintfmt+0x14a>
				err = -err;
  800bae:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bb0:	83 fb 64             	cmp    $0x64,%ebx
  800bb3:	7f 0b                	jg     800bc0 <vprintfmt+0x15a>
  800bb5:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  800bbc:	85 f6                	test   %esi,%esi
  800bbe:	75 19                	jne    800bd9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800bc0:	53                   	push   %ebx
  800bc1:	68 45 40 80 00       	push   $0x804045
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	e8 70 02 00 00       	call   800e41 <printfmt>
  800bd1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bd4:	e9 5b 02 00 00       	jmp    800e34 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bd9:	56                   	push   %esi
  800bda:	68 4e 40 80 00       	push   $0x80404e
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	ff 75 08             	pushl  0x8(%ebp)
  800be5:	e8 57 02 00 00       	call   800e41 <printfmt>
  800bea:	83 c4 10             	add    $0x10,%esp
			break;
  800bed:	e9 42 02 00 00       	jmp    800e34 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf5:	83 c0 04             	add    $0x4,%eax
  800bf8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfe:	83 e8 04             	sub    $0x4,%eax
  800c01:	8b 30                	mov    (%eax),%esi
  800c03:	85 f6                	test   %esi,%esi
  800c05:	75 05                	jne    800c0c <vprintfmt+0x1a6>
				p = "(null)";
  800c07:	be 51 40 80 00       	mov    $0x804051,%esi
			if (width > 0 && padc != '-')
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	7e 6d                	jle    800c7f <vprintfmt+0x219>
  800c12:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c16:	74 67                	je     800c7f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	50                   	push   %eax
  800c1f:	56                   	push   %esi
  800c20:	e8 1e 03 00 00       	call   800f43 <strnlen>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c2b:	eb 16                	jmp    800c43 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c2d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	50                   	push   %eax
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c40:	ff 4d e4             	decl   -0x1c(%ebp)
  800c43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c47:	7f e4                	jg     800c2d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c49:	eb 34                	jmp    800c7f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c4f:	74 1c                	je     800c6d <vprintfmt+0x207>
  800c51:	83 fb 1f             	cmp    $0x1f,%ebx
  800c54:	7e 05                	jle    800c5b <vprintfmt+0x1f5>
  800c56:	83 fb 7e             	cmp    $0x7e,%ebx
  800c59:	7e 12                	jle    800c6d <vprintfmt+0x207>
					putch('?', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 3f                	push   $0x3f
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
  800c6b:	eb 0f                	jmp    800c7c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	53                   	push   %ebx
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c7f:	89 f0                	mov    %esi,%eax
  800c81:	8d 70 01             	lea    0x1(%eax),%esi
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	0f be d8             	movsbl %al,%ebx
  800c89:	85 db                	test   %ebx,%ebx
  800c8b:	74 24                	je     800cb1 <vprintfmt+0x24b>
  800c8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c91:	78 b8                	js     800c4b <vprintfmt+0x1e5>
  800c93:	ff 4d e0             	decl   -0x20(%ebp)
  800c96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c9a:	79 af                	jns    800c4b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c9c:	eb 13                	jmp    800cb1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c9e:	83 ec 08             	sub    $0x8,%esp
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	6a 20                	push   $0x20
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cae:	ff 4d e4             	decl   -0x1c(%ebp)
  800cb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb5:	7f e7                	jg     800c9e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cb7:	e9 78 01 00 00       	jmp    800e34 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cbc:	83 ec 08             	sub    $0x8,%esp
  800cbf:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc2:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc5:	50                   	push   %eax
  800cc6:	e8 3c fd ff ff       	call   800a07 <getint>
  800ccb:	83 c4 10             	add    $0x10,%esp
  800cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cda:	85 d2                	test   %edx,%edx
  800cdc:	79 23                	jns    800d01 <vprintfmt+0x29b>
				putch('-', putdat);
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	6a 2d                	push   $0x2d
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	ff d0                	call   *%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf4:	f7 d8                	neg    %eax
  800cf6:	83 d2 00             	adc    $0x0,%edx
  800cf9:	f7 da                	neg    %edx
  800cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d08:	e9 bc 00 00 00       	jmp    800dc9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	ff 75 e8             	pushl  -0x18(%ebp)
  800d13:	8d 45 14             	lea    0x14(%ebp),%eax
  800d16:	50                   	push   %eax
  800d17:	e8 84 fc ff ff       	call   8009a0 <getuint>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d2c:	e9 98 00 00 00       	jmp    800dc9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	6a 58                	push   $0x58
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	ff d0                	call   *%eax
  800d3e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	6a 58                	push   $0x58
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	ff d0                	call   *%eax
  800d4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	6a 58                	push   $0x58
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	ff d0                	call   *%eax
  800d5e:	83 c4 10             	add    $0x10,%esp
			break;
  800d61:	e9 ce 00 00 00       	jmp    800e34 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d66:	83 ec 08             	sub    $0x8,%esp
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	6a 30                	push   $0x30
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	ff d0                	call   *%eax
  800d73:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	6a 78                	push   $0x78
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 c0 04             	add    $0x4,%eax
  800d8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800da1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800da8:	eb 1f                	jmp    800dc9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 e8             	pushl  -0x18(%ebp)
  800db0:	8d 45 14             	lea    0x14(%ebp),%eax
  800db3:	50                   	push   %eax
  800db4:	e8 e7 fb ff ff       	call   8009a0 <getuint>
  800db9:	83 c4 10             	add    $0x10,%esp
  800dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800dc2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dc9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd0:	83 ec 04             	sub    $0x4,%esp
  800dd3:	52                   	push   %edx
  800dd4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dd7:	50                   	push   %eax
  800dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	ff 75 08             	pushl  0x8(%ebp)
  800de4:	e8 00 fb ff ff       	call   8008e9 <printnum>
  800de9:	83 c4 20             	add    $0x20,%esp
			break;
  800dec:	eb 46                	jmp    800e34 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			break;
  800dfd:	eb 35                	jmp    800e34 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800dff:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800e06:	eb 2c                	jmp    800e34 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e08:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800e0f:	eb 23                	jmp    800e34 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e11:	83 ec 08             	sub    $0x8,%esp
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	6a 25                	push   $0x25
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	ff d0                	call   *%eax
  800e1e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e21:	ff 4d 10             	decl   0x10(%ebp)
  800e24:	eb 03                	jmp    800e29 <vprintfmt+0x3c3>
  800e26:	ff 4d 10             	decl   0x10(%ebp)
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	48                   	dec    %eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	3c 25                	cmp    $0x25,%al
  800e31:	75 f3                	jne    800e26 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e33:	90                   	nop
		}
	}
  800e34:	e9 35 fc ff ff       	jmp    800a6e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e39:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e47:	8d 45 10             	lea    0x10(%ebp),%eax
  800e4a:	83 c0 04             	add    $0x4,%eax
  800e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e50:	8b 45 10             	mov    0x10(%ebp),%eax
  800e53:	ff 75 f4             	pushl  -0xc(%ebp)
  800e56:	50                   	push   %eax
  800e57:	ff 75 0c             	pushl  0xc(%ebp)
  800e5a:	ff 75 08             	pushl  0x8(%ebp)
  800e5d:	e8 04 fc ff ff       	call   800a66 <vprintfmt>
  800e62:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e65:	90                   	nop
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8b 40 08             	mov    0x8(%eax),%eax
  800e71:	8d 50 01             	lea    0x1(%eax),%edx
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	8b 10                	mov    (%eax),%edx
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8b 40 04             	mov    0x4(%eax),%eax
  800e85:	39 c2                	cmp    %eax,%edx
  800e87:	73 12                	jae    800e9b <sprintputch+0x33>
		*b->buf++ = ch;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	8d 48 01             	lea    0x1(%eax),%ecx
  800e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e94:	89 0a                	mov    %ecx,(%edx)
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	88 10                	mov    %dl,(%eax)
}
  800e9b:	90                   	nop
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	01 d0                	add    %edx,%eax
  800eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ebf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ec3:	74 06                	je     800ecb <vsnprintf+0x2d>
  800ec5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec9:	7f 07                	jg     800ed2 <vsnprintf+0x34>
		return -E_INVAL;
  800ecb:	b8 03 00 00 00       	mov    $0x3,%eax
  800ed0:	eb 20                	jmp    800ef2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ed2:	ff 75 14             	pushl  0x14(%ebp)
  800ed5:	ff 75 10             	pushl  0x10(%ebp)
  800ed8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800edb:	50                   	push   %eax
  800edc:	68 68 0e 80 00       	push   $0x800e68
  800ee1:	e8 80 fb ff ff       	call   800a66 <vprintfmt>
  800ee6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800efa:	8d 45 10             	lea    0x10(%ebp),%eax
  800efd:	83 c0 04             	add    $0x4,%eax
  800f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f03:	8b 45 10             	mov    0x10(%ebp),%eax
  800f06:	ff 75 f4             	pushl  -0xc(%ebp)
  800f09:	50                   	push   %eax
  800f0a:	ff 75 0c             	pushl  0xc(%ebp)
  800f0d:	ff 75 08             	pushl  0x8(%ebp)
  800f10:	e8 89 ff ff ff       	call   800e9e <vsnprintf>
  800f15:	83 c4 10             	add    $0x10,%esp
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f2d:	eb 06                	jmp    800f35 <strlen+0x15>
		n++;
  800f2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f32:	ff 45 08             	incl   0x8(%ebp)
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	75 f1                	jne    800f2f <strlen+0xf>
		n++;
	return n;
  800f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f50:	eb 09                	jmp    800f5b <strnlen+0x18>
		n++;
  800f52:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f55:	ff 45 08             	incl   0x8(%ebp)
  800f58:	ff 4d 0c             	decl   0xc(%ebp)
  800f5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f5f:	74 09                	je     800f6a <strnlen+0x27>
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	84 c0                	test   %al,%al
  800f68:	75 e8                	jne    800f52 <strnlen+0xf>
		n++;
	return n;
  800f6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f7b:	90                   	nop
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8d 50 01             	lea    0x1(%eax),%edx
  800f82:	89 55 08             	mov    %edx,0x8(%ebp)
  800f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f8e:	8a 12                	mov    (%edx),%dl
  800f90:	88 10                	mov    %dl,(%eax)
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e4                	jne    800f7c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f9b:	c9                   	leave  
  800f9c:	c3                   	ret    

00800f9d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fa9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fb0:	eb 1f                	jmp    800fd1 <strncpy+0x34>
		*dst++ = *src;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8d 50 01             	lea    0x1(%eax),%edx
  800fb8:	89 55 08             	mov    %edx,0x8(%ebp)
  800fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbe:	8a 12                	mov    (%edx),%dl
  800fc0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	84 c0                	test   %al,%al
  800fc9:	74 03                	je     800fce <strncpy+0x31>
			src++;
  800fcb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fce:	ff 45 fc             	incl   -0x4(%ebp)
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fd7:	72 d9                	jb     800fb2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fdc:	c9                   	leave  
  800fdd:	c3                   	ret    

00800fde <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fee:	74 30                	je     801020 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ff0:	eb 16                	jmp    801008 <strlcpy+0x2a>
			*dst++ = *src++;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8d 50 01             	lea    0x1(%eax),%edx
  800ff8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801001:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801004:	8a 12                	mov    (%edx),%dl
  801006:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801008:	ff 4d 10             	decl   0x10(%ebp)
  80100b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100f:	74 09                	je     80101a <strlcpy+0x3c>
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	84 c0                	test   %al,%al
  801018:	75 d8                	jne    800ff2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	29 c2                	sub    %eax,%edx
  801028:	89 d0                	mov    %edx,%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80102f:	eb 06                	jmp    801037 <strcmp+0xb>
		p++, q++;
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	84 c0                	test   %al,%al
  80103e:	74 0e                	je     80104e <strcmp+0x22>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 10                	mov    (%eax),%dl
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	38 c2                	cmp    %al,%dl
  80104c:	74 e3                	je     801031 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	0f b6 d0             	movzbl %al,%edx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	0f b6 c0             	movzbl %al,%eax
  80105e:	29 c2                	sub    %eax,%edx
  801060:	89 d0                	mov    %edx,%eax
}
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801067:	eb 09                	jmp    801072 <strncmp+0xe>
		n--, p++, q++;
  801069:	ff 4d 10             	decl   0x10(%ebp)
  80106c:	ff 45 08             	incl   0x8(%ebp)
  80106f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 17                	je     80108f <strncmp+0x2b>
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	84 c0                	test   %al,%al
  80107f:	74 0e                	je     80108f <strncmp+0x2b>
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 10                	mov    (%eax),%dl
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	38 c2                	cmp    %al,%dl
  80108d:	74 da                	je     801069 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80108f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801093:	75 07                	jne    80109c <strncmp+0x38>
		return 0;
  801095:	b8 00 00 00 00       	mov    $0x0,%eax
  80109a:	eb 14                	jmp    8010b0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	0f b6 d0             	movzbl %al,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	0f b6 c0             	movzbl %al,%eax
  8010ac:	29 c2                	sub    %eax,%edx
  8010ae:	89 d0                	mov    %edx,%eax
}
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    

008010b2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 04             	sub    $0x4,%esp
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010be:	eb 12                	jmp    8010d2 <strchr+0x20>
		if (*s == c)
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010c8:	75 05                	jne    8010cf <strchr+0x1d>
			return (char *) s;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	eb 11                	jmp    8010e0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010cf:	ff 45 08             	incl   0x8(%ebp)
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 e5                	jne    8010c0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 04             	sub    $0x4,%esp
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010ee:	eb 0d                	jmp    8010fd <strfind+0x1b>
		if (*s == c)
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010f8:	74 0e                	je     801108 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	84 c0                	test   %al,%al
  801104:	75 ea                	jne    8010f0 <strfind+0xe>
  801106:	eb 01                	jmp    801109 <strfind+0x27>
		if (*s == c)
			break;
  801108:	90                   	nop
	return (char *) s;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80111a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80111e:	76 63                	jbe    801183 <memset+0x75>
		uint64 data_block = c;
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	99                   	cltd   
  801124:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801127:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80112a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801130:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801134:	c1 e0 08             	shl    $0x8,%eax
  801137:	09 45 f0             	or     %eax,-0x10(%ebp)
  80113a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801147:	c1 e0 10             	shl    $0x10,%eax
  80114a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80114d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801156:	89 c2                	mov    %eax,%edx
  801158:	b8 00 00 00 00       	mov    $0x0,%eax
  80115d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801160:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801163:	eb 18                	jmp    80117d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801165:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801168:	8d 41 08             	lea    0x8(%ecx),%eax
  80116b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80116e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	89 01                	mov    %eax,(%ecx)
  801176:	89 51 04             	mov    %edx,0x4(%ecx)
  801179:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80117d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801181:	77 e2                	ja     801165 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801183:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801187:	74 23                	je     8011ac <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801189:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80118f:	eb 0e                	jmp    80119f <memset+0x91>
			*p8++ = (uint8)c;
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	8d 50 01             	lea    0x1(%eax),%edx
  801197:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	75 e5                	jne    801191 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8011c3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011c7:	76 24                	jbe    8011ed <memcpy+0x3c>
		while(n >= 8){
  8011c9:	eb 1c                	jmp    8011e7 <memcpy+0x36>
			*d64 = *s64;
  8011cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ce:	8b 50 04             	mov    0x4(%eax),%edx
  8011d1:	8b 00                	mov    (%eax),%eax
  8011d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d6:	89 01                	mov    %eax,(%ecx)
  8011d8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011db:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011df:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011e3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011e7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011eb:	77 de                	ja     8011cb <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f1:	74 31                	je     801224 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8011f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8011f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8011ff:	eb 16                	jmp    801217 <memcpy+0x66>
			*d8++ = *s8++;
  801201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801204:	8d 50 01             	lea    0x1(%eax),%edx
  801207:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80120a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801210:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801213:	8a 12                	mov    (%edx),%dl
  801215:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80121d:	89 55 10             	mov    %edx,0x10(%ebp)
  801220:	85 c0                	test   %eax,%eax
  801222:	75 dd                	jne    801201 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80123b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801241:	73 50                	jae    801293 <memmove+0x6a>
  801243:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801246:	8b 45 10             	mov    0x10(%ebp),%eax
  801249:	01 d0                	add    %edx,%eax
  80124b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80124e:	76 43                	jbe    801293 <memmove+0x6a>
		s += n;
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801256:	8b 45 10             	mov    0x10(%ebp),%eax
  801259:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80125c:	eb 10                	jmp    80126e <memmove+0x45>
			*--d = *--s;
  80125e:	ff 4d f8             	decl   -0x8(%ebp)
  801261:	ff 4d fc             	decl   -0x4(%ebp)
  801264:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801267:	8a 10                	mov    (%eax),%dl
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	8d 50 ff             	lea    -0x1(%eax),%edx
  801274:	89 55 10             	mov    %edx,0x10(%ebp)
  801277:	85 c0                	test   %eax,%eax
  801279:	75 e3                	jne    80125e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80127b:	eb 23                	jmp    8012a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	8d 50 01             	lea    0x1(%eax),%edx
  801283:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801286:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80128c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80128f:	8a 12                	mov    (%edx),%dl
  801291:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	8d 50 ff             	lea    -0x1(%eax),%edx
  801299:	89 55 10             	mov    %edx,0x10(%ebp)
  80129c:	85 c0                	test   %eax,%eax
  80129e:	75 dd                	jne    80127d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012b7:	eb 2a                	jmp    8012e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8012b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bc:	8a 10                	mov    (%eax),%dl
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	38 c2                	cmp    %al,%dl
  8012c5:	74 16                	je     8012dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	0f b6 d0             	movzbl %al,%edx
  8012cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	0f b6 c0             	movzbl %al,%eax
  8012d7:	29 c2                	sub    %eax,%edx
  8012d9:	89 d0                	mov    %edx,%eax
  8012db:	eb 18                	jmp    8012f5 <memcmp+0x50>
		s1++, s2++;
  8012dd:	ff 45 fc             	incl   -0x4(%ebp)
  8012e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	75 c9                	jne    8012b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    

008012f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801308:	eb 15                	jmp    80131f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f b6 d0             	movzbl %al,%edx
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	0f b6 c0             	movzbl %al,%eax
  801318:	39 c2                	cmp    %eax,%edx
  80131a:	74 0d                	je     801329 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80131c:	ff 45 08             	incl   0x8(%ebp)
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801325:	72 e3                	jb     80130a <memfind+0x13>
  801327:	eb 01                	jmp    80132a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801329:	90                   	nop
	return (void *) s;
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801335:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80133c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801343:	eb 03                	jmp    801348 <strtol+0x19>
		s++;
  801345:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	3c 20                	cmp    $0x20,%al
  80134f:	74 f4                	je     801345 <strtol+0x16>
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	3c 09                	cmp    $0x9,%al
  801358:	74 eb                	je     801345 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	3c 2b                	cmp    $0x2b,%al
  801361:	75 05                	jne    801368 <strtol+0x39>
		s++;
  801363:	ff 45 08             	incl   0x8(%ebp)
  801366:	eb 13                	jmp    80137b <strtol+0x4c>
	else if (*s == '-')
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	3c 2d                	cmp    $0x2d,%al
  80136f:	75 0a                	jne    80137b <strtol+0x4c>
		s++, neg = 1;
  801371:	ff 45 08             	incl   0x8(%ebp)
  801374:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 06                	je     801387 <strtol+0x58>
  801381:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801385:	75 20                	jne    8013a7 <strtol+0x78>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 30                	cmp    $0x30,%al
  80138e:	75 17                	jne    8013a7 <strtol+0x78>
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	40                   	inc    %eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	3c 78                	cmp    $0x78,%al
  801398:	75 0d                	jne    8013a7 <strtol+0x78>
		s += 2, base = 16;
  80139a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80139e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013a5:	eb 28                	jmp    8013cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	75 15                	jne    8013c2 <strtol+0x93>
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	3c 30                	cmp    $0x30,%al
  8013b4:	75 0c                	jne    8013c2 <strtol+0x93>
		s++, base = 8;
  8013b6:	ff 45 08             	incl   0x8(%ebp)
  8013b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013c0:	eb 0d                	jmp    8013cf <strtol+0xa0>
	else if (base == 0)
  8013c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c6:	75 07                	jne    8013cf <strtol+0xa0>
		base = 10;
  8013c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 2f                	cmp    $0x2f,%al
  8013d6:	7e 19                	jle    8013f1 <strtol+0xc2>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8a 00                	mov    (%eax),%al
  8013dd:	3c 39                	cmp    $0x39,%al
  8013df:	7f 10                	jg     8013f1 <strtol+0xc2>
			dig = *s - '0';
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	0f be c0             	movsbl %al,%eax
  8013e9:	83 e8 30             	sub    $0x30,%eax
  8013ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013ef:	eb 42                	jmp    801433 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	3c 60                	cmp    $0x60,%al
  8013f8:	7e 19                	jle    801413 <strtol+0xe4>
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	3c 7a                	cmp    $0x7a,%al
  801401:	7f 10                	jg     801413 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f be c0             	movsbl %al,%eax
  80140b:	83 e8 57             	sub    $0x57,%eax
  80140e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801411:	eb 20                	jmp    801433 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 40                	cmp    $0x40,%al
  80141a:	7e 39                	jle    801455 <strtol+0x126>
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	3c 5a                	cmp    $0x5a,%al
  801423:	7f 30                	jg     801455 <strtol+0x126>
			dig = *s - 'A' + 10;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	0f be c0             	movsbl %al,%eax
  80142d:	83 e8 37             	sub    $0x37,%eax
  801430:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801436:	3b 45 10             	cmp    0x10(%ebp),%eax
  801439:	7d 19                	jge    801454 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801441:	0f af 45 10          	imul   0x10(%ebp),%eax
  801445:	89 c2                	mov    %eax,%edx
  801447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144a:	01 d0                	add    %edx,%eax
  80144c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80144f:	e9 7b ff ff ff       	jmp    8013cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801454:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801455:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801459:	74 08                	je     801463 <strtol+0x134>
		*endptr = (char *) s;
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	8b 55 08             	mov    0x8(%ebp),%edx
  801461:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801463:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801467:	74 07                	je     801470 <strtol+0x141>
  801469:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146c:	f7 d8                	neg    %eax
  80146e:	eb 03                	jmp    801473 <strtol+0x144>
  801470:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <ltostr>:

void
ltostr(long value, char *str)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80147b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801482:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801489:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80148d:	79 13                	jns    8014a2 <ltostr+0x2d>
	{
		neg = 1;
  80148f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801496:	8b 45 0c             	mov    0xc(%ebp),%eax
  801499:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80149c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80149f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014aa:	99                   	cltd   
  8014ab:	f7 f9                	idiv   %ecx
  8014ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b3:	8d 50 01             	lea    0x1(%eax),%edx
  8014b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014b9:	89 c2                	mov    %eax,%edx
  8014bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014be:	01 d0                	add    %edx,%eax
  8014c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014c3:	83 c2 30             	add    $0x30,%edx
  8014c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014d0:	f7 e9                	imul   %ecx
  8014d2:	c1 fa 02             	sar    $0x2,%edx
  8014d5:	89 c8                	mov    %ecx,%eax
  8014d7:	c1 f8 1f             	sar    $0x1f,%eax
  8014da:	29 c2                	sub    %eax,%edx
  8014dc:	89 d0                	mov    %edx,%eax
  8014de:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e5:	75 bb                	jne    8014a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	48                   	dec    %eax
  8014f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014f9:	74 3d                	je     801538 <ltostr+0xc3>
		start = 1 ;
  8014fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801502:	eb 34                	jmp    801538 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	8a 00                	mov    (%eax),%al
  80150e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801511:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	01 c2                	add    %eax,%edx
  801519:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	01 c8                	add    %ecx,%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801525:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152b:	01 c2                	add    %eax,%edx
  80152d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801530:	88 02                	mov    %al,(%edx)
		start++ ;
  801532:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801535:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80153e:	7c c4                	jl     801504 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801540:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	01 d0                	add    %edx,%eax
  801548:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80154b:	90                   	nop
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801554:	ff 75 08             	pushl  0x8(%ebp)
  801557:	e8 c4 f9 ff ff       	call   800f20 <strlen>
  80155c:	83 c4 04             	add    $0x4,%esp
  80155f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	e8 b6 f9 ff ff       	call   800f20 <strlen>
  80156a:	83 c4 04             	add    $0x4,%esp
  80156d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801570:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801577:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157e:	eb 17                	jmp    801597 <strcconcat+0x49>
		final[s] = str1[s] ;
  801580:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801583:	8b 45 10             	mov    0x10(%ebp),%eax
  801586:	01 c2                	add    %eax,%edx
  801588:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	01 c8                	add    %ecx,%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801594:	ff 45 fc             	incl   -0x4(%ebp)
  801597:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80159d:	7c e1                	jl     801580 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80159f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015ad:	eb 1f                	jmp    8015ce <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b2:	8d 50 01             	lea    0x1(%eax),%edx
  8015b5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015b8:	89 c2                	mov    %eax,%edx
  8015ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bd:	01 c2                	add    %eax,%edx
  8015bf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	01 c8                	add    %ecx,%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015cb:	ff 45 f8             	incl   -0x8(%ebp)
  8015ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015d4:	7c d9                	jl     8015af <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015dc:	01 d0                	add    %edx,%eax
  8015de:	c6 00 00             	movb   $0x0,(%eax)
}
  8015e1:	90                   	nop
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f3:	8b 00                	mov    (%eax),%eax
  8015f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801607:	eb 0c                	jmp    801615 <strsplit+0x31>
			*string++ = 0;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8d 50 01             	lea    0x1(%eax),%edx
  80160f:	89 55 08             	mov    %edx,0x8(%ebp)
  801612:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	84 c0                	test   %al,%al
  80161c:	74 18                	je     801636 <strsplit+0x52>
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8a 00                	mov    (%eax),%al
  801623:	0f be c0             	movsbl %al,%eax
  801626:	50                   	push   %eax
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	e8 83 fa ff ff       	call   8010b2 <strchr>
  80162f:	83 c4 08             	add    $0x8,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	75 d3                	jne    801609 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 5a                	je     801699 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80163f:	8b 45 14             	mov    0x14(%ebp),%eax
  801642:	8b 00                	mov    (%eax),%eax
  801644:	83 f8 0f             	cmp    $0xf,%eax
  801647:	75 07                	jne    801650 <strsplit+0x6c>
		{
			return 0;
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
  80164e:	eb 66                	jmp    8016b6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801650:	8b 45 14             	mov    0x14(%ebp),%eax
  801653:	8b 00                	mov    (%eax),%eax
  801655:	8d 48 01             	lea    0x1(%eax),%ecx
  801658:	8b 55 14             	mov    0x14(%ebp),%edx
  80165b:	89 0a                	mov    %ecx,(%edx)
  80165d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	01 c2                	add    %eax,%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80166e:	eb 03                	jmp    801673 <strsplit+0x8f>
			string++;
  801670:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	74 8b                	je     801607 <strsplit+0x23>
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	0f be c0             	movsbl %al,%eax
  801684:	50                   	push   %eax
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	e8 25 fa ff ff       	call   8010b2 <strchr>
  80168d:	83 c4 08             	add    $0x8,%esp
  801690:	85 c0                	test   %eax,%eax
  801692:	74 dc                	je     801670 <strsplit+0x8c>
			string++;
	}
  801694:	e9 6e ff ff ff       	jmp    801607 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801699:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80169a:	8b 45 14             	mov    0x14(%ebp),%eax
  80169d:	8b 00                	mov    (%eax),%eax
  80169f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016b1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8016c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016cb:	eb 4a                	jmp    801717 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8016cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	01 c2                	add    %eax,%edx
  8016d5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016db:	01 c8                	add    %ecx,%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e7:	01 d0                	add    %edx,%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	3c 40                	cmp    $0x40,%al
  8016ed:	7e 25                	jle    801714 <str2lower+0x5c>
  8016ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	01 d0                	add    %edx,%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	3c 5a                	cmp    $0x5a,%al
  8016fb:	7f 17                	jg     801714 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8016fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	01 d0                	add    %edx,%eax
  801705:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801708:	8b 55 08             	mov    0x8(%ebp),%edx
  80170b:	01 ca                	add    %ecx,%edx
  80170d:	8a 12                	mov    (%edx),%dl
  80170f:	83 c2 20             	add    $0x20,%edx
  801712:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801714:	ff 45 fc             	incl   -0x4(%ebp)
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	e8 01 f8 ff ff       	call   800f20 <strlen>
  80171f:	83 c4 04             	add    $0x4,%esp
  801722:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801725:	7f a6                	jg     8016cd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801727:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	6a 10                	push   $0x10
  801737:	e8 b2 15 00 00       	call   802cee <alloc_block>
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801742:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801746:	75 14                	jne    80175c <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	68 c8 41 80 00       	push   $0x8041c8
  801750:	6a 14                	push   $0x14
  801752:	68 f1 41 80 00       	push   $0x8041f1
  801757:	e8 fd ed ff ff       	call   800559 <_panic>

	node->start = start;
  80175c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175f:	8b 55 08             	mov    0x8(%ebp),%edx
  801762:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80176d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801774:	a1 24 50 80 00       	mov    0x805024,%eax
  801779:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177c:	eb 18                	jmp    801796 <insert_page_alloc+0x6a>
		if (start < it->start)
  80177e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801781:	8b 00                	mov    (%eax),%eax
  801783:	3b 45 08             	cmp    0x8(%ebp),%eax
  801786:	77 37                	ja     8017bf <insert_page_alloc+0x93>
			break;
		prev = it;
  801788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80178e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80179a:	74 08                	je     8017a4 <insert_page_alloc+0x78>
  80179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179f:	8b 40 08             	mov    0x8(%eax),%eax
  8017a2:	eb 05                	jmp    8017a9 <insert_page_alloc+0x7d>
  8017a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	75 c7                	jne    80177e <insert_page_alloc+0x52>
  8017b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017bb:	75 c1                	jne    80177e <insert_page_alloc+0x52>
  8017bd:	eb 01                	jmp    8017c0 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8017bf:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8017c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017c4:	75 64                	jne    80182a <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8017c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ca:	75 14                	jne    8017e0 <insert_page_alloc+0xb4>
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	68 00 42 80 00       	push   $0x804200
  8017d4:	6a 21                	push   $0x21
  8017d6:	68 f1 41 80 00       	push   $0x8041f1
  8017db:	e8 79 ed ff ff       	call   800559 <_panic>
  8017e0:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8017e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e9:	89 50 08             	mov    %edx,0x8(%eax)
  8017ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ef:	8b 40 08             	mov    0x8(%eax),%eax
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	74 0d                	je     801803 <insert_page_alloc+0xd7>
  8017f6:	a1 24 50 80 00       	mov    0x805024,%eax
  8017fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017fe:	89 50 0c             	mov    %edx,0xc(%eax)
  801801:	eb 08                	jmp    80180b <insert_page_alloc+0xdf>
  801803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801806:	a3 28 50 80 00       	mov    %eax,0x805028
  80180b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180e:	a3 24 50 80 00       	mov    %eax,0x805024
  801813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801816:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80181d:	a1 30 50 80 00       	mov    0x805030,%eax
  801822:	40                   	inc    %eax
  801823:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801828:	eb 71                	jmp    80189b <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  80182a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80182e:	74 06                	je     801836 <insert_page_alloc+0x10a>
  801830:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801834:	75 14                	jne    80184a <insert_page_alloc+0x11e>
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 24 42 80 00       	push   $0x804224
  80183e:	6a 23                	push   $0x23
  801840:	68 f1 41 80 00       	push   $0x8041f1
  801845:	e8 0f ed ff ff       	call   800559 <_panic>
  80184a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184d:	8b 50 08             	mov    0x8(%eax),%edx
  801850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801853:	89 50 08             	mov    %edx,0x8(%eax)
  801856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801859:	8b 40 08             	mov    0x8(%eax),%eax
  80185c:	85 c0                	test   %eax,%eax
  80185e:	74 0c                	je     80186c <insert_page_alloc+0x140>
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801863:	8b 40 08             	mov    0x8(%eax),%eax
  801866:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801869:	89 50 0c             	mov    %edx,0xc(%eax)
  80186c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801872:	89 50 08             	mov    %edx,0x8(%eax)
  801875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801878:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80187b:	89 50 0c             	mov    %edx,0xc(%eax)
  80187e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801881:	8b 40 08             	mov    0x8(%eax),%eax
  801884:	85 c0                	test   %eax,%eax
  801886:	75 08                	jne    801890 <insert_page_alloc+0x164>
  801888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188b:	a3 28 50 80 00       	mov    %eax,0x805028
  801890:	a1 30 50 80 00       	mov    0x805030,%eax
  801895:	40                   	inc    %eax
  801896:	a3 30 50 80 00       	mov    %eax,0x805030
}
  80189b:	90                   	nop
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8018a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	75 0c                	jne    8018b9 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8018ad:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8018b2:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  8018b7:	eb 67                	jmp    801920 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8018b9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8018be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018c1:	a1 24 50 80 00       	mov    0x805024,%eax
  8018c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8018c9:	eb 26                	jmp    8018f1 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8018cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ce:	8b 10                	mov    (%eax),%edx
  8018d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d3:	8b 40 04             	mov    0x4(%eax),%eax
  8018d6:	01 d0                	add    %edx,%eax
  8018d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018e1:	76 06                	jbe    8018e9 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8018e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8018f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8018f5:	74 08                	je     8018ff <recompute_page_alloc_break+0x61>
  8018f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fa:	8b 40 08             	mov    0x8(%eax),%eax
  8018fd:	eb 05                	jmp    801904 <recompute_page_alloc_break+0x66>
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801904:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801909:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80190e:	85 c0                	test   %eax,%eax
  801910:	75 b9                	jne    8018cb <recompute_page_alloc_break+0x2d>
  801912:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801916:	75 b3                	jne    8018cb <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801918:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80191b:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801928:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80192f:	8b 55 08             	mov    0x8(%ebp),%edx
  801932:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801935:	01 d0                	add    %edx,%eax
  801937:	48                   	dec    %eax
  801938:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80193b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	f7 75 d8             	divl   -0x28(%ebp)
  801946:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801949:	29 d0                	sub    %edx,%eax
  80194b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80194e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801952:	75 0a                	jne    80195e <alloc_pages_custom_fit+0x3c>
		return NULL;
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
  801959:	e9 7e 01 00 00       	jmp    801adc <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80195e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801965:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801969:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801970:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801977:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80197c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  80197f:	a1 24 50 80 00       	mov    0x805024,%eax
  801984:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801987:	eb 69                	jmp    8019f2 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801989:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80198c:	8b 00                	mov    (%eax),%eax
  80198e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801991:	76 47                	jbe    8019da <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801996:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80199c:	8b 00                	mov    (%eax),%eax
  80199e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8019a1:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8019a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019a7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8019aa:	72 2e                	jb     8019da <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8019ac:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8019b0:	75 14                	jne    8019c6 <alloc_pages_custom_fit+0xa4>
  8019b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019b5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8019b8:	75 0c                	jne    8019c6 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8019ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8019c0:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8019c4:	eb 14                	jmp    8019da <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8019c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019c9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019cc:	76 0c                	jbe    8019da <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8019ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8019d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8019da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019dd:	8b 10                	mov    (%eax),%edx
  8019df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e2:	8b 40 04             	mov    0x4(%eax),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8019ea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019f6:	74 08                	je     801a00 <alloc_pages_custom_fit+0xde>
  8019f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019fb:	8b 40 08             	mov    0x8(%eax),%eax
  8019fe:	eb 05                	jmp    801a05 <alloc_pages_custom_fit+0xe3>
  801a00:	b8 00 00 00 00       	mov    $0x0,%eax
  801a05:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a0a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	0f 85 72 ff ff ff    	jne    801989 <alloc_pages_custom_fit+0x67>
  801a17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a1b:	0f 85 68 ff ff ff    	jne    801989 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801a21:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801a26:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a29:	76 47                	jbe    801a72 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a2e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801a31:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801a36:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801a39:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801a3c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a3f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a42:	72 2e                	jb     801a72 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801a44:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801a48:	75 14                	jne    801a5e <alloc_pages_custom_fit+0x13c>
  801a4a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a4d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a50:	75 0c                	jne    801a5e <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801a52:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801a58:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801a5c:	eb 14                	jmp    801a72 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801a5e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a61:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a64:	76 0c                	jbe    801a72 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801a66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801a6c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801a72:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801a79:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801a7d:	74 08                	je     801a87 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a85:	eb 40                	jmp    801ac7 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801a87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a8b:	74 08                	je     801a95 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a93:	eb 32                	jmp    801ac7 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801a95:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a9a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801a9d:	89 c2                	mov    %eax,%edx
  801a9f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801aa4:	39 c2                	cmp    %eax,%edx
  801aa6:	73 07                	jae    801aaf <alloc_pages_custom_fit+0x18d>
			return NULL;
  801aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aad:	eb 2d                	jmp    801adc <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801aaf:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ab4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801ab7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801abd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ac0:	01 d0                	add    %edx,%eax
  801ac2:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801ac7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	ff 75 d0             	pushl  -0x30(%ebp)
  801ad0:	50                   	push   %eax
  801ad1:	e8 56 fc ff ff       	call   80172c <insert_page_alloc>
  801ad6:	83 c4 10             	add    $0x10,%esp

	return result;
  801ad9:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801aea:	a1 24 50 80 00       	mov    0x805024,%eax
  801aef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801af2:	eb 1a                	jmp    801b0e <find_allocated_size+0x30>
		if (it->start == va)
  801af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af7:	8b 00                	mov    (%eax),%eax
  801af9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801afc:	75 08                	jne    801b06 <find_allocated_size+0x28>
			return it->size;
  801afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b01:	8b 40 04             	mov    0x4(%eax),%eax
  801b04:	eb 34                	jmp    801b3a <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b06:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801b0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b12:	74 08                	je     801b1c <find_allocated_size+0x3e>
  801b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b17:	8b 40 08             	mov    0x8(%eax),%eax
  801b1a:	eb 05                	jmp    801b21 <find_allocated_size+0x43>
  801b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b21:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b26:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	75 c5                	jne    801af4 <find_allocated_size+0x16>
  801b2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b33:	75 bf                	jne    801af4 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801b35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b48:	a1 24 50 80 00       	mov    0x805024,%eax
  801b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b50:	e9 e1 01 00 00       	jmp    801d36 <free_pages+0x1fa>
		if (it->start == va) {
  801b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b58:	8b 00                	mov    (%eax),%eax
  801b5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801b5d:	0f 85 cb 01 00 00    	jne    801d2e <free_pages+0x1f2>

			uint32 start = it->start;
  801b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b66:	8b 00                	mov    (%eax),%eax
  801b68:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6e:	8b 40 04             	mov    0x4(%eax),%eax
  801b71:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b77:	f7 d0                	not    %eax
  801b79:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b7c:	73 1d                	jae    801b9b <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b84:	ff 75 e8             	pushl  -0x18(%ebp)
  801b87:	68 58 42 80 00       	push   $0x804258
  801b8c:	68 a5 00 00 00       	push   $0xa5
  801b91:	68 f1 41 80 00       	push   $0x8041f1
  801b96:	e8 be e9 ff ff       	call   800559 <_panic>
			}

			uint32 start_end = start + size;
  801b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba1:	01 d0                	add    %edx,%eax
  801ba3:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	79 19                	jns    801bc6 <free_pages+0x8a>
  801bad:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801bb4:	77 10                	ja     801bc6 <free_pages+0x8a>
  801bb6:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801bbd:	77 07                	ja     801bc6 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	78 2c                	js     801bf2 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bc9:	83 ec 0c             	sub    $0xc,%esp
  801bcc:	68 00 00 00 a0       	push   $0xa0000000
  801bd1:	ff 75 e0             	pushl  -0x20(%ebp)
  801bd4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bd7:	ff 75 e8             	pushl  -0x18(%ebp)
  801bda:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bdd:	50                   	push   %eax
  801bde:	68 9c 42 80 00       	push   $0x80429c
  801be3:	68 ad 00 00 00       	push   $0xad
  801be8:	68 f1 41 80 00       	push   $0x8041f1
  801bed:	e8 67 e9 ff ff       	call   800559 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bf8:	e9 88 00 00 00       	jmp    801c85 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801bfd:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801c04:	76 17                	jbe    801c1d <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801c06:	ff 75 f0             	pushl  -0x10(%ebp)
  801c09:	68 00 43 80 00       	push   $0x804300
  801c0e:	68 b4 00 00 00       	push   $0xb4
  801c13:	68 f1 41 80 00       	push   $0x8041f1
  801c18:	e8 3c e9 ff ff       	call   800559 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c20:	05 00 10 00 00       	add    $0x1000,%eax
  801c25:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	79 2e                	jns    801c5d <free_pages+0x121>
  801c2f:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801c36:	77 25                	ja     801c5d <free_pages+0x121>
  801c38:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801c3f:	77 1c                	ja     801c5d <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801c41:	83 ec 08             	sub    $0x8,%esp
  801c44:	68 00 10 00 00       	push   $0x1000
  801c49:	ff 75 f0             	pushl  -0x10(%ebp)
  801c4c:	e8 38 0d 00 00       	call   802989 <sys_free_user_mem>
  801c51:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801c54:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801c5b:	eb 28                	jmp    801c85 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c60:	68 00 00 00 a0       	push   $0xa0000000
  801c65:	ff 75 dc             	pushl  -0x24(%ebp)
  801c68:	68 00 10 00 00       	push   $0x1000
  801c6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c70:	50                   	push   %eax
  801c71:	68 40 43 80 00       	push   $0x804340
  801c76:	68 bd 00 00 00       	push   $0xbd
  801c7b:	68 f1 41 80 00       	push   $0x8041f1
  801c80:	e8 d4 e8 ff ff       	call   800559 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c88:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801c8b:	0f 82 6c ff ff ff    	jb     801bfd <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c95:	75 17                	jne    801cae <free_pages+0x172>
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	68 a2 43 80 00       	push   $0x8043a2
  801c9f:	68 c1 00 00 00       	push   $0xc1
  801ca4:	68 f1 41 80 00       	push   $0x8041f1
  801ca9:	e8 ab e8 ff ff       	call   800559 <_panic>
  801cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb1:	8b 40 08             	mov    0x8(%eax),%eax
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	74 11                	je     801cc9 <free_pages+0x18d>
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	8b 40 08             	mov    0x8(%eax),%eax
  801cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc1:	8b 52 0c             	mov    0xc(%edx),%edx
  801cc4:	89 50 0c             	mov    %edx,0xc(%eax)
  801cc7:	eb 0b                	jmp    801cd4 <free_pages+0x198>
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccf:	a3 28 50 80 00       	mov    %eax,0x805028
  801cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	74 11                	je     801cef <free_pages+0x1b3>
  801cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce7:	8b 52 08             	mov    0x8(%edx),%edx
  801cea:	89 50 08             	mov    %edx,0x8(%eax)
  801ced:	eb 0b                	jmp    801cfa <free_pages+0x1be>
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	8b 40 08             	mov    0x8(%eax),%eax
  801cf5:	a3 24 50 80 00       	mov    %eax,0x805024
  801cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d0e:	a1 30 50 80 00       	mov    0x805030,%eax
  801d13:	48                   	dec    %eax
  801d14:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1f:	e8 24 15 00 00       	call   803248 <free_block>
  801d24:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801d27:	e8 72 fb ff ff       	call   80189e <recompute_page_alloc_break>

			return;
  801d2c:	eb 37                	jmp    801d65 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d2e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3a:	74 08                	je     801d44 <free_pages+0x208>
  801d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3f:	8b 40 08             	mov    0x8(%eax),%eax
  801d42:	eb 05                	jmp    801d49 <free_pages+0x20d>
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
  801d49:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801d4e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d53:	85 c0                	test   %eax,%eax
  801d55:	0f 85 fa fd ff ff    	jne    801b55 <free_pages+0x19>
  801d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5f:	0f 85 f0 fd ff ff    	jne    801b55 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d77:	a1 08 50 80 00       	mov    0x805008,%eax
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	74 60                	je     801de0 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801d80:	83 ec 08             	sub    $0x8,%esp
  801d83:	68 00 00 00 82       	push   $0x82000000
  801d88:	68 00 00 00 80       	push   $0x80000000
  801d8d:	e8 0d 0d 00 00       	call   802a9f <initialize_dynamic_allocator>
  801d92:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801d95:	e8 f3 0a 00 00       	call   80288d <sys_get_uheap_strategy>
  801d9a:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801d9f:	a1 40 50 80 00       	mov    0x805040,%eax
  801da4:	05 00 10 00 00       	add    $0x1000,%eax
  801da9:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801dae:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801db3:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801db8:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801dbf:	00 00 00 
  801dc2:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801dc9:	00 00 00 
  801dcc:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801dd3:	00 00 00 

		__firstTimeFlag = 0;
  801dd6:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801ddd:	00 00 00 
	}
}
  801de0:	90                   	nop
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801df7:	83 ec 08             	sub    $0x8,%esp
  801dfa:	68 06 04 00 00       	push   $0x406
  801dff:	50                   	push   %eax
  801e00:	e8 d2 06 00 00       	call   8024d7 <__sys_allocate_page>
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e0f:	79 17                	jns    801e28 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	68 c0 43 80 00       	push   $0x8043c0
  801e19:	68 ea 00 00 00       	push   $0xea
  801e1e:	68 f1 41 80 00       	push   $0x8041f1
  801e23:	e8 31 e7 ff ff       	call   800559 <_panic>
	return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	50                   	push   %eax
  801e47:	e8 d2 06 00 00       	call   80251e <__sys_unmap_frame>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e56:	79 17                	jns    801e6f <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	68 fc 43 80 00       	push   $0x8043fc
  801e60:	68 f5 00 00 00       	push   $0xf5
  801e65:	68 f1 41 80 00       	push   $0x8041f1
  801e6a:	e8 ea e6 ff ff       	call   800559 <_panic>
}
  801e6f:	90                   	nop
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e78:	e8 f4 fe ff ff       	call   801d71 <uheap_init>
	if (size == 0) return NULL ;
  801e7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e81:	75 0a                	jne    801e8d <malloc+0x1b>
  801e83:	b8 00 00 00 00       	mov    $0x0,%eax
  801e88:	e9 67 01 00 00       	jmp    801ff4 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801e8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801e94:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e9b:	77 16                	ja     801eb3 <malloc+0x41>
		result = alloc_block(size);
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	ff 75 08             	pushl  0x8(%ebp)
  801ea3:	e8 46 0e 00 00       	call   802cee <alloc_block>
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eae:	e9 3e 01 00 00       	jmp    801ff1 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801eb3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801eba:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec0:	01 d0                	add    %edx,%eax
  801ec2:	48                   	dec    %eax
  801ec3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ece:	f7 75 f0             	divl   -0x10(%ebp)
  801ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed4:	29 d0                	sub    %edx,%eax
  801ed6:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801ed9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	75 0a                	jne    801eec <malloc+0x7a>
			return NULL;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	e9 08 01 00 00       	jmp    801ff4 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801eec:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	74 0f                	je     801f04 <malloc+0x92>
  801ef5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801efb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f00:	39 c2                	cmp    %eax,%edx
  801f02:	73 0a                	jae    801f0e <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801f04:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f09:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801f0e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801f13:	83 f8 05             	cmp    $0x5,%eax
  801f16:	75 11                	jne    801f29 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	ff 75 e8             	pushl  -0x18(%ebp)
  801f1e:	e8 ff f9 ff ff       	call   801922 <alloc_pages_custom_fit>
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801f29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2d:	0f 84 be 00 00 00    	je     801ff1 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3f:	e8 9a fb ff ff       	call   801ade <find_allocated_size>
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801f4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f4e:	75 17                	jne    801f67 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801f50:	ff 75 f4             	pushl  -0xc(%ebp)
  801f53:	68 3c 44 80 00       	push   $0x80443c
  801f58:	68 24 01 00 00       	push   $0x124
  801f5d:	68 f1 41 80 00       	push   $0x8041f1
  801f62:	e8 f2 e5 ff ff       	call   800559 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6a:	f7 d0                	not    %eax
  801f6c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f6f:	73 1d                	jae    801f8e <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	ff 75 e0             	pushl  -0x20(%ebp)
  801f77:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f7a:	68 84 44 80 00       	push   $0x804484
  801f7f:	68 29 01 00 00       	push   $0x129
  801f84:	68 f1 41 80 00       	push   $0x8041f1
  801f89:	e8 cb e5 ff ff       	call   800559 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801f8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f94:	01 d0                	add    %edx,%eax
  801f96:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	79 2c                	jns    801fcc <malloc+0x15a>
  801fa0:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801fa7:	77 23                	ja     801fcc <malloc+0x15a>
  801fa9:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801fb0:	77 1a                	ja     801fcc <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801fb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	79 13                	jns    801fcc <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801fb9:	83 ec 08             	sub    $0x8,%esp
  801fbc:	ff 75 e0             	pushl  -0x20(%ebp)
  801fbf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc2:	e8 de 09 00 00       	call   8029a5 <sys_allocate_user_mem>
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	eb 25                	jmp    801ff1 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801fcc:	68 00 00 00 a0       	push   $0xa0000000
  801fd1:	ff 75 dc             	pushl  -0x24(%ebp)
  801fd4:	ff 75 e0             	pushl  -0x20(%ebp)
  801fd7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fda:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdd:	68 c0 44 80 00       	push   $0x8044c0
  801fe2:	68 33 01 00 00       	push   $0x133
  801fe7:	68 f1 41 80 00       	push   $0x8041f1
  801fec:	e8 68 e5 ff ff       	call   800559 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801ffc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802000:	0f 84 26 01 00 00    	je     80212c <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	79 1c                	jns    80202f <free+0x39>
  802013:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80201a:	77 13                	ja     80202f <free+0x39>
		free_block(virtual_address);
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	ff 75 08             	pushl  0x8(%ebp)
  802022:	e8 21 12 00 00       	call   803248 <free_block>
  802027:	83 c4 10             	add    $0x10,%esp
		return;
  80202a:	e9 01 01 00 00       	jmp    802130 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  80202f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802034:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802037:	0f 82 d8 00 00 00    	jb     802115 <free+0x11f>
  80203d:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802044:	0f 87 cb 00 00 00    	ja     802115 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802052:	85 c0                	test   %eax,%eax
  802054:	74 17                	je     80206d <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802056:	ff 75 08             	pushl  0x8(%ebp)
  802059:	68 30 45 80 00       	push   $0x804530
  80205e:	68 57 01 00 00       	push   $0x157
  802063:	68 f1 41 80 00       	push   $0x8041f1
  802068:	e8 ec e4 ff ff       	call   800559 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	e8 66 fa ff ff       	call   801ade <find_allocated_size>
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  80207e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802082:	0f 84 a7 00 00 00    	je     80212f <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208b:	f7 d0                	not    %eax
  80208d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802090:	73 1d                	jae    8020af <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	ff 75 f0             	pushl  -0x10(%ebp)
  802098:	ff 75 f4             	pushl  -0xc(%ebp)
  80209b:	68 58 45 80 00       	push   $0x804558
  8020a0:	68 61 01 00 00       	push   $0x161
  8020a5:	68 f1 41 80 00       	push   $0x8041f1
  8020aa:	e8 aa e4 ff ff       	call   800559 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8020af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	79 19                	jns    8020da <free+0xe4>
  8020c1:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8020c8:	77 10                	ja     8020da <free+0xe4>
  8020ca:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8020d1:	77 07                	ja     8020da <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8020d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	78 2b                	js     802105 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	68 00 00 00 a0       	push   $0xa0000000
  8020e2:	ff 75 ec             	pushl  -0x14(%ebp)
  8020e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ee:	ff 75 08             	pushl  0x8(%ebp)
  8020f1:	68 94 45 80 00       	push   $0x804594
  8020f6:	68 69 01 00 00       	push   $0x169
  8020fb:	68 f1 41 80 00       	push   $0x8041f1
  802100:	e8 54 e4 ff ff       	call   800559 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	e8 2c fa ff ff       	call   801b3c <free_pages>
  802110:	83 c4 10             	add    $0x10,%esp
		return;
  802113:	eb 1b                	jmp    802130 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802115:	ff 75 08             	pushl  0x8(%ebp)
  802118:	68 f0 45 80 00       	push   $0x8045f0
  80211d:	68 70 01 00 00       	push   $0x170
  802122:	68 f1 41 80 00       	push   $0x8041f1
  802127:	e8 2d e4 ff ff       	call   800559 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80212c:	90                   	nop
  80212d:	eb 01                	jmp    802130 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  80212f:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 38             	sub    $0x38,%esp
  802138:	8b 45 10             	mov    0x10(%ebp),%eax
  80213b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80213e:	e8 2e fc ff ff       	call   801d71 <uheap_init>
	if (size == 0) return NULL ;
  802143:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802147:	75 0a                	jne    802153 <smalloc+0x21>
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
  80214e:	e9 3d 01 00 00       	jmp    802290 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802153:	8b 45 0c             	mov    0xc(%ebp),%eax
  802156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215c:	25 ff 0f 00 00       	and    $0xfff,%eax
  802161:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802164:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802168:	74 0e                	je     802178 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802170:	05 00 10 00 00       	add    $0x1000,%eax
  802175:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	c1 e8 0c             	shr    $0xc,%eax
  80217e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802181:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	75 0a                	jne    802194 <smalloc+0x62>
		return NULL;
  80218a:	b8 00 00 00 00       	mov    $0x0,%eax
  80218f:	e9 fc 00 00 00       	jmp    802290 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802194:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 0f                	je     8021ac <smalloc+0x7a>
  80219d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021a3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021a8:	39 c2                	cmp    %eax,%edx
  8021aa:	73 0a                	jae    8021b6 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8021ac:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021b1:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8021b6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021bb:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8021c0:	29 c2                	sub    %eax,%edx
  8021c2:	89 d0                	mov    %edx,%eax
  8021c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8021c7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021cd:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021d2:	29 c2                	sub    %eax,%edx
  8021d4:	89 d0                	mov    %edx,%eax
  8021d6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021df:	77 13                	ja     8021f4 <smalloc+0xc2>
  8021e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021e7:	77 0b                	ja     8021f4 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8021e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ec:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8021ef:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8021f2:	73 0a                	jae    8021fe <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f9:	e9 92 00 00 00       	jmp    802290 <smalloc+0x15e>
	}

	void *va = NULL;
  8021fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802205:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80220a:	83 f8 05             	cmp    $0x5,%eax
  80220d:	75 11                	jne    802220 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  80220f:	83 ec 0c             	sub    $0xc,%esp
  802212:	ff 75 f4             	pushl  -0xc(%ebp)
  802215:	e8 08 f7 ff ff       	call   801922 <alloc_pages_custom_fit>
  80221a:	83 c4 10             	add    $0x10,%esp
  80221d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802220:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802224:	75 27                	jne    80224d <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802226:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80222d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802230:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802233:	89 c2                	mov    %eax,%edx
  802235:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80223a:	39 c2                	cmp    %eax,%edx
  80223c:	73 07                	jae    802245 <smalloc+0x113>
			return NULL;}
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
  802243:	eb 4b                	jmp    802290 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802245:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80224a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80224d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802251:	ff 75 f0             	pushl  -0x10(%ebp)
  802254:	50                   	push   %eax
  802255:	ff 75 0c             	pushl  0xc(%ebp)
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	e8 cb 03 00 00       	call   80262b <sys_create_shared_object>
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802266:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80226a:	79 07                	jns    802273 <smalloc+0x141>
		return NULL;
  80226c:	b8 00 00 00 00       	mov    $0x0,%eax
  802271:	eb 1d                	jmp    802290 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802273:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802278:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  80227b:	75 10                	jne    80228d <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  80227d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	01 d0                	add    %edx,%eax
  802288:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802298:	e8 d4 fa ff ff       	call   801d71 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80229d:	83 ec 08             	sub    $0x8,%esp
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	ff 75 08             	pushl  0x8(%ebp)
  8022a6:	e8 aa 03 00 00       	call   802655 <sys_size_of_shared_object>
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8022b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022b5:	7f 0a                	jg     8022c1 <sget+0x2f>
		return NULL;
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	e9 32 01 00 00       	jmp    8023f3 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8022c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8022c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ca:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8022d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022d6:	74 0e                	je     8022e6 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8022de:	05 00 10 00 00       	add    $0x1000,%eax
  8022e3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8022e6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 0a                	jne    8022f9 <sget+0x67>
		return NULL;
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	e9 fa 00 00 00       	jmp    8023f3 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8022f9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 0f                	je     802311 <sget+0x7f>
  802302:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802308:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80230d:	39 c2                	cmp    %eax,%edx
  80230f:	73 0a                	jae    80231b <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802311:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802316:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80231b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802320:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802325:	29 c2                	sub    %eax,%edx
  802327:	89 d0                	mov    %edx,%eax
  802329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80232c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802332:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802337:	29 c2                	sub    %eax,%edx
  802339:	89 d0                	mov    %edx,%eax
  80233b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802344:	77 13                	ja     802359 <sget+0xc7>
  802346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802349:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80234c:	77 0b                	ja     802359 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  80234e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802351:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802357:	73 0a                	jae    802363 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802359:	b8 00 00 00 00       	mov    $0x0,%eax
  80235e:	e9 90 00 00 00       	jmp    8023f3 <sget+0x161>

	void *va = NULL;
  802363:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80236a:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80236f:	83 f8 05             	cmp    $0x5,%eax
  802372:	75 11                	jne    802385 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802374:	83 ec 0c             	sub    $0xc,%esp
  802377:	ff 75 f4             	pushl  -0xc(%ebp)
  80237a:	e8 a3 f5 ff ff       	call   801922 <alloc_pages_custom_fit>
  80237f:	83 c4 10             	add    $0x10,%esp
  802382:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802385:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802389:	75 27                	jne    8023b2 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80238b:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802392:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802395:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802398:	89 c2                	mov    %eax,%edx
  80239a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80239f:	39 c2                	cmp    %eax,%edx
  8023a1:	73 07                	jae    8023aa <sget+0x118>
			return NULL;
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a8:	eb 49                	jmp    8023f3 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8023aa:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8023af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8023b2:	83 ec 04             	sub    $0x4,%esp
  8023b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8023b8:	ff 75 0c             	pushl  0xc(%ebp)
  8023bb:	ff 75 08             	pushl  0x8(%ebp)
  8023be:	e8 af 02 00 00       	call   802672 <sys_get_shared_object>
  8023c3:	83 c4 10             	add    $0x10,%esp
  8023c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8023c9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8023cd:	79 07                	jns    8023d6 <sget+0x144>
		return NULL;
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	eb 1d                	jmp    8023f3 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8023d6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8023db:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8023de:	75 10                	jne    8023f0 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8023e0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	01 d0                	add    %edx,%eax
  8023eb:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023fb:	e8 71 f9 ff ff       	call   801d71 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	68 14 46 80 00       	push   $0x804614
  802408:	68 19 02 00 00       	push   $0x219
  80240d:	68 f1 41 80 00       	push   $0x8041f1
  802412:	e8 42 e1 ff ff       	call   800559 <_panic>

00802417 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80241d:	83 ec 04             	sub    $0x4,%esp
  802420:	68 3c 46 80 00       	push   $0x80463c
  802425:	68 2b 02 00 00       	push   $0x22b
  80242a:	68 f1 41 80 00       	push   $0x8041f1
  80242f:	e8 25 e1 ff ff       	call   800559 <_panic>

00802434 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	57                   	push   %edi
  802438:	56                   	push   %esi
  802439:	53                   	push   %ebx
  80243a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8b 55 0c             	mov    0xc(%ebp),%edx
  802443:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802446:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802449:	8b 7d 18             	mov    0x18(%ebp),%edi
  80244c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80244f:	cd 30                	int    $0x30
  802451:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802457:	83 c4 10             	add    $0x10,%esp
  80245a:	5b                   	pop    %ebx
  80245b:	5e                   	pop    %esi
  80245c:	5f                   	pop    %edi
  80245d:	5d                   	pop    %ebp
  80245e:	c3                   	ret    

0080245f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	8b 45 10             	mov    0x10(%ebp),%eax
  802468:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80246b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80246e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	6a 00                	push   $0x0
  802477:	51                   	push   %ecx
  802478:	52                   	push   %edx
  802479:	ff 75 0c             	pushl  0xc(%ebp)
  80247c:	50                   	push   %eax
  80247d:	6a 00                	push   $0x0
  80247f:	e8 b0 ff ff ff       	call   802434 <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
}
  802487:	90                   	nop
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_cgetc>:

int
sys_cgetc(void)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 02                	push   $0x2
  802499:	e8 96 ff ff ff       	call   802434 <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 03                	push   $0x3
  8024b2:	e8 7d ff ff ff       	call   802434 <syscall>
  8024b7:	83 c4 18             	add    $0x18,%esp
}
  8024ba:	90                   	nop
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 04                	push   $0x4
  8024cc:	e8 63 ff ff ff       	call   802434 <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
}
  8024d4:	90                   	nop
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	52                   	push   %edx
  8024e7:	50                   	push   %eax
  8024e8:	6a 08                	push   $0x8
  8024ea:	e8 45 ff ff ff       	call   802434 <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	56                   	push   %esi
  8024f8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8024fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802502:	8b 55 0c             	mov    0xc(%ebp),%edx
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	56                   	push   %esi
  802509:	53                   	push   %ebx
  80250a:	51                   	push   %ecx
  80250b:	52                   	push   %edx
  80250c:	50                   	push   %eax
  80250d:	6a 09                	push   $0x9
  80250f:	e8 20 ff ff ff       	call   802434 <syscall>
  802514:	83 c4 18             	add    $0x18,%esp
}
  802517:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80251a:	5b                   	pop    %ebx
  80251b:	5e                   	pop    %esi
  80251c:	5d                   	pop    %ebp
  80251d:	c3                   	ret    

0080251e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	ff 75 08             	pushl  0x8(%ebp)
  80252c:	6a 0a                	push   $0xa
  80252e:	e8 01 ff ff ff       	call   802434 <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	ff 75 0c             	pushl  0xc(%ebp)
  802544:	ff 75 08             	pushl  0x8(%ebp)
  802547:	6a 0b                	push   $0xb
  802549:	e8 e6 fe ff ff       	call   802434 <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 0c                	push   $0xc
  802562:	e8 cd fe ff ff       	call   802434 <syscall>
  802567:	83 c4 18             	add    $0x18,%esp
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 0d                	push   $0xd
  80257b:	e8 b4 fe ff ff       	call   802434 <syscall>
  802580:	83 c4 18             	add    $0x18,%esp
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 0e                	push   $0xe
  802594:	e8 9b fe ff ff       	call   802434 <syscall>
  802599:	83 c4 18             	add    $0x18,%esp
}
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 0f                	push   $0xf
  8025ad:	e8 82 fe ff ff       	call   802434 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
}
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	ff 75 08             	pushl  0x8(%ebp)
  8025c5:	6a 10                	push   $0x10
  8025c7:	e8 68 fe ff ff       	call   802434 <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 11                	push   $0x11
  8025e0:	e8 4f fe ff ff       	call   802434 <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
}
  8025e8:	90                   	nop
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <sys_cputc>:

void
sys_cputc(const char c)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8025f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	50                   	push   %eax
  802604:	6a 01                	push   $0x1
  802606:	e8 29 fe ff ff       	call   802434 <syscall>
  80260b:	83 c4 18             	add    $0x18,%esp
}
  80260e:	90                   	nop
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 14                	push   $0x14
  802620:	e8 0f fe ff ff       	call   802434 <syscall>
  802625:	83 c4 18             	add    $0x18,%esp
}
  802628:	90                   	nop
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 04             	sub    $0x4,%esp
  802631:	8b 45 10             	mov    0x10(%ebp),%eax
  802634:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802637:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80263a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	6a 00                	push   $0x0
  802643:	51                   	push   %ecx
  802644:	52                   	push   %edx
  802645:	ff 75 0c             	pushl  0xc(%ebp)
  802648:	50                   	push   %eax
  802649:	6a 15                	push   $0x15
  80264b:	e8 e4 fd ff ff       	call   802434 <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	52                   	push   %edx
  802665:	50                   	push   %eax
  802666:	6a 16                	push   $0x16
  802668:	e8 c7 fd ff ff       	call   802434 <syscall>
  80266d:	83 c4 18             	add    $0x18,%esp
}
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802675:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	51                   	push   %ecx
  802683:	52                   	push   %edx
  802684:	50                   	push   %eax
  802685:	6a 17                	push   $0x17
  802687:	e8 a8 fd ff ff       	call   802434 <syscall>
  80268c:	83 c4 18             	add    $0x18,%esp
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802694:	8b 55 0c             	mov    0xc(%ebp),%edx
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	52                   	push   %edx
  8026a1:	50                   	push   %eax
  8026a2:	6a 18                	push   $0x18
  8026a4:	e8 8b fd ff ff       	call   802434 <syscall>
  8026a9:	83 c4 18             	add    $0x18,%esp
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b4:	6a 00                	push   $0x0
  8026b6:	ff 75 14             	pushl  0x14(%ebp)
  8026b9:	ff 75 10             	pushl  0x10(%ebp)
  8026bc:	ff 75 0c             	pushl  0xc(%ebp)
  8026bf:	50                   	push   %eax
  8026c0:	6a 19                	push   $0x19
  8026c2:	e8 6d fd ff ff       	call   802434 <syscall>
  8026c7:	83 c4 18             	add    $0x18,%esp
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	50                   	push   %eax
  8026db:	6a 1a                	push   $0x1a
  8026dd:	e8 52 fd ff ff       	call   802434 <syscall>
  8026e2:	83 c4 18             	add    $0x18,%esp
}
  8026e5:	90                   	nop
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	50                   	push   %eax
  8026f7:	6a 1b                	push   $0x1b
  8026f9:	e8 36 fd ff ff       	call   802434 <syscall>
  8026fe:	83 c4 18             	add    $0x18,%esp
}
  802701:	c9                   	leave  
  802702:	c3                   	ret    

00802703 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 05                	push   $0x5
  802712:	e8 1d fd ff ff       	call   802434 <syscall>
  802717:	83 c4 18             	add    $0x18,%esp
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 06                	push   $0x6
  80272b:	e8 04 fd ff ff       	call   802434 <syscall>
  802730:	83 c4 18             	add    $0x18,%esp
}
  802733:	c9                   	leave  
  802734:	c3                   	ret    

00802735 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 07                	push   $0x7
  802744:	e8 eb fc ff ff       	call   802434 <syscall>
  802749:	83 c4 18             	add    $0x18,%esp
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <sys_exit_env>:


void sys_exit_env(void)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 1c                	push   $0x1c
  80275d:	e8 d2 fc ff ff       	call   802434 <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
}
  802765:	90                   	nop
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80276e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802771:	8d 50 04             	lea    0x4(%eax),%edx
  802774:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	52                   	push   %edx
  80277e:	50                   	push   %eax
  80277f:	6a 1d                	push   $0x1d
  802781:	e8 ae fc ff ff       	call   802434 <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
	return result;
  802789:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80278c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80278f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802792:	89 01                	mov    %eax,(%ecx)
  802794:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	c9                   	leave  
  80279b:	c2 04 00             	ret    $0x4

0080279e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	ff 75 10             	pushl  0x10(%ebp)
  8027a8:	ff 75 0c             	pushl  0xc(%ebp)
  8027ab:	ff 75 08             	pushl  0x8(%ebp)
  8027ae:	6a 13                	push   $0x13
  8027b0:	e8 7f fc ff ff       	call   802434 <syscall>
  8027b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027b8:	90                   	nop
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <sys_rcr2>:
uint32 sys_rcr2()
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 1e                	push   $0x1e
  8027ca:	e8 65 fc ff ff       	call   802434 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	83 ec 04             	sub    $0x4,%esp
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027e0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	50                   	push   %eax
  8027ed:	6a 1f                	push   $0x1f
  8027ef:	e8 40 fc ff ff       	call   802434 <syscall>
  8027f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f7:	90                   	nop
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <rsttst>:
void rsttst()
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 21                	push   $0x21
  802809:	e8 26 fc ff ff       	call   802434 <syscall>
  80280e:	83 c4 18             	add    $0x18,%esp
	return ;
  802811:	90                   	nop
}
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	8b 45 14             	mov    0x14(%ebp),%eax
  80281d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802820:	8b 55 18             	mov    0x18(%ebp),%edx
  802823:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802827:	52                   	push   %edx
  802828:	50                   	push   %eax
  802829:	ff 75 10             	pushl  0x10(%ebp)
  80282c:	ff 75 0c             	pushl  0xc(%ebp)
  80282f:	ff 75 08             	pushl  0x8(%ebp)
  802832:	6a 20                	push   $0x20
  802834:	e8 fb fb ff ff       	call   802434 <syscall>
  802839:	83 c4 18             	add    $0x18,%esp
	return ;
  80283c:	90                   	nop
}
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <chktst>:
void chktst(uint32 n)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	ff 75 08             	pushl  0x8(%ebp)
  80284d:	6a 22                	push   $0x22
  80284f:	e8 e0 fb ff ff       	call   802434 <syscall>
  802854:	83 c4 18             	add    $0x18,%esp
	return ;
  802857:	90                   	nop
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <inctst>:

void inctst()
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80285d:	6a 00                	push   $0x0
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 23                	push   $0x23
  802869:	e8 c6 fb ff ff       	call   802434 <syscall>
  80286e:	83 c4 18             	add    $0x18,%esp
	return ;
  802871:	90                   	nop
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <gettst>:
uint32 gettst()
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 24                	push   $0x24
  802883:	e8 ac fb ff ff       	call   802434 <syscall>
  802888:	83 c4 18             	add    $0x18,%esp
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	6a 25                	push   $0x25
  80289c:	e8 93 fb ff ff       	call   802434 <syscall>
  8028a1:	83 c4 18             	add    $0x18,%esp
  8028a4:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  8028a9:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	6a 00                	push   $0x0
  8028c1:	6a 00                	push   $0x0
  8028c3:	ff 75 08             	pushl  0x8(%ebp)
  8028c6:	6a 26                	push   $0x26
  8028c8:	e8 67 fb ff ff       	call   802434 <syscall>
  8028cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d0:	90                   	nop
}
  8028d1:	c9                   	leave  
  8028d2:	c3                   	ret    

008028d3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028d3:	55                   	push   %ebp
  8028d4:	89 e5                	mov    %esp,%ebp
  8028d6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	6a 00                	push   $0x0
  8028e5:	53                   	push   %ebx
  8028e6:	51                   	push   %ecx
  8028e7:	52                   	push   %edx
  8028e8:	50                   	push   %eax
  8028e9:	6a 27                	push   $0x27
  8028eb:	e8 44 fb ff ff       	call   802434 <syscall>
  8028f0:	83 c4 18             	add    $0x18,%esp
}
  8028f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	6a 00                	push   $0x0
  802903:	6a 00                	push   $0x0
  802905:	6a 00                	push   $0x0
  802907:	52                   	push   %edx
  802908:	50                   	push   %eax
  802909:	6a 28                	push   $0x28
  80290b:	e8 24 fb ff ff       	call   802434 <syscall>
  802910:	83 c4 18             	add    $0x18,%esp
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802918:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80291b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	6a 00                	push   $0x0
  802923:	51                   	push   %ecx
  802924:	ff 75 10             	pushl  0x10(%ebp)
  802927:	52                   	push   %edx
  802928:	50                   	push   %eax
  802929:	6a 29                	push   $0x29
  80292b:	e8 04 fb ff ff       	call   802434 <syscall>
  802930:	83 c4 18             	add    $0x18,%esp
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	ff 75 10             	pushl  0x10(%ebp)
  80293f:	ff 75 0c             	pushl  0xc(%ebp)
  802942:	ff 75 08             	pushl  0x8(%ebp)
  802945:	6a 12                	push   $0x12
  802947:	e8 e8 fa ff ff       	call   802434 <syscall>
  80294c:	83 c4 18             	add    $0x18,%esp
	return ;
  80294f:	90                   	nop
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802955:	8b 55 0c             	mov    0xc(%ebp),%edx
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	52                   	push   %edx
  802962:	50                   	push   %eax
  802963:	6a 2a                	push   $0x2a
  802965:	e8 ca fa ff ff       	call   802434 <syscall>
  80296a:	83 c4 18             	add    $0x18,%esp
	return;
  80296d:	90                   	nop
}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	6a 2b                	push   $0x2b
  80297f:	e8 b0 fa ff ff       	call   802434 <syscall>
  802984:	83 c4 18             	add    $0x18,%esp
}
  802987:	c9                   	leave  
  802988:	c3                   	ret    

00802989 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	ff 75 0c             	pushl  0xc(%ebp)
  802995:	ff 75 08             	pushl  0x8(%ebp)
  802998:	6a 2d                	push   $0x2d
  80299a:	e8 95 fa ff ff       	call   802434 <syscall>
  80299f:	83 c4 18             	add    $0x18,%esp
	return;
  8029a2:	90                   	nop
}
  8029a3:	c9                   	leave  
  8029a4:	c3                   	ret    

008029a5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	ff 75 0c             	pushl  0xc(%ebp)
  8029b1:	ff 75 08             	pushl  0x8(%ebp)
  8029b4:	6a 2c                	push   $0x2c
  8029b6:	e8 79 fa ff ff       	call   802434 <syscall>
  8029bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8029be:	90                   	nop
}
  8029bf:	c9                   	leave  
  8029c0:	c3                   	ret    

008029c1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8029c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	52                   	push   %edx
  8029d1:	50                   	push   %eax
  8029d2:	6a 2e                	push   $0x2e
  8029d4:	e8 5b fa ff ff       	call   802434 <syscall>
  8029d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8029dc:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8029dd:	c9                   	leave  
  8029de:	c3                   	ret    

008029df <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8029e5:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8029ec:	72 09                	jb     8029f7 <to_page_va+0x18>
  8029ee:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8029f5:	72 14                	jb     802a0b <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 60 46 80 00       	push   $0x804660
  8029ff:	6a 15                	push   $0x15
  802a01:	68 8b 46 80 00       	push   $0x80468b
  802a06:	e8 4e db ff ff       	call   800559 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	ba 60 50 80 00       	mov    $0x805060,%edx
  802a13:	29 d0                	sub    %edx,%eax
  802a15:	c1 f8 02             	sar    $0x2,%eax
  802a18:	89 c2                	mov    %eax,%edx
  802a1a:	89 d0                	mov    %edx,%eax
  802a1c:	c1 e0 02             	shl    $0x2,%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	c1 e0 02             	shl    $0x2,%eax
  802a24:	01 d0                	add    %edx,%eax
  802a26:	c1 e0 02             	shl    $0x2,%eax
  802a29:	01 d0                	add    %edx,%eax
  802a2b:	89 c1                	mov    %eax,%ecx
  802a2d:	c1 e1 08             	shl    $0x8,%ecx
  802a30:	01 c8                	add    %ecx,%eax
  802a32:	89 c1                	mov    %eax,%ecx
  802a34:	c1 e1 10             	shl    $0x10,%ecx
  802a37:	01 c8                	add    %ecx,%eax
  802a39:	01 c0                	add    %eax,%eax
  802a3b:	01 d0                	add    %edx,%eax
  802a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	c1 e0 0c             	shl    $0xc,%eax
  802a46:	89 c2                	mov    %eax,%edx
  802a48:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a4d:	01 d0                	add    %edx,%eax
}
  802a4f:	c9                   	leave  
  802a50:	c3                   	ret    

00802a51 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802a51:	55                   	push   %ebp
  802a52:	89 e5                	mov    %esp,%ebp
  802a54:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802a57:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5f:	29 c2                	sub    %eax,%edx
  802a61:	89 d0                	mov    %edx,%eax
  802a63:	c1 e8 0c             	shr    $0xc,%eax
  802a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6d:	78 09                	js     802a78 <to_page_info+0x27>
  802a6f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802a76:	7e 14                	jle    802a8c <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 a4 46 80 00       	push   $0x8046a4
  802a80:	6a 22                	push   $0x22
  802a82:	68 8b 46 80 00       	push   $0x80468b
  802a87:	e8 cd da ff ff       	call   800559 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8f:	89 d0                	mov    %edx,%eax
  802a91:	01 c0                	add    %eax,%eax
  802a93:	01 d0                	add    %edx,%eax
  802a95:	c1 e0 02             	shl    $0x2,%eax
  802a98:	05 60 50 80 00       	add    $0x805060,%eax
}
  802a9d:	c9                   	leave  
  802a9e:	c3                   	ret    

00802a9f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	05 00 00 00 02       	add    $0x2000000,%eax
  802aad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ab0:	73 16                	jae    802ac8 <initialize_dynamic_allocator+0x29>
  802ab2:	68 c8 46 80 00       	push   $0x8046c8
  802ab7:	68 ee 46 80 00       	push   $0x8046ee
  802abc:	6a 34                	push   $0x34
  802abe:	68 8b 46 80 00       	push   $0x80468b
  802ac3:	e8 91 da ff ff       	call   800559 <_panic>
		is_initialized = 1;
  802ac8:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802acf:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  802add:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802ae2:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802ae9:	00 00 00 
  802aec:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802af3:	00 00 00 
  802af6:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802afd:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802b00:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802b07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b0e:	eb 36                	jmp    802b46 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	c1 e0 04             	shl    $0x4,%eax
  802b16:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	c1 e0 04             	shl    $0x4,%eax
  802b27:	05 84 d0 81 00       	add    $0x81d084,%eax
  802b2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	c1 e0 04             	shl    $0x4,%eax
  802b38:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802b43:	ff 45 f4             	incl   -0xc(%ebp)
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b4c:	72 c2                	jb     802b10 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802b4e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b54:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b59:	29 c2                	sub    %eax,%edx
  802b5b:	89 d0                	mov    %edx,%eax
  802b5d:	c1 e8 0c             	shr    $0xc,%eax
  802b60:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802b63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802b6a:	e9 c8 00 00 00       	jmp    802c37 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802b6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b72:	89 d0                	mov    %edx,%eax
  802b74:	01 c0                	add    %eax,%eax
  802b76:	01 d0                	add    %edx,%eax
  802b78:	c1 e0 02             	shl    $0x2,%eax
  802b7b:	05 68 50 80 00       	add    $0x805068,%eax
  802b80:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b88:	89 d0                	mov    %edx,%eax
  802b8a:	01 c0                	add    %eax,%eax
  802b8c:	01 d0                	add    %edx,%eax
  802b8e:	c1 e0 02             	shl    $0x2,%eax
  802b91:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b96:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802b9b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ba1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ba4:	89 c8                	mov    %ecx,%eax
  802ba6:	01 c0                	add    %eax,%eax
  802ba8:	01 c8                	add    %ecx,%eax
  802baa:	c1 e0 02             	shl    $0x2,%eax
  802bad:	05 64 50 80 00       	add    $0x805064,%eax
  802bb2:	89 10                	mov    %edx,(%eax)
  802bb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb7:	89 d0                	mov    %edx,%eax
  802bb9:	01 c0                	add    %eax,%eax
  802bbb:	01 d0                	add    %edx,%eax
  802bbd:	c1 e0 02             	shl    $0x2,%eax
  802bc0:	05 64 50 80 00       	add    $0x805064,%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	74 1b                	je     802be6 <initialize_dynamic_allocator+0x147>
  802bcb:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802bd1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802bd4:	89 c8                	mov    %ecx,%eax
  802bd6:	01 c0                	add    %eax,%eax
  802bd8:	01 c8                	add    %ecx,%eax
  802bda:	c1 e0 02             	shl    $0x2,%eax
  802bdd:	05 60 50 80 00       	add    $0x805060,%eax
  802be2:	89 02                	mov    %eax,(%edx)
  802be4:	eb 16                	jmp    802bfc <initialize_dynamic_allocator+0x15d>
  802be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be9:	89 d0                	mov    %edx,%eax
  802beb:	01 c0                	add    %eax,%eax
  802bed:	01 d0                	add    %edx,%eax
  802bef:	c1 e0 02             	shl    $0x2,%eax
  802bf2:	05 60 50 80 00       	add    $0x805060,%eax
  802bf7:	a3 48 50 80 00       	mov    %eax,0x805048
  802bfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bff:	89 d0                	mov    %edx,%eax
  802c01:	01 c0                	add    %eax,%eax
  802c03:	01 d0                	add    %edx,%eax
  802c05:	c1 e0 02             	shl    $0x2,%eax
  802c08:	05 60 50 80 00       	add    $0x805060,%eax
  802c0d:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c15:	89 d0                	mov    %edx,%eax
  802c17:	01 c0                	add    %eax,%eax
  802c19:	01 d0                	add    %edx,%eax
  802c1b:	c1 e0 02             	shl    $0x2,%eax
  802c1e:	05 60 50 80 00       	add    $0x805060,%eax
  802c23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c29:	a1 54 50 80 00       	mov    0x805054,%eax
  802c2e:	40                   	inc    %eax
  802c2f:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802c34:	ff 45 f0             	incl   -0x10(%ebp)
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c3d:	0f 82 2c ff ff ff    	jb     802b6f <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c49:	eb 2f                	jmp    802c7a <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802c4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c4e:	89 d0                	mov    %edx,%eax
  802c50:	01 c0                	add    %eax,%eax
  802c52:	01 d0                	add    %edx,%eax
  802c54:	c1 e0 02             	shl    $0x2,%eax
  802c57:	05 68 50 80 00       	add    $0x805068,%eax
  802c5c:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802c61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c64:	89 d0                	mov    %edx,%eax
  802c66:	01 c0                	add    %eax,%eax
  802c68:	01 d0                	add    %edx,%eax
  802c6a:	c1 e0 02             	shl    $0x2,%eax
  802c6d:	05 6a 50 80 00       	add    $0x80506a,%eax
  802c72:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802c77:	ff 45 ec             	incl   -0x14(%ebp)
  802c7a:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802c81:	76 c8                	jbe    802c4b <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802c83:	90                   	nop
  802c84:	c9                   	leave  
  802c85:	c3                   	ret    

00802c86 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802c86:	55                   	push   %ebp
  802c87:	89 e5                	mov    %esp,%ebp
  802c89:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802c94:	29 c2                	sub    %eax,%edx
  802c96:	89 d0                	mov    %edx,%eax
  802c98:	c1 e8 0c             	shr    $0xc,%eax
  802c9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802c9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ca1:	89 d0                	mov    %edx,%eax
  802ca3:	01 c0                	add    %eax,%eax
  802ca5:	01 d0                	add    %edx,%eax
  802ca7:	c1 e0 02             	shl    $0x2,%eax
  802caa:	05 68 50 80 00       	add    $0x805068,%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802cb4:	c9                   	leave  
  802cb5:	c3                   	ret    

00802cb6 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802cb6:	55                   	push   %ebp
  802cb7:	89 e5                	mov    %esp,%ebp
  802cb9:	83 ec 14             	sub    $0x14,%esp
  802cbc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802cbf:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802cc3:	77 07                	ja     802ccc <nearest_pow2_ceil.1513+0x16>
  802cc5:	b8 01 00 00 00       	mov    $0x1,%eax
  802cca:	eb 20                	jmp    802cec <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802ccc:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802cd3:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802cd6:	eb 08                	jmp    802ce0 <nearest_pow2_ceil.1513+0x2a>
  802cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802cdb:	01 c0                	add    %eax,%eax
  802cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ce0:	d1 6d 08             	shrl   0x8(%ebp)
  802ce3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce7:	75 ef                	jne    802cd8 <nearest_pow2_ceil.1513+0x22>
        return power;
  802ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802cec:	c9                   	leave  
  802ced:	c3                   	ret    

00802cee <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
  802cf1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802cf4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802cfb:	76 16                	jbe    802d13 <alloc_block+0x25>
  802cfd:	68 04 47 80 00       	push   $0x804704
  802d02:	68 ee 46 80 00       	push   $0x8046ee
  802d07:	6a 72                	push   $0x72
  802d09:	68 8b 46 80 00       	push   $0x80468b
  802d0e:	e8 46 d8 ff ff       	call   800559 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802d13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d17:	75 0a                	jne    802d23 <alloc_block+0x35>
  802d19:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1e:	e9 bd 04 00 00       	jmp    8031e0 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802d23:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d30:	73 06                	jae    802d38 <alloc_block+0x4a>
        size = min_block_size;
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802d38:	83 ec 0c             	sub    $0xc,%esp
  802d3b:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802d3e:	ff 75 08             	pushl  0x8(%ebp)
  802d41:	89 c1                	mov    %eax,%ecx
  802d43:	e8 6e ff ff ff       	call   802cb6 <nearest_pow2_ceil.1513>
  802d48:	83 c4 10             	add    $0x10,%esp
  802d4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802d4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d51:	83 ec 0c             	sub    $0xc,%esp
  802d54:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802d57:	52                   	push   %edx
  802d58:	89 c1                	mov    %eax,%ecx
  802d5a:	e8 83 04 00 00       	call   8031e2 <log2_ceil.1520>
  802d5f:	83 c4 10             	add    $0x10,%esp
  802d62:	83 e8 03             	sub    $0x3,%eax
  802d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6b:	c1 e0 04             	shl    $0x4,%eax
  802d6e:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	85 c0                	test   %eax,%eax
  802d77:	0f 84 d8 00 00 00    	je     802e55 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d80:	c1 e0 04             	shl    $0x4,%eax
  802d83:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d91:	75 17                	jne    802daa <alloc_block+0xbc>
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 25 47 80 00       	push   $0x804725
  802d9b:	68 98 00 00 00       	push   $0x98
  802da0:	68 8b 46 80 00       	push   $0x80468b
  802da5:	e8 af d7 ff ff       	call   800559 <_panic>
  802daa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 10                	je     802dc3 <alloc_block+0xd5>
  802db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dbb:	8b 52 04             	mov    0x4(%edx),%edx
  802dbe:	89 50 04             	mov    %edx,0x4(%eax)
  802dc1:	eb 14                	jmp    802dd7 <alloc_block+0xe9>
  802dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc6:	8b 40 04             	mov    0x4(%eax),%eax
  802dc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dcc:	c1 e2 04             	shl    $0x4,%edx
  802dcf:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802dd5:	89 02                	mov    %eax,(%edx)
  802dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0f                	je     802df0 <alloc_block+0x102>
  802de1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dea:	8b 12                	mov    (%edx),%edx
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	eb 13                	jmp    802e03 <alloc_block+0x115>
  802df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802df8:	c1 e2 04             	shl    $0x4,%edx
  802dfb:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e01:	89 02                	mov    %eax,(%edx)
  802e03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e19:	c1 e0 04             	shl    $0x4,%eax
  802e1c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e29:	c1 e0 04             	shl    $0x4,%eax
  802e2c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e31:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e36:	83 ec 0c             	sub    $0xc,%esp
  802e39:	50                   	push   %eax
  802e3a:	e8 12 fc ff ff       	call   802a51 <to_page_info>
  802e3f:	83 c4 10             	add    $0x10,%esp
  802e42:	89 c2                	mov    %eax,%edx
  802e44:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802e48:	48                   	dec    %eax
  802e49:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e50:	e9 8b 03 00 00       	jmp    8031e0 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802e55:	a1 48 50 80 00       	mov    0x805048,%eax
  802e5a:	85 c0                	test   %eax,%eax
  802e5c:	0f 84 64 02 00 00    	je     8030c6 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802e62:	a1 48 50 80 00       	mov    0x805048,%eax
  802e67:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802e6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e6e:	75 17                	jne    802e87 <alloc_block+0x199>
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	68 25 47 80 00       	push   $0x804725
  802e78:	68 a0 00 00 00       	push   $0xa0
  802e7d:	68 8b 46 80 00       	push   $0x80468b
  802e82:	e8 d2 d6 ff ff       	call   800559 <_panic>
  802e87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	74 10                	je     802ea0 <alloc_block+0x1b2>
  802e90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e93:	8b 00                	mov    (%eax),%eax
  802e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e98:	8b 52 04             	mov    0x4(%edx),%edx
  802e9b:	89 50 04             	mov    %edx,0x4(%eax)
  802e9e:	eb 0b                	jmp    802eab <alloc_block+0x1bd>
  802ea0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea3:	8b 40 04             	mov    0x4(%eax),%eax
  802ea6:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802eab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eae:	8b 40 04             	mov    0x4(%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 0f                	je     802ec4 <alloc_block+0x1d6>
  802eb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb8:	8b 40 04             	mov    0x4(%eax),%eax
  802ebb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ebe:	8b 12                	mov    (%edx),%edx
  802ec0:	89 10                	mov    %edx,(%eax)
  802ec2:	eb 0a                	jmp    802ece <alloc_block+0x1e0>
  802ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec7:	8b 00                	mov    (%eax),%eax
  802ec9:	a3 48 50 80 00       	mov    %eax,0x805048
  802ece:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee1:	a1 54 50 80 00       	mov    0x805054,%eax
  802ee6:	48                   	dec    %eax
  802ee7:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802eec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ef2:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802ef6:	b8 00 10 00 00       	mov    $0x1000,%eax
  802efb:	99                   	cltd   
  802efc:	f7 7d e8             	idivl  -0x18(%ebp)
  802eff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f02:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802f06:	83 ec 0c             	sub    $0xc,%esp
  802f09:	ff 75 dc             	pushl  -0x24(%ebp)
  802f0c:	e8 ce fa ff ff       	call   8029df <to_page_va>
  802f11:	83 c4 10             	add    $0x10,%esp
  802f14:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802f17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f1a:	83 ec 0c             	sub    $0xc,%esp
  802f1d:	50                   	push   %eax
  802f1e:	e8 c0 ee ff ff       	call   801de3 <get_page>
  802f23:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f2d:	e9 aa 00 00 00       	jmp    802fdc <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802f39:	89 c2                	mov    %eax,%edx
  802f3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f3e:	01 d0                	add    %edx,%eax
  802f40:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802f43:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f47:	75 17                	jne    802f60 <alloc_block+0x272>
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	68 44 47 80 00       	push   $0x804744
  802f51:	68 aa 00 00 00       	push   $0xaa
  802f56:	68 8b 46 80 00       	push   $0x80468b
  802f5b:	e8 f9 d5 ff ff       	call   800559 <_panic>
  802f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f63:	c1 e0 04             	shl    $0x4,%eax
  802f66:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f6b:	8b 10                	mov    (%eax),%edx
  802f6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f70:	89 50 04             	mov    %edx,0x4(%eax)
  802f73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 14                	je     802f91 <alloc_block+0x2a3>
  802f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f80:	c1 e0 04             	shl    $0x4,%eax
  802f83:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f8d:	89 10                	mov    %edx,(%eax)
  802f8f:	eb 11                	jmp    802fa2 <alloc_block+0x2b4>
  802f91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f94:	c1 e0 04             	shl    $0x4,%eax
  802f97:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fa0:	89 02                	mov    %eax,(%edx)
  802fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa5:	c1 e0 04             	shl    $0x4,%eax
  802fa8:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802fae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fb1:	89 02                	mov    %eax,(%edx)
  802fb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbf:	c1 e0 04             	shl    $0x4,%eax
  802fc2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	8d 50 01             	lea    0x1(%eax),%edx
  802fcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcf:	c1 e0 04             	shl    $0x4,%eax
  802fd2:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802fd7:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802fd9:	ff 45 f4             	incl   -0xc(%ebp)
  802fdc:	b8 00 10 00 00       	mov    $0x1000,%eax
  802fe1:	99                   	cltd   
  802fe2:	f7 7d e8             	idivl  -0x18(%ebp)
  802fe5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802fe8:	0f 8f 44 ff ff ff    	jg     802f32 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff1:	c1 e0 04             	shl    $0x4,%eax
  802ff4:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802ffe:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803002:	75 17                	jne    80301b <alloc_block+0x32d>
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	68 25 47 80 00       	push   $0x804725
  80300c:	68 ae 00 00 00       	push   $0xae
  803011:	68 8b 46 80 00       	push   $0x80468b
  803016:	e8 3e d5 ff ff       	call   800559 <_panic>
  80301b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 10                	je     803034 <alloc_block+0x346>
  803024:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80302c:	8b 52 04             	mov    0x4(%edx),%edx
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	eb 14                	jmp    803048 <alloc_block+0x35a>
  803034:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80303d:	c1 e2 04             	shl    $0x4,%edx
  803040:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803046:	89 02                	mov    %eax,(%edx)
  803048:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80304b:	8b 40 04             	mov    0x4(%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 0f                	je     803061 <alloc_block+0x373>
  803052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803055:	8b 40 04             	mov    0x4(%eax),%eax
  803058:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80305b:	8b 12                	mov    (%edx),%edx
  80305d:	89 10                	mov    %edx,(%eax)
  80305f:	eb 13                	jmp    803074 <alloc_block+0x386>
  803061:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803069:	c1 e2 04             	shl    $0x4,%edx
  80306c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803072:	89 02                	mov    %eax,(%edx)
  803074:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308a:	c1 e0 04             	shl    $0x4,%eax
  80308d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	8d 50 ff             	lea    -0x1(%eax),%edx
  803097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309a:	c1 e0 04             	shl    $0x4,%eax
  80309d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030a2:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8030a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030a7:	83 ec 0c             	sub    $0xc,%esp
  8030aa:	50                   	push   %eax
  8030ab:	e8 a1 f9 ff ff       	call   802a51 <to_page_info>
  8030b0:	83 c4 10             	add    $0x10,%esp
  8030b3:	89 c2                	mov    %eax,%edx
  8030b5:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8030b9:	48                   	dec    %eax
  8030ba:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8030be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030c1:	e9 1a 01 00 00       	jmp    8031e0 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8030c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c9:	40                   	inc    %eax
  8030ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8030cd:	e9 ed 00 00 00       	jmp    8031bf <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d5:	c1 e0 04             	shl    $0x4,%eax
  8030d8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030dd:	8b 00                	mov    (%eax),%eax
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	0f 84 d5 00 00 00    	je     8031bc <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8030e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ea:	c1 e0 04             	shl    $0x4,%eax
  8030ed:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8030f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030fb:	75 17                	jne    803114 <alloc_block+0x426>
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 25 47 80 00       	push   $0x804725
  803105:	68 b8 00 00 00       	push   $0xb8
  80310a:	68 8b 46 80 00       	push   $0x80468b
  80310f:	e8 45 d4 ff ff       	call   800559 <_panic>
  803114:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803117:	8b 00                	mov    (%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 10                	je     80312d <alloc_block+0x43f>
  80311d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803125:	8b 52 04             	mov    0x4(%edx),%edx
  803128:	89 50 04             	mov    %edx,0x4(%eax)
  80312b:	eb 14                	jmp    803141 <alloc_block+0x453>
  80312d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803130:	8b 40 04             	mov    0x4(%eax),%eax
  803133:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803136:	c1 e2 04             	shl    $0x4,%edx
  803139:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80313f:	89 02                	mov    %eax,(%edx)
  803141:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 0f                	je     80315a <alloc_block+0x46c>
  80314b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803154:	8b 12                	mov    (%edx),%edx
  803156:	89 10                	mov    %edx,(%eax)
  803158:	eb 13                	jmp    80316d <alloc_block+0x47f>
  80315a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803162:	c1 e2 04             	shl    $0x4,%edx
  803165:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80316b:	89 02                	mov    %eax,(%edx)
  80316d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803176:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	c1 e0 04             	shl    $0x4,%eax
  803186:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803193:	c1 e0 04             	shl    $0x4,%eax
  803196:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80319b:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  80319d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a0:	83 ec 0c             	sub    $0xc,%esp
  8031a3:	50                   	push   %eax
  8031a4:	e8 a8 f8 ff ff       	call   802a51 <to_page_info>
  8031a9:	83 c4 10             	add    $0x10,%esp
  8031ac:	89 c2                	mov    %eax,%edx
  8031ae:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8031b2:	48                   	dec    %eax
  8031b3:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8031b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ba:	eb 24                	jmp    8031e0 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8031bc:	ff 45 f0             	incl   -0x10(%ebp)
  8031bf:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8031c3:	0f 8e 09 ff ff ff    	jle    8030d2 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8031c9:	83 ec 04             	sub    $0x4,%esp
  8031cc:	68 67 47 80 00       	push   $0x804767
  8031d1:	68 bf 00 00 00       	push   $0xbf
  8031d6:	68 8b 46 80 00       	push   $0x80468b
  8031db:	e8 79 d3 ff ff       	call   800559 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8031e0:	c9                   	leave  
  8031e1:	c3                   	ret    

008031e2 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8031e2:	55                   	push   %ebp
  8031e3:	89 e5                	mov    %esp,%ebp
  8031e5:	83 ec 14             	sub    $0x14,%esp
  8031e8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8031eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ef:	75 07                	jne    8031f8 <log2_ceil.1520+0x16>
  8031f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f6:	eb 1b                	jmp    803213 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8031f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8031ff:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803202:	eb 06                	jmp    80320a <log2_ceil.1520+0x28>
            x >>= 1;
  803204:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803207:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80320a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320e:	75 f4                	jne    803204 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803210:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803213:	c9                   	leave  
  803214:	c3                   	ret    

00803215 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803215:	55                   	push   %ebp
  803216:	89 e5                	mov    %esp,%ebp
  803218:	83 ec 14             	sub    $0x14,%esp
  80321b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  80321e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803222:	75 07                	jne    80322b <log2_ceil.1547+0x16>
  803224:	b8 00 00 00 00       	mov    $0x0,%eax
  803229:	eb 1b                	jmp    803246 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80322b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803232:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803235:	eb 06                	jmp    80323d <log2_ceil.1547+0x28>
			x >>= 1;
  803237:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80323a:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80323d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803241:	75 f4                	jne    803237 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803243:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803246:	c9                   	leave  
  803247:	c3                   	ret    

00803248 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803248:	55                   	push   %ebp
  803249:	89 e5                	mov    %esp,%ebp
  80324b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80324e:	8b 55 08             	mov    0x8(%ebp),%edx
  803251:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803256:	39 c2                	cmp    %eax,%edx
  803258:	72 0c                	jb     803266 <free_block+0x1e>
  80325a:	8b 55 08             	mov    0x8(%ebp),%edx
  80325d:	a1 40 50 80 00       	mov    0x805040,%eax
  803262:	39 c2                	cmp    %eax,%edx
  803264:	72 19                	jb     80327f <free_block+0x37>
  803266:	68 6c 47 80 00       	push   $0x80476c
  80326b:	68 ee 46 80 00       	push   $0x8046ee
  803270:	68 d0 00 00 00       	push   $0xd0
  803275:	68 8b 46 80 00       	push   $0x80468b
  80327a:	e8 da d2 ff ff       	call   800559 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80327f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803283:	0f 84 42 03 00 00    	je     8035cb <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803289:	8b 55 08             	mov    0x8(%ebp),%edx
  80328c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803291:	39 c2                	cmp    %eax,%edx
  803293:	72 0c                	jb     8032a1 <free_block+0x59>
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	a1 40 50 80 00       	mov    0x805040,%eax
  80329d:	39 c2                	cmp    %eax,%edx
  80329f:	72 17                	jb     8032b8 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8032a1:	83 ec 04             	sub    $0x4,%esp
  8032a4:	68 a4 47 80 00       	push   $0x8047a4
  8032a9:	68 e6 00 00 00       	push   $0xe6
  8032ae:	68 8b 46 80 00       	push   $0x80468b
  8032b3:	e8 a1 d2 ff ff       	call   800559 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8032b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bb:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8032c0:	29 c2                	sub    %eax,%edx
  8032c2:	89 d0                	mov    %edx,%eax
  8032c4:	83 e0 07             	and    $0x7,%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	74 17                	je     8032e2 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8032cb:	83 ec 04             	sub    $0x4,%esp
  8032ce:	68 d8 47 80 00       	push   $0x8047d8
  8032d3:	68 ea 00 00 00       	push   $0xea
  8032d8:	68 8b 46 80 00       	push   $0x80468b
  8032dd:	e8 77 d2 ff ff       	call   800559 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	83 ec 0c             	sub    $0xc,%esp
  8032e8:	50                   	push   %eax
  8032e9:	e8 63 f7 ff ff       	call   802a51 <to_page_info>
  8032ee:	83 c4 10             	add    $0x10,%esp
  8032f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8032f4:	83 ec 0c             	sub    $0xc,%esp
  8032f7:	ff 75 08             	pushl  0x8(%ebp)
  8032fa:	e8 87 f9 ff ff       	call   802c86 <get_block_size>
  8032ff:	83 c4 10             	add    $0x10,%esp
  803302:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803305:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803309:	75 17                	jne    803322 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 04 48 80 00       	push   $0x804804
  803313:	68 f1 00 00 00       	push   $0xf1
  803318:	68 8b 46 80 00       	push   $0x80468b
  80331d:	e8 37 d2 ff ff       	call   800559 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803322:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803325:	83 ec 0c             	sub    $0xc,%esp
  803328:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80332b:	52                   	push   %edx
  80332c:	89 c1                	mov    %eax,%ecx
  80332e:	e8 e2 fe ff ff       	call   803215 <log2_ceil.1547>
  803333:	83 c4 10             	add    $0x10,%esp
  803336:	83 e8 03             	sub    $0x3,%eax
  803339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803342:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803346:	75 17                	jne    80335f <free_block+0x117>
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	68 50 48 80 00       	push   $0x804850
  803350:	68 f6 00 00 00       	push   $0xf6
  803355:	68 8b 46 80 00       	push   $0x80468b
  80335a:	e8 fa d1 ff ff       	call   800559 <_panic>
  80335f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803362:	c1 e0 04             	shl    $0x4,%eax
  803365:	05 80 d0 81 00       	add    $0x81d080,%eax
  80336a:	8b 10                	mov    (%eax),%edx
  80336c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80336f:	89 10                	mov    %edx,(%eax)
  803371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 15                	je     80338f <free_block+0x147>
  80337a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337d:	c1 e0 04             	shl    $0x4,%eax
  803380:	05 80 d0 81 00       	add    $0x81d080,%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	eb 11                	jmp    8033a0 <free_block+0x158>
  80338f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803392:	c1 e0 04             	shl    $0x4,%eax
  803395:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  80339b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339e:	89 02                	mov    %eax,(%edx)
  8033a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a3:	c1 e0 04             	shl    $0x4,%eax
  8033a6:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8033ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033af:	89 02                	mov    %eax,(%edx)
  8033b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033be:	c1 e0 04             	shl    $0x4,%eax
  8033c1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	8d 50 01             	lea    0x1(%eax),%edx
  8033cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ce:	c1 e0 04             	shl    $0x4,%eax
  8033d1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033d6:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8033d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033db:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8033df:	40                   	inc    %eax
  8033e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033e3:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8033e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ea:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8033ef:	29 c2                	sub    %eax,%edx
  8033f1:	89 d0                	mov    %edx,%eax
  8033f3:	c1 e8 0c             	shr    $0xc,%eax
  8033f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8033f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803400:	0f b7 c8             	movzwl %ax,%ecx
  803403:	b8 00 10 00 00       	mov    $0x1000,%eax
  803408:	99                   	cltd   
  803409:	f7 7d e8             	idivl  -0x18(%ebp)
  80340c:	39 c1                	cmp    %eax,%ecx
  80340e:	0f 85 b8 01 00 00    	jne    8035cc <free_block+0x384>
    	uint32 blocks_removed = 0;
  803414:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80341b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341e:	c1 e0 04             	shl    $0x4,%eax
  803421:	05 80 d0 81 00       	add    $0x81d080,%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80342b:	e9 d5 00 00 00       	jmp    803505 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803438:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80343b:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803440:	29 c2                	sub    %eax,%edx
  803442:	89 d0                	mov    %edx,%eax
  803444:	c1 e8 0c             	shr    $0xc,%eax
  803447:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80344a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803450:	0f 85 a9 00 00 00    	jne    8034ff <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80345a:	75 17                	jne    803473 <free_block+0x22b>
  80345c:	83 ec 04             	sub    $0x4,%esp
  80345f:	68 25 47 80 00       	push   $0x804725
  803464:	68 04 01 00 00       	push   $0x104
  803469:	68 8b 46 80 00       	push   $0x80468b
  80346e:	e8 e6 d0 ff ff       	call   800559 <_panic>
  803473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 10                	je     80348c <free_block+0x244>
  80347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803484:	8b 52 04             	mov    0x4(%edx),%edx
  803487:	89 50 04             	mov    %edx,0x4(%eax)
  80348a:	eb 14                	jmp    8034a0 <free_block+0x258>
  80348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803495:	c1 e2 04             	shl    $0x4,%edx
  803498:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80349e:	89 02                	mov    %eax,(%edx)
  8034a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a3:	8b 40 04             	mov    0x4(%eax),%eax
  8034a6:	85 c0                	test   %eax,%eax
  8034a8:	74 0f                	je     8034b9 <free_block+0x271>
  8034aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ad:	8b 40 04             	mov    0x4(%eax),%eax
  8034b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b3:	8b 12                	mov    (%edx),%edx
  8034b5:	89 10                	mov    %edx,(%eax)
  8034b7:	eb 13                	jmp    8034cc <free_block+0x284>
  8034b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c1:	c1 e2 04             	shl    $0x4,%edx
  8034c4:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8034ca:	89 02                	mov    %eax,(%edx)
  8034cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e2:	c1 e0 04             	shl    $0x4,%eax
  8034e5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8034ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f2:	c1 e0 04             	shl    $0x4,%eax
  8034f5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8034fa:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8034fc:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8034ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803502:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803505:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803509:	0f 85 21 ff ff ff    	jne    803430 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  80350f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803514:	99                   	cltd   
  803515:	f7 7d e8             	idivl  -0x18(%ebp)
  803518:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80351b:	74 17                	je     803534 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80351d:	83 ec 04             	sub    $0x4,%esp
  803520:	68 74 48 80 00       	push   $0x804874
  803525:	68 0c 01 00 00       	push   $0x10c
  80352a:	68 8b 46 80 00       	push   $0x80468b
  80352f:	e8 25 d0 ff ff       	call   800559 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80353d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803540:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803546:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80354a:	75 17                	jne    803563 <free_block+0x31b>
  80354c:	83 ec 04             	sub    $0x4,%esp
  80354f:	68 44 47 80 00       	push   $0x804744
  803554:	68 11 01 00 00       	push   $0x111
  803559:	68 8b 46 80 00       	push   $0x80468b
  80355e:	e8 f6 cf ff ff       	call   800559 <_panic>
  803563:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803572:	8b 40 04             	mov    0x4(%eax),%eax
  803575:	85 c0                	test   %eax,%eax
  803577:	74 0c                	je     803585 <free_block+0x33d>
  803579:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80357e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803581:	89 10                	mov    %edx,(%eax)
  803583:	eb 08                	jmp    80358d <free_block+0x345>
  803585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803588:	a3 48 50 80 00       	mov    %eax,0x805048
  80358d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803590:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359e:	a1 54 50 80 00       	mov    0x805054,%eax
  8035a3:	40                   	inc    %eax
  8035a4:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8035a9:	83 ec 0c             	sub    $0xc,%esp
  8035ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8035af:	e8 2b f4 ff ff       	call   8029df <to_page_va>
  8035b4:	83 c4 10             	add    $0x10,%esp
  8035b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8035ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035bd:	83 ec 0c             	sub    $0xc,%esp
  8035c0:	50                   	push   %eax
  8035c1:	e8 69 e8 ff ff       	call   801e2f <return_page>
  8035c6:	83 c4 10             	add    $0x10,%esp
  8035c9:	eb 01                	jmp    8035cc <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8035cb:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8035cc:	c9                   	leave  
  8035cd:	c3                   	ret    

008035ce <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8035ce:	55                   	push   %ebp
  8035cf:	89 e5                	mov    %esp,%ebp
  8035d1:	83 ec 14             	sub    $0x14,%esp
  8035d4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8035d7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8035db:	77 07                	ja     8035e4 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8035dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e2:	eb 20                	jmp    803604 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8035e4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8035eb:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8035ee:	eb 08                	jmp    8035f8 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8035f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035f3:	01 c0                	add    %eax,%eax
  8035f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8035f8:	d1 6d 08             	shrl   0x8(%ebp)
  8035fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ff:	75 ef                	jne    8035f0 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803601:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803604:	c9                   	leave  
  803605:	c3                   	ret    

00803606 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803606:	55                   	push   %ebp
  803607:	89 e5                	mov    %esp,%ebp
  803609:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80360c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803610:	75 13                	jne    803625 <realloc_block+0x1f>
    return alloc_block(new_size);
  803612:	83 ec 0c             	sub    $0xc,%esp
  803615:	ff 75 0c             	pushl  0xc(%ebp)
  803618:	e8 d1 f6 ff ff       	call   802cee <alloc_block>
  80361d:	83 c4 10             	add    $0x10,%esp
  803620:	e9 d9 00 00 00       	jmp    8036fe <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803625:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803629:	75 18                	jne    803643 <realloc_block+0x3d>
    free_block(va);
  80362b:	83 ec 0c             	sub    $0xc,%esp
  80362e:	ff 75 08             	pushl  0x8(%ebp)
  803631:	e8 12 fc ff ff       	call   803248 <free_block>
  803636:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803639:	b8 00 00 00 00       	mov    $0x0,%eax
  80363e:	e9 bb 00 00 00       	jmp    8036fe <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803643:	83 ec 0c             	sub    $0xc,%esp
  803646:	ff 75 08             	pushl  0x8(%ebp)
  803649:	e8 38 f6 ff ff       	call   802c86 <get_block_size>
  80364e:	83 c4 10             	add    $0x10,%esp
  803651:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803654:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  80365b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803661:	73 06                	jae    803669 <realloc_block+0x63>
    new_size = min_block_size;
  803663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803666:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803669:	83 ec 0c             	sub    $0xc,%esp
  80366c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80366f:	ff 75 0c             	pushl  0xc(%ebp)
  803672:	89 c1                	mov    %eax,%ecx
  803674:	e8 55 ff ff ff       	call   8035ce <nearest_pow2_ceil.1572>
  803679:	83 c4 10             	add    $0x10,%esp
  80367c:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  80367f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803682:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803685:	75 05                	jne    80368c <realloc_block+0x86>
    return va;
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	eb 72                	jmp    8036fe <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  80368c:	83 ec 0c             	sub    $0xc,%esp
  80368f:	ff 75 0c             	pushl  0xc(%ebp)
  803692:	e8 57 f6 ff ff       	call   802cee <alloc_block>
  803697:	83 c4 10             	add    $0x10,%esp
  80369a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80369d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a1:	75 07                	jne    8036aa <realloc_block+0xa4>
    return NULL;
  8036a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a8:	eb 54                	jmp    8036fe <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8036aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b0:	39 d0                	cmp    %edx,%eax
  8036b2:	76 02                	jbe    8036b6 <realloc_block+0xb0>
  8036b4:	89 d0                	mov    %edx,%eax
  8036b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8036b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8036c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036cc:	eb 17                	jmp    8036e5 <realloc_block+0xdf>
    dst[i] = src[i];
  8036ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d4:	01 c2                	add    %eax,%edx
  8036d6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8036d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dc:	01 c8                	add    %ecx,%eax
  8036de:	8a 00                	mov    (%eax),%al
  8036e0:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8036e2:	ff 45 f4             	incl   -0xc(%ebp)
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036eb:	72 e1                	jb     8036ce <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8036ed:	83 ec 0c             	sub    $0xc,%esp
  8036f0:	ff 75 08             	pushl  0x8(%ebp)
  8036f3:	e8 50 fb ff ff       	call   803248 <free_block>
  8036f8:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8036fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8036fe:	c9                   	leave  
  8036ff:	c3                   	ret    

00803700 <__udivdi3>:
  803700:	55                   	push   %ebp
  803701:	57                   	push   %edi
  803702:	56                   	push   %esi
  803703:	53                   	push   %ebx
  803704:	83 ec 1c             	sub    $0x1c,%esp
  803707:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80370b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80370f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803713:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803717:	89 ca                	mov    %ecx,%edx
  803719:	89 f8                	mov    %edi,%eax
  80371b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80371f:	85 f6                	test   %esi,%esi
  803721:	75 2d                	jne    803750 <__udivdi3+0x50>
  803723:	39 cf                	cmp    %ecx,%edi
  803725:	77 65                	ja     80378c <__udivdi3+0x8c>
  803727:	89 fd                	mov    %edi,%ebp
  803729:	85 ff                	test   %edi,%edi
  80372b:	75 0b                	jne    803738 <__udivdi3+0x38>
  80372d:	b8 01 00 00 00       	mov    $0x1,%eax
  803732:	31 d2                	xor    %edx,%edx
  803734:	f7 f7                	div    %edi
  803736:	89 c5                	mov    %eax,%ebp
  803738:	31 d2                	xor    %edx,%edx
  80373a:	89 c8                	mov    %ecx,%eax
  80373c:	f7 f5                	div    %ebp
  80373e:	89 c1                	mov    %eax,%ecx
  803740:	89 d8                	mov    %ebx,%eax
  803742:	f7 f5                	div    %ebp
  803744:	89 cf                	mov    %ecx,%edi
  803746:	89 fa                	mov    %edi,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	39 ce                	cmp    %ecx,%esi
  803752:	77 28                	ja     80377c <__udivdi3+0x7c>
  803754:	0f bd fe             	bsr    %esi,%edi
  803757:	83 f7 1f             	xor    $0x1f,%edi
  80375a:	75 40                	jne    80379c <__udivdi3+0x9c>
  80375c:	39 ce                	cmp    %ecx,%esi
  80375e:	72 0a                	jb     80376a <__udivdi3+0x6a>
  803760:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803764:	0f 87 9e 00 00 00    	ja     803808 <__udivdi3+0x108>
  80376a:	b8 01 00 00 00       	mov    $0x1,%eax
  80376f:	89 fa                	mov    %edi,%edx
  803771:	83 c4 1c             	add    $0x1c,%esp
  803774:	5b                   	pop    %ebx
  803775:	5e                   	pop    %esi
  803776:	5f                   	pop    %edi
  803777:	5d                   	pop    %ebp
  803778:	c3                   	ret    
  803779:	8d 76 00             	lea    0x0(%esi),%esi
  80377c:	31 ff                	xor    %edi,%edi
  80377e:	31 c0                	xor    %eax,%eax
  803780:	89 fa                	mov    %edi,%edx
  803782:	83 c4 1c             	add    $0x1c,%esp
  803785:	5b                   	pop    %ebx
  803786:	5e                   	pop    %esi
  803787:	5f                   	pop    %edi
  803788:	5d                   	pop    %ebp
  803789:	c3                   	ret    
  80378a:	66 90                	xchg   %ax,%ax
  80378c:	89 d8                	mov    %ebx,%eax
  80378e:	f7 f7                	div    %edi
  803790:	31 ff                	xor    %edi,%edi
  803792:	89 fa                	mov    %edi,%edx
  803794:	83 c4 1c             	add    $0x1c,%esp
  803797:	5b                   	pop    %ebx
  803798:	5e                   	pop    %esi
  803799:	5f                   	pop    %edi
  80379a:	5d                   	pop    %ebp
  80379b:	c3                   	ret    
  80379c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037a1:	89 eb                	mov    %ebp,%ebx
  8037a3:	29 fb                	sub    %edi,%ebx
  8037a5:	89 f9                	mov    %edi,%ecx
  8037a7:	d3 e6                	shl    %cl,%esi
  8037a9:	89 c5                	mov    %eax,%ebp
  8037ab:	88 d9                	mov    %bl,%cl
  8037ad:	d3 ed                	shr    %cl,%ebp
  8037af:	89 e9                	mov    %ebp,%ecx
  8037b1:	09 f1                	or     %esi,%ecx
  8037b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037b7:	89 f9                	mov    %edi,%ecx
  8037b9:	d3 e0                	shl    %cl,%eax
  8037bb:	89 c5                	mov    %eax,%ebp
  8037bd:	89 d6                	mov    %edx,%esi
  8037bf:	88 d9                	mov    %bl,%cl
  8037c1:	d3 ee                	shr    %cl,%esi
  8037c3:	89 f9                	mov    %edi,%ecx
  8037c5:	d3 e2                	shl    %cl,%edx
  8037c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037cb:	88 d9                	mov    %bl,%cl
  8037cd:	d3 e8                	shr    %cl,%eax
  8037cf:	09 c2                	or     %eax,%edx
  8037d1:	89 d0                	mov    %edx,%eax
  8037d3:	89 f2                	mov    %esi,%edx
  8037d5:	f7 74 24 0c          	divl   0xc(%esp)
  8037d9:	89 d6                	mov    %edx,%esi
  8037db:	89 c3                	mov    %eax,%ebx
  8037dd:	f7 e5                	mul    %ebp
  8037df:	39 d6                	cmp    %edx,%esi
  8037e1:	72 19                	jb     8037fc <__udivdi3+0xfc>
  8037e3:	74 0b                	je     8037f0 <__udivdi3+0xf0>
  8037e5:	89 d8                	mov    %ebx,%eax
  8037e7:	31 ff                	xor    %edi,%edi
  8037e9:	e9 58 ff ff ff       	jmp    803746 <__udivdi3+0x46>
  8037ee:	66 90                	xchg   %ax,%ax
  8037f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037f4:	89 f9                	mov    %edi,%ecx
  8037f6:	d3 e2                	shl    %cl,%edx
  8037f8:	39 c2                	cmp    %eax,%edx
  8037fa:	73 e9                	jae    8037e5 <__udivdi3+0xe5>
  8037fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ff:	31 ff                	xor    %edi,%edi
  803801:	e9 40 ff ff ff       	jmp    803746 <__udivdi3+0x46>
  803806:	66 90                	xchg   %ax,%ax
  803808:	31 c0                	xor    %eax,%eax
  80380a:	e9 37 ff ff ff       	jmp    803746 <__udivdi3+0x46>
  80380f:	90                   	nop

00803810 <__umoddi3>:
  803810:	55                   	push   %ebp
  803811:	57                   	push   %edi
  803812:	56                   	push   %esi
  803813:	53                   	push   %ebx
  803814:	83 ec 1c             	sub    $0x1c,%esp
  803817:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80381b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80381f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803823:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803827:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80382b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80382f:	89 f3                	mov    %esi,%ebx
  803831:	89 fa                	mov    %edi,%edx
  803833:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803837:	89 34 24             	mov    %esi,(%esp)
  80383a:	85 c0                	test   %eax,%eax
  80383c:	75 1a                	jne    803858 <__umoddi3+0x48>
  80383e:	39 f7                	cmp    %esi,%edi
  803840:	0f 86 a2 00 00 00    	jbe    8038e8 <__umoddi3+0xd8>
  803846:	89 c8                	mov    %ecx,%eax
  803848:	89 f2                	mov    %esi,%edx
  80384a:	f7 f7                	div    %edi
  80384c:	89 d0                	mov    %edx,%eax
  80384e:	31 d2                	xor    %edx,%edx
  803850:	83 c4 1c             	add    $0x1c,%esp
  803853:	5b                   	pop    %ebx
  803854:	5e                   	pop    %esi
  803855:	5f                   	pop    %edi
  803856:	5d                   	pop    %ebp
  803857:	c3                   	ret    
  803858:	39 f0                	cmp    %esi,%eax
  80385a:	0f 87 ac 00 00 00    	ja     80390c <__umoddi3+0xfc>
  803860:	0f bd e8             	bsr    %eax,%ebp
  803863:	83 f5 1f             	xor    $0x1f,%ebp
  803866:	0f 84 ac 00 00 00    	je     803918 <__umoddi3+0x108>
  80386c:	bf 20 00 00 00       	mov    $0x20,%edi
  803871:	29 ef                	sub    %ebp,%edi
  803873:	89 fe                	mov    %edi,%esi
  803875:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803879:	89 e9                	mov    %ebp,%ecx
  80387b:	d3 e0                	shl    %cl,%eax
  80387d:	89 d7                	mov    %edx,%edi
  80387f:	89 f1                	mov    %esi,%ecx
  803881:	d3 ef                	shr    %cl,%edi
  803883:	09 c7                	or     %eax,%edi
  803885:	89 e9                	mov    %ebp,%ecx
  803887:	d3 e2                	shl    %cl,%edx
  803889:	89 14 24             	mov    %edx,(%esp)
  80388c:	89 d8                	mov    %ebx,%eax
  80388e:	d3 e0                	shl    %cl,%eax
  803890:	89 c2                	mov    %eax,%edx
  803892:	8b 44 24 08          	mov    0x8(%esp),%eax
  803896:	d3 e0                	shl    %cl,%eax
  803898:	89 44 24 04          	mov    %eax,0x4(%esp)
  80389c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038a0:	89 f1                	mov    %esi,%ecx
  8038a2:	d3 e8                	shr    %cl,%eax
  8038a4:	09 d0                	or     %edx,%eax
  8038a6:	d3 eb                	shr    %cl,%ebx
  8038a8:	89 da                	mov    %ebx,%edx
  8038aa:	f7 f7                	div    %edi
  8038ac:	89 d3                	mov    %edx,%ebx
  8038ae:	f7 24 24             	mull   (%esp)
  8038b1:	89 c6                	mov    %eax,%esi
  8038b3:	89 d1                	mov    %edx,%ecx
  8038b5:	39 d3                	cmp    %edx,%ebx
  8038b7:	0f 82 87 00 00 00    	jb     803944 <__umoddi3+0x134>
  8038bd:	0f 84 91 00 00 00    	je     803954 <__umoddi3+0x144>
  8038c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038c7:	29 f2                	sub    %esi,%edx
  8038c9:	19 cb                	sbb    %ecx,%ebx
  8038cb:	89 d8                	mov    %ebx,%eax
  8038cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038d1:	d3 e0                	shl    %cl,%eax
  8038d3:	89 e9                	mov    %ebp,%ecx
  8038d5:	d3 ea                	shr    %cl,%edx
  8038d7:	09 d0                	or     %edx,%eax
  8038d9:	89 e9                	mov    %ebp,%ecx
  8038db:	d3 eb                	shr    %cl,%ebx
  8038dd:	89 da                	mov    %ebx,%edx
  8038df:	83 c4 1c             	add    $0x1c,%esp
  8038e2:	5b                   	pop    %ebx
  8038e3:	5e                   	pop    %esi
  8038e4:	5f                   	pop    %edi
  8038e5:	5d                   	pop    %ebp
  8038e6:	c3                   	ret    
  8038e7:	90                   	nop
  8038e8:	89 fd                	mov    %edi,%ebp
  8038ea:	85 ff                	test   %edi,%edi
  8038ec:	75 0b                	jne    8038f9 <__umoddi3+0xe9>
  8038ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f3:	31 d2                	xor    %edx,%edx
  8038f5:	f7 f7                	div    %edi
  8038f7:	89 c5                	mov    %eax,%ebp
  8038f9:	89 f0                	mov    %esi,%eax
  8038fb:	31 d2                	xor    %edx,%edx
  8038fd:	f7 f5                	div    %ebp
  8038ff:	89 c8                	mov    %ecx,%eax
  803901:	f7 f5                	div    %ebp
  803903:	89 d0                	mov    %edx,%eax
  803905:	e9 44 ff ff ff       	jmp    80384e <__umoddi3+0x3e>
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	89 c8                	mov    %ecx,%eax
  80390e:	89 f2                	mov    %esi,%edx
  803910:	83 c4 1c             	add    $0x1c,%esp
  803913:	5b                   	pop    %ebx
  803914:	5e                   	pop    %esi
  803915:	5f                   	pop    %edi
  803916:	5d                   	pop    %ebp
  803917:	c3                   	ret    
  803918:	3b 04 24             	cmp    (%esp),%eax
  80391b:	72 06                	jb     803923 <__umoddi3+0x113>
  80391d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803921:	77 0f                	ja     803932 <__umoddi3+0x122>
  803923:	89 f2                	mov    %esi,%edx
  803925:	29 f9                	sub    %edi,%ecx
  803927:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80392b:	89 14 24             	mov    %edx,(%esp)
  80392e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803932:	8b 44 24 04          	mov    0x4(%esp),%eax
  803936:	8b 14 24             	mov    (%esp),%edx
  803939:	83 c4 1c             	add    $0x1c,%esp
  80393c:	5b                   	pop    %ebx
  80393d:	5e                   	pop    %esi
  80393e:	5f                   	pop    %edi
  80393f:	5d                   	pop    %ebp
  803940:	c3                   	ret    
  803941:	8d 76 00             	lea    0x0(%esi),%esi
  803944:	2b 04 24             	sub    (%esp),%eax
  803947:	19 fa                	sbb    %edi,%edx
  803949:	89 d1                	mov    %edx,%ecx
  80394b:	89 c6                	mov    %eax,%esi
  80394d:	e9 71 ff ff ff       	jmp    8038c3 <__umoddi3+0xb3>
  803952:	66 90                	xchg   %ax,%ax
  803954:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803958:	72 ea                	jb     803944 <__umoddi3+0x134>
  80395a:	89 d9                	mov    %ebx,%ecx
  80395c:	e9 62 ff ff ff       	jmp    8038c3 <__umoddi3+0xb3>
