
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 58 02 00 00       	call   80028e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 cf 25 00 00       	call   80261a <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80004e:	e8 35 23 00 00       	call   802388 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800053:	e8 e0 23 00 00       	call   802438 <sys_calculate_free_frames>
  800058:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  80005b:	83 ec 08             	sub    $0x8,%esp
  80005e:	68 60 38 80 00       	push   $0x803860
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	e8 0c 21 00 00       	call   802177 <sget>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  800071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  800077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80007a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80007d:	74 1a                	je     800099 <_main+0x61>
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	ff 75 e8             	pushl  -0x18(%ebp)
  800085:	ff 75 e4             	pushl  -0x1c(%ebp)
  800088:	68 64 38 80 00       	push   $0x803864
  80008d:	6a 20                	push   $0x20
  80008f:	68 df 38 80 00       	push   $0x8038df
  800094:	e8 a5 03 00 00       	call   80043e <_panic>
		expected = 1 ; /*1table*/
  800099:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000a0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000a3:	e8 90 23 00 00       	call   802438 <sys_calculate_free_frames>
  8000a8:	29 c3                	sub    %eax,%ebx
  8000aa:	89 d8                	mov    %ebx,%eax
  8000ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000b2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000b5:	74 24                	je     8000db <_main+0xa3>
  8000b7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ba:	e8 79 23 00 00       	call   802438 <sys_calculate_free_frames>
  8000bf:	29 c3                	sub    %eax,%ebx
  8000c1:	89 d8                	mov    %ebx,%eax
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c9:	50                   	push   %eax
  8000ca:	68 00 39 80 00       	push   $0x803900
  8000cf:	6a 23                	push   $0x23
  8000d1:	68 df 38 80 00       	push   $0x8038df
  8000d6:	e8 63 03 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  8000db:	e8 c2 22 00 00       	call   8023a2 <sys_unlock_cons>
	//sys_unlock_cons();

	sys_lock_cons();
  8000e0:	e8 a3 22 00 00       	call   802388 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8000e5:	e8 4e 23 00 00       	call   802438 <sys_calculate_free_frames>
  8000ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 98 39 80 00       	push   $0x803998
  8000f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f8:	e8 7a 20 00 00       	call   802177 <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800106:	05 00 10 00 00       	add    $0x1000,%eax
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80010e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800111:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800114:	74 1a                	je     800130 <_main+0xf8>
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	ff 75 d8             	pushl  -0x28(%ebp)
  80011c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80011f:	68 64 38 80 00       	push   $0x803864
  800124:	6a 2d                	push   $0x2d
  800126:	68 df 38 80 00       	push   $0x8038df
  80012b:	e8 0e 03 00 00       	call   80043e <_panic>
		expected = 0 ;
  800130:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800137:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80013a:	e8 f9 22 00 00       	call   802438 <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800146:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800149:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80014c:	74 24                	je     800172 <_main+0x13a>
  80014e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800151:	e8 e2 22 00 00       	call   802438 <sys_calculate_free_frames>
  800156:	29 c3                	sub    %eax,%ebx
  800158:	89 d8                	mov    %ebx,%eax
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 e0             	pushl  -0x20(%ebp)
  800160:	50                   	push   %eax
  800161:	68 00 39 80 00       	push   $0x803900
  800166:	6a 30                	push   $0x30
  800168:	68 df 38 80 00       	push   $0x8038df
  80016d:	e8 cc 02 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  800172:	e8 2b 22 00 00       	call   8023a2 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 9c 39 80 00       	push   $0x80399c
  800189:	6a 35                	push   $0x35
  80018b:	68 df 38 80 00       	push   $0x8038df
  800190:	e8 a9 02 00 00       	call   80043e <_panic>

	sys_lock_cons();
  800195:	e8 ee 21 00 00       	call   802388 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 99 22 00 00       	call   802438 <sys_calculate_free_frames>
  80019f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 d3 39 80 00       	push   $0x8039d3
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 c5 1f 00 00       	call   802177 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001bb:	05 00 20 00 00       	add    $0x2000,%eax
  8001c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001c9:	74 1a                	je     8001e5 <_main+0x1ad>
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d4:	68 64 38 80 00       	push   $0x803864
  8001d9:	6a 3c                	push   $0x3c
  8001db:	68 df 38 80 00       	push   $0x8038df
  8001e0:	e8 59 02 00 00       	call   80043e <_panic>
		expected = 0 ;
  8001e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001ec:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ef:	e8 44 22 00 00       	call   802438 <sys_calculate_free_frames>
  8001f4:	29 c3                	sub    %eax,%ebx
  8001f6:	89 d8                	mov    %ebx,%eax
  8001f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8001fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800201:	74 24                	je     800227 <_main+0x1ef>
  800203:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800206:	e8 2d 22 00 00       	call   802438 <sys_calculate_free_frames>
  80020b:	29 c3                	sub    %eax,%ebx
  80020d:	89 d8                	mov    %ebx,%eax
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e0             	pushl  -0x20(%ebp)
  800215:	50                   	push   %eax
  800216:	68 00 39 80 00       	push   $0x803900
  80021b:	6a 3f                	push   $0x3f
  80021d:	68 df 38 80 00       	push   $0x8038df
  800222:	e8 17 02 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  800227:	e8 76 21 00 00       	call   8023a2 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80022c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	83 f8 0a             	cmp    $0xa,%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 9c 39 80 00       	push   $0x80399c
  80023e:	6a 44                	push   $0x44
  800240:	68 df 38 80 00       	push   $0x8038df
  800245:	e8 f4 01 00 00       	call   80043e <_panic>

	sys_lock_cons();
  80024a:	e8 39 21 00 00       	call   802388 <sys_lock_cons>
	{
		*z = *x + *y ;
  80024f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800252:	8b 10                	mov    (%eax),%edx
  800254:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800257:	8b 00                	mov    (%eax),%eax
  800259:	01 c2                	add    %eax,%edx
  80025b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025e:	89 10                	mov    %edx,(%eax)
	}
	sys_unlock_cons();
  800260:	e8 3d 21 00 00       	call   8023a2 <sys_unlock_cons>

	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800268:	8b 00                	mov    (%eax),%eax
  80026a:	83 f8 1e             	cmp    $0x1e,%eax
  80026d:	74 14                	je     800283 <_main+0x24b>
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	68 9c 39 80 00       	push   $0x80399c
  800277:	6a 4c                	push   $0x4c
  800279:	68 df 38 80 00       	push   $0x8038df
  80027e:	e8 bb 01 00 00       	call   80043e <_panic>

	//To indicate that it's completed successfully
	inctst();
  800283:	e8 b7 24 00 00       	call   80273f <inctst>

	return;
  800288:	90                   	nop
}
  800289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	57                   	push   %edi
  800292:	56                   	push   %esi
  800293:	53                   	push   %ebx
  800294:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800297:	e8 65 23 00 00       	call   802601 <sys_getenvindex>
  80029c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 d0                	mov    %edx,%eax
  8002a4:	01 c0                	add    %eax,%eax
  8002a6:	01 d0                	add    %edx,%eax
  8002a8:	c1 e0 02             	shl    $0x2,%eax
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	c1 e0 02             	shl    $0x2,%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	c1 e0 03             	shl    $0x3,%eax
  8002b5:	01 d0                	add    %edx,%eax
  8002b7:	c1 e0 02             	shl    $0x2,%eax
  8002ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002bf:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c9:	8a 40 20             	mov    0x20(%eax),%al
  8002cc:	84 c0                	test   %al,%al
  8002ce:	74 0d                	je     8002dd <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d5:	83 c0 20             	add    $0x20,%eax
  8002d8:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e1:	7e 0a                	jle    8002ed <libmain+0x5f>
		binaryname = argv[0];
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e6:	8b 00                	mov    (%eax),%eax
  8002e8:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	e8 3d fd ff ff       	call   800038 <_main>
  8002fb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800303:	85 c0                	test   %eax,%eax
  800305:	0f 84 01 01 00 00    	je     80040c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80030b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800311:	bb d0 3a 80 00       	mov    $0x803ad0,%ebx
  800316:	ba 0e 00 00 00       	mov    $0xe,%edx
  80031b:	89 c7                	mov    %eax,%edi
  80031d:	89 de                	mov    %ebx,%esi
  80031f:	89 d1                	mov    %edx,%ecx
  800321:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800323:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800326:	b9 56 00 00 00       	mov    $0x56,%ecx
  80032b:	b0 00                	mov    $0x0,%al
  80032d:	89 d7                	mov    %edx,%edi
  80032f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800331:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800338:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800345:	50                   	push   %eax
  800346:	e8 ec 24 00 00       	call   802837 <sys_utilities>
  80034b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80034e:	e8 35 20 00 00       	call   802388 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	68 f0 39 80 00       	push   $0x8039f0
  80035b:	e8 cc 03 00 00       	call   80072c <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800363:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800366:	85 c0                	test   %eax,%eax
  800368:	74 18                	je     800382 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036a:	e8 e6 24 00 00       	call   802855 <sys_get_optimal_num_faults>
  80036f:	83 ec 08             	sub    $0x8,%esp
  800372:	50                   	push   %eax
  800373:	68 18 3a 80 00       	push   $0x803a18
  800378:	e8 af 03 00 00       	call   80072c <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	eb 59                	jmp    8003db <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800382:	a1 20 50 80 00       	mov    0x805020,%eax
  800387:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80038d:	a1 20 50 80 00       	mov    0x805020,%eax
  800392:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	68 3c 3a 80 00       	push   $0x803a3c
  8003a2:	e8 85 03 00 00       	call   80072c <cprintf>
  8003a7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8003af:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ba:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c5:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003cb:	51                   	push   %ecx
  8003cc:	52                   	push   %edx
  8003cd:	50                   	push   %eax
  8003ce:	68 64 3a 80 00       	push   $0x803a64
  8003d3:	e8 54 03 00 00       	call   80072c <cprintf>
  8003d8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003db:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e0:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	50                   	push   %eax
  8003ea:	68 bc 3a 80 00       	push   $0x803abc
  8003ef:	e8 38 03 00 00       	call   80072c <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 f0 39 80 00       	push   $0x8039f0
  8003ff:	e8 28 03 00 00       	call   80072c <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800407:	e8 96 1f 00 00       	call   8023a2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80040c:	e8 1f 00 00 00       	call   800430 <exit>
}
  800411:	90                   	nop
  800412:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800415:	5b                   	pop    %ebx
  800416:	5e                   	pop    %esi
  800417:	5f                   	pop    %edi
  800418:	5d                   	pop    %ebp
  800419:	c3                   	ret    

0080041a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800420:	83 ec 0c             	sub    $0xc,%esp
  800423:	6a 00                	push   $0x0
  800425:	e8 a3 21 00 00       	call   8025cd <sys_destroy_env>
  80042a:	83 c4 10             	add    $0x10,%esp
}
  80042d:	90                   	nop
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <exit>:

void
exit(void)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800436:	e8 f8 21 00 00       	call   802633 <sys_exit_env>
}
  80043b:	90                   	nop
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800444:	8d 45 10             	lea    0x10(%ebp),%eax
  800447:	83 c0 04             	add    $0x4,%eax
  80044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80044d:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	74 16                	je     80046c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800456:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	50                   	push   %eax
  80045f:	68 34 3b 80 00       	push   $0x803b34
  800464:	e8 c3 02 00 00       	call   80072c <cprintf>
  800469:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80046c:	a1 04 50 80 00       	mov    0x805004,%eax
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	ff 75 0c             	pushl  0xc(%ebp)
  800477:	ff 75 08             	pushl  0x8(%ebp)
  80047a:	50                   	push   %eax
  80047b:	68 3c 3b 80 00       	push   $0x803b3c
  800480:	6a 74                	push   $0x74
  800482:	e8 d2 02 00 00       	call   800759 <cprintf_colored>
  800487:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80048a:	8b 45 10             	mov    0x10(%ebp),%eax
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	e8 24 02 00 00       	call   8006bd <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	6a 00                	push   $0x0
  8004a1:	68 64 3b 80 00       	push   $0x803b64
  8004a6:	e8 12 02 00 00       	call   8006bd <vcprintf>
  8004ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ae:	e8 7d ff ff ff       	call   800430 <exit>

	// should not return here
	while (1) ;
  8004b3:	eb fe                	jmp    8004b3 <_panic+0x75>

008004b5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	53                   	push   %ebx
  8004b9:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	39 c2                	cmp    %eax,%edx
  8004cc:	74 14                	je     8004e2 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004ce:	83 ec 04             	sub    $0x4,%esp
  8004d1:	68 68 3b 80 00       	push   $0x803b68
  8004d6:	6a 26                	push   $0x26
  8004d8:	68 b4 3b 80 00       	push   $0x803bb4
  8004dd:	e8 5c ff ff ff       	call   80043e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004f0:	e9 d9 00 00 00       	jmp    8005ce <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	01 d0                	add    %edx,%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	75 08                	jne    800512 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80050a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80050d:	e9 b9 00 00 00       	jmp    8005cb <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800512:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800520:	eb 79                	jmp    80059b <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800522:	a1 20 50 80 00       	mov    0x805020,%eax
  800527:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80052d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80053d:	01 d8                	add    %ebx,%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8a 40 04             	mov    0x4(%eax),%al
  800546:	84 c0                	test   %al,%al
  800548:	75 4e                	jne    800598 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80054a:	a1 20 50 80 00       	mov    0x805020,%eax
  80054f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800555:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800558:	89 d0                	mov    %edx,%eax
  80055a:	01 c0                	add    %eax,%eax
  80055c:	01 d0                	add    %edx,%eax
  80055e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800565:	01 d8                	add    %ebx,%eax
  800567:	01 d0                	add    %edx,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800570:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800573:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800578:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	01 c8                	add    %ecx,%eax
  800589:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058b:	39 c2                	cmp    %eax,%edx
  80058d:	75 09                	jne    800598 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80058f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800596:	eb 19                	jmp    8005b1 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800598:	ff 45 e8             	incl   -0x18(%ebp)
  80059b:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a9:	39 c2                	cmp    %eax,%edx
  8005ab:	0f 87 71 ff ff ff    	ja     800522 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005b5:	75 14                	jne    8005cb <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 c0 3b 80 00       	push   $0x803bc0
  8005bf:	6a 3a                	push   $0x3a
  8005c1:	68 b4 3b 80 00       	push   $0x803bb4
  8005c6:	e8 73 fe ff ff       	call   80043e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005cb:	ff 45 f0             	incl   -0x10(%ebp)
  8005ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005d4:	0f 8c 1b ff ff ff    	jl     8004f5 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005e8:	eb 2e                	jmp    800618 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ef:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f8:	89 d0                	mov    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800605:	01 d8                	add    %ebx,%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	01 c8                	add    %ecx,%eax
  80060b:	8a 40 04             	mov    0x4(%eax),%al
  80060e:	3c 01                	cmp    $0x1,%al
  800610:	75 03                	jne    800615 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800612:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800615:	ff 45 e0             	incl   -0x20(%ebp)
  800618:	a1 20 50 80 00       	mov    0x805020,%eax
  80061d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800623:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800626:	39 c2                	cmp    %eax,%edx
  800628:	77 c0                	ja     8005ea <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80062a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800630:	74 14                	je     800646 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800632:	83 ec 04             	sub    $0x4,%esp
  800635:	68 14 3c 80 00       	push   $0x803c14
  80063a:	6a 44                	push   $0x44
  80063c:	68 b4 3b 80 00       	push   $0x803bb4
  800641:	e8 f8 fd ff ff       	call   80043e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800646:	90                   	nop
  800647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064a:	c9                   	leave  
  80064b:	c3                   	ret    

0080064c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	53                   	push   %ebx
  800650:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 48 01             	lea    0x1(%eax),%ecx
  80065b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065e:	89 0a                	mov    %ecx,(%edx)
  800660:	8b 55 08             	mov    0x8(%ebp),%edx
  800663:	88 d1                	mov    %dl,%cl
  800665:	8b 55 0c             	mov    0xc(%ebp),%edx
  800668:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	3d ff 00 00 00       	cmp    $0xff,%eax
  800676:	75 30                	jne    8006a8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800678:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  80067e:	a0 44 50 80 00       	mov    0x805044,%al
  800683:	0f b6 c0             	movzbl %al,%eax
  800686:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800689:	8b 09                	mov    (%ecx),%ecx
  80068b:	89 cb                	mov    %ecx,%ebx
  80068d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800690:	83 c1 08             	add    $0x8,%ecx
  800693:	52                   	push   %edx
  800694:	50                   	push   %eax
  800695:	53                   	push   %ebx
  800696:	51                   	push   %ecx
  800697:	e8 a8 1c 00 00       	call   802344 <sys_cputs>
  80069c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80069f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ab:	8b 40 04             	mov    0x4(%eax),%eax
  8006ae:	8d 50 01             	lea    0x1(%eax),%edx
  8006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006b7:	90                   	nop
  8006b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006cd:	00 00 00 
	b.cnt = 0;
  8006d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006da:	ff 75 0c             	pushl  0xc(%ebp)
  8006dd:	ff 75 08             	pushl  0x8(%ebp)
  8006e0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e6:	50                   	push   %eax
  8006e7:	68 4c 06 80 00       	push   $0x80064c
  8006ec:	e8 5a 02 00 00       	call   80094b <vprintfmt>
  8006f1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006f4:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006fa:	a0 44 50 80 00       	mov    0x805044,%al
  8006ff:	0f b6 c0             	movzbl %al,%eax
  800702:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800708:	52                   	push   %edx
  800709:	50                   	push   %eax
  80070a:	51                   	push   %ecx
  80070b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800711:	83 c0 08             	add    $0x8,%eax
  800714:	50                   	push   %eax
  800715:	e8 2a 1c 00 00       	call   802344 <sys_cputs>
  80071a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80071d:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800724:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80072a:	c9                   	leave  
  80072b:	c3                   	ret    

0080072c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800732:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800739:	8d 45 0c             	lea    0xc(%ebp),%eax
  80073c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	ff 75 f4             	pushl  -0xc(%ebp)
  800748:	50                   	push   %eax
  800749:	e8 6f ff ff ff       	call   8006bd <vcprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800754:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075f:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	c1 e0 08             	shl    $0x8,%eax
  80076c:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800771:	8d 45 0c             	lea    0xc(%ebp),%eax
  800774:	83 c0 04             	add    $0x4,%eax
  800777:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 f4             	pushl  -0xc(%ebp)
  800783:	50                   	push   %eax
  800784:	e8 34 ff ff ff       	call   8006bd <vcprintf>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80078f:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800796:	07 00 00 

	return cnt;
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079c:	c9                   	leave  
  80079d:	c3                   	ret    

0080079e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007a4:	e8 df 1b 00 00       	call   802388 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	e8 ff fe ff ff       	call   8006bd <vcprintf>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007c4:	e8 d9 1b 00 00       	call   8023a2 <sys_unlock_cons>
	return cnt;
  8007c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    

008007ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 14             	sub    $0x14,%esp
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ec:	77 55                	ja     800843 <printnum+0x75>
  8007ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f1:	72 05                	jb     8007f8 <printnum+0x2a>
  8007f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f6:	77 4b                	ja     800843 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800801:	ba 00 00 00 00       	mov    $0x0,%edx
  800806:	52                   	push   %edx
  800807:	50                   	push   %eax
  800808:	ff 75 f4             	pushl  -0xc(%ebp)
  80080b:	ff 75 f0             	pushl  -0x10(%ebp)
  80080e:	e8 d5 2d 00 00       	call   8035e8 <__udivdi3>
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	83 ec 04             	sub    $0x4,%esp
  800819:	ff 75 20             	pushl  0x20(%ebp)
  80081c:	53                   	push   %ebx
  80081d:	ff 75 18             	pushl  0x18(%ebp)
  800820:	52                   	push   %edx
  800821:	50                   	push   %eax
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	ff 75 08             	pushl  0x8(%ebp)
  800828:	e8 a1 ff ff ff       	call   8007ce <printnum>
  80082d:	83 c4 20             	add    $0x20,%esp
  800830:	eb 1a                	jmp    80084c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	ff 75 20             	pushl  0x20(%ebp)
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	ff d0                	call   *%eax
  800840:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800843:	ff 4d 1c             	decl   0x1c(%ebp)
  800846:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80084a:	7f e6                	jg     800832 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085a:	53                   	push   %ebx
  80085b:	51                   	push   %ecx
  80085c:	52                   	push   %edx
  80085d:	50                   	push   %eax
  80085e:	e8 95 2e 00 00       	call   8036f8 <__umoddi3>
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	05 74 3e 80 00       	add    $0x803e74,%eax
  80086b:	8a 00                	mov    (%eax),%al
  80086d:	0f be c0             	movsbl %al,%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	50                   	push   %eax
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
}
  80087f:	90                   	nop
  800880:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800888:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088c:	7e 1c                	jle    8008aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	8d 50 08             	lea    0x8(%eax),%edx
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	89 10                	mov    %edx,(%eax)
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	83 e8 08             	sub    $0x8,%eax
  8008a3:	8b 50 04             	mov    0x4(%eax),%edx
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	eb 40                	jmp    8008ea <getuint+0x65>
	else if (lflag)
  8008aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ae:	74 1e                	je     8008ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	8d 50 04             	lea    0x4(%eax),%edx
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	89 10                	mov    %edx,(%eax)
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 e8 04             	sub    $0x4,%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	eb 1c                	jmp    8008ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	8d 50 04             	lea    0x4(%eax),%edx
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	89 10                	mov    %edx,(%eax)
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	83 e8 04             	sub    $0x4,%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f3:	7e 1c                	jle    800911 <getint+0x25>
		return va_arg(*ap, long long);
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	8d 50 08             	lea    0x8(%eax),%edx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	89 10                	mov    %edx,(%eax)
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	83 e8 08             	sub    $0x8,%eax
  80090a:	8b 50 04             	mov    0x4(%eax),%edx
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	eb 38                	jmp    800949 <getint+0x5d>
	else if (lflag)
  800911:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800915:	74 1a                	je     800931 <getint+0x45>
		return va_arg(*ap, long);
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	8d 50 04             	lea    0x4(%eax),%edx
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	89 10                	mov    %edx,(%eax)
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	99                   	cltd   
  80092f:	eb 18                	jmp    800949 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	8d 50 04             	lea    0x4(%eax),%edx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	89 10                	mov    %edx,(%eax)
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	99                   	cltd   
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	56                   	push   %esi
  80094f:	53                   	push   %ebx
  800950:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800953:	eb 17                	jmp    80096c <vprintfmt+0x21>
			if (ch == '\0')
  800955:	85 db                	test   %ebx,%ebx
  800957:	0f 84 c1 03 00 00    	je     800d1e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	53                   	push   %ebx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	8b 45 10             	mov    0x10(%ebp),%eax
  80096f:	8d 50 01             	lea    0x1(%eax),%edx
  800972:	89 55 10             	mov    %edx,0x10(%ebp)
  800975:	8a 00                	mov    (%eax),%al
  800977:	0f b6 d8             	movzbl %al,%ebx
  80097a:	83 fb 25             	cmp    $0x25,%ebx
  80097d:	75 d6                	jne    800955 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800983:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80098a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800991:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800998:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099f:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a2:	8d 50 01             	lea    0x1(%eax),%edx
  8009a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a8:	8a 00                	mov    (%eax),%al
  8009aa:	0f b6 d8             	movzbl %al,%ebx
  8009ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b0:	83 f8 5b             	cmp    $0x5b,%eax
  8009b3:	0f 87 3d 03 00 00    	ja     800cf6 <vprintfmt+0x3ab>
  8009b9:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  8009c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c6:	eb d7                	jmp    80099f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009cc:	eb d1                	jmp    80099f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d8:	89 d0                	mov    %edx,%eax
  8009da:	c1 e0 02             	shl    $0x2,%eax
  8009dd:	01 d0                	add    %edx,%eax
  8009df:	01 c0                	add    %eax,%eax
  8009e1:	01 d8                	add    %ebx,%eax
  8009e3:	83 e8 30             	sub    $0x30,%eax
  8009e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	8a 00                	mov    (%eax),%al
  8009ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f4:	7e 3e                	jle    800a34 <vprintfmt+0xe9>
  8009f6:	83 fb 39             	cmp    $0x39,%ebx
  8009f9:	7f 39                	jg     800a34 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fe:	eb d5                	jmp    8009d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	83 c0 04             	add    $0x4,%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 e8 04             	sub    $0x4,%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a14:	eb 1f                	jmp    800a35 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1a:	79 83                	jns    80099f <vprintfmt+0x54>
				width = 0;
  800a1c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a23:	e9 77 ff ff ff       	jmp    80099f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a28:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2f:	e9 6b ff ff ff       	jmp    80099f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a34:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a39:	0f 89 60 ff ff ff    	jns    80099f <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a45:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4c:	e9 4e ff ff ff       	jmp    80099f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a51:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a54:	e9 46 ff ff ff       	jmp    80099f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a59:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5c:	83 c0 04             	add    $0x4,%eax
  800a5f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 e8 04             	sub    $0x4,%eax
  800a68:	8b 00                	mov    (%eax),%eax
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	50                   	push   %eax
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
			break;
  800a79:	e9 9b 02 00 00       	jmp    800d19 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a81:	83 c0 04             	add    $0x4,%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	83 e8 04             	sub    $0x4,%eax
  800a8d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8f:	85 db                	test   %ebx,%ebx
  800a91:	79 02                	jns    800a95 <vprintfmt+0x14a>
				err = -err;
  800a93:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a95:	83 fb 64             	cmp    $0x64,%ebx
  800a98:	7f 0b                	jg     800aa5 <vprintfmt+0x15a>
  800a9a:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800aa1:	85 f6                	test   %esi,%esi
  800aa3:	75 19                	jne    800abe <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa5:	53                   	push   %ebx
  800aa6:	68 85 3e 80 00       	push   $0x803e85
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	ff 75 08             	pushl  0x8(%ebp)
  800ab1:	e8 70 02 00 00       	call   800d26 <printfmt>
  800ab6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab9:	e9 5b 02 00 00       	jmp    800d19 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abe:	56                   	push   %esi
  800abf:	68 8e 3e 80 00       	push   $0x803e8e
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 57 02 00 00       	call   800d26 <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			break;
  800ad2:	e9 42 02 00 00       	jmp    800d19 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	83 c0 04             	add    $0x4,%eax
  800add:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	83 e8 04             	sub    $0x4,%eax
  800ae6:	8b 30                	mov    (%eax),%esi
  800ae8:	85 f6                	test   %esi,%esi
  800aea:	75 05                	jne    800af1 <vprintfmt+0x1a6>
				p = "(null)";
  800aec:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800af1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af5:	7e 6d                	jle    800b64 <vprintfmt+0x219>
  800af7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800afb:	74 67                	je     800b64 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	50                   	push   %eax
  800b04:	56                   	push   %esi
  800b05:	e8 1e 03 00 00       	call   800e28 <strnlen>
  800b0a:	83 c4 10             	add    $0x10,%esp
  800b0d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b10:	eb 16                	jmp    800b28 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b12:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	50                   	push   %eax
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b25:	ff 4d e4             	decl   -0x1c(%ebp)
  800b28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2c:	7f e4                	jg     800b12 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2e:	eb 34                	jmp    800b64 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b30:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b34:	74 1c                	je     800b52 <vprintfmt+0x207>
  800b36:	83 fb 1f             	cmp    $0x1f,%ebx
  800b39:	7e 05                	jle    800b40 <vprintfmt+0x1f5>
  800b3b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3e:	7e 12                	jle    800b52 <vprintfmt+0x207>
					putch('?', putdat);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	6a 3f                	push   $0x3f
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
  800b50:	eb 0f                	jmp    800b61 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	53                   	push   %ebx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b61:	ff 4d e4             	decl   -0x1c(%ebp)
  800b64:	89 f0                	mov    %esi,%eax
  800b66:	8d 70 01             	lea    0x1(%eax),%esi
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	0f be d8             	movsbl %al,%ebx
  800b6e:	85 db                	test   %ebx,%ebx
  800b70:	74 24                	je     800b96 <vprintfmt+0x24b>
  800b72:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b76:	78 b8                	js     800b30 <vprintfmt+0x1e5>
  800b78:	ff 4d e0             	decl   -0x20(%ebp)
  800b7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7f:	79 af                	jns    800b30 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b81:	eb 13                	jmp    800b96 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	6a 20                	push   $0x20
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b93:	ff 4d e4             	decl   -0x1c(%ebp)
  800b96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9a:	7f e7                	jg     800b83 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9c:	e9 78 01 00 00       	jmp    800d19 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 3c fd ff ff       	call   8008ec <getint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbf:	85 d2                	test   %edx,%edx
  800bc1:	79 23                	jns    800be6 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	6a 2d                	push   $0x2d
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	ff d0                	call   *%eax
  800bd0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd9:	f7 d8                	neg    %eax
  800bdb:	83 d2 00             	adc    $0x0,%edx
  800bde:	f7 da                	neg    %edx
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bed:	e9 bc 00 00 00       	jmp    800cae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfb:	50                   	push   %eax
  800bfc:	e8 84 fc ff ff       	call   800885 <getuint>
  800c01:	83 c4 10             	add    $0x10,%esp
  800c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c11:	e9 98 00 00 00       	jmp    800cae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	6a 58                	push   $0x58
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	6a 58                	push   $0x58
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	ff d0                	call   *%eax
  800c33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	6a 58                	push   $0x58
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	ff d0                	call   *%eax
  800c43:	83 c4 10             	add    $0x10,%esp
			break;
  800c46:	e9 ce 00 00 00       	jmp    800d19 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 30                	push   $0x30
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 78                	push   $0x78
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8d:	eb 1f                	jmp    800cae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 e8             	pushl  -0x18(%ebp)
  800c95:	8d 45 14             	lea    0x14(%ebp),%eax
  800c98:	50                   	push   %eax
  800c99:	e8 e7 fb ff ff       	call   800885 <getuint>
  800c9e:	83 c4 10             	add    $0x10,%esp
  800ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	52                   	push   %edx
  800cb9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	ff 75 08             	pushl  0x8(%ebp)
  800cc9:	e8 00 fb ff ff       	call   8007ce <printnum>
  800cce:	83 c4 20             	add    $0x20,%esp
			break;
  800cd1:	eb 46                	jmp    800d19 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	53                   	push   %ebx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	eb 35                	jmp    800d19 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ce4:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800ceb:	eb 2c                	jmp    800d19 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ced:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800cf4:	eb 23                	jmp    800d19 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	ff 75 0c             	pushl  0xc(%ebp)
  800cfc:	6a 25                	push   $0x25
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	ff d0                	call   *%eax
  800d03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d06:	ff 4d 10             	decl   0x10(%ebp)
  800d09:	eb 03                	jmp    800d0e <vprintfmt+0x3c3>
  800d0b:	ff 4d 10             	decl   0x10(%ebp)
  800d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d11:	48                   	dec    %eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	3c 25                	cmp    $0x25,%al
  800d16:	75 f3                	jne    800d0b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d18:	90                   	nop
		}
	}
  800d19:	e9 35 fc ff ff       	jmp    800953 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2f:	83 c0 04             	add    $0x4,%eax
  800d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d35:	8b 45 10             	mov    0x10(%ebp),%eax
  800d38:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3b:	50                   	push   %eax
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	ff 75 08             	pushl  0x8(%ebp)
  800d42:	e8 04 fc ff ff       	call   80094b <vprintfmt>
  800d47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4a:	90                   	nop
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 08             	mov    0x8(%eax),%eax
  800d56:	8d 50 01             	lea    0x1(%eax),%edx
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	8b 10                	mov    (%eax),%edx
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	8b 40 04             	mov    0x4(%eax),%eax
  800d6a:	39 c2                	cmp    %eax,%edx
  800d6c:	73 12                	jae    800d80 <sprintputch+0x33>
		*b->buf++ = ch;
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	8b 00                	mov    (%eax),%eax
  800d73:	8d 48 01             	lea    0x1(%eax),%ecx
  800d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d79:	89 0a                	mov    %ecx,(%edx)
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	88 10                	mov    %dl,(%eax)
}
  800d80:	90                   	nop
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	01 d0                	add    %edx,%eax
  800d9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da8:	74 06                	je     800db0 <vsnprintf+0x2d>
  800daa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dae:	7f 07                	jg     800db7 <vsnprintf+0x34>
		return -E_INVAL;
  800db0:	b8 03 00 00 00       	mov    $0x3,%eax
  800db5:	eb 20                	jmp    800dd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800db7:	ff 75 14             	pushl  0x14(%ebp)
  800dba:	ff 75 10             	pushl  0x10(%ebp)
  800dbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc0:	50                   	push   %eax
  800dc1:	68 4d 0d 80 00       	push   $0x800d4d
  800dc6:	e8 80 fb ff ff       	call   80094b <vprintfmt>
  800dcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dd7:	c9                   	leave  
  800dd8:	c3                   	ret    

00800dd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ddf:	8d 45 10             	lea    0x10(%ebp),%eax
  800de2:	83 c0 04             	add    $0x4,%eax
  800de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800de8:	8b 45 10             	mov    0x10(%ebp),%eax
  800deb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dee:	50                   	push   %eax
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	ff 75 08             	pushl  0x8(%ebp)
  800df5:	e8 89 ff ff ff       	call   800d83 <vsnprintf>
  800dfa:	83 c4 10             	add    $0x10,%esp
  800dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e12:	eb 06                	jmp    800e1a <strlen+0x15>
		n++;
  800e14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e17:	ff 45 08             	incl   0x8(%ebp)
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 f1                	jne    800e14 <strlen+0xf>
		n++;
	return n;
  800e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 09                	jmp    800e40 <strnlen+0x18>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	ff 4d 0c             	decl   0xc(%ebp)
  800e40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e44:	74 09                	je     800e4f <strnlen+0x27>
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 e8                	jne    800e37 <strnlen+0xf>
		n++;
	return n;
  800e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e60:	90                   	nop
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8d 50 01             	lea    0x1(%eax),%edx
  800e67:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e73:	8a 12                	mov    (%edx),%dl
  800e75:	88 10                	mov    %dl,(%eax)
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	84 c0                	test   %al,%al
  800e7b:	75 e4                	jne    800e61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e95:	eb 1f                	jmp    800eb6 <strncpy+0x34>
		*dst++ = *src;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8d 50 01             	lea    0x1(%eax),%edx
  800e9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	84 c0                	test   %al,%al
  800eae:	74 03                	je     800eb3 <strncpy+0x31>
			src++;
  800eb0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb3:	ff 45 fc             	incl   -0x4(%ebp)
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ebc:	72 d9                	jb     800e97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    

00800ec3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	74 30                	je     800f05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed5:	eb 16                	jmp    800eed <strlcpy+0x2a>
			*dst++ = *src++;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8d 50 01             	lea    0x1(%eax),%edx
  800edd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee9:	8a 12                	mov    (%edx),%dl
  800eeb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eed:	ff 4d 10             	decl   0x10(%ebp)
  800ef0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef4:	74 09                	je     800eff <strlcpy+0x3c>
  800ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	84 c0                	test   %al,%al
  800efd:	75 d8                	jne    800ed7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	29 c2                	sub    %eax,%edx
  800f0d:	89 d0                	mov    %edx,%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f14:	eb 06                	jmp    800f1c <strcmp+0xb>
		p++, q++;
  800f16:	ff 45 08             	incl   0x8(%ebp)
  800f19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	84 c0                	test   %al,%al
  800f23:	74 0e                	je     800f33 <strcmp+0x22>
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 10                	mov    (%eax),%dl
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	38 c2                	cmp    %al,%dl
  800f31:	74 e3                	je     800f16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f b6 d0             	movzbl %al,%edx
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 c0             	movzbl %al,%eax
  800f43:	29 c2                	sub    %eax,%edx
  800f45:	89 d0                	mov    %edx,%eax
}
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f4c:	eb 09                	jmp    800f57 <strncmp+0xe>
		n--, p++, q++;
  800f4e:	ff 4d 10             	decl   0x10(%ebp)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5b:	74 17                	je     800f74 <strncmp+0x2b>
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	84 c0                	test   %al,%al
  800f64:	74 0e                	je     800f74 <strncmp+0x2b>
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 10                	mov    (%eax),%dl
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	38 c2                	cmp    %al,%dl
  800f72:	74 da                	je     800f4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f78:	75 07                	jne    800f81 <strncmp+0x38>
		return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7f:	eb 14                	jmp    800f95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	0f b6 d0             	movzbl %al,%edx
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	0f b6 c0             	movzbl %al,%eax
  800f91:	29 c2                	sub    %eax,%edx
  800f93:	89 d0                	mov    %edx,%eax
}
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 04             	sub    $0x4,%esp
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa3:	eb 12                	jmp    800fb7 <strchr+0x20>
		if (*s == c)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fad:	75 05                	jne    800fb4 <strchr+0x1d>
			return (char *) s;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	eb 11                	jmp    800fc5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb4:	ff 45 08             	incl   0x8(%ebp)
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	75 e5                	jne    800fa5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    

00800fc7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	83 ec 04             	sub    $0x4,%esp
  800fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd3:	eb 0d                	jmp    800fe2 <strfind+0x1b>
		if (*s == c)
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fdd:	74 0e                	je     800fed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	84 c0                	test   %al,%al
  800fe9:	75 ea                	jne    800fd5 <strfind+0xe>
  800feb:	eb 01                	jmp    800fee <strfind+0x27>
		if (*s == c)
			break;
  800fed:	90                   	nop
	return (char *) s;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fff:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801003:	76 63                	jbe    801068 <memset+0x75>
		uint64 data_block = c;
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	99                   	cltd   
  801009:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80100f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801012:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801015:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801019:	c1 e0 08             	shl    $0x8,%eax
  80101c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80101f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80102c:	c1 e0 10             	shl    $0x10,%eax
  80102f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801032:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	b8 00 00 00 00       	mov    $0x0,%eax
  801042:	09 45 f0             	or     %eax,-0x10(%ebp)
  801045:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801048:	eb 18                	jmp    801062 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80104a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80104d:	8d 41 08             	lea    0x8(%ecx),%eax
  801050:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801053:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801059:	89 01                	mov    %eax,(%ecx)
  80105b:	89 51 04             	mov    %edx,0x4(%ecx)
  80105e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801062:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801066:	77 e2                	ja     80104a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801068:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106c:	74 23                	je     801091 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80106e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801071:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801074:	eb 0e                	jmp    801084 <memset+0x91>
			*p8++ = (uint8)c;
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	8d 50 01             	lea    0x1(%eax),%edx
  80107c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801082:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108a:	89 55 10             	mov    %edx,0x10(%ebp)
  80108d:	85 c0                	test   %eax,%eax
  80108f:	75 e5                	jne    801076 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010a8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ac:	76 24                	jbe    8010d2 <memcpy+0x3c>
		while(n >= 8){
  8010ae:	eb 1c                	jmp    8010cc <memcpy+0x36>
			*d64 = *s64;
  8010b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b3:	8b 50 04             	mov    0x4(%eax),%edx
  8010b6:	8b 00                	mov    (%eax),%eax
  8010b8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010bb:	89 01                	mov    %eax,(%ecx)
  8010bd:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010c0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010c4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010c8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010cc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d0:	77 de                	ja     8010b0 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d6:	74 31                	je     801109 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010e4:	eb 16                	jmp    8010fc <memcpy+0x66>
			*d8++ = *s8++;
  8010e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010f8:	8a 12                	mov    (%edx),%dl
  8010fa:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801102:	89 55 10             	mov    %edx,0x10(%ebp)
  801105:	85 c0                	test   %eax,%eax
  801107:	75 dd                	jne    8010e6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801126:	73 50                	jae    801178 <memmove+0x6a>
  801128:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	01 d0                	add    %edx,%eax
  801130:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801133:	76 43                	jbe    801178 <memmove+0x6a>
		s += n;
  801135:	8b 45 10             	mov    0x10(%ebp),%eax
  801138:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801141:	eb 10                	jmp    801153 <memmove+0x45>
			*--d = *--s;
  801143:	ff 4d f8             	decl   -0x8(%ebp)
  801146:	ff 4d fc             	decl   -0x4(%ebp)
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	8a 10                	mov    (%eax),%dl
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801153:	8b 45 10             	mov    0x10(%ebp),%eax
  801156:	8d 50 ff             	lea    -0x1(%eax),%edx
  801159:	89 55 10             	mov    %edx,0x10(%ebp)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	75 e3                	jne    801143 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801160:	eb 23                	jmp    801185 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801162:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801165:	8d 50 01             	lea    0x1(%eax),%edx
  801168:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80116b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801171:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801174:	8a 12                	mov    (%edx),%dl
  801176:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117e:	89 55 10             	mov    %edx,0x10(%ebp)
  801181:	85 c0                	test   %eax,%eax
  801183:	75 dd                	jne    801162 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80119c:	eb 2a                	jmp    8011c8 <memcmp+0x3e>
		if (*s1 != *s2)
  80119e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a1:	8a 10                	mov    (%eax),%dl
  8011a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	38 c2                	cmp    %al,%dl
  8011aa:	74 16                	je     8011c2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	0f b6 d0             	movzbl %al,%edx
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f b6 c0             	movzbl %al,%eax
  8011bc:	29 c2                	sub    %eax,%edx
  8011be:	89 d0                	mov    %edx,%eax
  8011c0:	eb 18                	jmp    8011da <memcmp+0x50>
		s1++, s2++;
  8011c2:	ff 45 fc             	incl   -0x4(%ebp)
  8011c5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	75 c9                	jne    80119e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011ed:	eb 15                	jmp    801204 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f b6 d0             	movzbl %al,%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	0f b6 c0             	movzbl %al,%eax
  8011fd:	39 c2                	cmp    %eax,%edx
  8011ff:	74 0d                	je     80120e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80120a:	72 e3                	jb     8011ef <memfind+0x13>
  80120c:	eb 01                	jmp    80120f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80120e:	90                   	nop
	return (void *) s;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801221:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801228:	eb 03                	jmp    80122d <strtol+0x19>
		s++;
  80122a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 20                	cmp    $0x20,%al
  801234:	74 f4                	je     80122a <strtol+0x16>
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	3c 09                	cmp    $0x9,%al
  80123d:	74 eb                	je     80122a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3c 2b                	cmp    $0x2b,%al
  801246:	75 05                	jne    80124d <strtol+0x39>
		s++;
  801248:	ff 45 08             	incl   0x8(%ebp)
  80124b:	eb 13                	jmp    801260 <strtol+0x4c>
	else if (*s == '-')
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	3c 2d                	cmp    $0x2d,%al
  801254:	75 0a                	jne    801260 <strtol+0x4c>
		s++, neg = 1;
  801256:	ff 45 08             	incl   0x8(%ebp)
  801259:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801260:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801264:	74 06                	je     80126c <strtol+0x58>
  801266:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80126a:	75 20                	jne    80128c <strtol+0x78>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 30                	cmp    $0x30,%al
  801273:	75 17                	jne    80128c <strtol+0x78>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	40                   	inc    %eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 78                	cmp    $0x78,%al
  80127d:	75 0d                	jne    80128c <strtol+0x78>
		s += 2, base = 16;
  80127f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801283:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80128a:	eb 28                	jmp    8012b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80128c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801290:	75 15                	jne    8012a7 <strtol+0x93>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 30                	cmp    $0x30,%al
  801299:	75 0c                	jne    8012a7 <strtol+0x93>
		s++, base = 8;
  80129b:	ff 45 08             	incl   0x8(%ebp)
  80129e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012a5:	eb 0d                	jmp    8012b4 <strtol+0xa0>
	else if (base == 0)
  8012a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ab:	75 07                	jne    8012b4 <strtol+0xa0>
		base = 10;
  8012ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 2f                	cmp    $0x2f,%al
  8012bb:	7e 19                	jle    8012d6 <strtol+0xc2>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 39                	cmp    $0x39,%al
  8012c4:	7f 10                	jg     8012d6 <strtol+0xc2>
			dig = *s - '0';
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	0f be c0             	movsbl %al,%eax
  8012ce:	83 e8 30             	sub    $0x30,%eax
  8012d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d4:	eb 42                	jmp    801318 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 60                	cmp    $0x60,%al
  8012dd:	7e 19                	jle    8012f8 <strtol+0xe4>
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 7a                	cmp    $0x7a,%al
  8012e6:	7f 10                	jg     8012f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	0f be c0             	movsbl %al,%eax
  8012f0:	83 e8 57             	sub    $0x57,%eax
  8012f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f6:	eb 20                	jmp    801318 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	3c 40                	cmp    $0x40,%al
  8012ff:	7e 39                	jle    80133a <strtol+0x126>
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 5a                	cmp    $0x5a,%al
  801308:	7f 30                	jg     80133a <strtol+0x126>
			dig = *s - 'A' + 10;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f be c0             	movsbl %al,%eax
  801312:	83 e8 37             	sub    $0x37,%eax
  801315:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80131e:	7d 19                	jge    801339 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801320:	ff 45 08             	incl   0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	0f af 45 10          	imul   0x10(%ebp),%eax
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132f:	01 d0                	add    %edx,%eax
  801331:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801334:	e9 7b ff ff ff       	jmp    8012b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801339:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80133a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80133e:	74 08                	je     801348 <strtol+0x134>
		*endptr = (char *) s;
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
  801346:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801348:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80134c:	74 07                	je     801355 <strtol+0x141>
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	f7 d8                	neg    %eax
  801353:	eb 03                	jmp    801358 <strtol+0x144>
  801355:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <ltostr>:

void
ltostr(long value, char *str)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801360:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801367:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80136e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801372:	79 13                	jns    801387 <ltostr+0x2d>
	{
		neg = 1;
  801374:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801381:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801384:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80138f:	99                   	cltd   
  801390:	f7 f9                	idiv   %ecx
  801392:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801395:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801398:	8d 50 01             	lea    0x1(%eax),%edx
  80139b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80139e:	89 c2                	mov    %eax,%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013a8:	83 c2 30             	add    $0x30,%edx
  8013ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013b5:	f7 e9                	imul   %ecx
  8013b7:	c1 fa 02             	sar    $0x2,%edx
  8013ba:	89 c8                	mov    %ecx,%eax
  8013bc:	c1 f8 1f             	sar    $0x1f,%eax
  8013bf:	29 c2                	sub    %eax,%edx
  8013c1:	89 d0                	mov    %edx,%eax
  8013c3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ca:	75 bb                	jne    801387 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	48                   	dec    %eax
  8013d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013da:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013de:	74 3d                	je     80141d <ltostr+0xc3>
		start = 1 ;
  8013e0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013e7:	eb 34                	jmp    80141d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 d0                	add    %edx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	01 c2                	add    %eax,%edx
  8013fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 c8                	add    %ecx,%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80140a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	01 c2                	add    %eax,%edx
  801412:	8a 45 eb             	mov    -0x15(%ebp),%al
  801415:	88 02                	mov    %al,(%edx)
		start++ ;
  801417:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80141a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80141d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801420:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801423:	7c c4                	jl     8013e9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801425:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801430:	90                   	nop
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801439:	ff 75 08             	pushl  0x8(%ebp)
  80143c:	e8 c4 f9 ff ff       	call   800e05 <strlen>
  801441:	83 c4 04             	add    $0x4,%esp
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801447:	ff 75 0c             	pushl  0xc(%ebp)
  80144a:	e8 b6 f9 ff ff       	call   800e05 <strlen>
  80144f:	83 c4 04             	add    $0x4,%esp
  801452:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801455:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80145c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801463:	eb 17                	jmp    80147c <strcconcat+0x49>
		final[s] = str1[s] ;
  801465:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	01 c2                	add    %eax,%edx
  80146d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	01 c8                	add    %ecx,%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801479:	ff 45 fc             	incl   -0x4(%ebp)
  80147c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801482:	7c e1                	jl     801465 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801484:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80148b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801492:	eb 1f                	jmp    8014b3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801494:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80149d:	89 c2                	mov    %eax,%edx
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	01 c2                	add    %eax,%edx
  8014a4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014aa:	01 c8                	add    %ecx,%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b0:	ff 45 f8             	incl   -0x8(%ebp)
  8014b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014b9:	7c d9                	jl     801494 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	c6 00 00             	movb   $0x0,(%eax)
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d8:	8b 00                	mov    (%eax),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ec:	eb 0c                	jmp    8014fa <strsplit+0x31>
			*string++ = 0;
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8014f7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	84 c0                	test   %al,%al
  801501:	74 18                	je     80151b <strsplit+0x52>
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	0f be c0             	movsbl %al,%eax
  80150b:	50                   	push   %eax
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	e8 83 fa ff ff       	call   800f97 <strchr>
  801514:	83 c4 08             	add    $0x8,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	75 d3                	jne    8014ee <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	74 5a                	je     80157e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801524:	8b 45 14             	mov    0x14(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	83 f8 0f             	cmp    $0xf,%eax
  80152c:	75 07                	jne    801535 <strsplit+0x6c>
		{
			return 0;
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
  801533:	eb 66                	jmp    80159b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801535:	8b 45 14             	mov    0x14(%ebp),%eax
  801538:	8b 00                	mov    (%eax),%eax
  80153a:	8d 48 01             	lea    0x1(%eax),%ecx
  80153d:	8b 55 14             	mov    0x14(%ebp),%edx
  801540:	89 0a                	mov    %ecx,(%edx)
  801542:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	01 c2                	add    %eax,%edx
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801553:	eb 03                	jmp    801558 <strsplit+0x8f>
			string++;
  801555:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	84 c0                	test   %al,%al
  80155f:	74 8b                	je     8014ec <strsplit+0x23>
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	0f be c0             	movsbl %al,%eax
  801569:	50                   	push   %eax
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	e8 25 fa ff ff       	call   800f97 <strchr>
  801572:	83 c4 08             	add    $0x8,%esp
  801575:	85 c0                	test   %eax,%eax
  801577:	74 dc                	je     801555 <strsplit+0x8c>
			string++;
	}
  801579:	e9 6e ff ff ff       	jmp    8014ec <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80157e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80157f:	8b 45 14             	mov    0x14(%ebp),%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158b:	8b 45 10             	mov    0x10(%ebp),%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801596:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b0:	eb 4a                	jmp    8015fc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	01 c2                	add    %eax,%edx
  8015ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 c8                	add    %ecx,%eax
  8015c2:	8a 00                	mov    (%eax),%al
  8015c4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	8a 00                	mov    (%eax),%al
  8015d0:	3c 40                	cmp    $0x40,%al
  8015d2:	7e 25                	jle    8015f9 <str2lower+0x5c>
  8015d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015da:	01 d0                	add    %edx,%eax
  8015dc:	8a 00                	mov    (%eax),%al
  8015de:	3c 5a                	cmp    $0x5a,%al
  8015e0:	7f 17                	jg     8015f9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	01 d0                	add    %edx,%eax
  8015ea:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f0:	01 ca                	add    %ecx,%edx
  8015f2:	8a 12                	mov    (%edx),%dl
  8015f4:	83 c2 20             	add    $0x20,%edx
  8015f7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015f9:	ff 45 fc             	incl   -0x4(%ebp)
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	e8 01 f8 ff ff       	call   800e05 <strlen>
  801604:	83 c4 04             	add    $0x4,%esp
  801607:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80160a:	7f a6                	jg     8015b2 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80160c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801617:	83 ec 0c             	sub    $0xc,%esp
  80161a:	6a 10                	push   $0x10
  80161c:	e8 b2 15 00 00       	call   802bd3 <alloc_block>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801627:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80162b:	75 14                	jne    801641 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	68 08 40 80 00       	push   $0x804008
  801635:	6a 14                	push   $0x14
  801637:	68 31 40 80 00       	push   $0x804031
  80163c:	e8 fd ed ff ff       	call   80043e <_panic>

	node->start = start;
  801641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801644:	8b 55 08             	mov    0x8(%ebp),%edx
  801647:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801649:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164f:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801652:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801659:	a1 24 50 80 00       	mov    0x805024,%eax
  80165e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801661:	eb 18                	jmp    80167b <insert_page_alloc+0x6a>
		if (start < it->start)
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	8b 00                	mov    (%eax),%eax
  801668:	3b 45 08             	cmp    0x8(%ebp),%eax
  80166b:	77 37                	ja     8016a4 <insert_page_alloc+0x93>
			break;
		prev = it;
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801673:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80167b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80167f:	74 08                	je     801689 <insert_page_alloc+0x78>
  801681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801684:	8b 40 08             	mov    0x8(%eax),%eax
  801687:	eb 05                	jmp    80168e <insert_page_alloc+0x7d>
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
  80168e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801693:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801698:	85 c0                	test   %eax,%eax
  80169a:	75 c7                	jne    801663 <insert_page_alloc+0x52>
  80169c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a0:	75 c1                	jne    801663 <insert_page_alloc+0x52>
  8016a2:	eb 01                	jmp    8016a5 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8016a4:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8016a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016a9:	75 64                	jne    80170f <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8016ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016af:	75 14                	jne    8016c5 <insert_page_alloc+0xb4>
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	68 40 40 80 00       	push   $0x804040
  8016b9:	6a 21                	push   $0x21
  8016bb:	68 31 40 80 00       	push   $0x804031
  8016c0:	e8 79 ed ff ff       	call   80043e <_panic>
  8016c5:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8016cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ce:	89 50 08             	mov    %edx,0x8(%eax)
  8016d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d4:	8b 40 08             	mov    0x8(%eax),%eax
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	74 0d                	je     8016e8 <insert_page_alloc+0xd7>
  8016db:	a1 24 50 80 00       	mov    0x805024,%eax
  8016e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016e3:	89 50 0c             	mov    %edx,0xc(%eax)
  8016e6:	eb 08                	jmp    8016f0 <insert_page_alloc+0xdf>
  8016e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016eb:	a3 28 50 80 00       	mov    %eax,0x805028
  8016f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f3:	a3 24 50 80 00       	mov    %eax,0x805024
  8016f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801702:	a1 30 50 80 00       	mov    0x805030,%eax
  801707:	40                   	inc    %eax
  801708:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  80170d:	eb 71                	jmp    801780 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  80170f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801713:	74 06                	je     80171b <insert_page_alloc+0x10a>
  801715:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801719:	75 14                	jne    80172f <insert_page_alloc+0x11e>
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	68 64 40 80 00       	push   $0x804064
  801723:	6a 23                	push   $0x23
  801725:	68 31 40 80 00       	push   $0x804031
  80172a:	e8 0f ed ff ff       	call   80043e <_panic>
  80172f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801732:	8b 50 08             	mov    0x8(%eax),%edx
  801735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801738:	89 50 08             	mov    %edx,0x8(%eax)
  80173b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173e:	8b 40 08             	mov    0x8(%eax),%eax
  801741:	85 c0                	test   %eax,%eax
  801743:	74 0c                	je     801751 <insert_page_alloc+0x140>
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	8b 40 08             	mov    0x8(%eax),%eax
  80174b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80174e:	89 50 0c             	mov    %edx,0xc(%eax)
  801751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801754:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801757:	89 50 08             	mov    %edx,0x8(%eax)
  80175a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801760:	89 50 0c             	mov    %edx,0xc(%eax)
  801763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801766:	8b 40 08             	mov    0x8(%eax),%eax
  801769:	85 c0                	test   %eax,%eax
  80176b:	75 08                	jne    801775 <insert_page_alloc+0x164>
  80176d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801770:	a3 28 50 80 00       	mov    %eax,0x805028
  801775:	a1 30 50 80 00       	mov    0x805030,%eax
  80177a:	40                   	inc    %eax
  80177b:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801789:	a1 24 50 80 00       	mov    0x805024,%eax
  80178e:	85 c0                	test   %eax,%eax
  801790:	75 0c                	jne    80179e <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801792:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801797:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  80179c:	eb 67                	jmp    801805 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80179e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8017a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017a6:	a1 24 50 80 00       	mov    0x805024,%eax
  8017ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017ae:	eb 26                	jmp    8017d6 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8017b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b3:	8b 10                	mov    (%eax),%edx
  8017b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b8:	8b 40 04             	mov    0x4(%eax),%eax
  8017bb:	01 d0                	add    %edx,%eax
  8017bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017c6:	76 06                	jbe    8017ce <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8017ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8017d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017da:	74 08                	je     8017e4 <recompute_page_alloc_break+0x61>
  8017dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017df:	8b 40 08             	mov    0x8(%eax),%eax
  8017e2:	eb 05                	jmp    8017e9 <recompute_page_alloc_break+0x66>
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	75 b9                	jne    8017b0 <recompute_page_alloc_break+0x2d>
  8017f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017fb:	75 b3                	jne    8017b0 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8017fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801800:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  80180d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	48                   	dec    %eax
  80181d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801820:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	f7 75 d8             	divl   -0x28(%ebp)
  80182b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80182e:	29 d0                	sub    %edx,%eax
  801830:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801833:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801837:	75 0a                	jne    801843 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
  80183e:	e9 7e 01 00 00       	jmp    8019c1 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801843:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80184a:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  80184e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801855:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80185c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801861:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801864:	a1 24 50 80 00       	mov    0x805024,%eax
  801869:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80186c:	eb 69                	jmp    8018d7 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  80186e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801876:	76 47                	jbe    8018bf <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  80187e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801881:	8b 00                	mov    (%eax),%eax
  801883:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801886:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801889:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80188c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80188f:	72 2e                	jb     8018bf <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801891:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801895:	75 14                	jne    8018ab <alloc_pages_custom_fit+0xa4>
  801897:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80189a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80189d:	75 0c                	jne    8018ab <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  80189f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8018a5:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8018a9:	eb 14                	jmp    8018bf <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8018ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018ae:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018b1:	76 0c                	jbe    8018bf <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8018b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8018b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8018bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c2:	8b 10                	mov    (%eax),%edx
  8018c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c7:	8b 40 04             	mov    0x4(%eax),%eax
  8018ca:	01 d0                	add    %edx,%eax
  8018cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8018cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018db:	74 08                	je     8018e5 <alloc_pages_custom_fit+0xde>
  8018dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e0:	8b 40 08             	mov    0x8(%eax),%eax
  8018e3:	eb 05                	jmp    8018ea <alloc_pages_custom_fit+0xe3>
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	0f 85 72 ff ff ff    	jne    80186e <alloc_pages_custom_fit+0x67>
  8018fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801900:	0f 85 68 ff ff ff    	jne    80186e <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801906:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80190b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80190e:	76 47                	jbe    801957 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801913:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801916:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80191b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80191e:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801921:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801924:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801927:	72 2e                	jb     801957 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801929:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80192d:	75 14                	jne    801943 <alloc_pages_custom_fit+0x13c>
  80192f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801932:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801935:	75 0c                	jne    801943 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80193a:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  80193d:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801941:	eb 14                	jmp    801957 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801943:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801946:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801949:	76 0c                	jbe    801957 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80194b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80194e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801951:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801954:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801957:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80195e:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801962:	74 08                	je     80196c <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801967:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80196a:	eb 40                	jmp    8019ac <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80196c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801970:	74 08                	je     80197a <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801975:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801978:	eb 32                	jmp    8019ac <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80197a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80197f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801982:	89 c2                	mov    %eax,%edx
  801984:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801989:	39 c2                	cmp    %eax,%edx
  80198b:	73 07                	jae    801994 <alloc_pages_custom_fit+0x18d>
			return NULL;
  80198d:	b8 00 00 00 00       	mov    $0x0,%eax
  801992:	eb 2d                	jmp    8019c1 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801994:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801999:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  80199c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8019a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019a5:	01 d0                	add    %edx,%eax
  8019a7:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  8019ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019af:	83 ec 08             	sub    $0x8,%esp
  8019b2:	ff 75 d0             	pushl  -0x30(%ebp)
  8019b5:	50                   	push   %eax
  8019b6:	e8 56 fc ff ff       	call   801611 <insert_page_alloc>
  8019bb:	83 c4 10             	add    $0x10,%esp

	return result;
  8019be:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019cf:	a1 24 50 80 00       	mov    0x805024,%eax
  8019d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8019d7:	eb 1a                	jmp    8019f3 <find_allocated_size+0x30>
		if (it->start == va)
  8019d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019dc:	8b 00                	mov    (%eax),%eax
  8019de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019e1:	75 08                	jne    8019eb <find_allocated_size+0x28>
			return it->size;
  8019e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e6:	8b 40 04             	mov    0x4(%eax),%eax
  8019e9:	eb 34                	jmp    801a1f <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019eb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8019f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019f7:	74 08                	je     801a01 <find_allocated_size+0x3e>
  8019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fc:	8b 40 08             	mov    0x8(%eax),%eax
  8019ff:	eb 05                	jmp    801a06 <find_allocated_size+0x43>
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
  801a06:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a0b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a10:	85 c0                	test   %eax,%eax
  801a12:	75 c5                	jne    8019d9 <find_allocated_size+0x16>
  801a14:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a18:	75 bf                	jne    8019d9 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a2d:	a1 24 50 80 00       	mov    0x805024,%eax
  801a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a35:	e9 e1 01 00 00       	jmp    801c1b <free_pages+0x1fa>
		if (it->start == va) {
  801a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a42:	0f 85 cb 01 00 00    	jne    801c13 <free_pages+0x1f2>

			uint32 start = it->start;
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	8b 00                	mov    (%eax),%eax
  801a4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a53:	8b 40 04             	mov    0x4(%eax),%eax
  801a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a5c:	f7 d0                	not    %eax
  801a5e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a61:	73 1d                	jae    801a80 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a69:	ff 75 e8             	pushl  -0x18(%ebp)
  801a6c:	68 98 40 80 00       	push   $0x804098
  801a71:	68 a5 00 00 00       	push   $0xa5
  801a76:	68 31 40 80 00       	push   $0x804031
  801a7b:	e8 be e9 ff ff       	call   80043e <_panic>
			}

			uint32 start_end = start + size;
  801a80:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a86:	01 d0                	add    %edx,%eax
  801a88:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801a8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	79 19                	jns    801aab <free_pages+0x8a>
  801a92:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801a99:	77 10                	ja     801aab <free_pages+0x8a>
  801a9b:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801aa2:	77 07                	ja     801aab <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 2c                	js     801ad7 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aae:	83 ec 0c             	sub    $0xc,%esp
  801ab1:	68 00 00 00 a0       	push   $0xa0000000
  801ab6:	ff 75 e0             	pushl  -0x20(%ebp)
  801ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801abc:	ff 75 e8             	pushl  -0x18(%ebp)
  801abf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ac2:	50                   	push   %eax
  801ac3:	68 dc 40 80 00       	push   $0x8040dc
  801ac8:	68 ad 00 00 00       	push   $0xad
  801acd:	68 31 40 80 00       	push   $0x804031
  801ad2:	e8 67 e9 ff ff       	call   80043e <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801add:	e9 88 00 00 00       	jmp    801b6a <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801ae2:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801ae9:	76 17                	jbe    801b02 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801aeb:	ff 75 f0             	pushl  -0x10(%ebp)
  801aee:	68 40 41 80 00       	push   $0x804140
  801af3:	68 b4 00 00 00       	push   $0xb4
  801af8:	68 31 40 80 00       	push   $0x804031
  801afd:	e8 3c e9 ff ff       	call   80043e <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b05:	05 00 10 00 00       	add    $0x1000,%eax
  801b0a:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b10:	85 c0                	test   %eax,%eax
  801b12:	79 2e                	jns    801b42 <free_pages+0x121>
  801b14:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b1b:	77 25                	ja     801b42 <free_pages+0x121>
  801b1d:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801b24:	77 1c                	ja     801b42 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	68 00 10 00 00       	push   $0x1000
  801b2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b31:	e8 38 0d 00 00       	call   80286e <sys_free_user_mem>
  801b36:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b39:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b40:	eb 28                	jmp    801b6a <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b45:	68 00 00 00 a0       	push   $0xa0000000
  801b4a:	ff 75 dc             	pushl  -0x24(%ebp)
  801b4d:	68 00 10 00 00       	push   $0x1000
  801b52:	ff 75 f0             	pushl  -0x10(%ebp)
  801b55:	50                   	push   %eax
  801b56:	68 80 41 80 00       	push   $0x804180
  801b5b:	68 bd 00 00 00       	push   $0xbd
  801b60:	68 31 40 80 00       	push   $0x804031
  801b65:	e8 d4 e8 ff ff       	call   80043e <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b70:	0f 82 6c ff ff ff    	jb     801ae2 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b7a:	75 17                	jne    801b93 <free_pages+0x172>
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	68 e2 41 80 00       	push   $0x8041e2
  801b84:	68 c1 00 00 00       	push   $0xc1
  801b89:	68 31 40 80 00       	push   $0x804031
  801b8e:	e8 ab e8 ff ff       	call   80043e <_panic>
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	8b 40 08             	mov    0x8(%eax),%eax
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	74 11                	je     801bae <free_pages+0x18d>
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	8b 40 08             	mov    0x8(%eax),%eax
  801ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba6:	8b 52 0c             	mov    0xc(%edx),%edx
  801ba9:	89 50 0c             	mov    %edx,0xc(%eax)
  801bac:	eb 0b                	jmp    801bb9 <free_pages+0x198>
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb4:	a3 28 50 80 00       	mov    %eax,0x805028
  801bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	74 11                	je     801bd4 <free_pages+0x1b3>
  801bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc6:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcc:	8b 52 08             	mov    0x8(%edx),%edx
  801bcf:	89 50 08             	mov    %edx,0x8(%eax)
  801bd2:	eb 0b                	jmp    801bdf <free_pages+0x1be>
  801bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd7:	8b 40 08             	mov    0x8(%eax),%eax
  801bda:	a3 24 50 80 00       	mov    %eax,0x805024
  801bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801bf3:	a1 30 50 80 00       	mov    0x805030,%eax
  801bf8:	48                   	dec    %eax
  801bf9:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801bfe:	83 ec 0c             	sub    $0xc,%esp
  801c01:	ff 75 f4             	pushl  -0xc(%ebp)
  801c04:	e8 24 15 00 00       	call   80312d <free_block>
  801c09:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801c0c:	e8 72 fb ff ff       	call   801783 <recompute_page_alloc_break>

			return;
  801c11:	eb 37                	jmp    801c4a <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c13:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c1f:	74 08                	je     801c29 <free_pages+0x208>
  801c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c24:	8b 40 08             	mov    0x8(%eax),%eax
  801c27:	eb 05                	jmp    801c2e <free_pages+0x20d>
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c33:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	0f 85 fa fd ff ff    	jne    801a3a <free_pages+0x19>
  801c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c44:	0f 85 f0 fd ff ff    	jne    801a3a <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    

00801c56 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801c5c:	a1 08 50 80 00       	mov    0x805008,%eax
  801c61:	85 c0                	test   %eax,%eax
  801c63:	74 60                	je     801cc5 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801c65:	83 ec 08             	sub    $0x8,%esp
  801c68:	68 00 00 00 82       	push   $0x82000000
  801c6d:	68 00 00 00 80       	push   $0x80000000
  801c72:	e8 0d 0d 00 00       	call   802984 <initialize_dynamic_allocator>
  801c77:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801c7a:	e8 f3 0a 00 00       	call   802772 <sys_get_uheap_strategy>
  801c7f:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801c84:	a1 40 50 80 00       	mov    0x805040,%eax
  801c89:	05 00 10 00 00       	add    $0x1000,%eax
  801c8e:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801c93:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c98:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801c9d:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801ca4:	00 00 00 
  801ca7:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801cae:	00 00 00 
  801cb1:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801cb8:	00 00 00 

		__firstTimeFlag = 0;
  801cbb:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801cc2:	00 00 00 
	}
}
  801cc5:	90                   	nop
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cdc:	83 ec 08             	sub    $0x8,%esp
  801cdf:	68 06 04 00 00       	push   $0x406
  801ce4:	50                   	push   %eax
  801ce5:	e8 d2 06 00 00       	call   8023bc <__sys_allocate_page>
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801cf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf4:	79 17                	jns    801d0d <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801cf6:	83 ec 04             	sub    $0x4,%esp
  801cf9:	68 00 42 80 00       	push   $0x804200
  801cfe:	68 ea 00 00 00       	push   $0xea
  801d03:	68 31 40 80 00       	push   $0x804031
  801d08:	e8 31 e7 ff ff       	call   80043e <_panic>
	return 0;
  801d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d28:	83 ec 0c             	sub    $0xc,%esp
  801d2b:	50                   	push   %eax
  801d2c:	e8 d2 06 00 00       	call   802403 <__sys_unmap_frame>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d3b:	79 17                	jns    801d54 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	68 3c 42 80 00       	push   $0x80423c
  801d45:	68 f5 00 00 00       	push   $0xf5
  801d4a:	68 31 40 80 00       	push   $0x804031
  801d4f:	e8 ea e6 ff ff       	call   80043e <_panic>
}
  801d54:	90                   	nop
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d5d:	e8 f4 fe ff ff       	call   801c56 <uheap_init>
	if (size == 0) return NULL ;
  801d62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d66:	75 0a                	jne    801d72 <malloc+0x1b>
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6d:	e9 67 01 00 00       	jmp    801ed9 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801d79:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d80:	77 16                	ja     801d98 <malloc+0x41>
		result = alloc_block(size);
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	e8 46 0e 00 00       	call   802bd3 <alloc_block>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d93:	e9 3e 01 00 00       	jmp    801ed6 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801d98:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  801da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da5:	01 d0                	add    %edx,%eax
  801da7:	48                   	dec    %eax
  801da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dae:	ba 00 00 00 00       	mov    $0x0,%edx
  801db3:	f7 75 f0             	divl   -0x10(%ebp)
  801db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db9:	29 d0                	sub    %edx,%eax
  801dbb:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801dbe:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	75 0a                	jne    801dd1 <malloc+0x7a>
			return NULL;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	e9 08 01 00 00       	jmp    801ed9 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801dd1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	74 0f                	je     801de9 <malloc+0x92>
  801dda:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801de0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801de5:	39 c2                	cmp    %eax,%edx
  801de7:	73 0a                	jae    801df3 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801de9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801dee:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801df3:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801df8:	83 f8 05             	cmp    $0x5,%eax
  801dfb:	75 11                	jne    801e0e <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	ff 75 e8             	pushl  -0x18(%ebp)
  801e03:	e8 ff f9 ff ff       	call   801807 <alloc_pages_custom_fit>
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e12:	0f 84 be 00 00 00    	je     801ed6 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801e1e:	83 ec 0c             	sub    $0xc,%esp
  801e21:	ff 75 f4             	pushl  -0xc(%ebp)
  801e24:	e8 9a fb ff ff       	call   8019c3 <find_allocated_size>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801e2f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e33:	75 17                	jne    801e4c <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801e35:	ff 75 f4             	pushl  -0xc(%ebp)
  801e38:	68 7c 42 80 00       	push   $0x80427c
  801e3d:	68 24 01 00 00       	push   $0x124
  801e42:	68 31 40 80 00       	push   $0x804031
  801e47:	e8 f2 e5 ff ff       	call   80043e <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4f:	f7 d0                	not    %eax
  801e51:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e54:	73 1d                	jae    801e73 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	ff 75 e0             	pushl  -0x20(%ebp)
  801e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e5f:	68 c4 42 80 00       	push   $0x8042c4
  801e64:	68 29 01 00 00       	push   $0x129
  801e69:	68 31 40 80 00       	push   $0x804031
  801e6e:	e8 cb e5 ff ff       	call   80043e <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801e73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e79:	01 d0                	add    %edx,%eax
  801e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e81:	85 c0                	test   %eax,%eax
  801e83:	79 2c                	jns    801eb1 <malloc+0x15a>
  801e85:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801e8c:	77 23                	ja     801eb1 <malloc+0x15a>
  801e8e:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801e95:	77 1a                	ja     801eb1 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801e97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	79 13                	jns    801eb1 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801e9e:	83 ec 08             	sub    $0x8,%esp
  801ea1:	ff 75 e0             	pushl  -0x20(%ebp)
  801ea4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ea7:	e8 de 09 00 00       	call   80288a <sys_allocate_user_mem>
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	eb 25                	jmp    801ed6 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801eb1:	68 00 00 00 a0       	push   $0xa0000000
  801eb6:	ff 75 dc             	pushl  -0x24(%ebp)
  801eb9:	ff 75 e0             	pushl  -0x20(%ebp)
  801ebc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ebf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec2:	68 00 43 80 00       	push   $0x804300
  801ec7:	68 33 01 00 00       	push   $0x133
  801ecc:	68 31 40 80 00       	push   $0x804031
  801ed1:	e8 68 e5 ff ff       	call   80043e <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801ee1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ee5:	0f 84 26 01 00 00    	je     802011 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	79 1c                	jns    801f14 <free+0x39>
  801ef8:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801eff:	77 13                	ja     801f14 <free+0x39>
		free_block(virtual_address);
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	ff 75 08             	pushl  0x8(%ebp)
  801f07:	e8 21 12 00 00       	call   80312d <free_block>
  801f0c:	83 c4 10             	add    $0x10,%esp
		return;
  801f0f:	e9 01 01 00 00       	jmp    802015 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801f14:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f19:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801f1c:	0f 82 d8 00 00 00    	jb     801ffa <free+0x11f>
  801f22:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801f29:	0f 87 cb 00 00 00    	ja     801ffa <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f37:	85 c0                	test   %eax,%eax
  801f39:	74 17                	je     801f52 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801f3b:	ff 75 08             	pushl  0x8(%ebp)
  801f3e:	68 70 43 80 00       	push   $0x804370
  801f43:	68 57 01 00 00       	push   $0x157
  801f48:	68 31 40 80 00       	push   $0x804031
  801f4d:	e8 ec e4 ff ff       	call   80043e <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	ff 75 08             	pushl  0x8(%ebp)
  801f58:	e8 66 fa ff ff       	call   8019c3 <find_allocated_size>
  801f5d:	83 c4 10             	add    $0x10,%esp
  801f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801f63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f67:	0f 84 a7 00 00 00    	je     802014 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f70:	f7 d0                	not    %eax
  801f72:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f75:	73 1d                	jae    801f94 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f80:	68 98 43 80 00       	push   $0x804398
  801f85:	68 61 01 00 00       	push   $0x161
  801f8a:	68 31 40 80 00       	push   $0x804031
  801f8f:	e8 aa e4 ff ff       	call   80043e <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	79 19                	jns    801fbf <free+0xe4>
  801fa6:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801fad:	77 10                	ja     801fbf <free+0xe4>
  801faf:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801fb6:	77 07                	ja     801fbf <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 2b                	js     801fea <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	68 00 00 00 a0       	push   $0xa0000000
  801fc7:	ff 75 ec             	pushl  -0x14(%ebp)
  801fca:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd3:	ff 75 08             	pushl  0x8(%ebp)
  801fd6:	68 d4 43 80 00       	push   $0x8043d4
  801fdb:	68 69 01 00 00       	push   $0x169
  801fe0:	68 31 40 80 00       	push   $0x804031
  801fe5:	e8 54 e4 ff ff       	call   80043e <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	ff 75 08             	pushl  0x8(%ebp)
  801ff0:	e8 2c fa ff ff       	call   801a21 <free_pages>
  801ff5:	83 c4 10             	add    $0x10,%esp
		return;
  801ff8:	eb 1b                	jmp    802015 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	68 30 44 80 00       	push   $0x804430
  802002:	68 70 01 00 00       	push   $0x170
  802007:	68 31 40 80 00       	push   $0x804031
  80200c:	e8 2d e4 ff ff       	call   80043e <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802011:	90                   	nop
  802012:	eb 01                	jmp    802015 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802014:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 38             	sub    $0x38,%esp
  80201d:	8b 45 10             	mov    0x10(%ebp),%eax
  802020:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802023:	e8 2e fc ff ff       	call   801c56 <uheap_init>
	if (size == 0) return NULL ;
  802028:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80202c:	75 0a                	jne    802038 <smalloc+0x21>
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	e9 3d 01 00 00       	jmp    802175 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80203e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802041:	25 ff 0f 00 00       	and    $0xfff,%eax
  802046:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802049:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80204d:	74 0e                	je     80205d <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802055:	05 00 10 00 00       	add    $0x1000,%eax
  80205a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	c1 e8 0c             	shr    $0xc,%eax
  802063:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802066:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80206b:	85 c0                	test   %eax,%eax
  80206d:	75 0a                	jne    802079 <smalloc+0x62>
		return NULL;
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	e9 fc 00 00 00       	jmp    802175 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802079:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80207e:	85 c0                	test   %eax,%eax
  802080:	74 0f                	je     802091 <smalloc+0x7a>
  802082:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802088:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80208d:	39 c2                	cmp    %eax,%edx
  80208f:	73 0a                	jae    80209b <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802091:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802096:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80209b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020a0:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8020a5:	29 c2                	sub    %eax,%edx
  8020a7:	89 d0                	mov    %edx,%eax
  8020a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8020ac:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8020b2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020b7:	29 c2                	sub    %eax,%edx
  8020b9:	89 d0                	mov    %edx,%eax
  8020bb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020c4:	77 13                	ja     8020d9 <smalloc+0xc2>
  8020c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020cc:	77 0b                	ja     8020d9 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8020ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d1:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8020d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8020d7:	73 0a                	jae    8020e3 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	e9 92 00 00 00       	jmp    802175 <smalloc+0x15e>
	}

	void *va = NULL;
  8020e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8020ea:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8020ef:	83 f8 05             	cmp    $0x5,%eax
  8020f2:	75 11                	jne    802105 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fa:	e8 08 f7 ff ff       	call   801807 <alloc_pages_custom_fit>
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802105:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802109:	75 27                	jne    802132 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80210b:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802112:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802115:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802118:	89 c2                	mov    %eax,%edx
  80211a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80211f:	39 c2                	cmp    %eax,%edx
  802121:	73 07                	jae    80212a <smalloc+0x113>
			return NULL;}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	eb 4b                	jmp    802175 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80212a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80212f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802132:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802136:	ff 75 f0             	pushl  -0x10(%ebp)
  802139:	50                   	push   %eax
  80213a:	ff 75 0c             	pushl  0xc(%ebp)
  80213d:	ff 75 08             	pushl  0x8(%ebp)
  802140:	e8 cb 03 00 00       	call   802510 <sys_create_shared_object>
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80214b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80214f:	79 07                	jns    802158 <smalloc+0x141>
		return NULL;
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	eb 1d                	jmp    802175 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802158:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80215d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802160:	75 10                	jne    802172 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802162:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	01 d0                	add    %edx,%eax
  80216d:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802172:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80217d:	e8 d4 fa ff ff       	call   801c56 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802182:	83 ec 08             	sub    $0x8,%esp
  802185:	ff 75 0c             	pushl  0xc(%ebp)
  802188:	ff 75 08             	pushl  0x8(%ebp)
  80218b:	e8 aa 03 00 00       	call   80253a <sys_size_of_shared_object>
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802196:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219a:	7f 0a                	jg     8021a6 <sget+0x2f>
		return NULL;
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a1:	e9 32 01 00 00       	jmp    8022d8 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8021a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8021ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021af:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8021b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021bb:	74 0e                	je     8021cb <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8021c3:	05 00 10 00 00       	add    $0x1000,%eax
  8021c8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8021cb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	75 0a                	jne    8021de <sget+0x67>
		return NULL;
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	e9 fa 00 00 00       	jmp    8022d8 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8021de:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0f                	je     8021f6 <sget+0x7f>
  8021e7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021ed:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021f2:	39 c2                	cmp    %eax,%edx
  8021f4:	73 0a                	jae    802200 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8021f6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021fb:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802200:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802205:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80220a:	29 c2                	sub    %eax,%edx
  80220c:	89 d0                	mov    %edx,%eax
  80220e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802211:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802217:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80221c:	29 c2                	sub    %eax,%edx
  80221e:	89 d0                	mov    %edx,%eax
  802220:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802229:	77 13                	ja     80223e <sget+0xc7>
  80222b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80222e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802231:	77 0b                	ja     80223e <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802236:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802239:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80223c:	73 0a                	jae    802248 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
  802243:	e9 90 00 00 00       	jmp    8022d8 <sget+0x161>

	void *va = NULL;
  802248:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80224f:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802254:	83 f8 05             	cmp    $0x5,%eax
  802257:	75 11                	jne    80226a <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802259:	83 ec 0c             	sub    $0xc,%esp
  80225c:	ff 75 f4             	pushl  -0xc(%ebp)
  80225f:	e8 a3 f5 ff ff       	call   801807 <alloc_pages_custom_fit>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80226a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226e:	75 27                	jne    802297 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802270:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802277:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80227a:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802284:	39 c2                	cmp    %eax,%edx
  802286:	73 07                	jae    80228f <sget+0x118>
			return NULL;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
  80228d:	eb 49                	jmp    8022d8 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80228f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802294:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	ff 75 f0             	pushl  -0x10(%ebp)
  80229d:	ff 75 0c             	pushl  0xc(%ebp)
  8022a0:	ff 75 08             	pushl  0x8(%ebp)
  8022a3:	e8 af 02 00 00       	call   802557 <sys_get_shared_object>
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8022ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022b2:	79 07                	jns    8022bb <sget+0x144>
		return NULL;
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b9:	eb 1d                	jmp    8022d8 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8022bb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022c0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8022c3:	75 10                	jne    8022d5 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8022c5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	01 d0                	add    %edx,%eax
  8022d0:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8022e0:	e8 71 f9 ff ff       	call   801c56 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8022e5:	83 ec 04             	sub    $0x4,%esp
  8022e8:	68 54 44 80 00       	push   $0x804454
  8022ed:	68 19 02 00 00       	push   $0x219
  8022f2:	68 31 40 80 00       	push   $0x804031
  8022f7:	e8 42 e1 ff ff       	call   80043e <_panic>

008022fc <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802302:	83 ec 04             	sub    $0x4,%esp
  802305:	68 7c 44 80 00       	push   $0x80447c
  80230a:	68 2b 02 00 00       	push   $0x22b
  80230f:	68 31 40 80 00       	push   $0x804031
  802314:	e8 25 e1 ff ff       	call   80043e <_panic>

00802319 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	57                   	push   %edi
  80231d:	56                   	push   %esi
  80231e:	53                   	push   %ebx
  80231f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	8b 55 0c             	mov    0xc(%ebp),%edx
  802328:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80232e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802331:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802334:	cd 30                	int    $0x30
  802336:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802339:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80233c:	83 c4 10             	add    $0x10,%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 04             	sub    $0x4,%esp
  80234a:	8b 45 10             	mov    0x10(%ebp),%eax
  80234d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802350:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802353:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	6a 00                	push   $0x0
  80235c:	51                   	push   %ecx
  80235d:	52                   	push   %edx
  80235e:	ff 75 0c             	pushl  0xc(%ebp)
  802361:	50                   	push   %eax
  802362:	6a 00                	push   $0x0
  802364:	e8 b0 ff ff ff       	call   802319 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	90                   	nop
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_cgetc>:

int
sys_cgetc(void)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 02                	push   $0x2
  80237e:	e8 96 ff ff ff       	call   802319 <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 03                	push   $0x3
  802397:	e8 7d ff ff ff       	call   802319 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	90                   	nop
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 04                	push   $0x4
  8023b1:	e8 63 ff ff ff       	call   802319 <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
}
  8023b9:	90                   	nop
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	52                   	push   %edx
  8023cc:	50                   	push   %eax
  8023cd:	6a 08                	push   $0x8
  8023cf:	e8 45 ff ff ff       	call   802319 <syscall>
  8023d4:	83 c4 18             	add    $0x18,%esp
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	56                   	push   %esi
  8023dd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023de:	8b 75 18             	mov    0x18(%ebp),%esi
  8023e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	56                   	push   %esi
  8023ee:	53                   	push   %ebx
  8023ef:	51                   	push   %ecx
  8023f0:	52                   	push   %edx
  8023f1:	50                   	push   %eax
  8023f2:	6a 09                	push   $0x9
  8023f4:	e8 20 ff ff ff       	call   802319 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5d                   	pop    %ebp
  802402:	c3                   	ret    

00802403 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	ff 75 08             	pushl  0x8(%ebp)
  802411:	6a 0a                	push   $0xa
  802413:	e8 01 ff ff ff       	call   802319 <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	ff 75 0c             	pushl  0xc(%ebp)
  802429:	ff 75 08             	pushl  0x8(%ebp)
  80242c:	6a 0b                	push   $0xb
  80242e:	e8 e6 fe ff ff       	call   802319 <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 0c                	push   $0xc
  802447:	e8 cd fe ff ff       	call   802319 <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 0d                	push   $0xd
  802460:	e8 b4 fe ff ff       	call   802319 <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 0e                	push   $0xe
  802479:	e8 9b fe ff ff       	call   802319 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 0f                	push   $0xf
  802492:	e8 82 fe ff ff       	call   802319 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	ff 75 08             	pushl  0x8(%ebp)
  8024aa:	6a 10                	push   $0x10
  8024ac:	e8 68 fe ff ff       	call   802319 <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 11                	push   $0x11
  8024c5:	e8 4f fe ff ff       	call   802319 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
}
  8024cd:	90                   	nop
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 04             	sub    $0x4,%esp
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	50                   	push   %eax
  8024e9:	6a 01                	push   $0x1
  8024eb:	e8 29 fe ff ff       	call   802319 <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
}
  8024f3:	90                   	nop
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 14                	push   $0x14
  802505:	e8 0f fe ff ff       	call   802319 <syscall>
  80250a:	83 c4 18             	add    $0x18,%esp
}
  80250d:	90                   	nop
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 04             	sub    $0x4,%esp
  802516:	8b 45 10             	mov    0x10(%ebp),%eax
  802519:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80251c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80251f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	6a 00                	push   $0x0
  802528:	51                   	push   %ecx
  802529:	52                   	push   %edx
  80252a:	ff 75 0c             	pushl  0xc(%ebp)
  80252d:	50                   	push   %eax
  80252e:	6a 15                	push   $0x15
  802530:	e8 e4 fd ff ff       	call   802319 <syscall>
  802535:	83 c4 18             	add    $0x18,%esp
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80253d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	52                   	push   %edx
  80254a:	50                   	push   %eax
  80254b:	6a 16                	push   $0x16
  80254d:	e8 c7 fd ff ff       	call   802319 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80255a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80255d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	51                   	push   %ecx
  802568:	52                   	push   %edx
  802569:	50                   	push   %eax
  80256a:	6a 17                	push   $0x17
  80256c:	e8 a8 fd ff ff       	call   802319 <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257c:	8b 45 08             	mov    0x8(%ebp),%eax
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	52                   	push   %edx
  802586:	50                   	push   %eax
  802587:	6a 18                	push   $0x18
  802589:	e8 8b fd ff ff       	call   802319 <syscall>
  80258e:	83 c4 18             	add    $0x18,%esp
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	6a 00                	push   $0x0
  80259b:	ff 75 14             	pushl  0x14(%ebp)
  80259e:	ff 75 10             	pushl  0x10(%ebp)
  8025a1:	ff 75 0c             	pushl  0xc(%ebp)
  8025a4:	50                   	push   %eax
  8025a5:	6a 19                	push   $0x19
  8025a7:	e8 6d fd ff ff       	call   802319 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	50                   	push   %eax
  8025c0:	6a 1a                	push   $0x1a
  8025c2:	e8 52 fd ff ff       	call   802319 <syscall>
  8025c7:	83 c4 18             	add    $0x18,%esp
}
  8025ca:	90                   	nop
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	50                   	push   %eax
  8025dc:	6a 1b                	push   $0x1b
  8025de:	e8 36 fd ff ff       	call   802319 <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 05                	push   $0x5
  8025f7:	e8 1d fd ff ff       	call   802319 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 06                	push   $0x6
  802610:	e8 04 fd ff ff       	call   802319 <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 07                	push   $0x7
  802629:	e8 eb fc ff ff       	call   802319 <syscall>
  80262e:	83 c4 18             	add    $0x18,%esp
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_exit_env>:


void sys_exit_env(void)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 1c                	push   $0x1c
  802642:	e8 d2 fc ff ff       	call   802319 <syscall>
  802647:	83 c4 18             	add    $0x18,%esp
}
  80264a:	90                   	nop
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802653:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802656:	8d 50 04             	lea    0x4(%eax),%edx
  802659:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	52                   	push   %edx
  802663:	50                   	push   %eax
  802664:	6a 1d                	push   $0x1d
  802666:	e8 ae fc ff ff       	call   802319 <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
	return result;
  80266e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802671:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802674:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802677:	89 01                	mov    %eax,(%ecx)
  802679:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	c9                   	leave  
  802680:	c2 04 00             	ret    $0x4

00802683 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	ff 75 10             	pushl  0x10(%ebp)
  80268d:	ff 75 0c             	pushl  0xc(%ebp)
  802690:	ff 75 08             	pushl  0x8(%ebp)
  802693:	6a 13                	push   $0x13
  802695:	e8 7f fc ff ff       	call   802319 <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
	return ;
  80269d:	90                   	nop
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 1e                	push   $0x1e
  8026af:	e8 65 fc ff ff       	call   802319 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
}
  8026b7:	c9                   	leave  
  8026b8:	c3                   	ret    

008026b9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026c5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	50                   	push   %eax
  8026d2:	6a 1f                	push   $0x1f
  8026d4:	e8 40 fc ff ff       	call   802319 <syscall>
  8026d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026dc:	90                   	nop
}
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <rsttst>:
void rsttst()
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 21                	push   $0x21
  8026ee:	e8 26 fc ff ff       	call   802319 <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f6:	90                   	nop
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 04             	sub    $0x4,%esp
  8026ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802702:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802705:	8b 55 18             	mov    0x18(%ebp),%edx
  802708:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80270c:	52                   	push   %edx
  80270d:	50                   	push   %eax
  80270e:	ff 75 10             	pushl  0x10(%ebp)
  802711:	ff 75 0c             	pushl  0xc(%ebp)
  802714:	ff 75 08             	pushl  0x8(%ebp)
  802717:	6a 20                	push   $0x20
  802719:	e8 fb fb ff ff       	call   802319 <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
	return ;
  802721:	90                   	nop
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <chktst>:
void chktst(uint32 n)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	ff 75 08             	pushl  0x8(%ebp)
  802732:	6a 22                	push   $0x22
  802734:	e8 e0 fb ff ff       	call   802319 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
	return ;
  80273c:	90                   	nop
}
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <inctst>:

void inctst()
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 23                	push   $0x23
  80274e:	e8 c6 fb ff ff       	call   802319 <syscall>
  802753:	83 c4 18             	add    $0x18,%esp
	return ;
  802756:	90                   	nop
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <gettst>:
uint32 gettst()
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 24                	push   $0x24
  802768:	e8 ac fb ff ff       	call   802319 <syscall>
  80276d:	83 c4 18             	add    $0x18,%esp
}
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 25                	push   $0x25
  802781:	e8 93 fb ff ff       	call   802319 <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
  802789:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80278e:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	ff 75 08             	pushl  0x8(%ebp)
  8027ab:	6a 26                	push   $0x26
  8027ad:	e8 67 fb ff ff       	call   802319 <syscall>
  8027b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8027b5:	90                   	nop
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c8:	6a 00                	push   $0x0
  8027ca:	53                   	push   %ebx
  8027cb:	51                   	push   %ecx
  8027cc:	52                   	push   %edx
  8027cd:	50                   	push   %eax
  8027ce:	6a 27                	push   $0x27
  8027d0:	e8 44 fb ff ff       	call   802319 <syscall>
  8027d5:	83 c4 18             	add    $0x18,%esp
}
  8027d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	52                   	push   %edx
  8027ed:	50                   	push   %eax
  8027ee:	6a 28                	push   $0x28
  8027f0:	e8 24 fb ff ff       	call   802319 <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8027fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802800:	8b 55 0c             	mov    0xc(%ebp),%edx
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	6a 00                	push   $0x0
  802808:	51                   	push   %ecx
  802809:	ff 75 10             	pushl  0x10(%ebp)
  80280c:	52                   	push   %edx
  80280d:	50                   	push   %eax
  80280e:	6a 29                	push   $0x29
  802810:	e8 04 fb ff ff       	call   802319 <syscall>
  802815:	83 c4 18             	add    $0x18,%esp
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	ff 75 10             	pushl  0x10(%ebp)
  802824:	ff 75 0c             	pushl  0xc(%ebp)
  802827:	ff 75 08             	pushl  0x8(%ebp)
  80282a:	6a 12                	push   $0x12
  80282c:	e8 e8 fa ff ff       	call   802319 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
	return ;
  802834:	90                   	nop
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80283a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283d:	8b 45 08             	mov    0x8(%ebp),%eax
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	52                   	push   %edx
  802847:	50                   	push   %eax
  802848:	6a 2a                	push   $0x2a
  80284a:	e8 ca fa ff ff       	call   802319 <syscall>
  80284f:	83 c4 18             	add    $0x18,%esp
	return;
  802852:	90                   	nop
}
  802853:	c9                   	leave  
  802854:	c3                   	ret    

00802855 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 2b                	push   $0x2b
  802864:	e8 b0 fa ff ff       	call   802319 <syscall>
  802869:	83 c4 18             	add    $0x18,%esp
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	ff 75 0c             	pushl  0xc(%ebp)
  80287a:	ff 75 08             	pushl  0x8(%ebp)
  80287d:	6a 2d                	push   $0x2d
  80287f:	e8 95 fa ff ff       	call   802319 <syscall>
  802884:	83 c4 18             	add    $0x18,%esp
	return;
  802887:	90                   	nop
}
  802888:	c9                   	leave  
  802889:	c3                   	ret    

0080288a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	ff 75 0c             	pushl  0xc(%ebp)
  802896:	ff 75 08             	pushl  0x8(%ebp)
  802899:	6a 2c                	push   $0x2c
  80289b:	e8 79 fa ff ff       	call   802319 <syscall>
  8028a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a3:	90                   	nop
}
  8028a4:	c9                   	leave  
  8028a5:	c3                   	ret    

008028a6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8028a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	52                   	push   %edx
  8028b6:	50                   	push   %eax
  8028b7:	6a 2e                	push   $0x2e
  8028b9:	e8 5b fa ff ff       	call   802319 <syscall>
  8028be:	83 c4 18             	add    $0x18,%esp
	return ;
  8028c1:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8028c2:	c9                   	leave  
  8028c3:	c3                   	ret    

008028c4 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8028ca:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  8028d1:	72 09                	jb     8028dc <to_page_va+0x18>
  8028d3:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  8028da:	72 14                	jb     8028f0 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8028dc:	83 ec 04             	sub    $0x4,%esp
  8028df:	68 a0 44 80 00       	push   $0x8044a0
  8028e4:	6a 15                	push   $0x15
  8028e6:	68 cb 44 80 00       	push   $0x8044cb
  8028eb:	e8 4e db ff ff       	call   80043e <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	ba 60 50 80 00       	mov    $0x805060,%edx
  8028f8:	29 d0                	sub    %edx,%eax
  8028fa:	c1 f8 02             	sar    $0x2,%eax
  8028fd:	89 c2                	mov    %eax,%edx
  8028ff:	89 d0                	mov    %edx,%eax
  802901:	c1 e0 02             	shl    $0x2,%eax
  802904:	01 d0                	add    %edx,%eax
  802906:	c1 e0 02             	shl    $0x2,%eax
  802909:	01 d0                	add    %edx,%eax
  80290b:	c1 e0 02             	shl    $0x2,%eax
  80290e:	01 d0                	add    %edx,%eax
  802910:	89 c1                	mov    %eax,%ecx
  802912:	c1 e1 08             	shl    $0x8,%ecx
  802915:	01 c8                	add    %ecx,%eax
  802917:	89 c1                	mov    %eax,%ecx
  802919:	c1 e1 10             	shl    $0x10,%ecx
  80291c:	01 c8                	add    %ecx,%eax
  80291e:	01 c0                	add    %eax,%eax
  802920:	01 d0                	add    %edx,%eax
  802922:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	c1 e0 0c             	shl    $0xc,%eax
  80292b:	89 c2                	mov    %eax,%edx
  80292d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802932:	01 d0                	add    %edx,%eax
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    

00802936 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80293c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802941:	8b 55 08             	mov    0x8(%ebp),%edx
  802944:	29 c2                	sub    %eax,%edx
  802946:	89 d0                	mov    %edx,%eax
  802948:	c1 e8 0c             	shr    $0xc,%eax
  80294b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80294e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802952:	78 09                	js     80295d <to_page_info+0x27>
  802954:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80295b:	7e 14                	jle    802971 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 e4 44 80 00       	push   $0x8044e4
  802965:	6a 22                	push   $0x22
  802967:	68 cb 44 80 00       	push   $0x8044cb
  80296c:	e8 cd da ff ff       	call   80043e <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802971:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802974:	89 d0                	mov    %edx,%eax
  802976:	01 c0                	add    %eax,%eax
  802978:	01 d0                	add    %edx,%eax
  80297a:	c1 e0 02             	shl    $0x2,%eax
  80297d:	05 60 50 80 00       	add    $0x805060,%eax
}
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	05 00 00 00 02       	add    $0x2000000,%eax
  802992:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802995:	73 16                	jae    8029ad <initialize_dynamic_allocator+0x29>
  802997:	68 08 45 80 00       	push   $0x804508
  80299c:	68 2e 45 80 00       	push   $0x80452e
  8029a1:	6a 34                	push   $0x34
  8029a3:	68 cb 44 80 00       	push   $0x8044cb
  8029a8:	e8 91 da ff ff       	call   80043e <_panic>
		is_initialized = 1;
  8029ad:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  8029b4:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  8029bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c2:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  8029c7:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  8029ce:	00 00 00 
  8029d1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8029d8:	00 00 00 
  8029db:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8029e2:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8029e5:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8029ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029f3:	eb 36                	jmp    802a2b <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	c1 e0 04             	shl    $0x4,%eax
  8029fb:	05 80 d0 81 00       	add    $0x81d080,%eax
  802a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	c1 e0 04             	shl    $0x4,%eax
  802a0c:	05 84 d0 81 00       	add    $0x81d084,%eax
  802a11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	c1 e0 04             	shl    $0x4,%eax
  802a1d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802a22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802a28:	ff 45 f4             	incl   -0xc(%ebp)
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a31:	72 c2                	jb     8029f5 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802a33:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a39:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a3e:	29 c2                	sub    %eax,%edx
  802a40:	89 d0                	mov    %edx,%eax
  802a42:	c1 e8 0c             	shr    $0xc,%eax
  802a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a4f:	e9 c8 00 00 00       	jmp    802b1c <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a57:	89 d0                	mov    %edx,%eax
  802a59:	01 c0                	add    %eax,%eax
  802a5b:	01 d0                	add    %edx,%eax
  802a5d:	c1 e0 02             	shl    $0x2,%eax
  802a60:	05 68 50 80 00       	add    $0x805068,%eax
  802a65:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a6d:	89 d0                	mov    %edx,%eax
  802a6f:	01 c0                	add    %eax,%eax
  802a71:	01 d0                	add    %edx,%eax
  802a73:	c1 e0 02             	shl    $0x2,%eax
  802a76:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a7b:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802a80:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802a86:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a89:	89 c8                	mov    %ecx,%eax
  802a8b:	01 c0                	add    %eax,%eax
  802a8d:	01 c8                	add    %ecx,%eax
  802a8f:	c1 e0 02             	shl    $0x2,%eax
  802a92:	05 64 50 80 00       	add    $0x805064,%eax
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9c:	89 d0                	mov    %edx,%eax
  802a9e:	01 c0                	add    %eax,%eax
  802aa0:	01 d0                	add    %edx,%eax
  802aa2:	c1 e0 02             	shl    $0x2,%eax
  802aa5:	05 64 50 80 00       	add    $0x805064,%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 1b                	je     802acb <initialize_dynamic_allocator+0x147>
  802ab0:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802ab6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ab9:	89 c8                	mov    %ecx,%eax
  802abb:	01 c0                	add    %eax,%eax
  802abd:	01 c8                	add    %ecx,%eax
  802abf:	c1 e0 02             	shl    $0x2,%eax
  802ac2:	05 60 50 80 00       	add    $0x805060,%eax
  802ac7:	89 02                	mov    %eax,(%edx)
  802ac9:	eb 16                	jmp    802ae1 <initialize_dynamic_allocator+0x15d>
  802acb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ace:	89 d0                	mov    %edx,%eax
  802ad0:	01 c0                	add    %eax,%eax
  802ad2:	01 d0                	add    %edx,%eax
  802ad4:	c1 e0 02             	shl    $0x2,%eax
  802ad7:	05 60 50 80 00       	add    $0x805060,%eax
  802adc:	a3 48 50 80 00       	mov    %eax,0x805048
  802ae1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae4:	89 d0                	mov    %edx,%eax
  802ae6:	01 c0                	add    %eax,%eax
  802ae8:	01 d0                	add    %edx,%eax
  802aea:	c1 e0 02             	shl    $0x2,%eax
  802aed:	05 60 50 80 00       	add    $0x805060,%eax
  802af2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afa:	89 d0                	mov    %edx,%eax
  802afc:	01 c0                	add    %eax,%eax
  802afe:	01 d0                	add    %edx,%eax
  802b00:	c1 e0 02             	shl    $0x2,%eax
  802b03:	05 60 50 80 00       	add    $0x805060,%eax
  802b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0e:	a1 54 50 80 00       	mov    0x805054,%eax
  802b13:	40                   	inc    %eax
  802b14:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802b19:	ff 45 f0             	incl   -0x10(%ebp)
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b22:	0f 82 2c ff ff ff    	jb     802a54 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b2e:	eb 2f                	jmp    802b5f <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802b30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b33:	89 d0                	mov    %edx,%eax
  802b35:	01 c0                	add    %eax,%eax
  802b37:	01 d0                	add    %edx,%eax
  802b39:	c1 e0 02             	shl    $0x2,%eax
  802b3c:	05 68 50 80 00       	add    $0x805068,%eax
  802b41:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b49:	89 d0                	mov    %edx,%eax
  802b4b:	01 c0                	add    %eax,%eax
  802b4d:	01 d0                	add    %edx,%eax
  802b4f:	c1 e0 02             	shl    $0x2,%eax
  802b52:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b57:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b5c:	ff 45 ec             	incl   -0x14(%ebp)
  802b5f:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802b66:	76 c8                	jbe    802b30 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802b68:	90                   	nop
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802b71:	8b 55 08             	mov    0x8(%ebp),%edx
  802b74:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b79:	29 c2                	sub    %eax,%edx
  802b7b:	89 d0                	mov    %edx,%eax
  802b7d:	c1 e8 0c             	shr    $0xc,%eax
  802b80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802b83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b86:	89 d0                	mov    %edx,%eax
  802b88:	01 c0                	add    %eax,%eax
  802b8a:	01 d0                	add    %edx,%eax
  802b8c:	c1 e0 02             	shl    $0x2,%eax
  802b8f:	05 68 50 80 00       	add    $0x805068,%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802b99:	c9                   	leave  
  802b9a:	c3                   	ret    

00802b9b <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802b9b:	55                   	push   %ebp
  802b9c:	89 e5                	mov    %esp,%ebp
  802b9e:	83 ec 14             	sub    $0x14,%esp
  802ba1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802ba4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802ba8:	77 07                	ja     802bb1 <nearest_pow2_ceil.1513+0x16>
  802baa:	b8 01 00 00 00       	mov    $0x1,%eax
  802baf:	eb 20                	jmp    802bd1 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802bb1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802bb8:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802bbb:	eb 08                	jmp    802bc5 <nearest_pow2_ceil.1513+0x2a>
  802bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bc0:	01 c0                	add    %eax,%eax
  802bc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802bc5:	d1 6d 08             	shrl   0x8(%ebp)
  802bc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcc:	75 ef                	jne    802bbd <nearest_pow2_ceil.1513+0x22>
        return power;
  802bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
  802bd6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802bd9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802be0:	76 16                	jbe    802bf8 <alloc_block+0x25>
  802be2:	68 44 45 80 00       	push   $0x804544
  802be7:	68 2e 45 80 00       	push   $0x80452e
  802bec:	6a 72                	push   $0x72
  802bee:	68 cb 44 80 00       	push   $0x8044cb
  802bf3:	e8 46 d8 ff ff       	call   80043e <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802bf8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfc:	75 0a                	jne    802c08 <alloc_block+0x35>
  802bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  802c03:	e9 bd 04 00 00       	jmp    8030c5 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802c08:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c15:	73 06                	jae    802c1d <alloc_block+0x4a>
        size = min_block_size;
  802c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1a:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802c1d:	83 ec 0c             	sub    $0xc,%esp
  802c20:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c23:	ff 75 08             	pushl  0x8(%ebp)
  802c26:	89 c1                	mov    %eax,%ecx
  802c28:	e8 6e ff ff ff       	call   802b9b <nearest_pow2_ceil.1513>
  802c2d:	83 c4 10             	add    $0x10,%esp
  802c30:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802c33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c36:	83 ec 0c             	sub    $0xc,%esp
  802c39:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802c3c:	52                   	push   %edx
  802c3d:	89 c1                	mov    %eax,%ecx
  802c3f:	e8 83 04 00 00       	call   8030c7 <log2_ceil.1520>
  802c44:	83 c4 10             	add    $0x10,%esp
  802c47:	83 e8 03             	sub    $0x3,%eax
  802c4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c50:	c1 e0 04             	shl    $0x4,%eax
  802c53:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	0f 84 d8 00 00 00    	je     802d3a <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c65:	c1 e0 04             	shl    $0x4,%eax
  802c68:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802c72:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c76:	75 17                	jne    802c8f <alloc_block+0xbc>
  802c78:	83 ec 04             	sub    $0x4,%esp
  802c7b:	68 65 45 80 00       	push   $0x804565
  802c80:	68 98 00 00 00       	push   $0x98
  802c85:	68 cb 44 80 00       	push   $0x8044cb
  802c8a:	e8 af d7 ff ff       	call   80043e <_panic>
  802c8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	74 10                	je     802ca8 <alloc_block+0xd5>
  802c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ca0:	8b 52 04             	mov    0x4(%edx),%edx
  802ca3:	89 50 04             	mov    %edx,0x4(%eax)
  802ca6:	eb 14                	jmp    802cbc <alloc_block+0xe9>
  802ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb1:	c1 e2 04             	shl    $0x4,%edx
  802cb4:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802cba:	89 02                	mov    %eax,(%edx)
  802cbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0f                	je     802cd5 <alloc_block+0x102>
  802cc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ccf:	8b 12                	mov    (%edx),%edx
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	eb 13                	jmp    802ce8 <alloc_block+0x115>
  802cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cdd:	c1 e2 04             	shl    $0x4,%edx
  802ce0:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ce6:	89 02                	mov    %eax,(%edx)
  802ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ceb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfe:	c1 e0 04             	shl    $0x4,%eax
  802d01:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	8d 50 ff             	lea    -0x1(%eax),%edx
  802d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0e:	c1 e0 04             	shl    $0x4,%eax
  802d11:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d16:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1b:	83 ec 0c             	sub    $0xc,%esp
  802d1e:	50                   	push   %eax
  802d1f:	e8 12 fc ff ff       	call   802936 <to_page_info>
  802d24:	83 c4 10             	add    $0x10,%esp
  802d27:	89 c2                	mov    %eax,%edx
  802d29:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802d2d:	48                   	dec    %eax
  802d2e:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d35:	e9 8b 03 00 00       	jmp    8030c5 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802d3a:	a1 48 50 80 00       	mov    0x805048,%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	0f 84 64 02 00 00    	je     802fab <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d47:	a1 48 50 80 00       	mov    0x805048,%eax
  802d4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d53:	75 17                	jne    802d6c <alloc_block+0x199>
  802d55:	83 ec 04             	sub    $0x4,%esp
  802d58:	68 65 45 80 00       	push   $0x804565
  802d5d:	68 a0 00 00 00       	push   $0xa0
  802d62:	68 cb 44 80 00       	push   $0x8044cb
  802d67:	e8 d2 d6 ff ff       	call   80043e <_panic>
  802d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 10                	je     802d85 <alloc_block+0x1b2>
  802d75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d7d:	8b 52 04             	mov    0x4(%edx),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	eb 0b                	jmp    802d90 <alloc_block+0x1bd>
  802d85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802d90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0f                	je     802da9 <alloc_block+0x1d6>
  802d9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da3:	8b 12                	mov    (%edx),%edx
  802da5:	89 10                	mov    %edx,(%eax)
  802da7:	eb 0a                	jmp    802db3 <alloc_block+0x1e0>
  802da9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	a3 48 50 80 00       	mov    %eax,0x805048
  802db3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc6:	a1 54 50 80 00       	mov    0x805054,%eax
  802dcb:	48                   	dec    %eax
  802dcc:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd7:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802ddb:	b8 00 10 00 00       	mov    $0x1000,%eax
  802de0:	99                   	cltd   
  802de1:	f7 7d e8             	idivl  -0x18(%ebp)
  802de4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802de7:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802deb:	83 ec 0c             	sub    $0xc,%esp
  802dee:	ff 75 dc             	pushl  -0x24(%ebp)
  802df1:	e8 ce fa ff ff       	call   8028c4 <to_page_va>
  802df6:	83 c4 10             	add    $0x10,%esp
  802df9:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802dfc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dff:	83 ec 0c             	sub    $0xc,%esp
  802e02:	50                   	push   %eax
  802e03:	e8 c0 ee ff ff       	call   801cc8 <get_page>
  802e08:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e12:	e9 aa 00 00 00       	jmp    802ec1 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802e1e:	89 c2                	mov    %eax,%edx
  802e20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e23:	01 d0                	add    %edx,%eax
  802e25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802e28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e2c:	75 17                	jne    802e45 <alloc_block+0x272>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 84 45 80 00       	push   $0x804584
  802e36:	68 aa 00 00 00       	push   $0xaa
  802e3b:	68 cb 44 80 00       	push   $0x8044cb
  802e40:	e8 f9 d5 ff ff       	call   80043e <_panic>
  802e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e48:	c1 e0 04             	shl    $0x4,%eax
  802e4b:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e50:	8b 10                	mov    (%eax),%edx
  802e52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e55:	89 50 04             	mov    %edx,0x4(%eax)
  802e58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e5b:	8b 40 04             	mov    0x4(%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 14                	je     802e76 <alloc_block+0x2a3>
  802e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e65:	c1 e0 04             	shl    $0x4,%eax
  802e68:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e72:	89 10                	mov    %edx,(%eax)
  802e74:	eb 11                	jmp    802e87 <alloc_block+0x2b4>
  802e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e79:	c1 e0 04             	shl    $0x4,%eax
  802e7c:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802e82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e85:	89 02                	mov    %eax,(%edx)
  802e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8a:	c1 e0 04             	shl    $0x4,%eax
  802e8d:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802e93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e96:	89 02                	mov    %eax,(%edx)
  802e98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea4:	c1 e0 04             	shl    $0x4,%eax
  802ea7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	8d 50 01             	lea    0x1(%eax),%edx
  802eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb4:	c1 e0 04             	shl    $0x4,%eax
  802eb7:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ebc:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802ebe:	ff 45 f4             	incl   -0xc(%ebp)
  802ec1:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ec6:	99                   	cltd   
  802ec7:	f7 7d e8             	idivl  -0x18(%ebp)
  802eca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ecd:	0f 8f 44 ff ff ff    	jg     802e17 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ed3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed6:	c1 e0 04             	shl    $0x4,%eax
  802ed9:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802ee3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802ee7:	75 17                	jne    802f00 <alloc_block+0x32d>
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	68 65 45 80 00       	push   $0x804565
  802ef1:	68 ae 00 00 00       	push   $0xae
  802ef6:	68 cb 44 80 00       	push   $0x8044cb
  802efb:	e8 3e d5 ff ff       	call   80043e <_panic>
  802f00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f03:	8b 00                	mov    (%eax),%eax
  802f05:	85 c0                	test   %eax,%eax
  802f07:	74 10                	je     802f19 <alloc_block+0x346>
  802f09:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f11:	8b 52 04             	mov    0x4(%edx),%edx
  802f14:	89 50 04             	mov    %edx,0x4(%eax)
  802f17:	eb 14                	jmp    802f2d <alloc_block+0x35a>
  802f19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f1c:	8b 40 04             	mov    0x4(%eax),%eax
  802f1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f22:	c1 e2 04             	shl    $0x4,%edx
  802f25:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f2b:	89 02                	mov    %eax,(%edx)
  802f2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	74 0f                	je     802f46 <alloc_block+0x373>
  802f37:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f3a:	8b 40 04             	mov    0x4(%eax),%eax
  802f3d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f40:	8b 12                	mov    (%edx),%edx
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	eb 13                	jmp    802f59 <alloc_block+0x386>
  802f46:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f4e:	c1 e2 04             	shl    $0x4,%edx
  802f51:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f57:	89 02                	mov    %eax,(%edx)
  802f59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6f:	c1 e0 04             	shl    $0x4,%eax
  802f72:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7f:	c1 e0 04             	shl    $0x4,%eax
  802f82:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f87:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802f89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f8c:	83 ec 0c             	sub    $0xc,%esp
  802f8f:	50                   	push   %eax
  802f90:	e8 a1 f9 ff ff       	call   802936 <to_page_info>
  802f95:	83 c4 10             	add    $0x10,%esp
  802f98:	89 c2                	mov    %eax,%edx
  802f9a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f9e:	48                   	dec    %eax
  802f9f:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802fa3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fa6:	e9 1a 01 00 00       	jmp    8030c5 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fae:	40                   	inc    %eax
  802faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802fb2:	e9 ed 00 00 00       	jmp    8030a4 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fba:	c1 e0 04             	shl    $0x4,%eax
  802fbd:	05 80 d0 81 00       	add    $0x81d080,%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	0f 84 d5 00 00 00    	je     8030a1 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	c1 e0 04             	shl    $0x4,%eax
  802fd2:	05 80 d0 81 00       	add    $0x81d080,%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802fdc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fe0:	75 17                	jne    802ff9 <alloc_block+0x426>
  802fe2:	83 ec 04             	sub    $0x4,%esp
  802fe5:	68 65 45 80 00       	push   $0x804565
  802fea:	68 b8 00 00 00       	push   $0xb8
  802fef:	68 cb 44 80 00       	push   $0x8044cb
  802ff4:	e8 45 d4 ff ff       	call   80043e <_panic>
  802ff9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	74 10                	je     803012 <alloc_block+0x43f>
  803002:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80300a:	8b 52 04             	mov    0x4(%edx),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	eb 14                	jmp    803026 <alloc_block+0x453>
  803012:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80301b:	c1 e2 04             	shl    $0x4,%edx
  80301e:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803024:	89 02                	mov    %eax,(%edx)
  803026:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803029:	8b 40 04             	mov    0x4(%eax),%eax
  80302c:	85 c0                	test   %eax,%eax
  80302e:	74 0f                	je     80303f <alloc_block+0x46c>
  803030:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803039:	8b 12                	mov    (%edx),%edx
  80303b:	89 10                	mov    %edx,(%eax)
  80303d:	eb 13                	jmp    803052 <alloc_block+0x47f>
  80303f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803047:	c1 e2 04             	shl    $0x4,%edx
  80304a:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803050:	89 02                	mov    %eax,(%edx)
  803052:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	c1 e0 04             	shl    $0x4,%eax
  80306b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	8d 50 ff             	lea    -0x1(%eax),%edx
  803075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803078:	c1 e0 04             	shl    $0x4,%eax
  80307b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803080:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803082:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803085:	83 ec 0c             	sub    $0xc,%esp
  803088:	50                   	push   %eax
  803089:	e8 a8 f8 ff ff       	call   802936 <to_page_info>
  80308e:	83 c4 10             	add    $0x10,%esp
  803091:	89 c2                	mov    %eax,%edx
  803093:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803097:	48                   	dec    %eax
  803098:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80309c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309f:	eb 24                	jmp    8030c5 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8030a1:	ff 45 f0             	incl   -0x10(%ebp)
  8030a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8030a8:	0f 8e 09 ff ff ff    	jle    802fb7 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 a7 45 80 00       	push   $0x8045a7
  8030b6:	68 bf 00 00 00       	push   $0xbf
  8030bb:	68 cb 44 80 00       	push   $0x8044cb
  8030c0:	e8 79 d3 ff ff       	call   80043e <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8030c5:	c9                   	leave  
  8030c6:	c3                   	ret    

008030c7 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8030c7:	55                   	push   %ebp
  8030c8:	89 e5                	mov    %esp,%ebp
  8030ca:	83 ec 14             	sub    $0x14,%esp
  8030cd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8030d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d4:	75 07                	jne    8030dd <log2_ceil.1520+0x16>
  8030d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030db:	eb 1b                	jmp    8030f8 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8030dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8030e4:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8030e7:	eb 06                	jmp    8030ef <log2_ceil.1520+0x28>
            x >>= 1;
  8030e9:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8030ec:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8030ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f3:	75 f4                	jne    8030e9 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8030f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8030f8:	c9                   	leave  
  8030f9:	c3                   	ret    

008030fa <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8030fa:	55                   	push   %ebp
  8030fb:	89 e5                	mov    %esp,%ebp
  8030fd:	83 ec 14             	sub    $0x14,%esp
  803100:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803103:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803107:	75 07                	jne    803110 <log2_ceil.1547+0x16>
  803109:	b8 00 00 00 00       	mov    $0x0,%eax
  80310e:	eb 1b                	jmp    80312b <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803117:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80311a:	eb 06                	jmp    803122 <log2_ceil.1547+0x28>
			x >>= 1;
  80311c:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80311f:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803126:	75 f4                	jne    80311c <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803128:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80312b:	c9                   	leave  
  80312c:	c3                   	ret    

0080312d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80312d:	55                   	push   %ebp
  80312e:	89 e5                	mov    %esp,%ebp
  803130:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803133:	8b 55 08             	mov    0x8(%ebp),%edx
  803136:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80313b:	39 c2                	cmp    %eax,%edx
  80313d:	72 0c                	jb     80314b <free_block+0x1e>
  80313f:	8b 55 08             	mov    0x8(%ebp),%edx
  803142:	a1 40 50 80 00       	mov    0x805040,%eax
  803147:	39 c2                	cmp    %eax,%edx
  803149:	72 19                	jb     803164 <free_block+0x37>
  80314b:	68 ac 45 80 00       	push   $0x8045ac
  803150:	68 2e 45 80 00       	push   $0x80452e
  803155:	68 d0 00 00 00       	push   $0xd0
  80315a:	68 cb 44 80 00       	push   $0x8044cb
  80315f:	e8 da d2 ff ff       	call   80043e <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803164:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803168:	0f 84 42 03 00 00    	je     8034b0 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  80316e:	8b 55 08             	mov    0x8(%ebp),%edx
  803171:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803176:	39 c2                	cmp    %eax,%edx
  803178:	72 0c                	jb     803186 <free_block+0x59>
  80317a:	8b 55 08             	mov    0x8(%ebp),%edx
  80317d:	a1 40 50 80 00       	mov    0x805040,%eax
  803182:	39 c2                	cmp    %eax,%edx
  803184:	72 17                	jb     80319d <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 e4 45 80 00       	push   $0x8045e4
  80318e:	68 e6 00 00 00       	push   $0xe6
  803193:	68 cb 44 80 00       	push   $0x8044cb
  803198:	e8 a1 d2 ff ff       	call   80043e <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80319d:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a0:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8031a5:	29 c2                	sub    %eax,%edx
  8031a7:	89 d0                	mov    %edx,%eax
  8031a9:	83 e0 07             	and    $0x7,%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	74 17                	je     8031c7 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8031b0:	83 ec 04             	sub    $0x4,%esp
  8031b3:	68 18 46 80 00       	push   $0x804618
  8031b8:	68 ea 00 00 00       	push   $0xea
  8031bd:	68 cb 44 80 00       	push   $0x8044cb
  8031c2:	e8 77 d2 ff ff       	call   80043e <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	83 ec 0c             	sub    $0xc,%esp
  8031cd:	50                   	push   %eax
  8031ce:	e8 63 f7 ff ff       	call   802936 <to_page_info>
  8031d3:	83 c4 10             	add    $0x10,%esp
  8031d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8031d9:	83 ec 0c             	sub    $0xc,%esp
  8031dc:	ff 75 08             	pushl  0x8(%ebp)
  8031df:	e8 87 f9 ff ff       	call   802b6b <get_block_size>
  8031e4:	83 c4 10             	add    $0x10,%esp
  8031e7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8031ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ee:	75 17                	jne    803207 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	68 44 46 80 00       	push   $0x804644
  8031f8:	68 f1 00 00 00       	push   $0xf1
  8031fd:	68 cb 44 80 00       	push   $0x8044cb
  803202:	e8 37 d2 ff ff       	call   80043e <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803207:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320a:	83 ec 0c             	sub    $0xc,%esp
  80320d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803210:	52                   	push   %edx
  803211:	89 c1                	mov    %eax,%ecx
  803213:	e8 e2 fe ff ff       	call   8030fa <log2_ceil.1547>
  803218:	83 c4 10             	add    $0x10,%esp
  80321b:	83 e8 03             	sub    $0x3,%eax
  80321e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803227:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80322b:	75 17                	jne    803244 <free_block+0x117>
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	68 90 46 80 00       	push   $0x804690
  803235:	68 f6 00 00 00       	push   $0xf6
  80323a:	68 cb 44 80 00       	push   $0x8044cb
  80323f:	e8 fa d1 ff ff       	call   80043e <_panic>
  803244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803247:	c1 e0 04             	shl    $0x4,%eax
  80324a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80324f:	8b 10                	mov    (%eax),%edx
  803251:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803254:	89 10                	mov    %edx,(%eax)
  803256:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 15                	je     803274 <free_block+0x147>
  80325f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803262:	c1 e0 04             	shl    $0x4,%eax
  803265:	05 80 d0 81 00       	add    $0x81d080,%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	eb 11                	jmp    803285 <free_block+0x158>
  803274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803277:	c1 e0 04             	shl    $0x4,%eax
  80327a:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803283:	89 02                	mov    %eax,(%edx)
  803285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803288:	c1 e0 04             	shl    $0x4,%eax
  80328b:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803294:	89 02                	mov    %eax,(%edx)
  803296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a3:	c1 e0 04             	shl    $0x4,%eax
  8032a6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	8d 50 01             	lea    0x1(%eax),%edx
  8032b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b3:	c1 e0 04             	shl    $0x4,%eax
  8032b6:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032bb:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8032bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032c4:	40                   	inc    %eax
  8032c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c8:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8032cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cf:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8032d4:	29 c2                	sub    %eax,%edx
  8032d6:	89 d0                	mov    %edx,%eax
  8032d8:	c1 e8 0c             	shr    $0xc,%eax
  8032db:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8032de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032e5:	0f b7 c8             	movzwl %ax,%ecx
  8032e8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032ed:	99                   	cltd   
  8032ee:	f7 7d e8             	idivl  -0x18(%ebp)
  8032f1:	39 c1                	cmp    %eax,%ecx
  8032f3:	0f 85 b8 01 00 00    	jne    8034b1 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8032f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803303:	c1 e0 04             	shl    $0x4,%eax
  803306:	05 80 d0 81 00       	add    $0x81d080,%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803310:	e9 d5 00 00 00       	jmp    8033ea <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80331d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803320:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803325:	29 c2                	sub    %eax,%edx
  803327:	89 d0                	mov    %edx,%eax
  803329:	c1 e8 0c             	shr    $0xc,%eax
  80332c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80332f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803332:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803335:	0f 85 a9 00 00 00    	jne    8033e4 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80333b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333f:	75 17                	jne    803358 <free_block+0x22b>
  803341:	83 ec 04             	sub    $0x4,%esp
  803344:	68 65 45 80 00       	push   $0x804565
  803349:	68 04 01 00 00       	push   $0x104
  80334e:	68 cb 44 80 00       	push   $0x8044cb
  803353:	e8 e6 d0 ff ff       	call   80043e <_panic>
  803358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	74 10                	je     803371 <free_block+0x244>
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803369:	8b 52 04             	mov    0x4(%edx),%edx
  80336c:	89 50 04             	mov    %edx,0x4(%eax)
  80336f:	eb 14                	jmp    803385 <free_block+0x258>
  803371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803374:	8b 40 04             	mov    0x4(%eax),%eax
  803377:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80337a:	c1 e2 04             	shl    $0x4,%edx
  80337d:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803383:	89 02                	mov    %eax,(%edx)
  803385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 0f                	je     80339e <free_block+0x271>
  80338f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803392:	8b 40 04             	mov    0x4(%eax),%eax
  803395:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803398:	8b 12                	mov    (%edx),%edx
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	eb 13                	jmp    8033b1 <free_block+0x284>
  80339e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a6:	c1 e2 04             	shl    $0x4,%edx
  8033a9:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8033af:	89 02                	mov    %eax,(%edx)
  8033b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c7:	c1 e0 04             	shl    $0x4,%eax
  8033ca:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d7:	c1 e0 04             	shl    $0x4,%eax
  8033da:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033df:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8033e1:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8033e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8033ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ee:	0f 85 21 ff ff ff    	jne    803315 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8033f4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033f9:	99                   	cltd   
  8033fa:	f7 7d e8             	idivl  -0x18(%ebp)
  8033fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803400:	74 17                	je     803419 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803402:	83 ec 04             	sub    $0x4,%esp
  803405:	68 b4 46 80 00       	push   $0x8046b4
  80340a:	68 0c 01 00 00       	push   $0x10c
  80340f:	68 cb 44 80 00       	push   $0x8044cb
  803414:	e8 25 d0 ff ff       	call   80043e <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803425:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80342b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80342f:	75 17                	jne    803448 <free_block+0x31b>
  803431:	83 ec 04             	sub    $0x4,%esp
  803434:	68 84 45 80 00       	push   $0x804584
  803439:	68 11 01 00 00       	push   $0x111
  80343e:	68 cb 44 80 00       	push   $0x8044cb
  803443:	e8 f6 cf ff ff       	call   80043e <_panic>
  803448:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80344e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803451:	89 50 04             	mov    %edx,0x4(%eax)
  803454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803457:	8b 40 04             	mov    0x4(%eax),%eax
  80345a:	85 c0                	test   %eax,%eax
  80345c:	74 0c                	je     80346a <free_block+0x33d>
  80345e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803463:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803466:	89 10                	mov    %edx,(%eax)
  803468:	eb 08                	jmp    803472 <free_block+0x345>
  80346a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346d:	a3 48 50 80 00       	mov    %eax,0x805048
  803472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803475:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80347a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803483:	a1 54 50 80 00       	mov    0x805054,%eax
  803488:	40                   	inc    %eax
  803489:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80348e:	83 ec 0c             	sub    $0xc,%esp
  803491:	ff 75 ec             	pushl  -0x14(%ebp)
  803494:	e8 2b f4 ff ff       	call   8028c4 <to_page_va>
  803499:	83 c4 10             	add    $0x10,%esp
  80349c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80349f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034a2:	83 ec 0c             	sub    $0xc,%esp
  8034a5:	50                   	push   %eax
  8034a6:	e8 69 e8 ff ff       	call   801d14 <return_page>
  8034ab:	83 c4 10             	add    $0x10,%esp
  8034ae:	eb 01                	jmp    8034b1 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034b0:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8034b1:	c9                   	leave  
  8034b2:	c3                   	ret    

008034b3 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8034b3:	55                   	push   %ebp
  8034b4:	89 e5                	mov    %esp,%ebp
  8034b6:	83 ec 14             	sub    $0x14,%esp
  8034b9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8034bc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8034c0:	77 07                	ja     8034c9 <nearest_pow2_ceil.1572+0x16>
      return 1;
  8034c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c7:	eb 20                	jmp    8034e9 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8034c9:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8034d0:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8034d3:	eb 08                	jmp    8034dd <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8034d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034d8:	01 c0                	add    %eax,%eax
  8034da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8034dd:	d1 6d 08             	shrl   0x8(%ebp)
  8034e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e4:	75 ef                	jne    8034d5 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8034e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8034e9:	c9                   	leave  
  8034ea:	c3                   	ret    

008034eb <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8034eb:	55                   	push   %ebp
  8034ec:	89 e5                	mov    %esp,%ebp
  8034ee:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8034f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f5:	75 13                	jne    80350a <realloc_block+0x1f>
    return alloc_block(new_size);
  8034f7:	83 ec 0c             	sub    $0xc,%esp
  8034fa:	ff 75 0c             	pushl  0xc(%ebp)
  8034fd:	e8 d1 f6 ff ff       	call   802bd3 <alloc_block>
  803502:	83 c4 10             	add    $0x10,%esp
  803505:	e9 d9 00 00 00       	jmp    8035e3 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80350a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80350e:	75 18                	jne    803528 <realloc_block+0x3d>
    free_block(va);
  803510:	83 ec 0c             	sub    $0xc,%esp
  803513:	ff 75 08             	pushl  0x8(%ebp)
  803516:	e8 12 fc ff ff       	call   80312d <free_block>
  80351b:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80351e:	b8 00 00 00 00       	mov    $0x0,%eax
  803523:	e9 bb 00 00 00       	jmp    8035e3 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803528:	83 ec 0c             	sub    $0xc,%esp
  80352b:	ff 75 08             	pushl  0x8(%ebp)
  80352e:	e8 38 f6 ff ff       	call   802b6b <get_block_size>
  803533:	83 c4 10             	add    $0x10,%esp
  803536:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803539:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803540:	8b 45 0c             	mov    0xc(%ebp),%eax
  803543:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803546:	73 06                	jae    80354e <realloc_block+0x63>
    new_size = min_block_size;
  803548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354b:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80354e:	83 ec 0c             	sub    $0xc,%esp
  803551:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803554:	ff 75 0c             	pushl  0xc(%ebp)
  803557:	89 c1                	mov    %eax,%ecx
  803559:	e8 55 ff ff ff       	call   8034b3 <nearest_pow2_ceil.1572>
  80355e:	83 c4 10             	add    $0x10,%esp
  803561:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803564:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803567:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80356a:	75 05                	jne    803571 <realloc_block+0x86>
    return va;
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	eb 72                	jmp    8035e3 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803571:	83 ec 0c             	sub    $0xc,%esp
  803574:	ff 75 0c             	pushl  0xc(%ebp)
  803577:	e8 57 f6 ff ff       	call   802bd3 <alloc_block>
  80357c:	83 c4 10             	add    $0x10,%esp
  80357f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803586:	75 07                	jne    80358f <realloc_block+0xa4>
    return NULL;
  803588:	b8 00 00 00 00       	mov    $0x0,%eax
  80358d:	eb 54                	jmp    8035e3 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80358f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803592:	8b 45 0c             	mov    0xc(%ebp),%eax
  803595:	39 d0                	cmp    %edx,%eax
  803597:	76 02                	jbe    80359b <realloc_block+0xb0>
  803599:	89 d0                	mov    %edx,%eax
  80359b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8035a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8035aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035b1:	eb 17                	jmp    8035ca <realloc_block+0xdf>
    dst[i] = src[i];
  8035b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b9:	01 c2                	add    %eax,%edx
  8035bb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	01 c8                	add    %ecx,%eax
  8035c3:	8a 00                	mov    (%eax),%al
  8035c5:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8035c7:	ff 45 f4             	incl   -0xc(%ebp)
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035d0:	72 e1                	jb     8035b3 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8035d2:	83 ec 0c             	sub    $0xc,%esp
  8035d5:	ff 75 08             	pushl  0x8(%ebp)
  8035d8:	e8 50 fb ff ff       	call   80312d <free_block>
  8035dd:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8035e3:	c9                   	leave  
  8035e4:	c3                   	ret    
  8035e5:	66 90                	xchg   %ax,%ax
  8035e7:	90                   	nop

008035e8 <__udivdi3>:
  8035e8:	55                   	push   %ebp
  8035e9:	57                   	push   %edi
  8035ea:	56                   	push   %esi
  8035eb:	53                   	push   %ebx
  8035ec:	83 ec 1c             	sub    $0x1c,%esp
  8035ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035ff:	89 ca                	mov    %ecx,%edx
  803601:	89 f8                	mov    %edi,%eax
  803603:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803607:	85 f6                	test   %esi,%esi
  803609:	75 2d                	jne    803638 <__udivdi3+0x50>
  80360b:	39 cf                	cmp    %ecx,%edi
  80360d:	77 65                	ja     803674 <__udivdi3+0x8c>
  80360f:	89 fd                	mov    %edi,%ebp
  803611:	85 ff                	test   %edi,%edi
  803613:	75 0b                	jne    803620 <__udivdi3+0x38>
  803615:	b8 01 00 00 00       	mov    $0x1,%eax
  80361a:	31 d2                	xor    %edx,%edx
  80361c:	f7 f7                	div    %edi
  80361e:	89 c5                	mov    %eax,%ebp
  803620:	31 d2                	xor    %edx,%edx
  803622:	89 c8                	mov    %ecx,%eax
  803624:	f7 f5                	div    %ebp
  803626:	89 c1                	mov    %eax,%ecx
  803628:	89 d8                	mov    %ebx,%eax
  80362a:	f7 f5                	div    %ebp
  80362c:	89 cf                	mov    %ecx,%edi
  80362e:	89 fa                	mov    %edi,%edx
  803630:	83 c4 1c             	add    $0x1c,%esp
  803633:	5b                   	pop    %ebx
  803634:	5e                   	pop    %esi
  803635:	5f                   	pop    %edi
  803636:	5d                   	pop    %ebp
  803637:	c3                   	ret    
  803638:	39 ce                	cmp    %ecx,%esi
  80363a:	77 28                	ja     803664 <__udivdi3+0x7c>
  80363c:	0f bd fe             	bsr    %esi,%edi
  80363f:	83 f7 1f             	xor    $0x1f,%edi
  803642:	75 40                	jne    803684 <__udivdi3+0x9c>
  803644:	39 ce                	cmp    %ecx,%esi
  803646:	72 0a                	jb     803652 <__udivdi3+0x6a>
  803648:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80364c:	0f 87 9e 00 00 00    	ja     8036f0 <__udivdi3+0x108>
  803652:	b8 01 00 00 00       	mov    $0x1,%eax
  803657:	89 fa                	mov    %edi,%edx
  803659:	83 c4 1c             	add    $0x1c,%esp
  80365c:	5b                   	pop    %ebx
  80365d:	5e                   	pop    %esi
  80365e:	5f                   	pop    %edi
  80365f:	5d                   	pop    %ebp
  803660:	c3                   	ret    
  803661:	8d 76 00             	lea    0x0(%esi),%esi
  803664:	31 ff                	xor    %edi,%edi
  803666:	31 c0                	xor    %eax,%eax
  803668:	89 fa                	mov    %edi,%edx
  80366a:	83 c4 1c             	add    $0x1c,%esp
  80366d:	5b                   	pop    %ebx
  80366e:	5e                   	pop    %esi
  80366f:	5f                   	pop    %edi
  803670:	5d                   	pop    %ebp
  803671:	c3                   	ret    
  803672:	66 90                	xchg   %ax,%ax
  803674:	89 d8                	mov    %ebx,%eax
  803676:	f7 f7                	div    %edi
  803678:	31 ff                	xor    %edi,%edi
  80367a:	89 fa                	mov    %edi,%edx
  80367c:	83 c4 1c             	add    $0x1c,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    
  803684:	bd 20 00 00 00       	mov    $0x20,%ebp
  803689:	89 eb                	mov    %ebp,%ebx
  80368b:	29 fb                	sub    %edi,%ebx
  80368d:	89 f9                	mov    %edi,%ecx
  80368f:	d3 e6                	shl    %cl,%esi
  803691:	89 c5                	mov    %eax,%ebp
  803693:	88 d9                	mov    %bl,%cl
  803695:	d3 ed                	shr    %cl,%ebp
  803697:	89 e9                	mov    %ebp,%ecx
  803699:	09 f1                	or     %esi,%ecx
  80369b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80369f:	89 f9                	mov    %edi,%ecx
  8036a1:	d3 e0                	shl    %cl,%eax
  8036a3:	89 c5                	mov    %eax,%ebp
  8036a5:	89 d6                	mov    %edx,%esi
  8036a7:	88 d9                	mov    %bl,%cl
  8036a9:	d3 ee                	shr    %cl,%esi
  8036ab:	89 f9                	mov    %edi,%ecx
  8036ad:	d3 e2                	shl    %cl,%edx
  8036af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036b3:	88 d9                	mov    %bl,%cl
  8036b5:	d3 e8                	shr    %cl,%eax
  8036b7:	09 c2                	or     %eax,%edx
  8036b9:	89 d0                	mov    %edx,%eax
  8036bb:	89 f2                	mov    %esi,%edx
  8036bd:	f7 74 24 0c          	divl   0xc(%esp)
  8036c1:	89 d6                	mov    %edx,%esi
  8036c3:	89 c3                	mov    %eax,%ebx
  8036c5:	f7 e5                	mul    %ebp
  8036c7:	39 d6                	cmp    %edx,%esi
  8036c9:	72 19                	jb     8036e4 <__udivdi3+0xfc>
  8036cb:	74 0b                	je     8036d8 <__udivdi3+0xf0>
  8036cd:	89 d8                	mov    %ebx,%eax
  8036cf:	31 ff                	xor    %edi,%edi
  8036d1:	e9 58 ff ff ff       	jmp    80362e <__udivdi3+0x46>
  8036d6:	66 90                	xchg   %ax,%ax
  8036d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036dc:	89 f9                	mov    %edi,%ecx
  8036de:	d3 e2                	shl    %cl,%edx
  8036e0:	39 c2                	cmp    %eax,%edx
  8036e2:	73 e9                	jae    8036cd <__udivdi3+0xe5>
  8036e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036e7:	31 ff                	xor    %edi,%edi
  8036e9:	e9 40 ff ff ff       	jmp    80362e <__udivdi3+0x46>
  8036ee:	66 90                	xchg   %ax,%ax
  8036f0:	31 c0                	xor    %eax,%eax
  8036f2:	e9 37 ff ff ff       	jmp    80362e <__udivdi3+0x46>
  8036f7:	90                   	nop

008036f8 <__umoddi3>:
  8036f8:	55                   	push   %ebp
  8036f9:	57                   	push   %edi
  8036fa:	56                   	push   %esi
  8036fb:	53                   	push   %ebx
  8036fc:	83 ec 1c             	sub    $0x1c,%esp
  8036ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803703:	8b 74 24 34          	mov    0x34(%esp),%esi
  803707:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80370b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80370f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803713:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803717:	89 f3                	mov    %esi,%ebx
  803719:	89 fa                	mov    %edi,%edx
  80371b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371f:	89 34 24             	mov    %esi,(%esp)
  803722:	85 c0                	test   %eax,%eax
  803724:	75 1a                	jne    803740 <__umoddi3+0x48>
  803726:	39 f7                	cmp    %esi,%edi
  803728:	0f 86 a2 00 00 00    	jbe    8037d0 <__umoddi3+0xd8>
  80372e:	89 c8                	mov    %ecx,%eax
  803730:	89 f2                	mov    %esi,%edx
  803732:	f7 f7                	div    %edi
  803734:	89 d0                	mov    %edx,%eax
  803736:	31 d2                	xor    %edx,%edx
  803738:	83 c4 1c             	add    $0x1c,%esp
  80373b:	5b                   	pop    %ebx
  80373c:	5e                   	pop    %esi
  80373d:	5f                   	pop    %edi
  80373e:	5d                   	pop    %ebp
  80373f:	c3                   	ret    
  803740:	39 f0                	cmp    %esi,%eax
  803742:	0f 87 ac 00 00 00    	ja     8037f4 <__umoddi3+0xfc>
  803748:	0f bd e8             	bsr    %eax,%ebp
  80374b:	83 f5 1f             	xor    $0x1f,%ebp
  80374e:	0f 84 ac 00 00 00    	je     803800 <__umoddi3+0x108>
  803754:	bf 20 00 00 00       	mov    $0x20,%edi
  803759:	29 ef                	sub    %ebp,%edi
  80375b:	89 fe                	mov    %edi,%esi
  80375d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803761:	89 e9                	mov    %ebp,%ecx
  803763:	d3 e0                	shl    %cl,%eax
  803765:	89 d7                	mov    %edx,%edi
  803767:	89 f1                	mov    %esi,%ecx
  803769:	d3 ef                	shr    %cl,%edi
  80376b:	09 c7                	or     %eax,%edi
  80376d:	89 e9                	mov    %ebp,%ecx
  80376f:	d3 e2                	shl    %cl,%edx
  803771:	89 14 24             	mov    %edx,(%esp)
  803774:	89 d8                	mov    %ebx,%eax
  803776:	d3 e0                	shl    %cl,%eax
  803778:	89 c2                	mov    %eax,%edx
  80377a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80377e:	d3 e0                	shl    %cl,%eax
  803780:	89 44 24 04          	mov    %eax,0x4(%esp)
  803784:	8b 44 24 08          	mov    0x8(%esp),%eax
  803788:	89 f1                	mov    %esi,%ecx
  80378a:	d3 e8                	shr    %cl,%eax
  80378c:	09 d0                	or     %edx,%eax
  80378e:	d3 eb                	shr    %cl,%ebx
  803790:	89 da                	mov    %ebx,%edx
  803792:	f7 f7                	div    %edi
  803794:	89 d3                	mov    %edx,%ebx
  803796:	f7 24 24             	mull   (%esp)
  803799:	89 c6                	mov    %eax,%esi
  80379b:	89 d1                	mov    %edx,%ecx
  80379d:	39 d3                	cmp    %edx,%ebx
  80379f:	0f 82 87 00 00 00    	jb     80382c <__umoddi3+0x134>
  8037a5:	0f 84 91 00 00 00    	je     80383c <__umoddi3+0x144>
  8037ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037af:	29 f2                	sub    %esi,%edx
  8037b1:	19 cb                	sbb    %ecx,%ebx
  8037b3:	89 d8                	mov    %ebx,%eax
  8037b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037b9:	d3 e0                	shl    %cl,%eax
  8037bb:	89 e9                	mov    %ebp,%ecx
  8037bd:	d3 ea                	shr    %cl,%edx
  8037bf:	09 d0                	or     %edx,%eax
  8037c1:	89 e9                	mov    %ebp,%ecx
  8037c3:	d3 eb                	shr    %cl,%ebx
  8037c5:	89 da                	mov    %ebx,%edx
  8037c7:	83 c4 1c             	add    $0x1c,%esp
  8037ca:	5b                   	pop    %ebx
  8037cb:	5e                   	pop    %esi
  8037cc:	5f                   	pop    %edi
  8037cd:	5d                   	pop    %ebp
  8037ce:	c3                   	ret    
  8037cf:	90                   	nop
  8037d0:	89 fd                	mov    %edi,%ebp
  8037d2:	85 ff                	test   %edi,%edi
  8037d4:	75 0b                	jne    8037e1 <__umoddi3+0xe9>
  8037d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037db:	31 d2                	xor    %edx,%edx
  8037dd:	f7 f7                	div    %edi
  8037df:	89 c5                	mov    %eax,%ebp
  8037e1:	89 f0                	mov    %esi,%eax
  8037e3:	31 d2                	xor    %edx,%edx
  8037e5:	f7 f5                	div    %ebp
  8037e7:	89 c8                	mov    %ecx,%eax
  8037e9:	f7 f5                	div    %ebp
  8037eb:	89 d0                	mov    %edx,%eax
  8037ed:	e9 44 ff ff ff       	jmp    803736 <__umoddi3+0x3e>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	89 c8                	mov    %ecx,%eax
  8037f6:	89 f2                	mov    %esi,%edx
  8037f8:	83 c4 1c             	add    $0x1c,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5f                   	pop    %edi
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    
  803800:	3b 04 24             	cmp    (%esp),%eax
  803803:	72 06                	jb     80380b <__umoddi3+0x113>
  803805:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803809:	77 0f                	ja     80381a <__umoddi3+0x122>
  80380b:	89 f2                	mov    %esi,%edx
  80380d:	29 f9                	sub    %edi,%ecx
  80380f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803813:	89 14 24             	mov    %edx,(%esp)
  803816:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80381a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80381e:	8b 14 24             	mov    (%esp),%edx
  803821:	83 c4 1c             	add    $0x1c,%esp
  803824:	5b                   	pop    %ebx
  803825:	5e                   	pop    %esi
  803826:	5f                   	pop    %edi
  803827:	5d                   	pop    %ebp
  803828:	c3                   	ret    
  803829:	8d 76 00             	lea    0x0(%esi),%esi
  80382c:	2b 04 24             	sub    (%esp),%eax
  80382f:	19 fa                	sbb    %edi,%edx
  803831:	89 d1                	mov    %edx,%ecx
  803833:	89 c6                	mov    %eax,%esi
  803835:	e9 71 ff ff ff       	jmp    8037ab <__umoddi3+0xb3>
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803840:	72 ea                	jb     80382c <__umoddi3+0x134>
  803842:	89 d9                	mov    %ebx,%ecx
  803844:	e9 62 ff ff ff       	jmp    8037ab <__umoddi3+0xb3>
